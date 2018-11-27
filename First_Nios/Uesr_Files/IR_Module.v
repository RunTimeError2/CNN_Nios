//红外驱动模块
module IR_Module(
		//---------------------- Avalon -----------------------
		csi_clk,                //100MHz Clock
		csi_reset_n,
		avs_chipselect,
		avs_address,
		avs_read,
		avs_readdata,
		avs_write,
		avs_writedata,
		avs_irq,
		//---------------------- User Interface --------------------
		coe_IRData_Input
);

// Avalon
input 						csi_clk;
input 						csi_reset_n;
input 						avs_chipselect;
input 		[3:0] 		avs_address;
input 						avs_read;
output reg  [31:0] 		avs_readdata;
input 						avs_write;
input 		[31:0] 		avs_writedata;
output 						avs_irq;
// User Interface
input 						coe_IRData_Input;
//output 		[31:0] 		coe_IRData_Output;

// Getting 50MHz clock
reg iCLK;
always@(posedge csi_clk or negedge csi_reset_n)
begin
	if(!csi_reset_n)
	begin
		iCLK = 0;
	end
	else
	begin
		if(iCLK == 1)
			iCLK = 0;
		else
			iCLK = 1;
	end
end

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter IDLE               = 2'b00;    //always high voltage level
parameter GUIDANCE           = 2'b01;    //9ms low voltage and 4.5 ms high voltage
parameter DATAREAD           = 2'b10;    //0.6ms low voltage start and with 0.52ms high voltage is 0,with 1.66ms high voltage is 1, 32bit in sum.

parameter IDLE_HIGH_DUR      =  262143;  // data_count    262143*0.02us = 5.24ms, threshold for DATAREAD-----> IDLE
parameter GUIDE_LOW_DUR      =  230000;  // idle_count    230000*0.02us = 4.60ms, threshold for IDLE--------->GUIDANCE
parameter GUIDE_HIGH_DUR     =  210000;  // state_count   210000*0.02us = 4.20ms, 4.5-4.2 = 0.3ms < BIT_AVAILABLE_DUR = 0.4ms,threshold for GUIDANCE------->DATAREAD
parameter DATA_HIGH_DUR      =  41500;	 // data_count    41500 *0.02us = 0.83ms, sample time from the posedge of iIRDA
parameter BIT_AVAILABLE_DUR  =  20000;   // data_count    20000 *0.02us = 0.4ms,  the sample bit pointer,can inhibit the interference from iIRDA signal


//=======================================================
//  PORT declarations
//=======================================================
/*input         iCLK;        //input clk,50MHz
input         iRST_n;      //rst
input         iIRDA;       //Irda RX output decoded data
output        oDATA_READY; //data ready
output [31:0] oDATA;       //output data,32bit */


//=======================================================
//  Signal Declarations
//=======================================================
//reg    [31:0] coe_IRData_Output;                 //data output reg
reg    [17:0] idle_count;            //idle_count counter works under data_read state
reg           idle_count_flag;       //idle_count conter flag
//wire          idle_count_max;
reg    [17:0] state_count;           //state_count counter works under guide state
reg           state_count_flag;      //state_count conter flag
reg    [17:0] data_count;            //data_count counter works under data_read state
reg           data_count_flag;       //data_count conter flag
reg     [5:0] bitcount;              //sample bit pointer
reg     [1:0] state;                 //state reg
reg    [31:0] data;                  //data reg
reg    [31:0] data_buf;              //data buf
reg           data_ready;            //data ready flag
reg    [31:0] state_register;
reg 				data_ready_tmp;


//=======================================================
//  Structural coding
//=======================================================	
assign avs_irq = data_ready;


//idle counter works on iclk under IDLE state only
always @(posedge iCLK or negedge csi_reset_n)	
	  if (!csi_reset_n)
		   idle_count <= 0;
	  else if (idle_count_flag)    //the counter works when the flag is 1
			 idle_count <= idle_count + 1'b1;
		else  
			 idle_count <= 0;	         //the counter resets when the flag is 0		      		 	

//idle counter switch when iIRDA is low under IDLE state
always @(posedge iCLK or negedge csi_reset_n)	
	  if (!csi_reset_n)
		   idle_count_flag <= 1'b0;
	  else if ((state == IDLE) && !coe_IRData_Input)
			 idle_count_flag <= 1'b1;
		else                           
			 idle_count_flag <= 1'b0;		     		 	
      
//state counter works on iclk under GUIDE state only
always @(posedge iCLK or negedge csi_reset_n)	
	  if (!csi_reset_n)
		   state_count <= 0;
	  else if (state_count_flag)    //the counter works when the flag is 1
			 state_count <= state_count + 1'b1;
		else  
			 state_count <= 0;	        //the counter resets when the flag is 0		      		 	

//state counter switch when iIRDA is high under GUIDE state
always @(posedge iCLK or negedge csi_reset_n)	
	  if (!csi_reset_n)
		   state_count_flag <= 1'b0;
	  else if ((state == GUIDANCE) && coe_IRData_Input)
			 state_count_flag <= 1'b1;
		else  
			 state_count_flag <= 1'b0;     		 	

//data read decode counter based on iCLK
always @(posedge iCLK or negedge csi_reset_n)	
	  if (!csi_reset_n)
		   data_count <= 1'b0;
	  else if(data_count_flag)      //the counter works when the flag is 1
			 data_count <= data_count + 1'b1;
		else 
			 data_count <= 1'b0;        //the counter resets when the flag is 0

//data counter switch
always @(posedge iCLK or negedge csi_reset_n)
	  if (!csi_reset_n) 
		   data_count_flag <= 0;	
	  else if ((state == DATAREAD) && coe_IRData_Input)
			 data_count_flag <= 1'b1;  
		else
			 data_count_flag <= 1'b0; 

//data reg pointer counter 
always @(posedge iCLK or negedge csi_reset_n)
    if (!csi_reset_n)
       bitcount <= 6'b0;
	  else if (state == DATAREAD)
		begin
			if (data_count == 20000)
					bitcount <= bitcount + 1'b1; //add 1 when iIRDA posedge
		end   
	  else
	     bitcount <= 6'b0;

//state change between IDLE,GUIDE,DATA_READ according to irda edge or counter
always @(posedge iCLK or negedge csi_reset_n) 
	  if (!csi_reset_n)	     
	     state <= IDLE;
	  else 
			 case (state)
 			    IDLE     : if (idle_count > GUIDE_LOW_DUR)  // state chang from IDLE to Guidance when detect the negedge and the low voltage last for > 4.6ms
			  	              state <= GUIDANCE; 
			    GUIDANCE : if (state_count > GUIDE_HIGH_DUR)//state change from GUIDANCE to DATAREAD when detect the posedge and the high voltage last for > 4.2ms
			  	              state <= DATAREAD;
			    DATAREAD : if ((data_count >= IDLE_HIGH_DUR) || (bitcount >= 33))
			  					      state <= IDLE;
	        default  : state <= IDLE; //default
			 endcase

//data decode base on the value of data_count 	
always @(posedge iCLK or negedge csi_reset_n)
	  if (!csi_reset_n)
	     data <= 0;
		else if (state == DATAREAD)
		begin
			 if (data_count >= DATA_HIGH_DUR) //2^15 = 32767*0.02us = 0.64us
			    data[bitcount-1'b1] <= 1'b1;  //>0.52ms  sample the bit 1
		end
		else
			 data <= 0;
	
//set the data_ready flag 
always @(posedge iCLK or negedge csi_reset_n) 
	  if (!csi_reset_n)
	     data_ready <= 1'b0;
    else if (bitcount == 32)   
		begin
			 if (data[31:24] == ~data[23:16])
			 begin		
					data_buf <= data;     //fetch the value to the databuf from the data reg
				  data_ready <= 1'b1;   //set the data ready flag
				  //data_ready_tmp <= 1; //====================================
			 end	
			 else
				  data_ready <= 1'b0 ;  //data error
		end
		else
		   data_ready <= 1'b0 ;

//read data
/*always @(posedge iCLK or negedge csi_reset_n)
	  if (!csi_reset_n)
		   coe_IRData_Output <= 32'b0000;
	  else if (data_ready)
	     coe_IRData_Output <= data_buf;  //output
		  //coe_IRData_Output <= 32'hFFFFFFFF;*/
	
reg flag2;	
always @(posedge csi_clk)
begin
	if((avs_chipselect == 1) && (avs_write == 1))
		state_register <= avs_writedata;
	if((avs_chipselect == 1) && (avs_read == 1))
	begin
		if(state_register == 32'd0)
			if(data_ready_tmp == 1)
			begin
				avs_readdata <= 32'd1;
				data_ready_tmp <= 0;
			end
			else
				avs_readdata <= 32'd0;
		else
			avs_readdata <= data_buf;
	end
	
	if(data_ready == 1)
		flag2 <= 1;
	else
	begin
		if(flag2 == 1)
		begin
			flag2 <= 0;
			data_ready_tmp <= 1;
		end
	end
end
					
endmodule

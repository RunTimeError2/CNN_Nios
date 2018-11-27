module User_Demo(
				//--------------Avalon-------------//
				csi_clk,		//100MHz
				csi_reset_n,
				avs_chipselect,
				avs_address,
				avs_read,
				avs_readdata,
				avs_write,
				avs_writedata,
				//------------User Interface-----------//
				coe_GPIO_LED
);
//Avalon
input						csi_clk;		     //100MHz
input						csi_reset_n;     //Low-Level Work
input						avs_chipselect;
input [3:0]				avs_address;
input						avs_read;
output reg [31:0]		avs_readdata;
input						avs_write;
input [31:0]			avs_writedata;

//GPIO for LED
output					coe_GPIO_LED;
reg                  coe_GPIO_LED;


//Uesr Define REG 
reg [31:0]           Pwm_Compare_Value;
reg [31:0]           Pwm_Cnts;


//Avalon Read-Writer Code
always @(posedge csi_clk or negedge csi_reset_n) begin		//Interface Clk = 100MHz
	if(!csi_reset_n) begin
	  Pwm_Compare_Value<=10;
	end
	else	begin
		if((avs_chipselect == 1) && (avs_write == 1)) begin		//write data
			Pwm_Compare_Value<=avs_writedata;
			
		end
		else if((avs_chipselect == 1) && (avs_read == 1)) begin	//read data
			avs_readdata <= Pwm_Compare_Value;
		end
	end
end



//User Code
//Clk Divid 100Mhz->1Mhz
reg [6:0] Div_Cnts;  //0~127
reg       Clk_1M;
always @(posedge csi_clk or negedge csi_reset_n) begin		//Interface Clk = 100MHz
if(!csi_reset_n) begin
	  Div_Cnts<=0;
	  Clk_1M<=1'b0;
	end
	else	begin
			if(Div_Cnts!=99)
			 Div_Cnts<=Div_Cnts+1'b1;
			 else 
			  Div_Cnts<=0;
			  
			if(Div_Cnts<50)
			 Clk_1M<=1'b0;
			else 
			 Clk_1M<=1'b1;
	end

end 

always @(posedge Clk_1M or negedge csi_reset_n) begin		//User Clk = 1MHz
if(!csi_reset_n) begin
	  coe_GPIO_LED<=1'b0;  //LED ON 
	  Pwm_Cnts<=0;
	end
	else	begin
	      if(Pwm_Cnts!=1001)   //1mS-Cycle
	        Pwm_Cnts<=Pwm_Cnts+1;
			else
	        Pwm_Cnts<=0;		
			if(Pwm_Cnts<Pwm_Compare_Value)
			 coe_GPIO_LED<=1'b0;  //LED ON
			else 
			 coe_GPIO_LED<=1'b1;  //LED OFF
	end

end 	
	
	
	
	
endmodule


///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: LCD_Module.v
// File history:
//      2017.07.08 ： The file was created and simulated .
//
// Description: The module connects to the Avalon bus, writes the data to 
//              be displayed and other parameters through the bus, and enables write operations.
//              Input-Clk:100Mhz
// Author: <ZLW>
//
///////////////////////////////////////////////////////////////////////////////////////////////////
module LCD_Module(
				//--------------Avalon-------------//
										csi_CLK,
										csi_RST_N,
										avs_chipselect,
										avs_address,
										avs_read,
										avs_readdata,
										avs_write,
										avs_writedata,									
										
										
				//--------------LCD Interface-------------//
										coe_LCD_DATA,
										coe_LCD_RW,
										coe_LCD_EN,
										coe_LCD_RS	,
										coe_LCD_BLON,
										coe_LCD_ON
										);
										
//	Avalon Side
input			           csi_CLK ;      //100Mhz
input              csi_RST_N ;
input		       	    avs_chipselect;
input [4:0]				    avs_address;
input						        avs_read;
output reg [31:0]		avs_readdata;
input						        avs_write;
input [31:0]			    avs_writedata;
//	LCD Side
inout 	[7:0]	      coe_LCD_DATA;
output		      	    coe_LCD_RW;
output             coe_LCD_EN;
output             coe_LCD_RS;
output    					    coe_LCD_BLON;
output    			 	    coe_LCD_ON;

assign        			 	coe_LCD_BLON=1'b0; //Not use this function ;
assign         				coe_LCD_ON=1'b1;   //Enable LCD power


//Div Clk  Input-Clk: 100Mhz  Output-Clk:1Mhz
reg       Clk_1M;
reg [6:0] Div_Cnts;  //0~127
always@(posedge csi_CLK or negedge csi_RST_N)
 begin
  if(!csi_RST_N)
   begin
				Div_Cnts<=0;
				Clk_1M<=1'b0;
			end 
  else  
   begin
			 if(Div_Cnts!=99)
				 Div_Cnts<=Div_Cnts+1'b1;
				else
				 Div_Cnts<=0;
					
				if(Div_Cnts<49)
				 Clk_1M<=1'b0;
				else
				 Clk_1M<=1'b1;
	
			end

 end

reg [31:0]  APB_DATA_Buf [19:0] ;
reg [7:0]   Write_Length ;
reg [7:0]   Write_Position;
reg [7:0]   Write_Row;
reg [7:0]   Write_Command;
reg         Avalon_Write_Buff;
reg         Avalon_Start_En;
reg	[5:0]	  LUT_INDEX;
reg	[8:0]	  LUT_DATA;
reg	[5:0]	  mLCD_ST;   //0~31
reg	[5:0]	  mDLY;      //0~31
reg			      mLCD_Start;
reg	[7:0]  	mLCD_DATA;
reg			      mLCD_RS;
wire		      mLCD_Done;
reg  [7:0]  Index_Cnts;
	
	
	//1 Avalon Read-Writer Code
always @(posedge csi_CLK or negedge csi_RST_N) begin		//Interface Clk = 100MHz
	if(!csi_RST_N) 
	 begin
				Avalon_Write_Buff<=1'b0;
    Avalon_Start_En  <=1'b0;
				Write_Length  <=8'h05;
				Write_Position<=8'h05;
				Write_Row     <=8'h40;
				Write_Command <=8'h33;
				APB_DATA_Buf[0]<=0;
				APB_DATA_Buf[1]<=8'h48;
				APB_DATA_Buf[2]<=8'h65;
				APB_DATA_Buf[3]<=8'h6c;
				APB_DATA_Buf[4]<=8'h6c;
				APB_DATA_Buf[5]<=8'h5f;
				APB_DATA_Buf[6]<=0;
				APB_DATA_Buf[7]<=0;
				APB_DATA_Buf[8]<=0;
				APB_DATA_Buf[9]<=0;
				APB_DATA_Buf[10]<=0;
				APB_DATA_Buf[11]<=0;
				APB_DATA_Buf[12]<=0;
				APB_DATA_Buf[13]<=0;
				APB_DATA_Buf[14]<=0;
				APB_DATA_Buf[15]<=0;
				APB_DATA_Buf[16]<=0;
				APB_DATA_Buf[17]<=0;
				APB_DATA_Buf[18]<=0;
				APB_DATA_Buf[19]<=0;
	 end
	else	
	 begin
	  	Avalon_Start_En<=Avalon_Write_Buff;
			if((avs_chipselect == 1) &&(avs_write == 1)) 
				begin		//write data
// 2017.07.08  After verification, in Quartus15.0, the use of avs_address, do not need to remove the low two bit, direct use can be.
					APB_DATA_Buf[avs_address[4:0]]<=avs_writedata[31:0];  //Store ARM Command to Buff .		
					if(avs_address[4:0]==5'b00000)
							begin
								Write_Position<=avs_writedata[31:24];   //Position range from 0~15
								Write_Length<=avs_writedata[23:16];
								Write_Row<=avs_writedata[15:8];
								Write_Command<=avs_writedata[7:0];
								Avalon_Write_Buff<=1'b1;
							end                
						else
									Avalon_Write_Buff<=1'b0;	
				end
			else 
		  begin
				   Avalon_Write_Buff<=1'b0;
				end
		end
end
	
	// 2 Avalon Read Process
always @(posedge csi_CLK or negedge csi_RST_N) 
 begin		
		if(!csi_RST_N) begin

		end
		else	
		 begin
				if((avs_chipselect == 1) &&(avs_read == 1)) 
				begin		 
		    	if(avs_address[4:0]==5'b00000)		
					   avs_readdata<={8'h00,Write_Command, 10'h000,mLCD_ST} ;
							else
							 avs_readdata<= APB_DATA_Buf[avs_address[4:0]];
				end
		end
end	
	
	// 3 Write Command Bigin Process
reg   Write_Cycle_Enable;
always@(posedge csi_CLK or negedge csi_RST_N)
 begin
  if(!csi_RST_N)
		 begin
			 Write_Cycle_Enable<=1'b0;
			end
		else
		 begin
			 if(Avalon_Start_En)
				  Write_Cycle_Enable<=1'b1;
				else if((mLCD_ST==7)||(mLCD_ST==10))
				  Write_Cycle_Enable<=1'b0;
			end
	end
	


	// 4 Mian States Process
always@(posedge Clk_1M or negedge csi_RST_N)
begin
	if(!csi_RST_N)
	begin
		LUT_INDEX	<=	0;
		mLCD_ST		<=	0;
		mDLY		<=	0;
		mLCD_Start	<=	0;
		mLCD_DATA	<=	0;
		mLCD_RS		<=	0;
		Index_Cnts<=0;
	end
	else
	begin
			case(mLCD_ST)
			0:	begin
					  mLCD_DATA	<=	LUT_DATA[7:0];
					  mLCD_RS	 	<=	LUT_DATA[8];
					  mLCD_Start<=	1;
					  mLCD_ST		 <=	1;
			  	end
			1: begin
							if(mDLY<6'd5)
								mDLY	<=	mDLY+1;
							else
								begin
									mDLY	<=	0;
									mLCD_ST	<=	2;
					  	end
      end							
			2:	begin
					if(mLCD_Done)
					begin
						mLCD_Start	<=	0;
						mLCD_ST		<=	3;					
					end
				end
			3:	begin
					if(mDLY<6'd10) //delay 10uS
					mDLY	<=	mDLY+1;
					else
					begin
						mDLY	<=	0;
						mLCD_ST	<=	4;
					end
				end
			4:	begin
			  if(LUT_INDEX<4)
					 begin
					 	LUT_INDEX	<=	LUT_INDEX+1;
				  	mLCD_ST	<=	0;					
						end
     else
					 begin
						 LUT_INDEX<=0;
							mLCD_ST	<=	5;
						end				  	
				end
			5:	begin
    if(Write_Cycle_Enable)  //wait for begin command .
				 begin
					 if(Write_Command==8'hff)       //Reset LCD1602 .
						  mLCD_ST	<=	0;		
					 else if(Write_Command==8'h33)  //Write Data LCD1602 .
						  mLCD_ST	<=	9;		
						else if(Write_Command==8'h55)  //Clear Disp Coment .
						  mLCD_ST	<=	6;
						else
						  mLCD_ST	<=	5;		
					end
				 
			 else
				 mLCD_ST	<=	5;		
				end				
			6:	begin
							mLCD_DATA<=8'h01;                           //Clear All Content .
							mLCD_RS  <=1'b0;                            //Write Command .
							mLCD_Start<=	1;
							mLCD_ST		 <=	7;
				end
			7:	begin
							if(mDLY<6'd100)  //delay 100uS
								mDLY	<=	mDLY+1;
							else
								begin
									mDLY	<=	0;
									mLCD_ST	<=	8;
					  	end		
				end
			8:	begin
						if(mLCD_Done)
						begin
							mLCD_Start	<=	0;
							mLCD_ST		<=	5;					
						end
			
				end
			9:	begin
							mLCD_DATA<=8'h80+Write_Row+Write_Position;  //Write now DDRAM original position .
							mLCD_RS  <=1'b0;                            //Write Command .
							mLCD_Start<=1;
							mLCD_ST		 <=10;
							Index_Cnts<=0;		
				end
			10:	begin
							if(mDLY<6'd5)
								mDLY	<=	mDLY+1;
							else
								begin
									mDLY	<=	0;
									mLCD_ST	<=	11;
					  	end			
				end
			11:	begin
								if(mLCD_Done)
								begin
									mLCD_Start	<=	0;
									mLCD_ST		<=	12;					
								end		
				end
			12:	begin
        if(Index_Cnts<Write_Length)
								 begin
									 Index_Cnts<=Index_Cnts+1'b1;
										mLCD_ST<=13;
									end
								else
								 begin
									 mLCD_ST<=5;
									end		    
				end							
				13:	begin
									mLCD_DATA<=APB_DATA_Buf[Index_Cnts];        //Write Data .
									mLCD_RS  <=1'b1;                            //Write Data .
									mLCD_Start<=	1;
									mLCD_ST		 <=	14;		
				end	
				14:	begin
								if(mDLY<6'd5)  //delay 5uS
									mDLY	<=	mDLY+1;
								else
									begin
										mDLY	<=	0;
										mLCD_ST	<=	15;
									end		
				end
					15:	begin
									if(mLCD_Done)
									begin
										mLCD_Start	<=	0;
										mLCD_ST		<=	16;					
									end		
				end
					16:	begin
								if(mDLY<6'd5)  //delay 5uS
									mDLY	<=	mDLY+1;
								else
									begin
										mDLY	<=	0;
										mLCD_ST	<=	12;
									end		
				end					
			endcase
		
	end
end



always
begin
	case(LUT_INDEX)
	//	Initial
	 0:	LUT_DATA	<=	9'h038;
	 1:	LUT_DATA	<=	9'h00C;
	 2:	LUT_DATA	<=	9'h001;
	 3:	LUT_DATA	<=	9'h006;
	 4:	LUT_DATA	<=	9'h080;
	
	default:		LUT_DATA	<=	9'h120;
	endcase
end



LCD_Driver Inst_0 (
    // Inputs
    .iCLK(Clk_1M),     //1Mhz
    .iRST_N(csi_RST_N),
    .iDATA(mLCD_DATA),
    .iRS(mLCD_RS),
    .iStart(mLCD_Start),

    // Outputs
    .oDone(mLCD_Done),
    .LCD_RW(coe_LCD_RW),
    .LCD_EN(coe_LCD_EN),
    .LCD_RS(coe_LCD_RS),

    // Inouts
    .LCD_DATA(coe_LCD_DATA)

);


endmodule 
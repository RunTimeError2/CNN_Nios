///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: LCD_Driver.v
// File history:
//      2017.07.08 ： The file was created and simulated .
//
// Description: The underlying driver is responsible for writing data or commands from the upper layer to the LCD1602. 
//              Before writing, the current LCD1602 will be checked whether it is busy or not, until the LCD1602 is in 
//              the idle state before it writes the new data.
//
// Author: <ZLW>
//
///////////////////////////////////////////////////////////////////////////////////////////////////


module LCD_Driver (	
      //	Host Side
					 iCLK,
						iRST_N,
						iDATA,
						iRS,
						iStart,
						oDone,
						//	LCD Interface
						LCD_DATA,
						LCD_RW,
						LCD_EN,
						LCD_RS	);

//	Host Side
input            iCLK ;     // 1Mhz 
input            iRST_N;
input	[7:0]	     iDATA;
input	           iRS;
input            iStart;
output reg	  				oDone;
//	LCD Interface
inout	[7:0]  	   LCD_DATA;
output	reg							LCD_EN;
output	reg	  			 LCD_RW;
output	reg							LCD_RS;

reg   [7:0]      LCD_DATA_r;
reg              LCD_RS_r;
reg              LCD_Direc;

assign LCD_DATA= LCD_Direc ? LCD_DATA_r : 8'hzz;


//	Internal Register
reg		[9:0]	Cont;      //0~1023
reg		[2:0]	ST;        //0~7
reg		preStart,mStart;

always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin

		LCD_DATA_r<=8'h00;
		LCD_Direc<=1'b0;   //Input
		LCD_RS<=1'b0 ;     //Command
		LCD_RW<=1'b1 ;     //Read
		LCD_EN	<=	1'b0;
		LCD_RS_r<=1'b0;
		
		oDone	<=	1'b0;
		preStart<=	1'b0;
		mStart	<=	1'b0;
		Cont	<=	0;
		ST		<=	0;
	end
	else
	begin
		//////	Input Start Detect ///////
		preStart<=	iStart;
		if({preStart,iStart}==2'b01)
		begin
			mStart	<=	1'b1;
			oDone	<=	1'b0;		
		end
		//////////////////////////////////
	if(mStart)
		begin
			case(ST)
			0:	begin               
							ST	<=	1;	
							LCD_EN<=1'b0;
							Cont<=0;
							LCD_DATA_r<=iDATA;   //Lock Input-Data
							LCD_RS_r<=iRS;       //Lock RS      
		   	end
			1:	begin                 //	Change "inout LCD_DATA" to input and read LCD States .
			    LCD_Direc<=1'b0;     //inout LCD_DATA ->Input
							LCD_RS<=1'b0 ;       //Command
							LCD_RW<=1'b1 ;       //Read
       ST	<=	2;	
			  	end
			2:	begin					
       LCD_EN<=1'b1;        //Chip-Enable
					  ST		<=	3;
			  	end 
			3:	begin                 //Determine whether the current LCD1602 is busy or not .
			    Cont<=Cont+1'b1; 
							if(Cont==3)
							 begin            
								 if(LCD_DATA[7])    //"1" LCD1602 Busying now!
									  ST<=4;
									else
									  ST<=5;
								end
							else
							 begin
								  ST<=3;
								end
				   end
			4: begin                 //Delay 0.5mS for lcd1602 Internel Process
			    Cont<=Cont+1'b1;
							LCD_EN<=1'b0;        //Chip-Disable
							if(Cont==503)        
							 ST	<=	0;
							else
						  ST	<=	4;		
			   end
			5: begin
			    LCD_EN<=1'b0;        //Chip-Disable
							ST	<=	6;
			   end		
			6: begin                 //Writes data to be written to the LCD interior .
							 LCD_RS<=LCD_RS_r ;  
							 LCD_RW<=1'b0 ;      //Write	  
						 	LCD_Direc<=1'b1;    //inout LCD_DATA ->Output					
								ST	<=	7;					
			   end		
			7: begin
			     Cont<=Cont+1'b1; 
								 if(Cont==6)		  
							    LCD_EN<=1'b1;    //Chip-Enable		
			      else if(Cont==9)
									  begin
											 LCD_EN<=1'b0;   //Chip-Disable
												oDone	<=	1'b1;
												ST	<=	0;
												mStart	<=	1'b0;
											end
									else
									  begin
											 ST	<=	7;
											end
			   end
			endcase
		end
	end
end

endmodule 
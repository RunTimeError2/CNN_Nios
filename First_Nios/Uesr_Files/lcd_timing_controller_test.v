// --------------------------------------------------------------------
// Copyright (c) 2005 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	DE2 LTM module Timing control and color pattern 
//					generator
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            		:| Mod. Date :| Changes Made:
//   V1.0 :| Johnny Fan				:| 07/06/30  :| Initial Revision
// --------------------------------------------------------------------
module lcd_timing_controller_test		(
						iCLK, 				// LCD display clock
						iRST_n, 			// systen reset
						//LCD SIDE
						oHD,				// LCD Horizontal sync 
						oVD,				// LCD Vertical sync 	
						oDEN,				// LCD Data Enable
						oLCD_R,				// LCD Red color data 
						oLCD_G,             // LCD Green color data  
						oLCD_B,             // LCD Blue color data  
						iDISPLAY_MODE
						);
//============================================================================
// PARAMETER declarations
//============================================================================
parameter H_LINE = 1056;
parameter V_LINE = 525;
parameter Hsync_Blank = 216;
parameter Hsync_Front_Porch = 40;
parameter Vertical_Back_Porch = 35;
parameter Vertical_Front_Porch = 10;
//===========================================================================
// PORT declarations
//===========================================================================
input			iCLK;   
input			iRST_n;
output	[7:0]	oLCD_R;		
output  [7:0]	oLCD_G;
output  [7:0]	oLCD_B;
output			oHD;
output			oVD;
output			oDEN;
input	[1:0]	iDISPLAY_MODE;	
//=============================================================================
// REG/WIRE declarations
//=============================================================================
reg		[10:0]  x_cnt;  
reg		[9:0]	y_cnt; 
wire	[7:0]	mred;
wire	[7:0]	mgreen;
wire	[7:0]	mblue; 
wire			display_area;
reg				mhd;
reg				mvd;
reg				mden;
reg				oHD;
reg				oVD;
reg				oDEN;
reg		[7:0]	oLCD_R;
reg		[7:0]	oLCD_G;	
reg		[7:0]	oLCD_B;	
wire	[1:0]	msel;	
reg		[7:0]	red_1;
reg 	[7:0]	green_1;
reg 	[7:0]	blue_1;
reg 	[7:0]	graycnt;
reg		[7:0]	pattern_data;

//=============================================================================
// Structural coding
//=============================================================================

					
// This signal indicate the lcd display area .
assign	display_area = ((x_cnt>(Hsync_Blank-1)&& //>215
						(x_cnt<(H_LINE-Hsync_Front_Porch))&& //< 1016
						(y_cnt>(Vertical_Back_Porch-1))&& 
						(y_cnt<(V_LINE - Vertical_Front_Porch))
						))  ? 1'b1 : 1'b0;


///////////////////////// x  y counter  and lcd hd generator //////////////////
always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
		begin
			x_cnt <= 11'd0;	
			mhd  <= 1'd0;  	
		end	
		else if (x_cnt == (H_LINE-1))
		begin
			x_cnt <= 11'd0;
			mhd  <= 1'd0;
		end	   
		else
		begin
			x_cnt <= x_cnt + 11'd1;
			mhd  <= 1'd1;
		end	
	end

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			y_cnt <= 10'd0;
		else if (x_cnt == (H_LINE-1))
		begin
			if (y_cnt == (V_LINE-1))
				y_cnt <= 10'd0;
			else
				y_cnt <= y_cnt + 10'd1;	
		end
	end
////////////////////////////// touch panel timing //////////////////

always@(posedge iCLK  or negedge iRST_n)
	begin
		if (!iRST_n)
			mvd  <= 1'b1;
		else if (y_cnt == 10'd0)
			mvd  <= 1'b0;
		else
			mvd  <= 1'b1;
	end			

always@(posedge iCLK  or negedge iRST_n)
	begin
		if (!iRST_n)
			mden  <= 1'b0;
		else if (display_area)
			mden  <= 1'b1;
		else
			mden  <= 1'b0;
	end			

//////////////RGB color patten generator ///////


assign	msel		=	(y_cnt<200)					?	2'b01	:
						(y_cnt>=200	&& y_cnt<360)	?	2'b10	:
													    2'b00	;
always@(posedge iCLK  or negedge iRST_n)
	begin
		if (!iRST_n)
			pattern_data	<=	8'h00;
		else if((x_cnt>(Hsync_Blank-1))&&(x_cnt<(H_LINE-Hsync_Front_Porch)))
			begin
				if(msel==1)
					begin
						pattern_data <= pattern_data + 1;		
						red_1 <= pattern_data;
						green_1 <= 0;
						blue_1 <= 0;
					end	
				else if (msel==2)
					begin
						pattern_data <= pattern_data + 1;
						red_1 <= 0;
						green_1 <= pattern_data;
						blue_1 <= 0;
					end	
				else if (msel==0)
					begin
						pattern_data <= pattern_data + 1;
						red_1 <= 0;
						green_1 <= 0;
						blue_1 <= pattern_data;
					end	
			end	
				else
					pattern_data<=	8'h00;	
	end	

//////////////gray level  patten generator ///////

always@(posedge iCLK  or negedge iRST_n)
	begin
		if (!iRST_n)
			graycnt <= 0;
		else if((x_cnt>(Hsync_Blank-1))&&(x_cnt<(H_LINE-Hsync_Front_Porch))) 
			graycnt <= graycnt + 1;	
		else
			graycnt <= 0;		
end	

////////////// displayed color pattern selection //////////////

assign mred    = (iDISPLAY_MODE == 2'b11)?  8'hff:  
				 (iDISPLAY_MODE == 2'b10)?  8'h7f: 
			     (iDISPLAY_MODE == 2'b01)?  red_1:
										    graycnt; 

assign mgreen  = (iDISPLAY_MODE == 2'b11)?  8'hff:
			     (iDISPLAY_MODE == 2'b10)?  8'h7f:
				 (iDISPLAY_MODE == 2'b01)?  green_1:
				  				            graycnt;
				 
assign mblue   = (iDISPLAY_MODE == 2'b11)?  8'hff:
			     (iDISPLAY_MODE == 2'b10)?  8'h7f:
				 (iDISPLAY_MODE == 2'b01)?  blue_1:
				  				            graycnt;


always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			begin
				oHD	<= 1'd0;
				oVD	<= 1'd0;
				oDEN <= 1'd0;
				oLCD_R <= 8'd0;
				oLCD_G <= 8'd0;
				oLCD_B <= 8'd0;
			end
		else
			begin
				oHD	<= mhd;
				oVD	<= mvd;
				oDEN <= display_area;
				oLCD_R <= mred;
				oLCD_G <= mgreen;
				oLCD_B <= mblue;
			end		
	end
						
endmodule












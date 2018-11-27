module SRAM_Image_100M (
		//---------------------- Avalon -----------------------
		csi_clk,                //100MHz Clock
		csi_reset_n,
		avs_chipselect,
		avs_address,
		avs_read,
		avs_readdata,
		avs_write,
		avs_writedata,
		//---------------------- User Interface --------------------
		coe_oSRAM_ADDR,
		coe_ioSRAM_DQ,
		coe_oSRAM_WE_N,
		coe_oSRAM_OE_N,
		coe_oSRAM_UB_N,
		coe_oSRAM_LB_N,
		coe_oSRAM_CE_N,
		coe_iRST_n,				// Reset signal with lcd_timing_controller
		coe_oSRAM_DATA,		// Output data from SRAM to lcd_timing_controller
		coe_iREAD_SRAM_EN, 	// Whether the reading loop continues
		coe_oCLK50M,         // 25M clock for lcd_timing_controller
);

// Avalon
input 						csi_clk;
input 						csi_reset_n;
input 						avs_chipselect;
input 		[3:0] 		avs_address;
input 						avs_read;
output reg  [31:0] 		avs_readdata;
input 						avs_write;
input 		[31:0] 		avs_writedata;  //[31:12]Address, [11]High(1) or Low(0), [10:3] data byte
// User Interface
output 		[19:0] 		coe_oSRAM_ADDR;
inout 		[15:0] 		coe_ioSRAM_DQ;
output 						coe_oSRAM_WE_N;
output 						coe_oSRAM_OE_N;
output 						coe_oSRAM_UB_N;
output 						coe_oSRAM_LB_N;
output 						coe_oSRAM_CE_N;
input 						coe_iRST_n;
output 		[31:0] 		coe_oSRAM_DATA; //[31:24]R, [23:16]G, [15:8]B
input 						coe_iREAD_SRAM_EN;
output 						coe_oCLK50M;

reg clk_50M;
assign coe_oCLK50M = clk_50M;

always@(posedge csi_clk or negedge csi_reset_n or negedge coe_iRST_n)
begin
	if((!csi_reset_n) || (!coe_iRST_n))
		clk_50M <= 0;
	else
		clk_50M <= (clk_50M == 1) ? 0 : 1;
end

reg SW; //1: read, 0: write
reg [19:0] read_counter;     // Address to be read
reg [19:0] write_counter;    // Address to be written
reg [15:0] write_data_word;  // Data (16bit, word) to be written
reg [31:0] coe_oSRAM_DATA;

reg UB_N, LB_N;
assign coe_oSRAM_ADDR = (SW) ? read_counter : write_counter;
assign coe_ioSRAM_DQ = (SW) ? 16'hzzzz : write_data_word;
assign coe_oSRAM_UB_N = UB_N;
assign coe_oSRAM_LB_N = LB_N;
assign coe_oSRAM_CE_N = 1'b0;
assign coe_oSRAM_WE_N = (SW ? 1'b1 : 1'b0);
assign coe_oSRAM_OE_N = (SW ? 1'b0 : 1'b1);

wire [15:0] SRAM_OUT;
assign SRAM_OUT = SW ? coe_ioSRAM_DQ : 16'b0;
reg avs_write_flag_clear;

always@(posedge csi_clk or negedge coe_iRST_n)
begin
	if(!coe_iRST_n)
	begin
		read_counter = 20'd0;
		coe_oSRAM_DATA = 32'd0;
		SW = 1;
		UB_N = 0;
		LB_N = 0;
	end
	else
	begin
		if((avs_chipselect == 1) && (avs_write == 1)) // write data to SRAM
		begin
			SW = 0;
			write_counter = avs_writedata[31:12];
			if(avs_writedata[11])
			begin
				UB_N = 1;
				write_data_word = {avs_writedata[10:3], 8'd0};
			end
			else
			begin
				LB_N = 1;
				write_data_word = {8'd0, avs_writedata[10:3]};
			end
		end
		else // read data from SRAM
		begin
			SW = 1;
			UB_N = 0;
			LB_N = 0;
			if(clk_50M == 1) 
				coe_oSRAM_DATA[31:16] = SRAM_OUT;
			else
				coe_oSRAM_DATA[15:0] = SRAM_OUT;
			if(coe_iREAD_SRAM_EN)
				read_counter = read_counter + 20'd1;
			if(read_counter == 20'd768000) // 800*480*2, 2 words stores color for 1 pixel
				read_counter = 20'd0;
		end
	end
end

endmodule

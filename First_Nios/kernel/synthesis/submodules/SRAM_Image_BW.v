module SRAM_Image_BW (
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
		coe_iCLK50M,         // 50M clock for lcd_timing_controller
);

// Avalon
input 						csi_clk;
input 						csi_reset_n;
input 						avs_chipselect;
input 		[3:0] 		avs_address;
input 						avs_read;
output reg  [31:0] 		avs_readdata;
input 						avs_write;
input 		[31:0] 		avs_writedata; //[31:12]Address, [7:0]data
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
input 						coe_iCLK50M;

reg SW;
reg [19:0] read_counter;     // Address to be read
reg [19:0] write_counter;    // Address to be written
reg [15:0] write_data_word;  // Data (16bit, word) to be written
//reg [31:0] coe_oSRAM_DATA;

assign coe_oSRAM_ADDR = (SW) ? read_counter : write_counter;
assign coe_ioSRAM_DQ = (SW) ? 16'hzzzz : write_data_word;
assign coe_oSRAM_UB_N = 1'b0;
assign coe_oSRAM_LB_N = 1'b0;
assign coe_oSRAM_CE_N = 1'b0;
assign coe_oSRAM_WE_N = (SW ? 1'b1 : 1'b0);
assign coe_oSRAM_OE_N = (SW ? 1'b0 : 1'b1);

wire [15:0] SRAM_OUT;
assign SRAM_OUT = SW ? coe_ioSRAM_DQ : 16'b1111111100000000;
//assign SRAM_OUT = SW ? 16'b1101111100000000 : 16'b0;
assign coe_oSRAM_DATA = {SRAM_OUT[15:8], SRAM_OUT[15:8], SRAM_OUT[15:8], 8'd0};

reg [1:0] countdown;
reg [31:0] avs_write_data_buf;

always@(posedge csi_clk or negedge csi_reset_n)
begin
	if(!csi_reset_n)
	begin
		SW = 1;
		countdown = 2'd0;
	end
	else
	begin
		if(countdown == 2'd0)
			SW = 1;
		else
		begin
			SW = 0;
			countdown = countdown - 2'd1;
		end
		if((avs_chipselect == 1) && (avs_write == 1))
		begin
			SW = 0;
			avs_write_data_buf = avs_writedata;
			write_counter = avs_write_data_buf[31:12];
			write_data_word = {avs_write_data_buf[7:0], 8'd0};
			countdown = 2'd2;
		end
	end
end

always@(posedge coe_iCLK50M or negedge coe_iRST_n)
begin
	if(!coe_iRST_n)
	begin
		read_counter = 20'd0;
		//coe_oSRAM_DATA = 32'd0;
	end
	else
	begin
		/*coe_oSRAM_DATA[31:24] = SRAM_OUT[15:8];
		coe_oSRAM_DATA[23:16] = SRAM_OUT[15:8];
		coe_oSRAM_DATA[15:8] = SRAM_OUT[15:8];*/
		if(coe_iREAD_SRAM_EN)
			read_counter = read_counter + 20'd1;
		if(read_counter == 20'd384000)
			read_counter = 20'd0;
	end
end

endmodule

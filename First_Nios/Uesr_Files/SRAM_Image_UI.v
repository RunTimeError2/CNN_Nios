module SRAM_Image_UI(
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
		coe_iRST_n,					
		coe_oSRAM_DATA,			
		coe_iREAD_SRAM_EN, 		
		coe_oCLK25M,         	
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
// User Interface
output 		[19:0] 		coe_oSRAM_ADDR;
inout 		[15:0] 		coe_ioSRAM_DQ; 	
output 						coe_oSRAM_WE_N; 	//写使能（WRITE ENABLE）
output 						coe_oSRAM_OE_N; 	//读使能（OUTPUT ENABLE）
output 						coe_oSRAM_UB_N; 	//高字节控制
output 						coe_oSRAM_LB_N; 	//低字节控制
output 						coe_oSRAM_CE_N; 	//片选
input 						coe_iRST_n;	
output 		[31:0] 		coe_oSRAM_DATA;
input 						coe_iREAD_SRAM_EN;
output 						coe_oCLK25M;

reg clk_50M, clk_25M;
reg [1:0] clk_disp_cnt;
always@(posedge csi_clk or negedge csi_reset_n)
begin
	if(!csi_reset_n)
	begin
		clk_50M <= 0;
		clk_25M <= 0;
		clk_disp_cnt <= 2'b00;
	end
	else
	begin
		case(clk_disp_cnt)
			2'b00: begin clk_50M <= 1; clk_25M <= 0; end
			2'b01: begin clk_50M <= 0; clk_25M <= 0; end
			2'b10: begin clk_50M <= 1; clk_25M <= 1; end
			2'b11: begin clk_50M <= 0; clk_25M <= 1; end
		endcase
		clk_disp_cnt <= clk_disp_cnt + 2'b01;
	end
end

assign coe_oCLK25M = clk_25M;

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

always@(posedge clk_50M or negedge coe_iRST_n)
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
		if(avs_write_flag)
		begin
			SW = 0; // write;
			write_counter = avs_writedata_buf[31:12];
			if(avs_writedata_buf[11])
			begin
				UB_N = 1;
				write_data_word = {avs_writedata_buf[10:3], 8'd0};
			end
			else
			begin
				LB_N = 1;
				write_data_word = {8'd0, avs_writedata_buf[10:3]};
			end
			avs_write_flag_clear = 1;
		end
		else
		begin
			SW = 1;
			if(clk_25M == 0)
				coe_oSRAM_DATA[31:16] = SRAM_OUT;
			else
				coe_oSRAM_DATA[15:0] = SRAM_OUT;
		end
	end
end

reg [31:0] avs_writedata_buf;
reg avs_write_flag;

always@(posedge csi_clk or negedge csi_reset_n)
begin
	if((avs_chipselect == 1) && (avs_write == 1))
	begin
		avs_write_flag <= 1;
		avs_writedata_buf <= avs_writedata;
	end
	if(avs_write_flag_clear == 1)
		avs_write_flag <= 0;
end

endmodule

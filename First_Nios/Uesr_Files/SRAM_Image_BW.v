// SRAM驱动程序
// 利用SRAM进行中转，储存屏幕像素灰度信息，实现灰度图的显示
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
		coe_iRST_n,				// 重置信号，需要与扫描显示模块lcd_timing_controller同步
		coe_oSRAM_DATA,		// 输出32bit颜色信息到扫描显示模块lcd_timing_controller
		coe_iREAD_SRAM_EN, 	// 扫描使能，有效时每收到一个时钟信号指针read_counter后移一位
		coe_iCLK25M,         // 扫描显示模块lcd_timing_controller使用的25MHz时钟，需要两模块同步
);

// Avalon
input 						csi_clk;
input 						csi_reset_n;
input 						avs_chipselect;
input 		[3:0] 		avs_address;
input 						avs_read;
output reg  [31:0] 		avs_readdata;
input 						avs_write;
input 		[31:0] 		avs_writedata;		//[31:12]位为写入目标地址，[7:0]位为写入数据（表示像素的灰度）
// User Interface
output 		[19:0] 		coe_oSRAM_ADDR; 	//当前读/写地址
inout 		[15:0] 		coe_ioSRAM_DQ; 	//（三态）数据输入输出
output 						coe_oSRAM_WE_N; 	//写使能（WRITE ENABLE）
output 						coe_oSRAM_OE_N; 	//读使能（OUTPUT ENABLE）
output 						coe_oSRAM_UB_N; 	//高字节控制
output 						coe_oSRAM_LB_N; 	//低字节控制
output 						coe_oSRAM_CE_N; 	//片选
input 						coe_iRST_n;
output 		[31:0] 		coe_oSRAM_DATA;
input 						coe_iREAD_SRAM_EN;
input 						coe_iCLK25M;

reg SW;								// 读写标志，1为读0为写
reg [19:0] read_counter;     	// 读数据指针（需要扫描）
reg [19:0] write_counter;    	// 写数据指针（需要随机访问）
reg [15:0] write_data_word;  	// 写入的数据（1个字）

assign coe_oSRAM_ADDR = (SW) ? read_counter : write_counter;
assign coe_ioSRAM_DQ = (SW) ? 16'hzzzz : write_data_word; 		//三态门控制（写）
assign coe_oSRAM_UB_N = 1'b0;
assign coe_oSRAM_LB_N = 1'b0;
assign coe_oSRAM_CE_N = 1'b0;												//片选固定为有效，不使用高/低字节控制
assign coe_oSRAM_WE_N = (SW ? 1'b1 : 1'b0);
assign coe_oSRAM_OE_N = (SW ? 1'b0 : 1'b1);

wire [15:0] SRAM_OUT;
assign SRAM_OUT = SW ? coe_ioSRAM_DQ : 16'b1111111100000000; 	//三态门控制（读），端口被占用时默认输出0xff00，即白色
assign coe_oSRAM_DATA = {SRAM_OUT[15:8], SRAM_OUT[15:8], SRAM_OUT[15:8], 8'd0};
																					//默认输出灰度，即RGB值相等

reg [1:0] countdown;
reg [31:0] avs_write_data_buf;

// DE2-115板的SRAM最高支持125MHz时钟，在此用100MHz的csi_clk
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
			write_counter = avs_write_data_buf[31:12]; 				//获取地址
			write_data_word = {avs_write_data_buf[7:0], 8'd0}; 	//获取灰度数据
			countdown = 2'd2;													//设置SW=0并延时，使得下一个时钟到来时数据能够顺利写入
		end
	end
end

always@(posedge coe_iCLK25M or negedge coe_iRST_n)
begin
	if(!coe_iRST_n)
	begin
		read_counter = 20'd0; 												//与扫描显示模块同部重置，使屏幕上的（0, 0）点对应内存中的0位置
	end
	else
	begin
		if(coe_iREAD_SRAM_EN)
			read_counter = read_counter + 20'd1; 						//扫描使能有效时每一个时钟到来时指针后移一位
		if(read_counter == 20'd384000)									//一个循环为384000（800*480）位
			read_counter = 20'd0;
	end
end

endmodule

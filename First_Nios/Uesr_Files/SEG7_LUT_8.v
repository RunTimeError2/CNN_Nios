//带总线接口的8位数码管显示模块
//每4位对应1个数码管，最高4位对应最左侧的（HEX7）
module SEG7_LUT_8(
		//--------------Avalon-------------//
		csi_clk,				//100MHz
		csi_reset_n,
		avs_chipselect,
		avs_address,
		avs_read,
		avs_readdata,
		avs_write,
		avs_writedata,
		//------------User Interface-----------//
		coe_oSEG0,
		coe_oSEG1,
		coe_oSEG2,
		coe_oSEG3,
		coe_oSEG4,
		coe_oSEG5,
		coe_oSEG6,
		coe_oSEG7
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
output 		[6:0] 		coe_oSEG0;
output 		[6:0] 		coe_oSEG1;
output 		[6:0] 		coe_oSEG2;
output 		[6:0] 		coe_oSEG3;
output 		[6:0] 		coe_oSEG4;
output 		[6:0] 		coe_oSEG5;
output 		[6:0] 		coe_oSEG6;
output 		[6:0] 		coe_oSEG7;

reg 			[31:0]		iDIG;

SEG7_LUT	u0	(coe_oSEG0, iDIG[3:0]);
SEG7_LUT	u1	(coe_oSEG1, iDIG[7:4]);
SEG7_LUT	u2	(coe_oSEG2, iDIG[11:8]);
SEG7_LUT	u3	(coe_oSEG3, iDIG[15:12]);
SEG7_LUT	u4	(coe_oSEG4, iDIG[19:16]);
SEG7_LUT	u5	(coe_oSEG5, iDIG[23:20]);
SEG7_LUT	u6	(coe_oSEG6, iDIG[27:24]);
SEG7_LUT	u7	(coe_oSEG7, iDIG[31:28]);

always@(posedge csi_clk or negedge csi_reset_n)
begin
	if(!csi_reset_n)
	begin
		iDIG <= 32'hFFFFFFFF; // 4'hF is set as no output
	end
	else
	begin
		if((avs_chipselect == 1) && (avs_read == 1))
			avs_readdata <= iDIG;
		if((avs_chipselect == 1) && (avs_write == 1))
			iDIG <= avs_writedata;
	end
end

endmodule

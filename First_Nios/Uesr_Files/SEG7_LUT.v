//七段显示译码模块
//适用于DE2-115开发板的数码管
//0为亮1为不亮
//0xff被特意设置为不显示
module SEG7_LUT(oSEG, iDIG);
input		[3:0]	iDIG;
output	[6:0]	oSEG;
reg		[6:0]	oSEG;

always @(iDIG)
begin
		case(iDIG)
		4'h0: oSEG = 7'b1000000;
		4'h1: oSEG = 7'b1111001;	// ---g---
		4'h2: oSEG = 7'b0100100; 	// |	   |
		4'h3: oSEG = 7'b0110000; 	// b	   f
		4'h4: oSEG = 7'b0011001; 	// |	   |
		4'h5: oSEG = 7'b0010010; 	// ---a---
		4'h6: oSEG = 7'b0000010; 	// |	   |
		4'h7: oSEG = 7'b1111000; 	// c 	   e
		4'h8: oSEG = 7'b0000000; 	// |	   |
		4'h9: oSEG = 7'b0011000; 	// ---d---
		4'ha: oSEG = 7'b0001000;
		4'hb: oSEG = 7'b0000011;
		4'hc: oSEG = 7'b1000110;
		4'hd: oSEG = 7'b0100001;
		4'he: oSEG = 7'b0000110;
		4'hf: oSEG = 7'b1111111;
		endcase
end

endmodule

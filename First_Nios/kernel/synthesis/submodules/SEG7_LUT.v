module SEG7_LUT(oSEG, iDIG);
input		[3:0]	iDIG;
output	[6:0]	oSEG;
reg		[6:0]	oSEG;

always @(iDIG)
begin
		case(iDIG)
		4'h1: oSEG = 7'b1111001;	// ---t----
		4'h2: oSEG = 7'b0100100; 	// |	  |
		4'h3: oSEG = 7'b0110000; 	// lt	 rt
		4'h4: oSEG = 7'b0011001; 	// |	  |
		4'h5: oSEG = 7'b0010010; 	// ---m----
		4'h6: oSEG = 7'b0000010; 	// |	  |
		4'h7: oSEG = 7'b1111000; 	// lb	 rb
		4'h8: oSEG = 7'b0000000; 	// |	  |
		4'h9: oSEG = 7'b0011000; 	// ---b----
		4'ha: oSEG = 7'b0001000;
		4'hb: oSEG = 7'b0000011;
		4'hc: oSEG = 7'b1000110;
		4'hd: oSEG = 7'b0100001;
		4'he: oSEG = 7'b0000110;
		4'hf: oSEG = 7'b1111111;
		4'h0: oSEG = 7'b1000000;
		endcase
	/*case(iDIG)
		4'b0000: oSEG <= 7'b1111110;
		4'b0001: oSEG <= 7'b0110000;
		4'b0010: oSEG <= 7'b1101101;
		4'b0011: oSEG <= 7'b1111001;
		4'b0100: oSEG <= 7'b0110011;
		4'b0101: oSEG <= 7'b1011011;
		4'b0110: oSEG <= 7'b1011111;
		4'b0111: oSEG <= 7'b1110000;
		4'b1000: oSEG <= 7'b1111111;
		4'b1001: oSEG <= 7'b1111011;
		4'b1010: oSEG <= 7'b1110111;
		4'b1011: oSEG <= 7'b0011111;
		4'b1100: oSEG <= 7'b1001110;
		4'b1101: oSEG <= 7'b0111101;
		4'b1110: oSEG <= 7'b1001111;
		//4'b1111: oSEG <= 7'b1000111;
		4'b1111: oSEG <= 7'b0000000;
	endcase*/
end

endmodule

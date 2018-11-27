module three_wire_controller(	//	Host Side
						iCLK,
						iRST,
						iDATA,
						iSTR,
						oACK,
						oRDY,
						oCLK,
						//	Serial Side
						oSCEN,
						SDA,
						oSCLK	);
//	Host Side
input			iCLK;
input			iRST;
input			iSTR;
input	[15:0]	iDATA;
output			oACK;
output			oRDY;
output			oCLK;
//	Serial Side
output			oSCEN;
inout			SDA;
output			oSCLK;
//	Internal Register and Wire
reg				mSPI_CLK;
reg		[15:0]	mSPI_CLK_DIV;
reg				mSEN;
reg				mSDATA;
reg				mSCLK;
reg				mACK;
reg		[4:0]	mST;

parameter	CLK_Freq	=	50000000;	//	50	MHz
parameter	SPI_Freq	=	20000;		//	20	KHz

//	Serial Clock Generator
always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	begin
		mSPI_CLK	<=	0;
		mSPI_CLK_DIV	<=	0;
	end
	else
	begin
		if( mSPI_CLK_DIV	< (CLK_Freq/SPI_Freq) )
		mSPI_CLK_DIV	<=	mSPI_CLK_DIV+1;
		else
		begin
			mSPI_CLK_DIV	<=	0;
			mSPI_CLK		<=	~mSPI_CLK;
		end
	end
end
//	Parallel to Serial
always@(negedge mSPI_CLK or negedge iRST)
begin
	if(!iRST)
	begin
		mSEN	<=	1'b1;
		mSCLK	<=	1'b0;
		mSDATA	<=	1'bz;
		mACK	<=	1'b0;
		mST		<=	4'h00;
	end
	else
	begin
		if(iSTR)
		begin
			if(mST<17)
			mST	<=	mST+1'b1;
			if(mST==0)
			begin
				mSEN	<=	1'b0;
				mSCLK	<=	1'b1;
			end
			else if(mST==8)
			mACK	<=	SDA;
			else if(mST==16 && mSCLK)
			begin
				mSEN	<=	1'b1;
				mSCLK	<=	1'b0;	
			end
			if(mST<16)
			mSDATA	<=	iDATA[15-mST];
		end
		else
		begin
			mSEN	<=	1'b1;
			mSCLK	<=	1'b0;
			mSDATA	<=	1'bz;
			mACK	<=	1'b0;
			mST		<=	4'h00;
		end
	end
end

assign	oACK		=	mACK;
assign	oRDY		=	(mST==17)	?	1'b1	:	1'b0;
assign	oSCEN		=	mSEN;
assign	oSCLK		=	mSCLK	&	mSPI_CLK;
assign	SDA	=	(mST==8)	?	1'bz	:
						(mST==17)	?	1'bz	:
										mSDATA	;
assign	oCLK		=	mSPI_CLK;

endmodule
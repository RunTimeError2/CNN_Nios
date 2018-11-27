//触屏识别模块
//取自LTM屏的示例工程DE2_115_LTM_EPHOTO
//仅增加了总线接口
module adc_spi_controller (
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
		coe_iRST_n,
		coe_oADC_DIN,
		coe_oADC_DCLK,
		coe_oADC_CS,
		coe_iADC_DOUT,
		coe_iADC_BUSY,
		coe_iADC_PENIRQ_n,
		coe_oTOUCH_IRQ,
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
input							coe_iRST_n;
input							coe_iADC_DOUT;
input							coe_iADC_PENIRQ_n;
input							coe_iADC_BUSY;
output						coe_oADC_DIN;
output						coe_oADC_DCLK;
output						coe_oADC_CS;
output						coe_oTOUCH_IRQ;

always@(posedge csi_clk or negedge csi_reset_n)
begin
	if(!csi_reset_n)
		read_mode <= 32'd0;
	else
	begin
		if((avs_chipselect == 1) && (avs_write == 1))   //写控制字寄存器
			read_mode <= avs_writedata;
		if((avs_chipselect == 1) && (avs_read == 1))
		begin
			if(read_mode == 32'd0) 								//控制字寄存器为0时读状态，为1时读坐标
				avs_readdata <= {31'd0, oNEW_COORD};
			else
				avs_readdata <= {4'd0, oX_COORD, 4'd0, oY_COORD};
		end
	end
end

reg			[11:0]		oX_COORD;
reg			[11:0]		oY_COORD;
reg 			[31:0] 		read_mode;

reg iCLK; // 50MHz Clock
always@(posedge csi_clk or negedge csi_reset_n)
begin
	if(!csi_reset_n)
		iCLK = 0;
	else
		iCLK = (iCLK == 1) ? 0 : 1;
end

wire iRST_n;
assign iRST_n = coe_iRST_n;
wire oADC_DIN;
assign coe_oADC_DIN = oADC_DIN;
wire oADC_DCLK;
assign coe_oADC_DCLK = oADC_DCLK;
wire oADC_CS;
assign coe_oADC_CS = oADC_CS;
wire iADC_DOUT;
assign iADC_DOUT = coe_iADC_DOUT;
wire iADC_BUSY;
assign iADC_BUSY = coe_iADC_BUSY;
wire iADC_PENIRQ_n;
assign iADC_PENIRQ_n = coe_iADC_PENIRQ_n;
wire oTOUCH_IRQ;
assign coe_oTOUCH_IRQ = oTOUCH_IRQ;
					
//============================================================================
// PARAMETER declarations
//============================================================================	
parameter SYSCLK_FRQ	= 50000000;
parameter ADC_DCLK_FRQ	= 1000;
parameter ADC_DCLK_CNT	= SYSCLK_FRQ/(ADC_DCLK_FRQ*2);
		
//=============================================================================
// REG/WIRE declarations
//=============================================================================
reg				d1_PENIRQ_n;
reg				d2_PENIRQ_n;
wire			touch_irq;
reg		[15:0]	dclk_cnt;
wire			dclk;
reg				transmit_en;
reg		[6:0]	spi_ctrl_cnt;
//wire			oADC_CS;
reg				mcs;
reg				mdclk;
wire	[7:0]	x_config_reg;
wire	[7:0]	y_config_reg;
wire	[7:0]	ctrl_reg;
reg		[7:0]	mdata_in;
reg				y_coordinate_config;
wire			eof_transmition;	
reg		[5:0]	bit_cnt;	
reg				madc_out;	
reg		[11:0]	mx_coordinate;
reg		[11:0]	my_coordinate;	
//reg		[11:0]	oX_COORD;
//reg		[11:0]	oY_COORD;
wire			rd_coord_strob;
reg				oNEW_COORD;
reg		[5:0]	irq_cnt;
reg		[15:0]	clk_cnt;
//=============================================================================
// Structural coding
//=============================================================================
assign	x_config_reg = 8'h92;
assign	y_config_reg = 8'hd2;

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			madc_out <= 0;
		else
			madc_out <= iADC_DOUT;
	end		

///////////////   pen irq detect  //////// 
always@(posedge iCLK or negedge iRST_n)
	begin	
		if (!iRST_n)
			begin
				d1_PENIRQ_n	<= 0;
				d2_PENIRQ_n	<= 0;
			end
		else
			begin
				d1_PENIRQ_n	<= iADC_PENIRQ_n;	
				d2_PENIRQ_n	<= d1_PENIRQ_n;
			end
	end

// if iADC_PENIRQ_n form high to low , touch_irq goes high
assign		touch_irq = d2_PENIRQ_n & ~d1_PENIRQ_n; 
assign		oTOUCH_IRQ = touch_irq;
// if touch_irq goes high , starting transmit procedure ,transmit_en goes high
// if end of transmition and no penirq , transmit procedure stop.

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			transmit_en <= 0;
		else if (eof_transmition&&iADC_PENIRQ_n) 
			transmit_en <= 0;	
		else if (touch_irq)
			transmit_en <= 1;
	end			

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			dclk_cnt <= 0;
		else if (transmit_en) 
			begin
				if (dclk_cnt == ADC_DCLK_CNT)
					dclk_cnt <= 0;
				else
					dclk_cnt <= dclk_cnt + 1;		
			end
		else
			dclk_cnt <= 0;
	end			
	
assign	dclk =   (dclk_cnt == ADC_DCLK_CNT)? 1 : 0;		

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			spi_ctrl_cnt <= 0;
		else if (dclk)	
			begin
				if (spi_ctrl_cnt == 65)
					spi_ctrl_cnt <= 0;						
				else
					spi_ctrl_cnt <= spi_ctrl_cnt + 1;		
			end
	end				

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			begin
				mcs 	<= 1;
				mdclk	<= 0;
				mdata_in <= 0;
				y_coordinate_config <= 0;
				mx_coordinate <= 0;
				my_coordinate <= 0;
			end
		else if (transmit_en)
			begin
				if (dclk)
					begin
						if (spi_ctrl_cnt == 0)
							begin
								mcs 	<= 0;
								mdata_in <= ctrl_reg;
							end	
						else if (spi_ctrl_cnt == 49)
							begin
								mdclk	<= 0;
								y_coordinate_config <= ~y_coordinate_config;
								
								if (y_coordinate_config)
									mcs 	<= 1;
								else
									mcs 	<= 0;	
							end
						else if (spi_ctrl_cnt != 0)
							mdclk	<= ~mdclk;				
						if (mdclk)
							mdata_in <= {mdata_in[6:0],1'b0};
						if (!mdclk)	
							begin
								if(rd_coord_strob)
									begin
										if(y_coordinate_config)
											my_coordinate <= {my_coordinate[10:0],madc_out};
										else
											mx_coordinate <= {mx_coordinate[10:0],madc_out};	
									end
							end		
					end				
			end
	end

assign	oADC_CS  = mcs;
assign	oADC_DIN = 	mdata_in[7];
assign	oADC_DCLK = mdclk;
assign	ctrl_reg = y_coordinate_config ? y_config_reg : x_config_reg;
 
assign	eof_transmition = (y_coordinate_config & (spi_ctrl_cnt == 49) & dclk);

assign	rd_coord_strob = ((spi_ctrl_cnt>=19)&&(spi_ctrl_cnt<=41)) ? 1 : 0;

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			begin
				oX_COORD <= 0;	
				oY_COORD <= 0;
			end
		else if (eof_transmition&&(my_coordinate!=0))
			begin			
				oX_COORD <= mx_coordinate;	
				oY_COORD <= my_coordinate;
			end	
	end

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			oNEW_COORD <= 0;
		else if (eof_transmition&&(my_coordinate!=0))
			oNEW_COORD <= 1;
		else
			oNEW_COORD <= 0;		
	end

endmodule


module kernel (
	clk_clk,
	lcd1602_demo_conduit_end_0_export_data,
	lcd1602_demo_conduit_end_0_export_rw,
	lcd1602_demo_conduit_end_0_export_en,
	lcd1602_demo_conduit_end_0_export_rs,
	lcd1602_demo_conduit_end_0_export_blon,
	lcd1602_demo_conduit_end_0_export_on,
	pio_external_connection_export,
	reset_reset_n,
	sdram_controller_wire_addr,
	sdram_controller_wire_ba,
	sdram_controller_wire_cas_n,
	sdram_controller_wire_cke,
	sdram_controller_wire_cs_n,
	sdram_controller_wire_dq,
	sdram_controller_wire_dqm,
	sdram_controller_wire_ras_n,
	sdram_controller_wire_we_n,
	user_gio_pwm_conduit_end_0_export,
	user_ir_conduit_end_0_export_input,
	user_ltm_adc_conduit_end_0_export_irst_n,
	user_ltm_adc_conduit_end_0_export_oadc_din,
	user_ltm_adc_conduit_end_0_export_oadc_dclk,
	user_ltm_adc_conduit_end_0_export_oadc_cs,
	user_ltm_adc_conduit_end_0_export_iadc_dout,
	user_ltm_adc_conduit_end_0_export_iadc_busy,
	user_ltm_adc_conduit_end_0_export_iadc_penirq_n,
	user_ltm_adc_conduit_end_0_export_otouch_irq,
	user_seg8_conduit_end_0_export_0,
	user_seg8_conduit_end_0_export_1,
	user_seg8_conduit_end_0_export_2,
	user_seg8_conduit_end_0_export_3,
	user_seg8_conduit_end_0_export_4,
	user_seg8_conduit_end_0_export_5,
	user_seg8_conduit_end_0_export_6,
	user_seg8_conduit_end_0_export_7,
	user_sram_bw_conduit_end_0_export_osram_addr,
	user_sram_bw_conduit_end_0_export_iosram_dq,
	user_sram_bw_conduit_end_0_export_osram_we_n,
	user_sram_bw_conduit_end_0_export_osram_oe_n,
	user_sram_bw_conduit_end_0_export_osram_ub_n,
	user_sram_bw_conduit_end_0_export_osram_lb_n,
	user_sram_bw_conduit_end_0_export_osram_ce_n,
	user_sram_bw_conduit_end_0_export_irst_n,
	user_sram_bw_conduit_end_0_export_osram_data,
	user_sram_bw_conduit_end_0_export_iread_sram_en,
	user_sram_bw_conduit_end_0_export_iclk50m);	

	input		clk_clk;
	inout	[7:0]	lcd1602_demo_conduit_end_0_export_data;
	output		lcd1602_demo_conduit_end_0_export_rw;
	output		lcd1602_demo_conduit_end_0_export_en;
	output		lcd1602_demo_conduit_end_0_export_rs;
	output		lcd1602_demo_conduit_end_0_export_blon;
	output		lcd1602_demo_conduit_end_0_export_on;
	output		pio_external_connection_export;
	input		reset_reset_n;
	output	[12:0]	sdram_controller_wire_addr;
	output	[1:0]	sdram_controller_wire_ba;
	output		sdram_controller_wire_cas_n;
	output		sdram_controller_wire_cke;
	output		sdram_controller_wire_cs_n;
	inout	[31:0]	sdram_controller_wire_dq;
	output	[3:0]	sdram_controller_wire_dqm;
	output		sdram_controller_wire_ras_n;
	output		sdram_controller_wire_we_n;
	output		user_gio_pwm_conduit_end_0_export;
	input		user_ir_conduit_end_0_export_input;
	input		user_ltm_adc_conduit_end_0_export_irst_n;
	output		user_ltm_adc_conduit_end_0_export_oadc_din;
	output		user_ltm_adc_conduit_end_0_export_oadc_dclk;
	output		user_ltm_adc_conduit_end_0_export_oadc_cs;
	input		user_ltm_adc_conduit_end_0_export_iadc_dout;
	input		user_ltm_adc_conduit_end_0_export_iadc_busy;
	input		user_ltm_adc_conduit_end_0_export_iadc_penirq_n;
	output		user_ltm_adc_conduit_end_0_export_otouch_irq;
	output	[6:0]	user_seg8_conduit_end_0_export_0;
	output	[6:0]	user_seg8_conduit_end_0_export_1;
	output	[6:0]	user_seg8_conduit_end_0_export_2;
	output	[6:0]	user_seg8_conduit_end_0_export_3;
	output	[6:0]	user_seg8_conduit_end_0_export_4;
	output	[6:0]	user_seg8_conduit_end_0_export_5;
	output	[6:0]	user_seg8_conduit_end_0_export_6;
	output	[6:0]	user_seg8_conduit_end_0_export_7;
	output	[19:0]	user_sram_bw_conduit_end_0_export_osram_addr;
	inout	[15:0]	user_sram_bw_conduit_end_0_export_iosram_dq;
	output		user_sram_bw_conduit_end_0_export_osram_we_n;
	output		user_sram_bw_conduit_end_0_export_osram_oe_n;
	output		user_sram_bw_conduit_end_0_export_osram_ub_n;
	output		user_sram_bw_conduit_end_0_export_osram_lb_n;
	output		user_sram_bw_conduit_end_0_export_osram_ce_n;
	input		user_sram_bw_conduit_end_0_export_irst_n;
	output	[31:0]	user_sram_bw_conduit_end_0_export_osram_data;
	input		user_sram_bw_conduit_end_0_export_iread_sram_en;
	input		user_sram_bw_conduit_end_0_export_iclk50m;
endmodule

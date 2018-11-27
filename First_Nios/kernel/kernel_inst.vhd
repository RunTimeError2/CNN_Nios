	component kernel is
		port (
			clk_clk                                         : in    std_logic                     := 'X';             -- clk
			lcd1602_demo_conduit_end_0_export_data          : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- export_data
			lcd1602_demo_conduit_end_0_export_rw            : out   std_logic;                                        -- export_rw
			lcd1602_demo_conduit_end_0_export_en            : out   std_logic;                                        -- export_en
			lcd1602_demo_conduit_end_0_export_rs            : out   std_logic;                                        -- export_rs
			lcd1602_demo_conduit_end_0_export_blon          : out   std_logic;                                        -- export_blon
			lcd1602_demo_conduit_end_0_export_on            : out   std_logic;                                        -- export_on
			pio_external_connection_export                  : out   std_logic;                                        -- export
			reset_reset_n                                   : in    std_logic                     := 'X';             -- reset_n
			sdram_controller_wire_addr                      : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_controller_wire_ba                        : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_controller_wire_cas_n                     : out   std_logic;                                        -- cas_n
			sdram_controller_wire_cke                       : out   std_logic;                                        -- cke
			sdram_controller_wire_cs_n                      : out   std_logic;                                        -- cs_n
			sdram_controller_wire_dq                        : inout std_logic_vector(31 downto 0) := (others => 'X'); -- dq
			sdram_controller_wire_dqm                       : out   std_logic_vector(3 downto 0);                     -- dqm
			sdram_controller_wire_ras_n                     : out   std_logic;                                        -- ras_n
			sdram_controller_wire_we_n                      : out   std_logic;                                        -- we_n
			user_gio_pwm_conduit_end_0_export               : out   std_logic;                                        -- export
			user_ir_conduit_end_0_export_input              : in    std_logic                     := 'X';             -- export_input
			user_ltm_adc_conduit_end_0_export_irst_n        : in    std_logic                     := 'X';             -- export_irst_n
			user_ltm_adc_conduit_end_0_export_oadc_din      : out   std_logic;                                        -- export_oadc_din
			user_ltm_adc_conduit_end_0_export_oadc_dclk     : out   std_logic;                                        -- export_oadc_dclk
			user_ltm_adc_conduit_end_0_export_oadc_cs       : out   std_logic;                                        -- export_oadc_cs
			user_ltm_adc_conduit_end_0_export_iadc_dout     : in    std_logic                     := 'X';             -- export_iadc_dout
			user_ltm_adc_conduit_end_0_export_iadc_busy     : in    std_logic                     := 'X';             -- export_iadc_busy
			user_ltm_adc_conduit_end_0_export_iadc_penirq_n : in    std_logic                     := 'X';             -- export_iadc_penirq_n
			user_ltm_adc_conduit_end_0_export_otouch_irq    : out   std_logic;                                        -- export_otouch_irq
			user_seg8_conduit_end_0_export_0                : out   std_logic_vector(6 downto 0);                     -- export_0
			user_seg8_conduit_end_0_export_1                : out   std_logic_vector(6 downto 0);                     -- export_1
			user_seg8_conduit_end_0_export_2                : out   std_logic_vector(6 downto 0);                     -- export_2
			user_seg8_conduit_end_0_export_3                : out   std_logic_vector(6 downto 0);                     -- export_3
			user_seg8_conduit_end_0_export_4                : out   std_logic_vector(6 downto 0);                     -- export_4
			user_seg8_conduit_end_0_export_5                : out   std_logic_vector(6 downto 0);                     -- export_5
			user_seg8_conduit_end_0_export_6                : out   std_logic_vector(6 downto 0);                     -- export_6
			user_seg8_conduit_end_0_export_7                : out   std_logic_vector(6 downto 0);                     -- export_7
			user_sram_bw_conduit_end_0_export_osram_addr    : out   std_logic_vector(19 downto 0);                    -- export_osram_addr
			user_sram_bw_conduit_end_0_export_iosram_dq     : inout std_logic_vector(15 downto 0) := (others => 'X'); -- export_iosram_dq
			user_sram_bw_conduit_end_0_export_osram_we_n    : out   std_logic;                                        -- export_osram_we_n
			user_sram_bw_conduit_end_0_export_osram_oe_n    : out   std_logic;                                        -- export_osram_oe_n
			user_sram_bw_conduit_end_0_export_osram_ub_n    : out   std_logic;                                        -- export_osram_ub_n
			user_sram_bw_conduit_end_0_export_osram_lb_n    : out   std_logic;                                        -- export_osram_lb_n
			user_sram_bw_conduit_end_0_export_osram_ce_n    : out   std_logic;                                        -- export_osram_ce_n
			user_sram_bw_conduit_end_0_export_irst_n        : in    std_logic                     := 'X';             -- export_irst_n
			user_sram_bw_conduit_end_0_export_osram_data    : out   std_logic_vector(31 downto 0);                    -- export_osram_data
			user_sram_bw_conduit_end_0_export_iread_sram_en : in    std_logic                     := 'X';             -- export_iread_sram_en
			user_sram_bw_conduit_end_0_export_iclk50m       : in    std_logic                     := 'X'              -- export_iclk50m
		);
	end component kernel;

	u0 : component kernel
		port map (
			clk_clk                                         => CONNECTED_TO_clk_clk,                                         --                        clk.clk
			lcd1602_demo_conduit_end_0_export_data          => CONNECTED_TO_lcd1602_demo_conduit_end_0_export_data,          -- lcd1602_demo_conduit_end_0.export_data
			lcd1602_demo_conduit_end_0_export_rw            => CONNECTED_TO_lcd1602_demo_conduit_end_0_export_rw,            --                           .export_rw
			lcd1602_demo_conduit_end_0_export_en            => CONNECTED_TO_lcd1602_demo_conduit_end_0_export_en,            --                           .export_en
			lcd1602_demo_conduit_end_0_export_rs            => CONNECTED_TO_lcd1602_demo_conduit_end_0_export_rs,            --                           .export_rs
			lcd1602_demo_conduit_end_0_export_blon          => CONNECTED_TO_lcd1602_demo_conduit_end_0_export_blon,          --                           .export_blon
			lcd1602_demo_conduit_end_0_export_on            => CONNECTED_TO_lcd1602_demo_conduit_end_0_export_on,            --                           .export_on
			pio_external_connection_export                  => CONNECTED_TO_pio_external_connection_export,                  --    pio_external_connection.export
			reset_reset_n                                   => CONNECTED_TO_reset_reset_n,                                   --                      reset.reset_n
			sdram_controller_wire_addr                      => CONNECTED_TO_sdram_controller_wire_addr,                      --      sdram_controller_wire.addr
			sdram_controller_wire_ba                        => CONNECTED_TO_sdram_controller_wire_ba,                        --                           .ba
			sdram_controller_wire_cas_n                     => CONNECTED_TO_sdram_controller_wire_cas_n,                     --                           .cas_n
			sdram_controller_wire_cke                       => CONNECTED_TO_sdram_controller_wire_cke,                       --                           .cke
			sdram_controller_wire_cs_n                      => CONNECTED_TO_sdram_controller_wire_cs_n,                      --                           .cs_n
			sdram_controller_wire_dq                        => CONNECTED_TO_sdram_controller_wire_dq,                        --                           .dq
			sdram_controller_wire_dqm                       => CONNECTED_TO_sdram_controller_wire_dqm,                       --                           .dqm
			sdram_controller_wire_ras_n                     => CONNECTED_TO_sdram_controller_wire_ras_n,                     --                           .ras_n
			sdram_controller_wire_we_n                      => CONNECTED_TO_sdram_controller_wire_we_n,                      --                           .we_n
			user_gio_pwm_conduit_end_0_export               => CONNECTED_TO_user_gio_pwm_conduit_end_0_export,               -- user_gio_pwm_conduit_end_0.export
			user_ir_conduit_end_0_export_input              => CONNECTED_TO_user_ir_conduit_end_0_export_input,              --      user_ir_conduit_end_0.export_input
			user_ltm_adc_conduit_end_0_export_irst_n        => CONNECTED_TO_user_ltm_adc_conduit_end_0_export_irst_n,        -- user_ltm_adc_conduit_end_0.export_irst_n
			user_ltm_adc_conduit_end_0_export_oadc_din      => CONNECTED_TO_user_ltm_adc_conduit_end_0_export_oadc_din,      --                           .export_oadc_din
			user_ltm_adc_conduit_end_0_export_oadc_dclk     => CONNECTED_TO_user_ltm_adc_conduit_end_0_export_oadc_dclk,     --                           .export_oadc_dclk
			user_ltm_adc_conduit_end_0_export_oadc_cs       => CONNECTED_TO_user_ltm_adc_conduit_end_0_export_oadc_cs,       --                           .export_oadc_cs
			user_ltm_adc_conduit_end_0_export_iadc_dout     => CONNECTED_TO_user_ltm_adc_conduit_end_0_export_iadc_dout,     --                           .export_iadc_dout
			user_ltm_adc_conduit_end_0_export_iadc_busy     => CONNECTED_TO_user_ltm_adc_conduit_end_0_export_iadc_busy,     --                           .export_iadc_busy
			user_ltm_adc_conduit_end_0_export_iadc_penirq_n => CONNECTED_TO_user_ltm_adc_conduit_end_0_export_iadc_penirq_n, --                           .export_iadc_penirq_n
			user_ltm_adc_conduit_end_0_export_otouch_irq    => CONNECTED_TO_user_ltm_adc_conduit_end_0_export_otouch_irq,    --                           .export_otouch_irq
			user_seg8_conduit_end_0_export_0                => CONNECTED_TO_user_seg8_conduit_end_0_export_0,                --    user_seg8_conduit_end_0.export_0
			user_seg8_conduit_end_0_export_1                => CONNECTED_TO_user_seg8_conduit_end_0_export_1,                --                           .export_1
			user_seg8_conduit_end_0_export_2                => CONNECTED_TO_user_seg8_conduit_end_0_export_2,                --                           .export_2
			user_seg8_conduit_end_0_export_3                => CONNECTED_TO_user_seg8_conduit_end_0_export_3,                --                           .export_3
			user_seg8_conduit_end_0_export_4                => CONNECTED_TO_user_seg8_conduit_end_0_export_4,                --                           .export_4
			user_seg8_conduit_end_0_export_5                => CONNECTED_TO_user_seg8_conduit_end_0_export_5,                --                           .export_5
			user_seg8_conduit_end_0_export_6                => CONNECTED_TO_user_seg8_conduit_end_0_export_6,                --                           .export_6
			user_seg8_conduit_end_0_export_7                => CONNECTED_TO_user_seg8_conduit_end_0_export_7,                --                           .export_7
			user_sram_bw_conduit_end_0_export_osram_addr    => CONNECTED_TO_user_sram_bw_conduit_end_0_export_osram_addr,    -- user_sram_bw_conduit_end_0.export_osram_addr
			user_sram_bw_conduit_end_0_export_iosram_dq     => CONNECTED_TO_user_sram_bw_conduit_end_0_export_iosram_dq,     --                           .export_iosram_dq
			user_sram_bw_conduit_end_0_export_osram_we_n    => CONNECTED_TO_user_sram_bw_conduit_end_0_export_osram_we_n,    --                           .export_osram_we_n
			user_sram_bw_conduit_end_0_export_osram_oe_n    => CONNECTED_TO_user_sram_bw_conduit_end_0_export_osram_oe_n,    --                           .export_osram_oe_n
			user_sram_bw_conduit_end_0_export_osram_ub_n    => CONNECTED_TO_user_sram_bw_conduit_end_0_export_osram_ub_n,    --                           .export_osram_ub_n
			user_sram_bw_conduit_end_0_export_osram_lb_n    => CONNECTED_TO_user_sram_bw_conduit_end_0_export_osram_lb_n,    --                           .export_osram_lb_n
			user_sram_bw_conduit_end_0_export_osram_ce_n    => CONNECTED_TO_user_sram_bw_conduit_end_0_export_osram_ce_n,    --                           .export_osram_ce_n
			user_sram_bw_conduit_end_0_export_irst_n        => CONNECTED_TO_user_sram_bw_conduit_end_0_export_irst_n,        --                           .export_irst_n
			user_sram_bw_conduit_end_0_export_osram_data    => CONNECTED_TO_user_sram_bw_conduit_end_0_export_osram_data,    --                           .export_osram_data
			user_sram_bw_conduit_end_0_export_iread_sram_en => CONNECTED_TO_user_sram_bw_conduit_end_0_export_iread_sram_en, --                           .export_iread_sram_en
			user_sram_bw_conduit_end_0_export_iclk50m       => CONNECTED_TO_user_sram_bw_conduit_end_0_export_iclk50m        --                           .export_iclk50m
		);


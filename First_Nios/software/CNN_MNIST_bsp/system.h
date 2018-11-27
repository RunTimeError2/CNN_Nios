/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'nios2' in SOPC Builder design 'kernel'
 * SOPC Builder design path: ../../kernel.sopcinfo
 *
 * Generated: Fri Jul 13 20:22:26 GMT+08:00 2018
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_gen2"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x10000820
#define ALT_CPU_CPU_ARCH_NIOS2_R1
#define ALT_CPU_CPU_FREQ 100000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "fast"
#define ALT_CPU_DATA_ADDR_WIDTH 0x1d
#define ALT_CPU_DCACHE_LINE_SIZE 0
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_DCACHE_SIZE 0
#define ALT_CPU_EXCEPTION_ADDR 0x08000020
#define ALT_CPU_FLASH_ACCELERATOR_LINES 0
#define ALT_CPU_FLASH_ACCELERATOR_LINE_SIZE 0
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 100000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 1
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_EXTRA_EXCEPTION_INFO
#define ALT_CPU_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 32
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_ICACHE_SIZE 4096
#define ALT_CPU_INST_ADDR_WIDTH 0x1d
#define ALT_CPU_NAME "nios2"
#define ALT_CPU_NUM_OF_SHADOW_REG_SETS 0
#define ALT_CPU_OCI_VERSION 1
#define ALT_CPU_RESET_ADDR 0x08000000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x10000820
#define NIOS2_CPU_ARCH_NIOS2_R1
#define NIOS2_CPU_FREQ 100000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "fast"
#define NIOS2_DATA_ADDR_WIDTH 0x1d
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x08000020
#define NIOS2_FLASH_ACCELERATOR_LINES 0
#define NIOS2_FLASH_ACCELERATOR_LINE_SIZE 0
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 1
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_EXTRA_EXCEPTION_INFO
#define NIOS2_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 32
#define NIOS2_ICACHE_LINE_SIZE_LOG2 5
#define NIOS2_ICACHE_SIZE 4096
#define NIOS2_INST_ADDR_WIDTH 0x1d
#define NIOS2_NUM_OF_SHADOW_REG_SETS 0
#define NIOS2_OCI_VERSION 1
#define NIOS2_RESET_ADDR 0x08000000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_NEW_SDRAM_CONTROLLER
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_NIOS2_GEN2
#define __LCD1602_DEMO
#define __USER_GIO_PWM
#define __USER_IR
#define __USER_LTM_ADC
#define __USER_SEG8
#define __USER_SRAM_BW


/*
 * LCD1602_Demo configuration
 *
 */

#define ALT_MODULE_CLASS_LCD1602_Demo LCD1602_Demo
#define LCD1602_DEMO_BASE 0x10001000
#define LCD1602_DEMO_IRQ -1
#define LCD1602_DEMO_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LCD1602_DEMO_NAME "/dev/LCD1602_Demo"
#define LCD1602_DEMO_SPAN 128
#define LCD1602_DEMO_TYPE "LCD1602_Demo"


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Cyclone IV E"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart"
#define ALT_STDERR_BASE 0x100011d8
#define ALT_STDERR_DEV jtag_uart
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart"
#define ALT_STDIN_BASE 0x100011d8
#define ALT_STDIN_DEV jtag_uart
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart"
#define ALT_STDOUT_BASE 0x100011d8
#define ALT_STDOUT_DEV jtag_uart
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "kernel"


/*
 * User_GIO_PWM configuration
 *
 */

#define ALT_MODULE_CLASS_User_GIO_PWM User_GIO_PWM
#define USER_GIO_PWM_BASE 0x10001180
#define USER_GIO_PWM_IRQ -1
#define USER_GIO_PWM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define USER_GIO_PWM_NAME "/dev/User_GIO_PWM"
#define USER_GIO_PWM_SPAN 64
#define USER_GIO_PWM_TYPE "User_GIO_PWM"


/*
 * User_IR configuration
 *
 */

#define ALT_MODULE_CLASS_User_IR User_IR
#define USER_IR_BASE 0x10001140
#define USER_IR_IRQ -1
#define USER_IR_IRQ_INTERRUPT_CONTROLLER_ID -1
#define USER_IR_NAME "/dev/User_IR"
#define USER_IR_SPAN 64
#define USER_IR_TYPE "User_IR"


/*
 * User_LTM_ADC configuration
 *
 */

#define ALT_MODULE_CLASS_User_LTM_ADC User_LTM_ADC
#define USER_LTM_ADC_BASE 0x100010c0
#define USER_LTM_ADC_IRQ -1
#define USER_LTM_ADC_IRQ_INTERRUPT_CONTROLLER_ID -1
#define USER_LTM_ADC_NAME "/dev/User_LTM_ADC"
#define USER_LTM_ADC_SPAN 64
#define USER_LTM_ADC_TYPE "User_LTM_ADC"


/*
 * User_SEG8 configuration
 *
 */

#define ALT_MODULE_CLASS_User_SEG8 User_SEG8
#define USER_SEG8_BASE 0x10001100
#define USER_SEG8_IRQ -1
#define USER_SEG8_IRQ_INTERRUPT_CONTROLLER_ID -1
#define USER_SEG8_NAME "/dev/User_SEG8"
#define USER_SEG8_SPAN 64
#define USER_SEG8_TYPE "User_SEG8"


/*
 * User_SRAM_BW configuration
 *
 */

#define ALT_MODULE_CLASS_User_SRAM_BW User_SRAM_BW
#define USER_SRAM_BW_BASE 0x10001080
#define USER_SRAM_BW_IRQ -1
#define USER_SRAM_BW_IRQ_INTERRUPT_CONTROLLER_ID -1
#define USER_SRAM_BW_NAME "/dev/User_SRAM_BW"
#define USER_SRAM_BW_SPAN 64
#define USER_SRAM_BW_TYPE "User_SRAM_BW"


/*
 * hal configuration
 *
 */

#define ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
#define ALT_MAX_FD 32
#define ALT_SYS_CLK none
#define ALT_TIMESTAMP_CLK none


/*
 * jtag_uart configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart altera_avalon_jtag_uart
#define JTAG_UART_BASE 0x100011d8
#define JTAG_UART_IRQ 0
#define JTAG_UART_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_NAME "/dev/jtag_uart"
#define JTAG_UART_READ_DEPTH 64
#define JTAG_UART_READ_THRESHOLD 8
#define JTAG_UART_SPAN 8
#define JTAG_UART_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_WRITE_DEPTH 64
#define JTAG_UART_WRITE_THRESHOLD 8


/*
 * pio configuration
 *
 */

#define ALT_MODULE_CLASS_pio altera_avalon_pio
#define PIO_BASE 0x100011c0
#define PIO_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_CAPTURE 0
#define PIO_DATA_WIDTH 1
#define PIO_DO_TEST_BENCH_WIRING 0
#define PIO_DRIVEN_SIM_VALUE 0
#define PIO_EDGE_TYPE "NONE"
#define PIO_FREQ 100000000
#define PIO_HAS_IN 0
#define PIO_HAS_OUT 1
#define PIO_HAS_TRI 0
#define PIO_IRQ -1
#define PIO_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PIO_IRQ_TYPE "NONE"
#define PIO_NAME "/dev/pio"
#define PIO_RESET_VALUE 0
#define PIO_SPAN 16
#define PIO_TYPE "altera_avalon_pio"


/*
 * sdram_controller configuration
 *
 */

#define ALT_MODULE_CLASS_sdram_controller altera_avalon_new_sdram_controller
#define SDRAM_CONTROLLER_BASE 0x8000000
#define SDRAM_CONTROLLER_CAS_LATENCY 3
#define SDRAM_CONTROLLER_CONTENTS_INFO
#define SDRAM_CONTROLLER_INIT_NOP_DELAY 0.0
#define SDRAM_CONTROLLER_INIT_REFRESH_COMMANDS 2
#define SDRAM_CONTROLLER_IRQ -1
#define SDRAM_CONTROLLER_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SDRAM_CONTROLLER_IS_INITIALIZED 1
#define SDRAM_CONTROLLER_NAME "/dev/sdram_controller"
#define SDRAM_CONTROLLER_POWERUP_DELAY 100.0
#define SDRAM_CONTROLLER_REFRESH_PERIOD 15.625
#define SDRAM_CONTROLLER_REGISTER_DATA_IN 1
#define SDRAM_CONTROLLER_SDRAM_ADDR_WIDTH 0x19
#define SDRAM_CONTROLLER_SDRAM_BANK_WIDTH 2
#define SDRAM_CONTROLLER_SDRAM_COL_WIDTH 10
#define SDRAM_CONTROLLER_SDRAM_DATA_WIDTH 32
#define SDRAM_CONTROLLER_SDRAM_NUM_BANKS 4
#define SDRAM_CONTROLLER_SDRAM_NUM_CHIPSELECTS 1
#define SDRAM_CONTROLLER_SDRAM_ROW_WIDTH 13
#define SDRAM_CONTROLLER_SHARED_DATA 0
#define SDRAM_CONTROLLER_SIM_MODEL_BASE 0
#define SDRAM_CONTROLLER_SPAN 134217728
#define SDRAM_CONTROLLER_STARVATION_INDICATOR 0
#define SDRAM_CONTROLLER_TRISTATE_BRIDGE_SLAVE ""
#define SDRAM_CONTROLLER_TYPE "altera_avalon_new_sdram_controller"
#define SDRAM_CONTROLLER_T_AC 5.5
#define SDRAM_CONTROLLER_T_MRD 3
#define SDRAM_CONTROLLER_T_RCD 20.0
#define SDRAM_CONTROLLER_T_RFC 70.0
#define SDRAM_CONTROLLER_T_RP 20.0
#define SDRAM_CONTROLLER_T_WR 14.0


/*
 * sysid_qsys configuration
 *
 */

#define ALT_MODULE_CLASS_sysid_qsys altera_avalon_sysid_qsys
#define SYSID_QSYS_BASE 0x100011d0
#define SYSID_QSYS_ID 1
#define SYSID_QSYS_IRQ -1
#define SYSID_QSYS_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_QSYS_NAME "/dev/sysid_qsys"
#define SYSID_QSYS_SPAN 8
#define SYSID_QSYS_TIMESTAMP 1531484321
#define SYSID_QSYS_TYPE "altera_avalon_sysid_qsys"

#endif /* __SYSTEM_H_ */

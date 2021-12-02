create_clock -name {clk_50} -period 20.000 -waveform {0.000 10.000} { MAX10_CLK1_50 }
create_generated_clock -name spiclk -source [get_ports {MAX10_CLK1_50}] -divide_by 4 [get_registers {substitute_mcu:controller|spi_controller:spi|sck}]

set hostclk { clk_50 }
set supportclk { clk_50 }

derive_pll_clocks -create_base_clocks
derive_clock_uncertainty

# Set pin definitions for downstream constraints
set RAM_CLK DRAM_CLK
set RAM_OUT {DRAM_DQ* DRAM_ADDR* DRAM_BA* DRAM_RAS_N DRAM_CAS_N DRAM_WE_N DRAM_*DQM DRAM_CS_N DRAM_CKE}
set RAM_IN {DRAM_D*}

set VGA_OUT {VGA_R[*] VGA_G[*] VGA_B[*] VGA_HS VGA_VS}

# non timing-critical pins would be in the "FALSE_IN/OUT" collection (IN inputs, OUT outputs)
set FALSE_OUT {LED[*] SIGMA_* PS2_* JOYX_SEL_O AUDIO* I2S_* HDMI_I2C* HDMI_LRCLK HDMI_MCLK HDMI_SCLK HDMI_I2S[*] UART_TXD}
set FALSE_IN  {KEY[*] SW[*] PS2_* JOY1* AUDIO* HDMI_I2C* HDMI_LRCLK HDMI_MCLK HDMI_SCLK HDMI_I2S[*] EAR UART_RXD}
#the HDMI signals are probably fast enough to worth constraining properly at some point

# JTAG constraints for debug interface (if enabled)
# create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 altera_reserved_tdi
set_input_delay -clock altera_reserved_tck -clock_fall 3 altera_reserved_tms
set_output_delay -clock altera_reserved_tck 3 altera_reserved_tdo

set topmodule guest|
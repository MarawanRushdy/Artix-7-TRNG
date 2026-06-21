# ----------------------------------------------------------------------------
# Clock Signal (100 MHz Onboard Crystal)
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN W5 [get_ports clk]							
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

# ----------------------------------------------------------------------------
# Basys 3 Physical Pin Mapping for Switches & LEDs
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN V17 [get_ports enable_switch]
set_property IOSTANDARD LVCMOS33 [get_ports enable_switch]

set_property PACKAGE_PIN U16 [get_ports led_out]
set_property IOSTANDARD LVCMOS33 [get_ports led_out]

# ----------------------------------------------------------------------------
# USB-UART Transmission Pin
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN A18 [get_ports RsTx]						
set_property IOSTANDARD LVCMOS33 [get_ports RsTx]

# ----------------------------------------------------------------------------
# Architecture Overrides
# ----------------------------------------------------------------------------
# Downgrade the Combinatorial Loop Error (LUTLP-1) to a Warning for the entire design
set_property SEVERITY {Warning} [get_drc_checks LUTLP-1]
# Force Vivado to allow a standard IO switch to drive the chaotic loops
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets enable_switch_IBUF]
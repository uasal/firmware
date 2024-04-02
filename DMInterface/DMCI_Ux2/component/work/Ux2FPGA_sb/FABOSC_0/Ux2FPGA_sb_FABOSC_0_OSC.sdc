set_component Ux2FPGA_sb_FABOSC_0_OSC
# Microsemi Corp.
# Date: 2024-Mar-08 15:05:15
#

create_clock -ignore_errors -period 20 [ get_pins { I_RCOSC_25_50MHZ/CLKOUT } ]

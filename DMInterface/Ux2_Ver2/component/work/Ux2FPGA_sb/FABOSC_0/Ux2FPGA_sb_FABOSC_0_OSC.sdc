set_component Ux2FPGA_sb_FABOSC_0_OSC
# Microsemi Corp.
# Date: 2025-Apr-11 11:05:07
#

create_clock -ignore_errors -period 20 [ get_pins { I_RCOSC_25_50MHZ/CLKOUT } ]

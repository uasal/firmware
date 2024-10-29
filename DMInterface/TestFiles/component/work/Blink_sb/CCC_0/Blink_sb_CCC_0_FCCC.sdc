set_component Blink_sb_CCC_0_FCCC
# Microsemi Corp.
# Date: 2024-Jan-31 10:42:13
#

create_clock -period 10 [ get_pins { CCC_INST/CLK0_PAD } ]
create_generated_clock -multiply_by 4 -divide_by 4 -source [ get_pins { CCC_INST/CLK0_PAD } ] -phase 0 [ get_pins { CCC_INST/GL0 } ]

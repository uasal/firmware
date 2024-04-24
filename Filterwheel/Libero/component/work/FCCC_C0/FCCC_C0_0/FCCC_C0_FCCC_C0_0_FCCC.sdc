set_component FCCC_C0_FCCC_C0_0_FCCC
# Microsemi Corp.
# Date: 2024-Apr-23 14:20:27
#

create_clock -period 19.6078 [ get_pins { CCC_INST/CLK0_PAD } ]
create_generated_clock -multiply_by 8 -divide_by 4 -source [ get_pins { CCC_INST/CLK0_PAD } ] -phase 0 [ get_pins { CCC_INST/GL0 } ]
create_generated_clock -multiply_by 8 -divide_by 2 -source [ get_pins { CCC_INST/CLK0_PAD } ] -phase 0 [ get_pins { CCC_INST/GL1 } ]

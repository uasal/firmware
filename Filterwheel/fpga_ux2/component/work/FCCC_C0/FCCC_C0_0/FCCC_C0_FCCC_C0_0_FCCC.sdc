set_component FCCC_C0_FCCC_C0_0_FCCC
# Microsemi Corp.
# Date: 2024-Feb-08 11:34:46
#

create_clock -period 19.6078 [ get_pins { CCC_INST/CLK0 } ]
create_generated_clock -multiply_by 8 -divide_by 2 -source [ get_pins { CCC_INST/CLK0 } ] -phase 0 [ get_pins { CCC_INST/GL0 } ]

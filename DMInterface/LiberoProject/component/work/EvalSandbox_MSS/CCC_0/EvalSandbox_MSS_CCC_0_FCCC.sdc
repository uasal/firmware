set_component EvalSandbox_MSS_CCC_0_FCCC
# Microsemi Corp.
# Date: 2024-Mar-29 14:02:38
#

create_clock -period 19.6078 [ get_pins { CCC_INST/CLK0 } ]
create_generated_clock -multiply_by 4 -divide_by 2 -source [ get_pins { CCC_INST/CLK0 } ] -phase 0 [ get_pins { CCC_INST/GL0 } ]

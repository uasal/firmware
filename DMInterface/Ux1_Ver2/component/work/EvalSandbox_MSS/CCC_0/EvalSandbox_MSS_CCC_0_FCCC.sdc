set_component EvalSandbox_MSS_CCC_0_FCCC
# Microsemi Corp.
# Date: 2025-Apr-22 16:12:09
#

create_clock -period 9.80392 [ get_pins { CCC_INST/CLK0 } ]
create_generated_clock -multiply_by 3 -divide_by 3 -source [ get_pins { CCC_INST/CLK0 } ] -phase 0 [ get_pins { CCC_INST/GL0 } ]

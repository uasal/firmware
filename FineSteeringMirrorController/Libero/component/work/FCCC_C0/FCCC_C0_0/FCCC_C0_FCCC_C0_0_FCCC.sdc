set_component FCCC_C0_FCCC_C0_0_FCCC
# Microsemi Corp.
# Date: 2025-Sep-08 17:19:57
#

create_clock -period 29.4118 [ get_pins { CCC_INST/CLK0_PAD } ]
create_generated_clock -multiply_by 3 -source [ get_pins { CCC_INST/CLK0_PAD } ] -phase 0 [ get_pins { CCC_INST/GL0 } ]
create_generated_clock -multiply_by 3 -source [ get_pins { CCC_INST/CLK0_PAD } ] -phase 0 [ get_pins { CCC_INST/GL1 } ]

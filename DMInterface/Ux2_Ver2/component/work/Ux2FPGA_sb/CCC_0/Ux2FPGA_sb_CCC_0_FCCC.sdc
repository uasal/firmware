set_component Ux2FPGA_sb_CCC_0_FCCC
# Microsemi Corp.
# Date: 2025-Apr-11 11:05:06
#

create_clock -period 19.6078 [ get_pins { CCC_INST/CLK0 } ]
create_generated_clock -multiply_by 4 -divide_by 2 -source [ get_pins { CCC_INST/CLK0 } ] -phase 0 [ get_pins { CCC_INST/GL0 } ]

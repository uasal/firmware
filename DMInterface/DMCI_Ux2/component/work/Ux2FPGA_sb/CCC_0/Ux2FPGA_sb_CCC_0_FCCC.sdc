set_component Ux2FPGA_sb_CCC_0_FCCC
# Microsemi Corp.
# Date: 2024-Mar-08 15:05:14
#

create_clock -period 19.6078 [ get_pins { CCC_INST/CLK0 } ]
create_generated_clock -multiply_by 4 -divide_by 2 -source [ get_pins { CCC_INST/CLK0 } ] -phase 0 [ get_pins { CCC_INST/GL0 } ]

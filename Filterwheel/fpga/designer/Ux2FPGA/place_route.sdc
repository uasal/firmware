# Microsemi Corp.
# Date: 2024-Mar-12 14:39:00
# This file was generated based on the following SDC source files:
#   C:/MicroSemiProj/DMCI_Ux2/constraint/Ux2FPGA_derived_constraints.sdc
#

create_clock -name {CLK0} -period 19.6078 [ get_ports { CLK0 } ]
create_generated_clock -name {Ux2FPGA_sb_0/CCC_0/GL0} -multiply_by 4 -divide_by 2 -source [ get_pins { Ux2FPGA_sb_0/CCC_0/CCC_INST/INST_CCC_IP/CLK0 } ] -phase 0 [ get_pins { Ux2FPGA_sb_0/CCC_0/CCC_INST/INST_CCC_IP/GL0 } ]
set_false_path -through [ get_pins { Ux2FPGA_sb_0/Ux2FPGA_sb_MSS_0/MSS_ADLIB_INST/INST_MSS_025_IP/CONFIG_PRESET_N } ]

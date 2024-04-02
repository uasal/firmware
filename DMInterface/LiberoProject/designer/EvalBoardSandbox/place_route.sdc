# Microsemi Corp.
# Date: 2024-Mar-29 14:07:43
# This file was generated based on the following SDC source files:
#   C:/Users/SKaye/repos/firmware/DMInterface/LiberoProject/constraint/EvalBoardSandbox_derived_constraints.sdc
#

create_clock -name {CLK0} -period 19.6078 [ get_ports { CLK0 } ]
create_generated_clock -name {EvalSandbox_MSS_0/CCC_0/GL0} -multiply_by 4 -divide_by 2 -source [ get_pins { EvalSandbox_MSS_0/CCC_0/CCC_INST/INST_CCC_IP/CLK0 } ] -phase 0 [ get_pins { EvalSandbox_MSS_0/CCC_0/CCC_INST/INST_CCC_IP/GL0 } ]
set_false_path -through [ get_pins { EvalSandbox_MSS_0/EvalSandbox_MSS_MSS_0/MSS_ADLIB_INST/INST_MSS_025_IP/CONFIG_PRESET_N } ]

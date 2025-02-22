# Microsemi Corp.
# Date: 2025-Feb-19 11:10:04
# This file was generated based on the following SDC source files:
#   C:/Users/SKaye/repos/firmware/DMInterface/Ux1_Ver2/constraint/EvalBoardSandbox_derived_constraints.sdc
#

create_clock -name {CLK0_PAD} -period 19.6078 [ get_ports { CLK0_PAD } ]
create_generated_clock -name {EvalSandbox_MSS_0/CCC_0/GL0} -multiply_by 3 -divide_by 3 -source [ get_pins { EvalSandbox_MSS_0/CCC_0/CCC_INST/INST_CCC_IP/CLK0 } ] -phase 0 [ get_pins { EvalSandbox_MSS_0/CCC_0/CCC_INST/INST_CCC_IP/GL0 } ]
create_generated_clock -name {FCCC_C0_0/FCCC_C0_0/GL0} -multiply_by 4 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/CLK0_PAD } ] -phase 0 [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/GL0 } ]
create_generated_clock -name {FCCC_C0_0/FCCC_C0_0/GL1} -multiply_by 4 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/CLK0_PAD } ] -phase 0 [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/GL1 } ]
set_false_path -through [ get_pins { EvalSandbox_MSS_0/EvalSandbox_MSS_MSS_0/MSS_ADLIB_INST/INST_MSS_010_IP/CONFIG_PRESET_N } ]

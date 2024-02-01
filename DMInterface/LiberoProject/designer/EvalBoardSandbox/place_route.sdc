# Microsemi Corp.
# Date: 2024-Jan-31 16:43:33
# This file was generated based on the following SDC source files:
#   C:/Users/SKaye/repos/firmware/DMInterface/LiberoProject/constraint/EvalBoardSandbox_derived_constraints.sdc
#

create_clock -name {EvalSandbox_MSS_0/FABOSC_0/I_RCOSC_25_50MHZ/CLKOUT} -period 20 [ get_pins { EvalSandbox_MSS_0/FABOSC_0/I_RCOSC_25_50MHZ/CLKOUT } ]
create_generated_clock -name {EvalSandbox_MSS_0/CCC_0/GL0} -multiply_by 4 -divide_by 2 -source [ get_pins { EvalSandbox_MSS_0/CCC_0/CCC_INST/INST_CCC_IP/RCOSC_25_50MHZ } ] -phase 0 [ get_pins { EvalSandbox_MSS_0/CCC_0/CCC_INST/INST_CCC_IP/GL0 } ]
set_false_path -through [ get_pins { EvalSandbox_MSS_0/EvalSandbox_MSS_MSS_0/MSS_ADLIB_INST/INST_MSS_025_IP/CONFIG_PRESET_N } ]

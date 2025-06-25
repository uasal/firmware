# Microsemi Corp.
# Date: 2025-Jun-25 14:37:18
# This file was generated based on the following SDC source files:
#   /home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/constraint/EvalBoardSandbox_derived_constraints.sdc
#   /home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/constraint/user.sdc
#

create_clock -name {CLK0_PAD} -period 19.6078 [ get_ports { CLK0_PAD } ]
create_generated_clock -name {EvalSandbox_MSS_0/CCC_0/GL0} -multiply_by 3 -divide_by 3 -source [ get_pins { EvalSandbox_MSS_0/CCC_0/CCC_INST/INST_CCC_IP/CLK0 } ] -phase 0 [ get_pins { EvalSandbox_MSS_0/CCC_0/CCC_INST/INST_CCC_IP/GL0 } ]
create_generated_clock -name {FCCC_C0_0/FCCC_C0_0/GL0} -multiply_by 4 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/CLK0_PAD } ] -phase 0 [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/GL0 } ]
create_generated_clock -name {uart0clk} -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/GL0 } ] [ get_pins { DMMainPorts_1/Uart0BitClockDiv/clko_i/Q } ]
create_generated_clock -name {uart0txclk} -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/GL0 } ] [ get_pins { DMMainPorts_1/Uart0TxBitClockDiv/div_i/Q } ]
create_generated_clock -name {uart1clk} -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/GL0 } ] [ get_pins { DMMainPorts_1/Uart1BitClockDiv/clko_i/Q } ]
create_generated_clock -name {uart1txclk} -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/GL0 } ] [ get_pins { DMMainPorts_1/Uart1TxBitClockDiv/div_i/Q } ]
create_generated_clock -name {uart2clk} -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/GL0 } ] [ get_pins { DMMainPorts_1/Uart2BitClockDiv/clko_i/Q } ]
create_generated_clock -name {uart2txclk} -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/GL0 } ] [ get_pins { DMMainPorts_1/Uart2TxBitClockDiv/div_i/Q } ]
create_generated_clock -name {uart3clk} -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/GL0 } ] [ get_pins { DMMainPorts_1/Uart3BitClockDiv/clko_i/Q } ]
create_generated_clock -name {uart3txclk} -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/GL0 } ] [ get_pins { DMMainPorts_1/Uart3TxBitClockDiv/div_i/Q } ]
set_false_path -through [ get_pins { EvalSandbox_MSS_0/EvalSandbox_MSS_MSS_0/MSS_ADLIB_INST/INST_MSS_025_IP/CONFIG_PRESET_N } ]

# Microsemi Corp.
# Date: 2025-Apr-11 16:55:22
# This file was generated based on the following SDC source files:
#   C:/Users/SKaye/repos7/firmware/DMInterface/Ux2_Ver2/constraint/Ux2FPGA_derived_constraints.sdc
#   C:/Users/SKaye/repos7/firmware/DMInterface/Ux2_Ver2/constraint/user.sdc
#

create_clock -name {CLK0_PAD} -period 19.6078 [ get_ports { CLK0_PAD } ]
create_generated_clock -name {FCCC_C0_0/FCCC_C0_0/GL0} -multiply_by 4 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/CLK0_PAD } ] -phase 0 [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/GL0 } ]
create_generated_clock -name {FCCC_C0_0/FCCC_C0_0/GL1} -multiply_by 4 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/CLK0_PAD } ] -phase 0 [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/GL1 } ]
create_generated_clock -name {Ux2FPGA_sb_0/CCC_0/GL0} -multiply_by 4 -divide_by 2 -source [ get_pins { Ux2FPGA_sb_0/CCC_0/CCC_INST/INST_CCC_IP/CLK0 } ] -phase 0 [ get_pins { Ux2FPGA_sb_0/CCC_0/CCC_INST/INST_CCC_IP/GL0 } ]
create_generated_clock -name {uart3clk} -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/GL0 } ] [ get_pins { DMMainPorts_0/Uart3BitClockDiv/clko_i/Q } ]
create_generated_clock -name {uart3txclk} -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/INST_CCC_IP/GL0 } ] [ get_pins { DMMainPorts_0/Uart3TxBitClockDiv/div_i/Q } ]
set_false_path -through [ get_pins { Ux2FPGA_sb_0/Ux2FPGA_sb_MSS_0/MSS_ADLIB_INST/INST_MSS_025_IP/CONFIG_PRESET_N } ]

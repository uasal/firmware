# Microsemi Corp.
# Date: 2024-Apr-11 14:11:16
# This file was generated based on the following SDC source files:
#   C:/MicroSemiProj/DMCI_Ux2/component/work/Ux2FPGA_sb/CCC_0/Ux2FPGA_sb_CCC_0_FCCC.sdc
#   C:/Microchip/Libero_SoC_v2023.2/Designer/data/aPA4M/cores/constraints/coreresetp.sdc
#   C:/MicroSemiProj/DMCI_Ux2/component/work/Ux2FPGA_sb/FABOSC_0/Ux2FPGA_sb_FABOSC_0_OSC.sdc
#   C:/MicroSemiProj/DMCI_Ux2/component/work/Ux2FPGA_sb_MSS/Ux2FPGA_sb_MSS.sdc
#   C:/Microchip/Libero_SoC_v2023.2/Designer/data/aPA4M/cores/constraints/sysreset.sdc
# *** Any modifications to this file will be lost if derived constraints is re-run. ***
#

create_clock -name {CLK0} -period 19.6078 [ get_ports { CLK0 } ]
create_clock -ignore_errors -name {Ux2FPGA_sb_0/FABOSC_0/I_RCOSC_25_50MHZ/CLKOUT} -period 20 [ get_pins { Ux2FPGA_sb_0/FABOSC_0/I_RCOSC_25_50MHZ/CLKOUT } ]
create_generated_clock -name {Ux2FPGA_sb_0/CCC_0/GL0} -multiply_by 4 -divide_by 2 -source [ get_pins { Ux2FPGA_sb_0/CCC_0/CCC_INST/CLK0 } ] -phase 0 [ get_pins { Ux2FPGA_sb_0/CCC_0/CCC_INST/GL0 } ]
set_false_path -ignore_errors -through [ get_nets { Ux2FPGA_sb_0/CORERESETP_0/ddr_settled Ux2FPGA_sb_0/CORERESETP_0/count_ddr_enable Ux2FPGA_sb_0/CORERESETP_0/release_sdif*_core Ux2FPGA_sb_0/CORERESETP_0/count_sdif*_enable } ]
set_false_path -ignore_errors -from [ get_cells { Ux2FPGA_sb_0/CORERESETP_0/MSS_HPMS_READY_int } ] -to [ get_cells { Ux2FPGA_sb_0/CORERESETP_0/sm0_areset_n_rcosc Ux2FPGA_sb_0/CORERESETP_0/sm0_areset_n_rcosc_q1 } ]
set_false_path -ignore_errors -from [ get_cells { Ux2FPGA_sb_0/CORERESETP_0/MSS_HPMS_READY_int Ux2FPGA_sb_0/CORERESETP_0/SDIF*_PERST_N_re } ] -to [ get_cells { Ux2FPGA_sb_0/CORERESETP_0/sdif*_areset_n_rcosc* } ]
set_false_path -ignore_errors -through [ get_nets { Ux2FPGA_sb_0/CORERESETP_0/CONFIG1_DONE Ux2FPGA_sb_0/CORERESETP_0/CONFIG2_DONE Ux2FPGA_sb_0/CORERESETP_0/SDIF*_PERST_N Ux2FPGA_sb_0/CORERESETP_0/SDIF*_PSEL Ux2FPGA_sb_0/CORERESETP_0/SDIF*_PWRITE Ux2FPGA_sb_0/CORERESETP_0/SDIF*_PRDATA[*] Ux2FPGA_sb_0/CORERESETP_0/SOFT_EXT_RESET_OUT Ux2FPGA_sb_0/CORERESETP_0/SOFT_RESET_F2M Ux2FPGA_sb_0/CORERESETP_0/SOFT_M3_RESET Ux2FPGA_sb_0/CORERESETP_0/SOFT_MDDR_DDR_AXI_S_CORE_RESET Ux2FPGA_sb_0/CORERESETP_0/SOFT_FDDR_CORE_RESET Ux2FPGA_sb_0/CORERESETP_0/SOFT_SDIF*_PHY_RESET Ux2FPGA_sb_0/CORERESETP_0/SOFT_SDIF*_CORE_RESET Ux2FPGA_sb_0/CORERESETP_0/SOFT_SDIF0_0_CORE_RESET Ux2FPGA_sb_0/CORERESETP_0/SOFT_SDIF0_1_CORE_RESET } ]
set_false_path -ignore_errors -through [ get_pins { Ux2FPGA_sb_0/Ux2FPGA_sb_MSS_0/MSS_ADLIB_INST/CONFIG_PRESET_N } ]
set_false_path -ignore_errors -through [ get_pins { Ux2FPGA_sb_0/SYSRESET_POR/POWER_ON_RESET_N } ]


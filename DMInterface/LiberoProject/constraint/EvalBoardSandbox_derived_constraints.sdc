# Microsemi Corp.
# Date: 2024-Jan-29 12:06:50
# This file was generated based on the following SDC source files:
#   C:/MicroSemiProj/EvalBoardSandbox/component/work/EvalSandbox_MSS/CCC_0/EvalSandbox_MSS_CCC_0_FCCC.sdc
#   C:/Microchip/Libero_SoC_v2023.2/Designer/data/aPA4M/cores/constraints/PA4M1000/coreconfigp.sdc
#   C:/Microchip/Libero_SoC_v2023.2/Designer/data/aPA4M/cores/constraints/coreresetp.sdc
#   C:/MicroSemiProj/EvalBoardSandbox/component/work/EvalSandbox_MSS_MSS/EvalSandbox_MSS_MSS.sdc
#   C:/MicroSemiProj/EvalBoardSandbox/component/work/EvalSandbox_MSS/FABOSC_0/EvalSandbox_MSS_FABOSC_0_OSC.sdc
#   C:/Microchip/Libero_SoC_v2023.2/Designer/data/aPA4M/cores/constraints/sysreset.sdc
# *** Any modifications to this file will be lost if derived constraints is re-run. ***
#

create_clock -name {EvalSandbox_MSS_0/EvalSandbox_MSS_MSS_0/CLK_CONFIG_APB} -period 40 [ get_pins { EvalSandbox_MSS_0/EvalSandbox_MSS_MSS_0/MSS_ADLIB_INST/CLK_CONFIG_APB } ]
create_clock -ignore_errors -name {EvalSandbox_MSS_0/FABOSC_0/I_RCOSC_25_50MHZ/CLKOUT} -period 20 [ get_pins { EvalSandbox_MSS_0/FABOSC_0/I_RCOSC_25_50MHZ/CLKOUT } ]
create_generated_clock -name {EvalSandbox_MSS_0/CCC_0/GL0} -multiply_by 4 -divide_by 2 -source [ get_pins { EvalSandbox_MSS_0/CCC_0/CCC_INST/RCOSC_25_50MHZ } ] -phase 0 [ get_pins { EvalSandbox_MSS_0/CCC_0/CCC_INST/GL0 } ]
set_false_path -ignore_errors -through [ get_nets { EvalSandbox_MSS_0/CORECONFIGP_0/INIT_DONE EvalSandbox_MSS_0/CORECONFIGP_0/SDIF_RELEASED } ]
set_false_path -ignore_errors -through [ get_nets { EvalSandbox_MSS_0/CORERESETP_0/ddr_settled EvalSandbox_MSS_0/CORERESETP_0/count_ddr_enable EvalSandbox_MSS_0/CORERESETP_0/release_sdif*_core EvalSandbox_MSS_0/CORERESETP_0/count_sdif*_enable } ]
set_false_path -ignore_errors -from [ get_cells { EvalSandbox_MSS_0/CORERESETP_0/MSS_HPMS_READY_int } ] -to [ get_cells { EvalSandbox_MSS_0/CORERESETP_0/sm0_areset_n_rcosc EvalSandbox_MSS_0/CORERESETP_0/sm0_areset_n_rcosc_q1 } ]
set_false_path -ignore_errors -from [ get_cells { EvalSandbox_MSS_0/CORERESETP_0/MSS_HPMS_READY_int EvalSandbox_MSS_0/CORERESETP_0/SDIF*_PERST_N_re } ] -to [ get_cells { EvalSandbox_MSS_0/CORERESETP_0/sdif*_areset_n_rcosc* } ]
set_false_path -ignore_errors -through [ get_nets { EvalSandbox_MSS_0/CORERESETP_0/CONFIG1_DONE EvalSandbox_MSS_0/CORERESETP_0/CONFIG2_DONE EvalSandbox_MSS_0/CORERESETP_0/SDIF*_PERST_N EvalSandbox_MSS_0/CORERESETP_0/SDIF*_PSEL EvalSandbox_MSS_0/CORERESETP_0/SDIF*_PWRITE EvalSandbox_MSS_0/CORERESETP_0/SDIF*_PRDATA[*] EvalSandbox_MSS_0/CORERESETP_0/SOFT_EXT_RESET_OUT EvalSandbox_MSS_0/CORERESETP_0/SOFT_RESET_F2M EvalSandbox_MSS_0/CORERESETP_0/SOFT_M3_RESET EvalSandbox_MSS_0/CORERESETP_0/SOFT_MDDR_DDR_AXI_S_CORE_RESET EvalSandbox_MSS_0/CORERESETP_0/SOFT_FDDR_CORE_RESET EvalSandbox_MSS_0/CORERESETP_0/SOFT_SDIF*_PHY_RESET EvalSandbox_MSS_0/CORERESETP_0/SOFT_SDIF*_CORE_RESET EvalSandbox_MSS_0/CORERESETP_0/SOFT_SDIF0_0_CORE_RESET EvalSandbox_MSS_0/CORERESETP_0/SOFT_SDIF0_1_CORE_RESET } ]
set_false_path -ignore_errors -through [ get_pins { EvalSandbox_MSS_0/EvalSandbox_MSS_MSS_0/MSS_ADLIB_INST/CONFIG_PRESET_N } ]
set_false_path -ignore_errors -through [ get_pins { EvalSandbox_MSS_0/SYSRESET_POR/POWER_ON_RESET_N } ]
set_min_delay -24 -through [ get_nets { EvalSandbox_MSS_0/CORECONFIGP_0/FIC_2_APB_M_PWRITE EvalSandbox_MSS_0/CORECONFIGP_0/FIC_2_APB_M_PADDR[*] EvalSandbox_MSS_0/CORECONFIGP_0/FIC_2_APB_M_PWDATA[*] EvalSandbox_MSS_0/CORECONFIGP_0/FIC_2_APB_M_PSEL EvalSandbox_MSS_0/CORECONFIGP_0/FIC_2_APB_M_PENABLE } ]
set_min_delay 0 -through [ get_nets { EvalSandbox_MSS_0/CORECONFIGP_0/FIC_2_APB_M_PSEL EvalSandbox_MSS_0/CORECONFIGP_0/FIC_2_APB_M_PENABLE } ] -to [ get_cells { EvalSandbox_MSS_0/CORECONFIGP_0/FIC_2_APB_M_PREADY* EvalSandbox_MSS_0/CORECONFIGP_0/state[0] } ]

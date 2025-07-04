# Written by Synplify Pro version map202209actsp2, Build 145R. Synopsys Run ID: sid1750887398 
# Top Level Design Parameters 

# Clocks 
create_clock -period 19.608 -waveform {0.000 9.804} -name {CLK0_PAD} [get_ports {CLK0_PAD}] 

# Virtual Clocks 

# Generated Clocks 
create_generated_clock -name {FCCC_C0_0/FCCC_C0_0/GL0} -multiply_by {4} -divide_by {2} -source [get_pins {FCCC_C0_0/FCCC_C0_0/CCC_INST/CLK0_PAD}]  [get_pins {FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0}] 
create_generated_clock -name {EvalSandbox_MSS_0/CCC_0/GL0} -multiply_by {3} -divide_by {3} -source [get_pins {EvalSandbox_MSS_0/CCC_0/CCC_INST/CLK0}]  [get_pins {EvalSandbox_MSS_0/CCC_0/CCC_INST/GL0}] 

# Paths Between Clocks 

# Multicycle Constraints 

# Point-to-point Delay Constraints 

# False Path Constraints 

# Output Load Constraints 

# Driving Cell Constraints 

# Input Delay Constraints 

# Output Delay Constraints 

# Wire Loads 

# Other Constraints 

# syn_hier Attributes 

# set_case Attributes 

# Clock Delay Constraints 

# syn_mode Attributes 

# Cells 

# Port DRC Rules 

# Input Transition Constraints 

# Unused constraints (intentionally commented out) 
# create_clock -name EvalSandbox_MSS_0/FABOSC_0/I_RCOSC_25_50MHZ/CLKOUT -period 20 [get_pins { EvalSandbox_MSS_0.FABOSC_0.I_RCOSC_25_50MHZ.CLKOUT }]
# create_generated_clock -name uart0clk -divide_by 2 -source [get_pins { FCCC_C0_0.FCCC_C0_0.CCC_INST.GL0 }] [get_pins { DMMainPorts_1.Uart0BitClockDiv.clko_i.Q }]
# create_generated_clock -name uart0txclk -divide_by 2 -source [get_pins { FCCC_C0_0.FCCC_C0_0.CCC_INST.GL0 }] [get_pins { DMMainPorts_1.Uart0TxBitClockDiv.div_i.Q }]
# create_generated_clock -name uart1clk -divide_by 2 -source [get_pins { FCCC_C0_0.FCCC_C0_0.CCC_INST.GL0 }] [get_pins { DMMainPorts_1.Uart1BitClockDiv.clko_i.Q }]
# create_generated_clock -name uart1txclk -divide_by 2 -source [get_pins { FCCC_C0_0.FCCC_C0_0.CCC_INST.GL0 }] [get_pins { DMMainPorts_1.Uart1TxBitClockDiv.div_i.Q }]
# create_generated_clock -name uart2clk -divide_by 2 -source [get_pins { FCCC_C0_0.FCCC_C0_0.CCC_INST.GL0 }] [get_pins { DMMainPorts_1.Uart2BitClockDiv.clko_i.Q }]
# create_generated_clock -name uart2txclk -divide_by 2 -source [get_pins { FCCC_C0_0.FCCC_C0_0.CCC_INST.GL0 }] [get_pins { DMMainPorts_1.Uart2TxBitClockDiv.div_i.Q }]
# create_generated_clock -name uart3clk -divide_by 2 -source [get_pins { FCCC_C0_0.FCCC_C0_0.CCC_INST.GL0 }] [get_pins { DMMainPorts_1.Uart3BitClockDiv.clko_i.Q }]
# create_generated_clock -name uart3txclk -divide_by 2 -source [get_pins { FCCC_C0_0.FCCC_C0_0.CCC_INST.GL0 }] [get_pins { DMMainPorts_1.Uart3TxBitClockDiv.div_i.Q }]
# set_false_path -through [get_nets { EvalSandbox_MSS_0.CORERESETP_0.ddr_settled EvalSandbox_MSS_0.CORERESETP_0.count_ddr_enable EvalSandbox_MSS_0.CORERESETP_0.release_sdif*_core EvalSandbox_MSS_0.CORERESETP_0.count_sdif*_enable }]
# set_false_path -from [get_cells { EvalSandbox_MSS_0.CORERESETP_0.MSS_HPMS_READY_int }] -to [get_cells { EvalSandbox_MSS_0.CORERESETP_0.sm0_areset_n_rcosc EvalSandbox_MSS_0.CORERESETP_0.sm0_areset_n_rcosc_q1 }]
# set_false_path -from [get_cells { EvalSandbox_MSS_0.CORERESETP_0.MSS_HPMS_READY_int EvalSandbox_MSS_0.CORERESETP_0.SDIF*_PERST_N_re }] -to [get_cells { EvalSandbox_MSS_0.CORERESETP_0.sdif*_areset_n_rcosc* }]
# set_false_path -through [get_nets { EvalSandbox_MSS_0.CORERESETP_0.CONFIG1_DONE EvalSandbox_MSS_0.CORERESETP_0.CONFIG2_DONE EvalSandbox_MSS_0.CORERESETP_0.SDIF*_PERST_N EvalSandbox_MSS_0.CORERESETP_0.SDIF*_PSEL EvalSandbox_MSS_0.CORERESETP_0.SDIF*_PWRITE EvalSandbox_MSS_0.CORERESETP_0.SDIF*_PRDATA[*] EvalSandbox_MSS_0.CORERESETP_0.SOFT_EXT_RESET_OUT EvalSandbox_MSS_0.CORERESETP_0.SOFT_RESET_F2M EvalSandbox_MSS_0.CORERESETP_0.SOFT_M3_RESET EvalSandbox_MSS_0.CORERESETP_0.SOFT_MDDR_DDR_AXI_S_CORE_RESET EvalSandbox_MSS_0.CORERESETP_0.SOFT_FDDR_CORE_RESET EvalSandbox_MSS_0.CORERESETP_0.SOFT_SDIF*_PHY_RESET EvalSandbox_MSS_0.CORERESETP_0.SOFT_SDIF*_CORE_RESET EvalSandbox_MSS_0.CORERESETP_0.SOFT_SDIF0_0_CORE_RESET EvalSandbox_MSS_0.CORERESETP_0.SOFT_SDIF0_1_CORE_RESET }]
# set_false_path -through [get_pins { EvalSandbox_MSS_0.EvalSandbox_MSS_MSS_0.MSS_ADLIB_INST.CONFIG_PRESET_N }]
# set_false_path -through [get_pins { EvalSandbox_MSS_0.SYSRESET_POR.POWER_ON_RESET_N }]


# Non-forward-annotatable constraints (intentionally commented out) 

# Block Path constraints 


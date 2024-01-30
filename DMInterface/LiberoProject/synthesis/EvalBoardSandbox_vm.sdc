# Written by Synplify Pro version map202209actsp2, Build 145R. Synopsys Run ID: sid1706555277 
# Top Level Design Parameters 

# Clocks 
create_clock -period 40.000 -waveform {0.000 20.000} -name {EvalSandbox_MSS_0/EvalSandbox_MSS_MSS_0/CLK_CONFIG_APB} [get_pins {EvalSandbox_MSS_0/EvalSandbox_MSS_MSS_0/MSS_ADLIB_INST/CLK_CONFIG_APB}] 
create_clock -period 20.000 -waveform {0.000 10.000} -name {EvalSandbox_MSS_0/FABOSC_0/I_RCOSC_25_50MHZ/CLKOUT} [get_pins {EvalSandbox_MSS_0/FABOSC_0/I_RCOSC_25_50MHZ/CLKOUT}] 

# Virtual Clocks 

# Generated Clocks 
create_generated_clock -name {EvalSandbox_MSS_0/CCC_0/GL0} -multiply_by {4} -divide_by {2} -source [get_pins {EvalSandbox_MSS_0/CCC_0/CCC_INST/RCOSC_25_50MHZ}]  [get_pins {EvalSandbox_MSS_0/CCC_0/CCC_INST/GL0}] 

# Paths Between Clocks 

# Multicycle Constraints 

# Point-to-point Delay Constraints 

# False Path Constraints 
set_false_path -through [get_pins {EvalSandbox_MSS_0/SYSRESET_POR/POWER_ON_RESET_N}] 
set_false_path -through [get_pins {EvalSandbox_MSS_0/CORERESETP_0/INIT_DONE_int/Q}] 
set_false_path -through [get_pins {EvalSandbox_MSS_0/CORECONFIGP_0/soft_reset_reg[1]/Q EvalSandbox_MSS_0/CORECONFIGP_0/soft_reset_reg[2]/Q EvalSandbox_MSS_0/CORECONFIGP_0/control_reg_1[1]/Q EvalSandbox_MSS_0/CORECONFIGP_0/control_reg_1[0]/Q}] 
set_false_path -through [get_pins {EvalSandbox_MSS_0/CORERESETP_0/release_sdif3_core/Q EvalSandbox_MSS_0/CORERESETP_0/release_sdif2_core/Q EvalSandbox_MSS_0/CORERESETP_0/release_sdif1_core/Q EvalSandbox_MSS_0/CORERESETP_0/release_sdif0_core/Q EvalSandbox_MSS_0/CORERESETP_0/ddr_settled/Q EvalSandbox_MSS_0/CORERESETP_0/count_ddr_enable/Q}] 
set_false_path -from [get_cells {EvalSandbox_MSS_0/CORERESETP_0/MSS_HPMS_READY_int_rep EvalSandbox_MSS_0/CORERESETP_0/MSS_HPMS_READY_int}] -to [get_cells {EvalSandbox_MSS_0/CORERESETP_0/sm0_areset_n_rcosc_q1 EvalSandbox_MSS_0/CORERESETP_0/sm0_areset_n_rcosc}] 
set_false_path -from [get_cells {EvalSandbox_MSS_0/CORERESETP_0/MSS_HPMS_READY_int_rep EvalSandbox_MSS_0/CORERESETP_0/MSS_HPMS_READY_int}] -to [get_cells {EvalSandbox_MSS_0/CORERESETP_0/sdif3_areset_n_rcosc_q1 EvalSandbox_MSS_0/CORERESETP_0/sdif3_areset_n_rcosc EvalSandbox_MSS_0/CORERESETP_0/sdif2_areset_n_rcosc_q1 EvalSandbox_MSS_0/CORERESETP_0/sdif2_areset_n_rcosc EvalSandbox_MSS_0/CORERESETP_0/sdif1_areset_n_rcosc_q1 EvalSandbox_MSS_0/CORERESETP_0/sdif1_areset_n_rcosc EvalSandbox_MSS_0/CORERESETP_0/sdif0_areset_n_rcosc_q1 EvalSandbox_MSS_0/CORERESETP_0/sdif0_areset_n_rcosc}] 

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
# set_false_path -through [get_pins { EvalSandbox_MSS_0.EvalSandbox_MSS_MSS_0.MSS_ADLIB_INST.CONFIG_PRESET_N }]
# set_min_delay -24 -through [get_nets { EvalSandbox_MSS_0.CORECONFIGP_0.FIC_2_APB_M_PWRITE EvalSandbox_MSS_0.CORECONFIGP_0.FIC_2_APB_M_PADDR[*] EvalSandbox_MSS_0.CORECONFIGP_0.FIC_2_APB_M_PWDATA[*] EvalSandbox_MSS_0.CORECONFIGP_0.FIC_2_APB_M_PSEL EvalSandbox_MSS_0.CORECONFIGP_0.FIC_2_APB_M_PENABLE }]
# set_min_delay 0 -through [get_nets { EvalSandbox_MSS_0.CORECONFIGP_0.FIC_2_APB_M_PSEL EvalSandbox_MSS_0.CORECONFIGP_0.FIC_2_APB_M_PENABLE }] -to [get_cells { EvalSandbox_MSS_0.CORECONFIGP_0.FIC_2_APB_M_PREADY* EvalSandbox_MSS_0.CORECONFIGP_0.state[0] }]


# Non-forward-annotatable constraints (intentionally commented out) 

# Block Path constraints 


# Written by Synplify Pro version map202209actsp2, Build 145R. Synopsys Run ID: sid1726685836 
# Top Level Design Parameters 

# Clocks 
create_clock -period 10.000 -waveform {0.000 5.000} -name {FCCC_C0_FCCC_C0_0_FCCC|GL1_net_inferred_clock} [get_pins {FCCC_C0_0/FCCC_C0_0/CCC_INST/GL1}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {ClockDividerPorts_work_main_architecture_main_0layer1_0|div_i_inferred_clock} [get_pins {Main_0/UartGpsTxBitClockDiv/div_i/Q}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {ClockDividerPorts_work_main_architecture_main_2layer1|div_i_inferred_clock} [get_pins {Main_0/UartGpsRxBitClockDiv/div_i/Q}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {ClockDividerPorts_work_main_architecture_main_0layer1_1|div_i_inferred_clock} [get_pins {Main_0/UartUsbTxBitClockDiv/div_i/Q}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {ClockDividerPorts_work_main_architecture_main_1layer1|div_i_inferred_clock} [get_pins {Main_0/UartUsbRxBitClockDiv/div_i/Q}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {ClockDividerPorts_work_main_architecture_main_0layer1_2|div_i_inferred_clock} [get_pins {Main_0/Uart3TxBitClockDiv/div_i/Q}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {VariableClockDividerPorts_work_main_architecture_main_0layer1_0|clko_i_inferred_clock} [get_pins {Main_0/Uart3BitClockDiv/clko_i/Q}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {ClockDividerPorts_work_main_architecture_main_0layer1_3|div_i_inferred_clock} [get_pins {Main_0/Uart2TxBitClockDiv/div_i/Q}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {VariableClockDividerPorts_work_main_architecture_main_0layer1_1|clko_i_inferred_clock} [get_pins {Main_0/Uart2BitClockDiv/clko_i/Q}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {ClockDividerPorts_work_main_architecture_main_0layer1_4|div_i_inferred_clock} [get_pins {Main_0/Uart1TxBitClockDiv/div_i/Q}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {VariableClockDividerPorts_work_main_architecture_main_0layer1_2|clko_i_inferred_clock} [get_pins {Main_0/Uart1BitClockDiv/clko_i/Q}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {ClockDividerPorts_work_main_architecture_main_0layer1_5|div_i_inferred_clock} [get_pins {Main_0/Uart0TxBitClockDiv/div_i/Q}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {VariableClockDividerPorts_work_main_architecture_main_0layer1_3|clko_i_inferred_clock} [get_pins {Main_0/Uart0BitClockDiv/clko_i/Q}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {Filterwheel_sb_CCC_0_FCCC|GL0_net_inferred_clock} [get_pins {Filterwheel_sb_0/CCC_0/CCC_INST/GL0}] 

# Virtual Clocks 

# Generated Clocks 

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
set Inferred_clkgroup_0 [list FCCC_C0_FCCC_C0_0_FCCC|GL1_net_inferred_clock]
set Inferred_clkgroup_1 [list ClockDividerPorts_work_main_architecture_main_0layer1_0|div_i_inferred_clock]
set Inferred_clkgroup_2 [list ClockDividerPorts_work_main_architecture_main_2layer1|div_i_inferred_clock]
set Inferred_clkgroup_3 [list ClockDividerPorts_work_main_architecture_main_0layer1_1|div_i_inferred_clock]
set Inferred_clkgroup_4 [list ClockDividerPorts_work_main_architecture_main_1layer1|div_i_inferred_clock]
set Inferred_clkgroup_5 [list ClockDividerPorts_work_main_architecture_main_0layer1_2|div_i_inferred_clock]
set Inferred_clkgroup_6 [list VariableClockDividerPorts_work_main_architecture_main_0layer1_0|clko_i_inferred_clock]
set Inferred_clkgroup_7 [list ClockDividerPorts_work_main_architecture_main_0layer1_3|div_i_inferred_clock]
set Inferred_clkgroup_8 [list VariableClockDividerPorts_work_main_architecture_main_0layer1_1|clko_i_inferred_clock]
set Inferred_clkgroup_9 [list ClockDividerPorts_work_main_architecture_main_0layer1_4|div_i_inferred_clock]
set Inferred_clkgroup_10 [list VariableClockDividerPorts_work_main_architecture_main_0layer1_2|clko_i_inferred_clock]
set Inferred_clkgroup_11 [list ClockDividerPorts_work_main_architecture_main_0layer1_5|div_i_inferred_clock]
set Inferred_clkgroup_12 [list VariableClockDividerPorts_work_main_architecture_main_0layer1_3|clko_i_inferred_clock]
set Inferred_clkgroup_13 [list Filterwheel_sb_CCC_0_FCCC|GL0_net_inferred_clock]
set_clock_groups -asynchronous -group $Inferred_clkgroup_0
set_clock_groups -asynchronous -group $Inferred_clkgroup_1
set_clock_groups -asynchronous -group $Inferred_clkgroup_2
set_clock_groups -asynchronous -group $Inferred_clkgroup_3
set_clock_groups -asynchronous -group $Inferred_clkgroup_4
set_clock_groups -asynchronous -group $Inferred_clkgroup_5
set_clock_groups -asynchronous -group $Inferred_clkgroup_6
set_clock_groups -asynchronous -group $Inferred_clkgroup_7
set_clock_groups -asynchronous -group $Inferred_clkgroup_8
set_clock_groups -asynchronous -group $Inferred_clkgroup_9
set_clock_groups -asynchronous -group $Inferred_clkgroup_10
set_clock_groups -asynchronous -group $Inferred_clkgroup_11
set_clock_groups -asynchronous -group $Inferred_clkgroup_12
set_clock_groups -asynchronous -group $Inferred_clkgroup_13

set_clock_groups -asynchronous -group [get_clocks {FCCC_C0_FCCC_C0_0_FCCC|GL1_net_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {ClockDividerPorts_work_main_architecture_main_0layer1_0|div_i_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {ClockDividerPorts_work_main_architecture_main_2layer1|div_i_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {ClockDividerPorts_work_main_architecture_main_0layer1_1|div_i_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {ClockDividerPorts_work_main_architecture_main_1layer1|div_i_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {ClockDividerPorts_work_main_architecture_main_0layer1_2|div_i_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {VariableClockDividerPorts_work_main_architecture_main_0layer1_0|clko_i_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {ClockDividerPorts_work_main_architecture_main_0layer1_3|div_i_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {VariableClockDividerPorts_work_main_architecture_main_0layer1_1|clko_i_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {ClockDividerPorts_work_main_architecture_main_0layer1_4|div_i_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {VariableClockDividerPorts_work_main_architecture_main_0layer1_2|clko_i_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {ClockDividerPorts_work_main_architecture_main_0layer1_5|div_i_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {VariableClockDividerPorts_work_main_architecture_main_0layer1_3|clko_i_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {Filterwheel_sb_CCC_0_FCCC|GL0_net_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {Filterwheel_sb_FABOSC_0_OSC|N_RCOSC_25_50MHZ_CLKOUT_inferred_clock}]

# syn_mode Attributes 

# Cells 

# Port DRC Rules 

# Input Transition Constraints 

# Unused constraints (intentionally commented out) 


# Non-forward-annotatable constraints (intentionally commented out) 

# Block Path constraints 


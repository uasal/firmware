#
# Design Timing Constraints Definitions
#

#set_time_format -unit ns -decimal_places 3

##############################################################################
# Create Input reference clocks
#create_clock -name { VCXO } -period 59.605 -waveform { 0.000 29.802 } [get_ports { CGraphPZTPorts }]
#create_clock -period 59.605 -waveform { 0.000 29.802 } [get_ports VCXO] #16MHz
#create_clock -period 20.345 -waveform { 0.000 10.173 } [get_ports VCXO] #49MHz
#create_clock -name { VCXO } -period 20.345 -waveform { 0.000 10.173 } [get_ports { CGraphPZTPorts }]

##############################################################################
# Now that we have created the custom clocks which will be base clocks,
# derive_pll_clock is used to calculate all remaining clocks for PLLs
#derive_pll_clocks -create_base_clocks
#derive_clock_uncertainty

#create_clock -period 10.0  MasterClk
create_clock -period 20.0  VCXO
#96 - 128 - 144 MHz
#create_clock -period 10.4  pll0O #96MHz
#create_clock -period 7.81  pll0O #128MHz
create_clock -period 6.94  pll0O

#set_output_delay -clock clk 5 [ all_outputs ]
#set_input_delay -clock clk 5 [ all_inputs ]

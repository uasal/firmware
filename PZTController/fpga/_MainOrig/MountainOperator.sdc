#
# Design Timing Constraints Definitions
#

set_time_format -unit ns -decimal_places 3

##############################################################################
# Create Input reference clocks
#create_clock -name { VCXO } -period 59.605 -waveform { 0.000 29.802 } [get_ports { MountainOperatorPorts }]
create_clock -period 59.605 -waveform { 0.000 29.802 } [get_ports VCXO]

##############################################################################
# Now that we have created the custom clocks which will be base clocks,
# derive_pll_clock is used to calculate all remaining clocks for PLLs
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
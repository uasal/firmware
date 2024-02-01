set_component EvalSandbox_MSS_MSS
# Microsemi Corp.
# Date: 2024-Jan-31 15:56:25
#

create_clock -period 40 [ get_pins { MSS_ADLIB_INST/CLK_CONFIG_APB } ]
set_false_path -ignore_errors -through [ get_pins { MSS_ADLIB_INST/CONFIG_PRESET_N } ]

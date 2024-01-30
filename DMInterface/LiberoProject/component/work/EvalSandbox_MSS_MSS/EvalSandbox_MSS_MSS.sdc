set_component EvalSandbox_MSS_MSS
# Microsemi Corp.
# Date: 2024-Jan-29 10:17:12
#

create_clock -period 40 [ get_pins { MSS_ADLIB_INST/CLK_CONFIG_APB } ]
set_false_path -ignore_errors -through [ get_pins { MSS_ADLIB_INST/CONFIG_PRESET_N } ]

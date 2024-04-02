set_component EvalSandbox_MSS_MSS
# Microsemi Corp.
# Date: 2024-Mar-29 14:02:35
#

create_clock -period 39.2157 [ get_pins { MSS_ADLIB_INST/CLK_CONFIG_APB } ]
set_false_path -ignore_errors -through [ get_pins { MSS_ADLIB_INST/CONFIG_PRESET_N } ]

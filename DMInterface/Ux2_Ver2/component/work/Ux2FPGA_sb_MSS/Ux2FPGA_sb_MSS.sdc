set_component Ux2FPGA_sb_MSS
# Microsemi Corp.
# Date: 2025-Apr-11 11:05:04
#

create_clock -period 39.2157 [ get_pins { MSS_ADLIB_INST/CLK_CONFIG_APB } ]
set_false_path -ignore_errors -through [ get_pins { MSS_ADLIB_INST/CONFIG_PRESET_N } ]

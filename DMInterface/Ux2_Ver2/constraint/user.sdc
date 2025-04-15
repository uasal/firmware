create_generated_clock -name uart3clk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { DMMainPorts_0/Uart3BitClockDiv/clko_i/Q } ]
create_generated_clock -name uart3txclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { DMMainPorts_0/Uart3TxBitClockDiv/div_i/Q } ]

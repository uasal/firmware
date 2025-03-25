create_generated_clock -name uart0clk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { DMMainPorts_1/Uart0BitClockDiv/clko_i/Q } ]
create_generated_clock -name uart0txclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { DMMainPorts_1/Uart0TxBitClockDiv/div_i/Q } ]

create_generated_clock -name uart1clk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { DMMainPorts_1/Uart1BitClockDiv/clko_i/Q } ]
create_generated_clock -name uart1txclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { DMMainPorts_1/Uart1TxBitClockDiv/div_i/Q } ]

create_generated_clock -name uart2clk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { DMMainPorts_1/Uart2BitClockDiv/clko_i/Q } ]
create_generated_clock -name uart2txclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { DMMainPorts_1/Uart2TxBitClockDiv/div_i/Q } ]

create_generated_clock -name uart3clk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { DMMainPorts_1/Uart3BitClockDiv/clko_i/Q } ]
create_generated_clock -name uart3txclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { DMMainPorts_1/Uart3TxBitClockDiv/div_i/Q } ]

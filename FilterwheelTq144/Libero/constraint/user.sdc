create_generated_clock -name uart0clk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/Uart0BitClockDiv/clko_i/Q } ]
create_generated_clock -name uart0txclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/Uart0TxBitClockDiv/div_i/Q } ]

create_generated_clock -name uart1clk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/Uart1BitClockDiv/clko_i/Q } ]
create_generated_clock -name uart1txclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/Uart1TxBitClockDiv/div_i/Q } ]

create_generated_clock -name uart2clk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/Uart2BitClockDiv/clko_i/Q } ]
create_generated_clock -name uart2txclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/Uart2TxBitClockDiv/div_i/Q } ]

create_generated_clock -name uart3clk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/Uart3BitClockDiv/clko_i/Q } ]
create_generated_clock -name uart3txclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/Uart3TxBitClockDiv/div_i/Q } ]

#create_generated_clock -name uartgpsclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/UartGpsBitClockDiv/clko_i/Q } ]
#create_generated_clock -name uartgpstxclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/UartGpsTxBitClockDiv/div_i/Q } ]

#create_generated_clock -name uartusbclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/UartUsbBitClockDiv/clko_i/Q } ]
#create_generated_clock -name uartusbtxclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/UartUsbTxBitClockDiv/div_i/Q } ]

#create_generated_clock -name uart0clk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/Uart0BitClockDiv/clko_i_inferred_clock_RNIKQ1F } ]
#create_generated_clock -name uart0txclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/Uart0TxBitClockDiv/div_i_inferred_clock_RNIQ2FB } ]

#create_generated_clock -name uart1clk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/Uart1BitClockDiv/clko_i/Q } ]
#create_generated_clock -name uart1txclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/Uart1TxBitClockDiv/div_i/Q } ]

#create_generated_clock -name uart2clk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/Uart2BitClockDiv/clko_i/Q } ]
#create_generated_clock -name uart2txclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/Uart2TxBitClockDiv/div_i/Q } ]

#create_generated_clock -name uart3clk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/Uart3BitClockDiv/clko_i/Q } ]
#create_generated_clock -name uart3txclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/Uart3TxBitClockDiv/div_i/Q } ]

#create_generated_clock -name uartgpsclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/UartGpsBitClockDiv/clko_i/Q } ]
#create_generated_clock -name uartgpstxclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/UartGpsTxBitClockDiv/div_i/Q } ]

#create_generated_clock -name uartusbclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/UartUsbBitClockDiv/clko_i/Q } ]
#create_generated_clock -name uartusbtxclk -multiply_by 1 -divide_by 2 -source [ get_pins { FCCC_C0_0/FCCC_C0_0/CCC_INST/GL0 } ] [ get_pins { Main_0/UartUsbTxBitClockDiv/div_i/Q } ]

#    31     0      0      'Main_0/Uart0BitClockDiv/clko_i_inferred_clock_RNIKQ1F'
#    31     0      0      'Main_0/Uart1BitClockDiv/clko_i_inferred_clock_RNILRIF'
#    31     0      0      'Main_0/Uart2BitClockDiv/clko_i_inferred_clock_RNIMS3'
#    31     0      0      'Main_0/Uart3BitClockDiv/clko_i_inferred_clock_RNINTK'
#    31     0      0      'Main_0/UartGpsRxBitClockDiv/div_i_inferred_clock_RNIIMVC'
#    31     0      0      'Main_0/UartUsbRxBitClockDiv/div_i_inferred_clock_RNIILC9'
#    9      0      0      'Main_0/Uart0TxBitClockDiv/div_i_inferred_clock_RNIQ2FB'
#    9      0      0      'Main_0/Uart1TxBitClockDiv/div_i_inferred_clock_RNIR41D'
#    9      0      0      'Main_0/Uart2TxBitClockDiv/div_i_inferred_clock_RNIS6JE'
#    9      0      0      'Main_0/Uart3TxBitClockDiv/div_i_inferred_clock_RNIT85'
#    9      0      0      'Main_0/UartGpsTxBitClockDiv/div_i_inferred_clock_RNIKO1E'
#    9      0      0      'Main_0/UartUsbTxBitClockDiv/div_i_inferred_clock_RNIKNEA'
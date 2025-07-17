//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
//

#pragma once

#include "uart/uart_pinout_fpga.hpp"

#include "uart/TerminalUart.hpp"

#include "uart/BinaryUart.hpp"
#include "eeprom/CircularFifoFlattened.hpp"
#include "uart/BinaryUartRingBuffer.hpp"

extern uart_pinout_fpga FPGAUartPinout0;
extern uart_pinout_fpga FPGAUartPinout1;
extern uart_pinout_fpga FPGAUartPinout2;
extern uart_pinout_fpga FPGAUartPinout3;
//~ extern uart_pinout_fpga FPGAUartPinoutUsb;

extern BinaryUart FpgaUartParser3;
extern BinaryUart FpgaUartParser2;
extern BinaryUart FpgaUartParser1;
extern BinaryUartRingBuffer FpgaUartParser0;

//~ (ascii instead) extern BinaryUart FpgaUartParser0;
//~ (ascii instead) extern BinaryUart FpgaUartParserUsb;
//~ extern TerminalUart<16, 4096> DbgUartUsb;
extern TerminalUart<16, 4096> DbgUart485_0;

void ProcessAllUarts();


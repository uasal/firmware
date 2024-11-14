//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
//

#pragma once

#include "uart/IUartParser.hpp"

#include "uart/BinaryUart.hpp"

#include "uart/TerminalUart.hpp"

extern IUartParser* const UartParsers[];
extern const uint8_t NumUartParsers;

extern BinaryUart* const BinaryUartParsers[];
extern const uint8_t NumBinaryUartParsers;

extern TerminalUart<16, 4096>* const AsciiUartParsers[];
extern const uint8_t NumAsciiUartParsers;

//EOF
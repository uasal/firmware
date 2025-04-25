//
///           Copyright (c) by Franks Development, LLC
//
// This software is copyrighted by and is the sole property of Franks
// Development, LLC. All rights, title, ownership, or other interests
// in the software remain the property of Franks Development, LLC. This
// software may only be used in accordance with the corresponding
// license agreement.  Any unauthorized use, duplication, transmission,
// distribution, or disclosure of this software is expressly forbidden.
//
// This Copyright notice may not be removed or modified without prior
// written consent of Franks Development, LLC.
//
// Franks Development, LLC. reserves the right to modify this software
// without notice.
//
// Franks Development, LLC            support@franks-development.com
// 500 N. Bahamas Dr. #101           http://www.franks-development.com
// Tucson, AZ 85710
// USA
//

#include <stdint.h>

//#include "dbg/memwatch.h"

#include "uart/CmdSystem.hpp"

//Hardware Cmds
int8_t BinaryVersionCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t BinaryDMDacCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t BinaryDMStartSMCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument);
//int8_t BinaryDMVectorCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t BinaryDMAdcsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t BinaryDMAdcsFloatingPointCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t BinaryDMDacsFloatingPointCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t BinaryDMTelemetryCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t BinaryDMDacConfigCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument);
//int8_t BinaryDMUartCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t BinaryDMMappingCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t BinaryDMShortPixelsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t BinaryDMDitherCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t BinaryDMLongPixelsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument);


///The actual table (array) of commands for the system - links with CmdSystem.cpp.o
extern const BinaryCmd BinaryCmds[];
extern const uint8_t NumBinaryCmds;

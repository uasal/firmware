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
/// \file
/// $Source: /raincloud/src/clients/UACGraph/Zeus/Zeus3/firmware/arm/main/CmdTable.hpp,v $
/// $Revision: 1.27 $
/// $Date: 2010/06/08 23:54:01 $
/// $Author: summer $

#include <stdint.h>

#include "uart/CmdSystem.hpp"

//Hardware Cmds
int8_t ExitCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t VersionCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t GlobalSaveCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t GlobalRestoreCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t ParseConfigFileCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t HelpCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t InitFpgaCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t DeInitFpgaCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t ReadFpgaCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t WriteFpgaCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t PZTDacsCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t PZTAdcsCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t BISTCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t CirclesCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t GoXYCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t UartCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t BaudDividersCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t PrintBuffersCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);

///The actual table (array) of commands for the system - links with CmdSystem.cpp.o
extern const Cmd AsciiCmds[];
extern const uint8_t NumAsciiCmds;

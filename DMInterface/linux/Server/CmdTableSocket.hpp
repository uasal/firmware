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
/// $Source: /raincloud/src/clients/zonge/Zeus/Zeus3/firmware/arm/main/CmdTable.hpp,v $
/// $Revision: 1.27 $
/// $Date: 2010/06/08 23:54:01 $
/// $Author: steve $

#include <stdint.h>

#include "uart/CmdSystem.hpp"

//General Info commands
int8_t VersionCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
//Buffering commands
int8_t FlushDataToZenCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t FlushDataFromZenCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t BytesWaitingToZenCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t BytesWaitingFromZenCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
//Channel Table commands
int8_t ChannelTableClearCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t ChannelTableLenCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t ChannelTableEntryCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t ChannelTableDeleteCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
int8_t ChannelTableFindCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);
//Management
int8_t Mount457sCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);

///The actual table (array) of commands for the system - links with CmdSystem.cpp.o
extern const Cmd SocketCmds[];
extern const uint8_t NumSocketCmds;

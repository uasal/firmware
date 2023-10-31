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

#include "schedule/CmdHandlersSchedule.hpp"

#include "Brd355CalAtten.hpp"

#include "CmdTableSocket.hpp"

///The actual table (array) of commands for the system - links with CmdSystem.cpp.o

const Cmd SocketCmds[] = 
{
	Cmd (
		"\x3A\x29\x22\x2C",
		"Version: return build number of server, etc.",
		VersionCommand
    ),
	
	//Buffering commands
	
	Cmd (
		"\x3A\x29\xB1\xC1",
		"FlushDataToZen: Empty server's buffers of packets from client to send to zen.",
		FlushDataToZenCommand
    ),
	
	Cmd (
		"\x3A\x29\xB2\xC1",
		"FlushDataFromZen: Empty server's buffers of packets from zen to send to client.",
		FlushDataFromZenCommand
    ),

	Cmd (
		"\x3A\x29\xB3\xC1",
		"BytesWaitingToZen: Size of ready bytes in buffers of packets from client to send to zen.",
		BytesWaitingToZenCommand
    ),
	
	Cmd (
		"\x3A\x29\xB4\xC1",
		"BytesWaitingFromZen: Size of ready bytes in buffers of packets from zen to send to client.",
		BytesWaitingFromZenCommand
    ),
	
	Cmd(
    	"\x3A\x29\x72\xC1",
		"\"Mount457s\": Mounts attached Zen box to local server filesystem!",
		Mount457sCommand
    ),
};

//Calculate the number of commands instanciated in the system - links with CmdSystem.cpp.o
const uint8_t NumSocketCmds = sizeof(SocketCmds) / sizeof(SocketCmds[0]);

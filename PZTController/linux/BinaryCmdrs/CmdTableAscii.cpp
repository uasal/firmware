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

#include "../MonitorAdc.hpp"

#include "CmdTableAscii.hpp"

///The actual table (array) of commands for the system - links with CmdSystem.cpp.o
const Cmd AsciiCmds[] =
{
    Cmd (
        "X",
        "X: quit running this program.",
        ExitCommand
    ),
    Cmd (
        "Q",
        "Q: exit this running program.",
        ExitCommand
    ),
	
	Cmd(
        "VERSION",
		"\"Version\": Shows hardware and firmware version info.",
		VersionCommand
    ),
	
	//~ Cmd (
        //~ "READFPGA",
        //~ "ReadFpga <address>",
        //~ ReadFpgaCommand
    //~ ),

	//~ Cmd (
        //~ "WRITEFPGA",
        //~ "WriteFpga <address>,<value>",
        //~ WriteFpgaCommand
    //~ ),
	
	//~ Cmd (
        //~ "R",
        //~ "(R)ReadFpga <address>",
        //~ ReadFpgaCommand
    //~ ),

	//~ Cmd (
        //~ "W",
        //~ "(W)WriteFpga <address>,<value>",
        //~ WriteFpgaCommand
    //~ ),

    Cmd(
        "PZTDACS",
        "\"PZTDacs <A>,<B>,<C>\": Sets/queries the PZT D/A's.",
        PZTDacsCommand
    ),
	
	Cmd(
        "D",
        "\"(D)PZTDacs <A>,<B>,<C>\": Sets/queries the PZT D/A's.",
        PZTDacsCommand
    ),
	
	Cmd(
        "PZTADCS",
        "\"PZTAdcs <A>,<B>,<C>\": Sets/queries the PZT A/D's.",
        PZTAdcsCommand
    ),
	
	Cmd(
        "A",
        "\"(A)PZTAdcs <A>,<B>,<C>\": Sets/queries the PZT A/D's.",
        PZTAdcsCommand
    ),
	
	//~ Cmd(
        //~ "BIST",
        //~ "\"BIST\": Runs a self-test, logs values to terminal.",
        //~ BISTCommand
    //~ ),
};

//Calculate the number of commands instanciated in the system - links with CmdSystem.cpp.o
const uint8_t NumAsciiCmds = sizeof(AsciiCmds) / sizeof(AsciiCmds[0]);

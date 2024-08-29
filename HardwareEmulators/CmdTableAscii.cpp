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

#include "CmdTableAscii.hpp"

///The actual table (array) of commands for the system - links with CmdSystem.cpp.o
const Cmd AsciiCmds[] =
{
	//App Commands (housekeeping)
	
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
	
    Cmd (
        "HELP",
        "Help: Help with commands.",
        HelpCommand
    ),
	
	//General Commands

	Cmd(
        "VERSION",
		"\"Version\": Shows hardware and firmware version info.",
		VersionCommand
    ),
	
	//~ //FSM Commands
	
	//~ Cmd(
        //~ "FSMDACS",
        //~ "\"FSMDacs <A>,<B>,<C>\": Sets/queries the FSM D/A's.",
        //~ FSMDacsCommand
    //~ ),
	
	//~ Cmd(
        //~ "FSMD",
        //~ "\"(FSMD)FSMDacs <A>,<B>,<C>\": Sets/queries the FSM D/A's.",
        //~ FSMDacsCommand
    //~ ),
	
	//~ Cmd(
        //~ "FSMADCS",
        //~ "\"FSMAdcs <A>,<B>,<C>\": Sets/queries the FSM A/D's.",
        //~ FSMAdcsCommand
    //~ ),
	
	//~ Cmd(
        //~ "FSMA",
        //~ "\"(FSMA)FSMAdcs <A>,<B>,<C>\": Sets/queries the FSM A/D's.",
        //~ FSMAdcsCommand
    //~ ),
	
	//~ Cmd(
        //~ "FSMTELEMETRY",
        //~ "\"FSMTelemetry\": Get monitor A/D values.",
        //~ FSMTelemetryCommand
    //~ ),
	
	//~ //DM Commands
	
	//~ Cmd(
        //~ "DMDAC",
        //~ "\"DMDacCommand\": ",
        //~ DMDacCommand
    //~ ),
	
	//~ Cmd(
        //~ "DMTELEMETRY",
        //~ "\"DMTelemetry\": Queries the telemetry values.",
        //~ DMTelemetryCommand
    //~ ),

    //~ Cmd(
        //~ "DMHVSWITCH",
        //~ "\"DMHVSwitchCommand\": ",
        //~ DMHVSwitchCommand
    //~ ),

	//~ Cmd(
        //~ "DMCONFIGDACS",
        //~ "\"DMDacConfigCommand\": ",
        //~ DMDacConfigCommand
    //~ ),	
	
	//~ //FilterWheel Commands
	
    //~ Cmd(
        //~ "FWHWCTRLSTAT",
        //~ "\"FWHWCtrlStat\":Queries the H/W Control & Status values.",
        //~ FWHardwareControlStatusCommand
    //~ ),
	
	//~ Cmd(
        //~ "FWMOTORSTATUS",
        //~ "\"FWMotorStatus\": Queries the Motor Status values.",
        //~ FWMotorControlStatusCommand
    //~ ),

    //~ Cmd(
        //~ "FWPOSSENSE",
        //~ "\"FWPosSense\": Queries Position Sense values.",
        //~ FWPositionSenseControlStatusCommand
    //~ ),

	//~ Cmd(
        //~ "FWSENSORSTEPS",
        //~ "\"FWSensorSteps\": Queries the Sensor Step values.",
        //~ FWPositionStepsCommand
    //~ ),
	
	//~ Cmd(
        //~ "FWTELEMETRY",
        //~ "\"FWTelemetry\": Queries the telemetry values.",
        //~ FWTelemetryCommand
    //~ ),
	
	//~ Cmd(
        //~ "FWFILTERSELECT",
        //~ "\"FWFilterSelect <1-8>\": Sets/queries the currently loaded filter; respose of 0 means wheel is in motion/currently seeking a position.",
        //~ FWFilterSelectCommand
    //~ ),
	
	//~ Cmd(
        //~ "FWF",
        //~ "\"(FWF)ilterselect\": Shortcut for previous command",
        //~ FWFilterSelectCommand
    //~ ),
};

//Calculate the number of commands instanciated in the system - links with CmdSystem.cpp.o
const uint8_t NumAsciiCmds = sizeof(AsciiCmds) / sizeof(AsciiCmds[0]);

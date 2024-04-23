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
    //~ Cmd (
        //~ "X",
        //~ "X: quit running this program.",
        //~ ExitCommand
    //~ ),
    //~ Cmd (
        //~ "Q",
        //~ "Q: exit this running program.",
        //~ ExitCommand
    //~ ),
	
	Cmd(
        "VERSION",
		"\"Version\": Shows hardware and firmware version info.",
		VersionCommand
    ),
	
	Cmd(
		"GLOBALSAVE",
		"\"GlobalSave\": Save all operating parameters/configuration to eeprom so it will be restored on reboot / power cycle.",
		GlobalSaveCommand
	),
	
	Cmd(
		"GLOBALRESTORE",
		"\"GlobalRestore\": Restore all operating parameters/configuration from eeprom in order to erase any operating changes made since last restore (i.e. at bootup).",
		GlobalRestoreCommand
	),

	Cmd(
		"PARSECONFIGFILE",
		"\"ParseConfigFile <filename>\": Opens the given file and treats each line therein as a command.",
		ParseConfigFileCommand
	),
		
    Cmd (
        "INITFPGA",
        "InitFpga : Connect to FPGA interface.",
        InitFpgaCommand
    ),
    
	Cmd (
        "DEINITFPGA",
        "DeInitFpga : Disconnect from FPGA interface.",
        DeInitFpgaCommand
    ),
    
	Cmd (
        "READFPGA",
        "ReadFpga <address>",
        ReadFpgaCommand
    ),

	Cmd (
        "WRITEFPGA",
        "WriteFpga <address>,<value>",
        WriteFpgaCommand
    ),
	
	Cmd (
        "R",
        "R(eadFpga) <address>",
        ReadFpgaCommand
    ),

	Cmd (
        "W",
        "W(riteFpga) <address>,<value>",
        WriteFpgaCommand
    ),

    Cmd(
        "FWSTATUS",
        "\"FWStatus <A>,<B>,<C>\": Sets/queries the FW D/A's (hexadecimal lsb units).",
        FWStatusCommand
    ),
	
	Cmd(
        "SENSORSTEPS",
        "\"SensorSteps <A>,<B>,<C>\": Sets/queries the FW D/A's (decimal voltage units).",
        SensorStepsCommand
    ),
	
	Cmd(
        "MOTOR",
        "\"Motor <A>,<B>,<C>\": Sets/queries the FW A/D's.",
        MotorCommand
    ),
	
	Cmd(
        ScanMonitorAdcCmdString,
        ScanMonitorAdcHelp,
        ScanMonitorAdcCommand
    ),
	
	Cmd(
        "S",
        ScanMonitorAdcHelp,
        ScanMonitorAdcCommand
    ),
	
	Cmd(
        TestMonitorAdcCmdString,
        TestMonitorAdcHelp,
        TestMonitorAdcCommand
    ),
	
	Cmd(
        "T",
        TestMonitorAdcHelp,
        TestMonitorAdcCommand
    ),
	
	Cmd(
        CalibrateMonitorAdcCmdString,
        CalibrateMonitorAdcHelp,
        CalibrateMonitorAdcCommand
    ),
	
	Cmd(
        "BIST",
        "\"BIST\": Runs a self-test, logs values to terminal.",
        BISTCommand
    ),
	
	Cmd(
        "UART",
        "\"Uart\": Twiddle the uart.",
        UartCommand
    ),
	
	Cmd(
        "U",
        "\"U(art)\": Twiddle the uart.",
        UartCommand
    ),
	
	Cmd(
        "BAUDDIVIDERS",
        "\"BaudDividers\": 0,1,2: Set the divider to change the baudrate for each port...",
        BaudDividersCommand
    ),
	
	Cmd(
        "PRINTBUFFERS",
        "\"PrintBuffers\": Dump current contents of parsers for debug...",
        PrintBuffersCommand
    ),
	
	Cmd(
        "MONITORSERIAL",
        "\"MonitorSerial <0 | 1 | 2> <Y | N>\": Show/hide incoming serial bytes.",
        MonitorSerialCommand
    ),
};

//Calculate the number of commands instanciated in the system - links with CmdSystem.cpp.o
const uint8_t NumAsciiCmds = sizeof(AsciiCmds) / sizeof(AsciiCmds[0]);

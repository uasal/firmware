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
/// $Source: /raincloud/src/clients/UACGraph/Zeus/Zeus3/firmware/arm/main/CmdHandlersConfig.cpp,v $
/// $Revision: 1.7 $
/// $Date: 2010/06/08 23:51:10 $
/// $Author: summer $

#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <inttypes.h>
//offsetof:
#include <cstddef>
//kbhit
#include <termios.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <errno.h>
#include <unordered_map>
using namespace std;

#include <mcheck.h>
#include "dbg/memwatch.h"

#include "uart/AsciiCmdUserInterfaceLinux.h"

//~ #include "../MonitorAdc.hpp"
//~ extern CGraphFSMMonitorAdc MonitorAdc;

#include "../UASALHardwareEmulatorSerialBuildNum"

char Buffer[4096];

#include "cgraph/CGraphPacket.hpp"

#include "uart/BinaryUart.hpp"
extern BinaryUart UartParser;

int8_t ExitCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	muntrace();
	
	printf("\n\nExitCommand: Goodbye!\n\n\n\n");
	exit(0);
	
	return(ParamsLen);
}

int8_t HelpCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	bool Found = false;
	const size_t CharBufferLen = 1024;
	char CharBuffer[CharBufferLen];
	char CharBuffer2[CharBufferLen];
	
	//'help' shows everything
	if ( (ParamsLen < 1) || ('\0' == Params[0]) ) 
	{ 
		HelpCmds(AsciiCmds, NumAsciiCmds);
	    return(strlen(Params));
	}
	
	size_t i = 0;
	//help xyz; make 'xyz' lower:
	strncpy(CharBuffer2, &(Params[1]), strnlen(&(Params[1]), CharBufferLen));
	for (i = 0; i < CharBufferLen; i++)
	{
		if ('\0' == CharBuffer2[i]) { break; }
		CharBuffer2[i] = tolower(CharBuffer2[i]);
	}
	CharBuffer2[i] = '\0';

	//'help <blah>' searches
	formatf("\n\nHelp: Searching for all commands containing \"%s\":", CharBuffer2);	
	for (size_t j = 0; j < NumAsciiCmds; j++)
	{
		bool Match = false;
		
		//cmd name
		memset(CharBuffer, 0, CharBufferLen);
		strncpy(CharBuffer, AsciiCmds[j].Name, strnlen(AsciiCmds[j].Name, CharBufferLen));
		for (i = 0; i < CharBufferLen; i++)
		{
			if ('\0' == CharBuffer[i]) { break; }
			CharBuffer[i] = tolower(CharBuffer[i]);
		}
		CharBuffer[i] = '\0';
		if (0 != strstr(CharBuffer, CharBuffer2)) { Match = true; }
		//~ formatf("\n\nHelp: Is it in \"%s\"?", CharBuffer);	
		
		//cmd help
		memset(CharBuffer, 0, CharBufferLen);
		strncpy(CharBuffer, AsciiCmds[j].Help, strnlen(AsciiCmds[j].Help, CharBufferLen));
		for (i = 0; i < CharBufferLen; i++)
		{
			if ('\0' == CharBuffer[i]) { break; }
			CharBuffer[i] = tolower(CharBuffer[i]);
		}
		CharBuffer[i] = '\0';
		if (0 != strstr(CharBuffer, CharBuffer2)) { Match = true; }
		//~ formatf("\n\nHelp: Is it in \"%s\"?", CharBuffer);	
				
		if (Match)
		{
			formatf("\n%s: %s", AsciiCmds[j].Name, AsciiCmds[j].Help);	
			
			Found = true;
		}
	}
	
	if (!Found)
	{
		formatf("\nHelp: No commands found containing \"%s\".\n", &(Params[1]));	
	}

    return(ParamsLen);
}

int8_t VersionCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\n\nVersion: This PearlHardwareEmulator App: Global Revision: %s; build number: %u on: %s.\n", GITVERSION, BuildNum, BuildTimeStr);
	
	CGraphVersionPayload Version;
    Version.SerialNum = 0xDEADB10D;
	Version.ProcessorFirmwareBuildNum = BuildNum;
	Version.FPGAFirmwareBuildNum = 0x0A11D0E5;
    TxBinaryPacket(&UartParser, CGraphPayloadTypeVersion, 0, &Version, sizeof(CGraphVersionPayload));

	return(strlen(Params));
}

int8_t HardFaultCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\n\nHardFault: pretending we just crashed!\n");
	
	CGraphHardFaultPayload Fault;

	Fault.R0 = 0x00000000UL;
	Fault.R1 = 0x00000001UL;
	Fault.R2 = 0x00000002UL;
	Fault.R3 = 0x00000003UL;
	Fault.R12 = 0x00000012UL;
	Fault.LR = 0x00000013UL;
	//~ Fault.PC = __builtin_return_address(0);
	Fault.PC = 0x00000666UL;
	Fault.PSR = (uint64_t)(__builtin_return_address(0));
	Fault.BFAR = 0xE000ED38;
	Fault.CFSR = 0xE000ED28;
	Fault.HFSR = 0xE000ED2C;
	Fault.DFSR = 0xE000ED30;
	Fault.AFSR = 0xE000ED3C;

	Fault.formatf();
	printf("\n\n");

    TxBinaryPacket(&UartParser, CGraphPayloadTypeHardFault, 0, &Fault, sizeof(CGraphHardFaultPayload));
	
	return(strlen(Params));
}

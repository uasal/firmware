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

#include "../FWCmdrSerialBuildNum"

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

int8_t VersionCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\n\nVersion: Global Revision: %s; build number: %u on: %s.\n", GITVERSION, BuildNum, BuildTimeStr);
	
	TxBinaryPacket(&UartParser, CGraphPayloadTypeVersion, 0, NULL, 0);
	
	return(strlen(Params));
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

int8_t HardwareControlStatusCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\n\nHardwareControlStatusCommand: Querying...\n");
	TxBinaryPacket(&UartParser, CGraphPayloadTypeFWHardwareControlStatus, 0, NULL, 0);
    return(ParamsLen);
}
int8_t MotorControlStatusCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\n\nMotorControlStatusCommand: Querying...\n");
	TxBinaryPacket(&UartParser, CGraphPayloadTypeFWMotorControlStatus, 0, NULL, 0);
    return(ParamsLen);
}
int8_t PositionSenseControlStatusCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\n\nPositionSenseControlStatusCommand: Querying...\n");
	TxBinaryPacket(&UartParser, CGraphPayloadTypeFWPositionSenseControlStatus, 0, NULL, 0);
    return(ParamsLen);
}
int8_t PositionStepsCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\n\nPositionStepsCommand: Querying...\n");
	TxBinaryPacket(&UartParser, CGraphPayloadTypeFWPositionSteps, 0, NULL, 0);
    return(ParamsLen);
}
int8_t TelemetryADCCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\n\nTelemetryADCCommand: Querying...\n");
	TxBinaryPacket(&UartParser, CGraphPayloadTypeFWTelemetryADC, 0, NULL, 0);
    return(ParamsLen);
}

int8_t FilterSelectCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    unsigned long A = 0;
	uint32_t FilterSelect;
	
	//Convert parameters
    int8_t numfound = sscanf(Params, "%lu", &A);
    if (numfound >= 1)
    {
		FilterSelect = A;
		TxBinaryPacket(&UartParser, CGraphPayloadTypeFWFilterSelect, 0, &FilterSelect, sizeof(uint32_t));
		
		printf("\n\nFilterSelectCommand: set to: %lu\n", A);
		return(ParamsLen);
    }

	//No params? Just query it...
	printf("\n\nFilterSelectCommand: Querying...\n");
	TxBinaryPacket(&UartParser, CGraphPayloadTypeFWFilterSelect, 0, NULL, 0);
    return(ParamsLen);
}

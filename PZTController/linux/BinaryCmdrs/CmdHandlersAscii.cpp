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

#include "../PZTCmdrSerialBuildNum"

char Buffer[4096];

#include "uart/CGraphPacket.hpp"

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

//~ int8_t ReadFpgaCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
//~ {
	//~ uint8_t Buffer;

	//~ //Convert parameter to an integer
    //~ size_t addr = 0;
	//~ int8_t numfound = sscanf(Params, "%zX", &addr);
    //~ if (numfound < 1)
    //~ {
		//~ printf("\nReadFpgaCommand: ");
		//~ //for (addr = 0; addr <= 64; addr++)
		//~ for (addr = 0; addr <= 128; addr++)
		//~ {
			//~ Buffer = *(((uint8_t*)FSM)+addr);
			//~ printf("\n0x%.2zX: 0x%.2X ", addr, Buffer);
			//~ printf("[%u]", Buffer);
			//~ //printf(" ('%c')", Buffer);
		//~ }	
		//~ printf("\n\n");
    //~ }
	//~ else
	//~ {
		//~ Buffer = *(((uint8_t*)FSM)+addr);
		//~ printf("\nReadFpgaCommand: ");
		//~ //printf("\n%zu: 0x%.2X ", addr, Buffer);
		//~ printf("\n0x%.2zX: 0x%.2X ", addr, Buffer);
		//~ printf("[%u]", Buffer);
		//~ printf(" ('%c')\n\n", Buffer);
	//~ }
	
	//~ return(ParamsLen);
//~ }

//~ int8_t WriteFpgaCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
//~ {
	//~ //Convert parameter to an integer
	//~ size_t addr = 0;
    //~ unsigned long val = 0;
    //~ int8_t numfound = sscanf(Params, "%zX %lu", &addr, &val);
    //~ if (numfound < 2)
    //~ {
		//~ printf("\nWriteFpgaCommand: need 2 numeric parameters (address and value), got \"%s\" (%d params).\n", Params, numfound);
        //~ return(-1);
    //~ }

	//~ //Write data to fpga:
	//~ *(((uint8_t*)FSM)+addr) = (uint8_t)val;

	//~ printf("\nWriteFpgaCommand: Wrote %lu to ", val);
	//~ printf("0x%.4zX.\n", addr);
	
	//~ return(ParamsLen);
//~ }

int8_t PZTDacsCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    unsigned long A = 0, B = 0, C = 0;
	uint32_t DacSetpoints[3];
	
	//Convert parameters
    int8_t numfound = sscanf(Params, "%lx,%lx,%lx", &A, &B, &C);
    if (numfound >= 3)
    {
		DacSetpoints[0] = A;
		DacSetpoints[1] = B;
		DacSetpoints[2] = C;
		TxBinaryPacket(&UartParser, CGraphPayloadTypePZTDacs, 0, DacSetpoints, 3 * sizeof(uint32_t));
		
		printf("\n\nPZTDacs: set to: %x, %x, %x.\n", DacSetpoints[0], DacSetpoints[1], DacSetpoints[2]);
		return(ParamsLen);
    }
	if (numfound >= 1)
    {
		DacSetpoints[0] = A;
		DacSetpoints[1] = A;
		DacSetpoints[2] = A;
		TxBinaryPacket(&UartParser, CGraphPayloadTypePZTDacs, 0, DacSetpoints, 3 * sizeof(uint32_t));
		
		printf("\n\nPZTDacs: set to: %x, %x, %x.\n", DacSetpoints[0], DacSetpoints[1], DacSetpoints[2]);
		return(ParamsLen);
    }

	//No params? Just query it...
	printf("\n\nPZTDacs: Querying...\n");
	TxBinaryPacket(&UartParser, CGraphPayloadTypePZTDacs, 0, NULL, 0);
    return(ParamsLen);
}

int8_t PZTAdcsCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\n\nPZTAdcs: Querying...\n");
	TxBinaryPacket(&UartParser, CGraphPayloadTypePZTAdcs, 0, NULL, 0);
    return(ParamsLen);
}


int8_t PZTStatusCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\n\nPZTStatus: Querying...\n");
	TxBinaryPacket(&UartParser, CGraphPayloadTypePZTStatus, 0, NULL, 0);
    return(ParamsLen);
}


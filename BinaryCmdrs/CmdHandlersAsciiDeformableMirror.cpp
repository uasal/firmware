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
//~ #include <termios.h>

#include <sys/types.h>
#include <sys/stat.h>
//~ #include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>
//~ #include <sys/mman.h>
#include <errno.h>
#include <unordered_map>
using namespace std;

//~ #include <mcheck.h>
#include "dbg/memwatch.h"

#include "uart/AsciiCmdUserInterfaceLinux.h"

//~ #include "../MonitorAdc.hpp"
//~ extern CGraphFSMMonitorAdc MonitorAdc;

#include "cgraph/CGraphPacket.hpp"

#include "uart/BinaryUart.hpp"
extern BinaryUart UartParser;

int8_t DMDacCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
  unsigned long A = 0, B = 0, C = 0, D = 0;
	uint32_t DacSetpoints[4];
	
	//Convert parameters
        int8_t numfound = sscanf(Params, "%lx,%lx,%lx,%lx", &A, &B, &C, &D);
    if (numfound >= 4)
    {
		DacSetpoints[0] = A;
		DacSetpoints[1] = B;
		DacSetpoints[2] = C;
                DacSetpoints[3] = D;
		TxBinaryPacket(&UartParser, CGraphPayloadTypeDMDac, 0, DacSetpoints, 4 * sizeof(uint32_t));
		
		printf("\n\nDMDacs: set to: %x, %x, %x, %x.\n", DacSetpoints[0], DacSetpoints[1], DacSetpoints[2], DacSetpoints[3]);
		return(ParamsLen);
    }
	
	//No params? Just query it...
	printf("\n\nDMDacs: Querying...\n");
	TxBinaryPacket(&UartParser, CGraphPayloadTypeDMDac, 0, NULL, 0);
    return(ParamsLen);
}

int8_t DMHVSwitchCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    unsigned long A = 0, B = 0;
    uint32_t HVSwitchParams[2];
	
    size_t numfound = 0;
    if (numfound >= 2)
    {
		HVSwitchParams[0] = A;
		HVSwitchParams[1] = B;
		TxBinaryPacket(&UartParser, CGraphPayloadTypeDMHVSwitch, 0, HVSwitchParams, 2 * sizeof(uint32_t));
		
		printf("\n\nHVSwitchCommand: set to: %x, %x.\n", HVSwitchParams[0], HVSwitchParams[1]);
		return(ParamsLen);
    }

    //No params? Just query it...
    printf("\n\nHVSwitchCommand: Querying...\n");
    TxBinaryPacket(&UartParser, CGraphPayloadTypeDMHVSwitch, 0, NULL, 0);
    return(ParamsLen);
}

int8_t DMTelemetryCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
  printf("\n\nTelemetryCommand: Querying...\n");
  TxBinaryPacket(&UartParser, CGraphPayloadTypeDMTelemetry, 0, NULL, 0);
  return(ParamsLen);
}

int8_t DMDacConfigCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
  printf("\n\nDacConfigCommand: Sent...\n");
  TxBinaryPacket(&UartParser, CGraphPayloadTypeDMDacConfig, 0, NULL, 0);
  return(ParamsLen);
}

int8_t DMMappingCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	unsigned long A = 0, B = 0, C = 0, D = 0;

	//Convert parameters - at the moment we're being lazy and only support testing a single mapping at a time...
	int8_t numfound = sscanf(Params, "%lu,%lu,%lu,%lu", &A, &B, &C, &D);
	if (numfound >= 4)
	{
		CGraphDMPixelPayloadHeader PixelIndex(A);
		CGraphDMMappingPayload Mapping(B, C, D);
		
		//Make a really big buffer (cause we're on a desktop computer) for later when we support testing large mappings!
		uint8_t Buffer[(DMMaxActuators * sizeof(CGraphDMMappingPayload)) + sizeof(CGraphDMPixelPayloadHeader)];
		memcpy(Buffer, &PixelIndex, sizeof(CGraphDMPixelPayloadHeader));
		memcpy(&(Buffer[sizeof(CGraphDMPixelPayloadHeader)]), &Mapping, sizeof(CGraphDMMappingPayload));
		
		TxBinaryPacket(&UartParser, CGraphPayloadTypeDMMappings, 0, Buffer, sizeof(CGraphDMMappingPayload) + sizeof(CGraphDMPixelPayloadHeader));		
	}
	//query?
	else
	{
		printf("\n\nDMMappingCommand: No parameters given; querying...\n");
		TxBinaryPacket(&UartParser, CGraphPayloadTypeDMMappings, 0, NULL, 0);		
	}
		
    return(ParamsLen);
}

int8_t DMShortPixelsCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	unsigned long A = 0;
	
	strtok(const_cast<char*>(Params)," ,\t\r\n");

	//Convert start pixel
	int8_t numfound = sscanf(Params, "%lu", &A);
	if (numfound >= 1)
	{
		CGraphDMPixelPayloadHeader PixelIndex(A);
		
		//Make a really big buffer (cause we're on a desktop computer) for later when we support testing large mappings!
		uint8_t Buffer[(DMMaxActuators * sizeof(uint16_t)) + sizeof(CGraphDMPixelPayloadHeader)];
		memcpy(Buffer, &PixelIndex, sizeof(CGraphDMPixelPayloadHeader));

		//Now we start building an array of pixels...icky parsing lol
		size_t i = 0;
		for (i = 0; i < DMMaxActuators; i++)
		{
			char* PixStr = strtok((char*)nullptr," ,\t\r\n");
			if (nullptr == PixStr) { break; }
			uint16_t Pixel = atoi(PixStr);
			uint16_t* PixBuf = reinterpret_cast<uint16_t*>(&(Buffer[(i * sizeof(uint16_t)) + sizeof(CGraphDMPixelPayloadHeader)]));
			*PixBuf = Pixel;
		}

		printf("\n\nDMShortPixelsCommand: Writing %lu pixels starting at %lu...\n", (unsigned long)i, A);		
		TxBinaryPacket(&UartParser, CGraphPayloadTypeDMShortPixels, 0, Buffer, (i * sizeof(uint16_t)) + sizeof(CGraphDMPixelPayloadHeader));		
	}
	//query?
	else
	{
		printf("\n\nDMShortPixelsCommand: No parameters given; querying...\n");
		TxBinaryPacket(&UartParser, CGraphPayloadTypeDMShortPixels, 0, NULL, 0);		
	}
		
    return(ParamsLen);

}

int8_t DMDitherCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	unsigned long A = 0;
	
	strtok(const_cast<char*>(Params)," ,\t\r\n");

	//Convert start pixel
	int8_t numfound = sscanf(Params, "%lu", &A);
	if (numfound >= 1)
	{
		CGraphDMPixelPayloadHeader PixelIndex(A);
		
		//Make a really big buffer (cause we're on a desktop computer) for later when we support testing large mappings!
		uint8_t Buffer[(DMMaxActuators * sizeof(uint8_t)) + sizeof(CGraphDMPixelPayloadHeader)];
		memcpy(Buffer, &PixelIndex, sizeof(CGraphDMPixelPayloadHeader));

		//Now we start building an array of pixels...icky parsing lol
		size_t i = 0;
		for (i = 0; i < DMMaxActuators; i++)
		{
			char* PixStr = strtok((char*)nullptr," ,\t\r\n");
			if (nullptr == PixStr) { break; }
			uint8_t Pixel = atoi(PixStr);
			uint8_t* PixBuf = reinterpret_cast<uint8_t*>(&(Buffer[(i * sizeof(uint8_t)) + sizeof(CGraphDMPixelPayloadHeader)]));
			*PixBuf = Pixel;
		}

		printf("\n\nDMShortPixelsCommand: Writing %lu pixels starting at %lu...\n", (unsigned long)i, A);		
		TxBinaryPacket(&UartParser, CGraphPayloadTypeDMShortPixels, 0, Buffer, (i * sizeof(uint8_t)) + sizeof(CGraphDMPixelPayloadHeader));		
	}
	//query?
	else
	{
		printf("\n\nDMShortPixelsCommand: No parameters given; querying...\n");
		TxBinaryPacket(&UartParser, CGraphPayloadTypeDMShortPixels, 0, NULL, 0);		
	}
		
    return(ParamsLen);

}

int8_t DMLongPixelsCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	unsigned long A = 0;
	
	strtok(const_cast<char*>(Params)," ,\t\r\n");

	//Convert start pixel
	int8_t numfound = sscanf(Params, "%lu", &A);
	if (numfound >= 1)
	{
		CGraphDMPixelPayloadHeader PixelIndex(A);
		
		//Make a really big buffer (cause we're on a desktop computer) for later when we support testing large mappings!
		uint8_t Buffer[(DMMaxActuators * sizeof(uint32_t)) + sizeof(CGraphDMPixelPayloadHeader)];
		memcpy(Buffer, &PixelIndex, sizeof(CGraphDMPixelPayloadHeader));

		//Now we start building an array of pixels...icky parsing lol
		size_t i = 0;
		for (i = 0; i < DMMaxActuators; i++)
		{
			char* PixStr = strtok((char*)nullptr," ,\t\r\n");
			if (nullptr == PixStr) { break; }
			uint32_t Pixel = atoi(PixStr);
			uint8_t* PixBuf = reinterpret_cast<uint8_t*>(&(Buffer[(i * 3 * sizeof(uint8_t)) + sizeof(CGraphDMPixelPayloadHeader)]));
			//Yes, we're hard-coding an endianness here, have a nice day =)
			PixBuf[0] = (uint8_t)(Pixel & 0x000000FFUL);
			PixBuf[1] = (uint8_t)((Pixel & 0x0000FF00UL) >> 8);
			PixBuf[2] = (uint8_t)((Pixel & 0x00FF0000UL) >> 16);
		}

		printf("\n\nDMShortPixelsCommand: Writing %lu pixels starting at %lu...\n", (unsigned long)i, A);		
		TxBinaryPacket(&UartParser, CGraphPayloadTypeDMShortPixels, 0, Buffer, (i * 3 * sizeof(uint8_t)) + sizeof(CGraphDMPixelPayloadHeader));		
	}
	//query?
	else
	{
		printf("\n\nDMShortPixelsCommand: No parameters given; querying...\n");
		TxBinaryPacket(&UartParser, CGraphPayloadTypeDMShortPixels, 0, NULL, 0);		
	}
		
    return(ParamsLen);

}


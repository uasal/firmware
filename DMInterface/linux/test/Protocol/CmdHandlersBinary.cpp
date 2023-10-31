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
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <inttypes.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <errno.h>
#include <unordered_map>
using namespace std;

#include "uart/BinaryUart.hpp"

#include "uart/CGraphPacket.hpp"

#include "CmdTableBinary.hpp"

int8_t BinaryVersionCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//(Don't validate version; always reply, even though it will cause a mess, so everyone knows we're here!)
	
    CGraphVersionPayload Version;
    Version.SerialNum = 0;
	Version.ProcessorFirmwareBuildNum = 99;
	Version.FPGAFirmwareBuildNum = 0;
    printf("\nBinaryVersionCommand: Sending response (%lu bytes): ", sizeof(CGraphVersionPayload));
    Version.formatf();
    printf("\n");
    return(ParamsLen);
}

int8_t BinaryPZTDacsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if (ParamsLen >= (3 * sizeof(uint32_t)))
	{
		const uint32_t* DacSetpoints = (const uint32_t*)Params;
		printf("\nBinaryPZTDacsCommand Setting to (0x%X, 0x%X, 0x%X).\n\n", DacSetpoints[0], DacSetpoints[1], DacSetpoints[2]);
	}
	uint32_t DacSetpoints[3];
	DacSetpoints[0] = 0x01;
	DacSetpoints[1] = 0x02;
	DacSetpoints[2] = 0x03;
	printf("\nBinaryPZTDacsCommand  Replying (0x%X, 0x%X, 0x%X)...\n\n", DacSetpoints[0], DacSetpoints[1], DacSetpoints[2]);
	return(ParamsLen);
}

int8_t BinaryPZTAdcsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\nBinaryPZTAdcsCommand  Replying...\n\n");
	return(ParamsLen);
}
	
int8_t BinaryPZTAdcsFloatingPointCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\nBinaryPZTAdcsCommand processing(%lu)...\n\n", ParamsLen);
	
	double AdcVals[3];
	AdcVals[0] = 1.0;
	AdcVals[1] = 2.0;
	AdcVals[2] = 3.0;
	printf("\nBinaryPZTAdcsFloatingPointCommand  Replying (%lf, %lf, %lf)...\n\n", AdcVals[0], AdcVals[1], AdcVals[2]);
	return(ParamsLen);
}

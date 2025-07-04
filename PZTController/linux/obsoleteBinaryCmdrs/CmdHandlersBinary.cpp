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

#include "cgraph/CGraphPacket.hpp"

#include "uart/BinaryUart.hpp"

#include "cgraph/CGraphFSMHardwareInterface.hpp"

#include "../PZTCmdrSerialBuildNum"

#include "CmdTableBinary.hpp"

int8_t BinaryVersionCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= sizeof(CGraphVersionPayload)) )
	{
		const CGraphVersionPayload* Version = reinterpret_cast<const CGraphVersionPayload*>(Params);
		printf("\nBinaryVersionCommand: ");
		Version->formatf();
		printf("\n");
	}
	else
	{
		printf("\nBinaryVersionCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, sizeof(CGraphVersionPayload));
	}
    return(ParamsLen);
}

int8_t BinaryPZTDacsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (3 * sizeof(uint32_t))) )
	{
		const uint32_t* DacSetpoints = reinterpret_cast<const uint32_t*>(Params);
		printf("\nBinaryPZTDacsCommand: 0x%X | 0x%X | 0x%X\n\n", DacSetpoints[0], DacSetpoints[1], DacSetpoints[2]);
	}
	else
	{
		printf("\nBinaryPZTDacsCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (3 * sizeof(uint32_t)));
	}
    return(ParamsLen);
}

int8_t BinaryPZTAdcsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    if ( (NULL != Params) && (ParamsLen >= (3 * sizeof(AdcAccumulator))) )
	{
		const AdcAccumulator* AdcVals = reinterpret_cast<const AdcAccumulator*>(Params);
		printf("\nBinaryPZTAdcsCommand: ");
		AdcVals[0].formatf();
		printf(" | ");
		AdcVals[1].formatf();
		printf(" | ");
		AdcVals[2].formatf();
		printf("\n\n");
	}
	else
	{
		printf("\nBinaryPZTAdcsCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (3 * sizeof(AdcAccumulator)));
	}
    return(ParamsLen);
}
	
int8_t BinaryPZTAdcsFloatingPointCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (3 * sizeof(double))) )
	{
		const double* AdcVals = reinterpret_cast<const double*>(Params);
		printf("\nBinaryPZTAdcsFPCommand: %lf | %lf | %lf\n\n", AdcVals[0], AdcVals[1], AdcVals[2]);
	}
	else
	{
		printf("\nBinaryPZTAdcsFPCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (3 * sizeof(double)));
	}
    return(ParamsLen);
}

int8_t BinaryPZTStatusCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (3 * sizeof(double))) )
	{
		const CGraphPZTStatusPayload* Status = reinterpret_cast<const CGraphPZTStatusPayload*>(Params);

		formatf("\n\nBinaryPZTStatus Command: Values with corrected units follow:\n\n");
		
		formatf("P1V2: %3.6lf V\n", Status->P1V2);
		formatf("P2V2: %3.6lf V\n", Status->P2V2);
		formatf("P24V: %3.6lf V\n", Status->P24V);
		formatf("P2V5: %3.6lf V\n", Status->P2V5);
		formatf("P3V3A: %3.6lf V\n", Status->P3V3A);
		formatf("P6V: %3.6lf V\n", Status->P6V);
		formatf("P5V: %3.6lf V\n", Status->P5V);
		formatf("P3V3D: %3.6lf V\n", Status->P3V3D);
		formatf("P4V3: %3.6lf V\n", Status->P4V3);
		formatf("N5V: %3.6lf V\n", Status->N5V);
		formatf("N6V: %3.6lf V\n", Status->N6V);
		formatf("P150V: %3.6lf V\n", Status->P150V);
		
		formatf("\n\nBinaryPZTStatus Command complete.\n\n");
	}
	else
	{
		printf("\nBinaryPZTAdcsFPCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (3 * sizeof(double)));
	}
    return(ParamsLen);
}

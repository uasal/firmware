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

#include "CmdTableBinary.hpp"

int8_t BinaryFSMDacsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (3 * sizeof(uint32_t))) )
	{
		const uint32_t* DacSetpoints = reinterpret_cast<const uint32_t*>(Params);
		printf("\nBinaryFSMDacsCommand: 0x%X | 0x%X | 0x%X\n\n", DacSetpoints[0], DacSetpoints[1], DacSetpoints[2]);
	}
	else
	{
		printf("\nBinaryFSMDacsCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (3 * sizeof(uint32_t)));
	}
    return(ParamsLen);
}

int8_t BinaryFSMAdcsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    if ( (NULL != Params) && (ParamsLen >= (3 * sizeof(AdcAccumulator))) )
	{
		const AdcAccumulator* AdcVals = reinterpret_cast<const AdcAccumulator*>(Params);
		printf("\nBinaryFSMAdcsCommand: ");
		AdcVals[0].formatf();
		printf(" | ");
		AdcVals[1].formatf();
		printf(" | ");
		AdcVals[2].formatf();
		printf("\n\n");
	}
	else
	{
		printf("\nBinaryFSMAdcsCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (3 * sizeof(AdcAccumulator)));
	}
    return(ParamsLen);
}
	
int8_t BinaryFSMAdcsFloatingPointCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (3 * sizeof(double))) )
	{
		const double* AdcVals = reinterpret_cast<const double*>(Params);
		printf("\nBinaryFSMAdcsFPCommand: %lf | %lf | %lf\n\n", AdcVals[0], AdcVals[1], AdcVals[2]);
	}
	else
	{
		printf("\nBinaryFSMAdcsFPCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (3 * sizeof(double)));
	}
    return(ParamsLen);
}

int8_t BinaryFSMTelemetryCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (sizeof(CGraphFSMTelemetryPayload))) )
	{
		const CGraphFSMTelemetryPayload* Status = reinterpret_cast<const CGraphFSMTelemetryPayload*>(Params);

		formatf("\n\nBinaryFSMTelemetry Command: Values with corrected units follow:\n\n");
		
		formatf("P1V2: %3.6lf V\n", Status->P1V2);
		formatf("P2V2: %3.6lf V\n", Status->P2V2);
		formatf("P28V: %3.6lf V\n", Status->P28V);
		formatf("P2V5: %3.6lf V\n", Status->P2V5);
		formatf("P3V3A: %3.6lf V\n", Status->P3V3A);
		formatf("P6V: %3.6lf V\n", Status->P6V);
		formatf("P5V: %3.6lf V\n", Status->P5V);
		formatf("P3V3D: %3.6lf V\n", Status->P3V3D);
		formatf("P4V3: %3.6lf V\n", Status->P4V3);
		formatf("N5V: %3.6lf V\n", Status->N5V);
		formatf("N6V: %3.6lf V\n", Status->N6V);
		formatf("P150V: %3.6lf V\n", Status->P150V);
		
		formatf("\n\nBinaryFSMTelemetry Command complete.\n\n");
	}
	else
	{
		printf("\nBinaryFSMTelemetry: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (sizeof(CGraphFSMTelemetryPayload)));
	}
    return(ParamsLen);
}

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

uint32_t DacSetpoints[3];

int8_t BinaryFSMDacsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (3 * sizeof(uint32_t))) )
	{
		const void* Setpoints = reinterpret_cast<const void*>(Params);
		memcpy(DacSetpoints, Setpoints, 3 * sizeof(uint32_t));
		printf("\nBinaryFSMDacsCommand: Set to: 0x%X | 0x%X | 0x%X\n\n", DacSetpoints[0], DacSetpoints[1], DacSetpoints[2]);
	}
	printf("\nBinaryFSMDacsCommand: Replying 0x%X | 0x%X | 0x%X\n\n", DacSetpoints[0], DacSetpoints[1], DacSetpoints[2]);
	TxBinaryPacket(Argument, CGraphPayloadTypeFSMDacs, 0, DacSetpoints, 3 * sizeof(uint32_t));
    return(ParamsLen);
}

int8_t BinaryFSMAdcsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	AdcAccumulator AdcVals[3];	
	AdcVals[0].Samples = DacSetpoints[0] / 100;
	AdcVals[1].Samples = DacSetpoints[1] / 100;
	AdcVals[2].Samples = DacSetpoints[2] / 100;	
	AdcVals[0].NumAccums = 1;
	AdcVals[1].NumAccums = 1;
	AdcVals[2].NumAccums = 1;
	printf("\nBinaryFSMAdcsCommand: Replying (%d, %d, %d)...\n\n", AdcVals[0].Samples, AdcVals[1].Samples, AdcVals[2].Samples);
	TxBinaryPacket(Argument, CGraphPayloadTypeFSMAdcs, 0, AdcVals, 3 * sizeof(AdcAccumulator));
    return(ParamsLen);
}
	
int8_t BinaryFSMAdcsFloatingPointCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	double AdcVals[3];
	AdcVals[0] = (double)(DacSetpoints[0]) / 100.0;
	AdcVals[1] = (double)(DacSetpoints[1]) / 100.0;
	AdcVals[2] = (double)(DacSetpoints[2]) / 100.0;
	printf("\nBinaryFSMAdcsFloatingPointCommand  Replying (%lf, %lf, %lf)...\n\n", AdcVals[0], AdcVals[1], AdcVals[2]);
	TxBinaryPacket(Argument, CGraphPayloadTypeFSMAdcsFloatingPoint, 0, AdcVals, 3 * sizeof(double));
    return(ParamsLen);
}

int8_t BinaryFSMTelemetryCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	CGraphFSMTelemetryPayload Status;
	
	Status.P1V2 = 1.2;
	Status.P2V2 = 2.2;
	Status.P28V = 28.0;
	Status.P2V5 = 2.5;
	Status.P3V3A = 3.3;
	Status.P6V = 6.0;
	Status.P5V = 5.0;
	Status.P3V3D = 3.3;
	Status.P4V3 = 4.3;
	Status.N5V = -5.0;
	Status.N6V = -6.0;
	Status.P150V = 150.0;

	printf("\n\nBinaryFSMTelemetryCommand: CurrentValues:\n\n");
	
	formatf("P1V2: %3.6lf V\n", Status.P1V2);
	formatf("P2V2: %3.6lf V\n", Status.P2V2);
	formatf("P28V: %3.6lf V\n", Status.P28V);
	formatf("P2V5: %3.6lf V\n", Status.P2V5);
	formatf("P3V3A: %3.6lf V\n", Status.P3V3A);
	formatf("P6V: %3.6lf V\n", Status.P6V);
	formatf("P5V: %3.6lf V\n", Status.P5V);
	formatf("P3V3D: %3.6lf V\n", Status.P3V3D);
	formatf("P4V3: %3.6lf V\n", Status.P4V3);
	formatf("N5V: %3.6lf V\n", Status.N5V);
	formatf("N6V: %3.6lf V\n", Status.N6V);
	formatf("P150V: %3.6lf V\n", Status.P150V);

	
	printf("\nBinaryFSMTelemetryCommand: Replying...\n");
	TxBinaryPacket(Argument, CGraphPayloadTypeFSMTelemetry, 0, &Status, sizeof(CGraphFSMTelemetryPayload));
	return(ParamsLen);
}

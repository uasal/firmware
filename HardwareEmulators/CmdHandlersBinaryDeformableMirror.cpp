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

#include "cgraph/CGraphDMHardwareInterface.hpp"

#include "CmdTableBinary.hpp"

// These are what's returned from the Control Interface
int8_t BinaryDMDacCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//~ if ( (NULL != Params) && (ParamsLen >= 4*(sizeof(uint32_t))) )
	//~ {
		//~ const uint32_t DacParameters = *reinterpret_cast<const uint32_t*>(Params);
		//~ printf("\nBinaryDacCommand: Setting a mirror voltage: %lu\n", (unsigned long)DacParameters);
	//~ }
	//~ else
	//~ {
		//~ printf("\nBinaryDacCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (sizeof(uint32_t)));
	//~ }
		
	TxBinaryPacket(Argument, CGraphPayloadTypeDMDac, 0, Params, ParamsLen);
    return(ParamsLen);
}

int8_t BinaryDMTelemetryCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	formatf("\nBinaryDMTelemetryADCCommand: processing(%u)...\n\n", ParamsLen);

	CGraphDMTelemetryPayload Status;
	
	Status.P1V2 = 1.2;
	Status.P2V2 = 2.2;
	Status.P28V = 28.0;
	Status.P2V5 = 2.5;
	Status.P6V = 6.0;
	Status.P5V = 5.0;
	Status.P3V3D = 3.3;
	Status.P4V3 = 4.3;
	Status.P2I2 = 0.010;
	Status.P4I3 = 0.100;
	Status.P6I = 0.020;

	formatf("\n\nBinaryDMTelemetryADCCommand: CurrentValues:\n\n");
	
	formatf("P1V2: %3.6lf V\n", Status.P1V2);
	formatf("P2V2: %3.6lf V\n", Status.P2V2);
	formatf("P28V: %3.6lf V\n", Status.P28V);
	formatf("P2V5: %3.6lf V\n", Status.P2V5);
	formatf("P6V: %3.6lf V\n", Status.P6V);
	formatf("P5V: %3.6lf V\n", Status.P5V);
	formatf("P3V3D: %3.6lf V\n", Status.P3V3D);
	formatf("P4V3: %3.6lf V\n", Status.P4V3);
	formatf("P2I2: %3.6lf V\n", Status.P2I2);
	formatf("P4I3: %3.6lf V\n", Status.P4I3);
	formatf("P6I: %3.6lf V\n", Status.P6I);

	formatf("\nBinaryDMTelemetryADCCommand: Replying...\n");
	TxBinaryPacket(Argument, CGraphPayloadTypeDMTelemetry, 0, &Status, sizeof(CGraphDMTelemetryPayload));

	return(ParamsLen);
}

int8_t BinaryDMHVSwitchCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//~ if ( (NULL != Params) && (ParamsLen >= (sizeof(uint32_t))) )
	//~ {
		//~ const uint32_t FilterSelect = *reinterpret_cast<const uint32_t*>(Params);
		//~ printf("\nBinaryHVSwitchCommand: FilterSelected(0=select inprogress): %lu\n", (unsigned long)FilterSelect);
	//~ }
	//~ else
	//~ {
		//~ printf("\nBinaryHVSwitchCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (sizeof(uint32_t)));
	//~ }
	TxBinaryPacket(Argument, CGraphPayloadTypeDMHVSwitch, 0, Params, ParamsLen);
    return(ParamsLen);
}

int8_t BinaryDMDacConfigCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//~ if ( (NULL != Params) && (ParamsLen >= (sizeof(uint32_t))) )
	//~ {
		//~ const uint32_t FilterSelect = *reinterpret_cast<const uint32_t*>(Params);
		//~ printf("\nBinaryDacConfigCommand: FilterSelected(0=select inprogress): %lu\n", (unsigned long)FilterSelect);
	//~ }
	//~ else
	//~ {
          //~ printf("\nI am not sending anything back right now.  Work in progress...");
		//~ printf("\nBinaryDacConfigCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (sizeof(uint32_t)));
	//~ }
	TxBinaryPacket(Argument, CGraphPayloadTypeDMDacConfig, 0, Params, ParamsLen);
    return(ParamsLen);
}

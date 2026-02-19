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
//~ #include <sys/mman.h>
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
		printf("\nBinaryFSMDacsCommand: Short packet: %lu (exptected %lu bytes): ", (unsigned long)ParamsLen, (unsigned long)(3 * sizeof(uint32_t)));
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
		printf("\nBinaryFSMAdcsCommand: Short packet: %lu (exptected %lu bytes): ", (unsigned long)ParamsLen, (unsigned long)(3 * sizeof(AdcAccumulator)));
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
		printf("\nBinaryFSMAdcsFPCommand: Short packet: %lu (exptected %lu bytes): ", (unsigned long)ParamsLen, (unsigned long)(3 * sizeof(double)));
	}
    return(ParamsLen);
}

int8_t BinaryFSMTelemetryCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (sizeof(CGraphFSMTelemetryPayload))) )
	{
		const CGraphFSMTelemetryPayload* Status = reinterpret_cast<const CGraphFSMTelemetryPayload*>(Params);

		formatf("\n\nBinaryFSMTelemetry Command: Values with corrected units follow:\n\n");
		
		formatf("IHV: %3.6lf V\n", Status->IHV);
		formatf("INV: %3.6lf V\n", Status->INV);
		formatf("I6V: %3.6lf V\n", Status->I6V);
		formatf("I3VD: %3.6lf V\n", Status->I3VD);
		formatf("I2VD: %3.6lf V\n", Status->I2VD);
		formatf("I1V: %3.6lf V\n", Status->I1V);
		formatf("StrainBP: %3.6lf V\n", Status->StrainBP);
		formatf("StrainBM: %3.6lf V\n", Status->StrainBM);
		formatf("StrainB: %3.6lf V\n", Status->StrainB);
		formatf("StrainDP: %3.6lf V\n", Status->StrainDP);
		formatf("StrainDM: %3.6lf V\n", Status->StrainDM);
		formatf("StrainD: %3.6lf V\n", Status->StrainD);
		formatf("StrainCM: %3.6lf V\n", Status->StrainCM);
		formatf("StrainCP: %3.6lf V\n", Status->StrainCP);
		formatf("StrainC: %3.6lf V\n", Status->StrainC);
		formatf("StrainAM: %3.6lf V\n", Status->StrainAM);
		formatf("StrainAP: %3.6lf V\n", Status->StrainAP);
		formatf("StrainA: %3.6lf V\n", Status->StrainA);
		formatf("P5VD: %3.6lf V\n", Status->P5VD);
		formatf("I2VA: %3.6lf V\n", Status->I2VA);
		formatf("Temp: %3.6lf V\n", Status->Temp);
		formatf("P3V3D: %3.6lf V\n", Status->P3V3D);
		formatf("P28V: %3.6lf V\n", Status->P28V);
		formatf("P2V2: %3.6lf V\n", Status->P2V2);
		formatf("P2V5D: %3.6lf V\n", Status->P2V5D);
		formatf("P1V2: %3.6lf V\n", Status->P1V2);
		formatf("P2V5A: %3.6lf V\n", Status->P2V5A);
		formatf("P4V3: %3.6lf V\n", Status->P4V3);
		formatf("I3VA: %3.6lf V\n", Status->I3VA);
		formatf("P3V3A: %3.6lf V\n", Status->P3V3A);
		formatf("P6V: %3.6lf V\n", Status->P6V);
		formatf("P5VA: %3.6lf V\n", Status->P5VA);
		formatf("LuxRads: %3.6lf V\n", Status->LuxRads);
		formatf("N18V: %3.6lf V\n", Status->N18V);
		formatf("N20V: %3.6lf V\n", Status->N20V);
		formatf("P125V: %3.6lf V\n", Status->P125V);
		
		formatf("\n\nBinaryFSMTelemetry Command complete.\n\n");
	}
	else
	{
		printf("\nBinaryFSMTelemetry: Short packet: %lu (exptected %lu bytes): ", (unsigned long)ParamsLen, (unsigned long)(sizeof(CGraphFSMTelemetryPayload)));
	}
    return(ParamsLen);
}

int8_t BinaryFSMHardwareConfigCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (sizeof(CGraphFSMHardwareControlRegister))) )
	{
		const CGraphFSMHardwareControlRegister* read = reinterpret_cast<const CGraphFSMHardwareControlRegister*>(Params);
		printf("\nBinaryFSMHardwareConfigCommand Reply:");
		read->formatf();
		printf(".\n\n");	
	}
	else
	{
		printf("\nBinaryFSMHardwareConfigCommand: Short packet: %lu (exptected %lu bytes): ", (unsigned long)ParamsLen, (unsigned long)(sizeof(CGraphFSMHardwareControlRegister)));
	}
    return(ParamsLen);
}

int8_t BinaryFSMAdcConfigCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (sizeof(AdcConfigRegister))) )
	{
		const AdcConfigRegister* read = reinterpret_cast<const AdcConfigRegister*>(Params);
		printf("\nBinaryFSMAdcConfigCommand Reply:");
		read->formatf();
		printf(".\n\n");	
	}
	else
	{
		printf("\nBinaryFSMAdcConfigCommand: Short packet: %lu (exptected %lu bytes): ", (unsigned long)ParamsLen, (unsigned long)(sizeof(AdcConfigRegister)));
	}
    return(ParamsLen);
}

int8_t BinaryFSMAccumConfigCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (sizeof(AccumulatorConfigRegister))) )
	{
		const AccumulatorConfigRegister* read = reinterpret_cast<const AccumulatorConfigRegister*>(Params);
		printf("\nBinaryFSMAccumConfigCommand Reply:");
		read->formatf();
		printf(".\n\n");	
	}
	else
	{
		printf("\nBinaryFSMAccumConfigCommand: Short packet: %lu (exptected %lu bytes): ", (unsigned long)ParamsLen, (unsigned long)(sizeof(AccumulatorConfigRegister)));
	}
    return(ParamsLen);
}

int8_t BinaryFSMDacConfigCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (sizeof(DacConfigRegister))) )
	{
		const DacConfigRegister* read = reinterpret_cast<const DacConfigRegister*>(Params);
		printf("\nBinaryFSMDacConfigCommand Reply:");
		read->formatf();
		printf(".\n\n");	
	}
	else
	{
		printf("\nBinaryFSMDacConfigCommand: Short packet: %lu (exptected %lu bytes): ", (unsigned long)ParamsLen, (unsigned long)(sizeof(DacConfigRegister)));
	}
    return(ParamsLen);
}

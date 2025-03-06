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

#include "cgraph/CGraphFWHardwareInterface.hpp"

#include "CmdTableBinary.hpp"

int8_t BinaryFWHardwareControlStatusCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    if ( (NULL != Params) && (ParamsLen >= (sizeof(CGraphFWHardwareControlRegister))) )
	{
		const CGraphFWHardwareControlRegister* HCR = reinterpret_cast<const CGraphFWHardwareControlRegister*>(Params);
		printf("\nBinaryFWHardwareControlStatusCommand: ");
		HCR->formatf();
		printf("\n\n");
	}
	else
	{
		printf("\nBinaryFWHardwareControlStatusCommand: Short packet: %lu (exptected %lu bytes): ", (unsigned long)ParamsLen, (unsigned long)(sizeof(CGraphFWHardwareControlRegister)));
	}
    return(ParamsLen);
}

int8_t BinaryFWMotorControlStatusCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    if ( (NULL != Params) && (ParamsLen >= (sizeof(CGraphFWHardwareControlRegister))) )
	{
		const CGraphFWMotorControlStatusRegister* MCSR = reinterpret_cast<const CGraphFWMotorControlStatusRegister*>(Params);
		printf("\nBinaryFWMotorControlStatusCommand: ");
		MCSR->formatf();
		printf("\n\n");
	}
	else
	{
		printf("\nBinaryFWMotorControlStatusCommand: Short packet: %lu (exptected %lu bytes): ", (unsigned long)ParamsLen, (unsigned long)(sizeof(CGraphFWMotorControlStatusRegister)));
	}
    return(ParamsLen);
}

int8_t BinaryFWPositionSenseControlStatusCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    if ( (NULL != Params) && (ParamsLen >= (sizeof(CGraphFWPositionSenseRegister))) )
	{
		const CGraphFWPositionSenseRegister* PositionSensors = reinterpret_cast<const CGraphFWPositionSenseRegister*>(Params);
		printf("\nBinaryFWPositionSenseControlStatusCommand: ");
		PositionSensors->formatf();
		printf("\n\n");
	}
	else
	{
		printf("\nBinaryFWPositionSenseControlStatusCommand: Short packet: %lu (exptected %lu bytes): ", (unsigned long)ParamsLen, (unsigned long)(sizeof(CGraphFWPositionSenseRegister)));
	}
    return(ParamsLen);
}

int8_t BinaryFWPositionStepsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (48 * sizeof(uint32_t))) )
	{
		const uint32_t* PosSteps = reinterpret_cast<const uint32_t*>(Params);
		printf("\nBinaryFWPositionStepsCommand: \n");
		
		formatf("\nPosDetHomeA: On: %lu, Off: %lu", PosSteps[0], PosSteps[1]);
		formatf("\nPosDetA0: On: %lu, Off: %lu", PosSteps[2], PosSteps[3]);
		formatf("\nPosDetA1: On: %lu, Off: %lu", PosSteps[4], PosSteps[5]);
		formatf("\nPosDetA2: On: %lu, Off: %lu", PosSteps[6], PosSteps[7]);
		
		formatf("\nPosDetHomeB: On: %lu, Off: %lu", PosSteps[8], PosSteps[9]);
		formatf("\nPosDetB0: On: %lu, Off: %lu", PosSteps[10], PosSteps[11]);
		formatf("\nPosDetB1: On: %lu, Off: %lu", PosSteps[12], PosSteps[13]);
		formatf("\nPosDetB2: On: %lu, Off: %lu", PosSteps[14], PosSteps[15]);
	
		formatf("\nPosDet0A: On: %lu, Off: %lu", PosSteps[16], PosSteps[17]);
		formatf("\nPosDet1A: On: %lu, Off: %lu", PosSteps[18], PosSteps[19]);
		formatf("\nPosDet2A: On: %lu, Off: %lu", PosSteps[20], PosSteps[21]);
		formatf("\nPosDet3A: On: %lu, Off: %lu", PosSteps[22], PosSteps[23]);
		formatf("\nPosDet4A: On: %lu, Off: %lu", PosSteps[24], PosSteps[25]);
		formatf("\nPosDet5A: On: %lu, Off: %lu", PosSteps[26], PosSteps[27]);
		formatf("\nPosDet6A: On: %lu, Off: %lu", PosSteps[28], PosSteps[29]);
		formatf("\nPosDet7A: On: %lu, Off: %lu", PosSteps[30], PosSteps[31]);
	
		formatf("\nPosDet0B: On: %lu, Off: %lu", PosSteps[32], PosSteps[33]);
		formatf("\nPosDet1B: On: %lu, Off: %lu", PosSteps[34], PosSteps[35]);
		formatf("\nPosDet2B: On: %lu, Off: %lu", PosSteps[36], PosSteps[37]);
		formatf("\nPosDet3B: On: %lu, Off: %lu", PosSteps[38], PosSteps[39]);
		formatf("\nPosDet4B: On: %lu, Off: %lu", PosSteps[40], PosSteps[41]);
		formatf("\nPosDet5B: On: %lu, Off: %lu", PosSteps[42], PosSteps[43]);
		formatf("\nPosDet6B: On: %lu, Off: %lu", PosSteps[44], PosSteps[45]);
		formatf("\nPosDet7B: On: %lu, Off: %lu", PosSteps[46], PosSteps[47]);

		printf("\n\n");
	}
	else
	{
		printf("\nBinaryFWPositionStepsCommand: Short packet: %lu (exptected %lu bytes): ", (unsigned long)ParamsLen, (unsigned long)(48 * sizeof(uint32_t)));
	}
    return(ParamsLen);
}


int8_t BinaryFWTelemetryCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (sizeof(CGraphFWTelemetryPayload))) )
	{
		const CGraphFWTelemetryPayload* Telemetry = reinterpret_cast<const CGraphFWTelemetryPayload*>(Params);

		formatf("\n\nBinaryFWTelemetryCommand Command: Values with corrected units follow:\n\n");
		
		formatf("+1V2: %3.6lf V\n", Telemetry->P1V2);
		formatf("+2V2: %3.6lf V\n", Telemetry->P2V2);
		formatf("+28V: %3.6lf V\n", Telemetry->P28V);
		formatf("+2V5: %3.6lf V\n", Telemetry->P2V5);
		formatf("+6V: %3.6lf V\n", Telemetry->P6V);
		formatf("+5V: %3.6lf V\n", Telemetry->P5V);
		formatf("+3V3D: %3.6lf V\n", Telemetry->P3V3D);
		formatf("+4V3: %3.6lf V\n", Telemetry->P4V3);
		formatf("+2I2: %3.6lf V\n", Telemetry->P2I2);
		formatf("+4I3: %3.6lf V\n", Telemetry->P4I3);
		formatf("+6I: %3.6lf V\n", Telemetry->P6I);
		
		formatf("\n\nBinaryFWTelemetryCommand Command complete.\n\n");
	}
	else
	{
		printf("\nBinaryFWTelemetryCommand: Short packet: %lu (exptected %lu bytes): ", (unsigned long)ParamsLen, (unsigned long)(sizeof(CGraphFWTelemetryPayload)));
	}
    return(ParamsLen);
}


int8_t BinaryFWFilterSelectCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (sizeof(uint32_t))) )
	{
		const uint32_t FilterSelect = *reinterpret_cast<const uint32_t*>(Params);
		printf("\nBinaryFWFilterSelectCommand: FilterSelected(0=select inprogress): %lu\n", (unsigned long)FilterSelect);
	}
	else
	{
		printf("\nBinaryFWFilterSelectCommand: Short packet: %lu (exptected %lu bytes): ", (unsigned long)ParamsLen, (unsigned long)(sizeof(uint32_t)));
	}
    return(ParamsLen);
}


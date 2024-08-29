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

#include "cgraph/CGraphFWHardwareInterface.hpp"

#include "CmdTableBinary.hpp"

CGraphFWHardwareControlRegister ControlRegister;
CGraphFWMotorControlStatusRegister MotorControlStatus;
CGraphFWPositionSenseRegister PositionSensors;

uint16_t PosSteps[48];
	
uint32_t FilterSelect = 0;

int8_t BinaryFWHardwareControlStatusCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
 formatf("\nBinaryFWHardwareControlStatusCommand: processing(%u)...\n\n", ParamsLen);
	
	if ( (NULL != Params) && (ParamsLen >= (sizeof(CGraphFWHardwareControlRegister))) )
	{
		const CGraphFWHardwareControlRegister* HCR = (const CGraphFWHardwareControlRegister*)Params;
		
		formatf("\nBinaryFWHardwareControlStatusCommand: Setting to ");
		HCR->formatf();
		formatf("\n");
		
		memcpy(&ControlRegister, HCR, sizeof(CGraphFWHardwareControlRegister));
	}
	
	formatf("\nBinaryFWHardwareControlStatusCommand: Replying: ");
	ControlRegister.formatf();
	formatf("\n");
		
	TxBinaryPacket(Argument, CGraphPayloadTypeFWHardwareControlStatus, 0, &(ControlRegister), sizeof(CGraphFWHardwareControlRegister));

	return(ParamsLen);
}

int8_t BinaryFWMotorControlStatusCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
 formatf("\nBinaryFWMotorControlStatusCommand: processing(%u)...\n\n", ParamsLen);
	
	if ( (NULL != Params) && (ParamsLen >= (sizeof(CGraphFWMotorControlStatusRegister))) )
	{
		const CGraphFWMotorControlStatusRegister* MCSR = (const CGraphFWMotorControlStatusRegister*)Params;
		
		formatf("\nBinaryFWMotorControlStatusCommand: Setting to ");
		MCSR->formatf();
		formatf("\n");
		
		memcpy(&MotorControlStatus, MCSR, sizeof(CGraphFWMotorControlStatusRegister));
	}
	
	formatf("\nBinaryFWMotorControlStatusCommand: Replying: ");
	MotorControlStatus.formatf();
	formatf("\n");
		
	TxBinaryPacket(Argument, CGraphPayloadTypeFWMotorControlStatus, 0, &(MotorControlStatus), sizeof(CGraphFWMotorControlStatusRegister));

    return(ParamsLen);
}

int8_t BinaryFWPositionSenseControlStatusCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	formatf("\nBinaryFWPositionSenseControlStatusCommand: processing(%u)...\n\n", ParamsLen);
	
	formatf("\nBinaryFWPositionSenseControlStatusCommand: Replying: ");
	PositionSensors.formatf();
	formatf("\n");
		
	TxBinaryPacket(Argument, CGraphPayloadTypeFWPositionSenseControlStatus, 0, &(PositionSensors), sizeof(CGraphFWPositionSenseRegister));

    return(ParamsLen);
}

int8_t BinaryFWPositionStepsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	formatf("\nBinaryFWPositionStepsCommand: processing(%u)...\n\n", ParamsLen);
	
	formatf("\nBinaryFWPositionStepsCommand: Replying: ");
	
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

	TxBinaryPacket(Argument, CGraphPayloadTypeFWPositionSteps, 0, PosSteps, 48 * sizeof(uint16_t));

    return(ParamsLen);
}


int8_t BinaryFWTelemetryCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	formatf("\nBinaryFWTelemetryADCCommand: processing(%u)...\n\n", ParamsLen);

	CGraphFWTelemetryPayload Status;
	
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

	formatf("\n\nBinaryFWTelemetryADCCommand: CurrentValues:\n\n");
	
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

	formatf("\nBinaryFWTelemetryADCCommand: Replying...\n");
	TxBinaryPacket(Argument, CGraphPayloadTypeFWTelemetry, 0, &Status, sizeof(CGraphFWTelemetryPayload));

	return(ParamsLen);
}


int8_t BinaryFWFilterSelectCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	formatf("\nBinaryFWFilterSelectCommand: processing(%u)...\n\n", ParamsLen);
	
	if ( (NULL != Params) && (ParamsLen >= (sizeof(uint32_t))) )
	{
		FilterSelect = *(const uint32_t*)Params;
		
		formatf("\nBinaryFWFilterSelectCommand: Setting to &lu\n", (unsigned long)FilterSelect);
		
		//Ok, we actually need to do something here!!
		//~ = FilterSelect;
	}
	
	//Ok, we actually need to do something here!!
	//Also need to return -1 for a delay to emulate while it's moving
	//~ FilterSelect = ???;
	
	formatf("\nBinaryFWFilterSelectCommand: Replying: %lu \n\n", (unsigned long)FilterSelect);
		
	TxBinaryPacket(Argument, CGraphPayloadTypeFWFilterSelect, 0, &FilterSelect, sizeof(uint32_t));

    return(ParamsLen);
}


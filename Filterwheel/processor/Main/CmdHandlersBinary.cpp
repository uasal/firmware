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
#include <unordered_map>
using namespace std;

#include "format/formatf.h"

#include "uart/BinaryUart.hpp"

#include "cgraph/CGraphPacket.hpp"

#include "cgraph/CGraphFWHardwareInterface.hpp"
extern CGraphFWHardwareInterface* FW;	

#include "../MonitorAdc.hpp"
extern CGraphFWMonitorAdc MonitorAdc;

#include "../FWBuildNum"

#include "CmdTableBinary.hpp"

int8_t BinaryVersionCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//(Don't validate version; always reply, even though it will cause a mess, so everyone knows we're here!)
	
    CGraphVersionPayload Version;
    Version.SerialNum = 0;
	Version.ProcessorFirmwareBuildNum = BuildNum;
	Version.FPGAFirmwareBuildNum = 0;
	if (FW) 
	{ 
		Version.SerialNum = FW->DeviceSerialNumber; 
		Version.FPGAFirmwareBuildNum = FW->FpgaFirmwareBuildNumber; 
	}
    formatf("\nBinaryVersionCommand: Sending response (%u bytes): ", sizeof(CGraphVersionPayload));
    Version.formatf();
    formatf("\n");
    TxBinaryPacket(Argument, CGraphPayloadTypeVersion, 0, &Version, sizeof(CGraphVersionPayload));
    return(ParamsLen);
}

int8_t BinaryFWHardwareControlStatusCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	formatf("\nBinaryFWHardwareControlStatusCommand: processing(%u)...\n\n", ParamsLen);
	
	if ( (NULL != Params) && (ParamsLen >= (sizeof(CGraphFWHardwareControlRegister))) )
	{
		const CGraphFWHardwareControlRegister* HCR = (const CGraphFWHardwareControlRegister*)Params;
		
		formatf("\nBinaryFWHardwareControlStatusCommand: Setting to ");
		HCR->formatf();
		formatf("\n");
		
		FW->ControlRegister = *HCR;	
	}
	
	formatf("\nBinaryFWHardwareControlStatusCommand: Replying: ");
	FW->ControlRegister.formatf();
	formatf("\n");
		
	TxBinaryPacket(Argument, CGraphPayloadTypeFWHardwareControlStatus, 0, &(FW->ControlRegister), sizeof(CGraphFWHardwareControlRegister));

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
		
		FW->MotorControlStatus = *MCSR;	
	}
	
	formatf("\nBinaryFWMotorControlStatusCommand: Replying: ");
	FW->MotorControlStatus.formatf();
	formatf("\n");
		
	TxBinaryPacket(Argument, CGraphPayloadTypeFWMotorControlStatus, 0, &(FW->MotorControlStatus), sizeof(CGraphFWMotorControlStatusRegister));

    return(ParamsLen);
}
	
int8_t BinaryFWPositionSenseControlStatusCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	formatf("\nBinaryFWPositionSenseControlStatusCommand: processing(%u)...\n\n", ParamsLen);
	
	formatf("\nBinaryFWPositionSenseControlStatusCommand: Replying: ");
	FW->PositionSensors.formatf();
	formatf("\n");
		
	TxBinaryPacket(Argument, CGraphPayloadTypeFWPositionSenseControlStatus, 0, &(FW->PositionSensors), sizeof(CGraphFWPositionSenseRegister));

    return(ParamsLen);
}

int8_t BinaryFWPositionStepsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	uint16_t PosSteps[48];
	
	formatf("\nBinaryFWPositionStepsCommand: processing(%u)...\n\n", ParamsLen);
	
	formatf("\nBinaryFWPositionStepsCommand: Replying: ");

	formatf("\nPosDetHomeA: "); FW->PosDetHomeA.formatf(); PosSteps[0] = FW->PosDetHomeA.OnStep; PosSteps[1] = FW->PosDetHomeA.OffStep;
	formatf("\nPosDetA0: "); FW->PosDetA0.formatf(); PosSteps[2] = FW->PosDetA0.OnStep; PosSteps[3] = FW->PosDetA0.OffStep;
	formatf("\nPosDetA1: "); FW->PosDetA1.formatf(); PosSteps[4] = FW->PosDetA1.OnStep; PosSteps[5] = FW->PosDetA1.OffStep;
	formatf("\nPosDetA2: "); FW->PosDetA2.formatf(); PosSteps[6] = FW->PosDetA2.OnStep; PosSteps[7] = FW->PosDetA2.OffStep;
	
	formatf("\nPosDetHomeB: "); FW->PosDetHomeB.formatf(); PosSteps[8] = FW->PosDetHomeB.OnStep; PosSteps[9] = FW->PosDetHomeB.OffStep;
	formatf("\nPosDetB0: "); FW->PosDetB0.formatf(); PosSteps[10] = FW->PosDetB0.OnStep; PosSteps[11] = FW->PosDetB0.OffStep;
	formatf("\nPosDetB1: "); FW->PosDetB1.formatf(); PosSteps[12] = FW->PosDetB1.OnStep; PosSteps[13] = FW->PosDetB1.OffStep;
	formatf("\nPosDetB2: "); FW->PosDetB2.formatf(); PosSteps[14] = FW->PosDetB2.OnStep; PosSteps[15] = FW->PosDetB2.OffStep;
	
	formatf("\nPosDet0A: "); FW->PosDet0A.formatf(); PosSteps[16] = FW->PosDet0A.OnStep; PosSteps[17] = FW->PosDet0A.OffStep;
	formatf("\nPosDet1A: "); FW->PosDet1A.formatf(); PosSteps[18] = FW->PosDet1A.OnStep; PosSteps[19] = FW->PosDet1A.OffStep;
	formatf("\nPosDet2A: "); FW->PosDet2A.formatf(); PosSteps[20] = FW->PosDet2A.OnStep; PosSteps[21] = FW->PosDet2A.OffStep;
	formatf("\nPosDet3A: "); FW->PosDet3A.formatf(); PosSteps[22] = FW->PosDet3A.OnStep; PosSteps[23] = FW->PosDet3A.OffStep;
	formatf("\nPosDet4A: "); FW->PosDet4A.formatf(); PosSteps[24] = FW->PosDet4A.OnStep; PosSteps[25] = FW->PosDet4A.OffStep;
	formatf("\nPosDet5A: "); FW->PosDet5A.formatf(); PosSteps[26] = FW->PosDet5A.OnStep; PosSteps[27] = FW->PosDet5A.OffStep;
	formatf("\nPosDet6A: "); FW->PosDet6A.formatf(); PosSteps[28] = FW->PosDet6A.OnStep; PosSteps[29] = FW->PosDet6A.OffStep;
	formatf("\nPosDet7A: "); FW->PosDet7A.formatf(); PosSteps[30] = FW->PosDet7A.OnStep; PosSteps[31] = FW->PosDet7A.OffStep;
	
	formatf("\nPosDet0B: "); FW->PosDet0B.formatf(); PosSteps[32] = FW->PosDet0B.OnStep; PosSteps[33] = FW->PosDet0B.OffStep;
	formatf("\nPosDet1B: "); FW->PosDet1B.formatf(); PosSteps[34] = FW->PosDet1B.OnStep; PosSteps[35] = FW->PosDet1B.OffStep;
	formatf("\nPosDet2B: "); FW->PosDet2B.formatf(); PosSteps[36] = FW->PosDet2B.OnStep; PosSteps[37] = FW->PosDet2B.OffStep;
	formatf("\nPosDet3B: "); FW->PosDet3B.formatf(); PosSteps[38] = FW->PosDet3B.OnStep; PosSteps[39] = FW->PosDet3B.OffStep;
	formatf("\nPosDet4B: "); FW->PosDet4B.formatf(); PosSteps[40] = FW->PosDet4B.OnStep; PosSteps[41] = FW->PosDet4B.OffStep;
	formatf("\nPosDet5B: "); FW->PosDet5B.formatf(); PosSteps[42] = FW->PosDet5B.OnStep; PosSteps[43] = FW->PosDet5B.OffStep;
	formatf("\nPosDet6B: "); FW->PosDet6B.formatf(); PosSteps[44] = FW->PosDet6B.OnStep; PosSteps[45] = FW->PosDet6B.OffStep;
	formatf("\nPosDet7B: "); FW->PosDet7B.formatf(); PosSteps[46] = FW->PosDet7B.OnStep; PosSteps[47] = FW->PosDet7B.OffStep;
	
	TxBinaryPacket(Argument, CGraphPayloadTypeFWPositionSteps, 0, PosSteps, 48 * sizeof(uint16_t));

    return(ParamsLen);
}

int8_t BinaryFWTelemetryADCCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	formatf("\nBinaryFWTelemetryADCCommand: processing(%u)...\n\n", ParamsLen);

	CGraphFWTelemetryADCPayload Status;
	
	Status.P1V2 = MonitorAdc.GetP1V2();
	Status.P2V2 = MonitorAdc.GetP2V2();
	Status.P28V = MonitorAdc.GetP28V();
	Status.P2V5 = MonitorAdc.GetP2V5();
	Status.P6V = MonitorAdc.GetP6V();
	Status.P5V = MonitorAdc.GetP5V();
	Status.P3V3D = MonitorAdc.GetP3V3D();
	Status.P4V3 = MonitorAdc.GetP4V3();
	Status.P2I2 = MonitorAdc.GetP2I2();
	Status.P4I3 = MonitorAdc.GetP4I3();
	Status.P6I = MonitorAdc.GetP6I();

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
	TxBinaryPacket(Argument, CGraphPayloadTypeFWTelemetryADC, 0, &Status, sizeof(CGraphFWTelemetryADCPayload));

	return(ParamsLen);
}

int8_t BinaryFWFilterSelectCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	uint32_t FilterSelect = 0;
	
	formatf("\nBinaryFWFilterSelectCommand: processing(%u)...\n\n", ParamsLen);
	
	if ( (NULL != Params) && (ParamsLen >= (sizeof(uint32_t))) )
	{
		FilterSelect = *(const uint32_t*)Params;
		
		formatf("\nBinaryFWFilterSelectCommand: Setting to &lu\n", (unsigned long)FilterSelect);
		
		//Ok, we actually need to do something here!!
		//~ = FilterSelect;
	}
	
	//Ok, we actually need to do something here!!
	//~ FilterSelect = ;
	
	formatf("\nBinaryFWFilterSelectCommand: Replying: %lu \n\n", (unsigned long)FilterSelect);
		
	TxBinaryPacket(Argument, CGraphPayloadTypeFWFilterSelect, 0, &FilterSelect, sizeof(uint32_t));

    return(ParamsLen);
}


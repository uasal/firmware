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

#include "uart/BinaryUart.hpp"

#include "uart/CGraphPacket.hpp"

#include "cgraph/CGraphFWHardwareInterface.hpp"
extern CGraphFWHardwareInterface* FW;	

//#include "../MonitorAdc.hpp"
//extern CGraphFWMonitorAdc MonitorAdc;

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
    Version.printf();
    formatf("\n");
    TxBinaryPacket(Argument, CGraphPayloadTypeVersion, 0, &Version, sizeof(CGraphVersionPayload));
    return(ParamsLen);
}

int8_t BinaryFWDacsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//~ formatf("\nBinaryFWDacsCommand processing(%u)...\n\n", ParamsLen);
	
	//~ if (ValidateZenBinaryRfPacket(SerialNum, Params, ParamsLen))
	//~ {
		//~ GlobalSave();
		//~ TxBinaryResponsePacket(Argument, PayloadTypeGlobalSave, SerialNum, 0, 0);
	//~ }
    //~ return(ParamsLen);
	
	//~ if (ParamsLen >= (3 * sizeof(uint32_t)))
	//~ {
		//~ //const ZongeProtocolFilenameParam PacketData = *((const ZongeProtocolFilenameParam*)ZenBinaryPacketHeader::PayloadDataPointerFromSerialNumberOffsetPointer(Params));
		//~ const uint32_t* DacSetpoints = (const uint32_t*)Params;
		//~ formatf("\nBinaryFWDacsCommand Setting to (0x%X, 0x%X, 0x%X).\n\n", DacSetpoints[0], DacSetpoints[1], DacSetpoints[2]);
		//~ FW->DacASetpoint = DacSetpoints[0];
		//~ FW->DacBSetpoint = DacSetpoints[1];
		//~ FW->DacCSetpoint = DacSetpoints[2];		
	//~ }
	//~ uint32_t DacSetpoints[3];
	//~ DacSetpoints[0] = FW->DacASetpoint;
	//~ DacSetpoints[1] = FW->DacBSetpoint;
	//~ DacSetpoints[2] = FW->DacCSetpoint;	
	//~ formatf("\nBinaryFWDacsCommand  Replying (0x%X, 0x%X, 0x%X)...\n\n", DacSetpoints[0], DacSetpoints[1], DacSetpoints[2]);
	//~ TxBinaryPacket(Argument, CGraphPayloadTypeFWDacs, 0, DacSetpoints, 3 * sizeof(uint32_t));

    return(ParamsLen);
}

int8_t BinaryFWAdcsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//~ AdcAccumulator AdcVals[3];	
	//~ AdcVals[0] = FW->AdcAAccumulator;
	//~ AdcVals[1] = FW->AdcBAccumulator;
	//~ AdcVals[2] = FW->AdcCAccumulator;	
	//~ formatf("\nBinaryFWAdcsCommand  Replying (%lld, %lld, %lld)...\n\n", AdcVals[0].Samples, AdcVals[1].Samples, AdcVals[2].Samples);
	//~ TxBinaryPacket(Argument, CGraphPayloadTypeFWAdcs, 0, AdcVals, 3 * sizeof(AdcAccumulator));
    return(ParamsLen);
}
	
int8_t BinaryFWAdcsFloatingPointCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	formatf("\nBinaryFWAdcsCommand processing(%u)...\n\n", ParamsLen);
	
	//~ double AdcVals[3];
	//~ AdcAccumulator A, B, C;
	//~ A = FW->AdcAAccumulator;
	//~ B = FW->AdcBAccumulator;
	//~ C = FW->AdcCAccumulator;
	//~ AdcVals[0] = (8.192 * ((A.Samples - 0) / A.NumAccums)) / 16777216.0;
	//~ AdcVals[1] = (8.192 * ((B.Samples - 0) / B.NumAccums)) / 16777216.0;
	//~ AdcVals[2] = (8.192 * ((C.Samples - 0) / C.NumAccums)) / 16777216.0;
	//~ formatf("\nBinaryFWAdcsFloatingPointCommand  Replying (%lf, %lf, %lf)...\n\n", AdcVals[0], AdcVals[1], AdcVals[2]);
	//~ TxBinaryPacket(Argument, CGraphPayloadTypeFWAdcsFloatingPoint, 0, AdcVals, 3 * sizeof(double));

    return(ParamsLen);
}

int8_t BinaryFWDacsFloatingPointCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//~ double VA = 0.0, VB = 0.0, VC = 0.0;	
	//~ unsigned long A = 0, B = 0, C = 0;	
	
	//~ formatf("\nBinaryFWDacsFloatingPointCommand processing(%u)...\n\n", ParamsLen);
	
	//~ if (ValidateZenBinaryRfPacket(SerialNum, Params, ParamsLen))
	//~ {
		//~ GlobalSave();
		//~ TxBinaryResponsePacket(Argument, PayloadTypeGlobalSave, SerialNum, 0, 0);
	//~ }
    //~ return(ParamsLen);
	
	//~ if (ParamsLen >= (3 * sizeof(double)))
	//~ {
		//~ const double* DacSetpoints = (const double*)Params;
		
		//~ VA = DacSetpoints[0];
		//~ VB = DacSetpoints[1];
		//~ VC = DacSetpoints[2];
		
		//~ A = (VA * (double)(0x00FFFFFFUL) * 60.0) / 4.096;
		//~ B = (VB * (double)(0x00FFFFFFUL) * 60.0) / 4.096;
		//~ C = (VC * (double)(0x00FFFFFFUL) * 60.0) / 4.096;
		
		//~ formatf("\n\nBinaryFWDacsCommand: Setting to: %3.1lf (%lx), %3.1lf (%lx), %3.1lf (%lx).\n", VA, A, VB, B, VC, C);
		
		//~ FW->DacASetpoint = DacSetpoints[0];
		//~ FW->DacBSetpoint = DacSetpoints[1];
		//~ FW->DacCSetpoint = DacSetpoints[2];		
	//~ }
	
	//~ uint32_t DacSetpoints[3];
	
	//~ A = FW->DacASetpoint;
	//~ B = FW->DacBSetpoint;
	//~ C = FW->DacCSetpoint;	
	
	//~ VA = 4.096 * (double)(A) / ((double)(0x00FFFFFFUL) * 60.0);
	//~ VB = 4.096 * (double)(B) / ((double)(0x00FFFFFFUL) * 60.0);
	//~ VC = 4.096 * (double)(C) / ((double)(0x00FFFFFFUL) * 60.0);
	
	//~ DacSetpoints[0] = VA;
	//~ DacSetpoints[1] = VB;
	//~ DacSetpoints[2] = VC;	
	
	//~ formatf("\n\nBinaryFWDacsCommand: Replying: %3.1lf (%lx), %3.1lf (%lx), %3.1lf (%lx).\n", VA, A, VB, B, VC, C);
	//~ TxBinaryPacket(Argument, CGraphPayloadTypeFWDacs, 0, DacSetpoints, 3 * sizeof(double));

    return(ParamsLen);
}

int8_t BinaryFWStatusCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//~ CGraphFWStatusPayload Status;
	
	//~ Status.P1V2 = MonitorAdc.GetP1V2();
	//~ Status.P2V2 = MonitorAdc.GetP2V2();
	//~ Status.P24V = MonitorAdc.GetP24V();
	//~ Status.P2V5 = MonitorAdc.GetP2V5();
	//~ Status.P3V3A = MonitorAdc.GetP3V3A();
	//~ Status.P6V = MonitorAdc.GetP6V();
	//~ Status.P5V = MonitorAdc.GetP5V();
	//~ Status.P3V3D = MonitorAdc.GetP3V3D();
	//~ Status.P4V3 = MonitorAdc.GetP4V3();
	//~ Status.N5V = MonitorAdc.GetN5V();
	//~ Status.N6V = MonitorAdc.GetN6V();
	//~ Status.P150V = MonitorAdc.GetP150V();

	//~ formatf("\n\nBinaryFWStatusCommand: CurrentValues:\n\n");
	
	//~ formatf("P1V2: %3.6lf V\n", Status.P1V2);
	//~ formatf("P2V2: %3.6lf V\n", Status.P2V2);
	//~ formatf("P24V: %3.6lf V\n", Status.P24V);
	//~ formatf("P2V5: %3.6lf V\n", Status.P2V5);
	//~ formatf("P3V3A: %3.6lf V\n", Status.P3V3A);
	//~ formatf("P6V: %3.6lf V\n", Status.P6V);
	//~ formatf("P5V: %3.6lf V\n", Status.P5V);
	//~ formatf("P3V3D: %3.6lf V\n", Status.P3V3D);
	//~ formatf("P4V3: %3.6lf V\n", Status.P4V3);
	//~ formatf("N5V: %3.6lf V\n", Status.N5V);
	//~ formatf("N6V: %3.6lf V\n", Status.N6V);
	//~ formatf("P150V: %3.6lf V\n", Status.P150V);

	
	//~ formatf("\nBinaryFWStatusCommand: Replying...\n");
	//~ TxBinaryPacket(Argument, CGraphPayloadTypeFWStatus, 0, &Status, sizeof(CGraphFWStatusPayload));

	return(ParamsLen);
}

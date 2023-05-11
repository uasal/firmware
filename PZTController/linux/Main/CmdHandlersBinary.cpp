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

#include "CGraphFSMHardwareInterface.hpp"
extern CGraphFSMHardwareInterface* FSM;	

#include "../PZTBuildNum"

#include "CmdTableBinary.hpp"

int8_t BinaryVersionCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//(Don't validate version; always reply, even though it will cause a mess, so everyone knows we're here!)
	
    CGraphVersionPayload Version;
    Version.SerialNum = 0;
	Version.ProcessorFirmwareBuildNum = BuildNum;
	Version.FPGAFirmwareBuildNum = 0;
	if (FSM) 
	{ 
		Version.SerialNum = FSM->DeviceSerialNumber; 
		Version.FPGAFirmwareBuildNum = FSM->FpgaFirmwareBuildNumber; 
	}
    printf("\nBinaryVersionCommand: Sending response (%u bytes): ", sizeof(CGraphVersionPayload));
    Version.formatf();
    printf("\n");
    TxBinaryPacket(Argument, CGraphPayloadTypeVersion, 0, &Version, sizeof(CGraphVersionPayload));
    return(ParamsLen);
}

int8_t BinaryPZTDacsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//~ printf("\nBinaryPZTDacsCommand processing(%u)...\n\n", ParamsLen);
	
	//~ if (ValidateZenBinaryRfPacket(SerialNum, Params, ParamsLen))
	//~ {
		//~ GlobalSave();
		//~ TxBinaryResponsePacket(Argument, PayloadTypeGlobalSave, SerialNum, 0, 0);
	//~ }
    //~ return(ParamsLen);
	
	//~ if (sizeof(ZongeProtocolFilenameParam) <= ZenBinaryPacketHeader::PayloadLengthFromSerialNumberOffsetPointer(Params))
	if (ParamsLen >= (3 * sizeof(uint32_t)))
	{
		//~ const ZongeProtocolFilenameParam PacketData = *((const ZongeProtocolFilenameParam*)ZenBinaryPacketHeader::PayloadDataPointerFromSerialNumberOffsetPointer(Params));
		const uint32_t* DacSetpoints = (const uint32_t*)Params;
		printf("\nBinaryPZTDacsCommand Setting to (0x%X, 0x%X, 0x%X).\n\n", DacSetpoints[0], DacSetpoints[1], DacSetpoints[2]);
		FSM->DacASetpoint = DacSetpoints[0];
		FSM->DacBSetpoint = DacSetpoints[1];
		FSM->DacCSetpoint = DacSetpoints[2];		
	}
	uint32_t DacSetpoints[3];
	DacSetpoints[0] = FSM->DacASetpoint;
	DacSetpoints[1] = FSM->DacBSetpoint;
	DacSetpoints[2] = FSM->DacCSetpoint;	
	printf("\nBinaryPZTDacsCommand  Replying (0x%X, 0x%X, 0x%X)...\n\n", DacSetpoints[0], DacSetpoints[1], DacSetpoints[2]);
	TxBinaryPacket(Argument, CGraphPayloadTypePZTDacs, 0, DacSetpoints, 3 * sizeof(uint32_t));

    return(ParamsLen);
}

int8_t BinaryPZTAdcsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	AdcAccumulator AdcVals[3];	
	AdcVals[0] = FSM->AdcAAccumulator;
	AdcVals[1] = FSM->AdcBAccumulator;
	AdcVals[2] = FSM->AdcCAccumulator;	
	printf("\nBinaryPZTAdcsCommand  Replying (%lld, %lld, %lld)...\n\n", AdcVals[0].Samples, AdcVals[1].Samples, AdcVals[2].Samples);
	TxBinaryPacket(Argument, CGraphPayloadTypePZTAdcs, 0, AdcVals, 3 * sizeof(AdcAccumulator));
    return(ParamsLen);
}
	
int8_t BinaryPZTAdcsFloatingPointCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\nBinaryPZTAdcsCommand processing(%u)...\n\n", ParamsLen);
	
	double AdcVals[3];
	AdcAccumulator A, B, C;
	A = FSM->AdcAAccumulator;
	B = FSM->AdcBAccumulator;
	C = FSM->AdcCAccumulator;
	AdcVals[0] = (8.192 * ((A.Samples - 0) / A.NumAccums)) / 16777216.0;
	AdcVals[1] = (8.192 * ((B.Samples - 0) / B.NumAccums)) / 16777216.0;
	AdcVals[2] = (8.192 * ((C.Samples - 0) / C.NumAccums)) / 16777216.0;
	printf("\nBinaryPZTAdcsFloatingPointCommand  Replying (%lf, %lf, %lf)...\n\n", AdcVals[0], AdcVals[1], AdcVals[2]);
	TxBinaryPacket(Argument, CGraphPayloadTypePZTAdcsFloatingPoint, 0, AdcVals, 3 * sizeof(double));

    return(ParamsLen);
}

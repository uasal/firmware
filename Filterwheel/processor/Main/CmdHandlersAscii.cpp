//
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
/// \file
/// $Source: /raincloud/src/clients/UACGraph/Zeus/Zeus3/firmware/arm/main/CmdHandlersConfig.cpp,v $
/// $Revision: 1.7 $
/// $Date: 2010/06/08 23:51:10 $
/// $Author: summer $

#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <inttypes.h>
//offsetof:
#include <cstddef>

#include <unordered_map>
using namespace std;

#include "Delay.h"

#include "uart/BinaryUart.hpp"

#include "uart/CGraphPacket.hpp"

#include "cgraph/CGraphFWHardwareInterface.hpp"
extern int MmapHandle;
extern CGraphFWHardwareInterface* FW;	

#include "../MonitorAdc.hpp"
extern CGraphFWMonitorAdc MonitorAdc;

#include "../FWBuildNum"

extern BinaryUart FpgaUartParser2;
extern BinaryUart FpgaUartParser1;
//~ extern BinaryUart FpgaUartParser0;

char Buffer[4096];

int8_t ExitCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{

	formatf("\n\nExitCommand: Goodbye!\n\n\n\n");
	
	return(ParamsLen);
}

int8_t GlobalSaveCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//GlobalSave provides all needed formatf's:
	//~ GlobalSave();

	return(ParamsLen);
}

int8_t GlobalRestoreCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//GlobalRestore provides all needed formatf's:
	//~ GlobalRestore();

	return(ParamsLen);
}

int8_t ParseConfigFileCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	formatf("\n\nParseConfigFile: opening %s to parse...\n", &(Params[1]));

	return(ParamsLen);
}

int8_t VersionCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if (NULL != FW)
	{
		//formatf("\n\nVersion: Serial Number: %.8X, Global Revision: %s; build number: %u on: %s; fpga build: %u.\n", FW->DeviceSerialNumber, GITVERSION, BuildNum, BuildTimeStr, FW->FpgaFirmwareBuildNumber);
	}
	else
	{
		//formatf("\n\nVersion: Global Revision: %s; build number: %u on: %s.\n", GITVERSION, BuildNum, BuildTimeStr);
	}
	
    return(strlen(Params));
}

int8_t InitFpgaCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	formatf("\n\nInitFpga: Initializing...");
	
	MonitorAdc.Init();
	
	return(ParamsLen);
}

int8_t DeInitFpgaCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	formatf("\n\nDeInitFpga: De-initializing...");
	
	return(ParamsLen);
}

int8_t ReadFpgaCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	uint8_t Buffer;

	//Convert parameter to an integer
    size_t addr = 0;
	int8_t numfound = sscanf(Params, "%zX", &addr);
    if (numfound < 1)
    {
		formatf("\nReadFpgaCommand: ");
		//~ for (addr = 0; addr <= 64; addr++)
		for (addr = 0; addr <= 128; addr++)
		{
			Buffer = *(((uint8_t*)FW)+addr);
			formatf("\n0x%.2zX: 0x%.2X ", addr, Buffer);
			formatf("[%u]", Buffer);
			//~ formatf(" ('%c')", Buffer);
		}	
		formatf("\n\n");
    }
	else
	{
		Buffer = *(((uint8_t*)FW)+addr);
		formatf("\nReadFpgaCommand: ");
		//~ formatf("\n%zu: 0x%.2X ", addr, Buffer);
		formatf("\n0x%.2zX: 0x%.2X ", addr, Buffer);
		formatf("[%u]", Buffer);
		formatf(" ('%c')\n\n", Buffer);
	}
	
	return(ParamsLen);
}

int8_t WriteFpgaCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//Convert parameter to an integer
	size_t addr = 0;
    unsigned long val = 0;
    int8_t numfound = sscanf(Params, "%zX %lu", &addr, &val);
    if (numfound < 2)
    {
		formatf("\nWriteFpgaCommand: need 2 numeric parameters (address and value), got \"%s\" (%d params).\n", Params, numfound);
        return(-1);
    }

	//Write data to fpga:
	*(((uint8_t*)FW)+addr) = (uint8_t)val;

	formatf("\nWriteFpgaCommand: Wrote %lu to ", val);
	formatf("0x%.4zX.\n", addr);
	
	return(ParamsLen);
}


int8_t FWStatusCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	CGraphFWHardwareControlRegister HCR;
	CGraphFWMotorControlStatusRegister MCSR;
	CGraphFWPositionSenseRegister PSR;
	
	if (NULL == FW)
	{
		formatf("\n\nFWStatusCommand: Fpga interface is not initialized! Please call InitFpga first!.");
		return(ParamsLen);
	}
	
	formatf("\n\nFWStatusCommand: Offset of MotorControlStatus: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFWHardwareInterface, MotorControlStatus), 32UL);
	formatf("\nFWStatusCommand: Offset of PositionSensors: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFWHardwareInterface, PositionSensors), 36UL);
	formatf("\nFWStatusCommand: Offset of ControlRegister: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFWHardwareInterface, ControlRegister), 88UL);
	
	HCR = FW->ControlRegister;
	MCSR = FW->MotorControlStatus;
	PSR = FW->PositionSensors;
    
	formatf("\n\nFWStatusCommand: current values:\n");
	HCR.printf();
	formatf("\n");
	MCSR.printf();
	formatf("\n");
	PSR.printf();
	formatf("\n");
	formatf("\n");
	
    return(ParamsLen);
}

int8_t SensorStepsCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if (NULL == FW)
	{
		formatf("\n\nSensorStepsCommand: Fpga interface is not initialized! Please call InitFpga first!.");
		return(ParamsLen);
	}
	
	formatf("\n\nSensorStepsCommand: Offset of first Sensor Step: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFWHardwareInterface, PosDetHomeAOnStep), 148UL);
	formatf("\nSensorStepsCommand: Offset of last Sensor Step: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFWHardwareInterface, PosDet7BOffStep), 240UL);
	
	formatf("\n\nSensorStepsCommand: current values:\n");
	
	formatf("\nPosDetHomeAOnStep: %lu", (unsigned long)FW->PosDetHomeAOnStep);
	formatf("\nPosDetHomeAOffStep: %lu", (unsigned long)FW->PosDetHomeAOffStep);
	formatf("\nPosDetA0OnStep: %lu", (unsigned long)FW->PosDetA0OnStep);
	formatf("\nPosDetA0OffStep: %lu", (unsigned long)FW->PosDetA0OffStep);
	formatf("\nPosDetA1OnStep: %lu", (unsigned long)FW->PosDetA1OnStep);
	formatf("\nPosDetA1OffStep: %lu", (unsigned long)FW->PosDetA1OffStep);
	formatf("\nPosDetA2OnStep: %lu", (unsigned long)FW->PosDetA2OnStep);
	formatf("\nPosDetA2OffStep: %lu", (unsigned long)FW->PosDetA2OffStep);
	
	formatf("\nPosDetHomeBOnStep: %lu", (unsigned long)FW->PosDetHomeBOnStep);
	formatf("\nPosDetHomeBOffStep: %lu", (unsigned long)FW->PosDetHomeBOffStep);
	formatf("\nPosDetB0OnStep: %lu", (unsigned long)FW->PosDetB0OnStep);
	formatf("\nPosDetB0OffStep: %lu", (unsigned long)FW->PosDetB0OffStep);
	formatf("\nPosDetB1OnStep: %lu", (unsigned long)FW->PosDetB1OnStep);
	formatf("\nPosDetB1OffStep: %lu", (unsigned long)FW->PosDetB1OffStep);
	formatf("\nPosDetB2OnStep: %lu", (unsigned long)FW->PosDetB2OnStep);
	formatf("\nPosDetB2OffStep: %lu", (unsigned long)FW->PosDetB2OffStep);
	
	formatf("\nPosDet0AOnStep: %lu", (unsigned long)FW->PosDet0AOnStep);
	formatf("\nPosDet0AOffStep: %lu", (unsigned long)FW->PosDet0AOffStep);
	formatf("\nPosDet1AOnStep: %lu", (unsigned long)FW->PosDet1AOnStep);
	formatf("\nPosDet1AOffStep: %lu", (unsigned long)FW->PosDet1AOffStep);
	formatf("\nPosDet2AOnStep: %lu", (unsigned long)FW->PosDet2AOnStep);
	formatf("\nPosDet2AOffStep: %lu", (unsigned long)FW->PosDet2AOffStep);
	formatf("\nPosDet3AOnStep: %lu", (unsigned long)FW->PosDet3AOnStep);
	formatf("\nPosDet3AOffStep: %lu", (unsigned long)FW->PosDet3AOffStep);
	formatf("\nPosDet4AOnStep: %lu", (unsigned long)FW->PosDet4AOnStep);
	formatf("\nPosDet4AOffStep: %lu", (unsigned long)FW->PosDet4AOffStep);
	formatf("\nPosDet5AOnStep: %lu", (unsigned long)FW->PosDet5AOnStep);
	formatf("\nPosDet5AOffStep: %lu", (unsigned long)FW->PosDet5AOffStep);
	formatf("\nPosDet6AOnStep: %lu", (unsigned long)FW->PosDet6AOnStep);
	formatf("\nPosDet6AOffStep: %lu", (unsigned long)FW->PosDet6AOffStep);
	formatf("\nPosDet7AOnStep: %lu", (unsigned long)FW->PosDet7AOnStep);
	formatf("\nPosDet7AOffStep: %lu", (unsigned long)FW->PosDet7AOffStep);
	
	formatf("\nPosDet0BOnStep: %lu", (unsigned long)FW->PosDet0BOnStep);
	formatf("\nPosDet0BOffStep: %lu", (unsigned long)FW->PosDet0BOffStep);
	formatf("\nPosDet1BOnStep: %lu", (unsigned long)FW->PosDet1BOnStep);
	formatf("\nPosDet1BOffStep: %lu", (unsigned long)FW->PosDet1BOffStep);
	formatf("\nPosDet2BOnStep: %lu", (unsigned long)FW->PosDet2BOnStep);
	formatf("\nPosDet2BOffStep: %lu", (unsigned long)FW->PosDet2BOffStep);
	formatf("\nPosDet3BOnStep: %lu", (unsigned long)FW->PosDet3BOnStep);
	formatf("\nPosDet3BOffStep: %lu", (unsigned long)FW->PosDet3BOffStep);
	formatf("\nPosDet4BOnStep: %lu", (unsigned long)FW->PosDet4BOnStep);
	formatf("\nPosDet4BOffStep: %lu", (unsigned long)FW->PosDet4BOffStep);
	formatf("\nPosDet5BOnStep: %lu", (unsigned long)FW->PosDet5BOnStep);
	formatf("\nPosDet5BOffStep: %lu", (unsigned long)FW->PosDet5BOffStep);
	formatf("\nPosDet6BOnStep: %lu", (unsigned long)FW->PosDet6BOnStep);
	formatf("\nPosDet6BOffStep: %lu", (unsigned long)FW->PosDet6BOffStep);
	formatf("\nPosDet7BOnStep: %lu", (unsigned long)FW->PosDet7BOnStep);
	formatf("\nPosDet7BOffStep: %lu", (unsigned long)FW->PosDet7BOffStep);
	
	return(ParamsLen);	
}

int8_t MotorCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	CGraphFWMotorControlStatusRegister MCSR;
	unsigned long SeekStep;
	
	if (NULL == FW)
	{
		formatf("\n\nMotorCommand: Fpga interface is not initialized! Please call InitFpga first!.");
		return(ParamsLen);
	}
	
	//Convert parameters
    int8_t numfound = sscanf(Params, "%lu", &SeekStep);
    if (numfound >= 1)
    {
		MCSR.SeekStep = SeekStep;
		FW->MotorControlStatus = MCSR;		
		formatf("\n\nMotorCommand: set to: %lu\n", SeekStep);
    }
	
	MCSR = FW->MotorControlStatus;
	
	formatf("\n\nMotorCommand: current values:\n");
	MCSR.printf();
	formatf("\n");
	
	return(ParamsLen);
}

int8_t BISTCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	size_t cycle = 0;
	//~ unsigned long daca = 0;
	int key = 1;
	
	while(true)
	{
		cycle++;
		
		//~ //Show current A/D values:
		//~ {
			//~ AdcAccumulator A, B, C;
			//~ A = FW->AdcAAccumulator;
			//~ B = FW->AdcBAccumulator;
			//~ C = FW->AdcCAccumulator;

			//~ double Av, Bv, Cv;
			//~ Av = (4.096 * ((A.Samples - 0) / A.NumAccums)) / 8388608.0;
			//~ Bv = (4.096 * ((B.Samples - 0) / B.NumAccums)) / 8388608.0;
			//~ Cv = (4.096 * ((C.Samples - 0) / C.NumAccums)) / 8388608.0;
			
			//~ formatf("\n\nBIST: current A/D values: 0x%016llx, 0x%016llx, 0x%016llx; %+lld(%u), %+lld(%u), %+lld(%u), %+1.3lf, %+1.3lf, %+1.3lf; %u, %u, %u.\n", A.all, B.all, C.all, A.Samples, A.NumAccums, B.Samples, B.NumAccums, C.Samples, C.NumAccums, Av, Bv, Cv, offsetof(CGraphFWHardwareInterface, AdcAAccumulator), offsetof(CGraphFWHardwareInterface, AdcBAccumulator), offsetof(CGraphFWHardwareInterface, AdcCAccumulator));
		//~ }
		
		//~ //Update the D/A's every so often
		//~ if (0 == cycle % 4)
		//~ {
			//~ FW->DacASetpoint = daca;
			//~ //FW->DacBSetpoint = daca;
			//~ FW->DacBSetpoint = 0x00CFFFFFUL;
			//~ FW->DacCSetpoint = daca;
			//~ formatf("\n\nBIST: D/A's set to: %lx.\n", daca);	

			//~ switch(daca)
			//~ {
				//~ case 0x00000000UL: { daca = 0x002FFFFFUL; break; }
				//~ case 0x003FFFFFUL: { daca = 0x006FFFFFUL; break; }
				//~ case 0x007FFFFFUL: { daca = 0x009FFFFFUL; break; }
				//~ case 0x00BFFFFFUL: { daca = 0x00CFFFFFUL; break; }
				//~ default: { daca = 0; break; }
			//~ }
		//~ }
		
		//Show the monitor A/D
		{
			size_t j = cycle % 12;
			switch(j)
			{
				case 0: { formatf("P1V2: %3.6lf V\n", MonitorAdc.GetP1V2()); break; }
				case 1: { formatf("P2V2: %3.6lf V\n", MonitorAdc.GetP2V2()); break; }
				case 2: { formatf("P28V: %3.6lf V\n", MonitorAdc.GetP28V()); break; }
				case 3: { formatf("P2V5: %3.6lf V\n", MonitorAdc.GetP2V5()); break; }
				case 5: { formatf("P6V: %3.6lf V\n", MonitorAdc.GetP6V()); break; }
				case 6: { formatf("P5V: %3.6lf V\n", MonitorAdc.GetP5V()); break; }
				case 7: { formatf("P3V3D: %3.6lf V\n", MonitorAdc.GetP3V3D()); break; }
				case 8: { formatf("P4V3: %3.6lf V\n", MonitorAdc.GetP4V3()); break; }
				default : { }
			}
		}
		
		//Quit on any keypress
		{

			if (0 != key) 
			{ 
				fflush(stdin);
				formatf("\n\nBIST: Keypress(%d); exiting.\n", key);
				break; 
			}			
		}

		delayus(100000000);
	}
	
	return(ParamsLen);
}

int8_t UartCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	struct timespec sleeptime;
	memset((char *)&sleeptime,0,sizeof(sleeptime));
	sleeptime.tv_nsec = 1000000;
	sleeptime.tv_sec = 0;
	int key = 1;
	
	//Convert parameter to an integer
	//~ size_t addr = 0;
    //~ unsigned long val = 0;
    //~ int8_t numfound = sscanf(Params, "%zX %lu", &addr, &val);
    //~ if (numfound < 2)
    //~ {
		//~ formatf("\nUartCommand: need 2 numeric parameters (address and value), got \"%s\" (%d params).\n", Params, numfound);
        //~ return(-1);
    //~ }
	//~ char* cmd = 0;
	//~ char* params = 0;
	//~ int8_t numfound = sscanf(Params, "%s %s", cmd, params);
	//~ if (numfound < 2)
    //~ {
		//~ formatf("\nUartCommand: need 2 numeric parameters (address and value), got \"%s\" (%d params).\n", Params, numfound);
        //~ return(-1);
    //~ }
	
	//~ formatf("\nUartCommand: FW@0x%p, USR@%u, UF@%u, MAA@%u, ACF@%u, ACF is %u, ", (void*)FW, offsetof(CGraphFWHardwareInterface, UartStatusRegister), offsetof(CGraphFWHardwareInterface, UartFifo), offsetof(CGraphFWHardwareInterface, MonitorAdcAccumulator), offsetof(CGraphFWHardwareInterface, AdcCFifo), sizeof(AdcFifo));
	formatf("\nUartCommand: %u, %u. ", offsetof(CGraphFWHardwareInterface, UartFifo2), offsetof(CGraphFWHardwareInterface, UartStatusRegister2));
	
	if (0 == strncmp(&(Params[1]), "loop", 4))
	{
		while(true)
		{
			//~ FW->UartFifo0 = 0x55;
			//~ FW->UartFifo1 = 0x55;	
			FW->UartFifo2 = 0x55;
			
			//Quit on any keypress
			{
				if (0 != key) 
				{ 
					fflush(stdin);
					formatf("\n\nCircles: Keypress(%d); exiting.\n", key);
					break; 
				}			
			}
		}
	}
	
	//~ CGraphFWUartStatusRegister UartStatus = FW->UartStatusRegister2;
	//~ UartStatus.printf();	
	
	//~ formatf("; about to write to uart... ");	
	//~ FW->UartFifo = 'H';
	//~ nanosleep(&sleeptime, NULL);
	//~ FW->UartFifo = 'e';
	//~ nanosleep(&sleeptime, NULL);
	//~ FW->UartFifo = 'l';
	//~ nanosleep(&sleeptime, NULL);
	//~ FW->UartFifo = 'l';
	//~ nanosleep(&sleeptime, NULL);
	//~ FW->UartFifo = 'o';
	//~ nanosleep(&sleeptime, NULL);
	//~ FW->UartFifo = '!';
	//~ nanosleep(&sleeptime, NULL);
	
	//~ UartStatus = FW->UartStatusRegister; 
	//~ formatf("; uart written; ");	
	//~ UartStatus.printf();	
	
	//~ CGraphFWUartStatusRegister UartStatus2;
	
	//~ for(size_t i = 0; i < 100000; i++)
	//~ { 
		//~ UartStatus = FW->UartStatusRegister; 
		//~ if (0 == UartStatus.Uart2TxFifoEmpty) { break; }
	//~ }
	
	//~ formatf("\nUartCommand: about to read...");
	//~ UartStatus.printf();	
	//~ formatf("; reading from uart... ");
	
	//~ for (size_t i = 0; i < 1024; i++)
	//~ {
		//~ FpgaUartParser.Process();
	//~ }
		
	
	//~ for(size_t i = 0; i < 128; i++)
	//~ for(size_t i = 0; i < 4096; i++)
	//~ {
		//~ if (0 != UartStatus.Uart2RxFifoEmpty) { break; }
		//~ formatf(":%.2X", FW->UartFifo);
		//~ UartStatus = FW->UartStatusRegister; 		
	//~ }
	
	//~ {
		//~ //clear buffer:
		//~ FW->UartStatusRegister.all = 1;
	//~ }
	
	//~ formatf(":%.4X", FW->UartFifo2);
	
	//~ formatf("\n");
	//~ UartStatus.printf();	
	
	CGraphVersionPayload Version;
    Version.SerialNum = 0;
	Version.ProcessorFirmwareBuildNum = BuildNum;
	Version.FPGAFirmwareBuildNum = 0;
	if (FW) 
	{ 
		Version.SerialNum = FW->DeviceSerialNumber; 
		Version.FPGAFirmwareBuildNum = FW->FpgaFirmwareBuildNumber; 
	}
    formatf("\nUartCommand: Sending response (%u bytes): ", sizeof(CGraphVersionPayload));
    Version.printf();
    formatf("\n");
	//TxBinaryPacket(&FpgaUartParser0, CGraphPayloadTypeVersion, 0, &Version, sizeof(CGraphVersionPayload));
	TxBinaryPacket(&FpgaUartParser1, CGraphPayloadTypeVersion, 0, &Version, sizeof(CGraphVersionPayload));
    TxBinaryPacket(&FpgaUartParser2, CGraphPayloadTypeVersion, 0, &Version, sizeof(CGraphVersionPayload));
    
	formatf("\nUartCommand: complete.\n");

	return(ParamsLen);
}

int8_t BaudDividersCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	unsigned long A = 0, B = 0, C = 0;
	
	if (NULL == FW)
	{
		formatf("\n\nBaudDividers: Fpga interface is not initialized! Please call InitFpga first!.");
		return(ParamsLen);
	}
	
	//Convert parameters
    int8_t numfound = sscanf(Params, "%lu,%lu,%lu", &A, &B, &C);
    if (numfound >= 3)
    {
		FW->BaudDivider0 = A;
		FW->BaudDivider1 = B;
		FW->BaudDivider2 = C;
		formatf("\n\nBaudDividers: setting to: %lu, %lu, %lu.\n", A, B, C);
    }
	else
	{
		if (numfound >= 1)
		{
			FW->BaudDivider0 = A;
			FW->BaudDivider1 = A;
			//~ FW->DacBSetpoint = 0x006FFFFFUL; //Sometimes this is 100V
			//~ FW->DacBSetpoint = 0x00CFFFFFUL; //Aaaaaand, sometimes this is 100V
			FW->BaudDivider2 = A;
			formatf("\n\nBaudDividers: setting to: %lu, %lu, %lu.\n", A, A, A);
		}
	}
	
	A = FW->BaudDivider0;
	B = FW->BaudDivider1;
	C = FW->BaudDivider2;
	formatf("\n\nBaudDividers: current values: %lu, %lu, %lu.\n", A, B, C);
	
	//~ formatf("\nBaudDividers: (331 = 9600, 83 = 38400, 55 = 57600, 27 = 115200, 13 = 230400, 7 = 460800, 3 = 921600)\n");
	
	double BaudClock = 102000000.0;
	//~ unsigned int ActualDividerA = (A + 1) * 2;
	//~ unsigned int ActualDividerB = (B + 1) * 2;
	//~ unsigned int ActualDividerC = (C + 1) * 2;
	unsigned int ActualDividerA = (A + 1);
	unsigned int ActualDividerB = (B + 1);
	unsigned int ActualDividerC = (C + 1);
	double BaudRateA = (BaudClock / ActualDividerA) / 16;
	double BaudRateB = (BaudClock / ActualDividerB) / 16;
	double BaudRateC = (BaudClock / ActualDividerC) / 16;
	
	formatf("\nBaudDividers: Port0 final division ratio: %u (/16); Actual baudrate: %.5lf", ActualDividerA, BaudRateA);
	formatf("\nBaudDividers: Port1 final division ratio: %u (/16); Actual baudrate: %.5lf", ActualDividerB, BaudRateB);
	formatf("\nBaudDividers: Port2 final division ratio: %u (/16); Actual baudrate: %.5lf\n", ActualDividerC, BaudRateC);
	
	return(ParamsLen);
}

int8_t PrintBuffersCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	formatf("\nShowBuffersCommand: FpgaUartParser: ");
	FpgaUartParser2.formatf();
	FpgaUartParser1.formatf();
	//FpgaUartParser0.formatf();
	//FpgaUartParserUsb.formatf();
	formatf("\n\n");
	return(ParamsLen);
}

extern bool MonitorSerial0;
extern bool MonitorSerial1;
extern bool MonitorSerial2;

int8_t MonitorSerialCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	unsigned long port = 0;
	char seperator[8];
	char onoff;
    bool OnOff = false;

	//Convert parameters
    int8_t numfound = sscanf(Params, "%lu%2[,\t ]%c", &port, seperator, &onoff);
    if (numfound >= 3)
    {
		if ( ('Y' == onoff) || ('y' == onoff) || ('T' == onoff) || ('t' == onoff) || ('1' == onoff) ) { OnOff = true; }
		
		formatf("\n\nMonitorSerialCommand: Monitoring port %lu: %c.\n", port, OnOff?'Y':'N');
		
		switch(port)
		{
			case 0 : { MonitorSerial0 = OnOff; break; }			
			case 1 : { MonitorSerial1 = OnOff; break; }			
			case 2 : { MonitorSerial2 = OnOff; break; }			
			default : 
			{ 
				formatf("\n\nMonitorSerialCommand: Invalid port %lu; max is #2.\n", port);
			}
		}
			
		return(strlen(Params));
    }
	
	formatf("\n\nMonitorSerialCommand: Insufficient parameters (%u; should be 2); querying...", numfound);

	formatf("\nMonitorSerialCommand: Monitoring port 0: %c.\n", MonitorSerial0?'Y':'N');
	formatf("\nMonitorSerialCommand: Monitoring port 1: %c.\n", MonitorSerial1?'Y':'N');
	formatf("\nMonitorSerialCommand: Monitoring port 2: %c.\n", MonitorSerial2?'Y':'N');	
	
    return(strlen(Params));
}


//EOF


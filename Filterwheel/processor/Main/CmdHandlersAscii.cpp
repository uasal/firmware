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

#include "cgraph/CGraphFWHardwareInterface.hpp"
extern CGraphFWHardwareInterface* FW;	

#include "format/formatf.h"

#include "uart/BinaryUart.hpp"

#include "cgraph/CGraphPacket.hpp"

#include "../MonitorAdc.hpp"
extern CGraphFWMonitorAdc MonitorAdc;

#include "../FWBuildNum"

extern BinaryUart FpgaUartParser3;
extern BinaryUart FpgaUartParser2;
extern BinaryUart FpgaUartParser1;
//~ extern BinaryUart FpgaUartParser0;

char Buffer[4096];

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

int8_t ReadFpgaCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	uint32_t Buffer;

	//Convert parameter to an integer
    size_t addr = 0;
	int8_t numfound = sscanf(Params, "%zX", &addr);
    if (numfound < 1)
    {
		formatf("\nReadFpgaCommand: ");
		//~ for (addr = 0; addr <= 64; addr++)
		for (addr = 0; addr <= 128; addr+=4)
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
		addr -= (addr%4);
		Buffer = *(((uint8_t*)FW)+addr);
		formatf("\nReadFpgaCommand: ");
		//~ formatf("\n%zu: 0x%.2X ", addr, Buffer);
		formatf("\n0x%.2zX: 0x%.8lX ", addr, (unsigned long)Buffer);
		formatf("[%lu]", (unsigned long)Buffer);
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
	*(((uint8_t*)FW)+addr) = (uint32_t)val;

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
	HCR.formatf();
	formatf("\n");
	MCSR.formatf();
	formatf("\n");
	PSR.formatf();
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
	
	formatf("\n\nSensorStepsCommand: Offset of first Sensor Step: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFWHardwareInterface, PosDetHomeA), 148UL);
	//Had to blow these out cause 16b offsets kill the bloody M3:
	//~ formatf("\nSensorStepsCommand: Offset of last Sensor Step: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFWHardwareInterface, PosDet7B), 240UL);
	formatf("\nSensorStepsCommand: Offset of last Sensor Step: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFWHardwareInterface, PosDet7B), 332UL);
	
	
	formatf("\n\nSensorStepsCommand: current values:\n");
	
	formatf("\nPosDetHomeA: "); FW->PosDetHomeA.formatf();
	formatf("\nPosDetA0: "); FW->PosDetA0.formatf();
	formatf("\nPosDetA1: "); FW->PosDetA1.formatf();
	formatf("\nPosDetA2: "); FW->PosDetA2.formatf();
	
	formatf("\nPosDetHomeB: "); FW->PosDetHomeB.formatf();
	formatf("\nPosDetB0: "); FW->PosDetB0.formatf();
	formatf("\nPosDetB1: "); FW->PosDetB1.formatf();
	formatf("\nPosDetB2: "); FW->PosDetB2.formatf();
	
	formatf("\nPosDet0A: "); FW->PosDet0A.formatf();
	formatf("\nPosDet1A: "); FW->PosDet1A.formatf();
	formatf("\nPosDet2A: "); FW->PosDet2A.formatf();
	formatf("\nPosDet3A: "); FW->PosDet3A.formatf();
	formatf("\nPosDet4A: "); FW->PosDet4A.formatf();
	formatf("\nPosDet5A: "); FW->PosDet5A.formatf();
	formatf("\nPosDet6A: "); FW->PosDet6A.formatf();
	formatf("\nPosDet7A: "); FW->PosDet7A.formatf();
	
	formatf("\nPosDet0B: "); FW->PosDet0B.formatf();
	formatf("\nPosDet1B: "); FW->PosDet1B.formatf();
	formatf("\nPosDet2B: "); FW->PosDet2B.formatf();
	formatf("\nPosDet3B: "); FW->PosDet3B.formatf();
	formatf("\nPosDet4B: "); FW->PosDet4B.formatf();
	formatf("\nPosDet5B: "); FW->PosDet5B.formatf();
	formatf("\nPosDet6B: "); FW->PosDet6B.formatf();
	formatf("\nPosDet7B: "); FW->PosDet7B.formatf();
	
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
	MCSR.formatf();
	formatf("\n");
	
	return(ParamsLen);
}

int8_t FilterSelectCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	unsigned long FilterSelect = 0;
	
	//Convert parameters
    int8_t numfound = sscanf(Params, "%lu", &FilterSelect);
    if (numfound >= 1)
    {
		//Do something useful...
		//~ = FilterSelect;
		
		formatf("\n\nFilterSelectCommand: set to: %lu\n", FilterSelect);
    }
	
	//Do something useful...
	//~ FilterSelect = ;
			
	formatf("\n\nFilterSelectCommand: current value: %lu\n", FilterSelect);
	
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
		
		//Show the monitor A/D
		{
			MonitorAdc.Init();
			
			//~ size_t j = cycle % 12;
			//~ switch(j)
			//~ {
				//~ case 0: { formatf("P1V2: %3.6lf V\n", MonitorAdc.GetP1V2()); break; }
				//~ case 1: { formatf("P2V2: %3.6lf V\n", MonitorAdc.GetP2V2()); break; }
				//~ case 2: { formatf("P28V: %3.6lf V\n", MonitorAdc.GetP28V()); break; }
				//~ case 3: { formatf("P2V5: %3.6lf V\n", MonitorAdc.GetP2V5()); break; }
				//~ case 5: { formatf("P6V: %3.6lf V\n", MonitorAdc.GetP6V()); break; }
				//~ case 6: { formatf("P5V: %3.6lf V\n", MonitorAdc.GetP5V()); break; }
				//~ case 7: { formatf("P3V3D: %3.6lf V\n", MonitorAdc.GetP3V3D()); break; }
				//~ case 8: { formatf("P4V3: %3.6lf V\n", MonitorAdc.GetP4V3()); break; }
				//~ default : { }
			//~ }
			
			//~ PinoutMonitorAdc AdcTest;
			//static const uint8_t cmdtype_registerread = 0x02; << 5 = 0x40
			//static const uint8_t cmdtype_registerwrite = 0x03;	<,5 = 0x60
			//ads1258details::register_idnum = 0x09; //always reads 0x8B
			//__inline__ uint8_t  ReadRegister(const uint8_t& addr) 	{ spi_busmsg x; uint8_t  val = 0; txb(addr | 0x40); val |= rxb(); return(val); }
			//__inline__ void txb(uint8_t byte) { spi::transmit(byte); }
			//__inline__ uint8_t rxb() { uint8_t x = spi::receive((uint8_t)(0)); return(x); }
			//__inline__ spi_busmsg() { delayus(100); enable(true); }
			//~ uint8_t b = 0;
			
			//~ AdcTest.enable(true);
			//~ formatf("\n"); FW->MonitorAdcSpiCommandStatusRegister.formatf();
			//~ AdcTest.transmit(0x49); //0x40 | 0x09 0100:1001b
			//~ formatf("\n"); FW->MonitorAdcSpiCommandStatusRegister.formatf();
			//~ b = AdcTest.receive(0x00);
			//~ formatf("\n"); FW->MonitorAdcSpiCommandStatusRegister.formatf();
			//~ AdcTest.enable(false);
			//~ formatf("\n"); FW->MonitorAdcSpiCommandStatusRegister.formatf();
			//~ ::formatf("\nAdcTest try49: 0x%.2X", b);
			//~ AdcTest.transmit(0x92); // 1001:0010b
			//~ b = AdcTest.receive(0x00);
			//~ ::formatf("\nAdcTest try92: 0x%.2X", b);
			//~ AdcTest.transmit(0x24); // 0010:0100b
			//~ b = AdcTest.receive(0x00);
			//~ ::formatf("\nAdcTest try24: 0x%.2X", b);			
			
			//~ AdcTest.transmit(0xB6); // !0100:1001b = 1011:0110b
			//~ b = AdcTest.receive(0x00);
			//~ ::formatf("\nAdcTest tryB6: 0x%.2X", b);			
			//~ AdcTest.transmit(0x6D);  // !1001:0010b = 0110:1101b
			//~ b = AdcTest.receive(0x00);
			//~ ::formatf("\nAdcTest try6D: 0x%.2X", b);			
			//~ AdcTest.transmit(0xDB); // !0010:0100b = 1101:1011b
			//~ b = AdcTest.receive(0x00);
			//~ ::formatf("\nAdcTest tryDB: 0x%.2X", b);			
			
			//~ AdcTest.transmit(0x92); //0x40 | 0x09 0100:1001b -> 1001:0010b
			//~ b = AdcTest.receive(0x00);
			//~ ::formatf("\nAdcTest try92: 0x%.2X", b);
			//~ AdcTest.transmit(0x49); // 1001:0010b -> 0100:1001b
			//~ b = AdcTest.receive(0x00);
			//~ ::formatf("\nAdcTest try49: 0x%.2X", b);
			//~ AdcTest.transmit(0x42); // 0010:0100b -> 0010:0100b
			//~ b = AdcTest.receive(0x00);
			//~ ::formatf("\nAdcTest try42: 0x%.2X", b);			
			
			//~ AdcTest.transmit(0x6D); // !0100:1001b = 1011:0110b -> 0110:1101b
			//~ b = AdcTest.receive(0x00);
			//~ ::formatf("\nAdcTest try6D: 0x%.2X", b);			
			//~ AdcTest.transmit(0xB6);  // !1001:0010b = 0110:1101b -> 1011:0110b
			//~ b = AdcTest.receive(0x00);
			//~ ::formatf("\nAdcTest tryB6: 0x%.2X", b);			
			//~ AdcTest.transmit(0xDB); // !0010:0100b = 1101:1011b -> 1101:1011
			//~ b = AdcTest.receive(0x00);
			//~ ::formatf("\nAdcTest tryDB: 0x%.2X", b);			
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

int8_t BaudDividersCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	unsigned long A = 0, B = 0, C = 0, D = 0;
	
	if (NULL == FW)
	{
		formatf("\n\nBaudDividers: Fpga interface is not initialized! Please call InitFpga first!.");
		return(ParamsLen);
	}
	
	//Convert parameters
    int8_t numfound = sscanf(Params, "%lu,%lu,%lu,%lu", &A, &B, &C, &D);
    if (numfound >= 4)
    {
		FW->BaudDividers.Divider0 = A;
		FW->BaudDividers.Divider1 = B;
		FW->BaudDividers.Divider2 = C;
		FW->BaudDividers.Divider3 = D;
		formatf("\n\nBaudDividers: setting to: %lu, %lu, %lu, %lu.\n", A, B, C, D);
    }
	else
	{
		if (numfound >= 1)
		{
		FW->BaudDividers.Divider0 = A;
		FW->BaudDividers.Divider1 = A;
		FW->BaudDividers.Divider2 = A;
		FW->BaudDividers.Divider3 = A;
		formatf("\n\nBaudDividers: setting to: %lu, %lu, %lu, %lu.\n", A, A, A, A);
		}
	}
	
	A = FW->BaudDividers.Divider0;
	B = FW->BaudDividers.Divider1;
	C = FW->BaudDividers.Divider2;
	D = FW->BaudDividers.Divider3;
	formatf("\n\nBaudDividers: current values: %lu, %lu, %lu.\n", A, B, C, D);
	
	//~ formatf("\nBaudDividers: (331 = 9600, 83 = 38400, 55 = 57600, 27 = 115200, 13 = 230400, 7 = 460800, 3 = 921600)\n");
	
	double BaudClock = 102000000.0;
	unsigned int ActualDividerA = (A + 1);
	unsigned int ActualDividerB = (B + 1);
	unsigned int ActualDividerC = (C + 1);
	unsigned int ActualDividerD = (D + 1);
	double BaudRateA = (BaudClock / ActualDividerA) / 16;
	double BaudRateB = (BaudClock / ActualDividerB) / 16;
	double BaudRateC = (BaudClock / ActualDividerC) / 16;
	double BaudRateD = (BaudClock / ActualDividerD) / 16;
	
	formatf("\nBaudDividers: Port0 final division ratio: %u (/16); Actual baudrate: %.5lf", ActualDividerA, BaudRateA);
	formatf("\nBaudDividers: Port1 final division ratio: %u (/16); Actual baudrate: %.5lf", ActualDividerB, BaudRateB);
	formatf("\nBaudDividers: Port2 final division ratio: %u (/16); Actual baudrate: %.5lf\n", ActualDividerC, BaudRateC);
	formatf("\nBaudDividers: Port3 final division ratio: %u (/16); Actual baudrate: %.5lf\n", ActualDividerD, BaudRateD);
	
	return(ParamsLen);
}

int8_t PrintBuffersCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	formatf("\nShowBuffersCommand: FpgaUartParser: ");
	FpgaUartParser3.formatf();
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
extern bool MonitorSerial3;

int8_t MonitorSerialCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	unsigned long port = 0;
	char seperator[8];
	char onoff;
    bool OnOff = false;

	//Convert parameters
    int8_t numfound = sscanf(Params, "%lu%2[,\t ]%c", &port, seperator, &onoff);
    if (numfound >= 4)
    {
		if ( ('Y' == onoff) || ('y' == onoff) || ('T' == onoff) || ('t' == onoff) || ('1' == onoff) ) { OnOff = true; }
		
		formatf("\n\nMonitorSerialCommand: Monitoring port %lu: %c.\n", port, OnOff?'Y':'N');
		
		switch(port)
		{
			case 0 : { MonitorSerial0 = OnOff; break; }			
			case 1 : { MonitorSerial1 = OnOff; break; }			
			case 2 : { MonitorSerial2 = OnOff; break; }			
			case 3 : { MonitorSerial3 = OnOff; break; }			
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
	formatf("\nMonitorSerialCommand: Monitoring port 3: %c.\n", MonitorSerial3?'Y':'N');	
	
    return(strlen(Params));
}


//EOF


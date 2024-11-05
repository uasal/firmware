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

//~ #include <mcheck.h>
//~ #include "dbg/memwatch.h"

#include "uart/BinaryUart.hpp"

#include "uart/uart_pinout_fpga.hpp"

#include "cgraph/CGraphPacket.hpp"

#include "cgraph/CGraphFSMHardwareInterface.hpp"
extern CGraphFSMHardwareInterface* FSM;	

#include "../MonitorAdc.hpp"
extern CGraphFSMMonitorAdc MonitorAdc;

#include "MainBuildNum"

extern uart_pinout_fpga FPGAUartPinout0;
extern uart_pinout_fpga FPGAUartPinout1;
extern uart_pinout_fpga FPGAUartPinout2;
extern uart_pinout_fpga FPGAUartPinout3;
extern uart_pinout_fpga FPGAUartPinoutUsb;

extern BinaryUart FpgaUartParser3;
extern BinaryUart FpgaUartParser2;
extern BinaryUart FpgaUartParser1;
extern BinaryUart FpgaUartParser0;

char Buffer[4096];

int8_t VersionCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if (NULL != FSM)
	{
		printf("\n\nVersion: Serial Number: %.8lX, Global Revision: %s; build number: %u on: %s; fpga build: %lu.\n", FSM->DeviceSerialNumber, GITVERSION, BuildNum, BuildTimeStr, FSM->FpgaFirmwareBuildNumber);
	}
	else
	{
		printf("\n\nVersion: Global Revision: %s; build number: %u on: %s.\n", GITVERSION, BuildNum, BuildTimeStr);
	}
	
    return(strlen(Params));
}

int8_t ReadFpgaCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	uint8_t FpgaRdBuf;

	//Convert parameter to an integer
    size_t addr = 0;
	int8_t numfound = sscanf(Params, "%zX", &addr);
    if (numfound < 1)
    {
		printf("\nReadFpgaCommand: ");
		//~ for (addr = 0; addr <= 64; addr++)
		for (addr = 0; addr <= 128; addr++)
		{
			FpgaRdBuf = *(((uint8_t*)FSM)+addr);
			printf("\n0x%.2zX: 0x%.2X ", addr, FpgaRdBuf);
			printf("[%u]", FpgaRdBuf);
			//~ printf(" ('%c')", FpgaRdBuf);
		}	
		printf("\n\n");
    }
	else
	{
		FpgaRdBuf = *(((uint8_t*)FSM)+addr);
		printf("\nReadFpgaCommand: ");
		//~ printf("\n%zu: 0x%.2X ", addr, FpgaRdBuf);
		printf("\n0x%.2zX: 0x%.2X ", addr, FpgaRdBuf);
		printf("[%u]", FpgaRdBuf);
		printf(" ('%c')\n\n", FpgaRdBuf);
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
		printf("\nWriteFpgaCommand: need 2 numeric parameters (address and value), got \"%s\" (%d params).\n", Params, numfound);
        return(-1);
    }

	//Write data to fpga:
	*(((uint8_t*)FSM)+addr) = (uint8_t)val;

	printf("\nWriteFpgaCommand: Wrote %lu to ", val);
	printf("0x%.4zX.\n", addr);
	
	return(ParamsLen);
}


int8_t FSMDacsCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    unsigned long A = 0, B = 0, C = 0;	
	if (NULL == FSM)
	{
		printf("\n\nFSMDacs: Fpga interface is not initialized! Please call InitFpga first!.");
		return(ParamsLen);
	}
	
	//Convert parameters
    int8_t numfound = sscanf(Params, "%lx,%lx,%lx", &A, &B, &C);
    if (numfound >= 3)
    {
		FSM->DacASetpoint = A;
		FSM->DacBSetpoint = B;
		FSM->DacCSetpoint = C;
		printf("\n\nFSMDacs: set to: %lx, %lx, %lx.\n", A, B, C);
		return(ParamsLen);
    }
	if (numfound >= 1)
    {
		FSM->DacASetpoint = A;
		FSM->DacBSetpoint = A;
		//~ FSM->DacBSetpoint = 0x006FFFFFUL; //Sometimes this is 100V
		//~ FSM->DacBSetpoint = 0x00CFFFFFUL; //Aaaaaand, sometimes this is 100V
		FSM->DacCSetpoint = A;
		printf("\n\nFSMDacs: set to: %lx, %lx, %lx.\n", A, A, A);
		return(ParamsLen);
    }

	A = FSM->DacASetpoint;
	B = FSM->DacBSetpoint;
	C = FSM->DacCSetpoint;
	printf("\n\nFSMDacs: current value: %lx, %lx, %lx.\n", A, B, C);
	
	//Show current A/D values:
	{
		AdcAccumulator Aa, Ba, Ca;
		Aa = FSM->AdcAAccumulator;
		Ba = FSM->AdcBAccumulator;
		Ca = FSM->AdcCAccumulator;

		double Av, Bv, Cv;
		Av = (8.192 * ((Aa.Samples - 0) / Aa.NumAccums)) / 16777216.0;
		Bv = (8.192 * ((Ba.Samples - 0) / Ba.NumAccums)) / 16777216.0;
		Cv = (8.192 * ((Ca.Samples - 0) / Ca.NumAccums)) / 16777216.0;
		
			
		//~ printf("\n\nFSMAdcs: current values: 0x%016llx, 0x%016llx, 0x%016llx; %+lld(%u), %+lld(%u), %+lld(%u), %+1.3lf, %+1.3lf, %+1.3lf\n", A.all, B.all, C.all, A.Samples, A.NumAccums, B.Samples, B.NumAccums, C.Samples, C.NumAccums, (4.096 * (A.Samples / A.NumAccums)) / 16777216.0, (4.096 * (B.Samples / B.NumAccums)) / 16777216.0, (4.096 * (C.Samples / C.NumAccums)) / 16777216.0);
		printf("\nFSMDacs: Sensor A/D's: 0x%016llx, 0x%016llx, 0x%016llx; %+d(%u), %+d(%u), %+d(%u), %+1.3lf, %+1.3lf, %+1.3lf\n", Aa.all, Ba.all, Ca.all, Aa.Samples, Aa.NumAccums, Ba.Samples, Ba.NumAccums, Ca.Samples, Ca.NumAccums, Av, Bv, Cv);
	}
	
	//~ printf("\n\nFSMdaca: D/A registers at: %u, %u, %u.\n", offsetof(CGraphFSMHardwareInterface, DacASetpoint), offsetof(CGraphFSMHardwareInterface, DacBSetpoint), offsetof(CGraphFSMHardwareInterface, DacCSetpoint));
	
    return(ParamsLen);
}

int8_t VoltageCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	double VA = 0.0, VB = 0.0, VC = 0.0;	
	unsigned long A = 0, B = 0, C = 0;	
	
	if (NULL == FSM)
	{
		printf("\n\nVoltage: Fpga interface is not initialized! Please call InitFpga first!.");
		return(ParamsLen);
	}
	
	//Convert parameters
    int8_t numfound = sscanf(Params, "%lf,%lf,%lf", &VA, &VB, &VC);
	
	A = (VA * (double)(0x00FFFFFFUL) * 60.0) / 4.096;
	B = (VB * (double)(0x00FFFFFFUL) * 60.0) / 4.096;
	C = (VC * (double)(0x00FFFFFFUL) * 60.0) / 4.096;
	
    if (numfound >= 3)
    {
		FSM->DacASetpoint = A;
		FSM->DacBSetpoint = B;
		FSM->DacCSetpoint = C;
		printf("\n\nVoltage: set to: %3.1lf (%lx), %3.1lf (%lx), %3.1lf (%lx).\n", VA, A, VB, B, VC, C);
		return(ParamsLen);
    }
	if (numfound >= 1)
    {
		FSM->DacASetpoint = A;
		FSM->DacBSetpoint = A;
		//~ FSM->DacBSetpoint = 0x006FFFFFUL; //Sometimes this is 100V
		//~ FSM->DacBSetpoint = 0x00CFFFFFUL; //Aaaaaand, sometimes this is 100V
		FSM->DacCSetpoint = A;
		printf("\n\nVoltage: set to: %3.1lf (%lx), %3.1lf (%lx), %3.1lf (%lx).\n", VA, A, VB, B, VC, C);
		return(ParamsLen);
    }

	A = FSM->DacASetpoint;
	B = FSM->DacBSetpoint;
	C = FSM->DacCSetpoint;
	
	VA = 4.096 * (double)(A) / ((double)(0x00FFFFFFUL) * 60.0);
	VB = 4.096 * (double)(A) / ((double)(0x00FFFFFFUL) * 60.0);
	VC = 4.096 * (double)(A) / ((double)(0x00FFFFFFUL) * 60.0);
	
	printf("\n\nVoltage: current values: %3.1lf (%lx), %3.1lf (%lx), %3.1lf (%lx).\n", VA, A, VB, B, VC, C);
	
	return(ParamsLen);	
}

int8_t FSMAdcsCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//~ size_t cycle = 0;
	//~ int key = 0;

	if (NULL == FSM)
	{
		printf("\n\nFSMAdcs: Fpga interface is not initialized! Please call InitFpga first!.");
		return(ParamsLen);
	}
	
	//~ while(true)
	//~ {
		//~ cycle++;
		
		//Show current A/D values:
		{
			AdcAccumulator A, B, C;
			A = FSM->AdcAAccumulator;
			B = FSM->AdcBAccumulator;
			C = FSM->AdcCAccumulator;

			double Av, Bv, Cv;
			Av = (8.192 * ((A.Samples - 0) / A.NumAccums)) / 16777216.0;
			Bv = (8.192 * ((B.Samples - 0) / B.NumAccums)) / 16777216.0;
			Cv = (8.192 * ((C.Samples - 0) / C.NumAccums)) / 16777216.0;
			
				
			//~ printf("\n\nFSMAdcs: current values: 0x%016llx, 0x%016llx, 0x%016llx; %+lld(%u), %+lld(%u), %+lld(%u), %+1.3lf, %+1.3lf, %+1.3lf\n", A.all, B.all, C.all, A.Samples, A.NumAccums, B.Samples, B.NumAccums, C.Samples, C.NumAccums, (4.096 * (A.Samples / A.NumAccums)) / 16777216.0, (4.096 * (B.Samples / B.NumAccums)) / 16777216.0, (4.096 * (C.Samples / C.NumAccums)) / 16777216.0);
			printf("\nFSMAdcs: current values: 0x%016llx, 0x%016llx, 0x%016llx; %+d(%u), %+d(%u), %+d(%u), %+1.3lf, %+1.3lf, %+1.3lf\n", A.all, B.all, C.all, A.Samples, A.NumAccums, B.Samples, B.NumAccums, C.Samples, C.NumAccums, Av, Bv, Cv);
		}
		
		//~ //Quit on any keypress
		//~ {
			//~ struct termios argin, argout;
			//~ tcgetattr(0,&argin);
			//~ argout = argin;
			//~ argout.c_lflag &= ~(ICANON);
			//~ argout.c_iflag &= ~(ICRNL);
			//~ argout.c_oflag &= ~(OPOST);
			//~ argout.c_cc[VMIN] = 1;
			//~ argout.c_cc[VTIME] = 0;
			//~ tcsetattr(0,TCSADRAIN,&argout);
			//~ //read(0, &key, 1);
			//~ ioctl(0, FIONREAD, &key);
			//~ tcsetattr(0,TCSADRAIN,&argin);
			//~ if (0 != key) 
			//~ { 
				//~ fflush(stdin);
				//~ printf("\n\nFSMAdcs: Keypress(%d); exiting.\n", key);
				//~ break; 
			//~ }			
		//~ }

		//~ struct timespec sleeptime;
		//~ memset((char *)&sleeptime,0,sizeof(sleeptime));
		//~ sleeptime.tv_nsec = 100000000;
		//~ //sleeptime.tv_sec = 1;
		//~ nanosleep(&sleeptime, NULL);
	//~ }
	
	return(ParamsLen);
}

int8_t BISTCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	size_t cycle = 0;
	//~ unsigned long daca = 0;
	int key = 0;
	
	while(true)
	{
		cycle++;
		
		//~ //Show current A/D values:
		//~ {
			//~ AdcAccumulator A, B, C;
			//~ A = FSM->AdcAAccumulator;
			//~ B = FSM->AdcBAccumulator;
			//~ C = FSM->AdcCAccumulator;

			//~ double Av, Bv, Cv;
			//~ Av = (4.096 * ((A.Samples - 0) / A.NumAccums)) / 8388608.0;
			//~ Bv = (4.096 * ((B.Samples - 0) / B.NumAccums)) / 8388608.0;
			//~ Cv = (4.096 * ((C.Samples - 0) / C.NumAccums)) / 8388608.0;
			
			//~ printf("\n\nBIST: current A/D values: 0x%016llx, 0x%016llx, 0x%016llx; %+lld(%u), %+lld(%u), %+lld(%u), %+1.3lf, %+1.3lf, %+1.3lf; %u, %u, %u.\n", A.all, B.all, C.all, A.Samples, A.NumAccums, B.Samples, B.NumAccums, C.Samples, C.NumAccums, Av, Bv, Cv, offsetof(CGraphFSMHardwareInterface, AdcAAccumulator), offsetof(CGraphFSMHardwareInterface, AdcBAccumulator), offsetof(CGraphFSMHardwareInterface, AdcCAccumulator));
		//~ }
		
		//~ //Update the D/A's every so often
		//~ if (0 == cycle % 4)
		//~ {
			//~ FSM->DacASetpoint = daca;
			//~ //FSM->DacBSetpoint = daca;
			//~ FSM->DacBSetpoint = 0x00CFFFFFUL;
			//~ FSM->DacCSetpoint = daca;
			//~ printf("\n\nBIST: D/A's set to: %lx.\n", daca);	

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
				//~ case 4: { formatf("P3V3A: %3.6lf V\n", MonitorAdc.GetP3V3A()); break; }
				case 5: { formatf("P6V: %3.6lf V\n", MonitorAdc.GetP6V()); break; }
				case 6: { formatf("P5V: %3.6lf V\n", MonitorAdc.GetP5V()); break; }
				case 7: { formatf("P3V3D: %3.6lf V\n", MonitorAdc.GetP3V3D()); break; }
				case 8: { formatf("P4V3: %3.6lf V\n", MonitorAdc.GetP4V3()); break; }
				//~ case 9: { formatf("N5V: %3.6lf V\n", MonitorAdc.GetN5V()); break; }
				//~ case 10: { formatf("N6V: %3.6lf V\n", MonitorAdc.GetN6V()); break; }
				//~ case 11: { formatf("P150V: %3.6lf V\n\n\n", MonitorAdc.GetP150V()); break; }
				default : { }
			}
		}
		
		//Quit on any keypress
		{
			//~ if (0 != key) 
			{ 
				fflush(stdin);
				printf("\n\nBIST: Keypress(%d); exiting.\n", key);
				break; 
			}			
		}

		//~ DelayMs(10);
	}
	
	return(ParamsLen);
}

int8_t CirclesCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	size_t cycle = 0;
	unsigned long daca = 0;
	unsigned long dacb = 0;
	unsigned long dacc = 0;
	int key = 0;
	
	double radius = 1.0;
	double delayinms = 1.0; //1ms
	sscanf(Params, "%lf,%lf", &radius, &delayinms);
	if (radius < 0.0) { radius = 0.0; }
	if (radius > 1.0) { radius = 1.0; }
	if (delayinms < 0.001) { delayinms = 0.001; }
	if (delayinms > 10000) { delayinms = 10000; }
	
	printf("\n\nCircles: RunCircle(%lf, %lfms)...\n", radius, delayinms);	
	    	
	while(true)
	{
		cycle++;
		
		//Update the D/A's every so often
		{
			FSM->DacASetpoint = daca;
			FSM->DacBSetpoint = dacb;
			//~ FSM->DacBSetpoint = 0x00AAAAAAUL;
			//~ FSM->DacBSetpoint = 0x006FFFFFUL;
			//~ FSM->DacBSetpoint = 0x00CFFFFFUL;
			FSM->DacCSetpoint = dacc;
			//~ printf("\n\nBIST: D/A's set to: %lx, %lx, %lx.\n", daca, 0x006FFFFFUL, dacc);	

			unsigned long rba = FSM->DacASetpoint;
			unsigned long rbb = FSM->DacBSetpoint;
			unsigned long rbc = FSM->DacCSetpoint;
			printf("\n%lu, %lu, %lu", rba, rbb, rbc);
			
			
			//~ double ang = (double)(cycle % 360);
			double ang = (double)(cycle % 60) * 6.0;
			//~ double rad = (ang / 360.0) * 6.28;
			double rada = (ang / 360.0) * 6.28;
			double radb = ((ang + 120) / 360.0) * 6.28;
			double radc = ((ang + 240) / 360.0) * 6.28;
			//~ double carta = ((sin(rad) + 1.0) / 2.0) * radius;
			//~ double cartc = ((cos(rad) + 1.0) / 2.0) * radius;
			//~ printf("\n\nBIST: Deg:%f, Rad:%f, Sin:%f, Cos:%f.\n", ang, rad, carta, cartb);	
			double carta = ((sin(rada) + 1.0) / 2.0) * radius;
			double cartb = ((sin(radb) + 1.0) / 2.0) * radius;
			double cartc = ((sin(radc) + 1.0) / 2.0) * radius;
			
			daca = (unsigned long)(carta * 0x00CFFFFFUL);
			dacb = (unsigned long)(cartb * 0x00CFFFFFUL);
			dacc = (unsigned long)(cartc * 0x00CFFFFFUL);
			//~ daca = (unsigned long)(carta * 0x003FFFFFUL);
			//~ dacc = (unsigned long)(cartb * 0x003FFFFFUL);
			
			//~ printf("\n%lu, %lu, %lu", daca, dacb, dacc);
		}
		
		//Quit on any keypress
		{
			//~ if (0 != key) 
			{ 
				fflush(stdin);
				printf("\n\nCircles: Keypress(%d); exiting.\n", key);
				break; 
			}			
		}

		//~ DelayMs(delayinms);
	}
	
	return(ParamsLen);
}

int8_t GoXYCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    unsigned long A = 0, B = 0, C = 0;
	
	if (NULL == FSM)
	{
		printf("\n\nGoXY: Fpga interface is not initialized! Please call InitFpga first!.");
		return(ParamsLen);
	}
	
	//Convert parameters
	double X = 0.0;
	double Y = 0.0;
    sscanf(Params, "%lf,%lf", &X, &Y);
	if (X < 0.0) { X = 0.0; }
	if (X > 1.0) { X = 1.0; }
	if (Y < 0.0) { Y = 0.0; }
	if (Y > 1.0) { Y = 1.0; }
	
	A = (unsigned long)(X * 0x00CFFFFFUL);
	C = (unsigned long)(Y * 0x00CFFFFFUL);
	
	FSM->DacASetpoint = A;
	FSM->DacBSetpoint = 0x006FFFFFUL;
	FSM->DacBSetpoint = 0x00CFFFFFUL;
	FSM->DacCSetpoint = C;
	printf("\n\nGoXY: set to: %lx, %lx, %lx.\n", A, 0x00CFFFFFUL, C);


	A = FSM->DacASetpoint;
	B = FSM->DacBSetpoint;
	C = FSM->DacCSetpoint;
	printf("\n\nGoXY: current value: %lx, %lx, %lx (%lfV x %lfV).\n", A, B, C, X * 100.0, Y * 100.0);
	
	//Show current A/D values:
	{
		AdcAccumulator Aa, Ba, Ca;
		Aa = FSM->AdcAAccumulator;
		Ba = FSM->AdcBAccumulator;
		Ca = FSM->AdcCAccumulator;

		double Av, Bv, Cv;
		Av = (8.192 * ((Aa.Samples - 0) / Aa.NumAccums)) / 16777216.0;
		Bv = (8.192 * ((Ba.Samples - 0) / Ba.NumAccums)) / 16777216.0;
		Cv = (8.192 * ((Ca.Samples - 0) / Ca.NumAccums)) / 16777216.0;
		
			
		//~ printf("\n\nFSMAdcs: current values: 0x%016llx, 0x%016llx, 0x%016llx; %+lld(%u), %+lld(%u), %+lld(%u), %+1.3lf, %+1.3lf, %+1.3lf\n", A.all, B.all, C.all, A.Samples, A.NumAccums, B.Samples, B.NumAccums, C.Samples, C.NumAccums, (4.096 * (A.Samples / A.NumAccums)) / 16777216.0, (4.096 * (B.Samples / B.NumAccums)) / 16777216.0, (4.096 * (C.Samples / C.NumAccums)) / 16777216.0);
		printf("\nGoXY: Sensor A/D's: 0x%016llx, 0x%016llx, 0x%016llx; %+d(%u), %+d(%u), %+d(%u), %+1.3lf, %+1.3lf, %+1.3lf\n", Aa.all, Ba.all, Ca.all, Aa.Samples, Aa.NumAccums, Ba.Samples, Ba.NumAccums, Ca.Samples, Ca.NumAccums, Av, Bv, Cv);
	}
	
	//~ printf("\n\nFSMdaca: D/A registers at: %u, %u, %u.\n", offsetof(CGraphFSMHardwareInterface, DacASetpoint), offsetof(CGraphFSMHardwareInterface, DacBSetpoint), offsetof(CGraphFSMHardwareInterface, DacCSetpoint));
	
    return(ParamsLen);
}

int8_t UartCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	struct timespec sleeptime;
	memset((char *)&sleeptime,0,sizeof(sleeptime));
	sleeptime.tv_nsec = 1000000;
	sleeptime.tv_sec = 0;
	int key = 0;
	
	//Convert parameter to an integer
	//~ size_t addr = 0;
    //~ unsigned long val = 0;
    //~ int8_t numfound = sscanf(Params, "%zX %lu", &addr, &val);
    //~ if (numfound < 2)
    //~ {
		//~ printf("\nUartCommand: need 2 numeric parameters (address and value), got \"%s\" (%d params).\n", Params, numfound);
        //~ return(-1);
    //~ }
	//~ char* cmd = 0;
	//~ char* params = 0;
	//~ int8_t numfound = sscanf(Params, "%s %s", cmd, params);
	//~ if (numfound < 2)
    //~ {
		//~ printf("\nUartCommand: need 2 numeric parameters (address and value), got \"%s\" (%d params).\n", Params, numfound);
        //~ return(-1);
    //~ }
	
	//~ printf("\nUartCommand: FSM@0x%p, USR@%u, UF@%u, MAA@%u, ACF@%u, ACF is %u, ", (void*)FSM, offsetof(CGraphFSMHardwareInterface, UartStatusRegister), offsetof(CGraphFSMHardwareInterface, UartFifo), offsetof(CGraphFSMHardwareInterface, MonitorAdcAccumulator), offsetof(CGraphFSMHardwareInterface, AdcCFifo), sizeof(AdcFifo));
	printf("\nUartCommand: %u, %u. ", offsetof(CGraphFSMHardwareInterface, UartFifo2), offsetof(CGraphFSMHardwareInterface, UartStatusRegister2));
	
	if (0 == strncmp(&(Params[1]), "loop", 4))
	{
		while(true)
		{
			//~ FSM->UartFifo0 = 0x55;
			//~ FSM->UartFifo1 = 0x55;	
			FSM->UartFifo2 = 0x55;
			
			//Quit on any keypress
			{
				//~ if (0 != key) 
				{ 
					fflush(stdin);
					printf("\n\nCircles: Keypress(%d); exiting.\n", key);
					break; 
				}			
			}
		}
	}
	
	//~ CGraphFSMUartStatusRegister UartStatus = FSM->UartStatusRegister2;
	//~ UartStatus.printf();	
	
	//~ printf("; about to write to uart... ");	
	//~ FSM->UartFifo = 'H';
	//~ nanosleep(&sleeptime, NULL);
	//~ FSM->UartFifo = 'e';
	//~ nanosleep(&sleeptime, NULL);
	//~ FSM->UartFifo = 'l';
	//~ nanosleep(&sleeptime, NULL);
	//~ FSM->UartFifo = 'l';
	//~ nanosleep(&sleeptime, NULL);
	//~ FSM->UartFifo = 'o';
	//~ nanosleep(&sleeptime, NULL);
	//~ FSM->UartFifo = '!';
	//~ nanosleep(&sleeptime, NULL);
	
	//~ UartStatus = FSM->UartStatusRegister; 
	//~ printf("; uart written; ");	
	//~ UartStatus.printf();	
	
	//~ CGraphFSMUartStatusRegister UartStatus2;
	
	//~ for(size_t i = 0; i < 100000; i++)
	//~ { 
		//~ UartStatus = FSM->UartStatusRegister; 
		//~ if (0 == UartStatus.Uart2TxFifoEmpty) { break; }
	//~ }
	
	//~ printf("\nUartCommand: about to read...");
	//~ UartStatus.printf();	
	//~ printf("; reading from uart... ");
	
	//~ for (size_t i = 0; i < 1024; i++)
	//~ {
		//~ FpgaUartParser.Process();
	//~ }
		
	
	//~ for(size_t i = 0; i < 128; i++)
	//~ for(size_t i = 0; i < 4096; i++)
	//~ {
		//~ if (0 != UartStatus.Uart2RxFifoEmpty) { break; }
		//~ printf(":%.2X", FSM->UartFifo);
		//~ UartStatus = FSM->UartStatusRegister; 		
	//~ }
	
	//~ {
		//~ //clear buffer:
		//~ FSM->UartStatusRegister.all = 1;
	//~ }
	
	//~ printf(":%.4X", FSM->UartFifo2);
	
	//~ printf("\n");
	//~ UartStatus.printf();	
	
	CGraphVersionPayload Version;
    Version.SerialNum = 0;
	Version.ProcessorFirmwareBuildNum = BuildNum;
	Version.FPGAFirmwareBuildNum = 0;
	if (FSM) 
	{ 
		Version.SerialNum = FSM->DeviceSerialNumber; 
		Version.FPGAFirmwareBuildNum = FSM->FpgaFirmwareBuildNumber; 
	}
    printf("\nUartCommand: Sending response (%u bytes): ", sizeof(CGraphVersionPayload));
    Version.formatf();
    printf("\n");
	TxBinaryPacket(&FpgaUartParser0, CGraphPayloadTypeVersion, 0, &Version, sizeof(CGraphVersionPayload));
	TxBinaryPacket(&FpgaUartParser1, CGraphPayloadTypeVersion, 0, &Version, sizeof(CGraphVersionPayload));
    TxBinaryPacket(&FpgaUartParser2, CGraphPayloadTypeVersion, 0, &Version, sizeof(CGraphVersionPayload));
    
	printf("\nUartCommand: complete.\n");

	return(ParamsLen);
}

int8_t BaudDividersCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	unsigned long A = 0, B = 0, C = 0;
	
	if (NULL == FSM)
	{
		printf("\n\nBaudDividers: Fpga interface is not initialized! Please call InitFpga first!.");
		return(ParamsLen);
	}
	
	//Convert parameters
    int8_t numfound = sscanf(Params, "%lu,%lu,%lu", &A, &B, &C);
    if (numfound >= 3)
    {
		FSM->BaudDivider0 = A;
		FSM->BaudDivider1 = B;
		FSM->BaudDivider2 = C;
		printf("\n\nBaudDividers: setting to: %lu, %lu, %lu.\n", A, B, C);
    }
	else
	{
		if (numfound >= 1)
		{
			FSM->BaudDivider0 = A;
			FSM->BaudDivider1 = A;
			//~ FSM->DacBSetpoint = 0x006FFFFFUL; //Sometimes this is 100V
			//~ FSM->DacBSetpoint = 0x00CFFFFFUL; //Aaaaaand, sometimes this is 100V
			FSM->BaudDivider2 = A;
			printf("\n\nBaudDividers: setting to: %lu, %lu, %lu.\n", A, A, A);
		}
	}
	
	A = FSM->BaudDivider0;
	B = FSM->BaudDivider1;
	C = FSM->BaudDivider2;
	printf("\n\nBaudDividers: current values: %lu, %lu, %lu.\n", A, B, C);
	
	//~ printf("\nBaudDividers: (331 = 9600, 83 = 38400, 55 = 57600, 27 = 115200, 13 = 230400, 7 = 460800, 3 = 921600)\n");
	
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
	
	printf("\nBaudDividers: Port0 final division ratio: %u (/16); Actual baudrate: %.5lf", ActualDividerA, BaudRateA);
	printf("\nBaudDividers: Port1 final division ratio: %u (/16); Actual baudrate: %.5lf", ActualDividerB, BaudRateB);
	printf("\nBaudDividers: Port2 final division ratio: %u (/16); Actual baudrate: %.5lf\n", ActualDividerC, BaudRateC);
	
	return(ParamsLen);
}

int8_t PrintBuffersCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\nShowBuffersCommand: FpgaUartParser: ");
	FpgaUartParser2.formatf();
	FpgaUartParser1.formatf();
	FpgaUartParser0.formatf();
	printf("\n\n");
	return(ParamsLen);
}

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
			case 0 : { FPGAUartPinout0.Monitor(OnOff); break; }			
			case 1 : { FPGAUartPinout1.Monitor(OnOff); break; }			
			case 2 : { FPGAUartPinout2.Monitor(OnOff); break; }			
			case 3 : { FPGAUartPinout3.Monitor(OnOff); break; }			
			default : 
			{ 
				formatf("\n\nMonitorSerialCommand: Invalid port %lu; max is #2.\n", port);
			}
		}
			
		return(strlen(Params));
    }
	
	formatf("\n\nMonitorSerialCommand: Insufficient parameters (%u; should be 2); querying...", numfound);

	formatf("\nMonitorSerialCommand: Monitoring port 0: %c.\n", FPGAUartPinout0.Monitor()?'Y':'N');
	formatf("\nMonitorSerialCommand: Monitoring port 1: %c.\n", FPGAUartPinout1.Monitor()?'Y':'N');
	formatf("\nMonitorSerialCommand: Monitoring port 2: %c.\n", FPGAUartPinout2.Monitor()?'Y':'N');	
	formatf("\nMonitorSerialCommand: Monitoring port 3: %c.\n", FPGAUartPinout3.Monitor()?'Y':'N');	
	
    return(strlen(Params));
}



//EOF


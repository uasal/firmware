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
//kbhit
#include <termios.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <errno.h>
#include <unordered_map>
using namespace std;

#include <mcheck.h>
#include "dbg/memwatch.h"

#include "uart/AsciiCmdUserInterfaceLinux.h"

#include "cgraph/CGraphDeprecatedPZTHardwareInterface.hpp"
extern int MmapHandle;
extern CGraphPZTHardwareInterface* PZT;	

#include "../MonitorAdc.hpp"
extern CGraphPZTMonitorAdc MonitorAdc;

#include "../PZTBuildNum"

#include "ClientSocket.hpp"

extern BinaryUart FpgaUartParser2;
extern BinaryUart FpgaUartParser1;
extern BinaryUart FpgaUartParser0;

char Buffer[4096];

int8_t ExitCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	muntrace();
	
	printf("\n\nExitCommand: Goodbye!\n\n\n\n");
	exit(0);
	
	return(ParamsLen);
}

int8_t GlobalSaveCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//GlobalSave provides all needed printf's:
	//~ GlobalSave();

	return(ParamsLen);
}

int8_t GlobalRestoreCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//GlobalRestore provides all needed printf's:
	//~ GlobalRestore();

	return(ParamsLen);
}

int8_t ParseConfigFileCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\n\nParseConfigFile: opening %s to parse...\n", &(Params[1]));

	ParseConfigFile(&(Params[1]));

	return(ParamsLen);
}

int8_t VersionCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if (NULL != PZT)
	{
		printf("\n\nVersion: Serial Number: %.8X, Global Revision: %s; build number: %u on: %s; fpga build: %u.\n", PZT->DeviceSerialNumber, GITVERSION, BuildNum, BuildTimeStr, PZT->FpgaFirmwareBuildNumber);
	}
	else
	{
		printf("\n\nVersion: Global Revision: %s; build number: %u on: %s.\n", GITVERSION, BuildNum, BuildTimeStr);
	}
	
    return(strlen(Params));
}

int8_t InitFpgaCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\n\nInitFpga: Initializing...");

	int err = CGraphPZTProtoHardwareMmapper::open(MmapHandle, PZT);
	
	if (err < 0) { printf("\n\nInitFpga: Coudn't connect to hardware: %d", err); }
	
	return(ParamsLen);
}

int8_t DeInitFpgaCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\n\nDeInitFpga: De-initializing...");

	int err = CGraphPZTProtoHardwareMmapper::close(MmapHandle, PZT);
	
	if (err < 0) { printf("\n\nDeInitFpga: Coudn't connect to hardware: %d", err); }
	
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
		printf("\nReadFpgaCommand: ");
		//~ for (addr = 0; addr <= 64; addr++)
		for (addr = 0; addr <= 128; addr++)
		{
			Buffer = *(((uint8_t*)PZT)+addr);
			printf("\n0x%.2zX: 0x%.2X ", addr, Buffer);
			printf("[%u]", Buffer);
			//~ printf(" ('%c')", Buffer);
		}	
		printf("\n\n");
    }
	else
	{
		Buffer = *(((uint8_t*)PZT)+addr);
		printf("\nReadFpgaCommand: ");
		//~ printf("\n%zu: 0x%.2X ", addr, Buffer);
		printf("\n0x%.2zX: 0x%.2X ", addr, Buffer);
		printf("[%u]", Buffer);
		printf(" ('%c')\n\n", Buffer);
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
	*(((uint8_t*)PZT)+addr) = (uint8_t)val;

	printf("\nWriteFpgaCommand: Wrote %lu to ", val);
	printf("0x%.4zX.\n", addr);
	
	return(ParamsLen);
}


int8_t PZTDacsCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    unsigned long A = 0, B = 0, C = 0;	
	if (NULL == PZT)
	{
		printf("\n\nPZTDacs: Fpga interface is not initialized! Please call InitFpga first!.");
		return(ParamsLen);
	}
	
	//Convert parameters
    int8_t numfound = sscanf(Params, "%lx,%lx,%lx", &A, &B, &C);
    if (numfound >= 3)
    {
		PZT->DacASetpoint = A;
		PZT->DacBSetpoint = B;
		PZT->DacCSetpoint = C;
		printf("\n\nPZTDacs: set to: %lx, %lx, %lx.\n", A, B, C);
		return(ParamsLen);
    }
	if (numfound >= 1)
    {
		PZT->DacASetpoint = A;
		PZT->DacBSetpoint = A;
		//~ PZT->DacBSetpoint = 0x006FFFFFUL; //Sometimes this is 100V
		//~ PZT->DacBSetpoint = 0x00CFFFFFUL; //Aaaaaand, sometimes this is 100V
		PZT->DacCSetpoint = A;
		printf("\n\nPZTDacs: set to: %lx, %lx, %lx.\n", A, A, A);
		return(ParamsLen);
    }

	A = PZT->DacASetpoint;
	B = PZT->DacBSetpoint;
	C = PZT->DacCSetpoint;
	printf("\n\nPZTDacs: current value: %lx, %lx, %lx.\n", A, B, C);
	
	//Show current A/D values:
	{
		AdcAccumulator A, B, C;
		A = PZT->AdcAAccumulator;
		B = PZT->AdcBAccumulator;
		C = PZT->AdcCAccumulator;

		double Av, Bv, Cv;
		Av = (8.192 * ((A.Samples - 0) / A.NumAccums)) / 16777216.0;
		Bv = (8.192 * ((B.Samples - 0) / B.NumAccums)) / 16777216.0;
		Cv = (8.192 * ((C.Samples - 0) / C.NumAccums)) / 16777216.0;
		
			
		//~ printf("\n\nPZTAdcs: current values: 0x%016llx, 0x%016llx, 0x%016llx; %+lld(%u), %+lld(%u), %+lld(%u), %+1.3lf, %+1.3lf, %+1.3lf\n", A.all, B.all, C.all, A.Samples, A.NumAccums, B.Samples, B.NumAccums, C.Samples, C.NumAccums, (4.096 * (A.Samples / A.NumAccums)) / 16777216.0, (4.096 * (B.Samples / B.NumAccums)) / 16777216.0, (4.096 * (C.Samples / C.NumAccums)) / 16777216.0);
		printf("\nPZTDacs: Sensor A/D's: 0x%016llx, 0x%016llx, 0x%016llx; %+lld(%u), %+lld(%u), %+lld(%u), %+1.3lf, %+1.3lf, %+1.3lf\n", A.all, B.all, C.all, A.Samples, A.NumAccums, B.Samples, B.NumAccums, C.Samples, C.NumAccums, Av, Bv, Cv);
	}
	
	//~ printf("\n\nPZTdaca: D/A registers at: %u, %u, %u.\n", offsetof(CGraphPZTHardwareInterface, DacASetpoint), offsetof(CGraphPZTHardwareInterface, DacBSetpoint), offsetof(CGraphPZTHardwareInterface, DacCSetpoint));
	
    return(ParamsLen);
}

int8_t VoltageCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	double VA = 0.0, VB = 0.0, VC = 0.0;	
	unsigned long A = 0, B = 0, C = 0;	
	
	if (NULL == PZT)
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
		PZT->DacASetpoint = A;
		PZT->DacBSetpoint = B;
		PZT->DacCSetpoint = C;
		printf("\n\nVoltage: set to: %3.1lf (%lx), %3.1lf (%lx), %3.1lf (%lx).\n", VA, A, VB, B, VC, C);
		return(ParamsLen);
    }
	if (numfound >= 1)
    {
		PZT->DacASetpoint = A;
		PZT->DacBSetpoint = A;
		//~ PZT->DacBSetpoint = 0x006FFFFFUL; //Sometimes this is 100V
		//~ PZT->DacBSetpoint = 0x00CFFFFFUL; //Aaaaaand, sometimes this is 100V
		PZT->DacCSetpoint = A;
		printf("\n\nVoltage: set to: %3.1lf (%lx), %3.1lf (%lx), %3.1lf (%lx).\n", VA, A, VB, B, VC, C);
		return(ParamsLen);
    }

	A = PZT->DacASetpoint;
	B = PZT->DacBSetpoint;
	C = PZT->DacCSetpoint;
	
	VA = 4.096 * (double)(A) / ((double)(0x00FFFFFFUL) * 60.0);
	VB = 4.096 * (double)(A) / ((double)(0x00FFFFFFUL) * 60.0);
	VC = 4.096 * (double)(A) / ((double)(0x00FFFFFFUL) * 60.0);
	
	printf("\n\nVoltage: current values: %3.1lf (%lx), %3.1lf (%lx), %3.1lf (%lx).\n", VA, A, VB, B, VC, C);
	
	return(ParamsLen);	
}

int8_t PZTAdcsCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//~ size_t cycle = 0;
	//~ int key = 0;

	if (NULL == PZT)
	{
		printf("\n\nPZTAdcs: Fpga interface is not initialized! Please call InitFpga first!.");
		return(ParamsLen);
	}
	
	//~ while(true)
	//~ {
		//~ cycle++;
		
		//Show current A/D values:
		{
			AdcAccumulator A, B, C;
			A = PZT->AdcAAccumulator;
			B = PZT->AdcBAccumulator;
			C = PZT->AdcCAccumulator;

			double Av, Bv, Cv;
			Av = (8.192 * ((A.Samples - 0) / A.NumAccums)) / 16777216.0;
			Bv = (8.192 * ((B.Samples - 0) / B.NumAccums)) / 16777216.0;
			Cv = (8.192 * ((C.Samples - 0) / C.NumAccums)) / 16777216.0;
			
				
			//~ printf("\n\nPZTAdcs: current values: 0x%016llx, 0x%016llx, 0x%016llx; %+lld(%u), %+lld(%u), %+lld(%u), %+1.3lf, %+1.3lf, %+1.3lf\n", A.all, B.all, C.all, A.Samples, A.NumAccums, B.Samples, B.NumAccums, C.Samples, C.NumAccums, (4.096 * (A.Samples / A.NumAccums)) / 16777216.0, (4.096 * (B.Samples / B.NumAccums)) / 16777216.0, (4.096 * (C.Samples / C.NumAccums)) / 16777216.0);
			printf("\nPZTAdcs: current values: 0x%016llx, 0x%016llx, 0x%016llx; %+lld(%u), %+lld(%u), %+lld(%u), %+1.3lf, %+1.3lf, %+1.3lf\n", A.all, B.all, C.all, A.Samples, A.NumAccums, B.Samples, B.NumAccums, C.Samples, C.NumAccums, Av, Bv, Cv);
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
				//~ printf("\n\nPZTAdcs: Keypress(%d); exiting.\n", key);
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
			//~ A = PZT->AdcAAccumulator;
			//~ B = PZT->AdcBAccumulator;
			//~ C = PZT->AdcCAccumulator;

			//~ double Av, Bv, Cv;
			//~ Av = (4.096 * ((A.Samples - 0) / A.NumAccums)) / 8388608.0;
			//~ Bv = (4.096 * ((B.Samples - 0) / B.NumAccums)) / 8388608.0;
			//~ Cv = (4.096 * ((C.Samples - 0) / C.NumAccums)) / 8388608.0;
			
			//~ printf("\n\nBIST: current A/D values: 0x%016llx, 0x%016llx, 0x%016llx; %+lld(%u), %+lld(%u), %+lld(%u), %+1.3lf, %+1.3lf, %+1.3lf; %u, %u, %u.\n", A.all, B.all, C.all, A.Samples, A.NumAccums, B.Samples, B.NumAccums, C.Samples, C.NumAccums, Av, Bv, Cv, offsetof(CGraphPZTHardwareInterface, AdcAAccumulator), offsetof(CGraphPZTHardwareInterface, AdcBAccumulator), offsetof(CGraphPZTHardwareInterface, AdcCAccumulator));
		//~ }
		
		//~ //Update the D/A's every so often
		//~ if (0 == cycle % 4)
		//~ {
			//~ PZT->DacASetpoint = daca;
			//~ //PZT->DacBSetpoint = daca;
			//~ PZT->DacBSetpoint = 0x00CFFFFFUL;
			//~ PZT->DacCSetpoint = daca;
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
				case 2: { formatf("P24V: %3.6lf V\n", MonitorAdc.GetP24V()); break; }
				case 3: { formatf("P2V5: %3.6lf V\n", MonitorAdc.GetP2V5()); break; }
				case 4: { formatf("P3V3A: %3.6lf V\n", MonitorAdc.GetP3V3A()); break; }
				case 5: { formatf("P6V: %3.6lf V\n", MonitorAdc.GetP6V()); break; }
				case 6: { formatf("P5V: %3.6lf V\n", MonitorAdc.GetP5V()); break; }
				case 7: { formatf("P3V3D: %3.6lf V\n", MonitorAdc.GetP3V3D()); break; }
				case 8: { formatf("P4V3: %3.6lf V\n", MonitorAdc.GetP4V3()); break; }
				case 9: { formatf("N5V: %3.6lf V\n", MonitorAdc.GetN5V()); break; }
				case 10: { formatf("N6V: %3.6lf V\n", MonitorAdc.GetN6V()); break; }
				case 11: { formatf("P150V: %3.6lf V\n\n\n", MonitorAdc.GetP150V()); break; }
				default : { }
			}
		}
		
		//Quit on any keypress
		{
			struct termios argin, argout;
			tcgetattr(0,&argin);
			argout = argin;
			argout.c_lflag &= ~(ICANON);
			argout.c_iflag &= ~(ICRNL);
			argout.c_oflag &= ~(OPOST);
			argout.c_cc[VMIN] = 1;
			argout.c_cc[VTIME] = 0;
			tcsetattr(0,TCSADRAIN,&argout);
			//read(0, &key, 1);
			ioctl(0, FIONREAD, &key);
			tcsetattr(0,TCSADRAIN,&argin);
			if (0 != key) 
			{ 
				fflush(stdin);
				printf("\n\nBIST: Keypress(%d); exiting.\n", key);
				break; 
			}			
		}

		struct timespec sleeptime;
		memset((char *)&sleeptime,0,sizeof(sleeptime));
		sleeptime.tv_nsec = 100000000; //100ms
		//~ sleeptime.tv_nsec = 10000000; //10ms
		//~ sleeptime.tv_nsec = 1000000; //1ms
		//sleeptime.tv_sec = 1;
		nanosleep(&sleeptime, NULL);
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
			PZT->DacASetpoint = daca;
			PZT->DacBSetpoint = dacb;
			//~ PZT->DacBSetpoint = 0x00AAAAAAUL;
			//~ PZT->DacBSetpoint = 0x006FFFFFUL;
			//~ PZT->DacBSetpoint = 0x00CFFFFFUL;
			PZT->DacCSetpoint = dacc;
			//~ printf("\n\nBIST: D/A's set to: %lx, %lx, %lx.\n", daca, 0x006FFFFFUL, dacc);	

			unsigned long rba = PZT->DacASetpoint;
			unsigned long rbb = PZT->DacBSetpoint;
			unsigned long rbc = PZT->DacCSetpoint;
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
			struct termios argin, argout;
			tcgetattr(0,&argin);
			argout = argin;
			argout.c_lflag &= ~(ICANON);
			argout.c_iflag &= ~(ICRNL);
			argout.c_oflag &= ~(OPOST);
			argout.c_cc[VMIN] = 1;
			argout.c_cc[VTIME] = 0;
			tcsetattr(0,TCSADRAIN,&argout);
			//read(0, &key, 1);
			ioctl(0, FIONREAD, &key);
			tcsetattr(0,TCSADRAIN,&argin);
			if (0 != key) 
			{ 
				fflush(stdin);
				printf("\n\nCircles: Keypress(%d); exiting.\n", key);
				break; 
			}			
		}

		struct timespec sleeptime;
		memset((char *)&sleeptime,0,sizeof(sleeptime));
		//~ sleeptime.tv_nsec = 100000000; //100ms
		//~ sleeptime.tv_nsec = 10000000; //10ms
		//~ sleeptime.tv_nsec = 1000000; //1ms
		sleeptime.tv_nsec = delayinms * 1000000.0;
		//sleeptime.tv_sec = 1;
		nanosleep(&sleeptime, NULL);
	}
	
	return(ParamsLen);
}

int8_t GoXYCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    unsigned long A = 0, B = 0, C = 0;
	
	if (NULL == PZT)
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
	
	PZT->DacASetpoint = A;
	PZT->DacBSetpoint = 0x006FFFFFUL;
	PZT->DacBSetpoint = 0x00CFFFFFUL;
	PZT->DacCSetpoint = C;
	printf("\n\nGoXY: set to: %lx, %lx, %lx.\n", A, 0x00CFFFFFUL, C);


	A = PZT->DacASetpoint;
	B = PZT->DacBSetpoint;
	C = PZT->DacCSetpoint;
	printf("\n\nGoXY: current value: %lx, %lx, %lx (%lfV x %lfV).\n", A, B, C, X * 100.0, Y * 100.0);
	
	//Show current A/D values:
	{
		AdcAccumulator A, B, C;
		A = PZT->AdcAAccumulator;
		B = PZT->AdcBAccumulator;
		C = PZT->AdcCAccumulator;

		double Av, Bv, Cv;
		Av = (8.192 * ((A.Samples - 0) / A.NumAccums)) / 16777216.0;
		Bv = (8.192 * ((B.Samples - 0) / B.NumAccums)) / 16777216.0;
		Cv = (8.192 * ((C.Samples - 0) / C.NumAccums)) / 16777216.0;
		
			
		//~ printf("\n\nPZTAdcs: current values: 0x%016llx, 0x%016llx, 0x%016llx; %+lld(%u), %+lld(%u), %+lld(%u), %+1.3lf, %+1.3lf, %+1.3lf\n", A.all, B.all, C.all, A.Samples, A.NumAccums, B.Samples, B.NumAccums, C.Samples, C.NumAccums, (4.096 * (A.Samples / A.NumAccums)) / 16777216.0, (4.096 * (B.Samples / B.NumAccums)) / 16777216.0, (4.096 * (C.Samples / C.NumAccums)) / 16777216.0);
		printf("\nGoXY: Sensor A/D's: 0x%016llx, 0x%016llx, 0x%016llx; %+lld(%u), %+lld(%u), %+lld(%u), %+1.3lf, %+1.3lf, %+1.3lf\n", A.all, B.all, C.all, A.Samples, A.NumAccums, B.Samples, B.NumAccums, C.Samples, C.NumAccums, Av, Bv, Cv);
	}
	
	//~ printf("\n\nPZTdaca: D/A registers at: %u, %u, %u.\n", offsetof(CGraphPZTHardwareInterface, DacASetpoint), offsetof(CGraphPZTHardwareInterface, DacBSetpoint), offsetof(CGraphPZTHardwareInterface, DacCSetpoint));
	
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
	
	//~ printf("\nUartCommand: PZT@0x%p, USR@%u, UF@%u, MAA@%u, ACF@%u, ACF is %u, ", (void*)PZT, offsetof(CGraphPZTHardwareInterface, UartStatusRegister), offsetof(CGraphPZTHardwareInterface, UartFifo), offsetof(CGraphPZTHardwareInterface, MonitorAdcAccumulator), offsetof(CGraphPZTHardwareInterface, AdcCFifo), sizeof(AdcFifo));
	printf("\nUartCommand: %u, %u. ", offsetof(CGraphPZTHardwareInterface, UartFifo2), offsetof(CGraphPZTHardwareInterface, UartStatusRegister2));
	
	if (0 == strncmp(&(Params[1]), "loop", 4))
	{
		while(true)
		{
			//~ PZT->UartFifo0 = 0x55;
			//~ PZT->UartFifo1 = 0x55;	
			PZT->UartFifo2 = 0x55;
			
			//Quit on any keypress
			{
				struct termios argin, argout;
				tcgetattr(0,&argin);
				argout = argin;
				argout.c_lflag &= ~(ICANON);
				argout.c_iflag &= ~(ICRNL);
				argout.c_oflag &= ~(OPOST);
				argout.c_cc[VMIN] = 1;
				argout.c_cc[VTIME] = 0;
				tcsetattr(0,TCSADRAIN,&argout);
				//read(0, &key, 1);
				ioctl(0, FIONREAD, &key);
				tcsetattr(0,TCSADRAIN,&argin);
				if (0 != key) 
				{ 
					fflush(stdin);
					printf("\n\nCircles: Keypress(%d); exiting.\n", key);
					break; 
				}			
			}
		}
	}
	
	//~ CGraphPZTUartStatusRegister UartStatus = PZT->UartStatusRegister2;
	//~ UartStatus.printf();	
	
	//~ printf("; about to write to uart... ");	
	//~ PZT->UartFifo = 'H';
	//~ nanosleep(&sleeptime, NULL);
	//~ PZT->UartFifo = 'e';
	//~ nanosleep(&sleeptime, NULL);
	//~ PZT->UartFifo = 'l';
	//~ nanosleep(&sleeptime, NULL);
	//~ PZT->UartFifo = 'l';
	//~ nanosleep(&sleeptime, NULL);
	//~ PZT->UartFifo = 'o';
	//~ nanosleep(&sleeptime, NULL);
	//~ PZT->UartFifo = '!';
	//~ nanosleep(&sleeptime, NULL);
	
	//~ UartStatus = PZT->UartStatusRegister; 
	//~ printf("; uart written; ");	
	//~ UartStatus.printf();	
	
	//~ CGraphPZTUartStatusRegister UartStatus2;
	
	//~ for(size_t i = 0; i < 100000; i++)
	//~ { 
		//~ UartStatus = PZT->UartStatusRegister; 
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
		//~ printf(":%.2X", PZT->UartFifo);
		//~ UartStatus = PZT->UartStatusRegister; 		
	//~ }
	
	//~ {
		//~ //clear buffer:
		//~ PZT->UartStatusRegister.all = 1;
	//~ }
	
	//~ printf(":%.4X", PZT->UartFifo2);
	
	//~ printf("\n");
	//~ UartStatus.printf();	
	
	CGraphVersionPayload Version;
    Version.SerialNum = 0;
	Version.ProcessorFirmwareBuildNum = BuildNum;
	Version.FPGAFirmwareBuildNum = 0;
	if (PZT) 
	{ 
		Version.SerialNum = PZT->DeviceSerialNumber; 
		Version.FPGAFirmwareBuildNum = PZT->FpgaFirmwareBuildNumber; 
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
	
	if (NULL == PZT)
	{
		printf("\n\nBaudDividers: Fpga interface is not initialized! Please call InitFpga first!.");
		return(ParamsLen);
	}
	
	//Convert parameters
    int8_t numfound = sscanf(Params, "%lu,%lu,%lu", &A, &B, &C);
    if (numfound >= 3)
    {
		PZT->BaudDivider0 = A;
		PZT->BaudDivider1 = B;
		PZT->BaudDivider2 = C;
		printf("\n\nBaudDividers: setting to: %lu, %lu, %lu.\n", A, B, C);
    }
	else
	{
		if (numfound >= 1)
		{
			PZT->BaudDivider0 = A;
			PZT->BaudDivider1 = A;
			//~ PZT->DacBSetpoint = 0x006FFFFFUL; //Sometimes this is 100V
			//~ PZT->DacBSetpoint = 0x00CFFFFFUL; //Aaaaaand, sometimes this is 100V
			PZT->BaudDivider2 = A;
			printf("\n\nBaudDividers: setting to: %lu, %lu, %lu.\n", A, A, A);
		}
	}
	
	A = PZT->BaudDivider0;
	B = PZT->BaudDivider1;
	C = PZT->BaudDivider2;
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
	printf("; SocketHandler: ");
	ClientConnections[0].SocketHandler.formatf();
	printf("\n\n");
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
		
		printf("\n\nMonitorSerialCommand: Monitoring port %lu: %c.\n", port, OnOff?'Y':'N');
		
		switch(port)
		{
			case 0 : { MonitorSerial0 = OnOff; break; }			
			case 1 : { MonitorSerial1 = OnOff; break; }			
			case 2 : { MonitorSerial2 = OnOff; break; }			
			default : 
			{ 
				printf("\n\nMonitorSerialCommand: Invalid port %lu; max is #2.\n", port);
			}
		}
			
		return(strlen(Params));
    }
	
	printf("\n\nMonitorSerialCommand: Insufficient parameters (%u; should be 2); querying...", numfound);

	printf("\nMonitorSerialCommand: Monitoring port 0: %c.\n", MonitorSerial0?'Y':'N');
	printf("\nMonitorSerialCommand: Monitoring port 1: %c.\n", MonitorSerial1?'Y':'N');
	printf("\nMonitorSerialCommand: Monitoring port 2: %c.\n", MonitorSerial2?'Y':'N');	
	
    return(strlen(Params));
}


//EOF


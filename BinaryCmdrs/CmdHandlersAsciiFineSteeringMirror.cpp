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

#ifndef WIN32
//kbhit
#include <termios.h>
#endif

#include <sys/types.h>
#include <sys/stat.h>
#ifndef WIN32
#include <sys/ioctl.h>
#endif
#include <fcntl.h>
#include <unistd.h>
//~ #ifndef WIN32
//~ #include <sys/mman.h>
//~ #endif
#include <errno.h>
#include <unordered_map>
using namespace std;

//~ #include <mcheck.h>
#include "dbg/memwatch.h"

#include "uart/AsciiCmdUserInterfaceLinux.h"

//~ #include "../MonitorAdc.hpp"
//~ extern CGraphFSMMonitorAdc MonitorAdc;

#include "cgraph/CGraphPacket.hpp"

#include "uart/BinaryUart.hpp"
extern BinaryUart UartParser;

int8_t FSMDacsCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    unsigned long A = 0, B = 0, C = 0;
	uint32_t DacSetpoints[3];
	
	//Convert parameters
    int8_t numfound = sscanf(Params, "%lx,%lx,%lx", &A, &B, &C);
    if (numfound >= 3)
    {
		DacSetpoints[0] = A;
		DacSetpoints[1] = B;
		DacSetpoints[2] = C;
		TxBinaryPacket(&UartParser, CGraphPayloadTypeFSMDacs, 0, DacSetpoints, 3 * sizeof(uint32_t));
		
		printf("\n\nFSMDacs: set to: %x, %x, %x.\n", DacSetpoints[0], DacSetpoints[1], DacSetpoints[2]);
		return(ParamsLen);
    }
	if (numfound >= 1)
    {
		DacSetpoints[0] = A;
		DacSetpoints[1] = A;
		DacSetpoints[2] = A;
		TxBinaryPacket(&UartParser, CGraphPayloadTypeFSMDacs, 0, DacSetpoints, 3 * sizeof(uint32_t));
		
		printf("\n\nFSMDacs: set to: %x, %x, %x.\n", DacSetpoints[0], DacSetpoints[1], DacSetpoints[2]);
		return(ParamsLen);
    }

	//No params? Just query it...
	printf("\n\nFSMDacs: Querying...\n");
	TxBinaryPacket(&UartParser, CGraphPayloadTypeFSMDacs, 0, NULL, 0);
    return(ParamsLen);
}

int8_t FSMAdcsCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\n\nFSMAdcs: Querying...\n");
	TxBinaryPacket(&UartParser, CGraphPayloadTypeFSMAdcs, 0, NULL, 0);
    return(ParamsLen);
}


int8_t FSMTelemetryCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	printf("\n\nFSMTelemetry: Querying...\n");
	TxBinaryPacket(&UartParser, CGraphPayloadTypeFSMTelemetry, 0, NULL, 0);
    return(ParamsLen);
}

int8_t FSMCirclesCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	uint32_t DacSetpoints[3];
	size_t cycle = 0;
	unsigned long daca = 0;
	unsigned long dacb = 0;
	unsigned long dacc = 0;
	int key = 1;
	
	double radius = 1.0;
	double delayinms = 1.0; //1ms
	sscanf(Params, "%lf,%lf", &radius, &delayinms);
	if (radius < 0.0) { radius = 0.0; }
	if (radius > 1.0) { radius = 1.0; }
	if (delayinms < 0.001) { delayinms = 0.001; }
	if (delayinms > 10000) { delayinms = 10000; }
	
	printf("\n\nFSMCircles: RunCircle(%lf, %lfms)...\n", radius, delayinms);	
	    	
	while(true)
	{
		cycle++;
		
		//Update the D/A's every so often
		{
			DacSetpoints[0] = daca;
			DacSetpoints[1] = dacb;
			DacSetpoints[2] = dacc;
			TxBinaryPacket(&UartParser, CGraphPayloadTypeFSMDacs, 0, DacSetpoints, 3 * sizeof(uint32_t));
			
			double ang = (double)(cycle % 60) * 6.0;
			double rada = (ang / 360.0) * 6.28;
			double radb = ((ang + 120) / 360.0) * 6.28;
			double radc = ((ang + 240) / 360.0) * 6.28;
			double carta = ((sin(rada) + 1.0) / 2.0) * radius;
			double cartb = ((sin(radb) + 1.0) / 2.0) * radius;
			double cartc = ((sin(radc) + 1.0) / 2.0) * radius;
			daca = (unsigned long)(carta * 0x00CFFFFFUL);
			dacb = (unsigned long)(cartb * 0x00CFFFFFUL);
			dacc = (unsigned long)(cartc * 0x00CFFFFFUL);
			//~ printf("\n%lu, %lu, %lu", daca, dacb, dacc);
			
			for (size_t i = 0; i < 1024; i++)
			{
				//~ UartParser.Process();
			}
		}
		
		//Quit on any keypress
		{
			#ifndef WIN32
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
			#endif
			if (0 != key) 
			{ 
				fflush(stdin);
				printf("\n\nFSMCircles: Keypress(%d); exiting.\n", key);
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

int8_t FSMGoXYCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    uint32_t DacSetpoints[3];
	unsigned long A = 0, C = 0;
		
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
	
	DacSetpoints[0] = A;
	DacSetpoints[1] = 0x006FFFFFUL;
	//~ DacSetpoints[1] = 0x00CFFFFFUL;
	DacSetpoints[2] = C;
	TxBinaryPacket(&UartParser, CGraphPayloadTypeFSMDacs, 0, DacSetpoints, 3 * sizeof(uint32_t));
	printf("\n\nFSMGoXY: set to: %lx, %lx, %lx.\n", A, 0x006FFFFFUL, C);

	//~ printf("\n\nFSMdaca: D/A registers at: %u, %u, %u.\n", offsetof(CGraphFSMHardwareInterface, DacASetpoint), offsetof(CGraphFSMHardwareInterface, DacBSetpoint), offsetof(CGraphFSMHardwareInterface, DacCSetpoint));
	
    return(ParamsLen);
}

int8_t ControlRegisterCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	CGraphFSMHardwareControlRegister cr;
	char c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17;
	bool o1=false, o2=false, o3=false, o4=false, o5=false, o6=false, o7=false, o8=false, o9=false, o10=false, o11=false, o12=false, o13=false, o14=false, o15=false, o16=false, o17=false;
    
	if (NULL == FSM)
	{
		formatf("\nControlRegisterCommand: Fpga interface is not initialized!");
		return(ParamsLen);
	}
	
    int8_t numfound = sscanf(Params, " %c, %c, %c, %c, %c, %c, %c, %c, %c, %c, %c, %c, %c, %c, %c, %c, %c", &c1, &c2, &c3, &c4, &c5, &c6, &c7, &c8, &c9, &c10, &c11, &c12, &c13, &c14, &c15, &c16, &c17);
    if (numfound >= 1)
    {
		if ( ('Y' == c1) || ('y' == c1) || ('T' == c1) || ('t' == c1) || ('1' == c1) ) { o1 = true; }
		if ( ('Y' == c2) || ('y' == c2) || ('T' == c2) || ('t' == c2) || ('1' == c2) ) { o2 = true; }
		if ( ('Y' == c3) || ('y' == c3) || ('T' == c3) || ('t' == c3) || ('1' == c3) ) { o3 = true; }
		if ( ('Y' == c4) || ('y' == c4) || ('T' == c4) || ('t' == c4) || ('1' == c4) ) { o4 = true; }
		if ( ('Y' == c5) || ('y' == c5) || ('T' == c5) || ('t' == c5) || ('1' == c5) ) { o5 = true; }
		if ( ('Y' == c6) || ('y' == c6) || ('T' == c6) || ('t' == c6) || ('1' == c6) ) { o6 = true; }
		if ( ('Y' == c7) || ('y' == c7) || ('T' == c7) || ('t' == c7) || ('1' == c7) ) { o7 = true; }
		if ( ('Y' == c8) || ('y' == c8) || ('T' == c8) || ('t' == c8) || ('1' == c8) ) { o8 = true; }
		if ( ('Y' == c9) || ('y' == c9) || ('T' == c9) || ('t' == c9) || ('1' == c9) ) { o9 = true; }
		if ( ('Y' == c10) || ('y' == c10) || ('T' == c10) || ('t' == c10) || ('1' == c10) ) { o10 = true; }
		if ( ('Y' == c11) || ('y' == c11) || ('T' == c11) || ('t' == c11) || ('1' == c11) ) { o11 = true; }
		if ( ('Y' == c12) || ('y' == c12) || ('T' == c12) || ('t' == c12) || ('1' == c12) ) { o12 = true; }
		if ( ('Y' == c13) || ('y' == c13) || ('T' == c13) || ('t' == c13) || ('1' == c13) ) { o13 = true; }
		if ( ('Y' == c14) || ('y' == c14) || ('T' == c14) || ('t' == c14) || ('1' == c14) ) { o14 = true; }
		if ( ('Y' == c15) || ('y' == c15) || ('T' == c15) || ('t' == c15) || ('1' == c15) ) { o15 = true; }
		if ( ('Y' == c16) || ('y' == c16) || ('T' == c16) || ('t' == c16) || ('1' == c16) ) { o16 = true; }
		if ( ('Y' == c17) || ('y' == c17) || ('T' == c17) || ('t' == c17) || ('1' == c17) ) { o17 = true; }

		cr.PowerCycdAndClr = o1;
		cr.PowernEn = o2;
		cr.ChopEn = o3;
		cr.ChopRefState = o4;
		cr.ChopAdcState = o5;
		cr.Uart0OE = o6;
		cr.Uart1OE = o7;
		cr.Uart2OE = o8;
		cr.Uart3OE = o9;
		cr.Ux1SelJmp = o10;
		cr.PPSDetectedAndRst = o11;
		cr.PowernEnHV = o12;
		cr.HVEn1 = o13;
		cr.HVEn2 = o14;
		cr.DacSelectMaxti = o15;
		cr.GlobalFaultInhibit = o16;
		cr.nFaultsClr = o17;
		
		FSM->ControlRegister = cr;
	}		
	
	cr = FSM->ControlRegister;

	formatf("\nControlRegisterCommand: Current values: ");
	cr.formatf();
	
    return(strlen(Params));
}

int8_t ConfigAdcCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	AdcConfigRegister cr;
	AccumulatorConfigRegister ar;
	unsigned long A = 0, B = 0, C, D;
	
	if (NULL == FSM)
	{
		formatf("\n\nConfigAdc: Fpga interface is not initialized! Please call InitFpga first!.");
		return(ParamsLen);
	}
	
	//Convert parameters
    int8_t numfound = sscanf(Params, "%lu,%lu,%lu,%lu", &A, &B, &C, &D);
    if (numfound >= 2)
    {
		cr.AdcClkDivider = A;
		cr.AdcSamplesToAverage = B;
		formatf("\n\nConfigAdc: setting AdcConfig to: ");
		cr.formatf();
		formatf("\n");
		FSM->AdcConfig = cr;
    }
	if (numfound >= 4)
    {
		ar.ControlAdcMaxAccums = C;
		ar.MonitorAdcMaxAccums = D;
		formatf("\n\nConfigAdc: setting AccumConfig to: ");
		ar.formatf();
		formatf("\n");
		FSM->AccumConfig = ar;
    }
	
	cr = FSM->AdcConfig;
	ar = FSM->AccumConfig;
	formatf("\n\nConfigAdc: current values: ");
	cr.formatf();
	formatf("; ");
	ar.formatf();
	formatf("\n");
	
	return(ParamsLen);
}

int8_t ConfigDacCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	DacConfigRegister cr;
	unsigned long A = 0;
	
	if (NULL == FSM)
	{
		formatf("\n\nConfigDacCommand: Fpga interface is not initialized! Please call InitFpga first!.");
		return(ParamsLen);
	}
	
	//Convert parameters
    int8_t numfound = sscanf(Params, "%lu", &A);
    if (numfound >= 1)
    {
		cr.DitherClkDivider = A;
		formatf("\n\nConfigDacCommand: setting DacConfig to: ");
		cr.formatf();
		formatf("\n");
		FSM->DacConfig = cr;
    }
	
	cr = FSM->DacConfig;
	formatf("\n\nConfigDacCommand: current values: ");
	cr.formatf();
	formatf("\n");
	
	return(ParamsLen);
}

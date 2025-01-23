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
	int key = 0;
	
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

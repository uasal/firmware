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

int8_t DMDacCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//~ unsigned long A = 0, B = 0, C = 0, D = 0;
	//~ uint32_t DacSetpoints[4];
	
	//~ //Convert parameters
        //~ int8_t numfound = sscanf(Params, "%lx,%lx,%lx,%lx", &A, &B, &C, &D);
    //~ if (numfound >= 4)
    //~ {
		//~ DacSetpoints[0] = A;
		//~ DacSetpoints[1] = B;
		//~ DacSetpoints[2] = C;
                //~ DacSetpoints[3] = D;
		//~ TxBinaryPacket(&UartParser, CGraphPayloadTypeDMDac, 0, DacSetpoints, 4 * sizeof(uint32_t));
		
		//~ printf("\n\nDMDacs: set to: %x, %x, %x, %x.\n", DacSetpoints[0], DacSetpoints[1], DacSetpoints[2], DacSetpoints[3]);
		//~ return(ParamsLen);
    //~ }
	
	//~ //No params? Just query it...
	//~ printf("\n\nDMDacs: Querying...\n");
	//~ TxBinaryPacket(&UartParser, CGraphPayloadTypeDMDac, 0, NULL, 0);
    return(ParamsLen);
}

int8_t DMHVSwitchCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    //~ unsigned long A = 0, B = 0;
    //~ uint32_t HVSwitchParams[2];
	
    //~ size_t numfound = 0;
    //~ if (numfound >= 2)
    //~ {
		//~ HVSwitchParams[0] = A;
		//~ HVSwitchParams[1] = B;
		//~ TxBinaryPacket(&UartParser, CGraphPayloadTypeDMHVSwitch, 0, HVSwitchParams, 2 * sizeof(uint32_t));
		
		//~ printf("\n\nHVSwitchCommand: set to: %x, %x.\n", HVSwitchParams[0], HVSwitchParams[1]);
		//~ return(ParamsLen);
    //~ }

    //~ //No params? Just query it...
    //~ printf("\n\nHVSwitchCommand: Querying...\n");
    //~ TxBinaryPacket(&UartParser, CGraphPayloadTypeDMHVSwitch, 0, NULL, 0);
    return(ParamsLen);
}

int8_t DMTelemetryCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
  //~ printf("\n\nTelemetryCommand: Querying...\n");
  //~ TxBinaryPacket(&UartParser, CGraphPayloadTypeDMTelemetry, 0, NULL, 0);
  return(ParamsLen);
}

int8_t DMDacConfigCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
  //~ printf("\n\nDacConfigCommand: Sent...\n");
  //~ TxBinaryPacket(&UartParser, CGraphPayloadTypeDMDacConfig, 0, NULL, 0);
  return(ParamsLen);
}

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

#include <stdint.h>
#include "uart/CmdSystem.hpp"
#include "uart/CGraphPacket.hpp"
#include "CmdTableBinary.hpp"

/* Which FPGA are we programming? */
#define Ux1
#undef  Ux2

//#undef  Ux1
//#define Ux2

///The actual table (array) of commands for the system - links with CmdSystem.cpp.o
/* Table of Ux1 Commands */
#ifdef Ux1
const BinaryCmd BinaryCmds[] = 
{
	BinaryCmd (
		CGraphPayloadTypeVersion,
		"BinaryVersionCommand",
		BinaryVersionCommand
    ),
	BinaryCmd (
		CGraphPayloadTypeDMDacs,
		"BinaryDMDacsCommand",
		BinaryDMDacsCommand
    ),	
	BinaryCmd (
		CGraphPayloadTypeDMStatus,
		"BinaryDMStatusCommand",
		BinaryDMStatusCommand
    ),
        BinaryCmd (
                CGraphPayloadTypeDMConfigDacs,
                "BinaryDMConfigDacsCommand",
                BinaryDMConfigDacsCommand
    ),
        BinaryCmd (
                CGraphPayloadTypeDMVector,
                "BinaryDMVectorCommand",
                BinaryDMVectorCommand
    ),
        BinaryCmd (
                CGraphPayloadTypeDMUart,
                "BinaryDMUartCommand",
                BinaryDMUartCommand
    ),
};
#endif

#ifdef Ux2
const BinaryCmd BinaryCmds[] = 
{
	BinaryCmd (
		CGraphPayloadTypeVersion,
		"BinaryVersionCommand",
		BinaryVersionCommand
    ),
	BinaryCmd (
		CGraphPayloadTypeDMAdcs,
		"BinaryDMAdcsCommand",
		BinaryDMAdcsCommand
    ),
	BinaryCmd (
		CGraphPayloadTypeDMAdcsFloatingPoint,
		"BinaryDMAdcsFloatingPointCommand",
		BinaryDMAdcsFloatingPointCommand
    ),	
	BinaryCmd (
		CGraphPayloadTypeDMStatus,
		"BinaryDMStatusCommand",
		BinaryDMStatusCommand
    ),
        BinaryCmd (
                CGraphPayloadTypeHVSwitch,
                "BinaryHVSwitchCommand",
                BinaryHVSwitchCommand
    ),

};
#endif

//Calculate the number of commands instanciated in the system - links with CmdSystem.cpp.o
const uint8_t NumBinaryCmds = sizeof(BinaryCmds) / sizeof(BinaryCmds[0]);

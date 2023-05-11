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
/// $Source: /raincloud/src/clients/zonge/Zeus/Zeus3/firmware/arm/main/CmdHandlersSchedule.cpp,v $
/// $Revision: 1.7 $
/// $Date: 2010/06/08 23:52:38 $
/// $Author: steve $

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <limits.h>

#include "uart/CmdSystem.hpp" 

#include "rf/ChannelTableEntry.hpp"

#include "MainBuildNum"

#include "ClientConnection.hpp"

#include "CmdTableAscii.hpp"

//~ int8_t BytesWaitingToSensorBoardCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
//~ {
	//~ if (ValidateMountainOpsBinaryRfPacket(ZongeBinaryServerSerial, Params, ParamsLen))
	//~ {
		//~ const size_t SocketIndex = reinterpret_cast<const size_t>(Argument);
		
		//~ uint32_t Depth = (uint32_t)ClientConnections[SocketIndex].DataToSensorBoard.len();
		
		//~ formatf("\nSensorBoardServer : BytesWaitingToSensorBoard: replying answer of %u to client.\n", Depth);
		
		//~ MountainOpsBinaryPacket<sizeof(uint32_t)> Packet(ZongeBinaryResponsePacketStartToken, PayloadTypeBytesWaitingToSensorBoard, ZongeBinaryServerSerial);
		//~ memcpy(Packet.Payload, &Depth, sizeof(uint32_t));
		//~ Packet.CalcCRC();
		//~ for (size_t i = 0; i < sizeof(MountainOpsBinaryPacket<sizeof(uint32_t)>); i++) { ClientConnections[SocketIndex].DataFromSensorBoard.push(Packet.AsUint8()[i]); }
	//~ }
	//~ else
	//~ {
		//~ formatf("\nSensorBoardServer : BytesWaitingToSensorBoard: corrupted packet.\n");
	//~ }

    //~ return(ParamsLen);
//~ }

//~ int8_t BytesWaitingFromSensorBoardCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
//~ {
	//~ if (ValidateMountainOpsBinaryRfPacket(ZongeBinaryServerSerial, Params, ParamsLen))
	//~ {
		//~ const size_t SocketIndex = reinterpret_cast<const size_t>(Argument);
		
		//~ uint32_t Depth = (uint32_t)ClientConnections[SocketIndex].DataFromSensorBoard.len();
		
		//~ formatf("\nSensorBoardServer : BytesWaitingFromSensorBoard: replying answer of %u to client.\n", Depth);
		
		//~ MountainOpsBinaryPacket<sizeof(uint32_t)> Packet(ZongeBinaryResponsePacketStartToken, PayloadTypeBytesWaitingFromSensorBoard, ZongeBinaryServerSerial);
		//~ memcpy(Packet.Payload, &Depth, sizeof(uint32_t));
		//~ Packet.CalcCRC();
		//~ for (size_t i = 0; i < sizeof(MountainOpsBinaryPacket<sizeof(uint32_t)>); i++) { ClientConnections[SocketIndex].DataFromSensorBoard.push(Packet.AsUint8()[i]); }
	//~ }
	//~ else
	//~ {
		//~ formatf("\nSensorBoardServer : BytesWaitingToSensorBoard: corrupted packet.\n");
	//~ }

    //~ return(ParamsLen);
//~ }

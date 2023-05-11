//~ //
//~ ///           Copyright (c) by Franks Development, LLC
//~ //
//~ // This software is copyrighted by and is the sole property of Franks
//~ // Development, LLC. All rights, title, ownership, or other interests
//~ // in the software remain the property of Franks Development, LLC. This
//~ // software may only be used in accordance with the corresponding
//~ // license agreement.  Any unauthorized use, duplication, transmission,
//~ // distribution, or disclosure of this software is expressly forbidden.
//~ //
//~ // This Copyright notice may not be removed or modified without prior
//~ // written consent of Franks Development, LLC.
//~ //
//~ // Franks Development, LLC. reserves the right to modify this software
//~ // without notice.
//~ //
//~ // Franks Development, LLC            support@franks-development.com
//~ // 500 N. Bahamas Dr. #101           http://www.franks-development.com
//~ // Tucson, AZ 85710
//~ // USA
//~ //
//~ /// \file
//~ /// $Source: /raincloud/src/clients/zonge/Zeus/Zeus3/firmware/arm/main/CmdHandlersConfig.cpp,v $
//~ /// $Revision: 1.7 $
//~ /// $Date: 2010/06/08 23:51:10 $
//~ /// $Author: steve $

//~ #include "rf/XBeeApi.h"
//~ using namespace XBeeApi;
//~ #include "rf/XBee.hpp"

//~ #include "rf/ZongeProtocol.hpp"

//~ #include "timing/ZongeHwTypes.h"

//~ #include "rf/ChannelTableEntry.hpp"

//~ #include "./../../firmware/linux/SensorBoardProcessTable.h"

//~ #include "ClientConnection.hpp"

//~ #include "SensorBoardConnection.hpp"

//~ #include "MainBuildNum"

//~ extern uint32_t SerialNum;
//~ extern uint64_t ZigPanID;
//~ extern bool ZigPanIDVerified;
//~ void SaveStateConfigToDisk();

//~ int8_t VersionCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
//~ {
	//~ if (ValidateMountainOpsBinaryRfPacket(ZongeBinaryServerSerial, Params, ParamsLen))
	//~ {
		//~ const size_t SocketIndex = reinterpret_cast<const size_t>(Argument);
		
		//~ VersionResponse VR;
		//~ VR.SerialNumber = 0;
		//~ VR.ArmFirmwareVersion = atoi(HGVERSION);
		//~ VR.ArmFirmwareBuildNumber = BuildNum;
		//~ VR.FgpaFirmwareBuildNumber = BuildNum;
		//~ VR.HardwareType = ZongeHwRadioServer;
		
		//~ formatf("\nSensorBoardServer : Version: Sending response (%u bytes): ", sizeof(VersionResponse));
		//~ VR.formatf();
		//~ formatf("\n");
		
		//~ MountainOpsBinaryPacket<sizeof(VersionResponse)> Packet(ZongeBinaryResponsePacketStartToken, PayloadTypeVersion, ZongeBinaryServerSerial);
		//~ memcpy(Packet.Payload, &VR, sizeof(VersionResponse));
		//~ Packet.CalcCRC();
		//~ for (size_t i = 0; i < sizeof(MountainOpsBinaryPacket<sizeof(VersionResponse)>); i++) { ClientConnections[SocketIndex].DataFromSensorBoard.push(Packet.AsUint8()[i]); }
	//~ }
	//~ else
	//~ {
		//~ formatf("\nSensorBoardServer : Version: corrupted packet.\n");
	//~ }

    //~ return(ParamsLen);
//~ }

//~ int8_t FlushDataToSensorBoardCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
//~ {
	//~ if (ValidateMountainOpsBinaryRfPacket(ZongeBinaryServerSerial, Params, ParamsLen))
	//~ {
		//~ const size_t SocketIndex = reinterpret_cast<const size_t>(Argument);
		
		//~ ClientConnections[SocketIndex].DataToSensorBoard.clear();
		
		//~ formatf("\nSensorBoardServer : FlushDataToSensorBoard: complete.\n");
		
		//~ MountainOpsBinaryPacket<0> Packet(ZongeBinaryResponsePacketStartToken, PayloadTypeFlushDataToSensorBoard, ZongeBinaryServerSerial);
		//~ Packet.CalcCRC();
		//~ for (size_t i = 0; i < sizeof(MountainOpsBinaryPacket<0>); i++) { ClientConnections[SocketIndex].DataFromSensorBoard.push(Packet.AsUint8()[i]); }
	//~ }
	//~ else
	//~ {
		//~ formatf("\nSensorBoardServer : FlushDataToSensorBoard: corrupted packet.\n");
	//~ }

    //~ return(ParamsLen);
//~ }

//~ int8_t FlushDataFromSensorBoardCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
//~ {
	//~ if (ValidateMountainOpsBinaryRfPacket(ZongeBinaryServerSerial, Params, ParamsLen))
	//~ {
		//~ const size_t SocketIndex = reinterpret_cast<const size_t>(Argument);
		
		//~ ClientConnections[SocketIndex].DataFromSensorBoard.clear();
		
		//~ formatf("\nSensorBoardServer : FlushDataFromSensorBoard: complete.\n");
		
		//~ MountainOpsBinaryPacket<0> Packet(ZongeBinaryResponsePacketStartToken, PayloadTypeFlushDataFromSensorBoard, ZongeBinaryServerSerial);
		//~ Packet.CalcCRC();
		//~ for (size_t i = 0; i < sizeof(MountainOpsBinaryPacket<0>); i++) { ClientConnections[SocketIndex].DataFromSensorBoard.push(Packet.AsUint8()[i]); }
	//~ }
	//~ else
	//~ {
		//~ formatf("\nSensorBoardServer : FlushDataFromSensorBoard: corrupted packet.\n");
	//~ }
	
    //~ return(ParamsLen);
//~ }

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

//~ int8_t MountSensorBoardsCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
//~ {
	//~ //Find all SensorBoards and mount them!
	//~ for (size_t j = 0; j < NumSensorBoardConnections.load(); j++) 		
	//~ {
		//~ if (SensorBoardConnections[j].IsConnected()) //only the live ones though
		//~ {
			//~ char SensorBoardIP[20];
			//~ char SensorBoardLogin[32];
			//~ char SensorBoardPath[256];
			
			//~ SensorBoardConnections[j].SensorBoardIP.sprintf(SensorBoardIP);
			//~ sprintf(SensorBoardPath, "/media/SensorBoard/%u", SensorBoardConnections[j].SensorBoardIP.O1); 
			//~ sprintf(SensorBoardLogin, "root@%s:/", SensorBoardIP); 
			
			//~ spawn("/bin/umount", "-lf", SensorBoardPath);
			//~ spawn("/bin/rm", "-r", SensorBoardPath);
			//~ spawn("/bin/mkdir -pv", SensorBoardPath);			
			//~ spawn("/usr/bin/sshfs", SensorBoardLogin, SensorBoardPath, "-ouid=1000", "-ogid=1000", "-o reconnect,ServerAliveInterval=1,ServerAliveCountMax=3,TCPKeepAlive=yes,cache_timeout=3");
			//~ spawn("/usr/bin/sshfs", SensorBoardLogin, SensorBoardPath, "-ouid=1000", "-ogid=1000");
			
			//~ printf("\nSensorBoardServer: MountingSensorBoard[%u] on %s at %s.", (unsigned)j, SensorBoardLogin, SensorBoardPath);
		//~ }
	//~ }

    //~ return(ParamsLen);
//~ }

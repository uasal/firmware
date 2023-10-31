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

//~ #include "./../../firmware/linux/ZenProcessTable.h"

//~ #include "ClientConnection.hpp"

//~ #include "ZenConnection.hpp"

//~ #include "MainBuildNum"

//~ extern uint32_t SerialNum;
//~ extern uint64_t ZigPanID;
//~ extern bool ZigPanIDVerified;
//~ void SaveStateConfigToDisk();

//~ int8_t VersionCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
//~ {
	//~ if (ValidateZenBinaryRfPacket(ZongeBinaryServerSerial, Params, ParamsLen))
	//~ {
		//~ const size_t SocketIndex = reinterpret_cast<const size_t>(Argument);
		
		//~ VersionResponse VR;
		//~ VR.SerialNumber = 0;
		//~ VR.ArmFirmwareVersion = atoi(HGVERSION);
		//~ VR.ArmFirmwareBuildNumber = BuildNum;
		//~ VR.FgpaFirmwareBuildNumber = BuildNum;
		//~ VR.HardwareType = ZongeHwRadioServer;
		
		//~ formatf("\nZen457Server : Version: Sending response (%u bytes): ", sizeof(VersionResponse));
		//~ VR.formatf();
		//~ formatf("\n");
		
		//~ ZenBinaryPacket<sizeof(VersionResponse)> Packet(ZongeBinaryResponsePacketStartToken, PayloadTypeVersion, ZongeBinaryServerSerial);
		//~ memcpy(Packet.Payload, &VR, sizeof(VersionResponse));
		//~ Packet.CalcCRC();
		for (size_t i = 0; i < sizeof(ZenBinaryPacket<sizeof(VersionResponse)>); i++) { ClientConnections[SocketIndex].DataFromZen.push(Packet.AsUint8()[i]); }
	//~ }
	//~ else
	//~ {
		//~ formatf("\nZen457Server : Version: corrupted packet.\n");
	//~ }

    //~ return(ParamsLen);
//~ }

//~ int8_t FlushDataToZenCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
//~ {
	if (ValidateZenBinaryRfPacket(ZongeBinaryServerSerial, Params, ParamsLen))
	{
		const size_t SocketIndex = reinterpret_cast<const size_t>(Argument);
		
		ClientConnections[SocketIndex].DataToZen.clear();
		
		formatf("\nZen457Server : FlushDataToZen: complete.\n");
		
		ZenBinaryPacket<0> Packet(ZongeBinaryResponsePacketStartToken, PayloadTypeFlushDataToZen, ZongeBinaryServerSerial);
		Packet.CalcCRC();
		for (size_t i = 0; i < sizeof(ZenBinaryPacket<0>); i++) { ClientConnections[SocketIndex].DataFromZen.push(Packet.AsUint8()[i]); }
	}
	else
	{
		formatf("\nZen457Server : FlushDataToZen: corrupted packet.\n");
	}

    //~ return(ParamsLen);
//~ }

//~ int8_t FlushDataFromZenCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
//~ {
	if (ValidateZenBinaryRfPacket(ZongeBinaryServerSerial, Params, ParamsLen))
	{
		const size_t SocketIndex = reinterpret_cast<const size_t>(Argument);
		
		ClientConnections[SocketIndex].DataFromZen.clear();
		
		formatf("\nZen457Server : FlushDataFromZen: complete.\n");
		
		ZenBinaryPacket<0> Packet(ZongeBinaryResponsePacketStartToken, PayloadTypeFlushDataFromZen, ZongeBinaryServerSerial);
		Packet.CalcCRC();
		for (size_t i = 0; i < sizeof(ZenBinaryPacket<0>); i++) { ClientConnections[SocketIndex].DataFromZen.push(Packet.AsUint8()[i]); }
	}
	else
	{
		formatf("\nZen457Server : FlushDataFromZen: corrupted packet.\n");
	}
	
    //~ return(ParamsLen);
//~ }

//~ int8_t BytesWaitingToZenCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
//~ {
	if (ValidateZenBinaryRfPacket(ZongeBinaryServerSerial, Params, ParamsLen))
	{
		const size_t SocketIndex = reinterpret_cast<const size_t>(Argument);
		
		uint32_t Depth = (uint32_t)ClientConnections[SocketIndex].DataToZen.len();
		
		formatf("\nZen457Server : BytesWaitingToZen: replying answer of %u to client.\n", Depth);
		
		ZenBinaryPacket<sizeof(uint32_t)> Packet(ZongeBinaryResponsePacketStartToken, PayloadTypeBytesWaitingToZen, ZongeBinaryServerSerial);
		memcpy(Packet.Payload, &Depth, sizeof(uint32_t));
		Packet.CalcCRC();
		for (size_t i = 0; i < sizeof(ZenBinaryPacket<sizeof(uint32_t)>); i++) { ClientConnections[SocketIndex].DataFromZen.push(Packet.AsUint8()[i]); }
	}
	else
	{
		formatf("\nZen457Server : BytesWaitingToZen: corrupted packet.\n");
	}

    //~ return(ParamsLen);
//~ }

//~ int8_t BytesWaitingFromZenCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
//~ {
	if (ValidateZenBinaryRfPacket(ZongeBinaryServerSerial, Params, ParamsLen))
	{
		const size_t SocketIndex = reinterpret_cast<const size_t>(Argument);
		
		uint32_t Depth = (uint32_t)ClientConnections[SocketIndex].DataFromZen.len();
		
		formatf("\nZen457Server : BytesWaitingFromZen: replying answer of %u to client.\n", Depth);
		
		ZenBinaryPacket<sizeof(uint32_t)> Packet(ZongeBinaryResponsePacketStartToken, PayloadTypeBytesWaitingFromZen, ZongeBinaryServerSerial);
		memcpy(Packet.Payload, &Depth, sizeof(uint32_t));
		Packet.CalcCRC();
		for (size_t i = 0; i < sizeof(ZenBinaryPacket<sizeof(uint32_t)>); i++) { ClientConnections[SocketIndex].DataFromZen.push(Packet.AsUint8()[i]); }
	}
	else
	{
		formatf("\nZen457Server : BytesWaitingToZen: corrupted packet.\n");
	}

    //~ return(ParamsLen);
//~ }

int8_t Mount457sCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//Find all Zens and mount them!
	for (size_t j = 0; j < NumZenConnections.load(); j++) 		
	{
		if (ZenConnections[j].IsConnected()) //only the live ones though
		{
			char ZenIP[20];
			char ZenLogin[32];
			char ZenPath[256];
			
			ZenConnections[j].ZenIP.sprintf(ZenIP);
			sprintf(ZenPath, "/media/457/%u", ZenConnections[j].ZenIP.O1); 
			sprintf(ZenLogin, "root@%s:/", ZenIP); 
			
			spawn("/bin/umount", "-lf", ZenPath);
			spawn("/bin/rm", "-r", ZenPath);
			spawn("/bin/mkdir -pv", ZenPath);			
			spawn("/usr/bin/sshfs", ZenLogin, ZenPath, "-ouid=1000", "-ogid=1000", "-o reconnect,ServerAliveInterval=1,ServerAliveCountMax=3,TCPKeepAlive=yes,cache_timeout=3");
			spawn("/usr/bin/sshfs", ZenLogin, ZenPath, "-ouid=1000", "-ogid=1000");
			
			printf("\nZen457Server: Mounting457[%u] on %s at %s.", (unsigned)j, ZenLogin, ZenPath);
		}
	}

    return(ParamsLen);
}

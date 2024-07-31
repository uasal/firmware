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
#pragma once

#include <unistd.h>  /* UNIX standard function definitions */
#include <fcntl.h>   /* File control definitions */
#include <errno.h>   /* Error number definitions */
#include <termios.h> /* POSIX terminal control definitions */
#include <sys/ioctl.h> /* ioctl() */
#include <sys/socket.h> /* FIONREAD on cygwin */
#include <netinet/in.h> /* struct sockaddr_in */
#include <netinet/ip.h> 
#include <netdb.h>
#include <sys/types.h>
#include <sys/stat.h>

#include "uart/BinaryUart.hpp"

#include "cgraph/CGraphPacket.hpp"

#include "eeprom/CircularFifo.hpp"

#include "uart/linux_pinout_circular_uart.hpp"

#include "CmdTableBinary.hpp"

#include "EzThread.hpp"
class ClientSocketThread : public EzThread
{
public:
	ClientSocketThread() { BoredDelayuS = 1000; strcpy(ThreadName, "ClientSocketThread"); }
	virtual void ThreadInit() { nice(-2); }
	virtual ~ClientSocketThread() { }
	virtual bool Process();
	//~ virtual void TenHzRoutines();
	//~ virtual void OneSecondRoutines();
};

int InitClientSocket();

struct MsgSocketPacketCallbacks : BinaryUartCallbacks
{
	MsgSocketPacketCallbacks() { }
	virtual ~MsgSocketPacketCallbacks() { }
	
	//Malformed/corrupted packet handler:
	virtual void InvalidPacket(const uint8_t* Buffer, const size_t& BufferLen)
	{ 
		if ( (NULL == Buffer) || (BufferLen < 1) ) { printf("\nSocketUartCallbacks: NULL(%u) InvalidPacket!\n\n", BufferLen); return; }
	
		size_t len = BufferLen;
		if (len > 32) { len = 32; }
		printf("\nSocketUartCallbacks: InvalidPacket! contents: :");
		for(size_t i = 0; i < len; i++) { printf("%.2X:", Buffer[i]); }
		printf("\n\n");
		
		//~ const BinaryPacket<BinaryMaxPayloadLength>* PacketDebug = (const BinaryPacket<BinaryMaxPayloadLength>*)Packet;
		//~ PacketDebug->formatf_shortpkt(len);		
		//~ //Packet->printf();		
	}
	
	//We don't handle any packets by Cmd, so ~all~ packets are unhandled!
	virtual void UnHandledPacket(const IPacket* Packet, const size_t& PacketLen)
	{ 
		if ( (NULL == Packet) || (PacketLen < sizeof(CGraphPacketHeader)) ) { printf("\nSocketUartCallbacks: NULL(%u) UnHandledPacket!\n\n", PacketLen); return; }
		
		const CGraphPacketHeader* Header = reinterpret_cast<const CGraphPacketHeader*>(Packet);
		printf("\nSocketUartCallbacks: Unhandled packet(%u): ", PacketLen);
		Header->formatf();
		printf("\n\n");
	}
	
	//In case we need to look at every packet that goes by...
	//~ virtual void EveryPacket(const IPacket& Packet, const size_t& PacketLen) { }
	
	//We just wanna see if this is happening, not much to do about it
	virtual void BufferOverflow(const uint8_t* Buffer, const size_t& BufferLen) 
	{ 
		printf("\nClientSocketCallbacks: BufferOverflow(%zu)!\n", BufferLen);
	}
};

struct ClientConnection
{
	int hSocket;
	pthread_t thread;
	linux_pinout_circular_uart<char, 32768, 32768> DataToFromDevice; //.wasFull() .wasEmpty() bool .push() bool .pop()
	MsgSocketPacketCallbacks SocketPacketCallbacks;
	CGraphPacket Protocol;
	BinaryUart SocketHandler;

	ClientConnection() : hSocket(-1), SocketHandler(DataToFromDevice, Protocol, BinaryCmds, NumBinaryCmds, SocketPacketCallbacks)
	{ 

	}
	
	bool Connected() const { return(hSocket >= 0); }
};

const size_t MaxClientConnections = 1;
extern ClientConnection ClientConnections[MaxClientConnections];


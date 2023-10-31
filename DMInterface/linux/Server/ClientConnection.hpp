#pragma once

#include <pthread.h>
#include <vector>
using namespace std;
#include <atomic> // std::atomic requires C++11 support.

#ifdef WIN32
	#include <io.h>
	#include <winsock.h>
#else
	#include <sys/types.h>
	#include <sys/stat.h>
	#include <fcntl.h>
	#include <unistd.h>
	#include <sys/socket.h>
	#include <netinet/in.h>
	#include <ifaddrs.h>
	#include <netinet/in.h> 
	#include <arpa/inet.h>
#endif

#include "eeprom/CircularFifo.hpp"
#include "uart/linux_pinout_circular_buffer_bytes.hpp"
#include "uart/ZongeBinaryPacketFinderThreadSafeFifo.hpp"

struct ClientConnection
{
	int hSocket;
	int hServerSocket;
	struct sockaddr Addr;
	#ifdef WIN32
	int AddrLen;
	#else
	socklen_t AddrLen;
	#endif	
	pthread_t thread;	
	CircularFifo<uint8_t, 32768> DataToClient;
	CircularFifo<uint8_t, 32768> DataFromClient;
	//~ linux_pinout_circular_buffer DataFromClient;
	ZongeBinaryPacketFinder<32768, 4096> DataFromClientPacketizer;	
	//~ char Packet[OutgoingMaxMessageLen];
	//~ size_t PacketLen;
	//~ const size_t OutgoingMaxMessageLen;

	ClientConnection() 
		: 
		hSocket(0),
		hServerSocket(0),
		AddrLen(0),
		//~ DataFromClientPacketizer(DataFromClient)
		DataFromClientPacketizer(DataFromClient, false)
		//~ PacketLen(0),
		//~ OutgoingMaxMessageLen(4096)
	{ 
		memset(&Addr, 0, sizeof(struct sockaddr_in)); 
		//~ memset(Packet, '\0', OutgoingMaxMessageLen); 
	}
	
	ClientConnection(const ClientConnection& Client) : DataFromClientPacketizer(DataFromClient, false)
	{
		hSocket = Client.hSocket;
		hServerSocket = Client.hServerSocket;
	}
	
	bool operator==(const ClientConnection& connection) const { return(hSocket == connection.hSocket); }
	
	bool Connected() const { return(hSocket > 0); }
};

static const size_t MaxClientConnections = 8;
extern std::atomic<size_t> NumClientConnections;
extern ClientConnection ClientConnections[MaxClientConnections];

bool InClientConnections(const ClientConnection& connection);

extern "C"
{
	void* SocketHandleClientThread(void *arg);
};

//EOF

#pragma once

#include <pthread.h>
#include <vector>
using namespace std;
#include <string.h>
#include <atomic> // std::atomic requires C++11 support.

#include "uart/IUart.h"
#include "eeprom/CircularFifo.hpp"
#include "uart/linux_pinout_client_socket.hpp"
#include "uart/linux_pinout_circular_buffer_bytes.hpp"
#include "uart/ZongeBinaryPacketFinderThreadSafeFifo.hpp"
#include "IPAddr.h"

struct ZenConnection
{
	IPAddr ZenIP;
	pthread_t thread;	
	CircularFifo<uint8_t, 32768> DataToZen;
	CircularFifo<uint8_t, 32768> DataFromZen;
	//~ linux_pinout_circular_buffer DataFromZen;
	ZongeBinaryPacketFinder<32768, 4096> DataFromZenPacketizer;	
	linux_pinout_client_socket ZenSocketPinout;
	
	ZenConnection() : DataFromZenPacketizer(DataFromZen, false)
	{ 
	
	}
	
	ZenConnection(const IPAddr& IP) : ZenIP(IP), DataFromZenPacketizer(DataFromZen, false)
	{
		
	}
	
	ZenConnection(const ZenConnection& zen) : DataFromZenPacketizer(DataFromZen, false)
	{
		//~ memcpy(this, &zen, sizeof(ZenConnection));
		ZenIP = zen.ZenIP;
	}
	
	bool operator==(const ZenConnection& zen) const { return(ZenIP == zen.ZenIP); }
	bool operator==(const IPAddr& ip) const { return(ZenIP == ip); }
	
	bool IsConnected() const { return(ZenSocketPinout.connected()); }
};

static const size_t MaxZenConnections = 8;
extern std::atomic<size_t> NumZenConnections;
//~ extern std::vector<ZenConnection> ZenConnections;
extern ZenConnection ZenConnections[MaxZenConnections];

bool InZenConnections(const IPAddr& ip);

extern "C"
{
	void* SocketHandleZenThread(void *arg);
};

//EOF

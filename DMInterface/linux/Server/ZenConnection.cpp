#include <pthread.h>
#include <vector>
using namespace std;
#include <string.h>

#include "uart/IUart.h"
#include "eeprom/CircularFifo.hpp"
#include "uart/linux_pinout_client_socket.hpp"
#include "uart/linux_pinout_circular_buffer_bytes.hpp"
#include "uart/ZongeBinaryPacketFinderThreadSafeFifo.hpp"
#include "IPAddr.h"

#include "ZenConnection.hpp"

//~ std::vector<ZenConnection> ZenConnections;
ZenConnection ZenConnections[MaxZenConnections];
std::atomic<size_t> NumZenConnections(0);

bool InZenConnections(const IPAddr& ip)
{
	//~ if (ZenConnections.empty()) { return(false); }
	//~ for (size_t i = 0; i < ZenConnections.size(); i++) 
	for (size_t i = 0; i < NumZenConnections.load(); i++) 
	{
		if (ip == ZenConnections[i].ZenIP) { return(true); }
	}
	return(false);
}

extern "C"
{
	void* SocketHandleZenThread(void *arg)
	{	
		if (!arg) { return(NULL); }
		
		//~ ZenConnection* Zen = reinterpret_cast<ZenConnection*>(arg);
		IPAddr IP = *reinterpret_cast<IPAddr*>(arg);
		
		//Done with heap container
		delete (reinterpret_cast<IPAddr*>(arg));
			
		//Add it to the list!
		//~ {
			//~ //Make sure destructor gets called on obj before copy, so it doesn't jack the connection?!
			//~ ZenConnection NewZen(IP);
			//~ Index = ZenConnections.size();
			//~ ZenConnections.push_back(NewZen);					
		//~ }
		//~ //Now get the 'real' object from the list after copy constructor
		//~ ZenConnection& Zen = ZenConnections.back();
		
		//Add it to the list!
		size_t ZenConnectionIndex = NumZenConnections.fetch_add(1);
		ZenConnection& Zen = ZenConnections[ZenConnectionIndex];
		Zen.ZenIP = IP;

		//Is our input sane???
		if (0 == Zen.ZenIP.all) { return(NULL); }
		if (0xFFFFFFFFUL == Zen.ZenIP.all) { return(NULL); }
		
		//Make the IP into a string!
		//~ struct sockaddr_in AddrIn;
		//~ char IPAddr[INET_ADDRSTRLEN];
		//~ inet_ntop(AF_INET, &AddrIn, IPAddr, INET_ADDRSTRLEN);
        char IPAddr[255];
		Zen.ZenIP.sprintf(IPAddr);
		
		printf("\nZen457Server: SocketHandleZenThread(%s) started...\n", IPAddr);
		
		//Ok, now we fire up the Zen Socket!
		if (IUart::IUartOK != Zen.ZenSocketPinout.init(457, IPAddr))
		{
			printf("\nZen457Server: SocketHandleZenThread(): Couldn't open Zen socket %s:457!", IPAddr);
		}
		
		printf("\nZen457Server: SocketHandleZenThread(): Zen socket %s:457 is handle %u.", IPAddr, Zen.ZenSocketPinout.hSocket);
			
		//Now we handle the socket!
		while(true)
		{
			bool Bored = true;
			
			if (-1 == Zen.ZenSocketPinout.hSocket)
			{
				printf("\nZen457Server: SocketHandleZenThread(): Zen socket %s:457 failed! reconnecting!", IPAddr);
				if (IUart::IUartOK != Zen.ZenSocketPinout.init(457, IPAddr))
				{
					printf("\nZen457Server: SocketHandleZenThread(): Couldn't open Zen socket %s:457 on reconnect!", IPAddr);
				}
			}
			
			if (Zen.IsConnected()) 
			{
				//Get data from Zen
				if (Zen.ZenSocketPinout.dataready())
				{
					Bored = false;
					Zen.DataFromZen.push(Zen.ZenSocketPinout.getcqq());
					//~ printf("#");
					//~ printf("\nZen457Server: DataFromZen(%zu).", Zen.DataFromZen.depth());
				}
				
				//Send data to Zen
				if (!(Zen.DataToZen.wasEmpty()))
				{
					uint8_t c = 0;
					Bored = false;
					if (Zen.DataToZen.pop(c)) { Zen.ZenSocketPinout.putcqq(c); }
					//~ printf("@");
				}
				else
				{
					if (0 == ZenConnectionIndex)
					{
						//~ printf("\nZen457Server: SocketHandleZenThread(%s): DataToZenEmpty!", IPAddr);
					}
				}
			}
			else
			{
				printf("\nZen457Server: SocketHandleZenThread(%s): Re-Connecting!", IPAddr);
				fflush(stdout);
				if (IUart::IUartOK != Zen.ZenSocketPinout.init(457, IPAddr))
				{
					printf("\nZen457Server: SocketHandleZenThread(): Couldn't open Zen socket %s:457!", IPAddr);
				}	
			}
			
			//give up our timeslice so as not to bog the system...maybe there's someting around to smoke. or we could watch clouds...if a thread falls asleep in the desert, and no one's around to hear it...
			if (Bored)
			{
				#ifdef WIN32
				Sleep(10);
				#else
				struct timespec tenmilliseconds;
				memset((char *)&tenmilliseconds,0,sizeof(tenmilliseconds));
				tenmilliseconds.tv_nsec = 10000000;
				nanosleep(&tenmilliseconds, NULL);
				#endif
			}			
		}	
	}
}

//EOF

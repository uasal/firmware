// Zen457Server
//
// This utility will locate all 457's connected to a computer, and expose them all to a single local socket, in a compatible manner to ZigSockServer, for use with ZenRadio.
//
//GetIFAddrs short:
//http://stackoverflow.com/questions/20800319/how-do-i-get-my-ip-address-in-c-on-linux
//GetIFAddrs long:
//http://stackoverflow.com/questions/4130147/get-local-ip-address-in-c-linux
//Ioctl() method:
//http://stackoverflow.com/questions/2021549/how-do-i-output-my-host-s-ip-addresses-from-a-c-program
//Ping source:
//http://www.ping127001.com/pingpage/ping.text
//

#ifdef WIN32
	#define WINVER                   0x6000
	#define _WIN32_WINDOWS           0x6000
	#define _WIN32_WINNT             0x6000
#endif

#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <inttypes.h>

#ifdef WIN32
	#include <winsock2.h>
	#include <ws2tcpip.h>
	#include <io.h>
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
#include <pthread.h>

#include <iostream>
using namespace std;

#include "ClientConnection.hpp"
#include "ZenConnection.hpp"

#include "rf/ZongeProtocol.hpp"

#include "AsciiCmdUserInterface.h"

int8_t BinaryBoardsInBoxCommand(const uint64_t& RadioAddr, char const* Params, const size_t ParamsLen);

#include "uart/IUart.h"
#include "uart/ZongeBinaryUart.hpp"
#include "rf/ZongeProtocol.hpp"
#include "CmdTableSocket.hpp"

struct Zen457ServerControlParserUnHandledPacketCallbacks : ZongeBinaryUartUnHandledPacketCallbacks
{
	Zen457ServerControlParserUnHandledPacketCallbacks() { }
	virtual ~Zen457ServerControlParserUnHandledPacketCallbacks() { }
	
	//Malformed/corrupted packet handler:
	virtual void InvalidPacket(const uint8_t* Packet, const size_t& PacketLen) 
	{ 
		formatf("\nZen457Server : Server : incoming packet CRC Failed! Corrupted packet (0x%.2x%.2x:0x%.2x%.2x:0x%.2x%.2x%.2x%.2x); contents: ", Packet[1], Packet[0], Packet[4], Packet[3], Packet[8], Packet[7], Packet[6], Packet[5]);
		const ZenBinaryPacket<ZongeBinaryMaxPayloadLength>* PacketDebug = (const ZenBinaryPacket<ZongeBinaryMaxPayloadLength>*)Packet;
		PacketDebug->formatf_shortpkt(255);		
		//~ Packet->formatf();
		formatf("\n\n");
	}
	
	//Packet with no matching command handler:
	virtual void UnHandledPacket(const ZenBinaryPacketHeader& Packet, const size_t& PacketLen) 
	{ 
		//This is expected; since not all packets going thru the server are actually addressed to the server, this will get called a *lot*. Probably best not to generate any output here unless the server was the intended recipient.
		if (ZongeBinaryServerSerial == Packet.SerialNumber)
		{
			formatf("\nZen457Server : Server : unhandled packet intended for this server; contents: ");
			//~ const ZenBinaryPacket<ZongeBinaryMaxPayloadLength>* Packet = (const ZenBinaryPacket*<ZongeBinaryMaxPayloadLength>)Packet;
			//~ Packet.formatf_shortpkt();		
			Packet.formatf();
			formatf("\n\n");
		}
	}
};

Zen457ServerControlParserUnHandledPacketCallbacks DebugUnHandledPacketCallbacks;

#include "uart/LoopbackUart.hpp"
LoopbackUart<4096> ControlPacketBuffer;
ZongeBinaryUart<4096,4096> ControlPacketParser(ControlPacketBuffer, SocketCmds, NumSocketCmds, DebugUnHandledPacketCallbacks, false, NULL);

extern "C"
{
	int stdio_hook_putc(int c) { putchar(c); return(c); }
};

//Here's where we talk to the socket:
void* SocketHandleClientThread(void *argument);
void* SocketHandleZenThread(void *argument);

bool QueriesNotDone = true;

time_t LastBoxDiscoverTime = 0;

void LocateZenIPs();

void TxPkt(const uint64_t& RadioAddr, const void* Packet, const size_t PacketLen, const uint16_t RadioShortAddr);

int main(int argc, char *argv[])
{
	int hServerSocket;  /* handle to socket */
	#ifndef WIN32
	struct hostent* pHostInfo;   /* holds info about a machine */
	#endif
	struct sockaddr_in Address; /* Internet socket address stuct */
	int nAddressSize=sizeof(struct sockaddr_in);
	struct timespec  tenmilliseconds;
	memset((char *)&tenmilliseconds,0,sizeof(tenmilliseconds));
	tenmilliseconds.tv_nsec = 50000000;
	int nHostPort = 20457;	
	
	//Tell C lib (stdio.h) not to buffer output, so we can ditch all the fflush(stdout) calls...
	setvbuf(stdout, NULL, _IONBF, 0);

	if (argc > 1)
    {
        nHostPort = atoi(argv[1]);
    }
	
	#ifdef WIN32
	WSADATA wsaData;
	if (WSAStartup(MAKEWORD(2,0), &wsaData) != 0) 
	{
		formatf("\nZen457Server: WSAStartup failed.\n");
        return 0;
    }
	#endif

	formatf("\nZen457Server: Starting server");
	formatf("\nZen457Server: Making socket");
	hServerSocket=socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);
	if(hServerSocket == -1)
	{
		#ifdef WIN32
		formatf("\nZen457Server: Could not make a socket: %lu\n", (unsigned long)WSAGetLastError());
		WSACleanup();
		#else
		perror("\nZen457Server: Could not make a socket\n");
		#endif
		return 0;
	}

	formatf("\nZen457Server: Binding to port %d",nHostPort);
	Address.sin_addr.s_addr=INADDR_ANY;
	Address.sin_port=htons(nHostPort);
	Address.sin_family=AF_INET;
	if(bind(hServerSocket,(struct sockaddr*)&Address,sizeof(Address)) == -1)
	{
		formatf("\nZen457Server: Could not connect to host\n");
		#ifdef WIN32
		WSACleanup();
		#endif
		return 0;
	}
	
	/*  get port number */
	#ifdef WIN32
	getsockname( hServerSocket, (struct sockaddr*) &Address, (int*)&nAddressSize);
	#else
	getsockname( hServerSocket, (struct sockaddr*) &Address, (socklen_t*)&nAddressSize);
	#endif 
	formatf("\nZen457Server: opened socket as fd (%d) on port (%d) for stream i/o",hServerSocket, ntohs(Address.sin_port) );
	//~ formatf("Server\n
		//~ sin_family        = %d\n
		//~ sin_addr.s_addr   = %d\n
		//~ sin_port          = %d\n"
		//~ , Address.sin_family
		//~ , Address.sin_addr.s_addr
		//~ , ntohs(Address.sin_port)
	//~ );
	
	//listen() to socket
	formatf("\nZen457Server: Making a listen queue of %d elements.", SOMAXCONN);
	if(listen(hServerSocket, SOMAXCONN) == -1)
	{
		formatf("\nZen457Server: Could not listen\n");
		#ifdef WIN32
		WSACleanup();
		#endif
		return 0;
	}
	
	//Start up Client socket handler threads!
	for (size_t i = 0; i < 1; i++) //let's just start with one??
	{
		formatf("\nZen457Server: creating socket handler thread %u.", i);
		pthread_t thread;
		int rc = pthread_create(&thread, NULL, SocketHandleClientThread, reinterpret_cast<void*>(hServerSocket));
		if (0 != rc) { formatf("\nZen457Server: pthread_create[%u] returned %d.\n", i, rc); }
	}
	
	formatf("\nZen457Server: NumPacketTypeDefinitions: %u.\n", NumPacketTypeDefinitions);
	
	LocateZenIPs();
	
	StartUserInterface();

	bool Bored = true;
	
	while(true)
	{	
		Bored = true;
		
		ProcessUserInterface();
		
		//Move data from Zen->Clients
		for (size_t i = 0; i < NumZenConnections.load(); i++) 		
		{
			if (ZenConnections[i].IsConnected()) 
			{				
				//Look for completed packets in incoming data.
				bool processed = ZenConnections[i].DataFromZenPacketizer.Process();			

				if (processed) { Bored = false; }
								
				//Got one!
				if (ZenConnections[i].DataFromZenPacketizer.FoundPacket()) 
				{ 
					//debug
					{
						const ZenBinaryPacketHeader& Packet = ZenConnections[i].DataFromZenPacketizer.Packet();
						printf("\nZen457Server: Got packet from Zen(%zu), sending to clients: ", i);
						Packet.formatf_txt();
						printf("\n\n");									
					}
					
					//Push it to all the clients!
					for (size_t j = 0; j < NumClientConnections.load(); j++) 
					{
						if (ClientConnections[j].Connected()) //only the live ones though
						{
							//~ printf("\nZen457Server: Writing %zu bytes to ClientConnections[%zu].", ZenConnections[i].DataFromZenPacketizer.PacketLen(), j);
							
							//Buffer it up a byte at a time, cause thread-safe fifos only hold bytes
							for (size_t k = 0; k < ZenConnections[i].DataFromZenPacketizer.PacketLen(); k++)
							{
								ClientConnections[j].DataToClient.push((ZenConnections[i].DataFromZenPacketizer.PacketBuffer())[k]);
							}
						}
						//~ else
						//~ {
							//~ printf("\nZen457Server: ClientConnections[%zu/%zu] not connected.", j, ClientConnections.size());
						//~ }
					}
					
					//Get ready to look for another packet:
					ZenConnections[i].DataFromZenPacketizer.Init();
				}		
			}	
		}
		
		//Move data from Client->Zens
		for (size_t i = 0; i < NumClientConnections.load(); i++) 
		{
			if (ClientConnections[i].Connected()) 
			{
				//~ ///DEBUG!!
				//~ ClientConnections[i].DataFromClientPacketizer.Debug(true);
				
				//Look for completed packets in incoming data.
				bool processed = ClientConnections[i].DataFromClientPacketizer.Process();			
				
				if (processed) { Bored = false; }
				
				//Got one!
				if (ClientConnections[i].DataFromClientPacketizer.FoundPacket()) 
				{ 
					//The packet:
					ZenBinaryPacketHeader& Packet = ClientConnections[i].DataFromClientPacketizer.PacketNonConst();
					
					//debug
					//~ {
						//~ printf("\nZen457Server: Got packet from Client(%zu): ", i);
						//~ Packet.formatf();
						//~ printf("\n\n");						
					//~ }
					
					//Is it an "all channels" packet?? If so, send it's ~payload~ packet to everyone!
					if ( (PayloadTypeAllChannelsInBoxPayload == Packet.PayloadTypeToken) && (ZongeBinaryCommandPacketStartToken == Packet.PacketStartToken) )
					{		
						ZenBinaryPacketHeader* InnerPacket = reinterpret_cast<ZenBinaryPacketHeader*>( ((uint8_t*)Packet.PayloadDataNonConst()) + sizeof(uint32_t) );
													
						//First, we need to turn it into a broadcast serial, cause Marc usually put's Ch1's serial in there instead, like it's a 339 radio!
						{
							InnerPacket->SerialNumber = ZongeBinaryBroadcastSerial;
							InnerPacket->CalcCRC();
							printf("\nZen457Server: AllChannels packet marked up with broadcast S/N; now: ");
							InnerPacket->formatf_txt();
							printf("\n");
						}
						
						//Push packet's ~payload~ to all the zens!
						for (size_t j = 0; j < NumZenConnections.load(); j++) 		
						{
							if (ZenConnections[j].IsConnected()) //only the live ones though
							{
								//~ printf("\nZen457Server: Writing %zu bytes to ZenConnections[%zu].", Packet.PayloadLen, j);
								
								//Buffer it up a byte at a time, cause thread-safe fifos only hold bytes
								for (size_t k = 0; k < Packet.PayloadLen; k++)
								{
									ZenConnections[j].DataToZen.push(((uint8_t*)InnerPacket)[k]);
								}
								
								//~ printf("\nZen457Server: ZenConnections[%zu/%zu]: Depth now: %zu.", j, ZenConnections.size(), ZenConnections[j].DataToZen.depth());
							}
							else
							{
								printf("\nZen457Server: ZenConnections[%u/%u] not connected.", (unsigned)j, (unsigned)NumZenConnections.load());
							}
						}
					}
					else
					{		
						if (ZongeBinaryServerSerial != Packet.SerialNumber)
						{
							printf("\nZen457Server: Raw packet outgoing to all Zens: ");
							Packet.formatf_txt();
							printf("\n");
							
							//Push ~raw~ packet to all the zens!
							for (size_t j = 0; j < NumZenConnections.load(); j++) 		
							{
								if (ZenConnections[j].IsConnected()) //only the live ones though
								{
									//~ printf("\nZen457Server: Writing %zu bytes to ZenConnections[%zu].", ZenConnections[i].DataFromZenPacketizer.PacketLen(), j);
									
									//Buffer it up a byte at a time, cause thread-safe fifos only hold bytes
									for (size_t k = 0; k < ClientConnections[i].DataFromClientPacketizer.PacketLen(); k++)
									{
										ZenConnections[j].DataToZen.push((ClientConnections[i].DataFromClientPacketizer.PacketBuffer())[k]);
									}
									
									//~ printf("\nZen457Server: ZenConnections[%zu/%zu]: Depth now: %zu.", j, ZenConnections.size(), ZenConnections[j].DataToZen.depth());
								}
								else
								{
									printf("\nZen457Server: ZenConnections[%u/%u] not connected.", (unsigned)j, (unsigned)NumZenConnections.load());
								}
							}
						}
						else
						{
							printf("\nZen457Server: Packet intended for server; not passing to Zens.");
						}
					}	
					
					//Get ready to look for another packet:
					ClientConnections[i].DataFromClientPacketizer.Init();
				}		
			}	
		}
		
		//give up our timeslice so as not to bog the system			
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
		
		time_t Now = time(NULL);
		if ( Now > (LastBoxDiscoverTime + 30) )
		{
			LastBoxDiscoverTime = Now;			
			LocateZenIPs();
		}
	}

    return(0);
}

void IsZenIP(void* ip);

void LocateZenIPs()
{
	#ifdef WIN32
	char ac[80];
	
    if (gethostname(ac, sizeof(ac)) == SOCKET_ERROR) 
	{
        cerr << "\nZen457Server: Box Discover: Error " << WSAGetLastError() <<
                " when getting local host name." << endl;
        return;
    }

    struct hostent *phe = gethostbyname(ac);
	
    if (phe == 0) 
	{
        cerr << "\nZen457Server: Box Discover: Bad host lookup." << endl;
        return;
    }

    for (int i = 0; phe->h_addr_list[i] != 0; ++i) 
	{
        struct in_addr addr;
        memcpy(&addr, phe->h_addr_list[i], sizeof(struct in_addr));
		IsZenIP(&addr);
    }
	
	#else //pozix
	struct ifaddrs * ifAddrStruct=NULL;
    struct ifaddrs * ifa=NULL;
    void * tmpAddrPtr=NULL;      
	
    getifaddrs(&ifAddrStruct);

    for (ifa = ifAddrStruct; ifa != NULL; ifa = ifa->ifa_next) 
	{
        if (ifa ->ifa_addr->sa_family==AF_INET)  // check it is IP4
		{
            tmpAddrPtr=&((struct sockaddr_in *)ifa->ifa_addr)->sin_addr;
			
			IsZenIP(tmpAddrPtr);
         } 
		 //Don't care about IPv6 now.
		 //~ else if (ifa->ifa_addr->sa_family==AF_INET6) { } // check it is IP6
    }
    if (ifAddrStruct!=NULL) 
	{
        freeifaddrs(ifAddrStruct);//remember to free ifAddrStruct
	}
	#endif
}

void IsZenIP(void* ip)
{
	bool ZenMatch = false;
	char addressBuffer[255];
	
	inet_ntop(AF_INET, ip, addressBuffer, 255);
	
	//~ printf("'%s' ", addressBuffer); 
	uint8_t O3 = ((uint8_t*)ip)[0];
	if (10 == O3) { ZenMatch = true; } else { ZenMatch = false; }
	//~ if (192 == O3) { ZenMatch = true; } else { ZenMatch = false; }
	//~ if (ZenMatch) 
	//~ { 
		//~ printf("; i.e. %hu.%hu.%hu.%hu, ", O0, O1, O2, 1);
		//~ printf("Box%hu, Channel%hu", O1, O2); 
	//~ }
	//~ printf("\nZen457Server: Box Discover: %s a Zen457.\n", ZenMatch?"is":"not");
	if (ZenMatch)
	{
		IPAddr* IP = new IPAddr(*((uint32_t*)ip)); //This is the IP of our computer, i.e. 10.<box>.<ch>.231
		if (!IP) 
		{
			perror("\nZen457Server: Box Discover: Unable to allocate new IP addr container!");
		}
		
		IP->O0 = 1; //Zen channel IP is always @ 10.<box>.<ch>.1
		
		//~ ZenConnection NewZen(IP);
		
		//Have we seen this IP yet? If not, add it and fire up a thread for it!
		if (!InZenConnections(*IP))
		{
			//~ //Add it to the list!
			//~ ZenConnections.push_back(NewZen);					
			//~ ZenConnection& Zen = ZenConnections.back();
			
			//Start the thread
			pthread_t thread;	
			formatf("\nZen457Server: Box Discover: Found new Zen channel! Creating Zen handler thread.");
			int rc = pthread_create(&thread, NULL, SocketHandleZenThread, (void*)IP);
			if (0 != rc) { perror("\nZen457Server: Box Discover: pthread_create failed.\n"); }
		}
		//~ else
		//~ {
			//~ printf("\nZen457Server: Zen channel at ");
			//~ IP.printf();
			//~ printf(" already in connection list.");					
		//~ }
	}

}

//~ void TxBinary(char (*sendchar)(const char), const uint16_t PacketTypeToken, const uint16_t PayloadTypeToken, const uint32_t SerialNumber, const void* PayloadData, const size_t PayloadLen)
void TxBinary(const void* TxPktContext, const uint16_t PacketTypeToken, const uint16_t PayloadTypeToken, const uint32_t SerialNumber, const void* PayloadDataUint8, const size_t PayloadLen)
{
	formatf("\nZen457Server: !! TXBinary() stub called!!\n\n");
}

void TxPkt(const uint64_t& RadioAddr, const void* Packet, const size_t PacketLen, const uint16_t RadioShortAddr)
{
	formatf("\nZen457Server: !! TxPkt() stub called!!\n\n");
}

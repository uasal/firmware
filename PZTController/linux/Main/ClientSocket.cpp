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
#include <time.h>
#include <pthread.h>
#include <sys/time.h>
#include <spawn.h>

#include "dbg/memwatch.h"

#include "Delay.h"

#include "uart/BinaryUart.hpp"

#include "cgraph/CGraphPacket.hpp"

#include "ClientSocket.hpp"

ClientSocketThread ClientSocketProcessor;

ClientConnection ClientConnections[MaxClientConnections];

//~ uint8_t ZigFrameID = 0; //Keeper through multiple runs to increment id frame of outgoing radio packets to keep track of order/loss of packets.

void* SocketHandleClientThread(void *argument);

const int nHostPort = 65536 + 1337;
int hServerSocket;  /* handle to socket */
struct sockaddr_in Address; /* Internet socket address stuct */
const int nAddressSize=sizeof(struct sockaddr_in);

int InitClientSocket()
{
	//~ printf("\nMsg: Start binary network socket handler...");
	//~ int err = LocalhostSocketPinout.init(457, "localhost");
	//~ if (IUart::IUartOK == err) { printf("\n\nMsg: LocalhostSocketPinout opened!\n"); }
	//~ //else { printf("."); }
	
	//~ printf("\nMsg: creating socket handler thread.");
	//~ pthread_t thread = 0;
	//~ int rc = pthread_create(&thread, NULL, SocketHandleClientThread, 0);
	//~ if (0 != rc) { printf("\nInitClientSocket: pthread_create returned %d.\n", rc); }	

	//~ printf("\nMsg: Ready.\n\n");

	//~ struct hostent* pHostInfo;   /* holds info about a machine */

	printf("\nClientSocket: Starting server");
	printf("\nClientSocket: Making socket");
	hServerSocket=socket(AF_INET,SOCK_STREAM,0);
	if(hServerSocket == -1)
	{
		printf("\nClientSocket: Could not make a socket\n");
		return 0;
	}

	printf("\nClientSocket: Binding to port %d",nHostPort);
	Address.sin_addr.s_addr=INADDR_ANY;
	Address.sin_port=htons(nHostPort);
	Address.sin_family=AF_INET;
	
	const int enable = 1;
	if (setsockopt(hServerSocket, SOL_SOCKET, SO_REUSEADDR, &enable, sizeof(int)) < 0) { perror("setsockopt(SO_REUSEADDR) failed"); }
	if (setsockopt(hServerSocket, SOL_SOCKET, SO_REUSEPORT, &enable, sizeof(int)) < 0) { perror("setsockopt(SO_REUSEPORT) failed"); }
	
	if(bind(hServerSocket,(struct sockaddr*)&Address,sizeof(Address)) == -1)
	{
		printf("\nClientSocket: Could not connect to host\n");
		return 0;
	}
	
	/*  get port number */
	getsockname( hServerSocket, (struct sockaddr*) &Address, (socklen_t*)&nAddressSize);
	printf("\nClientSocket: opened socket as fd (%d) on port (%d) for stream i/o",hServerSocket, ntohs(Address.sin_port) );
	//~ printf("Server\n
		//~ sin_family        = %d\n
		//~ sin_addr.s_addr   = %d\n
		//~ sin_port          = %d\n"
		//~ , Address.sin_family
		//~ , Address.sin_addr.s_addr
		//~ , ntohs(Address.sin_port)
	//~ );
	
	printf("\nClientSocket: Making a listen queue of %d elements.", MaxClientConnections);
	if(listen(hServerSocket, MaxClientConnections) == -1)
	{
		printf("\nClientSocket: Could not listen\n");
		return 0;
	}
	
	for (size_t Client = 0; Client < MaxClientConnections; Client++)
	{
		printf("\nClientSocket: creating socket handler thread %u.", Client);
		int rc = pthread_create(&ClientConnections[Client].thread, NULL, SocketHandleClientThread, (void*)Client);
		if (0 != rc) { printf("\nClientSocket: pthread_create[%u] returned %d.\n", Client, rc); }
	}
	
	ClientSocketProcessor.Init();
	
	return(true);
}	


//~ bool ProcessClientSocket()
bool ClientSocketThread::Process()
{
	bool Processed = false;
	
	for (size_t Client = 0; Client < MaxClientConnections; Client++)
	{
		for (size_t c = 0; c < 255; c++)
		{
			Processed = ClientConnections[Client].SocketHandler.Process();
			if (!Processed) { break; }
		}
	}
	
    return(Processed);
}

void SocketConnect(const size_t Client)
{
	ClientConnections[Client].hSocket = -1;
	
	//~ Address.sin_addr.s_addr=INADDR_ANY;
	//~ Address.sin_port=htons(nHostPort);
	//~ Address.sin_family=AF_INET;

	/* get the connected socket */
	//~ ClientConnections[Client].hSocket=accept((int)hServerSocket, (struct sockaddr*)&Address, (socklen_t*)&nAddressSize);
	ClientConnections[Client].hSocket=accept((int)hServerSocket, NULL, 0);
	
	if (ClientConnections[Client].hSocket < 0)
	{
		perror("\nClientSocket: connection error; ");
	}
	else { printf("\nClientSocket: %u: Got a connection.\n\n", Client); }
	fflush(stdout);
}	

void* SocketHandleClientThread(void *arg)
{
	fd_set sockset;
	struct timeval nowait;
	
	pid_t tid = syscall(SYS_gettid);
	printf("\nSocketHandleClientThread: launched! ID: %d", tid);
	//since nice only applies to default SCHED_OTHER processes: let's hot things up a bit and turn on the realtime scheduler:
	//~ int sched_pri = (sched_get_priority_max(SCHED_FIFO) - sched_get_priority_min(SCHED_FIFO)) / 4;
	//~ printf("Setting SCHED_FIFO and priority to %d\n", sched_pri);
	//~ struct sched_param param;
	//~ param.sched_priority = sched_pri;
	//~ sched_setscheduler(0, SCHED_FIFO, &param);
	//~ int sched_pri = (sched_get_priority_max(SCHED_RR) - sched_get_priority_min(SCHED_RR)) / 4;
	//~ int sched_pri = ((sched_get_priority_max(SCHED_RR) - sched_get_priority_min(SCHED_RR)) / 2) - 1;
	int sched_pri = ((sched_get_priority_max(SCHED_RR) - sched_get_priority_min(SCHED_RR)) / 2);
	printf("Setting SCHED_RR and priority to %d\n", sched_pri);
	struct sched_param param;
	param.sched_priority = sched_pri;
	int err = sched_setscheduler(0, SCHED_RR, &param);
	if (err < 0)
	{
		perror("\nSocketHandleClientThread: sched_setscheduler() error: ");
	}
		
	err = nice(-18); //(keep the nice value set to a unique # so we can still find this thread in htop even though we are really using setscheduler() to set the priority)
	if (err < 0)
	{
		perror("\nSocketHandleClientThread: nice() error: ");
	}
	
	size_t Client = reinterpret_cast<size_t>(arg);

	memset((char *)&nowait,0,sizeof(nowait));
			
	printf("\nClientSocket: %u: Waiting for a connection...\n\n", Client);
	fflush(stdout);
	
	SocketConnect(Client);
	
	while(true)
	{
		bool Bored = true;
		
		if (ClientConnections[Client].DataToFromDevice.remotedataready())  
		{ 
			Bored = false;
			//~ printf("DFZ: %d\n", DataFromDevice.len()); 
			char c = ClientConnections[Client].DataToFromDevice.remotegetcqq();
			int numbytes = send(ClientConnections[Client].hSocket,&c,1,0);
			if (1 != numbytes)
			{
				printf("\nClientSocket: %u: write to socket error (%d bytes gave: %u)\n", Client, numbytes, errno);
				close(ClientConnections[Client].hSocket);
				ClientConnections[Client].hSocket = -1;
				printf("\nClientSocket: %u: Closed old socket; looking for new connections.\n\n", Client); 
				SocketConnect(Client);
			}
			//~ else { printf("->'%c'", c); fflush(stdout); }
		}
		//~ else { printf("DFZ: %d\n", DataFromDevice.len()); fflush(stdout); }
		
		FD_ZERO(&sockset);
		FD_SET(ClientConnections[Client].hSocket, &sockset);	
		int result = select(ClientConnections[Client].hSocket + 1, &sockset, NULL, NULL, &nowait);
		if (result < 0)	
		{ 
			perror("\nClientSocket: select from socket error: ");
			close(ClientConnections[Client].hSocket);
			ClientConnections[Client].hSocket = -1;
			printf("\nClientSocket: %u: Closed old socket; looking for new connections.\n\n", Client); 
			SocketConnect(Client);
		}
		else if (result == 1)
		{
			if (FD_ISSET(ClientConnections[Client].hSocket, &sockset)) // The socket has data. For good measure, it's not a bad idea to test further
			{
				char c = 0;
				int numbytes = recv(ClientConnections[Client].hSocket,&c,1,0);
				if (1 != numbytes)
				{
					printf("\nClientSocket: %u: read from socket error or empty read (%d bytes gave: %u)\n", Client, numbytes, errno);
					perror("\nClientSocket: errno: ");
					close(ClientConnections[Client].hSocket);
					ClientConnections[Client].hSocket = -1;
					printf("\nClientSocket: %u: Closed old socket; looking for new connections.\n\n", Client); 
					SocketConnect(Client);
				}
				else
				{
					Bored = false;
					//~ printf("->'%c'", c); fflush(stdout);
					ClientConnections[Client].DataToFromDevice.remoteputcqq(c);
				}
			}
		}
		
		//give up our timeslice so as not to bog the system...maybe there's someting around to smoke. or we could watch clouds...if a thread falls asleep in the desert, and no one's around to hear it...
		if (Bored)
		{
			struct timespec tenmilliseconds;
			memset((char *)&tenmilliseconds,0,sizeof(tenmilliseconds));
			tenmilliseconds.tv_nsec = 10000000;
			nanosleep(&tenmilliseconds, NULL);
		}
	}
	
	//see http://stefan.buettcher.org/cs/conn_closed.html to know when socket is closed by client. or just wait until read or select returns 0.
	return(NULL);
}



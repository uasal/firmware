#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>

#include "ClientConnection.hpp"

std::atomic<size_t> NumClientConnections(0);
ClientConnection ClientConnections[MaxClientConnections];

bool InClientConnections(const ClientConnection& connection)
{
	for (size_t i = 0; i < NumClientConnections.load(); i++) 
	{
		if (connection == ClientConnections[i]) { return(true); }
	}
	return(false);
}

extern "C"
{
	#ifdef WIN32
	void SocketConnect(int& hsock, const int hserver, struct sockaddr& addr, int addrlen)
	#else
	void SocketConnect(int& hsock, const int hserver, struct sockaddr& addr, socklen_t& addrlen)
	#endif
	{
		//Get ready to fill in the new address; leaving contents in the addr variable can cause accept() to fail.
		{
			hsock = 0; //This lets us know we're not connected anymore
			memset(&addr, 0, sizeof(struct sockaddr));
			addrlen = sizeof(struct sockaddr);
		}

		//Wait for someone to connect!
		hsock=accept(hserver, &addr, &addrlen);
		
		if (hsock < 0)
		{
			#ifdef WIN32
			formatf("\nSensorBoardServer: connection error: %lu\n", (unsigned long)WSAGetLastError());
			#else
			perror("\nSensorBoardServer: connection error; ");
			#endif
		}
		else { printf("\nSensorBoardServer: Got a connection(%u).\n\n", hsock); }
	}	

	void* SocketHandleClientThread(void *arg)
	{
		fd_set sockset;
		struct timeval nowait;
		struct timespec tenmilliseconds;
		memset((char *)&nowait,0,sizeof(nowait));
		memset((char *)&tenmilliseconds,0,sizeof(tenmilliseconds));
		tenmilliseconds.tv_nsec = 10000000;
	
		if (NULL == arg) { return(NULL); }
		
		long hServerSocket = reinterpret_cast<long>(arg);
		
		//Add it to the list!
		size_t ClientConnectionIndex = NumClientConnections.fetch_add(1);
		ClientConnection& Client = ClientConnections[ClientConnectionIndex];
		Client.hServerSocket = hServerSocket; //the all important stuff we just set up must be passed to the new thread!
		
		printf("\nSensorBoardServer: SocketHandleClientThread: Waiting for a connection...");
		fflush(stdout);
		
		SocketConnect(Client.hSocket, Client.hServerSocket, Client.Addr, Client.AddrLen);
		
		//If we get here, someone connected to us, so start another thread for the next connection!
		formatf("\nSensorBoardServer: connected; creating ~another~ socket handler thread for the ~next~ connection...");
		pthread_t thread;
		int rc = pthread_create(&thread, NULL, SocketHandleClientThread, reinterpret_cast<void*>(hServerSocket));
		if (0 != rc) { formatf("\nSensorBoardServer: pthread_create returned %d.\n", rc); }
		
		while(true)
		{
			bool Bored = true;
			
			if ( false == (Client.DataToClient.wasEmpty()) ) 
			{ 
				Bored = false;
				//~ printf("DFZ: %d\n", DataToClient.len()); 
				uint8_t c = 0; 
				Client.DataToClient.pop(c);
				#ifdef WIN32
				char d = c;
				int numbytes = send(Client.hSocket,&d,1,0);
				#else
				int numbytes = send(Client.hSocket,&c,1,0);
				#endif
				if (1 != numbytes)
				{
					printf("\nSensorBoardServer: %s: write to socket error (%d bytes gave: %u)\n", Client.Addr.sa_data, numbytes, errno);
					#ifdef WIN32
					closesocket(Client.hSocket);
					#else
					close(Client.hSocket);
					#endif
					printf("\nSensorBoardServer: %s: Closed old socket; looking for new connections.\n\n", Client.Addr.sa_data); 
					SocketConnect(Client.hSocket, Client.hServerSocket, Client.Addr, Client.AddrLen);
				}
				//~ printf("%%");
				//~ else { printf("->'%c'", c); fflush(stdout); }
			}
			//~ else { printf("DFZ: %d\n", DataToClient.len()); fflush(stdout); }
			
			FD_ZERO(&sockset);
			FD_SET(Client.hSocket, &sockset);	
			int result = select(Client.hSocket + 1, &sockset, NULL, NULL, &nowait);
			if (result < 0)	
			{ 
				#ifdef WIN32
				formatf("\nSensorBoardServer: select from socket error: %lu\n", (unsigned long)WSAGetLastError());
				#else
				perror("\nSensorBoardServer: select from socket error: ");
				#endif
				#ifdef WIN32
				closesocket(Client.hSocket);
				#else
				close(Client.hSocket);
				#endif
				printf("\nSensorBoardServer: %s: Closed old socket; looking for new connections.\n\n", Client.Addr.sa_data); 
				SocketConnect(Client.hSocket, Client.hServerSocket, Client.Addr, Client.AddrLen);
			}
			else if (result == 1)
			{
				if (FD_ISSET(Client.hSocket, &sockset)) // The socket has data. For good measure, it's not a bad idea to test further
				{
					char c = 0;
					int numbytes = recv(Client.hSocket,&c,1,0);
					if (1 != numbytes)
					{
						printf("\nSensorBoardServer: %s: read from socket error or empty read (%d bytes gave: %u)\n", Client.Addr.sa_data, numbytes, errno);
						perror("\nSensorBoardServer: errno: ");
						#ifdef WIN32
						closesocket(Client.hSocket);
						#else
						close(Client.hSocket);
						#endif
						printf("\nSensorBoardServer: %s: Closed old socket; looking for new connections.\n\n", Client.Addr.sa_data); 
						SocketConnect(Client.hSocket, Client.hServerSocket, Client.Addr, Client.AddrLen);
					}
					else
					{
						Bored = false;
						//~ printf("->'%c'", c); fflush(stdout);
						Client.DataFromClient.push(c);
						//~ printf("&");
					}
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
		
		//see http://stefan.buettcher.org/cs/conn_closed.html to know when socket is closed by Client. or just wait until read or select returns 0.
		return(NULL);
	}
}

//EOF

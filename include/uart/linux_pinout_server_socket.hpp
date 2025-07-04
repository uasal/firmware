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
// Permission granted for perpetual non-exclusive end-use by the University of Arizona August 1, 2020
//


#ifndef _linux_pinout_server_socket_h
#define _linux_pinout_server_socket_h
#pragma once

#include <stdio.h>   /* Standard input/output definitions */
#include <string.h>  /* String function definitions */
#ifdef WIN32
	#include <winsock.h>
	#include <winsock2.h>
	#include <ws2tcpip.h>
	#include <io.h>
	//~ #include <windows.h>
#else
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
#endif

#include "format/formatf.h"

#include "IUart.h"

#define HOST_NAME_SIZE      255

class linux_pinout_server_socket : public IUart
{
public:

	linux_pinout_server_socket() : IUart(), hSocket(-1), hServer(-1), nAddressSize(sizeof(struct sockaddr_in)), nHostAddress(-1), Silent(false) { }
	virtual ~linux_pinout_server_socket() { deinit(); }

	virtual int init(const uint32_t HostPort, const char* HostName)
	{
		//~ struct hostent* pHostInfo;   /* holds info about a machine */
		char strHostName[HOST_NAME_SIZE];
		int nHostPort = 20339;
		
		if (-1 != hSocket) { deinit(); }
		
		if (-1 == hServer)		
		{
			strcpy(strHostName, "localhost");

			if (NULL != HostName)
			{
				strncpy(strHostName, HostName, HOST_NAME_SIZE);
				strHostName[HOST_NAME_SIZE - 1] = '\0';
			}
			if (0 != HostPort)
			{
				nHostPort = HostPort;
			}
			
			#ifdef WIN32
			formatf("\nStarting Winsock");
			WSADATA wsaData;
			if (WSAStartup(MAKEWORD(2,0), &wsaData) != 0) 
			{
				printf("\nZigSockServer: WSAStartup failed.\n");
				return 0;
			}
			#endif
							
			formatf("\nlinux_pinout_server_socket: Making socket");
			#ifdef WIN32
			hServer=socket(AF_INET, SOCK_STREAM, 0); //supposedly all sockets are non-blocking on w32
			#else
			hServer=socket(AF_INET, SOCK_STREAM | SOCK_NONBLOCK, 0);
			#endif
			if(hServer == -1)
			{
				perror("\nlinux_pinout_server_socket: Could not make a socket");
				return(errno);
			}
			
			// According to "Linux Socket Programming by Example" p. 319, we must call
			// setsockopt w/ SO_REUSEADDR option BEFORE calling bind.
			// Make the address is reuseable so we don't get the nasty message.
			int so_reuseaddr = 1; // Enabled.
			int reuseAddrResult = setsockopt(hServer, SOL_SOCKET, SO_REUSEADDR, (const char*)&so_reuseaddr, sizeof(so_reuseaddr));
			if(reuseAddrResult == -1)
			{
				perror("\nlinux_pinout_server_socket: Could not re-use socket");
				hServer = -1;
				return(errno);
			}
			
			formatf("\nlinux_pinout_server_socket: Binding to port %d",nHostPort);
			Address.sin_addr.s_addr = INADDR_ANY;
			Address.sin_port = htons(nHostPort);
			Address.sin_family = AF_INET;
			if (bind(hServer,(struct sockaddr*)&Address,sizeof(Address)) == -1)
			{
				perror("\nlinux_pinout_server_socket: Could not connect to host");
				hServer = -1;
				return(errno);
			}
			
			/*  get port number */
			getsockname( hServer, (struct sockaddr*) &Address, (socklen_t*)&nAddressSize);
			formatf("\nlinux_pinout_server_socket: opened socket as fd (%d) on port (%d) for stream i/o",hServer, ntohs(Address.sin_port) );
			//~ formatf("Server\n
				//~ sin_family        = %d\n
				//~ sin_addr.s_addr   = %d\n
				//~ sin_port          = %d\n"
				//~ , Address.sin_family
				//~ , Address.sin_addr.s_addr
				//~ , ntohs(Address.sin_port)
			//~ );
			
			formatf("\nlinux_pinout_server_socket: Making a listen queue of %d elements.", 2);
			if(listen(hServer, 2) == -1)
			{
				perror("\nlinux_pinout_server_socket: Could not listen");
				hServer = -1;
				return(errno);
			}
		}
		
		//Try to connect; it probably won't work cause there's no client ready. The calling thread will need to poll SocketConnect elsewhere...
		SocketConnect();
		
		return(IUart::IUartOK);
	}
	
	int SocketConnect()
	{
		/* get the connected socket */
		#ifdef WIN32
		hSocket=accept((int)hServer, (struct sockaddr*)&Address, (socklen_t*)&nAddressSize); //supposedly all sockets non-blocking on w32
		#else
		hSocket=accept4((int)hServer, (struct sockaddr*)&Address, (socklen_t*)&nAddressSize, SOCK_NONBLOCK);
		#endif
		if (hSocket < 0)
		{
			hSocket = -1;
				
			if ((errno != EAGAIN) && (errno != EWOULDBLOCK))
			{
				perror("\nlinux_pinout_server_socket: connection error; ");
			}
			
			return(errno);
		}
		else { formatf("\nlinux_pinout_server_socket: Got a connection.\n"); }
		
		return(IUart::IUartOK);
	}

	virtual void deinit()
	{
		formatf("\nClosing socket\n");
		if (-1 != hSocket) 
		{ 
			close(hSocket);
			close(hServer);
			hSocket = -1;
			hServer = -1;
		}
	}
	
	virtual bool dataready() const
	{
		fd_set sockset;
		struct timeval  nowait;
		memset((char *)&nowait,0,sizeof(nowait));
		//~ if (-1 == hSocket) { SocketConnect(); } //can't auto-reconnect as it breaks const-ness...
		if (-1 == hSocket) { return(false); }
		//~ if (-1 == hSocket) { return(true); } //technicall it's false, but returning true will call getcqq and make us reconnect...
		FD_ZERO(&sockset);
		FD_SET(hSocket, &sockset);	
		int result = select(hSocket + 1, &sockset, NULL, NULL, &nowait);
		if (result < 0)	
		{ 
			if ((errno != EAGAIN) && (errno != EWOULDBLOCK))
			{
				perror("\nlinux_pinout_server_socket: select from socket error: ");
				close(hSocket);
				formatf("\nlinux_pinout_server_socket: Closed old socket; looking for new connections.\n\n"); 
				//~ SocketConnect(); //can't auto-reconnect as it breaks const-ness...
			}
			return(false);
		}	
		else if (result == 1)
		{
			if (FD_ISSET(hSocket, &sockset)) // The socket has data. For good measure, it's not a bad idea to test further
			{
				return(true);
			}
		}
		return(false);
	}

	virtual char getcqq()
	{
		char c = (char)(-1);
		fd_set sockset;
		struct timeval  nowait;
		memset((char *)&nowait,0,sizeof(nowait));
		
		if (-1 != hSocket)
		{			
			FD_ZERO(&sockset);
			FD_SET(hSocket, &sockset);	
			int result = select(hSocket + 1, &sockset, NULL, NULL, &nowait);
			if (result < 0)	
			{ 
				if ((errno != EAGAIN) && (errno != EWOULDBLOCK))
				{
					perror("\nlinux_pinout_server_socket: select from socket error: ");
				}
				else
				{
					//~ formatf("\nlinux_pinout_server_socket: getcqq() : EAGAIN\n"); 
				}
				#ifdef WIN32
				closesocket(hSocket);
				#else
				close(hSocket);
				#endif
				hSocket = -1;					
				formatf("\nlinux_pinout_server_socket: Closed old socket; looking for new connections.\n\n"); 
				SocketConnect();
			}
			else if (result == 1)
			{
				if (FD_ISSET(hSocket, &sockset)) // The socket has data. For good measure, it's not a bad idea to test further
				{
					int numbytes = recv(hSocket,&c,1,0);
					if (1 != numbytes)
					{
						if ((errno != EAGAIN) && (errno != EWOULDBLOCK))
						{
							formatf("\nlinux_pinout_server_socket: read from socket error or empty read (%d bytes gave: %u)\n", numbytes, errno);
							perror("\nlinux_pinout_server_socket: errno: ");
						}
						else
						{
							//~ formatf("\nlinux_pinout_server_socket: getcqq() : EAGAIN\n"); 
						}
						#ifdef WIN32
						closesocket(hSocket);
						#else
						close(hSocket);
						#endif
						hSocket = -1;					
						formatf("\nlinux_pinout_server_socket: Closed old socket; looking for new connections.\n\n"); 
						SocketConnect();
					}
					else
					{
						//Do nothing, just return(c), below...
						//~ formatf("\nlinux_pinout_server_socket: getcqq(x%.2X)\n", c); 
					}
				}
			}
			else
			{
				//~ formatf("\nlinux_pinout_server_socket: getcqq() : != 1\n"); 
			}
		}
		else
		{
			if (!Silent) { printf("\nlinux_pinout_server_socket::getcqq(): read on uninitialized socket (not an err if no client connected); please open socket!\n"); }
			SocketConnect();
		}

  		return(c);
	}

	virtual char putcqq(char c)
	{
		if (-1 != hSocket)
		{
			int numbytes = send(hSocket,&c,1,0);
			if (1 != numbytes)
			{
				formatf("\nlinux_pinout_server_socket: write to socket error (%d bytes gave: %u)\n", numbytes, errno);
				#ifdef WIN32
				closesocket(hSocket);
				#else
				close(hSocket);
				#endif
				formatf("\nlinux_pinout_server_socket: Closed old socket; looking for new connections.\n\n"); 
				SocketConnect();
			}
			//~ else { formatf("->'%c'", c); fflush(stdout); }
			//~ else { formatf("->'x%.2X'", c); fflush(stdout); }
		}
		else
		{
			if (!Silent) { printf("linux_pinout_server_socket::putcqq('%c'): write on uninitialized socket (not an err if no clients connected); please open socket!\n", c); }
			SocketConnect();
		}

 		return (c);
	}

	virtual void flushoutput()
	{
		if (-1 != hSocket)
		{
			#ifdef WIN32
			#else
			fsync(hSocket);
			#endif
		}
		else
		{
			printf("linux_pinout_server_socket::flushout(): fflush on uninitialized socket; please open socket!\n");
		}
	}
	
	virtual void purgeinput()
	{
		//~ if(dataready)
	}
	
	virtual bool connected() { return(hSocket > 0); }	
	virtual bool isopen() const { return(hSocket > 0); }	
	void silent(const bool s) { Silent = s; }
	
	private:

		int hSocket;                 /* handle to socket */
		int hServer; 
		struct sockaddr_in Address;  /* Internet socket address stuct */
		int nAddressSize;
		long nHostAddress;
		bool Silent;
};

#endif //linux_pinout_server_socket_h

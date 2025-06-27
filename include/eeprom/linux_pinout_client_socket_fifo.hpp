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


#ifndef _linux_pinout_client_socket_fifo_h
#define _linux_pinout_client_socket_fifo_h
#pragma once

#include <stdio.h>   /* Standard input/output definitions */
#include <string.h>  /* String function definitions */
#ifdef WIN32
	//~ #include <windows.h>
	#include <io.h>
	#include <winsock.h>
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

#include "CircularFifo.hpp"

#define HOST_NAME_SIZE      255

class linux_pinout_client_socket_fifo
{
public:

	linux_pinout_client_socket_fifo() : hSocket(-1) { }
	~linux_pinout_client_socket_fifo() { }
	
	CircularFifo<uint8_t, 16384> RxData;

	int init(const int HostPort, const char* HostName)
	{
		struct hostent* pHostInfo;   /* holds info about a machine */
		struct sockaddr_in Address;  /* Internet socket address stuct */
		long nHostAddress;
		char strHostName[HOST_NAME_SIZE];
		int nHostPort = 20339;
		
		if (-1 != hSocket) { deinit(); }
		
		strcpy(strHostName, "localhost");

		if (NULL != HostName)
		{
			strncpy(strHostName, HostName, HOST_NAME_SIZE);
			strHostName[HOST_NAME_SIZE] = '\0';
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
			
		formatf("\nlinux_pinout_client_socket_fifo::init(): Making a socket");
		/* make a socket */
		hSocket=socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);

		if(hSocket == -1)
		{
			#ifdef WIN32
			formatf("\nlinux_pinout_client_socket_fifo::init(): Could not make a socket: %d\n", WSAGetLastError());
			#else
			perror("\nlinux_pinout_client_socket_fifo::init(): Could not make a socket\n");
			#endif
			return(errno);
		}
		else { formatf("\nlinux_pinout_client_socket_fifo::init(): Socket handle: %d\n", hSocket); }

		/* get IP address from name */
		pHostInfo=gethostbyname(strHostName);
		if (NULL == pHostInfo)
		{
			#ifdef WIN32
			formatf("\nlinux_pinout_client_socket_fifo::init(): Could not gethostbyname(): %d\n", WSAGetLastError());
			#else
			perror("\nlinux_pinout_client_socket_fifo::init(): Could not gethostbyname(): ");
			#endif
			return(errno);
		}
		/* copy address into long */
		memcpy(&nHostAddress,pHostInfo->h_addr,pHostInfo->h_length);

		/* fill address struct */
		Address.sin_addr.s_addr=nHostAddress;
		Address.sin_port=htons(nHostPort);
		Address.sin_family=AF_INET;

		formatf("\nlinux_pinout_client_socket_fifo::init(): Connecting to %s", strHostName);
		formatf(" on port %d", nHostPort);

		/* connect to host */
		if(connect(hSocket,(struct sockaddr*)&Address,sizeof(Address)) 
		   == -1)
		{
			#ifdef WIN32
			formatf("\nlinux_pinout_client_socket_fifo::init(): Could not connect to host: %d\n", WSAGetLastError());
			#else
			perror("\nlinux_pinout_client_socket_fifo::init(): Could not connect to host: ");
			#endif
			return(errno);
		}
		else { formatf("\nlinux_pinout_client_socket_fifo::init(): Connected.\n"); }
			
		return(IUartOK);
	}

	void deinit()
	{
		if (-1 != hSocket) 
		{ 
			formatf("\nlinux_pinout_client_socket_fifo::deinit(): Closing socket\n");
		
			#ifdef WIN32
			closesocket(hSocket);
			#else
			close(hSocket);
			#endif
			
			hSocket = -1;
		}

		#ifdef WIN32
		WSACleanup();
		#endif
	}
	
	bool dataready() const
	{
		fd_set sockset;
		struct timeval  nowait;
		memset((char *)&nowait,0,sizeof(nowait));
		if (-1 == hSocket) { return(false); } //open?
		FD_ZERO(&sockset);
		FD_SET(hSocket, &sockset);	
		int result = select(hSocket + 1, &sockset, NULL, NULL, &nowait);
		if (result < 0)	{ } //"You have an error"
		else if (result == 1)
		{
			if (FD_ISSET(hSocket, &sockset)) // The socket has data. For good measure, it's not a bad idea to test further
			{
				return(true);
			}
		}
		return(false);
	}

	bool Process()
	{
		if (!dataready()) { return(false); }

		const size_t MAX_BUFFER = 4096;
		uint8_t Buffer[MAX_BUFFER];
		
		if (-1 != hSocket)
		{			
			int numbytes = recv(hSocket,Buffer,MAX_BUFFER,0);
			if (numbytes <= 0)
			{
				#ifdef WIN32
				formatf("linux_pinout_client_socket_fifo::getcqq(): read from socket error (%d bytes gave: %u [errno: %u])\n", numbytes, WSAGetLastError(), errno);
				#else
				formatf("linux_pinout_client_socket_fifo::getcqq(): read from socket error (%d bytes gave: %u)\n", numbytes, errno);
				#endif
				
				deinit();
				
				return(false);
			}
			else
			{
				//Put data in ring buffer
				for (size_t i = 0; i < numbytes; i++) { RxData.push(Buffer[i]); }
			}
			//~ else { formatf("<-'x%.2X'", c); fflush(stdout); }
			//~ putchar(c);
			//~ formatf("%c", c);
		}
		else
		{
			printf("linux_pinout_client_socket_fifo::getcqq(): read on uninitialized socket; please open socket!\n");
			return(false);
		}

  		return(true);
	}

	void puts(const uint8_t const* s, const size_t len)	
	{
		if (-1 != hSocket)
		{
			int numbytes = send(hSocket,s,len,0);
			if (numbytes <= 0)
			{
				#ifdef WIN32
				formatf("linux_pinout_client_socket_fifo::putcqq(): write from socket error (%d bytes gave: %u [errno: %u])\n", numbytes, WSAGetLastError(), errno);
				#else
				formatf("linux_pinout_client_socket_fifo::putcqq(): write from socket error (%d bytes gave: %u)\n", numbytes, errno);
				#endif
				
				deinit();
				
				return(0);
			}
		}
		else
		{
			printf("linux_pinout_client_socket_fifo::putcqq(): write on uninitialized socket; please open socket!\n");
		}

 		return (c);
	}

	void flushoutput()
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
			printf("linux_pinout_client_socket_fifo::flushout(): fflush on uninitialized socket; please open socket!\n");
		}
	}
	
	void purgeinput()
	{
		//~ if(dataready)
	}
	
	bool connected() const
	{
		return(-1 != hSocket);
	}
	
	bool isopen() const { return(connected()); }
	
	public:

		int hSocket;                 /* handle to socket */
};

#endif //linux_pinout_client_socket_fifo_h

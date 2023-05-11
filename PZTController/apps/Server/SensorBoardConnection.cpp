#include <pthread.h>
#include <vector>
using namespace std;
#include <string.h>

#include "uart/IUart.h"
#include "eeprom/CircularFifo.hpp"
#include "uart/linux_pinout_client_socket.hpp"
#include "uart/linux_pinout_circular_buffer_bytes.hpp"
#include "uart/MountainOpsBinaryPacketFinderThreadSafeFifo.hpp"
#include "IPAddr.h"

#include "SensorBoardConnection.hpp"

//~ std::vector<SensorBoardConnection> SensorBoardConnections;
SensorBoardConnection SensorBoardConnections[MaxSensorBoardConnections];
std::atomic<size_t> NumSensorBoardConnections(0);

bool InSensorBoardConnections(const IPAddr& ip)
{
	//~ if (SensorBoardConnections.empty()) { return(false); }
	//~ for (size_t i = 0; i < SensorBoardConnections.size(); i++) 
	for (size_t i = 0; i < NumSensorBoardConnections.load(); i++) 
	{
		if (ip == SensorBoardConnections[i].SensorBoardIP) { return(true); }
	}
	return(false);
}

extern "C"
{
	void* SocketHandleSensorBoardThread(void *arg)
	{	
		if (!arg) { return(NULL); }
		
		//~ SensorBoardConnection* SensorBoard = reinterpret_cast<SensorBoardConnection*>(arg);
		IPAddr IP = *reinterpret_cast<IPAddr*>(arg);
		
		//Done with heap container
		delete (reinterpret_cast<IPAddr*>(arg));
			
		//Add it to the list!
		//~ {
			//~ //Make sure destructor gets called on obj before copy, so it doesn't jack the connection?!
			//~ SensorBoardConnection NewSensorBoard(IP);
			//~ Index = SensorBoardConnections.size();
			//~ SensorBoardConnections.push_back(NewSensorBoard);					
		//~ }
		//~ //Now get the 'real' object from the list after copy constructor
		//~ SensorBoardConnection& SensorBoard = SensorBoardConnections.back();
		
		//Add it to the list!
		size_t SensorBoardConnectionIndex = NumSensorBoardConnections.fetch_add(1);
		SensorBoardConnection& SensorBoard = SensorBoardConnections[SensorBoardConnectionIndex];
		SensorBoard.SensorBoardIP = IP;

		//Is our input sane???
		if (0 == SensorBoard.SensorBoardIP.all) { return(NULL); }
		if (0xFFFFFFFFUL == SensorBoard.SensorBoardIP.all) { return(NULL); }
		
		//Make the IP into a string!
		//~ struct sockaddr_in AddrIn;
		//~ char IPAddr[INET_ADDRSTRLEN];
		//~ inet_ntop(AF_INET, &AddrIn, IPAddr, INET_ADDRSTRLEN);
        char IPAddr[255];
		SensorBoard.SensorBoardIP.sprintf(IPAddr);
		
		printf("\nSensorBoardServer: SocketHandleSensorBoardThread(%s) started...\n", IPAddr);
		
		//Ok, now we fire up the SensorBoard Socket!
		if (IUart::IUartOK != SensorBoard.SensorBoardSocketPinout.init(SensorBoard, IPAddr))
		{
			printf("\nSensorBoardServer: SocketHandleSensorBoardThread(): Couldn't open SensorBoard socket %s:SensorBoard!", IPAddr);
		}
		
		printf("\nSensorBoardServer: SocketHandleSensorBoardThread(): SensorBoard socket %s:SensorBoard is handle %u.", IPAddr, SensorBoard.SensorBoardSocketPinout.hSocket);
			
		//Now we handle the socket!
		while(true)
		{
			bool Bored = true;
			
			if (-1 == SensorBoard.SensorBoardSocketPinout.hSocket)
			{
				printf("\nSensorBoardServer: SocketHandleSensorBoardThread(): SensorBoard socket %s:SensorBoard failed! reconnecting!", IPAddr);
				if (IUart::IUartOK != SensorBoard.SensorBoardSocketPinout.init(SensorBoard, IPAddr))
				{
					printf("\nSensorBoardServer: SocketHandleSensorBoardThread(): Couldn't open SensorBoard socket %s:SensorBoard on reconnect!", IPAddr);
				}
			}
			
			if (SensorBoard.IsConnected()) 
			{
				//Get data from SensorBoard
				if (SensorBoard.SensorBoardSocketPinout.dataready())
				{
					Bored = false;
					SensorBoard.DataFromSensorBoard.push(SensorBoard.SensorBoardSocketPinout.getcqq());
					//~ printf("#");
					//~ printf("\nSensorBoardServer: DataFromSensorBoard(%zu).", SensorBoard.DataFromSensorBoard.depth());
				}
				
				//Send data to SensorBoard
				if (!(SensorBoard.DataToSensorBoard.wasEmpty()))
				{
					uint8_t c = 0;
					Bored = false;
					if (SensorBoard.DataToSensorBoard.pop(c)) { SensorBoard.SensorBoardSocketPinout.putcqq(c); }
					//~ printf("@");
				}
				else
				{
					if (0 == SensorBoardConnectionIndex)
					{
						//~ printf("\nSensorBoardServer: SocketHandleSensorBoardThread(%s): DataToSensorBoardEmpty!", IPAddr);
					}
				}
			}
			else
			{
				printf("\nSensorBoardServer: SocketHandleSensorBoardThread(%s): Re-Connecting!", IPAddr);
				fflush(stdout);
				if (IUart::IUartOK != SensorBoard.SensorBoardSocketPinout.init(SensorBoard, IPAddr))
				{
					printf("\nSensorBoardServer: SocketHandleSensorBoardThread(): Couldn't open SensorBoard socket %s:SensorBoard!", IPAddr);
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

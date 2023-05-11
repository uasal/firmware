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
#include "uart/MountainOpsBinaryPacketFinderThreadSafeFifo.hpp"
#include "IPAddr.h"

struct SensorBoardConnection
{
	IPAddr SensorBoardIP;
	pthread_t thread;	
	CircularFifo<uint8_t, 32768> DataToSensorBoard;
	CircularFifo<uint8_t, 32768> DataFromSensorBoard;
	//~ linux_pinout_circular_buffer DataFromSensorBoard;
	MountainOpsBinaryPacketFinder<32768, 4096> DataFromSensorBoardPacketizer;	
	linux_pinout_client_socket SensorBoardSocketPinout;
	
	SensorBoardConnection() : DataFromSensorBoardPacketizer(DataFromSensorBoard, false)
	{ 
	
	}
	
	SensorBoardConnection(const IPAddr& IP) : SensorBoardIP(IP), DataFromSensorBoardPacketizer(DataFromSensorBoard, false)
	{
		
	}
	
	SensorBoardConnection(const SensorBoardConnection& SensorBoard) : DataFromSensorBoardPacketizer(DataFromSensorBoard, false)
	{
		//~ memcpy(this, &SensorBoard, sizeof(SensorBoardConnection));
		SensorBoardIP = SensorBoard.SensorBoardIP;
	}
	
	bool operator==(const SensorBoardConnection& SensorBoard) const { return(SensorBoardIP == SensorBoard.SensorBoardIP); }
	bool operator==(const IPAddr& ip) const { return(SensorBoardIP == ip); }
	
	bool IsConnected() const { return(SensorBoardSocketPinout.connected()); }
};

static const size_t MaxSensorBoardConnections = 8;
extern std::atomic<size_t> NumSensorBoardConnections;
//~ extern std::vector<SensorBoardConnection> SensorBoardConnections;
extern SensorBoardConnection SensorBoardConnections[MaxSensorBoardConnections];

bool InSensorBoardConnections(const IPAddr& ip);

extern "C"
{
	void* SocketHandleSensorBoardThread(void *arg);
};

//EOF

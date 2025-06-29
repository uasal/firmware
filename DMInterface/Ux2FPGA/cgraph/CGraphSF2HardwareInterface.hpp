/// \file
/// $Revision: $

#pragma once
#include <stdint.h>
#include <sys/types.h>
#define TBDTOMakeNiceOffset  32

union AdcAccumulator 		
{
    uint64_t all;
    struct 
    {
        //~ int64_t Samples : 48;
		int64_t Samples : 24;
		int64_t reserved : 24;
        uint16_t NumAccums;

    } __attribute__((__packed__));

    //static const int32_t AdcFullScale = 0x7FFFFFFFL; //2^32 - 1; must divide accumulator by numaccums first obviously

    AdcAccumulator() { all = 0; }

    void formatf() const { ::printf("AdcAccumulator: Samples: %+10.0lf ", (double)Samples); ::printf("(0x%.8lX", (unsigned long)(all >> 32));  ::printf("%.8lX)", (unsigned long)(all)); ::printf(", NumAccums: %lu ", (unsigned long)NumAccums); ::printf("(0x%lX)", (unsigned long)NumAccums); }

} __attribute__((__packed__));

//#include "CGraphFSMHardwareInterface.hpp" //AdcAccumulator definition
// Make a separate AdcAccumulator definition - possibly in a utilities directory

union CGraphDMHardwareControlRegister
{
    uint32_t all;
    struct 
    {
        uint16_t HighVoltageEnable : 1; //b0; Turn on the +150V supply
        uint16_t PowerEnable : 1; //b2; Turn on the secondary supplies

    } __attribute__((__packed__));

    CGraphDMHardwareControlRegister() { all = 0; }

    //~ void printf() const { ::printf("CGraphDMHardwareControlRegister: Sample: %+10.0lf ", (double)Sample); ::printf("(0x%.8lX", (unsigned long)(all >> 32));  ::printf("%.8lX)", (unsigned long)(all)); ::printf(", NumAccums: %lu ", (unsigned long)NumAccums); ::printf("(0x%lX)", (unsigned long)NumAccums); }

} __attribute__((__packed__));

union CGraphDMHardwareStatusRegister
{
    uint32_t all;
    struct 
    {
        uint32_t PPSDetected : 1; //b0; Is there toggling on the PPS input?
        uint32_t HVFault : 1; //b1; Overtemperature or overcurrent on first high voltage output driver
		uint32_t VNegFault : 1; //b1; Overtemperature or overcurrent on first high voltage output driver
		uint32_t V1Fault : 1; //b1; Overtemperature or overcurrent on first high voltage output driver
		uint32_t V3DmFault : 1; //b1; Overtemperature or overcurrent on first high voltage output driver
		uint32_t V3FpgaFault : 1; //b1; Overtemperature or overcurrent on first high voltage output driver
		uint32_t V3AuxFault : 1; //b1; Overtemperature or overcurrent on first high voltage output driver
		uint32_t V5Fault : 1; //b1; Overtemperature or overcurrent on first high voltage output driver
		uint32_t V6Fault : 1; //b1; Overtemperature or overcurrent on first high voltage output driver
		uint32_t V9Fault : 1; //b1; Overtemperature or overcurrent on first high voltage output driver
        
    } __attribute__((__packed__));

    CGraphDMHardwareStatusRegister() { all = 0; }

    //~ void printf() const { ::printf("CGraphDMHardwareStatusRegister: Sample: %+10.0lf ", (double)Sample); ::printf("(0x%.8lX", (uint32_t)(all >> 32));  ::printf("%.8lX)", (uint32_t)(all)); ::printf(", NumAccums: %lu ", (uint32_t)NumAccums); ::printf("(0x%lX)", (uint32_t)NumAccums); }

} __attribute__((__packed__));

union CGraphDMUartStatusRegister
{
    uint32_t all;
    struct {
      uint32_t UartRxFifoEmpty : 1;
      uint32_t UartRxFifoFull : 1;
      uint32_t UartTxFifoEmpty : 1;
      uint32_t UartTxFifoFull : 1;
      uint32_t reserved1 : 4;
      uint32_t UartRxFifoCount : 8;
      uint32_t UartTxFifoCount : 8;
      uint32_t UartRxFifoCountHi : 2;
      uint32_t UartTxFifoCountHi : 2;
      uint32_t reserved2 : 4;

    } __attribute__((__packed__));

  CGraphDMUartStatusRegister() { all = 0; }

  //~ void printf() const { ::printf("CGraphDMUartStatusRegister: RxE:%c, RxF:%c, TxE:%c, TxF:%c, RxC:%u, TxC:%u", UartRxFifoEmpty?'Y':'N', UartRxFifoFull?'Y':'N', UartTxFifoEmpty?'Y':'N', UartTxFifoFull?'Y':'N', UartRxFifoCount + (UartRxFifoCountHi << 8), UartTxFifoCount + (UartTxFifoCountHi << 8)); }
  void printf() const { ::printf("CGraphDMUartStatusRegister: RxE:%c, RxF:%c, TxE:%c, TxF:%c, RxC:%u, TxC:%u", UartRxFifoEmpty?'Y':'N', UartRxFifoFull?'Y':'N', UartTxFifoEmpty?'Y':'N', UartTxFifoFull?'Y':'N', UartRxFifoCount, UartTxFifoCount); }

} __attribute__((__packed__));

struct CGraphDMHardwareInterface
{
  uint32_t DeviceSerialNumber; //ro; FPGA manufacturer hardcoded device UUID
  uint32_t FpgaFirmwareBuildNumber; //ro; Auto-incremented firmware UUID
  uint32_t UnixSeconds; //rw; equivalent to time_t for 32b systems; low order bits of time_t on 64b systems; write to set/initialize FPGA clock
  uint32_t IdealTicksPerSecond; //ro; Target clock speed of FPGA device, approx 100M; likely 14.7456M * 7 = 103,219,200.
  uint32_t ActualTicksLastSecond; //ro; Count of clock ticks for entire last second; equal to IdealTicksPerSecond unless clock was set or GPS PPS signal is present
  uint32_t ClockTicksThisSecondAddr; //ro Running count of clock ticks since the start of the current second
  uint32_t ClockSteeringDacSetpoint; //rw; 
  uint32_t DacChannelIndex; //either this way of setting Dac's or the flat model, below...
  uint32_t DacSetpoint; //either this way of setting Dac's or the flat model, below...
  CGraphDMHardwareControlRegister ControlRegister; //rw; see definition above
  CGraphDMHardwareStatusRegister StatusRegister; //ro; see definition above
  int32_t PPSRtcPhaseComparator; //ro;
  int32_t PPSAdcPhaseComparator; //ro;
  AdcAccumulator MonitorAdcAccumulator; //ro; Monitor A/D samples for channel specififed in MonitorAdcReadChannel
  uint32_t MonitorAdcReadChannel; //rw; which channel to read for MonitorA/D
  uint32_t UartFifo2; //rw; send or read bytes from uart(s)
  CGraphDMUartStatusRegister UartStatusRegister2; //ro; what state are the uart(s) in?
  uint32_t UartFifo1; //rw; send or read bytes from uart(s)
  CGraphDMUartStatusRegister UartStatusRegister1; //ro; what state are the uart(s) in?
  uint32_t UartFifo0; //rw; send or read bytes from uart(s)
  CGraphDMUartStatusRegister UartStatusRegister0; //ro; what state are the uart(s) in?
  uint8_t BaudDivider0; //rw; clock divider for the first serial port
  CGraphDMUartStatusRegister UartStatusRegister3; //ro; what state are the uart(s) in?
  uint8_t BaudDividerUsb;
  uint32_t UartFifoUsb; //rw; send or read bytes from uart(s)
  CGraphDMUartStatusRegister UartStatusRegisterUsb; //ro; what state are the uart(s) in?
  uint32_t reserved[TBDTOMakeNiceOffset];
  uint32_t DacSetpoints[960];
	
  static const uint32_t DacFullScale;
  static const double DacDriverFullScaleOutputVoltage; //150 Volts, don't get your fingers near this thing!
  static const double DMDriverFullScaleOutputTravel; //Meters; note our granularity is this / DacFullScale which is approx 10pm

} __attribute__((__packed__));

class CGraphDMProtoHardwareMmapper
{
public:

  static const off_t FpgaMmapAdress;
  static const off_t FpgaMmapMask;
  static const char FpgaBusEmulationPathName[];

  //~ int FpgaHandle;
  //~ void* FpgaBus;
  
  //~ CGraphDMHardwareMmapper(const bool OpenOnConstruct = false) :

  //~ FpgaHandle(0),
  //~ FpgaBus(MAP_FAILED)//,

  //~ { if (OpenOnConstruct) { open(); } }
  
  //~ ~CGraphDMHardwareMmapper() { close(); }

  static int open(int& FpgaHandle, CGraphDMHardwareInterface*& FpgaBus);
  static int close(int& FpgaHandle, CGraphDMHardwareInterface*& FpgaBus);
  static int read(const CGraphDMHardwareInterface* FpgaBus, const size_t Address, void* Buffer, const size_t Len);
  static int write(CGraphDMHardwareInterface* FpgaBus, const size_t Address, const void* Buffer, const size_t Len);
};

//EOF

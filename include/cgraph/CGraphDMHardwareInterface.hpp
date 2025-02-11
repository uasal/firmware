//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
//

#pragma once
#include <stdint.h>
#include <sys/types.h>

#include "format/formatf.h"

#include "uart/UartStatusRegister.hpp"

#include "cgraph/CGraphCommon.hpp"
#include "CGraphFSMHardwareInterface.hpp" //AdcAccumulator definition

union CGraphDMCIHardwareControlRegister
{
    uint32_t all;
    struct 
    {
        uint16_t HighVoltageEnable : 1; //b0; Turn on the +150V supply
        uint16_t PowerEnable : 1; //b2; Turn on the secondary supplies

    } __attribute__((__packed__));

    CGraphDMCIHardwareControlRegister() { all = 0; }

    //~ void formatf() const { ::formatf("CGraphDMCIHardwareControlRegister: Sample: %+10.0lf ", (double)Sample); ::formatf("(0x%.8lX", (unsigned long)(all >> 32));  ::formatf("%.8lX)", (unsigned long)(all)); ::formatf(", NumAccums: %lu ", (unsigned long)NumAccums); ::formatf("(0x%lX)", (unsigned long)NumAccums); }

} __attribute__((__packed__));

union CGraphDMCIHardwareStatusRegister
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

    CGraphDMCIHardwareStatusRegister() { all = 0; }

    //~ void formatf() const { ::formatf("CGraphDMCIHardwareStatusRegister: Sample: %+10.0lf ", (double)Sample); ::formatf("(0x%.8lX", (uint32_t)(all >> 32));  ::formatf("%.8lX)", (uint32_t)(all)); ::formatf(", NumAccums: %lu ", (uint32_t)NumAccums); ::formatf("(0x%lX)", (uint32_t)NumAccums); }

} __attribute__((__packed__));

union CGraphDMCIUartStatusRegister
{
    uint32_t all;
    struct 
    {
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

    CGraphDMCIUartStatusRegister() { all = 0; }

    //~ void formatf() const { ::formatf("CGraphDMCIUartStatusRegister: RxE:%c, RxF:%c, TxE:%c, TxF:%c, RxC:%u, TxC:%u", UartRxFifoEmpty?'Y':'N', UartRxFifoFull?'Y':'N', UartTxFifoEmpty?'Y':'N', UartTxFifoFull?'Y':'N', UartRxFifoCount + (UartRxFifoCountHi << 8), UartTxFifoCount + (UartTxFifoCountHi << 8)); }
	void formatf() const { ::formatf("CGraphDMCIUartStatusRegister: RxE:%c, RxF:%c, TxE:%c, TxF:%c, RxC:%u, TxC:%u", UartRxFifoEmpty?'Y':'N', UartRxFifoFull?'Y':'N', UartTxFifoEmpty?'Y':'N', UartTxFifoFull?'Y':'N', UartRxFifoCount, UartTxFifoCount); }

} __attribute__((__packed__));

struct CGraphDMCIHardwareInterface
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
    CGraphDMCIHardwareControlRegister ControlRegister; //rw; see definition above
    CGraphDMCIHardwareStatusRegister StatusRegister; //ro; see definition above
    int32_t PPSRtcPhaseComparator; //ro;
    int32_t PPSAdcPhaseComparator; //ro;
	AdcAccumulator MonitorAdc0Accumulator; //ro; Monitor A/D samples for channel specififed in MonitorAdcReadChannel
	uint32_t MonitorAdc0ReadChannel; //rw; which channel to read for MonitorA/D
	AdcAccumulator MonitorAdc1Accumulator; //ro; Monitor A/D samples for channel specififed in MonitorAdcReadChannel
	uint32_t MonitorAdc1ReadChannel; //rw; which channel to read for MonitorA/D
	AdcAccumulator DMController0MonitorAdcAccumulator; //ro; Monitor A/D samples for channel specififed in MonitorAdcReadChannel
	uint32_t DMController0MonitorAdcReadChannel; //rw; which channel to read for MonitorA/D
	AdcAccumulator DMController1MonitorAdcAccumulator; //ro; Monitor A/D samples for channel specififed in MonitorAdcReadChannel
	uint32_t DMController1MonitorAdcReadChannel; //rw; which channel to read for MonitorA/D
	AdcAccumulator DMController2MonitorAdcAccumulator; //ro; Monitor A/D samples for channel specififed in MonitorAdcReadChannel
	uint32_t DMController2MonitorAdcReadChannel; //rw; which channel to read for MonitorA/D
	AdcAccumulator DMController3MonitorAdcAccumulator; //ro; Monitor A/D samples for channel specififed in MonitorAdcReadChannel
	uint32_t DMController3MonitorAdcReadChannel; //rw; which channel to read for MonitorA/D
	AdcAccumulator DMController4MonitorAdcAccumulator; //ro; Monitor A/D samples for channel specififed in MonitorAdcReadChannel
	uint32_t DMController4MonitorAdcReadChannel; //rw; which channel to read for MonitorA/D
	AdcAccumulator DMController5MonitorAdcAccumulator; //ro; Monitor A/D samples for channel specififed in MonitorAdcReadChannel
	uint32_t DMController5MonitorAdcReadChannel; //rw; which channel to read for MonitorA/D
	uint32_t UartFifo0; //rw; send or read bytes from uart(s)
	CGraphDMCIUartStatusRegister UartStatusRegister0; //ro; what state are the uart(s) in?
	uint32_t UartFifo1; //rw; send or read bytes from uart(s)
	CGraphDMCIUartStatusRegister UartStatusRegister1; //ro; what state are the uart(s) in?
	uint32_t UartFifo2; //rw; send or read bytes from uart(s)
	CGraphDMCIUartStatusRegister UartStatusRegister2; //ro; what state are the uart(s) in?
	uint32_t UartFifo3; //rw; send or read bytes from uart(s)
	CGraphDMCIUartStatusRegister UartStatusRegister3; //ro; what state are the uart(s) in?
	uint8_t BaudDivider0; //rw; clock divider for the first serial port
	uint8_t BaudDivider1;
	uint8_t BaudDivider2;
	uint8_t BaudDivider3;
	uint16_t SpiExtBusAddrOut;
	uint16_t SpiExtBusAddrIn;
	uint16_t SpiExtBusDataOut;
	uint16_t SpiExtBusDataIn;
	uint32_t reserved[208]; //if we counted correctly there's 48 4-byte registers preceeding this padding...
	uint32_t DacSetpoints[960]; //These should start at offset 1024 / 0x0400
	
    static const uint32_t DacFullScale;
    static const double DacDriverFullScaleOutputVoltage; //150 Volts, don't get your fingers near this thing!
    static const double DMCIDriverFullScaleOutputTravel; //Meters; note our granularity is this / DacFullScale which is approx 10pm

    //~ void formatf() const { ::formatf("CGraphDMCIHardwareInterface: Sample: %+10.0lf ", (double)Sample); ::formatf("(0x%.8lX", (uint32_t)(all >> 32));  ::formatf("%.8lX)", (uint32_t)(all)); ::formatf(", NumAccums: %lu ", (uint32_t)NumAccums); ::formatf("(0x%lX)", (uint32_t)NumAccums); }

} __attribute__((__packed__));

class CGraphDMCIProtoHardwareMmapper
{
public:

    static const off_t FpgaMmapAdress;
    static const off_t FpgaMmapMask;
    static const char FpgaBusEmulationPathName[];

    //~ int FpgaHandle;
    //~ void* FpgaBus;

    //~ CGraphDMCIHardwareMmapper(const bool OpenOnConstruct = false) :

    //~ FpgaHandle(0),
    //~ FpgaBus(MAP_FAILED)//,

    //~ { if (OpenOnConstruct) { open(); } }

    //~ ~CGraphDMCIHardwareMmapper() { close(); }

    static int open(int& FpgaHandle, CGraphDMCIHardwareInterface*& FpgaBus);
    static int close(int& FpgaHandle, CGraphDMCIHardwareInterface*& FpgaBus);
    static int read(const CGraphDMCIHardwareInterface* FpgaBus, const size_t Address, void* Buffer, const size_t Len);
    static int write(CGraphDMCIHardwareInterface* FpgaBus, const size_t Address, const void* Buffer, const size_t Len);
};

//EOF

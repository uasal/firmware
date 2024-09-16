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

    void formatf() const { ::formatf("AdcAccumulator: Samples: %+10.0lf ", (double)Samples); ::formatf("(0x%.8lX", (unsigned long)(all >> 32));  ::formatf("%.8lX)", (unsigned long)(all)); ::formatf(", NumAccums: %lu ", (unsigned long)NumAccums); ::formatf("(0x%lX)", (unsigned long)NumAccums); }

} __attribute__((__packed__));

union AdcTimestamp
{
    uint32_t all;
    struct 
    {
        uint32_t SubsecondTicks : 27; //Max FPGA clock rate for 27b is 134,217,728Hz (134MHz) works well for our target speed of 103MHz.
        uint32_t UnixTimeLsbs: 5; //We'd really like a little more granularity, but it's only ambiguous every 32 seconds I think we can deal with that...

    } __attribute__((__packed__));

    //~ AdcTimestamp() { all = 0; }

    //~ void formatf() const { ::formatf("AdcTimestamp: SubsecondTicks: %+10.0lf ", (double)SubsecondTicks); ::formatf("(0x%.8lX", (unsigned long)(all >> 32));  ::formatf("%.8lX)", (unsigned long)(all)); ::formatf(", NumAccums: %lu ", (unsigned long)NumAccums); ::formatf("(0x%lX)", (unsigned long)NumAccums); }

} __attribute__((__packed__));

union AdcFifo
{
    uint64_t all;
    struct 
    {
        int32_t Sample;
        AdcTimestamp Timestamp;
        //~ uint16_t NumSamplesInFifo; //this makes it 10 bytes instead of 8...which for some reason makes acessing uartstatusregister segfault

    } __attribute__((__packed__));

    //~ static const int32_t AdcFullScale = 0x7FFFFFFFL; //2^32 - 1;
    //~ static const uint16_t FifoMaxDepth = 0x0FFFUL; //The FPGA doesn't actually have very much ram for fifos.

    AdcFifo() { all = 0; }

    //~ void formatf() const { ::formatf("AdcFifo: Sample: %+10.0lf ", (double)Sample); ::formatf("(0x%.8lX", (unsigned long)(all >> 32));  ::formatf("%.8lX)", (unsigned long)(all)); ::formatf(", NumAccums: %lu ", (unsigned long)NumAccums); ::formatf("(0x%lX)", (unsigned long)NumAccums); }

} __attribute__((__packed__));

union CGraphFSMHardwareControlRegister
{
    uint32_t all;
    struct 
    {
        uint16_t HighVoltageEnable : 1; //b0; Turn on the +150V supply
        uint16_t P1p2VEnable : 1; //b1; Turn on the +1.2V supply
        uint16_t P3p3VDEnable : 1; //b2; Turn on the +3.3V digital supply
        uint16_t PAnalogVEnable : 1; //b3; Turn on the analog supplies (+2.5V, +3.3VA, +5V, -5V)
        uint16_t SyncAdcs : 1; //b4; Syncronize first A/D sample to next incoming PPS signal
        uint16_t ForceChopper : 1; //b5; Force vs. freerun chopper; advanced feature not initially implemented
        uint16_t ChopperNonInverted : 1; //b6; Chopper polarity
        uint16_t AdcDownsampleRatio; //b16-31;  65535 = 16Hz; 1 = 1.04MHz

    } __attribute__((__packed__));

    CGraphFSMHardwareControlRegister() { all = 0; }

    //~ void formatf() const { ::formatf("CGraphFSMHardwareControlRegister: Sample: %+10.0lf ", (double)Sample); ::formatf("(0x%.8lX", (unsigned long)(all >> 32));  ::formatf("%.8lX)", (unsigned long)(all)); ::formatf(", NumAccums: %lu ", (unsigned long)NumAccums); ::formatf("(0x%lX)", (unsigned long)NumAccums); }

} __attribute__((__packed__));

union CGraphFSMHardwareStatusRegister
{
    uint32_t all;
    struct 
    {
        uint32_t PPSDetected : 1; //b0; Is there toggling on the PPS input?
        uint32_t HVFaultA : 1; //b1; Overtemperature or overcurrent on first high voltage output driver
        uint32_t HVFaultB : 1; //b2; Overtemperature or overcurrent on second high voltage output driver
        uint32_t HVFaultC : 1; //b3; Overtemperature or overcurrent on third high voltage output driver

    } __attribute__((__packed__));

    CGraphFSMHardwareStatusRegister() { all = 0; }

    //~ void formatf() const { ::formatf("CGraphFSMHardwareStatusRegister: Sample: %+10.0lf ", (double)Sample); ::formatf("(0x%.8lX", (uint32_t)(all >> 32));  ::formatf("%.8lX)", (uint32_t)(all)); ::formatf(", NumAccums: %lu ", (uint32_t)NumAccums); ::formatf("(0x%lX)", (uint32_t)NumAccums); }

} __attribute__((__packed__));

union CGraphFSMUartStatusRegister
{
    uint32_t all;
    struct 
    {
        uint32_t Uart2RxFifoEmpty : 1;
        uint32_t Uart2RxFifoFull : 1;
        uint32_t Uart2TxFifoEmpty : 1;
        uint32_t Uart2TxFifoFull : 1;
		uint32_t reserved1 : 4;
		uint32_t Uart2RxFifoCount : 8;
		uint32_t Uart2TxFifoCount : 8;
		uint32_t Uart2RxFifoCountHi : 2;
		uint32_t Uart2TxFifoCountHi : 2;
		uint32_t reserved2 : 4;

    } __attribute__((__packed__));

    CGraphFSMUartStatusRegister() { all = 0; }

    //~ void formatf() const { ::formatf("CGraphFSMUartStatusRegister: RxE:%c, RxF:%c, TxE:%c, TxF:%c, RxC:%u, TxC:%u", Uart2RxFifoEmpty?'Y':'N', Uart2RxFifoFull?'Y':'N', Uart2TxFifoEmpty?'Y':'N', Uart2TxFifoFull?'Y':'N', Uart2RxFifoCount + (Uart2RxFifoCountHi << 8), Uart2TxFifoCount + (Uart2TxFifoCountHi << 8)); }
	void formatf() const { ::formatf("CGraphFSMUartStatusRegister: RxE:%c, RxF:%c, TxE:%c, TxF:%c, RxC:%u, TxC:%u", Uart2RxFifoEmpty?'Y':'N', Uart2RxFifoFull?'Y':'N', Uart2TxFifoEmpty?'Y':'N', Uart2TxFifoFull?'Y':'N', Uart2RxFifoCount, Uart2TxFifoCount); }

} __attribute__((__packed__));

struct CGraphFSMHardwareInterface
{
    uint32_t DeviceSerialNumber; //ro; FPGA manufacturer hardcoded device UUID
    uint32_t FpgaFirmwareBuildNumber; //ro; Auto-incremented firmware UUID
    uint32_t UnixSeconds; //rw; equivalent to time_t for 32b systems; low order bits of time_t on 64b systems; write to set/initialize FPGA clock
    uint32_t IdealTicksPerSecond; //ro; Target clock speed of FPGA device, approx 100M; likely 14.7456M * 7 = 103,219,200.
    uint32_t ActualTicksLastSecond; //ro; Count of clock ticks for entire last second; equal to IdealTicksPerSecond unless clock was set or GPS PPS signal is present
	uint32_t ClockTicksThisSecondAddr; //ro Running count of clock ticks since the start of the current second
    uint32_t ClockSteeringDacSetpoint; //rw; 
    uint32_t DacASetpoint; //rw; First D/A; Zero = zero travel, DacFullScale = full scale travel
    uint32_t DacBSetpoint; //rw; Second D/A; Zero = zero travel, DacFullScale = full scale travel
    uint32_t DacCSetpoint; //rw; Third D/A; Zero = zero travel, DacFullScale = full scale travel
    AdcAccumulator AdcAAccumulator; //rw; First A/D; read or write any value to clear & reset accumulator
    AdcAccumulator AdcBAccumulator; //rw; Second A/D; read or write any value to clear & reset accumulator
    AdcAccumulator AdcCAccumulator; //rw; Third A/D; read or write any value to clear & reset accumulator
    AdcFifo AdcAFifo; //rw; First A/D; read of first byte of this structure latches entire structure on bus and removes one sample from fifo; write of any value clears fifo
    AdcFifo AdcBFifo; //rw; Second A/D; read of first byte of this structure latches entire structure on bus and removes one sample from fifo; write of any value clears fifo
    AdcFifo AdcCFifo; //rw; Third A/D; read of first byte of this structure latches entire structure on bus and removes one sample from fifo; write of any value clears fifo
    CGraphFSMHardwareControlRegister ControlRegister; //rw; see definition above
    CGraphFSMHardwareStatusRegister StatusRegister; //ro; see definition above
    int32_t PPSRtcPhaseComparator; //ro;
    int32_t PPSAdcPhaseComparator; //ro;
	AdcAccumulator MonitorAdcAccumulator; //ro; Monitor A/D samples for channel specififed in MonitorAdcReadChannel
	uint32_t MonitorAdcReadChannel; //rw; which channel to read for MonitorA/D
	uint32_t UartFifo2; //rw; send or read bytes from uart(s)
	CGraphFSMUartStatusRegister UartStatusRegister2; //ro; what state are the uart(s) in?
	uint32_t UartFifo1; //rw; send or read bytes from uart(s)
	CGraphFSMUartStatusRegister UartStatusRegister1; //ro; what state are the uart(s) in?
	uint32_t UartFifo0; //rw; send or read bytes from uart(s)
	CGraphFSMUartStatusRegister UartStatusRegister0; //ro; what state are the uart(s) in?
	uint8_t BaudDivider0; //rw; clock divider for the first serial port
	uint8_t BaudDivider1;
	uint8_t BaudDivider2;
	uint8_t BaudDivider3;
	
    static const uint32_t DacFullScale; //2^20 - 1
    static const double DacDriverFullScaleOutputVoltage; //150 Volts, don't get your fingers near this thing!
    static const double PZTDriverFullScaleOutputTravel; //Meters; note our granularity is this / DacFullScale which is approx 10pm

    //~ void formatf() const { ::formatf("CGraphFSMHardwareInterface: Sample: %+10.0lf ", (double)Sample); ::formatf("(0x%.8lX", (uint32_t)(all >> 32));  ::formatf("%.8lX)", (uint32_t)(all)); ::formatf(", NumAccums: %lu ", (uint32_t)NumAccums); ::formatf("(0x%lX)", (uint32_t)NumAccums); }

} __attribute__((__packed__));

class CGraphFSMProtoHardwareMmapper
{
public:

    static const off_t FpgaMmapAdress;
    static const off_t FpgaMmapMask;
    static const char FpgaBusEmulationPathName[];

    //~ int FpgaHandle;
    //~ void* FpgaBus;

    //~ CGraphFSMHardwareMmapper(const bool OpenOnConstruct = false) :

    //~ FpgaHandle(0),
    //~ FpgaBus(MAP_FAILED)//,

    //~ { if (OpenOnConstruct) { open(); } }

    //~ ~CGraphFSMHardwareMmapper() { close(); }

    static int open(int& FpgaHandle, CGraphFSMHardwareInterface*& FpgaBus);
    static int close(int& FpgaHandle, CGraphFSMHardwareInterface*& FpgaBus);
    static int read(const CGraphFSMHardwareInterface* FpgaBus, const size_t Address, void* Buffer, const size_t Len);
    static int write(CGraphFSMHardwareInterface* FpgaBus, const size_t Address, const void* Buffer, const size_t Len);
};

//EOF

/// \file
/// $Revision: $

#pragma once
#include <stdint.h>
#include <sys/types.h>

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

union CGraphFWHardwareControlRegister
{
    uint16_t all;
    struct 
    {
        uint16_t PosLedsEnA : 1; //b0; rw turn on A leds
        uint16_t PosLedsEnB : 1; //b1; rw turn on B leds
        uint16_t MotorEnable : 1; //b2; rw turn on motor
		uint16_t ResetSteps : 1; //b3; rw reset all step counters
        uint16_t MotorAPlus : 1; //b4; ro current state of motor control signal
        uint16_t MotorAMinus : 1; //b5; ro current state of motor control signal
        uint16_t MotorBPlus : 1; //b6; ro current state of motor control signal
        uint16_t MotorBMinus : 1; //b7; ro current state of motor control signal

    } __attribute__((__packed__));

    CGraphFWHardwareControlRegister() { all = 0; }

    void printf() const 
	{ 
		::printf("CGraphFWHardwareControlRegister: All: %.4X ", all); 
		::printf(", PosLedsEnA: %u ", (unsigned)PosLedsEnA);
		::printf(", PosLedsEnB: %u ", (unsigned)PosLedsEnB);
		::printf(", MotorEnable: %u ", (unsigned)MotorEnable);
		::printf(", ResetSteps: %u ", (unsigned)ResetSteps);
		::printf(", MotorAPlus: %u ", (unsigned)MotorAPlus);
		::printf(", MotorAMinus: %u ", (unsigned)MotorAMinus);
		::printf(", MotorBPlus: %u ", (unsigned)MotorBPlus);
		::printf(", MotorBMinus: %u ", (unsigned)MotorBMinus);
	}

} __attribute__((__packed__));

union CGraphFWMotorControlStatusRegister
{
    uint32_t all;
    struct 
    {
        uint16_t SeekStep; //rw; move the motor to here
        uint16_t CurrentStep; //ro; where is motor now (note: if <> SeekStep, motor is probably moving right now, unless ((CGraphFWHardwareControlRegister::MotorEnable == 0) || (CGraphFWHardwareControlRegister::ResetSteps == 1)) )
        
    } __attribute__((__packed__));

    CGraphFWMotorControlStatusRegister() { all = 0; }

    void printf() const { ::printf("CGraphFWMotorControlStatusRegister: All: %.8lX ", (unsigned long)all); ::printf(", SeekStep: %u ", SeekStep);  ::printf(", CurrentStep: %u ", CurrentStep); }

} __attribute__((__packed__));

union CGraphFWPositionSenseRegister
{
    uint16_t all;
    struct 
    {
        uint16_t PosSenseHomeA : 1; //b0; ro
        uint16_t PosSenseBit0A : 1; //b1; ro
        uint16_t PosSenseBit1A : 1; //b2; ro
		uint16_t PosSenseBit2A : 1; //b3; ro
        uint16_t PosSenseHomeB : 1; //b4; ro
        uint16_t PosSenseBit0B : 1; //b5; ro
        uint16_t PosSenseBit1B : 1; //b6; ro
        uint16_t PosSenseBit2B : 1; //b7; ro
		uint16_t PosSenseA : 4; //b8-11; ro
		uint16_t PosSenseB : 4; //b12-15; ro

    } __attribute__((__packed__));

    CGraphFWPositionSenseRegister() { all = 0; }

	void printf() const 
	{ 
		::printf("CGraphFWPositionSenseRegister: All: %.4X ", all); 
		::printf(", PosSenseHomeA: %u ", (unsigned)PosSenseHomeA);
		::printf(", PosSenseBit0A: %u ", (unsigned)PosSenseBit0A);
		::printf(", PosSenseBit1A: %u ", (unsigned)PosSenseBit1A);
		::printf(", PosSenseBit2A: %u ", (unsigned)PosSenseBit2A);
		::printf(", PosSenseHomeB: %u ", (unsigned)PosSenseHomeB);
		::printf(", PosSenseBit0B: %u ", (unsigned)PosSenseBit0B);
		::printf(", PosSenseBit1B: %u ", (unsigned)PosSenseBit1B);
		::printf(", PosSenseBit2B: %u ", (unsigned)PosSenseBit2B);
		::printf(", PosSenseA: 0x%.1X ", (unsigned)PosSenseA);
		::printf(", PosSenseA: 0x%.1X ", (unsigned)PosSenseB);
	}

} __attribute__((__packed__));

union CGraphFWUartStatusRegister
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

    CGraphFWUartStatusRegister() { all = 0; }

    //~ void printf() const { ::printf("CGraphFWUartStatusRegister: RxE:%c, RxF:%c, TxE:%c, TxF:%c, RxC:%u, TxC:%u", Uart2RxFifoEmpty?'Y':'N', Uart2RxFifoFull?'Y':'N', Uart2TxFifoEmpty?'Y':'N', Uart2TxFifoFull?'Y':'N', Uart2RxFifoCount + (Uart2RxFifoCountHi << 8), Uart2TxFifoCount + (Uart2TxFifoCountHi << 8)); }
	void printf() const { ::printf("CGraphFWUartStatusRegister: RxE:%c, RxF:%c, TxE:%c, TxF:%c, RxC:%lu, TxC:%lu", Uart2RxFifoEmpty?'Y':'N', Uart2RxFifoFull?'Y':'N', Uart2TxFifoEmpty?'Y':'N', Uart2TxFifoFull?'Y':'N', Uart2RxFifoCount, Uart2TxFifoCount); }

} __attribute__((__packed__));

struct CGraphFWHardwareInterface
{
    uint32_t DeviceSerialNumber; //ro; FPGA manufacturer hardcoded device UUID
    uint32_t FpgaFirmwareBuildNumber; //ro; Auto-incremented firmware UUID
    uint32_t UnixSeconds; //rw; equivalent to time_t for 32b systems; low order bits of time_t on 64b systems; write to set/initialize FPGA clock
    uint32_t IdealTicksPerSecond; //ro; Target clock speed of FPGA device, approx 100M; likely 14.7456M * 7 = 103,219,200.
    uint32_t ActualTicksLastSecond; //ro; Count of clock ticks for entire last second; equal to IdealTicksPerSecond unless clock was set or GPS PPS signal is present
	uint32_t ClockTicksThisSecondAddr; //ro Running count of clock ticks since the start of the current second
    uint32_t ClockSteeringDacSetpoint; //rw; 
    uint32_t reserved0; //rw; First D/A; Zero = zero travel, DacFullScale = full scale travel
    CGraphFWMotorControlStatusRegister MotorControlStatus; //rw; motor settings
	uint16_t unused1;
    CGraphFWPositionSenseRegister PositionSensors; //ro; state of all the position sensor readouts
	uint16_t unused2;
    uint64_t reserved1;
    uint64_t reserved2;
    uint64_t reserved3;
    uint64_t reserved4;
    uint64_t reserved5;
    uint64_t reserved6;
    CGraphFWHardwareControlRegister ControlRegister; //rw; see definition above
    uint32_t reserved7;
    int32_t PPSRtcPhaseComparator; //ro;
    int32_t PPSAdcPhaseComparator; //ro;
	AdcAccumulator MonitorAdcAccumulator; //ro; Monitor A/D samples for channel specififed in MonitorAdcReadChannel
	uint32_t MonitorAdcReadChannel; //rw; which channel to read for MonitorA/D
	uint32_t UartFifo2; //rw; send or read bytes from uart(s)
	CGraphFWUartStatusRegister UartStatusRegister2; //ro; what state are the uart(s) in?
	uint32_t UartFifo1; //rw; send or read bytes from uart(s)
	CGraphFWUartStatusRegister UartStatusRegister1; //ro; what state are the uart(s) in?
	uint32_t UartFifo0; //rw; send or read bytes from uart(s)
	CGraphFWUartStatusRegister UartStatusRegister0; //ro; what state are the uart(s) in?
	uint8_t BaudDivider0; //rw; clock divider for the first serial port
	uint8_t BaudDivider1;
	uint8_t BaudDivider2;
	uint8_t BaudDivider3;
	uint32_t reserved8;	
	uint16_t PosDetHomeAOnStep; //ro; the step at which this signal toggled
	uint16_t PosDetHomeAOffStep; //ro; the step at which this signal toggled
	uint16_t PosDetA0OnStep; //ro; the step at which this signal toggled
	uint16_t PosDetA0OffStep; //ro; the step at which this signal toggled
	uint16_t PosDetA1OnStep; //ro; the step at which this signal toggled
	uint16_t PosDetA1OffStep; //ro; the step at which this signal toggled
	uint16_t PosDetA2OnStep; //ro; the step at which this signal toggled
	uint16_t PosDetA2OffStep; //ro; the step at which this signal toggled	
	uint16_t PosDetHomeBOnStep; //ro; the step at which this signal toggled
	uint16_t PosDetHomeBOffStep; //ro; the step at which this signal toggled
	uint16_t PosDetB0OnStep; //ro; the step at which this signal toggled
	uint16_t PosDetB0OffStep; //ro; the step at which this signal toggled
	uint16_t PosDetB1OnStep; //ro; the step at which this signal toggled
	uint16_t PosDetB1OffStep; //ro; the step at which this signal toggled
	uint16_t PosDetB2OnStep; //ro; the step at which this signal toggled
	uint16_t PosDetB2OffStep; //ro; the step at which this signal toggled	
	uint16_t PosDet0AOnStep; //ro; the step at which this signal toggled
	uint16_t PosDet0AOffStep; //ro; the step at which this signal toggled
	uint16_t PosDet1AOnStep; //ro; the step at which this signal toggled
	uint16_t PosDet1AOffStep; //ro; the step at which this signal toggled
	uint16_t PosDet2AOnStep; //ro; the step at which this signal toggled
	uint16_t PosDet2AOffStep; //ro; the step at which this signal toggled
	uint16_t PosDet3AOnStep; //ro; the step at which this signal toggled
	uint16_t PosDet3AOffStep; //ro; the step at which this signal toggled
	uint16_t PosDet4AOnStep; //ro; the step at which this signal toggled
	uint16_t PosDet4AOffStep; //ro; the step at which this signal toggled
	uint16_t PosDet5AOnStep; //ro; the step at which this signal toggled
	uint16_t PosDet5AOffStep; //ro; the step at which this signal toggled
	uint16_t PosDet6AOnStep; //ro; the step at which this signal toggled
	uint16_t PosDet6AOffStep; //ro; the step at which this signal toggled
	uint16_t PosDet7AOnStep; //ro; the step at which this signal toggled
	uint16_t PosDet7AOffStep; //ro; the step at which this signal toggled	
	uint16_t PosDet0BOnStep; //ro; the step at which this signal toggled
	uint16_t PosDet0BOffStep; //ro; the step at which this signal toggled
	uint16_t PosDet1BOnStep; //ro; the step at which this signal toggled
	uint16_t PosDet1BOffStep; //ro; the step at which this signal toggled
	uint16_t PosDet2BOnStep; //ro; the step at which this signal toggled
	uint16_t PosDet2BOffStep; //ro; the step at which this signal toggled
	uint16_t PosDet3BOnStep; //ro; the step at which this signal toggled
	uint16_t PosDet3BOffStep; //ro; the step at which this signal toggled
	uint16_t PosDet4BOnStep; //ro; the step at which this signal toggled
	uint16_t PosDet4BOffStep; //ro; the step at which this signal toggled
	uint16_t PosDet5BOnStep; //ro; the step at which this signal toggled
	uint16_t PosDet5BOffStep; //ro; the step at which this signal toggled
	uint16_t PosDet6BOnStep; //ro; the step at which this signal toggled
	uint16_t PosDet6BOffStep; //ro; the step at which this signal toggled
	uint16_t PosDet7BOnStep; //ro; the step at which this signal toggled
	uint16_t PosDet7BOffStep; //ro; the step at which this signal toggled	
	
    //~ static const uint32_t DacFullScale; //2^20 - 1
    //~ static const double DacDriverFullScaleOutputVoltage; //150 Volts, don't get your fingers near this thing!
    //~ static const double PZTDriverFullScaleOutputTravel; //Meters; note our granularity is this / DacFullScale which is approx 10pm

    //~ void printf() const { ::printf("CGraphFWHardwareInterface: Sample: %+10.0lf ", (double)Sample); ::printf("(0x%.8lX", (uint32_t)(all >> 32));  ::printf("%.8lX)", (uint32_t)(all)); ::printf(", NumAccums: %lu ", (uint32_t)NumAccums); ::printf("(0x%lX)", (uint32_t)NumAccums); }

} __attribute__((__packed__));

extern CGraphFWHardwareInterface* FW;

//EOF

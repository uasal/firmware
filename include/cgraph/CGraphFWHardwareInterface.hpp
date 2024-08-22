/// \file
/// $Revision: $

#pragma once
#include <stdint.h>
#include <sys/types.h>
#include <algorithm>

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

union CGraphFWHardwareControlRegister
{
    uint32_t all;
    struct 
    {
        uint32_t PosLedsEnA : 1; //b0; rw turn on A leds
        uint32_t PosLedsEnB : 1; //b1; rw turn on B leds
        uint32_t MotorEnable : 1; //b2; rw turn on motor
		uint32_t ResetSteps : 1; //b3; rw reset all step counters
        uint32_t MotorAPlus : 1; //b4; ro current state of motor control signal
        uint32_t MotorAMinus : 1; //b5; ro current state of motor control signal
        uint32_t MotorBPlus : 1; //b6; ro current state of motor control signal
        uint32_t MotorBMinus : 1; //b7; ro current state of motor control signal
		
		uint32_t Fault1V : 1; //b8; r: current fault state; w: reset fault
        uint32_t Fault3V : 1; //b9; r: current fault state; w: reset fault
        uint32_t Fault5V : 1; //b10; r: current fault state; w: reset fault
		uint32_t PowernEn5V : 1; //b11; rw turn +5V on/off
        uint32_t PowerCycd : 1; //b12; r: current fault state; w: reset fault
        uint32_t LedR : 1; //b13; rw: led state
        uint32_t LedG : 1; //b14; rw: led state
        uint32_t LedB : 1; //b15; rw: led state
		
		//note: earlier versions of f/w are 16b and these high bits may be inacessible...
		
		uint32_t Uart0OE : 1; //b16; rw: jumper state
		uint32_t Uart1OE : 1; //b17; rw: jumper state
		uint32_t Uart2OE : 1; //b18; rw: jumper state
		uint32_t Uart3OE : 1; //b19; rw: jumper state
		
		uint32_t Ux1SelJmp : 1; //b20; rw: jumper state
		uint32_t Ux2SelJmp : 1; //b21; rw: jumper state

    } __attribute__((__packed__));

    CGraphFWHardwareControlRegister() { all = 0; }

    void formatf() const 
	{ 
		::formatf("CGraphFWHardwareControlRegister: All: %.4X ", all); 
		::formatf(", PosLedsEnA: %u ", (unsigned)PosLedsEnA);
		::formatf(", PosLedsEnB: %u ", (unsigned)PosLedsEnB);
		::formatf(", MotorEnable: %u ", (unsigned)MotorEnable);
		::formatf(", ResetSteps: %u ", (unsigned)ResetSteps);
		::formatf(", MotorAPlus: %u ", (unsigned)MotorAPlus);
		::formatf(", MotorAMinus: %u ", (unsigned)MotorAMinus);
		::formatf(", MotorBPlus: %u ", (unsigned)MotorBPlus);
		::formatf(", MotorBMinus: %u ", (unsigned)MotorBMinus);
		
		::formatf(", Fault1V: %u ", (unsigned)Fault1V);
		::formatf(", Fault3V: %u ", (unsigned)Fault3V);
		::formatf(", Fault5V: %u ", (unsigned)Fault5V);
		::formatf(", PowernEn5V: %u ", (unsigned)PowernEn5V);
		::formatf(", PowerCycd: %u ", (unsigned)PowerCycd);
		::formatf(", LedR: %u ", (unsigned)LedR);
		::formatf(", LedG: %u ", (unsigned)LedG);
		::formatf(", LedB: %u ", (unsigned)LedB);
		
		::formatf(", Uart0OE: %u ", (unsigned)Uart0OE);
		::formatf(", Uart1OE: %u ", (unsigned)Uart1OE);
		::formatf(", Uart2OE: %u ", (unsigned)Uart2OE);
		::formatf(", Uart3OE: %u ", (unsigned)Uart3OE);
		::formatf(", Ux1SelJmp: %u ", (unsigned)Ux1SelJmp);
		::formatf(", Ux2SelJmp: %u ", (unsigned)Ux2SelJmp);
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

    void formatf() const { ::formatf("CGraphFWMotorControlStatusRegister: All: %.8lX ", (unsigned long)all); ::formatf(", SeekStep: %u ", SeekStep);  ::formatf(", CurrentStep: %u ", CurrentStep); }

} __attribute__((__packed__));

union CGraphFWPositionSenseRegister
{
    uint32_t all;
    struct 
    {
        uint32_t PosSenseHomeA : 1; //b0; ro
        uint32_t PosSenseBit0A : 1; //b1; ro
        uint32_t PosSenseBit1A : 1; //b2; ro
		uint32_t PosSenseBit2A : 1; //b3; ro
        uint32_t PosSenseHomeB : 1; //b4; ro
        uint32_t PosSenseBit0B : 1; //b5; ro
        uint32_t PosSenseBit1B : 1; //b6; ro
        uint32_t PosSenseBit2B : 1; //b7; ro
		uint32_t PosSenseA : 4; //b8-11; ro
		uint32_t PosSenseB : 4; //b12-15; ro

    } __attribute__((__packed__));

    CGraphFWPositionSenseRegister() { all = 0; }

	void formatf() const 
	{ 
		::formatf("CGraphFWPositionSenseRegister: All: %.4X ", all); 
		::formatf(", PosSenseHomeA: %u ", (unsigned)PosSenseHomeA);
		::formatf(", PosSenseBit0A: %u ", (unsigned)PosSenseBit0A);
		::formatf(", PosSenseBit1A: %u ", (unsigned)PosSenseBit1A);
		::formatf(", PosSenseBit2A: %u ", (unsigned)PosSenseBit2A);
		::formatf(", PosSenseHomeB: %u ", (unsigned)PosSenseHomeB);
		::formatf(", PosSenseBit0B: %u ", (unsigned)PosSenseBit0B);
		::formatf(", PosSenseBit1B: %u ", (unsigned)PosSenseBit1B);
		::formatf(", PosSenseBit2B: %u ", (unsigned)PosSenseBit2B);
		::formatf(", PosSenseA: 0x%.1X ", (unsigned)PosSenseA);
		::formatf(", PosSenseA: 0x%.1X ", (unsigned)PosSenseB);
	}

} __attribute__((__packed__));

union CGraphFWPositionStepRegister
{
    uint64_t all;
    struct 
    {
        uint32_t OnStep;// : 16;
        uint32_t OffStep;// : 16; //Word offset reliably crashes uC
        
    } __attribute__((__packed__));

    CGraphFWPositionStepRegister() { all = 0; }
	
	int32_t MidStep() const { return(std::min(OnStep, OffStep) + (abs((int32_t)OnStep - (int32_t)OffStep) / 2 )); }

	void formatf() const 
	{ 
		::formatf("StepRegister: All: %.4X ", all); 
		::formatf(", OnStep: %u ", (unsigned)OnStep);
		::formatf(", OffStep: %u ", (unsigned)OffStep);
		::formatf(", MidStep: %d ", (int)MidStep());
	}

} __attribute__((__packed__));

union CGraphFWBaudDividers
{
    uint32_t all;
    struct 
    {
        uint32_t Divider0 : 8;
		uint32_t Divider1 : 8;  //8b offsets reliably crash uC
		uint32_t Divider2 : 8;
		uint32_t Divider3 : 8;
        
    } __attribute__((__packed__));

    CGraphFWBaudDividers() { all = 0; }
	
	void formatf() const 
	{ 
		::formatf("CGraphFWBaudDividers: All: %.4X ", all); 
		::formatf(", Divider0: %u ", (unsigned)Divider0);
		::formatf(", Divider1: %u ", (unsigned)Divider1);
		::formatf(", Divider2: %u ", (unsigned)Divider2);
		::formatf(", Divider3: %u ", (unsigned)Divider3);
	}

} __attribute__((__packed__));

union CGraphFWUartStatusRegister
{
    uint32_t all;
    struct 
    {
        uint32_t RxFifoEmpty : 1;
        uint32_t RxFifoFull : 1;
        uint32_t TxFifoEmpty : 1;
        uint32_t TxFifoFull : 1;
		uint32_t reserved1 : 4;
		uint32_t RxFifoCount : 10;
		uint32_t TxFifoCount : 10;
		uint32_t reserved2 : 4;

    } __attribute__((__packed__));

    CGraphFWUartStatusRegister() { all = 0; }

    //~ void formatf() const { ::formatf("CGraphFWUartStatusRegister: RxE:%c, RxF:%c, TxE:%c, TxF:%c, RxC:%u, TxC:%u", RxFifoEmpty?'Y':'N', RxFifoFull?'Y':'N', TxFifoEmpty?'Y':'N', TxFifoFull?'Y':'N', RxFifoCount + (RxFifoCountHi << 8), TxFifoCount + (TxFifoCountHi << 8)); }
	void formatf() const { ::formatf("CGraphFWUartStatusRegister: RxE:%c, RxF:%c, TxE:%c, TxF:%c, RxC:%lu, TxC:%lu", RxFifoEmpty?'Y':'N', RxFifoFull?'Y':'N', TxFifoEmpty?'Y':'N', TxFifoFull?'Y':'N', RxFifoCount, TxFifoCount); }

} __attribute__((__packed__));

union CGraphFWMonitorAdcCommandStatusRegister
{
    uint32_t all;
    struct 
    {
        uint32_t FrameEnable : 1; //1=nCs asserted (0), 0=nCs clear (1)
        uint32_t TransactionComplete : 1; //Is the bus busy?
        uint32_t nDrdy : 1; //Samples ready?
        
    } __attribute__((__packed__));

    CGraphFWMonitorAdcCommandStatusRegister() { all = 0; }

    void formatf() const { ::formatf("CGraphFWMonitorAdcCommandStatusRegister: FrameEnable:%c, TransactionComplete:%c, nDrdy:%c", FrameEnable?'1':'0', TransactionComplete?'1':'0', nDrdy?'1':'0'); }

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
	CGraphFWPositionSenseRegister PositionSensors; //ro; state of all the position sensor readouts
    uint64_t reserved1;
    uint64_t reserved2;
    uint64_t reserved3;
    uint64_t reserved4;
    uint32_t UartFifo3; //rw; send or read bytes from uart(s)
	CGraphFWUartStatusRegister UartStatusRegister3; //ro; what state are the uart(s) in?
	uint64_t reserved5;
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
	CGraphFWBaudDividers BaudDividers; //rw; clock dividers for the serial ports
	uint32_t reserved8;	
	CGraphFWPositionStepRegister PosDetHomeA; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDetA0; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDetA1; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDetA2; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDetHomeB; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDetB0; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDetB1; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDetB2; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDet0A; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDet1A; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDet2A; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDet3A; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDet4A; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDet5A; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDet6A; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDet7A; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDet0B; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDet1B; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDet2B; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDet3B; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDet4B; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDet5B; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDet6B; //ro; the step at which this signal toggled
	CGraphFWPositionStepRegister PosDet7B; //ro; the step at which this signal toggled
	uint32_t UartFifoUsb; //rw; send or read bytes from uart(s)
	CGraphFWUartStatusRegister UartStatusRegisterUsb; //ro; what state are the uart(s) in?
	uint32_t MonitorAdcSpiTransactionRegister;
	CGraphFWMonitorAdcCommandStatusRegister MonitorAdcSpiCommandStatusRegister;
	uint32_t UartFifoGps; //rw; send or read bytes from uart(s)
	CGraphFWUartStatusRegister UartStatusRegisterGps; //ro; what state are the uart(s) in?
	
    //~ static const uint32_t DacFullScale; //2^20 - 1
    //~ static const double DacDriverFullScaleOutputVoltage; //150 Volts, don't get your fingers near this thing!
    //~ static const double PZTDriverFullScaleOutputTravel; //Meters; note our granularity is this / DacFullScale which is approx 10pm

    //~ void formatf() const { ::formatf("CGraphFWHardwareInterface: Sample: %+10.0lf ", (double)Sample); ::formatf("(0x%.8lX", (uint32_t)(all >> 32));  ::formatf("%.8lX)", (uint32_t)(all)); ::formatf(", NumAccums: %lu ", (uint32_t)NumAccums); ::formatf("(0x%lX)", (uint32_t)NumAccums); }

} __attribute__((__packed__));

extern CGraphFWHardwareInterface* FW;

//EOF

//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
//

#pragma once
#include <stdint.h>

#include "uart/UartStatusRegister.hpp"

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

union CGraphBaudDividers
{
    uint32_t all;
    struct 
    {
        uint32_t Divider0 : 8;
		uint32_t Divider1 : 8;  //8b offsets reliably crash uC
		uint32_t Divider2 : 8;
		uint32_t Divider3 : 8;
        
    } __attribute__((__packed__));

    CGraphBaudDividers() { all = 0; }
	
	void formatf() const 
	{ 
		::formatf("CGraphBaudDividers: All: %.4X ", all); 
		::formatf(", Divider0: %u ", (unsigned)Divider0);
		::formatf(", Divider1: %u ", (unsigned)Divider1);
		::formatf(", Divider2: %u ", (unsigned)Divider2);
		::formatf(", Divider3: %u ", (unsigned)Divider3);
	}

} __attribute__((__packed__));

union CGraphMonitorAdcCommandStatusRegister
{
    uint32_t all;
    struct 
    {
        uint32_t FrameEnable : 1; //1=nCs asserted (0), 0=nCs clear (1)
        uint32_t TransactionComplete : 1; //Is the bus busy?
        uint32_t nDrdy : 1; //Samples ready?
        
    } __attribute__((__packed__));

    CGraphMonitorAdcCommandStatusRegister() { all = 0; }

    void formatf() const { ::formatf("CGraphMonitorAdcCommandStatusRegister: FrameEnable:%c, TransactionComplete:%c, nDrdy:%c", FrameEnable?'1':'0', TransactionComplete?'1':'0', nDrdy?'1':'0'); }

} __attribute__((__packed__));

union CGraphCrcCurrentAddr
{
    uint32_t all;
    struct 
    {
        uint32_t CurrentAddr : 31;
		uint32_t CrcComplete : 1;
        
    } __attribute__((__packed__));

    CGraphCrcCurrentAddr() { all = 0; }
	
	void formatf() const //note: using this function causes some major fuckery with the volatile qulifier in many places...
	{ 
		::formatf("CGraphCrcCurrentAddr: All: %.4X ", all); 
		::formatf(", CurrentAddr: %u ", (unsigned)CurrentAddr);
		::formatf(", CrcComplete: %c ", CrcComplete?'Y':'N');
	}

} __attribute__((__packed__));

struct FpgaRingBufferCrcer
{
	FpgaRingBufferCrcer(volatile uint32_t* const crcstartaddr, volatile uint32_t* const crcendaddr, volatile CGraphCrcCurrentAddr* const crccurentaddr, volatile uint32_t* const crcresult) :
		CrcStartAddr(crcstartaddr),
		CrcEndAddr(crcendaddr),
		CrcCurrentAddr(crccurentaddr),
		CrcResult(crcresult)
	{ }
	
	public:
		
		volatile uint32_t* const CrcStartAddr;
		volatile uint32_t* const CrcEndAddr;
		volatile CGraphCrcCurrentAddr* const CrcCurrentAddr;
		volatile uint32_t* const CrcResult;
};

//EOF

//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
//

#pragma once

#include <stdint.h>
#include <string.h>
#include <stdio.h>
//~ #include <setjmp.h>
//~ #include <signal.h>
//~ #include <syscall.h>
//~ #include <execinfo.h>
//~ #include <ucontext.h>
//~ #include <sys/resource.h>

//DEBUG!
//~ #include "dbg/memwatch.h"
//~ #include <mcheck.h>

#include "Delay.h"

#include "uart/IUart.h"

#include "uart/UartStatusRegister.hpp"

class uart_pinout_fpga : public IUart
{
	
private:

	bool monitor = false;
	const UartStatusRegister* StatusRegister;
	const uint32_t* ReadRequestRegister;
	const uint32_t* ReadDataRegister;
	uint32_t* WriteDataRegister;
	const char MonitorPrefaceChar;
	
public:

	uart_pinout_fpga(const UartStatusRegister* statusregister, const uint32_t* readrequestregister, const uint32_t* readdataregister, uint32_t* writedataregister, const char monitorprefacechar) : 
		IUart(),
		monitor(false),
		StatusRegister(statusregister),
		ReadRequestRegister(readrequestregister),
		ReadDataRegister(readdataregister),
		WriteDataRegister(writedataregister),
		MonitorPrefaceChar(monitorprefacechar)
	{ }
	
	virtual ~uart_pinout_fpga() { }

	virtual bool dataready() const override
	{
		if (NULL == StatusRegister) { return(false); }
		return(0 == StatusRegister->RxFifoEmpty);
	}

	virtual char getcqq() override
	{
		if ( (NULL == ReadRequestRegister) || (NULL == ReadDataRegister) ) { return(false); }
		volatile uint32_t c = 0;
		c = *ReadRequestRegister; //Initiate the read from the fifo (this sends back 0xBAADC0DE if you care to check)
		c = *ReadDataRegister;
		//if (monitor) { formatf("%c%.2x", MonitorPrefaceChar, c); }
		return((char)(c));
	}

	virtual char putcqq(char c) override
	{
		if (NULL != WriteDataRegister) { *WriteDataRegister = c; }
		return(c);
	}
	
	size_t depth() const
	{
		if (NULL == StatusRegister) { return(0); }
		return(StatusRegister->RxFifoCount);
	}

	virtual void flushoutput() override { } // if (FW) { FW->UartTxStatusRegister = 0; } //Need to make tx & rx status registers seperate...
	virtual void purgeinput() override { } // if (FW) { FW->UartRxStatusRegister = 0; }
	virtual bool isopen() const override { return(true); }
	
	void Monitor(const bool m) { monitor = m; }
	bool Monitor() const { return(monitor); }
	
	
};

//EOF

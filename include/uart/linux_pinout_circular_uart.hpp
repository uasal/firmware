/// \file
/// $Source: /raincloud/src/projects/include/circular_buffer/linux_pinout_circular_uart.hpp,v $
/// $Revision: 1.9 $
/// $Date: 2009/11/14 00:20:04 $
/// $Author: steve $

#ifndef _linux_pinout_circular_uart_h
#define _linux_pinout_circular_uart_h
#pragma once

#include <stdio.h>   /* Standard input/output definitions */
#include <string.h>  /* String function definitions */

#include "eeprom/CircularFifo.hpp"

#include "format/formatf.h"

#include "IUart.h"

template<class BufferT, size_t RxBufferLen, size_t TxBufferLen> class linux_pinout_circular_uart : public IUart
{
public:

	linux_pinout_circular_uart() : IUart(), RxBuffer(), TxBuffer(), Silent(false) { }
	virtual ~linux_pinout_circular_uart() { }

	virtual int init(const uint32_t nc, const char* nc2) { return(IUartOK); }

	virtual void deinit() { }
	
	virtual bool dataready() const
	{
		return(0 != RxBuffer.depth());
	}

	virtual char getcqq()
	{
		BufferT c = 0;
		bool Popped = RxBuffer.pop(c);
		if (!Popped) { return((BufferT)(-1)); }
		return((char)c);
	}

	virtual char putcqq(char b)
	{
		BufferT c = (BufferT)b;
		bool pushed = TxBuffer.push(c);
		if (!pushed) { printf("\nlinux_pinout_circular_uart: !push()!"); }
		//~ else { printf("\nlinux_pinout_circular_uart: depth(%zu).", Buffer.depth()); }
		return(c);
	}
	
	virtual bool remotedataready() const
	{
		return(0 != TxBuffer.depth());
	}

	virtual char remotegetcqq()
	{
		BufferT c = 0;
		bool Popped = TxBuffer.pop(c);
		if (!Popped) { return((BufferT)(-1)); }
		return((char)c);
	}

	virtual char remoteputcqq(char b)
	{
		BufferT c = (BufferT)b;
		bool pushed = RxBuffer.push(c);
		if (!pushed) { printf("\nlinux_pinout_circular_uart: !remotepush()!"); }
		//~ else { printf("\nlinux_pinout_circular_uart: depth(%zu).", Buffer.depth()); }
		return(c);
	}
	
	virtual size_t depth() const
	{
		return(RxBuffer.depth());
	}

	virtual size_t remotedepth() const
	{
		return(TxBuffer.depth());
	}

	virtual void flushoutput() { TxBuffer.flush(); }
	virtual void purgeinput() { RxBuffer.flush(); }	
	virtual bool connected() { return(true); }	
	virtual bool isopen() const { return(true); }	
	void silent(const bool s) { Silent = s; }
	
	private:

		CircularFifo<BufferT, RxBufferLen> RxBuffer;
		CircularFifo<BufferT, TxBufferLen> TxBuffer;
		bool Silent;
};

#endif //linux_pinout_circular_uart_h

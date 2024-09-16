//
///           Copyright (c) by Franks Development, LLC
//
// This software is copyrighted by and is the sole property of Franks
// Development, LLC. All rights, title, ownership, or other interests
// in the software remain the property of Franks Development, LLC. This
// software may only be used in accordance with the corresponding
// license agreement.  Any unauthorized use, duplication, transmission,
// distribution, or disclosure of this software is expressly forbidden.
//
// This Copyright notice may not be removed or modified without prior
// written consent of Franks Development, LLC.
//
// Franks Development, LLC. reserves the right to modify this software
// without notice.
//
// Franks Development, LLC            support@franks-development.com
// 500 N. Bahamas Dr. #101           http://www.franks-development.com
// Tucson, AZ 85710
// USA
//
// Permission granted for perpetual non-exclusive end-use by the University of Arizona August 1, 2020
//


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

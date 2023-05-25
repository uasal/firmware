/// \file
/// $Source: /raincloud/src/projects/include/circular_buffer/linux_pinout_circular_buffer.hpp,v $
/// $Revision: 1.9 $
/// $Date: 2009/11/14 00:20:04 $
/// $Author: steve $

#ifndef _linux_pinout_circular_buffer_h
#define _linux_pinout_circular_buffer_h
#pragma once

#include <stdio.h>   /* Standard input/output definitions */
#include <string.h>  /* String function definitions */

#include "eeprom/CircularFifo.hpp"

#include "format/formatf.h"

#include "IUart.h"

template<class BufferT, size_t BufferLen> class linux_pinout_circular_buffer : public IUart
{
public:

	linux_pinout_circular_buffer() : IUart(), Silent(false) { }
	virtual ~linux_pinout_circular_buffer() { }

	virtual int init(const uint32_t nc, const char* nc2) { return(IUartOK); }

	virtual void deinit() { }
	
	virtual bool dataready() const
	{
		//~ if ((0 != Buffer.depth())) { printf("?"); } else { printf("~"); }
		//~ return(!(Buffer.wasEmpty()));
		return(0 != Buffer.depth());
	}

	virtual char getcqq()
	{
		BufferT c = 0;
		bool Popped = Buffer.pop(c);
		if (!Popped) { return((BufferT)(-1)); }
		return((char)c);
	}

	virtual char putcqq(char b)
	{
		BufferT c = (BufferT)b;
		bool pushed = Buffer.push(c);
		if (!pushed) { printf("\nlinux_pinout_circular_buffer: !push()!"); }
		//~ else { printf("\nlinux_pinout_circular_buffer: depth(%zu).", Buffer.depth()); }
		return(c);
	}
	
	virtual size_t depth() const
	{
		return(Buffer.depth());
	}

	virtual void flushoutput() { Buffer.flush(); }
	virtual void purgeinput() { Buffer.flush(); }	
	virtual bool connected() { return(true); }	
	virtual bool isopen() const { return(true); }	
	void silent(const bool s) { Silent = s; }
	
	private:

		CircularFifo<BufferT, BufferLen> Buffer;
		bool Silent;
};

#endif //linux_pinout_circular_buffer_h

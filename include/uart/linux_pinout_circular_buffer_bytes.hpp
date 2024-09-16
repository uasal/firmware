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


#ifndef _linux_pinout_circular_buffer_h
#define _linux_pinout_circular_buffer_h
#pragma once

#include <stdio.h>   /* Standard input/output definitions */
#include <string.h>  /* String function definitions */

#include "eeprom/CircularFifo.hpp"

#include "format/formatf.h"

#include "IUart.h"

class linux_pinout_circular_buffer : public IUart
{
public:

	virtual bool dataready() const
	{
		//~ if ((0 != Buffer.depth())) { printf("?"); } else { printf("~"); }
		return(!(Buffer.wasEmpty()));
		//~ return(0 != Buffer.depth());
	}

	virtual char getcqq()
	{
		uint8_t c = 0;
		bool Popped = Buffer.pop(c);
		if (!Popped) { return((uint8_t)(-1)); }
		return((char)c);
	}

	virtual char putcqq(char b)
	{
		uint8_t c = (uint8_t)b;
		bool pushed = Buffer.push(c);
		if (!pushed) { printf("\nlinux_pinout_circular_buffer: !push()!"); }
		//~ else { printf("\nlinux_pinout_circular_buffer: depth(%zu).", Buffer.depth()); }
		return(c);
	}
	
	virtual size_t depth() const
	{
		//~ return(Buffer.depth());
		return((size_t)(-1));
	}

	//~ virtual void flushoutput()
	//~ {
	//~ }
	
	//~ virtual void purgeinput()
	//~ {
	//~ }
	
	virtual bool connected() { return(true); }	
	virtual bool isopen() const { return(true); }	
	void silent(const bool s) { Silent = s; }
	
	linux_pinout_circular_buffer() : IUart(), Silent(false) { }
	virtual ~linux_pinout_circular_buffer() { deinit(); }

	virtual int init(const uint32_t nc, const char* nc2) { return(IUartOK); }

	virtual void deinit() { }
	
	private:

		CircularFifo<uint8_t, 32768> Buffer;
		bool Silent;
};

#endif //linux_pinout_circular_buffer_h

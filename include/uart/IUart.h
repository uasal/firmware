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

#pragma once

#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>

class IUart
{
public:
	IUart() { }
	virtual ~IUart() { }

	static const bool OddParity = true;
	static const bool NoParity = false;
	static const bool IUartOK = 0x00;
	static const bool UseRTSCTS = true;
	static const bool NoRTSCTS = false;


	//All the following pinout functions are very hardware & device dependant, so they are declared in another class to preserve the abstraction
	//virtual int init() { return(InitOK); } //note: this functiuon usually gets overloaded with different params, so it's no longer virtual anyway - probably not an issue, since it usually gets called from code with the full object, not just the base class.
	//~ virtual bool dataready() { printf("\nIUart::dataready() stub!\n"); return(false); }
	//~ virtual char getcqq() { printf("\nIUart::getcqq() stub!\n"); return('\0'); }
	//~ virtual char putcqq(char c) { printf("\nIUart::putcqq() stub!\n"); return('\0'); }
	//~ virtual void flushoutput() { printf("\nIUart::flushoutput() stub!\n"); }
	//~ virtual void purgeinput() { printf("\nIUart::purgeinput() stub!\n"); }
	//~ virtual bool isopen() { printf("\nIUart::isopen() stub!\n"); return(false); }
	virtual bool dataready() const = 0;
	virtual char getcqq() = 0;
	virtual char putcqq(char c) = 0;
	virtual void flushoutput() = 0;
	virtual void purgeinput() = 0;
	virtual bool isopen() const = 0;
	
	void puts(const char* s, const size_t len)
	{
		for (size_t i = 0; i < len; i++)
		{
			if ('\0' == s[i]) { break; }
			
			putcqq(s[i]);
		}
	}
};

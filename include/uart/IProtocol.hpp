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
#ifndef _IProtocol_H_
#define _IProtocol_H_

#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>

class IProtocol
{
public:
	IProtocol() { }
	virtual ~IProtocol() { }

	virtual bool dataready() const = 0;
	virtual char getcqq() = 0;
	virtual char putcqq(char c) = 0;
	virtual void flushoutput() = 0;
	virtual void purgeinput() = 0;
	virtual bool isopen() const = 0;
};

#endif // _IProtocol_H_

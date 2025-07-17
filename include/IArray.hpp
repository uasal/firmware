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

class IArray
{
public:
	IArray() { }
	virtual ~IArray() { }	
	
	virtual uint8_t operator[](const size_t offset) const = 0;
	virtual uint8_t peek(const size_t offset) const = 0;
	virtual uint16_t asU16(const size_t offset) const = 0;
	virtual uint32_t asU32(const size_t offset) const = 0;
	virtual size_t Depth() const = 0;
	virtual size_t CopyToFlatBuffer(const size_t StartOffset, size_t& NumToCopy, uint8_t* const Buffer, const size_t BufferMaxLen) const = 0;
	virtual void PopMany(const size_t LastReadAddrToPop) = 0;
};
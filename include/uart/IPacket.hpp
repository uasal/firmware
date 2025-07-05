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

#include "IArray.hpp"

class IPacket
{
public:
	IPacket() { }
	virtual ~IPacket() { }	
	
	virtual bool FindPacketStartPos(const uint8_t* Buffer, const size_t BufferLen, size_t& Offset) const = 0;
	virtual bool FindPacketEndPos(const uint8_t* Buffer, const size_t BufferLen, size_t& Offset) const = 0;
	virtual bool FindPacketStartPos(const uint8_t* Buffer, const size_t BufferLen, const size_t SearchStartPos, size_t& Offset) const = 0;
	virtual bool FindPacketEndPos(const uint8_t* Buffer, const size_t BufferLen, const size_t SearchStartPos,  size_t& Offset) const = 0;
	virtual size_t HeaderLen() const = 0;
	virtual size_t FooterLen() const = 0;
	virtual size_t EndTokenLen() const = 0;
	virtual size_t PayloadOffset() const = 0;
	virtual size_t MaxPayloadLength() const = 0;
	virtual size_t PayloadLen(const uint8_t* Buffer, const size_t BufferCount, const size_t PacketStartPos) const = 0;
	virtual bool IsValid(const uint8_t* Buffer, const size_t BufferCount, const size_t PacketStartPos, const size_t PacketEndPos) const = 0;
	virtual bool IsBroadcastSerialNum(const uint8_t* Buffer, const size_t PacketStartPos, const size_t PacketEndPos) const = 0;
	virtual uint64_t SerialNum(const uint8_t* Buffer, const size_t PacketStartPos, const size_t PacketEndPos) const = 0;
	virtual uint64_t PayloadType(const uint8_t* Buffer, const size_t PacketStartPos, const size_t PacketEndPos) const = 0;
	virtual bool DoesPayloadTypeMatch(const uint8_t* Buffer, const size_t BufferCount, const size_t PacketStartPos, const size_t PacketEndPos, const uint32_t CmdType) const = 0;
	virtual size_t MakePacket(uint8_t* Buffer, const size_t BufferCount, const void* Payload, const uint16_t PayloadType, const size_t PayloadLen) const = 0;
	
	virtual bool FindPacketStartPos(const IArray& Buffer, const size_t SearchStartPos, size_t& Offset) const = 0;
	virtual bool ReverseFindPacketStartPos(const IArray& Buffer, const size_t SearchEndPos, size_t& Offset) const = 0; //Look backwards from this location for first occurence of start byte(s)
	virtual bool FindPacketEndPos(const IArray& Buffer, const size_t SearchStartPos,  size_t& Offset) const = 0;
	virtual size_t PayloadLen(const IArray& Buffer, const size_t PacketStartPos) const = 0;
	virtual bool IsValid(const IArray& Buffer, const size_t PacketStartPos, const size_t PacketEndPos) const = 0;
	virtual bool IsBroadcastSerialNum(const IArray& Buffer, const size_t PacketStartPos, const size_t PacketEndPos) const = 0;
	virtual uint64_t SerialNum(const IArray& Buffer, const size_t PacketStartPos, const size_t PacketEndPos) const = 0;
	virtual uint64_t PayloadType(const IArray& Buffer, const size_t PacketStartPos, const size_t PacketEndPos) const = 0;
	virtual bool DoesPayloadTypeMatch(const IArray& Buffer, const size_t PacketStartPos, const size_t PacketEndPos, const uint32_t CmdType) const = 0;
};

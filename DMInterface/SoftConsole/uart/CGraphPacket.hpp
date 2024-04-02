/// \file
/// $Source: /raincloud/src/projects/include/Packet/IPacket.h,v $
/// $Revision: 1.5 $
/// $Date: 2009/01/06 07:14:18 $
/// $Author: steve $
/// The functionality for the Packet hardware when polled on the Atmel AVR processor

#pragma once
#ifndef _IPacket_H_
#define _IPacket_H_

#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>

#include "IPacket.hpp"


uint32_t CRC32(const uint8_t* data, const size_t length);

static const uint32_t CGraphMagikPacketStartToken = 0x1BADBABEUL;

struct CGraphPacketHeader
{
	uint32_t PacketStartToken;
	uint16_t PayloadType;
	uint16_t PayloadLen;

	CGraphPacketHeader() : PacketStartToken(CGraphMagikPacketStartToken), PayloadType(0), PayloadLen(0) { }
	
	CGraphPacketHeader(uint16_t packettype, uint16_t payloadtype, uint16_t payloadlen) : PacketStartToken(packettype), PayloadType(payloadtype), PayloadLen(payloadlen) { }
	
	const void* PayloadData() const { return(reinterpret_cast<const void*>(&(this[1]))); }

	void* PayloadDataNonConst() { return(reinterpret_cast<void*>(&(this[1]))); }
	
	void formatf() const { ::printf("CGraphPacketHeader: StartToken: 0x%lX, PayloadType: %lu, PayloadLen: %lu", (long)PacketStartToken, (unsigned long)PayloadType, (unsigned long)PayloadLen); }
	
} __attribute__((__packed__));

static const uint32_t CGraphMagikPacketEndToken = 0x0A0FADEDUL; //\n(0a) goes in high-byte to terminate serial stream in le arch

struct CGraphPacketFooter
{
	uint32_t CRC32;
	uint32_t PacketEndToken;
	
	CGraphPacketFooter() : CRC32(0), PacketEndToken(CGraphMagikPacketEndToken) { }
	
	//~ void formatf() const { ::formatf("CGraphPacketFooter: CRC: 0x%.8lX; PacketEndToken(0x%.8lX): 0x%.8lX", CRC32, CGraphMagikPacketEndToken, PacketEndToken); }

} __attribute__((__packed__));


class CGraphPacket: public IPacket
{
public:
  CGraphPacket() { }
  virtual ~CGraphPacket() { }
  
  virtual bool FindPacketStart(const uint8_t* Buffer, const size_t BufferLen, size_t& Offset) const {
    
    for (size_t i = 0; i < (BufferLen - sizeof(uint32_t)); i++) {
      if (CGraphMagikPacketStartToken == *((uint32_t*)&(Buffer[i]))) { Offset = i; return(true); }
    }
    return(false);
  }

  virtual bool FindPacketEnd(const uint8_t* Buffer, const size_t BufferLen, size_t& Offset) const {
    for (size_t i = 0; i <= (BufferLen - sizeof(uint32_t)); i++) {
      if (CGraphMagikPacketEndToken == *((uint32_t*)&(Buffer[i]))) { Offset = i; return(true); }
    }
    return(false);
  }
	
  virtual size_t HeaderLen() const { return(sizeof(CGraphPacketHeader)); }
  virtual size_t FooterLen() const { return(sizeof(CGraphPacketHeader)); }
  virtual size_t PayloadOffset() const { return(sizeof(CGraphPacketHeader)); }
  virtual size_t MaxPayloadLength() const { return(0xFFFFU); }
  virtual bool IsBroadcastSerialNum(const uint8_t* Buffer, const size_t PacketStartPos, const size_t PacketEndPos) const { return(false); }
  virtual uint64_t SerialNum(const uint8_t* Buffer, const size_t PacketStartPos, const size_t PacketEndPos) const { return(0); }

  virtual size_t PayloadLen(const uint8_t* Buffer, const size_t BufferCount, const size_t PacketStartPos) const {
    if ((PacketStartPos + sizeof(CGraphPacketHeader)) > BufferCount) { return(0); }
    const CGraphPacketHeader* Packet = reinterpret_cast<const CGraphPacketHeader*>(&(Buffer[PacketStartPos]));
    return(Packet->PayloadLen);
  }
	
  virtual uint64_t PayloadType(const uint8_t* Buffer, const size_t BufferCount, const size_t PacketStartPos) const {
    if ((PacketStartPos + sizeof(CGraphPacketHeader)) > BufferCount) { return(0); }
    const CGraphPacketHeader* Packet = reinterpret_cast<const CGraphPacketHeader*>(&(Buffer[PacketStartPos]));
    return(Packet->PayloadType);
  }
	
  virtual bool DoesPayloadTypeMatch(const uint8_t* Buffer, const size_t BufferCount, const size_t PacketStartPos, const size_t PacketEndPos, const uint32_t CmdType) const {
    //~ if ( ((PacketStartPos + sizeof(CGraphPacketHeader)) > BufferCount) || (NULL == CmdType) ) { return(false); }
    if ( ((PacketStartPos + sizeof(CGraphPacketHeader)) > BufferCount) ) { return(false); }
    const CGraphPacketHeader* Packet = reinterpret_cast<const CGraphPacketHeader*>(&(Buffer[PacketStartPos]));
    //~ ::printf("\nCGraphPacketHeader: DoesPayloadTypeMatch: Cmd: 0x%X, PayloadType: %u\n\n", CmdType, Packet->PayloadType);
    if (CmdType == Packet->PayloadType) { return(true); }
    return(false);
  }
	
  virtual bool IsValid(const uint8_t* Buffer, const size_t BufferCount, const size_t PacketStartPos, const size_t PacketEndPos) const {
    if ((PacketStartPos + sizeof(CGraphPacketHeader) + sizeof(CGraphPacketFooter)) > BufferCount) { return(false); }
    const CGraphPacketHeader* Header = reinterpret_cast<const CGraphPacketHeader*>(&(Buffer[PacketStartPos]));
    if ((PacketStartPos + sizeof(CGraphPacketHeader) + Header->PayloadLen + sizeof(CGraphPacketFooter)) > BufferCount) { return(false); }
    if (CGraphMagikPacketStartToken != Header->PacketStartToken) { return(false); }
    const CGraphPacketFooter* Footer = reinterpret_cast<const CGraphPacketFooter*>(&(Buffer[PacketStartPos + sizeof(CGraphPacketHeader) + Header->PayloadLen]));
    if (CGraphMagikPacketEndToken != Footer->PacketEndToken) { return(false); }
    uint32_t CRC = CRC32((uint8_t*)Header, sizeof(CGraphPacketHeader) + Header->PayloadLen);
    if (CRC != Footer->CRC32) { return(false); }		
    return(true);
  }
	
  virtual size_t MakePacket(uint8_t* Buffer, const size_t BufferCount, const void* Payload, const uint16_t PayloadType, const size_t PayloadLen) const {
    if ( (NULL == Buffer) || ((NULL == Payload) && (0 != PayloadLen)) || (BufferCount < (sizeof(CGraphPacketHeader) + PayloadLen + sizeof(CGraphPacketFooter))) ) { return(0); }
    CGraphPacketHeader Header;
    Header.PayloadType = PayloadType;
    Header.PayloadLen = PayloadLen;
    memcpy(Buffer, &Header, sizeof(CGraphPacketHeader));
    if (NULL != Payload) { memcpy(&(Buffer[sizeof(CGraphPacketHeader)]), Payload, PayloadLen); }
    CGraphPacketFooter* Footer = reinterpret_cast<CGraphPacketFooter*>(&(Buffer[sizeof(CGraphPacketHeader) + PayloadLen]));
    uint32_t CRC = CRC32(Buffer, sizeof(CGraphPacketHeader) + PayloadLen);
    Footer->CRC32 = CRC;
    Footer->PacketEndToken = CGraphMagikPacketEndToken;
    return(sizeof(CGraphPacketHeader) + PayloadLen + sizeof(CGraphPacketFooter));
  }
};

static const uint16_t CGraphPayloadTypeVersion = 0x0001U;
struct CGraphVersionPayload
{
	uint32_t SerialNum;
	uint32_t ProcessorFirmwareBuildNum;
	uint32_t FPGAFirmwareBuildNum;
	void formatf() const { ::printf("CGraphVersionPayload: SerialNum: 0x%lX, ProcessorFirmwareBuildNum: %lu, FPGAFirmwareBuildNum: %lu", (long)SerialNum, (unsigned long)ProcessorFirmwareBuildNum, (unsigned long)FPGAFirmwareBuildNum); }
};

static const uint16_t CGraphPayloadTypeDMDacs = 0x0002U; //Payload: 3 uint32's
static const uint16_t CGraphPayloadTypeDMDacsFloatingPoint = 0x0003U; //Payload: 3 double-precision floats
static const uint16_t CGraphPayloadTypeDMAdcs = 0x0004U; //Payload: 3 AdcAcumulators
static const uint16_t CGraphPayloadTypeDMAdcsFloatingPoint = 0x0005U; //Payload: 3 double-precision floats
static const uint16_t CGraphPayloadTypeDMConfigDacs = 0x0009U; // Payload: Nothing

static const uint16_t CGraphPayloadTypeDMStatus = 0x0006U;
struct CGraphDMStatusPayload
{
	double P1V2;
	double P2V2;
	double P24V;
	double P2V5;
	double P3V3A;
	double P6V;
	double P5V;
	double P3V3D;
	double P4V3;
	double N5V;
	double N6V;
	double P150V;
	//~ void formatf() const { ::printf("CGraphPZTStatusPayload: SerialNum: 0x%lX, ProcessorFirmwareBuildNum: %lu, FPGAFirmwareBuildNum: %lu", (long)SerialNum, (unsigned long)ProcessorFirmwareBuildNum, (unsigned long)FPGAFirmwareBuildNum); }
};


#endif // _IPacket_H_

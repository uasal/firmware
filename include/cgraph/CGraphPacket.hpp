//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
//

#pragma once
#ifndef _IPacket_H_
#define _IPacket_H_

#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "uart/IPacket.hpp"

#include "uart/Crc32Bzip2.h"

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
	uint32_t CRC32BZIP2;
	uint32_t PacketEndToken;
	
	CGraphPacketFooter() : CRC32BZIP2(0), PacketEndToken(CGraphMagikPacketEndToken) { }
	
	//~ void formatf() const { ::formatf("CGraphPacketFooter: CRC: 0x%.8lX; PacketEndToken(0x%.8lX): 0x%.8lX", CRC32BZIP2, CGraphMagikPacketEndToken, PacketEndToken); }

} __attribute__((__packed__));


class CGraphPacket: public IPacket
{
public:
	CGraphPacket() { }
	virtual ~CGraphPacket() { }
	
	virtual bool FindPacketStart(const uint8_t* Buffer, const size_t BufferLen, size_t& Offset) const override
	{
		for (size_t i = 0; i < (BufferLen - sizeof(uint32_t)); i++) { if (CGraphMagikPacketStartToken == *((const uint32_t*)&(Buffer[i]))) { Offset = i; return(true); } }
		return(false);
	}

	virtual bool FindPacketEnd(const uint8_t* Buffer, const size_t BufferLen, size_t& Offset) const override
	{
		for (size_t i = 0; i <= (BufferLen - sizeof(uint32_t)); i++) { if (CGraphMagikPacketEndToken == *((const uint32_t*)&(Buffer[i]))) { Offset = i; return(true); } }
		return(false);
	}
	
	virtual size_t HeaderLen() const override { return(sizeof(CGraphPacketHeader)); }
	virtual size_t FooterLen() const override { return(sizeof(CGraphPacketHeader)); }
	virtual size_t PayloadOffset() const override { return(sizeof(CGraphPacketHeader)); }
	virtual size_t MaxPayloadLength() const override { return(0xFFFFU); }
	virtual bool IsBroadcastSerialNum(const uint8_t* Buffer, const size_t PacketStartPos, const size_t PacketEndPos) const override { return(false); }
	virtual uint64_t SerialNum(const uint8_t* Buffer, const size_t PacketStartPos, const size_t PacketEndPos) const override { return(0); }

	virtual size_t PayloadLen(const uint8_t* Buffer, const size_t BufferCount, const size_t PacketStartPos) const override
	{
		if ((PacketStartPos + sizeof(CGraphPacketHeader)) > BufferCount) { return(0); }
		const CGraphPacketHeader* Packet = reinterpret_cast<const CGraphPacketHeader*>(&(Buffer[PacketStartPos]));
		return(Packet->PayloadLen);
	}
	
	virtual uint64_t PayloadType(const uint8_t* Buffer, const size_t BufferCount, const size_t PacketStartPos) const override
	{
		if ((PacketStartPos + sizeof(CGraphPacketHeader)) > BufferCount) { return(0); }
		const CGraphPacketHeader* Packet = reinterpret_cast<const CGraphPacketHeader*>(&(Buffer[PacketStartPos]));
		return(Packet->PayloadType);
	}
	
	virtual bool DoesPayloadTypeMatch(const uint8_t* Buffer, const size_t BufferCount, const size_t PacketStartPos, const size_t PacketEndPos, const uint32_t CmdType) const override
	{
		//~ if ( ((PacketStartPos + sizeof(CGraphPacketHeader)) > BufferCount) || (NULL == CmdType) ) { return(false); }
		if ( ((PacketStartPos + sizeof(CGraphPacketHeader)) > BufferCount) ) { return(false); }
		const CGraphPacketHeader* Packet = reinterpret_cast<const CGraphPacketHeader*>(&(Buffer[PacketStartPos]));
		//~ ::printf("\nCGraphPacketHeader: DoesPayloadTypeMatch: Cmd: 0x%X, PayloadType: %u\n\n", CmdType, Packet->PayloadType);
		if (CmdType == Packet->PayloadType) { return(true); }
		return(false);
	}
	
	virtual bool IsValid(const uint8_t* Buffer, const size_t BufferCount, const size_t PacketStartPos, const size_t PacketEndPos) const override
	{
		if ((PacketStartPos + sizeof(CGraphPacketHeader) + sizeof(CGraphPacketFooter)) > BufferCount) { return(false); }
		const CGraphPacketHeader* Header = reinterpret_cast<const CGraphPacketHeader*>(&(Buffer[PacketStartPos]));
		if ((PacketStartPos + sizeof(CGraphPacketHeader) + Header->PayloadLen + sizeof(CGraphPacketFooter)) > BufferCount) { return(false); }
		if (CGraphMagikPacketStartToken != Header->PacketStartToken) { return(false); }
		const CGraphPacketFooter* Footer = reinterpret_cast<const CGraphPacketFooter*>(&(Buffer[PacketStartPos + sizeof(CGraphPacketHeader) + Header->PayloadLen]));
		if (CGraphMagikPacketEndToken != Footer->PacketEndToken) { return(false); }
		uint32_t CRC = CRC32BZIP2((const uint8_t*)Header, sizeof(CGraphPacketHeader) + Header->PayloadLen);
		if (CRC != Footer->CRC32BZIP2) { return(false); }		
		return(true);
	}
	
	virtual size_t MakePacket(uint8_t* Buffer, const size_t BufferCount, const void* Payload, const uint16_t PayloadType, const size_t PayloadLen) const override
	{
		if ( (NULL == Buffer) || ((NULL == Payload) && (0 != PayloadLen)) || (BufferCount < (sizeof(CGraphPacketHeader) + PayloadLen + sizeof(CGraphPacketFooter))) ) { return(0); }
		CGraphPacketHeader Header;
		Header.PayloadType = PayloadType;
		Header.PayloadLen = PayloadLen;
		memcpy(Buffer, &Header, sizeof(CGraphPacketHeader));
		if (NULL != Payload) { memcpy(&(Buffer[sizeof(CGraphPacketHeader)]), Payload, PayloadLen); }
		CGraphPacketFooter* Footer = reinterpret_cast<CGraphPacketFooter*>(&(Buffer[sizeof(CGraphPacketHeader) + PayloadLen]));
		uint32_t CRC = CRC32BZIP2(Buffer, sizeof(CGraphPacketHeader) + PayloadLen);
		Footer->CRC32BZIP2 = CRC;
		Footer->PacketEndToken = CGraphMagikPacketEndToken;
		return(sizeof(CGraphPacketHeader) + PayloadLen + sizeof(CGraphPacketFooter));
	}
};

//************************************************* Packet Types *************************************************


//--------------------------------------------------------------------- General: supported by all hardware 0x1000 packets -------------------------------------------------------------

static const uint16_t CGraphPayloadTypeVersionDeprecated = 0x0001U;
static const uint16_t CGraphPayloadTypeVersion = 0x1001U;
struct CGraphVersionPayload
{
	uint32_t SerialNum;
	uint32_t ProcessorFirmwareBuildNum;
	uint32_t FPGAFirmwareBuildNum;
	void formatf() const { ::printf("CGraphVersionPayload: SerialNum: 0x%lX, ProcessorFirmwareBuildNum: %lu, FPGAFirmwareBuildNum: %lu", (long)SerialNum, (unsigned long)ProcessorFirmwareBuildNum, (unsigned long)FPGAFirmwareBuildNum); }
};

static const uint16_t CGraphPayloadTypeBaudClock = 0x1002U; //Payload: 64-bit uint; master clock rate in Hz
static const uint16_t CGraphPayloadTypeBaudDividers = 0x1003U; //Payload: 4 8-bit uint's which generate baud * 16 from master BaudClock. !!Beware: can change speed of port currently being talked to!!

static const uint16_t CGraphPayloadTypeHardFault = 0x1004U;
struct CGraphHardFaultPayload
{
	uint32_t R0;
	uint32_t R1;
	uint32_t R2;
	uint32_t R3;
	uint32_t R12;
	uint32_t LR;
	uint32_t PC;
	uint32_t PSR;
	uint32_t BFAR;
	uint32_t CFSR;
	uint32_t HFSR;
	uint32_t DFSR;
	uint32_t AFSR;
	
	void formatf() const { ::printf("CGraphHardFaultPayload: R0: 0x%lX, R1: %lu, R2: %lu, R3: %lu, R12: %lu, LR: %lu, PC: %lu, PSR: %lu, BFAR: %lu, CFSR: %lu, HFSR: %lu, DFSR: %lu, AFSR: %lu", (unsigned long) R0,	(unsigned long) R1,	(unsigned long) R2,	(unsigned long) R3,	(unsigned long) R12,	(unsigned long) LR,	(unsigned long) PC,	(unsigned long) PSR,	(unsigned long) BFAR,	(unsigned long) CFSR,	(unsigned long) HFSR,	(unsigned long) DFSR,	(unsigned long) AFSR); }
};

//--------------------------------------------------------------------- FSM Fine Steering Mirror 0x2000 packets -------------------------------------------------------------

static const uint16_t CGraphPayloadTypeFSMDacs = 0x2002U;
static const uint16_t CGraphPayloadTypeFSMDacsDeprecated = 0x0002U; //Payload: 3 uint32's
static const uint16_t CGraphPayloadTypeFSMDacsFloatingPoint = 0x2003U;
static const uint16_t CGraphPayloadTypeFSMDacsFloatingPointDeprecated = 0x0003U; //Payload: 3 double-precision floats
static const uint16_t CGraphPayloadTypeFSMAdcs = 0x2004U;
static const uint16_t CGraphPayloadTypeFSMAdcsDeprecated = 0x0004U; //Payload: 3 AdcAcumulators
static const uint16_t CGraphPayloadTypeFSMAdcsFloatingPoint = 0x2005U; 
static const uint16_t CGraphPayloadTypeFSMAdcsFloatingPointDeprecated = 0x0005U; //Payload: 3 double-precision floats

static const uint16_t CGraphPayloadTypeFSMTelemetry = 0x2006U;
static const uint16_t CGraphPayloadTypeFSMStatusDeprecated = 0x0006U;
struct CGraphFSMTelemetryPayload
{
	double P1V2;
	double P2V2;
	double P28V;
	double P2V5;
	double P3V3A;
	double P6V;
	double P5V;
	double P3V3D;
	double P4V3;
	double N5V;
	double N6V;
	double P150V;
	
	//~ void formatf() const { ::printf("CGraphFSMStatusPayload: SerialNum: 0x%lX, ProcessorFirmwareBuildNum: %lu, FPGAFirmwareBuildNum: %lu", (long)SerialNum, (unsigned long)ProcessorFirmwareBuildNum, (unsigned long)FPGAFirmwareBuildNum); }
};

//--------------------------------------------------------------------- DM Deformable Mirror 0x3000 packets -------------------------------------------------------------

static const uint16_t DMMaxControllerBoards = 6;
static const uint16_t DMMDacsPerControllerBoard = 4;
static const uint16_t DMActuatorsPerDac = 40;
static const uint16_t DMMaxActuators = DMActuatorsPerDac * DMMDacsPerControllerBoard * DMMaxControllerBoards;

static const uint16_t CGraphPayloadTypeDMDac = 0x3002U;
static const uint16_t CGraphPayloadTypeDMTelemetry = 0x3004U;
static const uint16_t CGraphPayloadTypeDMHVSwitch = 0x3007U;
static const uint16_t CGraphPayloadTypeDMDacConfig = 0x3009U;
static const uint16_t CGraphPayloadTypeDMVector = 0x3008U;
static const uint16_t CGraphPayloadTypeDMUart = 0x300AU;
static const uint16_t CGraphPayloadTypeDMMappings = 0x300BU; //Payload: CGraphDMPixelPayloadHeader followed by one or more CGraphDMMappingPayload structs (num defined by packet payload length filed)
static const uint16_t CGraphPayloadTypeDMShortPixels = 0x300CU; //Payload: CGraphDMPixelPayloadHeader followed by one or more 16b pixel values (num defined by packet payload length filed)
static const uint16_t CGraphPayloadTypeDMDither = 0x300DU; //Payload: CGraphDMPixelPayloadHeader followed by one or more 8b dither values (num defined by packet payload length filed)[we reserve the right to be really tricky and bitpack multiple pixels per byte since dither will always be <8b / pix]
static const uint16_t CGraphPayloadTypeDMLongPixels = 0x300EU; //Payload: CGraphDMPixelPayloadHeader followed by one or more 24b pixel values (num defined by packet payload length filed)- this is gonna cause some funky math & casts when parsing packet to ram...

struct CGraphDMTelemetryPayload
{
	double P1V2;
	double P2V2;
	double P28V;
	double P2V5;
	double P6V;
	double P5V;
	double P3V3D;
	double P4V3;
	double P2I2;
	double P4I3;
	double P6I;
	
	//~ void formatf() const { ::printf("CGraphFSMStatusPayload: SerialNum: 0x%lX, ProcessorFirmwareBuildNum: %lu, FPGAFirmwareBuildNum: %lu", (long)SerialNum, (unsigned long)ProcessorFirmwareBuildNum, (unsigned long)FPGAFirmwareBuildNum); }
};

struct CGraphDMPixelPayloadHeader
{
	uint16_t StartPixel;
	
	CGraphDMPixelPayloadHeader() : StartPixel(0) { }
	CGraphDMPixelPayloadHeader(unsigned long sp) : StartPixel(sp) { }
	
	void formatf() const { ::printf("CGraphDMPixelPayloadHeader: StartPixel: %lu", (unsigned long)StartPixel); }
};

//May send multiple copies per packet; array of 1...N of the following:
struct CGraphDMMappingPayload
{
	uint8_t ControllerBoardIndex; // 0 ... DMMaxControllerBoards - 1
	uint8_t DacIndex; // 0 ... DMMDacsPerControllerBoard - 1
	uint8_t DacChannel; // 0 ... DMActuatorsPerDac - 1
	
	CGraphDMMappingPayload() : ControllerBoardIndex(0), DacIndex(0), DacChannel(0) { }
	CGraphDMMappingPayload(unsigned long bi, unsigned long di, unsigned long dc) : ControllerBoardIndex(bi), DacIndex(di), DacChannel(dc) { }
	
	void formatf() const { ::printf("CGraphDMMappingPayload: ControllerBoardIndex: %lu, DacIndex: %lu, DacChannel: %lu", (unsigned long)ControllerBoardIndex, (unsigned long)DacIndex, (unsigned long)DacChannel); }
};

//May send multiple copies per packet; array of 1...N of the following:
struct CGraphDMMappings
{
	CGraphDMMappingPayload Mappings[DMMaxActuators];
	
	//Let's just make a default initialization so it's not totally null until uploaded, cause that causes all actuators to write ram0:0:0 over & over
	CGraphDMMappings()
	{
		uint8_t ControllerBoardIndex = 0;
		uint8_t DacIndex = 0;
		uint8_t DacChannel = 0;

		for (size_t i = 0; i < DMMaxActuators; i++)
		{
			Mappings[i].ControllerBoardIndex = ControllerBoardIndex;
			Mappings[i].DacIndex = DacIndex;
			Mappings[i].DacChannel = DacChannel;
			
			DacChannel++;
			if (DacChannel >= DMActuatorsPerDac)
			{
				DacChannel = 0;
				DacIndex++;
				if (DacIndex >= DMMDacsPerControllerBoard)
				{
					DacIndex = 0;
					ControllerBoardIndex++;
					if (ControllerBoardIndex >= DMMaxControllerBoards)
					{
						//We really really really shouldn't get here, but just in case we do it's better than crashing...
						ControllerBoardIndex = 0;
					}
				}
			}
		}
	}
	
	void formatf() const 
	{ 
		for (size_t i = 0; i < DMMaxActuators; i++)
		{
			Mappings[i].formatf();
			::printf("\n");
		}
	}
};

//--------------------------------------------------------------------- FW Filterwheel 0x4000 packets -------------------------------------------------------------

//The following are debug/telemetry-only/if things break packets:

static const uint16_t CGraphPayloadTypeFWHardwareControlStatus = 0x4001U; //Payload: CGraphFWHardwareInterface::CGraphFWHardwareControlRegister
static const uint16_t CGraphPayloadTypeFWMotorControlStatus = 0x4002U; //Payload: CGraphFWHardwareInterface::CGraphFWMotorControlStatusRegister
static const uint16_t CGraphPayloadTypeFWPositionSenseControlStatus = 0x4003U; //Payload: CGraphFWHardwareInterface::CGraphFWPositionSenseRegister
static const uint16_t CGraphPayloadTypeFWPositionSteps = 0x4004U; //Payload: 48 16-bit uint's: PosDetHomeA - PosDet7B of CGraphFWHardwareInterface

//Ok, now the real operational packets:

static const uint16_t CGraphPayloadTypeFWTelemetry = 0x4005U;
struct CGraphFWTelemetryPayload
{
	double P1V2;
	double P2V2;
	double P28V;
	double P2V5;
	double P6V;
	double P5V;
	double P3V3D;
	double P4V3;
	double P2I2;
	double P4I3;
	double P6I;
	
	//~ void formatf() const { ::printf("CGraphFSMStatusPayload: SerialNum: 0x%lX, ProcessorFirmwareBuildNum: %lu, FPGAFirmwareBuildNum: %lu", (long)SerialNum, (unsigned long)ProcessorFirmwareBuildNum, (unsigned long)FPGAFirmwareBuildNum); }
};

enum FWFilterSelectPositions { FW_MOVING = -1, FW_SUNSAFE = 0, FILTERWHEEL_ONE = 1, FILTERWHEEL_TWO = 2, FILTERWHEEL_THREE = 3, FILTERWHEEL_FOUR = 4, FILTERWHEEL_FIVE = 5, FILTERWHEEL_SIX = 6, FILTERWHEEL_SEVEN = 7, FILTERWHEEL_EIGHT = 8 };
static const uint16_t CGraphPayloadTypeFWFilterSelect = 0x4006U; //Payload: uint32 (room to grow?) Read: Which filter is currently in position (1-8; 0 means the filterwheel is in transit to a new position); Write: move to the given filter (1-8)FILTERWHEEL_ONE = 1,


#endif // _IPacket_H_

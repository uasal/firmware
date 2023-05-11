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
#pragma once

#include <stdint.h>
#include <stdio.h>
//~ #include <stdlib.h>
#include <time.h>
//~ #include <string>

#include "format/formatf.h"

#include "uart/CmdSystem.hpp" //for "Cmd" definition: see parse binary cmd

#include "CGraphTypes.h"

//Calculate a checksum on the specified bytes: xor every byte
uint8_t XORCRC(const uint8_t* Data, const size_t Len);
//Calculate a more involved checksum on given bytes
uint32_t CGraphBinaryHash(const uint8_t* Data, const size_t Len);

static const size_t CGraphBinaryMaxPayloadLength = 225; //note: read/writes to named pipes are guaranteed atomic for <512 bytes.

const uint16_t CGraphBinaryCommandPacketStartToken = 0x293A;
const uint16_t CGraphBinaryResponsePacketStartToken = 0x293B;
const uint16_t CGraphBinaryErrorPacketStartToken = 0x293C;
const uint16_t CGraphBinaryPacketEndToken = 0x0A0D; //hexadecimal reads right->left on l/e, so 0x0A0D comes out as \r\n on the wire....

const uint32_t CGraphBinaryBroadcastSerial = 0x99999999UL;

const uint32_t CGraphBinaryServerSerial = 0x1B16BEBE;

const uint64_t CGraphBinaryDefaultPanID = 0x0ABABEBEDDEDBEEFULL;

const uint64_t XBeeBroadcastAddress = 0x000000000000FFFFULL;

extern bool BinaryStatusResponseOn;

struct PacketTypeDefinition
{
	const uint16_t PacketType;
	const char* PacketName;

	PacketTypeDefinition(const uint16_t packettype, const char* packetname)
	:
		PacketType(packettype),
		PacketName(packetname) //,
	{ }

	void formatf() const { ::formatf("PacketType(%.4X): \"%s\"", PacketType, PacketName); }
};

extern const PacketTypeDefinition PacketTypeDefinitions[];
extern const size_t NumPacketTypeDefinitions;

struct CGraphBinaryPacketHeader
{
	uint16_t PacketStartToken;
	uint16_t PayloadTypeToken;
	uint32_t SerialNumber;
	uint16_t PayloadLen;

	CGraphBinaryPacketHeader() : PacketStartToken(0), PayloadTypeToken(0), SerialNumber(0), PayloadLen(0) { }
	
	CGraphBinaryPacketHeader(uint16_t packettype, uint16_t payloadtype, uint32_t serial, uint16_t payloadlen) : PacketStartToken(packettype), PayloadTypeToken(payloadtype), SerialNumber(serial), PayloadLen(payloadlen) { }
	
	const void* PayloadData() const { return(reinterpret_cast<const void*>(&(this[1]))); }

	void* PayloadDataNonConst() { return(reinterpret_cast<void*>(&(this[1]))); }

	const uint8_t* PayloadDataUint8() const { return(reinterpret_cast<const uint8_t*>(&(this[1]))); }
	
	const uint16_t* PayloadDataUint16() const { return(reinterpret_cast<const uint16_t*>(&(this[1]))); }
	
	static uint32_t SerialNumberFromSerialNumberOffsetPointer(void const* PacketSerialAddr) 
	{ 
		if (NULL == PacketSerialAddr) { return(0); }		
		return(*(reinterpret_cast<uint32_t*>(const_cast<void*>(PacketSerialAddr))));
	}

	static const CGraphBinaryPacketHeader* PacketFromSerialNumberOffsetPointer(void const* PacketSerialAddr) 
	{ 
		if (NULL == PacketSerialAddr) { return(0); }		
		return( (const CGraphBinaryPacketHeader*)(reinterpret_cast<const uint8_t*>(PacketSerialAddr) - (2 * sizeof(uint16_t))) );
		
		//~ const uint8_t* bPkt = reinterpret_cast<const uint8_t*>(PacketSerialAddr);
		//~ ::formatf("\n bPkt: %p.\n", bPkt);
		//~ bPkt -= (2 * sizeof(uint16_t));
		//~ ::formatf("\n bPkt: %p.\n", bPkt);
		//~ const CGraphBinaryPacketHeader* zPkt = (const CGraphBinaryPacketHeader*)bPkt;
		//~ ::formatf("\n zPkt: %p.\n", zPkt);
		//~ return( zPkt  );
	}

	static size_t PayloadLengthFromSerialNumberOffsetPointer(void const* PacketSerialAddr) 
	{ 
		if (NULL == PacketSerialAddr) { return(0); }		
		return(PacketFromSerialNumberOffsetPointer(PacketSerialAddr)->PayloadLen);
	}

	static const void* PayloadDataPointerFromSerialNumberOffsetPointer(void const* PacketSerialAddr) 
	{ 
		if (NULL == PacketSerialAddr) { return(NULL); }		
		return(PacketFromSerialNumberOffsetPointer(PacketSerialAddr)->PayloadData());
	}

	static uint64_t PayloadDataUint64FromSerialNumberOffsetPointer(void const* PacketSerialAddr) 
	{ 
		uint64_t AlignedMem = 0;
		if (NULL == PacketSerialAddr) { return(0); }		
		if (PayloadLengthFromSerialNumberOffsetPointer(PacketSerialAddr) < sizeof(uint64_t)) { return((const uint64_t)(-1)); }		
		memcpy(&AlignedMem, PayloadDataPointerFromSerialNumberOffsetPointer(PacketSerialAddr), sizeof(uint64_t));
		return(AlignedMem);
	}
	
	static uint32_t PayloadDataUint32FromSerialNumberOffsetPointer(void const* PacketSerialAddr) 
	{ 
		uint32_t AlignedMem = 0;
		if (NULL == PacketSerialAddr) { return(0); }		
		if (PayloadLengthFromSerialNumberOffsetPointer(PacketSerialAddr) < sizeof(uint32_t)) { return((const uint32_t)(-1)); }		
		memcpy(&AlignedMem, PayloadDataPointerFromSerialNumberOffsetPointer(PacketSerialAddr), sizeof(uint32_t));
		return(AlignedMem);
	}
	
	static int32_t PayloadDataInt32FromSerialNumberOffsetPointer(void const* PacketSerialAddr) 
	{ 
		uint32_t AlignedMem = 0;
		if (NULL == PacketSerialAddr) { return(0); }		
		if (PayloadLengthFromSerialNumberOffsetPointer(PacketSerialAddr) < sizeof(uint32_t)) { return((const uint32_t)(-1)); }		
		memcpy(&AlignedMem, PayloadDataPointerFromSerialNumberOffsetPointer(PacketSerialAddr), sizeof(uint32_t));
		return((int32_t)(AlignedMem));
	}
	
	static uint16_t PayloadDataUint16FromSerialNumberOffsetPointer(void const* PacketSerialAddr) 
	{ 
		uint16_t AlignedMem = 0;
		if (NULL == PacketSerialAddr) { return(0); }		
		if (PayloadLengthFromSerialNumberOffsetPointer(PacketSerialAddr) < sizeof(uint16_t)) { return((const uint16_t)(-1)); }		
		memcpy(&AlignedMem, PayloadDataPointerFromSerialNumberOffsetPointer(PacketSerialAddr), sizeof(uint16_t));
		return(AlignedMem);
	}
	
	static uint8_t PayloadDataUint8FromSerialNumberOffsetPointer(void const* PacketSerialAddr) 
	{ 
		const void* Ptr = PayloadDataPointerFromSerialNumberOffsetPointer(PacketSerialAddr);
		if (PayloadLengthFromSerialNumberOffsetPointer(PacketSerialAddr) < sizeof(uint8_t)) { return((const uint8_t)(-1)); }		
		if (NULL == Ptr) { return((const uint8_t)(-1)); }		
		return(*((const uint8_t*)Ptr));
	}
	
	static bool PayloadDataBoolFromSerialNumberOffsetPointer(void const* PacketSerialAddr) 
	{ 
		bool AlignedMem = 0;
		if (NULL == PacketSerialAddr) { return(0); }		
		if (PayloadLengthFromSerialNumberOffsetPointer(PacketSerialAddr) < sizeof(bool)) { return((const bool)(-1)); }		
		memcpy(&AlignedMem, PayloadDataPointerFromSerialNumberOffsetPointer(PacketSerialAddr), sizeof(bool));
		return(AlignedMem);
	}
	
	static float PayloadDataSingleFloatFromSerialNumberOffsetPointer(void const* PacketSerialAddr) 
	{ 
		float AlignedMem = 0;
		if (NULL == PacketSerialAddr) { return(0); }		
		if (PayloadLengthFromSerialNumberOffsetPointer(PacketSerialAddr) < sizeof(float)) { return((const float)(-1)); }		
		memcpy(&AlignedMem, PayloadDataPointerFromSerialNumberOffsetPointer(PacketSerialAddr), sizeof(float));
		return(AlignedMem);
	}

	static double PayloadDataDoubleFloatFromSerialNumberOffsetPointer(void const* PacketSerialAddr) 
	{ 
		double AlignedMem = 0;
		if (NULL == PacketSerialAddr) { return(0); }		
		if (PayloadLengthFromSerialNumberOffsetPointer(PacketSerialAddr) < sizeof(double)) { return((const double)(-1)); }		
		memcpy(&AlignedMem, PayloadDataPointerFromSerialNumberOffsetPointer(PacketSerialAddr), sizeof(double));
		return(AlignedMem);
	}
	
	static bool IsPacketStart(const uint8_t c1, const uint8_t c2)
	{
		if 	(
				( (((const uint8_t*)&CGraphBinaryCommandPacketStartToken)[1] == c1) && (((const uint8_t*)&CGraphBinaryCommandPacketStartToken)[0] == c2) ) 
				||
				( (((const uint8_t*)&CGraphBinaryResponsePacketStartToken)[1] == c1) && (((const uint8_t*)&CGraphBinaryResponsePacketStartToken)[0] == c2) ) 
			)
			{ return(true); }
		
		return(false);
	}
	
	static bool IsPacketEnd(const uint8_t c1, const uint8_t c2)
	{
		if 	( (((const uint8_t*)&CGraphBinaryPacketEndToken)[1] == c1) && (((const uint8_t*)&CGraphBinaryPacketEndToken)[0] == c2) )
			{ return(true); }
		
		return(false);
	}
	
	uint8_t* CalcCRC() 
	{ 
		//~ if (PayloadLen > ) { return; } //Nice feature we probably can't use cause we don't know how big of packets we will support in the future...
		uint8_t* Crc = reinterpret_cast<uint8_t*>(&SerialNumber) + sizeof(SerialNumber) + sizeof(PayloadLen) + PayloadLen;
		//~ *Crc = 0xAA; //for debugging
		uint8_t crc = XORCRC(reinterpret_cast<uint8_t*>(&SerialNumber), sizeof(SerialNumber) + sizeof(PayloadLen) + PayloadLen); 		
		*Crc = crc;
		//~ ::formatf("\nCalcCRC(): pCrc: %p, pSn: %p, PLen: %u (0x%.2X): CRC: 0x%.2X(int), 0x%.2X(actual).\n", Crc, reinterpret_cast<uint8_t*>(&SerialNumber), PayloadLen, PayloadLen, crc, *Crc);
		return(Crc);
	}
		
	void formatf() const 
	{ 
		::formatf("CGraphBinaryPacketHeader: PacketStartToken: 0x%.4X; ", PacketStartToken);
		::formatf("PayloadTypeToken: 0x%.4X; ", PayloadTypeToken);
		::formatf("SerialNumber: 0x%.8lX; ", (long unsigned int)SerialNumber);
		::formatf("PayloadLen: %u ", PayloadLen);
		::formatf("(0x%.4X)", PayloadLen);
	}
	
	void formatf_brief() const 
	{ 
		::formatf("ZBPH: Token: 0x%.4X; ", PacketStartToken);
		::formatf("Type: 0x%.4X; ", PayloadTypeToken);
		::formatf("Serial: 0x%.8lX; ", (long unsigned int)SerialNumber);
		::formatf("Len: %u ", PayloadLen);
		::formatf("(0x%.4X)", PayloadLen);
	}
	
	void formatf_payload(const size_t& maxlen) const 
	{ 
		size_t len = PayloadLen;
		if (len > maxlen) { len = maxlen; }
		const uint8_t* payload = reinterpret_cast<const uint8_t*>(&(this[1]));
		::formatf("[");
		for (size_t i = 0; i < len; i++)
		{
			::formatf(":%.2X", payload[i]);
		}
		::formatf("]");
	}
	
	void formatf_txt() const 
	{ 
		size_t TypeFoundPos = 0;
		for (TypeFoundPos = 0; TypeFoundPos < NumPacketTypeDefinitions; TypeFoundPos++) { if (PacketTypeDefinitions[TypeFoundPos].PacketType == PayloadTypeToken) { break; } }
		if (TypeFoundPos < NumPacketTypeDefinitions) { ::formatf("CGraphBinaryPacketHeader: %s: ", PacketTypeDefinitions[TypeFoundPos].PacketName); }
		else { ::formatf("CGraphBinaryPacketHeader: (type unknown): "); }
		::formatf("PacketStartToken: 0x%.4X; ", PacketStartToken);
		::formatf("PayloadTypeToken: 0x%.4X; ", PayloadTypeToken);
		::formatf("SerialNumber: 0x%.8lX; ", (long unsigned int)SerialNumber);
		::formatf("PayloadLen: %u ", PayloadLen);
		::formatf("(0x%.4X)", PayloadLen);
	}
	

	void sformatf(char* s) const { ::sformatf(s, "CGraphBinaryPacketHeader: PacketStartToken: 0x%.4X; PayloadTypeToken: 0x%.4X; SerialNumber: 0x%.8lX; PayloadLen: %u (0x%.4X)", PacketStartToken, PayloadTypeToken, (long unsigned int)SerialNumber, PayloadLen, PayloadLen); }

} __attribute__((__packed__));

struct CGraphBinaryPacketFooter
{
	uint8_t CRC;
	uint16_t PacketEndToken;
	
	CGraphBinaryPacketFooter() : CRC(0), PacketEndToken(CGraphBinaryPacketEndToken) { }
	
	void formatf() const { ::formatf("CGraphBinaryPacketFooter: CRC: 0x%.2X; PacketEndToken(0x%.4X): 0x%.4X", CRC, CGraphBinaryPacketEndToken, PacketEndToken); }

} __attribute__((__packed__));

template <size_t payload_len_bytes>
struct CGraphBinaryPacket
{
	CGraphBinaryPacketHeader Header;
	uint8_t Payload[payload_len_bytes];
	CGraphBinaryPacketFooter Footer;
	
	CGraphBinaryPacket() : Header(), Footer() { Header.PayloadLen = payload_len_bytes; memset(Payload, 0x55, payload_len_bytes); }
	
	CGraphBinaryPacket(uint16_t packettype, uint16_t payloadtype, uint32_t serial) : Header(packettype, payloadtype, serial, payload_len_bytes), Footer() { memset(Payload, 0x55, payload_len_bytes); }
	
	CGraphBinaryPacket(const CGraphBinaryPacketHeader* wire, const size_t len) : Header(), Footer() { memset(Payload, 0x55, payload_len_bytes); memcpy(this, wire, len); }
	
	void CalcCRC() { Footer.CRC = XORCRC(reinterpret_cast<uint8_t*>(&Header.SerialNumber), sizeof(CGraphBinaryPacket) - (sizeof(Header.PacketStartToken) + sizeof(Header.PayloadTypeToken) + sizeof(CGraphBinaryPacketFooter)) ); }
	
	//This fixup is cause C++ has no support for variable-length structs; this lets you declare a 'max size' packet, and truncate the contents (extra bytes from declated struct are ignored by this call; that memory can be safely overritten as needed)
	void CalcShortPacketCRCFromPayloadLen() 
	{ 
		uint8_t* Crc = Header.CalcCRC(); //Header::CalcCRC() uses PayloadLen from the header, and automatically calculates the proper location of Footer::CRC from that information...
		//Now we need to fix up the footer too, since it's not where we expect either:
		Crc[1] = 0x0D;
		Crc[2] = 0x0A;
	} 
	
	uint8_t* AsUint8() { return(reinterpret_cast<uint8_t*>(this)); }
	
	void formatf() const 
	{ 
		::formatf("CGraphBinaryPacket: "); 
		Header.formatf(); 
		::formatf(", Payload: [");
		for(size_t i = 0; i < payload_len_bytes; i++) { ::formatf(":%.2X", Payload[i]); }
		::formatf("], "); 
		Footer.formatf(); 
	}
	
	void formatf_shortpkt(const size_t& maxlen) const 
	{ 
		size_t len = Header.PayloadLen;
		if (len > maxlen) { len = maxlen; }
		::formatf("CGraphBinaryPacket: "); 
		Header.formatf(); 
		::formatf(", Payload: [");
		for(size_t i = 0; i < len; i++) { ::formatf(":%.2X", Payload[i]); }
		::formatf("], "); 
		const CGraphBinaryPacketFooter* pFooter = reinterpret_cast<const CGraphBinaryPacketFooter*>((reinterpret_cast<const uint8_t*>(this)) + sizeof(CGraphBinaryPacketHeader) + len);
		pFooter->formatf(); 
	}
	
} __attribute__((__packed__));

//~ struct FourCharCmdPayload
//~ {
	//~ const char s[4];
	
	//~ FourCharCmdPayload(const uint16_t& CmdType, const uint16_t& PayloadType)
	//~ FourCharCmdPayload(const uint32_t& CmdType)
		//~ : s((const char[])(&CmdType))
		//~ : s((const char)(CmdType >> 8), (const char)(CmdType & 0xFF), (const char)(PayloadType >> 8), (const char)(PayloadType & 0xFF))
		//~ : s({ (const char)(CmdType >> 8), (const char)(CmdType & 0xFF), (const char)(PayloadType >> 8), (const char)(PayloadType & 0xFF) })
		//~ s[0]((const char)(CmdType >> 8));
		//~ s[1]((const char)(CmdType & 0xFF));
		//~ s[2]((const char)(PayloadType >> 8));
		//~ s[3]((const char)(PayloadType & 0xFF));
	//~ {
		//~ s[0] = CmdType >> 8;
		//~ s[1] = CmdType & 0xFF;
		//~ s[2] = PayloadType >> 8;
		//~ s[3] = PayloadType & 0xFF;
	//~ }
	
	//~ const char* CharStar() const { return(s); }
//~ };

//Regular CmdSystem style call, but looks @ binary pkt
bool ParseBinaryCmd(const CGraphBinaryPacketHeader* PktIn, const unsigned int PktLen, const Cmd* Cmds, const size_t NumCmds, const void* Argument);

//Check contents of packet (serial num, crc) to see if this is a valid packet
bool ValidateCGraphBinaryRfPacket(const uint32_t SerialNumber, void const* PacketSerialOffset, const size_t PacketLen);
bool ValidateCGraphBinaryRfPacket(void const* PacketSerialOffset, const size_t PacketLen); //if you don't care wether the serial#'s match (i.e. the gui/user)

//Consts for TxValidateCGraphRfCmdFailed():
const uint8_t ValidateCGraphRfCmdFail_EMPTY_PKT = 0x01;
const uint8_t ValidateCGraphRfCmdFail_BAD_SERIAL = 0x02;
const uint8_t ValidateCGraphRfCmdFail_BAD_CRC = 0x03;

//Respond to the sender with some error information when we receive a bogus or corrupt command
void TxValidateCGraphRfCmdFailed(const uint8_t FailCode, const uint32_t FailedValue);

//Send of packet of the given type with the payload specified
void TxBinaryCommandPacket(const void* TxPktContext, const uint16_t PayloadTypeToken, const uint32_t SerialNumber, const void* PayloadData, const size_t PayloadLen);
void TxBinaryResponsePacket(const void* TxPktContext, const uint16_t PayloadTypeToken, const uint32_t SerialNumber, const void* PayloadData, const size_t PayloadLen);
void TxBinaryErrorPacket(const void* TxPktContext, const uint16_t PayloadTypeToken, const uint32_t SerialNumber, const void* PayloadData, const size_t PayloadLen);
void TxBinary(const void* TxPktContext, const uint16_t PacketTypeToken, const uint16_t PayloadTypeToken, const uint32_t SerialNumber, const void* PayloadData, const size_t PayloadLen);

//How do we get from ParamsLen in CmdSystem.cpp to PayloadLen?
const size_t PayloadLengthVsPacketLengthFromSerialNum = 999;

//List of supported payloads
const uint16_t PayloadTypeCmdFailed = 0x2121;
const uint16_t PayloadTypeExpectedNonEmptyPayload = 0x631F;

	const size_t CGraphProtocolFilenameParamLen = 32;
	struct CGraphProtocolFilenameParam
	{
		char FileName[CGraphProtocolFilenameParamLen];
		
	} __attribute__((__packed__));

//broadcast & beacon payloads

const uint16_t PayloadTypeChannelBeacon = 0x761E;
	
	struct ChannelBeacon ///Comes from other channels in a box: 2+...
	{
		uint32_t Synced : 1; //0 
		uint32_t ScheduleRunning : 1; //1
		uint32_t DataLog : 1; //2
		uint32_t FFTLog : 1; //3
		uint32_t NumSats : 4; // 4 - 7; 15 saturates; 15 is really ">= 15";
		uint32_t FileOpen : 1; //8
		uint32_t AdcOverRange : 1; //9
		uint32_t FifoOverflows : 3; //10 - 12
		uint32_t NumCalRecords : 4; // 13 - 16
		uint32_t NumMetaRecords : 4; // 17 - 20
		uint32_t NumSched : 5; // 21 - 25
		uint32_t AutoSleep : 1; // 26
		uint32_t CalVoltage : 1; // 27
		uint32_t CalChannels : 1; // 28
		uint32_t reserved : 3; // 29 - 31		
		uint16_t PPSPpb;
		uint32_t GpsSeconds;
		uint32_t FileSize;
		//SP & MaxVoltage: Since we're +/- 1V, a byte gives us 2 digits for the decimal voltage, or 10mV resolution. Just divide by 100 to get floating-point value (134 = 1.34V; -75 = -0.75V [we can get values over 200 as the A/D is differential - +1V at the - input and -1V at the + inputs gives a reading of -200]).
		int8_t MaxVoltage;
		int8_t SelfPotentialVoltage;
		uint16_t HardwareType;
		uint16_t NumFiles;
		
		void formatf() const 
		{ 
			::formatf("ChannelBeacon: Synced: %c, ScheduleRunning: %c, DataLog: %c, FFTLog: %c, NumSats: %u, FileOpen: %c, AdcOverRange: %c, FifoOverflows: %u, NumCalRecords: %lu, NumMetaRecords: %lu, NumSched: %lu, AutoSleep: %c, CalVoltage: %c, CalChannels: %c, reserved: %lu, PPSPpb: %u, GpsSeconds: %lu, FileSize: %lu, MaxVoltage: %f V, SelfPotentialVoltage: %f V, HardwareType: %u, NumFiles: %u", 
			Synced?'Y':'N', 
			ScheduleRunning?'Y':'N', 
			DataLog?'Y':'N', 
			FFTLog?'Y':'N', 
			NumSats, 
			FileOpen?'Y':'N', 
			AdcOverRange?'Y':'N', 
			FifoOverflows, 
			NumCalRecords, 
			NumMetaRecords, 
			NumSched, 
			AutoSleep?'Y':'N', 
			CalVoltage?'Y':'N', 
			CalChannels?'Y':'N', 
			reserved, 
			PPSPpb, 
			GpsSeconds, 
			(long unsigned int)FileSize, 
			(float)MaxVoltage / 100.0, 
			(float)SelfPotentialVoltage / 100.0, 
			HardwareType, 
			NumFiles); 
		}		
	} __attribute__((__packed__));

const uint16_t PayloadTypeFirstBeacon = 0x76A1;
	
	struct FirstBeacon : public ChannelBeacon //Always comes from Ch1 in a box
	{
		//<Expect ChannelBeacon data here in LSB's since FirstBeacon derives from ChBeacon>
		uint8_t BattVCompressed; //i.e. 022 = 12.2V, 171 = 27.1V, 256=35.6V; CGraph shuts down at ~11V, so values <11 not likely seen.
		int16_t TermperatureCompressed; //i.e. 03275 = 32.75oC, -171 = -1.71oC, 15805=158.05oC;
		uint8_t SignalStrength;
		
		void formatf() const 
		{ 
			::formatf("FirstBeacon: BattVCompressed: %u (%2.1f V), Temperature: %f oC, SignalStrength: -%u dBm, ", BattVCompressed, ((float)BattVCompressed / 10.0) + 10.0, (float)TermperatureCompressed / 100.0, SignalStrength); 
			ChannelBeacon::formatf();
		}
		
	} __attribute__((__packed__));
	
const uint16_t PayloadTypeTXBeacon = 0x76A2;
	
	struct TXBeacon : public FirstBeacon //Always comes from Ch1 in a box
	{
		//<Expect FirstBeacon data here in LSB's since TXBeacon derives from FirstBeacon>
		FaultsMatrix Faults;
		double OutputCurrent;
		double OutputVoltage;
		
		void formatf() const 
		{ 
			::formatf("TXBeacon: "); 
			Faults.formatf();
			::formatf(", Output Current: %le, ", OutputCurrent);
			::formatf("Output Voltage: %le, ", OutputVoltage);
			FirstBeacon::formatf();
		}
		
	} __attribute__((__packed__));

//~ const uint16_t PayloadTypeXmtBeacon = 0x7631;

	//~ struct XmtBeacon
	//~ {
		//~ uint8_t Synced : 1;
		//~ uint8_t ScheduleRunning : 1;
		//~ uint8_t NumSats : 4; // 15 saturates; 15 is really ">=" 15
		//~ uint16_t PPSPpb;
		//~ uint32_t GpsSeconds;
		
		//~ void formatf() const { ::formatf("XmtBeacon: Synced: %c, ScheduleRunning: %c, NumSats: %u, PPSPpb: %u, GpsSeconds: %lu", Synced?'Y':'N', ScheduleRunning?'Y':'N', NumSats, PPSPpb, GpsSeconds); }
		
	//~ } __attribute__((__packed__));
	
union CGraphBeacons
{
	ChannelBeacon ChB;
	FirstBeacon FstB;
	TXBeacon TXB;
	//~ XmtBeacon XmtB;
	
	CGraphBeacons() { }
	
} __attribute__((__packed__));

const uint16_t PayloadTypeBoardsInBox = 0x989E;
const uint16_t PayloadTypeBoardsInBridge = 0x989F;
	
	const size_t MAX_CHANNELS = 6;
	struct BoardsInBoxResponse
	{
		uint8_t MaxChannels;
		uint32_t ChannelSerialNum[MAX_CHANNELS]; //Values of 0UL and 0xFFFFFFFFUL are considered invalid (i.e. empty slots in box)
		
		BoardsInBoxResponse() : MaxChannels(MAX_CHANNELS) { }
		
		#ifdef __linux__
		void formatf() const { ::formatf("BoardsInBox: MaxChannels: %u, Ch1: 0x%.8X, Ch2: 0x%.8X, Ch3: 0x%.8X, Ch4 0x%.8X, Ch5: 0x%.8X, Ch6: 0x%.8X", MaxChannels, ChannelSerialNum[0], ChannelSerialNum[1], ChannelSerialNum[2], ChannelSerialNum[3], ChannelSerialNum[4], ChannelSerialNum[5]); }
		#else
		void formatf() const { ::formatf("BoardsInBox: MaxChannels: %u, Ch1: 0x%.8LX, Ch2: 0x%.8LX, Ch3: 0x%.8LX, Ch4 0x%.8LX, Ch5: 0x%.8LX, Ch6: 0x%.8LX", MaxChannels, ChannelSerialNum[0], ChannelSerialNum[1], ChannelSerialNum[2], ChannelSerialNum[3], ChannelSerialNum[4], ChannelSerialNum[5]); }
		#endif
		
	} __attribute__((__packed__));
	
	template <size_t MAX_CHANS>
	struct BoardsInBoxResponseTemplate
	{
		uint8_t MaxChannels;
		uint32_t ChannelSerialNum[MAX_CHANS]; //Values of 0UL and 0xFFFFFFFFUL are considered invalid (i.e. empty slots in box)
		
		BoardsInBoxResponseTemplate() : MaxChannels(MAX_CHANS) { }
		
		#ifdef __linux__
		void formatf() const { ::formatf("BoardsInBox: MaxChannels: %u, Ch1: 0x%.8X ... etc.", MaxChannels, ChannelSerialNum[0]); }
		#else
		void formatf() const { ::formatf("BoardsInBox: MaxChannels: %u, Ch1: 0x%.8LX ... etc.", MaxChannels, ChannelSerialNum[0]); }
		#endif
		
	} __attribute__((__packed__));
	
	struct FFTResult
	{
		uint32_t GpsmS_TimeStamp;
		float FFTr;
		float FFTi;
		uint32_t Harmonic;
		
		void formatf() const { ::formatf("FFTResult: GpsmS_TimeStamp: %lu (%lu.%03lu), FFTr: %e, FFTr: %ei, Harmonic: %lu", GpsmS_TimeStamp, GpsmS_TimeStamp >> 10, (GpsmS_TimeStamp & 0x03FFUL), FFTr, FFTi, Harmonic); }
	
	} __attribute__((__packed__));

const uint16_t PayloadTypeFFTResult = 0x765D;

const uint16_t PayloadTypeAllChannelsInBoxPayload = 0x7604;
	
//config payloads
const uint16_t PayloadTypeAdcGain = 0x3412;
const uint16_t PayloadTypeAdcRate = 0x3413;
const uint16_t PayloadTypeAdcMux = 0x3414;
const uint16_t PayloadTypeAdcPeriod = 0x34B6;
const uint16_t PayloadTypeAdcDuty = 0x34B7;
const uint16_t PayloadTypePIDCoeffs = 0x346D;

	struct PIDCoeffsResponse
	{
		double P;
		double I;
		double D;
		double S;
		double N;
		double X;
		
		void formatf() const { ::formatf("PIDCoeffs: P:%lf, I:%lf, D:%lf, Set:%lf, Min:%lf, Max:%lf\n", P, I, D, S, N, X); }

	} __attribute__((__packed__));

const uint16_t PayloadTypeGlobalSave = 0x3493;
const uint16_t PayloadTypeGlobalRestore = 0x3494;
const uint16_t PayloadTypeGlobalDump = 0x3495;
const uint16_t PayloadTypeFactoryDefault = 0x346E;
const uint16_t PayloadTypeZigDestAddr = 0x3457;
const uint16_t PayloadTypeDataFileType = 0x344B;
const uint16_t PayloadTypeChannelNum = 0x34D1;
	
	struct MetaDataPayload
	{
		uint32_t NumBytes;
		// <bytes of actual file data start here and continue to end of payload...>
		
		void formatf() { ::formatf("MetaDataPayload: NumBytes: %lu", NumBytes); }
		
	} __attribute__((__packed__));

	
const uint16_t PayloadTypeMetaData = 0x347C;
const uint16_t PayloadTypeMetaDataHash = 0x347D;
const uint16_t PayloadTypeMetaDataClear = 0x3428;

const uint16_t PayloadTypeCalData = 0x345B;
const uint16_t PayloadTypeCalDataHash = 0x345C;
const uint16_t PayloadTypeCalDataClear = 0x345D;
	
	//sizeof(struct tm) varies across systems; here's a look-alike
	struct WakeTimeResponse
	{
		uint16_t tm_sec; //seconds after the minute	0-61*
		uint16_t tm_min; //minutes after the hour	0-59
		uint16_t tm_hour; //hours since midnight	0-23
		//~ uint16_t tm_mday; //day of the month	1-31
		//~ uint16_t tm_mon; //months since January	0-11
		//~ uint16_t tm_year; //years since 1900	
		
		WakeTimeResponse() { }
		
		WakeTimeResponse(const struct tm& other) 
		{ 
			tm_sec = other.tm_sec;
			tm_min = other.tm_min;
			tm_hour = other.tm_hour;
		}
		
		void set_tm(struct tm* other) const
		{ 
			if (NULL == other) { return; }
			other->tm_sec = tm_sec;
			other->tm_min = tm_min;
			other->tm_hour = tm_hour;
		}

		WakeTimeResponse& operator=(const WakeTimeResponse& other)
		{ 
			tm_sec = other.tm_sec;
			tm_min = other.tm_min;
			tm_hour = other.tm_hour;
			return(*this);
		}	

		void formatf() const { ::formatf("WakeTimeResponse: %.2u:%.2u:%.2u", tm_hour, tm_min, tm_sec); }
		
	} __attribute__((__packed__));
	
const uint16_t PayloadTypeWakeTime = 0x34E8;
const uint16_t PayloadTypeSleepNow = 0x3435;
const uint16_t PayloadTypeAutoSleep = 0x3436;
const uint16_t PayloadTypePostSleepSyncTime = 0x3437;
const uint16_t PayloadTypePreSleepWaitTime = 0x3438;
const uint16_t PayloadTypeNumSamplesPerTrigger = 0x3482;
const uint16_t PayloadTypeFFTConfig = 0x3458;
	
	struct FFTConfigResponse
	{
		uint32_t FFTNumStacks;
		bool FFTHarmonicEnabled[10];
		
		void formatf() const { ::formatf("FFTConfig: FFTNumStacks: %u, Harmonic[0]:%c, Harmonic[1]:%c, Harmonic[2]:%c, Harmonic[3]:%c, Harmonic[4]:%c, Harmonic[5]:%c, Harmonic[6]:%c, Harmonic[7]:%c, Harmonic[8]:%c, Harmonic[9]:%c\n", FFTNumStacks, FFTHarmonicEnabled[0]?'Y':'N', FFTHarmonicEnabled[1]?'Y':'N', FFTHarmonicEnabled[2]?'Y':'N', FFTHarmonicEnabled[3]?'Y':'N', FFTHarmonicEnabled[4]?'Y':'N', FFTHarmonicEnabled[5]?'Y':'N', FFTHarmonicEnabled[6]?'Y':'N', FFTHarmonicEnabled[7]?'Y':'N', FFTHarmonicEnabled[8]?'Y':'N', FFTHarmonicEnabled[9]?'Y':'N'); }
		
	} __attribute__((__packed__));
	
const uint16_t PayloadTypeFFTLog = 0x3447;
const uint16_t PayloadTypeCGraphBoxSerial = 0x3481;
const uint16_t PayloadTypeCGraphBoxNumber = 0x3453;
const uint16_t PayloadTypeParseConfigFile = 0x3417;
const uint16_t PayloadTypeAutoGain = 0x34D3;
const uint16_t PayloadTypeSynced = 0x3451;
const uint16_t PayloadTypeStreamingDecimationModulus = 0x348B;	
const uint16_t PayloadTypeRadioDecimationModulus = 0x348E;	
const uint16_t PayloadTypeStreamingHiSpeedSamples = 0x348C;	
const uint16_t PayloadTypeStreamingHiResolutionSamples = 0x348D;	
const uint16_t PayloadTypeZigBeaconsEnabled = 0x342F;		
const uint16_t PayloadTypeHardwareType = 0x3474;		
const uint16_t PayloadTypeZigPanID = 0x3438;		
const uint16_t PayloadTypeRadioSignalQuality = 0x3439;	

struct RadioPingResponse
{
	double LatitudeRadians;
	double LongitudeRadians;
	double AltitudeMeters;
	int32_t SignalStrength;
	
	double LatitudeDegrees() const { return(LatitudeRadians * 180.0 / 3.1415926535898); }
	double LongitudeDegrees() const { return(LongitudeRadians * 180.0 / 3.1415926535898); }
	
	void formatf() const { ::formatf("RadioPingResponse: Latitude: %lf o, ", LatitudeRadians * 360 / 6.28); ::formatf("Longitude: %lf o, ", LongitudeRadians * 360 / 6.28); ::formatf("Altitude: %lf m, ", AltitudeMeters); ::formatf("SignalStrength: %ld", SignalStrength); }
	
} __attribute__((__packed__));
	
const uint16_t PayloadTypeRadioPing = 0x343A;		
const uint16_t PayloadTypeSyncThreshold = 0x34A7;		
const uint16_t PayloadTypeTXSyncType = 0x34C0;		
const uint16_t PayloadTypeParseAscii = 0x341A;		
const uint16_t PayloadTypeUsbProtocol = 0x34A9;		

//schedule payloads
const uint16_t PayloadTypeTime = 0x67A9;
const uint16_t PayloadTypeScheduleAction = 0x6754;
const uint16_t PayloadTypeClearAndScheduleAction = 0x6755;
const uint16_t PayloadTypeUnScheduleAction = 0x672B;
const uint16_t PayloadTypeClearSchedule = 0x6772;
const uint16_t PayloadTypeClearScheduleAndStopLogging = 0x6773;
const uint16_t PayloadTypeShowSchedule = 0x67FC;
const uint16_t PayloadTypeShowScheduleHash = 0x67FD;
const uint16_t PayloadTypeNumSchedules = 0x67FE;
const uint16_t PayloadTypeOffsetSchedule = 0x674E;
const uint16_t PayloadTypeOffsetScheduleToToday = 0x674D;
const uint16_t PayloadTypeRelativeOffsetSchedule = 0x674F;
const uint16_t PayloadTypeOffsetScheduleAtGpsSync = 0x6783;
const uint16_t PayloadTypeScheduleStarting = 0x6791;
const uint16_t PayloadTypeScheduleStartingLate = 0x6792;
const uint16_t PayloadTypeScheduleSummary = 0x67FA;
	
	struct DeltaTime
	{
		uint32_t LastTime;
		uint32_t NewTime;
		
		DeltaTime(const uint32_t& Last, const uint32_t& New) : LastTime(Last), NewTime(New) { }
		DeltaTime(const time_t& Last, const time_t& New) : LastTime((uint32_t)Last), NewTime((uint32_t)New) { }
		
		void formatf() const { ::formatf("DeltaTime: Last: %lu, Now: %lu", (long unsigned int)LastTime, (long unsigned int)NewTime); }
		
	} __attribute__((__packed__));
	
const uint16_t PayloadTypeScheduleTimeSecondSkipped = 0x6793;

//datacard payloads
const uint16_t PayloadTypeNewFile = 0xA0DF;
const uint16_t PayloadTypeNewFileMetadata = 0xA0DE;
const uint16_t PayloadTypeInitSD = 0xA073;
const uint16_t PayloadTypeEjectSD = 0xA019;
const uint16_t PayloadTypePowerControl = 0xA051;
const uint16_t PayloadTypeDatalog = 0xA044;
const uint16_t PayloadTypeListFilesPrep = 0xA07A;
const uint16_t PayloadTypeListFilesNext = 0xA07B;

	const uint8_t ListFilesAttrib_RDO = 0x01;	/* Read only */
	const uint8_t ListFilesAttrib_HID = 0x02;	/* Hidden */
	const uint8_t ListFilesAttrib_SYS = 0x04;	/* System */
	const uint8_t ListFilesAttrib_VOL = 0x08;	/* Volume label */
	const uint8_t ListFilesAttrib_LFN = 0x0F;	/* LFN entry */
	const uint8_t ListFilesAttrib_DIR = 0x10;	/* Directory */
	const uint8_t ListFilesAttrib_ARC = 0x20;	/* Archive */
	const uint8_t ListFilesAttrib_MASK = 0x3F;	/* Mask of defined bits */

	struct ListFilesResponse
	{
		uint32_t error;			/* error code if any (0 means more files to list) */
		uint32_t size;			/* File size */
		uint32_t datetime;		/* Last modified date+time */
		uint8_t attrib;			/* Attribute */
		char name[64];			/* Short file name (8.3 format) */
		
		void formatf() 
		{ 
			name[63] = '\0'; 
			::formatf("ListFilesResponse: name: \"%s\", size: %lu, attribs: 0x%.2X, modified: ", name, size, attrib); 
			
			tm* ptm = 0;
			time_t t = (time_t)datetime;
			ptm = gmtime(&t);
			if (ptm) { ::formatf("%.4d-%.2d-%.2d,%.2d:%.2d:%.2d (%lu)", ptm->tm_year + 1900, ptm->tm_mon + 1, ptm->tm_mday, ptm->tm_hour, ptm->tm_min, ptm->tm_sec, datetime); }
			else { ::formatf("<null>"); }
			::formatf(".\n");			
		}
				
	} __attribute__((__packed__));

const uint16_t PayloadTypeNumFiles = 0xA07C;
const uint16_t PayloadTypeStreamFile = 0xA009;

	template <size_t FileNameLen>
	struct StreamFileParams
	{
		uint32_t StartPos;
		int32_t LengthToStream;
		char FileName[FileNameLen];

		void formatf() { ::formatf("StreamFileParams: FileName: \"%s\", Start: %lu, Len: %ld", FileName, StartPos, LengthToStream); }
		
	} __attribute__((__packed__));
	
	struct StreamFileResponse
	{
		uint32_t StartPos;
		// <bytes of actual file data start here and continue to end of payload...>
		
		void formatf() { ::formatf("StreamFileResponse: Start: %lu", StartPos); }
		
	} __attribute__((__packed__));

const uint16_t PayloadTypeWriteFile = 0xA0E2;

	struct WriteFileParams
	{
		char FileName[32];
		uint32_t NumBytesToWrite;
		// <bytes of actual file data start here and continue to end of payload...>
		
		void formatf() { FileName[31] = '\0'; ::formatf("WriteFileParams: FileName: \"%s\", NumBytesToWrite: %lu", FileName, NumBytesToWrite); }
		
	} __attribute__((__packed__));
	
const uint16_t PayloadTypeRenameFile = 0xA0C1;
	
	struct RenameFileParams
	{
		char OldFileName[CGraphProtocolFilenameParamLen];
		char NewFileName[CGraphProtocolFilenameParamLen];
		
	} __attribute__((__packed__));

const uint16_t PayloadTypeDeleteFile = 0xA059;
const uint16_t PayloadTypeUMass = 0xA065;	
	
//gps payloads
const uint16_t PayloadTypeGetPPSCount = 0x9689;
const uint16_t PayloadTypeGetLLA = 0x9654;

	struct GetLLAResponse
	{
		double LatitudeRadians;
		double LongitudeRadians;
		double AltitudeMeters;
		
		double LatitudeDegrees() const { return(LatitudeRadians * 180.0 / 3.1415926535898); }
		double LongitudeDegrees() const { return(LongitudeRadians * 180.0 / 3.1415926535898); }
		
		void formatf() const { ::formatf("LLAResponse: Latitude: %lf o, ", LatitudeRadians * 360 / 6.28); ::formatf("Longitude: %lf o, ", LongitudeRadians * 360 / 6.28); ::formatf("Altitude: %lf m", AltitudeMeters); }
		
	} __attribute__((__packed__));

const uint16_t PayloadTypeNumSats = 0x9617;
const uint16_t PayloadTypeGpsDetected = 0x96AA;
	
	const uint8_t DetectedGpsTypeNone = 0;
	const uint8_t DetectedGpsTypeTimingTSIP = 0x01;
	const uint8_t DetectedGpsTypeRTKGenout = 0x02;
	const uint8_t DetectedGpsTypeGenericNMEA = 0x04;
	const uint8_t DetectedGpsTypeAtomicClockCSAC = 0x08;
	
	struct GpsDetectedResponse
	{
		bool GpsDetected;
		uint8_t GpsType;
		
		void formatf() const { ::formatf("GpsDetectedResponse: GpsDetected: %c, GpsType: 0x%.2X", GpsDetected?'Y':'N', GpsType); }
		
	} __attribute__((__packed__));
	
const uint16_t PayloadTypeTimingStatus = 0x9632;
	
	struct TimingStatusResponse
	{
		uint8_t AntennaCableOpenOrShorted : 1;
		uint8_t SurveyInProgress : 1;
		uint8_t RTKGettingDiff : 1;
		uint8_t FixModeieGpsorRtkQuality : 3;
		uint8_t AtomicClockPresent : 1;
		uint8_t AdcStartupSynced : 1;
		uint16_t LastGoodClockDacTune;
		uint16_t LastDisciplineAccyPpb;
		uint32_t BoxDisciplineAccyPpb;
		float Pdop;
		uint32_t PPSCount;

		void formatf() const { ::formatf("TimingStatusResponse: AntennaCableOpenOrShorted: %lu, SurveyInProgress: %lu, RTKGettingDiff: %lu, FixModeieGpsorRtkQuality: %lu, AtomicClockPresent: %lu, AdcStartupSynced: %lu, LastGoodClockDacTune: %u, LastDisciplineAccyPpb: %u, BoxDisciplineAccyPpb: %u, Pdop: %f", AntennaCableOpenOrShorted, SurveyInProgress, RTKGettingDiff, FixModeieGpsorRtkQuality, AtomicClockPresent, AdcStartupSynced, LastGoodClockDacTune, LastDisciplineAccyPpb, BoxDisciplineAccyPpb, Pdop); }
		
	} __attribute__((__packed__));
	
	
const uint16_t PayloadTypeClockDac = 0x9698;	

const uint16_t PayloadTypeGpsTimeSecondSkipped = 0x9693;	
	
//debug payloads
	
const uint16_t PayloadTypeVersion = 0x2C22;
	
	//Deprecated; please see CGraphHwTypes.h...
	// const uint16_t VersionPayloadHardwareType339_CGraphHiRes = 339;
	// const uint16_t VersionPayloadHardwareType357_CGraphHiSpeed = 357;
	// const uint16_t VersionPayloadHardwareType441_ZT_50 = 441;
	// const uint16_t VersionPayloadHardwareType352_XmtG = 352;

	struct VersionResponse
	{
		uint32_t SerialNumber;
		uint16_t ArmFirmwareVersion;
		uint16_t ArmFirmwareBuildNumber;
		uint16_t FgpaFirmwareBuildNumber;
		uint16_t HardwareType;
		
		void formatf() const { ::formatf("Version: Serial: %.8lX, Revision: %u, Arm build: %u, Fpga build: %u, Hardware type: %u", SerialNumber, ArmFirmwareVersion, ArmFirmwareBuildNumber, FgpaFirmwareBuildNumber, HardwareType); }
		
	} __attribute__((__packed__));

const uint16_t PayloadTypeRedLight = 0x2C93;
const uint16_t PayloadTypeGreenLight = 0x2C94;
const uint16_t PayloadTypeYellowLight = 0x2C95;
const uint16_t PayloadTypeBlueLight = 0x2C96;
const uint16_t PayloadTypeAdcVoltage = 0x2C72;
const uint16_t PayloadTypeBatteryPower = 0x2C9D;
	
	struct BatteryPowerResponse
	{
		float Voltage;
		float CurrentAmperes;
		
	} __attribute__((__packed__));

const uint16_t PayloadTypeTemperature = 0x2C18;
const uint16_t PayloadTypeAdcStatus = 0x2C55;	
const uint16_t PayloadTypeAcqStatus = 0x2C56;	

	struct AcqStatusResponse
	{
		uint8_t SyncAdc : 1; //0
		uint8_t AdcSynced : 1; //1
		uint8_t AutoTriggerAdc : 1; //2
		uint8_t PeriodTriggerPhase : 1; //3
		uint8_t DutyTriggerPhase : 1; //4
		uint8_t PeriodTriggerEither : 1; //5
		uint8_t DutyTriggerEither : 1; //6
		uint8_t TimestampFifoEmpty : 1; //7
		uint8_t SampleFifoEmpty : 1; //8
		uint8_t TimestampFifoFull : 1; //9
		uint8_t SampleFifoFull : 1; //10
		uint8_t GpsUartFifoEmpty : 1; //11
		uint8_t GpsUartFifoFull : 1; //12
		uint8_t UsbUartFifoEmpty : 1; //13
		uint8_t UsbUartFifoFull : 1; //14
		uint8_t SyncCompleted : 1; //15
		uint8_t InputOverRange : 1; //16
		uint8_t reserved : 7; //17 - 23
		uint32_t AdcOverrangeEvents;
		uint32_t FifoOverruns;
		uint32_t SampleCount;
		
		void formatf() const { ::formatf("AcqStatusResponse: SyncAdc: %u, \
																AdcSynced: %u, \
																AutoTriggerAdc: %u, \
																PeriodTriggerPhase: %u, \
																DutyTriggerPhase: %u, \
																PeriodTriggerEither: %u, \
																DutyTriggerEither: %u, \
																TimestampFifoEmpty: %u, \
																SampleFifoEmpty: %u, \
																TimestampFifoFull: %u, \
																SampleFifoFull: %u, \
																GpsUartFifoEmpty: %u, \
																GpsUartFifoFull: %u, \
																UsbUartFifoEmpty: %u, \
																UsbUartFifoFull: %u, \
																SyncCompleted: %u, \
																InputOverRange: %u, \
																reserved: 0x%.2X, \
																AdcOverrangeEvents: %u, \
																FifoOverruns: %u, \
																SampleCount: %u", 
																SyncAdc, 
																AdcSynced, 
																AutoTriggerAdc, 
																PeriodTriggerPhase, 
																DutyTriggerPhase, 
																PeriodTriggerEither, 
																DutyTriggerEither, 
																TimestampFifoEmpty, 
																SampleFifoEmpty,
																TimestampFifoFull,
																SampleFifoFull,
																GpsUartFifoEmpty,
																GpsUartFifoFull,
																UsbUartFifoEmpty,
																UsbUartFifoFull,
																SyncCompleted,
																InputOverRange,
																reserved,
																AdcOverrangeEvents,
																FifoOverruns,
																SampleCount
		); }

	} __attribute__((__packed__));
	
const uint16_t PayloadTypeForcePeriodnDuty = 0x2CE4;	
	
const uint16_t PayloadTypeAdcNoDataRestarting = 0x2C4B;	

	struct AdcLoadInfo
	{
		uint32_t Time;
		uint32_t NumSamples;
		
		AdcLoadInfo(const uint32_t& time, const uint32_t& num) : Time(time), NumSamples(num) { }
		AdcLoadInfo(const time_t& time, const uint32_t& num) : Time((uint32_t)time), NumSamples(num) { }
		
		void formatf() const { ::formatf("AdcLoadInfo: Time: %lu, NumSamples: %lu", (uint32_t)Time, NumSamples); }
		
	} __attribute__((__packed__));

const uint16_t PayloadTypeAdcShortLoad = 0x2C4C;	
const uint16_t PayloadTypeAdcLongLoad = 0x2C4D;	

//calibrator payloads
	
const uint16_t PayloadTypeCalDac = 0x698A;	
const uint16_t PayloadTypeCalVoltage = 0x6977;	
const uint16_t PayloadTypeCalChannels = 0x6991;	
const uint16_t PayloadTypeAttenChannels = 0x6992;	
	
	struct ContactResistanceResult
	{
		double CRes;
		uint8_t CalChannels;
		
		ContactResistanceResult(const double& cres, const uint8_t& calchannels) : CRes(cres), CalChannels(calchannels) { }
		ContactResistanceResult() { }
		
		void formatf() const { ::formatf("ContactResistanceResult: CRes: %lu, CalChannels: %lu", CRes, CalChannels); }
		
	} __attribute__((__packed__));

const uint16_t PayloadTypeContactResistance = 0x69EE;	
const uint16_t PayloadTypeCalibrateContactResistance = 0x69EF;	

//MX-2 & ZT-50 & NT-32 payloads
	
const uint16_t PayloadTypeCurrentMeasured = 0x8D78;	//responds with two doubles, one for each TX polarity
const uint16_t PayloadTypeTXBrdHardware = 0x8D20; //responds with TXBrdHardware structure
const uint16_t PayloadTypeTXBrdControlStatus = 0x8D22; //responds with TXBrdControlStatus structure
const uint16_t PayloadTypeTXBrdCurrentAdjDac = 0x8D24;	//responds with 16b uint
const uint16_t PayloadTypeTXBrdFaultsMatrix = 0x8D26; //accepts / responds with FaultsMatrix structure	
const uint16_t PayloadTypeTXBrdActiveFaults = 0x8D27; //accepts / responds with FaultsMatrix structure	
const uint16_t PayloadTypeTXBrdFaultPolarity = 0x8D28; //accepts / responds with FaultsMatrix structure	
const uint16_t PayloadTypeTXBrdReset = 0x8DDE; 
const uint16_t PayloadTypeTXBrdTransmit = 0x8DA4; 
const uint16_t PayloadTypeTXBrdPanic = 0x8DFF; 
//These all return a double:
const uint16_t PayloadTypeTXBrdPowerMeter = 0x8D30;
const uint16_t PayloadTypeTXBrdTempMeter = 0x8D31;
const uint16_t PayloadTypeTXBrdDecayMeter = 0x8D32; 
const uint16_t PayloadTypeTXBrdCurrentMeter = 0x8D33;
const uint16_t PayloadTypeTXBrdIAdj = 0x8D34;
const uint16_t PayloadTypeTXBrdIGroundFault = 0x8D35; 
const uint16_t PayloadTypeTXBrdDriverTemp0 = 0x8D36;
const uint16_t PayloadTypeTXBrdDriverTemp1 = 0x8D37; 
const uint16_t PayloadTypeTXBrdOutputCurrent = 0x8D38;
const uint16_t PayloadTypeTXBrdOutputVoltage = 0x8D39;
const uint16_t PayloadTypeTXBrdInputCurrent = 0x8D3A; 
const uint16_t PayloadTypeTXBrdInputVoltage = 0x8D3B;
const uint16_t PayloadTypeTXBrdPhaseAVoltage = 0x8D3C;
const uint16_t PayloadTypeTXBrdPhaseBVoltage = 0x8D3D;
const uint16_t PayloadTypeTXBrdPhaseCVoltage = 0x8D3E;
//Brd467:
const uint16_t PayloadTypeSetNT32DacBinary = 0x8D42;
const uint16_t PayloadTypeShowNT32CalBinary = 0x8D43;
const uint16_t PayloadTypeScanNT32Binary = 0x8D44;
const uint16_t PayloadTypeSetNT32CurrentBinary = 0x8D45;
const uint16_t PayloadTypeNT32CurrentBinary = 0x8D46;

//Server control/config payloads
	
	//Clear incoming/outgoing packet buffers:
const uint16_t PayloadTypeFlushDataToCGraph = 0xC1B1;	
const uint16_t PayloadTypeFlushDataFromCGraph = 0xC1B2;	
const uint16_t PayloadTypeBytesWaitingToCGraph = 0xC1B3;	
const uint16_t PayloadTypeBytesWaitingFromCGraph = 0xC1B4;	
	
	//Usual suite of operations on the internal channel table:
const uint16_t PayloadTypeChannelTableClear = 0xC185; //delete all entries
const uint16_t PayloadTypeChannelTableLen = 0xC186;	//how many channels found since last clear
const uint16_t PayloadTypeChannelTableEntry = 0xC187; //send index to query, or send index plus entry to replace
const uint16_t PayloadTypeChannelTableDelete = 0xC189; //delete entry at given index
const uint16_t PayloadTypeChannelTableFind = 0xC18A; //locate index of given entry (only chan s/n required to lookup)

	//Internal 457 packets
	
	struct FpgaAcessPayload
	{
		uint16_t FpgaAddress;
		uint8_t NumBytes;
		
		void formatf() const { ::formatf("FpgaAcessPayload: FpgaAddress: %u, NumBytes:%u", FpgaAddress, NumBytes); }
		
	} __attribute__((__packed__));
	
	struct FpgaExtAcessPayload : FpgaAcessPayload
	{
		uint8_t Channel;
		
		void formatf() const { FpgaAcessPayload::formatf(); ::formatf(", Channel:%u", Channel); }
		
	} __attribute__((__packed__));
	
const uint16_t PayloadTypeRegisterCallbackPipe = 0xC133; //Associate a serial number and a named pipe (mkfifio()) for callback packets between 457 processes
const uint16_t PayloadTypeReadCGraphHardware = 0xC137; //Read bytes from CGraphHardware process
const uint16_t PayloadTypeWriteCGraphHardware = 0xC138; //Write bytes to CGraphHardware process
const uint16_t PayloadTypeReadCGraphBus = 0xC139;
const uint16_t PayloadTypeWriteCGraphBus = 0xC13A;
const uint16_t PayloadTypeScheduleRunning = 0xC190;
const uint16_t PayloadTypeBatteryVoltage = 0xC145;
const uint16_t PayloadTypeSignalStrength = 0xC16A;
const uint16_t PayloadTypeStartupSynced = 0xC111;
const uint16_t PayloadTypeDisciplineAccyPpb = 0xC193;
	
//EOF

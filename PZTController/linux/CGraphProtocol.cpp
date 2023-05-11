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
/// \file
/// $Source: /raincloud/src/clients/zonge/Zeus/Zeus3/firmware/arm/main/CmdHandlersConfig.cpp,v $
/// $Revision: 1.7 $
/// $Date: 2010/06/08 23:51:10 $
/// $Author: steve $

#include <stdint.h>
//~ #include <stdio.h>
#include <stdlib.h>
#include <string.h>
//~ #include <ctype.h>
//~ #include <time.h>

#include "CGraphProtocol.hpp"

extern uint32_t SerialNum; //every program better declare this somewhere...

bool BinaryStatusResponseOn = false;

//Calculate a checksum on the specified bytes: xor every byte
uint8_t XORCRC(const uint8_t* Data, const size_t Len)
{
	if (NULL == Data) { return(0); }
	uint8_t crc = 0;
	for (size_t i = 0; i < Len; i++) { crc ^= Data[i]; }
	return(crc);
}

uint32_t CGraphBinaryHash(const uint8_t* data, const size_t length)
{
	static const uint32_t table[256] = 
	{
    0x00000000UL,0x04C11DB7UL,0x09823B6EUL,0x0D4326D9UL,
    0x130476DCUL,0x17C56B6BUL,0x1A864DB2UL,0x1E475005UL,
    0x2608EDB8UL,0x22C9F00FUL,0x2F8AD6D6UL,0x2B4BCB61UL,
    0x350C9B64UL,0x31CD86D3UL,0x3C8EA00AUL,0x384FBDBDUL,
    0x4C11DB70UL,0x48D0C6C7UL,0x4593E01EUL,0x4152FDA9UL,
    0x5F15ADACUL,0x5BD4B01BUL,0x569796C2UL,0x52568B75UL,
    0x6A1936C8UL,0x6ED82B7FUL,0x639B0DA6UL,0x675A1011UL,
    0x791D4014UL,0x7DDC5DA3UL,0x709F7B7AUL,0x745E66CDUL,
    0x9823B6E0UL,0x9CE2AB57UL,0x91A18D8EUL,0x95609039UL,
    0x8B27C03CUL,0x8FE6DD8BUL,0x82A5FB52UL,0x8664E6E5UL,
    0xBE2B5B58UL,0xBAEA46EFUL,0xB7A96036UL,0xB3687D81UL,
    0xAD2F2D84UL,0xA9EE3033UL,0xA4AD16EAUL,0xA06C0B5DUL,
    0xD4326D90UL,0xD0F37027UL,0xDDB056FEUL,0xD9714B49UL,
    0xC7361B4CUL,0xC3F706FBUL,0xCEB42022UL,0xCA753D95UL,
    0xF23A8028UL,0xF6FB9D9FUL,0xFBB8BB46UL,0xFF79A6F1UL,
    0xE13EF6F4UL,0xE5FFEB43UL,0xE8BCCD9AUL,0xEC7DD02DUL,
    0x34867077UL,0x30476DC0UL,0x3D044B19UL,0x39C556AEUL,
    0x278206ABUL,0x23431B1CUL,0x2E003DC5UL,0x2AC12072UL,
    0x128E9DCFUL,0x164F8078UL,0x1B0CA6A1UL,0x1FCDBB16UL,
    0x018AEB13UL,0x054BF6A4UL,0x0808D07DUL,0x0CC9CDCAUL,
    0x7897AB07UL,0x7C56B6B0UL,0x71159069UL,0x75D48DDEUL,
    0x6B93DDDBUL,0x6F52C06CUL,0x6211E6B5UL,0x66D0FB02UL,
    0x5E9F46BFUL,0x5A5E5B08UL,0x571D7DD1UL,0x53DC6066UL,
    0x4D9B3063UL,0x495A2DD4UL,0x44190B0DUL,0x40D816BAUL,
    0xACA5C697UL,0xA864DB20UL,0xA527FDF9UL,0xA1E6E04EUL,
    0xBFA1B04BUL,0xBB60ADFCUL,0xB6238B25UL,0xB2E29692UL,
    0x8AAD2B2FUL,0x8E6C3698UL,0x832F1041UL,0x87EE0DF6UL,
    0x99A95DF3UL,0x9D684044UL,0x902B669DUL,0x94EA7B2AUL,
    0xE0B41DE7UL,0xE4750050UL,0xE9362689UL,0xEDF73B3EUL,
    0xF3B06B3BUL,0xF771768CUL,0xFA325055UL,0xFEF34DE2UL,
    0xC6BCF05FUL,0xC27DEDE8UL,0xCF3ECB31UL,0xCBFFD686UL,
    0xD5B88683UL,0xD1799B34UL,0xDC3ABDEDUL,0xD8FBA05AUL,
    0x690CE0EEUL,0x6DCDFD59UL,0x608EDB80UL,0x644FC637UL,
    0x7A089632UL,0x7EC98B85UL,0x738AAD5CUL,0x774BB0EBUL,
    0x4F040D56UL,0x4BC510E1UL,0x46863638UL,0x42472B8FUL,
    0x5C007B8AUL,0x58C1663DUL,0x558240E4UL,0x51435D53UL,
    0x251D3B9EUL,0x21DC2629UL,0x2C9F00F0UL,0x285E1D47UL,
    0x36194D42UL,0x32D850F5UL,0x3F9B762CUL,0x3B5A6B9BUL,
    0x0315D626UL,0x07D4CB91UL,0x0A97ED48UL,0x0E56F0FFUL,
    0x1011A0FAUL,0x14D0BD4DUL,0x19939B94UL,0x1D528623UL,
    0xF12F560EUL,0xF5EE4BB9UL,0xF8AD6D60UL,0xFC6C70D7UL,
    0xE22B20D2UL,0xE6EA3D65UL,0xEBA91BBCUL,0xEF68060BUL,
    0xD727BBB6UL,0xD3E6A601UL,0xDEA580D8UL,0xDA649D6FUL,
    0xC423CD6AUL,0xC0E2D0DDUL,0xCDA1F604UL,0xC960EBB3UL,
    0xBD3E8D7EUL,0xB9FF90C9UL,0xB4BCB610UL,0xB07DABA7UL,
    0xAE3AFBA2UL,0xAAFBE615UL,0xA7B8C0CCUL,0xA379DD7BUL,
    0x9B3660C6UL,0x9FF77D71UL,0x92B45BA8UL,0x9675461FUL,
    0x8832161AUL,0x8CF30BADUL,0x81B02D74UL,0x857130C3UL,
    0x5D8A9099UL,0x594B8D2EUL,0x5408ABF7UL,0x50C9B640UL,
    0x4E8EE645UL,0x4A4FFBF2UL,0x470CDD2BUL,0x43CDC09CUL,
    0x7B827D21UL,0x7F436096UL,0x7200464FUL,0x76C15BF8UL,
    0x68860BFDUL,0x6C47164AUL,0x61043093UL,0x65C52D24UL,
    0x119B4BE9UL,0x155A565EUL,0x18197087UL,0x1CD86D30UL,
    0x029F3D35UL,0x065E2082UL,0x0B1D065BUL,0x0FDC1BECUL,
    0x3793A651UL,0x3352BBE6UL,0x3E119D3FUL,0x3AD08088UL,
    0x2497D08DUL,0x2056CD3AUL,0x2D15EBE3UL,0x29D4F654UL,
    0xC5A92679UL,0xC1683BCEUL,0xCC2B1D17UL,0xC8EA00A0UL,
    0xD6AD50A5UL,0xD26C4D12UL,0xDF2F6BCBUL,0xDBEE767CUL,
    0xE3A1CBC1UL,0xE760D676UL,0xEA23F0AFUL,0xEEE2ED18UL,
    0xF0A5BD1DUL,0xF464A0AAUL,0xF9278673UL,0xFDE69BC4UL,
    0x89B8FD09UL,0x8D79E0BEUL,0x803AC667UL,0x84FBDBD0UL,
    0x9ABC8BD5UL,0x9E7D9662UL,0x933EB0BBUL,0x97FFAD0CUL,
    0xAFB010B1UL,0xAB710D06UL,0xA6322BDFUL,0xA2F33668UL,
    0xBCB4666DUL,0xB8757BDAUL,0xB5365D03UL,0xB1F740B4UL,
    };

	uint32_t crc = 0xffffffff;
	
	size_t len = length;
    while (len > 0)
    {
      crc = table[*data ^ ((crc >> 24) & 0xff)] ^ (crc << 8);
      data++;
      len--;
    }
    return crc ^ 0xffffffff;
}
	//~ uint8_t buf[256];
	
	//~ //see: https://en.wikipedia.org/wiki/Cyclic_redundancy_check
	//~ //see: http://www.cl.cam.ac.uk/research/srg/bluebook/21/crc/node6.html (algo #2)
	
	//~ const uint32_t QUOTIENT = 0x04c11db7;
	//~ uint32_t       result;
    //~ size_t              i,j;
    //~ unsigned char       octet;
    
	//~ memcpy(buf, data, length);    
	//~ size_t rem = length % 4;
	//~ size_t len = length + rem;
	//~ for (size_t k = 0; k < rem; k++) { buf[k + length] = 0x00; }
	
    //~ result = *data++ << 24;
    //~ result |= *data++ << 16;
    //~ result |= *data++ << 8;
    //~ result |= *data++;
    //~ result = ~ result;
    
    //~ for (i=0; i<(len-4); i++)
    //~ {
        //~ octet = *(data++);
        //~ for (j=0; j<8; j++)
        //~ {
            //~ if (result & 0x80000000)
            //~ {
                //~ result = (result << 1) ^ QUOTIENT ^ (octet >> 7);
            //~ }
            //~ else
            //~ {
                //~ result = (result << 1) ^ (octet >> 7);
            //~ }
            //~ octet <<= 1;
        //~ }
    //~ }
    
    //~ return ~result;             /* The complement of the remainder */
//~ }

//Regular CmdSystem style call, but looks @ binary pkt
bool ParseBinaryCmd(const CGraphBinaryPacketHeader* PktIn, const unsigned int PktLen, const Cmd* Cmds, const size_t NumCmds, const void* Argument)
{
	size_t i = 0;

	if ( (0 == PktIn) || (0 == PktLen) ) { return(false); }

	//"Params" is all of the packet starting with the serial number
	const char* Params = reinterpret_cast<const char*>(&(PktIn->SerialNumber));
	
	//debug:
	//~ formatf("\nCGraphProtocol::ParseBinaryCmd(): Packet Header Signature: %.2X:%.2X:%.2X:%.2X\n", ((const uint8_t*)&PktIn->PacketStartToken)[0], ((const uint8_t*)&PktIn->PacketStartToken)[1], ((const uint8_t*)&PktIn->PayloadTypeToken)[0], ((const uint8_t*)&PktIn->PayloadTypeToken)[1]);

	//look at each command, and exectute it if the input line matches.
	for(i = 0; i < NumCmds; i++)
	{
		//debug:
		//~ formatf("\nCGraphProtocol::ParseBinaryCmd(): Cmds[%lu] Signature: %.2X:%.2X:%.2X:%.2X\n", (uint32_t)i, ((const uint8_t*)Cmds[i].Name)[0], ((const uint8_t*)Cmds[i].Name)[1], ((const uint8_t*)Cmds[i].Name)[2], ((const uint8_t*)Cmds[i].Name)[3]);
		
		//do we match command(i)? This ugly hack cause standard cmds are defined as strings instead of structs
		if ( ( ((const uint8_t*)&PktIn->PacketStartToken)[0] == ((const uint8_t*)Cmds[i].Name)[0] ) && 
			 ( ((const uint8_t*)&PktIn->PacketStartToken)[1] == ((const uint8_t*)Cmds[i].Name)[1] ) &&
			 ( ((const uint8_t*)&PktIn->PayloadTypeToken)[0] == ((const uint8_t*)Cmds[i].Name)[2] ) && 
			 ( ((const uint8_t*)&PktIn->PayloadTypeToken)[1] == ((const uint8_t*)Cmds[i].Name)[3] ) 
		   )
		{
			//debug:
			//~ formatf("\nCGraphProtocol::ParseBinaryCmd(): Match for command packet @ Cmd%lu\n\n", (uint32_t)i);
			
			//call the actual command
			Cmds[i].Response(Cmds[i].Name, Params, PktLen - 4, Argument);
			
			//stop searching
			break;
		}
	}
	
	if (NumCmds == i)
	{
		formatf("\nCGraphProtocol::ParseBinaryCmd(): No match for command packet: ");
		PktIn->formatf();
		formatf("\n\n");
	}

	return(false);
}

//Check contents of packet (serial num, crc) to see if this is a valid packet
//!! Pass addr of s/n field, not addr of start token! PacketLen does not include the footer in this case!
bool ValidateCGraphBinaryRfPacket(const uint32_t SerialNumber, void const* PacketSerialOffset, const size_t PacketLen)
{
	uint32_t PktSerial = 0;
	uint32_t PktType = 0;
	
	//note: we're assuming the pointer given is to the middle of the packet where the serial is located, because the standard CmdSystem.cpp parser strips the Header & Type fields.
	
	if (NULL == PacketSerialOffset) { TxValidateCGraphRfCmdFailed(ValidateCGraphRfCmdFail_EMPTY_PKT, 0); return(false); }
	
	//~ formatf("\nValidate (%p,%p)", &PktSerial, PacketSerialOffset);
	//~ for (size_t i = 0; i < PacketLen; i++) { formatf("%.2X:", ((const uint8_t*)PacketSerialOffset)[i]); }
	
	memcpy(&PktSerial, PacketSerialOffset, sizeof(uint32_t)); //trust me, you want this in a local. Dereferencing a byte to a dword on arm has been shown to cause insane corruption.
	memcpy(&PktType, ((const uint8_t*)PacketSerialOffset) - 2, sizeof(uint16_t)); //trust me, you want this in a local. Dereferencing a byte to a dword on arm has been shown to cause insane corruption.
	
	if ( (SerialNumber != PktSerial) && (CGraphBinaryBroadcastSerial != PktSerial) )
	{ 
		formatf("\nValidateCGraphBinaryRfPacket Serial Failed; expected: 0x%.8lX, got: 0x%.8lX\n", (long unsigned int)SerialNumber, PktSerial);
		//~ for (size_t i = 0; i < PacketLen; i++) { formatf("%.2X:", reinterpret_cast<uint8_t*>(&PacketSerialOffset)[i]); }
		TxValidateCGraphRfCmdFailed(ValidateCGraphRfCmdFail_BAD_SERIAL, SerialNumber); 
		return(false); 
	}
	
	size_t len = CGraphBinaryPacketHeader::PayloadLengthFromSerialNumberOffsetPointer(PacketSerialOffset) + 7; //+7 b/c we do the payload, 4 bytes of s/n, 2 bytes of len, and the crc itself to get zero
	if (len > PacketLen) { len = PacketLen; }
	
	if (0 != XORCRC((uint8_t const*)PacketSerialOffset, len))
	{ 
		formatf("\nValidateCGraphBinaryRfPacket (0x%.4X) CRC Failed; expected: 0x%.2X, got: 0x%.2X\n", PktType, 0, XORCRC((uint8_t const*)PacketSerialOffset, len));
		//~ for (size_t i = 0; i < PacketLen; i++) { formatf("%.2X:", reinterpret_cast<uint8_t*>(&PacketSerialOffset)[i]); }
		TxValidateCGraphRfCmdFailed(ValidateCGraphRfCmdFail_BAD_CRC, XORCRC((uint8_t const*)PacketSerialOffset, PacketLen)); 
		return(false); 
	}
	
	return(true);
}

//Check contents of packet (serial num, crc) to see if this is a valid packet
//!! Pass addr of s/n field, not addr of start token! PacketLen does not include the footer in this case!
bool ValidateCGraphBinaryRfPacket(void const* PacketSerialOffset, const size_t PacketLen)
{
	//note: we're assuming the pointer given is to the middle of the packet where the serial is located, because the standard CmdSystem.cpp parser strips the Header & Type fields.
	
	if (NULL == PacketSerialOffset) { TxValidateCGraphRfCmdFailed(ValidateCGraphRfCmdFail_EMPTY_PKT, 0); return(false); }
	
	size_t len = CGraphBinaryPacketHeader::PayloadLengthFromSerialNumberOffsetPointer(PacketSerialOffset) + 7; //+7 b/c we do the payload, 4 bytes of s/n, 2 bytes of len, and the crc itself to get zero
	if (len > PacketLen) { len = PacketLen; }
		
	if (0 != XORCRC((uint8_t const*)PacketSerialOffset, len)) //+7 b/c we do the payload, 4 bytes of s/n, 2 bytes of len, and the crc itself to get zero
	{ 
		formatf("\nValidateCGraphBinaryRfPacket CRC Failed; expected: 0x%.2X, got: 0x%.2X\n", 0, XORCRC((uint8_t const*)PacketSerialOffset, len));
		//~ for (size_t i = 0; i < PacketLen; i++) { formatf("%.2X:", reinterpret_cast<uint8_t*>(&PacketSerialOffset)[i]); }
		TxValidateCGraphRfCmdFailed(ValidateCGraphRfCmdFail_BAD_CRC, XORCRC((uint8_t const*)PacketSerialOffset, PacketLen)); 
		return(false); 
	}
	
	return(true);
}

//Respond to the sender with some error information when we receive a bogus or corrupt command
void TxValidateCGraphRfCmdFailed(const uint8_t FailCode, const uint32_t FailedValue)
{
	formatf("\nTxValidateCGraphRfCmdFailed(%X, %lX)\n", FailCode, (long unsigned int)FailedValue);
	//~ CGraphBinaryPacket<sizeof(uint8_t) + sizeof(uint32_t)> Packet(PayloadTypeCmdFailed, SerialNum);
	//~ Packet.Payload[0] = FailCode;
	//~ memcpy(&(Packet.Payload[1]), &FailedValue, sizeof(uint32_t));
	//~ Packet.CalcCRC();
	//~ SendBinaryPacket(Packet.Addr(), sizeof(Packet), CGraphUartPinout);
	//~ //for (size_t i = 0; i < sizeof(Packet); i++) { formatf("%.2X:", reinterpret_cast<uint8_t*>(&Packet)[i]); }
}

//Send of packet of the given type with the payload specified
void TxBinaryCommandPacket(const void* TxPktContext, const uint16_t PayloadTypeToken, const uint32_t SerialNumber, const void* PayloadData, const size_t PayloadLen) { TxBinary(TxPktContext, CGraphBinaryCommandPacketStartToken, PayloadTypeToken, SerialNumber, PayloadData, PayloadLen); }
void TxBinaryResponsePacket(const void* TxPktContext, const uint16_t PayloadTypeToken, const uint32_t SerialNumber, const void* PayloadData, const size_t PayloadLen) { TxBinary(TxPktContext, CGraphBinaryResponsePacketStartToken, PayloadTypeToken, SerialNumber, PayloadData, PayloadLen); }
void TxBinaryErrorPacket(const void* TxPktContext, const uint16_t PayloadTypeToken, const uint32_t SerialNumber, const void* PayloadData, const size_t PayloadLen) { TxBinary(TxPktContext, CGraphBinaryErrorPacketStartToken, PayloadTypeToken, SerialNumber, PayloadData, PayloadLen); }
//~ void TxBinary(char (*sendchar)(const char), const uint16_t PacketTypeToken, const uint16_t PayloadTypeToken, const uint32_t SerialNumber, const void* PayloadData, const size_t PayloadLen)
//~ {
	//~ size_t i = 0;
	//~ uint8_t CRC = 0;
	//~ size_t bytes_sent = sizeof(CGraphBinaryPacketHeader);
	//~ //Header:
	//~ CGraphBinaryPacketHeader PacketHeader(PacketTypeToken, PayloadTypeToken, SerialNumber, PayloadLen);
	//~ for (i = 0; i < sizeof(CGraphBinaryPacketHeader); i++) { sendchar(reinterpret_cast<const uint8_t*>(&PacketHeader)[i]); }
	//~ CRC ^= XORCRC(reinterpret_cast<const uint8_t*>(&SerialNumber), sizeof(PacketHeader.SerialNumber));
	//~ CRC ^= XORCRC(reinterpret_cast<const uint8_t*>(&PayloadLen), sizeof(PacketHeader.PayloadLen));
	
	//~ //Payload:
	//~ if (NULL != PayloadData)
	//~ {
		//~ for (i = 0; i < PayloadLen; i++) 
		//~ { 
			//~ uint8_t data_i = (reinterpret_cast<const uint8_t*>(PayloadData))[i]; 
			//~ sendchar(data_i); 
			//~ CRC ^= data_i; 
			//~ bytes_sent++;
		//~ }
	//~ }
	
	//~ //Footer:
	//~ sendchar(CRC);	
	//~ uint16_t EndToken = CGraphBinaryPacketEndToken;
	//~ sendchar(reinterpret_cast<uint8_t*>(&EndToken)[0]);
	//~ sendchar(reinterpret_cast<uint8_t*>(&EndToken)[1]);
	//~ bytes_sent+=3;
	
	//~ formatf("\nTxBinaryPacket(%lu)\n", (long unsigned int)bytes_sent);
//~ }

const PacketTypeDefinition PacketTypeDefinitions[] = 
{
	PacketTypeDefinition(PayloadTypeCmdFailed, "CmdFailed"),
	PacketTypeDefinition(PayloadTypeExpectedNonEmptyPayload, "ExpectedNonEmptyPayload"),
	PacketTypeDefinition(PayloadTypeChannelBeacon, "ChannelBeacon"),
	PacketTypeDefinition(PayloadTypeFirstBeacon, "FirstBeacon"),
	//~ PacketTypeDefinition(PayloadTypeXmtBeacon, "XmtBeacon"),
	PacketTypeDefinition(PayloadTypeBoardsInBox, "BoardsInBox"),
	PacketTypeDefinition(PayloadTypeFFTResult, "FFTResult"),
	PacketTypeDefinition(PayloadTypeAllChannelsInBoxPayload, "AllChannelsInBoxPayload"),
	PacketTypeDefinition(PayloadTypeAdcGain, "AdcGain"),
	PacketTypeDefinition(PayloadTypeAdcRate, "AdcRate"),
	PacketTypeDefinition(PayloadTypeAdcMux, "AdcMux"),
	PacketTypeDefinition(PayloadTypeAdcPeriod, "AdcPeriod"),
	PacketTypeDefinition(PayloadTypeAdcDuty, "AdcDuty"),
	PacketTypeDefinition(PayloadTypePIDCoeffs, "PIDCoeffs"),
	PacketTypeDefinition(PayloadTypeGlobalSave, "GlobalSave"),
	PacketTypeDefinition(PayloadTypeGlobalRestore, "GlobalRestore"),
	PacketTypeDefinition(PayloadTypeGlobalDump, "GlobalDump"),
	PacketTypeDefinition(PayloadTypeFactoryDefault, "FactoryDefault"),
	PacketTypeDefinition(PayloadTypeZigDestAddr, "ZigDestAddr"),
	PacketTypeDefinition(PayloadTypeDataFileType, "DataFileType"),
	PacketTypeDefinition(PayloadTypeChannelNum, "ChannelNum"),
	PacketTypeDefinition(PayloadTypeMetaData, "MetaData"),
	PacketTypeDefinition(PayloadTypeMetaDataHash, "MetaDataHash"),
	PacketTypeDefinition(PayloadTypeMetaDataClear, "MetaDataClear"),
	PacketTypeDefinition(PayloadTypeCalData, "CalData"),
	PacketTypeDefinition(PayloadTypeCalDataHash, "CalDataHash"),
	PacketTypeDefinition(PayloadTypeCalDataClear, "CalDataClear"),
	PacketTypeDefinition(PayloadTypeWakeTime, "WakeTime"),
	PacketTypeDefinition(PayloadTypeSleepNow, "SleepNow"),
	PacketTypeDefinition(PayloadTypeAutoSleep, "AutoSleep"),
	PacketTypeDefinition(PayloadTypePostSleepSyncTime, "PostSleepSyncTime"),
	PacketTypeDefinition(PayloadTypePreSleepWaitTime, "PreSleepWaitTime"),
	PacketTypeDefinition(PayloadTypeNumSamplesPerTrigger, "NumSamplesPerTrigger"),
	PacketTypeDefinition(PayloadTypeFFTConfig, "FFTConfig"),
	PacketTypeDefinition(PayloadTypeFFTLog, "FFTLog"),
	PacketTypeDefinition(PayloadTypeCGraphBoxSerial, "CGraphBoxSerial"),
	PacketTypeDefinition(PayloadTypeCGraphBoxNumber, "CGraphBoxNumber"),
	PacketTypeDefinition(PayloadTypeParseConfigFile, "ParseConfigFile"),
	PacketTypeDefinition(PayloadTypeAutoGain, "AutoGain"),
	PacketTypeDefinition(PayloadTypeSynced, "Synced"),
	PacketTypeDefinition(PayloadTypeStreamingDecimationModulus, "StreamingDecimationModulus"),
	PacketTypeDefinition(PayloadTypeZigBeaconsEnabled, "ZigBeaconsEnabled"),
	PacketTypeDefinition(PayloadTypeHardwareType, "HardwareType"),
	PacketTypeDefinition(PayloadTypeZigPanID, "ZigPanID"),
	PacketTypeDefinition(PayloadTypeSyncThreshold, "SyncThreshold"),
	PacketTypeDefinition(PayloadTypeTXSyncType, "TXSyncType"),
	PacketTypeDefinition(PayloadTypeTime, "Time"),
	PacketTypeDefinition(PayloadTypeScheduleAction, "ScheduleAction"),
	PacketTypeDefinition(PayloadTypeUnScheduleAction, "UnScheduleAction"),
	PacketTypeDefinition(PayloadTypeClearSchedule, "ClearSchedule"),
	PacketTypeDefinition(PayloadTypeShowSchedule, "ShowSchedule"),
	PacketTypeDefinition(PayloadTypeShowScheduleHash, "ShowScheduleHash"),
	PacketTypeDefinition(PayloadTypeNumSchedules, "NumSchedules"),
	PacketTypeDefinition(PayloadTypeOffsetSchedule, "OffsetSchedule"),
	PacketTypeDefinition(PayloadTypeOffsetScheduleToToday, "OffsetScheduleToToday"),
	PacketTypeDefinition(PayloadTypeRelativeOffsetSchedule, "RelativeOffsetSchedule"),
	PacketTypeDefinition(PayloadTypeOffsetScheduleAtGpsSync, "OffsetScheduleAtGpsSync"),
	PacketTypeDefinition(PayloadTypeScheduleStarting, "ScheduleStarting"),
	PacketTypeDefinition(PayloadTypeScheduleStartingLate, "ScheduleStartingLate"),
	PacketTypeDefinition(PayloadTypeScheduleSummary, "ScheduleSummary"),
	PacketTypeDefinition(PayloadTypeScheduleTimeSecondSkipped, "ScheduleTimeSecondSkipped"),
	PacketTypeDefinition(PayloadTypeNewFile, "NewFile"),
	PacketTypeDefinition(PayloadTypeNewFileMetadata, "NewFileMetadata"),
	PacketTypeDefinition(PayloadTypeInitSD, "InitSD"),
	PacketTypeDefinition(PayloadTypeEjectSD, "EjectSD"),
	PacketTypeDefinition(PayloadTypePowerControl, "PowerControl"),
	PacketTypeDefinition(PayloadTypeDatalog, "Datalog"),
	PacketTypeDefinition(PayloadTypeListFilesPrep, "ListFilesPrep"),
	PacketTypeDefinition(PayloadTypeListFilesNext, "ListFilesNext"),
	PacketTypeDefinition(PayloadTypeNumFiles, "NumFiles"),
	PacketTypeDefinition(PayloadTypeStreamFile, "StreamFile"),
	PacketTypeDefinition(PayloadTypeWriteFile, "WriteFile"),
	PacketTypeDefinition(PayloadTypeRenameFile, "RenameFile"),
	PacketTypeDefinition(PayloadTypeDeleteFile, "DeleteFile"),
	PacketTypeDefinition(PayloadTypeUMass, "UMass"),
	PacketTypeDefinition(PayloadTypeGetPPSCount, "GetPPSCount"),
	PacketTypeDefinition(PayloadTypeGetLLA, "GetLLA"),
	PacketTypeDefinition(PayloadTypeNumSats, "NumSats"),
	PacketTypeDefinition(PayloadTypeGpsDetected, "GpsDetected"),
	PacketTypeDefinition(PayloadTypeTimingStatus, "TimingStatus"),
	PacketTypeDefinition(PayloadTypeGpsTimeSecondSkipped, "GpsTimeSecondSkipped"),
	PacketTypeDefinition(PayloadTypeVersion, "Version"),
	PacketTypeDefinition(PayloadTypeRedLight, "RedLight"),
	PacketTypeDefinition(PayloadTypeGreenLight, "GreenLight"),
	PacketTypeDefinition(PayloadTypeYellowLight, "YellowLight"),
	PacketTypeDefinition(PayloadTypeBlueLight, "BlueLight"),
	PacketTypeDefinition(PayloadTypeAdcVoltage, "AdcVoltage"),
	PacketTypeDefinition(PayloadTypeBatteryPower, "BatteryPower"),
	PacketTypeDefinition(PayloadTypeTemperature, "Temperature"),
	PacketTypeDefinition(PayloadTypeAcqStatus, "AcqStatus"),
	PacketTypeDefinition(PayloadTypeForcePeriodnDuty, "ForcePeriodnDuty"),
	PacketTypeDefinition(PayloadTypeAdcNoDataRestarting, "AdcNoDataRestarting"),
	PacketTypeDefinition(PayloadTypeAdcShortLoad, "AdcShortLoad"),
	PacketTypeDefinition(PayloadTypeAdcLongLoad, "AdcLongLoad"),
	PacketTypeDefinition(PayloadTypeCalDac, "CalDac"),
	PacketTypeDefinition(PayloadTypeCalVoltage, "CalVoltage"),
	PacketTypeDefinition(PayloadTypeCalChannels, "CalChannels"),
	PacketTypeDefinition(PayloadTypeAttenChannels, "AttenChannels"),
	PacketTypeDefinition(PayloadTypeContactResistance, "ContactResistance"),
	PacketTypeDefinition(PayloadTypeCalibrateContactResistance, "CalibrateContactResistance"),
	PacketTypeDefinition(PayloadTypeCurrentMeasured, "CurrentMeasured"),
	PacketTypeDefinition(PayloadTypeTXBrdHardware, "TXBrdHardware"),
	PacketTypeDefinition(PayloadTypeTXBrdControlStatus, "TXBrdControlStatus"),
	PacketTypeDefinition(PayloadTypeTXBrdCurrentAdjDac, "TXBrdCurrentAdjDac"),
	PacketTypeDefinition(PayloadTypeTXBrdFaultsMatrix, "TXBrdFaultsMatrix"),
	PacketTypeDefinition(PayloadTypeFlushDataToCGraph, "FlushDataToCGraph"),
	PacketTypeDefinition(PayloadTypeFlushDataFromCGraph, "FlushDataFromCGraph"),
	PacketTypeDefinition(PayloadTypeBytesWaitingToCGraph, "BytesWaitingToCGraph"),
	PacketTypeDefinition(PayloadTypeBytesWaitingFromCGraph, "BytesWaitingFromCGraph"),
	PacketTypeDefinition(PayloadTypeChannelTableClear, "ChannelTableClear"),
	PacketTypeDefinition(PayloadTypeChannelTableLen, "ChannelTableLen"),
	PacketTypeDefinition(PayloadTypeChannelTableEntry, "ChannelTableEntry"),
	PacketTypeDefinition(PayloadTypeChannelTableDelete, "ChannelTableDelete"),
	PacketTypeDefinition(PayloadTypeChannelTableFind, "ChannelTableFind"),
	PacketTypeDefinition(PayloadTypeRegisterCallbackPipe, "RegisterCallbackPipe"),
	PacketTypeDefinition(PayloadTypeReadCGraphHardware, "ReadCGraphHardware"),
	PacketTypeDefinition(PayloadTypeWriteCGraphHardware, "WriteCGraphHardware"),
	PacketTypeDefinition(PayloadTypeReadCGraphBus, "ReadCGraphBus"),
	PacketTypeDefinition(PayloadTypeWriteCGraphBus, "WriteCGraphBus"),
	PacketTypeDefinition(PayloadTypeScheduleRunning, "ScheduleRunning"),
	PacketTypeDefinition(PayloadTypeBatteryVoltage, "BatteryVoltage"),
	PacketTypeDefinition(PayloadTypeSignalStrength, "SignalStrength"),
	PacketTypeDefinition(PayloadTypeStartupSynced, "StartupSynced"),
	PacketTypeDefinition(PayloadTypeDisciplineAccyPpb, "DisciplineAccyPpb")//,
};

const size_t NumPacketTypeDefinitions = sizeof(PacketTypeDefinitions) / sizeof(PacketTypeDefinition);

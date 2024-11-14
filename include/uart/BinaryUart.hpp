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

#include <stdio.h>
#include <stdarg.h>
#include <stdint.h>

#include "fixedqueue.hpp"
//~ #include <queue> //Using std::queue calls malloc and screws everything up....

#include "uart/IUart.h"

#include "format/formatf.h"

#include "uart/CmdSystem.hpp"

#include "uart/IProtocol.hpp"
#include "uart/IPacket.hpp"
#include "uart/IUartParser.hpp"

struct BinaryUartCallbacks
{
	BinaryUartCallbacks() { }
	virtual ~BinaryUartCallbacks() { }
	
	//Malformed/corrupted packet handler:
	virtual void InvalidPacket(const uint8_t* Buffer, const size_t& BufferLen) { }
	
	//Packet with no matching command handler:
	virtual void UnHandledPacket(const IPacket* Packet, const size_t& PacketLen) { }
	
	//In case we need to look at every packet that goes by...
	virtual void EveryPacket(const IPacket* Packet, const size_t& PacketLen) { }
	
	//Seems like someone, sometime might wanna handle this...
	virtual void BufferOverflow(const uint8_t* Buffer, const size_t& BufferLen) { }
};

struct BinaryUart : IUartParser
{
    //This is where the received characters go while we are building a line up from the input
	static const size_t RxBufferLenBytes = 4096;
	static const size_t TxBufferLenBytes = 4096;
    uint8_t RxBuffer[RxBufferLenBytes];
    uint16_t RxCount;
    //~ IUart& Pinout;
	IPacket& Packet;
    const BinaryCmd* Cmds;
    size_t NumCmds;
	BinaryUartCallbacks& Callbacks;
    bool debug;
    bool InPacket;
	size_t PacketStart;
    size_t PacketLen;
	//~ const void* Argument;
	uint64_t SerialNum;
	static const uint64_t InvalidSerialNumber = 0xFFFFFFFFFFFFFFFFULL;
	
    BinaryUart(struct IUart& pinout, struct IPacket& packet, const BinaryCmd* cmds, const size_t numcmds, struct BinaryUartCallbacks& callbacks, const bool verbose = true, const uint64_t serialnum = InvalidSerialNumber)
        :
		IUartParser(pinout),
		RxCount(0),
        //~ Pinout(pinout),
		Packet(packet),
        Cmds(cmds),
        NumCmds(numcmds),
		Callbacks(callbacks),
		debug(false),
		//~ debug(true),
		InPacket(false),
		PacketStart(0),
		PacketLen(0),
		//~ Argument(argument),
		SerialNum(serialnum)	
	
    {

    }

    void Debug(bool dbg)
    {
        debug = dbg;
    }

    int Init(uint32_t serialnum)
    {
		SerialNum = serialnum;
        RxCount = 0;
        memset(RxBuffer, '\0', RxBufferLenBytes);
		
		::formatf("\n\nBinary Uart: Init(PktH %u, PktF %u).\n", Packet.HeaderLen(), Packet.FooterLen());
		
        return(0);
    }

	//~ void SetArgument(const void* argument) { Argument = argument; }
	//~ const void* GetArgument() { return(Argument); }	
	
    bool Process()
    {
	    //New char?
        if ( !(Pinout.dataready()) ) { return(false); }

		//pull it off the hardware
        uint8_t c = Pinout.getcqq();
		
		//~ if (debug) {
			//~ printf(".%.2x", c);
		//~ }
		
        //~ bool GotCmd = ProcessChar(c);
		ProcessByte(c);
		
		//~ return(GotCmd);
		return(true); //We just want to know if there's chars in the buffer to put threads to sleep or not...
	}
	
	bool ProcessByte(const char c)
	{
		bool Processed = false;
		size_t PacketEnd = 0;
		
		//~ stdio_hook_putc(c);
        //~ ::formatf(":0x%.2X", c);
        //~ ::formatf("\"%c\":", c);

		//Put the current character into the buffer
		if (RxCount < RxBufferLenBytes) 
		{
			RxCount++;
			RxBuffer[RxCount - 1] = c;
		}
		else 
		{ 
			if (debug) { ::formatf("\n\nBinaryUart: Buffer(%p) overflow; this packet will not fit (%zub), flushing buffer.\n", RxBuffer, RxCount); }

			Callbacks.BufferOverflow(RxBuffer, RxCount);
			
			InPacket = false;						
			RxCount = 0;
			RxBuffer[0] = 0;
		}

		//Packet Start?
		if ( (!InPacket) && (RxCount >= Packet.HeaderLen()) )
		{
			if (Packet.FindPacketStart(RxBuffer, RxCount, PacketStart)) //This is wasteful, we really only need to look at the 4 newest bytes every time...
			{
				if (debug) { ::formatf("\n\nBinaryUart: Packet start detected! Buffering.\n"); } 
				
				InPacket = true;
			}
		}
		
		//Packet End?
		if ( (InPacket) && (RxCount >= (Packet.HeaderLen() + Packet.FooterLen())) )
		{
			if (Packet.FindPacketEnd(RxBuffer, RxCount, PacketEnd)) //This is wasteful, we really only need to look at the 4 newest bytes every time...
			{
				if (debug) { ::formatf("\n\nBinaryUart: Packet end detected; Looking for matching packet handlers.\n"); }
				
				if (RxCount >= Packet.PayloadLen(RxBuffer, RxCount, PacketStart) + Packet.HeaderLen() + Packet.FooterLen())
				{
					if (Packet.IsValid(RxBuffer, RxCount, PacketStart, PacketEnd))
					{
						if ( (SerialNum == InvalidSerialNumber) || (Packet.IsBroadcastSerialNum(RxBuffer, PacketStart, PacketEnd)) || (SerialNum == Packet.SerialNum(RxBuffer, PacketStart, PacketEnd)) )
						{
							//just look at each command, and exectute it if the input line matches.
							bool CmdFound = false;
							
							for (size_t i = 0; i < NumCmds; i++)
							{
								//~ formatf("\nParseCmd(): i=%d, Line=%s (len=%d), L[0] = 0x%.2X, Cmd=", i, LineIn, strlen(LineIn), (uint16_t)(LineIn[0]));
								//~ formatf(Cmds[i].Name);
								//~ formatf(" CmdLen=%d\n", Cmds[i].Strlen);

								//do we match command(i)?
								if (Packet.DoesPayloadTypeMatch(RxBuffer, RxCount, PacketStart, PacketEnd, Cmds[i].Name))
								{
									//~ ::formatf("\n\nBinary Uart: PayloadTypeMatch. (%u, %u): ", PacketStart, Packet.PayloadOffset());
									//~ for(size_t i = 0; i < PacketEnd + 4; i++) { printf("%.2X:", RxBuffer[i]); }
									//~ printf("\n\n");

									//strip the part of the line with the arguments to this command (chars following command) for compatibility with the  parsing code, the "params" officially start with the s/n
									const char* Params = reinterpret_cast<char*>(&(RxBuffer[PacketStart + Packet.PayloadOffset()]));

									//call the actual command
									//~ Cmds[Cmd].Response(Cmds[Cmd].Name, Params, Packet.PayloadLen(RxBuffer, RxCount, PacketStart), Argument);
									Cmds[i].Response(Cmds[i].Name, Params, Packet.PayloadLen(RxBuffer, RxCount, PacketStart), (void*)this);
									CmdFound = true;
									
									Processed = true;
								}
							}			
							
							//Did we do anything?
							if (!CmdFound)
							{
								//~ if (debug) { ::formatf("\n\nBinaryUart: Unmatched command 0x%.8lX!\n", PacketHeader->PayloadTypeToken); }
								if (debug) { ::formatf("\n\nBinaryUart: Unmatched command 0x%.8lX! NumCmds: %lu\n", Packet.PayloadType(RxBuffer, PacketStart, PacketEnd), (unsigned long)NumCmds); }
								
								Callbacks.UnHandledPacket(reinterpret_cast<IPacket*>(&RxBuffer[PacketStart]), PacketEnd - PacketStart);
							}
							else
							{
								if (debug) 
								{ 
									//~ ::formatf("\n\nBinaryUart: Got Packet! \n");
									//~ PacketHeader->formatf();
									//~ ::formatf(" <");
									//~ for (size_t k = PacketStart; k < PacketEnd; k++)
									//~ {
										//~ ::formatf(":%0.2X", RxBuffer[k]);
									//~ }
									//~ ::formatf(">\n\n\n");
								}								
							}
						}
						else 
						{ 
							if (debug) { ::formatf("\n\nBinaryUart: Packet received, but SerialNumber comparison failed (expected: 0x%.8lX; got: 0x%.8lX).\n", SerialNum, Packet.SerialNum(RxBuffer, PacketStart, PacketEnd)); } 
							
							Callbacks.UnHandledPacket(reinterpret_cast<IPacket*>(&RxBuffer[PacketStart]), PacketEnd - PacketStart);
						}
						
						//Now just let the user do whatever they want with it...
						Callbacks.EveryPacket(reinterpret_cast<IPacket*>(&RxBuffer[PacketStart]), PacketEnd - PacketStart);
					}
					else 
					{ 
						if (debug) { ::formatf("\n\nBinaryUart: Packet received, but invalid.\n"); } 
						
						Callbacks.InvalidPacket(reinterpret_cast<uint8_t*>(RxBuffer), RxCount);
					}
				
					//~ ::formatf("\n\nBinaryUart: PacketEnd. (%u, %u): ", PacketEnd, RxCount);
					//~ for(size_t i = PacketEnd - 4; i < RxCount; i++) { printf("%.2X:", RxBuffer[i]); }
					//~ printf("\n\n");
					
					InPacket = false;						
					
					if (RxCount > (PacketEnd + 4) )
					{
						size_t pos = 0;
						size_t clr = 0;
						for (; pos < (RxCount - (PacketEnd + 4)); pos++)
						{
							RxBuffer[pos] = RxBuffer[(PacketEnd + 4) + pos];
						}
						for (clr = pos; clr < RxCount; clr++)
						{
							RxBuffer[clr] = 0;
						}								
						RxCount = pos;
						//~ ::formatf("\n\nBinary Uart: PacketEnd. (%u, %u, %u): ", RxCount, (PacketEnd + 4), clr);
					}
					else
					{
						RxCount = 0;
						RxBuffer[0] = 0;
					}
				}
				else 
				{ 
					if ( ((Packet.PayloadLen(RxBuffer, RxCount, PacketStart)) > RxBufferLenBytes) || ((Packet.PayloadLen(RxBuffer, RxCount, PacketStart)) > Packet.MaxPayloadLength())  )
					{
						//~ if (debug) { ::formatf("\n\nBinaryUart: Short packet (%lu bytes) with unrealistic payload len; ignoring corrupted packet (should have been header(%lu) + payload(%lu) + footer(%lu).\n", RxCount, sizeof(BinaryPacketHeader), PacketHeader->PayloadLen, sizeof(BinaryPacketFooter)); } 
						if (debug) { ::formatf("\n\nBinaryUart: Short packet (%lu bytes) with unrealistic payload len; ignoring corrupted packet (should have been header() + payload(%lu) + footer().\n", RxCount, Packet.PayloadLen(RxBuffer, RxCount, PacketStart)); } 
						
						Callbacks.InvalidPacket(reinterpret_cast<uint8_t*>(RxBuffer), RxCount);
						
						InPacket = false;						
						RxCount = 0;
						RxBuffer[0] = 0;
					}
					else
					{
						if (debug) { ::formatf("\n\nBinaryUart: Short packet (%lu bytes); we'll assume the packet footer was part of the payload data and keep searching for the packet end (should have been header() + payload(%lu) + footer().\n", RxCount, Packet.PayloadLen(RxBuffer, RxCount, PacketStart)); } 
					}
				}
			}
			else { if (debug) { ::formatf("\n\nBinaryUart: Still waiting for packet end...\n"); } }
		}
		
		return(Processed);
    }
	
	void TxBinaryPacket(const uint16_t PayloadType, const uint32_t SerialNumber, const void* PayloadData, const size_t PayloadLen) const
	{
		uint8_t TxBuffer[TxBufferLenBytes];
		size_t PktLen = Packet.MakePacket(TxBuffer, TxBufferLenBytes, PayloadData, PayloadType, PayloadLen);
		for (size_t i = 0; i < PktLen; i++) { Pinout.putcqq(TxBuffer[i]); }
		::formatf("\n\nBinary Uart: Sending packet(%u, %u): ", PayloadType, PayloadLen);
		for(size_t i = 0; i < PktLen; i++) { printf("%.2X:", TxBuffer[i]); }
		printf("\n\n");

	}
	
	void formatf() const
	{
		::formatf("\n\nBinaryUart(%u, %c, %u): :", RxCount, InPacket?'Y':'N', PacketStart);
		for(size_t i = 0; i < RxCount; i++) { printf("%.2X:", RxBuffer[i]); }
		printf("\n\n");
	}
};

//Slightly ugly hack cause our CmdSystem is C, not C++, but whatever...
__inline__ void TxBinaryPacket(const void* TxPktContext, const uint16_t PayloadTypeToken, const uint32_t SerialNumber, const void* PayloadData, const size_t PayloadLen)
{
	if (NULL != TxPktContext) { reinterpret_cast<const BinaryUart*>(TxPktContext)->TxBinaryPacket(PayloadTypeToken, SerialNumber, PayloadData, PayloadLen); }
	else { ::formatf("\n\nTxBinaryPacket: NULL PacketContext! (Should be BinaryUart*) Please recompile this binary...\n"); }
};

/** \file
 * \brief UART interface for binary packet communication
 *
 * \ingroup uart
 **/

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
//~ #include "uart/IUartParser.hpp"

#include "cgraph/CGraphDMHardwareInterface.hpp"
extern CGraphDMHardwareInterface* DM;  // Contains a bunch of variables

/**
 * @struct BinaryUartCallbacks
 *
 * Handlers for specific packet events.
 *
 **/
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

/**
 * @struct BinaryUart
 *
 * BinaryUart manages a UART interface for binary packet communication.
 * It provides buffering for received bytes, detects packet boundaries, and processes
 * commands within received packets.
 *
 **/
struct BinaryUart// : IUartParser
{
    // Constants for initial values
    static const uint16_t LastDataLenInit = 0; 				///< Initial count for received bytes.
    static const size_t PacketStartPosInit = 0;
    static const size_t PacketLenInit = 0;
    static const size_t PayloadLenInit = 0;
    static const size_t HeaderLenInit = 0;
    static const size_t FooterLenInit = 0;
    static const bool InPacketInit = false; 			///< Default in-packet status.
    static const bool debugDefault = false;
    static const char EmptyBufferChar = '\0'; 			///< Character to fill empty buffer space.
    //~ static const size_t Data.DataLenBytes = 4096;
    static const size_t TxBufferLenBytes = 4096;
    static const uint64_t InvalidSerialNumber = 0xFFFFFFFFFFFFFFFFULL;

    size_t PacketEndPos = 0; 								///< Position of the detected packet end.

    //~ IUart& Pinout;										///< UART interface for data input.
	CircularFifoFlattened& Data;
    IPacket& Packet;									///< Packet structure for defining headers, footers, etc.
    const BinaryCmd* Cmds;								///< Array of commands
    size_t NumCmds;
    BinaryUartCallbacks& Callbacks;
    bool debug;
    bool InPacket;										///< Whether a packet is currently being processed.
    size_t PacketStartPos;
    size_t PacketLen;
    size_t PayloadLen;
    size_t HeaderLen;
    size_t FooterLen;
    uint64_t SerialNum;									///< Serial number for validating received packets.
	uint32_t LastDataLen;
	uint32_t PacketSearchedPos;
	
    /**
     * @brief Constructs a BinaryUart object and initializes with given parameters.
     *
     * @param pinout    UART interface to use for receiving data.
     * @param packet    Packet structure defining header, footer, and payload format.
     * @param cmds      Array of available commands.
     * @param numcmds   Number of commands in the cmds array.
     * @param callbacks Callback functions for handling packet events.
     * @param verbose   Enable or disable verbose debug mode.
     * @param serialnum Optional initial serial number, defaulting to InvalidSerialNumber.
     */
    BinaryUart(CircularFifoFlattened& data, struct IPacket& packet, const BinaryCmd* cmds, const size_t numcmds, struct BinaryUartCallbacks& callbacks, const bool verbose = true, const uint64_t serialnum = InvalidSerialNumber)
        :
        //~ Pinout(pinout),
		Data(data),
        Packet(packet),
        Cmds(cmds),
        NumCmds(numcmds),
        Callbacks(callbacks),
        debug(debugDefault),
        //debug(true),
        InPacket(InPacketInit),
        PacketStartPos(PacketStartPosInit),
        PacketLen(PacketLenInit),
        PayloadLen(PayloadLenInit),
        HeaderLen(HeaderLenInit),
        FooterLen(FooterLenInit),
        //~ Argument(argument),
        SerialNum(serialnum),
		LastDataLen(0),
		PacketSearchedPos(0)
		
    {
        Init(serialnum);
    }

    void Debug(bool dbg)
    {
        debug = dbg;
    }

    /**
     * @brief Initializes the BinaryUart
     *
     * Initializes the BinaryUart with the specified serial number and
     * resets the Rx buffer and other internal states. Called upon construction
     * and after buffer overflows or other packet error states.
     *
     * @param serialnum Serial number to initialize, used for packet validation.
     * @return int status code, 0 for success.
     */
    int Init(uint64_t serialnum)
    {
        SerialNum = serialnum;
        //~ LastDataLen = LastDataLenInit;
        PacketStartPos = PacketStartPosInit;
        PacketLen = PacketLenInit;
        PayloadLen = PayloadLenInit;
        HeaderLen = HeaderLenInit;
        FooterLen = FooterLenInit;
        InPacket = InPacketInit;
		LastDataLen = 0;
		PacketSearchedPos = 0;
        //~ memset(Data.Data, EmptyBufferChar, Data.DataLenBytes);

        if (debug)
        {
            ::formatf("\n\nBinary Uart: Init(PktH %u, PktF %u).\n\r", Packet.HeaderLen(), Packet.FooterLen());
        }

        return(0);
    }

    int InitFast(uint64_t serialnum)
    {
        SerialNum = serialnum;
        //~ LastDataLen = LastDataLenInit;
        PacketStartPos = PacketStartPosInit;
        PacketLen = PacketLenInit;
        PayloadLen = PayloadLenInit;
        HeaderLen = HeaderLenInit;
        FooterLen = FooterLenInit;
        InPacket = InPacketInit;
		LastDataLen = 0;
		PacketSearchedPos = 0;
        
        //memset(Data.Data, EmptyBufferChar, Data.DataLenBytes);

        //if (debug) { ::formatf("\n\nBinary Uart: Init(PktH %u, PktF %u).\n\r", Packet.HeaderLen(), Packet.FooterLen()); }

        return(0);
    }

    /**
     * @brief Processes incoming data and checks for new packets.
     *
     * Reads a new character if available, adds it to the Rx buffer, and checks
     * for packet boundaries (start and end).
     *
     * @return bool Returns true if data was processed, false if no new data.
     */
    bool Process()// override
    {
		bool Processed = false;

        //Of note: the DataLen should only grow as we process, since there is no other consumer removing bytes from the buffer, and we're not going to remove any until it overflows or we find the end of a packet.
		
        //New char?
		size_t DataLen = Data.Depth();
		if (LastDataLen == DataLen) { return(false); }
		int32_t NewDataLen = DataLen - LastDataLen;
		if (NewDataLen < 0) { NewDataLen = 0; }
		LastDataLen = DataLen;
		if (0 == LastDataLen) { return(false); }
				
		//Packet End?? We have nothing to do until we have the end of a packet!
		//Need at least a Footer's worth of data...
		if (LastDataLen >= Packet.FooterLen())
		{
			//Where do we start searching for the Footer?
			int32_t FooterSearchStartPos = LastDataLen - NewDataLen;
			FooterSearchStartPos -= Packet.FooterLen(); //If we just got the final byte(s) of the footer, we need to look behind in the buffer from the start of the new data to actually find the footer!
			if (FooterSearchStartPos < 0) { FooterSearchStartPos = 0; } //But that could underrun the buffer so we truncate...
			
			//Did we get it??
			if (Packet.FindPacketEndPos(Data.Data, FooterSearchStartPos, LastDataLen, PacketEndPos))
			{
				//Oh, things just got interesting!
				
				//	if (debug) { ::formatf("\n\nBinaryUart: Packet end detected! Searching for start...\n\r"); }
				//~ InPacket = true;
				
				if (Packet.FindPacketStartPos(Data.Data, LastDataLen, PacketStartPos))
				{
					//Oh, now things just got really really interesting!!
					PayloadLen = Packet.PayloadLen(Data.Data, LastDataLen, PacketStartPos);
					HeaderLen = Packet.HeaderLen();
					FooterLen = Packet.FooterLen();
					
					// Validate packet
					if (Packet.IsValid(Data.Data, LastDataLen, PacketStartPos, PacketEndPos))
					{
						// Confirm that the serial number matches or is a broadcast
						if ( (SerialNum == InvalidSerialNumber) || (Packet.IsBroadcastSerialNum(Data.Data, PacketStartPos, PacketEndPos)) || (SerialNum == Packet.SerialNum(Data.Data, PacketStartPos, PacketEndPos)) )
						{
							// Just look at each command, and exectute it if the input line matches.
							bool CmdFound = false;

							// Search for a matching command in the packet
							// Inefficient to go through whole list of commands
							// Idea: last nibble or byte (depending on number of commands) corresponds to position of command
							// and can be used as index to Cmds[i].Response(...)
							// This only happens once for each full packet, so might not be much time savings
							//for (size_t i = 0; i < NumCmds; i++)
							//{
							size_t ii = Packet.PayloadType(Data.Data, LastDataLen, PacketStartPos) & 0x0F;
							// Check if command in buffer matches the defined command name
							if (Packet.DoesPayloadTypeMatch(Data.Data, LastDataLen, PacketStartPos, PacketEndPos, Cmds[ii].Name))
							{
								//strip the part of the line with the arguments to this command (chars following command) for compatibility with the  parsing code, the "params" officially start with the s/n
								//const char* Params = reinterpret_cast<char*>(&(Data.Data[PacketStartPos + Packet.PayloadOffset()]));
								const char* Params = reinterpret_cast<char*>(&(Data.Data[PacketStartPos + HeaderLen]));
								// Execute the command's response function
								// We already figured out the payload length, so we don't need to call Packet.PayloadLen
								// to get it again.  Comment out and use simpler Cmds[i].Respons(...) below
								//Cmds[i].Response(Cmds[i].Name, Params, Packet.PayloadLen(Data.Data, LastDataLen, PacketStartPos), (void*)this);
								Cmds[ii].Response(Cmds[ii].Name, Params, PayloadLen, (void*)this);
								CmdFound = true;
								Processed = true;
							}
							//}

							// If no command was found, trigger the unhandled packet callback
							if (!CmdFound)
							{
								//~ if (debug) { ::formatf("\n\nBinaryUart: Unmatched command 0x%.8lX!\n", PacketHeader->PayloadTypeToken); }
								if (debug)
								{
									::formatf("\n\nBinaryUart: Unmatched command 0x%.8lX! NumCmds: %lu\n", Packet.PayloadType(Data.Data, PacketStartPos, PacketEndPos), (unsigned long)NumCmds);
								}

								Callbacks.UnHandledPacket(reinterpret_cast<IPacket*>(&Data.Data[PacketStartPos]), PacketEndPos - PacketStartPos);
							}
							else
							{
								if (debug)
								{
									//~ ::formatf("\n\nBinaryUart: Got Packet! \n");
									//~ PacketHeader->formatf();
									//~ ::formatf(" <");
									//~ for (size_t k = PacketStartPos; k < PacketEndPos; k++)
									//~ {
									//~ ::formatf(":%0.2X", Data.Data[k]);
									//~ }
									//~ ::formatf(">\n\n\n");
								}
							}
						}
						else
							// If serial number does not match, packet is unhandled
						{
							if (debug)
							{
								::formatf("\n\nBinaryUart: Packet received, but SerialNumber comparison failed (expected: 0x%.8lX; got: 0x%.8lX).\n\r", SerialNum, Packet.SerialNum(Data.Data, PacketStartPos, PacketEndPos));
							}

							Callbacks.UnHandledPacket(reinterpret_cast<IPacket*>(&Data.Data[PacketStartPos]), PacketEndPos - PacketStartPos);
						}

						// Notify that every packet is processed, even if unmatched
						Callbacks.EveryPacket(reinterpret_cast<IPacket*>(&Data.Data[PacketStartPos]), PacketEndPos - PacketStartPos);
						
						//Ok, now we have to figure out how to remove the packet from the buffer...
						Data.Pop(PacketEndPos);
				        //~ InitFast(SerialNum);
					}
					else
					// If packet is invalid, trigger the invalid packet callback
					{
						if (debug)
						{
							::formatf("\n\nBinaryUart: Packet received, but invalid.\n\r");
						}

						Callbacks.InvalidPacket(reinterpret_cast<uint8_t*>(Data.Data), LastDataLen);
					}

				}
			}
		}
		
        return(true); //We just want to know if there's chars in the buffer to put threads to sleep or not...
    }

    /**
     * @brief Transmit a binary packet over UART.
     *
     * Constructs a binary packet using the specified payload type, serial number,
     * and payload data, and transmits it byte-by-byte over UART.
     *
     * @param PayloadType The type identifier for the packet. This distinguishes different commands in the packet.
     * @param SerialNumber The unique serial number for this packet.
     * @param PayloadData A pointer to the data to be transmitted as the packet payload.
     * @param PayloadLen The length of the payload data in bytes.
     */
    virtual void TxBinaryPacket(const uint16_t PayloadType, const uint32_t SerialNumber, const void* PayloadData, const size_t PayloadLen) const
    {
        uint8_t TxBuffer[TxBufferLenBytes]; ///< Temporary buffer to hold the constructed packet
        size_t PktLen = Packet.MakePacket(TxBuffer, TxBufferLenBytes, PayloadData, PayloadType, PayloadLen); ///< Build packet

        // Transmit each byte of the packet through the UART pinout
        for (size_t i = 0; i < PktLen; i++)
        {
            Pinout.putcqq(TxBuffer[i]);
        }

        // Debug output: log the packet type, length, and contents in hex format
        if (debug)
        {
            ::formatf("\n\nBinary Uart: Sending packet(%u, %u): ", PayloadType, PayloadLen);
            for(size_t i = 0; i < PktLen; i++)
            {
                printf("%.2X:", TxBuffer[i]);
            }
            printf("\n\n");
        }
    }

    void formatf() const
    {
        ::formatf("\n\nBinaryUart(%u, %c, %u): :", LastDataLen, InPacket?'Y':'N', PacketStartPos);
        for(size_t i = 0; i < LastDataLen; i++)
        {
            printf("%.2X:", Data.Data[i]);
        }
        printf("\n\n");
    }
};

//Slightly ugly hack cause our CmdSystem is C, not C++, but whatever...

__inline__ void TxBinaryPacket(const void* TxPktContext, const uint16_t PayloadTypeToken, const uint32_t SerialNumber, const void* PayloadData, const size_t PayloadLen)
{
    if (NULL != TxPktContext)
    {
        reinterpret_cast<const BinaryUart*>(TxPktContext)->TxBinaryPacket(PayloadTypeToken, SerialNumber, PayloadData, PayloadLen);
    }
    else
    {
        ::formatf("\n\nTxBinaryPacket: NULL PacketContext! (Should be BinaryUart*) Please recompile this binary...\n\r");
    }
};

void TxBinaryPacket(const void* TxPktContext, const uint16_t PayloadTypeToken, const uint32_t SerialNumber, const void* PayloadData, const size_t PayloadLen);


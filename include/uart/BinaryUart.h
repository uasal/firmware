/** \file
 * \brief UART interface for binary packet communication
 *
 * \ingroup uart
 **/

#pragma once

#include <stdio.h>
#include <stdarg.h>
#include <stdint.h>

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

//Slightly ugly hack cause our CmdSystem is C, not C++, but whatever...
void TxBinaryPacket(const void* TxPktContext, const uint16_t PayloadTypeToken, const uint32_t SerialNumber, const void* PayloadData, const size_t PayloadLength);

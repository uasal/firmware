//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
//

#include "uart/UartParserTable.hpp"

#include "cgraph/CGraphFWHardwareInterface.hpp"

#include "format/formatf.h"

#include "uart/BinaryUart.hpp"

#include "uart/uart_pinout_fpga.hpp"

#include "cgraph/CGraphPacket.hpp"

#include "uart/TerminalUart.hpp"

#include "Uarts.hpp"

#include "CmdTableAscii.hpp"

#include "CmdTableBinary.hpp"

char prompt[] = "\n\nESC-FW> ";
const char* TerminalUartPrompt()
{
    return(prompt);
}

uart_pinout_fpga FPGAUartPinout0(&(FW->UartStatusRegister0), &(FW->UartFifo0), &(FW->UartFifo0ReadData), &(FW->UartFifo0), '~');
uart_pinout_fpga FPGAUartPinout1(&(FW->UartStatusRegister1), &(FW->UartFifo1), &(FW->UartFifo1ReadData), &(FW->UartFifo1), '!');
uart_pinout_fpga FPGAUartPinout2(&(FW->UartStatusRegister2), &(FW->UartFifo2), &(FW->UartFifo2ReadData), &(FW->UartFifo2), '@');
uart_pinout_fpga FPGAUartPinout3(&(FW->UartStatusRegister3), &(FW->UartFifo3), &(FW->UartFifo3ReadData), &(FW->UartFifo3), '#');
uart_pinout_fpga FPGAUartPinoutUsb(&(FW->UartStatusRegisterUsb), &(FW->UartFifoUsb), &(FW->UartFifoUsbReadData), &(FW->UartFifoUsb), '$');

struct FPGABinaryUartCallbacks : public BinaryUartCallbacks
{
	FPGABinaryUartCallbacks() { }
	virtual ~FPGABinaryUartCallbacks() { }
	
	//Malformed/corrupted packet handler:
	virtual void InvalidPacket(const uint8_t* Buffer, const size_t& BufferLen) override
	{ 
		if ( (nullptr == Buffer) || (BufferLen < 1) ) { formatf("\nFPGAUartCallbacks: NULL(%u) InvalidPacket!\n\n", BufferLen); return; }
	
		size_t len = BufferLen;
		if (len > 32) { len = 32; }
		formatf("\nFPGAUartCallbacks: InvalidPacket! contents: :");
		for(size_t i = 0; i < len; i++) { formatf("%.2X:", Buffer[i]); }
		formatf("\n\n");
	}
	
	//Packet with no matching command handler:
	virtual void UnHandledPacket(const IPacket* Packet, const size_t& PacketLen) override
	{ 
		if ( (nullptr == Packet) || (PacketLen < sizeof(CGraphPacketHeader)) ) { formatf("\nFPGABinaryUartCallbacks: NULL(%u) UnHandledPacket!\n\n", PacketLen); return; }
		
		const CGraphPacketHeader* Header = reinterpret_cast<const CGraphPacketHeader*>(Packet);
		formatf("\nFPGAUartCallbacks: Unhandled packet(%u): ", PacketLen);
		Header->formatf();
		formatf("\n\n");
	}
	
	//In case we need to look at every packet that goes by...
	//~ virtual void EveryPacket(const IPacket& Packet, const size_t& PacketLen) override { }
	
	//We just wanna see if this is happening, not much to do about it
	virtual void BufferOverflow(const uint8_t* Buffer, const size_t& BufferLen) override
	{ 
		//~ formatf("\nFPGABinaryUartCallbacks: BufferOverflow(%zu)!\n", BufferLen);
	}

} BinaryPacketCallbacks;

CGraphPacket FPGAUartProtocol;

//~ BinaryUart(struct IUart& pinout, struct IPacket& packet, const Cmd* cmds, const size_t numcmds, struct BinaryUartCallbacks& callbacks, const bool verbose = true, const uint64_t serialnum = InvalidSerialNumber);

//~ (ascii instead) BinaryUart FpgaUartParser0(FPGAUartPinout0, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, BinaryPacketCallbacks, false);
BinaryUart FpgaUartParser1(FPGAUartPinout1, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, BinaryPacketCallbacks, false);
BinaryUart FpgaUartParser2(FPGAUartPinout2, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, BinaryPacketCallbacks, false);
BinaryUart FpgaUartParser3(FPGAUartPinout3, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, BinaryPacketCallbacks, false);
//~ (ascii instead) BinaryUart FpgaUartParserUsb(FPGAUartPinoutUsb, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, BinaryPacketCallbacks, false);
TerminalUart<16, 4096> DbgUartUsb(FPGAUartPinoutUsb, AsciiCmds, NumAsciiCmds, &TerminalUartPrompt, NoRTS, NoPrefix, false);
TerminalUart<16, 4096> DbgUart485_0(FPGAUartPinout0, AsciiCmds, NumAsciiCmds, &TerminalUartPrompt, NoRTS, NoPrefix, false);

IUartParser* const UartParsers[] =
{
	&FpgaUartParser1,
	&FpgaUartParser2,
	&FpgaUartParser3,
	&DbgUartUsb,
	&DbgUart485_0,	
};
const uint8_t NumUartParsers = sizeof(UartParsers) / sizeof(UartParsers[0]);

BinaryUart* const BinaryUartParsers[] =
{
	&FpgaUartParser1,
	&FpgaUartParser2,
	&FpgaUartParser3,
};
const uint8_t NumBinaryUartParsers = sizeof(BinaryUartParsers) / sizeof(BinaryUartParsers[0]);

TerminalUart<16, 4096>* const AsciiUartParsers[] =
{
	&DbgUartUsb,
	&DbgUart485_0,	
};
const uint8_t NumAsciiUartParsers = sizeof(AsciiUartParsers) / sizeof(AsciiUartParsers[0]);

void ProcessAllUarts()
{	
	for (size_t i = 0; i < NumUartParsers; i++)
	{
		if (nullptr != UartParsers[i]) { UartParsers[i]->Process(); }
	}
}

extern "C"
{	
	//This code is to make "syscalls.c" replace vendor's "newlib_stubs.c" and make printf() and friends connect to a real serial port in our actual hardware! Only useful if we can compile our own code from makefile and replace vendor's "softconsole" version...
	//It is also used in a similar fashion by the "formatf" library
	int stdio_hook_putc(int c) 
	{ 
		FPGAUartPinout0.putcqq(c); 
		FPGAUartPinoutUsb.putcqq(c);
		return(c);
	}
};

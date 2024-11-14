//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
//

#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <algorithm>

#include "Delay.h"

#include "cgraph/CGraphPacket.hpp"

#include "cgraph/CGraphFSMHardwareInterface.hpp"
CGraphFSMHardwareInterface* FSM = NULL;

#include "format/formatf.h"

#include "CmdTableAscii.hpp"

#include "CmdTableBinary.hpp"

#include "uart/BinaryUart.hpp"

#include "uart/uart_pinout_fpga.hpp"

struct FPGABinaryUartCallbacks : public BinaryUartCallbacks
{
	FPGABinaryUartCallbacks() { }
	virtual ~FPGABinaryUartCallbacks() { }
	
	//Malformed/corrupted packet handler:
	virtual void InvalidPacket(const uint8_t* Buffer, const size_t& BufferLen)
	{ 
		if ( (NULL == Buffer) || (BufferLen < 1) ) { formatf("\nFPGAUartCallbacks: NULL(%u) InvalidPacket!\n\n", BufferLen); return; }
	
		size_t len = BufferLen;
		if (len > 32) { len = 32; }
		formatf("\nFPGAUartCallbacks: InvalidPacket! contents: :");
		for(size_t i = 0; i < len; i++) { formatf("%.2X:", Buffer[i]); }
		formatf("\n\n");
	}
	
	//Packet with no matching command handler:
	virtual void UnHandledPacket(const IPacket* Packet, const size_t& PacketLen)
	{ 
		if ( (NULL == Packet) || (PacketLen < sizeof(CGraphPacketHeader)) ) { formatf("\nFPGABinaryUartCallbacks: NULL(%u) UnHandledPacket!\n\n", PacketLen); return; }
		
		const CGraphPacketHeader* Header = reinterpret_cast<const CGraphPacketHeader*>(Packet);
		formatf("\nFPGAUartCallbacks: Unhandled packet(%u): ", PacketLen);
		Header->formatf();
		formatf("\n\n");
	}
	
	//In case we need to look at every packet that goes by...
	//~ virtual void EveryPacket(const IPacket& Packet, const size_t& PacketLen) { }
	
	//We just wanna see if this is happening, not much to do about it
	virtual void BufferOverflow(const uint8_t* Buffer, const size_t& BufferLen) 
	{ 
		//~ formatf("\nFPGABinaryUartCallbacks: BufferOverflow(%zu)!\n", BufferLen);
	}

} BinaryPacketCallbacks;

CGraphPacket FPGAUartProtocol;
uart_pinout_fpga FPGAUartPinout0(&(FSM->UartStatusRegister0), &(FSM->UartFifo0), &(FSM->UartFifo0ReadData), &(FSM->UartFifo0), '~');
uart_pinout_fpga FPGAUartPinout1(&(FSM->UartStatusRegister1), &(FSM->UartFifo1), &(FSM->UartFifo1ReadData), &(FSM->UartFifo1), '!');
uart_pinout_fpga FPGAUartPinout2(&(FSM->UartStatusRegister2), &(FSM->UartFifo2), &(FSM->UartFifo2ReadData), &(FSM->UartFifo2), '@');
uart_pinout_fpga FPGAUartPinout3(&(FSM->UartStatusRegister3), &(FSM->UartFifo3), &(FSM->UartFifo3ReadData), &(FSM->UartFifo3), '#');
uart_pinout_fpga FPGAUartPinoutUsb(&(FSM->UartStatusRegisterLab), &(FSM->UartFifoLab), &(FSM->UartFifoLabReadData), &(FSM->UartFifoLab), '$');

//~ BinaryUart(struct IUart& pinout, struct IPacket& packet, const Cmd* cmds, const size_t numcmds, struct BinaryUartCallbacks& callbacks, const bool verbose = true, const uint64_t serialnum = InvalidSerialNumber);
BinaryUart FpgaUartParser3(FPGAUartPinout1, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, BinaryPacketCallbacks, false);
BinaryUart FpgaUartParser2(FPGAUartPinout2, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, BinaryPacketCallbacks, false);
BinaryUart FpgaUartParser1(FPGAUartPinout1, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, BinaryPacketCallbacks, false);
//~ (ascii instead) BinaryUart FpgaUartParser0(FPGAUartPinout1, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, BinaryPacketCallbacks, false);
//~ (ascii instead) BinaryUart FpgaUartParserUsb(FPGAUartPinoutUsb, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, BinaryPacketCallbacks, false);

#include "uart/TerminalUart.hpp"
char prompt[] = "\n\nESC-FSM> ";
const char* TerminalUartPrompt()
{
    return(prompt);
}
//Handle incoming ascii cmds & binary packets from the usb
TerminalUart<16, 4096> DbgUartUsb(FPGAUartPinoutUsb, AsciiCmds, NumAsciiCmds, &TerminalUartPrompt, NoRTS, NoPrefix, false);
TerminalUart<16, 4096> DbgUart485_0(FPGAUartPinout0, AsciiCmds, NumAsciiCmds, &TerminalUartPrompt, NoRTS, NoPrefix, false);

#include "../MonitorAdc.hpp"
extern CGraphFSMMonitorAdc MonitorAdc;

//Enable this if malloc problems occur (!!we shouldn't be using malloc, but c-libraries sometimes link it in!!)
//~ class MTracer
//~ {
//~ public:

//~ MTracer()
//~ {
//~ putenv("MALLOC_TRACE=/home/root/FSMTrace.txt");
//~ mtrace(); /* Starts the recording of memory allocations and releases */
//~ }
//~ } mtracer;

extern "C"
{	
	unsigned long long fclk_for_delay_loops = 102000000;

	//This code is to make "syscalls.c" replace vendor's "newlib_stubs.c" and make printf() and friends connect to a real serial port in our actual hardware! Only useful if we can compile our own code from makefile and replace vendor's "softconsole" version...
	int stdio_hook_putc(int c) 
	{ 
		FPGAUartPinout0.putcqq(c); 
		FPGAUartPinoutUsb.putcqq(c);
		return(c);
	}

    void wooinit(void) __attribute__((constructor));

	//Does the current clib need this?
    void AtExit()
    {
        //~ mwTerm();
    }

	//Does the current clib need this?
    void mwOutFunc(int c)
    {
        putchar(c);
    }
};

bool Process()
{
    bool Bored = true;
	
	MonitorAdc.Process();
	
	//Enable this if we need to debug ascii and binary on the same uart (note: madness ensues!)
	//~ {
		//~ if (FPGAUartPinoutUsb.dataready())
		//~ {
			//~ Bored = false;
			
			//~ char c = FPGAUartPinoutUsb.getcqq();
			
			//~ UsbUartAscii.remoteputcqq(c);
			//~ UsbUartBinary.remoteputcqq(c);
		//~ }
		//~ if (UsbUartAscii.remotedataready()) { FPGAUartPinoutUsb.putcqq(UsbUartAscii.remotegetcqq()); }
		//~ if (UsbUartBinary.remotedataready()) { FPGAUartPinoutUsb.putcqq(UsbUartBinary.remotegetcqq()); }
	//~ }
	
    if (FpgaUartParser3.Process()) { Bored = false; }    
	if (FpgaUartParser2.Process()) { Bored = false; }    
	if (FpgaUartParser1.Process()) { Bored = false; }    
	//~ if (FpgaUartParser0.Process()) { Bored = false; }    
	//~ if (FpgaUartParserUsb.Process()) { Bored = false; }    
	if (DbgUartUsb.Process()) { Bored = false; }    
    if (DbgUart485_0.Process()) { Bored = false; }
	
    return(Bored);
}

void ProcessAllUarts()
{
	FpgaUartParser3.Process();
	FpgaUartParser2.Process();
	FpgaUartParser1.Process();
	//~ FpgaUartParser0.Process();
	//~ FpgaUartParserUsb.Process();
	DbgUartUsb.Process();
	DbgUart485_0.Process();
}

int main(int argc, char *argv[])
{	
    //Tell C lib (stdio.h) not to buffer output, so we can ditch all the fflush(stdout) calls...
    //~ setvbuf(stdout, NULL, _IONBF, 0);

    //~ if (argc > 2)

	FPGAUartPinoutUsb.putcqq('\n');
	FPGAUartPinoutUsb.putcqq('\n');
	FPGAUartPinoutUsb.putcqq('\n');
	FPGAUartPinoutUsb.putcqq('\n');
	FPGAUartPinoutUsb.putcqq('\n');
	FPGAUartPinoutUsb.putcqq('\n');
	FPGAUartPinoutUsb.putcqq('\n');
	FPGAUartPinoutUsb.putcqq('\n');
	FPGAUartPinoutUsb.putcqq('\n');
	FPGAUartPinoutUsb.putcqq('H');
	FPGAUartPinoutUsb.putcqq('e');
	FPGAUartPinoutUsb.putcqq('l');
	FPGAUartPinoutUsb.putcqq('l');
	FPGAUartPinoutUsb.putcqq('o');
	FPGAUartPinoutUsb.putcqq(' ');
	FPGAUartPinoutUsb.putcqq('E');
    FPGAUartPinoutUsb.putcqq('S');
    FPGAUartPinoutUsb.putcqq('C');
    FPGAUartPinoutUsb.putcqq('-');
    FPGAUartPinoutUsb.putcqq('F');
    FPGAUartPinoutUsb.putcqq('S');
	FPGAUartPinoutUsb.putcqq('M');
	FPGAUartPinoutUsb.putcqq('\n');

    extern unsigned long __vector_table_start;
    extern unsigned long _evector_table;
    extern unsigned long __text_start;
    extern unsigned long _etext;
    extern unsigned long __exidx_start;
    extern unsigned long __exidx_end;
    extern unsigned long __data_start;
    extern unsigned long _edata;
    extern unsigned long __bss_start__;
    extern unsigned long _ebss;
    extern unsigned long __heap_start__;
    extern unsigned long _eheap;
    extern unsigned long __stack_start__;
	extern unsigned long _estack;
	extern unsigned long _end;	
    register char * stack_ptr asm ("sp");
	
	formatf("\nBuild parameters: \n");
    formatf("__vector_table_start: 0x%.8lX\n", (uint32_t)__vector_table_start);
    formatf("_evector_table: 0x%.8lX\n", (uint32_t)_evector_table);
    formatf("__text_start: 0x%.8lX\n", (uint32_t)__text_start);
    formatf("_etext: 0x%.8lX\n", (uint32_t)_etext);
    formatf("__exidx_start: 0x%.8lX\n", (uint32_t)__exidx_start);
    formatf("__exidx_end: 0x%.8lX\n", (uint32_t)__exidx_end);
    formatf("__data_start: 0x%.8lX\n", (uint32_t)__data_start);
    formatf("_edata: 0x%.8lX\n", (uint32_t)_edata);
    formatf("__bss_start__: 0x%.8lX\n", (uint32_t)__bss_start__);
    formatf("_ebss: 0x%.8lX\n", (uint32_t)_ebss);
    formatf("__heap_start__: 0x%.8lX\n", (uint32_t)__heap_start__);
    formatf("_eheap: 0x%.8lX\n", (uint32_t)_eheap);
    formatf("__stack_start__: 0x%.8lX\n", (uint32_t)__stack_start__);
    formatf("_estack: 0x%.8lX\n", (uint32_t)_estack);
    formatf("stack pointer: 0x%.8lX\n", (uint32_t)stack_ptr);
    formatf("_end: 0x%.8lX\n", (uint32_t)_end);
    formatf("\n\n");

	formatf("\n\nESC-FSM: v%s.b%s; Offset of ControlRegister: 0x%.2lX, expected: 0x%.2lX.", GITVERSION, BUILDNUM, (unsigned long)offsetof(CGraphFSMHardwareInterface, ControlRegister), 32UL);
	
	formatf("\nOffset of UartFifoUsb: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFSMHardwareInterface, UartFifoLab), 164UL);
	formatf("\nOffset of UartFifoUsbReadData: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFSMHardwareInterface, UartFifoLabReadData), 172UL);

	DbgUartUsb.Init();
	DbgUart485_0.Init();

    DbgUartUsb.SetEcho(false);
    DbgUart485_0.SetEcho(false);
	
	//~ MonitorAdc.SetMonitor(true);
	MonitorAdc.SetMonitor(false);
	MonitorAdc.Init();
	
	//~ uint8_t i = 0;
    while(true)
    {
		Process();
    }

    return(0);
}

//EOF

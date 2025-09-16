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

#include "arm/BuildParameters.h"

#include "cgraph/CGraphPacket.hpp"

#include "cgraph/CGraphFSMHardwareInterface.hpp"
extern CGraphFSMHardwareInterface* volatile FSM;

#include "format/formatf.h"

#include "CmdTableAscii.hpp"

//~ #include "CmdTableBinary.hpp"

//~ #include "uart/BinaryUart.hpp"

#include "uart/uart_pinout_fpga.hpp"

//~ struct FPGABinaryUartCallbacks : public BinaryUartCallbacks
//~ {
	//~ FPGABinaryUartCallbacks() { }
	//~ virtual ~FPGABinaryUartCallbacks() { }
	
	//~ //Malformed/corrupted packet handler:
	//~ virtual void InvalidPacket(const uint8_t* Buffer, const size_t& BufferLen)
	//~ { 
		//~ if ( (NULL == Buffer) || (BufferLen < 1) ) { formatf("\nFPGAUartCallbacks: NULL(%u) InvalidPacket!\n\n", BufferLen); return; }
	
		//~ size_t len = BufferLen;
		//~ if (len > 32) { len = 32; }
		//~ formatf("\nFPGAUartCallbacks: InvalidPacket! contents: :");
		//~ for(size_t i = 0; i < len; i++) { formatf("%.2X:", Buffer[i]); }
		//~ formatf("\n\n");
	//~ }
	
	//~ //Packet with no matching command handler:
	//~ virtual void UnHandledPacket(const IPacket* Packet, const size_t& PacketLen)
	//~ { 
		//~ if ( (NULL == Packet) || (PacketLen < sizeof(CGraphPacketHeader)) ) { formatf("\nFPGABinaryUartCallbacks: NULL(%u) UnHandledPacket!\n\n", PacketLen); return; }
		
		//~ const CGraphPacketHeader* Header = reinterpret_cast<const CGraphPacketHeader*>(Packet);
		//~ formatf("\nFPGAUartCallbacks: Unhandled packet(%u): ", PacketLen);
		//~ Header->formatf();
		//~ formatf("\n\n");
	//~ }
	
	//~ //In case we need to look at every packet that goes by...
	//~ //virtual void EveryPacket(const IPacket& Packet, const size_t& PacketLen) { }
	
	//~ //We just wanna see if this is happening, not much to do about it
	//~ virtual void BufferOverflow(const uint8_t* Buffer, const size_t& BufferLen) 
	//~ { 
		//~ //formatf("\nFPGABinaryUartCallbacks: BufferOverflow(%zu)!\n", BufferLen);
	//~ }

//~ } BinaryPacketCallbacks;

CGraphPacket FPGAUartProtocol;
uart_pinout_fpga FPGAUartPinout0(&(FSM->UartStatusRegister0), &(FSM->UartFifo0), &(FSM->UartFifo0ReadData), &(FSM->UartFifo0), '~');
uart_pinout_fpga FPGAUartPinout1(&(FSM->UartStatusRegister1), &(FSM->UartFifo1), &(FSM->UartFifo1ReadData), &(FSM->UartFifo1), '!');
uart_pinout_fpga FPGAUartPinout2(&(FSM->UartStatusRegister2), &(FSM->UartFifo2), &(FSM->UartFifo2ReadData), &(FSM->UartFifo2), '@');
uart_pinout_fpga FPGAUartPinout3(&(FSM->UartStatusRegister3), &(FSM->UartFifo3), &(FSM->UartFifo3ReadData), &(FSM->UartFifo3), '#');
//~ uart_pinout_fpga FPGAUartPinout0(&(FSM->UartStatusRegisterLab), &(FSM->UartFifoLab), &(FSM->UartFifoLabReadData), &(FSM->UartFifoLab), '$');

//~ BinaryUart(struct IUart& pinout, struct IPacket& packet, const Cmd* cmds, const size_t numcmds, struct BinaryUartCallbacks& callbacks, const bool verbose = true, const uint64_t serialnum = InvalidSerialNumber);
//~ BinaryUart FpgaUartParser3(FPGAUartPinout1, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, BinaryPacketCallbacks, false);
//~ BinaryUart FpgaUartParser2(FPGAUartPinout2, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, BinaryPacketCallbacks, false);
//~ BinaryUart FpgaUartParser1(FPGAUartPinout1, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, BinaryPacketCallbacks, false);
//~ (ascii instead) BinaryUart FpgaUartParser0(FPGAUartPinout1, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, BinaryPacketCallbacks, false);
//~ (ascii instead) BinaryUart FpgaUartParserUsb(FPGAUartPinout0, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, BinaryPacketCallbacks, false);

#include "uart/TerminalUart.hpp"
char prompt[] = "\n\nESC-FSM> ";
const char* TerminalUartPrompt()
{
    return(prompt);
}
//Handle incoming ascii cmds & binary packets from the usb
//TerminalUart<16, 4096> DbgUartUsb(FPGAUartPinout0, AsciiCmds, NumAsciiCmds, &TerminalUartPrompt, NoRTS, NoPrefix, false);
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
		//~ FPGAUartPinout0.putcqq(c);
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
	
	//~ MonitorAdc.Process();
	
	//Enable this if we need to debug ascii and binary on the same uart (note: madness ensues!)
	//~ {
		//~ if (FPGAUartPinout0.dataready())
		//~ {
			//~ Bored = false;
			
			//~ char c = FPGAUartPinout0.getcqq();
			
			//~ UsbUartAscii.remoteputcqq(c);
			//~ UsbUartBinary.remoteputcqq(c);
		//~ }
		//~ if (UsbUartAscii.remotedataready()) { FPGAUartPinout0.putcqq(UsbUartAscii.remotegetcqq()); }
		//~ if (UsbUartBinary.remotedataready()) { FPGAUartPinout0.putcqq(UsbUartBinary.remotegetcqq()); }
	//~ }
	
    //~ if (FpgaUartParser3.Process()) { Bored = false; }    
	//~ if (FpgaUartParser2.Process()) { Bored = false; }    
	//~ if (FpgaUartParser1.Process()) { Bored = false; }    
	//~ //if (FpgaUartParser0.Process()) { Bored = false; }    
	//~ //if (FpgaUartParserUsb.Process()) { Bored = false; }    
	//~ //if (DbgUartUsb.Process()) { Bored = false; }    
    if (DbgUart485_0.Process()) { Bored = false; }
	
    return(Bored);
}

void ProcessAllUarts()
{
	//~ FpgaUartParser3.Process();
	//~ FpgaUartParser2.Process();
	//~ FpgaUartParser1.Process();
	//~ //FpgaUartParser0.Process();
	//~ //FpgaUartParserUsb.Process();
	//~ //DbgUartUsb.Process();
	DbgUart485_0.Process();
}

int main(int argc, char *argv[])
{	
    //Tell C lib (stdio.h) not to buffer output, so we can ditch all the fflush(stdout) calls...
    //~ setvbuf(stdout, NULL, _IONBF, 0);

    //~ if (argc > 2)

	FPGAUartPinout0.putcqq('\n');
	FPGAUartPinout0.putcqq('\n');
	FPGAUartPinout0.putcqq('\n');
	FPGAUartPinout0.putcqq('\n');
	FPGAUartPinout0.putcqq('\n');
	FPGAUartPinout0.putcqq('\n');
	FPGAUartPinout0.putcqq('\n');
	FPGAUartPinout0.putcqq('\n');
	FPGAUartPinout0.putcqq('\n');
	FPGAUartPinout0.putcqq('H');
	FPGAUartPinout0.putcqq('e');
	FPGAUartPinout0.putcqq('l');
	FPGAUartPinout0.putcqq('l');
	FPGAUartPinout0.putcqq('o');
	FPGAUartPinout0.putcqq(' ');
	FPGAUartPinout0.putcqq('E');
    FPGAUartPinout0.putcqq('S');
    FPGAUartPinout0.putcqq('C');
    FPGAUartPinout0.putcqq('-');
    FPGAUartPinout0.putcqq('F');
    FPGAUartPinout0.putcqq('S');
	FPGAUartPinout0.putcqq('M');
	FPGAUartPinout0.putcqq('\n');

	//~ formatf("\n\nESC-FSM: v%s.b%s; Offset of ControlRegister: 0x%.2lX, expected: 0x%.2lX.", GITVERSION, BUILDNUM, (unsigned long)offsetof(CGraphFSMHardwareInterface, ControlRegister), 32UL);
	
	//~ ShowBuildParameters();

	//~ formatf("\nUartFifo3: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFSMHardwareInterface, UartFifo3), 152UL);
	//~ formatf("\nOffset of FSM->ControlRegister: 0x%.2lX, expected: 0x%.2lX; size: %lu.", (unsigned long)offsetof(CGraphFSMHardwareInterface, ControlRegister), 32UL, sizeof(CGraphFSMHardwareControlRegister));

	//~ DbgUartUsb.Init();
	DbgUart485_0.Init();

    //~ DbgUartUsb.SetEcho(false);
    DbgUart485_0.SetEcho(false);
	
	//~ MonitorAdc.SetMonitor(true);
	//~ MonitorAdc.SetMonitor(false);
	//~ MonitorAdc.Init();
	
	//~ uint8_t i = 0;
    while(true)
    {
		//~ FSM->ClockSteeringDacSetpoint = offsetof(CGraphFSMHardwareInterface, UartFifo0);
		
		Process();
		
		//~ CGraphBaudDividers Bauds;
		//~ Bauds.Divider0 = (102000000.0 / (115200.0 * 16.0)) - 1.0;
		//~ Bauds.Divider1 = (102000000.0 / (115200.0 * 16.0)) - 1.0;
		//~ Bauds.Divider2 = (102000000.0 / (115200.0 * 16.0)) - 1.0;
		//~ Bauds.Divider3 = (102000000.0 / (115200.0 * 16.0)) - 1.0;
		//~ FSM->BaudDividers = Bauds;
		
		//~ FPGAUartPinout0.putcqq('.');
		//~ FPGAUartPinout1.putcqq('*');
		//~ FPGAUartPinout2.putcqq('#');
		//~ FPGAUartPinout3.putcqq('$');
		
		//~ FSM->UartFifo0 = '.'; //period on port 1
		//~ FSM->UartFifo1 = '*'; //asterisk on port 2
		//~ FSM->UartFifo2 = '#'; //pound on port 3
		//~ FSM->UartFifo3 = '$'; //dolla on port 4
    }

    return(0);
}

//EOF

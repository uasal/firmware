/*******************************************************************************
 * (c) Copyright 2012-2015 Microsemi SoC Products Group.  All rights reserved.
 *
 *  Simple SmartFusion2 microcontroller subsystem UART example program
 *  transmitting a greeting message using UART1. Any characters received on
 *  UART1 are echoed back. The UART configuration is specified as part of the
 *  call to MSS_UART_init().
 *
 * SVN $Revision: 7985 $
 * SVN $Date: 2015-10-12 12:26:08 +0530 (Mon, 12 Oct 2015) $
 */



#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <algorithm>

#include "Delay.h"

#include "arm/BuildParameters.h"
//#include "arm/smartfusion/mss_gpio.h"

#include "cgraph/CGraphPacket.hpp"

#include "cgraph/CGraphDMHardwareInterface.hpp"
extern CGraphDMHardwareInterface* DM;  // Contains a bunch of variables
extern CGraphDMRamInterface* dRAM;     // Contains the mirror data RAM

#include "format/formatf.h"

//#include "CmdTableAscii.hpp"
#include "CmdTableBinary.hpp"

#include "uart/BinaryUart.hpp"
#include "uart/uart_pinout_fpga.hpp"


// Formula for Baud rate fpr the core_uart_apb
// Baud_rate_value = (clk_in_Hz/(Baud_rate*16)) - 1
// clk_in_Hz = 
// A few pre-calculated baud rates
#define BAUD_VALUE_9600       650
#define BAUD_VALUE_115200     54 // Should be 54.3385
#define BAUD_VALUE_256000     24 // Should be 23.90
#define BAUD_VALUE_460800     12 // Should be 12.56
#define BAUD_VALUE_576000     10 // should be 9.85 (100MHz clk_in)
#define BAUD_VALUE_921600      6 // should be 5.78 (100MHz clk_in)
#define MAX_RX_DATA_SIZE    128

/*------------------------------------------------------------------------------
  UART selection.
 */
//UART_instance_t my_uart;
//uint8_t rx_data[MAX_RX_DATA_SIZE];
//uint8_t rx_size = 0;
//uint8_t rx_err_status;

//uart_pinout_fpga FPGAUartPinout;

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
		printf("\nFPGAUartCallbacks: InvalidPacket! contents: :");
		for(size_t i = 0; i < len; i++) { printf("%.2X:", Buffer[i]); }
		printf("\n\n");
	}
	
	//Packet with no matching command handler:
	virtual void UnHandledPacket(const IPacket* Packet, const size_t& PacketLen)
	{ 
		if ( (NULL == Packet) || (PacketLen < sizeof(CGraphPacketHeader)) ) { printf("\nSocketUartCallbacks: NULL(%u) UnHandledPacket!\n\n", PacketLen); return; }
		
		const CGraphPacketHeader* Header = reinterpret_cast<const CGraphPacketHeader*>(Packet);
		printf("\nFPGAUartCallbacks: Unhandled packet(%u): ", PacketLen);
		Header->formatf();
		printf("\n\n");
	}
	
	//In case we need to look at every packet that goes by...
	//~ virtual void EveryPacket(const IPacket& Packet, const size_t& PacketLen) { }
	
	//We just wanna see if this is happening, not much to do about it
	virtual void BufferOverflow(const uint8_t* Buffer, const size_t& BufferLen) 
	{ 
		//~ printf("\nFPGABinaryUartCallbacks: BufferOverflow(%zu)!\n", BufferLen);
	}

} PacketCallbacks;

CGraphPacket FPGAUartProtocol;
uart_pinout_fpga FPGAUartPinout0(&(DM->UartStatusRegister0), &(DM->UartFifo0), &(DM->UartFifo0ReadData), &(DM->UartFifo0), '~');
uart_pinout_fpga FPGAUartPinout1(&(DM->UartStatusRegister1), &(DM->UartFifo1), &(DM->UartFifo1ReadData), &(DM->UartFifo1), '!');
uart_pinout_fpga FPGAUartPinout2(&(DM->UartStatusRegister2), &(DM->UartFifo2), &(DM->UartFifo2ReadData), &(DM->UartFifo2), '@');


BinaryUart FpgaUartParser0(FPGAUartPinout0, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, PacketCallbacks, false); // No serial number given, so Invalid is used by default
BinaryUart FpgaUartParser1(FPGAUartPinout1, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, PacketCallbacks, false); // No serial number given, so Invalid is used by default
BinaryUart FpgaUartParser2(FPGAUartPinout2, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, PacketCallbacks, false); // No serial number given, so Invalid is used by default

// Need this for initialization
struct CGraphSingleDacPayload
{
  uint32_t Board;
  uint32_t dacNum;
  uint32_t dacChan;
  uint32_t data;
};

CGraphSingleDacPayload dacPayload;

#include "uart/TerminalUart.hpp"
char prompt[] = "\n\nESC-FSM> ";
const char* TerminalUartPrompt()
{
    return(prompt);
}
//Handle incoming ascii cmds & binary packets from the usb
// Maybe we should put in the Usb UartFifoLab infrastructure
//TerminalUart<16, 4096> DbgUartUsb(FPGAUartPinoutUsb, AsciiCmds, NumAsciiCmds, &TerminalUartPrompt, NoRTS, NoPrefix, false);

//TerminalUart<16, 4096> DbgUart485_0(FPGAUartPinout0, AsciiCmds, NumAsciiCmds, &TerminalUartPrompt, NoRTS, NoPrefix, false);

//#include "../MonitorAdc.hpp"
//extern CGraphFSMMonitorAdc MonitorAdc;

/*------------------------------------------------------------------------------
  GPIO variables
*/
uint32_t gpio_inputs;


extern "C"
{	
	unsigned long long fclk_for_delay_loops = 102000000;

	//This code is to make "syscalls.c" replace vendor's "newlib_stubs.c" and make printf() and friends connect to a real serial port in our actual hardware! Only useful if we can compile our own code from makefile and replace vendor's "softconsole" version...
	int stdio_hook_putc(int c) 
	{ 
		FPGAUartPinout0.putcqq(c); 
		//FPGAUartPinoutUsb.putcqq(c);
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
	
    //	MonitorAdc.Process();
	
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
	
        //if (FpgaUartParser3.Process()) { Bored = false; }    
    if (FpgaUartParser2.Process()) { Bored = false; }
    if (FpgaUartParser1.Process()) { Bored = false; }
    if (FpgaUartParser0.Process()) { Bored = false; }
	//if (DbgUartUsb.Process()) { Bored = false; }    
        //if (DbgUart485_0.Process()) { Bored = false; }
//    uint32_t dval = 0x23456789;
//    uint32_t* DummyData;
//    DummyData = &dval;
//    FpgaUartParser0.TxBinaryPacket(CGraphPayloadTypeDMDac, 0, DummyData, sizeof(uint32_t));
//    FPGAUartPinout0.putcqq('h'); 

    return(Bored);
}

void ProcessAllUarts()
{
        //FpgaUartParser3.Process();
	FpgaUartParser2.Process();
	FpgaUartParser1.Process();
	//DbgUartUsb.Process();
	//DbgUart485_0.Process();
}

/*==============================================================================
 * main function.
 */
int main(int argc, char *argv[])
{
  /*--------------------------------------------------------------------------*
     * Initiailize the GPIO                                                     *
     *--------------------------------------------------------------------------*/
//    MSS_GPIO_init();  // Need to call this before anything else for the GPIO
//
//    // connected to DMMain.vhd domachine to pause the state machine until the RAM can be
//    // initialized to all zeros for all channels
//    MSS_GPIO_config(MSS_GPIO_0, MSS_GPIO_OUTPUT_MODE);
//    MSS_GPIO_set_output(MSS_GPIO_0, 0); // set output to 0 to hold the state machine until ram initialized
//
//    // Now initialize the ram
//    // Initialization code
//
//    MSS_GPIO_set_output(MSS_GPIO_0, 1); // set output to 1 to let the state machine go

  formatf("\nOffset of StartMachine: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphDMHardwareInterface, StartMachine), 148UL);
    // Now do forever loop to get communication data
    while(1) {
//      bool Bored = true;
//
//      if (FpgaUartParser1.Process()) {
//        Bored = false;
//      }
//
//      //give up our timeslice so as not to bog the system:
//      if (Bored) {
//        delayus(100);
//      }
      Process();
    }
    return(0);
}

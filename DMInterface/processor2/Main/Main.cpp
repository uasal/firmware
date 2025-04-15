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

#include "cgraph/CGraphPacket.hpp"

#include "cgraph/CGraphDMHardwareInterface.hpp"
extern CGraphDMHardwareInterface* DM;  // Contains a bunch of variables

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
uart_pinout_fpga FPGAUartPinout3(&(DM->UartStatusRegister3), &(DM->UartFifo3), &(DM->UartFifo3ReadData), &(DM->UartFifo3), '~');

BinaryUart FpgaUartParser3(FPGAUartPinout3, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, PacketCallbacks, false); // No serial number given, so Invalid is used by default

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
char prompt[] = "\n\nESC-DM> ";
const char* TerminalUartPrompt()
{
    return(prompt);
}

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
		FPGAUartPinout3.putcqq(c); 
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
	
    if (FpgaUartParser3.Process()) { Bored = false; }    
    
    return(Bored);
}

void ProcessAllUarts()
{
        FpgaUartParser3.Process();
}

/*==============================================================================
 * main function.
 */
int main(int argc, char *argv[])
{

    while(1) {

      Process();
    }
    return(0);
}

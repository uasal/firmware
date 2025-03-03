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
    FPGAUartPinout0.putcqq('h'); 

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
     * Initialize and configure UART.                                           *
     *--------------------------------------------------------------------------*/
    // Won't need this
//    UART_init(&my_uart, 0, //COREUARTAPB_C0_0,
//              BAUD_VALUE_115200,
//              (DATA_8_BITS | NO_PARITY));

    //    UART_polled_tx_string(&my_uart,(const uint8_t*)"Ux1Init\n"); // getting here?

    /*--------------------------------------------------------------------------*/

    

    /*--------------------------------------------------------------------------*
     * Initiailize the GPIO                                                     *
     *--------------------------------------------------------------------------*/
    // Might need this.  Keep in for now.
//    MSS_GPIO_init();  // Need to call this before anything else for the GPIO
//    
//    MSS_GPIO_config(MSS_GPIO_0, MSS_GPIO_INPUT_MODE);  // Make RxRdy an input
//    MSS_GPIO_config(MSS_GPIO_1, MSS_GPIO_OUTPUT_MODE); // Make SpiReset an output
//    MSS_GPIO_config(MSS_GPIO_2, MSS_GPIO_INPUT_MODE);  // Make SpiXferComplete an input
//    MSS_GPIO_config(MSS_GPIO_3, MSS_GPIO_OUTPUT_MODE);  // Make nClrDacs an output
//    MSS_GPIO_config(MSS_GPIO_4, MSS_GPIO_OUTPUT_MODE);  // Make nLDacs an output
//    MSS_GPIO_config(MSS_GPIO_5, MSS_GPIO_OUTPUT_MODE);  // Make nRstDacs an output
//    MSS_GPIO_config(MSS_GPIO_6, MSS_GPIO_OUTPUT_MODE);  // Make PowerHVnEn an output
//    MSS_GPIO_config(MSS_GPIO_7, MSS_GPIO_INPUT_MODE);  // Make Ux1Sel an input
//    
//    MSS_GPIO_set_output(MSS_GPIO_1, 1); // set the rst of the SPI module to 1 to hold it in reset until time to send SPI data
//    MSS_GPIO_set_output(MSS_GPIO_3, 1); // set the nClrDacs to 1
//    MSS_GPIO_set_output(MSS_GPIO_4, 1); // set the nLDacs to 1
//    MSS_GPIO_set_output(MSS_GPIO_5, 1); // set the nRstDacs 1
//    MSS_GPIO_set_output(MSS_GPIO_6, 0); // set the PwrHVnEn 0.  HV power on at start up
    /*--------------------------------------------------------------------------*/

    /*--------------------------------------------------------------------------*
     * Initialize the PDMA                                                      *
     *--------------------------------------------------------------------------*/
    // Will want this
//    PDMA_init();  // Initializes the PDMA controller

    /* Now configure the streams -----------------------------------------------*/
    /* Our peripherals or in the FPGA fabric in the FIC 1 address space         *
     * Use the source/destination as FIC_1
     * DMAREADY_0 is used for the SPI ports xfer done
     * DMAREADY_1 is used for the UART RxReady signal, so data is waiting in the UART buffer
     * The UART buffer is in memory from the getqq and Process commands
     * the Params contains the data and must now be sent to the eSRAM
     * When we write to the driver boards, we are getting from memory and sending
     * to the SPI ports
     *--------------------------------------------------------------------------*/
    /* PDMA Channel 0 memory to memory  */ /* This is UART memory to memory location */
    /* PDMA Channel 1 memory to SpiMasterPorts0 */
    /* PDMA Channel 2 memory to SpiMasterPorts1 */
    /* PDMA Channel 3 memory to SpiMasterPorts2 */
    /* PDMA Channel 4 memory to SpiMasterPorts3 */
    /* PDMA Channel 5 memory to SpiMasterPorts4 */
    /* PDMA Channel 6 memory to SpiMasterPorts5 */
//    PDMA_configure(PDMA_CHANNEL_0,
//                   PDMA_MEM_TO_MEM,
//                   PDMA_LOW_PRIORITY | PDMA_HALFWORD_TRANSFER
//                   | PDMA_INC_DEST_ONE_BYTE | PDMA_INC_SRC_FOUR_BYTES,  // increment src causes problems why??
//                   0);
    // DEST Two bytes, SRC four bytes has output of first element, then third element, then 5th element.  Remaining 2 spi outputs are static
    // DEST one byte, SRC four bytes
    // DEST four bytes, SRC four bytes
    // DEST four bytes, SRC two bytes
    /* This may be what we need to do to start */
//    PDMA_configure(PDMA_CHANNEL_0,
//                   PDMA_MEM_TO_MEM,
//                   PDMA_LOW_PRIORITY | PDMA_WORD_TRANSFER,
//                   PDMA_DEFAULT_WRITE_ADJ);

//    PDMA_configure(PDMA_CHANNEL_1,
//                   PDMA_TO_FIC_0_DMAREADY_0,
//                   PDMA_LOW_PRIORITY | PDMA_HALFWORD_TRANSFER,
//                   PDMA_DEFAULT_WRITE_ADJ);
    
//    PDMA_configure(PDMA_CHANNEL_2,
//                   PDMA_TO_FIC_0_DMAREADY_0,
//                   PDMA_LOW_PRIORITY | PDMA_HALFWORD_TRANSFER,
//                   PDMA_DEFAULT_WRITE_ADJ);
//    
//    PDMA_configure(PDMA_CHANNEL_3,
//                   PDMA_TO_FIC_0_DMAREADY_0,
//                   PDMA_LOW_PRIORITY | PDMA_HALFWORD_TRANSFER,
//                   PDMA_DEFAULT_WRITE_ADJ);
//    
//    PDMA_configure(PDMA_CHANNEL_4,
//                   PDMA_TO_FIC_0_DMAREADY_0,
//                   PDMA_LOW_PRIORITY | PDMA_HALFWORD_TRANSFER,
//                   PDMA_DEFAULT_WRITE_ADJ);
//    
//    PDMA_configure(PDMA_CHANNEL_5,
//                   PDMA_TO_FIC_0_DMAREADY_0,
//                   PDMA_LOW_PRIORITY | PDMA_HALFWORD_TRANSFER,
//                   PDMA_DEFAULT_WRITE_ADJ);
//    
//    PDMA_configure(PDMA_CHANNEL_6,
//                   PDMA_TO_FIC_0_DMAREADY_0,
//                   PDMA_LOW_PRIORITY | PDMA_HALFWORD_TRANSFER,
//                   PDMA_DEFAULT_WRITE_ADJ);               
    
    // Reset the DACs
    // How long is this delay?
//    MSS_GPIO_set_output(MSS_GPIO_5,0); // set nRstDacs to 0
//    for (int ii; ii < 10000; ii++) {  // a delay
//      MSS_GPIO_set_output(MSS_GPIO_5,0); // set nRstDacs to 0
//    }
//    MSS_GPIO_set_output(MSS_GPIO_5,1); // set nRstDacs to 1
//    // Dacs are now reset
//
//    // Clear the Dacs
//    MSS_GPIO_set_output(MSS_GPIO_3,0); // set nClrDacs to 0
//    for (int ii; ii < 10000; ii++) {  // a delay
//      MSS_GPIO_set_output(MSS_GPIO_3,0); // set nClrDacs to 0
//    }
//    MSS_GPIO_set_output(MSS_GPIO_3,1); // set nClrDacs to 1
//    // Dacs are now clear
//
//    // Need to write 0 to all of the Dacs otherwise the default value will
//    // be loaded when Dacs are loaded
//    for (int board; board < 6; board++) {
//      for (int dac; dac < 24; dac++) {
//        for (int chan; chan < 40; chan++) {
//          dacPayload.Board = board;
//          dacPayload.dacNum = dac;
//          dacPayload.dacChan = chan;
//          dacPayload.data = 0;
//
//          const char* Params = reinterpret_cast<char*>(&dacPayload);
//          // Call the BinaryHandler directly??
//          BinaryDMDacCommand(CGraphPayloadTypeDMDac, Params, sizeof(CGraphSingleDacPayload), NULL);
//          // Put in a delay loop
//          for (int ii; ii < 10000; ii++) {
//              MSS_GPIO_set_output(MSS_GPIO_5,1); // set nRstDacs to 1
//          }
//        }
//      }
//    }

    //    ShowBuildParameters(); // What is this??
    //DbgUartUsb.Init();
    //DbgUart485_0.Init();

    //DbgUartUsb.SetEcho(false);
    //DbgUart485_0.SetEcho(false);

//    MonitorAdc.SetMonitor(false);
//    MonitorAdc.Init();

//    for (;;) {
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

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
#include "core_uart_apb.h"
#include "coreuartapb_regs.h"
#include "mss_nvm.h"
#include "mss_gpio.h"
#include "EvalBoardSandbox_hw_platform.h"
#include "Delay.h"
#include "hw_reg_io.h"
#include "mss_pdma.h"
#include <stdio.h>

#include "cgraph/CGraphSF2HardwareInterface.hpp"

//int MmapHandle = 0;
extern CGraphDMHardwareInterface* DMCI;  // Contains a bunch of variables

bool MonitorSerial1 = false;

#include "uart/BinaryUart.hpp"
#include "uart/CGraphPacket.hpp"
#include "CmdTableBinary.hpp"

// Formula for Baud rate
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
UART_instance_t my_uart;
uint8_t rx_data[MAX_RX_DATA_SIZE];
uint8_t rx_size = 0;
uint8_t rx_err_status;

// Binary Uart Declaration
class DMCI_pinout_FPGAUart1 : public IUart
{
public:

  DMCI_pinout_FPGAUart1() : IUart() { }
  virtual ~DMCI_pinout_FPGAUart1() { }
  
  virtual int init(const uint32_t nc, const char* nc2) { return(IUartOK); }
  
  virtual void deinit() { }
	
  virtual bool dataready() const {
    if (!(MSS_GPIO_get_inputs() & MSS_GPIO_0_MASK)) {
      return(false);
    }
    else {
      return(true);
    }
  }

  // Get one byte to accommodate the remaining infrastructure
  virtual char getcqq() {
    uint8_t rx_buf[128];
    
    rx_err_status = UART_get_rx_status(&my_uart);
    if ((UART_APB_NO_ERROR == rx_err_status)) {
      char c = '\0';   // what does this do for us?
      rx_size = UART_get_rx(&my_uart, rx_buf, 1);  // Get 1 byte
      UART_polled_tx_string(&my_uart, (const uint8_t*)&rx_size);
      c = *rx_buf;
      if (MonitorSerial1) { printf("!%.2x",c); }
      //return(rx_buf[0]);
      return((char)(c));
    }
    else {
      UART_polled_tx_string(&my_uart, (const uint8_t*)&rx_err_status);
      return(false); }
    
  }

  virtual char putcqq(char c) {
    if (NULL == DMCI) { return(c); }
    DMCI->UartFifo1 = c;		
    delayus(12); //This was necessary the last hardware we tried this on...
    return(c);
  }
	
  virtual size_t depth() const {
    if (NULL == DMCI) { return(false); }
    CGraphDMUartStatusRegister UartStatus = DMCI->UartStatusRegister1;
    return(UartStatus.UartRxFifoCount);
  }

  virtual void flushoutput() { } // if (DMCI) { DMCI->UartTxStatusRegister = 0; } //Need to make tx & rx status registers seperate...
  virtual void purgeinput() { } // if (DMCI) { DMCI->UartRxStatusRegister = 0; }	
  virtual bool connected() { return(true); }	
  virtual bool isopen() const { return(true); }	
	
private:
  //~ CGraphDMCIHardwareInterface* fpgaDMCI;	
	
} FPGAUartPinout1;

struct FPGABinaryUartCallbacks : public BinaryUartCallbacks
{
	FPGABinaryUartCallbacks() { }
	virtual ~FPGABinaryUartCallbacks() { }
	
	//Malformed/corrupted packet handler:
	virtual void InvalidPacket(const uint8_t* Buffer, const size_t& BufferLen)
	{ 
		if ( (NULL == Buffer) || (BufferLen < 1) ) { printf("\nFPGAUartCallbacks: NULL(%u) InvalidPacket!\n\n", BufferLen); return; }
	
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
BinaryUart FpgaUartParser1(FPGAUartPinout1, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, PacketCallbacks, false); // No serial number given, so Invalid is used by default
CGraphSingleDacPayload dacPayload;

/*------------------------------------------------------------------------------
  GPIO variables
*/
uint32_t gpio_inputs;


/*==============================================================================
 * main function.
 */
int main()
{
    size_t rx_size;
    uint8_t rx_buff[1];
    uint32_t duty_cycle = 1;
    uint32_t duty_cycle2 = 2;
    uint32_t testdac=0;
    int direction = 1;
    int direction2 = 2;
    int dacNum, board;

    /*--------------------------------------------------------------------------*
     * Initialize the BinaryUart                                                *
     *--------------------------------------------------------------------------*/
    /* This clears teh RxBuffer, will this help with the three times to recognize a command? */
    //FpgaUartParser1.Init(FpgaUartParser1.SerialNum); // InvalidSerialNumber from uart/BinaryUart.hpp
    
    /*--------------------------------------------------------------------------*
     * Initialize and configure UART.                                           *
     *--------------------------------------------------------------------------*/
    UART_init(&my_uart, COREUARTAPB_C0_0,
              BAUD_VALUE_115200,
              (DATA_8_BITS | NO_PARITY));

    //    UART_polled_tx_string(&my_uart,(const uint8_t*)"Ux1Init\n"); // getting here?

    /*--------------------------------------------------------------------------*/

    

    /*--------------------------------------------------------------------------*
     * Initiailize the GPIO                                                     *
     *--------------------------------------------------------------------------*/
    MSS_GPIO_init();  // Need to call this before anything else for the GPIO

    
    MSS_GPIO_config(MSS_GPIO_0, MSS_GPIO_INPUT_MODE);  // Make RxRdy an input
    MSS_GPIO_config(MSS_GPIO_1, MSS_GPIO_OUTPUT_MODE); // Make SpiReset an output
    MSS_GPIO_config(MSS_GPIO_2, MSS_GPIO_INPUT_MODE);  // Make SpiXferComplete an input
    MSS_GPIO_config(MSS_GPIO_3, MSS_GPIO_OUTPUT_MODE);  // Make nClrDacs an output
    MSS_GPIO_config(MSS_GPIO_4, MSS_GPIO_OUTPUT_MODE);  // Make nLDacs an output
    MSS_GPIO_config(MSS_GPIO_5, MSS_GPIO_OUTPUT_MODE);  // Make nRstDacs an output
    MSS_GPIO_config(MSS_GPIO_6, MSS_GPIO_OUTPUT_MODE);  // Make PowerHVnEn an output
    MSS_GPIO_config(MSS_GPIO_7, MSS_GPIO_INPUT_MODE);  // Make Ux1Sel an input
    
    MSS_GPIO_set_output(MSS_GPIO_1, 1); // set the rst of the SPI module to 1 to hold it in reset until time to send SPI data
    MSS_GPIO_set_output(MSS_GPIO_3, 1); // set the nClrDacs to 1
    MSS_GPIO_set_output(MSS_GPIO_4, 1); // set the nLDacs to 1
    MSS_GPIO_set_output(MSS_GPIO_5, 1); // set the nRstDacs 1
    MSS_GPIO_set_output(MSS_GPIO_6, 0); // set the PwrHVnEn 0.  HV power on at start up
    /*--------------------------------------------------------------------------*/

    /*--------------------------------------------------------------------------*
     * Initialize the PDMA                                                      *
     *--------------------------------------------------------------------------*/
    PDMA_init();  // Initializes the PDMA controller

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
    PDMA_configure(PDMA_CHANNEL_0,
                   PDMA_MEM_TO_MEM,
                   PDMA_LOW_PRIORITY | PDMA_HALFWORD_TRANSFER
                   | PDMA_INC_DEST_ONE_BYTE | PDMA_INC_SRC_FOUR_BYTES,  // increment src causes problems why??
                   0);
    // DEST Two bytes, SRC four bytes has output of first element, then third element, then 5th element.  Remaining 2 spi outputs are static
    // DEST one byte, SRC four bytes
    // DEST four bytes, SRC four bytes
    // DEST four bytes, SRC two bytes
    /* This may be what we need to do to start */
//    PDMA_configure(PDMA_CHANNEL_0,
//                   PDMA_MEM_TO_MEM,
//                   PDMA_LOW_PRIORITY | PDMA_WORD_TRANSFER,
//                   PDMA_DEFAULT_WRITE_ADJ);

    PDMA_configure(PDMA_CHANNEL_1,
                   PDMA_TO_FIC_0_DMAREADY_0,
                   PDMA_LOW_PRIORITY | PDMA_HALFWORD_TRANSFER,
                   PDMA_DEFAULT_WRITE_ADJ);
    
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
    
    /* Test to see if this compiles */
    /* Yes, it does.  But is the size correct? */
//    PDMA_start(PDMA_CHANNEL_0,
//               COREUARTAPB_C0_0 + RXDATA_REG_OFFSET,
//               0x20000000,
//               sizeof(COREUARTAPB_C0_0 + RXDATA_REG_OFFSET));

    // Reset the DACs
    // How long is this delay?
    MSS_GPIO_set_output(MSS_GPIO_5,0); // set nRstDacs to 0
    for (int ii; ii < 10000; ii++) {  // a delay
      MSS_GPIO_set_output(MSS_GPIO_5,0); // set nRstDacs to 0
    }
    MSS_GPIO_set_output(MSS_GPIO_5,1); // set nRstDacs to 1
    // Dacs are now reset

    // Clear the Dacs
    MSS_GPIO_set_output(MSS_GPIO_3,0); // set nClrDacs to 0
    for (int ii; ii < 10000; ii++) {  // a delay
      MSS_GPIO_set_output(MSS_GPIO_3,0); // set nClrDacs to 0
    }
    MSS_GPIO_set_output(MSS_GPIO_3,1); // set nClrDacs to 1
    // Dacs are now clear

    // Need to write 0 to all of the Dacs otherwise the default value will
    // be loaded when Dacs are loaded
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
//          BinaryDMDacsCommand(CGraphPayloadTypeDMDacs, Params, sizeof(CGraphSingleDacPayload), NULL);
//          // Put in a delay loop
//          for (int ii; ii < 10000; ii++) {
//              MSS_GPIO_set_output(MSS_GPIO_5,1); // set nRstDacs to 1
//          }
//        }
//      }
//    }

//    for (;;) {
    while(1) {
      bool Bored = true;

      if (FpgaUartParser1.Process()) {
        Bored = false;
      }

      //give up our timeslice so as not to bog the system:
      if (Bored) {
        delayus(100);
      }
    }
}

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
#include "mss_nvm.h"
#include "mss_gpio.h"
#include "Ux2FPGA_hw_platform.h"
#include "Delay.h"
#include <stdio.h>
//#include "MirrorMap.hpp"

//#include "uart/AsciiCmdUserInterfaceLinux.h"
#include "cgraph/CGraphSF2HardwareInterface.hpp"

//int MmapHandle = 0;
CGraphDMHardwareInterface* DMCI = NULL;  // Contains a bunch of variables

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

/******************************************************************************
 * Local function prototype.
 *****************************************************************************/
void delay( void );

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
      c = *rx_buf;
      if (MonitorSerial1) { printf("!%.2x",c); }
      //return(rx_buf[0]);
      return((char)(c));
    }
    else {
      //      uint8_t msg[] = {"UWVeryLooooooongMessage"};
      //      UART_polled_tx_string(&my_uart,(const uint8_t *)&msg);
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
    int direction = 1;
    int direction2 = 2;
    
    /* diagnostics for the UART */
    const uint32_t master_tx_frame= 0xFFAAFF55;
    const uint32_t success_tx_frame=0x002200CC;
    const uint32_t protect_tx_frame=0x44AA4455;
    const uint32_t verify_tx_frame= 0x00440055;
    const uint32_t lock_tx_frame  = 0x99449955;

 
    /*--------------------------------------------------------------------------
     * Initialize and configure UART.
     */
    UART_init(&my_uart, COREUARTAPB_C0_0,
              BAUD_VALUE_115200,
              (DATA_8_BITS | NO_PARITY));


    /*--------------------------------------------------------------------------
     * Initiailize the GPIO
     */
    MSS_GPIO_config(MSS_GPIO_0, MSS_GPIO_INPUT_MODE);  // Make GPIO_0 an input
    MSS_GPIO_config(MSS_GPIO_1, MSS_GPIO_OUTPUT_MODE); // Make GPIO_1 an output
    MSS_GPIO_config(MSS_GPIO_2, MSS_GPIO_INPUT_MODE);  // Make GPIO_2 an input

    MSS_GPIO_config(MSS_GPIO_4, MSS_GPIO_OUTPUT_MODE); // Make GPIO_4 an output
    MSS_GPIO_config(MSS_GPIO_5, MSS_GPIO_OUTPUT_MODE); // Make GPIO_5 an output
    MSS_GPIO_config(MSS_GPIO_6, MSS_GPIO_OUTPUT_MODE); // Make GPIO_6 an output
    MSS_GPIO_config(MSS_GPIO_7, MSS_GPIO_OUTPUT_MODE); // Make GPIO_7 an output
    
    MSS_GPIO_config(MSS_GPIO_8, MSS_GPIO_INPUT_MODE); // Make GPIO_8 an input
    MSS_GPIO_config(MSS_GPIO_9, MSS_GPIO_INPUT_MODE); // Make GPIO_9 an input
    MSS_GPIO_config(MSS_GPIO_10, MSS_GPIO_INPUT_MODE); // Make GPIO_10 an input
    MSS_GPIO_config(MSS_GPIO_11, MSS_GPIO_INPUT_MODE); // Make GPIO_11 an input
    MSS_GPIO_config(MSS_GPIO_12, MSS_GPIO_INPUT_MODE); // Make GPIO_12 an input
    MSS_GPIO_config(MSS_GPIO_13, MSS_GPIO_INPUT_MODE); // Make GPIO_13 an input
    MSS_GPIO_config(MSS_GPIO_14, MSS_GPIO_INPUT_MODE); // Make GPIO_14 an input
    MSS_GPIO_config(MSS_GPIO_15, MSS_GPIO_INPUT_MODE); // Make GPIO_15 an input
    MSS_GPIO_config(MSS_GPIO_16, MSS_GPIO_INPUT_MODE); // Make GPIO_16 an input

    /* Set initial conditions for GPIO pins */
    MSS_GPIO_set_output(MSS_GPIO_1, 1); // set the rst of the SPI module to 1
    MSS_GPIO_set_output(MSS_GPIO_4, 1); // set nRstAdcs
    MSS_GPIO_set_output(MSS_GPIO_5, 0); // clear TrigAdcs
    MSS_GPIO_set_output(MSS_GPIO_6, 1); // set nPwrDnAdcs
    MSS_GPIO_set_output(MSS_GPIO_7, 0); // clear PowerEn until we want to turn on

    for (;;) {
      bool Bored = true;
      if (FpgaUartParser1.Process()) {
        Bored = false;
      }

      //give up our timeslice so as not to bog the system:
      if (Bored) {
        delayms(100);
      }

    }
}

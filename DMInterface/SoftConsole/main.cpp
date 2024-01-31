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
#include "core_pwm.h"
#include "core_spi.h"
#include "mss_nvm.h"
#include "mss_gpio.h"
#include "EvalBoardSandbox_hw_platform.h"
#include "Delay.h"
#include <pthread.h>
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

/******************************************************************************
 * PWM prescale and period configuration values.
 *****************************************************************************/
#define PWM_PRESCALE    8
#define PWM_PERIOD      300
#define DELAY_COUNT     10000
#define MAX_RX_DATA_SIZE    128

/******************************************************************************
 * Local function prototype.
 *****************************************************************************/
void delay( void );

/******************************************************************************
 * CorePWM instance data.
 *****************************************************************************/
pwm_instance_t the_pwm;

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
    //    if (NULL == DMCI) { return(false); }
    //CGraphDMUartStatusRegister UartStatus = DMCI->UartStatusRegister1;
    //return(0 == UartStatus.UartRxFifoEmpty);
    //    gpio_inputs = MSS_GPIO_get_inputs();
    
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
      //uint8_t msg[] = {"UWVeryLooooooongMessage"};
      ////UART_polled_tx_string(&my_uart,(const uint8_t *)&msg);
      ////UART_polled_tx_string(&my_uart,(const uint8_t *)&rx_buf);
      c = *rx_buf;
      //UART_polled_tx_string(&my_uart,(const uint8_t *)&c);
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
  SPI selection.
 */

//extern DACspi   SpiContainer;
spi_instance_t g_spi[2];
//spi_instance_t g_spi1;

/*------------------------------------------------------------------------------
  GPIO variables
*/
uint32_t gpio_inputs;


////bool Process()
////{
////    bool Bored = true;
////
////    //    if (ProcessUserInterface())
////    //    {
////    //  Bored = false;
////    //    }
////    
////    return(Bored);
////}

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

    /* This is memory diagnostics */
    //uint8_t idata[815] = {"Z"};
    //nvm_status_t status;

    /* Turn off the watchdog */
    //    SYSREG->WDOG_CR = 0;


    /**************************************************************************
     * Initialize the CorePWM instance setting the prescale and period values.
    *************************************************************************/
    PWM_init( &the_pwm, COREPWM_0_0, PWM_PRESCALE, PWM_PERIOD ) ;

    /**************************************************************************
     * Set the initial duty cycle for CorePWM output 1.
     *************************************************************************/
    PWM_set_duty_cycle( &the_pwm, PWM_1, duty_cycle );
    PWM_set_duty_cycle( &the_pwm, PWM_2, duty_cycle2 );

    /*--------------------------------------------------------------------------
     * Initialize and configure UART.
     */
    UART_init(&my_uart, COREUARTAPB_C0_0,
              BAUD_VALUE_115200,
              (DATA_8_BITS | NO_PARITY));


    /*--------------------------------------------------------------------------
     * Initialize and configure SPI.
     */
//    SpiContainer.Init();  // Both SPIs are now initialized
//    SPI_init(&g_spi[0], CORESPI_C0_0, 8);  // Initialize first SPI port
//    SPI_configure_master_mode(&g_spi[0]);  // Make the master
//
//    SPI_init(&g_spi[1], CORESPI_C1_0, 8);  // Initialize second SPI port
//    SPI_configure_master_mode(&g_spi[1]);  // Make the master

    /*--------------------------------------------------------------------------
     * Initiailize the GPIO
     */
    MSS_GPIO_config(MSS_GPIO_0, MSS_GPIO_INPUT_MODE);  // Make GPIO_0 an input
    MSS_GPIO_config(MSS_GPIO_1, MSS_GPIO_OUTPUT_MODE); // Make GPIO_1 an output
    MSS_GPIO_config(MSS_GPIO_2, MSS_GPIO_INPUT_MODE);  // Make GPIO_2 an input
    MSS_GPIO_set_output(MSS_GPIO_1, 1); // set the rst of the SPI module to 1 to hold it in reset until time to send SPI data

    /*----------------------------------
     * Initialize the BinaryUart
     */
    /* Is this necessary?  Seems there's an error if this is included */
    //    FpgaUartParser1.Init(FpgaUartParser1.InvalidSerialNumber);

    /*--------------------------------------------------------------------------
     * Send greeting message over the UART.
     */
//    UART_polled_tx_string(&my_uart,(const uint8_t*)"\n\r\n\r**********************************************************************\n\r");
//    UART_polled_tx_string(&my_uart,(const uint8_t*)"******************** SmartFusion2 MMUART Example *********************\n\r");
//    UART_polled_tx_string(&my_uart,(const uint8_t*)"**********************************************************************\n\r");
//    UART_polled_tx_string(&my_uart,(const uint8_t*)"Characters typed will be echoed back.\n\r");


    //status = NVM_write(ENVM_DAC_STORE, idata, sizeof(idata), NVM_DO_NOT_LOCK_PAGE);
      

    /*--------------------------------------------------------------------------
     * Echo back any characters received.
     */
    /* UART is initialized above.  Now wait for messages to process */
    for (;;) {
      bool Bored = true;		
      if (FpgaUartParser1.Process()) {
        //        UART_polled_tx_string(&my_uart,FpgaUartParser1.RxBuffer);
        Bored = false;
      }

      //give up our timeslice so as not to bog the system:
      if (Bored) {
        delayms(100);
      }

//        /**********************************************************************
//         * Update the duty cycle for CorePWM output 1.
//         *********************************************************************/
//        PWM_set_duty_cycle( &the_pwm, PWM_1, duty_cycle );
//        PWM_set_duty_cycle( &the_pwm, PWM_2, duty_cycle2 );
//        /**********************************************************************
//         * Wait for a short delay.
//         *********************************************************************/
//        delay();
//        /**********************************************************************
//         * Calculate the next PWM duty cycle.
//         *********************************************************************/
//        duty_cycle += direction;
//        duty_cycle2 += direction2;
//        if ( duty_cycle >= PWM_PERIOD )
//        {
//            direction = -1;
//        }
//        else if ( duty_cycle == 0 )
//        {
//            direction = 1;
//        }
//        if ( duty_cycle2 >= PWM_PERIOD )
//        {
//            direction2 = -3;
//        }
//        else if ( duty_cycle2 == 0 )
//        {
//            direction2 = 3;
//        }

    }
}

/******************************************************************************
 * Delay function.
 *****************************************************************************/
void delay( void )
{
    volatile int counter = 0;

    while ( counter < DELAY_COUNT )
    {
        counter++;
    }
}



/*
 * MirrorMap.hpp
 *
 *  Created on: Jan 17, 2024
 *      Author: SKaye (kaye2@arizona.edu)
 */

/* Includes */
#include <stdio.h>
#include "spi_regs.h"

#ifdef __cplusplus
extern "C" {
#endif
  
#include "hal.h"
#include "hal_assert.h"

#ifdef __cplusplus
}
#endif

#include "Delay.h"
#include "mss_gpio.h"
#include "Ux2FPGA_hw_platform.h"
#include <string.h>
#include <math.h>


#define DriverBoards 6
#define DacPerBoard  4
#define ChanPerDac   40
#define NumSpiPorts  6
#define NO_OFFSET    0x00u
#define MOSIA        0x00u

uint8_t DACaddr[] =
{    0b11001000,0b11001001,0b11001010,0b11001011,0b11001100,
     0b11001101,0b11001110,0b11001111,0b11010000,0b11010001,
     0b11010010,0b11010011,0b11010100,0b11010101,0b11010110,
     0b11010111,0b11011000,0b11011001,0b11011010,0b11011011,
     0b11011100,0b11011101,0b11011110,0b11011111,0b11100000,
     0b11100001,0b11100010,0b11100011,0b11100100,0b11100101,
     0b11100110,0b11100111,0b11101000,0b11101001,0b11101010,
     0b11101011,0b11101100,0b11101101,0b11101110,0b11101111};


// Need a simple translation from mirror number to board, dac, and dac channel numbers

struct DACspi {
  uint16_t        dmdacWord[952]; // Host CPU will translate voltage to dacWord; 952 channels
  int             board;

  // Assign the initial default values
  // Still developing...
  //  DACspi(struct mmap mirrorMap):

  // Initialize and configure SPI ports
  int Init() {
    return 0;
  };

  int sendSingleDacSpi(int board, int dacNum, int dacChan, const uint32_t data) {
    int        xferDone=0;
    uint8_t    addrByte, nCs;
    uint16_t   myData;
    uint32_t   addr=0;
    uint32_t   ambaPWrite;
    // Use the board number to choose SPI channel
    switch(board) {
    case 0:
      addr = SPIMASTERPORTS_0;
      break;
    case 1:
      addr = SPIMASTERPORTS_1;
      break;
//    case 2:
//      addr = SPIMASTERPORTS_2;
//      break;
    default:
      addr = 0;
      break;
    }

    nCs = dacNum % 4;
    addrByte = DACaddr[dacChan];
    ambaPWrite =  (nCs << 28);
    ambaPWrite += (addrByte << 16);

    myData = data &0xffff;
    ambaPWrite += myData;
    
    // Check that the board is valid (i.e. addr is not 0)
    if (addr != 0) {
      MSS_GPIO_set_output(MSS_GPIO_1, 0); // Begin SPI transaction
      HAL_set_32bit_reg(addr, MOSIA, ambaPWrite); // send all 32 bits and FPGA bus will truncate it
      //      UART_polled_tx_string(&my_uart,(const uint8_t*)"DacCmdUx2");
    
      while(!xferDone) {
        xferDone = (MSS_GPIO_get_inputs() & MSS_GPIO_2_MASK); // check MSS_GPIO_2 is xfer is done?
      }
      MSS_GPIO_set_output(MSS_GPIO_1, 1); // SPI transaction done, set rst high
    }
    else {
      return -1;
    }

    return 0;
  };

  void sendTwoDacSpi(int board, int dacNum) {
    uint16_t    data1, data2;
    int    xferDone=0;

    MSS_GPIO_set_output(MSS_GPIO_1, 0); // set rst on the SPI module to low to begin a SPI transaction
    // The transaction should be going now
        while(!xferDone) {
      xferDone = (MSS_GPIO_get_inputs() & MSS_GPIO_2_MASK);
    }
    MSS_GPIO_set_output(MSS_GPIO_1, 1); // SPI transaction done, set rst high

    return;
  };

};

struct ADCspi {
  uint16_t        dmdacWord[952]; // Host CPU will translate voltage to dacWord; 952 channels
  int             board;

  // Assign the initial default values
  // Still developing...
  //  DACspi(struct mmap mirrorMap):

  // Initialize and configure SPI ports
  int Init() {
    return 0;
  };

  int HVon_off(int board, int HVstate) {
    int        xferDone=0;
    int        ii=0;
    uint8_t    addrByte, nCs;
    
    uint32_t   gpioInit;
    uint32_t   addr=0;
    uint32_t   ambaPWriteConfig, ambaPWriteState;

    // Use the board number to choose SPI channel
    switch(board) {
    case 0:
      addr = SPIMASTERPORTS_5;
      break;
    case 1:
      addr = SPIMASTERPORTS_4;
      break;
    case 2:
      addr = SPIMASTERPORTS_3;
      break;
    case 3:
      addr = SPIMASTERPORTS_2;
      break;
    case 4:
      addr = SPIMASTERPORTS_1;
      break;
    case 5:
      addr = SPIMASTERPORTS_0;
      break;
    default:
      addr = 0;
      break;
    }

    nCs = 0;  // For ADCs, there is only 1 CS per SPI port address

    ambaPWriteConfig = (nCs << 28) + 0x67c000;  // All GPIO pins are outputs
    if (HVstate == 0)
      ambaPWriteState = (nCs << 28) + 0x680000;     // All GPIO pins are low
    if (HVstate == 1)
      ambaPWriteState = (nCs << 28) + 0x681f00;      // All GPIO pins are high
    
    // Check that the board is valid (i.e. addr is not 0)
    if (addr != 0) {
      // Send configuration
      MSS_GPIO_set_output(MSS_GPIO_1, 0); // Begin SPI transaction
      HAL_set_32bit_reg(addr, MOSIA, ambaPWriteConfig); // send all 32 bits and FPGA bus will truncate it
      //UART_polled_tx_string(&my_uart,(const uint8_t*)"SwitchUx2");
    
      while(!xferDone) {
        xferDone = (MSS_GPIO_get_inputs() & MSS_GPIO_2_MASK); // check MSS_GPIO_2 is xfer is done?
      }
      MSS_GPIO_set_output(MSS_GPIO_1, 1); // SPI transaction done, set rst high, nCs goes high to load SPI data to ADC
      xferDone = 0;  // Need to reset xferDone flag

      // delay a little bit between the SPI transactions
      for (ii = 0; ii < 20; ii++) {
        MSS_GPIO_set_output(MSS_GPIO_1, 1); // SPI transaction done, set rst high, nCs goes high to load SPI data to ADC
      }
      //delays(100); // This delay routine is for a linux CPU, not an embedded system
      // Send HV state
      MSS_GPIO_set_output(MSS_GPIO_1, 0); // Begin SPI transaction
      HAL_set_32bit_reg(addr, MOSIA, ambaPWriteState);

      while(!xferDone) {
        xferDone = (MSS_GPIO_get_inputs() & MSS_GPIO_2_MASK); // check MSS_GPIO_2 is xfer is done?
      }
      MSS_GPIO_set_output(MSS_GPIO_1, 1); // SPI transaction done, set rst high, nCs goes high to load SPI data to ADC
      xferDone = 0;  // Reset xferDone flag as a matter of fact
    }
    else {
      return -1;
    }

    return 0;
  };

};

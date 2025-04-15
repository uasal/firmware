/*
 * MirrorMap.hpp
 *
 *  Created on: Jan 17, 2024
 *      Author: SKaye (kaye2@arizona.edu)
 */

/* Includes */
#include <stdio.h>
#include "sextet_regs.h"  // Need this for register offset in HAL call

//#ifdef __cplusplus
//extern "C" {
//#endif
//  
//#include "hal/hal.h"
//#include "hal/hal_assert.h"
//
//#ifdef __cplusplus
//}
//#endif

//#include "drivers/mss_gpio/mss_gpio.h"
//#include "drivers/CoreUARTapb/core_uart_apb.h"
//#include "drivers/CoreUARTapb/coreuartapb_regs.h"
//#include "EvalBoardSandbox_hw_platform.h"
#include <string.h>
#include <math.h>

//extern UART_instance_t my_uart;

#define DriverBoards 6
#define DacPerBoard  4
#define ChanPerDac   40
#define NumSpiPorts  6
#define MOSIA        0x00u

uint8_t DACaddr[] =
{    0b11001000,0b11001001,0b11001010,0b11001011,
     0b11001100,0b11001101,0b11001110,0b11001111,
     0b11010000,0b11010001,0b11010010,0b11010011,
     0b11010100,0b11010101,0b11010110,0b11010111,
     0b11011000,0b11011001,0b11011010,0b11011011,
     0b11011100,0b11011101,0b11011110,0b11011111,
     0b11100000,0b11100001,0b11100010,0b11100011,
     0b11100100,0b11100101,0b11100110,0b11100111,
     0b11101000,0b11101001,0b11101010,0b11101011,
     0b11101100,0b11101101,0b11101110,0b11101111};


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

  int configOffset1(int cf1board, int dacNum) {
    int        xferDone=0;
    //~ int        ii=0;
    //~ uint8_t    addrByte
	uint8_t	   nCs;
    uint32_t   ambaPWrite;
    uint32_t   addr=0;

    
    // Use the board number to choose SPI channel
    switch(cf1board) {
    case 0:
      addr = 5; //SPIMASTERPORTS_5;
      break;
    case 1:
      addr = 4; //SPIMASTERPORTS_4;
      break;
    case 2:
      addr = 3; //SPIMASTERPORTS_3;
      break;
    case 3:
      addr = 2; //SPIMASTERPORTS_2;
      break;
    case 4:
      addr = 1; //SPIMASTERPORTS_1;
      break;
    case 5:
      addr = 0; //SPIMASTERPORTS_0;
      break;
    default:
      addr = 0;
      break;
    }

    // dacNum determines which nCs to pull low (bits 31:30 of Amba PWrite)
    // dacChan determines the MSByte of the SPI 24 bit word (bits 23:16of Amba PWrite)
    nCs = dacNum % 4;
    if (addr != 0) {
        ambaPWrite = (nCs << 28) + 0x020000; // Write offset reg. 0
        //MSS_GPIO_set_output(MSS_GPIO_1, 0); // begin a SPI transaction clear rst to low
        // Send data to a homebrew SPI peripheral
        //        HAL_set_32bit_reg(addr, MOSIA, ambaPWrite);
    
        // check on the MSS_GPIO_2 input to see if the xfer is done
        while(!xferDone) {
          //xferdone = (//MSS_GPIO_get_inputs() & //MSS_GPIO_2_MASK);
        }
        //MSS_GPIO_set_output(MSS_GPIO_1, 1); // SPI transaction done, set rst high
      }
    else {
      return -1;
    }
    return 0;
  }

  int configOffset2(int cfo2board, int dacNum) {
    int        xferDone=0;
    //~ int        ii=0;
    //~ uint8_t    addrByte;
	uint8_t    nCs;
    uint32_t   ambaPWrite;
    uint32_t   addr=0;

    
    // Use the board number to choose SPI channel
    switch(cfo2board) {
    case 0:
      addr = 5; //SPIMASTERPORTS_5;
      break;
    case 1:
      addr = 4; //SPIMASTERPORTS_4;
      break;
    case 2:
      addr = 3; //SPIMASTERPORTS_3;
      break;
    case 3:
      addr = 2; //SPIMASTERPORTS_2;
      break;
    case 4:
      addr = 1; //SPIMASTERPORTS_1;
      break;
    case 5:
      addr = 0; //SPIMASTERPORTS_0;
      break;
    default:
      addr = 0;
      break;
    }

    // dacNum determines which nCs to pull low (bits 31:30 of Amba PWrite)
    // dacChan determines the MSByte of the SPI 24 bit word (bits 23:16of Amba PWrite)
    nCs = dacNum % 4;
    if (addr != 0) {
        ambaPWrite = (nCs << 28) + 0x030000; // Write offset reg. 0
        //MSS_GPIO_set_output(MSS_GPIO_1, 0); // begin a SPI transaction clear rst to low
        // Send data to a homebrew SPI peripheral
        //        HAL_set_32bit_reg(addr, MOSIA, ambaPWrite);
    
        // check on the MSS_GPIO_2 input to see if the xfer is done
        while(!xferDone) {
          //xferdone = (//MSS_GPIO_get_inputs() & //MSS_GPIO_2_MASK);
        }
        //MSS_GPIO_set_output(MSS_GPIO_1, 1); // SPI transaction done, set rst high
      }
    else {
      return -1;
    }

    return 0;
  }

    int configRegSelect(int crsboard, int dacNum) {
    int        xferDone=0;
    //~ int        ii=0;
    //~ uint8_t    addrByte
	uint8_t    nCs;
    uint32_t   ambaPWrite;
    uint32_t   addr=0;

    
    // Use the board number to choose SPI channel
    switch(crsboard) {
    case 0:
      addr = 5; //SPIMASTERPORTS_5;
      break;
    case 1:
      addr = 4; //SPIMASTERPORTS_4;
      break;
    case 2:
      addr = 3; //SPIMASTERPORTS_3;
      break;
    case 3:
      addr = 2; //SPIMASTERPORTS_2;
      break;
    case 4:
      addr = 1; //SPIMASTERPORTS_1;
      break;
    case 5:
      addr = 0; //SPIMASTERPORTS_0;
      break;
    default:
      addr = 0;
      break;
    }

    // dacNum determines which nCs to pull low (bits 31:30 of Amba PWrite)
    // dacChan determines the MSByte of the SPI 24 bit word (bits 23:16of Amba PWrite)
    nCs = dacNum % 4;
    if (addr != 0) {
        ambaPWrite = (nCs << 28) + 0x0B0000; // Write offset reg. 0
        //MSS_GPIO_set_output(MSS_GPIO_1, 0); // begin a SPI transaction clear rst to low
        // Send data to a homebrew SPI peripheral
        //        HAL_set_32bit_reg(addr, MOSIA, ambaPWrite);
    
        // check on the MSS_GPIO_2 input to see if the xfer is done
        while(!xferDone) {
          //xferdone = (//MSS_GPIO_get_inputs() & //MSS_GPIO_2_MASK);
        }
        //MSS_GPIO_set_output(MSS_GPIO_1, 1); // SPI transaction done, set rst high
      }
    else {
      return -1;
    }

    return 0;
  }

  int configDacs(int cdboard, int dacNum, uint32_t dacWord) {
    int        xferDone=0;
    //~ int        ii=0;
    //~ uint8_t    addrByte, 
	uint8_t    nCs;
    uint32_t   ambaPWrite;
    uint32_t   addr=0;

    
    // Use the board number to choose SPI channel
    switch(cdboard) {
    case 0:
      addr = 5; //SPIMASTERPORTS_5;
      break;
    case 1:
      addr = 4; //SPIMASTERPORTS_4;
      break;
    case 2:
      addr = 3; //SPIMASTERPORTS_3;
      break;
    case 3:
      addr = 2; //SPIMASTERPORTS_2;
      break;
    case 4:
      addr = 1; //SPIMASTERPORTS_1;
      break;
    case 5:
      addr = 0; //SPIMASTERPORTS_0;
      break;
    default:
      addr = 0;
      break;
    }

    // dacNum determines which nCs to pull low (bits 31:30 of Amba PWrite)
    // dacChan determines the MSByte of the SPI 24 bit word (bits 23:16of Amba PWrite)
    nCs = dacNum % 4;
    if (addr != 0) {
        ambaPWrite = (nCs << 28) + dacWord; // Write offset reg. 0
        //MSS_GPIO_set_output(MSS_GPIO_1, 0); // begin a SPI transaction clear rst to low
        // Send data to a homebrew SPI peripheral
        //        HAL_set_32bit_reg(addr, MOSIA, ambaPWrite);
    
        // check on the MSS_GPIO_2 input to see if the xfer is done
        while(!xferDone) {
          //xferdone = (//MSS_GPIO_get_inputs() & //MSS_GPIO_2_MASK);
        }
        //MSS_GPIO_set_output(MSS_GPIO_1, 1); // SPI transaction done, set rst high
    }
    else {
      return -1;
    }

    return 0;

  }

  int sendSingleDacSpi(int ssdboard, int dacNum, int dacChan, const uint32_t data) {
    int        xferDone=0;
    uint8_t    addrByte;
	uint8_t    nCs;
    uint16_t   myData;
    uint32_t   addr=0;
    uint32_t   ambaPWrite;

    // Board is determined by the dacNum from the original Mirror Map
    //board = floor(dacNum/4);
    // Use the board number to choose SPI channel
    switch(ssdboard) {
    case 0:
      addr = 5; //SPIMASTERPORTS_5;
      break;
    case 1:
      addr = 4; //SPIMASTERPORTS_4;
      break;
    case 2:
      addr = 3; //SPIMASTERPORTS_3;
      break;
    case 3:
      addr = 2; //SPIMASTERPORTS_2;
      break;
    case 4:
      addr = 1; //SPIMASTERPORTS_1;
      break;
    case 5:
      addr = 0; //SPIMASTERPORTS_0;
      break;
    default:
      addr = 0;
      break;
    }

    // dacNum determines which nCs to pull low (bits 31:30 of Amba PWrite)
    // dacChan determines the MSByte of the SPI 24 bit word (bits 23:16of Amba PWrite)
    nCs = dacNum % 4;
    addrByte = DACaddr[dacChan]; 
    ambaPWrite = (nCs << 28) + (addrByte << 16);
    // Now we need to get the data and add it to the lowest 16 bits of Amba PWrite
    myData = data & 0xffff;
    ambaPWrite += myData;
    

    if (addr != 0) {
      //MSS_GPIO_set_output(MSS_GPIO_1, 0); // begin a SPI transaction clear rst to low
      // Send data to a homebrew SPI peripheral
      //      HAL_set_32bit_reg(addr, MOSIA, ambaPWrite);
    
      // check on the MSS_GPIO_2 input to see if the xfer is done
      while(!xferDone) {
        //xferdone = (MSS_GPIO_get_inputs() & MSS_GPIO_2_MASK);
      }
      //MSS_GPIO_set_output(MSS_GPIO_1, 1); // SPI transaction done, set rst high
    }
    else {
      return -1;
    }
    // Data has been set.  To load into the Dac, need to drop nLDac low for > 10ns
    // This will load the DAC value
    //MSS_GPIO_set_output(MSS_GPIO_4, 0); // set to 0
    // Need a delay or will this be > 10ns (probably)
    //MSS_GPIO_set_output(MSS_GPIO_4, 1); // set back to 1

    return 0;
  };

  void sendTwoDacSpi(int stdboard, int dacNum) {
    //~ uint16_t    data1, data2;
    int    xferDone=0;

    // Send data to a homebrew SPI peripheral
    //    HAL_set_16bit_reg(SPIMASTERTRIOPORTS_0_BIF_1, NO_OFFSET, 0xf432);
    //HW_set_16bit_reg(SPIMASTERTRIOPORTS_0_BIF_2, 0x234f);

    //MSS_GPIO_set_output(MSS_GPIO_1, 0); // set rst on the SPI module to low to begin a SPI transaction
    // The transaction should be going now
        while(!xferDone) {
      //xferdone = (MSS_GPIO_get_inputs() & MSS_GPIO_2_MASK);
    }
    //MSS_GPIO_set_output(MSS_GPIO_1, 1); // SPI transaction done, set rst high

//    SPI_set_slave_select(&dacSpi[board], (spi_slave_t)dacNum);
//    SPI_transfer_frame(&dacSpi[board], 0xf456);
//    SPI_clear_slave_select(&dacSpi[board], (spi_slave_t)dacNum);

    
    return;
  };

};

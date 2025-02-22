///           Copyright (c) by Franks Development, LLC
//
// This software is copyrighted by and is the sole property of Franks
// Development, LLC. All rights, title, ownership, or other interests
// in the software remain the property of Franks Development, LLC. This
// software may only be used in accordance with the corresponding
// license agreement.  Any unauthorized use, duplication, transmission,
// distribution, or disclosure of this software is expressly forbidden.
//
// This Copyright notice may not be removed or modified without prior
// written consent of Franks Development, LLC.
//
// Franks Development, LLC. reserves the right to modify this software
// without notice.
//
// Franks Development, LLC            support@franks-development.com
// 500 N. Bahamas Dr. #101           http://www.franks-development.com
// Tucson, AZ 85710
// USA
//
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <inttypes.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
//#include <sys/mman.h>
#include <errno.h>
#include <unordered_map>
using namespace std;

#include "uart/CGraphPacket.hpp"

#include "uart/BinaryUart.hpp"

#include "cgraph/CGraphSF2HardwareInterface.hpp"
#include "CmdTableBinary.hpp"
#include "MirrorMap.hpp"
#include "mss_pdma.h"


#define DriverBoards 6
#define DacPerBoard  4
#define ChanPerDac   40
#define NumSpiPorts  6
#define NO_OFFSET            0x00u

DACspi  SpiContainer;
extern UART_instance_t my_uart;

int8_t BinaryVersionCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= sizeof(CGraphVersionPayload)) )
	{
		const CGraphVersionPayload* Version = reinterpret_cast<const CGraphVersionPayload*>(Params);
		printf("\nBinaryVersionCommand: ");
		Version->formatf();
		printf("\n");
	}
	else
	{
		printf("\nBinaryVersionCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, sizeof(CGraphVersionPayload));
	}
    return(ParamsLen);
}

int8_t BinaryDMDacsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
  uint32_t board, dacNum, dacCh, data;
  
	if ( (NULL != Params) && (ParamsLen >= (4 * sizeof(uint32_t))) )
	{
		const uint32_t* DacSetpoints = reinterpret_cast<const uint32_t*>(Params);
		printf("\nBinaryDMDacsCommand: 0x%X | 0x%X | 0x%X\n\n", DacSetpoints[0], DacSetpoints[1], DacSetpoints[2], DacSetpoints[3]);
                board = DacSetpoints[0];
                dacNum = DacSetpoints[1];
                dacCh = DacSetpoints[2];
                data = DacSetpoints[3];

                SpiContainer.sendSingleDacSpi(DacSetpoints[0],
                                              DacSetpoints[1],
                                              DacSetpoints[2],
                                              DacSetpoints[3]); // param1: board number (don't care); param2: dac number
	}
	else
	{
		printf("\nBinaryDMDacsCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (3 * sizeof(uint32_t)));
	}
    return(ParamsLen);
}

//int8_t BinaryDMVectorCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument) {
//
//  uint16_t     ptrInc=0;
//
//
//  UART_polled_tx_string(&my_uart,(const uint8_t*)"In new Vector Cmd ");
//  if ( (NULL != Params) && (ParamsLen >= (1 * sizeof(uint16_t))) )  {
//    
//    const uint16_t* DMSetPoints = reinterpret_cast<const uint16_t*>(Params);
//    UART_polled_tx_string(&my_uart,(const uint8_t*)"Have Params ");
//
//    // Now lets just brute force the SPI to write out 960 values
//    for (int board=0; board < 6; board++) { 
//     for (int dac=0; dac < 24; dac ++) {
//        for (int chan; chan < 40; chan++) {
//          SpiContainer.sendSingleDacSpi(5,              // channel A
//                                        22,             // Dac 2
//                                        10,             // Dac chan 10
//                                        DMSetPoints[0]);// value from memory
//          ptrInc++;
//        }
//      }
//    }
//  } else {
//    UART_polled_tx_string(&my_uart,(const uint8_t*)"Not enough params ");
//  }
//  UART_polled_tx_string(&my_uart,(const uint8_t*)"end of vector ");
//  return(ParamsLen);    
//}

int8_t BinaryDMUartCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
  volatile uint32_t status;
  uint32_t          esram_addr;
  uint16_t          echodata[160];  // max number of elements
  int               ii,xferDone=0;
  

  // This is to test the Uart and see if the UART us indeed setting the limit on amount of data
  // Check to see we're getting here
  UART_polled_tx_string(&my_uart,(const uint8_t*)"In BUart Cmd ");
  // Not really necessary, but we'll keep this test in to stay close to the original
  if ( (NULL != Params) && (ParamsLen >= (30 * sizeof(uint16_t))) )  {
    UART_polled_tx_string(&my_uart,(const uint8_t*)"Sending back params ");
    UART_polled_tx_string(&my_uart,(const uint8_t*)Params);  // Send the string right back
    //    UART_polled_tx_string(&my_uart,(const uint8_t*)DMSetPoints[1]);  // Send the string right back
  }
  return(ParamsLen);
}

int8_t BinaryDMVectorCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
  volatile uint32_t status;
  uint32_t          esram_addr;
  uint16_t          echodata[160];  // max number of elements
  int               ii,xferDone=0;
  

  // echodata needed more than 1 element since the PDMA_start increments the desitination
  // I think that may have been the problem
  
  // Check to see we're getting here
  UART_polled_tx_string(&my_uart,(const uint8_t*)"In Vector Cmd ");
  esram_addr = 0x20000000;
  // This will normally be a vector of all 952 mirror set points
  // if ( (NULL != Params) && (ParamsLen >= (952 * sizeof(uint16_t))) )  
  // But let's start with 18 data points and then expand
  // This gives us 3 data points per spi
  // Try just one parameter and see if that works.  We may be getting
  // a boundry problem from one data location tot another
  if ( (NULL != Params) && (ParamsLen >= (30 * sizeof(uint16_t))) )  {
    
    const uint16_t* DMSetPoints = reinterpret_cast<const uint16_t*>(Params);
    UART_polled_tx_string(&my_uart,(const uint8_t*)"Have Params ");
    size_t numElements = sizeof(Params)/sizeof(uint16_t);
    

    // Write to the memory locations
    for (ii=0; ii <ParamsLen/2; ii++) {
      PDMA_start(PDMA_CHANNEL_0,
                 (uint32_t)(DMSetPoints+ii),
                 esram_addr+2*ii,
                 1);
      do {
        status = PDMA_status(PDMA_CHANNEL_0);
      } while (0 == status);
    }


// Use the PDMA to write to the fabric SPI port  
// Now can we start all of the SPI channels from memory and write simultaneously?

      // Start with 1 transfer to make sure this engine goes
      // Then write 5 to see if we can get all of them out.
    // Probably don't want to increment the destination address
    // Can we dynaically set the PDMA configuration?  Why not?
    // Just use one SPI port
    for (ii=0; ii < ParamsLen/2; ii++) {
      
      MSS_GPIO_set_output(MSS_GPIO_1, 0); // begin a SPI transaction clear rst to low
      PDMA_start(PDMA_CHANNEL_1,
                 esram_addr+2*ii,
                 SPIMASTERPORTS_0,
                 1);              // 160 transfers of 16 bytes
    
    while(!xferDone) {
        xferDone = (MSS_GPIO_get_inputs() & MSS_GPIO_2_MASK);
      }
      MSS_GPIO_set_output(MSS_GPIO_1, 1); // SPI transaction done, set rst high
    }
    
//    PDMA_start(PDMA_CHANNEL_2,
//               0x20000006,        // Next spi address will be 160*2bytes = 320bytes = 0x140bytes
//               SPIMASTERPORTS_1,
//               160);              // 160 transfers of 16 bytes
//    PDMA_start(PDMA_CHANNEL_3,
//               0x2000000C,
//               SPIMASTERPORTS_2,
//               160);              // 160 transfers of 16 bytes
//    PDMA_start(PDMA_CHANNEL_4,
//               0x20000012,
//               SPIMASTERPORTS_3,
//               160);              // 160 transfers of 16 bytes
//    PDMA_start(PDMA_CHANNEL_5,
//               0x20000018,
//               SPIMASTERPORTS_4,
//               160);              // 160 transfers of 16 bytes
//    PDMA_start(PDMA_CHANNEL_6,
//               0x2000101E,
//               SPIMASTERPORTS_5,
//               160);              // 160 transfers of 16 bytes
             
  }
  else {
    printf("\nBinaryDMDacsCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (3 * sizeof(uint32_t)));
  }

  UART_polled_tx_string(&my_uart,(const uint8_t*)"end of vector ");
  return(ParamsLen);
}

int8_t BinaryDMAdcsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    if ( (NULL != Params) && (ParamsLen >= (3 * sizeof(AdcAccumulator))) )
	{
		const AdcAccumulator* AdcVals = reinterpret_cast<const AdcAccumulator*>(Params);
		printf("\nBinarySF2AdcsCommand: ");
		AdcVals[0].formatf();
		printf(" | ");
		AdcVals[1].formatf();
		printf(" | ");
		AdcVals[2].formatf();
		printf("\n\n");
	}
	else
	{
		printf("\nBinarySF2AdcsCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (3 * sizeof(AdcAccumulator)));
	}
    return(ParamsLen);
}
	
int8_t BinaryDMAdcsFloatingPointCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (3 * sizeof(double))) )
	{
		const double* AdcVals = reinterpret_cast<const double*>(Params);
		printf("\nBinarySF2AdcsFPCommand: %lf | %lf | %lf\n\n", AdcVals[0], AdcVals[1], AdcVals[2]);
	}
	else
	{
		printf("\nBinarySF2AdcsFPCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (3 * sizeof(double)));
	}
    return(ParamsLen);
}

int8_t BinaryDMStatusCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (3 * sizeof(double))) )
	{
		const CGraphDMStatusPayload* Status = reinterpret_cast<const CGraphDMStatusPayload*>(Params);

//		formatf("\n\nBinaryDMStatus Command: Values with corrected units follow:\n\n");
//		
//		formatf("P1V2: %3.6lf V\n", Status->P1V2);
//		formatf("P2V2: %3.6lf V\n", Status->P2V2);
//		formatf("P24V: %3.6lf V\n", Status->P24V);
//		formatf("P2V5: %3.6lf V\n", Status->P2V5);
//		formatf("P3V3A: %3.6lf V\n", Status->P3V3A);
//		formatf("P6V: %3.6lf V\n", Status->P6V);
//		formatf("P5V: %3.6lf V\n", Status->P5V);
//		formatf("P3V3D: %3.6lf V\n", Status->P3V3D);
//		formatf("P4V3: %3.6lf V\n", Status->P4V3);
//		formatf("N5V: %3.6lf V\n", Status->N5V);
//		formatf("N6V: %3.6lf V\n", Status->N6V);
//		formatf("P150V: %3.6lf V\n", Status->P150V);
//		
//		formatf("\n\nBinaryDMStatus Command complete.\n\n");
	}
	else
	{
		printf("\nBinaryDMAdcsFPCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (3 * sizeof(double)));
	}
    return(ParamsLen);
}

int8_t BinaryDMConfigDacsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument) {
  int board, dacNum;
  /* Configure all 24 of the DACs */

  // First reset and clear all DACs
  // Reset the DACs
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

  for (dacNum = 0; dacNum <24; dacNum++) {
    board = floor(dacNum/4);
    SpiContainer.configDacs(board, dacNum, 0x020000);
    SpiContainer.configDacs(board, dacNum, 0x030000);
    SpiContainer.configDacs(board, dacNum, 0x0B0000);
    SpiContainer.configDacs(board, dacNum, 0x818000);
    SpiContainer.configDacs(board, dacNum, 0x41ff00);
  }
  // Let's do this by dac on each board board
//  for (dacNum = 0; dacNum < 4; dacNum++) {
//    for (board = 0; board < 6; board++) {
//      
//      SpiContainer.configDacs(board, dacNum);
//    }
//  }
  // Now turn on HV on board
  //  MSS_GPIO_set_output(MSS_GPIO_6, 0); // set the PwrHVnEn 0.  HV power is now on!!!

  return(ParamsLen);
}

//This technically is a "BZIP2CRC32", not an "ANSICRC32"; seealso: https://crccalc.com/
uint32_t CRC32(const uint8_t* data, const size_t length)
{
	static const uint32_t table[256] = 
	{
    0x00000000UL,0x04C11DB7UL,0x09823B6EUL,0x0D4326D9UL,
    0x130476DCUL,0x17C56B6BUL,0x1A864DB2UL,0x1E475005UL,
    0x2608EDB8UL,0x22C9F00FUL,0x2F8AD6D6UL,0x2B4BCB61UL,
    0x350C9B64UL,0x31CD86D3UL,0x3C8EA00AUL,0x384FBDBDUL,
    0x4C11DB70UL,0x48D0C6C7UL,0x4593E01EUL,0x4152FDA9UL,
    0x5F15ADACUL,0x5BD4B01BUL,0x569796C2UL,0x52568B75UL,
    0x6A1936C8UL,0x6ED82B7FUL,0x639B0DA6UL,0x675A1011UL,
    0x791D4014UL,0x7DDC5DA3UL,0x709F7B7AUL,0x745E66CDUL,
    0x9823B6E0UL,0x9CE2AB57UL,0x91A18D8EUL,0x95609039UL,
    0x8B27C03CUL,0x8FE6DD8BUL,0x82A5FB52UL,0x8664E6E5UL,
    0xBE2B5B58UL,0xBAEA46EFUL,0xB7A96036UL,0xB3687D81UL,
    0xAD2F2D84UL,0xA9EE3033UL,0xA4AD16EAUL,0xA06C0B5DUL,
    0xD4326D90UL,0xD0F37027UL,0xDDB056FEUL,0xD9714B49UL,
    0xC7361B4CUL,0xC3F706FBUL,0xCEB42022UL,0xCA753D95UL,
    0xF23A8028UL,0xF6FB9D9FUL,0xFBB8BB46UL,0xFF79A6F1UL,
    0xE13EF6F4UL,0xE5FFEB43UL,0xE8BCCD9AUL,0xEC7DD02DUL,
    0x34867077UL,0x30476DC0UL,0x3D044B19UL,0x39C556AEUL,
    0x278206ABUL,0x23431B1CUL,0x2E003DC5UL,0x2AC12072UL,
    0x128E9DCFUL,0x164F8078UL,0x1B0CA6A1UL,0x1FCDBB16UL,
    0x018AEB13UL,0x054BF6A4UL,0x0808D07DUL,0x0CC9CDCAUL,
    0x7897AB07UL,0x7C56B6B0UL,0x71159069UL,0x75D48DDEUL,
    0x6B93DDDBUL,0x6F52C06CUL,0x6211E6B5UL,0x66D0FB02UL,
    0x5E9F46BFUL,0x5A5E5B08UL,0x571D7DD1UL,0x53DC6066UL,
    0x4D9B3063UL,0x495A2DD4UL,0x44190B0DUL,0x40D816BAUL,
    0xACA5C697UL,0xA864DB20UL,0xA527FDF9UL,0xA1E6E04EUL,
    0xBFA1B04BUL,0xBB60ADFCUL,0xB6238B25UL,0xB2E29692UL,
    0x8AAD2B2FUL,0x8E6C3698UL,0x832F1041UL,0x87EE0DF6UL,
    0x99A95DF3UL,0x9D684044UL,0x902B669DUL,0x94EA7B2AUL,
    0xE0B41DE7UL,0xE4750050UL,0xE9362689UL,0xEDF73B3EUL,
    0xF3B06B3BUL,0xF771768CUL,0xFA325055UL,0xFEF34DE2UL,
    0xC6BCF05FUL,0xC27DEDE8UL,0xCF3ECB31UL,0xCBFFD686UL,
    0xD5B88683UL,0xD1799B34UL,0xDC3ABDEDUL,0xD8FBA05AUL,
    0x690CE0EEUL,0x6DCDFD59UL,0x608EDB80UL,0x644FC637UL,
    0x7A089632UL,0x7EC98B85UL,0x738AAD5CUL,0x774BB0EBUL,
    0x4F040D56UL,0x4BC510E1UL,0x46863638UL,0x42472B8FUL,
    0x5C007B8AUL,0x58C1663DUL,0x558240E4UL,0x51435D53UL,
    0x251D3B9EUL,0x21DC2629UL,0x2C9F00F0UL,0x285E1D47UL,
    0x36194D42UL,0x32D850F5UL,0x3F9B762CUL,0x3B5A6B9BUL,
    0x0315D626UL,0x07D4CB91UL,0x0A97ED48UL,0x0E56F0FFUL,
    0x1011A0FAUL,0x14D0BD4DUL,0x19939B94UL,0x1D528623UL,
    0xF12F560EUL,0xF5EE4BB9UL,0xF8AD6D60UL,0xFC6C70D7UL,
    0xE22B20D2UL,0xE6EA3D65UL,0xEBA91BBCUL,0xEF68060BUL,
    0xD727BBB6UL,0xD3E6A601UL,0xDEA580D8UL,0xDA649D6FUL,
    0xC423CD6AUL,0xC0E2D0DDUL,0xCDA1F604UL,0xC960EBB3UL,
    0xBD3E8D7EUL,0xB9FF90C9UL,0xB4BCB610UL,0xB07DABA7UL,
    0xAE3AFBA2UL,0xAAFBE615UL,0xA7B8C0CCUL,0xA379DD7BUL,
    0x9B3660C6UL,0x9FF77D71UL,0x92B45BA8UL,0x9675461FUL,
    0x8832161AUL,0x8CF30BADUL,0x81B02D74UL,0x857130C3UL,
    0x5D8A9099UL,0x594B8D2EUL,0x5408ABF7UL,0x50C9B640UL,
    0x4E8EE645UL,0x4A4FFBF2UL,0x470CDD2BUL,0x43CDC09CUL,
    0x7B827D21UL,0x7F436096UL,0x7200464FUL,0x76C15BF8UL,
    0x68860BFDUL,0x6C47164AUL,0x61043093UL,0x65C52D24UL,
    0x119B4BE9UL,0x155A565EUL,0x18197087UL,0x1CD86D30UL,
    0x029F3D35UL,0x065E2082UL,0x0B1D065BUL,0x0FDC1BECUL,
    0x3793A651UL,0x3352BBE6UL,0x3E119D3FUL,0x3AD08088UL,
    0x2497D08DUL,0x2056CD3AUL,0x2D15EBE3UL,0x29D4F654UL,
    0xC5A92679UL,0xC1683BCEUL,0xCC2B1D17UL,0xC8EA00A0UL,
    0xD6AD50A5UL,0xD26C4D12UL,0xDF2F6BCBUL,0xDBEE767CUL,
    0xE3A1CBC1UL,0xE760D676UL,0xEA23F0AFUL,0xEEE2ED18UL,
    0xF0A5BD1DUL,0xF464A0AAUL,0xF9278673UL,0xFDE69BC4UL,
    0x89B8FD09UL,0x8D79E0BEUL,0x803AC667UL,0x84FBDBD0UL,
    0x9ABC8BD5UL,0x9E7D9662UL,0x933EB0BBUL,0x97FFAD0CUL,
    0xAFB010B1UL,0xAB710D06UL,0xA6322BDFUL,0xA2F33668UL,
    0xBCB4666DUL,0xB8757BDAUL,0xB5365D03UL,0xB1F740B4UL,
    };

	uint32_t crc = 0xffffffff;
	
	size_t len = length;
    while (len > 0)
    {
      crc = table[*data ^ ((crc >> 24) & 0xff)] ^ (crc << 8);
      data++;
      len--;
    }
    return crc ^ 0xffffffff;
}

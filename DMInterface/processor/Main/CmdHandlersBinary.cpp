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

//#include <sys/types.h>
//#include <sys/stat.h>
//#include <fcntl.h>
//#include <unistd.h>
//#include <sys/mman.h>
//#include <errno.h>
#include <unordered_map>
using namespace std;

#include "uart/BinaryUart.hpp"

#include "cgraph/CGraphPacket.hpp"

#include "cgraph/CGraphDMHardwareInterface.hpp"
extern CGraphDMHardwareInterface* DM;

#include "MainBuildNum"

#include "CmdTableBinary.hpp"
#include "MirrorMap.hpp"
//#include "drivers/mss_pdma/mss_pdma.h"


#define DriverBoards 6
#define DacPerBoard  4
#define ChanPerDac   40
#define NumSpiPorts  6
#define NO_OFFSET            0x00u

DACspi  SpiContainer;
//extern UART_instance_t my_uart;

int8_t BinaryVersionCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
  CGraphVersionPayload Version;
  Version.SerialNum = 0;
  Version.ProcessorFirmwareBuildNum = BuildNum;
  Version.FPGAFirmwareBuildNum = 0;

  if (DM) { 
    //    Version.SerialNum = DM->DeviceSerialNumber; 
    Version.FPGAFirmwareBuildNum = DM->FpgaFirmwareBuildNumber; 
  }
  printf("\nBinaryVersionCommand: Sending response (%u bytes): ", sizeof(CGraphVersionPayload));
  Version.formatf();
  printf("\n");
  TxBinaryPacket(Argument, CGraphPayloadTypeVersion, 0, &Version, sizeof(CGraphVersionPayload));
  
  //if ( (NULL != Params) && (ParamsLen >= sizeof(CGraphVersionPayload)) ) {
  //  const CGraphVersionPayload* Version = reinterpret_cast<const CGraphVersionPayload*>(Params);
  //  printf("\nBinaryVersionCommand: ");
  //  Version->formatf();
  //  printf("\n");
  //}
  //else {
  //  printf("\nBinaryVersionCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, sizeof(CGraphVersionPayload));
  //}
  //TxBinaryPacket(Argument, CGraphPayloadTypeVersion, 0, &Version, sizeof(CGraphVersionPayload));
  
  return(ParamsLen);
}

int8_t BinaryDMDacCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
  uint32_t board, dacNum, dacCh, data;
  const uint32_t* DacSetpoints = reinterpret_cast<const uint32_t*>(Params);
  
  if ( (NULL != Params) && (ParamsLen >= (4 * sizeof(uint32_t))) ) {
    //    const uint32_t* DacSetpoints = reinterpret_cast<const uint32_t*>(Params);
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
  else {
    printf("\nBinaryDMDacsCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (3 * sizeof(uint32_t)));
  }
        
  TxBinaryPacket(Argument, CGraphPayloadTypeDMDac, 0, DacSetpoints, 4*sizeof(uint32_t));
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
  //  UART_polled_tx_string(&my_uart,(const uint8_t*)"In BUart Cmd ");
  // Not really necessary, but we'll keep this test in to stay close to the original
  if ( (NULL != Params) && (ParamsLen >= (30 * sizeof(uint16_t))) )  {
    //    UART_polled_tx_string(&my_uart,(const uint8_t*)"Sending back params ");
    //    UART_polled_tx_string(&my_uart,(const uint8_t*)Params);  // Send the string right back
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
  //  UART_polled_tx_string(&my_uart,(const uint8_t*)"In Vector Cmd ");
  esram_addr = 0x20000000;
  // This will normally be a vector of all 952 mirror set points
  // if ( (NULL != Params) && (ParamsLen >= (952 * sizeof(uint16_t))) )  
  // But let's start with 18 data points and then expand
  // This gives us 3 data points per spi
  // Try just one parameter and see if that works.  We may be getting
  // a boundry problem from one data location tot another
  if ( (NULL != Params) && (ParamsLen >= (30 * sizeof(uint16_t))) )  {
    
    const uint16_t* DMSetPoints = reinterpret_cast<const uint16_t*>(Params);
    //    UART_polled_tx_string(&my_uart,(const uint8_t*)"Have Params ");
    size_t numElements = sizeof(Params)/sizeof(uint16_t);
    

    // Write to the memory locations
    for (ii=0; ii <ParamsLen/2; ii++) {
//      PDMA_start(PDMA_CHANNEL_0,
//                 (uint32_t)(DMSetPoints+ii),
//                 esram_addr+2*ii,
//                 1);
      do {
//        status = PDMA_status(PDMA_CHANNEL_0);
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
      
//      MSS_GPIO_set_output(MSS_GPIO_1, 0); // begin a SPI transaction clear rst to low
//      PDMA_start(PDMA_CHANNEL_1,
//                 esram_addr+2*ii,
//                 0, //SPIMASTERPORTS_0,
//                 1);              // 160 transfers of 16 bytes
    
//    while(!xferDone) {
//        xferDone = (MSS_GPIO_get_inputs() & MSS_GPIO_2_MASK);
//      }
//      MSS_GPIO_set_output(MSS_GPIO_1, 1); // SPI transaction done, set rst high
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

    //  UART_polled_tx_string(&my_uart,(const uint8_t*)"end of vector ");
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

int8_t BinaryDMTelemetryCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (3 * sizeof(double))) )
	{
		const CGraphDMTelemetryPayload* Status = reinterpret_cast<const CGraphDMTelemetryPayload*>(Params);

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

int8_t BinaryDMDacConfigCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument) {
  int board, dacNum;
  /* Configure all 24 of the DACs */

  // First reset and clear all DACs
  // Reset the DACs
//  MSS_GPIO_set_output(MSS_GPIO_5,0); // set nRstDacs to 0
//  for (int ii; ii < 10000; ii++) {  // a delay
//    MSS_GPIO_set_output(MSS_GPIO_5,0); // set nRstDacs to 0
//  }
//  MSS_GPIO_set_output(MSS_GPIO_5,1); // set nRstDacs to 1
  // Dacs are now reset

  // Clear the Dacs
//  MSS_GPIO_set_output(MSS_GPIO_3,0); // set nClrDacs to 0
//  for (int ii; ii < 10000; ii++) {  // a delay
//    MSS_GPIO_set_output(MSS_GPIO_3,0); // set nClrDacs to 0
//  }
//  MSS_GPIO_set_output(MSS_GPIO_3,1); // set nClrDacs to 1
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



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
extern CGraphDMRamInterface* dRAM;

#include "MainBuildNum"

#include "CmdTableBinary.hpp"
#include "MirrorMap.hpp"
//#include "drivers/mss_pdma/mss_pdma.h"

DACspi  SpiContainer;

CGraphDMMappings DMMappings;

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
    const uint32_t* DacSetpoints = reinterpret_cast<const uint32_t*>(Params);
    printf("\nBinaryDMDacsCommand: 0x%lX | 0x%lX | 0x%lX | 0x%lX\n\n", DacSetpoints[0], DacSetpoints[1], DacSetpoints[2], DacSetpoints[3]);
    board = DacSetpoints[0];
    dacNum = DacSetpoints[1];
    dacCh = DacSetpoints[2];
    data = DacSetpoints[3];

    // This only has to write to the memory.  It no longer has to send out an spi command
//  So this part is now obsolete.  Maybe even MirrorMap.hpp can go away
//    SpiContainer.sendSingleDacSpi(DacSetpoints[0],
//                                  DacSetpoints[1],
//                                  DacSetpoints[2],
//                                  DacSetpoints[3]); // param1: board number (don't care); param2: dac number
  }
  else {
    printf("\nBinaryDMDacsCommand: Short packet: %u (exptected %u bytes): ", ParamsLen, (3 * sizeof(uint32_t)));
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
  //~ volatile uint32_t status;
  //~ uint32_t          esram_addr;
  //~ uint16_t          echodata[160];  // max number of elements
  //~ int               ii,xferDone=0;
  

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
  volatile uint32_t status = 0;
  uint32_t          esram_addr;
  //~ uint16_t          echodata[160];  // max number of elements
  unsigned int               ii;
  //~ unsigned int xferDone=0;
  

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
    
    //~ const uint16_t* DMSetPoints = reinterpret_cast<const uint16_t*>(Params);
    //    UART_polled_tx_string(&my_uart,(const uint8_t*)"Have Params ");
    //~ size_t numElements = sizeof(Params)/sizeof(uint16_t);
    

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
    printf("\nBinaryDMDacsCommand: Short packet: %u (exptected %u bytes): ", ParamsLen, (3 * sizeof(uint32_t)));
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
		printf("\nBinarySF2AdcsCommand: Short packet: %u (exptected %u bytes): ", ParamsLen, (3 * sizeof(AdcAccumulator)));
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
		printf("\nBinarySF2AdcsFPCommand: Short packet: %u (exptected %u bytes): ", ParamsLen, (3 * sizeof(double)));
	}
    return(ParamsLen);
}

int8_t BinaryDMTelemetryCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (NULL != Params) && (ParamsLen >= (3 * sizeof(double))) )
	{
		//~ const CGraphDMTelemetryPayload* Status = reinterpret_cast<const CGraphDMTelemetryPayload*>(Params);

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
		printf("\nBinaryDMAdcsFPCommand: Short packet: %u (exptected %u bytes): ", ParamsLen, (3 * sizeof(double)));
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

int8_t BinaryDMMappingCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (nullptr != Params) && (ParamsLen > sizeof(CGraphDMPixelPayloadHeader)) )
	{
		//Find a start index followed by some mappings
		const CGraphDMPixelPayloadHeader PixelHeader = *reinterpret_cast<const CGraphDMPixelPayloadHeader*>(Params);
		const unsigned long StartPixel = PixelHeader.StartPixel;
		if (StartPixel > DMMaxActuators) 
		{
			printf("\nBinaryDMMappingCommand: Invalid StartPixel: %lu!\n", (unsigned long)StartPixel);
			TxBinaryPacket(Argument, CGraphPayloadTypeDMMappings, 0, &StartPixel, sizeof(uint16_t));
		}
		else
		{
			unsigned long NumPixels = (ParamsLen - sizeof(CGraphDMPixelPayloadHeader)) / sizeof(CGraphDMMappingPayload);
			if ((NumPixels + StartPixel) > DMMaxActuators) { NumPixels = DMMaxActuators - StartPixel; }
			
			printf("\nBinaryDMMappingCommand: StartPixel: %lu, NumPixels: %lu\n", StartPixel, NumPixels);
			
			for (size_t i = StartPixel; i < (StartPixel + NumPixels); i++)
			{
				const CGraphDMMappingPayload Mapping = *reinterpret_cast<const CGraphDMMappingPayload*>(Params+sizeof(CGraphDMPixelPayloadHeader)+((i - StartPixel)*sizeof(CGraphDMMappingPayload)));
				if (Mapping.ControllerBoardIndex >= DMMaxControllerBoards)
				{
					printf("\nBinaryDMMappingCommand: Invalid Controller Board for mapping %lu: %lu!\n", (unsigned long)i, (unsigned long)Mapping.ControllerBoardIndex);
				}
				else
				{
					if (Mapping.DacIndex >= DMMDacsPerControllerBoard)
					{
						printf("\nBinaryDMMappingCommand: Invalid Dac Number for mapping %lu: %lu!\n", (unsigned long)i, (unsigned long)Mapping.DacIndex);
					}
					else
					{
						if (Mapping.DacChannel >= DMActuatorsPerDac)
						{
							printf("\nBinaryDMMappingCommand: Invalid Dac channel for mapping %lu: %lu!\n", (unsigned long)i, (unsigned long)Mapping.DacChannel);
						}
						else
						{
							//Yay! Finally valid data!
							DMMappings.Mappings[i] = Mapping;
							printf("\nBinaryDMMappingCommand: Set mapping %lu to ", (unsigned long)i);
							Mapping.formatf();
							printf("\n\n");
						}
					}
				}
			}
			TxBinaryPacket(Argument, CGraphPayloadTypeDMMappings, 0, &NumPixels, sizeof(uint16_t));
		}
	}
	//Query
	else
	{
		printf("\nBinaryDMMappingCommand: Empty packet, returning query\n");
		uint8_t Buffer[(DMMaxActuators * sizeof(CGraphDMMappingPayload)) + sizeof(CGraphDMPixelPayloadHeader)];
		uint16_t StartPix = 0;
		memcpy(Buffer, &StartPix, sizeof(CGraphDMPixelPayloadHeader));
		memcpy(&(Buffer[sizeof(CGraphDMPixelPayloadHeader)]), DMMappings.Mappings, sizeof(CGraphDMMappingPayload) * DMMaxActuators);
		
		TxBinaryPacket(Argument, CGraphPayloadTypeDMMappings, 0, Buffer, (sizeof(CGraphDMMappingPayload) * DMMaxActuators) + sizeof(CGraphDMPixelPayloadHeader));
	}
	
    return(ParamsLen);
}

int8_t BinaryDMShortPixelsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if (nullptr == DM)
	{
		printf("\nBinaryDMShortPixelsCommand: DM pointer is NULL! Firmware corrupted!\n");	
		return(ParamsLen);
	}
		
	if ( (nullptr != Params) && (ParamsLen >= sizeof(CGraphDMPixelPayloadHeader)) )
	{
		//ok, first we're looking for a packet with the start pixel and some pix's in it:
		const CGraphDMPixelPayloadHeader PixelHeader = *reinterpret_cast<const CGraphDMPixelPayloadHeader*>(Params);
                const unsigned long StartPixel = PixelHeader.StartPixel;  // Used to be const
                TxBinaryPacket(Argument, CGraphPayloadTypeDMShortPixels, 0, &StartPixel, sizeof(uint16_t));  // Reply with start pixel no matter what
		if (StartPixel > DMMaxActuators) 
		{
			//Complain and bail out, something is horribly wrong:
			printf("\nBinaryDMShortPixelsCommand: Invalid StartPixel: %lu!\n", (unsigned long)StartPixel);
			TxBinaryPacket(Argument, CGraphPayloadTypeDMShortPixels, 0, &StartPixel, sizeof(uint16_t));
		}
		else // start pixel less than DMMaxActuators
		{
			//Now do we have some actual pix to set?
			if (ParamsLen >= sizeof(CGraphDMPixelPayloadHeader))
			{
				unsigned long NumPixels = (ParamsLen - sizeof(CGraphDMPixelPayloadHeader)) / sizeof(uint16_t);
    
				if ((NumPixels + StartPixel) > DMMaxActuators) { NumPixels = DMMaxActuators - StartPixel; } //do let's try not to blow our array...
				
				printf("\nBinaryDMShortPixelsCommand: StartPixel: %lu, NumPixels: %lu\n", StartPixel, NumPixels);
				
				for (size_t i = StartPixel; i < (StartPixel + NumPixels); i++)
				{
					//pull a pix out of the packet:
					const uint16_t DacVal = *reinterpret_cast<const uint16_t*>(Params+sizeof(CGraphDMPixelPayloadHeader)+((i - StartPixel)*sizeof(uint16_t)));
					//What D/A ram does this pix belong to?
					if ( (DMMappings.Mappings[i].ControllerBoardIndex >= DMMaxControllerBoards) || (DMMappings.Mappings[i].ControllerBoardIndex >= DMMaxControllerBoards) || (DMMappings.Mappings[i].ControllerBoardIndex >= DMMaxControllerBoards) )
					{
						printf("\nBinaryDMShortPixelsCommand: Invalid mapping %lu; please reinitialize mappings!: ", (unsigned long)i);
						DMMappings.Mappings[i].formatf();
						printf("\n\n");
					}
					//Yay, we got here, things are actaully correct and we have something to do!
					else
					{
                                          uint8_t board = DMMappings.Mappings[i].ControllerBoardIndex; // 3;
                                          uint8_t dac = DMMappings.Mappings[i].DacIndex; // 4;
                                          uint8_t channel = DMMappings.Mappings[i].DacChannel; // 5;

                                          //TxBinaryPacket(Argument, CGraphPayloadTypeDMShortPixels, 0, &i, sizeof(size_t));
                                          TxBinaryPacket(Argument, CGraphPayloadTypeDMShortPixels, 0, &board, sizeof(uint8_t));
                                          TxBinaryPacket(Argument, CGraphPayloadTypeDMShortPixels, 0, &dac, sizeof(uint8_t));
                                          TxBinaryPacket(Argument, CGraphPayloadTypeDMShortPixels, 0, &channel, sizeof(uint8_t));

                                          // Writing to DM->DacSetpoints is causing the porblems.
                                          dRAM->DacSetpoints[board][dac][3] = ((uint32_t)DacVal);// << 8; // cause we really want 24b values when we dither
                                          //DM->DacSetpoints[i][i][i] = ((uint32_t)DacVal); //<<8 cause we really want 24b values when we dither
                                          printf("\nBinaryDMShortPixelsCommand: Set actuator %lu to %lu", (unsigned long)i, (unsigned long)DacVal);
					}			
				}
				
				//Ok, tell them how many we wrote (i.e. 952, or maybe 16 or something if we shorten the packets)(note there are no errors if the mappings aren't set right now it will silently fail every time)
				TxBinaryPacket(Argument, CGraphPayloadTypeDMShortPixels, 0, &NumPixels, sizeof(uint16_t));
			}
			else // ParamsLen >= sizeof(CGraphDMPixelPayloadHeader)
			{
				printf("\nBinaryDMMappingCommand: Short packet: %u (exptected >%u bytes): ", ParamsLen, (sizeof(CGraphDMPixelPayloadHeader)));
				TxBinaryPacket(Argument, CGraphPayloadTypeDMShortPixels, 0, &StartPixel, sizeof(uint16_t));
			}
		}
	}
	//empty packet? query.
	else
	{
		//Not sure what to do besides send back the whole entire block!
		uint8_t Buffer[(DMMaxActuators * sizeof(uint16_t)) + sizeof(CGraphDMPixelPayloadHeader)];
		uint16_t StartPix = 0;
		memcpy(Buffer, &StartPix, sizeof(CGraphDMPixelPayloadHeader));
		for (size_t j = 0; j < DMMaxActuators; j++)
		{
			uint16_t* Pixel = reinterpret_cast<uint16_t*>(Buffer+sizeof(CGraphDMPixelPayloadHeader)+(j*sizeof(uint16_t)));
			*Pixel = (reinterpret_cast<uint32_t*>(DM->DacSetpoints)[j] >> 8);
		}
		TxBinaryPacket(Argument, CGraphPayloadTypeDMShortPixels, 0, Buffer, sizeof(CGraphDMPixelPayloadHeader) + (sizeof(uint16_t) * DMMaxControllerBoards * DMMDacsPerControllerBoard * DMActuatorsPerDac));
	}
		
    return(ParamsLen);
}


int8_t BinaryDMDitherCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if (nullptr == DM)
	{
		printf("\nBinaryDMDitherCommand: DM pointer is NULL! Firmware corrupted!\n");	
		return(ParamsLen);
	}

	if ( (nullptr != Params) && (ParamsLen >= sizeof(CGraphDMPixelPayloadHeader)) )
	{
		//ok, first we're looking for a packet with the start pixel and some pix's in it:
		const CGraphDMPixelPayloadHeader PixelHeader = *reinterpret_cast<const CGraphDMPixelPayloadHeader*>(Params);
		const unsigned long StartPixel = PixelHeader.StartPixel;
		if (StartPixel > DMMaxActuators) 
		{
			//Complain and bail out, something is horribly wrong:
			printf("\nBinaryDMDitherCommand: Invalid StartPixel: %lu!\n", (unsigned long)StartPixel);
			TxBinaryPacket(Argument, CGraphPayloadTypeDMDither, 0, &StartPixel, sizeof(uint16_t));
		}
		else
		{
			//Now do we have some actual pix to set?
			if (ParamsLen >= sizeof(CGraphDMPixelPayloadHeader))
			{
				unsigned long NumPixels = (ParamsLen - sizeof(CGraphDMPixelPayloadHeader)) / sizeof(uint8_t);
				if ((NumPixels + StartPixel) > DMMaxActuators) { NumPixels = DMMaxActuators - StartPixel; } //do let's try not to blow our array...
				
				printf("\nBinaryDMDitherCommand: StartPixel: %lu, NumPixels: %lu\n", StartPixel, NumPixels);
				
				for (size_t i = StartPixel; i < (StartPixel + NumPixels); i++)
				{
					//pull a pix out of the packet:
					const uint8_t DacVal = *reinterpret_cast<const uint8_t*>(Params+sizeof(CGraphDMPixelPayloadHeader)+((i - StartPixel)*sizeof(uint8_t)));
					
					//What D/A ram does this pix belong to?
					if ( (DMMappings.Mappings[i].ControllerBoardIndex >= DMMaxControllerBoards) || (DMMappings.Mappings[i].ControllerBoardIndex >= DMMaxControllerBoards) || (DMMappings.Mappings[i].ControllerBoardIndex >= DMMaxControllerBoards) )
					{
						printf("\nBinaryDMDitherCommand: Invalid mapping %lu; please reinitialize mappings!: ", (unsigned long)i);
						DMMappings.Mappings[i].formatf();
						printf("\n\n");
					}
					//Yay, we got here, things are actaully correct and we have something to do!
					else
					{
						DM->DacSetpoints[DMMappings.Mappings[i].ControllerBoardIndex][DMMappings.Mappings[i].DacIndex][DMMappings.Mappings[i].DacChannel] |= (uint32_t)DacVal; //note value is OR'ed in, high bytes never get altered by this command...
						printf("\nBinaryDMDitherCommand: Set actuator %lu to %lu", (unsigned long)i, (unsigned long)DacVal);
					}			
				}
				
				//Ok, tell them how many we wrote (i.e. 952, or maybe 16 or something if we Ditheren the packets)(note there are no errors if the mappings aren't set right now it will silently fail every time)
				TxBinaryPacket(Argument, CGraphPayloadTypeDMDither, 0, &NumPixels, sizeof(uint16_t));
			}
			else
			{
				printf("\nBinaryDMMappingCommand: Dither packet: %u (exptected >%u bytes): ", ParamsLen, (sizeof(CGraphDMPixelPayloadHeader)));
				TxBinaryPacket(Argument, CGraphPayloadTypeDMDither, 0, &StartPixel, sizeof(uint16_t));
			}
		}
	}
	//empty packet? query.
	else
	{
		//Not sure what to do besides send back the whole entire block!
		uint8_t Buffer[(DMMaxActuators * sizeof(uint16_t)) + sizeof(CGraphDMPixelPayloadHeader)];
		uint16_t StartPix = 0;
		memcpy(Buffer, &StartPix, sizeof(CGraphDMPixelPayloadHeader));
		for (size_t j = 0; j < DMMaxActuators; j++)
		{
			uint8_t* Pixel = reinterpret_cast<uint8_t*>(Buffer+sizeof(CGraphDMPixelPayloadHeader)+(j*sizeof(uint8_t)));
			*Pixel = (reinterpret_cast<uint32_t*>(DM->DacSetpoints)[j] & 0x000000FFUL);
		}
		TxBinaryPacket(Argument, CGraphPayloadTypeDMDither, 0, Buffer, sizeof(CGraphDMPixelPayloadHeader) + (sizeof(uint8_t) * DMMaxControllerBoards * DMMDacsPerControllerBoard * DMActuatorsPerDac));
	}
		
    return(ParamsLen);
}
int8_t BinaryDMLongPixelsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if (nullptr == DM)
	{
		printf("\nBinaryDMLongPixelsCommand: DM pointer is NULL! Firmware corrupted!\n");	
		return(ParamsLen);
	}

	if ( (nullptr != Params) && (ParamsLen >= sizeof(CGraphDMPixelPayloadHeader)) )
	{
		//ok, first we're looking for a packet with the start pixel and some pix's in it:
		const CGraphDMPixelPayloadHeader PixelHeader = *reinterpret_cast<const CGraphDMPixelPayloadHeader*>(Params);
		const unsigned long StartPixel = PixelHeader.StartPixel;
		if (StartPixel > DMMaxActuators) 
		{
			//Complain and bail out, something is horribly wrong:
			printf("\nBinaryDMLongPixelsCommand: Invalid StartPixel: %lu!\n", (unsigned long)StartPixel);
			TxBinaryPacket(Argument, CGraphPayloadTypeDMLongPixels, 0, &StartPixel, sizeof(uint16_t));
		}
		else
		{
			//Now do we have some actual pix to set?
			if (ParamsLen >= sizeof(CGraphDMPixelPayloadHeader))
			{
				unsigned long NumPixels = (ParamsLen - sizeof(CGraphDMPixelPayloadHeader)) / (3 * sizeof(uint8_t));
				if ((NumPixels + StartPixel) > DMMaxActuators) { NumPixels = DMMaxActuators - StartPixel; } //do let's try not to blow our array...
				
				printf("\nBinaryDMLongPixelsCommand: StartPixel: %lu, NumPixels: %lu\n", StartPixel, NumPixels);
				
				for (size_t i = StartPixel; i < (StartPixel + NumPixels); i++)
				{
					//pull a pix out of the packet:
					const uint32_t DacVal = *reinterpret_cast<const uint32_t*>(Params+sizeof(CGraphDMPixelPayloadHeader)+((i - StartPixel)*3*sizeof(uint8_t))); //Note the "*3" for 24-bit pixels!!!
					
					//What D/A ram does this pix belong to?
					if ( (DMMappings.Mappings[i].ControllerBoardIndex >= DMMaxControllerBoards) || (DMMappings.Mappings[i].ControllerBoardIndex >= DMMaxControllerBoards) || (DMMappings.Mappings[i].ControllerBoardIndex >= DMMaxControllerBoards) )
					{
						printf("\nBinaryDMLongPixelsCommand: Invalid mapping %lu; please reinitialize mappings!: ", (unsigned long)i);
						DMMappings.Mappings[i].formatf();
						printf("\n\n");
					}
					//Yay, we got here, things are actaully correct and we have something to do!
					else
					{
						DM->DacSetpoints[DMMappings.Mappings[i].ControllerBoardIndex][DMMappings.Mappings[i].DacIndex][DMMappings.Mappings[i].DacChannel] = DacVal & 0x00FFFFFF; //mask off the byte we picked up from the last pixel since there's no concept of a "uint24_t"
						printf("\nBinaryDMLongPixelsCommand: Set actuator %lu to %lu", (unsigned long)i, (unsigned long)DacVal);
					}			
				}
				
				//Ok, tell them how many we wrote (i.e. 952, or maybe 16 or something if we Longen the packets)(note there are no errors if the mappings aren't set right now it will silently fail every time)
				TxBinaryPacket(Argument, CGraphPayloadTypeDMLongPixels, 0, &NumPixels, sizeof(uint16_t));
			}
			else
			{
				printf("\nBinaryDMMappingCommand: Long packet: %u (exptected >%u bytes): ", ParamsLen, (sizeof(CGraphDMPixelPayloadHeader)));
				TxBinaryPacket(Argument, CGraphPayloadTypeDMLongPixels, 0, &StartPixel, sizeof(uint16_t));
			}
		}
	}
	//empty packet? query.
	else
	{
		//Not sure what to do besides send back the whole entire block!
		uint8_t Buffer[(DMMaxActuators * 3 * sizeof(uint8_t)) + sizeof(CGraphDMPixelPayloadHeader)];
		uint16_t StartPix = 0;
		memcpy(Buffer, &StartPix, sizeof(CGraphDMPixelPayloadHeader));
		for (size_t j = 0; j < DMMaxActuators; j++)
		{
			uint8_t* Pixel = reinterpret_cast<uint8_t*>(Buffer+sizeof(CGraphDMPixelPayloadHeader)+(j*3*sizeof(uint8_t)));
			Pixel[0] = (uint8_t)(reinterpret_cast<uint32_t*>(DM->DacSetpoints)[j] & 0x000000FFUL);
			Pixel[1] = (uint8_t)((reinterpret_cast<uint32_t*>(DM->DacSetpoints)[j] & 0x0000FF00UL) >> 8);
			Pixel[2] = (uint8_t)((reinterpret_cast<uint32_t*>(DM->DacSetpoints)[j] & 0x00FF0000UL) >> 16);
		}
		TxBinaryPacket(Argument, CGraphPayloadTypeDMLongPixels, 0, Buffer, sizeof(CGraphDMPixelPayloadHeader) + (sizeof(uint8_t) * 3 * DMMaxControllerBoards * DMMDacsPerControllerBoard * DMActuatorsPerDac));
	}
		
    return(ParamsLen);
}


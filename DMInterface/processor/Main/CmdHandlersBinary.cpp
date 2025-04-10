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
  
  return(ParamsLen);
}

int8_t BinaryDMDacCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
        
  TxBinaryPacket(Argument, CGraphPayloadTypeDMDac, 0, (void*)dRAM->DacSetpoints[0][0][0], 4*sizeof(uint32_t));
  return(ParamsLen);
}

//int8_t BinaryDMUartCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
//{
//  //~ volatile uint32_t status;
//  //~ uint32_t          esram_addr;
//  //~ uint16_t          echodata[160];  // max number of elements
//  //~ int               ii,xferDone=0;
//  
//
//  // This is to test the Uart and see if the UART us indeed setting the limit on amount of data
//  // Check to see we're getting here
//  //  UART_polled_tx_string(&my_uart,(const uint8_t*)"In BUart Cmd ");
//  // Not really necessary, but we'll keep this test in to stay close to the original
//  if ( (NULL != Params) && (ParamsLen >= (30 * sizeof(uint16_t))) )  {
//    //    UART_polled_tx_string(&my_uart,(const uint8_t*)"Sending back params ");
//    //    UART_polled_tx_string(&my_uart,(const uint8_t*)Params);  // Send the string right back
//    //    UART_polled_tx_string(&my_uart,(const uint8_t*)DMSetPoints[1]);  // Send the string right back
//  }
//  return(ParamsLen);
//}

//int8_t BinaryDMVectorCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
//{
//  return(ParamsLen);
//}

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
    SpiContainer.configDacs(board, dacNum, 0x020000); // offset register 0
    SpiContainer.configDacs(board, dacNum, 0x030000); // offset register 1
    SpiContainer.configDacs(board, dacNum, 0x0B0000); // Block write nA/B select registers
    SpiContainer.configDacs(board, dacNum, 0x818000); // Write to gain (M) register
    SpiContainer.configDacs(board, dacNum, 0x41ff00); // Write to offset (C) register
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
                const unsigned long StartPixel = PixelHeader.StartPixel;
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
                                          uint8_t board = DMMappings.Mappings[i].ControllerBoardIndex;
                                          uint8_t dac = DMMappings.Mappings[i].DacIndex;
                                          uint8_t channel = DMMappings.Mappings[i].DacChannel;
                                          uint32_t spiBits = 0; // initialize to 0

                                          formatf("%p", (void*)&dRAM->DacSetpoints[board][dac][channel]);
                                          // Get Dac address for the SPI
                                          //addrByte = DACaddr[channel]; // the top 8 bits of the SPI stream determine the dac channel written
                                          spiBits = DacVal + (DACaddr[channel] << 16); // shift the address and add to the DacVal

                                          // Send off to memory
                                          dRAM->DacSetpoints[board][dac][channel] = (spiBits);
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
			*Pixel = (reinterpret_cast<uint32_t*>(dRAM->DacSetpoints)[j] >> 8);
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
						dRAM->DacSetpoints[DMMappings.Mappings[i].ControllerBoardIndex][DMMappings.Mappings[i].DacIndex][DMMappings.Mappings[i].DacChannel] |= (uint32_t)DacVal; //note value is OR'ed in, high bytes never get altered by this command...
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
			*Pixel = (reinterpret_cast<uint32_t*>(dRAM->DacSetpoints)[j] & 0x000000FFUL);
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
						dRAM->DacSetpoints[DMMappings.Mappings[i].ControllerBoardIndex][DMMappings.Mappings[i].DacIndex][DMMappings.Mappings[i].DacChannel] = DacVal & 0x00FFFFFF; //mask off the byte we picked up from the last pixel since there's no concept of a "uint24_t"
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
			Pixel[0] = (uint8_t)(reinterpret_cast<uint32_t*>(dRAM->DacSetpoints)[j] & 0x000000FFUL);
			Pixel[1] = (uint8_t)((reinterpret_cast<uint32_t*>(dRAM->DacSetpoints)[j] & 0x0000FF00UL) >> 8);
			Pixel[2] = (uint8_t)((reinterpret_cast<uint32_t*>(dRAM->DacSetpoints)[j] & 0x00FF0000UL) >> 16);
		}
		TxBinaryPacket(Argument, CGraphPayloadTypeDMLongPixels, 0, Buffer, sizeof(CGraphDMPixelPayloadHeader) + (sizeof(uint8_t) * 3 * DMMaxControllerBoards * DMMDacsPerControllerBoard * DMActuatorsPerDac));
	}
		
    return(ParamsLen);
}


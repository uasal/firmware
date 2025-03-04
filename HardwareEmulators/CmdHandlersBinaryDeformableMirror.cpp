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
#include <sys/mman.h>
#include <errno.h>
#include <unordered_map>
using namespace std;

#include "cgraph/CGraphPacket.hpp"

#include "uart/BinaryUart.hpp"

#include "cgraph/CGraphDMHardwareInterface.hpp"
extern CGraphDMHardwareInterface* DM;;

#include "CmdTableBinary.hpp"

CGraphDMMappings DMMappings;

// These are what's returned from the Control Interface
int8_t BinaryDMDacCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//~ if ( (nullptr != Params) && (ParamsLen >= 4*(sizeof(uint32_t))) )
	//~ {
		//~ const uint32_t DacParameters = *reinterpret_cast<const uint32_t*>(Params);
		//~ printf("\nBinaryDacCommand: Setting a mirror voltage: %lu\n", (unsigned long)DacParameters);
	//~ }
	//~ else
	//~ {
		//~ printf("\nBinaryDacCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (sizeof(uint32_t)));
	//~ }
		
	TxBinaryPacket(Argument, CGraphPayloadTypeDMDac, 0, Params, ParamsLen);
    return(ParamsLen);
}

int8_t BinaryDMTelemetryCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	formatf("\nBinaryDMTelemetryADCCommand: processing(%u)...\n\n", ParamsLen);

	CGraphDMTelemetryPayload Status;
	
	Status.P1V2 = 1.2;
	Status.P2V2 = 2.2;
	Status.P28V = 28.0;
	Status.P2V5 = 2.5;
	Status.P6V = 6.0;
	Status.P5V = 5.0;
	Status.P3V3D = 3.3;
	Status.P4V3 = 4.3;
	Status.P2I2 = 0.010;
	Status.P4I3 = 0.100;
	Status.P6I = 0.020;

	formatf("\n\nBinaryDMTelemetryADCCommand: CurrentValues:\n\n");
	
	formatf("P1V2: %3.6lf V\n", Status.P1V2);
	formatf("P2V2: %3.6lf V\n", Status.P2V2);
	formatf("P28V: %3.6lf V\n", Status.P28V);
	formatf("P2V5: %3.6lf V\n", Status.P2V5);
	formatf("P6V: %3.6lf V\n", Status.P6V);
	formatf("P5V: %3.6lf V\n", Status.P5V);
	formatf("P3V3D: %3.6lf V\n", Status.P3V3D);
	formatf("P4V3: %3.6lf V\n", Status.P4V3);
	formatf("P2I2: %3.6lf V\n", Status.P2I2);
	formatf("P4I3: %3.6lf V\n", Status.P4I3);
	formatf("P6I: %3.6lf V\n", Status.P6I);

	formatf("\nBinaryDMTelemetryADCCommand: Replying...\n");
	TxBinaryPacket(Argument, CGraphPayloadTypeDMTelemetry, 0, &Status, sizeof(CGraphDMTelemetryPayload));

	return(ParamsLen);
}

int8_t BinaryDMHVSwitchCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//~ if ( (nullptr != Params) && (ParamsLen >= (sizeof(uint32_t))) )
	//~ {
		//~ const uint32_t FilterSelect = *reinterpret_cast<const uint32_t*>(Params);
		//~ printf("\nBinaryHVSwitchCommand: FilterSelected(0=select inprogress): %lu\n", (unsigned long)FilterSelect);
	//~ }
	//~ else
	//~ {
		//~ printf("\nBinaryHVSwitchCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (sizeof(uint32_t)));
	//~ }
	TxBinaryPacket(Argument, CGraphPayloadTypeDMHVSwitch, 0, Params, ParamsLen);
    return(ParamsLen);
}

int8_t BinaryDMDacConfigCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//~ if ( (nullptr != Params) && (ParamsLen >= (sizeof(uint32_t))) )
	//~ {
		//~ const uint32_t FilterSelect = *reinterpret_cast<const uint32_t*>(Params);
		//~ printf("\nBinaryDacConfigCommand: FilterSelected(0=select inprogress): %lu\n", (unsigned long)FilterSelect);
	//~ }
	//~ else
	//~ {
          //~ printf("\nI am not sending anything back right now.  Work in progress...");
		//~ printf("\nBinaryDacConfigCommand: Short packet: %lu (exptected %lu bytes): ", ParamsLen, (sizeof(uint32_t)));
	//~ }
	TxBinaryPacket(Argument, CGraphPayloadTypeDMDacConfig, 0, Params, ParamsLen);
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
		if (StartPixel > DMMaxActuators) 
		{
			//Complain and bail out, something is horribly wrong:
			printf("\nBinaryDMShortPixelsCommand: Invalid StartPixel: %lu!\n", (unsigned long)StartPixel);
			TxBinaryPacket(Argument, CGraphPayloadTypeDMShortPixels, 0, &StartPixel, sizeof(uint16_t));
		}
		else
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
						DM->DacSetpoints[DMMappings.Mappings[i].ControllerBoardIndex][DMMappings.Mappings[i].DacIndex][DMMappings.Mappings[i].DacChannel] = ((uint32_t)DacVal) << 8; //<<8 cause we really want 24b values when we dither
						printf("\nBinaryDMShortPixelsCommand: Set actuator %lu to %lu", (unsigned long)i, (unsigned long)DacVal);
					}			
				}
				
				//Ok, tell them how many we wrote (i.e. 952, or maybe 16 or something if we shorten the packets)(note there are no errors if the mappings aren't set right now it will silently fail every time)
				TxBinaryPacket(Argument, CGraphPayloadTypeDMShortPixels, 0, &NumPixels, sizeof(uint16_t));
			}
			else
			{
				printf("\nBinaryDMMappingCommand: Short packet: %lu (exptected >%lu bytes): ", ParamsLen, (sizeof(CGraphDMPixelPayloadHeader)));
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
		printf("\nBinaryDMShortPixelsCommand: DM pointer is NULL! Firmware corrupted!\n");	
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
				printf("\nBinaryDMMappingCommand: Dither packet: %lu (exptected >%lu bytes): ", ParamsLen, (sizeof(CGraphDMPixelPayloadHeader)));
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
		printf("\nBinaryDMShortPixelsCommand: DM pointer is NULL! Firmware corrupted!\n");	
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
				printf("\nBinaryDMMappingCommand: Long packet: %lu (exptected >%lu bytes): ", ParamsLen, (sizeof(CGraphDMPixelPayloadHeader)));
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
		TxBinaryPacket(Argument, CGraphPayloadTypeDMShortPixels, 0, Buffer, sizeof(CGraphDMPixelPayloadHeader) + (sizeof(uint8_t) * 3 * DMMaxControllerBoards * DMMDacsPerControllerBoard * DMActuatorsPerDac));
	}
		
    return(ParamsLen);
}

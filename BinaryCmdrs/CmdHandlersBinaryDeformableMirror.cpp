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
//~ #include <sys/mman.h>
#include <errno.h>
#include <unordered_map>
using namespace std;

#include "cgraph/CGraphPacket.hpp"

#include "uart/BinaryUart.hpp"

#include "cgraph/CGraphDMHardwareInterface.hpp"

#include "CmdTableBinary.hpp"

void ShowPacketRoundtrip();

// These are what's returned from the Control Interface
int8_t BinaryDMDacCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (nullptr != Params) && (ParamsLen >= 4*(sizeof(uint32_t))) )
	{
		const uint32_t DacParameters = *reinterpret_cast<const uint32_t*>(Params);
		printf("\nBinaryDacCommand: Setting a mirror voltage: %lu\n", (unsigned long)DacParameters);
	}
	else
	{
		printf("\nBinaryDacCommand: Short packet: %lu (exptected %lu bytes): ", (unsigned long)ParamsLen, (unsigned long)(sizeof(uint32_t)));
	}

	ShowPacketRoundtrip();
    return(ParamsLen);
}

int8_t BinaryDMTelemetryCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//~ if ( (nullptr != Params) && (ParamsLen >= (sizeof(CGraphDMTelemetryADCPayload))) )
	//~ {
		//~ const CGraphDMTelemetryADCPayload* Telemetry = reinterpret_cast<const CGraphDMTelemetryADCPayload*>(Params);

		//~ formatf("\n\nBinaryTelemetryCommand Command: Values with corrected units follow:\n\n");
		
		//~ formatf("+1V2: %3.6lf V\n", Telemetry->P1V2);
		//~ formatf("+2V2: %3.6lf V\n", Telemetry->P2V2);
		//~ formatf("+28V: %3.6lf V\n", Telemetry->P28V);
		//~ formatf("+2V5: %3.6lf V\n", Telemetry->P2V5);
		//~ formatf("+6V: %3.6lf V\n", Telemetry->P6V);
		//~ formatf("+5V: %3.6lf V\n", Telemetry->P5V);
		//~ formatf("+3V3D: %3.6lf V\n", Telemetry->P3V3D);
		//~ formatf("+4V3: %3.6lf V\n", Telemetry->P4V3);
		//~ formatf("+2I2: %3.6lf V\n", Telemetry->P2I2);
		//~ formatf("+4I3: %3.6lf V\n", Telemetry->P4I3);
		//~ formatf("+6I: %3.6lf V\n", Telemetry->P6I);
		
		//~ formatf("\n\nBinaryTelemetryCommand Command complete.\n\n");
	//~ }
	//~ else
	//~ {
		//~ printf("\nBinaryTelemetryCommand: Short packet: %lu (exptected %lu bytes): ", (unsigned long)ParamsLen, (unsigned long)(sizeof(CGraphDMTelemetryADCPayload)));
	//~ }
	ShowPacketRoundtrip();
    return(ParamsLen);
}

int8_t BinaryDMHVSwitchCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (nullptr != Params) && (ParamsLen >= (sizeof(uint32_t))) )
	{
		const uint32_t FilterSelect = *reinterpret_cast<const uint32_t*>(Params);
		printf("\nBinaryHVSwitchCommand: FilterSelected(0=select inprogress): %lu\n", (unsigned long)FilterSelect);
	}
	else
	{
		printf("\nBinaryHVSwitchCommand: Short packet: %lu (exptected %lu bytes): ", (unsigned long)ParamsLen, (unsigned long)(sizeof(uint32_t)));
	}
	ShowPacketRoundtrip();
    return(ParamsLen);
}

int8_t BinaryDMDacConfigCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (nullptr != Params) && (ParamsLen >= (sizeof(uint32_t))) )
	{
		const uint32_t FilterSelect = *reinterpret_cast<const uint32_t*>(Params);
		printf("\nBinaryDacConfigCommand: FilterSelected(0=select inprogress): %lu\n", (unsigned long)FilterSelect);
	}
	else
	{
          printf("\nI am not sending anything back right now.  Work in progress...");
		printf("\nBinaryDacConfigCommand: Short packet: %lu (exptected %lu bytes): ", (unsigned long)ParamsLen, (unsigned long)(sizeof(uint32_t)));
	}
	ShowPacketRoundtrip();
    return(ParamsLen);
}

int8_t BinaryDMMappingCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (nullptr != Params) && (ParamsLen >= sizeof(CGraphDMPixelPayloadHeader)) )
	{
		//Find a start index followed by some mappings
		const CGraphDMPixelPayloadHeader PixelHeader = *reinterpret_cast<const CGraphDMPixelPayloadHeader*>(Params);
		const unsigned long StartPixel = PixelHeader.StartPixel;
		printf("\nBinaryDMMappingCommand: Returned StartPixel: %lu\n", (unsigned long)StartPixel);
		
		unsigned long NumPixels = (ParamsLen - sizeof(CGraphDMPixelPayloadHeader)) / sizeof(CGraphDMMappingPayload);
		if ((NumPixels + StartPixel) > DMMaxActuators) 
		{
			printf("\nBinaryDMMappingCommand: Invalid NumPixels (truncating): %lu\n", (unsigned long)NumPixels);					
			NumPixels = DMMaxActuators - StartPixel; 
		}
						
		for (size_t i = 0; i < NumPixels; i++)
		{
			const CGraphDMMappingPayload Mapping = *reinterpret_cast<const CGraphDMMappingPayload*>(Params+sizeof(CGraphDMPixelPayloadHeader)+(i*sizeof(CGraphDMMappingPayload)));
			printf("\nBinaryDMMappingCommand: Mapping %lu: ", (unsigned long)i);
			Mapping.formatf();
		}
		printf("\n\n");
	}
	else
	{
		printf("\nBinaryDMMappingCommand: Empty packet returned!\n\n");
	}
	
	ShowPacketRoundtrip();
    return(ParamsLen);
}

int8_t BinaryDMShortPixelsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (nullptr != Params) && (ParamsLen >= sizeof(CGraphDMPixelPayloadHeader)) )
	{
		//Find a start index followed by some mappings
		const CGraphDMPixelPayloadHeader PixelHeader = *reinterpret_cast<const CGraphDMPixelPayloadHeader*>(Params);
		const unsigned long StartPixel = PixelHeader.StartPixel;
		printf("\nBinaryDMShortPixelsCommand: Returned StartPixel: %lu\n", (unsigned long)StartPixel);
		
		unsigned long NumPixels = (ParamsLen - sizeof(CGraphDMPixelPayloadHeader)) / sizeof(uint16_t);
		if ((NumPixels + StartPixel) > DMMaxActuators) 
		{
			printf("\nBinaryDMShortPixelsCommand: Invalid NumPixels (truncating): %lu\n", (unsigned long)NumPixels);					
			NumPixels = DMMaxActuators - StartPixel; 
		}
						
		for (size_t i = 0; i < NumPixels; i++)
		{
			const uint16_t Pixel = *reinterpret_cast<const uint16_t*>(Params+sizeof(CGraphDMPixelPayloadHeader)+(i*sizeof(uint16_t)));
			printf("\nBinaryDMShortPixelsCommand: Pixel %lu: %lu", (unsigned long)i, (unsigned long)Pixel);
		}
		printf("\n\n");
	}
	else
	{
		printf("\nBinaryDMShortPixelsCommand: Empty packet returned!\n\n");
	}
	
	ShowPacketRoundtrip();
    return(ParamsLen);
}

int8_t BinaryDMDitherCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (nullptr != Params) && (ParamsLen >= sizeof(CGraphDMPixelPayloadHeader)) )
	{
		//Find a start index followed by some mappings
		const CGraphDMPixelPayloadHeader PixelHeader = *reinterpret_cast<const CGraphDMPixelPayloadHeader*>(Params);
		const unsigned long StartPixel = PixelHeader.StartPixel;
		printf("\nBinaryDMDitherCommand: Returned StartPixel: %lu\n", (unsigned long)StartPixel);
		
		unsigned long NumPixels = (ParamsLen - sizeof(CGraphDMPixelPayloadHeader)) / sizeof(uint8_t);
		if ((NumPixels + StartPixel) > DMMaxActuators) 
		{
			printf("\nBinaryDMDitherCommand: Invalid NumPixels (truncating): %lu\n", (unsigned long)NumPixels);					
			NumPixels = DMMaxActuators - StartPixel; 
		}
						
		for (size_t i = 0; i < NumPixels; i++)
		{
			const uint32_t Pixel = *reinterpret_cast<const uint32_t*>(Params+sizeof(CGraphDMPixelPayloadHeader)+(i*sizeof(uint32_t)));
			printf("\nBinaryDMDitherCommand: Pixel %lu: %lu", (unsigned long)i, (unsigned long)Pixel);
		}
		printf("\n\n");
	}
	else
	{
		printf("\nBinaryDMDitherCommand: Empty packet returned!\n\n");
	}
	
    ShowPacketRoundtrip();
	return(ParamsLen);
}

int8_t BinaryDMLongPixelsCommand(const uint32_t Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if ( (nullptr != Params) && (ParamsLen >= sizeof(CGraphDMPixelPayloadHeader)) )
	{
		//Find a start index followed by some mappings
		const CGraphDMPixelPayloadHeader PixelHeader = *reinterpret_cast<const CGraphDMPixelPayloadHeader*>(Params);
		const unsigned long StartPixel = PixelHeader.StartPixel;
		printf("\nBinaryDMLongPixelsCommand: Returned StartPixel: %lu\n", (unsigned long)StartPixel);
		
		unsigned long NumPixels = (ParamsLen - sizeof(CGraphDMPixelPayloadHeader)) / (3 * sizeof(uint8_t));
		if ((NumPixels + StartPixel) > DMMaxActuators) 
		{
			printf("\nBinaryDMLongPixelsCommand: Invalid NumPixels (truncating): %lu\n", (unsigned long)NumPixels);					
			NumPixels = DMMaxActuators - StartPixel; 
		}
						
		for (size_t i = 0; i < NumPixels; i++)
		{
			const uint32_t Pixel = *reinterpret_cast<const uint32_t*>(Params+sizeof(CGraphDMPixelPayloadHeader)+(i*3*sizeof(uint8_t)));
			printf("\nBinaryDMLongPixelsCommand: Pixel %lu: %lu", (unsigned long)i, (unsigned long)Pixel & 0x00FFFFFFUL);
		}
		printf("\n\n");
	}
	else
	{
		printf("\nBinaryDMLongPixelsCommand: Empty packet returned!\n\n");
	}
	
    ShowPacketRoundtrip();
	return(ParamsLen);
}



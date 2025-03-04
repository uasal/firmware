//
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

#include <stdint.h>

#include "uart/CmdSystem.hpp"

#include "cgraph/CGraphPacket.hpp"

#include "CmdTableBinary.hpp"

///The actual table (array) of commands for the system - links with CmdSystem.cpp.o
const BinaryCmd BinaryCmds[] = 
{
	//General Commands
	
	BinaryCmd (
		CGraphPayloadTypeVersion,
		"BinaryVersionCommand",
		BinaryVersionCommand
    ),	
	BinaryCmd (
		CGraphPayloadTypeVersionDeprecated,
		"BinaryVersionCommandDeprecated",
		BinaryVersionCommand
    ),

	//FineSteeringMirror Commands
	
	BinaryCmd (
		CGraphPayloadTypeFSMDacs,
		"BinaryFSMDacsCommand",
		BinaryFSMDacsCommand
    ),
	BinaryCmd (
		CGraphPayloadTypeFSMDacsDeprecated,
		"BinaryFSMDacsCommandDeprecated",
		BinaryFSMDacsCommand
    ),
	
	BinaryCmd (
		CGraphPayloadTypeFSMAdcs,
		"BinaryFSMAdcsCommand",
		BinaryFSMAdcsCommand
    ),
	BinaryCmd (
		CGraphPayloadTypeFSMAdcsDeprecated,
		"BinaryFSMAdcsCommandDeprecated",
		BinaryFSMAdcsCommand
    ),

	BinaryCmd (
		CGraphPayloadTypeFSMAdcsFloatingPoint,
		"BinaryFSMAdcsFloatingPointCommandDeprecated",
		BinaryFSMAdcsFloatingPointCommand
    ),
	BinaryCmd (
		CGraphPayloadTypeFSMAdcsFloatingPointDeprecated,
		"BinaryFSMAdcsFloatingPointCommandDeprecated",
		BinaryFSMAdcsFloatingPointCommand
    ),
	
	BinaryCmd (
		CGraphPayloadTypeFSMTelemetry,
		"BinaryFSMTelemetryCommand",
		BinaryFSMTelemetryCommand
    ),	
	BinaryCmd (
		CGraphPayloadTypeFSMStatusDeprecated,
		"BinaryFSMTelemetryCommandDeprecated",
		BinaryFSMTelemetryCommand
    ),	
	
	//DeformableMirror Commands
	
	BinaryCmd (
		CGraphPayloadTypeDMDac,
		"BinaryDMDacCommand",
		BinaryDMDacCommand
    ),
	
	BinaryCmd (
		CGraphPayloadTypeDMTelemetry,
		"BinaryDMTelemetryCommand",
		BinaryDMTelemetryCommand
    ),

	BinaryCmd (
		CGraphPayloadTypeDMHVSwitch,
		"BinaryDMHVSwitchCommand",
		BinaryDMHVSwitchCommand
    ),
	
	BinaryCmd (
		CGraphPayloadTypeDMDacConfig,
		"BinaryDMDacConfigCommand",
		BinaryDMDacConfigCommand
    ),
	
	BinaryCmd (
		CGraphPayloadTypeDMMappings,
		"BinaryDMMappingCommand",
		BinaryDMMappingCommand
    ),

	BinaryCmd (
		CGraphPayloadTypeDMShortPixels,
		"BinaryDMShortPixelsCommand",
		BinaryDMShortPixelsCommand
    ),

	BinaryCmd (
		CGraphPayloadTypeDMDither,
		"BinaryDMDitherCommand",
		BinaryDMDitherCommand
    ),

	BinaryCmd (
		CGraphPayloadTypeDMLongPixels,
		"BinaryDMLongPixelsCommand",
		BinaryDMLongPixelsCommand
    ),

	//FilterWheel Commands
	
	BinaryCmd (
		CGraphPayloadTypeFWHardwareControlStatus,
		"BinaryFWDacsCommand",
		BinaryFWHardwareControlStatusCommand
    ),
	
	BinaryCmd (
		CGraphPayloadTypeFWMotorControlStatus,
		"BinaryFWAdcsCommand",
		BinaryFWMotorControlStatusCommand
    ),

	BinaryCmd (
		CGraphPayloadTypeFWPositionSenseControlStatus,
		"BinaryFWAdcsFloatingPointCommand",
		BinaryFWPositionSenseControlStatusCommand
    ),
	
	BinaryCmd (
		CGraphPayloadTypeFWPositionSteps,
		"BinaryFWDacsFloatingPointCommand",
		BinaryFWPositionStepsCommand
    ),
	
	BinaryCmd (
		CGraphPayloadTypeFWTelemetry,
		"BinaryFWStatusCommand",
		BinaryFWTelemetryCommand
    ),

	BinaryCmd (
		CGraphPayloadTypeFWFilterSelect,
		"BinaryFWStatusCommand",
		BinaryFWFilterSelectCommand
    ),
};

//Calculate the number of commands instanciated in the system - links with CmdSystem.cpp.o
const uint8_t NumBinaryCmds = sizeof(BinaryCmds) / sizeof(BinaryCmds[0]);

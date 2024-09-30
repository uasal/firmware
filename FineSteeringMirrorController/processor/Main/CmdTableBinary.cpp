//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
//

#include <stdint.h>

#include "uart/CmdSystem.hpp"

#include "cgraph/CGraphPacket.hpp"

#include "CmdTableBinary.hpp"

///The actual table (array) of commands for the system - links with CmdSystem.cpp.o
const BinaryCmd BinaryCmds[] = 
{
	BinaryCmd (
		CGraphPayloadTypeVersion,
		"BinaryVersionCommand",
		BinaryVersionCommand
    ),
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
		BinaryFWTelemetryADCCommand
    ),

	BinaryCmd (
		CGraphPayloadTypeFWFilterSelect,
		"BinaryFWStatusCommand",
		BinaryFWFilterSelectCommand
    ),
};

//Calculate the number of commands instanciated in the system - links with CmdSystem.cpp.o
const uint8_t NumBinaryCmds = sizeof(BinaryCmds) / sizeof(BinaryCmds[0]);

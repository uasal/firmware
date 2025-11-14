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
		"Query CGraphVersionPayload packet",
		BinaryVersionCommand
    ),
	BinaryCmd (
		CGraphPayloadTypeFWHardwareControlStatus,
		"Set/query CGraphFWHardwareControlRegister packet",
		BinaryFWHardwareControlStatusCommand
    ),
	BinaryCmd (
		CGraphPayloadTypeFWMotorControlStatus,
		"Set/query CGraphFWMotorControlStatusRegister packet",
		BinaryFWMotorControlStatusCommand
    ),

	BinaryCmd (
		CGraphPayloadTypeFWPositionSenseControlStatus,
		"Query CGraphFWPositionSenseRegister packet",
		BinaryFWPositionSenseControlStatusCommand
    ),
	
	BinaryCmd (
		CGraphPayloadTypeFWPositionSteps,
		"Set/query CGraphFWPositionStepRegister packet",
		BinaryFWPositionStepsCommand
    ),
	
	BinaryCmd (
		CGraphPayloadTypeFWTelemetry,
		"Query CGraphFWTelemetryPayload packet",
		BinaryFWTelemetryADCCommand
    ),

	BinaryCmd (
		CGraphPayloadTypeFWFilterSelect,
		"Set/query Filter poosition (32b integer). Returns final position (0=sunsafe), -1 if moving, or -2 if positioning error.",
		BinaryFWFilterSelectCommand
    ),
};

//Calculate the number of commands instanciated in the system - links with CmdSystem.cpp.o
const uint8_t NumBinaryCmds = sizeof(BinaryCmds) / sizeof(BinaryCmds[0]);

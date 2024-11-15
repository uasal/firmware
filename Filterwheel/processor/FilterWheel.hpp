//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
//

#pragma once
#include <stdint.h>

const uint16_t MotorFindHomeSteps = 750; ///How many steps to move the motor to have definately passed home at least once? (prototype motor; should still work with flight motor)
const uint16_t MotorFullCircleSteps = 730; ///Exact number of steps in a single full rotation (prototype motor)
//~ const uint16_t MotorFullCircleSteps = 720; ///Exact number of steps in a single full rotation  (flight motor)
const uint16_t MotorSunSafeStep = 135; ///How far from home is the sun-safe position? This is the location in between filters where there are no slots for the sensor leds to shine through
const uint16_t BacklashSteps = 45; ///How far do we want to overshoot so we always come at a final position from the same direction?
const size_t MotorFindHomeTimeoutMs = 2000; ///How long should we try before giving up on major errors?
const size_t SensorPowerOnDelayMs = 100; ///How long to wait for lights and sensors to be functional after power-up

const uint32_t FWMaxPosition = 8; //Start invalid so we initialize
extern uint32_t FWPosition; //where do we want to be???

///ValidatedFWHomeStep(): where does the fpga think the sensors found home?
int16_t ValidatedFWHomeStep();

///FWHome(): send the filterwheel to the home position (filter #1)
void FWHome();

///FWSeekPosition(): send the filterwheel to any of the 8 filters (1-8), or the sunsafe position (0). Invalid inputs cause a re-home operation
void FWSeekPosition(const uint32_t SeekPos);

///ValidateFWPostition(): Do the sensors currently match the filter location we think we're in?
bool ValidateFWPosition();

//EOF

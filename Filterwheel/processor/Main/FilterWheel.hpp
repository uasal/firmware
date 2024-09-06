#pragma once
#include <stdint.h>

const uint16_t MotorFindHomeSteps = 750; //prototype motor; should still work with flight motor
const uint16_t MotorFullCircleSteps = 730; //prototype motor
//~ const uint16_t MotorFullCircleSteps = 720; //flight motor
const uint16_t MotorFindHomeTimeoutMs = 1000;
const uint16_t MotorSunSafeStep = 135; //prototype motor; should still work with flight motor

const uint32_t FWMaxPosition = 8; //Start invalid so we initialize
extern uint32_t FWPosition; //where do we want to be???

int16_t ValidatedFWHomeStep();
void FWHome();
void FWSeekPosition(const uint32_t SeekPos);
bool ValidateFWPostition();

//EOF

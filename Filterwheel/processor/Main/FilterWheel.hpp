#pragma once
#include <stdint.h>

const size_t MotorFindHomeSteps = 750; //prototype motor; should still work with flight motor
const size_t MotorFullCircleSteps = 730; //prototype motor
//~ const size_t MotorFullCircleSteps = 720; //flight motor
const size_t MotorFindHomeTimeoutMs = 1000;
const size_t MotorSunSafeStep = 45; //prototype motor; should still work with flight motor

const uint32_t FWMaxPosition = 8; //Start invalid so we initialize
extern uint32_t FWPosition; //where do we want to be???

uint16_t ValidatedFWHomeStep();
void FWHome();
void FWSeekPosition(const uint32_t SeekPos);
bool ValidateFWPostition();

//EOF

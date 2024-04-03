/*!
 * @file ocams_motor.h
 * @brief Header file for ocams_motor.c
 *
 * @par Copyright:
 * This document contains technical data that is controlled by the International
 * Traffic in Arms Regulations (22 CFR 120-130) and may not be provided, disclosed,
 * or transferred in any manner to any person, whether in the U.S. or abroad, who
 * is not 1) a citizen of the United States, 2) a lawful permanent resident of the
 * United States, or 3) a protected individual as defined by 8 USC 1324b(a)(3),
 * without the written permission of the United States Department of State.
 *
 * @section VersionControl
 * $Id: ocams_motor.h 3504 2015-04-14 20:10:17Z mikef $
 *
 */

#ifndef LOADED_MOTOR
#define LOADED_MOTOR

// ------------------------ Include Files
#include "ocams_fsw.h"
// ------------------------ Defines

#define  MAP_DELTA      0                                   //!< Parameter entry number delta to use for MapCam
#define  SAM_DELTA      (SAMCAM_STATUS - MAPCAM_STATUS)     //!< Parameter entry number delta to use for SamCam
#define  POLY_DELTA     (POLYCAM_STATUS - MAPCAM_STATUS)    //!< Parameter entry number delta to use for PolyCam

#define MOTOR_BAD_INDEX      0xFF   //!<  guaranteed to be an illegal index
#define MOTOR_SAFE_INDEX     0x80   //!<  indicates that the index is a sun-safe position

/* @brief Macro to determine if a motor id is for a motor */
#define IS_MOTOR(x)          (((motor_id)(x) < MOTOR_LAST) && ((motor_id)(x) != MOTOR_NONE))

/* @brief Macro to determine if a step count is a special motor command */
#define IS_MOTOR_HOME_CMD(x)      ((x) == MOTOR_HOME_CW || (x) == MOTOR_HOME_CCW)

#define POLYCAM_IDLER_CYCLE   1008  //!< estimate of PolyCam motor number of steps between Idler centers
#define POLYCAM_SHUTTER_CYCLE  540  //!< estimate of PolyCam motor number of steps between Shutter centers
#define POLYCAM_1ST_SHUTTER    540  //!< estimate of PolyCam motor number of steps from zero to first non-zero Shutter
#define POLYCAM_1ST_IDLER      222  //!< estimate of PolyCam motor number of steps from zero to first non-zero Idler

// ------------------------ Typedefs

typedef struct
{
   motor_id id;         //!< motor being run
   int08    index;      //!< last index LED readback
   int16    step;       //!< step number of last index LED readback
} idxscan_t;   /*!< structure used during a motorIndexScan() move to note
                *   when and where the index readback changes
                */

// ------------------------ Globals
// ------------------------ Prototypes

void motorInit(void);
void motorNextState(void);
uint16 motorEnable(motor_id);
uint16 motorLedEnable(motor_id);
uint16 motorMoveRel(motor_id, int16);
uint16 motorMoveAbs(motor_id, uint16);
uint16 motorMoveIndexed(motor_id, uint16);
uint16 motorAbort(uint16 fail);
uint16 motorGoHome(motor_id);
uint16 motorSafe(motor_id);
uint16 motorSafeAll(void);
uint16 motorIndexScan(motor_id, int16);
void motorFWtblDefault(void);
void motorPolyIdleDefault(void);
void motorPolyShutDefault(void);
void motorPolyIdle2ShutDefault(void);

#endif

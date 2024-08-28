/*!
 * @file ocams_motor.c
 * @brief Motor interface to the FPGA and motor state machine.
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
 * $Id: ocams_motor.c 3853 2015-09-05 02:12:53Z mikef $
 *
 */

// ------------------------ Include Files

#include "ocams_motor.h"
#include "ocams_timer.h"
#include "ocams_msg.h"
#include "ocams_loop.h"
#include "ocams_fpga.h"
#include "ocams_util.h"
#include <string.h>        // for memset()

//~ #ifdef OPS_ONLY

// ------------------------ Defines
// ------------------------ Typedefs
// ------------------------ Globals;
// ------------------------ Locals

STATIC uint08 PTdelta;           /*!< Parameter table delta for the current motor */
STATIC uint08 CheckIndex;        /*!< If set to a valid index number, verify motion ended on that index */
STATIC uint08 SafingMotorBits;   /*!< Bitwise IDs of motors being safed or waiting to be safed */
STATIC motor_mode MotorMode;     /*!< Current mode of the non-Idle motor state machine */
STATIC int16 PreBacklashMoved;   /*!< Holds the number of steps moved prior to backlash correction or other intermediate move */
STATIC uint16 MotorBacklash;     /*!< Holds the current backlash number of steps */
STATIC boolean PolySkirtHigh;    /*!< TRUE if the PolyCam skirts start high */
STATIC boolean MotorSafingTriggered;    /*!< TRUE if a motor error should trigger instrument safing */
STATIC motor_id FailedMotor;     /*!< ID of motor just failed that caused the safing */
STATIC uint16 HomeCommand;       /*!< Value of last/current home command */
STATIC uint08 HomeRetry;         /*!< Current count of home retries */

// motor index scan variables
STATIC idxscan_t IdxScan;        /*!< Information used during the motorIndexScan() motion */

// ------------------------ Functions


/***********************************************************/
/*! @brief Generate the MSG_MOTOR_STOPS message when a motor stops moving
 *
 *  @retval      N/A
 *
 ***********************************************************/

STATIC void motorEmitMsgStops(void)
{
   uint16 led;
   uint16 abs_pos;

   // Get real numbers if the motor power is on
   if (IS_MOTOR(State.motor_power))
   {
      led = State.LED_sense;
      abs_pos = State.motor_position[State.motor_power - 1];
   }
   else
   {
      led = 0;
      abs_pos = 0;
   }

   MSG_APPEND(MSG_MOTOR_STOPS,
              "Motor move complete: index=%c, motor=%c, position=%d, moved=%d",
              (led << 8) + State.motor_power, abs_pos,
              State.motor_moved + PreBacklashMoved);

   // Clear PreBacklashMoved now that the move is done and message sent
   PreBacklashMoved = 0;
} // motorEmitMsgStops



/***********************************************************/
/*! @brief Determine if it is OK to move the selected motor
 *
 * It's not OK if:
 *    - motors are not IDLE or a camera is taking images,.
 *    - MOVE_LOCK is enabled and another detector is active.
 *    - it's not a valid motor.
 *    - or the motor has been marked failed
 * \a PTdelta is set if OK
 *
 *  @param  id    the motor ID
 *
 *  @retval TRUE     OK to move motor
 *  @retval FALSE    Do not move the motor
 *
 ***********************************************************/

STATIC boolean motorReadyToMove(motor_id id)
{
   boolean ok = FALSE;

   do
   {
      // Don't move if a motor is non-IDLE or an image is being taken
      if (State.motor_state != STATE_IDLE)
      {
         MSG_APPEND(ERR_MOTOR_READY_STATE,
                    "Error, motor state not IDLE in ReadyToMove: state=%d, motor=%d",
                    State.motor_state, id, 0);
         break;
      }
      if (State.camera_state == STATE_ACTIVE)
      {
         MSG_APPEND(ERR_MOTOR_READY_CAMERA,
                    "Error, camera state ACTIVE in ReadyToMove: state=%d, motor=%d",
                    State.camera_state, id, 0);
         break;
      }

      // Don't move if another detector is selected as active and MOVE_LOCK is on
      if ((0 != ParamTbl[MOVE_LOCK]) &&
          (State.detector_select != DETECTOR_NONE) &&
          (State.detector_select != id))
      {
         MSG_APPEND(ERR_MOTOR_READY_DETECTOR,
                    "Error, tried to move when another detector selected: select=%d, motor=%d",
                    State.detector_select, id, 0);
         break;
      }

      // assume good, set parameter table delta from MapCam entries or error if invalid motor ID
      ok = TRUE;
      switch (id)
      {
         case MOTOR_MAPCAM:
            PTdelta = MAP_DELTA;
            break;

         case MOTOR_SAMCAM:
            PTdelta = SAM_DELTA;
            break;

         case MOTOR_POLYCAM:
            PTdelta = POLY_DELTA;
            break;

         default:
            MSG_APPEND(ERR_MOTOR_READY_ID,
                       "Error, invalid motor in ReadyToMove: motor=%d",
                       id, 0, 0);
            ok = FALSE;
            break;
      }

      if (ok)
      {
         // Don't move if the selected motor is failed
         if (0 != (ParamTbl[MAPCAM_STATUS + PTdelta] & FAILED_MOTOR))
         {
            MSG_APPEND(ERR_MOTOR_READY_FAIL,
                       "Error, failed motor in ReadyToMove: motor=%d, status=%d",
                       id, ParamTbl[MAPCAM_STATUS + PTdelta], 0);
            ok = FALSE;
         }
         else if (DETECTOR_NONE == State.detector_select)
         {
            // This detector is now the one selected as active
            State.detector_select = id;
         }
      }
   } while(FALSE);

   return(ok);
} // motorReadyToMove



/***********************************************************/
/*! @brief Given a number of steps, calculate the step number [0, rev) for FilterWheel motion
 *
 *  @param    steps   relative number of steps or step number
 *
 *  @retval   steps   reduced number of steps, [0, rev)
 *  @retval   steps   unchanged input if PolyCam or homing
 *
 ***********************************************************/

STATIC uint16 motorCalcStepNumber(int16 steps)
{
   // Don't do this calculation for PolyCam or if homing
   if ((POLY_DELTA != PTdelta) && (MOTOR_HOMING != MotorMode))
   {
      uint16 rev = ParamTbl[MAPCAM_MOTOR_REV + PTdelta];

      // Change steps to non-negative [0, xCAM_MOTOR_REV) steps
      if (0 < steps)
      {
         // When positive, if more than one revolution use modulus to reduce
         if (steps >= rev)
         {
            steps = steps % rev;
         }
      }
      else if (0 > steps)
      {
         // When positive, if more than one revolution use modulus to reduce
         if (-steps >= rev)
         {
            steps = -((-steps) % rev);
         }
         // if non-zero, add the negative steps to one rev to put in range
         if (0 > steps)
         {
            steps = (int16) rev + steps;
         }
      }
   }

   return (uint16)steps;
} // motorCalcStepNumber



/***********************************************************/
/*! @brief Calculate the current position based on skirt LEDs and Idler to Shutter steps
 *
 *  @retval      N/A
 *
 ***********************************************************/

STATIC void motorSetPolycamStep(void)
{
   int16 delta = State.motor_moved / 4;
   boolean neg_delta = FALSE;
   uint08 sense = 0;
   uint08 n;

   // Note which Skirts are currently active
   if(0 != (State.LED_sense & (1 << ParamTbl[POLYCAM_INDEX_SKIRT1])))
   {
      sense += 1;
   }
   if(0 != (State.LED_sense & (1 << ParamTbl[POLYCAM_INDEX_SKIRT2])))
   {
      sense += 2;
   }

   // If the delta is not positive the table should contain the next shutter info
   if (0 >= delta)
   {
      delta += (POLYCAM_SHUTTER_CYCLE / 4);
      neg_delta = TRUE;
   }

   // Look for a table entry with matching Skirts and approximate delta
   for (n = 0; n < (POLYCAM_IDLE_CNT - 1); n++)
   {
      // only check those positions where the skirts match
      if (sense == (Idler2Shut.info[n].idx_led & 0x03))
      {
         if((delta >= (Idler2Shut.info[n].delta - 2)) &&
            (delta <= (Idler2Shut.info[n].delta + 2)))
         {
            // Found it
            break;
         }
      }
   }

   if ((POLYCAM_IDLE_CNT - 1) > n)
   {
      // Found a matching entry, Shutter number is the upper 6 bits of the table entry
      n = (Idler2Shut.info[n].idx_led & 0xFC) >> 2;

      // At previous Shutter if the delta was not positive originally
      if (neg_delta)
      {
         n--;
      }
      State.motor_position[POLY_DELTA] = PolyShut[n];
      State.poly_init = TRUE;
   }
   else
   {
      MSG_APPEND(ERR_MOTOR_POLY_FIND,
                 "Error, unable to find match in Idler2Shut: delta=%d, sense=%d, count=%d",
                 delta, sense, n);

      // Fault protection: if enabled safe the instrument in motorNextState()
      if (0 == (ParamTbl[DONT_SAFE_FAIL_FLAGS] & DONT_FAIL_BAD_POLY_INIT))
      {
         ParamTbl[POLYCAM_STATUS] |= FAILED_MOTOR;
         if ((0 == State.safe_mode) &&
             (0 == (ParamTbl[DONT_SAFE_FAIL_FLAGS] & DONT_SAFE_FAILED_MOTOR)))
         {
            State.safe_reason = SAFE_REASON_POLYCAM_FAIL;
            State.safe_reason2 = (FAILED_MOTOR << 4) + 2;
            MotorSafingTriggered = TRUE;
            FailedMotor = MOTOR_SEL_POLY;
         }
      }
   }
} // motorSetPolycamStep



/***********************************************************/
/*! @brief Use table lookup to locate the nearest sun-safe Filter Wheel position
 *
 * Scan the Filter Wheel position table and select nearest sun-safe position
 *
 *  @param    id    the motor ID
 *
 *  @retval   idx   index of nearest sun-safe location
 *
 ***********************************************************/

STATIC uint16 motorFwFindSafeIndex(motor_id id)
{
   uint08 n;
   uint08 idx;
   uint16 pos;
   int16  rev2;
   uint16 *tbl;
   uint08 count;
   int16  delta1, delta2;

   // Set locals for MapCam or SamCam
   if (id == MOTOR_MAPCAM)
   {
      rev2 = ParamTbl[MAPCAM_MOTOR_REV] / 2;
      tbl = MapFWidx;
      count = MAPCAM_IDX_CNT;
   }
   else
   {
      rev2 = ParamTbl[SAMCAM_MOTOR_REV] / 2;
      tbl = SamFWidx;
      count = SAMCAM_IDX_CNT;
   }

   // First get the distance from home (index 0, position 0)
   idx = 0;
   delta1 = State.motor_position[id - 1];
   if (delta1 > rev2)
   {
      delta1 = rev2 + rev2 - delta1;
   }

   // Now see if the current position is closer to another sun-safe index
   for (n = 1; n < count; n++)
   {
      // Sun-safe index positions have the MSb of their entry set
      if (0 == (tbl[n] & 0x8000))
      {
         continue;
      }

      // Calculate the distance
      pos = tbl[n] & 0x7FFF;
      delta2 = State.motor_position[id - 1];
      if (delta2 > pos)
      {
         delta2 -= pos;
      }
      else
      {
         delta2 = pos - delta2;
      }
      if (delta2 > rev2)
      {
         delta2 = rev2 + rev2 - delta2;
      }

      // If smaller than the last smallest distance, use this index
      if (delta2 < delta1)
      {
         delta1 = delta2;
         idx = n;
      }
   }

   return idx;
} // motorFwFindSafeIndex



/***********************************************************/
/*! @brief Use table lookup to locate the nearest sun-safe Focus position
 *
 * Scan the Shutter position table and select nearest to the current position
 *
 *  @retval   pos   step number of closest Shutter
 *
 ***********************************************************/

STATIC uint16 motorFocusFindSafePos(void)
{
   uint08 n;
   uint16 pos;
   int16  delta1, delta2;

   // Find the first Shutter position past the current position
   // Don't bother checking the last, since it would be used anyway if went past
   for (n = 1; n < POLYCAM_SHUT_CNT - 1; n++)
   {
      if (PolyShut[n] > State.motor_position[POLY_DELTA])
      {
         break;
      }
   }

   // 0xFFFF signals the end of valid entries, if there are less than POLYCAM_SHUT_CNT entries
   while ((MAX_UINT16 == PolyShut[n]) && (0 < n))
   {
      n--;
   }

   // handle the no valid entries possibility
   if (1 > n)
   {
      boolean skirt_seen = (0 == (SFR_READ(LedSensor) & (1 << ParamTbl[POLYCAM_INDEX_SKIRT2])))
                              ? FALSE : TRUE;

      if (PolySkirtHigh == skirt_seen)
      {
         // Go clockwise if skirts seen matches PolySkirtHigh, assume maximum travel needed
         pos = State.motor_position[POLY_DELTA] + POLYCAM_SHUTTER_CYCLE;
      }
      else
      {
         // Go counter-clockwise if they don't match, assume maximum travel needed
         // but don't return a negative value
         if (POLYCAM_SHUTTER_CYCLE > State.motor_position[POLY_DELTA])
         {
            pos = 0;
         }
         else
         {
            pos = State.motor_position[POLY_DELTA] - POLYCAM_SHUTTER_CYCLE;
         }
      }
   }
   else
   {
      if ((1 == n) || (PolyShut[n] < State.motor_position[POLY_DELTA]))
      {
         // if below the first or after the last
         pos = PolyShut[n];
      }
      else
      {
         // find the shortest distance to one of the bracketing Shutter positions
         delta1 = PolyShut[n] - State.motor_position[POLY_DELTA];
         delta2 = State.motor_position[POLY_DELTA] - PolyShut[n - 1];
         if (delta1 <= delta2)
         {
            pos = PolyShut[n];
         }
         else
         {
            pos = PolyShut[n - 1];
         }
      }
   }

   return pos;
} // motorFocusFindSafePos


/***********************************************************/
/*! @brief Deal with the motor state machine in the Active state (motor is moving)
 *
 *  Waiting for the current move to finish or timeout.
 *  If finished a HOME command and the FPGA calculated Motor ZoneWidth is too small,
 *  reissue the HOME command because the motor is likely sitting on the edge - not
 *  center - of the HOME LED region.
 *  If finished a HOME command for the PolyCam Idler (and has a good ZoneWidth),
 *  immediately start the clock-wise HOME command for the PolyCam Shutter.
 *  Also handles generating messages on changed LED readback when doing an index
 *  scan move.
 *
 *  @retval      N/A
 *
 ***********************************************************/

STATIC void motorDoActiveState(void)
{
   uint16 err;

   // Did the motor get turned off?
   if (State.motor_power == MOTOR_SEL_NONE)
   {
      MSG_APPEND(ERR_MOTOR_ACT_OFF,
                 "Error, no motor selected in DoActive: mode=%d, motor=%d, moved=%d",
                 MotorMode, State.motor_curr, State.motor_moved);
      State.motor_state = STATE_ERR;
   }

   // Did the motor get switched
   else if (State.motor_power != State.motor_curr)
   {
      MSG_APPEND(ERR_MOTOR_ACT_MOTOR,
                 "Error, wrong motor selected in DoActive: mode=%d, motor=%d, power=%d",
                 MotorMode, State.motor_curr, State.motor_power);
      State.motor_state = STATE_ERR;
   }

   // Has the motor finished moving?
   else if (State.motor_csr == 0)
   {
      // Was an unrealistic zone width found during homing?
      if ((MOTOR_HALT != HomeCommand) && (ParamTbl[MOTOR_ZONE_MIN] > State.motor_zone) &&
          (ParamTbl[MAX_RETRY] > HomeRetry))
     {
         // Update position info and message
         PreBacklashMoved += State.motor_moved;
         State.motor_position[State.motor_curr - 1] += State.motor_moved;
         MSG_APPEND(ERR_MOTOR_HOME_ZONE,
                    "Error, invalid zone width while homing: zone=%c, motor=%c, position: %d, moved=%d",
                    (State.motor_zone<<8) + State.motor_curr,
                    State.motor_position[State.motor_curr - 1], State.motor_moved);

         // Try homing again
         fpgaSetMotorCsr(HomeCommand);

         // Reset the timeout timer so the retry move home does not timeout
         timerReset(TIMER_MOTOR);

         // Increment the retry counter so this doesn't continue indefinitely
         HomeRetry++;
      }

      // Did the PolyCam finish homing on the Idler?
      else if ((MOTOR_HOMING == MotorMode) &&
               (MOTOR_POLYCAM == State.motor_curr) &&
               (SFR_READ(MotorHomeSel) == ParamTbl[POLYCAM_INDEX_IDLER]))

      {
         uint32 timeout;

         // Update position info
         PreBacklashMoved += State.motor_moved;
         State.motor_position[State.motor_curr - 1] += State.motor_moved;

         // Now go clockwise to the next Shutter
         SFR_WRITE(MotorHomeSel, ParamTbl[POLYCAM_INDEX_SHUTTER]);
         CheckIndex = 1 << ParamTbl[POLYCAM_INDEX_SHUTTER];
         CheckIndex |= MOTOR_SAFE_INDEX;
         HomeCommand = MOTOR_HOME_CW;
         // Calculate the max time it should take for the FPGA to move to the home index
         // Max number of steps is distance between two shutter positions
         timeout = ((uint32) SFR_READ(MotorHiRate) + 1) * (PolyShut[2] - PolyShut[1]);
         // Added the time for the FPGA's homing algorithm
         timeout += ((uint16) SFR_READ(MotorLoRate) + 1) * ParamTbl[POLYSHUTR_HOME_STEPS];
         // With a little bit extra for margin
         timerOneShot(TIMER_MOTOR, timeout + ParamTbl[MOTOR_TIMEOUT_MARGIN]);
         fpgaSetMotorCsr(HomeCommand);
      }

      // Does backlash correction need to be done?
      else if (0 != MotorBacklash)
      {
         motor_mode mode = MotorMode;
         uint16 backlash = MotorBacklash;
         detector_id da = State.detector_select;
         state_id cam_state = State.camera_state;
         boolean safing = FALSE;

         State.motor_position[State.motor_curr - 1] += State.motor_moved;
         State.motor_state = STATE_IDLE;
         MotorBacklash = 0;
         if (MOTOR_SAFING == MotorMode)
         {
            // When safing, ensure motorMoveRel won't fail due to camera
            State.detector_select = DETECTOR_NONE;
            State.camera_state = STATE_IDLE;
            safing = TRUE;
         }
         err = motorMoveRel(State.motor_curr, backlash);
         if (safing)
         {
            // When safing, restore the camera state, selected detector, and mode
            State.camera_state = cam_state;
            State.detector_select = da;
            MotorMode = MOTOR_SAFING;
         }
         if (err)
         {
            // If unable to do backlash correction, revert the position and return state to ACTIVE.  That way,
            // on the next motorDoActiveState call, one of the next two cases will occur and go to WAITING_TIME.
            State.motor_position[State.motor_curr - 1] -= State.motor_moved;
            State.motor_state = STATE_ACTIVE;
         }
         else
         {
            // Restore the mode and adjust the PreBacklashMoved
            MotorMode = mode;
            PreBacklashMoved += State.motor_moved;
         }
      }

      // Is the motor safing or does it need to be safed?
      else if ((MOTOR_SAFING == MotorMode) || (0 != (SafingMotorBits & (1 << State.motor_power))))
      {
         // safing move finished (or need to safe current motor), don't wait for ringing (SRS-54)
         State.motor_state = STATE_WAITING_TIME;
         timerOneShot(TIMER_MOTOR, 1L);
      }
      else
      {
         // Move finished, turn motor off after settling time
         State.motor_state = STATE_WAITING_TIME;
         timerOneShot(TIMER_MOTOR, (uint32) ParamTbl[MAPCAM_MOTOR_WAIT + PTdelta]);
      }
   }

   // Did the move timeout?
   else if (State.chk_motor)
   {
      // Note: potentially lost abs position
      MSG_APPEND(ERR_MOTOR_ACT_TIMEOUT,
               "Error, move timeout in DoActive: mode=%d, motor=%d, moved=%d",
               MotorMode, State.motor_power, State.motor_moved);

      // If a regular move timed-out, try moving the remainder
      if (MOTOR_MOVE == MotorMode)
      {
         fpgaSetMotorCsr(MOTOR_HALT);
         State.motor_position[State.motor_curr - 1] += State.motor_moved;
         State.motor_state = STATE_IDLE;
         err = motorMoveRel(State.motor_curr, State.motor_csr);
         if (0 == err)
         {
            MotorMode = MOTOR_RETRY;
            PreBacklashMoved += State.motor_moved;
         }
         else
         {
            State.motor_position[State.motor_curr - 1] -= State.motor_moved;
            State.motor_state = STATE_ERR;
         }
      }
      else
      {
         State.motor_state = STATE_ERR;
      }
   }

   // If doing an index scan, send out messages on index or state change
   if (MOTOR_NONE != IdxScan.id)
   {
      if ((State.LED_sense != IdxScan.index) || (STATE_ACTIVE != State.motor_state))
      {
         int16 step = State.motor_position[IdxScan.id - 1] + State.motor_moved;

         MSG_APPEND(MSG_MOTOR_INDEX,
                    "Motor index change: motor=%c, index=%c, from=%d, to=%d",
                    (IdxScan.id << 8) + IdxScan.index, IdxScan.step, step);
         IdxScan.index = State.LED_sense;
         IdxScan.step = step;
         if (STATE_ACTIVE != State.motor_state)
         {
            IdxScan.id = MOTOR_NONE;
         }
      }
   }
} // motorDoActiveState


/***********************************************************/
/*! @brief Deal with the motor state machine in the Waiting for timeout state
 *
 *  @retval      N/A
 *
 ***********************************************************/

STATIC void motorDoWaitState(void)
{
   uint16 err;

   // Did the motor get turned off?
   if (State.motor_power == MOTOR_SEL_NONE)
   {
      MSG_APPEND(ERR_MOTOR_WAIT_OFF,
                 "Error, no motor selected in DoWait: mode=%d, motor=%d, moved=%d",
                 MotorMode, State.motor_curr, State.motor_moved);
      State.motor_state = STATE_ERR;
   }
   // Is the motor settling time over?
   else if (State.chk_motor)
   {
      int16 pos = (int16) State.motor_position[State.motor_curr - 1] + State.motor_moved;

      // Verify motor is at the requested index
      if (CheckIndex != MOTOR_BAD_INDEX)
      {
         uint08 test = State.LED_sense;
         uint08 isSafe = CheckIndex & MOTOR_SAFE_INDEX;

         // Clear the sun-safe indicator bit
         CheckIndex &= ~MOTOR_SAFE_INDEX;

         if (MOTOR_SEL_POLY == State.motor_curr)
         {
            // Only check the LED of interest.  Since both Shutter and Idler may be
            // seen at the same time, with or without skirts
            test &= CheckIndex;
         }

         // If not at the correct index, fault protection
         if (CheckIndex != test)
         {
            MSG_APPEND(ERR_MOTOR_WAIT_INDEX,
                       "Error, index move did not end on expected index: expected=%c, actual=%c, motor=%d, pos=%d",
                       ((uint16) CheckIndex << 8) + test, State.motor_curr, pos);
            if (0 == (ParamTbl[DONT_SAFE_FAIL_FLAGS] & DONT_FAIL_BAD_INDEX))
            {
               ParamTbl[MAPCAM_STATUS + State.motor_curr - 1] |= FAILED_MOTOR;
               if ((0 == State.safe_mode) &&
                   (0 == (ParamTbl[DONT_SAFE_FAIL_FLAGS] & DONT_SAFE_FAILED_MOTOR)))
               {
                  State.safe_reason = SAFE_REASON_MAPCAM_FAIL + PTdelta;
                  State.safe_reason2 = (FAILED_MOTOR << 4) + 1;
                  MotorSafingTriggered = TRUE;
                  FailedMotor = State.motor_curr;
               }
            }
         }
         // If a sunsafe index
         else if (MOTOR_SAFE_INDEX == isSafe)
         {
            ParamTbl[MAPCAM_STATUS + PTdelta] |= SUNSAFE_MOTOR;

            // deselect the detector once the motor is sunsafe if no cameras are active
            if ((State.detector_select == State.motor_curr) &&
                (NONE_ACTIVE == State.camera_curr))
            {
               State.detector_select = DETECTOR_NONE;
            }
         }
      }

      // turn off motor and index LEDs, update position, and generate the end-of-move message
      SFR_WRITE(LedIndex, MOTOR_SEL_NONE);
      SFR_WRITE(MotorSel, MOTOR_NONE);
      State.motor_position[State.motor_curr - 1] = motorCalcStepNumber(pos);
      motorEmitMsgStops();

      // When done homing, lookup PolyCam position or set the Filter Wheel position to 0
      if (MOTOR_HOMING == MotorMode)
      {
         if (MOTOR_SEL_POLY == State.motor_curr)
         {
            motorSetPolycamStep();
         }
         else
         {
            State.motor_position[State.motor_curr - 1] = 0;
         }
      }
      else if (MOTOR_SAFING == MotorMode)
      {
         // Clear the safing bit for the motor that just finished sun-safing
         SafingMotorBits &= ~(1 << State.motor_power);

         // Set the Filter Wheel position to 0 if a Home command was used to sun-safe it
         if ((MOTOR_HALT != HomeCommand) && (MOTOR_SEL_POLY != State.motor_curr))
         {
            State.motor_position[State.motor_curr - 1] = 0;
         }
      }

      // Turn off index check and set state IDLE
      CheckIndex = MOTOR_BAD_INDEX;
      MotorMode = MOTOR_DONE;
      HomeCommand = MOTOR_HALT;
      State.motor_state = STATE_IDLE;
      State.motor_curr = MOTOR_NONE;

      // If the current motor is waiting to be safed, start safing it immediately
      if (0 != (SafingMotorBits & (1 << State.motor_power)))
      {
         uint08 bits = SafingMotorBits & ~(1 << State.motor_power);

         SafingMotorBits = 0;
         err = motorSafe(State.motor_power);
         SafingMotorBits |= bits;
      }

      // If current motor did not start safing and other motors are waiting to be safed,
      // let the safing state handle them
      if ((0 != SafingMotorBits) && (STATE_IDLE == State.motor_state))
      {
         State.motor_state = STATE_SAFING;
      }
   }  // if (State.chk_motor)
} // motorDoWaitState


/***********************************************************/
/*! @brief Check for motor event and move to the next state
 *
 *  @retval      N/A
 *
 ***********************************************************/

void motorNextState(void)
{
   switch (State.motor_state)
   {
      case STATE_ACTIVE:
         motorDoActiveState();
         break;

      case STATE_WAITING_TIME:
         motorDoWaitState();
         break;

      case STATE_ERR:
         // In ERROR state, so error message, stop any motion, and turn off the motor and index LEDs
         MSG_APPEND(ERR_MOTOR_STATE_ERR,
                    "Error, motor in ERROR state: motor=%d, moved=%d, left=%d",
                    State.motor_power, State.motor_moved, State.motor_csr);

         // Need to stop the motor if it is still moving
         if (MOTOR_HALT != State.motor_csr)
         {
            // Need to select a motor if none is currently selected
            if (MOTOR_SEL_NONE == State.motor_power)
            {
               if (IS_MOTOR(State.motor_curr))
               {
                  // select the current motor if valid
                  motorEnable(State.motor_curr);
                  State.motor_power = State.motor_curr;
               }
               else
               {
                  // if invalid, one step on PolyCam is the most innocuous
                  motorEnable(MOTOR_POLYCAM);
               }
            }
            fpgaSetMotorCsr(MOTOR_HALT);
            // Go to the safing state to wait for the final step to finish
            State.motor_state = STATE_SAFING;
         }
         else
         {
            // Motor is stopped, so power it off and assume the idle state
            SFR_WRITE(MotorSel, MOTOR_SEL_NONE);
            SFR_WRITE(LedIndex, MOTOR_SEL_NONE);
            State.motor_state = STATE_IDLE;
         }

         if (MOTOR_SEL_NONE != State.motor_power)
         {
            // If a motor was powered on: update its position, send an end-of-motion message, and mark it FAILED
            State.motor_position[State.motor_power - 1] =
               motorCalcStepNumber(State.motor_position[State.motor_power - 1] + State.motor_moved);
            motorEmitMsgStops();
            ParamTbl[MAPCAM_STATUS + State.motor_power - 1] |= FAILED_MOTOR;

            // If not already safing, setup fault protection
            if ((0 == State.safe_mode) &&
                (0 == (ParamTbl[DONT_SAFE_FAIL_FLAGS] & DONT_SAFE_FAILED_MOTOR)))
            {
               State.safe_reason = SAFE_REASON_MAPCAM_FAIL + PTdelta;
               State.safe_reason2 = FAILED_MOTOR << 4;
               MotorSafingTriggered = TRUE;
               FailedMotor = State.motor_power;
            }

            // Clear the motor's safing bit if the failed motor was safing
            if (MOTOR_SAFING == MotorMode)
            {
               SafingMotorBits &= ~(1 << State.motor_power);
            }
         }

         // Reset variables for next move
         MotorBacklash = 0;
         IdxScan.id = MOTOR_NONE;
         HomeCommand = MOTOR_HALT;
         State.motor_curr = MOTOR_NONE;

         // If any motors are waiting to be safed, enter the SAFING state
         if (0 != SafingMotorBits)
         {
            State.motor_state = STATE_SAFING;
         }
         break;

      case STATE_SAFING:
         // Wait for any current motion to complete
         if (MOTOR_HALT == State.motor_csr)
         {
            motor_id id;
            uint16   err;
            uint08   bits;

            // Motor is stopped, so power it off and assume the idle state
            SFR_WRITE(MotorSel, MOTOR_SEL_NONE);
            SFR_WRITE(LedIndex, MOTOR_SEL_NONE);
            State.motor_state = STATE_IDLE;

            // Start safing any motors with safing bit set
            bits = SafingMotorBits;
            SafingMotorBits = 0;
            for (id = MOTOR_MAPCAM; id <= MOTOR_POLYCAM; id++)
            {
               if (0 != (bits & (1 << id)))
               {
                  err |= motorSafe(id);
               }
            }
         }
         break;

      default :
         // Invalid states drop into the ERROR state
         State.motor_state = STATE_ERR;
         break;
   }

   // Does the instrument need to be safed?
   if (MotorSafingTriggered)
   {
      MotorSafingTriggered = FALSE;

      // Only safe the instrument if it's not already safing or safe
      if (0 == State.safe_mode)
      {
         utilOcamsSafe(State.safe_reason, State.safe_reason2);

         // Motor safing may be delayed, leaving the state IDLE or ERROR
         // In that case, set state to SAFING so that safing will start once the MotorCSR is zero
         if ((STATE_IDLE == State.motor_state) || (STATE_ERR == State.motor_state))
         {
            State.motor_state = STATE_SAFING;
         }
      }
   }
} // motorNextState


/***********************************************************/
/*! @brief Step a motor relative to it's current position.
 *
 *  @param  id      motor ID
 *  @param  steps   motor steps [relative]
 *
 *  @retval 0  Sucess
 *  @retval 1  Motor not OK to move
 *  @retval 2  Commanded \a steps is a motor special command
 *  @retval 3  PolyCam would move below its minimum position
 *  @retval 4  PolyCam would move above its maximum position
 *  @retval 5  PolyCam not initialized
 *
 ***********************************************************/

uint16 motorMoveRel(motor_id id, int16 steps)
{
   uint16       err = 0;
   uint32 idata abs_steps;

   do
   {
      // Validate parameters
      if (FALSE == motorReadyToMove(id))
      {
         // motorReadyToMove() already issued an error message, so just return 1
         err = 1;
         break;
      }
      if (MOTOR_HALT == steps)
      {
         // No move, but try to get the index sensor for the selected motor
         SFR_WRITE(LedIndex, id);
         State.motor_power = id;
         State.motor_moved = 0;
         State.LED_sense = SFR_READ(LedSensor);
         SFR_WRITE(LedIndex, MOTOR_NONE);
         motorEmitMsgStops();

         // deselect the detector when the zero move is sunsafe and no cameras are active
         if (((0 != (ParamTbl[MAPCAM_STATUS + PTdelta] & SUNSAFE_MOTOR)) ||
              ((MOTOR_BAD_INDEX != CheckIndex) &&
               (MOTOR_SAFE_INDEX == (CheckIndex & MOTOR_SAFE_INDEX)))) &&
             (State.detector_select == id) &&
             (NONE_ACTIVE == State.camera_curr))
         {
            State.detector_select = DETECTOR_NONE;
         }
         CheckIndex = MOTOR_BAD_INDEX;
         break;
      }
      if (IS_MOTOR_HOME_CMD(steps))
      {
         MSG_APPEND(ERR_MOTOR_REL_STEP,
                    "Error, invalid number of steps in MoveRel: motor=%d, steps=%d",
                    id, steps, 0);
         err = 2;
         break;
      }

      if (MOTOR_POLYCAM == id)
      {
         if (State.poly_init)
         {
            // Verify that move will stay within the approved PolyCam range
            // for PolyCam moves after the absolute position is known
            int16 pos = (int16)State.motor_position[id - 1] + steps;
            int16 limit;

            if ((int16) ParamTbl[POLYCAM_MIN_POS] > pos)
            {
               limit = (int16) ParamTbl[POLYCAM_MIN_POS];
               err = 3;
            }
            else if ((int16) ParamTbl[POLYCAM_MAX_POS] < pos)
            {
               limit = (int16) ParamTbl[POLYCAM_MAX_POS];
               err = 4;
            }

            if (0 != err)
            {
               MSG_APPEND(ERR_MOTOR_REL_POLY_LIMIT,
                          "Error, requested position would exceed PolyCam limit: steps=%d, pos=%d, limit=%d",
                          steps, pos, limit);
               break;
            }
         }
         else if (TRUE != ParamTbl[REL_MV_NO_POLY_INIT])
         {
            // Can't do any absolute PolyCam moves until the current absolute position is known

            MSG_APPEND(ERR_MOTOR_REL_POLY_INIT,
                       "Error, PolyCam position not yet initialized: motor=%d, steps=%d, init=%d",
                       id, steps, State.poly_init);
            err = 5;
            break;
         }
      }

      // Add backlash correction, if needed, for negative motion
      if (0 > steps)
      {
         steps -= ParamTbl[MAPCAM_BACKLASH+PTdelta];
         MotorBacklash += ParamTbl[MAPCAM_BACKLASH+PTdelta];
         abs_steps = -steps;
      }
      else
      {
         abs_steps = steps;
      }

      // Setup and start moving the motor
      SFR_WRITE(LedIndex, id);
      SFR_WRITE(MotorSel, id);
      SFR_WRITE(MotorLoRate, ParamTbl[MAPCAM_MOTOR_LO + PTdelta]);
      SFR_WRITE(MotorHiRate, ParamTbl[MAPCAM_MOTOR_HI + PTdelta]);

      // Calculate the max time it should take for the FPGA to move the requested number of steps
      abs_steps *= ((uint32) SFR_READ(MotorHiRate) + 1);
      // Start the timeout timer with a little bit extra for margin
      timerOneShot(TIMER_MOTOR, abs_steps + ParamTbl[MOTOR_TIMEOUT_MARGIN]);

      // Start the move, transition to Active with the mode being just a regular move
      fpgaSetMotorCsr(steps);
      State.motor_state = STATE_ACTIVE;
      MotorMode = MOTOR_MOVE;

      // Set the current motor and the State variables for the affected FPGA registers
      State.motor_curr = id;
      State.LED_power = id;
      State.motor_power = id;
      State.motor_csr = steps;

      // Now that it's moving actively it's not sun-safe
      ParamTbl[MAPCAM_STATUS + id - 1] &= ~SUNSAFE_MOTOR;

      // unless the instrument is safing, no motor started the safing process
      if (0 == State.safe_mode)
      {
         FailedMotor = MOTOR_NONE;
      }
   } while (FALSE);

   return (err);
} // motorMoveRel



/***********************************************************/
/*! @brief Step a motor to an absolute postion.
 *
 *  @param  id        motor ID
 *  @param  abs_pos   motor absolute position
 *
 *  @retval 0  Sucess
 *  @retval 1  Motor not OK to move
 *  @retval 2  PolyCam can't move absolute until it's position is known
 *  @retval 3  PolyCam would move below its minimum position
 *  @retval 4  PolyCam would move above its maximum position
 *
 ***********************************************************/

uint16 motorMoveAbs(motor_id id, uint16 abs_pos)
{
   uint16 err = 1;
   int16 idata steps;

   // since move-abs calls move-rel there is no need to check if
   // the state machine is in the correct state.

   do
   {
      // Validate parameters
      if (FALSE == motorReadyToMove(id))
      {
         // motorReadyToMove() already issued an error message, so just return 1
         break;
      }

      if ((MOTOR_POLYCAM == id) && (FALSE == State.poly_init))
      {
         // Can't do any absolute PolyCam moves until the current absolute position is known

         MSG_APPEND(ERR_MOTOR_ABS_POLY_INIT,
                    "Error, PolyCam position not yet initialized: motor=%d, pos=%d, init=%d",
                    id, abs_pos, State.poly_init);
         err = 2;
         break;
      }

      // Calculate the number of relative steps to move
      steps = (int16) abs_pos - (int16) State.motor_position[id - 1];

      // Make Filter Wheel (MapCam or SamCam) steps +/- 0.5*rev
      if (MOTOR_POLYCAM != id)
      {
         uint16 rev = ParamTbl[MAPCAM_MOTOR_REV + PTdelta];

         // Change calc'd steps to positive [0, xCAM_MOTOR_REV) steps
         MotorMode = MOTOR_DONE;
         steps = motorCalcStepNumber(steps);

         // obtain steps +/- 1/2 rev
         if (steps > (rev >> 1))
         {
            steps -= rev;
         }
      }

      // allow call with steps == 0 to obtain move complete message
      err = motorMoveRel(id, steps);
   } while (FALSE);

   return(err);
} // motorMoveAbs


/***********************************************************/
/*! @brief Step a motor to an absolute position listed in a table.
 *
 *  @param  id    motor ID
 *  @param  index index into motor presets table
 *
 *  @retval 0  Sucess
 *  @retval 1  Motor not OK to move or invalid index selected
 *  @retval 2  PolyCam can't move absolute until it's position is known
 *  @retval 3  PolyCam would move below its minimum position
 *  @retval 4  PolyCam would move above its maximum position
 *
 ***********************************************************/

uint16 motorMoveIndexed(motor_id id, uint16 index)
{
   uint16 err = 0;
   uint16 pos;

   do
   {
      // Validate parameters
      if (FALSE == motorReadyToMove(id))
      {
         // motorReadyToMove() already issued an error message, so just return 1
         err = 1;
         break;
      }

      switch (id)
      {
         case MOTOR_MAPCAM:
            if (index < MAPCAM_IDX_CNT)
            {
               // High bit may be set, indicating a sun-safe position
               pos = MapFWidx[index] & (~MASK_BIT_15);
               if (0 == index)
               {
                  // 0 is the HOME position
                  CheckIndex = 1 << ParamTbl[MAPCAM_INDEX_HOME];
               }
               else
               {
                  // For non-home positions, the sensor readback is the index number
                  CheckIndex = index;
               }

               // Mark if sun-safe index
               if (MapFWidx[index] & MASK_BIT_15)
               {
                  CheckIndex |= MOTOR_SAFE_INDEX;
               }
            }
            else
            {
               err = 1;
            }
            break;

         case MOTOR_SAMCAM:
            if (index < SAMCAM_IDX_CNT)
            {
               // High bit may be set, indicating a sun-safe position
               pos = SamFWidx[index] & (~MASK_BIT_15);
               if (0 == index)
               {
                  // 0 is the HOME position
                  CheckIndex = 1 << ParamTbl[SAMCAM_INDEX_HOME];
               }
               else
               {
                  // For non-home positions, the sensor readback is the index number
                  CheckIndex = index;
                  if (0 == ParamTbl[SAMCAM_INDEX_HOME])
                  {
                     // Unless the Home LED is 0, then sensor readback is 2 times the index number
                     CheckIndex <<= 1;
                  }
               }

               // Mark if sun-safe index
               if (SamFWidx[index] & MASK_BIT_15)
               {
                  CheckIndex |= MOTOR_SAFE_INDEX;
               }
            }
            else
            {
               err = 1;
            }
            break;

         default: // case MOTOR_POLYCAM:, an invalid ID would have been caught by motorReadyToMove()
            if (index < POLYCAM_IDLE_CNT)
            {
               // For PolyCam, the index position is an Idler position
               pos = PolyIdler[index];
               CheckIndex = 1 << ParamTbl[POLYCAM_INDEX_IDLER];
            }
            else
            {
               err = 1;
            }
            break;
      }
      if (0 != err)
      {
         // Common error for invalid index number
         MSG_APPEND(ERR_MOTOR_INDEX_ARG,
                  "Error, invalid motor index: motor=%d, index=%d",
                  id, index, 0);
         break;
      }

      // Move to the absolute position of the selected index
      err = motorMoveAbs(id, pos);
   } while (FALSE);

   return (err);
} // motorMoveIndexed


/***********************************************************/
/*! @brief Immediately halt any motor motion.
 *
 *   This command should only be used by Action Sequences in flight
 *
 *  @param  fail  If set, mark the current motor as failed
 *
 *  @returns   0
 *
 ***********************************************************/

uint16 motorAbort(uint16 fail)
{
   uint16 led;
   uint16 abs_pos;

   // Need to stop the motor if it is still moving
   if (MOTOR_HALT != State.motor_csr)
   {
      // Need to select a motor if none is currently selected
      if (MOTOR_SEL_NONE == State.motor_power)
      {
         if (IS_MOTOR(State.motor_curr))
         {
            // select the current motor if valid
            motorEnable(State.motor_curr);
            State.motor_power = SFR_READ(MotorSel);
         }
         else
         {
            // if invalid, one step on PolyCam is the most innocuous
            motorEnable(MOTOR_POLYCAM);
         }
      }
      // Go to the safing state to wait for the final step to finish
      State.motor_state = STATE_SAFING;
   }
   else
   {
      // Motor is stopped, so power it off and assume the idle state
      SFR_WRITE(MotorSel, MOTOR_SEL_NONE);
      SFR_WRITE(LedIndex, MOTOR_SEL_NONE);
      State.motor_state = STATE_IDLE;
   }
   // Stop the motor
   fpgaSetMotorCsr(MOTOR_HALT);

   // If a motor is powered, update the motor info and get values for msg
   if (IS_MOTOR(State.motor_power))
   {
      State.motor_moved = fpgaGetMoved();
      State.LED_sense = SFR_READ(LedSensor);
      State.motor_position[State.motor_power - 1] += State.motor_moved;
      led = State.LED_sense;
      abs_pos = State.motor_position[State.motor_power - 1];
      if (0 != fail)
      {
         ParamTbl[MAPCAM_STATUS + State.motor_power - 1] |= FAILED_MOTOR;
      }
   }
   else
   {
      led = 0;
      abs_pos = 0;
      State.motor_moved = 0;
   }

   // Clear the motor variables
   CheckIndex = MOTOR_BAD_INDEX;
   MotorMode = MOTOR_DONE;
   IdxScan.id = MOTOR_NONE;
   HomeCommand = MOTOR_HALT;
   MotorBacklash = 0;
   State.motor_curr = MOTOR_NONE;

   // Send the abort message
   MSG_APPEND(MSG_MOTOR_ABORT,
              "Motor move aborted: index=%c, motor=%c, position=%d, moved=%d",
              (led << 8) + (0 == fail ? 0 : MOTOR_SAFE_INDEX) + State.motor_power,
              abs_pos, State.motor_moved);

   return (0);
} // motorAbort


/***********************************************************/
/*! @brief Move a motor to a home position.
 *
 *  For the FilterWheels, always move home by selecting the home index then
 *  issuing a clockwise home command.  Once done, the position will be set to 0.
 *
 *  "Homing" the PolyCam is more complicated.  If the Skirt2 LED reading
 *  matches Skirt2 LED indicator in the first entry of the Idler-to-Shutter
 *  position look-up-table, then home clockwise to the next Idler position,
 *  otherwise home counter-clockwise to the next Idler position.  Once the
 *  Idler position has been reached, the state machine will home clockwise
 *  to the next Shutter position.  Once done, the PolyCam position will be
 *  to the absolute position of the Shutter obtained from the Idler-to-Shutter
 *  position look-up-table.
 *
 *  @param  id   motor ID
 *
 *  @retval 0  Sucess
 *  @retval 1  Motor not OK to move
 *
 ***********************************************************/

uint16 motorGoHome(motor_id id)
{
   uint16 err = 1;
   uint16 steps;
   uint08 home_led;
   uint32 timeout;

   // Validate parameters
   if (motorReadyToMove(id))
   {
      if (MOTOR_POLYCAM == id)
      {
         boolean skirt_seen;

         SFR_WRITE(LedIndex, id);

         // Delay loop to give time for the index LEDs to turn on
         for (err = 0; err < ParamTbl[MOTOR_IDXLED_LOOPCNTR]; err++)
         {
            SFR_WRITE(ImagePadMsb, SFR_READ(ImagePadMsb));
         }

         // Read the current LED sensors to see which section of motion the Polycam is in
         home_led = SFR_READ(LedSensor);
         skirt_seen = (0 == (home_led & (1 << ParamTbl[POLYCAM_INDEX_SKIRT2]))) ? FALSE : TRUE;
         if (PolySkirtHigh == skirt_seen)
         {
            // in the lower section of motion
            HomeCommand = MOTOR_HOME_CW;
         }
         else
         {
            // in the upper section of motion
            HomeCommand = MOTOR_HOME_CCW;
         }

         // Max number of steps is distance between two idler positions
         steps = PolyIdler[2] - PolyIdler[1];
         home_led = ParamTbl[POLYCAM_INDEX_IDLER];
      }
      else
      {
         // we may be lost so go CW, that way backlash correction not needed
         // steps is only used to calculate the max timeout
         HomeCommand = MOTOR_HOME_CW;
         steps = ParamTbl[MAPCAM_MOTOR_REV + PTdelta];
         home_led = ParamTbl[MAPCAM_INDEX_HOME + PTdelta];
         CheckIndex = 1 << home_led;

         // Note that this is a sun-safe index
         CheckIndex |= MOTOR_SAFE_INDEX;
      }

      SFR_WRITE(MotorHomeSel, home_led);
      SFR_WRITE(LedCal, LED_CAL_NONE);
      SFR_WRITE(MotorSel, id);
      SFR_WRITE(LedIndex, id);
      SFR_WRITE(MotorLoRate, ParamTbl[MAPCAM_MOTOR_LO + PTdelta]);
      SFR_WRITE(MotorHiRate, ParamTbl[MAPCAM_MOTOR_HI + PTdelta]);

      // Calculate the max time it should take for the FPGA to move to the home index
      timeout = ((uint32) SFR_READ(MotorHiRate) + 1) * steps;
      // Added the time for the FPGA's homing algorithm
      timeout += ((uint16) SFR_READ(MotorLoRate) + 1) * ParamTbl[MAPCAM_HOME_STEPS+PTdelta];
      // With a little bit extra for margin
      timerOneShot(TIMER_MOTOR, timeout + ParamTbl[MOTOR_TIMEOUT_MARGIN]);
      fpgaSetMotorCsr(HomeCommand);

      // Set the current motor and the State variables for the affected FPGA registers
      State.motor_csr = HomeCommand;
      State.motor_curr = id;
      State.motor_power = id;
      State.LED_power = id;

      // Setup the state machine variables
      State.motor_state = STATE_ACTIVE;
      MotorMode = MOTOR_HOMING;
      HomeRetry = 0;

      // Clear FailedMotor, the motor that initiated safing, if not currently safing
      if (0 == State.safe_mode)
      {
         FailedMotor = MOTOR_NONE;
      }
      ParamTbl[MAPCAM_STATUS + PTdelta] &= ~SUNSAFE_MOTOR;
      err = 0;
   }  // if (motorReadyToMove(id))

   return (err);
} // motorGoHome


/***********************************************************/
/*! @brief Move a motor to a sun-safe position.
 *
 *  For the FilterWheels, find the closest sun-safe index to the current position,
 *  then do an move to that index.  For the PolyCam, if the absolute position
 *  is known then "home" to the nearest Shutter, otherwise examine the Skirt state
 *  at the current position then "home" to the next Shutter in the direction away
 *  from the hard-stop.
 *
 *  @param  id   motor ID
 *
 *
 *  @retval 0  Success
 *  @retval 1  Invalid \a id or requested FilterWheel motor is marked failed
 *  @retval 2  PolyCam Focus motor is marked failed
 *
 ***********************************************************/

uint16 motorSafe(motor_id id)
{
   uint16 err = 1;
   uint08 index = 0;

   // SAFE is allowed in all states of the FSM
   //    - it might be needed in an emergency

   do {
      // Validate parameters
      if ((MOTOR_SEL_NONE >= id) || (MOTOR_LAST <= id))
      {
         MSG_APPEND(ERR_MOTOR_SAFE_ID,
                    "Error, invalid motor ID in Safe: motor=%d",
                    id, 0, 0);
         break;
      }

      // Set safing bit for requested motor
      index = SafingMotorBits;
      SafingMotorBits |= (1 << id);

      // If already safing, then return
      err = 0;
      if (0 != index)
      {
         break;
      }

      // If MotorCSR is not zero (and state ACTIVE or SAFING [should always be if non-zero]) then set
      // MotorCSR to zero and return to let motorDoActiveState or motorNextState catch it going to zero
      if (0 != State.motor_csr)
      {
         uint16 rate1, rate2;

         CheckIndex = MOTOR_BAD_INDEX;
         fpgaSetMotorCsr(MOTOR_HALT);
         rate1 = SFR_READ(MotorLoRate) + 1;
         rate2 = SFR_READ(MotorHiRate) + 1;
         if (rate2 > rate1)
         {
            rate1 = rate2;
         }

         timerOneShot(TIMER_MOTOR, 2 * rate1);
         break;
      }

      // [what to do if state is not IDLE?  (ACTIVE{no, would have been handled}, WAIT, or ERROR)]
      // Let ERROR do what needs to be done, then start the safing
      if (STATE_ERR == State.motor_state)
      {
         break;
      }
      // Let the settling time finish, unless the request is for safing the current motor
      if (STATE_WAITING_TIME == State.motor_state)
      {
         if (State.motor_power == id)
         {
            timerOneShot(TIMER_MOTOR, 1);
         }
         break;
      }

      // turn things off
      SFR_WRITE(MotorSel, MOTOR_NONE);
      SFR_WRITE(LedIndex, MOTOR_NONE);
      State.motor_state = STATE_IDLE;
      HomeCommand = MOTOR_HALT;
      MotorBacklash = 0;

      // by motor type
      if (MOTOR_POLYCAM != id)
      {
         // Don't let non-IDLE camera state or incompatible detector prevent the safing
         detector_id da = State.detector_select;
         state_id cam_state = State.camera_state;

         // Set PTdelta for the motor being sun-safed
         if (MOTOR_MAPCAM == id)
         {
            PTdelta = MAP_DELTA;
         }
         else
         {
            PTdelta = SAM_DELTA;
         }

         // Only move if not already at a sun-safe position
         // (Note: failed status checked in MoveIndexed)
         if (0 != (ParamTbl[MAPCAM_STATUS + PTdelta] & SUNSAFE_MOTOR))
         {
            // If already safe, clear safing bit for motor
            SafingMotorBits &= ~(1 << id);
            break;
         }

         State.detector_select = DETECTOR_NONE;
         State.camera_state = STATE_IDLE;

         // Home this motor if marking it failed is what caused the safing
         if ((0 != (ParamTbl[MAPCAM_STATUS + PTdelta] & FAILED_MOTOR)) &&
             (FailedMotor == id))
         {
            ParamTbl[MAPCAM_STATUS + PTdelta] &= ~FAILED_MOTOR;
            err = motorGoHome(id);
            ParamTbl[MAPCAM_STATUS + PTdelta] |= FAILED_MOTOR;
         }
         else
         {
            // find the closest safe position from safe-tables and move there
            index = motorFwFindSafeIndex(id);
            // if the motor is failed, motorMoveIndexed will just return an error
            err = motorMoveIndexed(id, index);
            if ((0 == err) && (STATE_ACTIVE != State.motor_state))
            {
               // Already at the index position (move rel 0), so clear bit and mark sun-safe
               SafingMotorBits &= ~(1 << id);
               ParamTbl[MAPCAM_STATUS + PTdelta] |= SUNSAFE_MOTOR;
            }
         }

         // Restore the camera state and selected detector
         State.camera_state = cam_state;
         State.detector_select = da;

         // On error, don't continue trying to safe this motor
         if (0 != err)
         {
            // clear safing bit for motor
            SafingMotorBits &= ~(1 << id);
            break;
         }

         // set mode to LAST to flag the common closeout
         MotorMode = MOTOR_MODE_LAST;
      }
      else
      {
         uint16 pos;
         uint32 timeout;

         PTdelta = POLY_DELTA;
         // Only move if not already at a sun-safe position
         if (0 != (ParamTbl[MAPCAM_STATUS + PTdelta] & SUNSAFE_MOTOR))
         {
            // If already safe, clear safing bit for motor
            SafingMotorBits &= ~(1 << id);
            break;
         }

         // Don't try to safe a failed motor unless marking it failed caused the safing
         if ((0 != (ParamTbl[POLYCAM_STATUS] & FAILED_MOTOR)) &&
             (FailedMotor != id))
         {
            MSG_APPEND(ERR_MOTOR_SAFE_FAIL,
                     "Error, failed motor in Safe: motor=%d, status=%d",
                     id, ParamTbl[MAPCAM_STATUS + PTdelta], 0);
            err = 2;
            // clear safing bit for motor
            SafingMotorBits &= ~(1 << id);
            break;
         }

         // Turn on the Index LEDs and delay loop to give time for the index LEDs to turn on, ~80ms
         SFR_WRITE(LedIndex, id);
         SFR_WRITE(MotorSel, id);
         for (err = 0; err < ParamTbl[MOTOR_IDXLED_LOOPCNTR]; err++)
         {
            SFR_WRITE(ImagePadMsb, SFR_READ(ImagePadMsb));
         }
         err = 0;
         index = SFR_READ(LedSensor);

         // Only move if not already at shutter index
         if (0 != (index & (1 << ParamTbl[POLYCAM_INDEX_SHUTTER])))
         {
            // Mark as safed, no need to move
            ParamTbl[POLYCAM_STATUS] |= SUNSAFE_MOTOR;

            // Turn things off since not moving
            SFR_WRITE(MotorSel, MOTOR_NONE);
            SFR_WRITE(LedIndex, MOTOR_NONE);

            // deselect the detector when already sunsafe and no cameras are active
            if ((State.detector_select == id) &&
                (NONE_ACTIVE == State.camera_curr))
            {
               State.detector_select = DETECTOR_NONE;
            }

            // clear safing bit for motor since already safe
            SafingMotorBits &= ~(1 << id);
            break;
         }

         // Set up for the move to home to a Shutter
         SFR_WRITE(LedCal, LED_CAL_NONE);
         State.motor_power = id;
         State.motor_curr = id;
         SFR_WRITE(MotorLoRate, ParamTbl[POLYCAM_MOTOR_LO]);
         SFR_WRITE(MotorHiRate, ParamTbl[POLYCAM_MOTOR_HI]);
         SFR_WRITE(MotorHomeSel, ParamTbl[POLYCAM_INDEX_SHUTTER]);

         if (FALSE == State.poly_init)
         {
            // Absolute position unknown, set direction to go based on current skirt reading
            // Read the current LED sensors to see which section of motion the Polycam is in
            boolean skirt_seen = (0 == (index & (1 << ParamTbl[POLYCAM_INDEX_SKIRT2]))) ? FALSE : TRUE;

            if (PolySkirtHigh == skirt_seen)
            {
               // in the lower section of motion, so go positive
               HomeCommand = MOTOR_HOME_CW;
            }
            else
            {
               // in the upper section of motion, so go negative
               HomeCommand = MOTOR_HOME_CCW;
            }
         }
         else
         {
            // goto the nearest SAFE pos (<48 of them)
            pos = motorFocusFindSafePos();
            if (pos > State.motor_position[id - 1])
            {
               HomeCommand = MOTOR_HOME_CW;
            }
            else
            {
               HomeCommand = MOTOR_HOME_CCW;
            }
         }

         // Calculate the max time it should take for the FPGA to move to the home index
         // worst case for Max number of steps is distance between two shutter positions
         timeout = ((uint32)SFR_READ(MotorHiRate) + 1) * POLYCAM_SHUTTER_CYCLE;
         // Added the time for the FPGA's homing algorithm
         timeout += ((uint16)SFR_READ(MotorLoRate) + 1) * ParamTbl[POLYSHUTR_HOME_STEPS];
         // With a little bit extra for margin
         timerOneShot(TIMER_MOTOR, timeout + ParamTbl[MOTOR_TIMEOUT_MARGIN]);
         fpgaSetMotorCsr(HomeCommand);
         State.motor_csr = HomeCommand;

         State.motor_state = STATE_ACTIVE;
         CheckIndex = 1 << ParamTbl[POLYCAM_INDEX_SHUTTER];

         // Note that this is a sun-safe index
         CheckIndex |= MOTOR_SAFE_INDEX;

         // set mode to LAST to flag the common closeout
         MotorMode = MOTOR_MODE_LAST;
      }

      // common closeout, if safing started set mode
      if ((MOTOR_MODE_LAST == MotorMode) && (STATE_ACTIVE == State.motor_state))
      {
         MotorMode = MOTOR_SAFING;
         // Clear FailedMotor if not in SafeMode
         if (0 == State.safe_mode)
         {
            FailedMotor = MOTOR_NONE;
         }
      }

   } while (FALSE);

   return (err);
} // motorSafe




/***********************************************************/
/*! @brief Move all motors to a safe position.
 *
 *  @retval 0  Successfully started sun-safing or all motors already sun-safe
 *  @retval !0  At least one motor is marked failed and will not be sun-safed
 *
 ***********************************************************/

uint16 motorSafeAll(void)
{
   motor_id id;
   uint16 err = 0;

   for (id = MOTOR_MAPCAM; id <= MOTOR_POLYCAM; id++)
   {
      err |= motorSafe(id);
   }

   return (err);
} // motorSafeAll


/***********************************************************/
/*! @brief Select (power on) a motor by motor ID.
 *
 *  @param  id   motor ID
 *
 *
 *  @retval 0  Success
 *  @retval 1  Invalid \a id
 *
 ***********************************************************/

uint16 motorEnable(motor_id id)

{
   uint16 err = 0;

   // Validate parameters
   if (id < MOTOR_LAST)
   {
      SFR_WRITE(MotorSel, (uint08) id);
   }
   else
   {
      MSG_APPEND(ERR_MOTOR_ENABLE_ID,
                 "Error, invalid motor ID in Enable: motor=%d",
                 id, 0, 0);
      err = 1;
   }

   return (err);
} // motorEnable


/***********************************************************/
/*! @brief Enable/disable a motor's LEDs by LED ID.
 *
 *  @param  id   motor ID
 *
 *
 *  @retval 0  Success
 *  @retval 1  Invalid \a id
 *
 ***********************************************************/

uint16 motorLedEnable(motor_id id)
{
   uint16 err = 0;

   // Validate parameters
   if (id < MOTOR_LAST)
   {
      SFR_WRITE(LedIndex, (uint08) id);
   }
   else
   {
      MSG_APPEND(ERR_MOTOR_LED_ID,
                 "Error, invalid motor ID in LedEnable: motor=%d",
                 id, 0, 0);
      err = 1;
   }

   return (err);
} // motorLedEnable


/***********************************************************/
/*! @brief Runs a relative move on the selected motor.scanning
 *         for changes in the index sensors.
 *         Each change of state will generate a message
 *
 *  @param  id    motor ID
 *  @param  steps motor steps [relative]
 *
 *  @returns      Same as motorMoveRel()
 *
 ***********************************************************/
uint16 motorIndexScan(motor_id id,
                      int16 steps)
{
   uint16 err;

   // Validate parameters and start move if OK
   err = motorMoveRel(id, steps);
   if (0 == err)
   {
      // Setup the IdxScan structure for use in ACTIVE mode
      IdxScan.id = id;
      IdxScan.step = State.motor_position[id - 1];
      IdxScan.index = SFR_READ(LedSensor) & SENSE_LED_MASK;
   }

   return (err);
} // motorIndexScan


/***********************************************************/
/*! @brief Set the default positions of the filter wheels index positions
 *
 *  @retval      N/A
 *
 ***********************************************************/

void motorFWtblDefault(void)
{
   uint08 n;
   uint16 delta;

   delta = ParamTbl[MAPCAM_MOTOR_REV] / MAPCAM_IDX_CNT;
   for (n = 0; n < MAPCAM_IDX_CNT; n++)
   {
      MapFWidx[n] = delta * n;
   }
   // Mark the sun-safe positions
   MapFWidx[0] |= 0x8000;
   MapFWidx[6] |= 0x8000;

   delta = ParamTbl[SAMCAM_MOTOR_REV] / SAMCAM_IDX_CNT;
   for (n = 0; n < SAMCAM_IDX_CNT; n++)
   {
      SamFWidx[n] = delta * n;
   }
   // Mark the sun-safe positions
   SamFWidx[0] |= 0x8000;
   SamFWidx[3] |= 0x8000;

   FWindex[0] = TBL_ID_FILTER;
} // motorFWtblDefault


/***********************************************************/
/*! @brief Set the default positions of the PolyCam Idler index positions
 *
 *  @retval      N/A
 *
 ***********************************************************/

void motorPolyIdleDefault(void)
{
   uint08 n;

   PolyIdler[0] = TBL_ID_PC_IDLE;
   for (n = 1; n < POLYCAM_IDLE_CNT; n++)
   {
      PolyIdler[n] = POLYCAM_1ST_IDLER + (POLYCAM_IDLER_CYCLE * (n - 1));
   }
} // motorPolyIdleDefault


/***********************************************************/
/*! @brief Set the default positions of the PolyCam Shutter index positions
 *
 *  @retval      N/A
 *
 ***********************************************************/

void motorPolyShutDefault(void)
{
   uint08 n;

   PolyShut[0] = TBL_ID_PC_SHUT;
   for (n = 1; n < (POLYCAM_SHUT_CNT - 1); n++)
   {
      PolyShut[n] = POLYCAM_1ST_SHUTTER + (POLYCAM_SHUTTER_CYCLE * (n - 1));
   }
   PolyShut[POLYCAM_SHUT_CNT - 1] = MAX_UINT16;
} // motorPolyShutDefault


/***********************************************************/
/*! @brief Set the default info of the PolyCam Idler to Shutter index positions
 *
 *  @retval      N/A
 *
 ***********************************************************/

void motorPolyIdle2ShutDefault(void)
{
   uint08 n;
   uint08 shutidx;
   uint16 shutpos;
   uint16 idlepos;

   Idler2Shut.table_id = TBL_ID_PC_I2S;
   idlepos = POLYCAM_1ST_IDLER;
   shutpos = POLYCAM_1ST_SHUTTER;
   shutidx = 1;
   for (n = 0; n < POLYCAM_IDLE_CNT - 1; n++)
   {
      while (shutpos < idlepos)
      {
         shutidx++;
         shutpos += POLYCAM_SHUTTER_CYCLE;
      }
      Idler2Shut.info[n].delta = (shutpos - idlepos) / 4;
      Idler2Shut.info[n].idx_led = shutidx << 2;
      if ((POLYCAM_IDLE_CNT / 3) <= n)
      {
         Idler2Shut.info[n].idx_led |= 1;
      }
      if ((2 * POLYCAM_IDLE_CNT / 3) <= n)
      {
         Idler2Shut.info[n].idx_led |= 2;
      }
      idlepos += POLYCAM_IDLER_CYCLE;
   }
} // motorPolyIdle2ShutDefault


/***********************************************************/
/*! @brief Initialize the motor module.
 *
 *  @retval      N/A
 *
 ***********************************************************/

void motorInit(void)
{
   // Ensure the motors are stopped, turned off, with LEDs off
   fpgaSetMotorCsr(MOTOR_HALT);
   SFR_WRITE(MotorSel, MOTOR_SEL_NONE);
   SFR_WRITE(LedIndex, MOTOR_SEL_NONE);
   SFR_WRITE(LedCal, MOTOR_SEL_NONE);

   // Set the FPGA registers to MapCam defaults
   SFR_WRITE(MotorLoRate, ParamTbl[MAPCAM_MOTOR_LO]);
   SFR_WRITE(MotorHiRate, ParamTbl[MAPCAM_MOTOR_HI]);
   SFR_WRITE(MotorHomeSel, ParamTbl[MAPCAM_INDEX_HOME]);

   // Initialize static variables as they should be for Idle state
   PTdelta = 0;
   CheckIndex = MOTOR_BAD_INDEX;
   MotorMode = MOTOR_DONE;
   SafingMotorBits = 0;
   MotorBacklash = 0;
   PreBacklashMoved = 0;
   MotorSafingTriggered = FALSE;
   FailedMotor = MOTOR_NONE;
   HomeCommand = MOTOR_HALT;
   HomeRetry = 0;
   memset(&IdxScan, 0, sizeof(IdxScan));

   // Determine if the PolyCam skirts should be active on the low (neg, CCW) end of travel
   if (3 == (Idler2Shut.info[0].idx_led & 3))
   {
      PolySkirtHigh = TRUE;
   }
   else
   {
      PolySkirtHigh = FALSE;
   }
} // motorInit
#endif

Since you're only dealing with the filter wheel you should ignore anything having to do with PolyCam or focus.  In general, the logic for filter wheel movement is:
1) It  knows what the current position is since it's been counting steps since the last HOME. (State.motor_position)
2) It knows the step numbers of the filters. (*FWidx)
3) It knows the number of steps per revolution and for backlash correction (ParamTbl: *_MOTOR_REV & *_BACKLASH)
4) It makes sure it's OK to move (motorReadyToMove)
5) It calculates the smallest number of steps from current position to desired filter position.
6) It commands the FPGA to move that number of steps
7) Background loop polls for move complete (motorDoActiveState)
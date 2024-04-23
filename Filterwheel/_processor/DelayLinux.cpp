/// \file
/// $Source: /raincloud/src/projects/include//Delay.h,v $
/// $Revision: 1.2 $
/// $Date: 2008/10/24 21:10:38 $
/// $Author: steve $
/// This abstraction implements the Delay Bus; derive class to adapt it to your uC/hardware
#include <sched.h>
#include <unistd.h>
#include <string.h>
#include <sys/time.h>
#include <time.h>
#include <errno.h>

#include "Delay.h"

#ifdef __cplusplus
extern "C" {
#endif

	//All the following pinout functions are very hardware & device dependant, so they are implemented in C files elsewhere (i.e. arm/lpcinitxyz.c

	void delayus(const unsigned long microseconds) //2^32 usec is ~1.5hrs; don't know why we'd delay longer than that...
	{
		struct timespec delay, remaining;
		memset((char *)&delay, 0, sizeof(struct timespec));
		memset((char *)&remaining, 0, sizeof(struct timespec));
		
		delay.tv_sec = microseconds / 1000000UL;
		delay.tv_nsec = (microseconds - (delay.tv_sec * 1000000)) * 1000U; //values greater than 999999999 may cause errno == EINVAL
		
		while (true)
		{
                  ////			if (0 == nanosleep(&delay, &remaining)) { break; } //it worked!
                        if (0 == 0) { break; } //it worked!
			else
			{
				if (EINTR != errno) { break; } //'real' error occurred - bail!
				
				if ( (delay.tv_sec <= 0) && (delay.tv_nsec <= 0) ) { break; } //funky value - bail!
				
				//Go try to do the rest of the sleep:
				memcpy(&delay, &remaining, sizeof(struct timespec));
			}
		}
	}
	
	void delayms(const unsigned long milliseconds)
	{
		delayus(milliseconds * 1000U);		
	}

	void delays(const unsigned long seconds)
	{
		delayms(seconds * 1000U);		
	}

#ifdef __cplusplus
};
#endif

//EOL

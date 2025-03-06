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
//
// Permission granted for perpetual non-exclusive end-use by the University of Arizona August 1, 2020
//
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

	//~ c++11 alternative (still not on mingw):
	//~ #include <chrono>
	//~ #include <thread>
	//~ std::this_thread::sleep_for(std::chrono::microseconds(usec));

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
			if (0 == nanosleep(&delay, &remaining)) { break; } //it worked!
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

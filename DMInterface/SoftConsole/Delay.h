#ifndef _Delay_h
#define _Delay_h
#pragma once

#ifdef __cplusplus
extern "C" {
#endif

	//All the following pinout functions are very hardware & device dependant, so they are implemented in C files elsewhere (i.e. arm/lpcinitxyz.c

	void delayus(const unsigned long microseconds);
	void delayms(const unsigned long milliseconds);
	void delays(const unsigned long seconds);

#ifdef __cplusplus
};
#endif

#endif //_Delay_h

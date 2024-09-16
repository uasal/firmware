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

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

#ifndef _TempLM35_h
#define _TempLM35_h
#pragma once

#include <stdint.h>

/// This purely math implementation will take an A/D value and turn it into temperature assuming the origonal 
/// voltage is from an LM35 temp sensor chip.
class TempLM35
{
	public:

		TempLM35() { }
		
		//LM35 gives temp out as 10mV/oC; 0V = 0oC (negative voltage output for negative temps)
		
		static double VoltsToDegCFast(const double& Volts)
		{
			return(Volts * 100.0);
		}
		
		static double VoltsToDegCAccurate(const double& Volts)
		{
			return(Volts * 100.0);
		}
		
};

#endif //_TempLM35_h


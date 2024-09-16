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

#ifndef _TempLM20_h
#define _TempLM20_h
#pragma once

#include <stdint.h>
#include <math.h>

/// This purely math implementation will take an A/D value and turn it into temperature assuming the origonal 
/// voltage is from an LM20 temp sensor chip.
class TempLM20
{
	public:

		TempLM20() { }
		
		//Simplest conversion is V=-11.79mV/oC(Temp) + 1.8528V, but that can be off by 2oC...
		static double VoltsToDegCFast(const double& Volts)
		{
			return( (fabs(Volts) - 1.8528) / -0.01179 );
		}
		
		//Most accurate Eqn is T=sqrt( (2.19262e6+(1.8639-Vo)) / 3.88e-6) - 1481.96
		static double VoltsToDegCAccurate(const double& Volts)
		{
			return(sqrt((2192620.0 + (1.8639 - fabs(Volts))) / 0.00000388) - 1481.96);
		}
		
};

#endif //_TempLM20_h


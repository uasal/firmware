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


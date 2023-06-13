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


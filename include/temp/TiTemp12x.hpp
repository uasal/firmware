/// \file
/// $Source: /raincloud/src/projects/include/temp/TiTemp12x.hpp,v $
/// $Revision: 1.4 $
/// $Date: 2006/01/01 00:49:44 $
/// $Author: steve $

#ifndef _TITEMP12X_H_
#define _TITEMP12X_H_
#pragma once

#include "SPI.hpp"
namespace Franks_Development
{
    namespace tmp122
    {

	template <class pinout, class communications>
	struct TiTemp12x:  pinout, communications
	{

	private:
            struct guard
            {
                guard(){pinout::enable();}
                ~guard() {pinout::disable();}
            };

	public:
            using communications::tx;
            using communications::rx;
            using communications::ignore;
            char const *const pinout_name() {return pinout::name();}
            char const *const communications_name() {return communications::name();}

		TiTemp12x() {}

		int16_t GetTemp()
		{
			int16_t tempreg = 0x8000;
			int16_t tmp = 0x8000;
			pinout::enable();
			_delay_ms(350);
			tmp =  rx(tempreg);
			_delay_ms(1);
			pinout::disable();
			return(tmp);
		}
			//note:
			//150oC = 0x4B07>>3
			//0oC = 0x0007>>3
			//-55oC = 0xE487>>3
		float TempC() { return( ((float)GetTemp())/128.0); }
		float TempF() { return( (TempC()*9.0)/5.0 + 32.0); }

	};
    }
}

#endif //_TITEMP12X_H_

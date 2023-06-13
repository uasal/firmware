//
///           Copyright (c)2007 by Franks Development, LLC
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
/// \file
/// $Source: /raincloud/src/projects/include/adc/Dac8830.h,v $
/// $Revision: 1.6 $
/// $Date: 2010/02/22 23:16:24 $
/// $Author: steve $

#pragma once

#include <stdint.h>

//Vcc = 2.7 -> 5.5V
//Iqq = 20uA @ -40 -> +85oC
//INL & DNL < 1LSB
//GainErr < 7LSB, 0.1ppm/oC
//OffsetErr < 2LSB, 0.05ppm/oC
//VRef = 1.25V -> Vcc
//Zref >= 5k || 120pf
//RefBw = 1.3MHz
//RefRR = 1mV/1V (60dB)
//VOut = 0V -> VRef, 16 bits
//ZOut > 6k-ohm
//tOut = 1uS to 1/2LSB, 25V/uS max
//Noise = 10nV/Hz^1/2
//PSRR = +-1LSB/10% Vcc (@3.3V = 100uV/330mV (70dB)
//VOut = (Vref * Val) / 65536 (Val 16-bit unsigned integer)
//VOut = MaxNegative on reset
//Sck max = 20nS/50MHz
//nCs max = 20nS/50MHz

///This class is used to control the Dac8830 DAC chip over the spi bus
template <class pinout, class spi>
struct Dac8830 : pinout, spi
{

public:

	using pinout::enable;
	using spi::setclkpolarity;
	using spi::setclkphase;
	using spi::transmit;
	using spi::receive;

	Dac8830()
		//:
	{

	}

public:

	//Acutally set Dac to some level; no scaling, tweaking, or anything else - dac takes a 16-bit number in and puts out 4-20mA (approx)
	//~ __inline__ void Write(uint16_t val)
	__inline__ uint16_t Write(uint16_t val)
	{
		uint16_t loopback = 0;
		setclkpolarity(false);
		setclkphase(false);
		enable(true);
		transmit(val >> 8);
		transmit(val);
		enable(false);
		//Sometimes you need to do this twice...
		enable(true);
		loopback = (receive(val >> 8) << 8);
		loopback += receive(val);
		enable(false);
		return(loopback);
	}
};


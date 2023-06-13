/// \file
/// $Source: /raincloud/src/projects/include/temp/TempI2C.hpp,v $
/// $Revision: 1.13 $
/// $Date: 2009/02/19 18:02:37 $
/// $Author: steve $
/// This class will implement the hardware abstraction layer for an Atmel (as well as a good number of compatible devices) At24C series EEProm

#ifndef _TempI2C_h
#define _TempI2C_h
#pragma once

#include "IDelay.h"
#include "i2c/I2C.h"

/// This class will implement the hardware abstraction layer for an Analog Devices (as well as a good number of compatible devices) AD7414 Temp Sensor
class TempI2C
{
	public:

		I_I2C& Bus;  //The I_I2C Bus is very hardware-dependant, so it's declared in another file to preserve abstraction as well
		IDelay& Wait; //As is a delay loop...
		const uint8_t DeviceAddr;

		TempI2C(I_I2C& bus, IDelay& wait, const uint8_t deviceaddr = 0x92) : Bus(bus), Wait(wait), DeviceAddr(deviceaddr)
		{
			//~ Write(0x01, 0xC4); //Do a single conversion and go to sleep.
		}

		// Important Details from TempI2C datasheet:
		// Addr for grounded 7414: 1001. 001x? or 1001, 101x?; for float: 1001, 000x? or 1001, 100x?
		// 10 bits
		// 30uS reading
		// signed integer (MSB deleted); 0.25 deg C/LSB, -55-+125 deg C
		// Temp+ = code/4; Temp- = code-512/4
		// All transactions are: ADDR(7:0):REGISTERR/W(7:0)
		// R0 = Temp, R1 = Cfg, R2 = THi, R3 = TLo
		// Cfg Reg:
		// 7 = Power Down if 1
		// 6 = I_I2C Filtering if 1
		// 5 = nEnab Alert
		// 4 = Alert High on Overtemp if 1
		// 3 = Force Alert low for one conversion if 1
		// 2 = Convert immediately if written to one
		// 1:0 = Always write 0:0.
		// 5:3 not present on AD7415 (write zeros)
		// Temp Reg:
		// 15:8 = Temp 9:2
		// 7:6 = Temp 1:0
		// 5 = Alert/Overtemp status
		// 4 = Temp > THi
		// 3 = Temp < TLo
		// 2:0 = do not care
		// THi/Tlo registers: 7:0 = Temp threshold 9:2 (temp thresh 1:0 always 0:0 (1 deg C resolution)
		//Defaults: Cfg = 0x40, THi = 0x7F, TLo = 0x80
		// Iqq power-down = 3uA max (0.04uA typ) = 10uW max @ 3.3V
		// SCL max rate = 2.5uS/400kHz
		// Power/Conversion @ 3.3V = 3.63mW*29uS = 105nWS = 30pWh
		//Break even duty-cycle (Iconv = Isleep) = 3.63mW/10uW = 363:1 (where 1 = 29uS) or every 10.5 mS.

		//Define our error codes here
		enum TempErr { Sucess = 0, Failed };

		TempErr GetTempRaw(int16_t& Temp)
		{
			//Do a single conversion and go to sleep.
			uint8_t Err = Bus.tx(DeviceAddr, (uint8_t)0x01, (uint8_t)0xC4);
			if (0 != Err) { return((TempErr)Err); }

			for(uint8_t i = 0; i < 5; i++) { Wait.delayus(10); } //conversion time = 29uS max

			int16_t temptemp;
			Err = Bus.rx(DeviceAddr, 0x00, (uint8_t*)(&temptemp), sizeof(int16_t));
			if (Sucess != Err) { return((TempErr)Err); }
			
			//This is annoying, and shows analog devices's general lack of interest in software
			uint8_t temp;
			uint8_t* ptemp = (uint8_t*)(&temptemp);
			temp = ptemp[1];
			ptemp[1] = ptemp[0];
			ptemp[0] = temp;
			
			Temp = temptemp >> 6;
			
			return(Sucess);
		}
		
		static float RawToDegC(const int16_t Temp)
		{
			return(((float)Temp) / 4.0);
		}
		
		TempErr GetTempDegC(float& Temp)
		{
			int16_t temp = 0;
			TempErr Err = GetTempRaw(temp);
			if (Sucess != Err) { return(Err); }

			Temp = RawToDegC(temp);
			
			return(Sucess);
		}

		static float RawToDegF(const int16_t Temp)
		{
			//9/5 C+32; Raw=C*4; 40 = 32/4 * 5
			return( (float)((Temp * 9) + 640) / 20.0 );
		}
		
		TempErr GetTempDegF(float& Temp)
		{
			int16_t temp = 0;
			TempErr Err = GetTempRaw(temp);
			if (Sucess != Err) { return(Err); }
			
			Temp = RawToDegF(temp);

			return(Sucess);
		}
};

#endif //_TempI2C_h


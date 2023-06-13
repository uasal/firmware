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
/// $Source: /raincloud/src/projects/include/adc/lt244x.h,v $
/// $Revision: 1.9 $
/// $Date: 2009/05/18 18:19:59 $
/// $Author: steve $
#pragma once

#include <stdint.h>
#ifdef DEBUG
	#include <stdio.h>
	#include <string.h>
#endif

#include "format/formatf.h"

#include "Delay.h"

namespace lt244xdetails
{
	static const int32_t CountPosVRef = 0x1FFFFFFF; //+2^28
	static const int32_t CountZero = 0x000000UL;
	static const int32_t CountNegVRef = (int32_t)0xE0000000UL; //-2^28
	
	union channel
	{
		uint8_t all;
		
		struct
		{
			uint8_t ChannelBits123 : 3;
			uint8_t ChanBit0orInvertDiffChan : 1;
			uint8_t SingleEnded : 1;
			uint8_t reserved : 3;
		} __attribute__((__packed__));
		
		channel()
			{ all = 0x00; }
			
		channel(const uint8_t singleended, const uint8_t chanbit0, const uint8_t chanbits123) : ChannelBits123(chanbits123), ChanBit0orInvertDiffChan(chanbit0), SingleEnded(singleended)
			{ }

	} __attribute__((__packed__));
	
		static const uint8_t DataRateNoChange = 0x00;
		static const uint8_t DataRateFClkDiv64 = 0x01; // 3.52kHz / 7.04kHz
		static const uint8_t DataRateFClkDiv128 = 0x02;
		static const uint8_t DataRateFClkDiv256 = 0x03;
		static const uint8_t DataRateFClkDiv512 = 0x04;
		static const uint8_t DataRateFClkDiv1024 = 0x05;
		static const uint8_t DataRateFClkDiv2048 = 0x06; // 110Hz / 220Hz
		static const uint8_t DataRateFClkDiv4096 = 0x07;
		static const uint8_t DataRateFClkDiv8192 = 0x08;
		static const uint8_t DataRateFClkDiv16384 = 0x09;
		static const uint8_t DataRateFClkDiv32768_60Hz50HzNull = 0x0F; // 6.875Hz / 13.75Hz
	
	union configregister
	{
		uint32_t all;		
		uint8_t bytes[4];

		struct
		{
			uint32_t reserved : 19;
			uint32_t DoubleSpeedAndOneCycleLatency : 1;
			uint32_t DataRate : 4;
			uint32_t ChannelBits123 : 3;
			uint32_t ChanBit0orInvertDiffChan : 1;
			uint32_t SingleEnded : 1;
			uint32_t Enable : 1;
			uint32_t AlwaysZero : 1;
			uint32_t AlwaysOne : 1;
		} __attribute__((__packed__));
		
		configregister()
			{ all = 0x00; DataRate = DataRateFClkDiv32768_60Hz50HzNull; Enable = 1; AlwaysOne = 1; }

		//~ configregister(uint8_t a, uint8_t b, uint8_t c, uint8_t d, uint8_t e)
			//~ { DigitalFilterSel = a; FIRPhase = b; DataRate = c; Mode = d; SyncType = e; }

		bool operator!=(configregister& rhs)
			{ return(all != rhs.all); }
			
		const configregister& operator=(const channel rhs)
		{ 
			SingleEnded = rhs.SingleEnded;
			ChanBit0orInvertDiffChan = rhs.ChanBit0orInvertDiffChan;
			ChannelBits123 = rhs.ChannelBits123;
			return(*this); 
		}

		#ifdef DEBUG
			//~ void sformatf(char* s) { ::sformatf(s, "configreg: all=0x%.2X [FilterSel=%d, FIRPh=%d, Rate=%d, Mode=%d, Sync=%d]", all, DigitalFilterSel, FIRPhase, DataRate, Mode, SyncType); }
			//~ void formatf() { ::formatf("configreg: all=0x%.2X [FilterSel=%d, FIRPh=%d, Rate=%d, Mode=%d, Sync=%d]", all, DigitalFilterSel, FIRPhase, DataRate, Mode, SyncType); }
		#endif
	} __attribute__((__packed__));
	
	union lt244x_sample
	{
		uint32_t all;
		uint8_t bytes[4];

		struct
		{
			int32_t sample : 29;
			uint32_t OverrangeIfSameAsMsb : 1;
			uint32_t AlwaysZero : 1;
			uint32_t StillConverting : 1;
		} __attribute__((__packed__));
		
		lt244x_sample()
			{ all = 0x00; }

		//~ lt244x_sample(uint8_t a, uint8_t b, uint8_t c, uint8_t d, uint8_t e)
			//~ { DigitalFilterSel = a; FIRPhase = b; DataRate = c; Mode = d; SyncType = e; }

		bool operator!=(lt244x_sample& rhs)
			{ return(all != rhs.all); }
			
		bool overrange() const { return( (1 == (sample >> 28)) & (1 == OverrangeIfSameAsMsb) ); }
		bool underrange() const { return( (0 == (sample >> 28)) & (0 == OverrangeIfSameAsMsb) ); }
		
		double CountsToVolts(const lt244xdetails::lt244x_sample& Counts, const double& AdcVRef) const
		{
			if (Counts.overrange()) { return(AdcVRef * 1.5); }
			if (Counts.underrange()) { return(AdcVRef * -1.5); }
			
			//return((double)1.23456789); //debug - just give a recognizable number
			//return((double)1.23456789); //debug - just give a recognizable number
			//~ return((double)(Counts.sample));
			//~ return((double)(lt244xdetails::CountPosVRef));
			//~ return( ((double)Counts.sample * AdcVRef) / ((double)lt244xdetails::CountPosVRef * 2.0) ); //cheesy: just do the positive half of the calculation
			return(((double)(Counts.sample) * (double)AdcVRef) / (4.0 * ((double)lt244xdetails::CountPosVRef - (double)lt244xdetails::CountNegVRef)));
		}
		
		//~ #ifdef DEBUG
			//~ void sformatf(char* s) { ::sformatf(s, "configreg: all=0x%.2X [FilterSel=%d, FIRPh=%d, Rate=%d, Mode=%d, Sync=%d]", all, DigitalFilterSel, FIRPhase, DataRate, Mode, SyncType); }
			void formatf() { ::formatf("configreg: all=0x%.2X [sample=%ld, OverrangeIfSameAsMsb=%d, AlwaysZero=%d, StillConverting=%d]", all, sample, OverrangeIfSameAsMsb, AlwaysZero, StillConverting); }
		//~ #endif
	} __attribute__((__packed__));
};

template <class pinout, class spi, const uint8_t SpiClkDiv = 60> //SpiClkDiv: can run up to 20MHz
struct lt244x : pinout, spi
{
	public:

		using pinout::enable;
		//~ using spi::init;
		using spi::setclkdivider;
		using spi::setclkpolarity;
		using spi::setclkphase;
		using spi::transmit;
		using spi::receive;
		using spi::Miso;
		//~ using spi::sck;
	
		lt244x(const double adcvref) : 
			chan_diff0vs1(lt244xdetails::channel(0, 0, 0)),
			chan_diff2vs3(lt244xdetails::channel(0, 0, 1)),
			chan_diff4vs5(lt244xdetails::channel(0, 0, 2)),
			chan_diff6vs7(lt244xdetails::channel(0, 0, 3)),
			chan_diff8vs9(lt244xdetails::channel(0, 0, 4)),
			chan_diff10vs11(lt244xdetails::channel(0, 0, 5)),
			chan_diff12vs13(lt244xdetails::channel(0, 0, 6)),
			chan_diff14vs15(lt244xdetails::channel(0, 0, 7)),	
			chan_diff1vs0(lt244xdetails::channel(0, 1, 0)),
			chan_diff3vs2(lt244xdetails::channel(0, 1, 1)),
			chan_diff5vs4(lt244xdetails::channel(0, 1, 2)),
			chan_diff7vs6(lt244xdetails::channel(0, 1, 3)),
			chan_diff9vs8(lt244xdetails::channel(0, 1, 4)),
			chan_diff11vs10(lt244xdetails::channel(0, 1, 5)),
			chan_diff13vs12(lt244xdetails::channel(0, 1, 6)),
			chan_diff15vs14(lt244xdetails::channel(0, 1, 7)),
			chan_se0(lt244xdetails::channel(1, 0, 0)),
			chan_se1(lt244xdetails::channel(1, 1, 0)),
			chan_se2(lt244xdetails::channel(1, 0, 1)),
			chan_se3(lt244xdetails::channel(1, 1, 1)),
			chan_se4(lt244xdetails::channel(1, 0, 2)),
			chan_se5(lt244xdetails::channel(1, 1, 2)),
			chan_se6(lt244xdetails::channel(1, 0, 3)),
			chan_se7(lt244xdetails::channel(1, 1, 3)),
			chan_se8(lt244xdetails::channel(1, 0, 4)),
			chan_se9(lt244xdetails::channel(1, 1, 4)),
			chan_se10(lt244xdetails::channel(1, 0, 5)),
			chan_se11(lt244xdetails::channel(1, 1, 5)),
			chan_se12(lt244xdetails::channel(1, 0, 6)),
			chan_se13(lt244xdetails::channel(1, 1, 6)),
			chan_se14(lt244xdetails::channel(1, 0, 7)),
			chan_se15(lt244xdetails::channel(1, 1, 7)),
			AdcVRef(adcvref)
		{
			//~ spi::setclkpolarity(false);
			//~ spi::setclkphase(false);
		}

		virtual ~lt244x()
		{ }

		static const unsigned int WaitSlowestSampleTimeoutuS = 150000; //Slowest Fs = 6.8Hz, 145454uS
		static const unsigned int WaitFastestSampleTimeoutuS = 285; //Fastest Fs = 3.52kHz, 145454uS
				
		// (commenting out any lt244xdetails::channels you aren't using saves ram since static's always use ram, even if const, go figure)
		const lt244xdetails::channel chan_diff0vs1;
		const lt244xdetails::channel chan_diff2vs3;
		const lt244xdetails::channel chan_diff4vs5;
		const lt244xdetails::channel chan_diff6vs7;
		const lt244xdetails::channel chan_diff8vs9;
		const lt244xdetails::channel chan_diff10vs11;
		const lt244xdetails::channel chan_diff12vs13;
		const lt244xdetails::channel chan_diff14vs15;	
		const lt244xdetails::channel chan_diff1vs0;
		const lt244xdetails::channel chan_diff3vs2;
		const lt244xdetails::channel chan_diff5vs4;
		const lt244xdetails::channel chan_diff7vs6;
		const lt244xdetails::channel chan_diff9vs8;
		const lt244xdetails::channel chan_diff11vs10;
		const lt244xdetails::channel chan_diff13vs12;
		const lt244xdetails::channel chan_diff15vs14;
		const lt244xdetails::channel chan_se0;
		const lt244xdetails::channel chan_se1;
		const lt244xdetails::channel chan_se2;
		const lt244xdetails::channel chan_se3;
		const lt244xdetails::channel chan_se4;
		const lt244xdetails::channel chan_se5;
		const lt244xdetails::channel chan_se6;
		const lt244xdetails::channel chan_se7;
		const lt244xdetails::channel chan_se8;
		const lt244xdetails::channel chan_se9;
		const lt244xdetails::channel chan_se10;
		const lt244xdetails::channel chan_se11;
		const lt244xdetails::channel chan_se12;
		const lt244xdetails::channel chan_se13;
		const lt244xdetails::channel chan_se14;
		const lt244xdetails::channel chan_se15;
				
		double CountsToVolts(const lt244xdetails::lt244x_sample& Counts) const
		{
			if (Counts.overrange()) { return(AdcVRef * 1.5); }
			if (Counts.underrange()) { return(AdcVRef * -1.5); }
			
			//return((double)1.23456789); //debug - just give a recognizable number
			//return((double)1.23456789); //debug - just give a recognizable number
			//~ return((double)(Counts.sample));
			//~ return((double)(lt244xdetails::CountPosVRef));
			//~ return( ((double)Counts.sample * AdcVRef) / ((double)lt244xdetails::CountPosVRef * 2.0) ); //cheesy: just do the positive half of the calculation
			return(((double)(Counts.sample) * (double)AdcVRef) / (4.0 * ((double)lt244xdetails::CountPosVRef - (double)lt244xdetails::CountNegVRef)));
		}
		
		double CountsToVolts(const int32_t& Counts) const
		{
			//return((Counts * AdcVRef * 1.061) / CountPosVRef);
			return(((double)(Counts) * (double)AdcVRef) / (2.0 * ((double)lt244xdetails::CountPosVRef - (double)lt244xdetails::CountNegVRef)));
			//return( ((double)Counts * (double)AdcVRef * (double)CountPosMax) / ((double)CountPosVRef * (double)CountPosVRef) ); //This is shit, but it's pretty close (1.005x) to correct...
			//~ return((double)0.0);
		}
		
		bool StillConverting()
		{
			bool EOC = false;
			pinout::enable(false);
			delayus(10);
			pinout::enable(true);
			delayus(10);
			EOC = Miso();
			pinout::enable(false);
			return(EOC);
		}

		void ReadChannel(const lt244xdetails::configregister& NewChannel, lt244xdetails::lt244x_sample& newsample)
		{
			LastChannelAndSamplingFreq = NewChannel;
			
			XferData(LastChannelAndSamplingFreq, newsample); //set channel and get old sample from whatever channel we were last on
			
			delayus(WaitFastestSampleTimeoutuS << LastChannelAndSamplingFreq.DataRate); //This is way overkill at slowest rate since LT h/w guys are clueless about s/w.
			
			XferData(LastChannelAndSamplingFreq, newsample);			
		}
		
		void ReadChannel(const lt244xdetails::channel& NewChannel, lt244xdetails::lt244x_sample& newsample)
		{
			LastChannelAndSamplingFreq = NewChannel;
			
			//~ for(size_t i = 0; i < 20000; i++) { if (!StillConverting()) { formatf("lt244x: wait complete @ %lu cycles.\n", (uint32_t)i); break; } }
			delayus(200000);
			
			XferData(LastChannelAndSamplingFreq, newsample); //set channel and get old sample from whatever channel we were last on
						
			//~ for(size_t i = 0; i < 20000; i++) { if (!StillConverting()) { formatf("lt244x: conversion1 complete @ %lu cycles.\n", (uint32_t)i); break; } }
			//~ delayus(WaitFastestSampleTimeoutuS << LastChannelAndSamplingFreq.DataRate); //This is way overkill at slowest rate since LT h/w guys are clueless about s/w.
			delayus(200000); //This is way overkill at slowest rate since LT h/w guys are clueless about s/w.
			
			XferData(LastChannelAndSamplingFreq, newsample);			
			
			//~ for(size_t i = 0; i < 20000; i++) { if (!StillConverting()) { formatf("lt244x: conversion2 complete @ %lu cycles.\n", (uint32_t)i); break; } }
			delayus(200000);
			
			XferData(LastChannelAndSamplingFreq, newsample);
			
			if (newsample.StillConverting) { ::formatf("lt244x: sample still not completed.\n"); }
		}
		
		#ifdef DEBUG
		void DebugUnitTest()
		{
			formatf("\nlt244x::DebugUnitTest(): sizeof(lt244xdetails::configregister): %lu, sizeof(lt244xdetails::lt244x_sample): %lu\n", sizeof(lt244xdetails::configregister), sizeof(lt244xdetails::lt244x_sample));
			
		}
		#endif
		
	private:
		
		const double AdcVRef;
		
		lt244xdetails::configregister LastChannelAndSamplingFreq;
	
		//~ static const unsigned int InterbyteDelayuS = 10; 
		
		__inline__ void XferData(const lt244xdetails::configregister config_in, lt244xdetails::lt244x_sample& adcdata_out) 
		{ 
			spi::setclkpolarity(true);
			spi::setclkphase(true);
			spi::setclkdivider(SpiClkDiv); 
			pinout::enable(false);
			delayus(10);
			pinout::enable(true);
			delayus(10);
			//~ delay::delayus(InterbyteDelayuS); 
			adcdata_out.bytes[3] = spi::receive(config_in.bytes[3]); 
			adcdata_out.bytes[2] = spi::receive(config_in.bytes[2]); 
			adcdata_out.bytes[1] = spi::receive(config_in.bytes[1]); 
			adcdata_out.bytes[0] = spi::receive(config_in.bytes[0]); 
			pinout::enable(false);
			//~ delay::delayus(InterbyteDelayuS);
		}
};


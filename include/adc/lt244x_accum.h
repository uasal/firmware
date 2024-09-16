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

#pragma once

#include <stdint.h>
#ifdef DEBUG
	#include <stdio.h>
	#include <string.h>
#endif

#include "format/formatf.h"
#include "lt244x.h"

union Ltc244xAccumulator
{
	uint64_t all;
	struct 
	{
		int64_t Sample : 29; //0 - 28
		uint64_t reserved : 19; //29 - 47
		uint16_t NumAccums; //48 - 63
		
	} __attribute__((__packed__));
	
	Ltc244xAccumulator() { all = 0; }
	
	double CountsToVolts() const { return(((double)(0-Sample) * (double)8.192) / (1.0 * ((double)lt244xdetails::CountPosVRef - (double)lt244xdetails::CountNegVRef))); }
		
	void formatf() const { ::formatf("Ltc244xAccumulator: Sample: %+10.0lf ", (double)Sample); ::formatf("(0x%.8lX", (uint32_t)(all >> 32));  ::formatf("%.8lX)", (uint32_t)(all)); ::formatf(", NumAccums: %lu ", (uint32_t)NumAccums); ::formatf("(0x%lX)", (uint32_t)NumAccums); }
	
} __attribute__((__packed__));

union Ltc244xAccumulatorChannel
{
	uint8_t all;
	
	struct
	{
		uint8_t ChannelBits123 : 3;
		uint8_t ChanBit0orInvertDiffChan : 1;
		uint8_t SingleEnded : 1;
		uint8_t reserved : 3;
	} __attribute__((__packed__));
	
	Ltc244xAccumulatorChannel()
		{ all = 0x00; }
		
	Ltc244xAccumulatorChannel(const uint8_t singleended, const uint8_t chanbit0, const uint8_t chanbits123) : ChannelBits123(chanbits123), ChanBit0orInvertDiffChan(chanbit0), SingleEnded(singleended)
		{ }

} __attribute__((__packed__));


template <class pinout>
struct lt244x_accum //: pinout, spi
{
	public:
		
		const int32_t CountPosVRef;
		const int32_t CountZero;
		const int32_t CountNegVRef;
		const Ltc244xAccumulatorChannel chan_diff0vs1;
		const Ltc244xAccumulatorChannel chan_diff2vs3;
		const Ltc244xAccumulatorChannel chan_diff4vs5;
		const Ltc244xAccumulatorChannel chan_diff6vs7;
		const Ltc244xAccumulatorChannel chan_diff8vs9;
		const Ltc244xAccumulatorChannel chan_diff10vs11;
		const Ltc244xAccumulatorChannel chan_diff12vs13;
		const Ltc244xAccumulatorChannel chan_diff14vs15;	
		const Ltc244xAccumulatorChannel chan_diff1vs0;
		const Ltc244xAccumulatorChannel chan_diff3vs2;
		const Ltc244xAccumulatorChannel chan_diff5vs4;
		const Ltc244xAccumulatorChannel chan_diff7vs6;
		const Ltc244xAccumulatorChannel chan_diff9vs8;
		const Ltc244xAccumulatorChannel chan_diff11vs10;
		const Ltc244xAccumulatorChannel chan_diff13vs12;
		const Ltc244xAccumulatorChannel chan_diff15vs14;
		const Ltc244xAccumulatorChannel chan_se0;
		const Ltc244xAccumulatorChannel chan_se1;
		const Ltc244xAccumulatorChannel chan_se2;
		const Ltc244xAccumulatorChannel chan_se3;
		const Ltc244xAccumulatorChannel chan_se4;
		const Ltc244xAccumulatorChannel chan_se5;
		const Ltc244xAccumulatorChannel chan_se6;
		const Ltc244xAccumulatorChannel chan_se7;
		const Ltc244xAccumulatorChannel chan_se8;
		const Ltc244xAccumulatorChannel chan_se9;
		const Ltc244xAccumulatorChannel chan_se10;
		const Ltc244xAccumulatorChannel chan_se11;
		const Ltc244xAccumulatorChannel chan_se12;
		const Ltc244xAccumulatorChannel chan_se13;
		const Ltc244xAccumulatorChannel chan_se14;
		const Ltc244xAccumulatorChannel chan_se15;
		
		lt244x_accum(const double adcvref) : 
			CountPosVRef(0x1FFFFFFFUL), //+2^28
			CountZero(0x000000UL),
			CountNegVRef((int32_t)0xE0000000UL), //-2^28
			//~ chan_diff0vs1(Ltc244xAccumulatorChannel(0, 0, 0)), //0
			//~ chan_diff2vs3(Ltc244xAccumulatorChannel(0, 0, 1)),
			//~ chan_diff4vs5(Ltc244xAccumulatorChannel(0, 0, 2)),
			//~ chan_diff6vs7(Ltc244xAccumulatorChannel(0, 0, 3)),
			//~ chan_diff8vs9(Ltc244xAccumulatorChannel(0, 0, 4)),
			//~ chan_diff10vs11(Ltc244xAccumulatorChannel(0, 0, 5)),
			//~ chan_diff12vs13(Ltc244xAccumulatorChannel(0, 0, 6)),
			//~ chan_diff14vs15(Ltc244xAccumulatorChannel(0, 0, 7)),	
			//~ chan_diff1vs0(Ltc244xAccumulatorChannel(0, 1, 0)), //8
			//~ chan_diff3vs2(Ltc244xAccumulatorChannel(0, 1, 1)),
			//~ chan_diff5vs4(Ltc244xAccumulatorChannel(0, 1, 2)),
			//~ chan_diff7vs6(Ltc244xAccumulatorChannel(0, 1, 3)),
			//~ chan_diff9vs8(Ltc244xAccumulatorChannel(0, 1, 4)), //12
			//~ chan_diff11vs10(Ltc244xAccumulatorChannel(0, 1, 5)),
			//~ chan_diff13vs12(Ltc244xAccumulatorChannel(0, 1, 6)),
			//~ chan_diff15vs14(Ltc244xAccumulatorChannel(0, 1, 7)), //15
			//~ chan_se0(Ltc244xAccumulatorChannel(1, 0, 0)), //16
			//~ chan_se1(Ltc244xAccumulatorChannel(1, 1, 0)), //24
			//~ chan_se2(Ltc244xAccumulatorChannel(1, 0, 1)), //17
			//~ chan_se3(Ltc244xAccumulatorChannel(1, 1, 1)), //25
			//~ chan_se4(Ltc244xAccumulatorChannel(1, 0, 2)), //18
			//~ chan_se5(Ltc244xAccumulatorChannel(1, 1, 2)), //26
			//~ chan_se6(Ltc244xAccumulatorChannel(1, 0, 3)), //19
			//~ chan_se7(Ltc244xAccumulatorChannel(1, 1, 3)), //27
			//~ chan_se8(Ltc244xAccumulatorChannel(1, 0, 4)), //20
			//~ chan_se9(Ltc244xAccumulatorChannel(1, 1, 4)), //28
			//~ chan_se10(Ltc244xAccumulatorChannel(1, 0, 5)), //21
			//~ chan_se11(Ltc244xAccumulatorChannel(1, 1, 5)), //29
			//~ chan_se12(Ltc244xAccumulatorChannel(1, 0, 6)), //22
			//~ chan_se13(Ltc244xAccumulatorChannel(1, 1, 6)), //30
			//~ chan_se14(Ltc244xAccumulatorChannel(1, 0, 7)), //24
			//~ chan_se15(Ltc244xAccumulatorChannel(1, 1, 7)), //31
			//Due to 2X conversion latency, the fpga's count is off:
			chan_diff0vs1(Ltc244xAccumulatorChannel(0, 0, 0)), //0
			chan_diff2vs3(Ltc244xAccumulatorChannel(0, 0, 1)),
			chan_diff4vs5(Ltc244xAccumulatorChannel(0, 0, 2)),
			chan_diff6vs7(Ltc244xAccumulatorChannel(0, 0, 3)),
			chan_diff8vs9(Ltc244xAccumulatorChannel(0, 0, 4)),
			chan_diff10vs11(Ltc244xAccumulatorChannel(0, 0, 5)),
			chan_diff12vs13(Ltc244xAccumulatorChannel(0, 0, 6)),
			chan_diff14vs15(Ltc244xAccumulatorChannel(0, 0, 7)),	
			chan_diff1vs0(Ltc244xAccumulatorChannel(0, 1, 0)), //8
			chan_diff3vs2(Ltc244xAccumulatorChannel(0, 1, 1)),
			chan_diff5vs4(Ltc244xAccumulatorChannel(0, 1, 2)),
			chan_diff7vs6(Ltc244xAccumulatorChannel(0, 1, 3)),
			chan_diff9vs8(Ltc244xAccumulatorChannel(0, 1, 4)), //12
			chan_diff11vs10(Ltc244xAccumulatorChannel(0, 1, 5)),
			chan_diff13vs12(Ltc244xAccumulatorChannel(0, 1, 6)),
			chan_diff15vs14(Ltc244xAccumulatorChannel(0, 1, 7)), //15
			chan_se0(Ltc244xAccumulatorChannel(1, 0, 2)), //18
			chan_se1(Ltc244xAccumulatorChannel(1, 1, 2)), //26
			chan_se2(Ltc244xAccumulatorChannel(1, 0, 3)), //19
			chan_se3(Ltc244xAccumulatorChannel(1, 1, 3)), //27
			chan_se4(Ltc244xAccumulatorChannel(1, 0, 4)), //20
			chan_se5(Ltc244xAccumulatorChannel(1, 1, 4)), //28
			chan_se6(Ltc244xAccumulatorChannel(1, 0, 5)), //21
			chan_se7(Ltc244xAccumulatorChannel(1, 1, 5)), //29
			chan_se8(Ltc244xAccumulatorChannel(1, 0, 6)), //22
			chan_se9(Ltc244xAccumulatorChannel(1, 1, 6)), //30
			chan_se10(Ltc244xAccumulatorChannel(1, 0, 7)), //23
			chan_se11(Ltc244xAccumulatorChannel(1, 1, 7)), //31
			chan_se12(Ltc244xAccumulatorChannel(1, 1, 0)), //24
			chan_se13(Ltc244xAccumulatorChannel(0, 0, 0)), //0
			chan_se14(Ltc244xAccumulatorChannel(1, 1, 1)), //25
			chan_se15(Ltc244xAccumulatorChannel(0, 0, 1)), //1
			AdcVRef(adcvref)
		{ }

		virtual ~lt244x_accum()
		{ }
		
		double CountsToVolts(const Ltc244xAccumulator& Accumulator) const
		{
			//~ return((((double)(Accumulator.Sample) / (double)(Accumulator.NumAccums)) * (double)AdcVRef) / (4.0 * ((double)CountPosVRef - (double)CountNegVRef)));
			//~ return( (((double)Accumulator.Sample) * (double)AdcVRef) / (double)(536870912)); //4.096 / 536870912 = 0.00000000762939453125
			return(((double)(0-(int32_t)Accumulator.Sample) * (double)8.192) / (1.0 * ((double)lt244xdetails::CountPosVRef - (double)lt244xdetails::CountNegVRef)));
		}
		
		double CountsToVolts(const int32_t& Counts) const
		{
			//~ return(((double)(Counts) * (double)AdcVRef) / (2.0 * ((double)CountPosVRef - (double)CountNegVRef)));
			return(((double)(0-(int32_t)Counts) * (double)8.192) / (1.0 * ((double)lt244xdetails::CountPosVRef - (double)lt244xdetails::CountNegVRef)));
		}

		double CountsToVolts(const lt244xdetails::lt244x_sample& Counts) const
		{
			//~ return(((double)(Counts.sample) * (double)AdcVRef) / (2.0 * ((double)CountPosVRef - (double)CountNegVRef)));
			return(((double)(0-(int32_t)Counts.sample) * (double)8.192) / (1.0 * ((double)lt244xdetails::CountPosVRef - (double)lt244xdetails::CountNegVRef)));
		}
		
		void ReadChannel(const Ltc244xAccumulatorChannel& Channel, Ltc244xAccumulator& Sample)
		{
			pinout::SetAdcReadChannel(Channel.all);
			pinout::GetAdcSample(Sample);
		}
		
		#ifdef DEBUG
		void DebugUnitTest()
		{
			formatf("\nlt244x::DebugUnitTest(): sizeof(Ltc244xAccumulator): %lu, sizeof(Ltc244xAccumulatorChannel): %lu\n", sizeof(Ltc244xAccumulator), sizeof(Ltc244xAccumulatorChannel));
			
		}
		#endif
				
	private:
		
		const double AdcVRef;
};


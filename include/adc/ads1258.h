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

#include "Delay.h"
#include "format/formatf.h"

namespace ads1258details
{
	const int32_t CountPosMax = 0x7FFFFFUL; //106% VRef
	const int32_t CountPosVRef = 0x780000UL;
	const int32_t CountZero = 0x000000UL;
	const int32_t CountNegVRef = (int32_t)0xFF87FFFFUL;
	const int32_t CountNegMin = (int32_t)0xFF800000UL; //-106% VRef
	const int32_t CountVRefVccDenominator = 786432;
	const int32_t CountGainDenominator = 7864320;
	
	static double CountsToVolts(const int32_t& Counts, const double& AdcVRef)
	{
		return(((double)Counts * (double)AdcVRef) / (double)CountPosVRef);
	}

	union ads1258status
	{
		uint8_t all;

		struct
		{
			uint8_t channel : 5; //(LSBs) only valid when scanning
			uint8_t isbrownout : 1; //vcc <= 4.3VDC - data corrupt
			uint8_t isclipped : 1; //adc input saturated
			uint8_t isnew : 1; //(MSB) data updated since last read
		} __attribute__((__packed__));

		void formatf() { ::formatf("status: chan=%d, brown=%d, clip=%d, isnew=%d", channel, isbrownout, isclipped, isnew); }

	}  __attribute__((__packed__));

	union ads1258sample
	{
		uint32_t all;

		struct
		{
			uint8_t zero;
			uint8_t one;
			uint8_t two;
			uint8_t three;
		} __attribute__((__packed__));

		struct
		{
			int32_t sample : 24;
			ads1258status status; //MSBs
		}  __attribute__((__packed__));

		ads1258sample(uint32_t &val) { all = val; }
		ads1258sample() { all = 0; }

		void formatf() { ::formatf("ADS1258 sample: %ld, ", sample); status.formatf(); ::formatf("\n"); }

	}  __attribute__((__packed__));

	static const uint8_t cmdtype_chanreaddirect = 0x00;
	static const uint8_t cmdtype_chanreadregister = 0x01; //must use multiple bit = 1
	static const uint8_t cmdtype_registerread = 0x02;
	static const uint8_t cmdtype_registerwrite = 0x03;
	static const uint8_t cmdtype_pulseconvert = 0x04;
	static const uint8_t cmdtype_reserved = 0x05;
	static const uint8_t cmdtype_reset = 0x06;
	static const uint8_t cmdtype_chanreaddirectalt = 0x07; //same as 0x00?

	static const uint8_t register_config0 = 0x00;
	static const uint8_t register_config1 = 0x01;
	static const uint8_t register_muxsch = 0x02; //only used in fixed-channel mode to set input channels
	static const uint8_t register_muxdif = 0x03; //bitfield for which inputs to scan diff0-7
	static const uint8_t register_muxsg0 = 0x04; //bitfield for which inputs to scan se0-7
	static const uint8_t register_muxsg1 = 0x05; //bitfield for which inputs to scan se8-15
	static const uint8_t register_sysread = 0x06; //bitfield for which inputs to scan internal channels
	static const uint8_t register_gpioc = 0x07; //gpio direction 0=7: 0=output, 1=input !!note ads1258 uses 0 for output, 1 for input, unlike every other device ever...
	static const uint8_t register_gpiod = 0x08; //gpio value 0=7: 0=pin low, 1=pin hi
	static const uint8_t register_idnum = 0x09; //always reads 0x8B; hard-coded

	union ads1258cmdheader
	{
		uint8_t all;

		struct
		{
			uint8_t address : 4; //(LSBs)
			uint8_t multiple : 1; //multiple register access?
			uint8_t cmdtype : 3; // (MSBs) read/write/etc.
		} __attribute__((__packed__));

		ads1258cmdheader()
			{ cmdtype = cmdtype_registerread; multiple = false; address = register_config0; }

		ads1258cmdheader(uint8_t c, uint8_t m, uint8_t a)
			{ cmdtype = c; multiple = m; address = a; }

		bool operator!=(ads1258cmdheader& rhs)
			{ return(all != rhs.all); }
	} __attribute__((__packed__));

	union config0register //default: 0x0A != 0b00001010
	{
		uint8_t all;

		struct
		{
			uint8_t alsomustbezero : 1; //lsb
			uint8_t stat : 1; //0=no status byte (3-byte samples); 1=status byte (4-byte samples) - only affects direct read when scanning, see table 13
			uint8_t chop : 1; //0=no chopping, 1=chop; must be zero to read internal channels (temp,vcc,gain,ref)
			uint8_t clkout : 1; //0=no clkout; 1=clk on clkout pin
			uint8_t bypass : 1; //0=internal connect adc<->mux; 1=use external pins
			uint8_t muxmod : 1; //0=autoscan; 1=fixchannel
			uint8_t spiresettimeout : 1; //0=4096cyc=256uS; 1=256cyc=16us
			uint8_t mustbezero : 1; //msb
		} __attribute__((__packed__));

		config0register()
			{ mustbezero = 0; spiresettimeout = 1; muxmod = 0; bypass = 0; clkout = 0; chop = 0; stat = 1; alsomustbezero = 0; }

		config0register(uint8_t a, uint8_t b, uint8_t c, uint8_t d, uint8_t e, uint8_t f)
			{ mustbezero = 0; spiresettimeout = a; muxmod = b; bypass = c; clkout = d; chop = e; stat = f; alsomustbezero = 0; }

		bool operator!=(config0register& rhs)
			{ return(all != rhs.all); }

		#ifdef DEBUG
			void sformatf(char* s) { ::sformatf(s, "config0reg: timeo=%d, mux=%d, byp=%d, clk=%d, chop=%d, stat=%d", spiresettimeout, muxmod, bypass, clkout, chop, stat); }
		#endif
	} __attribute__((__packed__));

	union config1register //default: 0x83 == 0b10000011
	{
		uint8_t all;

		struct
		{
			uint8_t datarate : 2; //0=1831s/s scan, 1953fix; 1=6168 scan, 7813fix; 2=15123scan, 31250fix; 3=23739scan, 125ks/s fix
			uint8_t sensorbiascurrent : 2; //0=off; 1=1.5uA; 3=24uA
			uint8_t delay : 3; //set to allow for settling time (000: 0 clock delay, 111: 48 clock delay)
			uint8_t idlemode : 1; //0=standby (more Iqq, faster); 1=sleep (less Iqq, slow wake)
		} __attribute__((__packed__));

		config1register()
			{ idlemode = 0; delay = 7; sensorbiascurrent = 0; datarate = 0; }

		config1register(uint8_t a, uint8_t b, uint8_t c, uint8_t d)
			{ idlemode = a; delay = b; sensorbiascurrent = c; datarate = d; }

		bool operator!=(config1register& rhs)
			{ return(all != rhs.all); }

		#ifdef DEBUG
			void sformatf(char* s) { ::sformatf(s, "config1reg: idle=%d, delay=%d, bias=%d, rate=%d", idlemode, delay, sensorbiascurrent, datarate); }
		#endif
	} __attribute__((__packed__));

	union muxschregister
	{
		uint8_t all;

		struct
		{
			uint8_t chan_posin : 4; //source for positive adc input
			uint8_t chan_negin : 4; //source for negative adc input
		} __attribute__((__packed__));

		muxschregister()
			{ chan_negin = 0; chan_posin = 1; }

		muxschregister(uint8_t a, uint8_t b)
			{ chan_negin = a; chan_posin = b; }

		bool operator!=(muxschregister& rhs)
			{ return(all != rhs.all); }

		#ifdef DEBUG
			void sformatf(char* s) { ::sformatf(s, "muxschregister: neg=%d, pos=%d", chan_negin, chan_posin); }
		#endif
	} __attribute__((__packed__));

	union sysreadregister
	{
		uint8_t all;

		struct
		{
			uint8_t scan_offset : 1;
			uint8_t reserve2 : 1;
			uint8_t scan_vcc : 1;
			uint8_t scan_temp : 1;
			uint8_t scan_gain : 1;
			uint8_t scan_ref : 1;
			uint8_t reserve1 : 1;
			uint8_t reserve0 : 1;
		} __attribute__((__packed__));

		sysreadregister()
			{ reserve0 = 0; reserve1 = 0; scan_ref = 1; scan_gain = 1; scan_temp = 1; scan_vcc = 1; scan_offset = 1; reserve2 = 0; }

		sysreadregister(uint8_t a, uint8_t b, uint8_t c, uint8_t d, uint8_t e)
			{ reserve0 = 0; reserve1 = 0; scan_ref = a; scan_gain = b; scan_temp = c; scan_vcc = d; scan_offset = e; reserve2 = 0; }

		bool operator!=(sysreadregister& rhs)
			{ return(all != rhs.all); }

		#ifdef DEBUG
			void sformatf(char* s) { ::sformatf(s, "sysreadregister: ref=%d, gain=%d, temp=%d, vcc=%d, off=%d", scan_ref, scan_gain, scan_temp, scan_vcc, scan_offset); }
		#endif

	} __attribute__((__packed__));

	const uint8_t chan_diff0 = 0x00;
	const uint8_t chan_diff1 = 0x01;
	const uint8_t chan_diff2 = 0x02;
	const uint8_t chan_diff3 = 0x03;
	const uint8_t chan_diff4 = 0x04;
	const uint8_t chan_diff5 = 0x05;
	const uint8_t chan_diff6 = 0x06;
	const uint8_t chan_diff7 = 0x07;
	const uint8_t chan_se0 = 0x08;
	const uint8_t chan_se1 = 0x09;
	const uint8_t chan_se2 = 0x0A;
	const uint8_t chan_se3 = 0x0B;
	const uint8_t chan_se4 = 0x0C;
	const uint8_t chan_se5 = 0x0D;
	const uint8_t chan_se6 = 0x0E;
	const uint8_t chan_se7 = 0x0F;
	const uint8_t chan_se8 = 0x10;
	const uint8_t chan_se9 = 0x11;
	const uint8_t chan_se10 = 0x12;
	const uint8_t chan_se11 = 0x13;
	const uint8_t chan_se12 = 0x14;
	const uint8_t chan_se13 = 0x15;
	const uint8_t chan_se14 = 0x16;
	const uint8_t chan_se15 = 0x17;
	const uint8_t chan_offset = 0x18; //24d
	const uint8_t chan_zeroed = 0x19;
	const uint8_t chan_vcc = 0x1A; //err?  skips 0x19 in datasheet!
	const uint8_t chan_temp = 0x1B;
	const uint8_t chan_gain = 0x1C; //28d
	const uint8_t chan_ref = 0x1D;

	const uint8_t ads1258numchannels = 0x1E;
};

using namespace ads1258details;

template <class spipinout>
struct ads1258 : spipinout
{
	public:

		using spipinout::enable;
		
		static const uint8_t gpio_output_mask_all_outputs = 0x00;
		static const uint8_t gpio_output_mask_all_inputs = 0xFF;
	
		static const bool inputtypedifferential = true;
		static const bool inputtypesingleended = false;

		static const uint8_t InitOK = 0x00;
	
		const double AdcVRef;

		ads1258(const double adcvref) :
			AdcVRef(adcvref),
			ScanChansDiff(0),
			ScanChansSELo(0),
			ScanChansSEHi(0),
			ScanChansInternal(0)
		{
			spipinout::setclkpolarity(true);
			spipinout::setclkphase(true);
		}

		virtual ~ads1258() { }
		
		double CountsToVolts(const int32_t& Counts) const
		{
			return(((double)Counts * (double)AdcVRef) / (double)CountPosVRef);
		}

		int32_t ConvertOnceDiff(uint8_t chanpos, uint8_t channeg)
		{
			//Set fixedchannel mode:
			ads1258details::config0register config0(1, 1, 1, 0, 0, 1);
			config0.muxmod = 1;
			WriteRegister(ads1258details::register_config0, config0.all);

			//Set channel to read (always differential + & -)
			ads1258details::muxschregister muxsch(chanpos, channeg);
			WriteRegister(ads1258details::register_muxsch, muxsch.all);
			uint8_t temp = 0;
			ReadRegister(ads1258details::register_muxsch, temp);
			if (muxsch.all != temp)
			{
				#ifdef DEBUG
					formatf("ads1258::ConvertOnceDiff(): muxsch mismatch (reads:0x%.2X)\n", temp);
				#endif
				return(ads1258details::register_muxdif);
			}

			//Convert:
			SendCommand(ads1258details::ads1258cmdheader(ads1258details::cmdtype_pulseconvert, false, 0));

			//Wait
			delayus(1000000);

			//Read data & return:
			return(ReadLastChannel(chanpos));
		}

		void ClearScanChannels()
		{
			ScanChansDiff = 0;
			ScanChansSELo = 0;
			ScanChansSEHi = 0;
			ScanChansInternal = 0;
		}
		
		uint32_t GetScanChannelsMask()
		{
			uint32_t Mask = 0;
			
			Mask |= ScanChansDiff;
			Mask |= (ScanChansSELo << 8);
			Mask |= (ScanChansSEHi << 16);
			Mask |= (ScanChansInternal << 24);
			
			return(Mask);
		}
		
		void SetScanChannelsMask(const uint32_t Mask)
		{
			ScanChansDiff = Mask & 0xFF;
			ScanChansSELo = (Mask >> 8) & 0xFF;
			ScanChansSEHi = (Mask >> 16) & 0xFF;
			ScanChansInternal = (Mask >> 24) & 0xFF;
		}

		void AddScanChannel(const unsigned int chan)
		{
			if (chan >= ads1258details::ads1258numchannels) { return; }
			
			uint32_t ScanChannels = GetScanChannelsMask();
			
			ScanChannels |= (1UL << chan);
			
			SetScanChannelsMask(ScanChannels);
		}
		
		void SetScanChannels(const uint8_t chan_diff, const uint8_t chan_se_lo, const uint8_t chan_se_hi, const uint8_t chan_internal)
		{
			ScanChansDiff = chan_diff;
			ScanChansSELo = chan_se_lo;
			ScanChansSEHi = chan_se_hi;
			ScanChansInternal = chan_internal;
		}
		
		bool IsScanChannel(const unsigned int chan)
		{
			uint32_t ScanChannels = GetScanChannelsMask();
			return( 0 != (ScanChannels & (1UL << chan)) );
		}
		
		unsigned int NumScanChannels() 
		{ 
			unsigned int NumChannels = 0;
			
			uint32_t ScanChannels = GetScanChannelsMask();
			
			for (unsigned int i = 0; i < ads1258details::ads1258numchannels; i++)
			{
				if (ScanChannels & 1UL) { NumChannels++; }
				
				ScanChannels = ScanChannels >> 1;
			}
			
			return(NumChannels);
		}
		
		void CommitScanChannels()
		{
			WriteRegister(ads1258details::register_muxdif, ScanChansDiff);
			WriteRegister(ads1258details::register_muxsg0, ScanChansSELo);
			WriteRegister(ads1258details::register_muxsg1, ScanChansSEHi);
			WriteRegister(ads1258details::register_sysread, ScanChansInternal);

			uint8_t temp;
			ReadRegister(ads1258details::register_muxdif, temp);
			if (ScanChansDiff != temp)
			{
				//~ #ifdef DEBUG
					formatf("ads1258::SetScanChannels(): muxdif mismatch (reads:0x%.2X)\n", temp);
				//~ #endif
			}
			ReadRegister(ads1258details::register_muxsg0, temp);
			if (ScanChansSELo != temp)
			{
				//~ #ifdef DEBUG
					formatf("ads1258::SetScanChannels(): muxsg0 mismatch (reads:0x%.2X)\n", temp);
				//~ #endif
			}
			ReadRegister(ads1258details::register_muxsg1, temp);
			if (ScanChansSEHi != temp)
			{
				//~ #ifdef DEBUG
					formatf("ads1258::SetScanChannels(): muxsg1 mismatch (reads:0x%.2X)\n", temp);
				//~ #endif
			}
			ReadRegister(ads1258details::register_sysread, temp);
			if (ScanChansInternal != temp)
			{
				//~ #ifdef DEBUG
					formatf("ads1258::SetScanChannels(): sysred mismatch (reads:0x%.2X)\n", temp);
				//~ #endif
			}
		}
		
		bool StartChannelScan()
		{
			bool Sucess = true;

			//Set scan channel(s) mode:
			ads1258details::config0register config0(1, 0, 1, 0, 0, 1);
			config0.muxmod = 0;
			config0.stat = 1;
			config0.bypass = 0;
			WriteRegister(ads1258details::register_config0, config0.all);

			//Convert:
			SendCommand(ads1258details::ads1258cmdheader(ads1258details::cmdtype_pulseconvert, false, 0));

			return(Sucess);
		}

		bool Scan()
		{
			ads1258details::ads1258sample temp = ReadLastChannel();

			SendCommand(ads1258details::ads1258cmdheader(ads1258details::cmdtype_pulseconvert, false, 0));

			if ( (temp.status.channel < ads1258details::ads1258numchannels) && (temp.status.isnew) )
			{
				lastsamples[temp.status.channel] = temp;
			}

			bool Sucess = true;
			return(Sucess);
		}
		
		bool AutoScan()
		{
			ads1258details::ads1258sample temp = ReadLastChannel();

			if ( (temp.status.channel < ads1258details::ads1258numchannels) && (temp.status.isnew) )
			{
				lastsamples[temp.status.channel] = temp;
			}

			bool Sucess = true;
			return(Sucess);
		}

		void GetLastSample(const uint8_t channel, ads1258details::ads1258sample& sample)
		{
			//validate index
			if (channel >= ads1258details::ads1258numchannels) { return; }
			
			//copy out the sample
			sample = lastsamples[channel];
			
			//make that sample 'old' so we don't use it twice
			lastsamples[channel].status.isnew = false;
		}
		
		virtual uint8_t Init(uint8_t gpio_output_mask = gpio_output_mask_all_outputs) //All outputs is reccommended in datasheet as inputs are not allowed to float for some ass reason.
		{
			//~ uint8_t Return = InitOK;
			//see pg 41 of ads1258 revD datasheet.

			//1. Reset spi - disable for 4096xFclk
			{
				enable(false);
				delayus(10000);
			}

			//2. stop the converter: set "start" pin low
			//<unimplemented in hardware, not strictly neccessary>

			//3. Reset the converter
			{
				SendCommand(ads1258details::ads1258cmdheader(ads1258details::cmdtype_reset, false, 0));
				delayus(1000);
			}

			//4. Config registers
			//ads1258details::config0register config0(1, 0, 1, 0, 0, 1); //Chopper off
			ads1258details::config0register config0(1, 0, 1, 0, 1, 1); //Chopper on
			ads1258details::config1register config1(0, 7, 0, 0);
			ads1258details::sysreadregister sysread(1, 1, 1, 1, 1);
			{
				WriteRegister(ads1258details::register_config0, config0.all);
				WriteRegister(ads1258details::register_config1, config1.all);
				WriteRegister(ads1258details::register_sysread, sysread.all);

				//pg 42: set no-connected gpio's to outputs
				WriteRegister(ads1258details::register_gpioc, gpio_output_mask); //all outputs
				WriteRegister(ads1258details::register_gpiod, 0x00); //all zero
			}

			//5. Readback registers
			{
				uint8_t temp;

				ReadRegister(ads1258details::register_config0, temp);
				if (config0.all != temp)
				{
					//~ #ifdef DEBUG
						::formatf("ads1258::init(): config0 mismatch (reads:0x%.2X, wanted:0x%.2X)\n", temp, config0.all);
					//~ #endif
					return(ads1258details::register_config0);
					//~ Return |= ads1258details::register_config0;
				}

				ReadRegister(ads1258details::register_config1, temp);
				if (config1.all != temp)
				{
					//~ #ifdef DEBUG
						::formatf("ads1258::init(): config1 mismatch (reads:0x%.2X, wanted:0x%.2X)\n", temp, config1.all);
					//~ #endif
					return(ads1258details::register_config1);
					//~ Return |= ads1258details::register_config1;
				}

				ReadRegister(ads1258details::register_sysread, temp);
				if (sysread.all != temp)
				{
					//~ #ifdef DEBUG
						::formatf("ads1258::init(): sysread mismatch (reads:0x%.2X, wanted:0x%.2X)\n", temp, sysread.all);
					//~ #endif
					return(ads1258details::register_sysread);
					//~ Return |= ads1258details::register_sysread;
				}

				//pg 42: set no-connected gpio's to outputs
				ReadRegister(ads1258details::register_gpioc, temp);
				if (gpio_output_mask != temp)
				{
					//~ #ifdef DEBUG
						::formatf("ads1258::init(): gpioc mismatch (reads:0x%.2X, wanted:0x%.2X)\n", temp, gpio_output_mask);
					//~ #endif
					return(ads1258details::register_gpioc);
					//~ Return |= ads1258details::register_gpioc;
				}

				//(Don't read gpiod - we write 0x00, but if pins are set as inputs, they will not read 0x00)
				
				//Check and see if the ID register matched 0x8B:
				ReadRegister(ads1258details::register_idnum, temp);
				if (0x8B != temp)
				{
					//~ #ifdef DEBUG
						::formatf("ads1258::init(): idnum mismatch (reads:0x%.2X, wanted:0x%.2X)\n", temp, 0x8B);
					//~ #endif
					return(ads1258details::register_idnum);
					//~ Return |= ads1258details::register_idnum;
				}
			}

			return(InitOK);
			//~ return(Return);			
		}

	private:

		ads1258details::ads1258sample lastsamples[ads1258details::ads1258numchannels];

		uint8_t ScanChansDiff;
		uint8_t ScanChansSELo;
		uint8_t ScanChansSEHi;
		uint8_t ScanChansInternal;

		// Control the chip select line & calculate enable-disable delay consistently everywhere:
		struct spi_busmsg
		{
			__inline__ spi_busmsg() { delayus(1000); spipinout::waitbusytimeout(); enable(true); }
			__inline__ ~spi_busmsg() { delayus(1); spipinout::waitbusytimeout(); enable(false); delayus(1000); }
		};

		//tx/rx a byte over spi:
		__inline__ void txb(uint8_t byte) { spipinout::transmit(byte); }
		__inline__ uint8_t rxb() { uint8_t x = spipinout::receive((uint8_t)(0)); return(x); }
		
	public:

		//Transfer data to/from internal registers: notice they are all different numbers of bytes
		//~ __inline__ void SetRegister24(uint8_t addr, uint32_t val)	{ addr |= 0x80; spi_busmsg x; txb(addr); 	delayus(5); txb(val >> 16); 	delayus(5); txb(val >> 8); 	delayus(5); txb(val); }
		//~ __inline__ void WriteRegister(const uint8_t addr, const uint8_t val)  	{ ads1258details::ads1258cmdheader cmd(ads1258details::cmdtype_registerwrite, false, addr); spi_busmsg x; txb(cmd.all); txb(val); }
		__inline__ void WriteRegister(const uint8_t addr, const uint8_t val)  	{ spi_busmsg x; txb(addr | 0x60); txb(val); }

		//~ __inline__ ads1258sample ReadLastChannel() { spi_busmsg x; ads1258sample val; ads1258cmdheader cmd(cmdtype_chanreadregister, 1, 0); txb(cmd.all); val.three = rxb(); val.two = rxb(); val.one = rxb(); val.zero = rxb(); return(val); }
		__inline__ ads1258details::ads1258sample ReadLastChannel() { spi_busmsg x; ads1258details::ads1258sample val; txb(0x30); val.three = rxb(); val.two = rxb(); val.one = rxb(); val.zero = rxb(); return(val); }
		__inline__ uint8_t  ReadRegister(const uint8_t addr) 	{ spi_busmsg x; uint8_t  val = 0; txb(addr | 0x40); val |= rxb(); return(val); }
		__inline__ void  ReadRegister(const uint8_t addr, uint8_t& val) 				{ spi_busmsg x; val = 0; txb(addr | 0x40); val |= rxb(); }

		__inline__ void SendCommand(ads1258details::ads1258cmdheader cmd)  	{ spi_busmsg x; txb(cmd.all); }
};


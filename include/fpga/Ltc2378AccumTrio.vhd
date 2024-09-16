--
--           Copyright (c) by Franks Development, LLC
--
-- This software is copyrighted by and is the sole property of Franks
-- Development, LLC. All rights, title, ownership, or other interests
-- in the software remain the property of Franks Development, LLC. This
-- software may only be used in accordance with the corresponding
-- license agreement.  Any unauthorized use, duplication, transmission,
-- distribution, or disclosure of this software is expressly forbidden.
--
-- This Copyright notice may not be removed or modified without prior
-- written consent of Franks Development, LLC.
--
-- Franks Development, LLC. reserves the right to modify this software
-- without notice.
--
-- Franks Development, LLC            support@franks-development.com
-- 500 N. Bahamas Dr. #101           http:--www.franks-development.com
-- Tucson, AZ 85710
-- USA
--
-- Permission granted for perpetual non-exclusive end-use by the University of Arizona August 1, 2020
--

--------------------------------------------------------------------------------
-- Ltc2378AccumTrio-20 A/D handler
--
-- c2013 Franks Development, LLC
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

--Considering this as a 24-bit output A/D for rough compatibility with AD7760, we have 8 bits left for PPS timestamp.
--100MHz / 256 (8b) < 400k == 2^19 * 0.75, so we have 13b left for seconds of day, which would repeat every 2.5 hours.
--And we're writing the actual seconds into the datafile headers, so we'll have to tweak it up in the C code. 100MHz = 27 bits.

entity Ltc2378AccumTrioPorts is
	port (
	
		--Globals
		clk : in std_logic;
		rst : in std_logic;
		
		-- A/D:
		Trigger : out std_logic; --rising edge initiates a conversion; 20ns min per hi/lo, so 
		nDrdyA : in std_logic; --Falling edge indicates a new sample is ready, should be approx 1usec after trigger goes high (1MHz)
		nDrdyB : in std_logic; --Falling edge indicates a new sample is ready, should be approx 1usec after trigger goes high (1MHz)
		nDrdyC : in std_logic; --Falling edge indicates a new sample is ready, should be approx 1usec after trigger goes high (1MHz)
		nCsA : out std_logic; -- 18th bit (msb) of data valid on falling edge.
		nCsB : out std_logic; -- 18th bit (msb) of data valid on falling edge.
		nCsC : out std_logic; -- 18th bit (msb) of data valid on falling edge.
		Sck : out std_logic; --can run up to ~100MHz (">40MHz??); idle in low state
		MisoA : in  std_logic; --valid 16nsec after nCs low; shifts on rising edge of sck, sample when sck low.		
		MisoB : in  std_logic; --valid 16nsec after nCs low; shifts on rising edge of sck, sample when sck low.		
		MisoC : in  std_logic; --valid 16nsec after nCs low; shifts on rising edge of sck, sample when sck low.		
		OverRangeA : out std_logic; --is the A/D saturated?
		OverRangeB : out std_logic; --is the A/D saturated?
		OverRangeC : out std_logic; --is the A/D saturated?
	
		--Control signals
		AdcPowerDown : in std_logic; --self-explanatory...
		AdcClkDivider : in std_logic_vector(15 downto 0); --This knob controls the acquisition speed of the A/D.
		SamplesToAverage : in std_logic_vector(15 downto 0); --Only supported on LTC2380-24 hardware! This also controls the acquisition speed of the A/D; each 4x averaging gives an extra bit of SNR or 6dB.
		ChopperEnable : in std_logic; --turns chopper on/off to reduce 1/f noise and offset!
		ChopperMuxPos : out std_logic; --switches inputs when chopper on to reduce 1/f noise and offset!
		ChopperMuxNeg : out std_logic; --switches inputs when chopper on to reduce 1/f noise and offset!
	
		--Bus interface
		ReadAdcSample : in std_logic;  --"inversion results in read on falling edge so next sample is always in register before we start reading. When fifo is emptied, the first sample will probably always be crap, we'll fix that when this works...	"
		AdcSampleToReadA : out std_logic_vector(47 downto 0);		
		AdcSampleToReadB : out std_logic_vector(47 downto 0);		
		AdcSampleToReadC : out std_logic_vector(47 downto 0);	
		AdcSampleNumAccums : out std_logic_vector(15 downto 0);
		
		--Debug
		TP1 : out std_logic;
		TP2 : out std_logic;
		TP3 : out std_logic;
		TP4 : out std_logic--;

	); end Ltc2378AccumTrioPorts;

architecture Ltc2378AccumTrio of Ltc2378AccumTrioPorts is

	component IBufP2Ports is
	port (
		clk : in std_logic;
		I : in std_logic;
		O : out std_logic--;
	);
	end component;
	
	component VariableClockDividerPorts is
	generic (
		WIDTH_BITS : natural := 8;
		DIVOUT_RST_STATE : std_logic := '0'--;
	);
	port 
	(						
		clki : in std_logic;
		rst : in std_logic;
		rst_count : in std_logic_vector(WIDTH_BITS - 1 downto 0);
		terminal_count : in std_logic_vector(WIDTH_BITS - 1 downto 0);
		clko : out std_logic
	);
	end component;
	
	component OneShotPorts is
	generic (
		CLOCK_FREQHZ : natural := 10000000;
		DELAY_SECONDS : real := 0.001;
		SHOT_RST_STATE : std_logic := '0';
		SHOT_PRETRIGGER_STATE : std_logic := '0'--;
	);
	port (
	
		clk : in std_logic;
		rst : in std_logic;
		shot : out std_logic
	);
	end component;

	component SpiMasterTrioPorts is
	generic (
		CLOCK_DIVIDER : integer := 4;
		BYTE_WIDTH : natural := 1;
		CPOL : std_logic := '0'--;	
	);
	port
	(
		clk : in std_logic;
		rst : in std_logic;
		MosiA : out std_logic;
		MosiB : out std_logic;
		MosiC : out std_logic;
		Sck : out std_logic;
		MisoA : in std_logic;
		MisoB : in std_logic;
		MisoC : in std_logic;
		DataToMosiA : in std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataToMosiB : in std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataToMosiC : in std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataFromMisoA : out std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataFromMisoB : out std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataFromMisoC : out std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		XferComplete : out std_logic--;
	);
	end component;
	
	--nDrdy is inverted (obviously)
	constant DataReady : std_logic := '0';
	constant NoDataReady : std_logic := '1';
	
	signal LastnDrdy : std_logic; --to grab edge
	
	--~ signal LastPPS : std_logic; 
	
	--~ signal DataFromMisoA : signed(23 downto 0);
	--~ signal DataFromMisoB : signed(23 downto 0);
	--~ signal DataFromMisoC : signed(23 downto 0);
	signal DataFromMisoA : std_logic_vector(23 downto 0);
	signal DataFromMisoB : std_logic_vector(23 downto 0);
	signal DataFromMisoC : std_logic_vector(23 downto 0);
	signal SpiRst : std_logic; --kicks off / inhibits transfer of a sample out of the A/D
	signal SpiRst_i : std_logic; --delayed version to give a/d time to drive miso
	signal SpiXferComplete : std_logic;
	signal LastSpiXferComplete : std_logic;
	signal Sck_i : std_logic;
	
	--~ signal LastSyncRequest : std_logic;
	
	signal TriggeredSampleClk : std_logic;
	
	--~ type TrigStates is (Idle, WaitTriggered);
	--~ signal TrigNextState : TrigStates;
	--~ signal TrigCurrentState : TrigStates;
	
	signal AdcSampleA : std_logic_vector(23 downto 0);
	signal AdcSampleB : std_logic_vector(23 downto 0);
	signal AdcSampleC : std_logic_vector(23 downto 0);
	signal SampleLatched : std_logic;
	
	signal SamplesAveraged : std_logic_vector(15 downto 0);
	signal SamplesThisSecond : std_logic_vector(31 downto 0);
	
	signal LastReadRequest : std_logic;

	signal ChopperPolarity : std_logic := '0';
	
begin

	TP1 <= SpiRst;
	TP2 <= Sck_i;
	TP3 <= SampleLatched;
	TP4 <= TriggeredSampleClk;

	--~ TP1 <= nDrdyA;
	--~ TP2 <= nDrdyB;
	--~ TP3 <= nDrdyC;
	
	--Just run the A/D (max speed is clk / 96 [2^20Hz], min speed = 100MHz/16k = 1.536kHz)
	clk_div_adcconv : VariableClockDividerPorts
	generic map
	(
		WIDTH_BITS => 16--,
	)
	port map
	(
		clki => clk,
		rst => rst,
		rst_count => AdcClkDivider,
		terminal_count => AdcClkDivider,
		clko => TriggeredSampleClk
	);
	Trigger <= TriggeredSampleClk and not(AdcPowerDown); --falling edge initiates a conversion; we should add AdcPowerDown to the equation to save power...(200mW converting, 75uW idle)

	--Are we over-range?
	OverRangeA <= '1' when ( (AdcSampleA(23 downto 0) = "011111111111111111111111") or (AdcSampleA(23 downto 0) = "100000000000000000000000") ) else '0'; --This is either +/- VRef...
	OverRangeB <= '1' when ( (AdcSampleB(23 downto 0) = "011111111111111111111111") or (AdcSampleB(23 downto 0) = "100000000000000000000000") ) else '0'; --This is either +/- VRef...
	OverRangeC <= '1' when ( (AdcSampleC(23 downto 0) = "011111111111111111111111") or (AdcSampleC(23 downto 0) = "100000000000000000000000") ) else '0'; --This is either +/- VRef...

	Sck <= Sck_i;
	
	--ltc23xx miso transitions on falling edge of sck. First rising edge is msb; if falling edge before, falling ignored (sck idles low).
	Spi : SpiMasterTrioPorts
	generic map (
		--~ CLOCK_DIVIDER => 0, --supposed to work at 100MHz; ...datasheet suggests >64...
		--~ CLOCK_DIVIDER => 1, --supposed to work at 100MHz; ...datasheet suggests >64...
		CLOCK_DIVIDER => 32, --1.5MHz
		--~ CLOCK_DIVIDER => 10, --10MHz
		--~ CLOCK_DIVIDER => 4, --36MHz
		--~ CLOCK_DIVIDER => MASTER_CLOCK_FREQHZ / 10000,
		BYTE_WIDTH => 3, --Ltc2378AccumTrio samples are 18 bits wide; will be left-just to 24bit.
		CPOL => '0'--,
	)
	port map
	(
		clk => clk, --runs off the same clock as the A/D to keep everything nicely aligned & quiet
		rst => SpiRst_i, --every sample requires a set/rst sequence to run spimaster
		MosiA => open, --we don't actually send anything to the A/D, all it needs is the sample trigger/clock
		MosiB => open, --we don't actually send anything to the A/D, all it needs is the sample trigger/clock
		MosiC => open, --we don't actually send anything to the A/D, all it needs is the sample trigger/clock
		Sck => Sck_i,
		MisoA => MisoA,
		MisoB => MisoB,
		MisoC => MisoC,
		DataToMosiA => x"000000",
		DataToMosiB => x"000000",
		DataToMosiC => x"000000",
		DataFromMisoA => DataFromMisoA,
		DataFromMisoB => DataFromMisoB,
		DataFromMisoC => DataFromMisoC,
		XferComplete => SpiXferComplete--,
	);
	
	SpiEnableDelayOneShot : OneShotPorts
	generic map (
		CLOCK_FREQHZ => 100000000,
		DELAY_SECONDS => 0.00000003,
		SHOT_RST_STATE => '1',
		SHOT_PRETRIGGER_STATE => '1'
	)
	port map (		
		clk => clk,
		rst => SpiRst,
		shot => SpiRst_i--,
	);
	
	nCsA <= SpiRst; --these concepts are synchronous in this design
	nCsB <= SpiRst; --these concepts are synchronous in this design
	nCsC <= SpiRst; --these concepts are synchronous in this design
	
	--Read A/D:
	process (clk, rst, nDrdyA, nDrdyB, nDrdyC, SpiXferComplete)
	begin
	
		if (rst = '1') then --We're using AdcClkReset instead of the external rst signal here so that sync will reset SamplesAveraged so our sample is aligned to sync when we are downsampling...
		
			SpiRst <= '1';			
			LastnDrdy <= '0';
			--~ SampleLatched <= '0';
			SampleLatched <= '1';
			--~ AdcSample <= x"0000000000000000";
			LastSpiXferComplete <= '0';
			SamplesAveraged <= x"0000";
			SamplesThisSecond <= x"00000000";
			ChopperPolarity <= '0';
			ChopperMuxPos <= '0';
			ChopperMuxNeg <= '0';		
			LastReadRequest <= '0';			
			
		else
			
			if ( (clk'event) and (clk = '1') ) then
			
				--Follow Drdy
				--~ if (nDrdy /= LastnDrdy) then
					--~ LastnDrdy <= nDrdy;
					--~ if (nDrdy = DataReady) then
					
				if ((nDrdyA = DataReady) and (nDrdyB = DataReady) and (nDrdyC = DataReady) and (LastnDrdy = NoDataReady)) then
				
					LastnDrdy <= DataReady;
					
					--Here we go...
					
					--Switch the mux right at start of acquisition (aka right after a conversion is finished) to maximize settling time:
					if (ChopperEnable = '1') then

						ChopperMuxPos <= ChopperPolarity;
						ChopperMuxNeg <= ChopperPolarity;
						
					end if;
					
					--~ if (SamplesAveraged >= SamplesToAverage) then
					--~ if ( (SamplesAveraged >= SamplesToAverage) or ((PPSTrigger = '1') and (PPSCount > std_logic_vector(to_unsigned(100663196, 32)))) ) then
					if (unsigned(SamplesAveraged) >= unsigned(SamplesToAverage)) then
					
						SamplesAveraged <= x"0000";
				
						--Initiate reading the data.
						SpiRst <= '0';
						
						--Tell the outside world we're now in the middle of things.
						SampleLatched <= '0';
						
						--Ask for a timestamp:
						--~ AdcSample(50 downto 24) <= PPSCount(26 downto 0);
						--~ AdcSample(63 downto 51) <= Seconds(12 downto 0);
						
					else
					
						SamplesAveraged <= std_logic_vector(unsigned(SamplesAveraged) + x"0001");
					
					end if;
					
				else
				
					if ((nDrdyA = NoDataReady) and (nDrdyB = NoDataReady) and (nDrdyC = NoDataReady) and (LastnDrdy = DataReady)) then
					
						LastnDrdy <= NoDataReady;
						
					else

						--Wait for Spi xfer to complete, then grab the sample and we're done
						if (SpiXferComplete /= LastSpiXferComplete) then
						
							LastSpiXferComplete <= SpiXferComplete;

							if (SpiXferComplete = '1') then
						
								if (ChopperEnable = '0') then
								
									--grab sample
									AdcSampleA(23 downto 0) <= DataFromMisoA;
									AdcSampleB(23 downto 0) <= DataFromMisoB;
									AdcSampleC(23 downto 0) <= DataFromMisoC;
									--~ AdcSampleA <= std_logic_vector(to_signed(0, 48) + signed(DataFromMisoA));
									--~ AdcSampleB <= std_logic_vector(to_signed(0, 48) + signed(DataFromMisoB));
									--~ AdcSampleC <= std_logic_vector(to_signed(0, 48) + signed(DataFromMisoC));
									
									
									SampleLatched <= '1';
									
								else
								
									ChopperPolarity <= not(ChopperPolarity);
									
									if (ChopperPolarity = '0') then
									
										--just grab sample
										AdcSampleA(23 downto 0) <= DataFromMisoA;
										AdcSampleB(23 downto 0) <= DataFromMisoB;
										AdcSampleC(23 downto 0) <= DataFromMisoC;
										
									else
									
										--do the difference!
										AdcSampleA(23 downto 0) <= std_logic_vector(signed(AdcSampleA(23 downto 0)) - signed(DataFromMisoA));								
										AdcSampleB(23 downto 0) <= std_logic_vector(signed(AdcSampleB(23 downto 0)) - signed(DataFromMisoB));								
										AdcSampleC(23 downto 0) <= std_logic_vector(signed(AdcSampleC(23 downto 0)) - signed(DataFromMisoC));								
										SampleLatched <= '1';
										
									end if;
									
								end if;
								
								SamplesThisSecond <= std_logic_vector(unsigned(SamplesThisSecond) + x"00000001");
								
								--turn off spi master bus
								SpiRst <= '1';
								
							end if;
							
						else
						
							if (ReadAdcSample /= LastReadRequest) then
					
								LastReadRequest <= ReadAdcSample;
								
								if (ReadAdcSample = '1') then
								
									--We're not actually accumulating just yet...
									AdcSampleToReadA <= std_logic_vector(to_signed(0, 48) + signed(AdcSampleA));
									AdcSampleToReadB <= std_logic_vector(to_signed(0, 48) + signed(AdcSampleB));
									AdcSampleToReadC <= std_logic_vector(to_signed(0, 48) + signed(AdcSampleC));
									AdcSampleNumAccums <= x"0001";

								end if;					

							end if;
						
						end if;		
						
					end if;
					
				end if;
					
			end if;		
			
		end if;	
		
	end process;

end Ltc2378AccumTrio;

	------------------------------------------------------------------------------------------------------------  A/D ------------------------------------------------------------------------------------------------------------------ ------------------------------------------------------ 
	
	---LTC2389 A/D timing
	-- 400 ns min cycle time; 100663296 / 40 = 397 ns cycle time, 99.25%
	-- also shows Tcyc = Tacq + Tconv + Tbusylh; 77ns min + 310ns max (245ns min) + 13ns max.
	
	--And run the DC/DC at  A/D / 2 (1MHz):
	  --If the A/D clock is stopped (rst), DcDcClk_i doesn't toggle and the DC/DC is in low noise (DcDcClk_i = 1) or low power (DcDcClk_i = 0) mode.
	--~ DcDcClk_i <= TriggeredSampleClk / 2;
		
	--~ AdcSample(31 downto 18) <= PPSCounter(13 downto 0); --<debug; leave as doc when tested> --better idea than timestamp (or same exact thing from diff register?)? Max res, but max rollover...14b = 16384 and 100663296 / 16384 = 6144Hz (exactly) which would be 162.76uS before rollover, and one sample is 0.000000477s or every 341.2 samples (was 343.39... samples); nonsense calcs: 6144Hz / 48 = 128; 2097152Hz / 128  = 16384; 1/128 = 0.0078125, so 128 rollovers?
	--A/D clock runs at PPSClk / 48, so you'd expect a count of (dithered) exactly 48 PPSClks between samples. So, let's verify that, and agree that we can ditch the bottom 5 bits of the PPSCounter...
	-- ...at which point we'd do:
	--AdcSample(31 downto 18) <= PPSCount(18 downto 5); --<prefered> --PPSClk "MasterClock 100663296" / 32 = 3145728 which is 3.1MHz, and we can't run the a/d faster than that, so those bits are superflous (but / 64 would eat a non-toggling bit above 1.57MHz)
	--which would instead rollover at 100663296Hz / 32 / 14b = 192Hz (exactly), which would be 5.208333mS, or every 10922.67 samples (10922 / 341 = 32, in case you were wondering) [2097152 / 10922 = 192, if you were wondering]
	--now, down the road, we could rewrite the calc of 'SubMilliseconds' in RTC to reflect this [PPSCount(18 downto 5)], so the code would be more self-documenting and concise/consistent
	--incidentally, if PPS counts to 100663296, it counts up to 27 bits (which is why we pass it around as a 32-bit counter; if we rewrote that code with the 'natural' and 'range' constructs we could shrink alot of registers in the fpga by 5 bits (27 bits still holds up to 134MHz)
	--further, if we're skipping the top (26.5 downto 19) bits of the PPS counter, that's 8.5 MSB bits of it. bit 19 of PPS counter toggles at 384Hz or every 2.6ms. Samples come in every 477ns (which equates to 5450 samples, half of 10901). My calculator is a POS, it shouldn't introduce roundoff from cut & paste so soon.
	--...now our double-ledger accounting is done.
		
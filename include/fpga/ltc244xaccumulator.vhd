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
-- ltc244x accumulator infrastructure
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;
library work;
use work.ltc244xaccumulator_types.all;
use work.ltc244x_types.all;

entity ltc244xaccumulatorPorts is
	generic 
	(
		MASTER_CLOCK_FREQHZ : natural := 10000000;
		LTC244X_DATARATE : std_logic_vector(3 downto 0) := "1111";
		LTC244X_DOUBLERATE : std_logic := '0'--;
	);
	port 
	(
		clk : in std_logic;
		rst : in std_logic;
		
		-- To A/D
		nDrdy : in  std_logic; --Falling edge indicates new data
		nCs : out std_logic; --Falling edge initiates a new conversion
		Sck : out std_logic; --can run up to 20MHz
		Mosi : out std_logic; --10nsec setup time
		Miso : in  std_logic; --valid after 25nsec, 15nsec hold time

		--Debug
		InvalidStateReached : out std_logic;
		Dbg1 : out std_logic;
		Dbg2 : out std_logic;
		
		-- To Datamapper
		AdcChannelReadIndex : in std_logic_vector(4 downto 0);
		ReadAdcSample : in std_logic;		
		AdcSampleToRead : out ltc244xaccumulator--;
	);
end ltc244xaccumulatorPorts;

architecture ltc244xaccumulator_i of ltc244xaccumulatorPorts is

	component ltc244xAutoscanPorts is
		generic (
			MASTER_CLOCK_FREQHZ : natural := 10000000--;
		);
		port (
		
			--Globals
			clk : in std_logic;
			rst : in std_logic;
			
			-- A/D:
			nDrdy : in  std_logic; --Falling edge indicates new data
			nCs : out std_logic; --Falling edge initiates a new conversion
			Sck : out std_logic; --can run up to 20MHz
			Mosi : out std_logic; --10nsec setup time
			Miso : in  std_logic; --valid after 25nsec, 15nsec hold time
			
			--Control
			NextChannel : in std_logic_vector(4 downto 0);
			NextDatarate : in std_logic_vector(3 downto 0);
			NextDoubleRate : in std_logic;
			
			-- Bus / Fifos:
			Sample : out ltc244xsample;
			SampleLatched : out std_logic;		
			TimestampReq : out std_logic--;				
		);
	end component;

	--containers for data in/out of ram
	signal Retreived_ltc244xaccumulator : ltc244xaccumulator;
	signal Accumulated_ltc244xaccumulator : ltc244xaccumulator;
	
	--state machine for incoming samples
	type AccumSampleStates is ( WaitSample, GetLastAccum, ResetLastAccum, Accumulate, WriteAccumResult, WriteCompleteBumpChannel );
	signal AccumSampleNextState : AccumSampleStates;
	signal AccumSampleCurrentState : AccumSampleStates;
	
	--control/state signals:
	signal AdcSampleLatched : std_logic;
	signal LastAdcSampleLatched : std_logic;
	signal AdcSample : ltc244xsample;
	signal LastReadAdcSample : std_logic;
	signal ResetAccum : std_logic_vector(31 downto 0);
	signal Channel : std_logic_vector(4 downto 0);
	signal NextChannel : std_logic_vector(4 downto 0);
	
	constant DEPTH : natural := 32;
	type ram_type is array (0 to DEPTH - 1) of std_logic_vector(63 downto 0);
	--~ shared variable RAM		: ram_type := (others => (others => '0')); -- Shared variable to infer block ram
	shared variable RAM		: ram_type; -- Shared variable to infer block ram
		
begin

	--Debug signals
	Dbg1 <= ResetAccum(0);
	Dbg2 <= AdcSampleLatched;
	
	ltc244x_i : ltc244xAutoscanPorts
	generic map 
	(
		MASTER_CLOCK_FREQHZ => MASTER_CLOCK_FREQHZ--,
	)
	port map
	(
		clk => clk,
		rst => rst,		
		nDrdy => nDrdy,
		nCs => nCs,
		Sck => Sck,
		Mosi => Mosi,
		Miso => Miso,
		NextChannel => NextChannel,
		--~ NextChannel => "10000", --debug; always read Ch0 so we can figure out if we have hardware vs. software problems...
		NextDatarate => LTC244X_DATARATE,
		NextDoubleRate => LTC244X_DOUBLERATE,
		Sample => AdcSample,
		SampleLatched => AdcSampleLatched,
		TimestampReq => open--,
	);
	
	--This process grabs samples from the a/d and accumulates them
	process(clk, rst, AdcSampleLatched)
	begin
	
		if (rst = '1') then
		
			LastAdcSampleLatched <= '0';			
			LastReadAdcSample <= '0';			
			InvalidStateReached <= '0';			
			
			Channel <= "00000";
			NextChannel <= "00000";
			
			Accumulated_ltc244xaccumulator <= ltc244xaccumulator_init;
			Retreived_ltc244xaccumulator <= ltc244xaccumulator_init;			
			ResetAccum <= x"FFFFFFFF";
			
			AccumSampleNextState <= WaitSample;
			AccumSampleCurrentState <= WaitSample;
	
		else

			if ( (clk'event) and (clk = '1') ) then
			
				--Did the uC want to read a sample?
				if (ReadAdcSample /= LastReadAdcSample) then
				
					--Capture edge
					LastReadAdcSample <= ReadAdcSample;
				
					--Latch sample on rising edge
					if (ReadAdcSample = '1') then
					
						AdcSampleToRead <= std_logic_to_ltc244xaccum(RAM(to_integer(unsigned(AdcChannelReadIndex))));
						
					--Clear accumulator on falling edge
					else
					
						--Set reset flag
						ResetAccum(to_integer(unsigned(AdcChannelReadIndex))) <= '1';	
						
					end if;
					
				else
				
					--Change state when requested
					AccumSampleCurrentState <= AccumSampleNextState;
			  
					case AccumSampleCurrentState is
		
						when WaitSample =>
						
							--Wait state; don't change states until we get a new sample
							
							--If we get here, we're in the intended state machine
							InvalidStateReached <= '0';
							
							--Do we have a new sample from the A/D?
							if (AdcSampleLatched /= LastAdcSampleLatched) then
							
								--Capture edge
								LastAdcSampleLatched <= AdcSampleLatched;
								
								if (AdcSampleLatched = '1') then
								
									AccumSampleNextState <= GetLastAccum;	
									
									--Once we get a sample the channel is gonna get bumpped when we're done.
									NextChannel <= Channel + "00001";
									
								end if;
								
							end if;
							
						when GetLastAccum =>
							
							--Single clock state
							AccumSampleNextState <= ResetLastAccum;
							
							--Get old accumulator
							Retreived_ltc244xaccumulator <= std_logic_to_ltc244xaccum(RAM(to_integer(unsigned(Channel))));
							
						when ResetLastAccum =>
							
							--Single clock state
							AccumSampleNextState <= Accumulate;
							
							if ( ResetAccum(to_integer(unsigned(Channel))) = '1' ) then
								
									--Reset NumAccums
									Retreived_ltc244xaccumulator.NumAccums <= x"0000"; --Increment NumAccums
									
									--Reset Accumulator
									Retreived_ltc244xaccumulator.Sample <= x"000000000000";
									
									--Clear reset flag
									ResetAccum(to_integer(unsigned(Channel))) <= '0';
								
							end if;
						
						when Accumulate =>
						
							--Single clock state							
							AccumSampleNextState <= WriteAccumResult;
						
							--Saturate
							if (Retreived_ltc244xaccumulator.NumAccums < x"FFFF") then
							
								--Increment NumAccums
								Accumulated_ltc244xaccumulator.NumAccums <= Retreived_ltc244xaccumulator.NumAccums + x"0001"; --Increment NumAccums
								
								--Increment Accumulator
								--~ Accumulated_ltc244xaccumulator.Sample <= Retreived_ltc244xaccumulator.Sample + AdcSample.Sample; --Accumulate
								
								--Or
								
								--Debug: don't actually accumulate until we get semi-realistic values from A/D...
								
									--Just overwite accumulator with new sample
									Accumulated_ltc244xaccumulator.Sample(28 downto 0) <= AdcSample.Sample;
									
									--Sign extension - you only wanna do this for a bipolar supply...
									--~ if (AdcSample.Sample(28) = '0') then 
										Accumulated_ltc244xaccumulator.Sample(47 downto 29) <= "0000000000000000000"; 
									--~ else
										--~ Accumulated_ltc244xaccumulator.Sample(47 downto 29) <= "1111111111111111111"; 
									--~ end if;									
									
								--/Debug
															
							end if;
							
						when WriteAccumResult =>
						
							--Single clock state						
							AccumSampleNextState <= WriteCompleteBumpChannel;
							
							--Write to ram (if the ram isn't single-cycle we're in trouble)
							RAM(to_integer(unsigned(Channel))) := ltc244xaccum_to_std_logic(Accumulated_ltc244xaccumulator);
								
						when WriteCompleteBumpChannel =>
						
							--Single clock state
							AccumSampleNextState <= WaitSample;

							--Bump Channel
							Channel <= NextChannel;
							
						when others => -- ought never to get here...reset everything!
						
							InvalidStateReached <= '1';
					
							LastAdcSampleLatched <= '0';			
							LastReadAdcSample <= '0';						
							
							Channel <= "00000";
							NextChannel <= "00000";
							
							Accumulated_ltc244xaccumulator <= ltc244xaccumulator_init;
							Retreived_ltc244xaccumulator <= ltc244xaccumulator_init;			
							ResetAccum <= x"FFFFFFFF";
							
							AccumSampleNextState <= WaitSample;
							AccumSampleCurrentState <= WaitSample;
							
					end case;

				end if;		
				
			end if;		
				
		end if;		

	end process;

end ltc244xaccumulator_i;

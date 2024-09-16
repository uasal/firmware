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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;
use work.ads1258.all;

package ads1258accumulator_pkg is 

	type ads1258accumulator is 
	record

		NumAccums : std_logic_vector(15 downto 0); --63 - 48
		IsNew : std_logic; -- 47
		Clipped : std_logic; -- 46
		Brownout : std_logic; -- 45
		Channel : std_logic_vector(4 downto 0); -- 44 - 40
		Sample : std_logic_vector(39 downto 0); -- 39 - 0

	end record ads1258accumulator;
	
	constant ads1258accumulator_init : 
	ads1258accumulator := 
	(
		NumAccums => (others => '0'),
		IsNew => '0',
		Clipped => '0',
		Brownout => '0',
		Channel => (others => '0'),
		Sample => (others => '0')
	);
	
	function ads1258accum_to_std_logic( arg : ads1258accumulator ) return std_logic_vector;
	function ads1258accum_hi_to_std_logic( arg : ads1258accumulator ) return std_logic_vector;
	function ads1258accum_lo_to_std_logic( arg : ads1258accumulator ) return std_logic_vector;
	function ads1258accum_to_ads1258sample( arg : ads1258accumulator ) return ads1258sample;
	function std_logic_to_ads1258accum( arg : std_logic_vector(63 downto 0) ) return ads1258accumulator;
	function ads1258sample_to_ads1258accum( arg : ads1258sample ) return ads1258accumulator;
	
end package ads1258accumulator_pkg;

package body ads1258accumulator_pkg is

	--~ subtype numaccum_bits is natural range 63 downto 48; --handy construct for another day...
	
	function ads1258accum_to_std_logic( arg : ads1258accumulator ) return std_logic_vector is
		variable result : std_logic_vector(63 downto 0);
	begin
		result(63 downto 48) := arg.NumAccums;
		result(47) := arg.IsNew;
		result(46) := arg.Clipped;
		result(45) := arg.Brownout;
		result(44 downto 40) := arg.Channel;
		result(39 downto 0) := arg.Sample;		
		return result;		
	end function ads1258accum_to_std_logic;
	
	function ads1258accum_hi_to_std_logic( arg : ads1258accumulator ) return std_logic_vector is
		variable result : std_logic_vector(31 downto 0);
	begin
		result(31 downto 16) := arg.NumAccums;
		result(15) := arg.IsNew;
		result(14) := arg.Clipped;
		result(13) := arg.Brownout;
		result(12 downto 8) := arg.Channel;
		result(7 downto 0) := arg.Sample(39 downto 32);		
		return result;		
	end function ads1258accum_hi_to_std_logic;
	
	function ads1258accum_lo_to_std_logic( arg : ads1258accumulator ) return std_logic_vector is
		variable result : std_logic_vector(31 downto 0);
	begin
		result := arg.Sample(31 downto 0);		
		return result;		
	end function ads1258accum_lo_to_std_logic;
	
	function ads1258accum_to_ads1258sample( arg : ads1258accumulator ) return ads1258sample is
		variable result : ads1258sample;
	begin
		result.IsNew := arg.IsNew;
		result.Clipped := arg.Clipped;
		result.Brownout := arg.Brownout;
		result.Channel := arg.Channel;
		result.Sample := arg.Sample(23 downto 0);		
		return result;		
	end function ads1258accum_to_ads1258sample;
	
	function std_logic_to_ads1258accum( arg : std_logic_vector(63 downto 0) ) return ads1258accumulator is
		variable result : ads1258accumulator;
	begin
		result.NumAccums := arg(63 downto 48);
		result.IsNew := arg(47);
		result.Clipped := arg(46);
		result.Brownout := arg(45);
		result.Channel := arg(44 downto 40);
		result.Sample := arg(39 downto 0);
		return result;		
	end function std_logic_to_ads1258accum;
	
	function ads1258sample_to_ads1258accum( arg : ads1258sample ) return ads1258accumulator is
		variable result : ads1258accumulator;
	begin
		result.NumAccums := x"0000";
		result.IsNew := arg.IsNew;
		result.Clipped := arg.Clipped;
		result.Brownout := arg.Brownout;
		result.Channel := arg.Channel;
		result.Sample(39 downto 24) := x"0000";
		result.Sample := arg.Sample;
		return result;		
	end function ads1258sample_to_ads1258accum;
	
end ads1258accumulator_pkg;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;
library UNISIM;
use UNISIM.vcomponents.all;
use ads1258.all;
use ads1258accumulator_pkg.all;

entity ads1258accumulatorPorts is
	port 
	(
		clk : in std_logic;
		rst : in std_logic;
		
		-- From A/D
		AdcSampleIn : in ads1258sample;
		AdcSampleLatched : in std_logic;		
		AdcChannelLatched : out std_logic_vector(4 downto 0);
		
		--~ --Bram A port - accumulation
		--~ WriteRamA : out std_logic;		
		--~ RamAWriteAddress : out std_logic_vector(4 downto 0);
		--~ RamAWriteData : out std_logic_vector(63 downto 0);
		
		--~ --From Bram
		--~ ReadRam : out std_logic;		
		--~ RamReadAddress : out std_logic_vector(4 downto 0);
		--~ RamReadData : in std_logic_vector(63 downto 0);
		--~ ClearRam : out std_logic;		
		
		-- To Datamapper
		AdcChannelReadIndex : in std_logic_vector(4 downto 0);
		ReadAdcSample : in std_logic;		
		AdcSampleToRead : out ads1258accumulator--;
	);
end ads1258accumulatorPorts;

architecture ads1258accumulator_i of ads1258accumulatorPorts is

	--~ --Placeholders for Bram so we can convert to record type(ads1258accumulator)
	signal DOA_lo_i : std_logic_vector(31 downto 0);
	signal DOB_lo_i : std_logic_vector(31 downto 0);
	signal DOA_hi_i : std_logic_vector(31 downto 0);
	signal DOB_hi_i : std_logic_vector(31 downto 0);

	--containers for data in/out of ram
	signal retreived_ads1258accumulator : ads1258accumulator;
	signal accumulated_ads1258accumulator : ads1258accumulator;
	
	--state machine for incoming samples
	type AccumSampleStates is ( WaitSample, ReadOldAccum, Accumulate, WriteResult, Writing, WriteComplete );
	signal AccumSampleNextState : AccumSampleStates;
	signal AccumSampleCurrentState : AccumSampleStates;
	
	--control/state signals:
	signal LastAdcSampleLatched : std_logic;
	signal AdcSampleLatchedEdge : std_logic;
	signal SampleLatched : ads1258sample;
	signal LastReadAdcSample : std_logic;
	signal ReadAdcSampleEdge : std_logic;
	signal AccumDone : std_logic;
	signal ResetAccum : std_logic_vector(31 downto 0);
	
	signal RamEnA : std_logic;
	
begin

	RamEnA <= AdcSampleLatchedEdge or AccumDone;

	--Note: there are address setup times wrt clock & enable that might be problemeatic...
	ads1258accumulators_lo : RAMB16_S36_S36
	generic map 
	(
		WRITE_MODE_A => "READ_FIRST", --  WRITE_FIRST, READ_FIRST or NO_CHANGE
		WRITE_MODE_B => "READ_FIRST", --  WRITE_FIRST, READ_FIRST or NO_CHANGE
		SIM_COLLISION_CHECK => "ALL"--, -- "NONE", "WARNING", "GENERATE_X_ONLY", "ALL" 
		--~ INIT_00 =>  "1010010100100100101001000101001100101010010100111001010110101011", --at least INIT_10 possibilities...
	)
	port map 
	(
		CLKA => clk,
		SSRA => rst,
		--~ ENA => AdcSampleLatchedEdge, --r/o
		ENA => RamEnA, --r/w
		WEA => AccumDone,
		ADDRA(8 downto 5) => "0000",
		ADDRA(4 downto 0) => SampleLatched.Channel,		
		DOA => DOA_lo_i,
		DIA => ads1258accum_lo_to_std_logic(accumulated_ads1258accumulator),
		
		CLKB => clk,
		SSRB => rst,
		ENB => ReadAdcSampleEdge, --since we're read_first, we can read a sample, and clear the accumulator on the same clock cycle.
		WEB => '0',
		ADDRB(8 downto 5) => "0000",
		ADDRB(4 downto 0) => AdcChannelReadIndex,
		DOB => DOB_lo_i,
		DIB => x"00000000", --when we finish a sample, we reset the accumulation, otherwise known as writing all zeroes into it.
		
		 --no parity used:
		DOPA => open,
		DIPA => "0000",
		DOPB => open,
		DIPB => "0000"
	);
	
	ads1258accumulators_hi : RAMB16_S36_S36
	generic map 
	(
		WRITE_MODE_A => "READ_FIRST", --  WRITE_FIRST, READ_FIRST or NO_CHANGE
		WRITE_MODE_B => "READ_FIRST", --  WRITE_FIRST, READ_FIRST or NO_CHANGE
		SIM_COLLISION_CHECK => "ALL"--, -- "NONE", "WARNING", "GENERATE_X_ONLY", "ALL" 
		--~ INIT_00 =>  "1010010100100100101001000101001100101010010100111001010110101011", --at least INIT_10 possibilities...
	)
	port map 
	(
		CLKA => clk,
		SSRA => rst,
		ENA => RamEnA,
		WEA => AccumDone,
		ADDRA(8 downto 5) => "0000",
		ADDRA(4 downto 0) => SampleLatched.Channel,		
		DOA => DOA_hi_i,
		DIA => ads1258accum_hi_to_std_logic(accumulated_ads1258accumulator),
		
		CLKB => clk,
		SSRB => rst,
		ENB => ReadAdcSampleEdge, --since we're read_first, we can read a sample, and clear the accumulator on the same clock cycle.
		WEB => '0',
		ADDRB(8 downto 5) => "0000",
		ADDRB(4 downto 0) => AdcChannelReadIndex,
		DOB => DOB_hi_i,
		DIB => x"00000000", --when we finish a sample, we reset the accumulation, otherwise known as writing all zeroes into it.
		
		 --no parity used:
		DOPA => open,
		DIPA => "0000",
		DOPB => open,
		DIPB => "0000"
	);
	
	retreived_ads1258accumulator <= std_logic_to_ads1258accum(DOA_hi_i & DOA_lo_i);
	AdcSampleToRead <= std_logic_to_ads1258accum(DOB_hi_i & DOB_lo_i); --move to clocked process
	
	--This process grabs samples from the a/d and accumulates them
	process(clk, rst, AdcSampleLatched)
	begin
	
		if (rst = '1') then
		
			accumulated_ads1258accumulator <= ads1258accumulator_init;
			
			AccumSampleNextState <= WaitSample;
			AccumSampleCurrentState <= WaitSample;
	
			LastAdcSampleLatched <= '0';
			AdcSampleLatchedEdge <= '0';
			AccumDone <= '0';
		
		else

			if ( (clk'event) and (clk = '1') ) then
			
				--READ samples from accumulators
				
				--Did the uC want to read a sample?
				if (ReadAdcSample /= LastReadAdcSample) then
				
					LastReadAdcSample <= ReadAdcSample;
				
					if (ReadAdcSample = '1') then
					
						ReadAdcSampleEdge <= '1';
						
					end if;
					
				else
				
					if (ReadAdcSampleEdge = '1') then
					
						ReadAdcSampleEdge <= '0';
						
						--~ AdcSampleToRead <= std_logic_to_ads1258accum(DOB_hi_i & DOB_lo_i);
						
						--NEEDS TO GO IN SOMEHOW ResetAccum(to_integer(unsigned(SampleLatched.Channel))) <= '1';
						
					end if;
					
				end if;			

				--WRITE samples to accumulators
		
				AccumSampleCurrentState <= AccumSampleNextState;
	  
				case AccumSampleCurrentState is
	
					when WaitSample =>
					
						--Starting over or still waiting...disable write to bram
						AccumDone <= '0'; 
					
						--Do we have a new sample from the A/D?
						if (AdcSampleLatched /= LastAdcSampleLatched) then
						
							LastAdcSampleLatched <= AdcSampleLatched;
							
							if (AdcSampleLatched = '1') then
							
								AccumSampleNextState <= ReadOldAccum;	
								
								AdcSampleLatchedEdge <= '1';
								
								SampleLatched <= AdcSampleIn;
									
							end if;
							
						end if;
						
					when ReadOldAccum =>
					
						--~ --done with read
						--~ AdcSampleLatchedEdge <= '0';
						
						AccumSampleNextState <= Accumulate;
					
					when Accumulate =>
					
						--done with read
						AdcSampleLatchedEdge <= '0';
					
						AccumSampleNextState <= WriteResult;
						
						--if ( (SampleLatched.IsNew = '1') and (retreived_ads1258accumulator.NumAccums < x"FFFF") ) then --should we be halting at numaccums too?
						--
						--	if ( ( ResetAccum(to_integer(unsigned(SampleLatched.Channel))) = '1' ) and (ReadAdcSampleEdge = '0') ) then
						--		--NEEDS TO GO IN SOMEHOW ResetAccum(to_integer(unsigned(SampleLatched.Channel))) <= '0';
						--		accumulated_ads1258accumulator.NumAccums <= x"0001"; --Increment NumAccums
						--		accumulated_ads1258accumulator.IsNew <= SampleLatched.IsNew; --Basically, is it empty/initialized or not.
						--		accumulated_ads1258accumulator.Clipped <= SampleLatched.Clipped; --Track clipping (OR it in)
						--		accumulated_ads1258accumulator.Brownout <= SampleLatched.Brownout; --Track brownout (OR it in)
						--		accumulated_ads1258accumulator.Channel <= SampleLatched.Channel; --Basically, is it empty/initialized or not.
						--		accumulated_ads1258accumulator.Sample(23 downto 0) <= SampleLatched.Sample;
						--		accumulated_ads1258accumulator.Sample(23 downto 0) <= x"000000";
						--	else
						--		if (retreived_ads1258accumulator.NumAccums < x"FFFF") then
						--			accumulated_ads1258accumulator.NumAccums <= retreived_ads1258accumulator.NumAccums + x"0001"; --Increment NumAccums
						--			accumulated_ads1258accumulator.Sample <= retreived_ads1258accumulator.Sample + SampleLatched.Sample; --Accumulate
						--		else
						--			accumulated_ads1258accumulator.NumAccums <= x"FFFF";
						--			accumulated_ads1258accumulator.Sample <= retreived_ads1258accumulator.Sample;
						--		end if;
						--		accumulated_ads1258accumulator.IsNew <= SampleLatched.IsNew; --Basically, is it empty/initialized or not.
						--		accumulated_ads1258accumulator.Clipped <= retreived_ads1258accumulator.Clipped or SampleLatched.Clipped; --Track clipping (OR it in)
						--		accumulated_ads1258accumulator.Brownout <= retreived_ads1258accumulator.Brownout or SampleLatched.Brownout; --Track brownout (OR it in)
						--		accumulated_ads1258accumulator.Channel <= SampleLatched.Channel; --Basically, is it empty/initialized or not.
						--		
						--	end if;
							
						--	AdcChannelLatched <= SampleLatched.Channel; --looks fine on scope
						--	SampleLatched.IsNew <= '0';
							
						--end if;
					
					when WriteResult =>
					
						--initiate the write at the bram
						AccumDone <= '1';
						
						AccumSampleNextState <= Writing;
						
					when Writing =>
					
						AccumSampleNextState <= WriteComplete;
						
					when WriteComplete =>
					
						--initiate the write at the bram
						AccumDone <= '0'; 
						
						AccumSampleNextState <= WaitSample;
				
					when others => -- ought never to get here...
				
						AccumSampleNextState <= WaitSample;
						
						AdcSampleLatchedEdge <= '0';
						AccumDone <= '0';
						
				end case;

			end if;		
			
		end if;		

	end process;

end ads1258accumulator_i;

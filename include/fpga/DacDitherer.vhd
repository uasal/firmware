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
-- Ltc(REGISTER_IN_BITS - 1)78Accum-20 A/D handler
--
-- c2013 Franks Development, LLC
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use IEEE.NUMERIC_STD_UNSIGNED.ALL;

--Considering this as a REGISTER_IN_BITS-bit output A/D for rough compatibility with AD7760, we have 8 bits left for PPS timestamp.
--100MHz / 256 (8b) < 400k == 2^19 * 0.75, so we have 13b left for seconds of day, which would repeat every 2.5 hours.
--And we're writing the actual seconds into the datafile headers, so we'll have to tweak it up in the C code. 100MHz = 27 bits.

entity DacDitherer is
	generic (
		REGISTER_IN_BITS : natural := 24;
		REGISTER_OUT_BITS : natural := 24;
		DATA_BITS : natural := 20;
		DITHER_BITS : natural := 4--;
	);
	port (
	
		--Globals
		clk : in std_logic;
		rst : in std_logic;
		
		-- D/A:
		DitherClkDiv : in std_logic_vector(15 downto 0);
		DacTrigger : out std_logic;
		DacXferComplete : in std_logic; --we really shouldn't be updating values when this is low...
		
		SetPointIn : in std_logic_vector((REGISTER_IN_BITS - 1) downto 0);
		DacMagnitudeOut : out std_logic_vector((REGISTER_OUT_BITS - 1) downto 0)--;

	); end DacDitherer;

architecture DacDithererLogic of DacDitherer is
	
	component ClockDividerPorts is
	generic (
		CLOCK_DIVIDER : natural := 10;
		DIVOUT_RST_STATE : std_logic := '0'--;
	);
	port (
	
		clk : in std_logic;
		rst : in std_logic;
		div : out std_logic
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
	
	
	constant MaxVal : std_logic_vector((REGISTER_IN_BITS - 1) downto (REGISTER_IN_BITS - DATA_BITS)) := (others => '1');
	
	signal DitherClock : std_logic;
	signal LastDitherClock : std_logic;
	
	signal DitherPos : natural range 0 to ((2**DITHER_BITS) - 1);
	
	signal DacMagnitudeOut_i : std_logic_vector((REGISTER_OUT_BITS - 1) downto 0);
	
begin

	--~ DitherClk : ClockDividerPorts
	--~ generic map
	--~ (
		--~ CLOCK_DIVIDER => DITHER_CLOCK_DIV,
		--~ DIVOUT_RST_STATE => '0'--;
	--~ )
	--~ port map
	--~ (
		--~ clk => clk,
		--~ rst => rst,
		--~ div => DitherClock
	--~ );	
	DitherClk : VariableClockDividerPorts
	generic map
	(
		WIDTH_BITS => 16,
		DIVOUT_RST_STATE => '0'--;
	)
	port map
	(
		clki => clk,
		rst => rst,
		rst_count => x"0000",
		terminal_count => DitherClkDiv,
		clko => DitherClock
	);
	
	--~ DacTrigger <= not(DitherClock) when (DacXferComplete = '1') else '0'; --give us time to move things on rising edge so we don't have race conditions
	DacTrigger <= not(DitherClock); --give us time to move things on rising edge so we don't have race conditions
	
	DacMagnitudeOut <= DacMagnitudeOut_i;
	
	--Read A/D:
	process (clk, rst)
	begin
	
		if (rst = '1') then --We're using AdcClkReset instead of the external rst signal here so that sync will reset SamplesAveraged so our sample is aligned to sync when we are downsampling...
		
			DitherPos <= 0;			
			LastDitherClock <= '0';
			DacMagnitudeOut_i <= std_logic_vector(to_unsigned(0, REGISTER_OUT_BITS));
			
		else
			
			if ( (clk'event) and (clk = '1') ) then
			
				if (DitherClock /= LastDitherClock) then
		
					LastDitherClock <= DitherClock;
					
					if (DitherClock = '1') then
					
						if (DitherPos < ((2**DITHER_BITS) - 1)) then DitherPos <= DitherPos + 1; else DitherPos <= 0; end if;
						
						if ( ((SetPointIn((REGISTER_IN_BITS - 1) - DATA_BITS downto (REGISTER_IN_BITS - DATA_BITS) - DITHER_BITS)) > std_logic_vector(to_unsigned(DitherPos, DITHER_BITS))) and (SetPointIn((REGISTER_IN_BITS - 1) downto (REGISTER_IN_BITS - DATA_BITS)) < MaxVal) ) then
						
							DacMagnitudeOut_i((REGISTER_OUT_BITS - 1) downto REGISTER_OUT_BITS - DATA_BITS) <= SetPointIn((REGISTER_IN_BITS - 1) downto REGISTER_IN_BITS - DATA_BITS) + std_logic_vector(to_unsigned(1, DATA_BITS));
							DacMagnitudeOut_i((REGISTER_OUT_BITS - 1) - DATA_BITS downto 0) <= (others => '0');
							
						else
					
							DacMagnitudeOut_i((REGISTER_OUT_BITS - 1) downto REGISTER_OUT_BITS - DATA_BITS) <= SetPointIn((REGISTER_IN_BITS - 1) downto REGISTER_IN_BITS - DATA_BITS);
							DacMagnitudeOut_i((REGISTER_OUT_BITS - 1) - DATA_BITS downto 0) <= (others => '0');
							
						end if;
						
					end if;
					
				end if;
				
			end if;
					
		end if;	
		
	end process;

end DacDithererLogic;

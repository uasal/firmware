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
--~ A uint32 state variable can be updated by the simple algorithm (with invert meaning bitwise_not):

--~ state = invert(state)
--~ for each input byte x {
    --~ state = table[x ^ (state & 0xFF)] ^ (state >> 8)
--~ }
--~ state = invert(state)
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity CrcFifo is
	generic (
			DEPTH_BITS : natural := 10--;
	);
	port (
	
		--Globals
		clk : in std_logic;
		rst : in std_logic;
		
		FifoStartAddr : in unsigned(DEPTH_BITS - 1 downto 0);
		FifoEndAddr : in unsigned(DEPTH_BITS - 1 downto 0);
		FifoPeekAddr : out unsigned(DEPTH_BITS - 1 downto 0);
		FifoPeekData : in std_logic_vector(7 downto 0);
		
		Crc : out std_logic_vector(31 downto 0);
		CrcComplete : out std_logic--;
		
	); end CrcFifo;

architecture implementation of CrcFifo is

	component CrcStream is
	port (
	
		--Globals
		clk : in std_logic;
		rst : in std_logic;
		
		data : in std_logic_vector(7 downto 0);
		crc : out std_logic_vector(31 downto 0)
	
	); end component;

	--~ signal CrcIn : std_logic_vector(31 downto 0);
	signal CrcOut : std_logic_vector(31 downto 0);
	
	signal FifoPeekAddr_i : std_logic_vector(DEPTH_BITS - 1 downto 0);
	
begin

	crcer : CrcStream
	port map
	(
		clk => clk,
		rst => rst,
		data => FifoPeekData,
		crc => CrcOut--,
	);
	
	FifoPeekAddr <= FifoPeekAddr_i;
			
	process (clk, rst)
	begin
	
		if (rst = '1') then 
		
			CrcComplete <= '0';
			FifoPeekAddr_i <= FifoStartAddr;
					
		else
			
			if ( (clk'event) and (clk = '1') ) then

				if (FifoPeekAddr_i /= std_logic_vector(FifoEndAddr)) then
				
					CrcComplete <= '0';
					FifoPeekAddr_i <= FifoPeekAddr_i + std_logic_vector(to_unsigned(1, DEPTH_BITS));
					
				else
	
					Crc <= CrcOut;
					CrcComplete <= '1';

				end if;
			
			end if;	
			
		end if;	
		
	end process;
	
end implementation;

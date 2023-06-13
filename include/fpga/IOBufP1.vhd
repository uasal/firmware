--------------------------------------------------------------------------------
-- MountainOps DNT GPS Board PC/104 Firmware
--
-- $Revision: 1.4 $
-- $Date: 2009/08/11 00:16:45 $
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity IOBufP2Ports is
	port (
			clk : in std_logic;
			IO  : inout std_logic;
			T : in std_logic;
			I : in std_logic;
			O : out std_logic--;
	);
end IOBufP2Ports;

architecture IOBufP2 of IOBufP2Ports is

	signal Temp1 : std_logic;
	
begin

	IO <= I when (T = '1') else 'Z';
	
	process (clk)
	begin
	
		if ( (clk'event) and (clk = '1') ) then
		
			O <= IO; --second pipeline stage - O signal

		end if;

	end process; --(clock)

end IOBufP2;

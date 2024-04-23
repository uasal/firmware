--------------------------------------------------------------------------------
-- MountainOps DNT GPS Board PC/104 Firmware
--
-- $Revision: 1.3 $
-- $Date: 2009/07/28 16:50:53 $
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity IBufP2Ports is
	port (
			clk : in std_logic;
			I : in std_logic;
			O : out std_logic--;
	);
end IBufP2Ports;

architecture IBufP2 of IBufP2Ports is

	signal Temp1 : std_logic;
	
begin
	
	-- Master clock drives most logic
	process (clk)
	begin
		if ( (clk'event) and (clk = '1') ) then
		
			Temp1 <= I; --first pipeline stage - temp1 signal
			O <= Temp1; --second pipeline stage - O signal

		end if;

	end process; --(clock)

end IBufP2;

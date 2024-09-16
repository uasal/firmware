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
	signal Temp2 : std_logic;
	
begin

	IO <= I when (T = '1') else 'Z';
	
	Temp1 <= IO;
	
	process (clk)
	begin
	
		if ( (clk'event) and (clk = '1') ) then
		
			Temp2 <= Temp1; --first pipeline stage - temp2 signal
			O <= Temp2; --second pipeline stage - O signal

		end if;

	end process; --(clock)

end IOBufP2;

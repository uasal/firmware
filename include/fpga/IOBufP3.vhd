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
library UNISIM;
use UNISIM.vcomponents.all;

entity IOBufP3Ports is
	port (
			clk : in std_logic;
			IO  : inout std_logic;
			T : in std_logic;
			I : in std_logic;
			O : out std_logic--;
	);
end IOBufP3Ports;

architecture IOBufP3 of IOBufP3Ports is

	signal Temp1 : std_logic;
	signal Temp2 : std_logic;
	signal Temp3 : std_logic;
	
begin

	IOBUF_i : IOBUF
	port map (
		O => Temp1,
		IO => IO,
		I => I,
		T => T
	);

	process (clk)
	begin
	
		if ( (clk'event) and (clk = '1') ) then
		
			Temp2 <= Temp1; --first pipeline stage - temp2 signal
			Temp3 <= Temp2; --second pipeline stage - temp3 signal
			O <= Temp3; --third pipeline stage - O signal

		end if;

	end process; --(clock)

end IOBufP3;

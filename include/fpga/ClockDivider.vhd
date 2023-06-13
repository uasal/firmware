--------------------------------------------------------------------------------
-- MountainOps DNT GPS Board PC/104 Firmware
--
-- $Revision: 1.4 $
-- $Date: 2009/08/29 00:25:36 $
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity ClockDividerPorts is
	generic (
		CLOCK_DIVIDER : natural := 10;
		DIVOUT_RST_STATE : std_logic := '0'--;
	);
	port (
	
		clk : in std_logic;
		rst : in std_logic;
		div : out std_logic
	);
end ClockDividerPorts;

architecture ClockDivider of ClockDividerPorts is

	signal ClkDiv : natural range 0 to ((CLOCK_DIVIDER / 2) - 1) := 0;
	signal div_i : std_logic;	

begin

	div <= div_i;
	
	process (clk, rst)
	begin
	
		if (rst = '1') then
		
			ClkDiv <= 0;
			div_i <= DIVOUT_RST_STATE;
			
		else
			
			if ( (clk'event) and (clk = '1') ) then
			
				--Generate the master DE-sampling clock
				if (ClkDiv < ((CLOCK_DIVIDER / 2) - 1)) then --/2 because we're only one one edge of master clock, not both, -1 because we count 0 too...
						
						ClkDiv <= ClkDiv + 1;
						
					else
					
						div_i <= not(div_i);
						
						ClkDiv <= 0;

				end if;
				
			end if;
			
		end if;

	end process;

end ClockDivider;

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

entity VariableClockDividerPorts is
	generic (
		WIDTH_BITS : natural := 8;
		DIVOUT_RST_STATE : std_logic := '0'--;
	);
	port (
	
		clki : in std_logic;
		rst : in std_logic;
		rst_count : in std_logic_vector(WIDTH_BITS - 1 downto 0); --typically zero; if >= terminal_count, it will flip on the first clock after reset!
		terminal_count : in std_logic_vector(WIDTH_BITS - 1 downto 0); --a t/c of zero results in clko = clki / 2
		clko : out std_logic
	);
end VariableClockDividerPorts;

architecture VariableClockDivider of VariableClockDividerPorts is

	signal ClkDiv : natural range 0 to ((2**WIDTH_BITS) - 1) := 0;
	signal clko_i : std_logic;	

begin

	clko <= clko_i;
	
	process (clki, rst, rst_count)
	begin
	
		if (rst = '1') then
		
			ClkDiv <= to_integer(unsigned(rst_count));
			clko_i <= DIVOUT_RST_STATE;
			
		else
			
			if ( (clki'event) and (clki = '1') ) then
			
				--Generate the master DE-sampling clock
				if (ClkDiv < terminal_count) then
						
						ClkDiv <= ClkDiv + 1;
						
					else
					
						ClkDiv <= 0;

				end if;
				
				if (ClkDiv < ( (shift_right(unsigned(terminal_count),1)) - 1)) then
						
						clko_i <= DIVOUT_RST_STATE;
						
					else
					
						clko_i <= not(DIVOUT_RST_STATE);

				end if;
				
			end if;
			
		end if;

	end process;

end VariableClockDivider;

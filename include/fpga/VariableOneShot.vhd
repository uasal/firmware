--------------------------------------------------------------------------------
-- MountainOps DNT GPS Board PC/104 Firmware
--
-- $Revision: 1.2 $
-- $Date: 2010/04/30 01:08:12 $
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity VariableOneShotPorts is
	generic (
		WIDTH_BITS : natural := 8;
		SHOT_RST_STATE : std_logic := '0';
		SHOT_PRETRIGGER_STATE : std_logic := '0'--;
	);
	port (	
		clk : in std_logic;
		rst : in std_logic;
		delay_clks : in std_logic_vector(WIDTH_BITS - 1 downto 0);
		shot : out std_logic
	);
end VariableOneShotPorts;

architecture VariableOneShot of VariableOneShotPorts is

	signal ClkDiv : natural range 0 to (((2**WIDTH_BITS) / 2) - 1) := 0;
	signal shot_i : std_logic := SHOT_RST_STATE;	

begin

	shot <= shot_i;
	
	process (clk, rst)
	begin
	
		if (rst = '1') then
		
			ClkDiv <= 0;
			shot_i <= SHOT_RST_STATE;
			
		else
			
			if ( (clk'event) and (clk = '1') ) then
			
				--Generate the master DE-sampling clock
				if (ClkDiv < delay_clks) then --/2 because we're only one one edge of master clock, not both, -1 because we count 0 too...
						
					ClkDiv <= ClkDiv + 1;
					
					shot_i <= SHOT_PRETRIGGER_STATE;
					
				else
				
					shot_i <= not(SHOT_PRETRIGGER_STATE);
						
				end if;
				
			end if;
			
		end if;

	end process;

end VariableOneShot;

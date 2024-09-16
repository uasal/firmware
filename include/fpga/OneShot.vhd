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

entity OneShotPorts is
	generic (
		CLOCK_FREQHZ : natural := 10000000;
		DELAY_SECONDS : real := 0.001;
		SHOT_RST_STATE : std_logic := '0';
		SHOT_PRETRIGGER_STATE : std_logic := '0'--;
	);
	port (	
		clk : in std_logic;
		rst : in std_logic;
		shot : out std_logic
	);
end OneShotPorts;

architecture OneShot of OneShotPorts is

	--~ constant CLOCK_DIVIDER : natural := ((natural(real(CLOCK_FREQHZ) * DELAY_SECONDS)) / 2) - 1;
	constant CLOCK_DIVIDER : natural := ((natural(real(CLOCK_FREQHZ) * DELAY_SECONDS)) / 1) - 1;
	signal ClkDiv : natural range 0 to CLOCK_DIVIDER := 0;
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
				if (ClkDiv < CLOCK_DIVIDER) then --/2 because we're only one one edge of master clock, not both, -1 because we count 0 too...
						
					ClkDiv <= ClkDiv + 1;
					
					shot_i <= SHOT_PRETRIGGER_STATE;
					
				else
				
					shot_i <= not(SHOT_PRETRIGGER_STATE);
						
				end if;
				
			end if;
			
		end if;

	end process;

end OneShot;

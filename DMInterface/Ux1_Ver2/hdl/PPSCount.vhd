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

entity PPSCountPorts is
	generic (
			PPS_ACCUM_CYCLES : natural := 1--;
	);
    port (
			clk : in std_logic;
			
			PPS : in std_logic;
			
			PPSReset : in std_logic;
			
			PPSDetected : out std_logic;
			
			PPSCounter : out std_logic_vector(31 downto 0);
			
			PPSAccum : out std_logic_vector(31 downto 0)--;
	);
end PPSCountPorts;

architecture PPSCount of PPSCountPorts is

	signal LastPPS : std_logic;
	signal InvalidatePPSCount : std_logic := '0';
	signal PPSAccum_i : std_logic_vector(31 downto 0);
	signal PPSAccumCycles : natural range 0 to PPS_ACCUM_CYCLES := 0;
	
begin

	PPSCounter <= PPSAccum_i;

	-- Master clock drives most logic
	process (PPSReset, clk, PPS)
	begin

		--async reset
		if (PPSReset = '1') then
		
			--Reset cycle count
			PPSAccumCycles <= 0;
			
			PPSDetected <= '0';
			
			--Reset latch
			PPSAccum <= x"00000000";
			
			--Invalidate next accum cycle, so we don't get a good looking count that's missing some small part of the second and throws off filters...
			InvalidatePPSCount <= '1';
					
		else
		
			if ( (clk'event) and (clk = '1') ) then

				--rising edge of pps  - run pps cycle counter
				if (PPS /= LastPPS) then 
				
					LastPPS <= PPS;
					
					PPSDetected <= '1';
					
					if (PPS = '1') then
					
						--Move on to next PPS cycle
						--~ PPSAccumCycles <= PPSAccumCycles + 1;
									
						--have we reached the end of our accumulation?
						--~ if (PPSAccumCycles >= PPS_ACCUM_CYCLES - 1) then
						
							--Reset cycle count
							--~ PPSAccumCycles <= 0;
						
							--Reset accumulator
							PPSAccum_i <= x"00000000"; 
							
							if (InvalidatePPSCount = '1') then
							
								InvalidatePPSCount <= '0';
								
								PPSAccum <= x"00000000";
								
							else
								
								PPSAccum <= PPSAccum_i + x"00000002"; --latch output - since each edge of PPS takes 1 clock, the actual count is two more than the accumulator has in it
								
							end if;
							
						--~ end if;				
						
					end if;
					
				--keep accumulating
				else
				
					PPSAccum_i <= PPSAccum_i + x"00000001";
					
				end if;
				
			end if;
			
		end if;

	end process; --(clock)

end PPSCount;

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

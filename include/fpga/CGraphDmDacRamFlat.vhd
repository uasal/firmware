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
use work.CGraphDMTypes.all;
library work;

entity DmDacRamFlatPorts is
  port (
    clk : in std_logic;
    rst : in std_logic;
		
    -- Bus:
    ReadAddress : in integer range (DMMaxActuators - 1) downto 0;
	WriteAddress : in integer range (DMMaxActuators - 1) downto 0;
    DacSetpointIn : in std_logic_vector(DMSetpointMSB downto 0);
    DacSetpointOut : out std_logic_vector(DMSetpointMSB downto 0);
    WriteReq : in std_logic--;
  );
end DmDacRamFlatPorts;


architecture DmDacRamFlat of DmDacRamFlatPorts is

	shared variable DacSetpoints : DMDacSetpointRamFlat;

  begin
  
	--~ DacSetpointOut <= DacSetpoints(ReadAddress); --for asynchronous read
	
  process (clk, rst)
  begin
    if (rst = '1') then
      
		DacSetpointOut <= x"000000"; --for synchronous read			
      
    else
      if ( (clk'event) and (clk = '1') ) then

		DacSetpointOut <= DacSetpoints(ReadAddress); --for synchronous read
		
		if (WriteReq = '1') then
		
			DacSetpoints(WriteAddress) := DacSetpointIn;
		
		end if;
		
	  end if;
	  
    end if;
  end process;

end DmDacRamFlat;


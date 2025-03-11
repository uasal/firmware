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

entity DmDacRamPorts is
  port (
    clk : in std_logic;
    rst : in std_logic;
		
    -- Bus:
    ReadAddressController : in integer range (DMMaxControllerBoards - 1) downto 0;
    ReadAddressDac : in integer range (DMMDacsPerControllerBoard - 1) downto 0;
    ReadAddressChannel : in integer range (DMActuatorsPerDac - 1) downto 0;
	WriteAddress : in integer range (DMMaxActuators - 1) downto 0;
    DacSetpointIn : in std_logic_vector(DMSetpointMSB downto 0);
    DacSetpointOut : out std_logic_vector(DMSetpointMSB downto 0);
    WriteReq : in std_logic--;
  );
end DmDacRamPorts;


architecture DmDacRam of DmDacRamPorts is

	signal WriteAddressController : integer range (DMMaxControllerBoards - 1) downto 0;
	signal WriteAddressDac : integer range (DMMDacsPerControllerBoard - 1) downto 0;
	signal WriteAddressChannel : integer range (DMActuatorsPerDac - 1) downto 0;

	shared variable DacSetpoints : DMDacSetpointRam;

  begin
  
	DacSetpointOut <= DacSetpoints(ReadAddressController, ReadAddressDac, ReadAddressChannel); --for asynchronous read
	
	-- <where '%' is mod operator>
	-- n = (z * numy * numx) + (y * numx) + x
	-- z = n / (numy * numx)
	-- y = (n / numx) % numy
	-- x = n % numx
	
	WriteAddressController <= WriteAddress / (DMActuatorsPerDac * DMMDacsPerControllerBoard);
	WriteAddressDac <= (WriteAddress / DMActuatorsPerDac) mod DMMDacsPerControllerBoard;
	WriteAddressChannel <= WriteAddress mod DMActuatorsPerDac;

  process (clk, rst)
  begin
    if (rst = '1') then
      
		--~ DataOut <= x"000"; for synchronous read			
      
    else
      if ( (clk'event) and (clk = '1') ) then

		--~ DataOut <= DacSetpoints(ReadAddressController, ReadAddressDac, ReadAddressChannel); --for synchronous read
		
		if (WriteReq = '1') then
		
			DacSetpoints(WriteAddressController, WriteAddressDac, WriteAddressChannel) := DacSetpointIn;
		
		end if;
		
	  end if;
	  
    end if;
  end process;

end DmDacRam;


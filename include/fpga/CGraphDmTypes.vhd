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
library work;

package CGraphDMTypes is 

	constant DMSetpointMSB : integer := 23;
	constant DMMaxControllerBoards : integer := 6;
	constant DMMDacsPerControllerBoard : integer := 4;
	constant DMActuatorsPerDac : integer := 40;
	constant DMMaxActuators : integer := DMActuatorsPerDac * DMMDacsPerControllerBoard * DMMaxControllerBoards;

	type DMDacSetpointRam is array(0 to DMMaxControllerBoards - 1, 0 to DMMDacsPerControllerBoard - 1, 0 to DMActuatorsPerDac) of std_logic_vector(DMSetpointMSB downto 0);
	type DMDacSetpointRamFlat is array(0 to DMMaxActuators - 1) of std_logic_vector(DMSetpointMSB downto 0);
	
	--~ type DMDacSetpointChannel is array(0 to DMMaxControllerBoards - 1, 0 to DMMDacsPerControllerBoard - 1) of std_logic_vector(5 downto 0);
	type DMDacSetpointRegisters is array(0 to DMMaxControllerBoards - 1, 0 to DMMDacsPerControllerBoard - 1) of std_logic_vector(DMSetpointMSB downto 0);

	type DMProtoDacSetpointRegisters is array(0 to DMMaxControllerBoards - 1) of std_logic_vector(DMSetpointMSB downto 0);
	
	--~ entity ram_singleport_noreg is
	--~ port (
		--~ d : in std_logic_vector(7 downto 0);
		--~ a : in std_logic_vector(6 downto 0);
		--~ we : in std_logic;
		--~ clk : in std_logic;
		--~ q : out std_logic_vector(7 downto 0) 
	--~ );
	--~ end ram_singleport_noreg;

end package CGraphDMTypes;

package body CGraphDMTypes is

	--~ architecture rtl of ram_singleport_noreg is
		
		--~ type mem_type is array (127 downto 0) of std_logic_vector (7 downto 0);
		
		--~ signal mem: mem_type;
		
		--~ begin
			
			--~ q <= mem(conv_integer (a));
	
		--~ process (clk)
		--~ begin
			--~ if rising_edge(clk) then
			--~ if (we = '1') then
			--~ mem(conv_integer (a)) <= d;
			--~ end if;
			--~ end if;
		--~ end process;
			
	--~ end rtl;

end CGraphDMTypes;
--------------------------------------------------------------------------------
-- UA Extra-Solar Camera PZT Controller Project FPGA Firmware
--
-- Build Number Definition
--
-- !Warning: this file is electronically generated/updated; do not edit!!
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity BuildNumberPorts is
	port 
	(
		BuildNumber : out std_logic_vector(31 downto 0)--;
	);
end BuildNumberPorts;

architecture BuildNumber of BuildNumberPorts is

	constant BuildNum : std_logic_vector(31 downto 0) := x"0000001A"; -- (26 decimal)
	constant BuildTime : std_logic_vector(31 downto 0) := x"62EAB2ED"; -- (seconds since 01/01/1970 -> Wed Aug  3 17:39:57 2022)

begin

	BuildNumber <= BuildNum;
	
end BuildNumber;


































































































































































































































































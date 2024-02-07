--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Main.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::SmartFusion2> <Die::M2S025> <Package::256 VF>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity Main is
port (
    --<port_name> : <direction> <type>;
    clk : in  std_logic; -- example
	debug0 : in  std_logic; -- example
    debug : out std_logic_vector(7 downto 1)  -- example
    --<other_ports>
);
end Main;
architecture architecture_Main of Main is
   -- signal, component etc. declarations
	--signal signal_name1 : std_logic; -- example
	--signal signal_name2 : std_logic; -- example

begin

   -- architecture body
   debug(1) <= debug0;
   debug(6 downto 2) <= "10101";
   debug(7) <= clk;
   
end architecture_Main;

--
-- Synopsys
-- Vhdl wrapper for top level design, written on Wed Jan 31 10:57:28 2024
--
library ieee;
use ieee.std_logic_1164.all;

entity wrapper_for_Blink is
   port (
      port_name1 : in std_logic;
      port_name2 : out std_logic
   );
end wrapper_for_Blink;

architecture rtl of wrapper_for_Blink is

component Blink
 port (
   port_name1 : in std_logic;
   port_name2 : out std_logic
 );
end component;

signal tmp_port_name1 : std_logic;
signal tmp_port_name2 : std_logic;

begin

tmp_port_name1 <= port_name1;

port_name2 <= tmp_port_name2;



u1:   Blink port map (
		port_name1 => tmp_port_name1,
		port_name2 => tmp_port_name2
       );
end rtl;

--
-- Synopsys
-- Vhdl wrapper for top level design, written on Thu Feb  8 14:21:37 2024
--
library ieee;
use ieee.std_logic_1164.all;

entity wrapper_for_Blink is
   port (
      clk : in std_logic;
      debug1 : in std_logic;
      debug : out std_logic_vector(8 downto 2)
   );
end wrapper_for_Blink;

architecture rtl of wrapper_for_Blink is

component Blink
 port (
   clk : in std_logic;
   debug1 : in std_logic;
   debug : out std_logic_vector (8 downto 2)
 );
end component;

signal tmp_clk : std_logic;
signal tmp_debug1 : std_logic;
signal tmp_debug : std_logic_vector (8 downto 2);

begin

tmp_clk <= clk;

tmp_debug1 <= debug1;

debug <= tmp_debug;



u1:   Blink port map (
		clk => tmp_clk,
		debug1 => tmp_debug1,
		debug => tmp_debug
       );
end rtl;

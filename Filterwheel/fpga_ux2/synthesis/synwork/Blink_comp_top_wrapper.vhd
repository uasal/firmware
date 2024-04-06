--
-- Synopsys
-- Vhdl wrapper for top level design, written on Fri Feb 16 14:21:11 2024
--
library ieee;
use ieee.std_logic_1164.all;

entity wrapper_for_Blink is
   port (
      clk : in std_logic;
      debugA1 : in std_logic;
      debugA : out std_logic_vector(8 downto 2)
   );
end wrapper_for_Blink;

architecture rtl of wrapper_for_Blink is

component Blink
 port (
   clk : in std_logic;
   debugA1 : in std_logic;
   debugA : out std_logic_vector (8 downto 2)
 );
end component;

signal tmp_clk : std_logic;
signal tmp_debugA1 : std_logic;
signal tmp_debugA : std_logic_vector (8 downto 2);

begin

tmp_clk <= clk;

tmp_debugA1 <= debugA1;

debugA <= tmp_debugA;



u1:   Blink port map (
		clk => tmp_clk,
		debugA1 => tmp_debugA1,
		debugA => tmp_debugA
       );
end rtl;

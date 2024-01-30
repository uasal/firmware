--
-- Synopsys
-- Vhdl wrapper for top level design, written on Mon Jan 29 12:07:52 2024
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity wrapper_for_homebrew_spimastertrioports_spimastertrio_1000_1_'0'_'0'_1_CLOCK_DIVIDERBYTE_WIDTH is
   port (
      clk : in std_logic;
      rst : in std_logic;
      MosiA : out std_logic;
      MosiB : out std_logic;
      MosiC : out std_logic;
      Sck : out std_logic;
      MisoA : in std_logic;
      MisoB : in std_logic;
      MisoC : in std_logic;
      nCsA : out std_logic;
      nCsB : out std_logic;
      nCsC : out std_logic;
      DataToMosiA : in std_logic_vector(7 downto 0);
      DataToMosiB : in std_logic_vector(7 downto 0);
      DataToMosiC : in std_logic_vector(7 downto 0);
      DataFromMisoA : out std_logic_vector(7 downto 0);
      DataFromMisoB : out std_logic_vector(7 downto 0);
      DataFromMisoC : out std_logic_vector(7 downto 0);
      XferComplete : out std_logic
   );
end wrapper_for_homebrew_spimastertrioports_spimastertrio_1000_1_'0'_'0'_1_CLOCK_DIVIDERBYTE_WIDTH;

architecture spimastertrio of wrapper_for_homebrew_spimastertrioports_spimastertrio_1000_1_'0'_'0'_1_CLOCK_DIVIDERBYTE_WIDTH is

component homebrew_spimastertrioports_spimastertrio_1000_1_'0'_'0'_1_CLOCK_DIVIDERBYTE_WIDTH
 port (
   clk : in std_logic;
   rst : in std_logic;
   MosiA : out std_logic;
   MosiB : out std_logic;
   MosiC : out std_logic;
   Sck : out std_logic;
   MisoA : in std_logic;
   MisoB : in std_logic;
   MisoC : in std_logic;
   nCsA : out std_logic;
   nCsB : out std_logic;
   nCsC : out std_logic;
   DataToMosiA : in std_logic_vector (7 downto 0);
   DataToMosiB : in std_logic_vector (7 downto 0);
   DataToMosiC : in std_logic_vector (7 downto 0);
   DataFromMisoA : out std_logic_vector (7 downto 0);
   DataFromMisoB : out std_logic_vector (7 downto 0);
   DataFromMisoC : out std_logic_vector (7 downto 0);
   XferComplete : out std_logic
 );
end component;

signal tmp_clk : std_logic;
signal tmp_rst : std_logic;
signal tmp_MosiA : std_logic;
signal tmp_MosiB : std_logic;
signal tmp_MosiC : std_logic;
signal tmp_Sck : std_logic;
signal tmp_MisoA : std_logic;
signal tmp_MisoB : std_logic;
signal tmp_MisoC : std_logic;
signal tmp_nCsA : std_logic;
signal tmp_nCsB : std_logic;
signal tmp_nCsC : std_logic;
signal tmp_DataToMosiA : std_logic_vector (7 downto 0);
signal tmp_DataToMosiB : std_logic_vector (7 downto 0);
signal tmp_DataToMosiC : std_logic_vector (7 downto 0);
signal tmp_DataFromMisoA : std_logic_vector (7 downto 0);
signal tmp_DataFromMisoB : std_logic_vector (7 downto 0);
signal tmp_DataFromMisoC : std_logic_vector (7 downto 0);
signal tmp_XferComplete : std_logic;

begin

tmp_clk <= clk;

tmp_rst <= rst;

MosiA <= tmp_MosiA;

MosiB <= tmp_MosiB;

MosiC <= tmp_MosiC;

Sck <= tmp_Sck;

tmp_MisoA <= MisoA;

tmp_MisoB <= MisoB;

tmp_MisoC <= MisoC;

nCsA <= tmp_nCsA;

nCsB <= tmp_nCsB;

nCsC <= tmp_nCsC;

tmp_DataToMosiA <= DataToMosiA;

tmp_DataToMosiB <= DataToMosiB;

tmp_DataToMosiC <= DataToMosiC;

DataFromMisoA <= tmp_DataFromMisoA;

DataFromMisoB <= tmp_DataFromMisoB;

DataFromMisoC <= tmp_DataFromMisoC;

XferComplete <= tmp_XferComplete;



u1:   homebrew_spimastertrioports_spimastertrio_1000_1_'0'_'0'_1_CLOCK_DIVIDERBYTE_WIDTH port map (
		clk => tmp_clk,
		rst => tmp_rst,
		MosiA => tmp_MosiA,
		MosiB => tmp_MosiB,
		MosiC => tmp_MosiC,
		Sck => tmp_Sck,
		MisoA => tmp_MisoA,
		MisoB => tmp_MisoB,
		MisoC => tmp_MisoC,
		nCsA => tmp_nCsA,
		nCsB => tmp_nCsB,
		nCsC => tmp_nCsC,
		DataToMosiA => tmp_DataToMosiA,
		DataToMosiB => tmp_DataToMosiB,
		DataToMosiC => tmp_DataToMosiC,
		DataFromMisoA => tmp_DataFromMisoA,
		DataFromMisoB => tmp_DataFromMisoB,
		DataFromMisoC => tmp_DataFromMisoC,
		XferComplete => tmp_XferComplete
       );
end spimastertrio;

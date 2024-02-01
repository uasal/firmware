--
-- Synopsys
-- Vhdl wrapper for top level design, written on Wed Jan 31 16:41:37 2024
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity wrapper_for_work_spimastersextetports_spimastersextet_1000_1_'0'_'0'_1_CLOCK_DIVIDERBYTE_WIDTH is
   port (
      clk : in std_logic;
      rst : in std_logic;
      MosiA : out std_logic;
      MosiB : out std_logic;
      MosiC : out std_logic;
      MosiD : out std_logic;
      MosiE : out std_logic;
      MosiF : out std_logic;
      SckA : out std_logic;
      SckB : out std_logic;
      SckC : out std_logic;
      SckD : out std_logic;
      SckE : out std_logic;
      SckF : out std_logic;
      MisoA : in std_logic;
      MisoB : in std_logic;
      MisoC : in std_logic;
      MisoD : in std_logic;
      MisoE : in std_logic;
      MisoF : in std_logic;
      nCsA : out std_logic_vector(3 downto 0);
      nCsB : out std_logic_vector(3 downto 0);
      nCsC : out std_logic_vector(3 downto 0);
      nCsD : out std_logic_vector(3 downto 0);
      nCsE : out std_logic_vector(3 downto 0);
      nCsF : out std_logic_vector(3 downto 0);
      MosiDataWrite : in std_logic;
      DataToMosiA : in std_logic_vector(7 downto 0);
      DataToMosiB : in std_logic_vector(7 downto 0);
      DataToMosiC : in std_logic_vector(7 downto 0);
      DataToMosiD : in std_logic_vector(7 downto 0);
      DataToMosiE : in std_logic_vector(7 downto 0);
      DataToMosiF : in std_logic_vector(7 downto 0);
      DataFromMisoA : out std_logic_vector(7 downto 0);
      DataFromMisoB : out std_logic_vector(7 downto 0);
      DataFromMisoC : out std_logic_vector(7 downto 0);
      DataFromMisoD : out std_logic_vector(7 downto 0);
      DataFromMisoE : out std_logic_vector(7 downto 0);
      DataFromMisoF : out std_logic_vector(7 downto 0);
      XferComplete : out std_logic
   );
end wrapper_for_work_spimastersextetports_spimastersextet_1000_1_'0'_'0'_1_CLOCK_DIVIDERBYTE_WIDTH;

architecture spimastersextet of wrapper_for_work_spimastersextetports_spimastersextet_1000_1_'0'_'0'_1_CLOCK_DIVIDERBYTE_WIDTH is

component work_spimastersextetports_spimastersextet_1000_1_'0'_'0'_1_CLOCK_DIVIDERBYTE_WIDTH
 port (
   clk : in std_logic;
   rst : in std_logic;
   MosiA : out std_logic;
   MosiB : out std_logic;
   MosiC : out std_logic;
   MosiD : out std_logic;
   MosiE : out std_logic;
   MosiF : out std_logic;
   SckA : out std_logic;
   SckB : out std_logic;
   SckC : out std_logic;
   SckD : out std_logic;
   SckE : out std_logic;
   SckF : out std_logic;
   MisoA : in std_logic;
   MisoB : in std_logic;
   MisoC : in std_logic;
   MisoD : in std_logic;
   MisoE : in std_logic;
   MisoF : in std_logic;
   nCsA : out std_logic_vector (3 downto 0);
   nCsB : out std_logic_vector (3 downto 0);
   nCsC : out std_logic_vector (3 downto 0);
   nCsD : out std_logic_vector (3 downto 0);
   nCsE : out std_logic_vector (3 downto 0);
   nCsF : out std_logic_vector (3 downto 0);
   MosiDataWrite : in std_logic;
   DataToMosiA : in std_logic_vector (7 downto 0);
   DataToMosiB : in std_logic_vector (7 downto 0);
   DataToMosiC : in std_logic_vector (7 downto 0);
   DataToMosiD : in std_logic_vector (7 downto 0);
   DataToMosiE : in std_logic_vector (7 downto 0);
   DataToMosiF : in std_logic_vector (7 downto 0);
   DataFromMisoA : out std_logic_vector (7 downto 0);
   DataFromMisoB : out std_logic_vector (7 downto 0);
   DataFromMisoC : out std_logic_vector (7 downto 0);
   DataFromMisoD : out std_logic_vector (7 downto 0);
   DataFromMisoE : out std_logic_vector (7 downto 0);
   DataFromMisoF : out std_logic_vector (7 downto 0);
   XferComplete : out std_logic
 );
end component;

signal tmp_clk : std_logic;
signal tmp_rst : std_logic;
signal tmp_MosiA : std_logic;
signal tmp_MosiB : std_logic;
signal tmp_MosiC : std_logic;
signal tmp_MosiD : std_logic;
signal tmp_MosiE : std_logic;
signal tmp_MosiF : std_logic;
signal tmp_SckA : std_logic;
signal tmp_SckB : std_logic;
signal tmp_SckC : std_logic;
signal tmp_SckD : std_logic;
signal tmp_SckE : std_logic;
signal tmp_SckF : std_logic;
signal tmp_MisoA : std_logic;
signal tmp_MisoB : std_logic;
signal tmp_MisoC : std_logic;
signal tmp_MisoD : std_logic;
signal tmp_MisoE : std_logic;
signal tmp_MisoF : std_logic;
signal tmp_nCsA : std_logic_vector (3 downto 0);
signal tmp_nCsB : std_logic_vector (3 downto 0);
signal tmp_nCsC : std_logic_vector (3 downto 0);
signal tmp_nCsD : std_logic_vector (3 downto 0);
signal tmp_nCsE : std_logic_vector (3 downto 0);
signal tmp_nCsF : std_logic_vector (3 downto 0);
signal tmp_MosiDataWrite : std_logic;
signal tmp_DataToMosiA : std_logic_vector (7 downto 0);
signal tmp_DataToMosiB : std_logic_vector (7 downto 0);
signal tmp_DataToMosiC : std_logic_vector (7 downto 0);
signal tmp_DataToMosiD : std_logic_vector (7 downto 0);
signal tmp_DataToMosiE : std_logic_vector (7 downto 0);
signal tmp_DataToMosiF : std_logic_vector (7 downto 0);
signal tmp_DataFromMisoA : std_logic_vector (7 downto 0);
signal tmp_DataFromMisoB : std_logic_vector (7 downto 0);
signal tmp_DataFromMisoC : std_logic_vector (7 downto 0);
signal tmp_DataFromMisoD : std_logic_vector (7 downto 0);
signal tmp_DataFromMisoE : std_logic_vector (7 downto 0);
signal tmp_DataFromMisoF : std_logic_vector (7 downto 0);
signal tmp_XferComplete : std_logic;

begin

tmp_clk <= clk;

tmp_rst <= rst;

MosiA <= tmp_MosiA;

MosiB <= tmp_MosiB;

MosiC <= tmp_MosiC;

MosiD <= tmp_MosiD;

MosiE <= tmp_MosiE;

MosiF <= tmp_MosiF;

SckA <= tmp_SckA;

SckB <= tmp_SckB;

SckC <= tmp_SckC;

SckD <= tmp_SckD;

SckE <= tmp_SckE;

SckF <= tmp_SckF;

tmp_MisoA <= MisoA;

tmp_MisoB <= MisoB;

tmp_MisoC <= MisoC;

tmp_MisoD <= MisoD;

tmp_MisoE <= MisoE;

tmp_MisoF <= MisoF;

nCsA <= tmp_nCsA;

nCsB <= tmp_nCsB;

nCsC <= tmp_nCsC;

nCsD <= tmp_nCsD;

nCsE <= tmp_nCsE;

nCsF <= tmp_nCsF;

tmp_MosiDataWrite <= MosiDataWrite;

tmp_DataToMosiA <= DataToMosiA;

tmp_DataToMosiB <= DataToMosiB;

tmp_DataToMosiC <= DataToMosiC;

tmp_DataToMosiD <= DataToMosiD;

tmp_DataToMosiE <= DataToMosiE;

tmp_DataToMosiF <= DataToMosiF;

DataFromMisoA <= tmp_DataFromMisoA;

DataFromMisoB <= tmp_DataFromMisoB;

DataFromMisoC <= tmp_DataFromMisoC;

DataFromMisoD <= tmp_DataFromMisoD;

DataFromMisoE <= tmp_DataFromMisoE;

DataFromMisoF <= tmp_DataFromMisoF;

XferComplete <= tmp_XferComplete;



u1:   work_spimastersextetports_spimastersextet_1000_1_'0'_'0'_1_CLOCK_DIVIDERBYTE_WIDTH port map (
		clk => tmp_clk,
		rst => tmp_rst,
		MosiA => tmp_MosiA,
		MosiB => tmp_MosiB,
		MosiC => tmp_MosiC,
		MosiD => tmp_MosiD,
		MosiE => tmp_MosiE,
		MosiF => tmp_MosiF,
		SckA => tmp_SckA,
		SckB => tmp_SckB,
		SckC => tmp_SckC,
		SckD => tmp_SckD,
		SckE => tmp_SckE,
		SckF => tmp_SckF,
		MisoA => tmp_MisoA,
		MisoB => tmp_MisoB,
		MisoC => tmp_MisoC,
		MisoD => tmp_MisoD,
		MisoE => tmp_MisoE,
		MisoF => tmp_MisoF,
		nCsA => tmp_nCsA,
		nCsB => tmp_nCsB,
		nCsC => tmp_nCsC,
		nCsD => tmp_nCsD,
		nCsE => tmp_nCsE,
		nCsF => tmp_nCsF,
		MosiDataWrite => tmp_MosiDataWrite,
		DataToMosiA => tmp_DataToMosiA,
		DataToMosiB => tmp_DataToMosiB,
		DataToMosiC => tmp_DataToMosiC,
		DataToMosiD => tmp_DataToMosiD,
		DataToMosiE => tmp_DataToMosiE,
		DataToMosiF => tmp_DataToMosiF,
		DataFromMisoA => tmp_DataFromMisoA,
		DataFromMisoB => tmp_DataFromMisoB,
		DataFromMisoC => tmp_DataFromMisoC,
		DataFromMisoD => tmp_DataFromMisoD,
		DataFromMisoE => tmp_DataFromMisoE,
		DataFromMisoF => tmp_DataFromMisoF,
		XferComplete => tmp_XferComplete
       );
end spimastersextet;

--
-- Synopsys
-- Vhdl wrapper for top level design, written on Tue Mar 12 14:37:38 2024
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity wrapper_for_work_spimasterports_spimaster_1000_3_1_CLOCK_DIVIDERBYTE_WIDTH is
   port (
      clk : in std_logic;
      rst : in std_logic;
      Mosi : out std_logic;
      Sck : out std_logic;
      Miso : in std_logic;
      nCs : out std_logic_vector(3 downto 0);
      Penable : in std_logic;
      Psel : in std_logic;
      Presern : in std_logic;
      Pwrite : in std_logic;
      Pready : out std_logic;
      AmbaBusData : in std_logic_vector(31 downto 0);
      DataFromMiso : out std_logic_vector(23 downto 0);
      XferComplete : out std_logic
   );
end wrapper_for_work_spimasterports_spimaster_1000_3_1_CLOCK_DIVIDERBYTE_WIDTH;

architecture spimaster of wrapper_for_work_spimasterports_spimaster_1000_3_1_CLOCK_DIVIDERBYTE_WIDTH is

component work_spimasterports_spimaster_1000_3_1_CLOCK_DIVIDERBYTE_WIDTH
 port (
   clk : in std_logic;
   rst : in std_logic;
   Mosi : out std_logic;
   Sck : out std_logic;
   Miso : in std_logic;
   nCs : out std_logic_vector (3 downto 0);
   Penable : in std_logic;
   Psel : in std_logic;
   Presern : in std_logic;
   Pwrite : in std_logic;
   Pready : out std_logic;
   AmbaBusData : in std_logic_vector (31 downto 0);
   DataFromMiso : out std_logic_vector (23 downto 0);
   XferComplete : out std_logic
 );
end component;

signal tmp_clk : std_logic;
signal tmp_rst : std_logic;
signal tmp_Mosi : std_logic;
signal tmp_Sck : std_logic;
signal tmp_Miso : std_logic;
signal tmp_nCs : std_logic_vector (3 downto 0);
signal tmp_Penable : std_logic;
signal tmp_Psel : std_logic;
signal tmp_Presern : std_logic;
signal tmp_Pwrite : std_logic;
signal tmp_Pready : std_logic;
signal tmp_AmbaBusData : std_logic_vector (31 downto 0);
signal tmp_DataFromMiso : std_logic_vector (23 downto 0);
signal tmp_XferComplete : std_logic;

begin

tmp_clk <= clk;

tmp_rst <= rst;

Mosi <= tmp_Mosi;

Sck <= tmp_Sck;

tmp_Miso <= Miso;

nCs <= tmp_nCs;

tmp_Penable <= Penable;

tmp_Psel <= Psel;

tmp_Presern <= Presern;

tmp_Pwrite <= Pwrite;

Pready <= tmp_Pready;

tmp_AmbaBusData <= AmbaBusData;

DataFromMiso <= tmp_DataFromMiso;

XferComplete <= tmp_XferComplete;



u1:   work_spimasterports_spimaster_1000_3_1_CLOCK_DIVIDERBYTE_WIDTH port map (
		clk => tmp_clk,
		rst => tmp_rst,
		Mosi => tmp_Mosi,
		Sck => tmp_Sck,
		Miso => tmp_Miso,
		nCs => tmp_nCs,
		Penable => tmp_Penable,
		Psel => tmp_Psel,
		Presern => tmp_Presern,
		Pwrite => tmp_Pwrite,
		Pready => tmp_Pready,
		AmbaBusData => tmp_AmbaBusData,
		DataFromMiso => tmp_DataFromMiso,
		XferComplete => tmp_XferComplete
       );
end spimaster;

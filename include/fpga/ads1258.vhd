--------------------------------------------------------------------------------
-- MountainOps DNT GPS Board PC/104 Firmware
--
-- $Revision: 1.4 $
-- $Date: 2009/09/22 00:01:48 $
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

package ads1258 is 

	type ads1258sample is 
	record

		IsNew : std_logic; -- 31
		Clipped : std_logic; -- 30
		Brownout : std_logic; -- 29
		Channel : std_logic_vector(4 downto 0); -- 24 - 28
		Sample : std_logic_vector(23 downto 0); -- 23 - 0

	end record ads1258sample;
	
	constant ads1258sampleinit : 
	ads1258sample := 
	(
		IsNew => '0',
		Clipped => '0',
		Brownout => '0',
		Channel => (others => '0'),
		Sample => (others => '0')
	);
	
	function ads1258sample_to_std_logic( arg : ads1258sample ) return std_logic_vector;
	function std_logic_to_ads1258sample( arg : std_logic_vector(31 downto 0) ) return ads1258sample;
	
end package ads1258;

package body ads1258 is
	
	function ads1258sample_to_std_logic( arg : ads1258sample ) return std_logic_vector is
		variable result : std_logic_vector(31 downto 0);
	begin
		result(31) := arg.IsNew;
		result(30) := arg.Clipped;
		result(29) := arg.Brownout;
		result(28 downto 24) := arg.Channel;
		result(23 downto 0) := arg.Sample;		
		return result;		
	end function ads1258sample_to_std_logic;
	
	function std_logic_to_ads1258sample( arg : std_logic_vector(31 downto 0) ) return ads1258sample is
		variable result : ads1258sample;
	begin
		result.IsNew := arg(31);
		result.Clipped := arg(30);
		result.Brownout := arg(29);
		result.Channel := arg(28 downto 24);
		result.Sample := arg(23 downto 0);
		return result;		
	end function std_logic_to_ads1258sample;

end ads1258;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;
use ads1258.all;

entity ads1258Ports is
	generic (
		MASTER_CLOCK_FREQHZ : natural := 10000000--;
	);
	port (
	
		clk : in std_logic;
		rst : in std_logic;
		
		-- A/D:
		nDrdy : in std_logic;
		nCsAdc : out std_logic;
		Sck : out std_logic;
		Mosi : out  std_logic;
		Miso : in  std_logic;		
		
		--Raw, Basic Spi Xfers
		SpiDataIn : in std_logic_vector(7 downto 0);
		SpiDataOut : out std_logic_vector(7 downto 0);
		SpiXferStart : in std_logic;
		SpiXferDone : out std_logic;
		
		-- Bus / Fifos:
		Sample : out ads1258sample;
		SampleLatched : out std_logic;		
		TimestampReq : out std_logic--;				
	);
end ads1258Ports;

architecture ads1258_i of ads1258Ports is

	component SpiMasterPorts is
	generic (
		CLOCK_DIVIDER : integer := MASTER_CLOCK_FREQHZ;
		BYTE_WIDTH : natural := 1;
		CPOL : std_logic := '0'--;	
	);
	port
	(
		clk : in std_logic;
		rst : in std_logic;
		Mosi : out std_logic;
		Sck : out std_logic;
		Miso : in std_logic;
		DataToMosi : in std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataFromMiso : out std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		XferComplete : out std_logic--;
	);
	end component;

	constant DataReady : std_logic := '0';
	constant NoDataReady : std_logic := '1';
	signal LastnDrdy : std_logic;
	
	signal DataFromMiso : std_logic_vector(31 downto 0);
	signal SpiRst : std_logic;
	signal SpiXferComplete : std_logic;
	signal TimestampReq_i : std_logic;
	
	signal Sample_i : ads1258sample;
	
begin

	Spi : SpiMasterPorts
	generic map (
		CLOCK_DIVIDER => (MASTER_CLOCK_FREQHZ / 1000000) + 1, --ads1258 datahseet specs sclk <= 8MHz, so let's try 1MHz
		BYTE_WIDTH => 4,
		CPOL => '0'--,
	)
	port map
	(
		clk => clk,
		rst => SpiRst,
		Mosi => Mosi,
		Sck => Sck,
		Miso => Miso,
		DataToMosi => x"00000000", --We just tie Mosi to zero (or optionally 0xFF) to use continuous direct reads on nDrdy
		DataFromMiso => DataFromMiso,
		XferComplete => SpiXferComplete--,
	);
	
	nCsAdc <= SpiRst; --Just run nCs low while we're doing a transfer...
	
	TimestampReq <= TimestampReq_i;
	
	Sample <= Sample_i;

	process (clk, rst, nDrdy, SpiXferComplete)
	begin
	
		if (rst = '1') then
	
			LastnDrdy <= NoDataReady;
			SpiRst <= '1';
			Sample_i.IsNew <= '0';
			Sample_i.Clipped <= '0';
			Sample_i.Brownout <= '0';
			Sample_i.Channel <= "00000";
			Sample_i.Sample <= x"000000";
			SampleLatched <= '0';
			TimestampReq_i <= '0';
	
		else
			
			if ( (clk'event) and (clk = '1') ) then
		
				--Follow Drdy
				if (nDrdy /= LastnDrdy) then
				
					LastnDrdy <= nDrdy;
					
					if (nDrdy = DataReady) then
					
						--Just read the data...
						SpiRst <= '0';
						SampleLatched <= '0';
						
						--Ask for a timestamp
						TimestampReq_i <= '1';
					
					end if;
				
				end if;
				
				--Make sure TimestampReq is a single clock:
				if (TimestampReq_i = '1') then TimestampReq_i <= '0'; end if;
				
				--Wait for Spi xfer to complete, then grab the Sample_i...
				if (SpiXferComplete = '1') then
				
					Sample_i.IsNew <= DataFromMiso(31);
					Sample_i.Clipped <= DataFromMiso(30);
					Sample_i.Brownout <= DataFromMiso(29);
					Sample_i.Channel <= DataFromMiso(28 downto 24);
					Sample_i.Sample <= DataFromMiso(23 downto 0);

					SampleLatched <= '1';
					SpiRst <= '1';
					
				end if;
			
			end if;
			
		end if;

	end process;

end ads1258_i;

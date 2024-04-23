--------------------------------------------------------------------------------
-- ltc244x A/D handler
--
-- c2013 Franks Development, LLC
-- author: steve
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;
use work.ltc244x_types.all;

entity ltc244xPorts is
	generic (
		MASTER_CLOCK_FREQHZ : natural := 100000000--; --The input clock
	);
	port (
	
		--Globals
		clk : in std_logic;
		rst : in std_logic;
		
		-- A/D:
		nDrdy : in std_logic; --Falling edge indicates a new sample is ready, high while converting, low when ready, asleep, and serialxfer
		nCs : out std_logic; --Falling edge initiates a new conversion
		Sck : out std_logic; --can run up to 20MHz
		Mosi : out std_logic; --10nsec setup time
		Miso : in  std_logic; --valid after 25nsec, 15nsec hold time
		
		-- Bus:
		Channel : in std_logic_vector(4 downto 0);
		Datarate : in std_logic_vector(4 downto 0);
		ReadChannel : in std_logic;
		Sample : out std_logic_vector(31 downto 0);
		SampleLatched : out std_logic--;
	);
end ltc244xPorts;

architecture ltc244x_i of ltc244xPorts is

	component SpiMasterPorts is
	generic (
		CLOCK_DIVIDER : integer := 4;
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
	
	component OneShotPorts is
	generic (
		CLOCK_FREQHZ : natural := 10000000;
		DELAY_SECONDS : real := 0.001;
		SHOT_RST_STATE : std_logic := '0';
		SHOT_PRETRIGGER_STATE : std_logic := '0'--;
	);
	port (	
		clk : in std_logic;
		rst : in std_logic;
		shot : out std_logic
	);
	end component;

	--nDrdy is inverted (obviously)
	constant DataReady : std_logic := '0';
	constant NoDataReady : std_logic := '1';
	signal LastnDrdy : std_logic; --to grab edge
	signal LastReadChannel : std_logic; --to grab edge	
	signal DataFromMiso : std_logic_vector(31 downto 0);
	signal DataToMosi : std_logic_vector(31 downto 0);	
	signal SpiRst : std_logic; --kicks off / inhibits transfer of a sample out of the A/D
	signal SpiXferComplete : std_logic;
	signal LastSpiXferComplete : std_logic;
	
begin

	Spi : SpiMasterPorts
	generic map (
		CLOCK_DIVIDER => MASTER_CLOCK_FREQHZ / 5000000, --5MHz seems reasonable for a 20MHz part
		BYTE_WIDTH => 4, 
		CPOL => '0'--, --'normal' SCK polarity
	)
	port map
	(
		clk => clk, --runs off the same clock as the A/D to keep everything nicely aligned & quiet
		rst => SpiRst, --every sample requires a set/rst sequence to run spimaster
		Mosi => Mosi,
		Sck => Sck,
		Miso => Miso,
		DataToMosi => DataToMosi,
		DataFromMiso => DataFromMiso,
		XferComplete => SpiXferComplete--,
	);
	
	--~ nCs <= SpiRst; --these concepts are synchronous in this design
	
	--Read A/D:
	process (clk, rst, nDrdy, SpiXferComplete)
	begin
	
		if (rst = '1') then 
		
			SpiRst <= '1';			
			
		else
			
			if ( (clk'event) and (clk = '1') ) then
			
				--ReadChannel kicks the whole thing off signal controls Spi master transfers
				if (ReadChannel /= LastReadChannel) then
				
					LastReadChannel <= ReadChannel;
				
					if (ReadChannel = '1') then

						nCs <= '0'; --fire up the spi bus to get the sample off the a/d
						
						SampleLatched <= '0'; --no sample ready now.
						
					end if;
				
				end if;
			
				--Dataready signal controls Spi master transfers
				if (nDrdy /= LastnDrdy) then
				
					LastnDrdy <= nDrdy;
				
					if (nDrdy = DataReady) then

						SpiRst <= '0'; --fire up the spi bus to get the sample off the a/d
						
					else
					
						SpiRst <= '1'; --new sample incoming, reset bus
						
					end if;
				
				end if;
				
				--When spi xfer is complete, grab the data
				if (SpiXferComplete /= LastSpiXferComplete) then
				
					LastSpiXferComplete <= SpiXferComplete;
				
					if (SpiXferComplete = '1') then

						Sample <= DataFromMiso;
						
						nCs <= '1'; --fire up the spi bus to get the sample off the a/d
						
						SampleLatched <= '1'; --no sample ready now.
					
					end if;
				
				end if;				
				
			end if;		
			
		end if;	
		
	end process;

end ltc244x_i;

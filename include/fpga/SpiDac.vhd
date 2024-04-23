--------------------------------------------------------------------------------
-- SpiDac D/A handler
--
-- c2015 Franks Development, LLC
-- author: steve
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

--For now, we're going to assume a D/A which is fine with a 1MHz clock.
--It's also 16-bit.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity SpiDacPorts is
	generic (
		MASTER_CLOCK_FREQHZ : natural := 100000000;
		BIT_WIDTH : natural := 16--;
	);
	port (
	
		--Globals
		clk : in std_logic;
		rst : in std_logic;
		
		-- D/A:
		nCs : out std_logic;
		Sck : out std_logic;
		Mosi : out  std_logic;
		Miso : in  std_logic;
		
		--Control signals
		DacWriteOut : in std_logic_vector(BIT_WIDTH - 1 downto 0);
		WriteDac : in std_logic;
		DacReadback : out std_logic_vector(BIT_WIDTH - 1 downto 0)--;
		--~ TransferComplete : out std_logic;
		
	); end SpiDacPorts;

architecture SpiDac of SpiDacPorts is

	component IBufP2Ports is
	port (
		clk : in std_logic;
		I : in std_logic;
		O : out std_logic--;
	);
	end component;
		
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
		
	signal SpiRst : std_logic; --kicks off / inhibits transfer of a sample out of the A/D
	signal SpiXferComplete : std_logic;
	signal LastSpiXferComplete : std_logic;
		
	--~ signal DacClk : std_logic;
	signal LastWriteDac : std_logic;
	signal DacReadback_i : std_logic_vector(BIT_WIDTH - 1 downto 0);
	
begin

	Spi : SpiMasterPorts
	generic map (
		CLOCK_DIVIDER => MASTER_CLOCK_FREQHZ / 100000, --100kHz
		BYTE_WIDTH => BIT_WIDTH / 8,
		CPOL => '0'--, --'inverted' SCK polarity?
	)
	port map
	(
		clk => clk, --runs off the same clock as the A/D to keep everything nicely aligned & quiet
		rst => SpiRst, --every sample requires a set/rst sequence to run spimaster
		Mosi => Mosi, --we don't actually send anything to the A/D, all it needs is the sample trigger/clock
		Sck => Sck,
		Miso => Miso,
		DataToMosi => DacWriteOut, --we don't actually send anything to the A/D
		DataFromMiso => DacReadback_i,
		XferComplete => SpiXferComplete--,
	);
	
	nCs <= SpiRst; --these concepts are synchronous in this design
		
	--~ TransferComplete <= SpiRst; --these concepts are synchronous in this design
		
	--Read A/D:
	process (clk, rst, WriteDac, SpiXferComplete)
	begin
	
		if (rst = '1') then 
		
			SpiRst <= '1';			
			LastWriteDac <= '0';
			LastSpiXferComplete <= '0';
			
		else
			
			if ( (clk'event) and (clk = '1') ) then
			
				--Follow Drdy
				if (WriteDac /= LastWriteDac) then
				
					LastWriteDac <= WriteDac;
					
					--Here we go...
					if (WriteDac = '1') then
					
						--Initiate reading the data.
						SpiRst <= '0';
											
					end if;
					
				else

					--Wait for Spi xfer to complete, then grab the sample and we're done
					if (SpiXferComplete /= LastSpiXferComplete) then
					
						LastSpiXferComplete <= SpiXferComplete;

						if (SpiXferComplete = '1') then
						
							--Grab read back
							DacReadback <= DacReadback_i;
												
							--turn off spi master bus
							SpiRst <= '1';
							
						end if;
						
					end if;		
					
				end if;
				
			end if;		
			
		end if;	
		
	end process;
	
end SpiDac;

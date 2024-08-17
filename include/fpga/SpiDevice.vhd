--------------------------------------------------------------------------------
-- SpiDevice D/A handler
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

entity SpiDevicePorts is
	generic (
		CLOCK_DIVIDER : natural := 4;
		BIT_WIDTH : natural := 8;
		CPOL : std_logic := '0'; --'standard' spi knob - inverts clock polarity (0 seems to be the standard, 1 less common)
		CPHA : std_logic := '0'--; --'standard' spi knob - inverts clock phase (0 seems to be the standard, 1 less common)
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
		WriteOut : in std_logic_vector(BIT_WIDTH - 1 downto 0);
		Transfer : in std_logic;
		Readback : out std_logic_vector(BIT_WIDTH - 1 downto 0);
		TransferComplete : out std_logic--;
		
	); 
end SpiDevicePorts;

architecture SpiDevice of SpiDevicePorts is

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
		CPOL : std_logic := '0'; --'standard' spi knob - inverts clock polarity (0 seems to be the standard, 1 less common)
		CPHA : std_logic := '0'--; --'standard' spi knob - inverts clock phase (0 seems to be the standard, 1 less common)
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
	signal LastTransfer : std_logic;
	signal TransferActuallyComplete : std_logic; --When we're done & we reset the spi bus it's version of this signal goes back to zero
	signal Readback_i : std_logic_vector(BIT_WIDTH - 1 downto 0);
	
begin

	Spi : SpiMasterPorts
	generic map (
		CLOCK_DIVIDER => CLOCK_DIVIDER, --100kHz
		BYTE_WIDTH => BIT_WIDTH / 8,
		CPOL => CPOL, --'inverted' SCK polarity?
		CPHA => CPHA--, --'inverted' SCK phase?
	)
	port map
	(
		clk => clk, --runs off the same clock as the A/D to keep everything nicely aligned & quiet
		rst => SpiRst, --every sample requires a set/rst sequence to run spimaster
		Mosi => Mosi, --we don't actually send anything to the A/D, all it needs is the sample trigger/clock
		Sck => Sck,
		Miso => Miso,
		DataToMosi => WriteOut, --we don't actually send anything to the A/D
		DataFromMiso => Readback_i,
		XferComplete => SpiXferComplete--,
	);
	
	nCs <= SpiRst; --these concepts are synchronous in this design
	
	TransferComplete <= TransferActuallyComplete;
		
	--~ TransferComplete <= SpiRst; --these concepts are synchronous in this design
		
	--Read A/D:
	process (clk, rst, Transfer, SpiXferComplete)
	begin
	
		if (rst = '1') then 
		
			SpiRst <= '1';			
			LastTransfer <= '0';
			LastSpiXferComplete <= '0';
			TransferActuallyComplete <= '0';			
			
		else
			
			if ( (clk'event) and (clk = '1') ) then
			
				--Follow Drdy
				if (Transfer /= LastTransfer) then
				
					LastTransfer <= Transfer;
					
					--Here we go...
					if (Transfer = '1') then
					
						--Initiate reading the data.
						SpiRst <= '0';
						
						TransferActuallyComplete <= '0';
											
					end if;
					
				else

					--Wait for Spi xfer to complete, then grab the sample and we're done
					if (SpiXferComplete /= LastSpiXferComplete) then
					
						LastSpiXferComplete <= SpiXferComplete;

						if (SpiXferComplete = '1') then
						
							--Grab read back
							Readback <= Readback_i;
							
							TransferActuallyComplete <= '1';
												
							--turn off spi master bus
							SpiRst <= '1';
							
						end if;
						
					end if;		
					
				end if;
				
			end if;		
			
		end if;	
		
	end process;
	
end SpiDevice;

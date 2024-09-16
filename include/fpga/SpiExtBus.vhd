--
--           Copyright (c) by Franks Development, LLC
--
-- This software is copyrighted by and is the sole property of Franks
-- Development, LLC. All rights, title, ownership, or other interests
-- in the software remain the property of Franks Development, LLC. This
-- software may only be used in accordance with the corresponding
-- license agreement.  Any unauthorized use, duplication, transmission,
-- distribution, or disclosure of this software is expressly forbidden.
--
-- This Copyright notice may not be removed or modified without prior
-- written consent of Franks Development, LLC.
--
-- Franks Development, LLC. reserves the right to modify this software
-- without notice.
--
-- Franks Development, LLC            support@franks-development.com
-- 500 N. Bahamas Dr. #101           http:--www.franks-development.com
-- Tucson, AZ 85710
-- USA
--
-- Permission granted for perpetual non-exclusive end-use by the University of Arizona August 1, 2020
--

--------------------------------------------------------------------------------
-- SpiExtBus D/A handler
--
-- c2015 Franks Development, LLC
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

entity SpiExtBusPorts is
	generic (
		MASTER_CLOCK_FREQHZ : natural := 100000000--;
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
		SpiExtBusWriteOut : in std_logic_vector(7 downto 0);
		WriteSpiExtBus : in std_logic;
		SpiExtBusReadReady : out std_logic;
		SpiExtBusReadback : out std_logic_vector(7 downto 0)--;
		--~ TransferComplete : out std_logic;
		
	); end SpiExtBusPorts;

architecture SpiExtBus of SpiExtBusPorts is

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
		
	signal SpiExtBusClk : std_logic;
	signal LastWriteSpiExtBus : std_logic;
	signal SpiExtBusReadback_i : std_logic_vector(7 downto 0);
	
begin

	Spi : SpiMasterPorts
	generic map (
		--~ CLOCK_DIVIDER => MASTER_CLOCK_FREQHZ / 2000000, --2MHz works on 339...
		CLOCK_DIVIDER => MASTER_CLOCK_FREQHZ / 500000,
		--~ CLOCK_DIVIDER => MASTER_CLOCK_FREQHZ / 65535,
		--~ CLOCK_DIVIDER => MASTER_CLOCK_FREQHZ / 8191,
		--~ CLOCK_DIVIDER => MASTER_CLOCK_FREQHZ / 2047,
		BYTE_WIDTH => 1,
		--~ CPOL => '1'--, --'inverted' SCK polarity?
		CPOL => '0'--, --'inverted' SCK polarity?
	)
	port map
	(
		clk => clk, --runs off the same clock as the A/D to keep everything nicely aligned & quiet
		rst => SpiRst, --every sample requires a set/rst sequence to run spimaster
		Mosi => Mosi, --we don't actually send anything to the A/D, all it needs is the sample trigger/clock
		Sck => Sck,
		Miso => Miso,
		DataToMosi => SpiExtBusWriteOut, --we don't actually send anything to the A/D
		DataFromMiso => SpiExtBusReadback_i,
		XferComplete => SpiXferComplete--,
	);
	
	nCs <= SpiRst; --these concepts are synchronous in this design
		
	--~ TransferComplete <= SpiRst; --these concepts are synchronous in this design
		
	--~ SpiExtBusReadReady <= SpiXferComplete;
	
	--Read A/D:
	process (clk, rst, WriteSpiExtBus, SpiXferComplete)
	begin
	
		if (rst = '1') then 
		
			SpiRst <= '1';			
			LastWriteSpiExtBus <= '0';
			LastSpiXferComplete <= '0';
			
		else
			
			if ( (clk'event) and (clk = '1') ) then
			
				--Follow Drdy
				if (WriteSpiExtBus /= LastWriteSpiExtBus) then
				
					LastWriteSpiExtBus <= WriteSpiExtBus;
					
					--Here we go...
					if (WriteSpiExtBus = '1') then
					
						SpiExtBusReadReady <= '0';
					
						--Initiate reading the data.
						SpiRst <= '0';
											
					end if;
					
				else

					--Wait for Spi xfer to complete, then grab the sample and we're done
					if (SpiXferComplete /= LastSpiXferComplete) then
					
						LastSpiXferComplete <= SpiXferComplete;

						if (SpiXferComplete = '1') then
						
							--Grab read back
							SpiExtBusReadback <= SpiExtBusReadback_i;
							
							SpiExtBusReadReady <= '1';
												
							--~ --turn off spi master bus
							SpiRst <= '1';
							
						end if;
						
					end if;		
					
					--~ --Wait for Spi xfer to complete, then shut it off.
					--~ if ( (SpiXferComplete = '1') and (LastSpiXferComplete = '1') ) then
					
						--~ --turn off spi master bus
						--~ SpiRst <= '1';
						
					--~ end if;
					
				end if;
				
			end if;		
			
		end if;	
		
	end process;
	
end SpiExtBus;

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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;
library work;
use work.ltc244x_types.all;

entity ltc244xAutoscanPorts is
	generic (
		MASTER_CLOCK_FREQHZ : natural := 10000000--;
	);
	port (
	
		--Globals
		clk : in std_logic;
		rst : in std_logic;
		
		-- A/D:
		nDrdy : in  std_logic; --Falling edge indicates new data
		nCs : out std_logic; --Falling edge initiates a new conversion
		Sck : out std_logic; --can run up to 20MHz
		Mosi : out std_logic; --10nsec setup time
		Miso : in  std_logic; --valid after 25nsec, 15nsec hold time
		
		--Control
		NextChannel : in std_logic_vector(4 downto 0);
		NextDatarate : in std_logic_vector(3 downto 0);
		NextDoubleRate : in std_logic;
		
		-- Bus / Fifos:
		Sample : out ltc244xsample;
		SampleLatched : out std_logic;		
		TimestampReq : out std_logic--;				
	);
end ltc244xAutoscanPorts;

architecture ltc244x_i of ltc244xAutoscanPorts is

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
	signal LastnDrdy : std_logic := '1';
	
	signal DataFromMiso : std_logic_vector(31 downto 0);
	signal DataToMosi : std_logic_vector(31 downto 0);
	signal SpiRst : std_logic;
	signal SpiXferComplete : std_logic;
	signal TimestampReq_i : std_logic;
	
	signal Sample_i : ltc244xsample;
	signal Config_i : ltc244xconfig;
	
begin

	Spi : SpiMasterPorts
	generic map (
		--~ CLOCK_DIVIDER => (MASTER_CLOCK_FREQHZ / 1000000) + 1, --ltc244x datahseet specs sclk <= 20MHz, so let's try 1MHz
		CLOCK_DIVIDER => (MASTER_CLOCK_FREQHZ / 100000) + 1, --ltc244x datahseet specs sclk <= 20MHz, so let's try 1MHz
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
		DataToMosi => DataToMosi, --We just tie Mosi to zero (or optionally 0xFF) to use continuous direct reads on nDrdy
		DataFromMiso => DataFromMiso,
		XferComplete => SpiXferComplete--,
	);
	
	nCs <= SpiRst; --Just run nCs low while we're doing a transfer...
	
	TimestampReq <= TimestampReq_i;
	
	Sample <= Sample_i;
	
	process (clk, rst, nDrdy, SpiXferComplete)
	begin
	
		--here's how to invert a signal:
		--~ for i in ChannelInverted'range loop
			--~ ChannelInverted(ChannelInverted'left - i) <= NextChannel(i);
		--~ end loop;
	
		if (rst = '1') then
	
			LastnDrdy <= NoDataReady; --otherwise we'll never start up, because drdy will start at zero and never change, so we'll never toggle cs and start a new cycle...
			SpiRst <= '1';
			Sample_i <= ltc244xsampleinit;
			Config_i <= ltc244xconfiginit;
			SampleLatched <= '0';
			TimestampReq_i <= '0';
	
		else
			
			if ( (clk'event) and (clk = '1') ) then
		
				--Follow Drdy
				if (nDrdy /= LastnDrdy) then
				
					LastnDrdy <= nDrdy;
					
					if (nDrdy = DataReady) then
					
						--Set outgoing config (i.e. channel)
						--~ Config_i.Channel <= "10010"; --DEBUG! Ch4 (se) is IAdj 
						Config_i.Channel <= NextChannel;
						Config_i.DataRate <= NextDataRate;
						Config_i.DoubleSpeedAndOneCycleLatency <= NextDoubleRate;
						DataToMosi <= ltc244xconfig_to_std_logic(Config_i);
					
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
				
					Sample_i <= std_logic_to_ltc244xsample(DataFromMiso);
					--~ Sample_i <= std_logic_to_ltc244xsample(x"12345678"); --DEBUG!
					SampleLatched <= '1';
					SpiRst <= '1';
					
				end if;
			
			end if;
			
		end if;

	end process;

end ltc244x_i;

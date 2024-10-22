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
-- SpiDevice D/A handler
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

entity SpiDeviceDualPorts is
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
		MosiA : out  std_logic;
		MosiB : out  std_logic;
		MisoA : in  std_logic;
		MisoB : in  std_logic;
		
		--Control signals
		WriteOutA : in std_logic_vector(BIT_WIDTH - 1 downto 0);
		WriteOutB : in std_logic_vector(BIT_WIDTH - 1 downto 0);
		Transfer : in std_logic;
		ReadbackA : out std_logic_vector(BIT_WIDTH - 1 downto 0);
		ReadbackB : out std_logic_vector(BIT_WIDTH - 1 downto 0);
		TransferComplete : out std_logic--;
		
	); 
end SpiDevicePorts;

architecture SpiDeviceDual of SpiDeviceDualPorts is

	component IBufP2Ports is
	port (
		clk : in std_logic;
		I : in std_logic;
		O : out std_logic--;
	);
	end component;
		
	component SpiMasterDualPorts is
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
		MosiA : out std_logic;
		MosiB : out std_logic;
		Sck : out std_logic;
		MisoA : in std_logic;
		MisoB : in std_logic;
		DataToMosiA : in std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataToMosiB : in std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataFromMisoA : out std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataFromMisoB : out std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		XferComplete : out std_logic--;
	);
	end component;
		
	signal SpiRst : std_logic; --kicks off / inhibits transfer of a sample out of the A/D
	signal SpiXferComplete : std_logic;
	signal LastSpiXferComplete : std_logic;
		
	--~ signal DacClk : std_logic;
	signal LastTransfer : std_logic;
	signal TransferActuallyComplete : std_logic; --When we're done & we reset the spi bus it's version of this signal goes back to zero
	signal ReadbackA_i : std_logic_vector(BIT_WIDTH - 1 downto 0);
	signal ReadbackB_i : std_logic_vector(BIT_WIDTH - 1 downto 0);
	
begin

	Spi : SpiMasterDualPorts
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
		MosiA => MosiA, --we don't actually send anything to the A/D, all it needs is the sample trigger/clock
		MosiB => MosiB, --we don't actually send anything to the A/D, all it needs is the sample trigger/clock
		Sck => Sck,
		MisoA => MisoA,
		MisoB => MisoB,
		DataToMosiA => WriteOut, --we don't actually send anything to the A/D
		DataToMosiB => WriteOut, --we don't actually send anything to the A/D
		DataFromMisoA => ReadbackA_i,
		DataFromMisoB => ReadbackB_i,
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
							ReadbackA <= ReadbackA_i;
							ReadbackB <= ReadbackB_i;
							
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

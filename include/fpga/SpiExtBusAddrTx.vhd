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

entity SpiExtBusAddrTxPorts is
	generic (
		MASTER_CLOCK_FREQHZ : natural := 10000000--; --The input clock
	);
	port (
	
		clk : in std_logic;
		rst : in std_logic;
		SpiExtBusAddr : in std_logic_vector(7 downto 0);
		SendSpiExtBusAddr : in std_logic;
		SendingSpiExtBusAddr : out std_logic;
		SpiExtBusAddrTxdPin : out std_logic--;
	);
end SpiExtBusAddrTxPorts;

architecture SpiExtBusAddrTx of SpiExtBusAddrTxPorts is

	component ClockDividerPorts is
	generic (
		CLOCK_DIVIDER : natural := 10;
		DIVOUT_RST_STATE : std_logic := '0'--;
	);
	port (
	
		clk : in std_logic;
		rst : in std_logic;
		div : out std_logic
	);
	end component;
	
	component UartTx is
	port (
	
		Clk    : in  Std_Logic;
		Reset  : in  Std_Logic;
		Go     : in  Std_Logic; --To initate a xfer, raise this bit and wait for busy to go high, then lower.
		TxD    : out Std_Logic;
		Busy   : out Std_Logic;
		Data  : in  Std_Logic_Vector(7 downto 0)--; --not latched; must be held constant while busy is high
	);
	end component;

	type SpiExtBusAddrTxStates is (Idle, Load, Loaded, Transmit);

	signal SpiExtBusAddrTxNextState : SpiExtBusAddrTxStates := Idle;
	signal SpiExtBusAddrTxCurrentState : SpiExtBusAddrTxStates := Idle;
	
	signal LatchTxdSpiExtBusAddr : std_logic;	
	signal SpiExtBusAddrTxdClock : std_logic;	
	signal StartTxdSpiExtBusAddr : std_logic;	
	signal SpiExtBusAddrTxdInProgress : std_logic;	

begin
	
	--SpiExtBus addressing is always at 38.4kbps:
	SpiExtBusAddrTxdClockDiv : ClockDividerPorts
	generic map
	(
		CLOCK_DIVIDER => natural((real(MASTER_CLOCK_FREQHZ) / ( 38400.0 * 1.0)) + 0.5)
	)
	port map
	(
		clk => clk,
		rst => rst,
		div => SpiExtBusAddrTxdClock
	);

	SpiExtBusAddrOutUart : UartTx
	port map 
	(	
		clk => SpiExtBusAddrTxdClock,
		reset => rst,
		Go => StartTxdSpiExtBusAddr,
		TxD => SpiExtBusAddrTxdPin,
		Busy => SpiExtBusAddrTxdInProgress,
		Data => SpiExtBusAddr
	);
	
	--Run the SpiExtBus addr output cycle:
	process (clk, rst, SpiExtBusAddrTxCurrentState)
	begin
	
		if (rst = '1') then
		
			LatchTxdSpiExtBusAddr <= '0';
			StartTxdSpiExtBusAddr <= '0';
			SendingSpiExtBusAddr <= '0';
			SpiExtBusAddrTxNextState <= Idle;
		
		else
			
			if ( (clk'event) and (clk = '1') ) then
			
				SpiExtBusAddrTxCurrentState <= SpiExtBusAddrTxNextState;

				case SpiExtBusAddrTxCurrentState is
				
					when Idle =>
					
						if (SendSpiExtBusAddr = '1') then
			
							LatchTxdSpiExtBusAddr <= '1';
											
						end if;
						
						if ( (SendSpiExtBusAddr = '0') and (LatchTxdSpiExtBusAddr = '1') ) then
							
							SpiExtBusAddrTxNextState <= Load;
											
						end if;
						
					when Load =>
					
						StartTxdSpiExtBusAddr <= '1';
						
						LatchTxdSpiExtBusAddr <= '0';
						
						SendingSpiExtBusAddr <= '1';
						
						SpiExtBusAddrTxNextState <= Loaded;
										
					when Loaded =>
					
						if (SpiExtBusAddrTxdInProgress = '1') then
			
							StartTxdSpiExtBusAddr <= '0';
							
							SpiExtBusAddrTxNextState <= Transmit;
											
						end if;						
						
					when Transmit =>
					
						if (SpiExtBusAddrTxdInProgress = '0') then

							SendingSpiExtBusAddr <= '0';
							
							SpiExtBusAddrTxNextState <= Idle;
											
						end if;						

					when others => -- ought never to get here...
					
						LatchTxdSpiExtBusAddr <= '0';
						StartTxdSpiExtBusAddr <= '0';
						SendingSpiExtBusAddr <= '0';
						SpiExtBusAddrTxNextState <= Idle;
						
				end case;
				
			end if;
			  
		end if;

	end process;

end SpiExtBusAddrTx;

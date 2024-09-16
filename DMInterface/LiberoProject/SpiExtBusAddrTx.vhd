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
		SpiExtBussAddr : in std_logic_vector(7 downto 0);
		SendSpiExtBussAddr : in std_logic;
		SendingSpiExtBussAddr : out std_logic;
		SpiExtBussAddrTxdPin : out std_logic--;
	);
end SpiExtBusAddrTxPorts;

architecture SpiExtBussAddrTx of SpiExtBusAddrTxPorts is

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

	type SpiExtBussAddrTxStates is (Idle, Load, Loaded, Transmit);

	signal SpiExtBussAddrTxNextState : SpiExtBussAddrTxStates := Idle;
	signal SpiExtBussAddrTxCurrentState : SpiExtBussAddrTxStates := Idle;
	
	signal LatchTxdSpiExtBussAddr : std_logic;	
	signal SpiExtBussAddrTxdClock : std_logic;	
	signal StartTxdSpiExtBussAddr : std_logic;	
	signal SpiExtBussAddrTxdInProgress : std_logic;	

begin
	
	--SpiExtBuss addressing is always at 38.4kbps:
	SpiExtBussAddrTxdClockDiv : ClockDividerPorts
	generic map
	(
		CLOCK_DIVIDER => natural((real(MASTER_CLOCK_FREQHZ) / ( 38400.0 * 1.0)) + 0.5)
	)
	port map
	(
		clk => clk,
		rst => rst,
		div => SpiExtBussAddrTxdClock
	);

	SpiExtBussAddrOutUart : UartTx
	port map 
	(	
		clk => SpiExtBussAddrTxdClock,
		reset => rst,
		Go => StartTxdSpiExtBussAddr,
		TxD => SpiExtBussAddrTxdPin,
		Busy => SpiExtBussAddrTxdInProgress,
		Data => SpiExtBussAddr
	);
	
	--Run the SpiExtBuss addr output cycle:
	process (clk, rst, SpiExtBussAddrTxCurrentState)
	begin
	
		if (rst = '1') then
		
			LatchTxdSpiExtBussAddr <= '0';
			StartTxdSpiExtBussAddr <= '0';
			SendingSpiExtBussAddr <= '0';
			SpiExtBussAddrTxNextState <= Idle;
		
		else
			
			if ( (clk'event) and (clk = '1') ) then
			
				SpiExtBussAddrTxCurrentState <= SpiExtBussAddrTxNextState;

				case SpiExtBussAddrTxCurrentState is
				
					when Idle =>
					
						if (SendSpiExtBussAddr = '1') then
			
							LatchTxdSpiExtBussAddr <= '1';
											
						end if;
						
						if ( (SendSpiExtBussAddr = '0') and (LatchTxdSpiExtBussAddr = '1') ) then
							
							SpiExtBussAddrTxNextState <= Load;
											
						end if;
						
					when Load =>
					
						StartTxdSpiExtBussAddr <= '1';
						
						LatchTxdSpiExtBussAddr <= '0';
						
						SendingSpiExtBussAddr <= '1';
						
						SpiExtBussAddrTxNextState <= Loaded;
										
					when Loaded =>
					
						if (SpiExtBussAddrTxdInProgress = '1') then
			
							StartTxdSpiExtBussAddr <= '0';
							
							SpiExtBussAddrTxNextState <= Transmit;
											
						end if;						
						
					when Transmit =>
					
						if (SpiExtBussAddrTxdInProgress = '0') then

							SendingSpiExtBussAddr <= '0';
							
							SpiExtBussAddrTxNextState <= Idle;
											
						end if;						

					when others => -- ought never to get here...
					
						LatchTxdSpiExtBussAddr <= '0';
						StartTxdSpiExtBussAddr <= '0';
						SendingSpiExtBussAddr <= '0';
						SpiExtBussAddrTxNextState <= Idle;
						
				end case;
				
			end if;
			  
		end if;

	end process;

end SpiExtBussAddrTx;

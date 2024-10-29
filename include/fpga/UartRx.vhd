--------------------------------------------------------------------------------
--UartRx: a uart reciever with clocks and such built-in
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity UartRx is
	generic 
	(
		CLOCK_FREQHZ : natural := 14745600;
		BAUDRATE : natural := 38400--;
	);
	port 
	(
		clk : in std_logic;
		rst : in std_logic;
		UartClk : out std_logic; --debug
		Rxd : in std_logic; --external (async) uart data input pin
		RxComplete : out std_logic; --Just got a byte
		RxData : out std_logic_vector(7 downto 0) --The byte we just got		
	);
end UartRx;

architecture implementation of UartRx is

		component IBufP2Ports is
		port 
		(
			clk : in std_logic;
			I : in std_logic;
			O : out std_logic--;
		);
		end component;

		component ClockDividerPorts is
		generic 
		(
			CLOCK_DIVIDER : natural := 10;
			DIVOUT_RST_STATE : std_logic := '0'--;
		);
		port 
		(		
			clk : in std_logic;
			rst : in std_logic;
			div : out std_logic
		);
		end component;
		
		component UartRxRaw is
		port 
		(
			Clk    : in  std_logic;  -- system clock signal
			Reset  : in  std_logic;  -- Reset input
			Enable : in  std_logic;  -- Enable input
			RxD    : in  std_logic;  -- RS-232 data input
			RxAv   : out std_logic;  -- Byte available
			DataO  : out std_logic_vector(7 downto 0)--; -- Byte received
		);
		end component;
	
	signal UartBaudClkx16 : std_logic; --UartRx needs a clock at baud * 16
	signal Rxd_i : std_logic; --Sync Rxd to clock domain
	
begin

	--uart needs baud*16 for it to work, this just makes one...
	UartClkDiv : ClockDividerPorts
	generic map
	(
		CLOCK_DIVIDER => natural((real(CLOCK_FREQHZ) / ( real(BAUDRATE) * 16.0)) + 0.5)
		--~ CLOCK_DIVIDER => natural((real(CLOCK_FREQHZ) / ( real(BAUDRATE) * 16.0)))
	)
	port map
	(
		clk => clk,
		rst => rst,
		div => UartBaudClkx16
	);
	
	UartClk <= UartBaudClkx16;		
	
	--Just sync the Txd to the UartClock
	ClkSyncRxd : IBufP2Ports
	port map
	(
		clk => UartBaudClkx16,
		I => Rxd,
		O => Rxd_i
	);
	
	--The actual uart; decodes serial port data into a buffer
	Uart : UartRxRaw
	port map
	(
		Clk => UartBaudClkx16,
		Reset => rst,
		Enable => '1',
		RxD => Rxd_i,
		RxAv  => RxComplete,
		DataO => RxData--,
	);
	
end implementation;

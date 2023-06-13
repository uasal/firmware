--------------------------------------------------------------------------------
--UartRx: a uart reciever with clocks and such built-in
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity UartRxExtClk is
	port 
	(
		clk : in std_logic;
		uclk : in std_logic;
		rst : in std_logic;
		UartClk : out std_logic; --debug
		Rxd : in std_logic; --external (async) uart data input pin
		RxComplete : out std_logic; --Just got a byte
		RxData : out std_logic_vector(7 downto 0) --The byte we just got		
	);
end UartRxExtClk;

architecture implementation of UartRxExtClk is

		component IBufP2Ports is
		port 
		(
			clk : in std_logic;
			I : in std_logic;
			O : out std_logic--;
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

	UartBaudClkx16 <= uclk;
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

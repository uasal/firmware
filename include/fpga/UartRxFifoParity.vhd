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
--UartRxFifoParity: a uart reciever with clocks and such built-in
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity UartRxFifoParity is
	generic 
	(
		UART_CLOCK_FREQHZ : natural := 14745600;
		FIFO_BITS : natural := 10;
		BAUDRATE : natural := 38400--;
	);
	port 
	(
		--Outside world:
		clk : in std_logic;
		uclk : in std_logic;
		rst : in std_logic;
		
		--External (async) uart data input pin
		Rxd : in std_logic; 
		
		--Read from fifo:
		ReadFifo	: in std_logic;
		FifoReadAck : out std_logic;
		FifoReadData : out std_logic_vector(7 downto 0);
		
		--Fifo status:
		FifoFull	: out std_logic;
		FifoEmpty	: out std_logic;
		FifoCount	: out std_logic_vector(FIFO_BITS - 1 downto 0)--;		
	);
end UartRxFifoParity;

architecture implementation of UartRxFifoParity is

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
		
		component gated_fifo is
		generic 
		(
			WIDTH_BITS : natural := 32;
			DEPTH_BITS : natural := 9
		);
		port 
		(
			clk		: in std_logic;
			rst		: in std_logic;
			wone_i	: in std_logic;
			data_i	: in std_logic_vector(WIDTH_BITS - 1 downto 0);
			rone_i	: in std_logic;
			full_o	: out std_logic;
			empty_o	: out std_logic;
			data_o	: out std_logic_vector(WIDTH_BITS - 1 downto 0);
			count_o	: out std_logic_vector(DEPTH_BITS - 1 downto 0);
			r_ack : out std_logic--;
		);
		end component;
		
		component UartRxParity is
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
	signal RxComplete : std_logic; --Just got a byte
	signal RxData : std_logic_vector(7 downto 0); --The byte we just got		
	signal ReadFifo_i : std_logic; --Sync ReadFifo to clock domain
	signal WriteFifo_i : std_logic; --Sync WriteFifo to clock domain	
	
begin

	--uart needs baud*16 for it to work, this just makes one...
	UartClkDiv : ClockDividerPorts
	generic map
	(
		CLOCK_DIVIDER => natural((real(UART_CLOCK_FREQHZ) / ( real(BAUDRATE) * 16.0)) + 0.5)
	)
	port map
	(
		clk => uclk,
		rst => rst,
		div => UartBaudClkx16
	);
	
	--Just sync the Txd to the UartClock
	ClkSyncRxd : IBufP2Ports
	port map
	(
		clk => UartBaudClkx16,
		I => Rxd,
		O => Rxd_i
	);
	
	--~ --Just sync the Txd to the UartClock
	--~ ClkSyncRead : IBufP2Ports
	--~ port map
	--~ (
		--~ clk => clk,
		--~ I => ReadFifo,
		--~ O => ReadFifo_i
	--~ );
	ReadFifo_i <= ReadFifo;
	
	--The actual uart; decodes serial port data into a buffer
	Uart : UartRxParity
	port map
	(
		Clk => UartBaudClkx16,
		Reset => rst,
		Enable => '1',
		RxD => Rxd_i,
		RxAv  => RxComplete,
		DataO => RxData--,
	);
	
	--Just sync the fifo write from the usbclk to the MasterClock
	ClkSyncWrite : IBufP2Ports
	port map
	(
		clk => clk,
		I => RxComplete,
		O => WriteFifo_i
	);
	
	--Fifo holds bytes after we get them
	UartFifo : gated_fifo
	generic map
	(
		WIDTH_BITS => 8,
		DEPTH_BITS => FIFO_BITS--,
	)
	port map
	(
		clk => clk,
		rst => rst,
		wone_i => WriteFifo_i,
		data_i => RxData,
		full_o => FifoFull,
		empty_o => FifoEmpty,
		count_o => FifoCount,
		rone_i => ReadFifo_i,
		r_ack => FifoReadAck,
		data_o => FifoReadData--,
	);
	
end implementation;

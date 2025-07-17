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
--UartRxFifo: a uart reciever with clocks and such built-in
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity UartRxFifoExtClkPeek is
	generic 
	(
		DEPTH_BITS : natural := 10--;
	);
	port 
	(
		--Outside world:
		clk : in std_logic;
		uclk : in std_logic;
		rst : in std_logic;
		
		--External (async) uart data input pin
		Rxd : in std_logic; 
		
		Dbg1 : out std_logic; 
		
		--debug
		RxComplete : out std_logic;
		
		--Read from fifo:
		ReadFifo	: in std_logic;
		FifoReadAck : out std_logic;
		FifoReadData : out std_logic_vector(7 downto 0);
		
		--Fifo status:
		FifoFull	: out std_logic;
		FifoEmpty	: out std_logic;
		FifoCount	: out std_logic_vector(DEPTH_BITS - 1 downto 0);		
		
		--Fifo peeking:
		FifoReadAddr : out unsigned(DEPTH_BITS - 1 downto 0);
		FifoWriteAddr : out unsigned(DEPTH_BITS - 1 downto 0);
		FifoPeekAddr : in unsigned(DEPTH_BITS - 1 downto 0);
		FifoPeekData : out std_logic_vector(7 downto 0);
		FifoMultiPopAddr : in unsigned(DEPTH_BITS - 1 downto 0);
		FifoMultiPopStrobe : in std_logic--;		
	);
end UartRxFifoExtClkPeek;

architecture implementation of UartRxFifoExtClkPeek is

		component IBufP2Ports is
		port 
		(
			clk : in std_logic;
			I : in std_logic;
			O : out std_logic--;
		);
		end component;

		component gated_fifo_peek is
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
			raddr_o : out unsigned(DEPTH_BITS - 1 downto 0);
			waddr_o : out unsigned(DEPTH_BITS - 1 downto 0);
			peekaddr_i : in unsigned(DEPTH_BITS - 1 downto 0);
			peek_data_o	: out std_logic_vector(WIDTH_BITS - 1 downto 0);
			raddr_i : in unsigned(DEPTH_BITS - 1 downto 0);
			multipop_e_i	: in std_logic;
			r_ack : out std_logic--;
		);
		end component;
		
		component UartRxExtClk is
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
		end component;

	signal RxComplete_i : std_logic; --Just got a byte
	signal RxData : std_logic_vector(7 downto 0); --The byte we just got		
	signal ReadFifo_i : std_logic; --Sync ReadFifo to clock domain
	signal WriteFifo_i : std_logic; --Sync WriteFifo to clock domain	
	
begin

	--~ --Just sync the Txd to the UartClock
	--~ ClkSyncRead : IBufP2Ports
	--~ port map
	--~ (
		--~ clk => clk,
		--~ I => ReadFifo,
		--~ O => ReadFifo_i
	--~ );
	
	--~ Dbg1 <= RxComplete_i;
	Dbg1 <= WriteFifo_i;	
	
	ReadFifo_i <= ReadFifo;
	
	--The actual uart to grab data
	Uart : UartRxExtClk
	port map (						
		clk => clk,
		uclk => uclk,
        UartClk => open,
		rst => rst,
		Rxd => Rxd,
		RxComplete => RxComplete_i,
		RxData => RxData
	);
	
	RxComplete <= RxComplete_i;
	
	--Just sync the fifo write from the usbclk to the MasterClock
	ClkSyncWrite : IBufP2Ports
	port map
	(
		clk => clk,
		I => RxComplete_i,
		O => WriteFifo_i
	);
	
	--Fifo holds bytes after we get them
	UartFifo : gated_fifo
	generic map
	(
		WIDTH_BITS => 8,
		DEPTH_BITS => DEPTH_BITS--,
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
		data_o => FifoReadData,
		raddr_o => FifoReadAddr,
		waddr_o => FifoWriteAddr,
		peekaddr_i => FifoPeekAddr,
		peek_data_o => FifoPeekData,
		raddr_i => FifoMultiPopAddr,
		multipop_e_i => FifoMultiPopStrobe--,
	);
	
end implementation;

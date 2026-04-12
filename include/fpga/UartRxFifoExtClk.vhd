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

entity UartRxFifoExtClk is
	generic 
	(
		FIFO_BITS : natural := 10--;
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
		FifoCount	: out std_logic_vector(FIFO_BITS - 1 downto 0)--;		
	);
end UartRxFifoExtClk;

architecture implementation of UartRxFifoExtClk is

		component IBufP2Ports is
		port 
		(
			clk : in std_logic;
			I : in std_logic;
			O : out std_logic--;
		);
		end component;

		component fifo is
		generic (
			WIDTH_BITS : natural := 32;
			DEPTH_BITS : natural := 9
		);
		port (
			clk		: in std_logic;
			rst		: in std_logic;
			we_i	: in std_logic;
			data_i	: in std_logic_vector(WIDTH_BITS - 1 downto 0);
			re_i	: in std_logic;
			full_o	: out std_logic;
			empty_o	: out std_logic;
			data_o	: out std_logic_vector(WIDTH_BITS - 1 downto 0);
			count_o	: out std_logic_vector(DEPTH_BITS - 1 downto 0);
			r_ack	: out std_logic--;
		);
		end component;
		
		component UartRxExtClk is
		port 
		(
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
	signal ReadFifo_i : std_logic;
	signal WriteFifo_i : std_logic;
	-- signal WriteFifo_clean : std_logic;
	-- signal ReadFifo_clean : std_logic;

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
	-- WriteFifo_clean <= '1' when (WriteFifo_i = '1' and rst = '0') else '0';
	-- ReadFifo_clean <= '1' when (ReadFifo_i = '1' and rst = '0') else '0';
	
	--The actual uart to grab data
	Uart : UartRxExtClk
	port map (						
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
	UartFifo : fifo
	generic map
	(
		WIDTH_BITS => 8,
		DEPTH_BITS => FIFO_BITS--,
	)
	port map (
		clk => clk,
		rst => rst,
		we_i => WriteFifo_i,
		data_i => RxData,
		re_i => ReadFifo_i,
		full_o => FifoFull,
		empty_o => FifoEmpty,
		count_o => FifoCount,
		r_ack => FifoReadAck,
		data_o => FifoReadData--,
	);

end implementation;

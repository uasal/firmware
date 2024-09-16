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

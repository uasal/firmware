--  fifo.vhd
--  Parametrizable FIFO with a single clock domain
--
--  Created by Wenzel Jakob on 08/08/06.
--  Copyright 2006. All rights reserved.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_gen_tb is
end fifo_gen_tb;

architecture rtl of fifo_gen_tb is

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
		r_ack : out std_logic--;
	);
	end component;

	signal clk : std_logic := '0';
	signal rst : std_logic := '0';
	signal we_i : std_logic := '0';
	signal data_i : std_logic_vector(7 downto 0);
	signal re_i : std_logic := '0';
	signal full_o : std_logic := '0';
	signal empty_o : std_logic := '0';
	signal data_o	: std_logic_vector(7 downto 0);
	signal count_o	: std_logic_vector(7 downto 0);
	signal r_ack : std_logic := '0';

   -- Clock period definitions
   --~ constant clk_period : time := 78.125us; --12.8MHz * 4 = 51.2MHz
   constant clk_period : time := 21 ns; --12.8MHz * 4 = 51.2MHz

begin

	fifo_i : fifo
	generic map
	(
		WIDTH_BITS => 8,
		DEPTH_BITS => 8--,
	)
	port map
	(
		clk => clk,
		rst => rst,
		we_i => we_i,
		data_i => data_i,
		re_i => re_i,
		full_o => full_o,
		empty_o => empty_o,
		data_o => data_o,
		count_o => count_o,
		r_ack => r_ack--,
	);
	
	-- Clock process definitions
	clk_process :process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	-- Stimulus process
	stim_proc: process

		--~ variable l : line;
		
	begin		
   
		-- hold reset state for 100ms.
		wait for 10 us;	

		wait for clk_period*10;

		--initial values
		rst <= '1';
		wait for 10 us;	
		rst <= '0';
		
		data_i <= x"45";
		we_i <= '1';
		wait for clk_period;
		we_i <= '0';
		wait for clk_period;
		
		data_i <= x"69";
		we_i <= '1';
		wait for clk_period * 10;
		we_i <= '0';
		wait for clk_period;
		
		re_i <= '1';
		wait for clk_period;
		re_i <= '0';
		wait for clk_period;
		
		re_i <= '1';
		wait for clk_period * 4;
		re_i <= '0';
		wait for clk_period;
		
		we_i <= '1';
		wait for 10 us;	
		we_i <= '0';
		
		wait for 1 us;	
		
		re_i <= '1';
		
		wait;
	end process;

end rtl;

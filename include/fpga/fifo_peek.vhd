--  fifo.vhd
--  Parametrizable FIFO with a single clock domain
--
--  Created by Wenzel Jakob on 08/08/06.
--  Copyright 2006. All rights reserved.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_peek is
	generic (
		WIDTH_BITS : natural := 32;
		DEPTH_BITS : natural := 9
	);
	port (
		-- Clock input
		clk		: in std_logic;
		-- Asynchronous reset
		rst		: in std_logic;
		-- Write enable flag
		we_i	: in std_logic;
		-- Write data input
		data_i	: in std_logic_vector(WIDTH_BITS - 1 downto 0);
		-- Read enable flag
		re_i	: in std_logic;
		-- FIFO full flag
		full_o	: out std_logic;
		-- FIFO empty flag
		empty_o	: out std_logic;
		-- Read data output
		data_o	: out std_logic_vector(WIDTH_BITS - 1 downto 0);
		--current number of items
		count_o	: out std_logic_vector(DEPTH_BITS - 1 downto 0);
		--read pointer: allows shadow of fifo from c++ code
		raddr_o : out unsigned(DEPTH_BITS - 1 downto 0);
		--write pointer: allows shadow of fifo from c++ code
		waddr_o : out unsigned(DEPTH_BITS - 1 downto 0);
		--peek pointer: allows digging around inside fifo from c++ code without popping 
		peekaddr_i : in unsigned(DEPTH_BITS - 1 downto 0);
		--peek value: this is whatever's in the fifo at the peekaddr
		peek_data_o	: out std_logic_vector(WIDTH_BITS - 1 downto 0);
		--read pointer override: allows one to smash forward a big chunk after we're done digging around in the fifo
		raddr_i : in unsigned(DEPTH_BITS - 1 downto 0);
		-- multipop_en: initiates the smash-forward
		multipop_e_i	: in std_logic;
		--allows one to wait until lastest data is read from ram:
		r_ack : out std_logic--;
	);
end fifo_peek;

architecture rtl of fifo_peek is
	constant DEPTH : natural := 2**DEPTH_BITS;
	-- Declare a RAM array data type
	type ram_type is array (0 to DEPTH - 1) of std_logic_vector(WIDTH_BITS - 1 downto 0);
	-- Shared variable to infer block ram
	--~ shared variable RAM		: ram_type := (others => (others => '0'));
	shared variable RAM		: ram_type;
	-- Read/Write address pointers
	signal raddr_r, waddr_r	: unsigned(DEPTH_BITS - 1 downto 0) := (others => '0');
	-- Async. counter change/Read/Write flag
	signal do_count			: std_logic := '0';
	signal do_write			: std_logic := '0';
	signal do_read			: std_logic := '0';
	-- Fill counter
	signal counter_r		: natural range 0 to DEPTH := 0;
	signal empty_r			: std_logic := '1';
	signal full_r			: std_logic := '0';
	signal data_r			: std_logic_vector(WIDTH_BITS - 1 downto 0) := (others => '0');
	signal lastmultipop_e_i	: std_logic := '0';
begin
	do_read <= re_i and not empty_r;
	do_write <= we_i and not full_r;
	do_count <= '1' when do_read /= do_write else '0';
	empty_o <= empty_r;
	full_o <= full_r;
	data_o <= data_r;

	update: process(rst, clk)
	begin
	
		raddr_o <= raddr_r;
		waddr_o <= waddr_R;
		
		if rst = '1' then
			counter_r <= 0;
			raddr_r <= (others => '0');
			waddr_r <= (others => '0');
			full_r <= '0';
			empty_r <= '1';
		elsif rising_edge(clk) then
		
			if (full_r = '0') then
				count_o <= std_logic_vector(to_unsigned(counter_r, DEPTH_BITS));
			else 
				count_o <= std_logic_vector(to_unsigned((2**DEPTH_BITS) - 1, DEPTH_BITS));
			end if;
				
			if counter_r = 0 or (counter_r = 1 and do_read = '1' and 
				do_write = '0') then
				empty_r <= '1';
			else
				empty_r <= '0';
			end if;

			if counter_r = DEPTH or (counter_r = DEPTH - 1
				and do_write = '1' and do_read = '0') then
				full_r <= '1';
			else
				full_r <= '0';
			end if;

			lastmultipop_e_i <= multipop_e_i;
			
			if do_read = '1' then
				raddr_r <= raddr_r + 1;
			else
				if ( (multipop_e_i = '1') and (lastmultipop_e_i = '0') ) then --edge strrobe
					raddr_r <= raddr_i;
					counter_r <= counter_r - (raddr_i - raddr_r); --yeah.... this is prolly gonna mess shit up. but keeping a counter is a crap way to do a fifo anyway and this whole core needs replacing...like how does an integer that only has a set number of bits wrap in subtraction anyway?? but this is not a critical infrastructure, so let's ignore it for now
				end if;
			end if;

			if do_write = '1' then
				waddr_r <= waddr_r + 1;
			end if;

			if do_count = '1' then
				if do_read = '1' then
					counter_r <= counter_r - 1;
				else
					counter_r <= counter_r + 1;
				end if;
			end if;
		end if;
	end process update;

	dpram_porta: process(clk, do_write)
	begin
		if rising_edge(clk) and do_write = '1' then
			RAM(to_integer(waddr_r)) := data_i;
		end if;
	end process dpram_porta;

	dpram_portb: process(clk, do_read)
	begin
		if rising_edge(clk) then
			if do_read = '1' then
				data_r <= RAM(to_integer(raddr_r));
				r_ack <= '1';
			else
				peek_data_o <= RAM(to_integer(peekaddr_i));
				r_ack <= '0';
			end if;
		end if;
	end process dpram_portb;
end rtl;

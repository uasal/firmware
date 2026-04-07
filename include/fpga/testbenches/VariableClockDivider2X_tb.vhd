-- Same phase-decode idea as ClockDivider2X; set terminal_count to (fixed CLOCK_DIVIDER - 1) for the same rate as the generic 2X

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
use work.tb_utils_pkg.all;

entity VariableClockDivider2X_tb is
end entity VariableClockDivider2X_tb;

architecture sim of VariableClockDivider2X_tb is

	constant WIDTH_BITS : natural := 8;

	signal clk : std_logic;
	signal rst : std_logic;

	constant CLK_PERIOD : time := 10 ns;

	signal rst_count : std_logic_vector(WIDTH_BITS - 1 downto 0);
	signal terminal_count : std_logic_vector(WIDTH_BITS - 1 downto 0);

	signal clko_cfg1 : std_logic;
	signal clko_cfg2 : std_logic;

	signal test_name_display : string(1 to 40);

	constant RST_HIGH : std_logic := '1';
	constant RST_LOW : std_logic := '0';

	procedure test_divider(
		signal clko : in std_logic;
		signal clki : in std_logic;
		signal rsti : out std_logic;
		signal divider_value : std_logic_vector(WIDTH_BITS - 1 downto 0);
		signal rst_value : std_logic_vector(WIDTH_BITS - 1 downto 0);
		constant rst_state : std_logic
	) is
		variable expected_div : std_logic := not rst_state;
	begin
		reset_dut(clki, rsti);

		for j in 0 to ((to_integer(unsigned(divider_value))) / 2) - to_integer(unsigned(rst_value)) loop
			assert_equal(clko, rst_state, "Reset count state");
			wait until falling_edge(clki);
		end loop;

		assert_equal(clko, not rst_state, "Toggle after reset count");
	
		for i in 1 to 128 loop
			for k in 0 to ((to_integer(unsigned(divider_value)) / 2)) loop
				wait until falling_edge(clki);
			end loop;
			expected_div := not expected_div;
			assert_equal(clko, expected_div, "Toggle " & integer'image(i));
		end loop;
	end procedure;

begin

	clk_process : process
	begin
		clk <= '0';
		wait for CLK_PERIOD / 2;
		clk <= '1';
		wait for CLK_PERIOD / 2;
	end process;

	test_process : process
	begin

		
		rst_count <= (others => '0');
		terminal_count <= (others => '0');
	
		set_test_name(test_name_display, "Reset");
		reset_dut(clk, rst);
		assert_equal(clko_cfg1, '0', "Reset state");
		assert_equal(clko_cfg2, '1', "Reset state");

		set_test_name(test_name_display, "Test 1: TC=10 (DIV10), RST=0)");
		terminal_count <= std_logic_vector(to_unsigned(10 - 1, WIDTH_BITS));
		rst_count <= (others => '0');
		test_divider(clko_cfg1, clk, rst, terminal_count, rst_count, RST_LOW);

		set_test_name(test_name_display, "Test 2: TC=6 (DIV6), RST=0)");
		terminal_count <= std_logic_vector(to_unsigned(6 - 1, WIDTH_BITS));
		rst_count <= (others => '0');
		test_divider(clko_cfg1, clk, rst, terminal_count, rst_count, RST_LOW);

		set_test_name(test_name_display, "Test 3: TC=10 (DIV10), RST=1)");
		terminal_count <= std_logic_vector(to_unsigned(10 - 1, WIDTH_BITS));
		rst_count <= (others => '0');
		test_divider(clko_cfg2, clk, rst, terminal_count, rst_count, RST_HIGH);

		set_test_name(test_name_display, "Test 4: TC=2 (DIV1), RST=0)");
		terminal_count <= std_logic_vector(to_unsigned(2 - 1, WIDTH_BITS));
		rst_count <= (others => '0');
		test_divider(clko_cfg1, clk, rst, terminal_count, rst_count, RST_LOW);

		set_test_name(test_name_display, "Test 5: TC=2 (DIV2), RST=0)");
		terminal_count <= std_logic_vector(to_unsigned(2 - 1, WIDTH_BITS));
		rst_count <= (others => '0');
		test_divider(clko_cfg1, clk, rst, terminal_count, rst_count, RST_LOW);

		set_test_name(test_name_display, "Test 6: TC=2 (DIV2), RST=1)");
		terminal_count <= std_logic_vector(to_unsigned(2 - 1, WIDTH_BITS));
		rst_count <= (others => '0');
		test_divider(clko_cfg2, clk, rst, terminal_count, rst_count, RST_HIGH);

		set_test_name(test_name_display, "Test 7: reset count");
		rst_count <= std_logic_vector(to_unsigned(3, WIDTH_BITS));
		terminal_count <= std_logic_vector(to_unsigned(10 - 1, WIDTH_BITS));
		test_divider(clko_cfg1, clk, rst, terminal_count, rst_count, RST_LOW);

		set_test_name(test_name_display, "Test 8: reset count");
		rst_count <= std_logic_vector(to_unsigned(4, WIDTH_BITS));
		terminal_count <= std_logic_vector(to_unsigned(10 - 1, WIDTH_BITS));
		test_divider(clko_cfg2, clk, rst, terminal_count, rst_count, RST_HIGH);

		set_test_name(test_name_display, "Test 9: reset count");
		rst_count <= std_logic_vector(to_unsigned(1, WIDTH_BITS));
		terminal_count <= std_logic_vector(to_unsigned(10 - 1, WIDTH_BITS));
		test_divider(clko_cfg1, clk, rst, terminal_count, rst_count, RST_LOW);

		-- Will treat it like starting at 0 so sets to reset state
		set_test_name(test_name_display, "Test 10: reset count >= terminal_count");
		rst_count <= std_logic_vector(to_unsigned(10, WIDTH_BITS));
		terminal_count <= std_logic_vector(to_unsigned(10 - 1, WIDTH_BITS));
		reset_dut(clk, rst);
		wait until falling_edge(clk);
		for i in 0 to 4 loop
			assert_equal(clko_cfg1, '0', "Toggle " & integer'image(i));
			wait until falling_edge(clk);
		end loop;
		assert_equal(clko_cfg1, '1', "Toggle 10");

		finish;
	end process;

	dut_cfg1 : entity work.VariableClockDivider2XPorts
		generic map (
			WIDTH_BITS => WIDTH_BITS,
			DIVOUT_RST_STATE => RST_LOW
		)
		port map (
			clki => clk,
			rst => rst,
			rst_count => rst_count,
			terminal_count => terminal_count,
			clko => clko_cfg1
		);

	dut_cfg2 : entity work.VariableClockDivider2XPorts
		generic map (
			WIDTH_BITS => WIDTH_BITS,
			DIVOUT_RST_STATE => RST_HIGH
		)
		port map (
			clki => clk,
			rst => rst,
			rst_count => rst_count,
			terminal_count => terminal_count,
			clko => clko_cfg2
		);

end architecture sim;

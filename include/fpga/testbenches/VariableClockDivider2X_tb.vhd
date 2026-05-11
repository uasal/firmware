--! \brief Testbench for VariableClockDivider2X.vhd
--! Same idea as VariableClockDivider_tb.vhd, applied to the 2X implementation.
--! Checks dynamic terminal-count changes and reset recovery.

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

	signal test_name_display : string(1 to 80);

	constant RST_HIGH : std_logic := '1';
	constant RST_LOW : std_logic := '0';

	procedure expect_stable(
		signal observed : in std_logic;
		constant expected : std_logic;
		constant cycles : natural;
		constant check_name : string
	) is
	begin
		for i in 0 to cycles loop
			assert_equal(observed, expected, check_name & " cycle " & integer'image(i));
			if (i < cycles) then
				wait until falling_edge(clk);
			end if;
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
		variable expected : std_logic;
	begin	
		rst_count <= (others => '0');
		terminal_count <= (others => '0');
	
		set_test_name(test_name_display, "Reset states");
		reset_dut(clk, rst);
		assert_equal(clko_cfg1, '0', "Reset state");
		assert_equal(clko_cfg2, '1', "Reset state");
 
		set_test_name(test_name_display, "cfg1 TC=0 holds reset state");
		terminal_count <= std_logic_vector(to_unsigned(0, WIDTH_BITS));
		rst_count <= (others => '0');
		reset_dut(clk, rst);
		expect_stable(clko_cfg1, '0', 120, "cfg1 tc0 constant");

		-- low: 0,1,2,3,4 high: 5,6,7,8,9
		set_test_name(test_name_display, "cfg1 TC=9 (equiv div10)");
		terminal_count <= std_logic_vector(to_unsigned(10 - 1, WIDTH_BITS));
		rst_count <= (others => '0');
		reset_dut(clk, rst);
		expected := '0';
		for t in 1 to 30 loop
			expect_stable(clko_cfg1, expected, 4, "cfg1 hold");
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg1, expected, "cfg1 toggle " & integer'image(t));
		end loop;

		set_test_name(test_name_display, "cfg1 TC=5 (equiv div6)");
		terminal_count <= std_logic_vector(to_unsigned(6 - 1, WIDTH_BITS));
		rst_count <= (others => '0');
		reset_dut(clk, rst);
		expected := '0';
		for t in 1 to 36 loop
			expect_stable(clko_cfg1, expected, 2, "cfg1 tc5 hold");
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg1, expected, "cfg1 tc5 toggle " & integer'image(t));
		end loop;

		set_test_name(test_name_display, "cfg1 runtime retune without reset");
		terminal_count <= std_logic_vector(to_unsigned(10 - 1, WIDTH_BITS));
		rst_count <= (others => '0');
		reset_dut(clk, rst);
		expect_stable(clko_cfg1, '0', 2, "cfg1 before live retune");
		terminal_count <= std_logic_vector(to_unsigned(4 - 1, WIDTH_BITS));
		wait until falling_edge(clk);
		assert_equal(clko_cfg1, '1', "cfg1 toggles after live retune");
		expect_stable(clko_cfg1, '1', 0, "cfg1 short high window after retune");
		wait until falling_edge(clk);
		assert_equal(clko_cfg1, '0', "cfg1 retuned back low");

		set_test_name(test_name_display, "cfg2 inverted reset");
		terminal_count <= std_logic_vector(to_unsigned(10 - 1, WIDTH_BITS));
		rst_count <= (others => '0');
		reset_dut(clk, rst);
		expected := '1';
		for t in 1 to 30 loop
			expect_stable(clko_cfg2, expected, 4, "cfg2 hold");
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg2, expected, "cfg2 toggle " & integer'image(t));
		end loop;

		set_test_name(test_name_display, "cfg1 TC=1 (equiv div2)");
		terminal_count <= std_logic_vector(to_unsigned(2 - 1, WIDTH_BITS));
		rst_count <= (others => '0');
		reset_dut(clk, rst);
		expected := '0';
		for t in 1 to 80 loop
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg1, expected, "cfg1 tc1 toggle " & integer'image(t));
		end loop;

		set_test_name(test_name_display, "cfg1 TC=max decoded half-window");
		terminal_count <= std_logic_vector(to_unsigned((2**WIDTH_BITS) - 1, WIDTH_BITS));
		rst_count <= (others => '0');
		reset_dut(clk, rst);
		expect_stable(clko_cfg1, '0', 127, "cfg1 tcmax low half-window");
		wait until falling_edge(clk);
		assert_equal(clko_cfg1, '1', "cfg1 tcmax enters high half-window");
		expect_stable(clko_cfg1, '1', 20, "cfg1 tcmax high half-window");

		set_test_name(test_name_display, "cfg1 rst_count shifts phase");
		rst_count <= std_logic_vector(to_unsigned(3, WIDTH_BITS));
		terminal_count <= std_logic_vector(to_unsigned(10 - 1, WIDTH_BITS));
		reset_dut(clk, rst);
		expect_stable(clko_cfg1, '0', 1, "cfg1 rst_count hold");
		wait until falling_edge(clk);
		assert_equal(clko_cfg1, '1', "cfg1 first toggle with rst_count");

		set_test_name(test_name_display, "cfg1 rst_count > terminal_count");
		rst_count <= std_logic_vector(to_unsigned(10, WIDTH_BITS));
		terminal_count <= std_logic_vector(to_unsigned(10 - 1, WIDTH_BITS));
		reset_dut(clk, rst);
		expect_stable(clko_cfg1, '0', 4, "cfg1 starts from reset state");
		cycle_clock(clk, 10);

		set_test_name(test_name_display, "cfg2 long stress cadence");
		terminal_count <= std_logic_vector(to_unsigned(8 - 1, WIDTH_BITS));
		rst_count <= (others => '0');
		reset_dut(clk, rst);
		expected := '1';
		for t in 1 to 120 loop
			expect_stable(clko_cfg2, expected, 3, "cfg2 stress hold");
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg2, expected, "cfg2 stress toggle " & integer'image(t));
		end loop;

		set_test_name(test_name_display, "cfg1 random TC changes mid-run");
		terminal_count <= std_logic_vector(to_unsigned(10 - 1, WIDTH_BITS));
		rst_count <= (others => '0');
		reset_dut(clk, rst);
		expected := '0';
		for t in 1 to 120 loop
			expect_stable(clko_cfg1, expected, 4, "cfg1 random tc hold");
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg1, expected, "cfg1 random tc toggle " & integer'image(t));
		end loop;
		terminal_count <= std_logic_vector(to_unsigned(4 - 1, WIDTH_BITS));
		for t in 1 to 20 loop
			expect_stable(clko_cfg1, expected, 1, "cfg1 random tc change hold");
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg1, expected, "cfg1 random tc change toggle " & integer'image(t));
		end loop;	
		terminal_count <= std_logic_vector(to_unsigned(2 - 1, WIDTH_BITS));	
		for t in 1 to 20 loop
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg1, expected, "cfg1 random tc change toggle " & integer'image(t));
		end loop;
		terminal_count <= std_logic_vector(to_unsigned(40 - 1, WIDTH_BITS));
		for t in 1 to 20 loop
			expect_stable(clko_cfg1, expected, 19, "cfg1 random tc change hold");
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg1, expected, "cfg1 random tc change toggle " & integer'image(t));
		end loop;


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

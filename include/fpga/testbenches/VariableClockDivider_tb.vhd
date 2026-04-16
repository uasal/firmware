library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
use work.tb_utils_pkg.all;

entity VariableClockDivider_tb is
end entity VariableClockDivider_tb;

architecture sim of VariableClockDivider_tb is

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
	
		set_test_name(test_name_display, "Reset states");
		reset_dut(clk, rst);
		assert_equal(clko_cfg1, '0', "Reset state");
		assert_equal(clko_cfg2, '1', "Reset state");

		set_test_name(test_name_display, "cfg1 TC=0 toggles every cycle");
		terminal_count <= std_logic_vector(to_unsigned(0, WIDTH_BITS));
		rst_count <= (others => '0');
		reset_dut(clk, rst);
		expected := '0';
		for t in 1 to 80 loop
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg1, expected, "cfg1 tc0 toggle " & integer'image(t));
		end loop;

		-- low: 0,1,2,3,4,5,6,7,8,9 high: 0,1,2,3,4,5,6,7,8,9
		set_test_name(test_name_display, "cfg1 TC=10 toggle period");
		terminal_count <= std_logic_vector(to_unsigned(10, WIDTH_BITS));
		rst_count <= (others => '0');
		reset_dut(clk, rst);
		expected := '0';
		for t in 1 to 30 loop
			expect_stable(clko_cfg1, expected, 10, "cfg1 hold");
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg1, expected, "cfg1 toggle " & integer'image(t));
		end loop;

		set_test_name(test_name_display, "cfg1 TC=6 steady cadence");
		terminal_count <= std_logic_vector(to_unsigned(6, WIDTH_BITS));
		rst_count <= (others => '0');
		reset_dut(clk, rst);
		expected := '0';
		for t in 1 to 36 loop
			expect_stable(clko_cfg1, expected, 6, "cfg1 retuned hold");
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg1, expected, "cfg1 retuned toggle " & integer'image(t));
		end loop;

		set_test_name(test_name_display, "cfg1 runtime retune without reset");
		terminal_count <= std_logic_vector(to_unsigned(10, WIDTH_BITS));
		rst_count <= (others => '0');
		reset_dut(clk, rst);
		expect_stable(clko_cfg1, '0', 3, "cfg1 before live retune");
		terminal_count <= std_logic_vector(to_unsigned(3, WIDTH_BITS));
		wait until falling_edge(clk);
		assert_equal(clko_cfg1, '1', "cfg1 toggles immediately after live retune");
		expect_stable(clko_cfg1, '1', 3, "cfg1 retuned hold high");
		wait until falling_edge(clk);
		assert_equal(clko_cfg1, '0', "cfg1 retuned next toggle");

		set_test_name(test_name_display, "cfg2 inverted reset state");
		terminal_count <= std_logic_vector(to_unsigned(10, WIDTH_BITS));
		rst_count <= (others => '0');
		reset_dut(clk, rst);
		expected := '1';
		for t in 1 to 30 loop
			expect_stable(clko_cfg2, expected, 10, "cfg2 hold");
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg2, expected, "cfg2 toggle " & integer'image(t));
		end loop;

		set_test_name(test_name_display, "cfg1 TC=1 toggles every cycle");
		terminal_count <= std_logic_vector(to_unsigned(1, WIDTH_BITS));
		rst_count <= (others => '0');
		reset_dut(clk, rst);
		expected := '0';
		for t in 1 to 32 loop
			expect_stable(clko_cfg1, expected, 1, "cfg1 tc1 hold");
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg1, expected, "cfg1 tc1 toggle " & integer'image(t));
		end loop;

		set_test_name(test_name_display, "cfg1 TC=max-safe early window");
		terminal_count <= std_logic_vector(to_unsigned(((2**WIDTH_BITS) / 2) - 1, WIDTH_BITS));
		rst_count <= (others => '0');
		reset_dut(clk, rst);
		expect_stable(clko_cfg1, '0', 120, "cfg1 tcmax-safe early hold");

		set_test_name(test_name_display, "cfg1 reset_count shifts first toggle");
		rst_count <= std_logic_vector(to_unsigned(5, WIDTH_BITS));
		terminal_count <= std_logic_vector(to_unsigned(10, WIDTH_BITS));
		reset_dut(clk, rst);
		expect_stable(clko_cfg1, '0', 5, "cfg1 rst_count hold");
		wait until falling_edge(clk);
		assert_equal(clko_cfg1, '1', "cfg1 first toggle after rst_count");

		set_test_name(test_name_display, "cfg1 rst_count >= terminal_count immediate toggle");
		rst_count <= std_logic_vector(to_unsigned(10, WIDTH_BITS));
		terminal_count <= std_logic_vector(to_unsigned(10, WIDTH_BITS));
		reset_dut(clk, rst);
		assert_equal(clko_cfg1, '0', "Reset state");
		wait until falling_edge(clk);
		assert_equal(clko_cfg1, '1', "Immediate post-reset toggle");
		expect_stable(clko_cfg1, '1', 10, "Hold high after immediate toggle");
		wait until falling_edge(clk);
		assert_equal(clko_cfg1, '0', "Next toggle after full interval");

		set_test_name(test_name_display, "cfg1 long stress cadence");
		terminal_count <= std_logic_vector(to_unsigned(4, WIDTH_BITS));
		rst_count <= (others => '0');
		reset_dut(clk, rst);
		expected := '0';
		for t in 1 to 120 loop
			expect_stable(clko_cfg1, expected, 4, "cfg1 stress hold");
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg1, expected, "cfg1 stress toggle " & integer'image(t));
		end loop;

		set_test_name(test_name_display, "cfg1 random TC changes mid-run");
		terminal_count <= std_logic_vector(to_unsigned(10, WIDTH_BITS));
		rst_count <= (others => '0');
		reset_dut(clk, rst);
		expected := '0';
		for t in 1 to 120 loop
			expect_stable(clko_cfg1, expected, 10, "cfg1 random hold");
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg1, expected, "cfg1 random toggle " & integer'image(t));
		end loop;
		terminal_count <= std_logic_vector(to_unsigned(3, WIDTH_BITS));
		for t in 1 to 120 loop
			expect_stable(clko_cfg1, expected, 3, "cfg1 random retune hold");
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg1, expected, "cfg1 random retune toggle " & integer'image(t));
		end loop;
		terminal_count <= std_logic_vector(to_unsigned(7, WIDTH_BITS));
		for t in 1 to 120 loop
			expect_stable(clko_cfg1, expected, 7, "cfg1 random retune2 hold");
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg1, expected, "cfg1 random retune2 toggle " & integer'image(t));
		end loop;
		terminal_count <= std_logic_vector(to_unsigned(89, WIDTH_BITS));
		for t in 1 to 120 loop
			expect_stable(clko_cfg1, expected, 89, "cfg1 random retune3 hold");
			wait until falling_edge(clk);
			expected := not expected;
			assert_equal(clko_cfg1, expected, "cfg1 random retune3 toggle " & integer'image(t));
		end loop;

		finish;
	end process;

	dut_cfg1 : entity work.VariableClockDividerPorts
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

	dut_cfg2 : entity work.VariableClockDividerPorts
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

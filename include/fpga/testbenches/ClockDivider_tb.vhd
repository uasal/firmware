
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
use work.tb_utils_pkg.all;

entity ClockDivider_tb is
end entity ClockDivider_tb;

architecture sim of ClockDivider_tb is

	signal clk : std_logic := '0';
	signal rst : std_logic;
	
	constant CLK_PERIOD : time := 10 ns;
	
	signal div_cfg1 : std_logic;
	signal div_cfg2 : std_logic;
	signal div_cfg3 : std_logic;
	
	signal test_name_display : string(1 to 40) := (others => ' ');
	
	procedure test_divider(
		signal div : in std_logic;
		signal rst_out : out std_logic;
		constant name : string;
		constant divider_value : natural;
		constant rst_state : std_logic
	) is
		variable expected_div : std_logic := rst_state;
	begin

		wait until falling_edge(clk);
		report COLOR_YELLOW & "Testing: " & name & COLOR_RESET;

		rst_out <= '1';
		wait until falling_edge(clk);
		assert_equal(div, rst_state, "Reset state");
		
		rst_out <= '0';
		expected_div := rst_state;
		
		for i in 1 to 128 loop
			for k in 1 to (divider_value / 2) - 1 loop
				wait until falling_edge(clk);
			end loop;
			wait until falling_edge(clk);
			expected_div := expected_div;
			assert_equal(div, expected_div, "Toggle " & integer'image(i));
		end loop;
		
		rst_out <= '0';
		wait for 50 ns;
		
	end procedure;

begin

	clk_process: process
	begin
		clk <= '0';
		wait for CLK_PERIOD/2;
		clk <= '1';
		wait for CLK_PERIOD/2;
	end process;

	test_process: process
	begin
		test_name_display <= "Initializing...                         ";

		rst <= '0';
		wait for 100 ns;
		
		test_name_display <= "Test 1: Standard Config (DIV=10, RST=0) ";
		test_divider(div_cfg1, rst, test_name_display, 10, '0');
		
		test_name_display <= "Test 2: Fast Divider (DIV=6, RST=0)     ";
		test_divider(div_cfg2, rst, test_name_display, 6, '0');
		
		test_name_display <= "Test 3: Inverted Reset (DIV=10, RST=1)  ";
		test_divider(div_cfg3, rst, test_name_display, 10, '1');
		
		test_name_display <= "== All Tests Complete ==                ";
		report "All tests passed!" severity note;
		finish;
		
	end process;

	-- Clock Divider configurations, I can't easily parameterize the test procedure so making multiple, probably overkill
	-- I'm sure there's a better way to do this but this works for now
	dut_cfg1: entity work.ClockDividerPorts
		generic map (
			CLOCK_DIVIDER => 10,
			DIVOUT_RST_STATE => '0'
		)
		port map (
			clk => clk,
			rst => rst,
			div => div_cfg1
		);
	
	dut_cfg2: entity work.ClockDividerPorts
		generic map (
			CLOCK_DIVIDER => 6,
			DIVOUT_RST_STATE => '0'
		)
		port map (
			clk => clk,
			rst => rst,
			div => div_cfg2
		);
	
	dut_cfg3: entity work.ClockDividerPorts
		generic map (
			CLOCK_DIVIDER => 10,
			DIVOUT_RST_STATE => '1'
		)
		port map (
			clk => clk,
			rst => rst,
			div => div_cfg3
		);

end architecture sim;


	

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
use work.tb_utils_pkg.all;

entity OneShot_tb is
end entity OneShot_tb;

architecture sim of OneShot_tb is

    signal clk : std_logic := '0';
    signal rst : std_logic;
    signal shot_cfg1 : std_logic;
    signal shot_cfg2 : std_logic;
    signal shot_cfg3 : std_logic;
    signal shot_cfg4 : std_logic;
    signal test_name_display : string(1 to 80) := (others => ' ');
    constant CLK_PERIOD : time := 10 ns;

    procedure test_one_shot(
        signal shot : in std_logic;
        signal rst_out : out std_logic;
        constant name : string;
        constant delay_seconds : real;
        constant clock_freqhz : natural;
        constant rst_state : std_logic;
        constant pretrigger_state : std_logic
    )
    is
        variable expected_shot : std_logic := rst_state;
        constant expected_delay_cycles : natural := natural(real(clock_freqhz) * delay_seconds);
    begin

        wait until falling_edge(clk);
		report COLOR_YELLOW & "Testing: " & name & COLOR_RESET;

        rst_out <= '1';
        wait until falling_edge(clk);
        assert_equal(shot, rst_state, "Reset state");

        rst_out <= '0';
        expected_shot := rst_state;

        for i in 0 to expected_delay_cycles - 1 loop
            wait until falling_edge(clk);
            if (i < expected_delay_cycles - 1) then
                assert_equal(shot, pretrigger_state, "Pre-trigger state at cycle " & integer'image(i));
            else
                assert_equal(shot, not pretrigger_state, "Shot state at cycle " & integer'image(i));
            end if;
        end loop;

        wait until falling_edge(clk);
        assert_equal(shot, not pretrigger_state, "Post-shot state after delay");

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
        set_test_name(test_name_display, "OneShot Test 1: 1ms delay at 10MHz");
        wait for 0 ns;
        test_one_shot(
            shot => shot_cfg1,
            rst_out => rst,
            name => test_name_display,
            delay_seconds => 0.001,
            clock_freqhz => 10000000,
            rst_state => '0',
            pretrigger_state => '0'
        );

        set_test_name(test_name_display, "OneShot Test 2: 500us delay at 20MHz");
        wait for 0 ns;
        test_one_shot(
            shot => shot_cfg2,
            rst_out => rst,
            name => test_name_display,
            delay_seconds => 0.0005,
            clock_freqhz => 20000000,
            rst_state => '0',
            pretrigger_state => '0'
        );

        set_test_name(test_name_display, "OneShot Test 3: 2ms delay at 5MHz");
        wait for 0 ns;
        test_one_shot(
            shot => shot_cfg3,
            rst_out => rst,
            name => test_name_display,
            delay_seconds => 0.002,
            clock_freqhz => 5000000,
            rst_state => '0',
            pretrigger_state => '0'
        );

        set_test_name(test_name_display, "OneShot Test 4: inverted reset and pre-trigger");
        wait for 0 ns;
        test_one_shot(
            shot => shot_cfg4,
            rst_out => rst,
            name => test_name_display,
            delay_seconds => 0.001,
            clock_freqhz => 10000000,
            rst_state => '1',
            pretrigger_state => '1'
        );

        wait until falling_edge(clk);
        report "All tests passed!" severity note;
        finish;

    end process;

    dut_cfg1: entity work.OneShotPorts
        generic map (
            CLOCK_FREQHZ => 10000000,
            DELAY_SECONDS => 0.001,
            SHOT_RST_STATE => '0',
            SHOT_PRETRIGGER_STATE => '0'
        )
        port map (
            clk => clk,
            rst => rst,
            shot => shot_cfg1
        );

    dut_cfg2: entity work.OneShotPorts
        generic map (
            CLOCK_FREQHZ => 20000000,
            DELAY_SECONDS => 0.0005,
            SHOT_RST_STATE => '0',
            SHOT_PRETRIGGER_STATE => '0'
        )
        port map (
            clk => clk,
            rst => rst,
            shot => shot_cfg2
        );

    dut_cfg3: entity work.OneShotPorts
        generic map (
            CLOCK_FREQHZ => 5000000,
            DELAY_SECONDS => 0.002,
            SHOT_RST_STATE => '0',
            SHOT_PRETRIGGER_STATE => '0'
        )
        port map (
            clk => clk,
            rst => rst,
            shot => shot_cfg3
        );

    dut_cfg4: entity work.OneShotPorts
        generic map (
            CLOCK_FREQHZ => 10000000,
            DELAY_SECONDS => 0.001,
            SHOT_RST_STATE => '1',
            SHOT_PRETRIGGER_STATE => '1'
        )
        port map (
            clk => clk,
            rst => rst,
            shot => shot_cfg4
        );

end architecture sim;
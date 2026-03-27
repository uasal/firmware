library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
use work.tb_utils_pkg.all;

entity VariableOneShot_tb is
end entity VariableOneShot_tb;

architecture sim of VariableOneShot_tb is

    signal clk : std_logic;
    signal rst : std_logic;

    signal shot_cfg1 : std_logic;
    signal shot_cfg2 : std_logic;
    signal shot_cfg3 : std_logic;
    signal shot_cfg4 : std_logic;

    constant DEFAULT_WIDTH_BITS : natural := 8;
    constant MAX_DELAY_CYCLES : natural := (2**DEFAULT_WIDTH_BITS) - 1;

    signal test_name_display : string(1 to 80);
    constant CLK_PERIOD : time := 10 ns;
    signal delay_clks : std_logic_vector(DEFAULT_WIDTH_BITS - 1 downto 0);

    procedure test_one_shot(
        signal shot : in std_logic;
        signal rst_out : out std_logic;
        signal delay_clks_in : in std_logic_vector(DEFAULT_WIDTH_BITS - 1 downto 0);
        constant name : string;
        constant rst_state : std_logic;
        constant pretrigger_state : std_logic
    )
    is
        variable delay_cycles : natural;
    begin

        wait until falling_edge(clk);
		delay_cycles := to_integer(unsigned(delay_clks_in));
		report COLOR_YELLOW & "Testing: " & name & COLOR_RESET;

        rst_out <= '1';
        wait until falling_edge(clk);
        assert_equal(shot, rst_state, "Reset state");

        rst_out <= '0';

        for i in 0 to (delay_cycles) loop
            wait until falling_edge(clk);
            if (i < delay_cycles) then
                assert_equal(shot, pretrigger_state, "Pre-trigger state at cycle " & integer'image(i));
            else
                assert_equal(shot, not pretrigger_state, "Shot state at cycle " & integer'image(i));
            end if;
        end loop;

        for i in 1 to 3 loop
            wait until falling_edge(clk);
            assert_equal(shot, not pretrigger_state, "Post-shot hold state at cycle " & integer'image(i));
        end loop;

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

        delay_clks <= std_logic_vector(to_unsigned(0, DEFAULT_WIDTH_BITS));
        set_test_name(test_name_display, "cfg1 delay=0 edge case");
        test_one_shot(
            shot => shot_cfg1,
            rst_out => rst,
            delay_clks_in => delay_clks,
            name => "cfg1 delay=0 edge case",
            rst_state => '0',
            pretrigger_state => '0'
        );

        delay_clks <= std_logic_vector(to_unsigned(1, DEFAULT_WIDTH_BITS));
        set_test_name(test_name_display, "cfg1 delay=1 edge case");
        test_one_shot(
            shot => shot_cfg1,
            rst_out => rst,
            delay_clks_in => delay_clks,
            name => "cfg1 delay=1 edge case",
            rst_state => '0',
            pretrigger_state => '0'
        );

        delay_clks <= std_logic_vector(to_unsigned(10, DEFAULT_WIDTH_BITS));
        set_test_name(test_name_display, "cfg1 delay=10 nominal");
        test_one_shot(
            shot => shot_cfg1,
            rst_out => rst,
            delay_clks_in => delay_clks,
            name => "cfg1 delay=10 nominal",
            rst_state => '0',
            pretrigger_state => '0'
        );

        delay_clks <= std_logic_vector(to_unsigned(MAX_DELAY_CYCLES, DEFAULT_WIDTH_BITS));
        set_test_name(test_name_display, "cfg1 delay=max 8-bit");
        test_one_shot(
            shot => shot_cfg1,
            rst_out => rst,
            delay_clks_in => delay_clks,
            name => "cfg1 delay=max 8-bit",
            rst_state => '0',
            pretrigger_state => '0'
        );

        delay_clks <= std_logic_vector(to_unsigned(0, DEFAULT_WIDTH_BITS));
        set_test_name(test_name_display, "cfg2 delay=0 edge case");
        test_one_shot(
            shot => shot_cfg2,
            rst_out => rst,
            delay_clks_in => delay_clks,
            name => "cfg2 delay=0 edge case",
            rst_state => '1',
            pretrigger_state => '0'
        );

        delay_clks <= std_logic_vector(to_unsigned(6, DEFAULT_WIDTH_BITS));
        set_test_name(test_name_display, "cfg2 delay=6 nominal");
        test_one_shot(
            shot => shot_cfg2,
            rst_out => rst,
            delay_clks_in => delay_clks,
            name => "cfg2 delay=6 nominal",
            rst_state => '1',
            pretrigger_state => '0'
        );

        delay_clks <= std_logic_vector(to_unsigned(200, DEFAULT_WIDTH_BITS));
        set_test_name(test_name_display, "cfg2 delay=200 high");
        test_one_shot(
            shot => shot_cfg2,
            rst_out => rst,
            delay_clks_in => delay_clks,
            name => "cfg2 delay=200 high",
            rst_state => '1',
            pretrigger_state => '0'
        );

        delay_clks <= std_logic_vector(to_unsigned(1, DEFAULT_WIDTH_BITS));
        set_test_name(test_name_display, "cfg3 delay=1 edge case");
        test_one_shot(
            shot => shot_cfg3,
            rst_out => rst,
            delay_clks_in => delay_clks,
            name => "cfg3 delay=1 edge case",
            rst_state => '0',
            pretrigger_state => '1'
        );

        delay_clks <= std_logic_vector(to_unsigned(12, DEFAULT_WIDTH_BITS));
        set_test_name(test_name_display, "cfg3 delay=12 nominal");
        test_one_shot(
            shot => shot_cfg3,
            rst_out => rst,
            delay_clks_in => delay_clks,
            name => "cfg3 delay=12 nominal",
            rst_state => '0',
            pretrigger_state => '1'
        );

        delay_clks <= std_logic_vector(to_unsigned(254, DEFAULT_WIDTH_BITS));
        set_test_name(test_name_display, "cfg3 delay=254 near-max");
        test_one_shot(
            shot => shot_cfg3,
            rst_out => rst,
            delay_clks_in => delay_clks,
            name => "cfg3 delay=254 near-max",
            rst_state => '0',
            pretrigger_state => '1'
        );

        delay_clks <= std_logic_vector(to_unsigned(0, DEFAULT_WIDTH_BITS));
        set_test_name(test_name_display, "cfg4 delay=0 edge case");
        test_one_shot(
            shot => shot_cfg4,
            rst_out => rst,
            delay_clks_in => delay_clks,
            name => "cfg4 delay=0 edge case",
            rst_state => '1',
            pretrigger_state => '1'
        );

        delay_clks <= std_logic_vector(to_unsigned(3, DEFAULT_WIDTH_BITS));
        set_test_name(test_name_display, "cfg4 delay=3 nominal");
        test_one_shot(
            shot => shot_cfg4,
            rst_out => rst,
            delay_clks_in => delay_clks,
            name => "cfg4 delay=3 nominal",
            rst_state => '1',
            pretrigger_state => '1'
        );

        delay_clks <= std_logic_vector(to_unsigned(MAX_DELAY_CYCLES, DEFAULT_WIDTH_BITS));
        set_test_name(test_name_display, "cfg4 delay=max 8-bit");
        test_one_shot(
            shot => shot_cfg4,
            rst_out => rst,
            delay_clks_in => delay_clks,
            name => "cfg4 delay=max 8-bit",
            rst_state => '1',
            pretrigger_state => '1'
        );

        wait until falling_edge(clk);
        report "All tests passed!" severity note;
        finish;

    end process;

    dut_cfg1 : entity work.VariableOneShotPorts
        generic map (
            WIDTH_BITS => DEFAULT_WIDTH_BITS,
            SHOT_RST_STATE => '0',
            SHOT_PRETRIGGER_STATE => '0'
        )
        port map (
            clk => clk,
            rst => rst,
            delay_clks => delay_clks,
            shot => shot_cfg1
        );

    dut_cfg2 : entity work.VariableOneShotPorts
        generic map (
            WIDTH_BITS => DEFAULT_WIDTH_BITS,
            SHOT_RST_STATE => '1',
            SHOT_PRETRIGGER_STATE => '0'
        )
        port map (
            clk => clk,
            rst => rst,
            delay_clks => delay_clks,
            shot => shot_cfg2
        );

    dut_cfg3 : entity work.VariableOneShotPorts
        generic map (
            WIDTH_BITS => DEFAULT_WIDTH_BITS,
            SHOT_RST_STATE => '0',
            SHOT_PRETRIGGER_STATE => '1'
        )
        port map (
            clk => clk,
            rst => rst,
            delay_clks => delay_clks,
            shot => shot_cfg3
        );

    dut_cfg4 : entity work.VariableOneShotPorts
        generic map (
            WIDTH_BITS => DEFAULT_WIDTH_BITS,
            SHOT_RST_STATE => '1',
            SHOT_PRETRIGGER_STATE => '1'
        )
        port map (
            clk => clk,
            rst => rst,
            delay_clks => delay_clks,
            shot => shot_cfg4
        );
    
end architecture sim;
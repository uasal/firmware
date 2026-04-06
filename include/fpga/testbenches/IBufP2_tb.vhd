library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
use work.tb_utils_pkg.all;

entity IBufP2_tb is
end IBufP2_tb;

architecture sim of IBufP2_tb is

    signal clk : std_logic;
    signal I : std_logic;
    signal O : std_logic;

    signal test_name_display : string(1 to 80);

    constant CLK_PERIOD : time := 10 ns;

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
        set_test_name(test_name_display, "I=0");
        I <= '0';
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        assert_equal(O, '0', "O should be 0 when I is 0");

        set_test_name(test_name_display, "I=1");
        I <= '1';
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        assert_equal(O, '1', "O should be 1 when I is 1");

        set_test_name(test_name_display, "I=0");
        I <= '0';
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        assert_equal(O, '0', "O should be 0 when I is 0");

        set_test_name(test_name_display, "I=1");
        I <= '1';
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        assert_equal(O, '1', "O should be 1 when I is 1");

        finish;
    end process;

    dut : entity work.IBufP2Ports
        port map (
            clk => clk,
            I => I,
            O => O
        );

end architecture;
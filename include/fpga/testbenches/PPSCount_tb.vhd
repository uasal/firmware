library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
use work.tb_utils_pkg.all;

entity PPSCount_tb is
end entity PPSCount_tb;

architecture sim of PPSCount_tb is

    signal clk : std_logic := '0';
    signal rst : std_logic;
    signal PPS : std_logic;
    signal PPSDetected : std_logic;
    signal PPSCounter : std_logic_vector(31 downto 0);
    signal PPSAccum : std_logic_vector(31 downto 0);
    signal test_name_display : string(1 to 80) := (others => ' ');
    constant CLK_PERIOD : time := 10 ns;

    procedure test_pps_count(
        signal PPS_out : out std_logic;
        signal rst_out : out std_logic;
        signal PPSDetected_in : in std_logic;
        signal PPSCounter_in : in std_logic_vector(31 downto 0);
        signal PPSAccum_in : in std_logic_vector(31 downto 0);
        constant name : string
    ) is
    begin
        wait until falling_edge(clk);
        report COLOR_YELLOW & "Testing: " & name & COLOR_RESET;
        rst_out <= '1';
        wait until falling_edge(clk);
        assert_equal(PPSDetected_in, '0', "PPS Detected should be 0 after reset");
        assert_equal(PPSCounter_in, x"00000000", "PPS Counter should be 0 after reset");
        assert_equal(PPSAccum_in, x"00000000", "PPS Accum should be 0 after reset");
        rst_out <= '0';
        wait until falling_edge(clk);
        report COLOR_YELLOW & "  First PPS edge (post-reset): PPSAccum must always be discarded" & COLOR_RESET;
        PPS_out <= '1';
        wait until falling_edge(clk);
        assert_equal(PPSDetected_in, '1', "PPS Detected should be 1 after first PPS edge");
        assert_equal(PPSCounter_in, x"00000000", "PPS Counter should reset to 0 on first rising edge");
        wait until falling_edge(clk);
        assert_equal(PPSAccum_in, x"00000000", "INVARIANT: PPSAccum always 0 after first post-reset edge");
        assert_equal(PPSCounter_in, x"00000001", "PPS Counter should be 1 (one clock since rising edge)");
        
        report COLOR_YELLOW & "  PPS low period (10 clocks): counter accumulates, latch unchanged" & COLOR_RESET;
        PPS_out <= '0';
        -- Wait 10 clocks while PPS is low to allow counter to accumulate
        for i in 1 to 10 loop
            wait until falling_edge(clk);
        end loop;
        assert_equal(PPSDetected_in, '1', "PPS Detected should remain 1 (sticky) before reset");
        assert_equal(PPSCounter_in, x"0000000A", "PPS Counter should have incremented to 10");
        assert_equal(PPSAccum_in, x"00000000", "PPSAccum unchanged: only updates on rising PPS edge");

        -- Second rising edge: InvalidatePPSCount is now '0', so this edge latches a real count
        report COLOR_YELLOW & "  Second PPS edge: first valid latch (count + 2 compensation)" & COLOR_RESET;
        PPS_out <= '1';
        wait until falling_edge(clk);
        assert_equal(PPSDetected_in, '1', "PPS Detected should be 1 after second PPS edge");
        assert_equal(PPSCounter_in, x"00000000", "PPS Counter should reset to 0 after second rising edge");
        
        wait until falling_edge(clk);
        assert_equal(PPSAccum_in, x"0000000C", "PPSAccum latches PPSAccum_i + 2 (10 clocks + 2 edge compensaton = 12)");
        
        PPS_out <= '0';
        -- Wait 15 clocks while PPS is low
        for i in 1 to 15 loop
            wait until falling_edge(clk);
        end loop;
        assert_equal(PPSDetected_in, '1', "PPS Detected should remain 1 (sticky)");
        assert_equal(PPSCounter_in, x"0000000F", "PPS Counter should have incremented to 15");
        assert_equal(PPSAccum_in, x"0000000C", "PPS Accum should still hold previous latched value");

        -- Reset to clear sticky PPSDetected flag
        rst_out <= '1';
        wait until falling_edge(clk);
        assert_equal(PPSDetected_in, '0', "PPS Detected should be 0 after reset");
        rst_out <= '0';
        wait until falling_edge(clk);

    end procedure;

begin

    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    test_process: process
    begin

        set_test_name(test_name_display, "Reset Test");
        report COLOR_YELLOW & "Testing: Reset Test" & COLOR_RESET;
        PPS <= '0';
        wait until falling_edge(clk);
        rst <= '1';
        wait until falling_edge(clk);
        assert_equal(PPSDetected, '0', "PPS Detected should be 0 after reset");
        assert_equal(PPSCounter, x"00000000", "PPS Counter should be 0 after reset");
        assert_equal(PPSAccum, x"00000000", "PPS Accum should be 0 after reset");
        rst <= '0';
        wait until falling_edge(clk);

        set_test_name(test_name_display, "Basic PPS Count Test");
        test_pps_count(
            PPS_out => PPS,
            rst_out => rst,
            PPSDetected_in => PPSDetected,
            PPSCounter_in => PPSCounter,
            PPSAccum_in => PPSAccum,
            name => "Basic PPS Count Test"
        );

        finish;

    end process;

    dut: entity work.PPSCountPorts
        port map (
            clk => clk,
            PPS => PPS,
            PPSReset => rst,
            PPSDetected => PPSDetected,
            PPSCounter => PPSCounter,
            PPSAccum => PPSAccum
        );

    end architecture sim;
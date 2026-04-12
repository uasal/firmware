library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
use work.tb_utils_pkg.all;

entity UartRxExtClk_tb is
end UartRxExtClk_tb;

architecture sim of UartRxExtClk_tb is

    signal uclk : std_logic;
    signal rst : std_logic;
    signal UartClk : std_logic;
    signal Rxd : std_logic;
    signal RxComplete : std_logic;
    signal RxData : std_logic_vector(7 downto 0);

    signal clk : std_logic;

    signal test_name_display : string(1 to 80);

    constant BAUDRATE : natural := 38400;
    constant UCLK_PERIOD : time := 1 sec / (BAUDRATE * 16);
    constant CLK_PERIOD : time := 1 sec / BAUDRATE;
    constant BIT_CYCLES : natural := 16;

    procedure send_byte_timed(
        signal Rxd_o : out std_logic;
        constant b : in std_logic_vector(7 downto 0);
        constant cycles_per_bit : in natural := 16;
        constant pre_idle_cycles : in natural := 16;
        constant stop_cycles : in natural := 16
    ) is
    begin

        -- start bit
        Rxd_o <= '0';
        wait until falling_edge(clk);
        assert_equal(RxComplete, '0', "RxComplete should be 0 after start bit");

        -- data bits, LSB first
        for i in 0 to 7 loop
            Rxd_o <= byte_bit(b, i);
            wait until falling_edge(clk);
        end loop;

        assert_equal(RxComplete, '0', "RxComplete should be 0 after sending byte");

        -- stop bit
        Rxd_o <= '1';
        wait until falling_edge(clk);

        assert_equal(RxComplete, '1', "RxComplete should be 1 after sending byte");
        assert_equal(RxData, b, "RxData should be " & to_hstring(b) & " after sending byte");
    end procedure;


begin

    uclk_process : process
    begin
        uclk <= '0';
        wait for UCLK_PERIOD / 2;
        uclk <= '1';
        wait for UCLK_PERIOD / 2;
    end process;

    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    test_process : process
    begin
        set_test_name(test_name_display, "Reset");
        Rxd <= '1';
        reset_dut(uclk, rst);
        wait until rising_edge(uclk);
        assert_equal(RxComplete, '0', "RxComplete should be 0 after reset");
        assert_equal(RxData, x"00", "RxData should be 0 after reset");


        set_test_name(test_name_display, "Test 1: Basic operation");
        send_byte_timed(Rxd, x"55");
        assert_equal(RxComplete, '1', "RxComplete should be 1 after byte");
        assert_equal(RxData, x"55", "RxData should be 0x55 after byte");


        set_test_name(test_name_display, "Back-to-back bytes");
        send_byte_timed(Rxd, x"55");
        send_byte_timed(Rxd, x"AA");
        send_byte_timed(Rxd, x"FF");
        send_byte_timed(Rxd, x"00");


        set_test_name(test_name_display, "Stress Test: All Byte Values");
        for i in 0 to 255 loop
            send_byte_timed(Rxd, std_logic_vector(to_unsigned(i, 8)));
        end loop;


        set_test_name(test_name_display, "Hold old RxData until new byte completes");
        send_byte_timed(Rxd, x"FF");
        assert_equal(RxData, x"FF", "RxData should hold previous byte");
        Rxd <= '0';
        wait until falling_edge(clk);
        assert_equal(RxComplete, '0', "RxComplete should drop during next frame");
        assert_equal(RxData, x"FF", "RxData should still hold old byte before next completion");
        Rxd <= '1';
        wait until RxComplete = '1';

                
        set_test_name(test_name_display, "Reset during reception");
        Rxd <= '1';
        wait until falling_edge(clk);
        Rxd <= '0';
        wait until falling_edge(clk);
        Rxd <= '1';
        wait until falling_edge(clk);
        Rxd <= '0';
        wait until falling_edge(clk);
        Rxd <= '1'; -- Rxd must go low before reset so it isn't fed into the IBuf2 which could mimic a RX start bit
        reset_dut(clk, rst);
        assert_equal(RxComplete, '0', "RxComplete should be 0 after mid-byte reset");


        set_test_name(test_name_display, "Break condition");
        Rxd <= '0';
        cycle_clock(clk, 9);

        Rxd <= '0';
        cycle_clock(uclk, 16); -- finish stop bit without it showing
        assert_equal(RxComplete, '0', "RxComplete should be 0 after break condition");
        assert_equal(RxData, x"00", "RxData should be 0 after sending byte");


        set_test_name(test_name_display, "RxComplete should assert after byte");
        wait until falling_edge(clk);
        -- reset_dut(clk, rst);
        send_byte_timed(Rxd, x"55");
        assert_equal(RxComplete, '1', "RxComplete should assert");
        wait until rising_edge(uclk);
        assert_equal(RxComplete, '1', "RxComplete should still be 1 after byte");

        finish;
    end process;

    dut : entity work.UartRxExtClk
        port map (
            uclk => uclk,
            rst => rst,
            UartClk => UartClk,
            Rxd => Rxd,
            RxComplete => RxComplete,
            RxData => RxData
        );

end architecture sim;


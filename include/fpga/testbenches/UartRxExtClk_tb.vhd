--! \brief Testbench for UartRxExtClk.vhd
--! Same coverage style as UartRx_tb.vhd, but with external clocking.
--! Also checks ext-clock-specific stop-bit timing thresholds.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
use work.tb_utils_pkg.all;

entity UartRxExtClk_tb is
end UartRxExtClk_tb;

architecture sim of UartRxExtClk_tb is

    signal clk : std_logic;
    signal bit_clk : std_logic;
    signal uclk : std_logic;
    signal rst : std_logic;
    signal UartClk : std_logic;
    signal Rxd : std_logic;
    signal RxComplete : std_logic;
    signal RxData : std_logic_vector(7 downto 0);

    signal test_name_display : string(1 to 80);

    constant BAUDRATE : natural := 38400;
    constant CLK_PERIOD : time := 1 sec / (BAUDRATE * 32);
    constant BIT_CLK_PERIOD : time := 1 sec / BAUDRATE;
    constant UCLK_PERIOD : time := 1 sec / (BAUDRATE * 16);
    constant UART_SAMPLES_PER_BIT : natural := 16;

    procedure send_byte(
        signal Rxd_o : out std_logic;
        constant b : in std_logic_vector(7 downto 0);
        constant cycles_per_bit : in natural := UART_SAMPLES_PER_BIT;
        constant pre_idle_cycles : in natural := UART_SAMPLES_PER_BIT;
        constant stop_cycles : in natural := UART_SAMPLES_PER_BIT
    ) is
    begin
        Rxd_o <= '1';
        cycle_clock(uclk, pre_idle_cycles);
        Rxd_o <= '0';
        cycle_clock(uclk, cycles_per_bit);
        assert_equal(RxComplete, '0', "RxComplete should be 0 after start bit");
        for i in 0 to 7 loop
            Rxd_o <= byte_bit(b, i);
            cycle_clock(uclk, cycles_per_bit);
        end loop;

        assert_equal(RxComplete, '0', "RxComplete should be 0 after sending byte");
        Rxd_o <= '1';
        cycle_clock(uclk, stop_cycles);

        assert_equal(RxComplete, '1', "RxComplete should be 1 after sending byte");
        assert_equal(RxData, b, "RxData should be " & to_hstring(b) & " after sending byte");
    end procedure;


begin

    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    bit_clk_process : process
    begin
        bit_clk <= '0';
        wait for BIT_CLK_PERIOD / 2;
        bit_clk <= '1';
        wait for BIT_CLK_PERIOD / 2;
    end process;

    uclk_process : process
    begin
        uclk <= '0';
        wait for UCLK_PERIOD / 2;
        uclk <= '1';
        wait for UCLK_PERIOD / 2;
    end process;

    test_process : process
    begin
        set_test_name(test_name_display, "Reset");
        Rxd <= '1';
        reset_dut(uclk, rst);
        assert_equal(RxComplete, '0', "RxComplete should be 0 after reset");
        assert_equal(RxData, x"00", "RxData should be 0 after reset");


        set_test_name(test_name_display, "Test 1: Basic operation");
        send_byte(Rxd, x"55");
        assert_equal(RxComplete, '1', "RxComplete should be 1 after byte");
        assert_equal(RxData, x"55", "RxData should be 0x55 after byte");


        set_test_name(test_name_display, "Back-to-back bytes");
        send_byte(Rxd, x"55");
        send_byte(Rxd, x"AA");
        send_byte(Rxd, x"FF");
        send_byte(Rxd, x"00");


        set_test_name(test_name_display, "Stress Test: All Byte Values");
        for i in 0 to 255 loop
            send_byte(Rxd, std_logic_vector(to_unsigned(i, 8)));
        end loop;


        set_test_name(test_name_display, "Hold old RxData until new byte completes");
        send_byte(Rxd, x"FF");
        assert_equal(RxData, x"FF", "RxData should hold previous byte");
        Rxd <= '0';
        cycle_clock(uclk, UART_SAMPLES_PER_BIT);
        assert_equal(RxComplete, '0', "RxComplete should drop during next frame");
        assert_equal(RxData, x"FF", "RxData should still hold old byte before next completion");
        Rxd <= '1';
        cycle_clock(uclk, 200);

                
        set_test_name(test_name_display, "Reset during reception");
        Rxd <= '1';
        cycle_clock(uclk, UART_SAMPLES_PER_BIT);
        Rxd <= '0';
        cycle_clock(uclk, UART_SAMPLES_PER_BIT);
        Rxd <= '1';
        cycle_clock(uclk, UART_SAMPLES_PER_BIT);
        Rxd <= '0';
        cycle_clock(uclk, UART_SAMPLES_PER_BIT);
        Rxd <= '1'; -- Rxd must go low before reset so it isn't fed into the IBuf2 which could mimic a RX start bit
        reset_dut(uclk, rst);
        assert_equal(RxComplete, '0', "RxComplete should be 0 after mid-byte reset");


        set_test_name(test_name_display, "Break condition");
        Rxd <= '0';
        cycle_clock(uclk, 9 * UART_SAMPLES_PER_BIT);
        Rxd <= '0';
        cycle_clock(uclk, UART_SAMPLES_PER_BIT); -- finish stop bit without it showing
        assert_equal(RxComplete, '0', "RxComplete should be 0 after break condition");
        assert_equal(RxData, x"00", "RxData should be 0 after sending byte");

        set_test_name(test_name_display, "Early stop-bit (SampleCnt >= 3)");
        reset_dut(uclk, rst);
        Rxd <= '0';
        cycle_clock(uclk, UART_SAMPLES_PER_BIT);
        for i in 0 to 7 loop
            Rxd <= byte_bit(x"A5", i);
            cycle_clock(uclk, UART_SAMPLES_PER_BIT);
        end loop;
        Rxd <= '1';
        cycle_clock(uclk, 3);
        assert_equal(RxComplete, '0', "RxComplete should be 0 during early stop bit");
        assert_equal(RxData, x"00", "RxData should not update during early stop bit");
        Rxd <= '1';
        cycle_clock(uclk, UART_SAMPLES_PER_BIT - 3);
        assert_equal(RxComplete, '1', "RxComplete should assert after stop window");
        assert_equal(RxData, x"A5", "RxData should be 0xA5");


        set_test_name(test_name_display, "Stop-bit reject if low through SampleCnt >= 13");
        reset_dut(uclk, rst);
        Rxd <= '1';

        Rxd <= '0';
        cycle_clock(uclk, UART_SAMPLES_PER_BIT);
        for i in 0 to 7 loop
            Rxd <= byte_bit(x"5A", i);
            cycle_clock(uclk, UART_SAMPLES_PER_BIT);
        end loop;
        Rxd <= '0';
        cycle_clock(uclk, UART_SAMPLES_PER_BIT);
        cycle_clock(uclk, UART_SAMPLES_PER_BIT);
        assert_equal(RxComplete, '0', "RxComplete should stay 0 when stop bit is missing too long");
        assert_equal(RxData, x"00", "RxData should not update when stop bit is missing too long");

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


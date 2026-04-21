library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
use work.tb_utils_pkg.all;

entity UartRXRaw_tb is
end UartRXRaw_tb;

architecture sim of UartRXRaw_tb is

    signal clk : std_logic;
    signal rst : std_logic;
    signal Enable : std_logic;
    signal RxD : std_logic;
    signal RxAv : std_logic;
    signal DataO : std_logic_vector(7 downto 0);

    signal test_name_display : string(1 to 80);

    constant CLK_PERIOD : time := 10 ns;
    constant UART_SAMPLES_PER_BIT : natural := 16;

    procedure send_byte(
        signal RxD_o : out std_logic;
        constant b : in std_logic_vector(7 downto 0);
        constant cycles_per_bit : in natural := UART_SAMPLES_PER_BIT;
        constant pre_idle_cycles : in natural := UART_SAMPLES_PER_BIT;
        constant stop_cycles : in natural := UART_SAMPLES_PER_BIT
    ) is
    begin
        RxD_o <= '1';
        cycle_clock(clk, pre_idle_cycles);

        RxD_o <= '0';
        cycle_clock(clk, cycles_per_bit);

        for i in 0 to 7 loop
            RxD_o <= byte_bit(b, i);
            cycle_clock(clk, cycles_per_bit);
        end loop;

        RxD_o <= '1';
        cycle_clock(clk, stop_cycles);
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
        set_test_name(test_name_display, "Reset");
        Enable <= '0';
        RxD <= '1';
        reset_dut(clk, rst);
        assert_equal(RxAv, '0', "RxAv should be 0 after reset");
        assert_equal(DataO, x"00", "DataO should be 0 after reset");

        set_test_name(test_name_display, "Enable=0 ignores RxD");
        RxD <= '0';
        cycle_clock(clk, UART_SAMPLES_PER_BIT * 8);
        assert_equal(RxAv, '0', "RxAv should remain 0 when disabled");
        assert_equal(DataO, x"00", "DataO should remain 0 when disabled");
        RxD <= '1';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);

        set_test_name(test_name_display, "Receive bytes (basic patterns)");
        Enable <= '1';
        assert_equal(RxAv, '0', "RxAv starts low");

        send_byte(RxD, x"55");
        assert_equal(DataO, x"55", "DataO = 0x55 after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive (sticky until next frame)");

        RxD <= '1';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);
        RxD <= '0';
        cycle_clock(clk, 2);
        assert_equal(RxAv, '0', "RxAv clears quickly after byte begins");
        cycle_clock(clk, UART_SAMPLES_PER_BIT - 2);
        for i in 0 to 7 loop
            RxD <= byte_bit(x"00", i);
            cycle_clock(clk, UART_SAMPLES_PER_BIT);
        end loop;
        RxD <= '1';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);
        assert_equal(DataO, x"00", "DataO = 0x00 after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive");

        send_byte(RxD, x"FF");
        assert_equal(DataO, x"FF", "DataO = 0xFF after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive");

        send_byte(RxD, x"01");
        assert_equal(DataO, x"01", "DataO = 0x01 after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive");

        send_byte(RxD, x"80");
        assert_equal(DataO, x"80", "DataO = 0x80 after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive");

        set_test_name(test_name_display, "Baud mismatch");
        reset_dut(clk, rst);
        Enable <= '1';
        RxD <= '1';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);

        send_byte(RxD, x"C3", cycles_per_bit => 15);
        assert_equal(DataO, x"C3", "DataO = 0xC3 after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive");

        reset_dut(clk, rst);
        cycle_clock(clk, UART_SAMPLES_PER_BIT);

        send_byte(RxD, x"3C", cycles_per_bit => 17);
        assert_equal(DataO, x"3C", "DataO = 0x3C after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive");

        reset_dut(clk, rst);
        cycle_clock(clk, UART_SAMPLES_PER_BIT);

        -- the FF bits and long  cause it to end early (so FE)
        send_byte(RxD, x"FF", cycles_per_bit => 24);
        assert_equal(DataO, x"FE", "DataO = 0x00 after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive");

        reset_dut(clk, rst);
        cycle_clock(clk, UART_SAMPLES_PER_BIT);

        -- the clocks are too short so intentional no RxAv
        send_byte(RxD, x"FF", cycles_per_bit => 5);
        assert_equal(DataO, x"00", "DataO = 0x00 after receive");
        assert_equal(RxAv, '0', "RxAv asserted after receive");

        set_test_name(test_name_display, "SampleCnt=7 sampling point");
        reset_dut(clk, rst);
        Enable <= '1';
        RxD <= '1';
        assert_equal(RxAv, '0', "RxAv low after reset");
        -- each data bit is wrong except around the SampleCnt=7 instant.
        RxD <= '1';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);
        RxD <= '0';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);
        for i in 0 to 7 loop
            RxD <= not byte_bit(x"A5", i);
            cycle_clock(clk, 7);
            RxD <= byte_bit(x"A5", i);
            cycle_clock(clk, 2);
            RxD <= not byte_bit(x"A5", i);
            cycle_clock(clk, 7);
        end loop;
        RxD <= '1';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);
        assert_equal(DataO, x"A5", "Captured data matches value at SampleCnt=7");
        assert_equal(RxAv, '1', "RxAv asserted after receive");

        set_test_name(test_name_display, "Stop bit accept if high by SampleCnt>=3");
        reset_dut(clk, rst);
        Enable <= '1';
        RxD <= '1';
        send_byte(RxD, x"3C", cycles_per_bit => UART_SAMPLES_PER_BIT, pre_idle_cycles => UART_SAMPLES_PER_BIT, stop_cycles => 0);
        RxD <= '0';
        cycle_clock(clk, 3);
        RxD <= '1';
        cycle_clock(clk, UART_SAMPLES_PER_BIT - 3);
        assert_equal(DataO, x"3C", "DataO updated when stop bit becomes high early");
        assert_equal(RxAv, '1', "RxAv asserted when stop bit becomes high early");

        set_test_name(test_name_display, "Stop bit reject if low through SampleCnt>=13");
        reset_dut(clk, rst);
        Enable <= '1';
        RxD <= '1';
        send_byte(RxD, x"5A", cycles_per_bit => UART_SAMPLES_PER_BIT, pre_idle_cycles => UART_SAMPLES_PER_BIT, stop_cycles => 0);
        RxD <= '0';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);
        cycle_clock(clk, UART_SAMPLES_PER_BIT);

        assert_equal(RxAv, '0', "RxAv should stay 0 when stop bit missing too long");
        assert_equal(DataO, x"00", "DataO should not update when stop bit missing too long");

        set_test_name(test_name_display, "Back-to-back bytes with minimal legal gap");
        reset_dut(clk, rst);
        Enable <= '1';
        RxD <= '1';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);
        send_byte(RxD, x"12", pre_idle_cycles => UART_SAMPLES_PER_BIT, stop_cycles => UART_SAMPLES_PER_BIT);
        send_byte(RxD, x"34", pre_idle_cycles => 0);
        assert_equal(DataO, x"34", "DataO should match second tightly packed byte");
        assert_equal(RxAv, '1', "RxAv should assert after second tightly packed byte");

        set_test_name(test_name_display, "Reset during active frame");
        reset_dut(clk, rst);
        Enable <= '1';
        RxD <= '1';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);
        RxD <= '0';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);
        for i in 0 to 2 loop
            RxD <= byte_bit(x"A9", i);
            cycle_clock(clk, UART_SAMPLES_PER_BIT);
        end loop;
        reset_dut(clk, rst);
        assert_equal(RxAv, '0', "RxAv should clear on reset during frame");
        assert_equal(DataO, x"00", "DataO should clear on reset during frame");

        finish;
    end process;

    dut : entity work.UartRxRaw
        port map (
            Clk => clk,
            Reset => rst,
            Enable => Enable,
            RxD => RxD,
            RxAv => RxAv,
            DataO => DataO
        );
end architecture;
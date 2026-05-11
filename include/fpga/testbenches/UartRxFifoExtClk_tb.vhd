--! \brief Testbench for UartRxFifoExtClk.vhd
--! FIFO integration after the interface swap.
--! Single/burst/overlap traffic, read-while-write behavior, and drain ordering.
--! Full/empty boundaries plus resets with buffered data and active frames.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
use work.tb_utils_pkg.all;

entity UartRxFifoExtClk_tb is
end UartRxFifoExtClk_tb;

architecture sim of UartRxFifoExtClk_tb is

    -- Match UartRx.vhd defaults
    constant CLOCK_FREQHZ : natural := 14745600;
    constant BAUDRATE : natural := 38400;
    constant FIFO_BITS : natural := 10; -- match UartRxFifoExtClk default

    constant CLK_PERIOD : time := 1 sec / CLOCK_FREQHZ;
    constant BIT_CLK_PERIOD : time := 1 sec / BAUDRATE;
    constant UCLK_PERIOD : time := 1 sec / (BAUDRATE * 16);

    signal clk : std_logic;
    signal bit_clk : std_logic;
    signal uclk : std_logic;

    signal rst : std_logic;
    signal Rxd : std_logic;
    signal Dbg1 : std_logic;

    signal RxComplete : std_logic;
    signal ReadFifo : std_logic;
    signal FifoReadAck : std_logic;
    signal FifoReadData : std_logic_vector(7 downto 0);
    signal FifoFull : std_logic;
    signal FifoEmpty : std_logic;
    signal FifoCount : std_logic_vector(FIFO_BITS - 1 downto 0);

    signal test_name_display : string(1 to 80);

    -- Drive Rxd in the UART oversample clock domain (same idea as UartRxExtClk_tb).
    constant UART_SAMPLES_PER_BIT : natural := 16;

    procedure send_byte(
        signal Rxd_o : out std_logic;
        constant b : in std_logic_vector(7 downto 0)
    ) is
    begin
        Rxd_o <= '0';
        cycle_clock(uclk, UART_SAMPLES_PER_BIT);
        for i in 0 to 7 loop
            Rxd_o <= byte_bit(b, i);
            cycle_clock(uclk, UART_SAMPLES_PER_BIT);
        end loop;
        Rxd_o <= '1';
        cycle_clock(uclk, UART_SAMPLES_PER_BIT);
        wait until falling_edge(bit_clk);
    end procedure;

    procedure read_fifo(
        signal re_out : out std_logic;
        signal ack_in : in std_logic
    ) is
    begin
        wait until falling_edge(bit_clk);
        re_out <= '1';
        while (ack_in /= '1') loop
            wait until falling_edge(bit_clk);
        end loop;
        assert_equal(ack_in, '1', "FifoReadAck should be 1 when FIFO read is acknowledged");
        re_out <= '0';
        wait until falling_edge(bit_clk);
    end procedure;

    procedure settle_after_uart is
    begin
        wait until falling_edge(bit_clk);
        wait until falling_edge(bit_clk);
        wait until falling_edge(bit_clk);
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
        ReadFifo <= '0';
        Rxd <= '1';

        set_test_name(test_name_display, "Reset");
        reset_dut(bit_clk, rst);
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 after reset");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after reset");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(0, FIFO_BITS)), "FifoCount should be 0 after reset");
        assert_equal(RxComplete, '0', "RxComplete should be 0 after reset");
        assert_equal(FifoReadAck, '0', "FifoReadAck should be 0 after reset");
        assert_equal(FifoReadData, x"00", "FifoReadData should be 0 after reset");

        set_test_name(test_name_display, "Receive Byte 0xA5");
        send_byte(Rxd, x"A5");
        settle_after_uart;
        assert_equal(FifoEmpty, '0', "FifoEmpty should be 0 after receiving byte");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after receiving one byte");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(1, FIFO_BITS)), "FifoCount should be 1 after receiving one byte");
        assert_equal(FifoReadData, x"00", "FifoReadData should still be 0 before reading from FIFO");
        assert_equal(FifoReadAck, '0', "FifoReadAck should be 0 before reading from FIFO");

        read_fifo(ReadFifo, FifoReadAck);
        assert_equal(FifoReadData, x"A5", "FifoReadData should be 0xA5 after read");
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 after read");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after read");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(0, FIFO_BITS)), "FifoCount should be 0 after read");

        set_test_name(test_name_display, "Back-to-back receives");
        send_byte(Rxd, x"11");
        send_byte(Rxd, x"22");
        send_byte(Rxd, x"33");
        settle_after_uart;
        assert_equal(FifoCount, std_logic_vector(to_unsigned(3, FIFO_BITS)), "FifoCount should be 3 after three receives");
        assert_equal(FifoEmpty, '0', "FifoEmpty should be 0 after three receives");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after three receives");

        read_fifo(ReadFifo, FifoReadAck);
        assert_equal(FifoReadData, x"11", "FifoReadData should be 0x11 after first read");
        assert_equal(FifoEmpty, '0', "FifoEmpty should be 0 after first read");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after first read");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(2, FIFO_BITS)), "FifoCount should be 2 after first read");

        read_fifo(ReadFifo, FifoReadAck);
        assert_equal(FifoReadData, x"22", "FifoReadData should be 0x22 after second read");
        assert_equal(FifoEmpty, '0', "FifoEmpty should be 0 after second read");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after second read");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(1, FIFO_BITS)), "FifoCount should be 1 after second read");

        set_test_name(test_name_display, "Read while send is in progress");
        wait until falling_edge(bit_clk);
        ReadFifo <= '1';
        send_byte(Rxd, x"44");
        wait until falling_edge(bit_clk);
        wait until falling_edge(bit_clk);
        while (FifoReadAck /= '1') loop
            wait until falling_edge(bit_clk);
        end loop;
        wait until falling_edge(bit_clk);
        ReadFifo <= '0';
        assert_equal(FifoReadData, x"33", "FifoReadData should pop oldest byte during overlap");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(1, FIFO_BITS)), "FifoCount should remain 1 after overlap read/write");
        assert_equal(FifoEmpty, '0', "FifoEmpty should be 0 after overlap read/write");

        read_fifo(ReadFifo, FifoReadAck);
        assert_equal(FifoReadData, x"44", "FifoReadData should be 0x44 after overlap follow-up read");
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 after overlap follow-up read");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after overlap follow-up read");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(0, FIFO_BITS)), "FifoCount should be 0 after overlap follow-up read");

        set_test_name(test_name_display, "Simultaneous FIFO read/write");
        send_byte(Rxd, x"55");
        settle_after_uart;
        assert_equal(FifoCount, std_logic_vector(to_unsigned(1, FIFO_BITS)), "FifoCount should be 1 before simultaneous FIFO read/write");

        send_byte(Rxd, x"66");
        wait until falling_edge(bit_clk);
        ReadFifo <= '1';
        wait until falling_edge(bit_clk);
        assert_equal(FifoCount, std_logic_vector(to_unsigned(1, FIFO_BITS)), "FifoCount should remain 1 when FIFO read and write overlap");
        while (FifoReadAck /= '1') loop
            wait until falling_edge(bit_clk);
        end loop;
        wait until falling_edge(bit_clk);
        ReadFifo <= '0';
        assert_equal(FifoReadData, x"55", "FifoReadData should pop older byte during simultaneous FIFO read/write");
        assert_equal(FifoEmpty, '0', "FifoEmpty should be 0 after simultaneous FIFO read/write");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after simultaneous FIFO read/write");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(1, FIFO_BITS)), "FifoCount should be 1 after simultaneous FIFO read/write");

        read_fifo(ReadFifo, FifoReadAck);
        assert_equal(FifoReadData, x"66", "FifoReadData should be 0x66 after simultaneous FIFO read/write follow-up");
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 after simultaneous FIFO read/write follow-up");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after simultaneous FIFO read/write follow-up");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(0, FIFO_BITS)), "FifoCount should be 0 after simultaneous FIFO read/write follow-up");

        set_test_name(test_name_display, "Read when empty");
        wait until falling_edge(bit_clk);
        ReadFifo <= '1';
        wait until falling_edge(bit_clk);
        wait until falling_edge(bit_clk);
        assert_equal(FifoReadAck, '0', "FifoReadAck should stay 0 when reading empty FIFO");
        ReadFifo <= '0';
        assert_equal(FifoCount, std_logic_vector(to_unsigned(0, FIFO_BITS)), "FifoCount should stay 0 when reading empty FIFO");
        assert_equal(FifoEmpty, '1', "FifoEmpty should stay 1 when reading empty FIFO");

        set_test_name(test_name_display, "Reset while FIFO has data");
        send_byte(Rxd, x"66");
        send_byte(Rxd, x"77");
        settle_after_uart;
        assert_equal(FifoCount, std_logic_vector(to_unsigned(2, FIFO_BITS)), "FifoCount should be 2 before reset");
        reset_dut(bit_clk, rst);
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 after reset");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after reset");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(0, FIFO_BITS)), "FifoCount should be 0 after reset");
        assert_equal(FifoReadAck, '0', "FifoReadAck should be 0 after reset");

        set_test_name(test_name_display, "Receive after mid reset");
        send_byte(Rxd, x"99");
        settle_after_uart;
        read_fifo(ReadFifo, FifoReadAck);
        assert_equal(FifoReadData, x"99", "FifoReadData should be 0x99 after post-reset read");
        for i in 0 to 100 loop
            wait until falling_edge(bit_clk);
        end loop;
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 after post-reset read");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after post-reset read");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(0, FIFO_BITS)), "FifoCount should be 0 after post-reset read");

        set_test_name(test_name_display, "Fill FIFO to full then drain");
        reset_dut(bit_clk, rst);
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 before full-fill burst");
        for wi in 0 to (2 ** FIFO_BITS) - 1 loop
            send_byte(Rxd, std_logic_vector(to_unsigned(wi mod 256, 8)));
        end loop;
        settle_after_uart;
        settle_after_uart;
        assert_equal(FifoFull, '1', "FifoFull should be 1 when FIFO is full");
        assert_equal(FifoEmpty, '0', "FifoEmpty should be 0 when FIFO is full");
        assert_equal(FifoCount, std_logic_vector(to_unsigned((2 ** FIFO_BITS) - 1, FIFO_BITS)), "FifoCount should be DEPTH-1 when FIFO is full");

        set_test_name(test_name_display, "Receive when FIFO full (extra byte dropped)");
        send_byte(Rxd, x"AB");
        settle_after_uart;
        assert_equal(FifoFull, '1', "FifoFull should stay 1 after write while full");
        assert_equal(FifoCount, std_logic_vector(to_unsigned((2 ** FIFO_BITS) - 1, FIFO_BITS)), "FifoCount should not grow when writing while full");

        set_test_name(test_name_display, "Drain full FIFO in order");
        read_fifo(ReadFifo, FifoReadAck);
        assert_equal(FifoReadData, x"00", "First drained byte should be 0x00");
        while (FifoEmpty = '0') loop
            read_fifo(ReadFifo, FifoReadAck);
        end loop;
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 after draining full FIFO");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(0, FIFO_BITS)), "FifoCount should be 0 after draining full FIFO");

        set_test_name(test_name_display, "Reset during UART frame");
        Rxd <= '1';
        cycle_clock(uclk, UART_SAMPLES_PER_BIT);
        Rxd <= '0';
        cycle_clock(uclk, UART_SAMPLES_PER_BIT);
        Rxd <= '1';
        cycle_clock(uclk, UART_SAMPLES_PER_BIT);
        Rxd <= '0';
        cycle_clock(uclk, UART_SAMPLES_PER_BIT);
        Rxd <= '1';
        reset_dut(bit_clk, rst);
        assert_equal(RxComplete, '0', "RxComplete should be 0 after reset during frame");
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 after reset during frame");

        finish;
    end process;

    dut : entity work.UartRxFifoExtClk
        generic map (
            FIFO_BITS => FIFO_BITS
        )
        port map (
            clk => bit_clk,
            uclk => uclk,
            rst => rst,
            Rxd => Rxd,
            Dbg1 => Dbg1,
            RxComplete => RxComplete,
            ReadFifo => ReadFifo,
            FifoReadAck => FifoReadAck,
            FifoReadData => FifoReadData,
            FifoFull => FifoFull,
            FifoEmpty => FifoEmpty,
            FifoCount => FifoCount
        );

end architecture sim;

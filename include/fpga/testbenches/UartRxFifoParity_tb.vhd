library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
use work.tb_utils_pkg.all;

entity UartRxFifoParity_tb is
end UartRxFifoParity_tb;

architecture sim of UartRxFifoParity_tb is

    constant CLOCK_FREQHZ : natural := 14745600;
    constant BAUDRATE : natural := 38400;
    constant FIFO_BITS : natural := 10;

    constant CLK_PERIOD : time := 1 sec / CLOCK_FREQHZ;
    constant BIT_CLK_PERIOD : time := 1 sec / BAUDRATE;
    constant UCLK_PERIOD : time := 1 sec / CLOCK_FREQHZ;
    constant UART_SAMPLES_PER_BIT : natural := CLOCK_FREQHZ / BAUDRATE;

    signal clk : std_logic;
    signal bit_clk : std_logic;
    signal uclk : std_logic;

    signal rst : std_logic;
    signal Rxd : std_logic;

    signal ReadFifo : std_logic;
    signal FifoReadAck : std_logic;
    signal FifoReadData : std_logic_vector(7 downto 0);
    signal FifoFull : std_logic;
    signal FifoEmpty : std_logic;
    signal FifoCount : std_logic_vector(FIFO_BITS - 1 downto 0);

    signal test_name_display : string(1 to 80);

    signal PARITY_EVEN : std_logic;

    function parity(data_i : std_logic_vector(7 downto 0); parity_even_i : std_logic) return std_logic is
        variable parity_bit : std_logic := '0';
    begin
        for i in 0 to 7 loop
            parity_bit := parity_bit xor data_i(i);
        end loop;
        if (parity_even_i = '1') then
            return parity_bit;
        else
            return not(parity_bit);
        end if;
    end function;

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
        for i in 0 to 7 loop
            Rxd_o <= byte_bit(b, i);
            cycle_clock(uclk, cycles_per_bit);
        end loop;
        Rxd_o <= parity(b, PARITY_EVEN);
        cycle_clock(uclk, cycles_per_bit);
        Rxd_o <= '1';
        cycle_clock(uclk, stop_cycles);
        wait until falling_edge(bit_clk);
    end procedure;

    procedure send_frame_with_parity_bit(
        signal Rxd_o : out std_logic;
        constant b : in std_logic_vector(7 downto 0);
        constant parity_bit : in std_logic;
        constant cycles_per_bit : in natural := UART_SAMPLES_PER_BIT;
        constant pre_idle_cycles : in natural := UART_SAMPLES_PER_BIT;
        constant stop_cycles : in natural := UART_SAMPLES_PER_BIT
    ) is
    begin
        Rxd_o <= '1';
        cycle_clock(uclk, pre_idle_cycles);

        Rxd_o <= '0';
        cycle_clock(uclk, cycles_per_bit);
        for i in 0 to 7 loop
            Rxd_o <= byte_bit(b, i);
            cycle_clock(uclk, cycles_per_bit);
        end loop;
        Rxd_o <= parity_bit;
        cycle_clock(uclk, cycles_per_bit);
        Rxd_o <= '1';
        cycle_clock(uclk, stop_cycles);
        wait until falling_edge(bit_clk);
    end procedure;

    procedure read_fifo(
        signal re_out : out std_logic;
        signal ack_in : in std_logic
    ) is
        variable guard_cycles : natural := 0;
    begin
        wait until falling_edge(clk);
        re_out <= '1';
        while (ack_in /= '1') loop
            wait until falling_edge(clk);
            guard_cycles := guard_cycles + 1;
            exit when guard_cycles > 4096;
        end loop;
        assert_equal(ack_in, '1', "FifoReadAck should be 1 when FIFO read is acknowledged");
        re_out <= '0';
        wait until falling_edge(clk);
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
        PARITY_EVEN <= '1';
        ReadFifo <= '0';
        Rxd <= '1';

        set_test_name(test_name_display, "Reset");
        reset_dut(bit_clk, rst);
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 after reset");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after reset");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(0, FIFO_BITS)), "FifoCount should be 0 after reset");
        assert_equal(FifoReadAck, '0', "FifoReadAck should be 0 after reset");
        assert_equal(FifoReadData, x"00", "FifoReadData should be 0 after reset");

        set_test_name(test_name_display, "Receive good parity byte");
        send_byte(Rxd, x"A5");
        settle_after_uart;
        assert_equal(FifoEmpty, '0', "FifoEmpty should be 0 after receiving byte");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after receiving one byte");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(1, FIFO_BITS)), "FifoCount should be 1 after receiving one byte");

        read_fifo(ReadFifo, FifoReadAck);
        assert_equal(FifoReadData, x"A5", "FifoReadData should be 0xA5 after read");
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 after read");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(0, FIFO_BITS)), "FifoCount should be 0 after read");

        set_test_name(test_name_display, "Back-to-back good parity receives");
        send_byte(Rxd, x"11");
        send_byte(Rxd, x"22");
        send_byte(Rxd, x"33");
        settle_after_uart;
        assert_equal(FifoCount, std_logic_vector(to_unsigned(3, FIFO_BITS)), "FifoCount should be 3 after three receives");
        assert_equal(FifoEmpty, '0', "FifoEmpty should be 0 after three receives");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after three receives");

        read_fifo(ReadFifo, FifoReadAck);
        assert_equal(FifoReadData, x"11", "FifoReadData should be 0x11 after first read");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(2, FIFO_BITS)), "FifoCount should be 2 after first read");

        read_fifo(ReadFifo, FifoReadAck);
        assert_equal(FifoReadData, x"22", "FifoReadData should be 0x22 after second read");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(1, FIFO_BITS)), "FifoCount should be 1 after second read");

        set_test_name(test_name_display, "Read while good frame is in progress");
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
        assert_equal(FifoCount, std_logic_vector(to_unsigned(0, FIFO_BITS)), "FifoCount should be 0 after overlap follow-up read");

        set_test_name(test_name_display, "Bad parity frame is dropped");
        send_frame_with_parity_bit(Rxd, x"5A", not parity(x"5A", PARITY_EVEN));
        settle_after_uart;
        assert_equal(FifoEmpty, '1', "FifoEmpty should remain 1 after bad parity frame");
        assert_equal(FifoFull, '0', "FifoFull should remain 0 after bad parity frame");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(0, FIFO_BITS)), "FifoCount should stay 0 after bad parity frame");
        assert_equal(FifoReadAck, '0', "FifoReadAck should remain 0 after bad parity frame");

        set_test_name(test_name_display, "Good-bad-good parity sequence");
        send_byte(Rxd, x"AA");
        send_frame_with_parity_bit(Rxd, x"BB", not parity(x"BB", PARITY_EVEN));
        send_byte(Rxd, x"CC");
        settle_after_uart;
        assert_equal(FifoCount, std_logic_vector(to_unsigned(2, FIFO_BITS)), "FifoCount should only include good-parity frames");
        assert_equal(FifoEmpty, '0', "FifoEmpty should be 0 after good-bad-good sequence");

        read_fifo(ReadFifo, FifoReadAck);
        assert_equal(FifoReadData, x"AA", "First read should return first good frame");
        read_fifo(ReadFifo, FifoReadAck);
        assert_equal(FifoReadData, x"CC", "Second read should return second good frame");
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 after reading only good-parity frames");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(0, FIFO_BITS)), "FifoCount should be 0 after reading only good-parity frames");

        set_test_name(test_name_display, "Read while bad frame is in progress");
        send_byte(Rxd, x"D1");
        settle_after_uart;
        assert_equal(FifoCount, std_logic_vector(to_unsigned(1, FIFO_BITS)), "FifoCount should be 1 before bad-frame overlap");

        wait until falling_edge(bit_clk);
        ReadFifo <= '1';
        send_frame_with_parity_bit(Rxd, x"E2", not parity(x"E2", PARITY_EVEN));
        wait until falling_edge(bit_clk);
        wait until falling_edge(bit_clk);
        while (FifoReadAck /= '1') loop
            wait until falling_edge(bit_clk);
        end loop;
        wait until falling_edge(bit_clk);
        ReadFifo <= '0';
        assert_equal(FifoReadData, x"D1", "Read should pop existing byte during bad-frame overlap");
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 because bad frame was dropped");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(0, FIFO_BITS)), "FifoCount should be 0 after read overlaps dropped bad frame");

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

        set_test_name(test_name_display, "Write full with good parity");
        for i in 0 to (2 ** FIFO_BITS) - 1 loop
            send_byte(Rxd, std_logic_vector(to_unsigned(i mod 256, 8)));
        end loop;
        settle_after_uart;
        assert_equal(FifoFull, '1', "FifoFull should be 1 after writing full");
        assert_equal(FifoEmpty, '0', "FifoEmpty should be 0 after writing full");
        assert_equal(FifoCount, std_logic_vector(to_unsigned((2 ** FIFO_BITS) - 1, FIFO_BITS)), "FifoCount should be DEPTH-1 after writing full");

        set_test_name(test_name_display, "Write while full with good parity");
        send_byte(Rxd, x"88");
        settle_after_uart;
        assert_equal(FifoFull, '1', "FifoFull should stay 1 after writing while full");
        assert_equal(FifoCount, std_logic_vector(to_unsigned((2 ** FIFO_BITS) - 1, FIFO_BITS)), "FifoCount should not grow when writing while full");

        set_test_name(test_name_display, "Drain full FIFO in order");
        read_fifo(ReadFifo, FifoReadAck);
        assert_equal(FifoReadData, x"00", "First drained byte should be 0x00");
        while (FifoEmpty = '0') loop
            read_fifo(ReadFifo, FifoReadAck);
        end loop;

        set_test_name(test_name_display, "Write full with bad parity");
        for i in 0 to (2 ** FIFO_BITS) - 1 loop
            send_frame_with_parity_bit(Rxd, std_logic_vector(to_unsigned(i mod 256, 8)), not parity(std_logic_vector(to_unsigned(i mod 256, 8)), PARITY_EVEN));
        end loop;
        settle_after_uart;
        assert_equal(FifoFull, '0', "FifoFull should be 0 after writing full");
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 after writing full");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(0, FIFO_BITS)), "FifoCount should be 0 after writing full");

        finish;
    end process;

    dut : entity work.UartRxFifoParity
        generic map (
            UART_CLOCK_FREQHZ => CLOCK_FREQHZ,
            FIFO_BITS => FIFO_BITS,
            BAUDRATE => BAUDRATE
        )
        port map (
            clk => clk,
            uclk => uclk,
            rst => rst,
            Rxd => Rxd,
            ReadFifo => ReadFifo,
            FifoReadAck => FifoReadAck,
            FifoReadData => FifoReadData,
            FifoFull => FifoFull,
            FifoEmpty => FifoEmpty,
            FifoCount => FifoCount
        );

end architecture sim;

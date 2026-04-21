library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
use work.tb_utils_pkg.all;
use work.CGraphTypes.all;

entity UartRxFifoExtClkPeek_tb is
end UartRxFifoExtClkPeek_tb;

architecture sim of UartRxFifoExtClkPeek_tb is

    constant CLOCK_FREQHZ : natural := 14745600;
    constant BAUDRATE : natural := 38400;
    constant UART_SAMPLES_PER_BIT : natural := 16;

    constant CLK_PERIOD : time := 1 sec / CLOCK_FREQHZ;
    constant BIT_CLK_PERIOD : time := 1 sec / BAUDRATE;
    constant UCLK_PERIOD : time := 1 sec / (BAUDRATE * 16);

    signal clk : std_logic;
    signal bit_clk : std_logic;
    signal uclk : std_logic;

    signal rst : std_logic;
    signal Rxd : std_logic;

    signal Dbg1 : std_logic;
    signal Dbg2 : std_logic;
    signal Dbg3 : std_logic;

    signal RxComplete : std_logic;
    signal ReadFifo : std_logic;
    signal FifoReadAck : std_logic;
    signal FifoReadData : std_logic_vector(7 downto 0);

    signal FifoFull : std_logic;
    signal FifoEmpty : std_logic;
    signal FifoCount : std_logic_vector(PeekRamDepth - 1 downto 0);

    signal FifoReadAddr : std_logic_vector(PeekRamDepth - 1 downto 0);
    signal FifoWriteAddr : std_logic_vector(PeekRamDepth - 1 downto 0);
    signal FifoPeekAddr : std_logic_vector(PeekRamDepth - 1 downto 0);
    signal FifoPeekData : std_logic_vector(7 downto 0);
    signal FifoMultiPopAddr : std_logic_vector(PeekRamDepth - 1 downto 0);
    signal FifoMultiPopStrobe : std_logic;

    signal test_name_display : string(1 to 80);

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

    procedure settle_after_uart is
    begin
        wait until falling_edge(bit_clk);
        wait until falling_edge(bit_clk);
        wait until falling_edge(bit_clk);
    end procedure;

    procedure pop_to(
        signal addr_out : out std_logic_vector(PeekRamDepth - 1 downto 0);
        signal strobe_out : out std_logic;
        constant addr : in natural
    ) is
    begin
        wait until falling_edge(bit_clk);
        addr_out <= std_logic_vector(to_unsigned(addr, PeekRamDepth));
        strobe_out <= '1';
        wait until falling_edge(bit_clk);
        strobe_out <= '0';
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
        FifoPeekAddr <= (others => '0');
        FifoMultiPopAddr <= (others => '0');
        FifoMultiPopStrobe <= '0';

        set_test_name(test_name_display, "Reset");
        reset_dut(bit_clk, rst);
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 after reset");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after reset");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(0, PeekRamDepth)), "FifoCount should be 0 after reset");
        assert_equal(FifoReadAddr, std_logic_vector(to_unsigned(0, PeekRamDepth)), "FifoReadAddr should be 0 after reset");
        assert_equal(FifoWriteAddr, std_logic_vector(to_unsigned(0, PeekRamDepth)), "FifoWriteAddr should be 0 after reset");

        set_test_name(test_name_display, "Receive 3 bytes and peek");
        send_byte(Rxd, x"A5");
        send_byte(Rxd, x"5A");
        send_byte(Rxd, x"33");
        settle_after_uart;
        assert_equal(FifoEmpty, '0', "FifoEmpty should be 0 after three receives");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after three receives");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(3, PeekRamDepth)), "FifoCount should be 3 after three receives");
        assert_equal(FifoReadAddr, std_logic_vector(to_unsigned(0, PeekRamDepth)), "FifoReadAddr should stay at 0 before pop");
        assert_equal(FifoWriteAddr, std_logic_vector(to_unsigned(3, PeekRamDepth)), "FifoWriteAddr should advance to 3 after three receives");

        FifoPeekAddr <= std_logic_vector(to_unsigned(0, PeekRamDepth));
        wait until falling_edge(bit_clk);
        assert_equal(FifoPeekData, x"A5", "Peek addr 0 should be first byte");
        FifoPeekAddr <= std_logic_vector(to_unsigned(1, PeekRamDepth));
        wait until falling_edge(bit_clk);
        assert_equal(FifoPeekData, x"5A", "Peek addr 1 should be second byte");
        FifoPeekAddr <= std_logic_vector(to_unsigned(2, PeekRamDepth));
        wait until falling_edge(bit_clk);
        assert_equal(FifoPeekData, x"33", "Peek addr 2 should be third byte");

        set_test_name(test_name_display, "Multi-pop to address 1");
        pop_to(FifoMultiPopAddr, FifoMultiPopStrobe, 1);
        assert_equal(FifoCount, std_logic_vector(to_unsigned(2, PeekRamDepth)), "FifoCount should drop to 2 after pop-to-1");
        assert_equal(FifoReadAddr, std_logic_vector(to_unsigned(1, PeekRamDepth)), "FifoReadAddr should move to 1 after pop-to-1");
        assert_equal(FifoEmpty, '0', "FifoEmpty should stay 0 after pop-to-1");
        FifoPeekAddr <= std_logic_vector(to_unsigned(1, PeekRamDepth));
        wait until falling_edge(bit_clk);
        assert_equal(FifoPeekData, x"5A", "Peek addr 1 should now be oldest byte");
        FifoPeekAddr <= std_logic_vector(to_unsigned(2, PeekRamDepth));
        wait until falling_edge(bit_clk);
        assert_equal(FifoPeekData, x"33", "Peek addr 2 should still hold last byte");

        set_test_name(test_name_display, "Multi-pop to write address (empty)");
        pop_to(FifoMultiPopAddr, FifoMultiPopStrobe, 3);
        assert_equal(FifoCount, std_logic_vector(to_unsigned(0, PeekRamDepth)), "FifoCount should be 0 after pop to write addr");
        assert_equal(FifoReadAddr, std_logic_vector(to_unsigned(3, PeekRamDepth)), "FifoReadAddr should match write addr when empty");
        assert_equal(FifoWriteAddr, std_logic_vector(to_unsigned(3, PeekRamDepth)), "FifoWriteAddr should remain 3 after pop-only");
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 after pop to write addr");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after pop to write addr");

        set_test_name(test_name_display, "Receive after pop/empty");
        send_byte(Rxd, x"7E");
        settle_after_uart;
        assert_equal(FifoCount, std_logic_vector(to_unsigned(1, PeekRamDepth)), "FifoCount should be 1 after post-pop receive");
        assert_equal(FifoReadAddr, std_logic_vector(to_unsigned(3, PeekRamDepth)), "FifoReadAddr should stay at 3 until pop");
        assert_equal(FifoWriteAddr, std_logic_vector(to_unsigned(4, PeekRamDepth)), "FifoWriteAddr should advance to 4");
        FifoPeekAddr <= std_logic_vector(to_unsigned(3, PeekRamDepth));
        wait until falling_edge(bit_clk);
        assert_equal(FifoPeekData, x"7E", "Peek addr 3 should show post-pop byte");

        set_test_name(test_name_display, "Pop while UART write is in progress");
        wait until falling_edge(bit_clk);
        FifoMultiPopAddr <= FifoWriteAddr;
        FifoMultiPopStrobe <= '1';
        wait until falling_edge(bit_clk);
        FifoMultiPopStrobe <= '0';
        wait until falling_edge(bit_clk);
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 before overlap setup");

        send_byte(Rxd, x"10");
        send_byte(Rxd, x"20");
        settle_after_uart;
        assert_equal(FifoCount, std_logic_vector(to_unsigned(2, PeekRamDepth)), "FifoCount should be 2 before pop/write overlap");
        assert_equal(FifoReadAddr, std_logic_vector(to_unsigned(4, PeekRamDepth)), "FifoReadAddr should be 4 before pop/write overlap");
        assert_equal(FifoWriteAddr, std_logic_vector(to_unsigned(6, PeekRamDepth)), "FifoWriteAddr should be 6 before pop/write overlap");

        wait until falling_edge(bit_clk);
        FifoMultiPopAddr <= std_logic_vector(to_unsigned(5, PeekRamDepth));
        FifoMultiPopStrobe <= '1';
        send_byte(Rxd, x"30");
        wait until falling_edge(bit_clk);
        FifoMultiPopStrobe <= '0';
        settle_after_uart;
        assert_equal(FifoReadAddr, std_logic_vector(to_unsigned(5, PeekRamDepth)), "FifoReadAddr should advance once during overlap");
        assert_equal(FifoWriteAddr, std_logic_vector(to_unsigned(7, PeekRamDepth)), "FifoWriteAddr should advance by one during overlap");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(2, PeekRamDepth)), "FifoCount should remain 2 after one pop and one write overlap");
        FifoPeekAddr <= std_logic_vector(to_unsigned(5, PeekRamDepth));
        wait until falling_edge(bit_clk);
        assert_equal(FifoPeekData, x"20", "Peek oldest should be 0x20 after overlap");
        FifoPeekAddr <= std_logic_vector(to_unsigned(6, PeekRamDepth));
        wait until falling_edge(bit_clk);
        assert_equal(FifoPeekData, x"30", "Peek next should be 0x30 after overlap");

        set_test_name(test_name_display, "Write and pop at same time");
        wait until falling_edge(bit_clk);
        FifoMultiPopAddr <= FifoWriteAddr;
        FifoMultiPopStrobe <= '1';
        wait until falling_edge(bit_clk);
        FifoMultiPopStrobe <= '0';
        wait until falling_edge(bit_clk);
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 before simultaneous high test");

        send_byte(Rxd, x"AA");
        settle_after_uart;
        assert_equal(FifoCount, std_logic_vector(to_unsigned(1, PeekRamDepth)), "FifoCount should be 1 before write/pop test");
        assert_equal(FifoReadAddr, std_logic_vector(to_unsigned(7, PeekRamDepth)), "FifoReadAddr should be 7 before write/pop test");
        assert_equal(FifoWriteAddr, std_logic_vector(to_unsigned(8, PeekRamDepth)), "FifoWriteAddr should be 8 before write/pop test");

        -- do a write, then pop immediately (no settle_after_uart). A pop and a write are happening at the same time here
        send_byte(Rxd, x"DD");
        wait until falling_edge(bit_clk);
        FifoMultiPopAddr <= std_logic_vector(to_unsigned(8, PeekRamDepth));
        FifoMultiPopStrobe <= '1';
        wait until falling_edge(bit_clk);
        FifoMultiPopStrobe <= '0';
        settle_after_uart;

        assert_equal(FifoReadAddr, std_logic_vector(to_unsigned(8, PeekRamDepth)), "FifoReadAddr should advance by one due to pop");
        assert_equal(FifoWriteAddr, std_logic_vector(to_unsigned(9, PeekRamDepth)), "FifoWriteAddr should advance by one due to write");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(1, PeekRamDepth)), "FifoCount should stay the same when pop and write overlap");
        FifoPeekAddr <= FifoReadAddr;
        wait until falling_edge(bit_clk);
        assert_equal(FifoPeekData, x"DD", "Oldest byte should be the newly written byte after overlap");

        set_test_name(test_name_display, "Fill to full then pop to empty with peeks");
        wait until falling_edge(bit_clk);
        FifoMultiPopAddr <= FifoWriteAddr;
        FifoMultiPopStrobe <= '1';
        wait until falling_edge(bit_clk);
        FifoMultiPopStrobe <= '0';
        wait until falling_edge(bit_clk);
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 before full-fill test");
        assert_equal(FifoReadAddr, std_logic_vector(to_unsigned(9, PeekRamDepth)), "FifoReadAddr should be 9 before fill");
        assert_equal(FifoWriteAddr, std_logic_vector(to_unsigned(9, PeekRamDepth)), "FifoWriteAddr should be 9 before fill");

        for wi in 0 to (2 ** PeekRamDepth) - 2 loop
            send_byte(Rxd, std_logic_vector(to_unsigned(wi mod 256, 8)));
        end loop;
        settle_after_uart;
        settle_after_uart;
        assert_equal(FifoFull, '1', "FifoFull should be 1 after fill");
        assert_equal(FifoEmpty, '0', "FifoEmpty should be 0 after fill");
        -- near full wrap
        assert_equal(FifoReadAddr, std_logic_vector(to_unsigned(9, PeekRamDepth)), "FifoReadAddr should stay at start after fill");
        assert_equal(FifoWriteAddr, std_logic_vector(to_unsigned(8, PeekRamDepth)), "FifoWriteAddr should be start+DEPTH-1 after fill");

        FifoPeekAddr <= std_logic_vector(to_unsigned(9, PeekRamDepth));
        wait until falling_edge(bit_clk);
        assert_equal(FifoPeekData, x"00", "Peek addr 9 should be 0x00 after fill");
        FifoPeekAddr <= std_logic_vector(to_unsigned(10, PeekRamDepth));
        wait until falling_edge(bit_clk);
        assert_equal(FifoPeekData, x"01", "Peek addr 10 should be 0x01 after fill");
        FifoPeekAddr <= std_logic_vector(to_unsigned(7, PeekRamDepth));
        wait until falling_edge(bit_clk);
        assert_equal(FifoPeekData, x"FE", "Peek tail addr 7 should be 0xFE after fill");

        pop_to(FifoMultiPopAddr, FifoMultiPopStrobe, 7);
        assert_equal(FifoReadAddr, std_logic_vector(to_unsigned(7, PeekRamDepth)), "FifoReadAddr should move to midpoint pop");
        assert_equal(FifoEmpty, '0', "FifoEmpty should stay 0 after midpoint pop");
        FifoPeekAddr <= std_logic_vector(to_unsigned(7, PeekRamDepth));
        wait until falling_edge(bit_clk);
        assert_equal(FifoPeekData, x"FE", "Peek at midpoint addr 7 should be 0xFE");
        FifoPeekAddr <= std_logic_vector(to_unsigned(6, PeekRamDepth));
        wait until falling_edge(bit_clk);
        assert_equal(FifoPeekData, x"FD", "Peek near tail addr 6 should be 0xFD");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(1, PeekRamDepth)), "FifoCount should be 1 before final pop-to-empty");

        pop_to(FifoMultiPopAddr, FifoMultiPopStrobe, 8);
        assert_equal(FifoReadAddr, std_logic_vector(to_unsigned(8, PeekRamDepth)), "FifoReadAddr should move to write boundary after final pop");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(0, PeekRamDepth)), "FifoCount should be 0 after final pop-to-empty");
        assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 after final pop-to-empty");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after final pop-to-empty");

        finish;
    end process;

    dut : entity work.UartRxFifoExtClkPeek
        port map (
            clk => bit_clk,
            uclk => uclk,
            rst => rst,
            Rxd => Rxd,
            Dbg1 => Dbg1,
            Dbg2 => Dbg2,
            Dbg3 => Dbg3,
            RxComplete => RxComplete,
            ReadFifo => ReadFifo,
            FifoReadAck => FifoReadAck,
            FifoReadData => FifoReadData,
            FifoFull => FifoFull,
            FifoEmpty => FifoEmpty,
            FifoCount => FifoCount,
            FifoReadAddr => FifoReadAddr,
            FifoWriteAddr => FifoWriteAddr,
            FifoPeekAddr => FifoPeekAddr,
            FifoPeekData => FifoPeekData,
            FifoMultiPopAddr => FifoMultiPopAddr,
            FifoMultiPopStrobe => FifoMultiPopStrobe
        );

end architecture sim;

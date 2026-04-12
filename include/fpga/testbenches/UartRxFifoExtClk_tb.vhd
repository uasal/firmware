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
    constant UCLK_PERIOD : time := 1 sec / (BAUDRATE * 16);
    constant BIT_CLK_PERIOD : time := 1 sec / BAUDRATE;

    signal clk : std_logic;
    signal uclk : std_logic;
    signal bit_clk : std_logic;

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

    procedure send_byte_timed(
        signal Rxd_o : out std_logic;
        constant b : in std_logic_vector(7 downto 0)
    ) is
    begin
        Rxd_o <= '0';
        wait until falling_edge(bit_clk);
        for i in 0 to 7 loop
            Rxd_o <= byte_bit(b, i);
            wait until falling_edge(bit_clk);
        end loop;
        Rxd_o <= '1';
        wait until falling_edge(bit_clk);
    end procedure;

    procedure read_fifo(
        signal re_out : out std_logic
    ) is
    begin
        wait until falling_edge(clk);
        re_out <= '1';
        wait until falling_edge(clk);
        re_out <= '0';
    end procedure;

begin

    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    uclk_process : process
    begin
        uclk <= '0';
        wait for UCLK_PERIOD / 2;
        uclk <= '1';
        wait for UCLK_PERIOD / 2;
    end process;

    bit_clk_process : process
    begin
        bit_clk <= '0';
        wait for BIT_CLK_PERIOD / 2;
        bit_clk <= '1';
        wait for BIT_CLK_PERIOD / 2;
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
        send_byte_timed(Rxd, x"A5");
        wait until falling_edge(bit_clk);
        wait until falling_edge(bit_clk);
        wait until falling_edge(bit_clk);
        assert_equal(FifoEmpty, '0', "FifoEmpty should be 0 after receiving byte");
        assert_equal(FifoFull, '0', "FifoFull should be 0 after receiving one byte");
        assert_equal(FifoCount, std_logic_vector(to_unsigned(1, FIFO_BITS)), "FifoCount should be 1 after receiving one byte");
        assert_equal(FifoReadData, x"00", "FifoReadData should still be 0 before reading from FIFO");
        assert_equal(FifoReadAck, '0', "FifoReadAck should be 0 before reading from FIFO");


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

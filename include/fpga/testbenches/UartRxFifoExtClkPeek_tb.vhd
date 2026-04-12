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

    constant CLK_PERIOD : time := 1 sec / CLOCK_FREQHZ;
    constant UCLK_PERIOD : time := 1 sec / (BAUDRATE * 16);
    constant BIT_CLK_PERIOD : time := 1 sec / BAUDRATE;

    signal clk : std_logic;
    signal uclk : std_logic;
    signal bit_clk : std_logic;

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
        -- ReadFifo <= '0';
        -- FifoPeekAddr <= (others => '0');
        -- FifoMultiPopAddr <= (others => '0');
        -- FifoMultiPopStrobe <= '0';
        -- Rxd <= '1';
        -- FifoPeekAddr <= (others => '0');
        -- FifoMultiPopAddr <= (others => '0');
        -- FifoMultiPopStrobe <= '0';

        -- set_test_name(test_name_display, "Reset");
        -- reset_dut(bit_clk, rst);
        -- assert_equal(FifoEmpty, '1', "FifoEmpty should be 1 after reset");
        -- assert_equal(FifoFull, '0', "FifoFull should be 0 after reset");
        -- assert_equal(FifoCount, std_logic_vector(to_unsigned(0, PeekRamDepth)), "FifoCount should be 0 after reset");
        -- assert_equal(RxComplete, '0', "RxComplete should be 0 after reset");

        -- set_test_name(test_name_display, "Receive Byte 0xA5");
        -- send_byte_timed(Rxd, x"A5");
        -- wait until falling_edge(bit_clk);
        -- wait until falling_edge(bit_clk);
        -- assert_equal(FifoEmpty, '0', "FifoEmpty should be 0 after receiving byte");
        -- assert_equal(FifoFull, '0', "FifoFull should be 0 after receiving one byte");
        -- assert_equal(FifoCount, std_logic_vector(to_unsigned(1, PeekRamDepth)), "FifoCount should be 1 after receiving one byte");

        -- send_byte_timed(Rxd, x"5A");
        -- wait until falling_edge(bit_clk);
        -- wait until falling_edge(bit_clk);
        -- assert_equal(FifoEmpty, '0', "FifoEmpty should be 0 after receiving byte");
        -- assert_equal(FifoFull, '0', "FifoFull should be 0 after receiving one byte");
        -- assert_equal(FifoCount, std_logic_vector(to_unsigned(2, PeekRamDepth)), "FifoCount should be 2 after receiving two bytes");

        

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

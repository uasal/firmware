--! \brief Testbench for UartRx.vhd
--! Basic decode, back-to-back bytes, and byte-range traffic.
--! Reset-during-reception and break-condition handling.
--! Checks completion signaling and output hold behavior.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
use work.tb_utils_pkg.all;

entity UartRx_tb is
end UartRx_tb;

architecture sim of UartRx_tb is

    -- Must match DUT generics so divider yields baud*16
    constant CLOCK_FREQHZ : natural := 14745600;
    constant BAUDRATE : natural := 38400;

    constant SYS_CLK_PERIOD : time := 1 sec / CLOCK_FREQHZ;
    constant BIT_CLK_PERIOD : time := 1 sec / BAUDRATE;

    signal sys_clk : std_logic;
    signal bit_clk : std_logic;

    signal rst : std_logic;
    signal UartClk : std_logic;
    signal Rxd : std_logic;
    signal RxComplete : std_logic;
    signal RxData : std_logic_vector(7 downto 0);

    signal test_name_display : string(1 to 80);

    procedure send_byte(
        signal Rxd_o : out std_logic;
        constant b : in std_logic_vector(7 downto 0)
    ) is
    begin
        Rxd_o <= '0';
        wait until falling_edge(bit_clk);
        assert_equal(RxComplete, '0', "RxComplete should be 0 after start bit");

        for i in 0 to 7 loop
            Rxd_o <= byte_bit(b, i);
            wait until falling_edge(bit_clk);
        end loop;

        assert_equal(RxComplete, '0', "RxComplete should be 0 after sending byte");

        Rxd_o <= '1';
        wait until falling_edge(bit_clk);

        assert_equal(RxComplete, '1', "RxComplete should be 1 after sending byte");
        assert_equal(RxData, b, "RxData should be " & to_hstring(b) & " after sending byte");
    end procedure;

begin

    sys_clk_process : process
    begin
        sys_clk <= '0';
        wait for SYS_CLK_PERIOD / 2;
        sys_clk <= '1';
        wait for SYS_CLK_PERIOD / 2;
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
        set_test_name(test_name_display, "Reset");
        Rxd <= '1';
        reset_dut(sys_clk, rst);
        wait until rising_edge(UartClk);
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
        wait until falling_edge(bit_clk);
        assert_equal(RxComplete, '0', "RxComplete should drop during next frame");
        assert_equal(RxData, x"FF", "RxData should still hold old byte before next completion");
        Rxd <= '1';
        wait until RxComplete = '1';


        set_test_name(test_name_display, "Reset during reception");
        Rxd <= '1';
        wait until falling_edge(bit_clk);
        Rxd <= '0';
        wait until falling_edge(bit_clk);
        Rxd <= '1';
        wait until falling_edge(bit_clk);
        Rxd <= '0';
        wait until falling_edge(bit_clk);
        Rxd <= '1'; -- Rxd must go high before reset so IBuf2 does not mimic a start bit
        reset_dut(bit_clk, rst);
        assert_equal(RxComplete, '0', "RxComplete should be 0 after mid-byte reset");


        -- Assert while line still low!! release + reset avoids 0x00 complete from UartRxRaw
        set_test_name(test_name_display, "Break condition");
        Rxd <= '1';
        wait until falling_edge(bit_clk);
        cycle_clock(bit_clk, 2);
        Rxd <= '0';
        cycle_clock(bit_clk, 24);
        assert_equal(RxComplete, '0', "Break should not create valid byte (line still low)");
        assert_equal(RxData, x"00", "RxData should still be reset value during break");

        Rxd <= '1';
        cycle_clock(bit_clk, 2);
        reset_dut(sys_clk, rst);
        wait until rising_edge(UartClk);
        assert_equal(RxComplete, '0', "RxComplete clear after break cleanup reset");
        assert_equal(RxData, x"00", "RxData should be 0 after reset");


        set_test_name(test_name_display, "RxComplete should assert after byte");
        wait until falling_edge(bit_clk);
        send_byte(Rxd, x"55");
        assert_equal(RxComplete, '1', "RxComplete should assert");
        wait until rising_edge(UartClk);
        assert_equal(RxComplete, '1', "RxComplete should still be 1 after byte");

        finish;
    end process;

    dut : entity work.UartRx
        generic map (
            CLOCK_FREQHZ => CLOCK_FREQHZ,
            BAUDRATE => BAUDRATE
        )
        port map (
            clk => sys_clk,
            rst => rst,
            UartClk => UartClk,
            Rxd => Rxd,
            RxComplete => RxComplete,
            RxData => RxData
        );

end architecture sim;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
use work.tb_utils_pkg.all;

entity UartRXParity_tb is
end UartRXParity_tb;

architecture sim of UartRXParity_tb is

    signal clk : std_logic;
    signal rst : std_logic;
    signal Enable : std_logic;
    signal RxD : std_logic;
    signal RxAv : std_logic;
    signal DataO : std_logic_vector(7 downto 0);
    signal ParityErr : std_logic;
    signal RxAv2 : std_logic;
    signal DataO2 : std_logic_vector(7 downto 0);
    signal ParityErr2 : std_logic;

    signal test_name_display : string(1 to 80);

    constant CLK_PERIOD : time := 10 ns;
    constant UART_SAMPLES_PER_BIT : natural := 16;

    signal PARITY_EVEN : std_logic;

    function parity(data_i : std_logic_vector(7 downto 0); parity_even_i : std_logic) return std_logic is
        variable parity_bit : std_logic := '0';
    begin
        for i in 0 to 7 loop
            parity_bit := parity_bit xor data_i(i);
        end loop;
        if (parity_even_i = '1') then
            return (parity_bit);
        else
            return not(parity_bit);
        end if;
    end function;

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

        RxD_o <= parity(b, PARITY_EVEN);
        cycle_clock(clk, cycles_per_bit);

        RxD_o <= '1';
        cycle_clock(clk, stop_cycles);
    end procedure; 

    procedure send_frame_with_parity_bit(
        signal RxD_o : out std_logic;
        constant b : in std_logic_vector(7 downto 0);
        constant parity_bit : in std_logic;
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

        RxD_o <= parity_bit;
        cycle_clock(clk, cycles_per_bit);

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
        PARITY_EVEN <= '0';
        Enable <= '0';
        RxD <= '1';
        reset_dut(clk, rst);
        assert_equal(RxAv, '0', "RxAv should be 0 after reset");
        assert_equal(DataO, x"00", "DataO should be 0 after reset");
        assert_equal(ParityErr, '0', "ParityErr should be 0 after reset");

        set_test_name(test_name_display, "Enable=0 ignores RxD");
        RxD <= '0';
        cycle_clock(clk, UART_SAMPLES_PER_BIT * 8);
        assert_equal(RxAv, '0', "RxAv should remain 0 when disabled");
        assert_equal(DataO, x"00", "DataO should remain 0 when disabled");
        assert_equal(ParityErr, '0', "ParityErr should remain 0 when disabled");
        RxD <= '1';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);

        set_test_name(test_name_display, "Odd parity (dut: generic 1)");
        PARITY_EVEN <= '0';
        reset_dut(clk, rst);
        Enable <= '1';
        assert_equal(RxAv, '0', "RxAv starts low");

        send_byte(RxD, x"55");
        assert_equal(DataO, x"55", "DataO = 0x55 after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive (sticky until next frame)");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for correct parity");

        send_byte(RxD, x"FF");
        assert_equal(DataO, x"FF", "DataO = 0xFF after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for correct parity");

        send_byte(RxD, x"01");
        assert_equal(DataO, x"01", "DataO = 0x01 after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for correct parity");

        send_byte(RxD, x"80");
        assert_equal(DataO, x"80", "DataO = 0x80 after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for correct parity");

        set_test_name(test_name_display, "Even parity (dut2: generic 0)");
        PARITY_EVEN <= '1';
        reset_dut(clk, rst);
        Enable <= '1';
        assert_equal(RxAv2, '0', "RxAv2 starts low");

        send_byte(RxD, x"55");
        assert_equal(DataO2, x"55", "DataO2 = 0x55 after receive");
        assert_equal(RxAv2, '1', "RxAv2 asserted after receive (sticky until next frame)");
        assert_equal(ParityErr2, '0', "ParityErr2 should be 0 for correct parity");

        send_byte(RxD, x"FF");
        assert_equal(DataO2, x"FF", "DataO2 = 0xFF after receive");
        assert_equal(RxAv2, '1', "RxAv2 asserted after receive");
        assert_equal(ParityErr2, '0', "ParityErr2 should be 0 for correct parity");

        send_byte(RxD, x"01");
        assert_equal(DataO2, x"01", "DataO2 = 0x01 after receive");
        assert_equal(RxAv2, '1', "RxAv2 asserted after receive");
        assert_equal(ParityErr2, '0', "ParityErr2 should be 0 for correct parity");

        send_byte(RxD, x"80");
        assert_equal(DataO2, x"80", "DataO2 = 0x80 after receive");
        assert_equal(RxAv2, '1', "RxAv2 asserted after receive");
        assert_equal(ParityErr2, '0', "ParityErr2 should be 0 for correct parity");

        set_test_name(test_name_display, "Baud mismatch (odd / dut)");
        reset_dut(clk, rst);
        PARITY_EVEN <= '0';
        Enable <= '1';
        RxD <= '1';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);

        send_byte(RxD, x"C3", cycles_per_bit => 15);
        assert_equal(DataO, x"C3", "DataO = 0xC3 after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for correct parity");

        reset_dut(clk, rst);
        cycle_clock(clk, UART_SAMPLES_PER_BIT);

        send_byte(RxD, x"01", cycles_per_bit => 17);
        assert_equal(DataO, x"01", "DataO = 0x01 after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for correct parity");

        reset_dut(clk, rst);
        cycle_clock(clk, UART_SAMPLES_PER_BIT);

        -- the FF bits and long  cause it to end early (so FE)
        send_byte(RxD, x"FF", cycles_per_bit => 24);
        assert_equal(DataO, x"FE", "DataO = 0xFE (last bit sampled early under slow baud)");
        assert_equal(RxAv, '1', "RxAv asserted after receive");
        assert_equal(ParityErr, '1', "ParityErr set when parity bit mis-sampled (with framing error)");

        reset_dut(clk, rst);
        cycle_clock(clk, UART_SAMPLES_PER_BIT);

        -- the clocks are too short so intentional no RxAv
        send_byte(RxD, x"FF", cycles_per_bit => 5);
        assert_equal(DataO, x"00", "DataO = 0x00 after receive");
        assert_equal(RxAv, '0', "RxAv should stay 0 when bit times too short");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for correct parity");

        set_test_name(test_name_display, "Parity error flagged (odd / dut)");
        reset_dut(clk, rst);
        PARITY_EVEN <= '0';
        Enable <= '1';
        RxD <= '1';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);
        RxD <= '0';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);
        for i in 0 to 7 loop
            RxD <= byte_bit(x"42", i);
            cycle_clock(clk, UART_SAMPLES_PER_BIT);
        end loop;
        RxD <= not parity(x"42", PARITY_EVEN);
        cycle_clock(clk, UART_SAMPLES_PER_BIT);
        RxD <= '1';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);
        assert_equal(DataO, x"42", "DataO = 0x42 despite parity error");
        assert_equal(RxAv, '1', "RxAv asserted after frame with bad parity");
        assert_equal(ParityErr, '1', "ParityErr should be 1 when parity bit wrong");

        set_test_name(test_name_display, "SampleCnt=7 sampling point");
        reset_dut(clk, rst);
        PARITY_EVEN <= '0';
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
        RxD <= parity(x"A5", PARITY_EVEN);
        cycle_clock(clk, UART_SAMPLES_PER_BIT);
        RxD <= '1';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);
        assert_equal(DataO, x"A5", "Captured data matches value at SampleCnt=7");
        assert_equal(RxAv, '1', "RxAv asserted after SampleCnt=7 frame");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for SampleCnt=7 frame");
   
        set_test_name(test_name_display, "Stop bit accept if high by SampleCnt>=3 (odd / dut)");
        reset_dut(clk, rst);
        PARITY_EVEN <= '0';
        Enable <= '1';
        RxD <= '1';
        send_byte(RxD, x"3C", cycles_per_bit => UART_SAMPLES_PER_BIT, pre_idle_cycles => UART_SAMPLES_PER_BIT, stop_cycles => 0);
        RxD <= '0';
        cycle_clock(clk, 3);
        RxD <= '1';
        cycle_clock(clk, UART_SAMPLES_PER_BIT - 3);
        assert_equal(DataO, x"3C", "DataO updated when stop bit becomes high early");
        assert_equal(RxAv, '1', "RxAv asserted when stop bit becomes high early");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for correct parity");

        set_test_name(test_name_display, "Stop bit reject if low through SampleCnt>=13 (odd / dut)");
        reset_dut(clk, rst);
        PARITY_EVEN <= '0';
        Enable <= '1';
        RxD <= '1';
        send_byte(RxD, x"5A", cycles_per_bit => UART_SAMPLES_PER_BIT, pre_idle_cycles => UART_SAMPLES_PER_BIT, stop_cycles => 0);
        RxD <= '0';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);
        cycle_clock(clk, UART_SAMPLES_PER_BIT);

        assert_equal(RxAv, '0', "RxAv should stay 0 when stop bit missing too long");
        assert_equal(DataO, x"00", "DataO should not update when stop bit missing too long");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for correct parity");

        set_test_name(test_name_display, "Parity mode matrix on same wire");
        reset_dut(clk, rst);
        Enable <= '1';
        RxD <= '1';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);

        send_frame_with_parity_bit(RxD, x"69", parity(x"69", '0'));
        assert_equal(DataO, x"69", "Odd DUT data should update on odd-parity frame");
        assert_equal(DataO2, x"69", "Even DUT data should update on odd-parity frame");
        assert_equal(ParityErr, '0', "Odd DUT parity should pass on odd-parity frame");
        assert_equal(ParityErr2, '1', "Even DUT parity should fail on odd-parity frame");

        send_frame_with_parity_bit(RxD, x"96", parity(x"96", '1'), pre_idle_cycles => 0);
        assert_equal(DataO, x"96", "Odd DUT data should update on even-parity frame");
        assert_equal(DataO2, x"96", "Even DUT data should update on even-parity frame");
        assert_equal(ParityErr, '1', "Odd DUT parity should fail on even-parity frame");
        assert_equal(ParityErr2, '0', "Even DUT parity should pass on even-parity frame");

        set_test_name(test_name_display, "Reset during active frame");
        reset_dut(clk, rst);
        Enable <= '1';
        RxD <= '1';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);
        RxD <= '0';
        cycle_clock(clk, UART_SAMPLES_PER_BIT);
        for i in 0 to 2 loop
            RxD <= byte_bit(x"B6", i);
            cycle_clock(clk, UART_SAMPLES_PER_BIT);
        end loop;
        reset_dut(clk, rst);
        assert_equal(RxAv, '0', "Odd DUT RxAv should clear on reset during frame");
        assert_equal(DataO, x"00", "Odd DUT DataO should clear on reset during frame");
        assert_equal(ParityErr, '0', "Odd DUT ParityErr should clear on reset during frame");
        assert_equal(RxAv2, '0', "Even DUT RxAv should clear on reset during frame");
        assert_equal(DataO2, x"00", "Even DUT DataO should clear on reset during frame");
        assert_equal(ParityErr2, '0', "Even DUT ParityErr should clear on reset during frame");

        finish;
    end process;

    dut : entity work.UartRxParity
        generic map (
            PARITY_EVEN => 1
        )
        port map (
            Clk => clk,
            Reset => rst,
            Enable => Enable,
            RxD => RxD,
            RxAv => RxAv,
            DataO => DataO,
            ParityErr => ParityErr
        );

    dut2 : entity work.UartRxParity
        generic map (
            PARITY_EVEN => 0
        )
        port map (
            Clk => clk,
            Reset => rst,
            Enable => Enable,
            RxD => RxD,
            RxAv => RxAv2,
            DataO => DataO2,
            ParityErr => ParityErr2
        );

end architecture;
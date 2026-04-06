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
    constant BIT_CYCLES : natural := 16; -- matches SampleCnt 0..15 in DUT

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

    procedure send_byte_timed(
        signal RxD_o : out std_logic;
        constant b : in std_logic_vector(7 downto 0);
        constant cycles_per_bit : in natural := 16;
        constant pre_idle_cycles : in natural := 16;
        constant stop_cycles : in natural := 16
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
        cycle_clock(clk, BIT_CYCLES * 8);
        assert_equal(RxAv, '0', "RxAv should remain 0 when disabled");
        assert_equal(DataO, x"00", "DataO should remain 0 when disabled");
        assert_equal(ParityErr, '0', "ParityErr should remain 0 when disabled");
        RxD <= '1';
        cycle_clock(clk, BIT_CYCLES);

        set_test_name(test_name_display, "Odd parity (dut: generic 1)");
        PARITY_EVEN <= '0';
        reset_dut(clk, rst);
        Enable <= '1';
        assert_equal(RxAv, '0', "RxAv starts low");

        send_byte_timed(RxD, x"55");
        assert_equal(DataO, x"55", "DataO = 0x55 after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive (sticky until next frame)");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for correct parity");

        send_byte_timed(RxD, x"FF");
        assert_equal(DataO, x"FF", "DataO = 0xFF after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for correct parity");

        send_byte_timed(RxD, x"01");
        assert_equal(DataO, x"01", "DataO = 0x01 after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for correct parity");

        send_byte_timed(RxD, x"80");
        assert_equal(DataO, x"80", "DataO = 0x80 after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for correct parity");

        set_test_name(test_name_display, "Even parity (dut2: generic 0)");
        PARITY_EVEN <= '1';
        reset_dut(clk, rst);
        Enable <= '1';
        assert_equal(RxAv2, '0', "RxAv2 starts low");

        send_byte_timed(RxD, x"55");
        assert_equal(DataO2, x"55", "DataO2 = 0x55 after receive");
        assert_equal(RxAv2, '1', "RxAv2 asserted after receive (sticky until next frame)");
        assert_equal(ParityErr2, '0', "ParityErr2 should be 0 for correct parity");

        send_byte_timed(RxD, x"FF");
        assert_equal(DataO2, x"FF", "DataO2 = 0xFF after receive");
        assert_equal(RxAv2, '1', "RxAv2 asserted after receive");
        assert_equal(ParityErr2, '0', "ParityErr2 should be 0 for correct parity");

        send_byte_timed(RxD, x"01");
        assert_equal(DataO2, x"01", "DataO2 = 0x01 after receive");
        assert_equal(RxAv2, '1', "RxAv2 asserted after receive");
        assert_equal(ParityErr2, '0', "ParityErr2 should be 0 for correct parity");

        send_byte_timed(RxD, x"80");
        assert_equal(DataO2, x"80", "DataO2 = 0x80 after receive");
        assert_equal(RxAv2, '1', "RxAv2 asserted after receive");
        assert_equal(ParityErr2, '0', "ParityErr2 should be 0 for correct parity");

        set_test_name(test_name_display, "Baud mismatch (odd / dut)");
        reset_dut(clk, rst);
        PARITY_EVEN <= '0';
        Enable <= '1';
        RxD <= '1';
        cycle_clock(clk, BIT_CYCLES);

        send_byte_timed(RxD, x"C3", cycles_per_bit => 15);
        assert_equal(DataO, x"C3", "DataO = 0xC3 after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for correct parity");

        reset_dut(clk, rst);
        cycle_clock(clk, BIT_CYCLES);

        send_byte_timed(RxD, x"01", cycles_per_bit => 17);
        assert_equal(DataO, x"01", "DataO = 0x01 after receive");
        assert_equal(RxAv, '1', "RxAv asserted after receive");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for correct parity");

        reset_dut(clk, rst);
        cycle_clock(clk, BIT_CYCLES);

        -- the FF bits and long  cause it to end early (so FE)
        send_byte_timed(RxD, x"FF", cycles_per_bit => 24);
        assert_equal(DataO, x"FE", "DataO = 0xFE (last bit sampled early under slow baud)");
        assert_equal(RxAv, '1', "RxAv asserted after receive");
        assert_equal(ParityErr, '1', "ParityErr set when parity bit mis-sampled (with framing error)");

        reset_dut(clk, rst);
        cycle_clock(clk, BIT_CYCLES);

        -- the clocks are too short so intentional no RxAv
        send_byte_timed(RxD, x"FF", cycles_per_bit => 5);
        assert_equal(DataO, x"00", "DataO = 0x00 after receive");
        assert_equal(RxAv, '0', "RxAv should stay 0 when bit times too short");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for correct parity");

        set_test_name(test_name_display, "Parity error flagged (odd / dut)");
        reset_dut(clk, rst);
        PARITY_EVEN <= '0';
        Enable <= '1';
        RxD <= '1';
        cycle_clock(clk, BIT_CYCLES);
        RxD <= '0';
        cycle_clock(clk, BIT_CYCLES);
        for i in 0 to 7 loop
            RxD <= byte_bit(x"42", i);
            cycle_clock(clk, BIT_CYCLES);
        end loop;
        RxD <= not parity(x"42", PARITY_EVEN);
        cycle_clock(clk, BIT_CYCLES);
        RxD <= '1';
        cycle_clock(clk, BIT_CYCLES);
        assert_equal(DataO, x"42", "DataO = 0x42 despite parity error");
        assert_equal(RxAv, '1', "RxAv asserted after frame with bad parity");
        assert_equal(ParityErr, '1', "ParityErr should be 1 when parity bit wrong");

        set_test_name(test_name_display, "SampleCnt=7 sampling point");
        reset_dut(clk, rst);
        Enable <= '1';
        RxD <= '1';
        assert_equal(RxAv, '0', "RxAv low after reset");
        -- each data bit is wrong except around the SampleCnt=7 instant.
        RxD <= '1';
        cycle_clock(clk, BIT_CYCLES);
        RxD <= '0';
        cycle_clock(clk, BIT_CYCLES);
        for i in 0 to 7 loop
            RxD <= not byte_bit(x"A5", i);
            cycle_clock(clk, 7);
            RxD <= byte_bit(x"A5", i);
            cycle_clock(clk, 2);
            RxD <= not byte_bit(x"A5", i);
            cycle_clock(clk, 7);
        end loop;
   
        set_test_name(test_name_display, "Stop bit accept if high by SampleCnt>=3 (odd / dut)");
        reset_dut(clk, rst);
        PARITY_EVEN <= '0';
        Enable <= '1';
        RxD <= '1';
        send_byte_timed(RxD, x"3C", cycles_per_bit => BIT_CYCLES, pre_idle_cycles => BIT_CYCLES, stop_cycles => 0);
        RxD <= '0';
        cycle_clock(clk, 3);
        RxD <= '1';
        cycle_clock(clk, BIT_CYCLES - 3);
        assert_equal(DataO, x"3C", "DataO updated when stop bit becomes high early");
        assert_equal(RxAv, '1', "RxAv asserted when stop bit becomes high early");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for correct parity");

        set_test_name(test_name_display, "Stop bit reject if low through SampleCnt>=13 (odd / dut)");
        reset_dut(clk, rst);
        PARITY_EVEN <= '0';
        Enable <= '1';
        RxD <= '1';
        send_byte_timed(RxD, x"5A", cycles_per_bit => BIT_CYCLES, pre_idle_cycles => BIT_CYCLES, stop_cycles => 0);
        RxD <= '0';
        cycle_clock(clk, BIT_CYCLES);
        cycle_clock(clk, BIT_CYCLES);

        assert_equal(RxAv, '0', "RxAv should stay 0 when stop bit missing too long");
        assert_equal(DataO, x"00", "DataO should not update when stop bit missing too long");
        assert_equal(ParityErr, '0', "ParityErr should be 0 for correct parity");

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
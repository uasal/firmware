--! \brief Basic testbench for SpiDacTrio.vhd
--! Covers reset/idle behavior, trio-lane send/receive, write-data latching,
--! chip-select control, TransferComplete timing, and reset during transfer.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
use work.tb_utils_pkg.all;

entity SpiDacTrio_tb is
end SpiDacTrio_tb;

architecture sim of SpiDacTrio_tb is

    constant CLK_PERIOD : time := 10 ns;
    constant TRANSFER_COMPLETE_TIMEOUT_CYCLES : natural := 5000;

    type spi_tb_out_t is record
        rst       : std_logic;
        miso_a    : std_logic;
        miso_b    : std_logic;
        miso_c    : std_logic;
        write_dac : std_logic;
    end record;

    type spi_dut_out_t is record
        ncs_a             : std_logic;
        ncs_b             : std_logic;
        ncs_c             : std_logic;
        sck               : std_logic;
        mosi_a            : std_logic;
        mosi_b            : std_logic;
        mosi_c            : std_logic;
        transfer_complete : std_logic;
    end record;

    signal clk : std_logic := '0';
    signal test_name_display : string(1 to 80);
    signal spi_tb : spi_tb_out_t;
    signal spi_dut : spi_dut_out_t;

    signal dac_write_out_a, dac_readback_a : std_logic_vector(23 downto 0) := (others => '0');
    signal dac_write_out_b, dac_readback_b : std_logic_vector(23 downto 0) := (others => '0');
    signal dac_write_out_c, dac_readback_c : std_logic_vector(23 downto 0) := (others => '0');

    procedure drive_trio_miso(
        signal spi_tb_sig : out spi_tb_out_t;
        constant miso_a_value : std_logic;
        constant miso_b_value : std_logic;
        constant miso_c_value : std_logic
    ) is
    begin
        spi_tb_sig.miso_a <= miso_a_value;
        spi_tb_sig.miso_b <= miso_b_value;
        spi_tb_sig.miso_c <= miso_c_value;
    end procedure;

    procedure assert_trio_equal(
        constant actual_a : std_logic;
        constant expected_a : std_logic;
        constant actual_b : std_logic;
        constant expected_b : std_logic;
        constant actual_c : std_logic;
        constant expected_c : std_logic;
        constant msg : string
    ) is
    begin
        assert_equal(actual_a, expected_a, msg & " A");
        assert_equal(actual_b, expected_b, msg & " B");
        assert_equal(actual_c, expected_c, msg & " C");
    end procedure;

    procedure assert_trio_equal(
        constant actual_a : std_logic_vector;
        constant expected_a : std_logic_vector;
        constant actual_b : std_logic_vector;
        constant expected_b : std_logic_vector;
        constant actual_c : std_logic_vector;
        constant expected_c : std_logic_vector;
        constant msg : string
    ) is
    begin
        assert_equal(actual_a, expected_a, msg & " A");
        assert_equal(actual_b, expected_b, msg & " B");
        assert_equal(actual_c, expected_c, msg & " C");
    end procedure;

    procedure assert_all_ncs(
        signal spi_dut_sig : in spi_dut_out_t;
        constant expected : std_logic;
        constant msg : string
    ) is
    begin
        assert_equal(spi_dut_sig.ncs_a, expected, msg & " nCsA");
        assert_equal(spi_dut_sig.ncs_b, expected, msg & " nCsB");
        assert_equal(spi_dut_sig.ncs_c, expected, msg & " nCsC");
    end procedure;

    procedure send_receive_transaction(
        signal clk_in : in std_logic;
        signal spi_tb_sig : out spi_tb_out_t;
        signal spi_dut_sig : in spi_dut_out_t;
        signal dac_write_out_a_sig : out std_logic_vector;
        signal dac_write_out_b_sig : out std_logic_vector;
        signal dac_write_out_c_sig : out std_logic_vector;
        signal dac_readback_a_sig : in std_logic_vector;
        signal dac_readback_b_sig : in std_logic_vector;
        signal dac_readback_c_sig : in std_logic_vector;
        constant tx_data_a : std_logic_vector;
        constant tx_data_b : std_logic_vector;
        constant tx_data_c : std_logic_vector;
        constant rx_data_a : std_logic_vector;
        constant rx_data_b : std_logic_vector;
        constant rx_data_c : std_logic_vector
    ) is
        variable tx_vec_a : std_logic_vector(dac_write_out_a_sig'range);
        variable tx_vec_b : std_logic_vector(dac_write_out_b_sig'range);
        variable tx_vec_c : std_logic_vector(dac_write_out_c_sig'range);
        variable rx_vec_a : std_logic_vector(dac_readback_a_sig'range);
        variable rx_vec_b : std_logic_vector(dac_readback_b_sig'range);
        variable rx_vec_c : std_logic_vector(dac_readback_c_sig'range);
    begin
        tx_vec_a := tx_data_a;
        tx_vec_b := tx_data_b;
        tx_vec_c := tx_data_c;
        rx_vec_a := rx_data_a;
        rx_vec_b := rx_data_b;
        rx_vec_c := rx_data_c;

        spi_tb_sig.write_dac <= '0';
        dac_write_out_a_sig <= tx_vec_a;
        dac_write_out_b_sig <= tx_vec_b;
        dac_write_out_c_sig <= tx_vec_c;
        drive_trio_miso(spi_tb_sig, rx_vec_a(rx_vec_a'high), rx_vec_b(rx_vec_b'high), rx_vec_c(rx_vec_c'high));

        wait until rising_edge(clk_in);
        wait until falling_edge(clk_in);
        assert_all_ncs(spi_dut_sig, '1', "nCs high while idle before transfer");
        assert_equal(spi_dut_sig.sck, '1', "Sck idle before transfer");
        assert_equal(spi_dut_sig.transfer_complete, '1', "TransferComplete high while idle before transfer");

        spi_tb_sig.write_dac <= '1';
        wait until rising_edge(clk_in);
        wait until falling_edge(clk_in);
        assert_all_ncs(spi_dut_sig, '0', "nCs low once transfer starts");
        assert_equal(spi_dut_sig.transfer_complete, '0', "TransferComplete low while transfer starts");

        for bit_num in tx_vec_a'high downto tx_vec_a'low loop
            wait until (spi_dut_sig.sck'event and (spi_dut_sig.sck = '0'));
            assert_equal(spi_dut_sig.sck, '0', "Sck at shift point for bit " & integer'image(bit_num));
            assert_trio_equal(
                spi_dut_sig.mosi_a, tx_vec_a(bit_num),
                spi_dut_sig.mosi_b, tx_vec_b(bit_num),
                spi_dut_sig.mosi_c, tx_vec_c(bit_num),
                "Master shifted MOSI bit " & integer'image(bit_num)
            );
            assert_all_ncs(spi_dut_sig, '0', "nCs stays low during shift of bit " & integer'image(bit_num));
            assert_equal(spi_dut_sig.transfer_complete, '0', "TransferComplete low during shift of bit " & integer'image(bit_num));

            if bit_num /= tx_vec_a'high then
                drive_trio_miso(spi_tb_sig, rx_vec_a(bit_num), rx_vec_b(bit_num), rx_vec_c(bit_num));
            end if;

            wait until (spi_dut_sig.sck'event and (spi_dut_sig.sck = '1'));
            assert_equal(spi_dut_sig.sck, '1', "Sck at sample point for bit " & integer'image(bit_num));
            assert_trio_equal(
                spi_dut_sig.mosi_a, tx_vec_a(bit_num),
                spi_dut_sig.mosi_b, tx_vec_b(bit_num),
                spi_dut_sig.mosi_c, tx_vec_c(bit_num),
                "Slave sampled MOSI bit " & integer'image(bit_num)
            );
            assert_all_ncs(spi_dut_sig, '0', "nCs stays low during sample of bit " & integer'image(bit_num));
            assert_equal(spi_dut_sig.transfer_complete, '0', "TransferComplete low during sample of bit " & integer'image(bit_num));
        end loop;

        wait_until_value(clk_in, spi_dut_sig.transfer_complete, '1', TRANSFER_COMPLETE_TIMEOUT_CYCLES, "Timed out waiting for TransferComplete after transaction");
        assert_trio_equal(dac_readback_a_sig, rx_vec_a, dac_readback_b_sig, rx_vec_b, dac_readback_c_sig, rx_vec_c, "Readback captured expected RX data");
        assert_all_ncs(spi_dut_sig, '1', "nCs released after transfer completes");
        assert_equal(spi_dut_sig.transfer_complete, '1', "TransferComplete high after transfer completes");
        assert_equal(spi_dut_sig.sck, '1', "Sck idle after transfer completes");

        wait until falling_edge(clk_in);
        assert_equal(spi_dut_sig.transfer_complete, '1', "TransferComplete high after transfer completes and before next request");
        assert_trio_equal(dac_readback_a_sig, rx_vec_a, dac_readback_b_sig, rx_vec_b, dac_readback_c_sig, rx_vec_c, "Readback stable after transfer completes");
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
        spi_tb.write_dac <= '0';
        spi_tb.rst <= '1';
        drive_trio_miso(spi_tb, '0', '0', '0');
        dac_write_out_a <= (others => '0');
        dac_write_out_b <= (others => '0');
        dac_write_out_c <= (others => '0');

        set_test_name(test_name_display, "reset and idle");
        wait until falling_edge(clk);
        assert_all_ncs(spi_dut, '1', "nCs high in reset");
        assert_equal(spi_dut.sck, '1', "Sck idle in reset");
        assert_equal(spi_dut.transfer_complete, '1', "TransferComplete high in reset");

        spi_tb.rst <= '0';
        wait until falling_edge(clk);
        assert_all_ncs(spi_dut, '1', "nCs high after reset");
        assert_equal(spi_dut.sck, '1', "Sck idle after reset");
        assert_equal(spi_dut.transfer_complete, '1', "TransferComplete high after reset");

        set_test_name(test_name_display, "send only");
        send_receive_transaction(clk, spi_tb, spi_dut, dac_write_out_a, dac_write_out_b, dac_write_out_c, dac_readback_a, dac_readback_b, dac_readback_c, x"ABCDEF", x"13579B", x"2468AC", x"000000", x"000000", x"000000");

        set_test_name(test_name_display, "receive only");
        send_receive_transaction(clk, spi_tb, spi_dut, dac_write_out_a, dac_write_out_b, dac_write_out_c, dac_readback_a, dac_readback_b, dac_readback_c, x"000000", x"000000", x"000000", x"55AA33", x"AA55CC", x"3CC33C");

        set_test_name(test_name_display, "send and receive");
        send_receive_transaction(clk, spi_tb, spi_dut, dac_write_out_a, dac_write_out_b, dac_write_out_c, dac_readback_a, dac_readback_b, dac_readback_c, x"FEDCBA", x"89ABCD", x"102938", x"A5A5A5", x"5A5A5A", x"C33CC3");

        set_test_name(test_name_display, "write data latches at transfer start");
        spi_tb.write_dac <= '0';
        drive_trio_miso(spi_tb, '0', '0', '0');
        dac_write_out_a <= x"ABCDEF";
        dac_write_out_b <= x"13579B";
        dac_write_out_c <= x"2468AC";
        wait until falling_edge(clk);
        spi_tb.write_dac <= '1';
        wait until falling_edge(clk);

        wait until (spi_dut.sck'event and (spi_dut.sck = '1'));
        assert_trio_equal(spi_dut.mosi_a, '1', spi_dut.mosi_b, '0', spi_dut.mosi_c, '0', "sampled original MOSI bit 23 before data change");
        wait until (spi_dut.sck'event and (spi_dut.sck = '0'));
        assert_trio_equal(spi_dut.mosi_a, '0', spi_dut.mosi_b, '0', spi_dut.mosi_c, '1', "shifted original MOSI bit 22 before data change");
        dac_write_out_a <= x"123456";
        dac_write_out_b <= x"654321";
        dac_write_out_c <= x"F0F0F0";
        wait until (spi_dut.sck'event and (spi_dut.sck = '1'));
        assert_trio_equal(spi_dut.mosi_a, '0', spi_dut.mosi_b, '0', spi_dut.mosi_c, '1', "sampled original MOSI bit 22 after data change");
        wait until (spi_dut.sck'event and (spi_dut.sck = '0'));
        assert_trio_equal(spi_dut.mosi_a, '1', spi_dut.mosi_b, '1', spi_dut.mosi_c, '0', "shifted original MOSI bit 21 after data change");
        wait_until_value(clk, spi_dut.transfer_complete, '1', TRANSFER_COMPLETE_TIMEOUT_CYCLES, "Timed out waiting for completion after data latch test");

        set_test_name(test_name_display, "hold WriteDac high does not restart");
        cycle_clock(clk, 10);
        assert_all_ncs(spi_dut, '1', "nCs stays high when WriteDac remains high");
        assert_equal(spi_dut.sck, '1', "Sck stays idle when WriteDac remains high");
        assert_equal(spi_dut.transfer_complete, '1', "TransferComplete stays high when WriteDac remains high");

        spi_tb.write_dac <= '0';
        wait until falling_edge(clk);
        assert_all_ncs(spi_dut, '1', "dropping WriteDac low does not start transfer");
        assert_equal(spi_dut.transfer_complete, '1', "TransferComplete stays high after dropping WriteDac low");

        set_test_name(test_name_display, "back to back requests");
        send_receive_transaction(clk, spi_tb, spi_dut, dac_write_out_a, dac_write_out_b, dac_write_out_c, dac_readback_a, dac_readback_b, dac_readback_c, x"111111", x"222222", x"333333", x"012345", x"89ABCD", x"FEDCBA");
        spi_tb.write_dac <= '0';
        wait until falling_edge(clk);
        send_receive_transaction(clk, spi_tb, spi_dut, dac_write_out_a, dac_write_out_b, dac_write_out_c, dac_readback_a, dac_readback_b, dac_readback_c, x"444444", x"555555", x"666666", x"0F0F0F", x"F0F0F0", x"A55AA5");

        set_test_name(test_name_display, "reset during active transfer");
        spi_tb.write_dac <= '0';
        drive_trio_miso(spi_tb, '0', '0', '0');
        dac_write_out_a <= x"C3C3C3";
        dac_write_out_b <= x"3C3C3C";
        dac_write_out_c <= x"5A5A5A";
        wait until falling_edge(clk);
        spi_tb.write_dac <= '1';
        wait until falling_edge(clk);
        wait until (spi_dut.sck'event and (spi_dut.sck = '0'));
        assert_all_ncs(spi_dut, '0', "nCs low before reset during transfer");

        spi_tb.rst <= '1';
        wait until falling_edge(clk);
        assert_all_ncs(spi_dut, '1', "nCs high after reset during transfer");
        assert_equal(spi_dut.sck, '1', "Sck idle after reset during transfer");
        assert_equal(spi_dut.transfer_complete, '1', "TransferComplete high after reset during transfer");

        spi_tb.write_dac <= '0';
        spi_tb.rst <= '0';
        wait until falling_edge(clk);
        assert_all_ncs(spi_dut, '1', "nCs stays high after releasing reset");
        assert_equal(spi_dut.sck, '1', "Sck stays idle after releasing reset");
        assert_equal(spi_dut.transfer_complete, '1', "TransferComplete high after releasing reset");

        finish;
    end process;

    dut : entity work.SpiDacTrioPorts
    generic map (
        MASTER_CLOCK_FREQHZ => 1000000
    )
    port map (
        clk => clk,
        rst => spi_tb.rst,
        nCsA => spi_dut.ncs_a,
        nCsB => spi_dut.ncs_b,
        nCsC => spi_dut.ncs_c,
        Sck => spi_dut.sck,
        MosiA => spi_dut.mosi_a,
        MosiB => spi_dut.mosi_b,
        MosiC => spi_dut.mosi_c,
        MisoA => spi_tb.miso_a,
        MisoB => spi_tb.miso_b,
        MisoC => spi_tb.miso_c,
        WriteDac => spi_tb.write_dac,
        DacWriteOutA => dac_write_out_a,
        DacWriteOutB => dac_write_out_b,
        DacWriteOutC => dac_write_out_c,
        DacReadbackA => dac_readback_a,
        DacReadbackB => dac_readback_b,
        DacReadbackC => dac_readback_c,
        TransferComplete => spi_dut.transfer_complete
    );

end architecture sim;

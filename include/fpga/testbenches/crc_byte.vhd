library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
use work.tb_utils_pkg.all;

entity crc_byte_tb is
end crc_byte_tb;

architecture sim of crc_byte_tb is

    signal crcIn : std_logic_vector(31 downto 0);
    signal data : std_logic_vector(7 downto 0);
    signal crcOut : std_logic_vector(31 downto 0);

    signal test_name_display : string(1 to 80);

    procedure get_expected_crc(
        constant data : in std_logic_vector(7 downto 0);
        constant crcIn : in std_logic_vector(31 downto 0);
        variable expected_crc : out std_logic_vector(31 downto 0)
    ) is
    begin
        expected_crc <= crcIn mod data;
        assert_equal(crcOut, expected_crc, "CRC should be " & to_string(expected_crc));
    end procedure;

    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    test_process : process
    begin
        get_expected_crc(x"00", x"FFFFFFFF", expected_crc);
        
    end process;
end architecture sim;
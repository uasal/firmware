library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
library work;
use work.CGraphTypes.all;
use work.tb_utils_pkg.all;

entity PeekRingBuffer_tb is
end PeekRingBuffer_tb;

architecture sim of PeekRingBuffer_tb is

    constant CLK_PERIOD : time := 10 ns;
    constant DEPTH      : natural := 2 ** PeekRamDepth;

    signal clk : std_logic := '0';
    signal rst : std_logic := '1';

    signal DataStartAddress : std_logic_vector(PeekRamDepth - 1 downto 0);
    signal DataEndAddress   : std_logic_vector(PeekRamDepth - 1 downto 0);
    signal PeekAddress      : std_logic_vector(PeekRamDepth - 1 downto 0) := (others => '0');
    signal PopAddress       : std_logic_vector(PeekRamDepth - 1 downto 0) := (others => '0');
    signal ByteIn           : std_logic_vector(7 downto 0) := (others => '0');
    signal ByteOut          : std_logic_vector(7 downto 0);
    signal WriteReq         : std_logic := '0';
    signal PopReq           : std_logic := '0';
    signal Dbg1             : std_logic;
    signal Dbg2             : std_logic;
    signal Dbg3             : std_logic;
    signal Empty            : std_logic;
    signal Full             : std_logic;
    signal Count            : std_logic_vector(PeekRamDepth - 1 downto 0);

    signal test_name_display : string(1 to 80);

    procedure write_once(
        signal write_req_out : out std_logic;
        signal byte_in_out   : out std_logic_vector(7 downto 0);
        constant data        : std_logic_vector(7 downto 0)
    ) is
    begin
        wait until falling_edge(clk);
        byte_in_out <= data;
        write_req_out <= '1';
        wait until falling_edge(clk);
        write_req_out <= '0';
    end procedure;

    procedure hold_write_high(
        signal write_req_out : out std_logic;
        signal byte_in_out   : out std_logic_vector(7 downto 0);
        constant data        : std_logic_vector(7 downto 0);
        constant cycles      : natural
    ) is
    begin
        wait until falling_edge(clk);
        byte_in_out <= data;
        write_req_out <= '1';
        for i in 1 to cycles loop
            wait until falling_edge(clk);
        end loop;
        write_req_out <= '0';
    end procedure;

    procedure pop_once(
        signal pop_req_out  : out std_logic;
        signal pop_addr_out : out std_logic_vector(PeekRamDepth - 1 downto 0);
        constant addr       : natural
    ) is
    begin
        wait until falling_edge(clk);
        pop_addr_out <= std_logic_vector(to_unsigned(addr, PeekRamDepth));
        pop_req_out <= '1';
        wait until falling_edge(clk);
        pop_req_out <= '0';
    end procedure;

    procedure hold_pop_high(
        signal pop_req_out  : out std_logic;
        signal pop_addr_out : out std_logic_vector(PeekRamDepth - 1 downto 0);
        constant addr       : natural;
        constant cycles     : natural
    ) is
    begin
        wait until falling_edge(clk);
        pop_addr_out <= std_logic_vector(to_unsigned(addr, PeekRamDepth));
        pop_req_out <= '1';
        for i in 1 to cycles loop
            wait until falling_edge(clk);
        end loop;
        pop_req_out <= '0';
    end procedure;

    procedure peek_at(
        signal peek_addr_out : out std_logic_vector(PeekRamDepth - 1 downto 0);
        constant addr        : natural
    ) is
    begin
        wait until falling_edge(clk);
        peek_addr_out <= std_logic_vector(to_unsigned(addr, PeekRamDepth));
        wait until falling_edge(clk);
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
        reset_dut(clk, rst);
        assert_equal(DataStartAddress, std_logic_vector(to_unsigned(0, PeekRamDepth)), "Start address should be 0 after reset");
        assert_equal(DataEndAddress, std_logic_vector(to_unsigned(0, PeekRamDepth)), "End address should be 0 after reset");
        assert_equal(Empty, '1', "Buffer should be empty after reset");
        assert_equal(Full, '0', "Buffer should not be full after reset");
        assert_equal(Count, std_logic_vector(to_unsigned(0, PeekRamDepth)), "Count should be 0 after reset");

        set_test_name(test_name_display, "Single write");
        write_once(WriteReq, ByteIn, x"AA");
        wait until falling_edge(clk);
        assert_equal(DataStartAddress, std_logic_vector(to_unsigned(0, PeekRamDepth)), "Start address should remain 0 after one write");
        assert_equal(DataEndAddress, std_logic_vector(to_unsigned(1, PeekRamDepth)), "End address should increment after one write");
        assert_equal(Empty, '0', "Buffer should not be empty after one write");
        assert_equal(Count, std_logic_vector(to_unsigned(1, PeekRamDepth)), "Count should be 1 after one write");

        set_test_name(test_name_display, "Peek first written byte");
        peek_at(PeekAddress, 0);
        assert_equal(ByteOut, x"AA", "Peek at address 0 should return AA");

        set_test_name(test_name_display, "Held write high only increments once");
        reset_dut(clk, rst);
        hold_write_high(WriteReq, ByteIn, x"11", 4);
        wait until falling_edge(clk);
        assert_equal(DataEndAddress, std_logic_vector(to_unsigned(1, PeekRamDepth)), "Held write high should only increment once");
        assert_equal(Count, std_logic_vector(to_unsigned(1, PeekRamDepth)), "Count should be 1 after held write high");

        set_test_name(test_name_display, "Multiple separate writes");
        reset_dut(clk, rst);
        write_once(WriteReq, ByteIn, x"10");
        write_once(WriteReq, ByteIn, x"20");
        write_once(WriteReq, ByteIn, x"30");
        wait until falling_edge(clk);
        assert_equal(DataEndAddress, std_logic_vector(to_unsigned(3, PeekRamDepth)), "End address should be 3 after three writes");
        assert_equal(Count, std_logic_vector(to_unsigned(3, PeekRamDepth)), "Count should be 3 after three writes");

        set_test_name(test_name_display, "Peek multiple locations");
        peek_at(PeekAddress, 0);
        assert_equal(ByteOut, x"10", "Peek at address 0 should return 10");
        peek_at(PeekAddress, 1);
        assert_equal(ByteOut, x"20", "Peek at address 1 should return 20");
        peek_at(PeekAddress, 2);
        assert_equal(ByteOut, x"30", "Peek at address 2 should return 30");

        set_test_name(test_name_display, "Single pop updates start address");
        pop_once(PopReq, PopAddress, 1);
        wait until falling_edge(clk);
        assert_equal(DataStartAddress, std_logic_vector(to_unsigned(1, PeekRamDepth)), "Start address should move to pop address");
        assert_equal(Count, std_logic_vector(to_unsigned(2, PeekRamDepth)), "Count should decrease after pop");
        assert_equal(Empty, '0', "Buffer should not be empty after popping one of three");

        set_test_name(test_name_display, "Held pop high only updates once");
        hold_pop_high(PopReq, PopAddress, 2, 3);
        wait until falling_edge(clk);
        assert_equal(DataStartAddress, std_logic_vector(to_unsigned(2, PeekRamDepth)), "Held pop high should only update start once");
        assert_equal(Count, std_logic_vector(to_unsigned(1, PeekRamDepth)), "Count should be 1 after held pop high");

        set_test_name(test_name_display, "Pop to end makes empty");
        pop_once(PopReq, PopAddress, 3);
        wait until falling_edge(clk);
        assert_equal(DataStartAddress, std_logic_vector(to_unsigned(3, PeekRamDepth)), "Start address should move to 3");
        assert_equal(DataEndAddress, std_logic_vector(to_unsigned(3, PeekRamDepth)), "End address should remain 3");
        assert_equal(Empty, '1', "Buffer should be empty when start equals end");
        assert_equal(Count, std_logic_vector(to_unsigned(0, PeekRamDepth)), "Count should be 0 when empty");

        set_test_name(test_name_display, "Debug signals on write");
        reset_dut(clk, rst);
        wait until falling_edge(clk);
        ByteIn <= x"44";
        WriteReq <= '1';
        wait until falling_edge(clk);
        assert_equal(Dbg3, '1', "Dbg3 should reflect WriteReq");
        WriteReq <= '0';
        wait until falling_edge(clk);
        assert_equal(Dbg2, '1', "Dbg2 should reflect previous WriteReq");
        assert_equal(Dbg3, '0', "Dbg3 should deassert when WriteReq deasserts");

        set_test_name(test_name_display, "Wraparound write address");
        reset_dut(clk, rst);
        for i in 0 to DEPTH - 2 loop
            write_once(WriteReq, ByteIn, std_logic_vector(to_unsigned(i mod 256, 8)));
        end loop;
        wait until falling_edge(clk);
        assert_equal(Full, '1', "Buffer should be full at DEPTH-1 entries");
        assert_equal(Count, std_logic_vector(to_unsigned(DEPTH - 1, PeekRamDepth)), "Count should indicate full occupancy");

        set_test_name(test_name_display, "Pop near wraparound");
        pop_once(PopReq, PopAddress, DEPTH - 2);
        wait until falling_edge(clk);
        assert_equal(Full, '0', "Buffer should not remain full after pop");
        assert_equal(Count, std_logic_vector(to_unsigned(1, PeekRamDepth)), "Count should be 1 after large pop");

        set_test_name(test_name_display, "Write wraps to zero");
        write_once(WriteReq, ByteIn, x"EE");
        wait until falling_edge(clk);
        assert_equal(DataEndAddress, std_logic_vector(to_unsigned(0, PeekRamDepth)), "End address should wrap to 0");
        assert_equal(Count, std_logic_vector(to_unsigned(2, PeekRamDepth)), "Count should be 2 after wrap write");

        set_test_name(test_name_display, "Peek wrapped location");
        peek_at(PeekAddress, DEPTH - 1);
        assert_equal(ByteOut, x"EE", "Wrapped write should be stored at last write address before increment");

        set_test_name(test_name_display, "Reset while active");
        WriteReq <= '1';
        PopReq <= '1';
        PopAddress <= std_logic_vector(to_unsigned(5, PeekRamDepth));
        wait until falling_edge(clk);
        reset_dut(clk, rst);
        WriteReq <= '0';
        PopReq <= '0';
        wait until falling_edge(clk);
        assert_equal(DataStartAddress, std_logic_vector(to_unsigned(0, PeekRamDepth)), "Start address should reset to 0");
        assert_equal(DataEndAddress, std_logic_vector(to_unsigned(0, PeekRamDepth)), "End address should reset to 0");
        assert_equal(Empty, '1', "Buffer should be empty after reset");
        assert_equal(Full, '0', "Buffer should not be full after reset");
        assert_equal(Count, std_logic_vector(to_unsigned(0, PeekRamDepth)), "Count should be 0 after reset");

        finish;
    end process;

    dut : entity work.PeekRingBuffer
    port map (
        clk              => clk,
        rst              => rst,
        DataStartAddress => DataStartAddress,
        DataEndAddress   => DataEndAddress,
        PeekAddress      => PeekAddress,
        PopAddress       => PopAddress,
        ByteIn           => ByteIn,
        ByteOut          => ByteOut,
        WriteReq         => WriteReq,
        PopReq           => PopReq,
        Dbg1             => Dbg1,
        Dbg2             => Dbg2,
        Dbg3             => Dbg3,
        Empty            => Empty,
        Full             => Full,
        Count            => Count
    );

end architecture sim;
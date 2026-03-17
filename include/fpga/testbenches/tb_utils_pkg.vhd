-- Helpful TB utils

library ieee;
use ieee.std_logic_1164.all;

package tb_utils_pkg is

	constant COLOR_GREEN : string := character'val(27) & "[32m";
	constant COLOR_RED : string := character'val(27) & "[31m";
	constant COLOR_YELLOW : string := character'val(27) & "[33m";
	constant COLOR_RESET : string := character'val(27) & "[0m";

	procedure assert_equal(
		constant actual : std_logic;
		constant expected : std_logic;
		constant msg : string
	);

	procedure assert_equal(
		constant actual : std_logic_vector;
		constant expected : std_logic_vector;
		constant msg : string
	);

	procedure set_test_name(
		signal dst : out string;
		constant src : in string
	);

end package tb_utils_pkg;

package body tb_utils_pkg is

	procedure assert_equal(
		constant actual : std_logic;
		constant expected : std_logic;
		constant msg : string
	) is
	begin
		if (actual = expected) then
			report COLOR_GREEN & "  PASS: " & msg & COLOR_RESET;
		else
			report COLOR_RED & "  FAIL: " & msg & " - got '" & std_logic'image(actual) & "' expected '" & std_logic'image(expected) & "'" & COLOR_RESET 
				severity error;
		end if;
	end procedure;

	procedure assert_equal(
		constant actual : std_logic_vector;
		constant expected : std_logic_vector;
		constant msg : string
	) is
	begin
		if (actual = expected) then
			report COLOR_GREEN & "  PASS: " & msg & COLOR_RESET;
		else
			report COLOR_RED & "  FAIL: " & msg & " - got 0x" & to_hstring(actual) & " expected 0x" & to_hstring(expected) & COLOR_RESET
				severity error;
		end if;
	end procedure;

	procedure set_test_name(
		signal dst : out string;
		constant src : in string
	) is
		variable copy_len : natural;
	begin
		for i in dst'range loop
			dst(i) <= ' ';
		end loop;
		copy_len := src'length;
		if (copy_len > dst'length) then
			copy_len := dst'length;
		end if;
		dst(1 to copy_len) <= src(src'low to src'low + integer(copy_len) - 1);
	end procedure;

end package body tb_utils_pkg;

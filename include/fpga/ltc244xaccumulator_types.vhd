--
--           Copyright (c) by Franks Development, LLC
--
-- This software is copyrighted by and is the sole property of Franks
-- Development, LLC. All rights, title, ownership, or other interests
-- in the software remain the property of Franks Development, LLC. This
-- software may only be used in accordance with the corresponding
-- license agreement.  Any unauthorized use, duplication, transmission,
-- distribution, or disclosure of this software is expressly forbidden.
--
-- This Copyright notice may not be removed or modified without prior
-- written consent of Franks Development, LLC.
--
-- Franks Development, LLC. reserves the right to modify this software
-- without notice.
--
-- Franks Development, LLC            support@franks-development.com
-- 500 N. Bahamas Dr. #101           http:--www.franks-development.com
-- Tucson, AZ 85710
-- USA
--
-- Permission granted for perpetual non-exclusive end-use by the University of Arizona August 1, 2020
--

--------------------------------------------------------------------------------
-- ltc244x accumulator infrastructure
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;
library work;
use work.ltc244x_types.all;

package ltc244xaccumulator_types is 

	type ltc244xaccumulator is 
	record

		NumAccums : std_logic_vector(15 downto 0); --63 - 48
		Sample : std_logic_vector(47 downto 0); -- 47 - 0

	end record ltc244xaccumulator;
	
	constant ltc244xaccumulator_init : 
	ltc244xaccumulator := 
	(
		NumAccums => (others => '0'),
		Sample => (others => '0')
	);
	
	function ltc244xaccum_to_std_logic( arg : ltc244xaccumulator ) return std_logic_vector;
	function ltc244xaccum_hi_to_std_logic( arg : ltc244xaccumulator ) return std_logic_vector;
	function ltc244xaccum_lo_to_std_logic( arg : ltc244xaccumulator ) return std_logic_vector;
	function ltc244xaccum_to_ltc244xsample( arg : ltc244xaccumulator ) return ltc244xsample;
	function std_logic_to_ltc244xaccum( arg : std_logic_vector(63 downto 0) ) return ltc244xaccumulator;
	function ltc244xsample_to_ltc244xaccum( arg : ltc244xsample ) return ltc244xaccumulator;
	
end package ltc244xaccumulator_types;

package body ltc244xaccumulator_types is

	--~ subtype numaccum_bits is natural range 63 downto 48; --handy construct for another day...
	
	function ltc244xaccum_to_std_logic( arg : ltc244xaccumulator ) return std_logic_vector is
		variable result : std_logic_vector(63 downto 0);
	begin
		result(63 downto 48) := arg.NumAccums;
		--~ result(44 downto 40) := arg.Channel;
		result(47 downto 0) := arg.Sample;		
		return result;		
	end function ltc244xaccum_to_std_logic;
	
	function ltc244xaccum_hi_to_std_logic( arg : ltc244xaccumulator ) return std_logic_vector is
		variable result : std_logic_vector(31 downto 0);
	begin
		result(31 downto 16) := arg.NumAccums;
		--~ result(12 downto 8) := arg.Channel;
		result(15 downto 0) := arg.Sample(47 downto 32);		
		return result;		
	end function ltc244xaccum_hi_to_std_logic;
	
	function ltc244xaccum_lo_to_std_logic( arg : ltc244xaccumulator ) return std_logic_vector is
		variable result : std_logic_vector(31 downto 0);
	begin
		result := arg.Sample(31 downto 0);		
		return result;		
	end function ltc244xaccum_lo_to_std_logic;
	
	function ltc244xaccum_to_ltc244xsample( arg : ltc244xaccumulator ) return ltc244xsample is
		variable result : ltc244xsample;
	begin
		result.StillConverting := '0';
		result.AlwaysZero := '0';
		result.OverrangeIfSameAsMsb := not(arg.Sample(28));
		result.Sample := arg.Sample(28 downto 0);		
		return result;		
	end function ltc244xaccum_to_ltc244xsample;
	
	function std_logic_to_ltc244xaccum( arg : std_logic_vector(63 downto 0) ) return ltc244xaccumulator is
		variable result : ltc244xaccumulator;
	begin
		result.NumAccums := arg(63 downto 48);
		result.Sample := arg(47 downto 0);
		return result;		
	end function std_logic_to_ltc244xaccum;
	
	function ltc244xsample_to_ltc244xaccum( arg : ltc244xsample ) return ltc244xaccumulator is
		variable result : ltc244xaccumulator;
	begin
		result.NumAccums := x"0000";
		--~ result.Channel := arg.Channel;
		result.Sample(47 downto 29) := "0000000000000000000";
		result.Sample := arg.Sample;
		return result;		
	end function ltc244xsample_to_ltc244xaccum;
	
end ltc244xaccumulator_types;

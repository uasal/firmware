--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

package ltc244x_types is 

	type ltc244xsample is 
	record

		StillConverting : std_logic; -- 31
		AlwaysZero : std_logic; -- 30
		OverrangeIfSameAsMsb : std_logic; -- 29
		Sample : std_logic_vector(28 downto 0); -- 28 - 0

	end record ltc244xsample;

	constant ltc244xsampleinit : 
	ltc244xsample := 
	(
		StillConverting => '0',
		AlwaysZero => '0',
		OverrangeIfSameAsMsb => '0',
		Sample => (others => '0')
	);
	
	type ltc244xconfig is 
	record

		AlwaysOne : std_logic; -- 31
		AlwaysZero : std_logic; -- 30
		Enable : std_logic; -- 29
		Channel : std_logic_vector(4 downto 0); -- 28 - 24
		DataRate : std_logic_vector(3 downto 0); -- 23 - 20
		DoubleSpeedAndOneCycleLatency : std_logic; -- 19
		reserved : std_logic_vector(18 downto 0); -- 18 - 0
		
	end record ltc244xconfig;
	
	constant ltc244xconfiginit : 
	ltc244xconfig := 
	(
		AlwaysOne => '1',
		AlwaysZero => '0',
		Enable => '1',
		Channel => (others => '0'),
		DataRate => (others => '0'),
		DoubleSpeedAndOneCycleLatency => '0',
		reserved => (others => '0')
	);
	
	function ltc244xsample_to_std_logic( arg : ltc244xsample ) return std_logic_vector;
	function std_logic_to_ltc244xsample( arg : std_logic_vector(31 downto 0) ) return ltc244xsample;
	function ltc244xconfig_to_std_logic( arg : ltc244xconfig ) return std_logic_vector;
	function std_logic_to_ltc244xconfig( arg : std_logic_vector(31 downto 0) ) return ltc244xconfig;
	
end package ltc244x_types;

package body ltc244x_types is
	
	function ltc244xsample_to_std_logic( arg : ltc244xsample ) return std_logic_vector is
		variable result : std_logic_vector(31 downto 0);
	begin
		result(31) := arg.StillConverting;
		result(30) := arg.AlwaysZero;
		result(29) := arg.OverrangeIfSameAsMsb;
		result(28 downto 0) := arg.Sample;		
		return result;		
	end function ltc244xsample_to_std_logic;
	
	function std_logic_to_ltc244xsample( arg : std_logic_vector(31 downto 0) ) return ltc244xsample is
		variable result : ltc244xsample;
	begin
		result.StillConverting := arg(31);
		result.AlwaysZero := arg(30);
		result.OverrangeIfSameAsMsb := arg(29);
		result.Sample := arg(28 downto 0);
		return result;		
	end function std_logic_to_ltc244xsample;

	function ltc244xconfig_to_std_logic( arg : ltc244xconfig ) return std_logic_vector is
		variable result : std_logic_vector(31 downto 0);
	begin
		result(31) := arg.AlwaysOne;
		result(30) := arg.AlwaysZero;
		result(29) := arg.Enable;
		result(28 downto 24) := arg.Channel;
		result(23 downto 20) := arg.DataRate;
		result(19) := arg.DoubleSpeedAndOneCycleLatency;
		result(18 downto 0) := arg.reserved;
		return result;		
	end function ltc244xconfig_to_std_logic;
	
	function std_logic_to_ltc244xconfig( arg : std_logic_vector(31 downto 0) ) return ltc244xconfig is
		variable result : ltc244xconfig;
	begin
		result.AlwaysOne := arg(31);
		result.AlwaysZero := arg(30);
		result.Enable := arg(29);
		result.Channel := arg(28 downto 24);
		result.DataRate := arg(23 downto 20);
		result.DoubleSpeedAndOneCycleLatency := arg(19);
		result.reserved := arg(18 downto 0);
		return result;		
	end function std_logic_to_ltc244xconfig;

end ltc244x_types;

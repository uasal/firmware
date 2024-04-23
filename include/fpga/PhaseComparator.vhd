--------------------------------------------------------------------------------
-- MountainOps DNT GPS Board PC/104 Firmware
--
-- $Revision: 1.2 $
-- $Date: 2009/05/01 00:42:47 $
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity PhaseComparatorPorts is
	generic (
			MAX_CLOCK_BITS_DELTA : natural := 16--; -- 16-bits is approx +/-500uS @ 50MHz
	);
    port (
			clk : in std_logic;
			rst : in std_logic;

			InA : in std_logic;
			InB : in std_logic;
			
			Delta : out std_logic_vector(MAX_CLOCK_BITS_DELTA - 1 downto 0)--;
	);
end PhaseComparatorPorts;

architecture PhaseComparatorr of PhaseComparatorPorts is

	component IBufP3Ports is
	port (
		clk : in std_logic;
		I : in std_logic;
		O : out std_logic--;
	);
	end component;

	signal InA_i : std_logic;
	signal InB_i : std_logic;
	signal Delta_i : std_logic_vector(MAX_CLOCK_BITS_DELTA - 1 downto 0);
	signal DeltaLatched : std_logic;
	
	--Constants of the right length...
	constant One : std_logic_vector(MAX_CLOCK_BITS_DELTA - 1 downto 0) := std_logic_vector(to_unsigned(1, MAX_CLOCK_BITS_DELTA));
	constant Zero : std_logic_vector(MAX_CLOCK_BITS_DELTA - 1 downto 0) := std_logic_vector(to_unsigned(0, MAX_CLOCK_BITS_DELTA));
	--~ constant DeltaSaturated : std_logic_vector(MAX_CLOCK_BITS_DELTA - 1 downto 0) := std_logic_vector(to_unsigned((2 ** (MAX_CLOCK_BITS_DELTA - 1)) - 1, MAX_CLOCK_BITS_DELTA));
	constant DeltaSaturated : std_logic_vector(MAX_CLOCK_BITS_DELTA - 1 downto 0) := (others => '1');
	
begin

	IBUF_A : IBufP3Ports
	port map (
		clk => clk,
		I => InA,
		O => InA_i
	);
	
	IBUF_B : IBufP3Ports
	port map (
		clk => clk,
		I => InB,
		O => InB_i
	);

	-- Master clock drives most logic
	process (clk, rst)
	begin
		if (rst = '1') then
		
			Delta_i <= Zero;
			Delta <= Zero;
			
		else
		
			if ( (clk'event) and (clk = '1') ) then
			
				--Reset Counters on start of cycle (this is preferred to be both low, then if one clock is lost, delta will swing wildly, instead of stick at zero)
				if ( (InA_i = '0') and (InB_i = '0') ) then
				
					Delta_i <= Zero;
				
					DeltaLatched <= '0';
					
				end if;
				
				--If A preceeds B, we count down from 0
				if ( (InA_i = '1') and (InB_i = '0') ) then
				
					--saturate:
					if (Delta_i < DeltaSaturated) then
						
						Delta_i <= Delta_i + One;
						
					end if;
					
				end if;
				
				--If B preceeds A, we count up from 0
				if ( (InA_i = '0') and (InB_i = '1') ) then
				
					--saturate:
					if ( (Delta_i > (DeltaSaturated + One)) or (Delta_i = Zero) ) then --signed logic in unsigned var =>big numbers are negative
					
						Delta_i <= Delta_i - One;
						
					end if;
					
				end if;
				
				--If they're both end of cycle, sit on our hands...
				if ( (InA_i = '1') and (InB_i = '1') ) then
				
					if (DeltaLatched = '0') then
					
						Delta <= Delta_i;
						
						DeltaLatched <= '1';
						
					end if;
					
				end if;

			end if;
			
		end if;

	end process; --(clock)

end PhaseComparatorr;

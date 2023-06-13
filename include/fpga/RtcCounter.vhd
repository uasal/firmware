--------------------------------------------------------------------------------
-- MountainOps DNT GPS Board PC/104 Firmware
--
-- $Revision: 1.4 $
-- $Date: 2009/09/29 00:37:06 $
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity RtcCounterPorts is
	generic (
		CLOCK_FREQ : natural := 100000000--;
	);
    port (
			clk : in std_logic;
			rst : in std_logic;
			
			PPS : in std_logic;
			PPSDetected : out std_logic;
			Sync : in std_logic; --unused. compatibility interface
			GeneratePPS : in std_logic;
			GeneratedPPS : out std_logic;
									
			SetTimeSeconds : in std_logic_vector(21 downto 0);
			SetTime : in std_logic;
			SetChangedTime : out std_logic;
			
			Seconds : out std_logic_vector(21 downto 0);
			Milliseconds : out std_logic_vector(9 downto 0)--;
	);
end RtcCounterPorts;

architecture RtcCounter of RtcCounterPorts is

	--~ constant ClockDividerRollover : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned((CLOCK_FREQ / 1000) - 1, 16)); --51.2MHz / 51200 - 1 = 1kHz = 1 mS
	constant ClockDividerRollover : natural := (CLOCK_FREQ / 1000) - 1; --51.2MHz / 51200 - 1 = 1kHz = 1 mS
	--~ signal ClockDivider : std_logic_vector(15 downto 0);
	signal ClockDivider : natural range 0 to ClockDividerRollover := 0;

	signal Milliseconds_i : std_logic_vector(9 downto 0);
	signal Seconds_i : std_logic_vector(21 downto 0);
	
	signal LastPPS : std_logic;
	signal HavePPS : std_logic;
	
	signal TimeWasSet : std_logic;
	
begin

	Seconds <= Seconds_i;
	MilliSeconds <= MilliSeconds_i;
	PPSDetected <= HavePPS;
	GeneratedPPS <= '1' when (MilliSeconds_i < 64) else '0';
	
	process (rst, clk, PPS, SetTime, Milliseconds_i)
	begin
	
		if (rst = '1') then
		
			ClockDivider <= 0;
			MilliSeconds_i <= "0000000000";
			Seconds_i <= "0000000000000000000000";
			HavePPS <= '0';
			LastPPS <= '1'; --pulled up by default in h/w, so must idle at 1; also makes it do both edges before acting on the first pps. Now, when the GPS pulls in, does it move a whole bunch and fubar our autosync?
			TimeWasSet <= '0';
			
		else
			
			if ( (clk'event) and (clk = '1') ) then
		
				--Edge of PPS is sacred: resets everything...
				if ( (LastPPS /= PPS) and (GeneratePPS = '0') ) then --the generatepps flag keeps us from listening when we are the source of pps instead of gps!
				
					LastPPS <= PPS;
					
					HavePPS <= '1';
					
					if (PPS = '1') then
					
						Seconds_i <= Seconds_i + 1;
					
						Milliseconds_i <= std_logic_vector(to_unsigned(0, 10));
						
						ClockDivider <= 0;
					
					end if;
					
				else
						
					if (ClockDivider < ClockDividerRollover) then
					
						ClockDivider <= ClockDivider + 1; --wait for a millisecond to go by...
						
						--Handle setting the time
						if ( (SetTime = '1') and (TimeWasSet = '0') ) then 
						
							TimeWasSet <= '1';
							
							if (Seconds_i /= SetTimeSeconds) then 
							
								SetChangedTime <= '1';
							
								Seconds_i <= SetTimeSeconds;
							
							else
							
								SetChangedTime <= '0';
								
							end if;
							
						end if;

						if (SetTime = '0') then TimeWasSet <= '0'; end if;
						
					else --edge of next millisecond
					
						ClockDivider <= 0;
						
						if (Milliseconds_i >= std_logic_vector(to_unsigned(1000, 10))) then
						
							--Trip this, next PPS sets it back. 
							HavePPS <= '0';							
							
							Seconds_i <= Seconds_i + 1; 
							
							Milliseconds_i <= std_logic_vector(to_unsigned(0, 10));
							
						else
							
							if (Milliseconds_i >= std_logic_vector(to_unsigned(999, 10))) then
							
								if (HavePPS = '0') then 
								
									Seconds_i <= Seconds_i + 1; 
									
									Milliseconds_i <= std_logic_vector(to_unsigned(0, 10));
									
								else
								
									Milliseconds_i <= Milliseconds_i + 1;
									
								end if;
								
							else
							
								Milliseconds_i <= Milliseconds_i + 1;
							
							end if;
							
						end if;
						
					end if;
					
				end if;
				
			end if;
			
		end if;

	end process; --(clock)

end RtcCounter;

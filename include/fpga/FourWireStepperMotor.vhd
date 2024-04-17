--------------------------------------------------------------------------------
--
-- Four Wire Stepper Motor Driver
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity FourWireStepperMotorPorts is
	port (
		clk : in std_logic;
		rst : in std_logic;

		--inputs
		Direction : in std_logic;
		Step : in std_logic;

		MotorA+ : out std_logic;
		MotorA- : out std_logic;
		MotorB+ : out std_logic;
		MotorB- : out std_logic--;
	);
end FourWireStepperMotorPorts;

architecture FourWireStepperMotor of FourWireStepperMotorPorts is

	signal MotorA+_i : std_logic;
	signal MotorA-_i : std_logic;
	signal MotorB+_i : std_logic;
	signal MotorB-_i : std_logic;
	
	signal LastStep : std_logic;
	
	signal State : std_logic_vector(1 downto 0);
	
begin

	MotorA+_i <= MotorA+_i;
	MotorA-_i <= MotorA-_i;
	MotorB+_i <= MotorB+_i;
	MotorB-_i <= MotorB-_i;
	
	-- Master clock drives most logic
	process (clk, rst)
	begin
		if (rst = '1') then
		
			LastStep <= '0';
			State <= "00";
			
		else
		
			if ( (clk'event) and (clk = '1') ) then
			
				if (Step /= LastStep) then
				
					LastStep <= Step;
					
					if (Step = '1') then			
			
						if (Direction = '1') then State <= State + "01"; else State <= State - "01"; end if;

						case State is
						
							when "00" =>
							
								MotorA+_i <= "1";
								MotorA-_i <= "0";
								MotorB+_i <= "1";
								MotorB-_i <= "0";
								
							when "01" =>
							
								MotorA+_i <= "1";
								MotorA-_i <= "0";
								MotorB+_i <= "0";
								MotorB-_i <= "1";
								
							when "10" =>
							
								MotorA+_i <= "0";
								MotorA-_i <= "1";
								MotorB+_i <= "0";
								MotorB-_i <= "1";
								
							when "11" =>
							
								MotorA+_i <= "0";
								MotorA-_i <= "1";
								MotorB+_i <= "1";
								MotorB-_i <= "0";
								
						end case;
				
					end if;
				
				end if;
				
			end if;
			
		end if;

	end process; --(clock)

end FourWireStepperMotor;

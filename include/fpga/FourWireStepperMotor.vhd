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

		MotorAPlus : out std_logic;
		MotorAMinus : out std_logic;
		MotorBPlus : out std_logic;
		MotorBMinus : out std_logic--;
	);
end FourWireStepperMotorPorts;

architecture FourWireStepperMotor of FourWireStepperMotorPorts is

	signal MotorAPlus_i : std_logic;
	signal MotorAMinus_i : std_logic;
	signal MotorBPlus_i : std_logic;
	signal MotorBMinus_i : std_logic;
	
	signal LastStep : std_logic;
	
	signal State : std_logic_vector(1 downto 0);
	
begin

	MotorAPlus <= MotorAPlus_i;
	MotorAMinus <= MotorAMinus_i;
	MotorBPlus <= MotorBPlus_i;
	MotorBMinus <= MotorBMinus_i;
	
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
							
								MotorAPlus_i <= '1';
								MotorAMinus_i <= '0';
								MotorBPlus_i <= '1';
								MotorBMinus_i <= '0';
								
							when "01" =>
							
								MotorAPlus_i <= '1';
								MotorAMinus_i <= '0';
								MotorBPlus_i <= '0';
								MotorBMinus_i <= '1';
								
							when "10" =>
							
								MotorAPlus_i <= '0';
								MotorAMinus_i <= '1';
								MotorBPlus_i <= '0';
								MotorBMinus_i <= '1';
								
							when "11" =>
							
								MotorAPlus_i <= '0';
								MotorAMinus_i <= '1';
								MotorBPlus_i <= '1';
								MotorBMinus_i <= '0';
								
						end case;
				
					end if;
				
				end if;
				
			end if;
			
		end if;

	end process; --(clock)

end FourWireStepperMotor;

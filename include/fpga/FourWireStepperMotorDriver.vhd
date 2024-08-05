--------------------------------------------------------------------------------
--
-- Four Wire Stepper Motor Driver
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity FourWireStepperMotorDriverPorts is
	generic (
		CLOCK_FREQHZ : natural := 10000000;
		MOTOR_STEP_SECONDS : real := 0.001--;
	);
    port (
		clk : in std_logic;
		rst : in std_logic;

		--inputs
		SeekStep : in std_logic_vector(15 downto 0);
		
		--outputs
		CurrentStep : out std_logic_vector(15 downto 0);
		
		MotorAPlus : out std_logic;
		MotorAMinus : out std_logic;
		MotorBPlus : out std_logic;
		MotorBMinus : out std_logic--;
	);
end FourWireStepperMotorDriverPorts;

architecture FourWireStepperMotorDriver of FourWireStepperMotorDriverPorts is

		component OneShotPorts is
		generic (
			CLOCK_FREQHZ : natural := 10000000;
			DELAY_SECONDS : real := 0.001;
			SHOT_RST_STATE : std_logic := '0';
			SHOT_PRETRIGGER_STATE : std_logic := '0'--;
		);
		port (
		
			clk : in std_logic;
			rst : in std_logic;
			shot : out std_logic
		);
		end component;

		component FourWireStepperMotorPorts is
		port 
		(		
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
		end component;
		
	signal CurrentStep_i : std_logic_vector(15 downto 0);
	signal Direction : std_logic;
	signal MotorStopped : std_logic;
	signal MotorStep : std_logic;
	signal InTransit : std_logic;
	
	signal MotorAPlus_i : std_logic;
	signal MotorAMinus_i : std_logic;
	signal MotorBPlus_i : std_logic;
	signal MotorBMinus_i : std_logic;
	
	--Constants of the right length...
	--~ constant DeltaSaturated : std_logic_vector(MAX_CLOCK_BITS_DELTA - 1 downto 0) := std_logic_vector(to_unsigned((2 ** (MAX_CLOCK_BITS_DELTA - 1)) - 1, MAX_CLOCK_BITS_DELTA));
	
begin

	StepOneShot : OneShotPorts
	generic map (
		CLOCK_FREQHZ => CLOCK_FREQHZ,
		DELAY_SECONDS => MOTOR_STEP_SECONDS,
		SHOT_RST_STATE => '0',
		SHOT_PRETRIGGER_STATE => '0'
	)
	port map (		
		clk => clk,
		rst => MotorStopped,
		shot => MotorStep--,
	);
	
	StepperMotor : FourWireStepperMotorPorts
	port map
	(
		clk => clk,
		rst => rst,
		Direction => Direction,
		Step => MotorStep,
		MotorAPlus => MotorAPlus_i,
		MotorAMinus => MotorAMinus_i,
		MotorBPlus => MotorBPlus_i,
		MotorBMinus => MotorBMinus_i--,
	);	
	
	CurrentStep <= CurrentStep_i;
	
	--We really don't need static holding force in most use-cases, it wastes power and heats things up!
	MotorAPlus <= MotorAPlus_i when (InTransit = '1') else '0';
	MotorAMinus <= MotorAMinus_i when (InTransit = '1') else '0';
	MotorBPlus <= MotorBPlus_i when (InTransit = '1') else '0';
	MotorBMinus <= MotorBMinus_i when (InTransit = '1') else '0';
	
	-- Master clock drives most logic
	process (clk, rst)
	begin
		if (rst = '1') then
		
			CurrentStep_i <= x"0000";
			Direction <= '0';
			MotorStopped <= '1';
			InTransit <= '0';
			
		else
		
			if ( (clk'event) and (clk = '1') ) then
			
				if (CurrentStep_i /= SeekStep) then
				
					InTransit <= '1';						
				
					if (SeekStep > CurrentStep_i) then Direction <= '1'; else Direction <= '0'; end if;
					
					if (MotorStep = '0') then 
					
						MotorStopped <= '0';
						
					else
					
						if (SeekStep > CurrentStep_i) then CurrentStep_i <= CurrentStep_i + x"0001"; else CurrentStep_i <= CurrentStep_i - x"0001"; end if;
						
						MotorStopped <= '1';
						
					end if;
			
				else
				
					InTransit <= '0';
					
					MotorStopped <= '1';
					
				end if;			
				
			end if;
			
		end if;

	end process; --(clock)

end FourWireStepperMotorDriver;

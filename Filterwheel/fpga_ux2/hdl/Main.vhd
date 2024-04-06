--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Main is
port (
    --clk : in  std_logic; -- example
	
	--Repurposed output pins from the debug connector:
	PosLEDEnA : out std_logic;
	PosLEDEnB : out std_logic;
	MotorDriveBPlusPrime : out std_logic;
	MotorDriveBMinusPrime : out std_logic;
	MotorDriveBMinus : out std_logic;
	MotorDriveBPlus : out std_logic;
	
	--Repurposed input pins from the first DM controller channel connectors (loopback cable req'd for operation!):
	PosLEDEnA_InFromUx1 : in std_logic;
	PosLEDEnB_InFromUx1 : in std_logic;
	MotorDriveBPlusPrime_InFromUx1 : in std_logic;
	MotorDriveBMinusPrime_InFromUx1 : in std_logic;
	MotorDriveBMinus_InFromUx1 : in std_logic;
	MotorDriveBPlus_InFromUx1 : in std_logic--;
);
end Main;
architecture architecture_Main of Main is
   
begin

	--Just keepin' it basic =P
	PosLEDEnA <= PosLEDEnA_InFromUx1;
	PosLEDEnB <= PosLEDEnB_InFromUx1;
	MotorDriveBPlusPrime <= MotorDriveBPlusPrime_InFromUx1;
	MotorDriveBMinusPrime <= MotorDriveBMinusPrime_InFromUx1;
	MotorDriveBMinus <= MotorDriveBMinus_InFromUx1;
	MotorDriveBPlus <= MotorDriveBPlus_InFromUx1;

end architecture_Main;

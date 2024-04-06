--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Main is
port (
    clk : in  std_logic;
	
	--Light outputs
	PosLEDEnA : out std_logic;
	PosLEDEnB : out std_logic;
	
	--Photodetector Inputs
	PosSenseHomeA : in std_logic;
	PosSenseBit0A : in std_logic;
	PosSenseBit1A : in std_logic;
	PosSenseBit2A : in std_logic;
	PosSenseHomeB : in std_logic;
	PosSenseBit0B : in std_logic;
	PosSenseBit1B : in std_logic;
	PosSenseBit2B : in std_logic;
	
	--N-Type H-Bridge
	MotorDriveAPlus : out std_logic;
	MotorDriveAMinus : out std_logic;
	MotorDriveBPlus : out std_logic;
	MotorDriveBMinus : out std_logic;
	
	--CMOS H-Bridge
	MotorDriveAPlusPrime : out std_logic;
	MotorDriveAMinusPrime : out std_logic;
	MotorDriveBPlusPrime : out std_logic;
	MotorDriveBMinusPrime : out std_logic;
);
end Main;
architecture architecture_Main of Main is
   
begin

	
end architecture_Main;

--
-- Synopsys
-- Vhdl wrapper for top level design, written on Wed Mar 26 16:47:46 2025
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wrapper_for_Main is
   port (
      clk : in std_logic;
      rst_out : out std_logic;
      nCsXO : out std_logic;
      SckXO : out std_logic;
      MosiXO : out std_logic;
      PosLEDEnA : out std_logic;
      PosLEDEnB : out std_logic;
      PosSenseHomeA : in std_logic;
      PosSenseBit0A : in std_logic;
      PosSenseBit1A : in std_logic;
      PosSenseBit2A : in std_logic;
      PosSenseHomeB : in std_logic;
      PosSenseBit0B : in std_logic;
      PosSenseBit1B : in std_logic;
      PosSenseBit2B : in std_logic;
      MotorDriveAPlus : out std_logic;
      MotorDriveAMinus : out std_logic;
      MotorDriveBPlus : out std_logic;
      MotorDriveBMinus : out std_logic;
      MotorDriveAPlusPrime : out std_logic;
      MotorDriveAMinusPrime : out std_logic;
      MotorDriveBPlusPrime : out std_logic;
      MotorDriveBMinusPrime : out std_logic;
      RamBusAddress : in std_logic_vector(9 downto 0);
      RamBusDataIn : in std_logic_vector(31 downto 0);
      RamBusDataOut : out std_logic_vector(31 downto 0);
      RamBusnCs : in std_logic;
      RamBusWrnRd : in std_logic;
      RamBusLatch : in std_logic;
      RamBusAck : out std_logic;
      Txd0 : out std_logic;
      Oe0 : out std_logic;
      Rxd0 : in std_logic;
      Txd1 : out std_logic;
      Oe1 : out std_logic;
      Rxd1 : in std_logic;
      Txd2 : out std_logic;
      Oe2 : out std_logic;
      Rxd2 : in std_logic;
      Txd3 : out std_logic;
      Oe3 : out std_logic;
      Rxd3 : in std_logic;
      RxdUsb : out std_logic;
      TxdUsb : in std_logic;
      CtsUsb : out std_logic;
      TxdGps : out std_logic;
      RxdGps : in std_logic;
      PPS : in std_logic;
      nCsMonAdc0 : out std_logic;
      SckMonAdc0 : out std_logic;
      MosiMonAdc0 : out std_logic;
      MisoMonAdc0 : in std_logic;
      nDrdyMonAdc0 : in std_logic;
      nFaultClr1V : out std_logic;
      nFaultClr3V : out std_logic;
      nFaultClr5V : out std_logic;
      nPowerCycClr : out std_logic;
      PowernEn5V : out std_logic;
      PowerSync : out std_logic;
      Fault1V : in std_logic;
      Fault3V : in std_logic;
      Fault5V : in std_logic;
      PowerCycd : in std_logic;
      LedR : out std_logic;
      LedG : out std_logic;
      LedB : out std_logic;
      TP1 : out std_logic;
      TP2 : out std_logic;
      TP3 : out std_logic;
      TP4 : out std_logic;
      TP5 : out std_logic;
      TP6 : out std_logic;
      TP7 : out std_logic;
      TP8 : out std_logic;
      Ux1SelJmp : in std_logic
   );
end wrapper_for_Main;

architecture architecture_main of wrapper_for_Main is

component Main
 port (
   clk : in std_logic;
   rst_out : out std_logic;
   nCsXO : out std_logic;
   SckXO : out std_logic;
   MosiXO : out std_logic;
   PosLEDEnA : out std_logic;
   PosLEDEnB : out std_logic;
   PosSenseHomeA : in std_logic;
   PosSenseBit0A : in std_logic;
   PosSenseBit1A : in std_logic;
   PosSenseBit2A : in std_logic;
   PosSenseHomeB : in std_logic;
   PosSenseBit0B : in std_logic;
   PosSenseBit1B : in std_logic;
   PosSenseBit2B : in std_logic;
   MotorDriveAPlus : out std_logic;
   MotorDriveAMinus : out std_logic;
   MotorDriveBPlus : out std_logic;
   MotorDriveBMinus : out std_logic;
   MotorDriveAPlusPrime : out std_logic;
   MotorDriveAMinusPrime : out std_logic;
   MotorDriveBPlusPrime : out std_logic;
   MotorDriveBMinusPrime : out std_logic;
   RamBusAddress : in std_logic_vector (9 downto 0);
   RamBusDataIn : in std_logic_vector (31 downto 0);
   RamBusDataOut : out std_logic_vector (31 downto 0);
   RamBusnCs : in std_logic;
   RamBusWrnRd : in std_logic;
   RamBusLatch : in std_logic;
   RamBusAck : out std_logic;
   Txd0 : out std_logic;
   Oe0 : out std_logic;
   Rxd0 : in std_logic;
   Txd1 : out std_logic;
   Oe1 : out std_logic;
   Rxd1 : in std_logic;
   Txd2 : out std_logic;
   Oe2 : out std_logic;
   Rxd2 : in std_logic;
   Txd3 : out std_logic;
   Oe3 : out std_logic;
   Rxd3 : in std_logic;
   RxdUsb : out std_logic;
   TxdUsb : in std_logic;
   CtsUsb : out std_logic;
   TxdGps : out std_logic;
   RxdGps : in std_logic;
   PPS : in std_logic;
   nCsMonAdc0 : out std_logic;
   SckMonAdc0 : out std_logic;
   MosiMonAdc0 : out std_logic;
   MisoMonAdc0 : in std_logic;
   nDrdyMonAdc0 : in std_logic;
   nFaultClr1V : out std_logic;
   nFaultClr3V : out std_logic;
   nFaultClr5V : out std_logic;
   nPowerCycClr : out std_logic;
   PowernEn5V : out std_logic;
   PowerSync : out std_logic;
   Fault1V : in std_logic;
   Fault3V : in std_logic;
   Fault5V : in std_logic;
   PowerCycd : in std_logic;
   LedR : out std_logic;
   LedG : out std_logic;
   LedB : out std_logic;
   TP1 : out std_logic;
   TP2 : out std_logic;
   TP3 : out std_logic;
   TP4 : out std_logic;
   TP5 : out std_logic;
   TP6 : out std_logic;
   TP7 : out std_logic;
   TP8 : out std_logic;
   Ux1SelJmp : inout std_logic
 );
end component;

signal tmp_clk : std_logic;
signal tmp_rst_out : std_logic;
signal tmp_nCsXO : std_logic;
signal tmp_SckXO : std_logic;
signal tmp_MosiXO : std_logic;
signal tmp_PosLEDEnA : std_logic;
signal tmp_PosLEDEnB : std_logic;
signal tmp_PosSenseHomeA : std_logic;
signal tmp_PosSenseBit0A : std_logic;
signal tmp_PosSenseBit1A : std_logic;
signal tmp_PosSenseBit2A : std_logic;
signal tmp_PosSenseHomeB : std_logic;
signal tmp_PosSenseBit0B : std_logic;
signal tmp_PosSenseBit1B : std_logic;
signal tmp_PosSenseBit2B : std_logic;
signal tmp_MotorDriveAPlus : std_logic;
signal tmp_MotorDriveAMinus : std_logic;
signal tmp_MotorDriveBPlus : std_logic;
signal tmp_MotorDriveBMinus : std_logic;
signal tmp_MotorDriveAPlusPrime : std_logic;
signal tmp_MotorDriveAMinusPrime : std_logic;
signal tmp_MotorDriveBPlusPrime : std_logic;
signal tmp_MotorDriveBMinusPrime : std_logic;
signal tmp_RamBusAddress : std_logic_vector (9 downto 0);
signal tmp_RamBusDataIn : std_logic_vector (31 downto 0);
signal tmp_RamBusDataOut : std_logic_vector (31 downto 0);
signal tmp_RamBusnCs : std_logic;
signal tmp_RamBusWrnRd : std_logic;
signal tmp_RamBusLatch : std_logic;
signal tmp_RamBusAck : std_logic;
signal tmp_Txd0 : std_logic;
signal tmp_Oe0 : std_logic;
signal tmp_Rxd0 : std_logic;
signal tmp_Txd1 : std_logic;
signal tmp_Oe1 : std_logic;
signal tmp_Rxd1 : std_logic;
signal tmp_Txd2 : std_logic;
signal tmp_Oe2 : std_logic;
signal tmp_Rxd2 : std_logic;
signal tmp_Txd3 : std_logic;
signal tmp_Oe3 : std_logic;
signal tmp_Rxd3 : std_logic;
signal tmp_RxdUsb : std_logic;
signal tmp_TxdUsb : std_logic;
signal tmp_CtsUsb : std_logic;
signal tmp_TxdGps : std_logic;
signal tmp_RxdGps : std_logic;
signal tmp_PPS : std_logic;
signal tmp_nCsMonAdc0 : std_logic;
signal tmp_SckMonAdc0 : std_logic;
signal tmp_MosiMonAdc0 : std_logic;
signal tmp_MisoMonAdc0 : std_logic;
signal tmp_nDrdyMonAdc0 : std_logic;
signal tmp_nFaultClr1V : std_logic;
signal tmp_nFaultClr3V : std_logic;
signal tmp_nFaultClr5V : std_logic;
signal tmp_nPowerCycClr : std_logic;
signal tmp_PowernEn5V : std_logic;
signal tmp_PowerSync : std_logic;
signal tmp_Fault1V : std_logic;
signal tmp_Fault3V : std_logic;
signal tmp_Fault5V : std_logic;
signal tmp_PowerCycd : std_logic;
signal tmp_LedR : std_logic;
signal tmp_LedG : std_logic;
signal tmp_LedB : std_logic;
signal tmp_TP1 : std_logic;
signal tmp_TP2 : std_logic;
signal tmp_TP3 : std_logic;
signal tmp_TP4 : std_logic;
signal tmp_TP5 : std_logic;
signal tmp_TP6 : std_logic;
signal tmp_TP7 : std_logic;
signal tmp_TP8 : std_logic;
signal tmp_Ux1SelJmp : std_logic;

begin

tmp_clk <= clk;

rst_out <= tmp_rst_out;

nCsXO <= tmp_nCsXO;

SckXO <= tmp_SckXO;

MosiXO <= tmp_MosiXO;

PosLEDEnA <= tmp_PosLEDEnA;

PosLEDEnB <= tmp_PosLEDEnB;

tmp_PosSenseHomeA <= PosSenseHomeA;

tmp_PosSenseBit0A <= PosSenseBit0A;

tmp_PosSenseBit1A <= PosSenseBit1A;

tmp_PosSenseBit2A <= PosSenseBit2A;

tmp_PosSenseHomeB <= PosSenseHomeB;

tmp_PosSenseBit0B <= PosSenseBit0B;

tmp_PosSenseBit1B <= PosSenseBit1B;

tmp_PosSenseBit2B <= PosSenseBit2B;

MotorDriveAPlus <= tmp_MotorDriveAPlus;

MotorDriveAMinus <= tmp_MotorDriveAMinus;

MotorDriveBPlus <= tmp_MotorDriveBPlus;

MotorDriveBMinus <= tmp_MotorDriveBMinus;

MotorDriveAPlusPrime <= tmp_MotorDriveAPlusPrime;

MotorDriveAMinusPrime <= tmp_MotorDriveAMinusPrime;

MotorDriveBPlusPrime <= tmp_MotorDriveBPlusPrime;

MotorDriveBMinusPrime <= tmp_MotorDriveBMinusPrime;

tmp_RamBusAddress <= RamBusAddress;

tmp_RamBusDataIn <= RamBusDataIn;

RamBusDataOut <= tmp_RamBusDataOut;

tmp_RamBusnCs <= RamBusnCs;

tmp_RamBusWrnRd <= RamBusWrnRd;

tmp_RamBusLatch <= RamBusLatch;

RamBusAck <= tmp_RamBusAck;

Txd0 <= tmp_Txd0;

Oe0 <= tmp_Oe0;

tmp_Rxd0 <= Rxd0;

Txd1 <= tmp_Txd1;

Oe1 <= tmp_Oe1;

tmp_Rxd1 <= Rxd1;

Txd2 <= tmp_Txd2;

Oe2 <= tmp_Oe2;

tmp_Rxd2 <= Rxd2;

Txd3 <= tmp_Txd3;

Oe3 <= tmp_Oe3;

tmp_Rxd3 <= Rxd3;

RxdUsb <= tmp_RxdUsb;

tmp_TxdUsb <= TxdUsb;

CtsUsb <= tmp_CtsUsb;

TxdGps <= tmp_TxdGps;

tmp_RxdGps <= RxdGps;

tmp_PPS <= PPS;

nCsMonAdc0 <= tmp_nCsMonAdc0;

SckMonAdc0 <= tmp_SckMonAdc0;

MosiMonAdc0 <= tmp_MosiMonAdc0;

tmp_MisoMonAdc0 <= MisoMonAdc0;

tmp_nDrdyMonAdc0 <= nDrdyMonAdc0;

nFaultClr1V <= tmp_nFaultClr1V;

nFaultClr3V <= tmp_nFaultClr3V;

nFaultClr5V <= tmp_nFaultClr5V;

nPowerCycClr <= tmp_nPowerCycClr;

PowernEn5V <= tmp_PowernEn5V;

PowerSync <= tmp_PowerSync;

tmp_Fault1V <= Fault1V;

tmp_Fault3V <= Fault3V;

tmp_Fault5V <= Fault5V;

tmp_PowerCycd <= PowerCycd;

LedR <= tmp_LedR;

LedG <= tmp_LedG;

LedB <= tmp_LedB;

TP1 <= tmp_TP1;

TP2 <= tmp_TP2;

TP3 <= tmp_TP3;

TP4 <= tmp_TP4;

TP5 <= tmp_TP5;

TP6 <= tmp_TP6;

TP7 <= tmp_TP7;

TP8 <= tmp_TP8;

tmp_Ux1SelJmp <= Ux1SelJmp;



u1:   Main port map (
		clk => tmp_clk,
		rst_out => tmp_rst_out,
		nCsXO => tmp_nCsXO,
		SckXO => tmp_SckXO,
		MosiXO => tmp_MosiXO,
		PosLEDEnA => tmp_PosLEDEnA,
		PosLEDEnB => tmp_PosLEDEnB,
		PosSenseHomeA => tmp_PosSenseHomeA,
		PosSenseBit0A => tmp_PosSenseBit0A,
		PosSenseBit1A => tmp_PosSenseBit1A,
		PosSenseBit2A => tmp_PosSenseBit2A,
		PosSenseHomeB => tmp_PosSenseHomeB,
		PosSenseBit0B => tmp_PosSenseBit0B,
		PosSenseBit1B => tmp_PosSenseBit1B,
		PosSenseBit2B => tmp_PosSenseBit2B,
		MotorDriveAPlus => tmp_MotorDriveAPlus,
		MotorDriveAMinus => tmp_MotorDriveAMinus,
		MotorDriveBPlus => tmp_MotorDriveBPlus,
		MotorDriveBMinus => tmp_MotorDriveBMinus,
		MotorDriveAPlusPrime => tmp_MotorDriveAPlusPrime,
		MotorDriveAMinusPrime => tmp_MotorDriveAMinusPrime,
		MotorDriveBPlusPrime => tmp_MotorDriveBPlusPrime,
		MotorDriveBMinusPrime => tmp_MotorDriveBMinusPrime,
		RamBusAddress => tmp_RamBusAddress,
		RamBusDataIn => tmp_RamBusDataIn,
		RamBusDataOut => tmp_RamBusDataOut,
		RamBusnCs => tmp_RamBusnCs,
		RamBusWrnRd => tmp_RamBusWrnRd,
		RamBusLatch => tmp_RamBusLatch,
		RamBusAck => tmp_RamBusAck,
		Txd0 => tmp_Txd0,
		Oe0 => tmp_Oe0,
		Rxd0 => tmp_Rxd0,
		Txd1 => tmp_Txd1,
		Oe1 => tmp_Oe1,
		Rxd1 => tmp_Rxd1,
		Txd2 => tmp_Txd2,
		Oe2 => tmp_Oe2,
		Rxd2 => tmp_Rxd2,
		Txd3 => tmp_Txd3,
		Oe3 => tmp_Oe3,
		Rxd3 => tmp_Rxd3,
		RxdUsb => tmp_RxdUsb,
		TxdUsb => tmp_TxdUsb,
		CtsUsb => tmp_CtsUsb,
		TxdGps => tmp_TxdGps,
		RxdGps => tmp_RxdGps,
		PPS => tmp_PPS,
		nCsMonAdc0 => tmp_nCsMonAdc0,
		SckMonAdc0 => tmp_SckMonAdc0,
		MosiMonAdc0 => tmp_MosiMonAdc0,
		MisoMonAdc0 => tmp_MisoMonAdc0,
		nDrdyMonAdc0 => tmp_nDrdyMonAdc0,
		nFaultClr1V => tmp_nFaultClr1V,
		nFaultClr3V => tmp_nFaultClr3V,
		nFaultClr5V => tmp_nFaultClr5V,
		nPowerCycClr => tmp_nPowerCycClr,
		PowernEn5V => tmp_PowernEn5V,
		PowerSync => tmp_PowerSync,
		Fault1V => tmp_Fault1V,
		Fault3V => tmp_Fault3V,
		Fault5V => tmp_Fault5V,
		PowerCycd => tmp_PowerCycd,
		LedR => tmp_LedR,
		LedG => tmp_LedG,
		LedB => tmp_LedB,
		TP1 => tmp_TP1,
		TP2 => tmp_TP2,
		TP3 => tmp_TP3,
		TP4 => tmp_TP4,
		TP5 => tmp_TP5,
		TP6 => tmp_TP6,
		TP7 => tmp_TP7,
		TP8 => tmp_TP8,
		Ux1SelJmp => tmp_Ux1SelJmp
       );
end architecture_main;

--------------------------------------------------------------------------------
-- Zonge BD457 Z3 High-res A/D firmware
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity MountainOperatorPorts is
    port (	
			-- Arm uC Connections

				RstuC : inout std_logic;
				TxduC0 : out std_logic;
				RxduC0 : in std_logic;
				TxduC1 : out std_logic;
				RxduC1 : in std_logic;
				ArmMosi : in std_logic;
				ArmSck : in std_logic;
				ArmMiso : out std_logic;
				--~ nCsAdcuC : in std_logic;
				X0 : out std_logic;
				X1 : in std_logic;
				X2 : in std_logic;
				--~ X3 : in std_logic; 
				UConnuC : out std_logic;
				RamBusAddress : in std_logic_vector(15 downto 0); 
				RamBusData : inout std_logic_vector(15 downto 0); 
				--~ RamBusData : out std_logic_vector(15 downto 0); 
				RamBusnCs : in std_logic_vector(2 downto 0); 
				--~ RamBusDqm : in std_logic_vector(1 downto 0); 
				RamBusWE : in std_logic;
				RamBusOE : in std_logic;
				--~ RamBusRdy : out std_logic;
				
			-- Usb Connections

				TxdUsb : out std_logic;
				RxdUsb : in std_logic;
				--~ RtsUsb : in std_logic;
				--~ CtsUsb : in std_logic;
				--~ DtrUsb : in std_logic;
				UsbConn : in std_logic;
				UsbSw : out std_logic;
				
			-- ZigBee Connections

				RstZig : out std_logic;
				RxdZig : in std_logic;
				TxdZig : out std_logic; --Now Rst Zig
				CtsZig : in std_logic; --Now TXD Zig
				RtsZig : out std_logic; --Now RXD Zig
				
			--  Power / DC/DC Converter Connections

				SyncDCDC : out std_logic; -- 0.9-1.1MHz clk for switching powersupplies
				PwrSD : out std_logic;
				PwrRadio : out std_logic;
				
			-- Clock / Sync / Gps Connections

				VCXO : in std_logic;
				
				--~ ClkO : out std_logic;
				
				TxdGps : in std_logic; --note: unlike other txd/rxd's this is the direct net to the ResT, not across connector blocks, and therefore Txd is an input from ResT, unlike other txd's which are outputs
				RxdGps : out std_logic; --dito swapped rxd to output
				PpsGps : in std_logic; --pps is always an input, however...

				TxdAClk : out std_logic;
				RxdAClk : in std_logic;

				nCsClk : out std_logic;
				SckClk : out std_logic;
				MosiClk : out std_logic;
				MisoClk : in std_logic; -- reserved; not on hardware; we are looping back in sw
				
			-- A/D Connections
				
				SarAdcTrig : out std_logic;
				SarAdcSck : out std_logic;
				SarAdcMiso : in std_logic;
				SarAdcnCs : out std_logic;
				SarAdcnDrdy : in std_logic;

				AdcGainMux : out std_logic_vector(5 downto 0); --sets mux to change gain resistors
				ChopperMuxPos : out std_logic;
				ChopperMuxNeg : out std_logic;
				
			-- External SPI Connections
			
				SckSpiExt : inout std_logic;
				MosiSpiExt : inout std_logic;
				MisoSpiExt : inout std_logic;
				nCsSpiExt0 : inout std_logic;
				nCsSpiExt1 : inout std_logic;
				nCsSpiExt2 : inout std_logic;
				GpsRxdSpiExt : inout std_logic;
				GpsPpsSpiExt : inout std_logic;
			
			-- Mux/Aux Spi Connections
			
				--!! unfortunately, the Brd355v3.0 connects these (SpiAux) directly to the SpiExt pins internally, so these must all float to use SpiExt bus!!
				SckAux : inout std_logic;
				MosiAux : inout std_logic;
				MisoAux : inout std_logic;
				nCs0Aux : inout std_logic;
				nCs1Aux : inout std_logic;
				nCs2Aux : inout std_logic;
				PeriodAux : out std_logic;
				DutyAux : out std_logic;
				
			-- Zonge Timing Chain
				
				ZPeriod : out std_logic;
				ZDuty : out std_logic;
				--~ ZRst : in std_logic;
				--~ ZRst2 : out std_logic;
				TxdXMT : out std_logic;
				RxdXMT : in std_logic;
				--~ ZIO6 : inout std_logic;
				--~ ZIO7 : inout std_logic;
				
			-- GPIO Connections
				
				LedR : out std_logic;
				LedG : out std_logic;
				--~ TP3 : out std_logic;
				TP3 : inout std_logic;
				TP4 : out std_logic;
				TP5 : out std_logic;
				TP6 : out std_logic;
				TP7 : out std_logic;
				TP8 : out std_logic--;
	);
end MountainOperatorPorts;

architecture MountainOperator of MountainOperatorPorts is

	--attribute altera_attribute : string;
	--attribute altera_attribute of my_pin1: signal is "-name FAST_INPUT_REGISTER ON";	
	attribute chip_pin : string;	
	attribute chip_pin of RstuC : signal is "J5";
	--attribute chip_pin of nCsuC : signal is "M6";
	attribute chip_pin of TxduC0 : signal is "C14"; --labeled tx connected to rx multiple times in sch. this way works with the actual h/w...
	attribute chip_pin of RxduC0 : signal is "D14"; --labeled tx connected to rx multiple times in sch. this way works with the actual h/w...
	attribute chip_pin of TxduC1 : signal is "H6"; --labeled tx connected to rx multiple times in sch. this way works with the actual h/w...
	attribute chip_pin of RxduC1 : signal is "H5"; --labeled tx connected to rx multiple times in sch. this way works with the actual h/w...
	--attribute chip_pin of CtsuC : signal is "C9"; --in std_logic;
	--attribute chip_pin of RtsuC : signal is "E9"; --in std_logic;
	--attribute chip_pin of PwmuC : signal is "C10"; --in std_logic;
	attribute chip_pin of ArmMosi : signal is "A10"; --in std_logic;
	attribute chip_pin of ArmSck : signal is "A12"; --in std_logic;
	attribute chip_pin of ArmMiso : signal is "A11"; --out std_logic;
	--attribute chip_pin of ArmnCs : signal is "A14"; --out std_logic;
	--attribute chip_pin of nCsAdcuC : signal is ""; --in std_logic;
	attribute chip_pin of X0 : signal is "F11"; --in std_logic;
	attribute chip_pin of X1 : signal is "A13"; --in std_logic;
	attribute chip_pin of X2 : signal is "C12"; --in std_logic;
	--attribute chip_pin of X3 : signal is "E11"; --in std_logic; 
	attribute chip_pin of UConnuC : signal is "G2"; --out std_logic;
	attribute chip_pin of RamBusData    : signal is "P4, P2, R1, R2, T2, R3, T3, R4, T4, P5, R5, T5, P6, R6, T6, R7";
	attribute chip_pin of RamBusAddress : signal is "B5, A5, B6, A6, B7, A7, A8, B9, B1, C1, B2, B3, C3, C4, C6, D9";
	--attribute chip_pin of RamBusAddress(0) : signal is "D9"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusAddress(1) : signal is "C6"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusAddress(2) : signal is "C4"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusAddress(3) : signal is "C3"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusAddress(4) : signal is "B3"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusAddress(5) : signal is "B2"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusAddress(6) : signal is "C1"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusAddress(7) : signal is "B1"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusAddress(8) : signal is "B9"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusAddress(9) : signal is "A8"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusAddress(10) : signal is "A7"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusAddress(11) : signal is "B7"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusAddress(12) : signal is "A6"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusAddress(13) : signal is "B6"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusAddress(14) : signal is "A5"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusAddress(15) : signal is "B5"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusData(0) : signal is "R7"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusData(1) : signal is "T6"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusData(2) : signal is "R6"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusData(3) : signal is "P6"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusData(4) : signal is "T5"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusData(5) : signal is "R5"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusData(6) : signal is "P5"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusData(7) : signal is "T4"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusData(8) : signal is "R4"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusData(9) : signal is "T3"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusData(10) : signal is "R3"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusData(11) : signal is "T2"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusData(12) : signal is "R2"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusData(13) : signal is "R1"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusData(14) : signal is "P2"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusData(15) : signal is "P4"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of RamBusData(16) : signal is "N5"; --in std_logic_vector(15 downto 0); 
	attribute chip_pin of RamBusnCs : signal is "F12, F10, E10"; --in std_logic_vector(2 downto 0); 
	--attribute chip_pin of RamBusnCs(0) : signal is "E10"; --in std_logic_vector(2 downto 0); 
	--attribute chip_pin of RamBusnCs(1) : signal is "F10"; --in std_logic_vector(2 downto 0); 
	--attribute chip_pin of RamBusnCs(2) : signal is "F12"; --in std_logic_vector(2 downto 0); 
	--attribute chip_pin of RamBusDqm : signal is "B4, A4"; --in std_logic_vector(1 downto 0); 
	--attribute chip_pin of RamBusDqm(0) : signal is "A4"; --in std_logic_vector(1 downto 0); 
	--attribute chip_pin of RamBusDqm(1) : signal is "B4"; --in std_logic_vector(1 downto 0); 
	attribute chip_pin of RamBusWE : signal is "A3"; --in std_logic;
	attribute chip_pin of RamBusOE : signal is "C2"; --in std_logic;
	--attribute chip_pin of RamBusRdWr : signal is "A2"; --in std_logic;
	--attribute chip_pin of RamBusRdy : signal is "B12"; --in std_logic;
	--attribute chip_pin of RamBusPwe : signal is "B11"; --in std_logic;
	attribute chip_pin of PwrSD : signal is "T11"; --out std_logic;
	attribute chip_pin of PwrRadio : signal is "F9"; --out std_logic;
	attribute chip_pin of TxdUsb : signal is "P15"; --out std_logic;
	attribute chip_pin of RxdUsb : signal is "N14"; --in std_logic;
	--attribute chip_pin of RtsUsb : signal is "P16"; --in std_logic;
	--attribute chip_pin of CtsUsb : signal is "R12"; --in std_logic;
	--attribute chip_pin of DtrUsb : signal is "R15"; --in std_logic;
	attribute chip_pin of UsbConn : signal is "T8"; --in std_logic;
	attribute chip_pin of UsbSw : signal is "T15"; --out std_logic;
	attribute chip_pin of RstZig : signal is "N1"; --out std_logic;
	attribute chip_pin of RxdZig : signal is "L2"; --in std_logic; --fpga: rx, zig: tx
	attribute chip_pin of TxdZig : signal is "M2"; --out std_logic; --fpga: tx, zig: rx
	attribute chip_pin of CtsZig : signal is "K2"; --in std_logic;  --fpga: tx, zig: rx (?)
	attribute chip_pin of RtsZig : signal is "L1"; --out std_logic;
	attribute chip_pin of SyncDCDC : signal is "R8"; --out std_logic; -- 0.9-1.1MHz clk for switching powersupplies
	attribute chip_pin of VCXO : signal is "M3"; --in std_logic;
	attribute chip_pin of TxdGps : signal is "M11"; --in std_logic; --note : signal is ""; --unlike other txd/rxd's this is the direct net to the ResT, not across connector blocks, and therefore Txd is an input from ResT, unlike other txd's which are outputs
	attribute chip_pin of RxdGps : signal is "L12"; --out std_logic; --dito swapped rxd to output
	attribute chip_pin of PpsGps : signal is "K14"; --in std_logic; --pps is always an input, however...
	attribute chip_pin of RxdAClk : signal is "J14"; --in std_logic; --pps is always an input, however...
	attribute chip_pin of TxdAClk : signal is "L11"; --in std_logic; --pps is always an input, however...
	attribute chip_pin of nCsClk : signal is "J6"; --out std_logic;
	attribute chip_pin of SckClk : signal is "K6"; --out std_logic;
	attribute chip_pin of MosiClk : signal is "P1"; --out std_logic;
	attribute chip_pin of MisoClk : signal is "N2"; --in std_logic; -- reserved; not on hardware; we are looping back in sw
	attribute chip_pin of SarAdcTrig : signal is "M15"; --out std_logic;
	attribute chip_pin of SarAdcSck : signal is "N16"; --out std_logic;
	attribute chip_pin of SarAdcMiso : signal is "M14"; --in std_logic;
	attribute chip_pin of SarAdcnCs : signal is "M16"; --out std_logic;
	attribute chip_pin of SarAdcnDrdy : signal is "L16"; --in std_logic;
	attribute chip_pin of AdcGainMux : signal is "K12, K11, J12, J15, J11, G11"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of AdcGainMux(0) : signal is "G11"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of AdcGainMux(1) : signal is "J11"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of AdcGainMux(2) : signal is "J15"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of AdcGainMux(3) : signal is "J12"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of AdcGainMux(4) : signal is "K11"; --in std_logic_vector(15 downto 0); 
	--attribute chip_pin of AdcGainMux(5) : signal is "K12"; --in std_logic_vector(15 downto 0); 
	attribute chip_pin of ChopperMuxPos : signal is "B16"; --inout std_logic;
	attribute chip_pin of ChopperMuxNeg : signal is "C16"; --inout std_logic;				
	attribute chip_pin of SckSpiExt : signal is "R14"; --inout std_logic;
	attribute chip_pin of MosiSpiExt : signal is "T14"; --inout std_logic;
	attribute chip_pin of MisoSpiExt : signal is "P14"; --inout std_logic;
	attribute chip_pin of nCsSpiExt0 : signal is "P10"; --inout std_logic;
	attribute chip_pin of nCsSpiExt1 : signal is "R11"; --inout std_logic;
	attribute chip_pin of nCsSpiExt2 : signal is "P11"; --inout std_logic;
	attribute chip_pin of GpsRxdSpiExt : signal is "T12"; --inout std_logic;
	attribute chip_pin of GpsPpsSpiExt : signal is "R10"; --inout std_logic;
	attribute chip_pin of SckAux : signal is "L9"; --inout std_logic;
	attribute chip_pin of MosiAux : signal is "M10"; --inout std_logic;
	attribute chip_pin of MisoAux : signal is "L10"; --inout std_logic;
	attribute chip_pin of nCs0Aux : signal is "M9"; --inout std_logic;
	attribute chip_pin of nCs1Aux : signal is "L7"; --inout std_logic;
	attribute chip_pin of nCs2Aux : signal is "L8"; --inout std_logic;
	--attribute chip_pin of PPSAux : signal is "P8"; --inout std_logic;
	attribute chip_pin of DutyAux : signal is "R9"; --inout std_logic;
	attribute chip_pin of PeriodAux : signal is "M7"; --inout std_logic;
	--attribute chip_pin of GpsRxAux : signal is "M8"; --inout std_logic;
	attribute chip_pin of ZPeriod : signal is "F4"; --out std_logic;
	--attribute chip_pin of ZPeriodIn : signal is "K5"; --out std_logic;
	attribute chip_pin of ZDuty : signal is "F5"; --out std_logic;
	--attribute chip_pin of ZDutyIn : signal is "F2"; --out std_logic;
	--attribute chip_pin of ZRst : signal is "B13"; --in std_logic;
	--attribute chip_pin of ZRst2 : signal is "C13"; --out std_logic;	
	--attribute chip_pin of ZIO6 : signal is "B15"; --inout std_logic;	
	--attribute chip_pin of ZIO6In : signal is "E1"; --inout std_logic;
	--attribute chip_pin of ZIO6OE : signal is "D1"; --inout std_logic;	
	--attribute chip_pin of ZIO7 : signal is "A15"; --inout std_logic;	
	--attribute chip_pin of ZIO7In : signal is "F1"; --inout std_logic;
	--attribute chip_pin of ZIO7OE : signal is "E3"; --inout std_logic;
	attribute chip_pin of TxdXMT : signal is "J3"; --out std_logic;
	attribute chip_pin of RxdXMT : signal is "J2"; --in std_logic;
	attribute chip_pin of LedR : signal is "N4"; --out std_logic;
	attribute chip_pin of LedG : signal is "N3"; --out std_logic;	
	attribute chip_pin of TP3 : signal is "T13"; --out std_logic;
	attribute chip_pin of TP4 : signal is "T7"; --out std_logic;
	attribute chip_pin of TP5 : signal is "M1"; --out std_logic;
	attribute chip_pin of TP6 : signal is "J1"; --out std_logic--;
	attribute chip_pin of TP7 : signal is "R16"; --out std_logic;
	attribute chip_pin of TP8 : signal is "A9"; --out std_logic--;	
	
	-- Component declarations - Boilerplate
				
						component IBufP2Ports is
						port (
							clk : in std_logic;
							I : in std_logic;
							O : out std_logic--;
						);
						end component;

						component IOBufP2Ports is
						port (
							clk : in std_logic;
							IO  : inout std_logic;
							T : in std_logic;
							I : in std_logic;
							O : out std_logic--;
						);
						end component;
						
						component ClockDividerPorts is
						generic (
							CLOCK_DIVIDER : natural := 10;
							DIVOUT_RST_STATE : std_logic := '0'--;
						);
						port (
						
							clk : in std_logic;
							rst : in std_logic;
							div : out std_logic
						);
						end component;
						
						component VariableClockDividerPorts is
						generic (
							WIDTH_BITS : natural := 8;
							DIVOUT_RST_STATE : std_logic := '0'--;
						);
						port 
						(						
							clki : in std_logic;
							rst : in std_logic;
							divisor : in std_logic_vector(WIDTH_BITS - 1 downto 0);
							clko : out std_logic
						);
						end component;
						
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

						component PPSCountPorts is
						port
						(
							clk : in std_logic;
							PPS : in std_logic;
							PPSReset : in std_logic;
							PPSCounter : out std_logic_vector(31 downto 0);
							PPSAccum : out std_logic_vector(31 downto 0)--;
						);
						end component;

						component RtcCounterPorts is
						generic (
							CLOCK_FREQ : natural := 100000000--;
						);
						port
						(
							clk : in std_logic;
							rst : in std_logic;
							PPS : in std_logic;
							PPSDetected : out std_logic;
							Sync : in std_logic;
							GeneratedPPS : out std_logic;
							SetTimeSeconds : in std_logic_vector(21 downto 0);
							SetTime : in std_logic;
							SetChangedTime : out std_logic;
							Seconds : out std_logic_vector(21 downto 0);
							Milliseconds : out std_logic_vector(9 downto 0)--;
						);
						end component;

						component DnaRegisterPorts is
						generic (
							BIT_WIDTH : natural := 16--;
						);
						port
						(
							clk : in std_logic;
							rst : in std_logic;
							DnaRegister : out std_logic_vector(BIT_WIDTH - 1 downto 0)--;
						);
						end component;
						
						component fifo is
						generic (
							WIDTH : natural := 32;
							DEPTH_BITS : natural := 9
						);
						port (
							clk		: in std_logic;
							rst		: in std_logic;
							wone_i	: in std_logic;
							data_i	: in std_logic_vector(WIDTH - 1 downto 0);
							rone_i	: in std_logic;
							full_o	: out std_logic;
							empty_o	: out std_logic;
							data_o	: out std_logic_vector(WIDTH - 1 downto 0);
							count_o	: out std_logic_vector(DEPTH_BITS - 1 downto 0);
							r_ack : out std_logic--;
						);
						end component;
						
						component SRamSlaveBusPorts is
						generic (
							INT_ADDRESS_BITS : natural := 8;
							INT_DATA_BITS : natural := 8;
							RAM_BASE_ADDR : std_logic_vector(15 downto 0) := x"6900"--; --bottom <INT_ADDRESS_BITS> lsb bits are ignored...
						);
						port (
							clk : in std_logic;
							--External bus signals:
							Addr : in std_logic_vector(15 downto 0);
							DataIn : in std_logic_vector(INT_DATA_BITS - 1 downto 0);
							DataOut : out std_logic_vector(INT_DATA_BITS - 1 downto 0);
							DataOutEn : out std_logic;
							OE : in std_logic;
							WE : in std_logic;
							--Internal bus signals:
							AddrMatch : out std_logic;
							IntAddress : out std_logic_vector(INT_ADDRESS_BITS - 1 downto 0);
							IntWriteData : out std_logic_vector(INT_DATA_BITS - 1 downto 0);
							IntWriteReq : out std_logic;
							IntWriteAck : in  std_logic;
							IntReadData : in std_logic_vector(INT_DATA_BITS - 1 downto 0);
							IntReadReq : out  std_logic;
							IntReadAck : in  std_logic
						);
						end component;
						
						component SpiRegistersPorts is
						port
						(
							ByteComplete : out std_logic;
							AddrLatched : out std_logic;
							
							clk : in std_logic;

							--Bus
							nCS : in std_logic;
							Mosi : in std_logic;
							Sck : in std_logic;
							Miso : out std_logic;
							nCsAck : out std_logic;

							--Registers
							Address : out std_logic_vector(6 downto 0);
							DataToWrite : out std_logic_vector(7 downto 0);
							DataWriteReq : out std_logic;
							DataWriteAck : in std_logic;
							DataFromRead : in std_logic_vector(7 downto 0);
							DataReadReq : out  std_logic;
							DataReadAck : in std_logic--;
						);
						end component;

						component DataMapperPorts is
						generic (
							RAM_ADDRESS_BITS : natural := 6;
							FIFO_BITS : natural := 10;
							MUX_ADDRESS_BITS : natural := 4 --;
						);
						port (
						
							clk : in std_logic;
							
							-- Data Flow:
							Address : in std_logic_vector(RAM_ADDRESS_BITS - 1 downto 0);
							DataToWrite : in std_logic_vector(15 downto 0);
							DataFromRead : out std_logic_vector(15 downto 0);
							DataReadReq : in  std_logic;
							DataWriteReq : in std_logic;
							DataReadAck : out std_logic;
							DataWriteAck : out std_logic;
							
							--Data to access:			
							AdcClkDivider : out std_logic_vector(15 downto 0);
							AdcPeriodDividerOut : out std_logic_vector(31 downto 0);
							AdcPeriodDividerIn : in std_logic_vector(31 downto 0);
							AdcDutyDividerOut : out std_logic_vector(31 downto 0);
							AdcDutyDividerIn : in std_logic_vector(31 downto 0);
							GeneratePps : out std_logic;
							UsingAtomicClock : out std_logic;		
							SyncPeriodDuty : out std_logic;
							PeriodDutySynced : in std_logic;
							SyncAdc : out std_logic;
							SarSyncCompleted : in std_logic;
							ResetSyncCompleted : out std_logic;		
							TxTriggerAdc : out std_logic;				
							PeriodTriggerQuadrant : out std_logic;		
							DutyTriggerQuadrant : out std_logic;		
							PeriodTriggerEither : out std_logic;		
							DutyTriggerEither : out std_logic;	
							PPSTriggerAdc : out std_logic;	
							AdcPeriod : in std_logic;
							AdcDuty : in std_logic;
							DutyOff : out std_logic;
							PPSDetected : in std_logic;
							SetChangedTime : in std_logic;
							PPSCount : in std_logic_vector(31 downto 0);
							PPSCountReset : out std_logic;		
							SecondsOut : out std_logic_vector(21 downto 0);
							SecondsIn : in std_logic_vector(21 downto 0);
							SetTime : out std_logic;		
							
							SetTimeHi : out std_logic;		
							SetTimeLo : out std_logic;		
							LatchRtcHi : out std_logic;		
							LatchRtcLo : out std_logic;		
							
							SarAdcSample : in std_logic_vector(63 downto 0);
							SarAdcSampleCount : in std_logic_vector(11 downto 0);
							SarReadAdcSample : out std_logic;		
							SarAdcSampleReadAck : in std_logic;		
							SarAdcSampleFifoFull : in std_logic;		
							SarAdcSampleFifoEmpty : in std_logic;		
							SarAdcFifoReset : out std_logic;
							SarAdcOverrange : in std_logic;
							SarSamplesToAverage : out std_logic_vector(15 downto 0);
							SarSamplesPerSecond : out std_logic_vector(31 downto 0);
							AdcGain : out std_logic_vector(5 downto 0);
							GpsUart : in std_logic_vector(7 downto 0);		
							ReadGpsUart : out std_logic;			
							GpsUartReadAck : in std_logic;		
							GpsUartFifoFull : in std_logic;		
							GpsUartFifoEmpty : in std_logic;		
							GpsUartCount : in std_logic_vector(FIFO_BITS - 1 downto 0);
							GpsFifoReset : out std_logic;				
							GpsOutTxdWriteData : out std_logic_vector(7 downto 0);	
							WriteGpsOutTxd : out std_logic;			
							GpsOutTxdFifoFull : in std_logic;		
							GpsOutTxdFifoEmpty : in std_logic;		
							GpsOutTxdCount : in std_logic_vector(FIFO_BITS - 1 downto 0);
							UsbUart : in std_logic_vector(7 downto 0);		
							ReadUsbUart : out std_logic;			
							UsbUartReadAck : in std_logic;		
							UsbUartFifoFull : in std_logic;		
							UsbUartFifoEmpty : in std_logic;		
							UsbUartCount : in std_logic_vector(FIFO_BITS - 1 downto 0);
							UsbFifoReset : out std_logic;							
							UsbSwitch : out std_logic;							
							Milliseconds : in std_logic_vector(9 downto 0);
							SDPower : out std_logic;		
							RadioPower : out std_logic;		
							SpiExtInUse : in std_logic_vector(7 downto 0);		
							SpiExtAddr : out std_logic_vector(7 downto 0);			
							ZigUart : in std_logic_vector(7 downto 0);	
							ReadZigUart : out std_logic;			
							ZigUartReadAck : in std_logic;		
							ZigUartFifoFull : in std_logic;		
							ZigUartFifoEmpty : in std_logic;		
							ZigUartCount : in std_logic_vector(FIFO_BITS - 1 downto 0);
							ZigFifoReset : out std_logic;
							UartMux : out std_logic_vector(7 downto 0);
							SpiTxUartReadData : in std_logic_vector(7 downto 0);	
							SpiTxUartWriteData : out std_logic_vector(7 downto 0);	
							ReadSpiTxUart : out std_logic;			
							SpiTxUartReadAck : in std_logic;		
							WriteSpiTxUart : out std_logic;			
							SpiTxUartFifoFull : in std_logic;		
							SpiTxUartFifoEmpty : in std_logic;		
							SpiTxUartCount : in std_logic_vector(FIFO_BITS - 1 downto 0);
							SpiTxFifoReset : out std_logic;
							SpiRxUartReadData : in std_logic_vector(7 downto 0);	
							SpiRxUartWriteData : out std_logic_vector(7 downto 0);	
							ReadSpiRxUart : out std_logic;			
							SpiRxUartReadAck : in std_logic;		
							WriteSpiRxUart : out std_logic;			
							SpiRxUartFifoFull : in std_logic;		
							SpiRxUartFifoEmpty : in std_logic;		
							SpiRxUartCount : in std_logic_vector(FIFO_BITS - 1 downto 0);
							SpiRxFifoReset : out std_logic;
							ZBusAddrOut : out std_logic_vector(7 downto 0);
							SetZBusAddr : out std_logic;
							ZBusAddrIn : in std_logic_vector(7 downto 0);
							ZBusWriteData : out std_logic_vector(7 downto 0);
							WriteZBus : out std_logic;
							ZBusReadbackData : in std_logic_vector(7 downto 0);
							ZigOutTxdWriteData : out std_logic_vector(7 downto 0);	
							WriteZigOutTxd : out std_logic;			
							ZigOutTxdFifoFull : in std_logic;		
							ZigOutTxdFifoEmpty : in std_logic;		
							ZigOutTxdCount : in std_logic_vector(FIFO_BITS - 1 downto 0);
							AClkUart : in std_logic_vector(7 downto 0);	
							ReadAClkUart : out std_logic;			
							AClkUartReadAck : in std_logic;		
							AClkUartFifoFull : in std_logic;		
							AClkUartFifoEmpty : in std_logic;		
							AClkUartCount : in std_logic_vector(FIFO_BITS - 1 downto 0);
							AClkFifoReset : out std_logic;
							AClkOutTxdWriteData : out std_logic_vector(7 downto 0);	
							WriteAClkOutTxd : out std_logic;			
							AClkOutTxdFifoFull : in std_logic;		
							AClkOutTxdFifoEmpty : in std_logic;		
							AClkOutTxdCount : in std_logic_vector(FIFO_BITS - 1 downto 0);
							XMTUart : in std_logic_vector(7 downto 0);	
							ReadXMTUart : out std_logic;			
							XMTUartReadAck : in std_logic;		
							XMTUartFifoFull : in std_logic;		
							XMTUartFifoEmpty : in std_logic;		
							XMTUartCount : in std_logic_vector(FIFO_BITS - 1 downto 0);
							XMTFifoReset : out std_logic;
							XMTOutTxdWriteData : out std_logic_vector(7 downto 0);	
							WriteXMTOutTxd : out std_logic;			
							XMTOutTxdFifoFull : in std_logic;		
							XMTOutTxdFifoEmpty : in std_logic;		
							XMTOutTxdCount : in std_logic_vector(FIFO_BITS - 1 downto 0);			
							PPSRtcPhaseCmp : in std_logic_vector(31 downto 0);
							SarPPSAdcPhaseCmp : in std_logic_vector(31 downto 0);
							PPSPeriodDutyPhaseCmp : in std_logic_vector(31 downto 0);
							ForcePnD : out std_logic;
							ForcedPeriod : out std_logic;
							ForcedDuty : out std_logic;
							ClkDacWrite : out std_logic_vector(15 downto 0);	
							WriteClkDac : out std_logic;		
							ClkDacReadback : in std_logic_vector(15 downto 0);	
							LastSPIExtAddr : in std_logic_vector(6 downto 0);	
							SyncSummary : out std_logic_vector(31 downto 0);		
							ChopperEnable : out std_logic;
							DnaRegister : in std_logic_vector(31 downto 0);
							BuildNum : in std_logic_vector(15 downto 0)--;
						);
						end component;

						component ltc2378fifoPorts is
						--~ generic (
							--~ MASTER_CLOCK_FREQHZ : natural := 100000000--; --The input clock
						--~ );
						port (
						
							--Globals
							clk : in std_logic;
							rst : in std_logic;
							
							-- A/D:
							Trigger : out std_logic; --rising edge initiates a conversion; 20ns min per hi/lo, so 
							nDrdy : in std_logic; --Falling edge indicates a new sample is ready, should be approx 1usec after trigger goes high (1MHz)
							nCs : out std_logic; -- 18th bit (msb) of data valid on falling edge.
							Sck : out std_logic; --can run up to ~100MHz (">40MHz??); idle in low state
							Miso : in  std_logic; --valid 16nsec after nCs low; shifts on rising edge of sck, sample when sck low.		
							MosiDbg : out std_logic; --To look at timing on scope; end device should toggle at same time at fpga toggles if outputting x55's..
							OverRange : out std_logic; --is the A/D saturated?
							
							--Control signals
							AdcPowerDown : in std_logic; --self-explanatory...
							AdcClkDivider : in std_logic_vector(15 downto 0); --This know controls the acquisition speed of the A/D.
							SamplesToAverage : in std_logic_vector(15 downto 0); --Only supported on LTC2380-24 hardware! This also controls the acquisition speed of the A/D; each 4x averaging gives an extra bit of SNR or 6dB.
							SamplesPerSecond : in std_logic_vector(31 downto 0); --Needed to find resync sample when using continuous pps trigger...
							PPS : in std_logic; --This signal from the GPS actually initiates the synchronization
							PPSCount : in std_logic_vector(26 downto 0); --Our primary timestamp
							Seconds : in std_logic_vector(12 downto 0); --Our slower timestamp, the lsb's of the seconds (rolls over every 2.5 hrs)
							SyncRequest : in std_logic; --raise this line to resync A/D on next PPS rising edge
							SyncCompleted : out std_logic; --true until PPS goes high again
							SampleTimestampLatched : out std_logic; --true when we start reading the newest sample, false when we finish!
							ChopperEnable : in std_logic; --turns chopper on/off to reduce 1/f noise and offset!
							ChopperMuxPos : out std_logic; --switches inputs when chopper on to reduce 1/f noise and offset!
							ChopperMuxNeg : out std_logic; --switches inputs when chopper on to reduce 1/f noise and offset!
							
							--Trigger signals
							TxTrigger : in std_logic;				
							PeriodTriggerQuadrant : in std_logic;		
							DutyTriggerQuadrant : in std_logic;		
							PeriodTriggerEither : in std_logic;		
							DutyTriggerEither : in std_logic;	
							PPSTrigger : in std_logic;	
							AdcPeriod : in std_logic;
							AdcDuty : in std_logic;
							
							TP1 : out std_logic;
							TP2 : out std_logic;
							TP3 : out std_logic;
							TP4 : out std_logic;

							--Read from fifo:
							ReadAdcSampleFifo	: in std_logic;
							AdcSampleFifoReadAck : out std_logic;
							AdcSampleFifoData : out std_logic_vector(63 downto 0);
							AdcSampleFifoFull	: out std_logic;
							AdcSampleFifoEmpty	: out std_logic;
							AdcSampleFifoCount	: out std_logic_vector(11 downto 0)--;		
								
						); 
						end component;
						
						component gated_fifo is
						generic (
							WIDTH_BITS : natural := 32;
							DEPTH_BITS : natural := 9
						);
						port (
							clk		: in std_logic;
							rst		: in std_logic;
							wone_i	: in std_logic;
							data_i	: in std_logic_vector(WIDTH_BITS - 1 downto 0);
							rone_i	: in std_logic;
							full_o	: out std_logic;
							empty_o	: out std_logic;
							data_o	: out std_logic_vector(WIDTH_BITS - 1 downto 0);
							count_o	: out std_logic_vector(DEPTH_BITS - 1 downto 0);
							r_ack : out std_logic--;
						);
						end component;
						
						component uart_receiver is
						port (
							clk         : in std_logic;                                 -- Clock
							rst         : in std_logic;                                 -- Reset
							rxclk       : in std_logic;                                 -- Receiver clock (16x baudrate)
							rxclear     : in std_logic;                                 -- Reset receiver state
							wls         : in std_logic_vector(1 downto 0);              -- Word length select
							stb         : in std_logic;                                 -- Number of stop bits
							pen         : in std_logic;                                 -- Parity enable
							eps         : in std_logic;                                 -- Even parity select
							sp          : in std_logic;                                 -- Stick parity
							sin         : in std_logic;                                 -- Receiver input
							pe          : out std_logic;                                -- Parity error
							fe          : out std_logic;                                -- Framing error
							bi          : out std_logic;                                -- Break interrupt
							dout        : out std_logic_vector(7 downto 0);             -- Output data
							rxfinished  : out std_logic                                 -- Receiver operation finished
						);
						end component;
						
						component UartRxParity is
						port (
							 Clk    : in  std_logic;  -- system clock signal
							 Reset  : in  std_logic;  -- Reset input
							 Enable : in  std_logic;  -- Enable input
							 ReadA  : in  Std_logic;  -- Async Read Received Byte
							 RxD    : in  std_logic;  -- RS-232 data input
							 RxAv   : out std_logic;  -- Byte available
							 DataO  : out std_logic_vector(7 downto 0)--; -- Byte received
						);
						end component;

						component UartRxRaw is
						port (
							 Clk    : in  std_logic;  -- system clock signal
							 Reset  : in  std_logic;  -- Reset input
							 Enable : in  std_logic;  -- Enable input
							 --~ ReadA  : in  Std_logic;  -- Async Read Received Byte
							 RxD    : in  std_logic;  -- RS-232 data input
							 RxAv   : out std_logic;  -- Byte available
							 DataO  : out std_logic_vector(7 downto 0)--; -- Byte received
						);
						end component;
						
						component UartRx is
						generic (
							CLOCK_FREQHZ : natural := 14745600;
							BAUDRATE : natural := 38400--;
						);
						port (						
							clk : in std_logic;
							rst : in std_logic;
							Rxd : in std_logic; --external (async) uart data input pin
							RxComplete : out std_logic; --Just got a byte
							RxData : out std_logic_vector(7 downto 0) --The byte we just got		
						);
						end component;
						
						component UartRxFifo is
						generic 
						(
							UART_CLOCK_FREQHZ : natural := 14745600;
							FIFO_BITS : natural := 10;
							BAUDRATE : natural := 38400--;
						);
						port 
						(
							--Outside world:
							clk : in std_logic;
							uclk : in std_logic;
							rst : in std_logic;
							--External (async) uart data input pin
							Rxd : in std_logic; 
							--Read from fifo:
							ReadFifo	: in std_logic;
							FifoReadAck : out std_logic;
							FifoReadData : out std_logic_vector(7 downto 0);
							--Fifo status:
							FifoFull	: out std_logic;
							FifoEmpty	: out std_logic;
							FifoCount	: out std_logic_vector(FIFO_BITS - 1 downto 0)--;		
						);
						end component;
						
						component UartRxFifoParity is
						generic 
						(
							UART_CLOCK_FREQHZ : natural := 14745600;
							FIFO_BITS : natural := 10;
							BAUDRATE : natural := 38400--;
						);
						port 
						(
							--Outside world:
							clk : in std_logic;
							uclk : in std_logic;
							rst : in std_logic;
							--External (async) uart data input pin
							Rxd : in std_logic; 
							--Read from fifo:
							ReadFifo	: in std_logic;
							FifoReadAck : out std_logic;
							FifoReadData : out std_logic_vector(7 downto 0);
							--Fifo status:
							FifoFull	: out std_logic;
							FifoEmpty	: out std_logic;
							FifoCount	: out std_logic_vector(FIFO_BITS - 1 downto 0)--;		
						);
						end component;
						
						component UartTxFifo is
						generic 
						(
							UART_CLOCK_FREQHZ : natural := 14745600; --for making industry-standard baudrates
							FIFO_BITS : natural := 10;
							BAUDRATE : natural := 38400--;
						);
						port 
						(
							--global control signals
							clk : in std_logic; --generic clock base for fifo & control signals
							uclk : in std_logic; --clock base for correct uart speed (should be less than clk)
							rst : in std_logic; --global reset
							
							--'digital' side (backyard)
							WriteStrobe : in std_logic; --send byte to fifo
							WriteData : in std_logic_vector(7 downto 0); --the byte
							FifoFull : out std_logic; --fifo status:
							FifoEmpty : out std_logic; --fifo status:
							FifoCount : out std_logic_vector(FIFO_BITS - 1 downto 0); --fifo status:
							
							--'analog' side (frontyard)
							TxInProgress : out std_logic; --currently sending data...
							Cts : in std_logic;
							Txd : out std_logic--; --Uart data output pin (i.e. to RS-232 driver chip)
						);
						end component;
						
						component UartTxFifoParity is
						generic 
						(
							UART_CLOCK_FREQHZ : natural := 14745600; --for making industry-standard baudrates
							PARITY_EVEN : std_logic := '1'; --1=odd, 0=even
							FIFO_BITS : natural := 10;
							BAUDRATE : natural := 38400--;
						);
						port 
						(
							--global control signals
							clk : in std_logic; --generic clock base for fifo & control signals
							uclk : in std_logic; --clock base for correct uart speed (should be less than clk)
							rst : in std_logic; --global reset
							
							--'digital' side (backyard)
							WriteStrobe : in std_logic; --send byte to fifo
							WriteData : in std_logic_vector(7 downto 0); --the byte
							FifoFull : out std_logic; --fifo status:
							FifoEmpty : out std_logic; --fifo status:
							FifoCount : out std_logic_vector(FIFO_BITS - 1 downto 0); --fifo status:
							
							--'analog' side (frontyard)
							TxInProgress : out std_logic; --currently sending data...
							Cts : in std_logic;
							Txd : out std_logic--; --Uart data output pin (i.e. to RS-232 driver chip)
						);
						end component;

						component ZBusAddrTxPorts is
						generic 
						(
							MASTER_CLOCK_FREQHZ : natural := 10000000--; --The input clock
						);
						port 
						(
							clk : in std_logic;
							rst : in std_logic;
							ZBusAddr : in std_logic_vector(7 downto 0);
							SendZBusAddr : in std_logic;
							SendingZBusAddr : out std_logic;
							ZBusAddrTxdPin : out std_logic--;
						);
						end component;
						
						component AdcClocksPeriodDutyPorts is
						port
						(
							clk : in std_logic;
							rst : in std_logic;
							AdcPeriod : out std_logic;
							AdcDuty : out std_logic;
							AdcPrescaleDivider : in std_logic_vector(15 downto 0);
							AdcPeriodDivider : in std_logic_vector(31 downto 0);
							AdcPeriodMultiplier : in std_logic_vector(7 downto 0);
							AdcDutyDivider : in std_logic_vector(31 downto 0);
							PPS : in std_logic;
							Sync : in std_logic;
							Synced : out std_logic--;
						);
						end component;
						
						component SpiMasterPorts is
						generic (
							CLOCK_DIVIDER : integer := 4; --allowable values are from AClk/2 to AClk/16...
							BYTE_WIDTH : natural := 1;
							CPOL : std_logic := '0'--;	
						);
						port
						(
							clk : in std_logic;
							rst : in std_logic;
							Mosi : out std_logic;
							Sck : out std_logic;
							Miso : in std_logic;
							DataToMosi : in std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
							DataFromMiso : out std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
							XferComplete : out std_logic--;
						);
						end component;
						
						component PhaseComparatorPorts is
						generic (
								MAX_CLOCK_BITS_DELTA : natural := 16--;
						);
						port (
								clk : in std_logic;
								rst : in std_logic;

								InA : in std_logic;
								InB : in std_logic;
								
								Delta : out std_logic_vector(MAX_CLOCK_BITS_DELTA - 1 downto 0)--;
						);
						end component;
						
						component BuildNumberPorts is
						port (
							BuildNumber : out std_logic_vector(15 downto 0)--;
						);
						end component;
						
						component ClockMultiplierPorts is
						generic (
							CLOCK_DIVIDER : natural := 1;
							CLOCK_MULTIPLIER : natural := 2;
							CLOCK_FREQ_KHZ : real := 10000.0--;
						);
						port (
								rst : in std_logic;
								clkin : in std_logic;
								clkout : out std_logic;
								locked : out std_logic--;
						);
						end component;

						component SpiDacPorts is
						generic (
							MASTER_CLOCK_FREQHZ : natural := 100000000--;
						);
						port (
						
							--Globals
							clk : in std_logic;
							rst : in std_logic;
							
							-- D/A:
							nCs : out std_logic;
							Sck : out std_logic;
							Mosi : out  std_logic;
							Miso : in  std_logic;
							
							--Control signals
							DacWriteOut : in std_logic_vector(15 downto 0);
							WriteDac : in std_logic;
							DacReadback : out std_logic_vector(15 downto 0)--;
								
						); end component;

						component ZBusPorts is
						generic (
							MASTER_CLOCK_FREQHZ : natural := 100000000--;
						);
						port (
						
							--Globals
							clk : in std_logic;
							rst : in std_logic;
							
							-- D/A:
							nCs : out std_logic;
							Sck : out std_logic;
							Mosi : out  std_logic;
							Miso : in  std_logic;
							
							--Control signals
							ZBusWriteOut : in std_logic_vector(7 downto 0);
							WriteZBus : in std_logic;
							ZBusReadReady : out std_logic;
							ZBusReadback : out std_logic_vector(7 downto 0)--;
								
						); end component;

	--Signals /  Local variables
		
		--Note on variable names ending in '_i': these are generally used to syncronize asynchronous signals with internal clocked logic, 
		-- to merge (and, or, etc) two inputs into one control signal, or so that we can read-back a value sent to an output-only pin.
		--Also, 'datamapper' is the logic that maps SPI bus data from/to the Arm uC with specific internal registers; hence it's referred to alot.
		
		--Constants & Setup
		
			--~ constant BaseClockFreq : natural := 16384000; --old xtal (250Hz Fs)
			constant BaseClockFreq : natural := 16777216; --new xtal (256Hz Fs)
			
			constant ClockFreqMultiplier : natural := 6;
			constant BaseClockPeriod : real := 59.6; --really should be exactly 1 / conv_real(BaseClockFreq), but it's just used by DCM clock library, and conv_real doesn't exist.
			--~ constant BaseClockFreq : natural := 4194304; --new xtal (256Hz Fs)
			--~ constant ClockFreqMultiplier : natural := 24;
			--~ constant BaseClockPeriod : real := 200.1; --really should be exactly 1 / conv_real(BaseClockFreq), but it's just used by DCM clock library, and conv_real doesn't exist.
			constant BoardMasterClockFreq : natural := BaseClockFreq * ClockFreqMultiplier; --16.777MHz * 6, 
			
			constant UartClockFreqMultiplier : natural := 7; --15/17 is also a good scaler, and uart dividers come out just over ideal instead of under, so integer math works on them...
			constant UartClockFreqDivider : natural := 8;
			constant UartClockPeriod : real := 68.12; --really should be exactly 1 / conv_real(UartBaseClockFreq), but it's just used by DCM clock library, and conv_real doesn't exist.
			constant UartClockFreq : natural := BaseClockFreq * UartClockFreqMultiplier / UartClockFreqDivider; -- 14.6801MHz (14.7456 ideal; 0.44% dev)
			
			constant TwiceMaxConceviableSampleRate : natural := 32768; -- What's the minimum amount of time we can expect a sample in?
			
			constant FifoBitsMinimum : natural := 8;
			
			signal BuildNum : std_logic_vector(15 downto 0);
			
		--Clocks
		
			signal MasterClk : std_logic; --This is the main clock for *everything*
			signal VcxoClkDcmFeedbackIn : std_logic; --Used by DCM logic to multiply osc input up to master clk freq
			signal VcxoClkDcmFeedbackOut : std_logic; --Used by DCM logic to multiply osc input up to master clk freq
			signal VCXO_i : std_logic; --The oscillator input shadow variable
			--~ signal VCXO_out : std_logic; --The oscillator input shadow variable
			signal VCXO_out : std_logic_vector(4 downto 0); --The oscillator input shadow variable
			signal DcDcClk_i : std_logic; --1Mhz clock for the DC/DC
			signal DcDcClkDiv : std_logic; --temp to generate DC/DC clock from A/D clock
			signal UartClkDcmFeedbackIn : std_logic; --Used by DCM logic to multiply osc input up to master clk freq
			signal UartClkDcmFeedbackOut : std_logic; --Used by DCM logic to multiply osc input up to master clk freq
			signal UartClk : std_logic; --14Mhz clock for the uart(s)
			signal UartClk_out : std_logic_vector(4 downto 0); --14Mhz clock for the uart(s); shadow variable
			
		--uC / Arm
			
			signal nMasterReset : std_logic; --uC reset shadow - Master reset for most logic & the Arm uC, generated on boot or uC isp bootload from usb
			signal IspuC_i : std_logic; --uC ISP shadow - Forces Arm into bootloader on reset
			signal FifoUsbUart : std_logic_vector(7 downto 0); --current character from fifo 
			signal ReadUsbUart : std_logic; --from datamapper - initiates read from fifo
			signal UsbUartReadAck : std_logic; --fifo read complete - FifoUsbUart now has valid character
			signal UsbUartFifoFull : std_logic;		
			signal UsbUartFifoEmpty : std_logic;		
			signal UsbUartCount : std_logic_vector(FifoBitsMinimum - 1 downto 0); --number of chars in fifo
			signal UsbFifoReset : std_logic; --reset the fifo  - generated by datamapper
			signal UsbFifoReset_i : std_logic; --Concatenate reset from datamapper with master/bootup reset	
					
		--A/D & A/D fifos
			
			signal SarAdcSck_i : std_logic; --SPI bus to A/D
			signal SarAdcMiso_i : std_logic; --SPI bus to A/D
			signal SarMosiAdc_i : std_logic; --SPI bus to A/D			
			--~ signal SarAdcSampleCount : std_logic_vector(10 downto 0); --Number of samples in sample fifo
			signal SarAdcSampleCount : std_logic_vector(11 downto 0); --Number of samples in sample fifo
			signal SarReadAdcSample : std_logic; --Get a sample out of the fifo - generated by datamapper
			signal SarAdcSampleReadAck : std_logic; --Got a sample out of the fifo
			signal SarFifoAdcSample : std_logic_vector(63 downto 0); --Current sample from fifo
			signal SarAdcSampleFifoFull : std_logic;		
			signal SarAdcSampleFifoEmpty : std_logic;		
			signal SarAdcFifoReset : std_logic; --reset the fifo  - generated by datamapper
			signal SarAdcFifoReset_i : std_logic; --Concatenate reset from datamapper with master/bootup reset
			signal SarAdcTimestampReq : std_logic; --DRdy?
			signal SarAdcOverrange : std_logic; --DRdy?
			signal SarSamplesToAverage : std_logic_vector(15 downto 0); --downsampling factor for ltc2380-24 a/d hardware
			signal SarSampleTimestampLatched : std_logic; --true when we start reading the newest sample, false when we finish!
			signal SyncAdcRequest :  std_logic; -- from datamapper; requests an adc sync on next PPS from GPS
			--~ signal LastSyncAdc :  std_logic; -- edge detect
			--~ signal SyncAdc_i :  std_logic; --Most important & touchy signal in the system - rising edge resets the Delta-Sigma hardware in the A/D so multiple boards can be sync'd by GPS PPS signal
			--~ signal AdcSynced :  std_logic; --Follows rising edge of SyncAdc_i
			signal SarSyncCompleted :  std_logic := '0'; --Did we do a sync on the last PPS?
			signal ResetSyncCompleted : std_logic := '0'; --From datamapper - reset the sync completed bit
			signal TxTriggerAdc : std_logic; --Should we be triggering A/D on a specific state of P/D?
			signal PeriodTriggerQuadrant :  std_logic; --Trigger A/D on this state of Period
			signal DutyTriggerQuadrant :  std_logic; --Trigger A/D on this state of Period
			signal PeriodTriggerEither :  std_logic; --Trigger A/D on either state of Period
			signal DutyTriggerEither :  std_logic; --Trigger A/D on either state of Period
			signal PPSTriggerAdc :  std_logic; --Master aggregator signal that turns A/D on/off
			signal SarAdcnDrdy_i : std_logic; --debug		
			signal ChopperEnable : std_logic; --turn on chopper?					

		--GPS
		
			signal FifoGpsUart : std_logic_vector(7 downto 0); --current character from fifo 
			signal ReadGpsUart : std_logic; --from datamapper - initiates read from fifo
			signal GpsUartReadAck : std_logic; --fifo read complete - FifoGpsUart now has valid character
			signal GpsUartFifoFull : std_logic;		
			signal GpsUartFifoEmpty : std_logic;		
			signal GpsUartCount : std_logic_vector(FifoBitsMinimum - 1 downto 0); --number of chars in fifo
			signal GpsFifoReset : std_logic; --reset the fifo  - generated by datamapper
			signal GpsFifoReset_i : std_logic; --Concatenate reset from datamapper with master/bootup reset	
			signal GpsOutTxdWriteData : std_logic_vector(7 downto 0); --buffer for Gpsaddr uart
			signal WriteGpsOutTxd : std_logic; --strobe for uart
			signal GpsOutTxdFifoFull : std_logic;		
			signal GpsOutTxdFifoEmpty : std_logic;		
			signal GpsOutTxdCount : std_logic_vector(FifoBitsMinimum - 1 downto 0);
			signal GpsOutTxdInProgress : std_logic;
			signal GpsOutTxdPin : std_logic;
			signal RxdGpsMux : std_logic; --let's us select different pins (or even internal loopback) for the origin of gps serial data
			signal PPS_i : std_logic; --the PPS signal as used by anything that needs PPS
			signal PPSMux : std_logic; --either the external GPS PPS, or PpsGenerated that we make internally when we don't have GPS
			signal PPSCountReset : std_logic; --generated by datamapper
			signal PPSDetected : std_logic; --are edges occuring on PPS?  Mainly used by rtc to decide wether to roll the clock over on it's own or let PPS sync it
			signal PPSCount : std_logic_vector(31 downto 0); --How many MasterClocks have gone by since the last PPS edge (so we can phase-lock oscillator to GPS time)
			signal PPSCounter : std_logic_vector(31 downto 0); --This one is the current count for this second, not the total for the last second...
			signal PpsGenerated : std_logic; --This holds the PPS when we roll our own
			signal GeneratePps : std_logic := '0'; --Are we rolling our own PPS? - from datamapper
			signal UsingAtomicClock : std_logic := '0'; --Are we using the Atomic clock (for PPS & time instead of GPS)
			signal PPSRtcPhaseCmp : std_logic_vector(31 downto 0); --output comparator to see how far PPS & RTC diverges
			signal SarPPSAdcPhaseCmp : std_logic_vector(31 downto 0); --output comparator to see how far PPS & A/D diverges

		--RTC
			
			signal SetTimeSeconds : std_logic_vector(21 downto 0); --Incoming time to set to the RTC
			signal SetTime : std_logic; --Set the RTC? - from datamapper
			signal SetChangedTime : std_logic; --since we get the time from the GPS every second, we set it every second; in normal opertation this allows us to ensure the PPS has already updated to the new second (when we set it, it shouldn't have actually changed if the PPS's are updating the second)
			signal Seconds : std_logic_vector(21 downto 0); --The current second reported by the RTC
			signal Milliseconds : std_logic_vector(9 downto 0); -- ...and the mS

		--FPGA internal
		
			signal DnaRegister_i : std_logic_vector(31 downto 0); --This is a xilinx proprietary toy that we use as the serial number, it's supposed to be unique on each board
			signal CurrentSRamAddr : std_logic_vector(16 downto 0); --Which register is the uC trying to talk to?  used by datamapper
			--Rest of the data flow on the SPI bus:
			signal DataToWrite : std_logic_vector(15 downto 0);
			signal DataWriteReq : std_logic;
			signal DataWriteAck : std_logic;
			signal DataFromRead : std_logic_vector(15 downto 0);
			signal DataReadReq : std_logic;
			signal DataReadAck : std_logic;
			signal ByteComplete : std_logic;
			--end SPI dataflow
			--same as above, but for ext spi bus:
			signal nCsExt : std_logic;
			signal nCsExt_i : std_logic;
			signal SckExt_i : std_logic;
			signal MosiExt_i : std_logic;
			signal MisoExt_i : std_logic;
			signal CurrentSPIExtAddr : std_logic_vector(6 downto 0);
			signal ExtDataToWrite : std_logic_vector(7 downto 0);
			signal ExtDataWriteReq : std_logic;
			signal ExtDataWriteAck : std_logic;
			signal ExtDataFromRead : std_logic_vector(7 downto 0);
			signal ExtDataReadReq : std_logic;
			signal ExtDataReadAck : std_logic;		
			signal ExtByteComplete : std_logic;		
			signal ExtAddressLatched : std_logic;		
			signal UsbSw_i : std_logic := '0';	--default to zero so we get the uart debug log by default. We should switch to the internal usb for networking after bootup.
			constant UsbSwUart : std_logic := '0';		
			constant UsbSwArmUsbClient : std_logic := '1';		
			--end ext spi bus:

		--ZigBee Radio
			
			signal UartMux : std_logic_vector(7 downto 0);	--Is the device uart sending chars to the Gps or the Zig???
			
			signal FifoZigUart : std_logic_vector(7 downto 0); --current character from fifo 
			signal ReadZigUart : std_logic; --from datamapper - initiates read from fifo
			signal ZigUartReadAck : std_logic; --fifo read complete - FifoZigUart now has valid character
			signal ZigUartFifoFull : std_logic;		
			signal ZigUartFifoEmpty : std_logic;		
			signal ZigUartCount : std_logic_vector(FifoBitsMinimum - 1 downto 0); --number of chars in fifo
			signal ZigFifoReset : std_logic; --reset the fifo  - generated by datamapper
			signal ZigFifoReset_i : std_logic; --Concatenate reset from datamapper with master/bootup reset	
			signal RadioPower :  std_logic := '1';	--from datamapper - switches fet that powers the flash card
					
		--uSD Flash card
		
			signal SDPower :  std_logic := '1';	--from datamapper - switches fet that powers the flash card
		
		--Zonge compatible timing chain
																	
			signal TxPeriodDivider : std_logic_vector(31 downto 0) := x"001FFFFF"; --used to set frequency of zonge 'tx period' signal
			signal TxDutyDivider : std_logic_vector(31 downto 0) := x"001FFFFF"; --used to set frequency of zonge 'tx duty' signal
			signal SyncPeriodDuty :  std_logic; --from datamapper - request sync to next PPS from GPS
			signal SyncPeriodDutyStrobe :  std_logic; --The edge of the PPS to sync
			signal PeriodDutySynced :  std_logic; --Follows PPS so we know if/when we synced
			signal TxPeriod_i :  std_logic; --output and datamapper readback of zonge 'tx period' signal
			signal TxDuty_i :  std_logic; --output and datamapper readback of zonge 'tx duty' signal
			signal TxPeriod_i_i :  std_logic; --output and datamapper readback of zonge 'tx period' signal
			signal TxDuty_i_i :  std_logic; --output and datamapper readback of zonge 'tx duty' signal
			signal DutyOff :  std_logic := '1'; --we always start with duty off so as not to fire up a 3kV generator when we power or reboot the FPGA.
			signal DutyOff_i :  std_logic := '1'; --shadow to lock out when duty=FFFFFFFFF as well
			signal ForcePnD :  std_logic := '0'; --So one can set the timing chain control signals explicitly for testing
			signal ForcedPeriod :  std_logic; --What period gets set to when ForcePD is enabled
			signal ForcedDuty :  std_logic; --What duty gets set to when ForcePD is enabled

		--Hub/SpiExt bus
		
			constant BoxMasterSpiExtAddr : std_logic_vector(7 downto 0) := x"01";
			signal SpiExtInUse : std_logic_vector(7 downto 0); -- this is the readback from the outside world, to see if another card is using the bus as master
			signal SpiExtAddr : std_logic_vector(7 downto 0) := x"07"; -- this is what spi address (chip selects) we are supposed to respond to; if zero, we are master, else slave (hence the default)
			signal SpiTxUartReadData : std_logic_vector(7 downto 0);	
			signal SpiTxUartWriteData : std_logic_vector(7 downto 0);	
			signal ReadSpiTxUart : std_logic;			
			signal SpiTxUartReadAck : std_logic;		
			signal WriteSpiTxUart : std_logic;			
			signal SpiTxUartFifoFull : std_logic;		
			signal SpiTxUartFifoEmpty : std_logic;		
			signal SpiTxUartCount : std_logic_vector(FifoBitsMinimum - 1 downto 0);
			signal SpiTxFifoReset : std_logic;
			signal SpiRxUartReadData : std_logic_vector(7 downto 0);	
			signal SpiRxUartWriteData : std_logic_vector(7 downto 0);	
			signal ReadSpiRxUart : std_logic;			
			signal SpiRxUartReadAck : std_logic;		
			signal WriteSpiRxUart : std_logic;			
			signal SpiRxUartFifoFull : std_logic;		
			signal SpiRxUartFifoEmpty : std_logic;		
			signal SpiRxUartCount : std_logic_vector(FifoBitsMinimum - 1 downto 0);
			signal SpiRxFifoReset : std_logic;
			signal ZBusAddr : std_logic_vector(7 downto 0); --value to set zbusaddr to
			signal SetZBusAddr : std_logic; --strobe for above
			signal ZBusAddrExt : std_logic_vector(7 downto 0); --value read in from bus
			signal ZBusAddrTxdPin : std_logic; --This is the txd signal for the ZBus addr, actual pin gets tristated with a when statement, hence the buffer signal
			signal ZBusAddrIsOutgoing : std_logic; --Zero while the ZBusAddr is being transmitted on bus
			signal ZBusWriteOut : std_logic_vector(7 downto 0);
			signal WriteZBus : std_logic;
			signal ZBusReadback : std_logic_vector(7 downto 0);
			signal ZigOutTxdWriteData : std_logic_vector(7 downto 0); --buffer for zigaddr uart
			signal WriteZigOutTxd : std_logic; --strobe for uart
			signal ZigOutTxdFifoFull : std_logic;		
			signal ZigOutTxdFifoEmpty : std_logic;		
			signal ZigOutTxdCount : std_logic_vector(FifoBitsMinimum - 1 downto 0);
			signal ZigOutTxdInProgress : std_logic;
			signal ZigOutTxdPin : std_logic;
			signal FifoPZig_i : std_logic;
			signal FifoAClkUart : std_logic_vector(7 downto 0); --current character from fifo 
			signal ReadAClkUart : std_logic; --from datamapper - initiates read from fifo
			signal AClkUartReadAck : std_logic; --fifo read complete - FifoAClkUart now has valid character
			signal AClkUartFifoFull : std_logic;		
			signal AClkUartFifoEmpty : std_logic;		
			signal AClkUartCount : std_logic_vector(FifoBitsMinimum - 1 downto 0); --number of chars in fifo
			signal AClkFifoReset : std_logic; --reset the fifo  - generated by datamapper
			signal AClkFifoReset_i : std_logic; --Concatenate reset from datamapper with master/bootup reset	
			signal AClkOutTxdWriteData : std_logic_vector(7 downto 0);	
			signal WriteAClkOutTxd : std_logic;			
			signal AClkOutTxdFifoFull : std_logic;		
			signal AClkOutTxdFifoEmpty : std_logic;		
			signal AClkOutTxdCount : std_logic_vector(FifoBitsMinimum - 1 downto 0);
			signal AClkOutTxdInProgress : std_logic;
			signal AClkOutTxdPin : std_logic;

			signal FifoXMTUart : std_logic_vector(7 downto 0); --current character from fifo 
			signal ReadXMTUart : std_logic; --from datamapper - initiates read from fifo
			signal XMTUartReadAck : std_logic; --fifo read complete - FifoXMTUart now has valid character
			signal XMTUartFifoFull : std_logic;		
			signal XMTUartFifoEmpty : std_logic;		
			signal XMTUartCount : std_logic_vector(FifoBitsMinimum - 1 downto 0); --number of chars in fifo
			signal XMTFifoReset : std_logic; --reset the fifo  - generated by datamapper
			signal XMTFifoReset_i : std_logic; --Concatenate reset from datamapper with master/bootup reset	
			signal XMTOutTxdWriteData : std_logic_vector(7 downto 0);	
			signal WriteXMTOutTxd : std_logic;			
			signal XMTOutTxdFifoFull : std_logic;		
			signal XMTOutTxdFifoEmpty : std_logic;		
			signal XMTOutTxdCount : std_logic_vector(FifoBitsMinimum - 1 downto 0);
			signal XMTOutTxdInProgress : std_logic;
			signal XMTOutTxdPin : std_logic;
			
			signal LastPPSMux : std_logic;
			signal LastWriteAdcSample : std_logic;
			signal LastReadAdcSample : std_logic;
			signal AdcSamplesWritten_i : std_logic_vector(31 downto 0);
			signal AdcSamplesRead_i : std_logic_vector(31 downto 0);
			
			--~ signal UsbTxUartWriteData : std_logic_vector(7 downto 0);	
			--~ signal WriteUsbTxUart : std_logic;			
			--~ signal UsbTxUartFifoFull : std_logic;		
			signal UsbTxUartFifoEmpty : std_logic;		
			--~ signal UsbTxUartCount : std_logic_vector(FifoBitsMinimum - 1 downto 0);
			signal UsbTxUartInProgress : std_logic;		
			signal UsbTxUartPin : std_logic;		
			
			signal RamBusOE_i : std_logic;		
			signal RamBusCE_i : std_logic;		
			signal RamBusWE_i : std_logic;		
			signal RamBusAddress_i : std_logic_vector(15 downto 0);		
			signal nTristateRamDataPins : std_logic;		
			signal RamDataOut : std_logic_vector(15 downto 0);		
			signal RamDataIn : std_logic_vector(15 downto 0);		
			signal SRamAddrMatch : std_logic;		
			signal SarAdcnCs_i : std_logic;		
			signal SarAdcTrig_i : std_logic;		
			signal SarAdcClkDivider : std_logic_vector(15 downto 0);		
			signal SarAdcMosiDbg_i : std_logic;		
			
			signal ClkDacWrite : std_logic_vector(15 downto 0);		
			signal WriteClkDac : std_logic;		
			signal ClkDacReadback : std_logic_vector(15 downto 0);		
			
			signal PPSPeriodDutyPhaseCmp : std_logic_vector(31 downto 0);
			
			signal nCsClk_i : std_logic;		
			signal SckClk_i : std_logic;		
			signal MosiClk_i : std_logic;		
			signal MisoClk_i : std_logic;		

			signal nCsZBus_i : std_logic;		
			signal SckZBus_i : std_logic;		
			signal MosiZBus_i : std_logic;		
			signal MisoZBus_i : std_logic;		
			signal ZBusReadReady : std_logic;		
			
			signal SyncSummary : std_logic_vector(31 downto 0);		
			signal SarSamplesPerSecond : std_logic_vector(31 downto 0);

begin

	------------------------------PORTMAPS - map all library functions/logic to our specific local variables/signals----------------------------------
	
	BuildNumber : BuildNumberPorts
	port map
	(
		BuildNumber => BuildNum--;
	);
		
	MasterPll : ClockMultiplierPorts
	generic map (
		CLOCK_DIVIDER => 1,
		CLOCK_MULTIPLIER => ClockFreqMultiplier,
		CLOCK_FREQ_KHZ => 16777.7--,		
	)
	PORT MAP (
		rst => '0',
		clkin => VCXO,
		clkout => MasterClk,
		locked => open
	);
	
	UartPll : ClockMultiplierPorts
	generic map (
		CLOCK_DIVIDER => UartClockFreqDivider,
		CLOCK_MULTIPLIER => UartClockFreqMultiplier,
		CLOCK_FREQ_KHZ => 16777.7--,		
	)
	PORT MAP (
		rst => '0',
		clkin => VCXO,
		clkout => UartClk,
		locked => open
	);
	
	--Clocks the internal xilinx serial number ('dna') into a buffer
	DnaRegister : DnaRegisterPorts
	generic map
	(
		BIT_WIDTH => 32
	)
	port map
	(
		clk => MasterClk,
		rst => not(nMasterReset),
		DnaRegister => DnaRegister_i--,
	);

	BootupReset : OneShotPorts
	generic map (
		CLOCK_FREQHZ => BoardMasterClockFreq,
		DELAY_SECONDS => 0.000010,
		SHOT_RST_STATE => '0',
		SHOT_PRETRIGGER_STATE => '0'--,
	)
	port map 
	(	
		clk => MasterClk,
		rst => '0',
		--~ rst => not(TP3),
		shot => nMasterReset
	);

	--~ TP5 <= MasterClk;
	--~ TP6 <= nMasterReset;
	
	UConnuC <= UsbConn;
	
	RstuC <= '0' when (nMasterReset = '0') else 'Z';	
	
		--Just sync external PPS to master clock
		IBufPPS : IBufP2Ports
		port map
		(
			clk => MasterClk,
			I => PPSMux,
			O => PPS_i--,
		);

	--Mux internal vs. extranal PPS
	PPSMux <= 	PpsGenerated when (GeneratePps = '1') else 	--get PPS from internal counter
	PpsGps;
	
	X0 <= PPSMux; --The PPS goes into this GPIO on the arm processor so NTP can auto-sync it's clock to real time. (also requires NMEA/TSIP serial data to GPSD pipe for date)
	
	--Count up MasterClocks per PPS so we can sync the oscilator to the GPS clock
	PPSAccumulator : PPSCountPorts
    port map
	(
		clk => MasterClk,
		PPS => PPS_i,
		PPSReset => PPSCountReset,
		PPSCounter => PPSCounter,
		PPSAccum => PPSCount--,
	);
	
	PPSRtcPhaseComparator : PhaseComparatorPorts
	generic map (
		MAX_CLOCK_BITS_DELTA => 32--,
	)
	port map (
		clk => MasterClk,
		rst => not(nMasterReset),
		InA => PPSMux,
		InB => PpsGenerated,
		Delta => PPSRtcPhaseCmp--,
	);
	
	SarPPSAdcPhaseComparator : PhaseComparatorPorts
	generic map (
		MAX_CLOCK_BITS_DELTA => 32--,
	)
	port map (
		clk => MasterClk,
		rst => not(nMasterReset),
		InA => PPSMux,
		--~ InB => SarAdcnDrdy, --since the A/D undersamples, this really should be the one drdy where we read the a/d, not all of them!
		InB => SarSampleTimestampLatched,
		Delta => SarPPSAdcPhaseCmp--,
	);
	
	PPSPeriodDutyPhaseCmp_i : PhaseComparatorPorts
	generic map (
		MAX_CLOCK_BITS_DELTA => 32--,
	)
	port map (
		clk => MasterClk,
		rst => not(nMasterReset),
		InA => PPSMux,
		InB => TxPeriod_i_i,
		Delta => PPSPeriodDutyPhaseCmp--,
	);
		
	--Implements a real time clock that's locked to the PPS
	RtcCounter : RtcCounterPorts
    generic map
	(
		CLOCK_FREQ => BoardMasterClockFreq--,
	)
    port map
	(
		clk => MasterClk,
		rst => not(nMasterReset),
		PPS => PPS_i,
		PPSDetected => PPSDetected,
		Sync => SyncAdcRequest,
		GeneratedPPS => PpsGenerated,
		SetTimeSeconds => SetTimeSeconds,
		SetTime => SetTime,
		SetChangedTime => SetChangedTime,
		Seconds => Seconds,
		Milliseconds => Milliseconds--,
	);
	
	--~ TP4 <= PPS_i;
	--~ TP5 <= PpsGenerated;
	--~ TP6 <= Seconds(0);
	--~ TP7 <= SarAdcnCs_i;
	--~ TP8 <= SyncAdcRequest;	
	
	------------------------------------------ SPI & Datamappers ---------------------------------------------------

		--Just sync external SPI clock to master clock
		IBufOE : IBufP2Ports
		port map
		(
			clk => MasterClk,
			I => RamBusOE,
			O => RamBusOE_i--,
		);
		
		--Just sync external SPI clock to master clock
		IBufCE : IBufP2Ports
		port map
		(
			clk => MasterClk,
			I => RamBusnCs(0),
			O => RamBusCE_i--,
		);

		--Just sync external SPI serial data input to master clock
		IBufWE : IBufP2Ports
		port map
		(
			clk => MasterClk,
			I => RamBusWE,
			O => RamBusWE_i--,
		);

		GenRamAddrBus: for i in 0 to 15 generate
		begin
		IBUF_RamAddr_i : IBufP2Ports
		port map (
			clk => MasterClk,
			I => RamBusAddress(i),
			O => RamBusAddress_i(i)--,
		); 
		end generate;
		
		GenRamDataBus: for i in 0 to 15 generate
		begin
		IOBUF_RamData_i : IOBufP2Ports
		port map (
			clk => MasterClk,
			IO => RamBusData(i),
			T => not(nTristateRamDataPins),
			I => RamDataOut(i),
			O => RamDataIn(i)--,
		);
		end generate;
		
		--~ RamBusData(15 downto 8) <= "ZZZZZZZZ";
		--~ RamBusData <= x"0000";
		--~ RamBusData <= x"AA55";
		--~ RamBusData <= x"A55A" when ( (RamBusOE = '0') and (RamBusnCs(0) = '0') ) else "ZZZZZZZZZZZZZZZZ";
		--~ RamBusData <= x"0000" when ( (RamBusOE = '0') and (RamBusnCs(0) = '0') ) else "ZZZZZZZZZZZZZZZZ";
		--~ RamBusData <= RamBusAddress when ( (RamBusOE = '0') and (RamBusnCs(0) = '0') ) else "ZZZZZZZZZZZZZZZZ";		
		--~ RamBusData <= RamBusAddress;		
		--~ RamBusRdy <= '0';
		
		--~ RamBusData(15 downto 8) <= x"55" when ( (RamBusOE = '0') and (RamBusnCs(0) = '0') ) else "ZZZZZZZZ";		
		--~ RamBusData(7 downto 0) <= RamDataOut when ( (RamBusOE = '0') and (RamBusnCs(0) = '0') ) else "ZZZZZZZZ";		
		--~ RamBusData(15 downto 8) <= RamDataOut when ( (RamBusOE = '0') and (RamBusnCs(0) = '0') ) else "ZZZZZZZZ";		
	
		--~ RamBusData <= RamBusAddress_i when ( (RamBusOE = '0') and (RamBusnCs(0) = '0') ) else "ZZZZZZZZZZZZZZZZ";			
		--~ RamBusData <= RamDataOut when ( (RamBusOE = '0') and (RamBusnCs(0) = '0') ) else "ZZZZZZZZZZZZZZZZ";		
	
	CurrentSRamAddr(16 downto 1) <= RamBusAddress_i;
	CurrentSRamAddr(0) <= '0'; --16-bit ram expected, so no odd addresses, the address is the word addr, not the byte addr, so we hardcode addr 0 to 0 for compatibility...
	
	--devmem2 0x021B8010 w 0x3F000FE0 for max wait states on arm, write is taking 400ns / word, 1us / 32b
	DataToWrite <= RamDataIn;
	DataWriteReq <= '1' when ( (RamBusCE_i = '0') and (RamBusWE_i = '0') ) else '0';
	
	--devmem2 0x021B8008 w 0x3F000707 for max wait states on arm, read is taking 400ns / word, 1us / 32b
	RamDataOut <= DataFromRead;
	--~ DataReadReq  <= '1' when ( (RamBusnCs(0) = '0') and (RamBusOE = '0') ) else '0';
	--~ nTristateRamDataPins <= '1' when ( (RamBusnCs(0) = '0') and (RamBusOE = '0') ) else '0';
	--RamBusData <= RamDataOut when ( (RamBusOE = '0') and (RamBusnCs(0) = '0') ) else "ZZZZZZZZZZZZZZZZ";	
	DataReadReq  <= '1' when ( (RamBusCE_i = '0') and (RamBusOE_i = '0') ) else '0';
	nTristateRamDataPins <= '1' when ( (RamBusCE_i = '0') and (RamBusOE_i = '0') ) else '0';

	--~ TP4 <= DataWriteReq;
	--~ TP5 <= DataWriteAck;
	--~ TP6 <= RamBusnCs(0);
	--~ TP7 <= RamDataIn(0);
	--~ TP8 <= RamBusWE;
	
	--Does aforementioned mapping between SPI transactions and specific registers - see DataMapper.vhd for adress <-> register mapping (which is always sent as first byte of frame on SPI)
	DataMapper : DataMapperPorts
	generic map 
	(
		RAM_ADDRESS_BITS => 17,
		FIFO_BITS => FifoBitsMinimum,
		MUX_ADDRESS_BITS => 4--,
	)
	port map
	(
		clk => MasterClk,
		Address => CurrentSRamAddr,
		DataToWrite => DataToWrite,
		DataFromRead => DataFromRead,
		DataReadReq => DataReadReq,
		DataWriteReq => DataWriteReq,
		DataReadAck => DataReadAck,
		DataWriteAck => DataWriteAck,
		AdcClkDivider => SarAdcClkDivider,
		AdcPeriodDividerOut => TxPeriodDivider,
		AdcPeriodDividerIn => TxPeriodDivider,
		AdcDutyDividerOut => TxDutyDivider,
		AdcDutyDividerIn => TxDutyDivider,
		GeneratePps => GeneratePps,
		UsingAtomicClock => UsingAtomicClock,
		SyncPeriodDuty => SyncPeriodDuty,
		PeriodDutySynced => PeriodDutySynced,
		SyncAdc => SyncAdcRequest,
		SarSyncCompleted => SarSyncCompleted,
		ResetSyncCompleted => ResetSyncCompleted,
		TxTriggerAdc => TxTriggerAdc,
		PeriodTriggerQuadrant => PeriodTriggerQuadrant,
		DutyTriggerQuadrant => DutyTriggerQuadrant,
		PeriodTriggerEither => PeriodTriggerEither,
		DutyTriggerEither => DutyTriggerEither,
		PPSTriggerAdc => PPSTriggerAdc,
		AdcPeriod => TxPeriod_i,
		AdcDuty => TxDuty_i,
		DutyOff => DutyOff,
		PPSDetected => PPSDetected,
		SetChangedTime => SetChangedTime,
		PPSCount => PPSCount,
		--~ PPSCount => PPSCounter, --debug: get the current count since the PPS at any given time, instead of the total for the last PPS period. Note this will completely disable the GPS sync code in the arm.
		PPSCountReset => PPSCountReset,
		SarAdcSample => SarFifoAdcSample,
		--~ SarAdcSample => x"8AAA55514CC24CC2",
		SarAdcSampleCount => SarAdcSampleCount,--(10 downto 0),
		SarReadAdcSample => SarReadAdcSample,
		SarAdcSampleReadAck => SarAdcSampleReadAck,
		SarAdcSampleFifoFull => SarAdcSampleFifoFull,
		SarAdcSampleFifoEmpty => SarAdcSampleFifoEmpty,
		SarAdcFifoReset => SarAdcFifoReset,
		SarAdcOverrange => SarAdcOverrange,
		SarSamplesToAverage => SarSamplesToAverage,
		SarSamplesPerSecond => SarSamplesPerSecond,
		AdcGain => AdcGainMux,
		GpsUart => FifoGpsUart,
		ReadGpsUart => ReadGpsUart,
		GpsUartReadAck => GpsUartReadAck,
		GpsUartFifoFull => GpsUartFifoFull,
		GpsUartFifoEmpty => GpsUartFifoEmpty,
		GpsUartCount => GpsUartCount,
		GpsFifoReset => GpsFifoReset,
		WriteGpsOutTxd => WriteGpsOutTxd,
		GpsOutTxdWriteData => GpsOutTxdWriteData,
		GpsOutTxdFifoFull => GpsOutTxdFifoFull,
		GpsOutTxdFifoEmpty => GpsOutTxdFifoEmpty,
		GpsOutTxdCount => GpsOutTxdCount,
		UsbUart => FifoUsbUart,
		ReadUsbUart => ReadUsbUart,
		UsbUartReadAck => UsbUartReadAck,
		UsbUartFifoFull => UsbUartFifoFull,
		UsbUartFifoEmpty => UsbUartFifoEmpty,
		UsbUartCount => UsbUartCount,
		UsbFifoReset => UsbFifoReset,
		UsbSwitch => UsbSw_i,
		SecondsOut => SetTimeSeconds,
		SecondsIn => Seconds,
		SetTime => SetTime,
		Milliseconds => Milliseconds,
		SDPower => SDPower,
		RadioPower => RadioPower,		
		SpiExtInUse => SpiExtInUse,
		SpiExtAddr => SpiExtAddr,
		ZigUart => FifoZigUart,
		ReadZigUart => ReadZigUart,
		ZigUartReadAck => ZigUartReadAck,
		ZigUartFifoFull => ZigUartFifoFull,
		ZigUartFifoEmpty => ZigUartFifoEmpty,
		ZigUartCount => ZigUartCount,
		ZigFifoReset => ZigFifoReset,
		UartMux => UartMux,

		--Internal bus writes to the Tx fifo
		WriteSpiTxUart => WriteSpiTxUart,
		SpiTxUartWriteData => SpiTxUartWriteData,
		ReadSpiTxUart => open,
		SpiTxUartReadData => x"00",
		SpiTxUartReadAck => '1',
		SpiTxUartFifoFull => SpiTxUartFifoFull,
		SpiTxUartFifoEmpty => SpiTxUartFifoEmpty,
		SpiTxUartCount => SpiTxUartCount,
		SpiTxFifoReset => SpiTxFifoReset,
		
		--Internal bus reads from the Rx fifo
		WriteSpiRxUart => open,
		SpiRxUartWriteData => open, 
		ReadSpiRxUart => ReadSpiRxUart,
		SpiRxUartReadData => SpiRxUartReadData,
		SpiRxUartReadAck => SpiRxUartReadAck,
		SpiRxUartFifoFull => SpiRxUartFifoFull,
		SpiRxUartFifoEmpty => SpiRxUartFifoEmpty,
		SpiRxUartCount => SpiRxUartCount,
		SpiRxFifoReset => SpiRxFifoReset,
		
		ZBusAddrOut => ZBusAddr,
		SetZBusAddr => SetZBusAddr,
		ZBusAddrIn => ZBusAddrExt,
		ZBusWriteData => ZBusWriteOut,
		WriteZBus => WriteZBus,
		ZBusReadbackData => ZBusReadback,
		
		WriteZigOutTxd => WriteZigOutTxd,
		ZigOutTxdWriteData => ZigOutTxdWriteData,
		ZigOutTxdFifoFull => ZigOutTxdFifoFull,
		ZigOutTxdFifoEmpty => ZigOutTxdFifoEmpty,
		ZigOutTxdCount => ZigOutTxdCount,
		
		AClkUart => FifoAClkUart,
		ReadAClkUart => ReadAClkUart,
		AClkUartReadAck => AClkUartReadAck,
		AClkUartFifoFull => AClkUartFifoFull,
		AClkUartFifoEmpty => AClkUartFifoEmpty,
		AClkUartCount => AClkUartCount,
		AClkFifoReset => AClkFifoReset,
		WriteAClkOutTxd => WriteAClkOutTxd,
		AClkOutTxdWriteData => AClkOutTxdWriteData,
		AClkOutTxdFifoFull => AClkOutTxdFifoFull,
		AClkOutTxdFifoEmpty => AClkOutTxdFifoEmpty,
		AClkOutTxdCount => AClkOutTxdCount,
		
		XMTUart => FifoXMTUart,
		ReadXMTUart => ReadXMTUart,
		XMTUartReadAck => XMTUartReadAck,
		XMTUartFifoFull => XMTUartFifoFull,
		XMTUartFifoEmpty => XMTUartFifoEmpty,
		XMTUartCount => XMTUartCount,
		XMTFifoReset => XMTFifoReset,
		WriteXMTOutTxd => WriteXMTOutTxd,
		XMTOutTxdWriteData => XMTOutTxdWriteData,
		XMTOutTxdFifoFull => XMTOutTxdFifoFull,
		XMTOutTxdFifoEmpty => XMTOutTxdFifoEmpty,
		XMTOutTxdCount => XMTOutTxdCount,
				
		PPSRtcPhaseCmp => PPSRtcPhaseCmp,
		SarPPSAdcPhaseCmp => SarPPSAdcPhaseCmp,
		PPSPeriodDutyPhaseCmp => PPSPeriodDutyPhaseCmp,

		ForcePnD => ForcePnD,
		ForcedPeriod => ForcedPeriod,
		ForcedDuty => ForcedDuty,
		
		ClkDacWrite => ClkDacWrite,
		WriteClkDac => WriteClkDac,
		ClkDacReadback => ClkDacReadback,
		
		LastSPIExtAddr => CurrentSPIExtAddr,
		
		SyncSummary => SyncSummary,
		
		ChopperEnable => ChopperEnable,
		
		DnaRegister => DnaRegister_i,
		BuildNum => BuildNum--,
	);
			
		--Just sync external SPI frame signal to master clock
		IBufnCsExt : IBufP2Ports
		port map
		(
			clk => MasterClk,
			I => nCsExt,
			O => nCsExt_i--,
		);
				
		--Just sync external SPI clock to master clock
		IBufSckExt : IBufP2Ports
		port map
		(
			clk => MasterClk,
			I => SckSpiExt,
			O => SckExt_i--,
		);

		--Just sync external SPI serial data input to master clock
		IBufMosiExt : IBufP2Ports
		port map
		(
			clk => MasterClk,
			I => MosiSpiExt,
			O => MosiExt_i--,
		);

	--Makes FPGA able to decode SPI data into a buffer
	SpiRegistersExt : SpiRegistersPorts
	port map
	(
		ByteComplete => ExtByteComplete,
		AddrLatched => ExtAddressLatched,
		clk => MasterClk,
		nCS => nCsExt_i,
		Sck => SckExt_i,
		Mosi => MosiExt_i,
		Miso => MisoExt_i,
		nCsAck => open,
		Address => CurrentSPIExtAddr,
		DataToWrite => ExtDataToWrite,
		DataWriteReq => ExtDataWriteReq,
		DataWriteAck => ExtDataWriteAck,
		DataFromRead => ExtDataFromRead,
		DataReadReq => ExtDataReadReq,
		DataReadAck => ExtDataReadAck--,
	);
			
	------------------------------------------------------ A/D ------------------------------------------------------------
		
	IBufSarAdcnDrdy : IBufP2Ports
	port map
	(
		clk => MasterClk,
		I => SarAdcnDrdy,
		O => SarAdcnDrdy_i--,
	);

	IBufSarAdcMiso : IBufP2Ports
	port map
	(
		clk => MasterClk,
		I => SarAdcMiso,
		O => SarAdcMiso_i--,
	);
	
	ltc2378 : ltc2378fifoPorts
	--~ generic map (
		--~ MASTER_CLOCK_FREQHZ => BoardMasterClockFreq,
	--~ );
	port map
	(
		clk => MasterClk,
		rst => SarAdcFifoReset_i,
		--~ rst => '0',
		Trigger => SarAdcTrig_i,
		nDrdy => SarAdcnDrdy_i,
		Sck => SarAdcSck_i,
		Miso => SarAdcMiso_i,
		MosiDbg => SarAdcMosiDbg_i,
		nCs => SarAdcnCs_i,
		--~ nCs => open,
		OverRange => SarAdcOverrange,
		AdcPowerDown => SarAdcFifoReset_i,
		AdcClkDivider => SarAdcClkDivider,
		SamplesToAverage => SarSamplesToAverage,
		SamplesPerSecond => SarSamplesPerSecond,
		--~ AdcPowerDown => '0',
		--~ AdcClkDivider => x"002F",
		--~ SamplesToAverage => x"03FF",		
		--~ SamplesPerSecond => x"00000400",
		PPS => PPS_i,
		PPSCount => PPSCounter(26 downto 0),
		Seconds => Seconds(12 downto 0),
		SyncRequest => SyncAdcRequest,
		SyncCompleted => SarSyncCompleted,
		SampleTimestampLatched => SarSampleTimestampLatched,
		TxTrigger => TxTriggerAdc,		
		--~ TxTrigger => '0',		
		PeriodTriggerQuadrant => PeriodTriggerQuadrant,	
		DutyTriggerQuadrant => DutyTriggerQuadrant,
		PeriodTriggerEither => PeriodTriggerEither,	
		DutyTriggerEither => DutyTriggerEither,
		PPSTrigger => PPSTriggerAdc,
		--~ PPSTrigger => '0',
		AdcPeriod => TxPeriod_i,
		AdcDuty => TxDuty_i,
		ChopperEnable => ChopperEnable,
		ChopperMuxPos => ChopperMuxPos,
		ChopperMuxNeg => ChopperMuxNeg,
		--~ TP1 <= SampleLatched;
		--~ TP2 <= SpiRst_i;
		--~ TP3 <= WriteSampleFifo;
		TP1 => TP3,
		TP2 => TP4,
		TP3 => TP5,
		TP4 => TP6,
		--~ TP1 => open,
		--~ TP2 => open,
		--~ TP3 => open,
		--~ TP4 => open,
		ReadAdcSampleFifo  => SarReadAdcSample, --inversion results in read on falling edge so next sample is always in register before we start reading. When fifo is emptied, the first sample will probably always be crap, we'll fix that when this works...
		AdcSampleFifoReadAck => SarAdcSampleReadAck,
		AdcSampleFifoData => SarFifoAdcSample,
		AdcSampleFifoFull => SarAdcSampleFifoFull,
		AdcSampleFifoEmpty => SarAdcSampleFifoEmpty,
		AdcSampleFifoCount => SarAdcSampleCount--,
	);

	LedR <= '1' when ( ( (SarFifoAdcSample(23) /= SarFifoAdcSample(15)) and (SarFifoAdcSample(23) /= SarFifoAdcSample(16)) ) or (SarAdcOverrange = '1') ) else '0';
	
	--We pretty much want to keep the xilinx away from the a/d and in a known state if we reset the whole fpga, or clear the fifos, or reset the a/d via the pin, or the arm tries to tweak it's settings over it's own spi.
	SarAdcFifoReset_i <= (not nMasterReset) or SarAdcFifoReset; -- this keeps arm from being able to talk: or (not nCsAdcuC);
		
	--Map the other A/D signals to the actual pins:
	SarAdcTrig <= SarAdcTrig_i;
	SarAdcnCs <= SarAdcnCs_i;
	--~ SarAdcnCs <= '0';
	SarAdcSck <= SarAdcSck_i;
		
	--To test between fpga & A/D:
	--~ TP8 <= SarAdcTrig_i;
	--~ TP4 <= SarAdcnDrdy_i;
	--~ TP5 <= SarSampleTimestampLatched;
	--~ TP6 <= SarAdcnCs_i;
	--~ TP7 <= PPS_i;
	--~ TP5 <= SarAdcSck_i;
	--~ TP8 <= SarAdcMiso_i;
	
	--To test between fpga & uC:
	--~ TP8 <= SarReadAdcSample;
	--~ TP4 <= SarAdcSampleReadAck;
	--~ TP5 <= SarFifoAdcSample(0);
	TP7 <= SarAdcSampleFifoFull;
	TP8 <= SarAdcSampleFifoEmpty;
	--~ TP7 <= TxPeriod_i;
	--~ TP8 <= TxDuty_i;
		
	--~ TP8 <= SarAdcSampleCount(0);
	
	------------------------------------------ Clock Steering D/A ---------------------------------------------------
	
	IBufDacMiso : IBufP2Ports
	port map
	(
		clk => MasterClk,
		I => MisoClk,
		O => MisoClk_i--,
	);

	ClkDac_i : SpiDacPorts
	generic map 
	(
		MASTER_CLOCK_FREQHZ => BoardMasterClockFreq--,
	)
	port map 
	(
		clk => MasterClk,
		rst => not(nMasterReset),
		nCs => nCsClk_i,
		Sck => SckClk_i,
		Mosi => MosiClk_i,
		Miso => MisoClk_i,
		DacWriteOut => ClkDacWrite,
		WriteDac => WriteClkDac,
		DacReadback => ClkDacReadback
	);

	nCsClk <= nCsClk_i;
	SckClk <= SckClk_i;
	MosiClk <= MosiClk_i;
	
	--~ TP4 <= nCsClk_i;
	--~ TP5 <= SckClk_i;
	--~ TP6 <= MosiClk_i;
	--~ TP8 <= MisoClk;
	
	------------------------------------------ GPS Uart+Fifo ---------------------------------------------------
	
	--Mux master reset (boot) and user reset (datamapper)
	GpsFifoReset_i <= (not nMasterReset) or GpsFifoReset;
	
	TxduC1 <= RxdGpsMux;
	
	--What pin is the gps serial data coming from on the pcb?
	RxdGpsMux <=	RxduC1 when ( (GeneratePps = '1') or (UsingAtomicClock = '1') ) else 	--get RXD looped back from arm's GPS simulator
					TxdGps;
					
	--Holds characters from the GPS until the uC is ready to chew on them
	GpsUart : UartRxFifoParity
	generic map
	(
		UART_CLOCK_FREQHZ => UartClockFreq,
		FIFO_BITS => FifoBitsMinimum,
		BAUDRATE => 9600--,
	)
	port map
	(
		clk => MasterClk,
		uclk => UartClk,
		rst => GpsFifoReset_i,
		Rxd => RxdGpsMux,
		ReadFifo => ReadGpsUart,
		FifoFull => GpsUartFifoFull,
		FifoEmpty => GpsUartFifoEmpty,
		FifoReadData => FifoGpsUart,
		FifoCount => GpsUartCount,
		FifoReadAck => GpsUartReadAck--,		
	);
	
	GpsOutUart : UartTxFifoParity
	generic map
	(
		UART_CLOCK_FREQHZ => UartClockFreq,
		FIFO_BITS => FifoBitsMinimum,
		PARITY_EVEN => '0',
		BAUDRATE => 9600--,
	)
	port map
	(
		clk => MasterClk,
		uclk => UartClk,
		rst => GpsFifoReset_i,
		WriteStrobe => WriteGpsOutTxd,
		WriteData => GpsOutTxdWriteData,
		FifoFull => GpsOutTxdFifoFull,
		FifoEmpty => GpsOutTxdFifoEmpty,
		FifoCount => GpsOutTxdCount,
		TxInProgress => GpsOutTxdInProgress,
		Cts => '0',
		Txd => GpsOutTxdPin--,
	);
	
	RxdGps <= GpsOutTxdPin; --use fpga uart
	--~ RxdGps <= RxduC1; --Use arm's uart
	
	--~ TP4 <= GpsOutTxdPin;
	--~ TP5 <= WriteGpsOutTxd;
	--~ TP6 <= GpsOutTxdFifoEmpty;
	--~ TP8 <= GpsOutTxdInProgress;
	--~ TP8 <= SarSamplesToAverage(0); --so we can test if we're hitting the high bits of addr by setting to even/odd values
	
	------------------------------------------ USB Uart+Fifo ---------------------------------------------------
	
	--Mux master reset (boot) and user reset (datamapper)
	UsbFifoReset_i <= (not nMasterReset) or UsbFifoReset;
	
	UsbUart : UartRxFifo
	generic map
	(
		UART_CLOCK_FREQHZ => UartClockFreq,
		FIFO_BITS => FifoBitsMinimum,
		BAUDRATE => 230400--,
	)
	port map
	(
		clk => MasterClk,
		uclk => UartClk,
		rst => UsbFifoReset_i,
		Rxd => RxdUsb,
		ReadFifo => ReadUsbUart,
		FifoFull => UsbUartFifoFull,
		FifoEmpty => UsbUartFifoEmpty,
		FifoReadData => FifoUsbUart,
		FifoCount => UsbUartCount,
		FifoReadAck => UsbUartReadAck--,		
	);
	
	UsbTxUartPin <= '1';
	UsbTxUartFifoEmpty <= '1';
	UsbTxUartInProgress <= '0';	
	TxdUsb <= RxduC0 when ( (UsbTxUartFifoEmpty = '1') and (UsbTxUartInProgress = '0') ) else UsbTxUartPin;

	TxduC0 <= RxdUsb;

	------------------------------------------ Zig Uart+Fifo ---------------------------------------------------
	
	--Note on configuring the XBee/XStick: Digi's config program "XCTU", requires both the correct serial port and "Enable API" mode on it's first pane
	--Defaults for newly purchased XStick devices are 9600bps and "Enable API".  First, go to the final tab, change the firmware to one ending in "AT" instead of API, then write the firmware
	--The write will say there were errors - go back to the first pane and uncheck "Enable API" at this point; do a read, and it should work fine.  You can then set the baud rate to 115k,
	-- and change XCTU to 115k, then re-read, and all settings should be ok.
	
	--~ RstZig <= not(ZigFifoReset_i); --Just let 'er run.
	RstZig <= RadioPower; --Just let 'er run.
	PwrRadio <= RadioPower;
	--~ TP6 <= RadioPower;
	
	--Mux master reset (boot) and user reset (datamapper)
	ZigFifoReset_i <= (not nMasterReset) or ZigFifoReset;
	--~ TP5 <= (not nMasterReset) or ZigFifoReset;
	
	ZigUart : UartRxFifo
	generic map
	(
		UART_CLOCK_FREQHZ => UartClockFreq,
		FIFO_BITS => FifoBitsMinimum,
		BAUDRATE => 115200--,
	)
	port map
	(
		clk => MasterClk,
		uclk => UartClk,
		rst => ZigFifoReset_i,
		--~ rst => '0',
		Rxd => RxdZig,
		--~ Rxd => ZigOutTxdPin, --loopback
		--~ Rxd => RxduC1, --loopback
		ReadFifo => ReadZigUart,
		FifoFull => ZigUartFifoFull,
		FifoEmpty => ZigUartFifoEmpty,
		FifoReadData => FifoZigUart,
		FifoCount => ZigUartCount,
		FifoReadAck => ZigUartReadAck--,		
	);
	
	--~ TP7 <= RxdZig;
	RtsZig <= ZigUartFifoFull; --RTS pin -> radio; when high, radio won't send more bytes to fpga
	--~ RtsZig <= '0'; --RTS pin -> radio; when high, radio won't send more bytes to fpga
	--~ TP4 <= ZigUartFifoFull;
	
	ZigOutUart : UartTxFifo
	generic map
	(
		UART_CLOCK_FREQHZ => UartClockFreq,
		FIFO_BITS => FifoBitsMinimum,
		BAUDRATE => 115200--,
	)
	port map
	(
		clk => MasterClk,
		uclk => UartClk,
		rst => ZigFifoReset_i,
		WriteStrobe => WriteZigOutTxd,
		WriteData => ZigOutTxdWriteData,
		FifoFull => ZigOutTxdFifoFull,
		FifoEmpty => ZigOutTxdFifoEmpty,
		FifoCount => ZigOutTxdCount,
		TxInProgress => ZigOutTxdInProgress,
		Cts => CtsZig, --radio CTS is connected to miso pin...
		--~ Cts => '0',
		Txd => ZigOutTxdPin--,
	);
	
	--~ TP3 <= CtsZig;
	
	TxdZig <= ZigOutTxdPin;
	--~ TP8 <= ZigOutTxdPin;
	------------------------------------------ Atomic Clock Uart+Fifo ---------------------------------------------------

	--Mux master reset (boot) and user reset (datamapper)
	AClkFifoReset_i <= (not nMasterReset) or AClkFifoReset;
	
	AClkUart : UartRxFifo
	generic map
	(
		UART_CLOCK_FREQHZ => UartClockFreq,
		FIFO_BITS => FifoBitsMinimum,
		BAUDRATE => 57600--,
	)
	port map
	(
		clk => MasterClk,
		uclk => UartClk,
		rst => AClkFifoReset_i,
		--~ Rxd => ZRst, --Brd326 h/w v1.0
		Rxd => RxdAClk, --Brd326 h/w v2.x
		ReadFifo => ReadAClkUart,
		FifoFull => AClkUartFifoFull,
		FifoEmpty => AClkUartFifoEmpty,
		FifoReadData => FifoAClkUart,
		FifoCount => AClkUartCount,
		FifoReadAck => AClkUartReadAck--,		
	);
	
	AClkOutUart : UartTxFifo
	generic map
	(
		UART_CLOCK_FREQHZ => UartClockFreq,
		FIFO_BITS => FifoBitsMinimum,
		BAUDRATE => 57600--,
	)
	port map
	(
		clk => MasterClk,
		uclk => UartClk,
		rst => AClkFifoReset_i,
		WriteStrobe => WriteAClkOutTxd,
		WriteData => AClkOutTxdWriteData,
		FifoFull => AClkOutTxdFifoFull,
		FifoEmpty => AClkOutTxdFifoEmpty,
		FifoCount => AClkOutTxdCount,
		TxInProgress => AClkOutTxdInProgress,
		Cts => '0',
		Txd => AClkOutTxdPin--,
	);
	
	--~ ZRst2 <= AClkOutTxdPin; --Brd326 h/w v1.0
	TxdAClk <= AClkOutTxdPin; --Brd326 h/w v2.x
	
	------------------------------------------ XMT Interface Uart+Fifo ---------------------------------------------------

	--Mux master reset (boot) and user reset (datamapper)
	XMTFifoReset_i <= (not nMasterReset) or XMTFifoReset;
	
	XMTUart : UartRxFifo
	generic map
	(
		UART_CLOCK_FREQHZ => UartClockFreq,
		FIFO_BITS => FifoBitsMinimum,
		BAUDRATE => 38400--,
	)
	port map
	(
		clk => MasterClk,
		uclk => UartClk,
		rst => XMTFifoReset_i,
		Rxd => RxdXMT,
		ReadFifo => ReadXMTUart,
		FifoFull => XMTUartFifoFull,
		FifoEmpty => XMTUartFifoEmpty,
		FifoReadData => FifoXMTUart,
		FifoCount => XMTUartCount,
		FifoReadAck => XMTUartReadAck--,		
	);
	
	XMTOutUart : UartTxFifo
	generic map
	(
		UART_CLOCK_FREQHZ => UartClockFreq,
		FIFO_BITS => FifoBitsMinimum,
		BAUDRATE => 38400--,
	)
	port map
	(
		clk => MasterClk,
		uclk => UartClk,
		rst => XMTFifoReset_i,
		WriteStrobe => WriteXMTOutTxd,
		WriteData => XMTOutTxdWriteData,
		FifoFull => XMTOutTxdFifoFull,
		FifoEmpty => XMTOutTxdFifoEmpty,
		FifoCount => XMTOutTxdCount,
		TxInProgress => XMTOutTxdInProgress,
		Cts => '0',
		Txd => XMTOutTxdPin--,
	);
	
	TxdXMT <= XMTOutTxdPin;
	
	------------------------------------------ Internal 'uart' Fifos (no actual uart, we just stuff chars in/out of them as if they were uarts) ---------------------------------------------------
	
	SpiTxUartFifo : gated_fifo
	generic map
	(
		WIDTH_BITS => 8,
		DEPTH_BITS => FifoBitsMinimum--,
	)
	port map
	(
		clk => MasterClk,
		rst => SpiTxFifoReset,
		wone_i => WriteSpiTxUart,
		data_i => SpiTxUartWriteData,
		rone_i => ReadSpiTxUart,
		full_o => SpiTxUartFifoFull,
		empty_o => SpiTxUartFifoEmpty,
		data_o => SpiTxUartReadData,
		count_o => SpiTxUartCount,
		r_ack => SpiTxUartReadAck--,
	);

	SpiRxUartFifo : gated_fifo
	generic map
	(
		WIDTH_BITS => 8,
		DEPTH_BITS => FifoBitsMinimum--,
	)
	port map
	(
		clk => MasterClk,
		rst => SpiRxFifoReset,
		wone_i => WriteSpiRxUart,
		data_i => SpiRxUartWriteData,
		rone_i => ReadSpiRxUart,
		full_o => SpiRxUartFifoFull,
		empty_o => SpiRxUartFifoEmpty,
		data_o => SpiRxUartReadData,
		count_o => SpiRxUartCount,
		r_ack => SpiRxUartReadAck--,
	);
	
	------------------------------SD Card----------------------------------
	
	PwrSD <= SDPower;
	
	UsbSw <= UsbSw_i; --(see constants UsbSwUart and UsbSwArmUsbClient for behavior of Usb Mux device)

	------------------------------ZBus Addr (38.4k serial on nCs0 pin)----------------------------------

	ZBusAddrOutUart : ZBusAddrTxPorts
	generic map	(
		MASTER_CLOCK_FREQHZ => BoardMasterClockFreq--,
	)
	port map (
		clk => MasterClk,
		rst => not(nMasterReset),
		ZBusAddr => ZBusAddr,
		SendZBusAddr => SetZBusAddr,
		SendingZBusAddr => ZBusAddrIsOutgoing,
		ZBusAddrTxdPin => ZBusAddrTxdPin--,
	);
	
	nCsSpiExt0 <= ZBusAddrTxdPin;
	
	ZBusAddrInUart : UartRx
	generic map (
		CLOCK_FREQHZ => BoardMasterClockFreq,
		BAUDRATE => 38400--;
	)
	port map (						
		clk => MasterClk,
		rst => not(nMasterReset),
		Rxd => nCsSpiExt0,
		RxComplete => open,
		RxData => ZBusAddrExt
	);
	
	IBufZBusMiso : IBufP2Ports
	port map
	(
		clk => MasterClk,
		I => MisoSpiExt,
		O => MisoZBus_i--,
	);

	ZBus_i : ZBusPorts
	generic map 
	(
		MASTER_CLOCK_FREQHZ => BoardMasterClockFreq--,
		--~ CLOCK_DIVIDER => MASTER_CLOCK_FREQHZ / 100000, --100kHz
	)
	port map 
	(
		clk => MasterClk,
		rst => not(nMasterReset),
		nCs => nCsZBus_i, --we use the serial nCs, not a 'real' TTL nCs.
		Sck => SckZBus_i,
		Mosi => MosiZBus_i,
		Miso => MisoZBus_i,
		--~ Miso => MosiZBus_i, --debug loopback
		ZBusWriteOut => ZBusWriteOut,
		WriteZBus => WriteZBus,
		ZBusReadReady => ZBusReadReady,
		ZBusReadback => ZBusReadback
		--~ ZBusReadback => open
	);
	
	--~ TP4 <= nCsZBus_i;
	--~ TP5 <= SckZBus_i;
	--~ TP6 <= MosiZBus_i;
	--~ TP8 <= ZBusReadReady;
	
	--~ ZBusReadback <= x"BB";
	
	--SpiExtInUse: this is the readback from the outside world, to see if another card is using the bus as master
	SpiExtInUse <= x"00" when ( (ZBusAddrExt = x"00") or (ZBusAddrExt = x"FF") ) else x"01";
	
	--This is how we figure out nCsExt:
	nCsExt <= '0' when (ZBusAddrExt = SpiExtAddr) else '1'; --inverted; 0=true

	--This is all the connections for the SpiExt bus to the hub board (BD335)
	SckSpiExt <= SckZBus_i;
	MosiSpiExt <= MosiZBus_i;
	MisoSpiExt <= MisoExt_i when (nCsExt_i = '0') else 'Z';
	nCsSpiExt1 <= X1;
	nCsSpiExt2 <= X2;
	GpsRxdSpiExt <= RxdGpsMux;
	GpsPpsSpiExt <= PPSMux;
	
	--~ TP4 <= nCsSpiExt0;
	--~ TP5 <= SckSpiExt;
	--~ TP6 <= MosiSpiExt;
	--~ TP8 <= MisoSpiExt;
	
	--Run the aux spi (we're just using it for the mux at the moment)
	SckAux <= 'Z';
	MosiAux <= 'Z';
	MisoAux <= 'Z';
	nCs0Aux <= 'Z';
	nCs1Aux <= 'Z';
	nCs2Aux <= 'Z'; --reserved for the moment...
	
	--~ TP4 <= nCsZBus_i;
	--~ TP5 <= DataReadReq;
	--~ TP6 <= WriteZBus;
	--~ TP8 <= ZBusReadReady;

	--~ TP4 <= nCsZBus_i;
	--~ TP5 <= SckZBus_i;
	--~ TP6 <= MosiZBus_i;
	--~ TP8 <= MisoZBus_i;

	------------------------------ZBus Addr (38.4k serial on nCs0 pin)----------------------------------

	--Our DC/DC buck power supply requires a 1MHz clock to sync to the a/d multiple:
	DcDcClkDivider : ClockDividerPorts
	generic map
	(
		CLOCK_DIVIDER => 96, --100MHz / 100 = 1MHz
		DIVOUT_RST_STATE => '0'--,
	)
	port map
	(
		clk => MasterClk,
		rst => not(nMasterReset),
		div => DcDcClk_i--,
	);
	
	--~ DeLevelXDir <= '0';
	
	--Map the clock for the DC/DC to it's output pin
	SyncDCDC <= DcDcClk_i;
	
	ArmMiso <= '1';
	
	LedG <= nMasterReset xor not(PPS_i);
	
	-----------------------------Debug----------------------------------
		
	--~ LedR <= SarAdcOverrange or SarAdcSampleFifoFull or DeAdcOverrange or DeAdcSampleFifoFull;
	--~ LedG <= PpsGps;
	
	--~ LedG <= not(TxDuty_i);
	--~ LedR <= UsbUartCount(0);
	--~ LedG <= PPS_i;
	--~ LedR <= not(TP3);
	
	--This is the definitive debug suite - all signals that must remain in sync...
	--~ TP3 <= TxPeriod_i; --To check Period & Duty phase
	--~ TP4 <= PpsGenerated; --To check RTC phase
	--~ TP5 <= PPS_i; --To check A/D phase
	--~ TP6 <= PPSMux; --GPS's PPS to check phase against
	
	--Debug RAM bus:
	--TP3 <= nTristateRamDataPins;
	--~ TP4 <= RamBusOE_i;
	--~ TP5 <= RamBusWE_i;
	--~ TP6 <= nTristateRamDataPins;
	--~ TP7 <= DataWriteAck;
	--~ TP8 <= DataReadAck;
	--~ Addr => RamBusAddress_i,
	--~ DataIn => RamDataIn,
	--~ DataOut => RamDataOut,
	--~ IntAddress => CurrentSRamAddr,
	--~ TP4 <= RamBusOE;
	--~ TP5 <= DataReadAck;
	--~ TP6 <= RamBusAddress(0);
	--~ TP7 <= RamBusAddress(1);
	--~ TP8 <= nTristateRamDataPins;
	
	--~ TP4 <= SarAdcMiso_i;
	--~ TP5 <= SarAdcnDrdy_i;
	--~ TP6 <= SarAdcSck_i;
	--~ TP7 <= SarAdcMosiDbg_i;
	--~ TP8 <= SarAdcnCs_i;
	
	--~ TP4 <= RamBusAddress_i(15);
	--~ TP5 <= RamBusAddress_i(14);
	--~ TP6 <= RamBusAddress_i(13);
	--~ TP7 <= RamBusAddress_i(12);
	--~ TP8 <= RamBusAddress_i(11);
	
	
	--~ TP3 <= ArmSck;
	--~ TP4 <= ArmMosi;
	--~ TP5 <= MisoSpiExt;
	--~ TP6 <= X0 or X3 or X2;
	--~ TP3 <= nCsSpiExt0;
	--~ TP4 <= nCsSpiExt1;
	--~ TP5 <= nCsSpiExt2;
	--~ TP6 <= nCsExt_i;
	--~ TP6 <= ExtAddressLatched;	
	--~ TP6 <= ExtByteComplete;		
	--~ TP3 <= X0;
	--~ TP4 <= X3;
	--~ TP5 <= X2;
	--~ TP3 <= SckSpiExt;
	--~ TP4 <= MosiSpiExt;
	--~ TP5 <= MisoSpiExt;
	--~ TP6 <= nCsExt_i;
	--~ TP6 <= nCsSpiExt0 or nCsSpiExt1 or nCsSpiExt2; --used for debugging hub board...this is the exact function of it's chip select...
	--~ TP4 <= '1' when CurrentSRamAddr(6 downto 0) = "0101011" else '0'; --yes, you can have alot of 'fun' debugging SPI...
	--~ TP3 <= nMasterReset;
	--~ TP4 <= IspuC_i;
	--~ TP5 <= UsbConn;
	
	--~ TP3 <= MuxChannel(0);
	--~ TP4 <= MuxChannel(1);
	--~ TP5 <= MuxChannel(2);
	--~ TP6 <= MuxChannel(3);
	
	--~ TP3 <= MuxClk;
	--~ TP4 <= ResetMuxCounter;
	--~ TP5 <= SarAdcnDrdy;
	--~ TP6 <= MuxChannel(0);	
	
	--~ TP3 <= UartClk;
	
	--~ TP3 <= ArmSck; --SckSD;
	--~ TP4 <= ArmMosi; --MosiSD
	--~ TP5 <= MisoSD;
	--~ TP6 <= nCsSDuC; --nCsSD

	--~ TP3 <= SyncAdcRequest;
	--~ TP5 <= SyncAdc_i;
	--~ TP4 <= SyncCompleted;
	--~ TP6 <= PPS_i;
	--~ TP6 <= SarAdcMiso;
	
	--~ TP3 <= MasterClk;
	--~ TP5 <= SyncAdc_i;
	--~ TP4 <= SarAdcnDrdy;
	--~ TP6 <= SarAdcMiso;
	
	--Debug Arm control of A/D spi bus
	--~ TP3 <= nCsAdcuC;
	--~ TP4 <= Sck_i when nCsAdcuC = '0' else '0';
	--~ TP4 <= SarAdcSck; --readback from inout pin - seems to fubar things if used in actual operation, so debug only...
	--~ TP5 <= ArmMosi when nCsAdcuC = '0' else '0';
	--~ TP6 <= SarAdcMiso;
	
	--~ --Debug Fpga control of A/D spi bus
	--~ TP3 <= AdcSampleLatched;
	--~ TP4 <= SarAdcSck_i;
	--~ TP5 <= MosiAdc;
	--~ TP6 <= SarAdcMiso_i;
	
	--~ TP5 <= ReadAdcSample;
	--~ TP6 <= AdcSampleReadAck(0);
	--~ TP3 <= SarAdcnDrdy;
	--~ TP4 <= SarAdcSck;
	--~ TP5 <= MosiAdc;
	--~ TP6 <= SarAdcMiso;
	--~ TP6 <= SarAdcnDrdy;

	--~ TP3 <= SckSD;
	--~ TP4 <= MosiSD;
	--~ TP5 <= MisoSD;
	--~ TP6 <= nCsSD;
			
	--~ TP4 <= DcDcClk_i;
	--~ TP5 <= MasterClk;
	--~ TP5 <= AClkOutTxdPin;
	--~ TP4 <= ZigOutTxdPin;
	
	--~ ZRst2 <= AClkTxdArm when ( (AClkOutTxdFifoEmpty = '1') and (AClkOutTxdInProgress = '0') ) else AClkOutTxdPin;
	--~ FifoPZig <= FifoPZig_i when ( (ZigOutTxdFifoEmpty = '1') and (ZigOutTxdInProgress = '0') ) else ZigOutTxdPin;
	
	--~ TP4 <= RxduC1 when (UartMux = x"00") else '1';
	
	--~ TP3 <= SetZBusAddr;
	--~ TP4 <= ZBusAddrIsOutgoing;
	--~ TP5 <= ZBusAddrTxdPin;
	--~ TP6 <= ZBusAddrTxdPin when (ZBusAddrIsOutgoing = '1') else 'Z';
	--~ TP6 <= ZBusAddrTxdPin;
	
	--~ TP3 <= X0 when (SpiExtAddr = BoxMasterSpiExtAddr) else nCsExt_i;
	--~ TP4 <= SckSpiExt when (SpiExtAddr = BoxMasterSpiExtAddr) else SckExt_i;
	--~ TP5 <= MosiSpiExt when (SpiExtAddr = BoxMasterSpiExtAddr) else MosiExt_i;
	--~ TP6 <= ZBusAddrTxdPin when (SpiExtAddr = BoxMasterSpiExtAddr) else nCsSpiExt0;
	
	--~ TP4 <= X3;
	--~ TP5 <= X2;

	--~ ClkO <= MasterClk;

	--/debug

	--~ --here we do the general-purpose top-level clocked logic
	--~ process (MasterClk)
	--~ begin
		
		--~ if ( (MasterClk'event) and (MasterClk = '1') ) then
		
			--~ --Grab a timestamp when the ads1282 wants one...
			--~ if (AdcTimestampReq /= LastAdcTimestampReq) then
			
				--~ LastAdcTimestampReq <= AdcTimestampReq;
			
				--~ if (AdcTimestampReq = '1') then

					--~ --AdcTimestamp <= PPSCounter;
					
					--~ AdcTimestamp(9 downto 0) <= Milliseconds;
				
					--~ --Since the A/D sample trigger and the timestamp rollover are intended to be phase locked (occur at the same time), there is a nyquist-type race condition every second for the timestamp of whatever sample lies at this boundary. Here's how we make it deterministic:
					--~ --100MHz master clock counts PPS's; 100663296Hz / 8192Hz is 12282.003, so by definition, if we get a sample within that many PPS counts of the seconds rollover (100651013.997), it goes with the next second.
					--~ --Using a constant of 8192 would break if the ads1282 was overclocked to a 16kHz samplerate; I could have made the rollover window adaptive on the current sample rate (i.e. < 8192 or < 4096, ... or < 256), but since we're supposed to be phase locked to PPS, all the samples with (seconds - 1) from what we desire should be coming right near the rollover irrespective of sample rate, so the shortest window is defined by the max achievable sample rate, and should still provide ample room to correct this condition.

					--~ --if (PPSCounter < 100651014) then --(if we bugger the math below, try a constant by uncommenting this line)
					--~ --if (PPSCounter < 100663000) then --(if we bugger the math below, try a constant by uncommenting this line)
					--~ if ( (PPSDetected = '0') or ( PPSCounter < (BoardMasterClockFreq - (BoardMasterClockFreq / TwiceMaxConceviableSampleRate)) ) ) then
										
						--~ AdcTimestamp(31 downto 10) <= Seconds;
						
					--~ else
					
						--~ AdcTimestamp(31 downto 10) <= Seconds + 1;
						
					--~ end if;

					--~ --AdcTimestamp(31 downto 10) <= PPSCounter(31 downto 10); --debug: just cram the whole, exact count since the last PPS into the timestamp instead...
					
				--~ end if;
			
			--~ end if;
				
		--~ end if;

	--~ end process;
		
end MountainOperator;

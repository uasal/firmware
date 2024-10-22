--------------------------------------------------------------------------------
-- UA Extra-Solar Camera PZT Controller Project FPGA Firmware
--
-- FPGA Top-level Firmware
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity CGraphPZTPorts is
    port (	
			-- Arm uC Connections

				RamBusAddress : in std_logic_vector(9 downto 0); 
				--~ RamBusData : inout std_logic_vector(15 downto 0); --need an fpga with more pins to do it right
				RamBusData_in : inout std_logic_vector(7 downto 0); 
				RamBusData_out : out std_logic_vector(7 downto 0); 
				RamBusData_ena : out std_logic_vector(7 downto 0); 
				RamBusnCs : in std_logic_vector(1 downto 0); 
				RamBusWE : in std_logic;
				RamBusOE : in std_logic;
				
				--~ ArmnCs : in std_logic;
				--~ ArmSck : in std_logic;
				--~ ArmMosi : in std_logic;
				--~ ArmMiso : out std_logic;
								
			-- Clock / Sync / Gps Connections

				VCXO : in std_logic;
				--~ PpsIn : in std_logic; --pps is always an input, however...

				--~ nCsClk : out std_logic;
				--~ SckClk : out std_logic;
				--~ MosiClk : out std_logic;
				--~ MisoClk : in std_logic;
				
			-- PZT Setpoint D/A's

				SckDacs : out std_logic;
				MosiDacA : inout std_logic;
				MosiDacB : inout std_logic;
				MosiDacC : inout std_logic;
				--~ MisoDacA : in std_logic; --These pins only exist in AD5791 which we can't get, not in MAX5719 which we can get
				--~ MisoDacB : in std_logic;
				--~ MisoDacC : in std_logic;
				nCsDacA : out std_logic;
				nCsDacB : out std_logic;
				nCsDacC : out std_logic;
				nLDacs : out std_logic;
				nClrDacs : out std_logic;
				nRstDacs : out std_logic;
				
			-- PZT Strainguage Readback A/D's

				--~ SckAdcs : out std_logic;
				--~ MosiAdcA : out std_logic;
				--~ MosiAdcB : out std_logic;
				--~ MosiAdcC : out std_logic;
				--~ MisoAdcA : in std_logic;
				--~ MisoAdcB : in std_logic;
				--~ MisoAdcC : in std_logic;
				--~ nCsRstAdcA : out std_logic;
				--~ nCsRstAdcB : out std_logic;
				--~ nCsRstAdcC : out std_logic;
				--~ nDrdyAdcA : in std_logic;
				--~ nDrdyAdcB : in std_logic;
				--~ nDrdyAdcC : in std_logic;
				--~ TrigSyncAdcs : out std_logic;
				--~ CMuxPosAClkAdcs : out std_logic;
				--~ CMuxNegPwrDnAdcs : out std_logic;

			-- Power Supply Monitor A/D

				--~ nCsMonitorAdc : out std_logic;
				--~ SckMonitorAdcTP3 : out std_logic;
				--~ MosiMonitorAdcTP1 : out std_logic;
				--~ MisoMonitorAdc : in std_logic;
				--~ nDrdyMonitorAdcTP4 : in std_logic;
				
			-- LVDS

				--~ SckLvds : in std_logic;
				--~ MosiLvds : in std_logic;
				--~ MisoLvds : out std_logic;
				--~ RSckLvds : out std_logic;
				
			--  Discrete I/O Connections

				--High Voltage!
				HVPowernEn : out std_logic;
				nHVEn : out std_logic;
				--~ nHVFaultA : in std_logic;
				--~ nHVFaultB : in std_logic;
				--~ nHVFaultC : in std_logic;
				
				AnalogPowernEn : out std_logic--;
				--~ PowerSync : out std_logic;
				
				--~ UserJmpJstnCse : inout std_logic;
				
			-- Accelerometer / External SPI Connections
			
				--~ SckSpiExtInt2Accel : inout std_logic;
				--~ MosiSpiExtInt1Accel : inout std_logic;
				--~ MisoSpiExtSckAccel : inout std_logic;
				--~ nCsSpiExtDrdyAccel : inout std_logic;
				--~ OutClkSpiExtnCsAccel : inout std_logic;
				--~ InIntSpiExtMosiAccel : inout std_logic;
				--~ MisoAccel : inout std_logic--;
	);
end CGraphPZTPorts;

architecture CGraphPZT of CGraphPZTPorts is

	--attribute altera_attribute : string;
	--attribute altera_attribute of my_pin1: signal is "-name FAST_INPUT_REGISTER ON";	
	attribute chip_pin : string;	
	--~ attribute chip_pin of RamBusData    : signal is "P4, P2, R1, R2, T2, R3, T3, R4, T4, P5, R5, T5, P6, R6, T6, R7";
	--~ attribute chip_pin of RamBusAddress : signal is "B5, A5, B6, A6, B7, A7, A8, B9, B1, C1, B2, B3, C3, C4, C6, D9";
	attribute chip_pin of RamBusData    : signal is "P4, P2, R1, R2, T2, R3, T3, R4";
	attribute chip_pin of RamBusAddress : signal is "B5, A5, B6, A6, B7, A7, A8, B9, B1, C1";
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
	--~ attribute chip_pin of RamBusnCs : signal is "F12, F10, E10"; --in std_logic_vector(2 downto 0); 
	attribute chip_pin of RamBusnCs : signal is "F12, F10"; --in std_logic_vector(2 downto 0); 
	--attribute chip_pin of RamBusnCs(0) : signal is "E10"; --in std_logic_vector(2 downto 0); 
	--attribute chip_pin of RamBusnCs(1) : signal is "F10"; --in std_logic_vector(2 downto 0); 
	attribute chip_pin of RamBusWE : signal is "A3"; --in std_logic;
	attribute chip_pin of RamBusOE : signal is "C2"; --in std_logic;
	--~ attribute chip_pin of SyncDCDC : signal is "R8"; --out std_logic; -- 0.9-1.1MHz clk for switching powersupplies
	attribute chip_pin of VCXO : signal is "M3"; --in std_logic;
	--~ attribute chip_pin of PpsIn : signal is "K14"; --in std_logic; --pps is always an input, however...
	--~ attribute chip_pin of nCsClk : signal is "J6"; --out std_logic;
	--~ attribute chip_pin of SckClk : signal is "K6"; --out std_logic;
	--~ attribute chip_pin of MosiClk : signal is "P1"; --out std_logic;
	--~ attribute chip_pin of MisoClk : signal is "N2"; --in std_logic; -- reserved; not on hardware; we are looping back in sw
	--~ attribute chip_pin of LTAdcTrig : signal is "M15"; --out std_logic;
	--~ attribute chip_pin of LTAdcSck : signal is "N16"; --out std_logic;
	--~ attribute chip_pin of LTAPlliso : signal is "M14"; --in std_logic;
	--~ attribute chip_pin of LTAdcnCs : signal is "M16"; --out std_logic;
	--~ attribute chip_pin of LTAdcnDrdy : signal is "L16"; --in std_logic;
	--~ attribute chip_pin of SckSpiExt : signal is "R14"; --inout std_logic;
	--~ attribute chip_pin of MosiSpiExt : signal is "T14"; --inout std_logic;
	--~ attribute chip_pin of MisoSpiExt : signal is "P14"; --inout std_logic;
	--~ attribute chip_pin of nCsSpiExt0 : signal is "P10"; --inout std_logic;
	--~ attribute chip_pin of nCsSpiExt1 : signal is "R11"; --inout std_logic;
	--~ attribute chip_pin of nCsSpiExt2 : signal is "P11"; --inout std_logic;
	--~ attribute chip_pin of GpsRxdSpiExt : signal is "T12"; --inout std_logic;
	--~ attribute chip_pin of GpsPpsSpiExt : signal is "R10"; --inout std_logic;
	--~ attribute chip_pin of LedR : signal is "N4"; --out std_logic;
	--~ attribute chip_pin of LedG : signal is "N3"; --out std_logic;	
	--~ attribute chip_pin of TP3 : signal is "T13"; --out std_logic;
	--~ attribute chip_pin of TP4 : signal is "T7"; --out std_logic;
	--~ attribute chip_pin of TP5 : signal is "M1"; --out std_logic;
	--~ attribute chip_pin of TP6 : signal is "J1"; --out std_logic--;
	--~ attribute chip_pin of TP7 : signal is "R16"; --out std_logic;
	--~ attribute chip_pin of TP8 : signal is "A9"; --out std_logic--;	
				
	attribute chip_pin of SckDacs : signal is "K14"; --in std_logic; --pps is always an input, however...
	attribute chip_pin of MosiDacA : signal is "J6"; --out std_logic;
	attribute chip_pin of MosiDacB : signal is "K6"; --out std_logic;
	attribute chip_pin of MosiDacC : signal is "P1"; --out std_logic;
	--~ attribute chip_pin of MisoDacA : signal is "N2"; --in std_logic; -- reserved; not on hardware; we are looping back in sw
	--~ attribute chip_pin of MisoDacB : signal is "M15"; --out std_logic;
	--~ attribute chip_pin of MisoDacC : signal is "N16"; --out std_logic;
	attribute chip_pin of nCsDacA : signal is "M14"; --in std_logic;
	attribute chip_pin of nCsDacB : signal is "M16"; --out std_logic;
	attribute chip_pin of nCsDacC : signal is "L16"; --in std_logic;
	attribute chip_pin of nLDacs : signal is "R14"; --inout std_logic;
	attribute chip_pin of nClrDacs : signal is "T14"; --inout std_logic;
	attribute chip_pin of nRstDacs : signal is "P14"; --inout std_logic;
	attribute chip_pin of HVPowernEn : signal is "P10"; --inout std_logic;
	attribute chip_pin of nHVEn : signal is "R11"; --inout std_logic;
	attribute chip_pin of AnalogPowernEn : signal is "P11"; --inout std_logic;
	
	-- Component declarations - Boilerplate
				
						component IBufP1Ports is
						port (
							clk : in std_logic;
							I : in std_logic;
							O : out std_logic--;
						);
						end component;

						component IBufP2Ports is
						port (
							clk : in std_logic;
							I : in std_logic;
							O : out std_logic--;
						);
						end component;

						component IOBufP1Ports is
						port (
							clk : in std_logic;
							IO  : inout std_logic;
							T : in std_logic;
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
							BIT_WIDTH : natural := 32--;
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

						component RegisterSpacePorts is
						generic (
							ADDRESS_BITS : natural := 10--;
						);
						port (
											
							clk : in std_logic;
							rst : in std_logic;
							
							-- Bus:
							Address : in std_logic_vector(ADDRESS_BITS - 1 downto 0); -- vhdl can't figure out that ADDRESS_BITS is a constant because it's in a generic map...
							DataIn : in std_logic_vector(7 downto 0);
							DataOut : out std_logic_vector(7 downto 0);
							ReadReq : in  std_logic;
							WriteReq : in std_logic;
							ReadAck : out std_logic;
							WriteAck : out std_logic;
							
							--Data to access:			

							SerialNumber : in std_logic_vector(31 downto 0);
							BuildNumber : in std_logic_vector(31 downto 0);

							DacASetpoint : out std_logic_vector(23 downto 0);
							DacBSetpoint : out std_logic_vector(23 downto 0);
							DacCSetpoint : out std_logic_vector(23 downto 0);
							WriteDacs : out std_logic;
							DacAReadback : in std_logic_vector(23 downto 0);
							DacBReadback : in std_logic_vector(23 downto 0);
							DacCReadback : in std_logic_vector(23 downto 0)--;							
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
							BuildNumber : out std_logic_vector(31 downto 0)--;
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
							MASTER_CLOCK_FREQHZ : natural := 100000000;
							BIT_WIDTH : natural := 24--;
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
							DacWriteOut : in std_logic_vector(BIT_WIDTH - 1 downto 0);
							WriteDac : in std_logic;
							DacReadback : out std_logic_vector(BIT_WIDTH - 1 downto 0)--;
								
						); end component;

						component SpiDacTrioPorts is
						generic (
							MASTER_CLOCK_FREQHZ : natural := 100000000--;
						);
						port (
						
							--Globals
							clk : in std_logic;
							rst : in std_logic;
							
							-- D/A:
							nCsA : out std_logic;
							nCsB : out std_logic;
							nCsC : out std_logic;
							Sck : out std_logic;
							MosiA : out  std_logic;
							MosiB : out  std_logic;
							MosiC : out  std_logic;
							MisoA : in  std_logic;
							MisoB : in  std_logic;
							MisoC : in  std_logic;
							
							--Control signals
							WriteDac : in std_logic;
							DacWriteOutA : in std_logic_vector(23 downto 0);
							DacWriteOutB : in std_logic_vector(23 downto 0);
							DacWriteOutC : in std_logic_vector(23 downto 0);
							DacReadbackA : out std_logic_vector(23 downto 0);
							DacReadbackB : out std_logic_vector(23 downto 0);
							DacReadbackC : out std_logic_vector(23 downto 0)--;
								
						); end component;

	--Signals /  Local variables
		
		--Note on variable names ending in '_i': these are generally used to syncronize asynchronous signals with internal clocked logic, 
		-- to merge (and, or, etc) two inputs into one control signal, or so that we can read-back a value sent to an output-only pin.
							
		--Clocks
		
			constant BaseClockFreq : natural := 49152000; --49MHz
			constant ClockFreqMultiplier : natural := 2;
			constant BaseClockPeriod : real := 20.345; --really should be exactly 1 / conv_real(BaseClockFreq), but it's just used by Pll clock library, and conv_real doesn't exist.
			constant BoardMasterClockFreq : natural := BaseClockFreq * ClockFreqMultiplier; 
			signal MasterClk : std_logic; --This is the main clock for *everything*
			--~ signal DcDcClk_i : std_logic; --1Mhz clock for the switching power supplies
			--~ signal DcDcClkDiv : std_logic; --temp to generate DC/DC clock from A/D clock

		--FPGA internal
		
			signal MasterReset : std_logic; --Our power-on-reset signal for everything
			signal SerialNumber : std_logic_vector(31 downto 0); --This is a xilinx proprietary toy that we use as the serial number, it's supposed to be unique on each board
			signal BuildNumber : std_logic_vector(31 downto 0); --How many attempts got us to this particular version of the firmware?
		
		-- Ram bus
						
			signal RamBusOE_i : std_logic;		
			signal RamBusCE_i : std_logic;		
			signal RamBusWE_i : std_logic;		
			signal RamBusAddress_i : std_logic_vector(9 downto 0);		
			signal nTristateRamDataPins : std_logic;		
			signal RamDataOut : std_logic_vector(7 downto 0);		
			signal RamDataIn : std_logic_vector(7 downto 0);		
			
		-- Register space
		
			signal DataToWrite : std_logic_vector(7 downto 0);
			signal WriteReq : std_logic;
			signal WriteAck : std_logic;
			signal DataFromRead : std_logic_vector(7 downto 0);
			signal ReadReq : std_logic;
			signal ReadAck : std_logic;

		--PZT D/As
			
			signal nCsDacA_i : std_logic;	
			signal nCsDacB_i : std_logic;	
			signal nCsDacC_i : std_logic;	
			signal SckDacs_i : std_logic;	
			signal MosiDacA_i : std_logic;	
			signal MosiDacB_i : std_logic;	
			signal MosiDacC_i : std_logic;	
			signal MisoDacA_i : std_logic;	
			signal MisoDacB_i : std_logic;	
			signal MisoDacC_i : std_logic;	
			signal DacASetpoint : std_logic_vector(23 downto 0);	
			signal DacBSetpoint : std_logic_vector(23 downto 0);	
			signal DacCSetpoint : std_logic_vector(23 downto 0);	
			signal WriteDacs : std_logic;	
			signal DacAReadback : std_logic_vector(23 downto 0);	
			signal DacBReadback : std_logic_vector(23 downto 0);	
			signal DacCReadback : std_logic_vector(23 downto 0);	
			signal nLDacs_i : std_logic;	
				
begin

	------------------------------PORTMAPS - map all library functions/logic to our specific local variables/signals----------------------------------
	
	MasterPll : ClockMultiplierPorts
	generic map (
		CLOCK_DIVIDER => 1,
		CLOCK_MULTIPLIER => ClockFreqMultiplier,
		CLOCK_FREQ_KHZ => 49152.0--,		
	)
	PORT MAP (
		rst => '0',
		clkin => VCXO,
		clkout => MasterClk,
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
		rst => MasterReset,
		DnaRegister => SerialNumber--,
	);

	BuildNumber_i : BuildNumberPorts
	port map
	(
		BuildNumber => BuildNumber--;
	);
	
	BootupReset : OneShotPorts
	generic map (
		CLOCK_FREQHZ => BoardMasterClockFreq,
		DELAY_SECONDS => 0.000010,
		SHOT_RST_STATE => '1',
		SHOT_PRETRIGGER_STATE => '1'--,
	)
	port map 
	(	
		clk => MasterClk,
		rst => '0',
		shot => MasterReset
	);

	------------------------------------------ RegisterSpaces ---------------------------------------------------

	--Just sync external SPI clock to master clock
	IBufOE : IBufP1Ports
	port map
	(
		clk => MasterClk,
		I => RamBusOE,
		O => RamBusOE_i--,
	);
	
	--Just sync external SPI clock to master clock
	IBufCE : IBufP1Ports
	port map
	(
		clk => MasterClk,
		I => RamBusnCs(0),
		O => RamBusCE_i--,
	);

	--Just sync external SPI serial data input to master clock
	IBufWE : IBufP1Ports
	port map
	(
		clk => MasterClk,
		I => RamBusWE,
		O => RamBusWE_i--,
	);

	GenRamAddrBus: for i in 0 to 9 generate
	begin
	IBUF_RamAddr_i : IBufP1Ports
	port map (
		clk => MasterClk,
		I => RamBusAddress(i),
		O => RamBusAddress_i(i)--,
	); 
	end generate;
	
	GenRamDataBus: for i in 0 to 7 generate
	begin
	IOBUF_RamData_i : IOBufP1Ports
	port map (
		clk => MasterClk,
		IO => RamBusData(i),
		T => not(nTristateRamDataPins),
		I => RamDataOut(i),
		O => RamDataIn(i)--,
	);
	end generate;
		
	--devmem2 0x021B8010 w 0x3F000FE0 for max wait states on arm, write is taking 400ns / word, 1us / 32b
	DataToWrite <= RamDataIn;
	WriteReq <= '1' when ( (RamBusCE_i = '0') and (RamBusWE_i = '0') ) else '0';
	
	--devmem2 0x021B8008 w 0x3F000707 for max wait states on arm, read is taking 400ns / word, 1us / 32b
	RamDataOut <= DataFromRead;
	ReadReq  <= '1' when ( (RamBusCE_i = '0') and (RamBusOE_i = '0') ) else '0';
	nTristateRamDataPins <= '1' when ( (RamBusCE_i = '0') and (RamBusOE_i = '0') ) else '0';

	
	------------------------------------------ RegisterSpace ---------------------------------------------------

	--Mapping between bus transactions and specific registers - see RegisterSpace.vhd for adresses
	RegisterSpace : RegisterSpacePorts
	generic map 
	(
		ADDRESS_BITS => 10--,
	)
	port map
	(
		clk => MasterClk,
		rst => MasterReset,

		Address => RamBusAddress_i,
		DataIn => DataToWrite,
		DataOut => DataFromRead,
		ReadReq => ReadReq,
		WriteReq => WriteReq,
		ReadAck => ReadAck,
		WriteAck => WriteAck,
		
		--Data to access:			
		SerialNumber => SerialNumber,
		BuildNumber => BuildNumber,
		
		DacASetpoint => DacASetpoint,
		DacBSetpoint => DacBSetpoint,
		DacCSetpoint => DacCSetpoint,
		WriteDacs => WriteDacs,
		DacAReadback => DacAReadback,
		DacBReadback => DacBReadback,
		DacCReadback => DacCReadback--,
	);
	
	
	------------------------------------------ PZT D/A's ---------------------------------------------------
	
	IBufPZTDacMisoA : IBufP2Ports
	port map
	(
		clk => MasterClk,
		--~ I => MisoDacA, --No Miso on MAX5719
		I => MosiDacA, --But we can loopback to make sure signal isn't shorted anywhere!
		O => MisoDacA_i--,
	);
	IBufPZTDacMisoB : IBufP2Ports
	port map
	(
		clk => MasterClk,
		--~ I => MisoDacB, --No Miso on MAX5719
		I => MosiDacB, --But we can loopback to make sure signal isn't shorted anywhere!
		O => MisoDacB_i--,
	);
	IBufPZTDacMisoC : IBufP2Ports
	port map
	(
		clk => MasterClk,
		--~ I => MisoDacC, --No Miso on MAX5719
		I => MosiDacC, --But we can loopback to make sure signal isn't shorted anywhere!
		O => MisoDacC_i--,
	);

	PZTDacs_i : SpiDacTrioPorts
	generic map 
	(
		MASTER_CLOCK_FREQHZ => BoardMasterClockFreq--,
	)
	port map 
	(
		clk => MasterClk,
		rst => MasterReset,
		nCsA => nCsDacA_i,
		nCsB => nCsDacB_i,
		nCsC => nCsDacC_i,
		Sck => SckDacs_i,
		MosiA => MosiDacA_i,
		MosiB => MosiDacB_i,
		MosiC => MosiDacC_i,
		MisoA => MisoDacA_i,
		MisoB => MisoDacB_i,
		MisoC => MisoDacC_i,
		WriteDac => WriteDacs,
		DacWriteOutA => DacASetpoint,
		DacWriteOutB => DacBSetpoint,
		DacWriteOutC => DacCSetpoint,
		DacReadbackA => DacAReadback,
		DacReadbackB => DacBReadback,
		DacReadbackC => DacCReadback
	);

	nCsDacA <= nCsDacA_i;
	nCsDacB <= nCsDacB_i;
	nCsDacC <= nCsDacC_i;
	SckDacs <= SckDacs_i;
	MosiDacA <= MosiDacA_i;
	MosiDacB <= MosiDacB_i;
	MosiDacC <= MosiDacC_i;

	--~ nLDacs <= not(nCsDacA_i);
	--not(nCs) prolly works, but this is more technically correct:
	nLDacsOneShot : OneShotPorts
	generic map (
		CLOCK_FREQHZ => BoardMasterClockFreq,
		DELAY_SECONDS => 0.000000025, --25ns
		SHOT_RST_STATE => '1',
		SHOT_PRETRIGGER_STATE => '1' --This is gonna hold nLDac low until the next SPI cycle, which doesn't look like the pic in the datasheet, but it doesn't say we can't, since the falling edge is what matters...ideally we'd toggle it back on the Rising edge of WriteDac at the very beginning, but we can sort the brass tacks later...
	)
	port map (	
		clk => MasterClk,
		rst => not(nCsDacA_i),
		shot => nLDacs_i
	);

	nLDacs <= nLDacs_i;
	nClrDacs <= '0';
	nRstDacs <= not(MasterReset);

	----------------------------- Power Supplies ----------------------------------
	
	HVPowernEn <= '0';
	nHVEn <= '0';
	AnalogPowernEn <= '0';
				
	-----------------------------Debug----------------------------------
	
	--Debug RAM bus:
	--~ TP1 <= RamBusOE_i;
	--~ TP2 <= RamBusWE_i;
	--~ TP3 <= nTristateRamDataPins;
	--~ TP4 <= DataWriteAck;
	--~ TP1 <= DataReadAck;
	--~ TP2 <= RamBusAddress(0);
	--~ TP3 <= RamBusAddress(1);
	--~ TP4 <= nTristateRamDataPins;
	
	--~ ClkO <= MasterClk;

	--/debug

	--~ --here we do the general-purpose top-level clocked logic
	--~ process (MasterClk)
	--~ begin
		
		--~ if ( (MasterClk'event) and (MasterClk = '1') ) then
			
		--~ end if;

	--~ end process;
		
end CGraphPZT;

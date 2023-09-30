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
library work;
use work.ltc244xaccumulator_types.all;

entity CGraphPZTPorts is
    port (	
			-- Arm uC Connections

				RamBusAddress : in std_logic_vector(9 downto 0); 
				--~ RamBusData : inout std_logic_vector(15 downto 0); --need an fpga with more pins to do it right
				RamBusData_in : in std_logic_vector(7 downto 0); 
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

				--VCXO : in std_logic; --Currently handled by the stupid efinix interface designer
                pll0O : in std_logic; --Main clock; 96MHz
				pll1O : in std_logic; --Uart clock; 192MHz
				
				PpsIn : in std_logic; --pps is always an input, however...

				nCsClk : out std_logic;
				SckClk : out std_logic;
				MosiClk : out std_logic;
				MisoClk : in std_logic;
				
			-- PZT Setpoint D/A's

				SckDacs : out std_logic;
				MosiDacA_in : in std_logic;
				MosiDacB_in : in std_logic;
				MosiDacC_in : in std_logic;
				MosiDacA_out : out std_logic;
				MosiDacB_out : out std_logic;
				MosiDacC_out : out std_logic;
				MosiDacA_ena : out std_logic;
				MosiDacB_ena : out std_logic;
				MosiDacC_ena : out std_logic;
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

				SckAdcs : out std_logic;
				MosiAdcA : out std_logic;
				MosiAdcB : out std_logic;
				MosiAdcC : out std_logic;
				MisoAdcA : in std_logic;
				MisoAdcB : in std_logic;
				MisoAdcC : in std_logic;
				nCsRstAdcA : out std_logic;
				nCsRstAdcB : out std_logic;
				nCsRstAdcC : out std_logic;
				nDrdyAdcA : in std_logic;
				nDrdyAdcB : in std_logic;
				nDrdyAdcC : in std_logic;
				TrigSyncAdcs : out std_logic;
				CMuxPosAClkAdcs : out std_logic;
				CMuxNegPwrDnAdcs : out std_logic;

			-- Power Supply Monitor A/D

				nCsMonitorAdc : out std_logic;
				SckMonitorAdcTP3 : out std_logic;
				MosiMonitorAdcTP1 : out std_logic;
				MisoMonitorAdcTP2 : in std_logic; --use the A/D
				nDrdyMonitorAdcTP4 : in std_logic; --use the A/D
				--~ MisoMonitorAdcTP2 : out std_logic; --steal the pin for a testpoint
				--~ nDrdyMonitorAdcTP4 : out std_logic; --steal the pin for a testpoint
				
			-- LVDS

				--~ SckLvds : in std_logic;
				--~ MosiLvds : in std_logic;
				--~ MisoLvds : out std_logic;
				--~ RSckLvds : out std_logic;
				--How about a shit-ton of testpoints while we ain't using these?
				TP1 : out std_logic; --Sck+
				TP2 : out std_logic; --Mosi+
				TP3 : out std_logic; --Miso+
				TP4 : out std_logic; --RSck+
				TP5 : out std_logic; --Sck-
				TP6 : out std_logic; --Mosi-
				TP7 : out std_logic; --Miso-
				TP8 : out std_logic; --RSck-
				
			--RS-422 (uses LVDS and/or Accel pins)

				Txd0 : out std_logic;
				Rxd0 : in std_logic;
				Txd1 : out std_logic;
				Rxd1 : in std_logic;
				Txd2 : out std_logic;
				Rxd2 : in std_logic;
				--~ Txd3 : out std_logic;
				--~ Rxd3 : in std_logic;
			
			--  Discrete I/O Connections
			
				--High Voltage!
				HVPowernEn : out std_logic;
				nHVEn : out std_logic;
				--~ nHVFaultA : in std_logic;
				--~ nHVFaultB : in std_logic;
				--~ nHVFaultC : in std_logic;
				
				AnalogPowernEn : out std_logic;
				PowerSync : out std_logic;
				
				--UserJmpJstnCse : inout std_logic--;
                UserJmpJstnCse : out std_logic--;
				
			-- Accelerometer / External SPI Connections
			
				--~ SckSpiExtInt2Accel : out std_logic;
				--~ MosiSpiExtInt1Accel : out std_logic;
				--~ MisoSpiExtSckAccel : out std_logic;
				--~ nCsSpiExtDrdyAccel : out std_logic;
				--~ OutClkSpiExtnCsAccel : out std_logic;
				--~ InIntSpiExtMosiAccel : out std_logic;
				--~ MisoAccel : out std_logic--;
	);
end CGraphPZTPorts;

architecture CGraphPZT of CGraphPZTPorts is

	--attribute altera_attribute : string;
	--attribute altera_attribute of my_pin1: signal is "-name FAST_INPUT_REGISTER ON";	
	--~ attribute chip_pin : string;	
	--~ attribute chip_pin of RamBusData    : signal is "P4, P2, R1, R2, T2, R3, T3, R4, T4, P5, R5, T5, P6, R6, T6, R7";
	--~ attribute chip_pin of RamBusAddress : signal is "B5, A5, B6, A6, B7, A7, A8, B9, B1, C1, B2, B3, C3, C4, C6, D9";
	--~ attribute chip_pin of RamBusData    : signal is "P4, P2, R1, R2, T2, R3, T3, R4";
	--~ attribute chip_pin of RamBusAddress : signal is "B5, A5, B6, A6, B7, A7, A8, B9, B1, C1";
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
	--~ attribute chip_pin of RamBusnCs : signal is "F12, F10"; --in std_logic_vector(2 downto 0); 
	--attribute chip_pin of RamBusnCs(0) : signal is "E10"; --in std_logic_vector(2 downto 0); 
	--attribute chip_pin of RamBusnCs(1) : signal is "F10"; --in std_logic_vector(2 downto 0); 
	--~ attribute chip_pin of RamBusWE : signal is "A3"; --in std_logic;
	--~ attribute chip_pin of RamBusOE : signal is "C2"; --in std_logic;
	--~ attribute chip_pin of SyncDCDC : signal is "R8"; --out std_logic; -- 0.9-1.1MHz clk for switching powersupplies
	--~ attribute chip_pin of VCXO : signal is "M3"; --in std_logic;
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
				
	--~ attribute chip_pin of SckDacs : signal is "K14"; --in std_logic; --pps is always an input, however...
	--~ attribute chip_pin of MosiDacA : signal is "J6"; --out std_logic;
	--~ attribute chip_pin of MosiDacB : signal is "K6"; --out std_logic;
	--~ attribute chip_pin of MosiDacC : signal is "P1"; --out std_logic;
	--~ attribute chip_pin of MisoDacA : signal is "N2"; --in std_logic; -- reserved; not on hardware; we are looping back in sw
	--~ attribute chip_pin of MisoDacB : signal is "M15"; --out std_logic;
	--~ attribute chip_pin of MisoDacC : signal is "N16"; --out std_logic;
	--~ attribute chip_pin of nCsDacA : signal is "M14"; --in std_logic;
	--~ attribute chip_pin of nCsDacB : signal is "M16"; --out std_logic;
	--~ attribute chip_pin of nCsDacC : signal is "L16"; --in std_logic;
	--~ attribute chip_pin of nLDacs : signal is "R14"; --inout std_logic;
	--~ attribute chip_pin of nClrDacs : signal is "T14"; --inout std_logic;
	--~ attribute chip_pin of nRstDacs : signal is "P14"; --inout std_logic;
	--~ attribute chip_pin of HVPowernEn : signal is "P10"; --inout std_logic;
	--~ attribute chip_pin of nHVEn : signal is "R11"; --inout std_logic;
	--~ attribute chip_pin of AnalogPowernEn : signal is "P11"; --inout std_logic;
	
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
						
						component IBufP3Ports is
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
						
						component IOBufP3Ports is
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
							rst_count : in std_logic_vector(WIDTH_BITS - 1 downto 0);
							terminal_count : in std_logic_vector(WIDTH_BITS - 1 downto 0);
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
							UartClk : out std_logic; --debug
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
							Dbg1 : out std_logic; 
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
						
						component UartRxFifoExtClk is
						generic 
						(
							FIFO_BITS : natural := 10--;
						);
						port 
						(
							--Outside world:
							clk : in std_logic;
							uclk : in std_logic;
							rst : in std_logic;
							--External (async) uart data input pin
							Rxd : in std_logic; 
							Dbg1 : out std_logic; 
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
						
						component UartRxMultiFifo is
						generic 
						(
							FIFO_BITS : natural := 10;
							BAUD_DIVIDER_BITS : natural := 8--;
						);
						port 
						(
							--Outside world:
							clk : in std_logic;
							uclk : in std_logic;
							rst : in std_logic;
							BaudDivider : in std_logic_vector(BAUD_DIVIDER_BITS - 1 downto 0); --sets baud rate
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
						
						component UartTx is
						port 
						(
							Clk    : in  Std_Logic;
							Reset  : in  Std_Logic;
							Go     : in  Std_Logic; --To initate a xfer, raise this bit and wait for busy to go high, then lower.
							TxD    : out Std_Logic;
							Busy   : out Std_Logic;
							Data  : in  Std_Logic_Vector(7 downto 0)--; --not latched; must be held constant while busy is high
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
							BitClockOut : out std_logic; --generally used for debug of divider values...		
							
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
						
						component UartTxFifoExtClk is
						generic 
						(
							FIFO_BITS : natural := 10--;
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
							BitClockOut : out std_logic; --generally used for debug of divider values...		
							
							--'analog' side (frontyard)
							TxInProgress : out std_logic; --currently sending data...
							Cts : in std_logic; --Are the folks on the other end actually ready for data if we have some? (Just tie it to zero if unused).
							Txd : out std_logic--; --Uart data output pin (i.e. to RS-232 driver chip)
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
							Address : in std_logic_vector(ADDRESS_BITS - 1 downto 0); -- this is fucked, but vhdl can't figure out that ADDRESS_BITS is a constant because it's in a generic map...
							DataIn : in std_logic_vector(7 downto 0);
							DataOut : out std_logic_vector(7 downto 0);
							ReadReq : in  std_logic;
							WriteReq : in std_logic;
							ReadAck : out std_logic;
							WriteAck : out std_logic;
							
							--Data to access:			

							--Infrastructure
							SerialNumber : in std_logic_vector(31 downto 0);
							BuildNumber : in std_logic_vector(31 downto 0);

							--PZT D/A's
							DacASetpoint : out std_logic_vector(23 downto 0);
							DacBSetpoint : out std_logic_vector(23 downto 0);
							DacCSetpoint : out std_logic_vector(23 downto 0);
							WriteDacs : out std_logic;
							DacAReadback : in std_logic_vector(23 downto 0);
							DacBReadback : in std_logic_vector(23 downto 0);
							DacCReadback : in std_logic_vector(23 downto 0);	
							DacTransferComplete : in std_logic;

							-- PZT Readback A/Ds
							ReadAdcSample : out std_logic;
							AdcSampleToReadA : in std_logic_vector(47 downto 0);	
							AdcSampleToReadB : in std_logic_vector(47 downto 0);	
							AdcSampleToReadC : in std_logic_vector(47 downto 0);	
							AdcSampleNumAccums : in std_logic_vector(15 downto 0);	
														
							--Monitor A/D:
							MonitorAdcChannelReadIndex : out std_logic_vector(4 downto 0);
							ReadMonitorAdcSample : out std_logic;
							MonitorAdcSampleToRead : in std_logic_vector(63 downto 0);
							
							--RS-422
							Uart0FifoReset : out std_logic;
							ReadUart0 : out std_logic;
							Uart0RxFifoFull : in std_logic;
							Uart0RxFifoEmpty : in std_logic;
							Uart0RxFifoData : in std_logic_vector(7 downto 0);
							Uart0RxFifoCount : in std_logic_vector(9 downto 0);
							WriteUart0 : out std_logic;
							Uart0TxFifoFull : in std_logic;
							Uart0TxFifoEmpty : in std_logic;
							Uart0TxFifoData : out std_logic_vector(7 downto 0);
							Uart0TxFifoCount : in std_logic_vector(9 downto 0);
							Uart0ClkDivider : out std_logic_vector(7 downto 0);
							
							Uart1FifoReset : out std_logic;
							ReadUart1 : out std_logic;
							Uart1RxFifoFull : in std_logic;
							Uart1RxFifoEmpty : in std_logic;
							Uart1RxFifoData : in std_logic_vector(7 downto 0);
							Uart1RxFifoCount : in std_logic_vector(9 downto 0);
							WriteUart1 : out std_logic;
							Uart1TxFifoFull : in std_logic;
							Uart1TxFifoEmpty : in std_logic;
							Uart1TxFifoData : out std_logic_vector(7 downto 0);
							Uart1TxFifoCount : in std_logic_vector(9 downto 0);
							Uart1ClkDivider : out std_logic_vector(7 downto 0);
							
							Uart2FifoReset : out std_logic;
							ReadUart2 : out std_logic;
							Uart2RxFifoFull : in std_logic;
							Uart2RxFifoEmpty : in std_logic;
							Uart2RxFifoData : in std_logic_vector(7 downto 0);
							Uart2RxFifoCount : in std_logic_vector(9 downto 0);
							WriteUart2 : out std_logic;
							Uart2TxFifoFull : in std_logic;
							Uart2TxFifoEmpty : in std_logic;
							Uart2TxFifoData : out std_logic_vector(7 downto 0);
							Uart2TxFifoCount : in std_logic_vector(9 downto 0);
							Uart2ClkDivider : out std_logic_vector(7 downto 0);

							--Timing
							IdealTicksPerSecond : in std_logic_vector(31 downto 0);
							ActualTicksLastSecond : in std_logic_vector(31 downto 0);
							ClockTicksThisSecond : in std_logic_vector(31 downto 0);
							PPSCountReset : out std_logic;		
							ClkDacWrite : out std_logic_vector(15 downto 0);
							WriteClkDac : out std_logic;
							ClkDacReadback : in std_logic_vector(15 downto 0)--;
						);
						end component;
						
						component Ltc2378AccumTrioPorts is
						port (
						
							--Globals
							clk : in std_logic;
							rst : in std_logic;
							
							-- A/D:
							Trigger : out std_logic; --rising edge initiates a conversion; 20ns min per hi/lo, so 
							nDrdyA : in std_logic; --Falling edge indicates a new sample is ready, should be approx 1usec after trigger goes high (1MHz)
							nDrdyB : in std_logic; --Falling edge indicates a new sample is ready, should be approx 1usec after trigger goes high (1MHz)
							nDrdyC : in std_logic; --Falling edge indicates a new sample is ready, should be approx 1usec after trigger goes high (1MHz)
							nCsA : out std_logic; -- 18th bit (msb) of data valid on falling edge.
							nCsB : out std_logic; -- 18th bit (msb) of data valid on falling edge.
							nCsC : out std_logic; -- 18th bit (msb) of data valid on falling edge.
							Sck : out std_logic; --can run up to ~100MHz (">40MHz??); idle in low state
							MisoA : in  std_logic; --valid 16nsec after nCs low; shifts on rising edge of sck, sample when sck low.		
							MisoB : in  std_logic; --valid 16nsec after nCs low; shifts on rising edge of sck, sample when sck low.		
							MisoC : in  std_logic; --valid 16nsec after nCs low; shifts on rising edge of sck, sample when sck low.		
							OverRangeA : out std_logic; --is the A/D saturated?
							OverRangeB : out std_logic; --is the A/D saturated?
							OverRangeC : out std_logic; --is the A/D saturated?
						
							--Control signals
							AdcPowerDown : in std_logic; --self-explanatory...
							AdcClkDivider : in std_logic_vector(15 downto 0); --This knob controls the acquisition speed of the A/D.
							SamplesToAverage : in std_logic_vector(15 downto 0); --Only supported on LTC2380-24 hardware! This also controls the acquisition speed of the A/D; each 4x averaging gives an extra bit of SNR or 6dB.
							ChopperEnable : in std_logic; --turns chopper on/off to reduce 1/f noise and offset!
							ChopperMuxPos : out std_logic; --switches inputs when chopper on to reduce 1/f noise and offset!
							ChopperMuxNeg : out std_logic; --switches inputs when chopper on to reduce 1/f noise and offset!
						
							--Bus interface
							ReadAdcSample : in std_logic;		
							AdcSampleToReadA : out std_logic_vector(47 downto 0);		
							AdcSampleToReadB : out std_logic_vector(47 downto 0);		
							AdcSampleToReadC : out std_logic_vector(47 downto 0);	
							AdcSampleNumAccums : out std_logic_vector(15 downto 0);
							
							--Debug
							TP1 : out std_logic;
							TP2 : out std_logic;
							TP3 : out std_logic;
							TP4 : out std_logic--;
						); 
						end component;
						
						component ltc244xaccumulatorPorts is
						generic 
						(
							MASTER_CLOCK_FREQHZ : natural := 10000000;
							LTC244X_DATARATE : std_logic_vector(3 downto 0) := "1111";
							LTC244X_DOUBLERATE : std_logic := '0'--;
						);
						port 
						(
							clk : in std_logic;
							rst : in std_logic;
							
							-- To A/D
							nDrdy : in  std_logic; --Falling edge indicates new data
							nCs : out std_logic; --Falling edge initiates a new conversion
							Sck : out std_logic; --can run up to 20MHz
							Mosi : out std_logic; --10nsec setup time
							Miso : in  std_logic; --valid after 25nsec, 15nsec hold time

							InvalidStateReached : out std_logic;
							Dbg1 : out std_logic;
							Dbg2 : out std_logic;
							
							-- To Datamapper
							AdcChannelReadIndex : in std_logic_vector(4 downto 0);
							ReadAdcSample : in std_logic;		
							AdcSampleToRead : out ltc244xaccumulator--;
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
							DacReadbackC : out std_logic_vector(23 downto 0);
							TransferComplete : out std_logic--;
							
						); end component;

	--Signals /  Local variables
		
		--Note on variable names ending in '_i': these are generally used to syncronize asynchronous signals with internal clocked logic, 
		-- to merge (and, or, etc) two inputs into one control signal, or so that we can read-back a value sent to an output-only pin.
							
		--Clocks
		
			--~ constant BaseClockFreq : natural := 49152000; --49MHz
			--~ constant ClockFreqMultiplier : natural := 3;
			--~ constant ClockFreqMultiplier : natural := 125;
			--~ constant ClockFreqDivider : natural := 64;
			--~ constant BaseClockPeriod : real := 20.345; --really should be exactly 1 / conv_real(BaseClockFreq), but it's just used by Pll clock library, and conv_real doesn't exist.
			--~ constant BoardMasterClockFreq : natural := BaseClockFreq * ClockFreqMultiplier; 
			--~ constant BoardMasterClockFreq : natural := BaseClockFreq * ClockFreqMultiplier / ClockFreqDivider;
			--~ constant BoardMasterClockFreq : natural := 139719000;
			--~ constant BoardMasterClockFreq : natural := 95996094; --95996093.75 --old 49.150 clock
			--~ constant BoardMasterClockFreq : natural := 99609375; --99609375.0 --51.0 clock
			constant BoardMasterClockFreq : natural := 102000000; -- --102.0 clock
			constant BoardUartClockFreq : natural := 136000000;
			--~ constant BoardMasterClockFreq : natural := 153000000; -- --102.0 clock
			signal MasterClk : std_logic; --This is the main clock for *everything*
			signal UartClk : std_logic; --This is the uart clock, it runs at 136MHz, and a lot of the regular logic won't run that fast, which is why we have a seperate clock. In practice, it immediately gets divided by 16 ny the uarts so it actually is slower than the other logic, but at a weird ratio...
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

		-- PZT D/As
			
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
			signal DacTransferComplete : std_logic;	
			
			
		-- PZT Readback A/Ds
			
			signal TrigSyncAdcs_i : std_logic;	
			signal nDrdyAdcA_i : std_logic;	
			signal nDrdyAdcB_i : std_logic;	
			signal nDrdyAdcC_i : std_logic;	
			signal SckAdcs_i : std_logic;	
			signal MisoAdcA_i : std_logic;	
			signal MisoAdcB_i : std_logic;	
			signal MisoAdcC_i : std_logic;	
			signal nCsRstAdcA_i : std_logic;	
			signal nCsRstAdcB_i : std_logic;	
			signal nCsRstAdcC_i : std_logic;	
			signal ReadAdcSample : std_logic;
			signal AdcSampleToReadA : std_logic_vector(47 downto 0);	
			signal AdcSampleToReadB : std_logic_vector(47 downto 0);	
			signal AdcSampleToReadC : std_logic_vector(47 downto 0);	
			signal AdcSampleNumAccums : std_logic_vector(15 downto 0);	
			
		--Monitor A/D
		
			signal nDrdyMonitorAdc_i : std_logic;
			signal nCsMonitorAdc_i : std_logic;
			signal SckMonitorAdc_i : std_logic;
			signal MosiMonitorAdc_i : std_logic;
			signal MisoMonitorAdc_i : std_logic;
			signal MonitorAdcChannel : std_logic_vector(4 downto 0);
			signal MonitorAdcReadSample : std_logic;
			signal MonitorAdcSample : ltc244xaccumulator;
			
		--RS-422
		
			--~ signal Uart1Data : std_logic_vector(7 downto 0);
			--~ signal Uart1RxComplete : std_logic;
			--~ signal Uart1Clkx16 : std_logic;
			--~ signal Uart1Clk : std_logic;
			signal Uart0FifoReset : std_logic;
			signal Uart0FifoReset_i : std_logic;
			signal ReadUart0 : std_logic;
			signal Uart0RxFifoFull : std_logic;
			signal Uart0RxFifoEmpty : std_logic;
			signal Uart0RxFifoReadAck : std_logic;
			signal Uart0RxFifoData : std_logic_vector(7 downto 0);
			signal Uart0RxFifoCount : std_logic_vector(9 downto 0);
			signal WriteUart0 : std_logic;
			signal Uart0TxFifoFull : std_logic;
			signal Uart0TxFifoEmpty : std_logic;
			signal Uart0TxFifoData : std_logic_vector(7 downto 0);
			signal Uart0TxFifoCount : std_logic_vector(9 downto 0);
			signal Uart0ClkDivider : std_logic_vector(7 downto 0);
			signal UartClk0 : std_logic;			
			signal UartTxClk0 : std_logic;			
			signal Txd0_i : std_logic;
			signal Rxd0_i : std_logic;
			signal UartRx0Dbg : std_logic;						
			signal Uart1FifoReset : std_logic;
			signal Uart1FifoReset_i : std_logic;
			signal ReadUart1 : std_logic;
			signal Uart1RxFifoFull : std_logic;
			signal Uart1RxFifoEmpty : std_logic;
			signal Uart1RxFifoReadAck : std_logic;
			signal Uart1RxFifoData : std_logic_vector(7 downto 0);
			signal Uart1RxFifoCount : std_logic_vector(9 downto 0);
			signal WriteUart1 : std_logic;
			signal Uart1TxFifoFull : std_logic;
			signal Uart1TxFifoEmpty : std_logic;
			signal Uart1TxFifoData : std_logic_vector(7 downto 0);
			signal Uart1TxFifoCount : std_logic_vector(9 downto 0);
			signal Uart1ClkDivider : std_logic_vector(7 downto 0);
			signal UartClk1 : std_logic;			
			signal UartTxClk1 : std_logic;			
			signal Txd1_i : std_logic;
			signal Rxd1_i : std_logic;
			signal UartRx1Dbg : std_logic;	
			signal Uart2FifoReset : std_logic;
			signal Uart2FifoReset_i : std_logic;
			signal ReadUart2 : std_logic;
			signal Uart2RxFifoFull : std_logic;
			signal Uart2RxFifoEmpty : std_logic;
			signal Uart2RxFifoReadAck : std_logic;
			signal Uart2RxFifoData : std_logic_vector(7 downto 0);
			signal Uart2RxFifoCount : std_logic_vector(9 downto 0);
			signal WriteUart2 : std_logic;
			signal Uart2TxFifoFull : std_logic;
			signal Uart2TxFifoEmpty : std_logic;
			signal Uart2TxFifoData : std_logic_vector(7 downto 0);
			signal Uart2TxFifoCount : std_logic_vector(9 downto 0);
			signal Uart2ClkDivider : std_logic_vector(7 downto 0);
			signal UartClk2 : std_logic;			
			signal UartTxClk2 : std_logic;			
			signal Txd2_i : std_logic;
			signal Rxd2_i : std_logic;
			signal UartRx2Dbg : std_logic;			
			
		-- Timing
		
			signal PPS_i : std_logic;	
			signal PPSCountReset : std_logic; --generated by register read
			signal PPSDetected : std_logic; --are edges occuring on PPS?  Mainly used by rtc to decide wether to roll the clock over on it's own or let PPS sync it
			signal PPSCount : std_logic_vector(31 downto 0); --How many MasterClocks have gone by since the last PPS edge (so we can phase-lock oscillator to GPS time)
			signal PPSCounter : std_logic_vector(31 downto 0); --This one is the current count for this second, not the total for the last second...
			signal ClkDacWrite : std_logic_vector(15 downto 0);
			signal WriteClkDac : std_logic;
			signal ClkDacReadback : std_logic_vector(15 downto 0);
			signal nCsClk_i : std_logic;
			signal SckClk_i : std_logic;
			signal MosiClk_i : std_logic;
			signal MisoClk_i : std_logic;
			
		-- Debug
			
			signal TP1_i : std_logic;
			signal TP2_i : std_logic;
			signal TP3_i : std_logic;
			signal TP4_i : std_logic;
				
begin

	------------------------------PORTMAPS - map all library functions/logic to our specific local variables/signals----------------------------------
	
	--~ MasterPll : ClockMultiplierPorts
	--~ generic map (
		--~ CLOCK_DIVIDER => 1,
		--~ CLOCK_MULTIPLIER => ClockFreqMultiplier,
		--~ CLOCK_FREQ_KHZ => 49152.0--,		
	--~ )
	--~ PORT MAP (
		--~ rst => '0',
		--~ clkin => VCXO,
		--~ clkout => MasterClk,
		--~ locked => open
	--~ );
    
	--MasterClk <= VCXO;
    MasterClk <= pll0O;
	UartClk <= pll1O;
	--~ UartClk <= pll0O;
    
    --~ UserJmpJstnCse <= MasterClk;
    --UserJmpJstnCse <= '1';
    --UserJmpJstnCse <= '0';
	
	--~ --Clocks the internal xilinx serial number ('dna') into a buffer
	--~ DnaRegister : DnaRegisterPorts
	--~ generic map
	--~ (
		--~ BIT_WIDTH => 32
	--~ )
	--~ port map
	--~ (
		--~ clk => MasterClk,
		--~ rst => MasterReset,
		--~ DnaRegister => SerialNumber--,
	--~ );
	--~ SerialNumber <= x"BAADC0DE";
	SerialNumber <= x"DEADA555";
	
	BuildNumber_i : BuildNumberPorts
	port map
	(
		BuildNumber => BuildNumber--;
	);
	
	--~ BuildNumber <= x"69696969";
	
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
	
	--~ TP1 <= TP1_i;
	--~ TP2 <= TP2_i;
	--~ TP3 <= TP3_i;
	--~ TP4 <= TP4_i;

	------------------------------------------ RegisterSpaces ---------------------------------------------------

		IBufOE : IBufP2Ports port map(clk => MasterClk, I => RamBusOE, O => RamBusOE_i);
		IBufCE : IBufP2Ports port map(clk => MasterClk, I => RamBusnCs(0), O => RamBusCE_i);
		IBufWE : IBufP2Ports port map(clk => MasterClk, I => RamBusWE, O => RamBusWE_i);

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
		
			IBUF_RamData_i : IBufP1Ports
			port map (
				clk => MasterClk,
				I => RamBusData_in(i),
				O => RamDataIn(i)--,
			);
			
			RamBusData_out(i) <= RamDataOut(i);
			
			RamBusData_ena(i) <= not(nTristateRamDataPins);
			
		end generate;
	
	--devmem2 0x021B8010 w 0x3F000FE0 for max wait states on arm, write is taking 400ns / word, 1us / 32b
	DataToWrite <= RamDataIn;
	WriteReq <= '1' when ( (RamBusCE_i = '0') and (RamBusWE_i = '0') ) else '0';
	
	--devmem2 0x021B8008 w 0x3F000707 for max wait states on arm, read is taking 400ns / word, 1us / 32b
	RamDataOut <= DataFromRead;
    --RamDataOut <= x"69";
	--~ ReadReq  <= '1' when ( (RamBusCE_i = '0') and (RamBusOE_i = '0') ) else '0';
	--~ ReadReq  <= '1' when (RamBusCE_i = '0') else '0';
	ReadReq <= '1' when ( (RamBusCE_i = '0') and (RamBusWE_i = '1') ) else '0';
	nTristateRamDataPins <= '1' when ( (RamBusCE_i = '0') and (RamBusOE_i = '0') ) else '0';

	--~ MosiMonitorAdcTP1 <= RamBusnCs(0);
	--~ MisoMonitorAdcTP2 <= RamBusOE;
	--~ SckMonitorAdcTP3 <= RamBusWE;
	--~ nDrdyMonitorAdcTP4 <= ReadAck;
	--~ TP1_i <= RamBusnCs(0);
	--~ TP2_i <= RamBusOE;
	--~ TP2_i <= RamBusWE;
	--~ TP3_i <= RamBusWE;
	--~ TP3_i <= RamBusAddress(0);
	--~ TP4_i <= ReadAck;
	--~ TP4_i <= WriteAck;
	--~ TP4_i <= RamBusData_in(0);
	--~ UserJmpJstnCse <= TP1_i and TP2_i and TP3_i and TP4_i;
	
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

		--Infrastructure
		SerialNumber => SerialNumber,
		BuildNumber => BuildNumber,
		
		--PZT D/A's
		DacASetpoint => DacASetpoint,
		DacBSetpoint => DacBSetpoint,
		DacCSetpoint => DacCSetpoint,
		WriteDacs => WriteDacs,
		DacAReadback => DacAReadback,
		DacBReadback => DacBReadback,
		DacCReadback => DacCReadback,
		--~ DacAReadback => DacASetpoint,
		--~ DacBReadback => DacBSetpoint,
		--~ DacCReadback => DacCSetpoint--,
		DacTransferComplete => DacTransferComplete,
		
		--PZT A/D's
		ReadAdcSample => ReadAdcSample,
		AdcSampleToReadA => AdcSampleToReadA,
		AdcSampleToReadB => AdcSampleToReadB,
		AdcSampleToReadC => AdcSampleToReadC,
		AdcSampleNumAccums => AdcSampleNumAccums,
		
		--Monitor A/D
		MonitorAdcChannelReadIndex => MonitorAdcChannel,
		ReadMonitorAdcSample => MonitorAdcReadSample,
		MonitorAdcSampleToRead => ltc244xaccum_to_std_logic(MonitorAdcSample),
		
		--RS-422
		Uart0FifoReset => Uart0FifoReset,
		ReadUart0 => ReadUart0,
		Uart0RxFifoFull => Uart0RxFifoFull,
		Uart0RxFifoEmpty => Uart0RxFifoEmpty,
		Uart0RxFifoData => Uart0RxFifoData,
		Uart0RxFifoCount => Uart0RxFifoCount,
		WriteUart0 => WriteUart0,
		Uart0TxFifoFull => Uart0TxFifoFull,
		Uart0TxFifoEmpty => Uart0TxFifoEmpty,
		Uart0TxFifoData => Uart0TxFifoData,
		Uart0TxFifoCount => Uart0TxFifoCount,
		Uart0ClkDivider => Uart0ClkDivider,
		
		Uart1FifoReset => Uart1FifoReset,
		ReadUart1 => ReadUart1,
		Uart1RxFifoFull => Uart1RxFifoFull,
		Uart1RxFifoEmpty => Uart1RxFifoEmpty,
		Uart1RxFifoData => Uart1RxFifoData,
		Uart1RxFifoCount => Uart1RxFifoCount,
		WriteUart1 => WriteUart1,
		Uart1TxFifoFull => Uart1TxFifoFull,
		Uart1TxFifoEmpty => Uart1TxFifoEmpty,
		Uart1TxFifoData => Uart1TxFifoData,
		Uart1TxFifoCount => Uart1TxFifoCount,
		Uart1ClkDivider => Uart1ClkDivider,
		
		Uart2FifoReset => Uart2FifoReset,
		ReadUart2 => ReadUart2,
		Uart2RxFifoFull => Uart2RxFifoFull,
		Uart2RxFifoEmpty => Uart2RxFifoEmpty,
		Uart2RxFifoData => Uart2RxFifoData,
		Uart2RxFifoCount => Uart2RxFifoCount,
		WriteUart2 => WriteUart2,
		Uart2TxFifoFull => Uart2TxFifoFull,
		Uart2TxFifoEmpty => Uart2TxFifoEmpty,
		Uart2TxFifoData => Uart2TxFifoData,
		Uart2TxFifoCount => Uart2TxFifoCount,
		Uart2ClkDivider => Uart2ClkDivider,
		
		--Timing
		IdealTicksPerSecond => std_logic_vector(to_unsigned(BoardMasterClockFreq, 32)),
		ActualTicksLastSecond => PPSCount,
		PPSCountReset => PPSCountReset,
		ClockTicksThisSecond => PPSCounter,
		ClkDacWrite => ClkDacWrite,
		WriteClkDac => WriteClkDac,
		ClkDacReadback => ClkDacReadback--,
	);
	
	
	------------------------------------------ PZT D/A's ---------------------------------------------------
	
		IBufPZTDacMisoA : IBufP1Ports port map(clk => MasterClk, I => MosiDacA_in, O => MisoDacA_i); --No actual Miso on MAX5719, so we're looping back the Mosi signal to see if the bit is stuck on the pcb...
		IBufPZTDacMisoB : IBufP1Ports port map(clk => MasterClk, I => MosiDacB_in, O => MisoDacB_i); --No actual Miso on MAX5719, so we're looping back the Mosi signal to see if the bit is stuck on the pcb...
		IBufPZTDacMisoC : IBufP1Ports port map(clk => MasterClk, I => MosiDacC_in, O => MisoDacC_i); --No actual Miso on MAX5719, so we're looping back the Mosi signal to see if the bit is stuck on the pcb...
		
	--MAX5719 is left-shifted, MSB-first
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
		DacReadbackC => DacCReadback,
		TransferComplete => DacTransferComplete
	);

	nCsDacA <= nCsDacA_i;
	nCsDacB <= nCsDacB_i;
	nCsDacC <= nCsDacC_i;
	SckDacs <= SckDacs_i;
	MosiDacA_out <= MosiDacA_i;
	MosiDacB_out <= MosiDacB_i;
	MosiDacC_out <= MosiDacC_i;
	MosiDacA_ena <= '1';
	MosiDacB_ena <= '1';
	MosiDacC_ena <= '1';
	
	--~ nCsMonitorAdc <= '1';
	UserJmpJstnCse <= nCsDacA_i;
	--~ SckMonitorAdcTP3 <= SckDacs_i;
	--~ MosiMonitorAdcTP1 <= MosiDacA_i;
	--~ MosiMonitorAdcTP1 <= nLDacs_i;	

	--~ nLDacs <= not(nCsDacA_i);
	--not(nCs) prolly works, but this is more technically correct:
	nLDacsOneShot : OneShotPorts
	generic map (
		CLOCK_FREQHZ => BoardMasterClockFreq,
		--~ DELAY_SECONDS => 0.000000025, --25ns
		DELAY_SECONDS => 0.00000005, --50ns (MAX5719 specifies 20ns min)
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
	
	--~ TP1_i <= nCsDacA_i;
	--~ TP2_i <= nLDacs_i;
	--~ TP2_i <= MosiDacA_i;
	--~ TP2_i <= RamBusWE;
	--~ TP3_i <= SckDacs_i;
	--~ TP3_i <= WriteDacs;
	--~ TP4_i <= MisoDacA_i;
	--~ TP4_i <= WriteAck;
	--~ TP4_i <= RamBusData_in(0);
	
	----------------------------- A/D's ----------------------------------
			
		IBufSarAdcnDrdyA : IBufP2Ports port map(clk => MasterClk, I => nDrdyAdcA, O => nDrdyAdcA_i);
		IBufSarAdcnDrdyB : IBufP2Ports port map(clk => MasterClk, I => nDrdyAdcB, O => nDrdyAdcB_i);
		IBufSarAdcnDrdyC : IBufP2Ports port map(clk => MasterClk, I => nDrdyAdcC, O => nDrdyAdcC_i);

		IBufSarAdcMisoA : IBufP2Ports port map(clk => MasterClk, I => MisoAdcA, O => MisoAdcA_i);
		IBufSarAdcMisoB : IBufP2Ports port map(clk => MasterClk, I => MisoAdcB, O => MisoAdcB_i);
		IBufSarAdcMisoC : IBufP2Ports port map(clk => MasterClk, I => MisoAdcC, O => MisoAdcC_i);
	
	ltc2378 : Ltc2378AccumTrioPorts
	port map
	(
		clk => MasterClk,
		rst => MasterReset,
		Trigger => TrigSyncAdcs_i,
		nDrdyA => nDrdyAdcA_i,
		nDrdyB => nDrdyAdcB_i,
		nDrdyC => nDrdyAdcC_i,
		Sck => SckAdcs_i,
		MisoA => MisoAdcA_i,
		MisoB => MisoAdcB_i,
		MisoC => MisoAdcC_i,
		nCsA => nCsRstAdcA_i,
		nCsB => nCsRstAdcB_i,
		nCsC => nCsRstAdcC_i,
		OverRangeA => open,
		OverRangeB => open,
		OverRangeC => open,
		AdcPowerDown => '0',
		--~ AdcClkDivider => x"002F", --1MHz
		--~ AdcClkDivider => x"05DC", --32kHz
		AdcClkDivider => x"0FFF", --32kHz
		--~ SamplesToAverage => x"03FF",		
		SamplesToAverage => x"0001",		
		ChopperEnable => '0',
		ChopperMuxPos => CMuxPosAClkAdcs,
		ChopperMuxNeg => CMuxNegPwrDnAdcs,
		ReadAdcSample  => ReadAdcSample,
		AdcSampleToReadA => AdcSampleToReadA,
		AdcSampleToReadB => AdcSampleToReadB,
		AdcSampleToReadC => AdcSampleToReadC,
		AdcSampleNumAccums => AdcSampleNumAccums,
		--~ TP1 => MosiMonitorAdcTP1,
		--~ TP1 => Txd0,
		--~ TP2 => MisoMonitorAdcTP2,
		--~ TP2 => Txd1,
		--~ TP2 => Txd0,
		--~ TP3 => SckMonitorAdcTP3,
		--~ TP3 => Txd2,
		--~ TP4 => open--,
		--~ TP4 => nDrdyMonitorAdcTP4--,		
		--~ TP4 => Txd1--,		
		--~ TP1 => TP1,
		--~ TP2 => TP2,
		--~ TP3 => TP3,
		--~ TP4 => TP4--,		
		TP1 => open,
		TP2 => open,
		TP3 => open,
		TP4 => open--,		
	);

	--Map the other A/D signals to the actual pins:
	MosiAdcA <= '0';
	MosiAdcB <= '0';
	MosiAdcC <= '0';
	TrigSyncAdcs <= TrigSyncAdcs_i;
	nCsRstAdcA <= nCsRstAdcA_i;
	nCsRstAdcB <= nCsRstAdcB_i;
	nCsRstAdcC <= nCsRstAdcC_i;
	SckAdcs <= SckAdcs_i;
		
	--To test between fpga & A/D:
	TP1_i <= TrigSyncAdcs_i;
	TP2_i <= nDrdyAdcA_i;
	TP3_i <= nCsRstAdcA_i;
	TP4_i <= SckAdcs_i;
	--~ TP8 <= SarAdcMiso_i;
	
	TP5 <= MisoAdcA_i;
	TP6 <= MisoAdcB_i;
	TP7 <= MisoAdcC_i;
	TP8 <= ReadAdcSample;
	
	--To test between fpga & uC:
	--~ TP8 <= SarReadAdcSample;
	--~ TP4 <= SarAdcSampleReadAck;
	--~ TP5 <= SarFifoAdcSample(0);
	
	----------------------------------------------------------------Monitor A/D--------------------------------------------------------------------
			
	IBufnDrdyAdc : IBufP3Ports port map(clk => MasterClk, I => nDrdyMonitorAdcTP4, O => nDrdyMonitorAdc_i); --if you want to change the pin for this chip select, it's here
	IBufMisoAdc : IBufP3Ports port map(clk => MasterClk, I => MisoMonitorAdcTP2, O => MisoMonitorAdc_i); --if you want to change the pin for this chip select, it's here
	
	ltc244xaccumulator : ltc244xaccumulatorPorts
	generic MAP
	(
		MASTER_CLOCK_FREQHZ => BoardMasterClockFreq,
		LTC244X_DATARATE => "1111",
		LTC244X_DOUBLERATE => '0'--,
	)
	port map
	(
		clk => MasterClk,
		rst => MasterReset,
		nDrdy => nDrdyMonitorAdc_i,
		nCs => nCsMonitorAdc_i,
		Sck => SckMonitorAdc_i,
		Mosi => MosiMonitorAdc_i,
		Miso => MisoMonitorAdc_i,
		--~ Dbg1 => Txd0,
		--~ Dbg2 => Txd1,
		--~ InvalidStateReached => Txd2,
		Dbg1 => open,
		Dbg2 => open,
		InvalidStateReached => open,
		AdcChannelReadIndex => MonitorAdcChannel,
		ReadAdcSample => MonitorAdcReadSample,
		AdcSampleToRead => MonitorAdcSample--,
	);
	
	--Internal A/D control:
	nCsMonitorAdc <= nCsMonitorAdc_i;
	SckMonitorAdcTP3 <= SckMonitorAdc_i;
	MosiMonitorAdcTP1 <= MosiMonitorAdc_i;
	
	--~ nCsMonitorAdc <= '1';
	--~ TP1 <= nCsMonitorAdc_i;
	--~ TP2 <= MonitorAdcReadSample;
				
	--~ SckSpiExtInt2Accel <= nCsMonitorAdc_i;
	--~ MosiSpiExtInt1Accel <= MonitorAdcReadSample;
	--~ MisoSpiExtSckAccel <= '0';
	--~ nCsSpiExtDrdyAccel <= '0';
	--~ OutClkSpiExtnCsAccel <= '1';
	--~ InIntSpiExtMosiAccel <= MonitorAdcChannel(0);
	--~ MisoAccel <= '0';
		
	--~ Txd0 <= MonitorAdcReadSample;
	--~ Txd1 <= MonitorAdcReadSample;
	--~ Txd2 <= MonitorAdcReadSample;
	
	----------------------------- RS-422 ----------------------------------
	
	--First, the _really_ boring loopback (hardware)
	--~ Txd0 <= Rxd0;
	
	--~ --Second, the somewhat less boring loopback (firmware)	

	--~ RS422_Rx1 : UartRx
	--~ generic map (
		--~ CLOCK_FREQHZ => BoardMasterClockFreq,
		--~ --BAUDRATE => 12500000--;
		--~ --BAUDRATE => 8000000--,
		--~ --BAUDRATE => BoardMasterClockFreq / 16--, --9.216MHz
		--~ BAUDRATE => 115200--,
		
	--~ )
	--~ port map (						
		--~ clk => MasterClk,
		--~ rst => MasterReset,
		--~ Rxd => Rxd1,
		--~ UartClk => Uart1Clkx16,
		--~ RxComplete => Uart1RxComplete,
		--~ RxData => Uart1Data
	--~ );
	
	--~ Uart1TxClockDivider : ClockDividerPorts generic map(CLOCK_DIVIDER => 16, DIVOUT_RST_STATE => '0') port map(clk => Uart1Clkx16, rst => MasterReset, div => Uart1Clk);
	
	--~ RS422_Tx1 : UartTx
	--~ port map
	--~ (
		--~ clk => Uart1Clk,
		--~ reset => MasterReset,
		--~ Go => Uart1RxComplete,
		--~ TxD => Txd1,
		--~ --TxD => open,
		--~ Busy => open,
		--~ --Busy => UserJmpJstnCse,
		--~ Data => Uart1Data
	--~ );

	--Thirdly, the very not boring fifos (software)
	
	Uart0BitClockDiv : VariableClockDividerPorts
	generic map
	(
		WIDTH_BITS => 8,
		DIVOUT_RST_STATE => '0'--;
	)
	port map
	(
		--~ clki => MasterClk,
		clki => UartClk,
		rst => MasterReset,
		rst_count => x"00",
		terminal_count => Uart0ClkDivider,
		clko => UartClk0
	);
	Uart0TxBitClockDiv : ClockDividerPorts
	generic map
	(
		CLOCK_DIVIDER => 16,
		DIVOUT_RST_STATE => '0'--;
	)
	port map
	(
		clk => UartClk0,
		rst => MasterReset,
		div => UartTxClk0
	);
		
	IBufRxd0 : IBufP3Ports port map(clk => UartClk, I => Rxd0, O => Rxd0_i); --if you want to change the pin for this chip select, it's here
	
	RS422_Rx0 : UartRxFifoExtClk
	generic map
	(
		--~ UART_CLOCK_FREQHZ => BoardMasterClockFreq,
		FIFO_BITS => 10--,
		--~ BAUD_DIVIDER_BITS => 8--,
		--~ BAUDRATE => BoardMasterClockFreq--,
		--~ BAUDRATE => 8000000--,
		--~ BAUDRATE => 4000000--,
		--~ BAUDRATE => 2000000--,
		--~ BAUDRATE => 1000000--,
		--~ BAUDRATE => BoardMasterClockFreq / 16--, --9.216MHz
		--~ BAUDRATE => BoardMasterClockFreq / 8192--,
		--~ BAUDRATE => 115200--,
	)
	port map
	(
		clk => MasterClk,
		uclk => UartClk0,
		rst => Uart0FifoReset_i,
		--~ BaudDivider => Uart0ClkDivider,
		Rxd => Rxd0_i,
		--~ Dbg1 => UartRx0Dbg,
		ReadFifo => ReadUart0,
		FifoFull => Uart0RxFifoFull,
		FifoEmpty => Uart0RxFifoEmpty,
		FifoReadData => Uart0RxFifoData,
		FifoCount => Uart0RxFifoCount,
		FifoReadAck => open--,		
	);
	
	RS422_Tx0 : UartTxFifoExtClk
	generic map
	(
		--~ UART_CLOCK_FREQHZ => BoardMasterClockFreq,
		FIFO_BITS => 10--,
		--~ BAUD_DIVIDER_BITS => 8--,
		--~ BAUDRATE => 12500000--,
		--~ BAUDRATE => 8000000--,
		--~ BAUDRATE => 4000000--,
		--~ BAUDRATE => 2000000--,
		--~ BAUDRATE => 1000000--,
		--~ BAUDRATE => BoardMasterClockFreq / 16--, --9.216MHz
		--~ BAUDRATE => BoardMasterClockFreq / 8192--,
		--~ BAUDRATE => 115200--,
	)
	port map
	(
		clk => MasterClk,
		uclk => UartTxClk0,
		rst => Uart0FifoReset_i,
		--~ BaudDivider => Uart0ClkDivider,
		BitClockOut => open,
		--~ BitClockOut => UserJmpJstnCse,		
		WriteStrobe => WriteUart0,
		WriteData => Uart0TxFifoData,
		FifoFull => Uart0TxFifoFull,
		FifoEmpty => Uart0TxFifoEmpty,
		FifoCount => Uart0TxFifoCount,
		TxInProgress => open,
		--~ TxInProgress => SckMonitorAdcTP3,		
		Cts => '0',
		Txd => Txd0_i--,
		--~ Txd => open--,
	);
	Txd0 <= Txd0_i;
	
	--Mux master reset (boot) and user reset (datamapper)
	Uart0FifoReset_i <= MasterReset or Uart0FifoReset;
	
	Uart1BitClockDiv : VariableClockDividerPorts
	generic map
	(
		WIDTH_BITS => 8,
		DIVOUT_RST_STATE => '0'--;
	)
	port map
	(
		--~ clki => MasterClk,
		clki => UartClk,
		rst => MasterReset,
		rst_count => x"00",
		terminal_count => Uart1ClkDivider,
		clko => UartClk1
	);
	Uart1TxBitClockDiv : ClockDividerPorts
	generic map
	(
		CLOCK_DIVIDER => 16,
		DIVOUT_RST_STATE => '0'--;
	)
	port map
	(
		clk => UartClk1,
		rst => MasterReset,
		div => UartTxClk1
	);
	
	IBufRxd1 : IBufP3Ports port map(clk => UartClk, I => Rxd1, O => Rxd1_i); --if you want to change the pin for this chip select, it's here
	
	RS422_Rx1 : UartRxFifoExtClk
	generic map
	(
		--~ UART_CLOCK_FREQHZ => BoardMasterClockFreq,
		FIFO_BITS => 10--,
		--~ BAUD_DIVIDER_BITS => 8--,
		--~ BAUDRATE => 12500000--,
		--~ BAUDRATE => 8000000--,
		--~ BAUDRATE => BoardMasterClockFreq / 16--, --9.216MHz
		--~ BAUDRATE => BoardMasterClockFreq / 8192--,
		--~ BAUDRATE => 921600--,
		--~ BAUDRATE => 460800--, --calcs show 460k is the fastest standard baudrate with a clean divisor...
	)
	port map
	(
		clk => MasterClk,
		uclk => UartClk1,
		rst => Uart1FifoReset_i,
		--~ BaudDivider => Uart1ClkDivider,
		Rxd => Rxd1_i,
		--~ Dbg1 => UartRx1Dbg,
		ReadFifo => ReadUart1,
		FifoFull => Uart1RxFifoFull,
		FifoEmpty => Uart1RxFifoEmpty,
		FifoReadData => Uart1RxFifoData,
		FifoCount => Uart1RxFifoCount,
		FifoReadAck => open--,		
	);
	
	RS422_Tx1 : UartTxFifoExtClk
	generic map
	(
		--~ UART_CLOCK_FREQHZ => BoardMasterClockFreq,
		FIFO_BITS => 10--,
		--~ BAUD_DIVIDER_BITS => 8--,
		--~ BAUDRATE => 12500000--,
		--~ BAUDRATE => 8000000--,
		--~ BAUDRATE => BoardMasterClockFreq / 16--, --9.216MHz
		--~ BAUDRATE => BoardMasterClockFreq / 8192--,
		--~ BAUDRATE => 921600--,
		--~ BAUDRATE => 460800--, --calcs show 460k is the fastest standard baudrate with a clean divisor...
	)
	port map
	(
		clk => MasterClk,
		uclk => UartTxClk1,
		rst => Uart1FifoReset_i,
		--~ BaudDivider => Uart1ClkDivider,
		BitClockOut => open,
		WriteStrobe => WriteUart1,
		WriteData => Uart1TxFifoData,
		FifoFull => Uart1TxFifoFull,
		FifoEmpty => Uart1TxFifoEmpty,
		FifoCount => Uart1TxFifoCount,
		TxInProgress => open,
		--~ TxInProgress => SckMonitorAdcTP3,		
		Cts => '0',
		Txd => Txd1_i--,
		--~ Txd => open--,
	);
	Txd1 <= Txd1_i;
	
	--Mux master reset (boot) and user reset (datamapper)
	Uart1FifoReset_i <= MasterReset or Uart1FifoReset;
	
	Uart2BitClockDiv : VariableClockDividerPorts
	generic map
	(
		WIDTH_BITS => 8,
		DIVOUT_RST_STATE => '0'--;
	)
	port map
	(
		--~ clki => MasterClk,
		clki => UartClk,
		rst => MasterReset,
		rst_count => x"00",
		terminal_count => Uart2ClkDivider,
		clko => UartClk2
	);
	Uart2TxBitClockDiv : ClockDividerPorts
	generic map
	(
		CLOCK_DIVIDER => 16,
		DIVOUT_RST_STATE => '0'--;
	)
	port map
	(
		clk => UartClk2,
		rst => MasterReset,
		div => UartTxClk2
	);
	
	--~ UserJmpJstnCse <= UartClk2;
	
	IBufRxd2 : IBufP3Ports port map(clk => UartClk, I => Rxd2, O => Rxd2_i); --if you want to change the pin for this chip select, it's here
	
	--~ UserJmpJstnCse <= Rxd2;
	
	RS422_Rx2 : UartRxFifoExtClk
	generic map
	(
		--~ UART_CLOCK_FREQHZ => BoardMasterClockFreq,
		FIFO_BITS => 10--,
		--~ BAUD_DIVIDER_BITS => 8--,
		--~ BAUDRATE => 12500000--,
		--~ BAUDRATE => 8000000--,
		--~ BAUDRATE => BoardMasterClockFreq / 16--, --9.216MHz
		--~ BAUDRATE => BoardMasterClockFreq / 8192--,
		--~ BAUDRATE => 115200--,
	)
	port map
	(
		clk => MasterClk,
		uclk => UartClk2,
		rst => Uart2FifoReset_i,
		--~ BaudDivider => Uart2ClkDivider,
		Rxd => Rxd2_i,
		--~ Dbg1 => UartRx2Dbg,
		ReadFifo => ReadUart2,
		FifoFull => Uart2RxFifoFull,
		FifoEmpty => Uart2RxFifoEmpty,
		FifoReadData => Uart2RxFifoData,
		FifoCount => Uart2RxFifoCount,
		FifoReadAck => open--,		
	);
	
	RS422_Tx2 : UartTxFifoExtClk
	--~ RS422_Tx2 : UartTxFifo
	generic map
	(
		--~ UART_CLOCK_FREQHZ => BoardMasterClockFreq,
		--~ FIFO_BITS => 10,
		FIFO_BITS => 10--,
		--~ BAUD_DIVIDER_BITS => 8--,
		--~ BAUDRATE => 12500000--,
		--~ BAUDRATE => 8000000--,
		--~ BAUDRATE => BoardMasterClockFreq / 16--, --9.216MHz
		--~ BAUDRATE => BoardMasterClockFreq / 8192--,
		--~ BAUDRATE => 115200--,
	)
	port map
	(
		clk => MasterClk,
		--~ uclk => MasterClk,
		uclk => UartTxClk2,
		rst => Uart2FifoReset_i,
		--~ BaudDivider => Uart2ClkDivider,
		BitClockOut => open,
		--~ BitClockOut => UserJmpJstnCse,		
		WriteStrobe => WriteUart2,
		WriteData => Uart2TxFifoData,
		FifoFull => Uart2TxFifoFull,
		FifoEmpty => Uart2TxFifoEmpty,
		FifoCount => Uart2TxFifoCount,
		TxInProgress => open,
		--~ TxInProgress => SckMonitorAdcTP3,		
		Cts => '0',
		Txd => Txd2_i--,
		--~ Txd => open--,
	);
	Txd2 <= Txd2_i;
	
	--Debug monitors
	--~ Txd2 <= Txd0_i;
	--~ Txd1 <= Rxd0_i;
	
	--Mux master reset (boot) and user reset (datamapper)
	Uart2FifoReset_i <= MasterReset or Uart2FifoReset;
	
	--~ SckMonitorAdcTP3 <= Uart1RxComplete;
	--~ MosiMonitorAdcTP1 <= UartRx2Dbg;
	--~ UserJmpJstnCse <= Rxd2_i;
	--~ UserJmpJstnCse <= UartRx2Dbg;
	--~ SckMonitorAdcTP3 <= Txd2_i;
	--~ MosiMonitorAdcTP1 <= Uart2TxFifoEmpty;
	--~ UserJmpJstnCse <= UartTxClk0;
	--~ UserJmpJstnCse <= Rxd0_i;	
		
	----------------------------- Timing ----------------------------------
	
		--Just sync external PPS to master clock
		IBufPPS : IBufP2Ports port map(clk => MasterClk, I => PpsIn, O => PPS_i);

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
	
	--~ PPSRtcPhaseComparator : PhaseComparatorPorts
	--~ generic map (
		--~ MAX_CLOCK_BITS_DELTA => 32--,
	--~ )
	--~ port map (
		--~ clk => MasterClk,
		--~ rst => not(nMasterReset),
		--~ InA => PPSMux,
		--~ InB => PpsGenerated,
		--~ Delta => PPSRtcPhaseCmp--,
	--~ );
	
	--~ SarPPSAdcPhaseComparator : PhaseComparatorPorts
	--~ generic map (
		--~ MAX_CLOCK_BITS_DELTA => 32--,
	--~ )
	--~ port map (
		--~ clk => MasterClk,
		--~ rst => not(nMasterReset),
		--~ InA => PPSMux,
		--~ --InB => SarAdcnDrdy, --since the A/D undersamples, this really should be the one drdy where we read the a/d, not all of them!
		--~ InB => SarSampleTimestampLatched,
		--~ Delta => SarPPSAdcPhaseCmp--,
	--~ );
	
	--~ --Implements a real time clock that's locked to the PPS
	--~ RtcCounter : RtcCounterPorts
    --~ generic map
	--~ (
		--~ CLOCK_FREQ => BoardMasterClockFreq--,
	--~ )
    --~ port map
	--~ (
		--~ clk => MasterClk,
		--~ rst => not(nMasterReset),
		--~ PPS => PPS_i,
		--~ PPSDetected => PPSDetected,
		--~ Sync => SyncAdcRequest,
		--~ GeneratedPPS => PpsGenerated,
		--~ SetTimeSeconds => SetTimeSeconds,
		--~ SetTime => SetTime,
		--~ SetChangedTime => SetChangedTime,
		--~ Seconds => Seconds,
		--~ Milliseconds => Milliseconds--,
	--~ );
	
	IBufDacMiso : IBufP2Ports port map(clk => MasterClk, I => MisoClk, O => MisoClk_i);

	ClkDac_i : SpiDacPorts
	generic map 
	(
		MASTER_CLOCK_FREQHZ => BoardMasterClockFreq,
		BIT_WIDTH => 16
	)
	port map 
	(
		clk => MasterClk,
		rst => MasterReset,
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
	
	----------------------------- Power Supplies ----------------------------------
	
	HVPowernEn <= '0';
	nHVEn <= '1';
	AnalogPowernEn <= '0';
	
	PowerSyncClockDivider : ClockDividerPorts generic map(CLOCK_DIVIDER => 96, DIVOUT_RST_STATE => '0') port map(clk => MasterClk, rst => MasterReset, div => PowerSync);


				
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

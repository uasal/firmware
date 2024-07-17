--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.ltc244xaccumulator_types.all;
use work.ltc244x_types.all;

entity Main is
port (
    clk : in  std_logic;
	
	--ClkDac
	nCsXO : out std_logic;
	SckXO : out std_logic;
	MosiXO : out std_logic;
	
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
	
	--H-Bridge
	MotorDriveAPlus : out std_logic;
	MotorDriveAMinus : out std_logic;
	MotorDriveBPlus : out std_logic;
	MotorDriveBMinus : out std_logic;
	MotorDriveAPlusPrime : out std_logic;
	MotorDriveAMinusPrime : out std_logic;
	MotorDriveBPlusPrime : out std_logic;
	MotorDriveBMinusPrime : out std_logic;
	
	--uC Ram Bus 
	RamBusAddress : in std_logic_vector(9 downto 0); 
	RamBusDataIn : in std_logic_vector(15 downto 0);
	RamBusDataOut : out std_logic_vector(15 downto 0);
	RamBusnCs : in std_logic;
	RamBusWE : in std_logic;
	RamBusOE : in std_logic;
	
	--RS-422 (uses LVDS and/or Accel pins)
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
	
	--MonitorA/D
	
	nCsMonAdc0 : out std_logic;
	SckMonAdc0 : out std_logic;
	MosiMonAdc0 : out std_logic;
	MisoMonAdc0 : in std_logic;
	nDrdyMonAdc0 : in std_logic;
	
	--  Discrete I/O Connections

		--Faults
		nFaultClr1V : out std_logic;
		nFaultClr3V : out std_logic;
		nFaultClr5V : out std_logic;
		nPowerCycClr : out std_logic;
		PowernEn5V : out std_logic;
		PowerSync : out std_logic;
		Fault1V : in std_logic;
		Fault3V : in std_logic;
		Fault5V : in std_logic;
		PowerCycd: in std_logic;
		
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
		
		Ux1SelJmp : inout std_logic--;
		--Ux1SelJmp : out std_logic--;
);
end Main;

architecture architecture_Main of Main is
   
						component IBufP1Ports is
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
						
						component IBufP3Ports is
						port (
							clk : in std_logic;
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
							RxComplete : out std_logic;
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
							DataIn : in std_logic_vector(15 downto 0);
							DataOut : out std_logic_vector(15 downto 0);
							ReadReq : in  std_logic;
							WriteReq : in std_logic;
							ReadAck : out std_logic;
							WriteAck : out std_logic;
							
							--Data to access:			

							--Infrastructure
							SerialNumber : in std_logic_vector(31 downto 0);
							BuildNumber : in std_logic_vector(31 downto 0);

							--Motor
							MotorEnable : out std_logic;
							MotorSeekStep : out std_logic_vector(15 downto 0);
							MotorCurrentStep : in std_logic_vector(15 downto 0);
							ResetSteps : out std_logic;
							MotorAPlus : in std_logic;
							MotorAMinus : in std_logic;
							MotorBPlus : in std_logic;
							MotorBMinus : in std_logic;
							
							--Sensors
							PosLedsEnA : out std_logic;
							PosLedsEnB : out std_logic;
									
							PosSenseHomeA : in std_logic;
							PosSenseBit0A : in std_logic;
							PosSenseBit1A : in std_logic;
							PosSenseBit2A : in std_logic;
							PosSenseHomeB : in std_logic;
							PosSenseBit0B : in std_logic;
							PosSenseBit1B : in std_logic;
							PosSenseBit2B : in std_logic;
							
							PosSenseA : in std_logic_vector(3 downto 0);
							PosSenseB : in std_logic_vector(3 downto 0);
							
							PosDetHomeAOnStep : in std_logic_vector(15 downto 0);
							PosDetHomeAOffStep : in std_logic_vector(15 downto 0);
							PosDetA0OnStep : in std_logic_vector(15 downto 0);
							PosDetA0OffStep : in std_logic_vector(15 downto 0);
							PosDetA1OnStep : in std_logic_vector(15 downto 0);
							PosDetA1OffStep : in std_logic_vector(15 downto 0);
							PosDetA2OnStep : in std_logic_vector(15 downto 0);
							PosDetA2OffStep : in std_logic_vector(15 downto 0);
							
							PosDetHomeBOnStep : in std_logic_vector(15 downto 0);
							PosDetHomeBOffStep : in std_logic_vector(15 downto 0);
							PosDetB0OnStep : in std_logic_vector(15 downto 0);
							PosDetB0OffStep : in std_logic_vector(15 downto 0);
							PosDetB1OnStep : in std_logic_vector(15 downto 0);
							PosDetB1OffStep : in std_logic_vector(15 downto 0);
							PosDetB2OnStep : in std_logic_vector(15 downto 0);
							PosDetB2OffStep : in std_logic_vector(15 downto 0);
							
							PosDet0AOnStep : in std_logic_vector(15 downto 0);
							PosDet0AOffStep : in std_logic_vector(15 downto 0);
							PosDet1AOnStep : in std_logic_vector(15 downto 0);
							PosDet1AOffStep : in std_logic_vector(15 downto 0);
							PosDet2AOnStep : in std_logic_vector(15 downto 0);
							PosDet2AOffStep : in std_logic_vector(15 downto 0);
							PosDet3AOnStep : in std_logic_vector(15 downto 0);
							PosDet3AOffStep : in std_logic_vector(15 downto 0);
							PosDet4AOnStep : in std_logic_vector(15 downto 0);
							PosDet4AOffStep : in std_logic_vector(15 downto 0);
							PosDet5AOnStep : in std_logic_vector(15 downto 0);
							PosDet5AOffStep : in std_logic_vector(15 downto 0);
							PosDet6AOnStep : in std_logic_vector(15 downto 0);
							PosDet6AOffStep : in std_logic_vector(15 downto 0);
							PosDet7AOnStep : in std_logic_vector(15 downto 0);
							PosDet7AOffStep : in std_logic_vector(15 downto 0);
							
							PosDet0BOnStep : in std_logic_vector(15 downto 0);
							PosDet0BOffStep : in std_logic_vector(15 downto 0);
							PosDet1BOnStep : in std_logic_vector(15 downto 0);
							PosDet1BOffStep : in std_logic_vector(15 downto 0);
							PosDet2BOnStep : in std_logic_vector(15 downto 0);
							PosDet2BOffStep : in std_logic_vector(15 downto 0);
							PosDet3BOnStep : in std_logic_vector(15 downto 0);
							PosDet3BOffStep : in std_logic_vector(15 downto 0);
							PosDet4BOnStep : in std_logic_vector(15 downto 0);
							PosDet4BOffStep : in std_logic_vector(15 downto 0);
							PosDet5BOnStep : in std_logic_vector(15 downto 0);
							PosDet5BOffStep : in std_logic_vector(15 downto 0);
							PosDet6BOnStep : in std_logic_vector(15 downto 0);
							PosDet6BOffStep : in std_logic_vector(15 downto 0);
							PosDet7BOnStep : in std_logic_vector(15 downto 0);
							PosDet7BOffStep : in std_logic_vector(15 downto 0);
							
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
						
						component FourWireStepperMotorDriverPorts is
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
						end component;

						
--Constants & Setup
	

	--Clocks
			
		--~ constant BaseClockFreq : natural := 16777216; --new xtal (256Hz Fs)
		--~ constant ClockFreqMultiplier : natural := 5; --Xilinx says it won't run at 100MHz (x6) as currently written (prob. the accumulator). x4=67MHz, x5=84MHz
		--~ constant BaseClockPeriod : real := 59.6; --really should be exactly 1 / conv_real(BaseClockFreq), but it's just used by DCM clock library, and conv_real doesn't exist.
		--~ constant BoardMasterClockFreq : natural := BaseClockFreq * ClockFreqMultiplier; 
		
		constant BoardMasterClockFreq : natural := 102000000; -- --102.0 clock
		constant BoardUartClockFreq : natural := 136000000;
		--~ constant BoardMasterClockFreq : natural := 153000000; -- --102.0 clock
		signal MasterClk : std_logic; --This is the main clock for *everything*
		signal UartClk : std_logic; --This is the uart clock, it runs at 136MHz, and a lot of the regular logic won't run that fast, which is why we have a seperate clock. In practice, it immediately gets divided by 16 ny the uarts so it actually is slower than the other logic, but at a weird ratio...
		
        signal ShootThruIxnaeAPlus : std_logic;
        signal ShootThruIxnaeAMinus : std_logic;
        signal ShootThruIxnaeBPlus : std_logic;
        signal ShootThruIxnaeBMinus : std_logic;
        signal MotorCurrentStep : std_logic_vector(15 downto 0);
		--~ constant UartClockFreqMultiplier : natural := 7; --15/17 is also a good scaler, and uart dividers come out just over ideal instead of under, so integer math works on them...
		--~ constant UartClockFreqDivider : natural := 8;
		--~ constant UartClockPeriod : real := 68.1; --really should be exactly 1 / conv_real(UartBaseClockFreq), but it's just used by DCM clock library, and conv_real doesn't exist.
		--~ constant UartClockFreq : natural := BaseClockFreq * UartClockFreqMultiplier / UartClockFreqDivider; -- 14.6802MHz (14.7456 ideal; 0.44% dev)

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
			signal RamDataOut : std_logic_vector(15 downto 0);		
			signal RamDataIn : std_logic_vector(15 downto 0);		
			
		-- Register space
		
			signal DataToWrite : std_logic_vector(15 downto 0);
			signal WriteReq : std_logic;
			signal WriteAck : std_logic;
			signal DataFromRead : std_logic_vector(15 downto 0);
			signal ReadReq : std_logic;
			signal ReadAck : std_logic;

			signal MotorEnable : std_logic;        
			signal MotorSeekStep : std_logic_vector(15 downto 0);    
			--signal MotorCurrentStep : std_logic_vector(15 downto 0);
			signal ResetSteps : std_logic;          
			--signal MotorAPlus_i : std_logic;        
			--signal MotorAMinus_i : std_logic;      
			--signal MotorBPlus_i : std_logic;        
			--signal MotorBMinus_i : std_logic;      
			--
			--
			--signal PosLedsEnA : std_logic;          
			--signal PosLedsEnB : std_logic;          
			--
			--signal PosSenseHomeA : std_logic;    
			--signal PosSenseBit0A : std_logic;    
			--signal PosSenseBit1A : std_logic;    
			--signal PosSenseBit2A : std_logic;    
			--signal PosSenseHomeB : std_logic;    
			--signal PosSenseBit0B : std_logic;    
			--signal PosSenseBit1B : std_logic;    
			--signal PosSenseBit2B : std_logic;    
			--
			--signal PosSenseA : std_logic_vector(3 downto 0);            
			--signal PosSenseB : std_logic_vector(3 downto 0);            
			--
			--signal PosDetHomeAOnStep : std_logic_vector(15 downto 0);
			--signal PosDetHomeAOffStep : std_logic_vector(15 downto 0);
			--signal PosDetA0OnStep : std_logic_vector(15 downto 0);  
			--signal PosDetA0OffStep : std_logic_vector(15 downto 0);
			--signal PosDetA1OnStep : std_logic_vector(15 downto 0);  
			--signal PosDetA1OffStep : std_logic_vector(15 downto 0);
			--signal PosDetA2OnStep : std_logic_vector(15 downto 0);  
			--signal PosDetA2OffStep : std_logic_vector(15 downto 0);
			--
			--signal PosDetHomeBOnStep : std_logic_vector(15 downto 0);
			--signal PosDetHomeBOffStep : std_logic_vector(15 downto 0);
			--signal PosDetB0OnStep : std_logic_vector(15 downto 0);  
			--signal PosDetB0OffStep : std_logic_vector(15 downto 0);
			--signal PosDetB1OnStep : std_logic_vector(15 downto 0);  
			--signal PosDetB1OffStep : std_logic_vector(15 downto 0);
			--signal PosDetB2OnStep : std_logic_vector(15 downto 0);  
			--signal PosDetB2OffStep : std_logic_vector(15 downto 0);
			--
			--signal PosDet0AOnStep : std_logic_vector(15 downto 0);  
			--signal PosDet0AOffStep : std_logic_vector(15 downto 0);
			--signal PosDet1AOnStep : std_logic_vector(15 downto 0);  
			--signal PosDet1AOffStep : std_logic_vector(15 downto 0);
			--signal PosDet2AOnStep : std_logic_vector(15 downto 0);  
			--signal PosDet2AOffStep : std_logic_vector(15 downto 0);
			--signal PosDet3AOnStep : std_logic_vector(15 downto 0);  
			--signal PosDet3AOffStep : std_logic_vector(15 downto 0);
			--signal PosDet4AOnStep : std_logic_vector(15 downto 0);  
			--signal PosDet4AOffStep : std_logic_vector(15 downto 0);
			--signal PosDet5AOnStep : std_logic_vector(15 downto 0);  
			--signal PosDet5AOffStep : std_logic_vector(15 downto 0);
			--signal PosDet6AOnStep : std_logic_vector(15 downto 0);  
			--signal PosDet6AOffStep : std_logic_vector(15 downto 0);
			--signal PosDet7AOnStep : std_logic_vector(15 downto 0);  
			--signal PosDet7AOffStep : std_logic_vector(15 downto 0);
			--
			--signal PosDet0BOnStep : std_logic_vector(15 downto 0);  
			--signal PosDet0BOffStep : std_logic_vector(15 downto 0);
			--signal PosDet1BOnStep : std_logic_vector(15 downto 0);  
			--signal PosDet1BOffStep : std_logic_vector(15 downto 0);
			--signal PosDet2BOnStep : std_logic_vector(15 downto 0);  
			--signal PosDet2BOffStep : std_logic_vector(15 downto 0);
			--signal PosDet3BOnStep : std_logic_vector(15 downto 0);  
			--signal PosDet3BOffStep : std_logic_vector(15 downto 0);
			--signal PosDet4BOnStep : std_logic_vector(15 downto 0);  
			--signal PosDet4BOffStep : std_logic_vector(15 downto 0);
			--signal PosDet5BOnStep : std_logic_vector(15 downto 0);  
			--signal PosDet5BOffStep : std_logic_vector(15 downto 0);
			--signal PosDet6BOnStep : std_logic_vector(15 downto 0);  
			--signal PosDet6BOffStep : std_logic_vector(15 downto 0);
			--signal PosDet7BOnStep : std_logic_vector(15 downto 0);  
			--signal PosDet7BOffStep : std_logic_vector(15 downto 0);
			
		--Monitor A/D
		
			--~ signal nDrdyMonitorAdc_i : std_logic;
			--~ signal nCsMonitorAdc_i : std_logic;
			--~ signal SckMonitorAdc_i : std_logic;
			--~ signal MosiMonitorAdc_i : std_logic;
			--~ signal MisoMonitorAdc_i : std_logic;
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
			signal PPSCount : std_logic_vector(31 downto 0) := x"00000000"; --How many MasterClocks have gone by since the last PPS edge (so we can phase-lock oscillator to GPS time)
			signal PPSCounter : std_logic_vector(31 downto 0) := x"00000000"; --This one is the current count for this second, not the total for the last second...
			signal ClkDacWrite : std_logic_vector(15 downto 0) := x"0000";
			signal WriteClkDac : std_logic;
			signal ClkDacReadback : std_logic_vector(15 downto 0);
			signal nCsClk_i : std_logic;
			signal SckClk_i : std_logic;
			signal MosiClk_i : std_logic;
			signal MisoClk_i : std_logic;
			
		-- "The FUN Shit"
		
		-- Positioning System - Led's and Optodetectors
		
		signal LastPosSenseHomeA : std_logic := '0';
		signal LastPosSenseBit0A : std_logic := '0';
		signal LastPosSenseBit1A : std_logic := '0';
		signal LastPosSenseBit2A : std_logic := '0';
		signal LastPosSenseHomeB : std_logic := '0';
		signal LastPosSenseBit0B : std_logic := '0';
		signal LastPosSenseBit1B : std_logic := '0';
		signal LastPosSenseBit2B : std_logic := '0';

		signal PosSenseA : std_logic_vector(3 downto 0) := "0000";
		signal PosSenseB : std_logic_vector(3 downto 0) := "0000";
		signal LastPosSenseA : std_logic_vector(3 downto 0) := "0000";
		signal LastPosSenseB : std_logic_vector(3 downto 0) := "0000";
				
				
		signal PosLedsEnA : std_logic := '0';
		
		signal PosDetHomeAOnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDetHomeAOffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDetA0OnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDetA0OffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDetA1OnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDetA1OffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDetA2OnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDetA2OffStep : std_logic_vector(15 downto 0) := x"0000";
		
		signal PosLedsEnB : std_logic := '0';
		
		signal PosDetHomeBOnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDetHomeBOffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDetB0OnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDetB0OffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDetB1OnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDetB1OffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDetB2OnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDetB2OffStep : std_logic_vector(15 downto 0) := x"0000";
		
		signal PosDet0AOnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet0AOffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet1AOnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet1AOffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet2AOnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet2AOffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet3AOnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet3AOffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet4AOnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet4AOffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet5AOnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet5AOffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet6AOnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet6AOffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet7AOnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet7AOffStep : std_logic_vector(15 downto 0) := x"0000";
		
		signal PosDet0BOnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet0BOffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet1BOnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet1BOffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet2BOnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet2BOffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet3BOnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet3BOffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet4BOnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet4BOffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet5BOnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet5BOffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet6BOnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet6BOffStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet7BOnStep : std_logic_vector(15 downto 0) := x"0000";
		signal PosDet7BOffStep : std_logic_vector(15 downto 0) := x"0000";
		
		-- Motors

		signal ShootThruIxnae : std_logic := '0';
		
		signal MotorAPlus_i : std_logic := '0';
		signal MotorAMinus_i : std_logic := '0';
		signal MotorBPlus_i : std_logic := '0';
		signal MotorBMinus_i : std_logic := '0';
		

		constant PushPullHigh : std_logic := '1';
		constant PushPullGround : std_logic := '0';

		constant OpenDrainOn : std_logic := '0';
		constant OpenDrainFloat : std_logic := 'Z';

		constant nCsEnabled : std_logic := '0';
		constant nCsNotEnabled : std_logic := '1';
		
		constant JumperNotInserted : std_logic := '1';
		constant JumperInserted : std_logic := '0';

begin

	------------------------------------------ Globals ---------------------------------------------------

	MasterClk <= clk;
	UartClk <= clk;
	
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
	
	------------------------------------------ RegisterSpaces ---------------------------------------------------

		IBufOE : IBufP2Ports port map(clk => MasterClk, I => RamBusOE, O => RamBusOE_i);
		--~ IBufCE : IBufP2Ports port map(clk => MasterClk, I => RamBusnCs(0), O => RamBusCE_i);
		IBufCE : IBufP2Ports port map(clk => MasterClk, I => RamBusnCs, O => RamBusCE_i);
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
		
		GenRamDataBus: for i in 0 to 15 generate
		begin
		
		--~ IOBUF_RamData_i : IOBufP2Ports
		--~ port map (
			--~ clk => MasterClk,
			--~ IO => RamBusData(i),
			--~ T => not(nTristateRamDataPins),
			--~ I => RamDataOut(i),
			--~ O => RamDataIn(i)--,
		--~ );
		
			IBUF_RamData_i : IBufP1Ports
			port map (
				clk => MasterClk,
				I => RamBusDataIn(i),
				O => RamDataIn(i)--,
			);
			
			RamBusDataOut(i) <= RamDataOut(i);
			
			--~ RamBusData_ena(i) <= not(nTristateRamDataPins);
					
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
		
		--Motor
		MotorEnable => MotorEnable,        
		MotorSeekStep => MotorSeekStep,    
		MotorCurrentStep => MotorCurrentStep,
		ResetSteps => ResetSteps,          
		MotorAPlus => MotorAPlus_i,        
		MotorAMinus => MotorAMinus_i,      
		MotorBPlus => MotorBPlus_i,        
		MotorBMinus => MotorBMinus_i,      
		                                   
		--Sensors                          
		PosLedsEnA => PosLEDEnA,          
		PosLedsEnB => PosLEDEnB,          
			                  
		PosSenseHomeA => PosSenseHomeA,    
		PosSenseBit0A => PosSenseBit0A,    
		PosSenseBit1A => PosSenseBit1A,    
		PosSenseBit2A => PosSenseBit2A,    
		PosSenseHomeB => PosSenseHomeB,    
		PosSenseBit0B => PosSenseBit0B,    
		PosSenseBit1B => PosSenseBit1B,    
		PosSenseBit2B => PosSenseBit2B,    
		                                   
		PosSenseA => PosSenseA,            
		PosSenseB => PosSenseB,            
		                                   
		PosDetHomeAOnStep => PosDetHomeAOnStep,
		PosDetHomeAOffStep => PosDetHomeAOffStep,
		PosDetA0OnStep => PosDetA0OnStep,  
		PosDetA0OffStep => PosDetA0OffStep,
		PosDetA1OnStep => PosDetA1OnStep,  
		PosDetA1OffStep => PosDetA1OffStep,
		PosDetA2OnStep => PosDetA2OnStep,  
		PosDetA2OffStep => PosDetA2OffStep,
		                                   
		PosDetHomeBOnStep => PosDetHomeBOnStep,
		PosDetHomeBOffStep => PosDetHomeBOffStep,
		PosDetB0OnStep => PosDetB0OnStep,  
		PosDetB0OffStep => PosDetB0OffStep,
		PosDetB1OnStep => PosDetB1OnStep,  
		PosDetB1OffStep => PosDetB1OffStep,
		PosDetB2OnStep => PosDetB2OnStep,  
		PosDetB2OffStep => PosDetB2OffStep,
		                                   
		PosDet0AOnStep => PosDet0AOnStep,  
		PosDet0AOffStep => PosDet0AOffStep,
		PosDet1AOnStep => PosDet1AOnStep,  
		PosDet1AOffStep => PosDet1AOffStep,
		PosDet2AOnStep => PosDet2AOnStep,  
		PosDet2AOffStep => PosDet2AOffStep,
		PosDet3AOnStep => PosDet3AOnStep,  
		PosDet3AOffStep => PosDet3AOffStep,
		PosDet4AOnStep => PosDet4AOnStep,  
		PosDet4AOffStep => PosDet4AOffStep,
		PosDet5AOnStep => PosDet5AOnStep,  
		PosDet5AOffStep => PosDet5AOffStep,
		PosDet6AOnStep => PosDet6AOnStep,  
		PosDet6AOffStep => PosDet6AOffStep,
		PosDet7AOnStep => PosDet7AOnStep,  
		PosDet7AOffStep => PosDet7AOffStep,
		                                   
		PosDet0BOnStep => PosDet0BOnStep,  
		PosDet0BOffStep => PosDet0BOffStep,
		PosDet1BOnStep => PosDet1BOnStep,  
		PosDet1BOffStep => PosDet1BOffStep,
		PosDet2BOnStep => PosDet2BOnStep,  
		PosDet2BOffStep => PosDet2BOffStep,
		PosDet3BOnStep => PosDet3BOnStep,  
		PosDet3BOffStep => PosDet3BOffStep,
		PosDet4BOnStep => PosDet4BOnStep,  
		PosDet4BOffStep => PosDet4BOffStep,
		PosDet5BOnStep => PosDet5BOnStep,  
		PosDet5BOffStep => PosDet5BOffStep,
		PosDet6BOnStep => PosDet6BOnStep,  
		PosDet6BOffStep => PosDet6BOffStep,
		PosDet7BOnStep => PosDet7BOnStep,  
		PosDet7BOffStep => PosDet7BOffStep,
		
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
	
	----------------------------------------------------------------Monitor A/D--------------------------------------------------------------------
			
	--~ IBufnDrdyAdc : IBufP3Ports port map(clk => MasterClk, I => nDrdyMonitorAdc, O => nDrdyMonitorAdc_i); --if you want to change the pin for this chip select, it's here
	--~ IBufMisoAdc : IBufP3Ports port map(clk => MasterClk, I => MisoMonitorAdc, O => MisoMonitorAdc_i); --if you want to change the pin for this chip select, it's here
	
	--~ ltc244xaccumulator : ltc244xaccumulatorPorts
	--~ generic MAP
	--~ (
		--~ MASTER_CLOCK_FREQHZ => BoardMasterClockFreq,
		--~ LTC244X_DATARATE => "1111",
		--~ LTC244X_DOUBLERATE => '0'--,
	--~ )
	--~ port map
	--~ (
		--~ clk => MasterClk,
		--~ rst => MasterReset,
		--~ nDrdy => nDrdyMonitorAdc_i,
		--~ nCs => nCsMonitorAdc_i,
		--~ Sck => SckMonitorAdc_i,
		--~ Mosi => MosiMonitorAdc_i,
		--~ Miso => MisoMonitorAdc_i,
		--~ --Dbg1 => Txd0,
		--~ --Dbg2 => Txd1,
		--~ --InvalidStateReached => Txd2,
		--~ Dbg1 => open,
		--~ Dbg2 => open,
		--~ InvalidStateReached => open,
		--~ AdcChannelReadIndex => MonitorAdcChannel,
		--~ ReadAdcSample => MonitorAdcReadSample,
	    --~ --AdcSampleToRead => MonitorAdcSample--,	
        --~ AdcSampleToRead => Open--,
	--~ );
	
	--~ --Internal A/D control:
	--~ nCsMonitorAdc <= nCsMonitorAdc_i;
	--~ SckMonitorAdc <= SckMonitorAdc_i;
	--~ MosiMonitorAdc <= MosiMonitorAdc_i;
	
	----------------------------- RS-422 ----------------------------------
	
	Oe0 <= '1';
	Oe1 <= '1';
	Oe2 <= '1';
	
	--This is just to excercise the thing so it stays in the design...
	--~ Ux1SelJmp <= '1' when ( (Rxd1 = '1') and (Rxd2 = '0') ) else '0' when ( (Rxd1 = '0') and (Rxd2 = '1') ) else 'Z';

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
		--~ --Busy => Ux1SelJmp,
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
		Dbg1 => open,
		RxComplete => open,
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
		--~ BitClockOut => Ux1SelJmp,		
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
		Dbg1 => open,
		RxComplete => open,
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
	
	--~ Ux1SelJmp <= UartClk2;
	
	IBufRxd2 : IBufP3Ports port map(clk => UartClk, I => Rxd2, O => Rxd2_i); --if you want to change the pin for this chip select, it's here
	
	--~ Ux1SelJmp <= Rxd2;
	
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
		Dbg1 => open,
		RxComplete => open,
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
		--~ BitClockOut => Ux1SelJmp,		
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
	
	
	----------------------------- Timing ----------------------------------
	
		--Just sync external PPS to master clock
		--~ IBufPPS : IBufP2Ports port map(clk => MasterClk, I => PpsIn, O => PPS_i);
		
	--Count up MasterClocks per PPS so we can sync the oscilator to the GPS clock
	--~ PPSAccumulator : PPSCountPorts
    --~ port map
	--~ (
		--~ clk => MasterClk,
		--~ PPS => PPS_i,
		--~ PPSReset => PPSCountReset,
		--~ PPSCounter => PPSCounter,
		--~ PPSAccum => PPSCount--,
	--~ );
	
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
	
	--~ IBufDacMiso : IBufP2Ports port map(clk => MasterClk, I => MisoClk, O => MisoClk_i);

	--~ ClkDac_i : SpiDacPorts
	--~ generic map 
	--~ (
		--~ MASTER_CLOCK_FREQHZ => BoardMasterClockFreq,
		--~ BIT_WIDTH => 16
	--~ )
	--~ port map 
	--~ (
		--~ clk => MasterClk,
		--~ rst => MasterReset,
		--~ nCs => nCsClk_i,
		--~ Sck => SckClk_i,
		--~ Mosi => MosiClk_i,
		--~ Miso => MisoClk_i,
		--~ DacWriteOut => ClkDacWrite,
		--~ WriteDac => WriteClkDac,
		--~ DacReadback => ClkDacReadback
	--~ );

	--~ nCsClk <= nCsClk_i;
	--~ SckClk <= SckClk_i;
	--~ MosiClk <= MosiClk_i;
	
	----------------------------- Power Supplies ----------------------------------
	
	--~ HVPowernEn <= '0';
	--~ nHVEn <= '1';
	--~ AnalogPowernEn <= '0';
	
	--~ PowerSyncClockDivider : ClockDividerPorts generic map(CLOCK_DIVIDER => 96, DIVOUT_RST_STATE => '0') port map(clk => MasterClk, rst => MasterReset, div => PowerSync);

	--This just makes a synchronous clock out of the 2.5MHz clock to keep the dc/dc converter running on the same clockbase as everything else, and nice & slow so it's cool. LT3791 will accept 200-700kHz clocks.
	--~ SyncDCDCDivider : ClockDividerPorts
	--~ generic map (
		--~ --CLOCK_DIVIDER => 12, --208kHz
		--~ CLOCK_DIVIDER => 8, --312kHz
		--~ DIVOUT_RST_STATE => '0'
	--~ )
	--~ port map (		
		--~ clk => MasterClk,
		--~ rst => MasterReset,
		--~ --div => SyncDCD
        --~ div => Open
	--~ );	
	--~ --SyncDCDC <= 'Z'
	
	----------------------------- H-Bridge ----------------------------------
	
	--ShootThruIxnae is a 100nsec pulse reset & initiated by either edge of period; thus we must also gate on (Period_i = LastPeriod) to avoid a one-clock glitch while ShootThruIxnae is being reset
	  
	--"Prime" signals are the high-side FETs in the H-bridge and due to complex drive circuits take much longer to turn on and turn off! Therefore we wanna take our sweet time turning on the low-side drivers!
	
	--~ --just use the 100MHz clock: that's 10nsec, which is a 'long' time
	--~ ShootThruIxnae <= not(PeriodEdge);
	
	--SiCFETs show maybe 25nsec for transistion time, others are probably alot worse - use a clock divider to get 100nsec-type delays...
	ShootThruIxnaeOneShotAPlus : OneShotPorts
	generic map (
		CLOCK_FREQHZ => BoardMasterClockFreq,
		DELAY_SECONDS => 100.0E-9,
		SHOT_RST_STATE => '0',
		SHOT_PRETRIGGER_STATE => '0'--,
	)
	port map (	
		clk => MasterClk,
		rst => not(MotorAPlus_i), 
		shot => ShootThruIxnaeAPlus
	);
	ShootThruIxnaeOneShotAMinus : OneShotPorts
	generic map (
		CLOCK_FREQHZ => BoardMasterClockFreq,
		DELAY_SECONDS => 100.0E-9,
		SHOT_RST_STATE => '0',
		SHOT_PRETRIGGER_STATE => '0'--,
	)
	port map (	
		clk => MasterClk,
		rst => not(MotorAMinus_i), 
		shot => ShootThruIxnaeAMinus
	);
	ShootThruIxnaeOneShotBPlus : OneShotPorts
	generic map (
		CLOCK_FREQHZ => BoardMasterClockFreq,
		DELAY_SECONDS => 100.0E-9,
		SHOT_RST_STATE => '0',
		SHOT_PRETRIGGER_STATE => '0'--,
	)
	port map (	
		clk => MasterClk,
		rst => not(MotorBPlus_i), 
		shot => ShootThruIxnaeBPlus
	);
	ShootThruIxnaeOneShotBMinus : OneShotPorts
	generic map (
		CLOCK_FREQHZ => BoardMasterClockFreq,
		DELAY_SECONDS => 100.0E-9,
		SHOT_RST_STATE => '0',
		SHOT_PRETRIGGER_STATE => '0'--,
	)
	port map (	
		clk => MasterClk,
		rst => not(MotorBMinus_i), 
		shot => ShootThruIxnaeBMinus
	);

	StepperMotor : FourWireStepperMotorDriverPorts
	generic map (
		CLOCK_FREQHZ => BoardMasterClockFreq,
		MOTOR_STEP_SECONDS => 0.100	--;
	)
	port map (	
	
		clk => MasterClk,
		rst => ResetSteps,		
	
		--inputs
		SeekStep => MotorSeekStep,
		CurrentStep => MotorCurrentStep,
		
		--outputs
		MotorAPlus => MotorAPlus_i,
		MotorAMinus => MotorAMinus_i,
		MotorBPlus => MotorBPlus_i,
		MotorBMinus => MotorBMinus_i--,
	);

	--Low-side FETs
	--~ MotorDriveAPlus <= MotorAPlus_i;
	--~ MotorDriveAMinus <= MotorAMinus_i;
	--~ MotorDriveBPlus <= MotorBPlus_i;
	--~ MotorDriveBMinus <= MotorBMinus_i;
	MotorDriveAPlus <= PushPullHigh when ( (MotorEnable = '1') and (MotorAPlus_i = '1') and (ShootThruIxnaeAPlus = '1') ) else PushPullGround;
	MotorDriveAMinus <= PushPullHigh when ( (MotorEnable = '1') and (MotorAMinus_i = '1') and (ShootThruIxnaeAMinus = '1') ) else PushPullGround;
	MotorDriveBPlus <= PushPullHigh when ( (MotorEnable = '1') and (MotorBPlus_i = '1') and (ShootThruIxnaeBPlus = '1') ) else PushPullGround;
	MotorDriveBMinus <= PushPullHigh when ( (MotorEnable = '1') and (MotorBMinus_i = '1') and (ShootThruIxnaeBMinus = '1') ) else PushPullGround;
	
	--High-side FETs
	--~ MotorDriveAPlusPrime <= MotorAPlus_i;
	--~ MotorDriveAMinusPrime <= MotorAMinus_i;
	--~ MotorDriveBPlusPrime <= MotorBPlus_i;
	--~ MotorDriveBMinusPrime <= MotorBMinus_i;
	MotorDriveAPlusPrime <= PushPullHigh when ( (MotorEnable = '1') and (MotorAPlus_i = '1') ) else PushPullGround;
	MotorDriveAMinusPrime <= PushPullHigh when ( (MotorEnable = '1') and (MotorAMinus_i = '1') ) else PushPullGround;
	MotorDriveBPlusPrime <= PushPullHigh when ( (MotorEnable = '1') and (MotorBPlus_i = '1') ) else PushPullGround;
	MotorDriveBMinusPrime <= PushPullHigh when ( (MotorEnable = '1') and (MotorBMinus_i = '1') ) else PushPullGround;
	
	----------------------------- DEBUG IDEAS ----------------------------------
	
	Ux1SelJmp <= RamBusDataIn(0);
	
	--~ Ux1SelJmp <= MotorSeekStep(0);
	
	--~ Ux1SelJmp <= '1' when ( (Rxd1 = '1') and (Rxd2 = '0') ) else '0' when ( (Rxd1 = '0') and (Rxd2 = '1') ) else 'Z';
	
	--~ Ux1SelJmp <= MasterClk;
		
	--ClkDac
	nCsXO <= '1';
	SckXO <= '1';
	MosiXO <= '1';
	
	Txd3 <= Rxd3;
	Oe3 <= '1';
	
	RxdUsb <= TxdUsb;
	CtsUsb <= '1';
	
	TxdGps <= RxdGps and PPS;
	
	--MonitorA/D
	
	nCsMonAdc0 <= '1';
	SckMonAdc0 <= nDrdyMonAdc0;
	MosiMonAdc0 <= MisoMonAdc0;
	
	--  Discrete I/O Connections

		--Faults
		nFaultClr1V <= '1';
		nFaultClr3V <= '1';
		nFaultClr5V <= '1';
		nPowerCycClr <= '1';
		PowernEn5V <= '0';
		PowerSync <= '1';
		
		LedR <= '1';
		LedG <= '1';
		LedB <= '1';
		
		TP1 <= Fault1V;
		TP2 <= Fault3V;
		TP3 <= Fault5V;
		TP4 <= PowerCycd;
		TP5 <= '1';
		TP6 <= '1';
		TP7 <= '1';
		TP8 <= '1';
		
	----------------------------- Clocked Logic / Main Loop ----------------------------------
	
	process(MasterClk)
	begin
	
		if ( (MasterClk'event) and (MasterClk = '1') ) then
		
			--Run position detector logic:
		
			if (LastPosSenseHomeA /= PosSenseHomeA) then LastPosSenseHomeA <= PosSenseHomeA; if (PosSenseHomeA = '1') then PosDetHomeAOnStep <= MotorCurrentStep; else PosDetHomeAOffStep <= MotorCurrentStep; end if; end if;
			if (LastPosSenseBit0A /= PosSenseBit0A) then LastPosSenseBit0A <= PosSenseBit0A; if (PosSenseBit0A = '1') then PosDetA0OnStep <= MotorCurrentStep; else PosDetA0OffStep <= MotorCurrentStep; end if; end if;
			if (LastPosSenseBit1A /= PosSenseBit1A) then LastPosSenseBit1A <= PosSenseBit1A; if (PosSenseBit1A = '1') then PosDetA1OnStep <= MotorCurrentStep; else PosDetA1OffStep <= MotorCurrentStep; end if; end if;
			if (LastPosSenseBit2A /= PosSenseBit2A) then LastPosSenseBit2A <= PosSenseBit2A; if (PosSenseBit2A = '1') then PosDetA2OnStep <= MotorCurrentStep; else PosDetA2OffStep <= MotorCurrentStep; end if; end if;
			
			if (LastPosSenseHomeB /= PosSenseHomeB) then LastPosSenseHomeB <= PosSenseHomeB; if (PosSenseHomeB = '1') then PosDetHomeBOnStep <= MotorCurrentStep; else PosDetHomeBOffStep <= MotorCurrentStep; end if; end if;
			if (LastPosSenseBit0B /= PosSenseBit0B) then LastPosSenseBit0B <= PosSenseBit0B; if (PosSenseBit0B = '1') then PosDetB0OnStep <= MotorCurrentStep; else PosDetB0OffStep <= MotorCurrentStep; end if; end if;
			if (LastPosSenseBit1B /= PosSenseBit1B) then LastPosSenseBit1B <= PosSenseBit1B; if (PosSenseBit1B = '1') then PosDetB1OnStep <= MotorCurrentStep; else PosDetB1OffStep <= MotorCurrentStep; end if; end if;
			if (LastPosSenseBit2B /= PosSenseBit2B) then LastPosSenseBit2B <= PosSenseBit2B; if (PosSenseBit2B = '1') then PosDetB2OnStep <= MotorCurrentStep; else PosDetB2OffStep <= MotorCurrentStep; end if; end if;
			
			PosSenseA <= PosSenseBit2A & PosSenseBit1A & PosSenseBit0A & PosSenseHomeA;
			PosSenseB <= PosSenseBit2B & PosSenseBit1B & PosSenseBit0B & PosSenseHomeB;
			
			--Not sure if these will be useful due to hysteresis/jitter, but we'll see, light & capacitor may smooth things out
			
			if (ResetSteps = '1') then
			
				PosDet0AOnStep <= x"0000"; 
				PosDet1AOnStep <= x"0000";
				PosDet2AOnStep <= x"0000";
				PosDet3AOnStep <= x"0000";
				PosDet4AOnStep <= x"0000";
				PosDet5AOnStep <= x"0000";
				PosDet6AOnStep <= x"0000";
				PosDet7AOnStep <= x"0000";

				PosDet0AOffStep <= x"0000";
				PosDet1AOffStep <= x"0000";
				PosDet2AOffStep <= x"0000";
				PosDet3AOffStep <= x"0000";
				PosDet4AOffStep <= x"0000";
				PosDet5AOffStep <= x"0000";
				PosDet6AOffStep <= x"0000";
				PosDet7AOffStep <= x"0000";

				PosDet0BOnStep <= x"0000";
				PosDet1BOnStep <= x"0000";
				PosDet2BOnStep <= x"0000";
				PosDet3BOnStep <= x"0000";
				PosDet4BOnStep <= x"0000";
				PosDet5BOnStep <= x"0000";
				PosDet6BOnStep <= x"0000";
				PosDet7BOnStep <= x"0000";

				PosDet0BOffStep <= x"0000";
				PosDet1BOffStep <= x"0000";
				PosDet2BOffStep <= x"0000";
				PosDet3BOffStep <= x"0000";
				PosDet4BOffStep <= x"0000";
				PosDet5BOffStep <= x"0000";
				PosDet6BOffStep <= x"0000";
				PosDet7BOffStep <= x"0000";
			
			else
			
				if (LastPosSenseA /= PosSenseA) then
				
					LastPosSenseA <= PosSenseA;
					
					case PosSenseA is
						
						when "0001" => PosDet0AOnStep <= MotorCurrentStep; 
						when "0010" => PosDet1AOnStep <= MotorCurrentStep;
						when "0100" => PosDet2AOnStep <= MotorCurrentStep;
						when "0110" => PosDet3AOnStep <= MotorCurrentStep;
						when "1000" => PosDet4AOnStep <= MotorCurrentStep;
						when "1010" => PosDet5AOnStep <= MotorCurrentStep;
						when "1100" => PosDet6AOnStep <= MotorCurrentStep;
						when "1110" => PosDet7AOnStep <= MotorCurrentStep;
                        when others =>
						
					end case;
					
					case LastPosSenseA is
						
						when "0001" => PosDet0AOffStep <= MotorCurrentStep;
						when "0010" => PosDet1AOffStep <= MotorCurrentStep;
						when "0100" => PosDet2AOffStep <= MotorCurrentStep;
						when "0110" => PosDet3AOffStep <= MotorCurrentStep;
						when "1000" => PosDet4AOffStep <= MotorCurrentStep;
						when "1010" => PosDet5AOffStep <= MotorCurrentStep;
						when "1100" => PosDet6AOffStep <= MotorCurrentStep;
						when "1110" => PosDet7AOffStep <= MotorCurrentStep;
                        when others =>
						
					end case;
					
				end if;
				
				if (LastPosSenseB /= PosSenseB) then
				
					LastPosSenseB <= PosSenseB;
					
					case PosSenseB is
						
						when "0001" => PosDet0BOnStep <= MotorCurrentStep;
						when "0010" => PosDet1BOnStep <= MotorCurrentStep;
						when "0100" => PosDet2BOnStep <= MotorCurrentStep;
						when "0110" => PosDet3BOnStep <= MotorCurrentStep;
						when "1000" => PosDet4BOnStep <= MotorCurrentStep;
						when "1010" => PosDet5BOnStep <= MotorCurrentStep;
						when "1100" => PosDet6BOnStep <= MotorCurrentStep;
						when "1110" => PosDet7BOnStep <= MotorCurrentStep;
						when others =>
                        
					end case;
					
					case LastPosSenseB is
						
						when "0001" => PosDet0BOffStep <= MotorCurrentStep;
						when "0010" => PosDet1BOffStep <= MotorCurrentStep;
						when "0100" => PosDet2BOffStep <= MotorCurrentStep;
						when "0110" => PosDet3BOffStep <= MotorCurrentStep;
						when "1000" => PosDet4BOffStep <= MotorCurrentStep;
						when "1010" => PosDet5BOffStep <= MotorCurrentStep;
						when "1100" => PosDet6BOffStep <= MotorCurrentStep;
						when "1110" => PosDet7BOffStep <= MotorCurrentStep;
                        when others =>
						
					end case;
					
				end if;
				
			end if;
			
		end if;		

	end process;

	
end architecture_Main;

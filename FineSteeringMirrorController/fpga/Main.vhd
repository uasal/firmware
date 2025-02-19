--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--~ use work.ads1258.all;
--~ use work.ads1258accumulator_pkg.all;

entity Main is
port (

    clk : in  std_logic;
	
	--ClkDac
	
	nCsXO : out std_logic;
	SckXO : out std_logic;
	MosiXO : out std_logic;
	
	--D/A's
	
	MosiTiDacA : inout std_logic;
	MosiTiDacB : inout std_logic;
	MosiTiDacC : inout std_logic;
	MosiTiDacD : inout std_logic;
	SckTiDacs : inout std_logic;
	nCsTiDacs : inout std_logic;
	PowerEnTi : out std_logic;
	
	MosiMaxDacA : inout std_logic;
	MosiMaxDacB : inout std_logic;
	MosiMaxDacC : inout std_logic;
	MosiMaxDacD : inout std_logic;
	SckMaxDacs : inout std_logic;
	nCsMaxDacs : inout std_logic;
	nLoadMaxDacs : inout std_logic;
	PowerEnMax : out std_logic;
	
	--Driver Control
	
	HVEn1 : out std_logic;
	HVEn2 : out std_logic;
	PowernEnHV : out std_logic;	
	nHVFaultA : in std_logic;
	nHVFaultB : in std_logic;
	nHVFaultC : in std_logic;
	nHVFaultD : in std_logic;
	
	--A/D's
	
	ChopRef : out std_logic;
	ChopAdcs : out std_logic;
	TrigAdcs : out std_logic;	
	SckAdcs : out std_logic;
	nCsAdcs : out std_logic;
	MisoAdcA : in std_logic;
	MisoAdcB : in std_logic;
	MisoAdcC : in std_logic;
	MisoAdcD : in std_logic;
	nDrdyAdcA : in std_logic;
	nDrdyAdcB : in std_logic;
	nDrdyAdcC : in std_logic;
	nDrdyAdcD : in std_logic;
	
	--uC Ram Bus 
	
	RamBusAddress : in std_logic_vector(9 downto 0); 
	RamBusDataIn : in std_logic_vector(31 downto 0);
	RamBusDataOut : out std_logic_vector(31 downto 0);
	RamBusnCs : in std_logic;
	RamBusWrnRd : in std_logic;
	RamBusLatch : in std_logic;
	RamBusAck : out std_logic;
	
	--RS-422
	
	Tx0 : out std_logic;
	Oe0 : out std_logic;
	Rx0 : in std_logic;
	Tx1 : out std_logic;
	Oe1 : out std_logic;
	Rx1 : in std_logic;
	Tx2 : out std_logic;
	Oe2 : out std_logic;
	Rx2 : in std_logic;
	Tx3 : out std_logic;
	Oe3 : out std_logic;
	Rx3 : in std_logic;
	PPS : in std_logic;
	
	--MonitorA/D
	
	nCsMonAdcs : out std_logic;
	SckMonAdcs : out std_logic;
	MosiMonAdcs : out std_logic;
	TrigMonAdcs : out std_logic;
	MisoMonAdc0 : in std_logic;
	nDrdyMonAdc0 : in std_logic;
	MisoMonAdc1 : in std_logic;
	nDrdyMonAdc1 : in std_logic;

	--Power Supplies
	
	PowerSync : out std_logic;
	PowernEn : out std_logic;
	GlobalFaultInhibit : out std_logic;
	nFaultsClr : out std_logic;
	nPowerCycClr : out std_logic;
	PowerCycd: in std_logic;
	
	--Faults
	
	FaultNegV : in std_logic;
	Fault1V : in std_logic;
	Fault2VA : in std_logic;
	Fault2VD : in std_logic;
	Fault3VA : in std_logic;
	Fault3VD : in std_logic;
	Fault43V : in std_logic;
	Fault5V : in std_logic;
	FaultHV : in std_logic;
	
	--Testpoints
	
	TP1 : out std_logic;
	TP2 : out std_logic;
	TP3 : out std_logic;
	TP4 : out std_logic;
	TP5 : out std_logic;
	TP6 : out std_logic;
	TP7 : out std_logic;
	TP8 : out std_logic;
	
	Ux1SelJmp : inout std_logic--;
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
							PPSDetected : out std_logic;
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
							BitCountOut : out std_logic_vector(3 downto 0);
							
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
							Address : in std_logic_vector(ADDRESS_BITS - 1 downto 0); -- vhdl can't figure out that ADDRESS_BITS is a constant because it's in a generic map...
							DataIn : in std_logic_vector(31 downto 0);
							DataOut : out std_logic_vector(31 downto 0);
							ReadReq : in  std_logic;
							WriteReq : in std_logic;
							ReadAck : out std_logic;
							WriteAck : out std_logic;
							
							--Data to access:			

							--Infrastructure
							SerialNumber : in std_logic_vector(31 downto 0);
							BuildNumber : in std_logic_vector(31 downto 0);
							
							--Faults and control
							HVEn1 : out std_logic;
							HVEn2 : out std_logic;
							PowernEnHV : out std_logic;	
							DacSelectMaxti : out std_logic;
							FaultNegV : in std_logic;
							Fault1V : in std_logic;
							Fault2VA : in std_logic;
							Fault2VD : in std_logic;
							Fault3VA : in std_logic;
							Fault3VD : in std_logic;
							Fault43V : in std_logic;
							Fault5V : in std_logic;
							FaultHV : in std_logic;
							nHVFaultA : in std_logic;
							nHVFaultB : in std_logic;
							nHVFaultC : in std_logic;
							nHVFaultD : in std_logic;
							GlobalFaultInhibit : out std_logic;
							nFaultsClr : out std_logic;
							PowerCycd : in std_logic;
							nPowerCycClr : out std_logic;								
							PowernEn : out std_logic;
							Uart0OE : out std_logic;
							Uart1OE : out std_logic;
							Uart2OE : out std_logic;
							Uart3OE : out std_logic;				
							Ux1SelJmp : out std_logic;
							
							--FSM D/A's
							DacASetpoint : out std_logic_vector(23 downto 0);
							DacBSetpoint : out std_logic_vector(23 downto 0);
							DacCSetpoint : out std_logic_vector(23 downto 0);
							DacDSetpoint : out std_logic_vector(23 downto 0);
							WriteDacs : out std_logic;
							DacAReadback : in std_logic_vector(23 downto 0);
							DacBReadback : in std_logic_vector(23 downto 0);
							DacCReadback : in std_logic_vector(23 downto 0);	
							DacDReadback : in std_logic_vector(23 downto 0);	
							DacTransferComplete : in std_logic;

							-- FSM Readback A/Ds
							ReadAdcSample : out std_logic;
							AdcSampleToReadA : in std_logic_vector(47 downto 0);	
							AdcSampleToReadB : in std_logic_vector(47 downto 0);	
							AdcSampleToReadC : in std_logic_vector(47 downto 0);	
							AdcSampleToReadD : in std_logic_vector(47 downto 0);	
							AdcSampleNumAccums : in std_logic_vector(15 downto 0);	
							
							--Monitor A/D:
							MonitorAdcChannelReadIndex : out std_logic_vector(4 downto 0);
							ReadMonitorAdcSample : out std_logic;
							MonitorAdcSampleToRead : in std_logic_vector(63 downto 0);
							MonitorAdcReset : out std_logic;
							MonitorAdcSpiDataIn : out std_logic_vector(7 downto 0);
							MonitorAdcSpiDataOut0 : in std_logic_vector(7 downto 0);
							MonitorAdcSpiDataOut1 : in std_logic_vector(7 downto 0);
							MonitorAdcSpiXferStart : out std_logic;
							MonitorAdcSpiXferDone : in std_logic;
							MonitorAdcnDrdy0  : in std_logic;
							MonitorAdcnDrdy1  : in std_logic;
							MonitorAdcSpiFrameEnable : out std_logic;
							
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
							
							Uart3FifoReset : out std_logic;
							ReadUart3 : out std_logic;
							Uart3RxFifoFull : in std_logic;
							Uart3RxFifoEmpty : in std_logic;
							Uart3RxFifoData : in std_logic_vector(7 downto 0);
							Uart3RxFifoCount : in std_logic_vector(9 downto 0);
							WriteUart3 : out std_logic;
							Uart3TxFifoFull : in std_logic;
							Uart3TxFifoEmpty : in std_logic;
							Uart3TxFifoData : out std_logic_vector(7 downto 0);
							Uart3TxFifoCount : in std_logic_vector(9 downto 0);
							Uart3ClkDivider : out std_logic_vector(7 downto 0);
							
							--Timing
							IdealTicksPerSecond : in std_logic_vector(31 downto 0);
							ActualTicksLastSecond : in std_logic_vector(31 downto 0);
							ClockTicksThisSecond : in std_logic_vector(31 downto 0);
							PPSCountReset : out std_logic;		
							PPSDetected : in std_logic;
							ClkDacWrite : out std_logic_vector(15 downto 0);
							WriteClkDac : out std_logic;
							ClkDacReadback : in std_logic_vector(15 downto 0)--;
						);
						end component;
						
						--~ component ads1258Ports is
						--~ generic (
							--~ MASTER_CLOCK_FREQHZ : natural := 10000000--;
						--~ );
						--~ port (
						
							--~ clk : in std_logic;
							--~ rst : in std_logic;
							
							--~ -- A/D:
							--~ nDrdy : in std_logic;
							--~ nCsAdc : out std_logic;
							--~ Sck : out std_logic;
							--~ Mosi : out  std_logic;
							--~ Miso : in  std_logic;		
							
							--~ --Raw, Basic Spi Xfers
							--~ SpiDataIn : in std_logic_vector(7 downto 0);
							--~ SpiDataOut : out std_logic_vector(7 downto 0);
							--~ SpiXferStart : in std_logic;
							--~ SpiXferDone : out std_logic;
							
							--~ -- Bus / Fifos:
							--~ Sample : out ads1258sample;
							--~ SampleLatched : out std_logic;		
							--~ TimestampReq : out std_logic--;				
						--~ );
						--~ end component;
						
						--~ component ads1258accumulatorPorts is
						--~ port 
						--~ (
							--~ clk : in std_logic;
							--~ rst : in std_logic;
							
							--~ -- From A/D
							--~ AdcSampleIn : in ads1258sample;
							--~ AdcSampleLatched : in std_logic;		
							--~ AdcChannelLatched : out std_logic_vector(4 downto 0);
							
							--~ -- To Datamapper
							--~ AdcChannelReadIndex : in std_logic_vector(4 downto 0);
							--~ ReadAdcSample : in std_logic;		
							--~ AdcSampleToRead : out ads1258accumulator--;
						--~ );
						--~ end component;
						
						component SpiDeviceDualPorts is
						generic (
							CLOCK_DIVIDER : natural := 4;
							BIT_WIDTH : natural := 8;
							CPOL : std_logic := '0'; --'standard' spi knob - inverts clock polarity (0 seems to be the standard, 1 less common)
							CPHA : std_logic := '0'--; --'standard' spi knob - inverts clock phase (0 seems to be the standard, 1 less common)
						);
						port (
						
							--Globals
							clk : in std_logic;
							rst : in std_logic;
							
							-- D/A:
							nCs : out std_logic;
							Sck : out std_logic;
							MosiA : out  std_logic;
							MosiB : out  std_logic;
							MisoA : in  std_logic;
							MisoB : in  std_logic;
							
							--Control signals
							WriteOutA : in std_logic_vector(BIT_WIDTH - 1 downto 0);
							WriteOutB : in std_logic_vector(BIT_WIDTH - 1 downto 0);
							Transfer : in std_logic;
							ReadbackA : out std_logic_vector(BIT_WIDTH - 1 downto 0);
							ReadbackB : out std_logic_vector(BIT_WIDTH - 1 downto 0);
							TransferComplete : out std_logic--;
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
						
						component Ltc2378AccumQuadPorts is
						port (
						
							--Globals
							clk : in std_logic;
							rst : in std_logic;
							
							-- A/D:
							Trigger : out std_logic; --rising edge initiates a conversion; 20ns min per hi/lo, so 
							nDrdyA : in std_logic; --Falling edge indicates a new sample is ready, should be approx 1usec after trigger goes high (1MHz)
							nDrdyB : in std_logic; --Falling edge indicates a new sample is ready, should be approx 1usec after trigger goes high (1MHz)
							nDrdyC : in std_logic; --Falling edge indicates a new sample is ready, should be approx 1usec after trigger goes high (1MHz)
							nDrdyD : in std_logic; --Falling edge indicates a new sample is ready, should be approx 1usec after trigger goes high (1MHz)
							nCsA : out std_logic; -- 18th bit (msb) of data valid on falling edge.
							nCsB : out std_logic; -- 18th bit (msb) of data valid on falling edge.
							nCsC : out std_logic; -- 18th bit (msb) of data valid on falling edge.
							nCsD : out std_logic; -- 18th bit (msb) of data valid on falling edge.
							Sck : out std_logic; --can run up to ~100MHz (">40MHz??); idle in low state
							MisoA : in  std_logic; --valid 16nsec after nCs low; shifts on rising edge of sck, sample when sck low.		
							MisoB : in  std_logic; --valid 16nsec after nCs low; shifts on rising edge of sck, sample when sck low.		
							MisoC : in  std_logic; --valid 16nsec after nCs low; shifts on rising edge of sck, sample when sck low.		
							MisoD : in  std_logic; --valid 16nsec after nCs low; shifts on rising edge of sck, sample when sck low.		
							OverRangeA : out std_logic; --is the A/D saturated?
							OverRangeB : out std_logic; --is the A/D saturated?
							OverRangeC : out std_logic; --is the A/D saturated?
							OverRangeD : out std_logic; --is the A/D saturated?
						
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
							AdcSampleToReadD : out std_logic_vector(47 downto 0);	
							AdcSampleNumAccums : out std_logic_vector(15 downto 0);
							
							--Debug
							TP1 : out std_logic;
							TP2 : out std_logic;
							TP3 : out std_logic;
							TP4 : out std_logic--;
						); 
						end component;
												
						component SpiDacQuadPorts is
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
							nCsD : out std_logic;
							Sck : out std_logic;
							MosiA : out  std_logic;
							MosiB : out  std_logic;
							MosiC : out  std_logic;
							MosiD : out  std_logic;
							MisoA : in  std_logic;
							MisoB : in  std_logic;
							MisoC : in  std_logic;
							MisoD : in  std_logic;
							
							--Control signals
							WriteDac : in std_logic;
							DacWriteOutA : in std_logic_vector(23 downto 0);
							DacWriteOutB : in std_logic_vector(23 downto 0);
							DacWriteOutC : in std_logic_vector(23 downto 0);
							DacWriteOutD : in std_logic_vector(23 downto 0);
							DacReadbackA : out std_logic_vector(23 downto 0);
							DacReadbackB : out std_logic_vector(23 downto 0);
							DacReadbackC : out std_logic_vector(23 downto 0);
							DacReadbackD : out std_logic_vector(23 downto 0);
							TransferComplete : out std_logic--;
							
						); end component;
						
						
						component SpiExtBusAddrTxPorts is
						generic 
						(
							MASTER_CLOCK_FREQHZ : natural := 10000000--; --The input clock
						);
						port 
						(
							clk : in std_logic;
							rst : in std_logic;
							SpiExtBusAddr : in std_logic_vector(7 downto 0);
							SendSpiExtBusAddr : in std_logic;
							SendingSpiExtBusAddr : out std_logic;
							SpiExtBusAddrTxdPin : out std_logic--;
						);
						end component;
						
						component SpiExtBusPorts is
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
							SpiExtBusWriteOut : in std_logic_vector(7 downto 0);
							WriteSpiExtBus : in std_logic;
							SpiExtBusReadReady : out std_logic;
							SpiExtBusReadback : out std_logic_vector(7 downto 0)--;
								
						); end component;
						


						
--Constants & Setup
	

	--Clocks
			
		--~ constant BaseClockFreq : natural := 16777216; --new xtal (256Hz Fs)
		--~ constant ClockFreqMultiplier : natural := 5; --Xilinx says it won't run at 100MHz (x6) as currently written (prob. the accumulator). x4=67MHz, x5=84MHz
		--~ constant BaseClockPeriod : real := 59.6; --really should be exactly 1 / conv_real(BaseClockFreq), but it's just used by DCM clock library, and conv_real doesn't exist.
		--~ constant BoardMasterClockFreq : natural := BaseClockFreq * ClockFreqMultiplier; 
		
		constant BoardMasterClockFreq : natural := 102000000; -- --102.0 clock
		--~ constant BoardUartClockFreq : natural := 136000000;
		constant BoardUartClockFreq : natural := 102000000;
		--~ constant BoardMasterClockFreq : natural := 153000000; -- --102.0 clock
		signal MasterClk : std_logic; --This is the main clock for *everything*
		signal UartClk : std_logic; --This is the uart clock, it runs at 136MHz, and a lot of the regular logic won't run that fast, which is why we have a seperate clock. In practice, it immediately gets divided by 16 ny the uarts so it actually is slower than the other logic, but at a weird ratio...
		--~ constant UartClockFreqMultiplier : natural := 7; --15/17 is also a good scaler, and uart dividers come out just over ideal instead of under, so integer math works on them...
		--~ constant UartClockFreqDivider : natural := 8;
		--~ constant UartClockPeriod : real := 68.1; --really should be exactly 1 / conv_real(UartBaseClockFreq), but it's just used by DCM clock library, and conv_real doesn't exist.
		--~ constant UartClockFreq : natural := BaseClockFreq * UartClockFreqMultiplier / UartClockFreqDivider; -- 14.6802MHz (14.7456 ideal; 0.44% dev)

		--FPGA internal
		
			signal MasterReset : std_logic; --Our power-on-reset signal for everything
			signal SerialNumber : std_logic_vector(31 downto 0); --This is a xilinx proprietary toy that we use as the serial number, it's supposed to be unique on each board
			signal BuildNumber : std_logic_vector(31 downto 0); --How many attempts got us to this particular version of the firmware?
		
		-- Ram bus
						
			signal RamBusLatch_i : std_logic;		
			signal RamBusCE_i : std_logic;		
			signal RamBusWrnRd_i : std_logic;		
			signal RamBusAddress_i : std_logic_vector(9 downto 0);		
			signal RamDataOut : std_logic_vector(31 downto 0);		
			signal RamDataIn : std_logic_vector(31 downto 0);		
			signal RamBusAck_i : std_logic;					
			
		-- Register space
		
			signal DataToWrite : std_logic_vector(31 downto 0);
			signal WriteReq : std_logic;
			signal WriteAck : std_logic;
			signal DataFromRead : std_logic_vector(31 downto 0);
			signal ReadReq : std_logic;
			signal ReadAck : std_logic;
			
		-- FSM D/As
		
			signal DacSelectMaxti : std_logic;	
			signal nCsDacA_i : std_logic;	
			signal nCsDacB_i : std_logic;	
			signal nCsDacC_i : std_logic;	
			signal nCsDacD_i : std_logic;	
			signal SckDacs_i : std_logic;	
			signal MosiDacA_i : std_logic;	
			signal MosiDacB_i : std_logic;	
			signal MosiDacC_i : std_logic;	
			signal MosiDacD_i : std_logic;	
			signal MisoDacA_i : std_logic;	
			signal MisoDacB_i : std_logic;	
			signal MisoDacC_i : std_logic;	
			signal MisoDacD_i : std_logic;	
			signal DacASetpoint : std_logic_vector(23 downto 0);	
			signal DacBSetpoint : std_logic_vector(23 downto 0);	
			signal DacCSetpoint : std_logic_vector(23 downto 0);	
			signal DacDSetpoint : std_logic_vector(23 downto 0);	
			signal WriteDacs : std_logic;	
			signal DacAReadback : std_logic_vector(23 downto 0);	
			signal DacBReadback : std_logic_vector(23 downto 0);	
			signal DacCReadback : std_logic_vector(23 downto 0);	
			signal DacDReadback : std_logic_vector(23 downto 0);	
			signal nLDacs_i : std_logic;	
			signal DacTransferComplete : std_logic;	
			
			
		-- FSM Readback A/Ds
			
			signal TrigAdcs_i : std_logic;	
			signal nDrdyAdcA_i : std_logic;	
			signal nDrdyAdcB_i : std_logic;	
			signal nDrdyAdcC_i : std_logic;	
			signal nDrdyAdcD_i : std_logic;	
			signal SckAdcs_i : std_logic;	
			signal MisoAdcA_i : std_logic;	
			signal MisoAdcB_i : std_logic;	
			signal MisoAdcC_i : std_logic;	
			signal MisoAdcD_i : std_logic;	
			signal nCsAdcA_i : std_logic;	
			signal nCsAdcB_i : std_logic;	
			signal nCsAdcC_i : std_logic;	
			signal nCsAdcD_i : std_logic;	
			signal ReadAdcSample : std_logic;
			signal AdcSampleToReadA : std_logic_vector(47 downto 0);	
			signal AdcSampleToReadB : std_logic_vector(47 downto 0);	
			signal AdcSampleToReadC : std_logic_vector(47 downto 0);	
			signal AdcSampleToReadD : std_logic_vector(47 downto 0);	
			signal AdcSampleNumAccums : std_logic_vector(15 downto 0);	
			signal ChopperMuxPos_i : std_logic;
			signal ChopperMuxNeg_i : std_logic;			
			
			
		--Monitor A/D
		
			signal nDrdyMonitorAdc0_i : std_logic;
			signal nDrdyMonitorAdc1_i : std_logic;
			signal nCsMonitorAdc_i : std_logic;
			signal SckMonitorAdc_i : std_logic;
			signal MosiMonitorAdc_i : std_logic;
			signal MisoMonitorAdc0_i : std_logic;
			signal MisoMonitorAdc1_i : std_logic;
			signal MonitorAdcChannel : std_logic_vector(4 downto 0);
			signal MonitorAdcReadSample : std_logic;
			--~ signal MonitorAdcSample : ltc244xaccumulator;
			--~ signal MonitorAdcSample : ads1258accumulator;			
			signal MonitorAdcSample : std_logic_vector(63 downto 0);
			signal MonitorAdcReset : std_logic;
			signal MonitorAdcReset_i : std_logic;			
			signal MonitorAdcSpiDataIn : std_logic_vector(7 downto 0);
			signal MonitorAdcSpiDataOut0 : std_logic_vector(7 downto 0);
			signal MonitorAdcSpiDataOut1 : std_logic_vector(7 downto 0);
			signal MonitorAdcSpiXferStart : std_logic;
			signal MonitorAdcSpiXferDone : std_logic;
			signal MonitorAdcSpiFrameEnable : std_logic;
			
		--RS-422
		
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
			
			signal Uart3FifoReset : std_logic;
			signal Uart3FifoReset_i : std_logic;
			signal ReadUart3 : std_logic;
			signal Uart3RxFifoFull : std_logic;
			signal Uart3RxFifoEmpty : std_logic;
			signal Uart3RxFifoReadAck : std_logic;
			signal Uart3RxFifoData : std_logic_vector(7 downto 0);
			signal Uart3RxFifoCount : std_logic_vector(9 downto 0);
			signal WriteUart3 : std_logic;
			signal Uart3TxFifoFull : std_logic;
			signal Uart3TxFifoEmpty : std_logic;
			signal Uart3TxFifoData : std_logic_vector(7 downto 0);
			signal Uart3TxFifoCount : std_logic_vector(9 downto 0);
			signal Uart3ClkDivider : std_logic_vector(7 downto 0);
			signal UartClk3 : std_logic;			
			signal UartTxClk3 : std_logic;			
			signal Txd3_i : std_logic;
			signal Rxd3_i : std_logic;
			signal UartRx3Dbg : std_logic;		

			signal TxdUartBitCount : std_logic_vector(3 downto 0); --debug
			
		-- Timing
		
			signal PPS_i : std_logic;	
			signal PPSCountReset : std_logic; --generated by register read
			signal PPSDetected : std_logic; --are edges occuring on PPS?  Mainly used by rtc to decide wether to roll the clock over on it's own or let PPS sync it
			signal PPSCount : std_logic_vector(31 downto 0) := x"00000000"; --How many MasterClocks have gone by since the last PPS edge (so we can phase-lock oscillator to GPS time)
			signal PPSCounter : std_logic_vector(31 downto 0) := x"00000000"; --This one is the current count for this second, not the total for the last second...
			signal ClkDacWrite : std_logic_vector(15 downto 0) := x"0000";
			signal WriteClkDac : std_logic;
			signal ClkDacReadback : std_logic_vector(15 downto 0);
			signal nCsXO_i : std_logic;
			signal SckXO_i : std_logic;
			signal MosiXO_i : std_logic;
			signal MisoXO_i : std_logic;

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

		--~ IBufLatch : IBufP2Ports port map(clk => MasterClk, I => RamBusLatch, O => RamBusLatch_i);
		IBufCE : IBufP2Ports port map(clk => MasterClk, I => RamBusnCs, O => RamBusCE_i);
		IBufWrnRd : IBufP2Ports port map(clk => MasterClk, I => RamBusWrnRd, O => RamBusWrnRd_i);

		GenRamAddrBus: for i in 0 to 9 generate
		begin
			IBUF_RamAddr_i : IBufP1Ports
			port map (
				clk => MasterClk,
				I => RamBusAddress(i),
				O => RamBusAddress_i(i)--,
			); 
		end generate;
		
		GenRamDataBus: for i in 0 to 31 generate
		begin
			IBUF_RamData_i : IBufP1Ports
			port map (
				clk => MasterClk,
				I => RamBusDataIn(i),
				O => RamDataIn(i)--,
			);
			
			RamBusDataOut(i) <= RamDataOut(i);
		end generate;
		
	DataToWrite <= RamDataIn;
	WriteReq <= '1' when ( (RamBusCE_i = '1') and (RamBusWrnRd_i = '1') ) else '0';
	RamDataOut <= DataFromRead;
    ReadReq <= '1' when ( (RamBusCE_i = '1') and (RamBusWrnRd_i = '0') ) else '0';
	RamBusAck_i <= ReadAck or WriteAck;
	RamBusAck <= RamBusAck_i;
	
	--~ TP1 <= RamBusCE_i;
	--~ TP2 <= RamBusLatch_i;
	--~ TP3 <= RamBusDataIn(0);
	--~ TP4 <= RamBusWrnRd_i;
	--~ TP5 <= WriteReq;
	--~ TP6 <= ReadAck;
	--~ TP7 <= ReadReq;
	--~ TP8 <= RamBusAck_i;
	
	
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
		
		--Faults and control
		HVEn1 => HVEn1,
		HVEn2 => HVEn2,
		PowernEnHV => PowernEnHV,
		DacSelectMaxti => DacSelectMaxti,
		FaultNegV => FaultNegV,
		Fault1V => Fault1V,
		Fault2VA => Fault2VA,
		Fault2VD => Fault2VD,
		Fault3VA => Fault3VA,
		Fault3VD => Fault3VD,
		Fault43V => Fault43V,
		Fault5V => Fault5V,
		FaultHV => FaultHV,
		nHVFaultA => nHVFaultA,
		nHVFaultB => nHVFaultB,
		nHVFaultC => nHVFaultC,
		nHVFaultD => nHVFaultD,
		GlobalFaultInhibit => GlobalFaultInhibit,
		nFaultsClr => nFaultsClr,
		PowernEn => PowernEn,
		PowerCycd => PowerCycd,
		nPowerCycClr => nPowerCycClr,
		Uart0OE => OE0,
		Uart1OE => OE1,
		Uart2OE => OE2,
		Uart3OE => OE3,
		--~ Ux1SelJmp => Ux1SelJmp,
		Ux1SelJmp => open,
				
		--FSM D/A's
		DacASetpoint => DacASetpoint,
		DacBSetpoint => DacBSetpoint,
		DacCSetpoint => DacCSetpoint,
		DacDSetpoint => DacDSetpoint,
		WriteDacs => WriteDacs,
		DacAReadback => DacAReadback,
		DacBReadback => DacBReadback,
		DacCReadback => DacCReadback,
		DacDReadback => DacDReadback,
		--~ DacAReadback => DacASetpoint,
		--~ DacBReadback => DacBSetpoint,
		--~ DacCReadback => DacCSetpoint--,
		DacTransferComplete => DacTransferComplete,
		
		--FSM A/D's
		ReadAdcSample => ReadAdcSample,
		AdcSampleToReadA => AdcSampleToReadA,
		AdcSampleToReadB => AdcSampleToReadB,
		AdcSampleToReadC => AdcSampleToReadC,
		AdcSampleToReadD => AdcSampleToReadD,
		AdcSampleNumAccums => AdcSampleNumAccums,
		
		--Monitor A/D
		MonitorAdcChannelReadIndex => MonitorAdcChannel,
		ReadMonitorAdcSample => MonitorAdcReadSample,
		--~ MonitorAdcSampleToRead => ltc244xaccum_to_std_logic(MonitorAdcSample),
		MonitorAdcSampleToRead => MonitorAdcSample,
		MonitorAdcReset => MonitorAdcReset,
		MonitorAdcSpiDataIn => MonitorAdcSpiDataIn,
		MonitorAdcSpiDataOut0 => MonitorAdcSpiDataOut0,
		MonitorAdcSpiDataOut1 => MonitorAdcSpiDataOut1,
		MonitorAdcSpiXferStart => MonitorAdcSpiXferStart,
		MonitorAdcSpiXferDone => MonitorAdcSpiXferDone,
		MonitorAdcnDrdy0 => nDrdyMonitorAdc0_i,
		MonitorAdcnDrdy1 => nDrdyMonitorAdc1_i,
		MonitorAdcSpiFrameEnable => MonitorAdcSpiFrameEnable,			
		
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
		
		Uart3FifoReset => Uart3FifoReset,
		ReadUart3 => ReadUart3,
		Uart3RxFifoFull => Uart3RxFifoFull,
		Uart3RxFifoEmpty => Uart3RxFifoEmpty,
		Uart3RxFifoData => Uart3RxFifoData,
		Uart3RxFifoCount => Uart3RxFifoCount,
		WriteUart3 => WriteUart3,
		Uart3TxFifoFull => Uart3TxFifoFull,
		Uart3TxFifoEmpty => Uart3TxFifoEmpty,
		Uart3TxFifoData => Uart3TxFifoData,
		Uart3TxFifoCount => Uart3TxFifoCount,
		Uart3ClkDivider => Uart3ClkDivider,
				
		--Timing
		IdealTicksPerSecond => std_logic_vector(to_unsigned(BoardMasterClockFreq, 32)),
		ActualTicksLastSecond => PPSCount,
		PPSCountReset => PPSCountReset,
		PPSDetected => PPSDetected,
		ClockTicksThisSecond => PPSCounter,
		ClkDacWrite => ClkDacWrite,
		WriteClkDac => WriteClkDac,
		ClkDacReadback => ClkDacReadback--,
	);
	
	------------------------------------------ FSM D/A's ---------------------------------------------------
	
		--~ IBufFSMDacMisoA : IBufP1Ports port map(clk => MasterClk, I => MosiDacA, O => MisoDacA_i); --No actual Miso on MAX5719, so we're looping back the Mosi signal to see if the bit is stuck on the pcb...
		--~ IBufFSMDacMisoB : IBufP1Ports port map(clk => MasterClk, I => MosiDacB, O => MisoDacB_i); --No actual Miso on MAX5719, so we're looping back the Mosi signal to see if the bit is stuck on the pcb...
		--~ IBufFSMDacMisoC : IBufP1Ports port map(clk => MasterClk, I => MosiDacC, O => MisoDacC_i); --No actual Miso on MAX5719, so we're looping back the Mosi signal to see if the bit is stuck on the pcb...
		--~ IBufFSMDacMisoD : IBufP1Ports port map(clk => MasterClk, I => MosiDacD, O => MisoDacD_i); --No actual Miso on MAX5719, so we're looping back the Mosi signal to see if the bit is stuck on the pcb...
		
	--MAX5719 is left-shifted, MSB-first
	FSMDacs_i : SpiDacQuadPorts
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
		nCsD => nCsDacD_i,
		Sck => SckDacs_i,
		MosiA => MosiDacA_i,
		MosiB => MosiDacB_i,
		MosiC => MosiDacC_i,
		MosiD => MosiDacD_i,
		MisoA => MosiDacA_i, --these should really loop back at the board level not the signal level, but we got two d/a's to juggle...
		MisoB => MosiDacB_i,
		MisoC => MosiDacC_i,
		MisoD => MosiDacD_i,
		WriteDac => WriteDacs,
		DacWriteOutA => DacASetpoint,
		DacWriteOutB => DacBSetpoint,
		DacWriteOutC => DacCSetpoint,
		DacWriteOutD => DacDSetpoint,
		DacReadbackA => DacAReadback,
		DacReadbackB => DacBReadback,
		DacReadbackC => DacCReadback,
		DacReadbackD => DacDReadback,
		TransferComplete => DacTransferComplete
	);

	--~ UserJmpJstnCse <= nCsDacA_i;
	--~ TP3 <= SckDacs_i;
	--~ TP1 <= MosiDacA_i;
	--~ TP1 <= nLDacs_i;	

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

	--D/A Muxing:
	
	MosiTiDacA <= MosiDacA_i when (DacSelectMaxti = '0') else 'Z';
	MosiTiDacB <= MosiDacB_i when (DacSelectMaxti = '0') else 'Z';
	MosiTiDacC <= MosiDacC_i when (DacSelectMaxti = '0') else 'Z';
	MosiTiDacD <= MosiDacD_i when (DacSelectMaxti = '0') else 'Z';
	SckTiDacs <= SckDacs_i when (DacSelectMaxti = '0') else 'Z';
	nCsTiDacs <= nCsDacA_i when (DacSelectMaxti = '0') else 'Z';
	PowerEnTi <= not(DacSelectMaxti);
	
	MosiMaxDacA <= MosiDacA_i when (DacSelectMaxti = '1') else 'Z';
	MosiMaxDacB <= MosiDacB_i when (DacSelectMaxti = '1') else 'Z';
	MosiMaxDacC <= MosiDacC_i when (DacSelectMaxti = '1') else 'Z';
	MosiMaxDacD <= MosiDacD_i when (DacSelectMaxti = '1') else 'Z';
	SckMaxDacs <= SckDacs_i when (DacSelectMaxti = '1') else 'Z';
	nCsMaxDacs <= nCsDacA_i when (DacSelectMaxti = '1') else 'Z';
	nLoadMaxDacs <= nLDacs_i when (DacSelectMaxti = '1') else 'Z';
	PowerEnMax <= DacSelectMaxti;
	
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
		IBufSarAdcnDrdyD : IBufP2Ports port map(clk => MasterClk, I => nDrdyAdcD, O => nDrdyAdcD_i);

		IBufSarAdcMisoA : IBufP2Ports port map(clk => MasterClk, I => MisoAdcA, O => MisoAdcA_i);
		IBufSarAdcMisoB : IBufP2Ports port map(clk => MasterClk, I => MisoAdcB, O => MisoAdcB_i);
		IBufSarAdcMisoC : IBufP2Ports port map(clk => MasterClk, I => MisoAdcC, O => MisoAdcC_i);
		IBufSarAdcMisoD : IBufP2Ports port map(clk => MasterClk, I => MisoAdcD, O => MisoAdcD_i);
	
	ltc2378 : Ltc2378AccumQuadPorts
	port map
	(
		clk => MasterClk,
		rst => MasterReset,
		Trigger => TrigAdcs_i,
		nDrdyA => nDrdyAdcA_i,
		nDrdyB => nDrdyAdcB_i,
		nDrdyC => nDrdyAdcC_i,
		nDrdyD => nDrdyAdcD_i,
		Sck => SckAdcs_i,
		MisoA => MisoAdcA_i,
		MisoB => MisoAdcB_i,
		MisoC => MisoAdcC_i,
		MisoD => MisoAdcD_i,
		nCsA => nCsAdcA_i,
		nCsB => nCsAdcB_i,
		nCsC => nCsAdcC_i,
		nCsD => nCsAdcD_i,
		OverRangeA => open,
		OverRangeB => open,
		OverRangeC => open,
		OverRangeD => open,
		AdcPowerDown => '0',
		--~ AdcClkDivider => x"002F", --1MHz
		--~ AdcClkDivider => x"05DC", --32kHz
		AdcClkDivider => x"0FFF", --32kHz
		--~ SamplesToAverage => x"03FF",		
		SamplesToAverage => x"0001",		
		ChopperEnable => '0',
		ChopperMuxPos => ChopperMuxPos_i,
		ChopperMuxNeg => ChopperMuxNeg_i,
		ReadAdcSample  => ReadAdcSample,
		AdcSampleToReadA => AdcSampleToReadA,
		AdcSampleToReadB => AdcSampleToReadB,
		AdcSampleToReadC => AdcSampleToReadC,
		AdcSampleToReadD => AdcSampleToReadD,
		AdcSampleNumAccums => AdcSampleNumAccums,
		--~ TP1 => TP1_i,
		--~ TP2 => TP2_i,
		--~ TP3 => TP3_i,
		--~ TP4 => TP4_i--,		
		TP1 => open,
		TP2 => open,
		TP3 => open,
		TP4 => open--,		
	);

	--Map the other A/D signals to the actual pins:
	
	--~ ChopperMuxPos_i
	--~ ChopperMuxNeg_i
	ChopRef <= '0';
	ChopAdcs <= '0';
	
	TrigAdcs <= TrigAdcs_i;
	--~ nCsAdcA <= nCsAdcA_i;
	--~ nCsAdcB <= nCsAdcB_i;
	--~ nCsAdcC <= nCsAdcC_i;
	--~ nCsAdcD <= nCsAdcD_i;
	nCsAdcs <= nCsAdcA_i;
	SckAdcs <= SckAdcs_i;
		
	--To test between fpga & A/D:
	--~ TP1_i <= TrigAdcs_i;
	--~ TP2_i <= nDrdyAdcA_i;
	--~ TP3_i <= nCsAdcA_i;
	--~ TP4_i <= SckAdcs_i;
	--~ TP8_i <= SarAdcMiso_i;	
	--~ TP5_i <= MisoAdcA_i;
	--~ TP6_i <= MisoAdcB_i;
	--~ TP7_i <= MisoAdcC_i;
	--~ TP8_i <= ReadAdcSample;
	
	--To test between fpga & uC:
	--~ TP8_i <= SarReadAdcSample;
	--~ TP4_i <= SarAdcSampleReadAck;
	--~ TP5_i <= SarFifoAdcSample(0);
	
	----------------------------------------------------------------Monitor A/D--------------------------------------------------------------------
			
	IBufnDrdyAdc0 : IBufP3Ports port map(clk => MasterClk, I => nDrdyMonAdc0, O => nDrdyMonitorAdc0_i); --if you want to change the pin for this chip select, it's here
	IBufMisoAdc0 : IBufP3Ports port map(clk => MasterClk, I => MisoMonAdc0, O => MisoMonitorAdc0_i); --if you want to change the pin for this chip select, it's here
	IBufnDrdyAdc1 : IBufP3Ports port map(clk => MasterClk, I => nDrdyMonAdc1, O => nDrdyMonitorAdc1_i); --if you want to change the pin for this chip select, it's here
	IBufMisoAdc1 : IBufP3Ports port map(clk => MasterClk, I => MisoMonAdc1, O => MisoMonitorAdc1_i); --if you want to change the pin for this chip select, it's here
	
	--~ --Decodes the A/D data into a buffer and creates timing signals to manage fifos
	--~ ads1258 : ads1258Ports
	--~ generic map 
	--~ (
		--~ MASTER_CLOCK_FREQHZ => BoardMasterClockFreq--,
	--~ )
	--~ port map (
		--~ clk => MasterClk,
		--~ rst => MonitorAdcReset_i,
		--~ nDrdy => nDrdyMonitorAdc_i,
		--~ nCsAdc => nCsMonAdc0,
		--~ Sck => SckMonAdc0,
		--~ Mosi => MosiMonAdc0,
		--~ Miso => MisoMonitorAdc_i,
		--~ SpiDataIn => MonitorAdcSpiDataIn,
		--~ SpiDataOut => MonitorAdcSpiDataOut,
		--~ SpiXferStart => MonitorAdcSpiXferStart,
		--~ SpiXferDone => MonitorAdcSpiXferDone,
		--~ Sample => MonitorAdcSample,
		--~ SampleLatched => MonitorAdcSampleLatched,
		--~ TimestampReq => open--,
	--~ );
	
	--~ ads1258accum : ads1258accumulatorPorts
	--~ port map
	--~ (
		--~ clk => MasterClk,
		--~ rst => MonitorAdcReset_i,
		--~ AdcSampleIn => MonitorAdcSample,
		--~ AdcSampleLatched => MonitorAdcSampleLatched,
		--~ AdcChannelLatched => open,
		--~ AdcChannelReadIndex => MonitorAdcChannel,
		--~ ReadAdcSample => MonitorAdcReadSample,
		--~ AdcSampleToRead => MonitorAdcSampleToRead--,
	--~ );
	
	ads1258 : SpiDeviceDualPorts
	generic map 
	(
		--~ CLOCK_DIVIDER => 16,
		CLOCK_DIVIDER => 256,
		--~ CLOCK_DIVIDER => 4096,
		BIT_WIDTH => 8,
		CPOL => '0',
		CPHA => '0'--,
	)
	port map 
	(
		clk => MasterClk,
		rst => MonitorAdcReset_i,
		--~ nCs => nCsMonitorAdc_i,
		nCs => open,
		Sck => SckMonitorAdc_i,
		MosiA => MosiMonitorAdc_i,
		MosiB => open,
		MisoA => MisoMonitorAdc0_i,
		MisoB => MisoMonitorAdc1_i,
		WriteOutA => MonitorAdcSpiDataIn,
		WriteOutB => MonitorAdcSpiDataIn,
		Transfer => MonitorAdcSpiXferStart,
		ReadbackA => MonitorAdcSpiDataOut0,
		ReadbackB => MonitorAdcSpiDataOut1,
		TransferComplete => MonitorAdcSpiXferDone--,
	);
	
	nCsMonitorAdc_i <= not(MonitorAdcSpiFrameEnable); --this is controlled by a seperate address in the register space, so we can do variable number of bytes per transfer
	
	nCsMonAdcs <= nCsMonitorAdc_i;
	SckMonAdcs <= SckMonitorAdc_i;
	MosiMonAdcs <= MosiMonitorAdc_i;	
	
	TrigMonAdcs <= 'Z'; --We're not driving this rn
	
	MonitorAdcReset_i <= MasterReset or MonitorAdcReset;
	
	--~ TP1 <= nCsMonitorAdc_i;
	--~ TP2 <= SckMonitorAdc_i;
	--~ TP3 <= MosiMonitorAdc_i;
	--~ TP4 <= MisoMonitorAdc_i;
	--~ TP5 <= MonitorAdcSpiXferStart;
	--~ TP6 <= MonitorAdcSpiXferDone;
	--~ TP7 <= MonitorAdcSpiDataIn(0);
	--~ TP8 <= MonitorAdcSpiDataOut(0);
	
	
	----------------------------- RS-422 ----------------------------------
	
	--~ Oe0 <= '1';
	--~ Oe1 <= '1';
	--~ Oe2 <= '1';
	--~ Oe3 <= '1';
	
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

	--Thirdly, the very NOT boring fifos (software)
	
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
		
	IBufRxd0 : IBufP3Ports port map(clk => UartClk, I => Rx0, O => Rxd0_i); --if you want to change the pin for this chip select, it's here
	
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
	Tx0 <= Txd0_i;
	
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
	
	IBufRxd1 : IBufP3Ports port map(clk => UartClk, I => Rx1, O => Rxd1_i); --if you want to change the pin for this chip select, it's here
	
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
	Tx1 <= Txd1_i;
	
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
	
	IBufRxd2 : IBufP3Ports port map(clk => UartClk, I => Rx2, O => Rxd2_i); --if you want to change the pin for this chip select, it's here
	
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
	Tx2 <= Txd2_i;
	
	--Debug monitors
	--~ Txd2 <= Txd0_i;
	--~ Txd1 <= Rxd0_i;
	
	--Mux master reset (boot) and user reset (datamapper)
	Uart2FifoReset_i <= MasterReset or Uart2FifoReset;
	
	
	
	
	
	
	Uart3BitClockDiv : VariableClockDividerPorts
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
		terminal_count => Uart3ClkDivider,
		clko => UartClk3
	);
	Uart3TxBitClockDiv : ClockDividerPorts
	generic map
	(
		CLOCK_DIVIDER => 16,
		DIVOUT_RST_STATE => '0'--;
	)
	port map
	(
		clk => UartClk3,
		rst => MasterReset,
		div => UartTxClk3
	);
	
	--~ Ux1SelJmp <= UartClk3;
	
	IBufRxd3 : IBufP3Ports port map(clk => UartClk, I => Rx3, O => Rxd3_i); --if you want to change the pin for this chip select, it's here
	
	--~ Ux1SelJmp <= Rxd3;
	
	RS433_Rx3 : UartRxFifoExtClk
	generic map
	(
		--~ UART_CLOCK_FREQHZ => BoardMasterClockFreq,
		FIFO_BITS => 10--,
		--~ BAUD_DIVIDER_BITS => 8--,
		--~ BAUDRATE => 13500000--,
		--~ BAUDRATE => 8000000--,
		--~ BAUDRATE => BoardMasterClockFreq / 16--, --9.316MHz
		--~ BAUDRATE => BoardMasterClockFreq / 8193--,
		--~ BAUDRATE => 115300--,
	)
	port map
	(
		clk => MasterClk,
		uclk => UartClk3,
		rst => Uart3FifoReset_i,
		--~ BaudDivider => Uart3ClkDivider,
		Rxd => Rxd3_i,
		Dbg1 => open,
		RxComplete => open,
		ReadFifo => ReadUart3,
		FifoFull => Uart3RxFifoFull,
		FifoEmpty => Uart3RxFifoEmpty,
		FifoReadData => Uart3RxFifoData,
		FifoCount => Uart3RxFifoCount,
		FifoReadAck => open--,		
	);
	
	RS433_Tx3 : UartTxFifoExtClk
	--~ RS433_Tx3 : UartTxFifo
	generic map
	(
		--~ UART_CLOCK_FREQHZ => BoardMasterClockFreq,
		--~ FIFO_BITS => 10,
		FIFO_BITS => 10--,
		--~ BAUD_DIVIDER_BITS => 8--,
		--~ BAUDRATE => 13500000--,
		--~ BAUDRATE => 8000000--,
		--~ BAUDRATE => BoardMasterClockFreq / 16--, --9.316MHz
		--~ BAUDRATE => BoardMasterClockFreq / 8193--,
		--~ BAUDRATE => 115300--,
	)
	port map
	(
		clk => MasterClk,
		--~ uclk => MasterClk,
		uclk => UartTxClk3,
		rst => Uart3FifoReset_i,
		--~ BaudDivider => Uart3ClkDivider,
		BitClockOut => open,
		--~ BitClockOut => Ux1SelJmp,		
		WriteStrobe => WriteUart3,
		WriteData => Uart3TxFifoData,
		FifoFull => Uart3TxFifoFull,
		FifoEmpty => Uart3TxFifoEmpty,
		FifoCount => Uart3TxFifoCount,
		TxInProgress => open,
		--~ TxInProgress => SckMonitorAdcTP3,		
		Cts => '0',
		Txd => Txd3_i--,
		--~ Txd => open--,
	);
	Tx3 <= Txd3_i;
	
	--Debug monitors
	--~ Txd3 <= Txd0_i;
	--~ Txd1 <= Rxd0_i;
	
	--Mux master reset (boot) and user reset (datamapper)
	Uart3FifoReset_i <= MasterReset or Uart3FifoReset;

	--DEBUG
	--~ TP8 <= TxdLab_i;
	
	--~ LedR <= not(TxdLab_i);
	--~ TP1 <= TxdLab_i;
	
	--Debug monitors
	--~ TxdLab <= Txd0_i;
	--~ Txd1 <= Rxd0_i;
	
	--~ TP1 <= RxdUsb_i;
	--~ TP2 <= UartClkUsb;
	--~ TP3 <= RamBusDataIn(0);
	--~ TP4 <= UartTxClkUsb;
	--~ TP5 <= TxdUartBitCount(0);
	--~ TP6 <= TxdUartBitCount(1);
	--~ TP7 <= TxdUartBitCount(2);
	--~ TP8 <= TxdUartBitCount(3);
	--~ TP5 <= UartUsbRxFifoEmpty;
	--~ TP6 <= ReadUartUsb;
	--~ TP7 <= UartUsbRxFifoCount(0);
	--~ TP8 <= UartUsbRxFifoCount(1);
	
	
	----------------------------- Timing ----------------------------------
	
		--~ --Just sync external PPS to master clock
		IBufPPS : IBufP2Ports port map(clk => MasterClk, I => PPS, O => PPS_i);
		
	--~ --Count up MasterClocks per PPS so we can sync the oscilator to the GPS clock
	PPSAccumulator : PPSCountPorts
    port map
	(
		clk => MasterClk,
		PPS => PPS_i,
		PPSReset => PPSCountReset,
		PPSDetected => PPSDetected,
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
	
	--~ IBufDacMiso : IBufP2Ports port map(clk => MasterClk, I => '1', O => MisoXO_i);
	MisoXO_i <= '1';

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
		nCs => nCsXO_i,
		Sck => SckXO_i,
		Mosi => MosiXO_i,
		Miso => MisoXO_i,
		DacWriteOut => ClkDacWrite,
		WriteDac => WriteClkDac,
		DacReadback => ClkDacReadback
	);

	nCsXO <= nCsXO_i;
	SckXO <= SckXO_i;
	MosiXO <= MosiXO_i;
	
	----------------------------- Power Supplies ----------------------------------
		
	PowerSync <= '1';
	--~ PowerSyncClockDivider : ClockDividerPorts generic map(CLOCK_DIVIDER => 96, DIVOUT_RST_STATE => '0') port map(clk => MasterClk, rst => MasterReset, div => PowerSync);
	
	----------------------------- DEBUG IDEAS ----------------------------------
	
	Ux1SelJmp <= RamBusDataIn(0);
	--~ Ux1SelJmp <= MotorSeekStep(0);
	--~ Ux1SelJmp <= '1' when ( (Rxd1 = '1') and (Rxd2 = '0') ) else '0' when ( (Rxd1 = '0') and (Rxd2 = '1') ) else 'Z';
	--~ Ux1SelJmp <= MasterClk;
		
	--  Discrete I/O Connections
	
		TP1 <= RamBusnCs;
		TP2 <= RamBusWrnRd;
		TP3 <= RamBusDataIn(0);
		TP4 <= RamBusDataIn(1);
		TP5 <= RamBusDataIn(2);
		TP6 <= PowerCycd;
		TP7 <= RamBusDataIn(3);
		TP8 <= Fault3VA or Fault1V or PowerCycd or Fault5V;
			
	----------------------------- Clocked Logic / Main Loop ----------------------------------
	
	process(MasterReset, MasterClk)
	begin
	
		if (MasterReset = '1') then
		
		--This is where we have to actually set all of our registers, since the M2S devices don't support initialization as though they are from the 1980's...
		
		
		else
		
			if ( (MasterClk'event) and (MasterClk = '1') ) then
				
			end if;
			
		end if;		

	end process;

	
end architecture_Main;



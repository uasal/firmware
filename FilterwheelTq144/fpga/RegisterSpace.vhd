--------------------------------------------------------------------------------
-- UA Extra-Solar Camera PZT Controller Project FPGA Firmware
--
-- Register Space Definitions & Interface
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;
--~ use work.ads1258.all;
--~ use work.ads1258accumulator_pkg.all;

entity RegisterSpacePorts is
	generic (
		ADDRESS_BITS : natural := 10--;
		--~ FIFO_BITS : natural := 9--;
	);
	port (
	
		clk : in std_logic;
		rst : in std_logic;
		
		-- Bus:
		Address : in std_logic_vector(ADDRESS_BITS - 1 downto 0); -- this is fucked, but vhdl can't figure out that ADDRESS_BITS is a constant because it's in a generic map...
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
		Fault1V : in std_logic;
		Fault3V : in std_logic;
		Fault5V : in std_logic;
		nFaultClr1V : out std_logic;								
		nFaultClr3V : out std_logic;								
		nFaultClr5V : out std_logic;								
		PowernEn5V : out std_logic;								
		PowerCycd : in std_logic;
		nPowerCycClr : out std_logic;								
		LedR : out std_logic;
		LedG : out std_logic;
		LedB : out std_logic;
		Uart0OE : out std_logic;
		Uart1OE : out std_logic;
		Uart2OE : out std_logic;
		Uart3OE : out std_logic;				
		Ux1SelJmp : out std_logic;
		Ux2SelJmp : out std_logic;
				
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
		--~ MonitorAdcSampleToRead : in ads1258accumulator;
		MonitorAdcSampleToRead : in std_logic_vector(63 downto 0);
		MonitorAdcReset : out std_logic;
		MonitorAdcSpiDataIn : out std_logic_vector(7 downto 0);
		MonitorAdcSpiDataOut : in std_logic_vector(7 downto 0);
		MonitorAdcSpiXferStart : out std_logic;
		MonitorAdcSpiXferDone : in std_logic;
		MonitorAdcnDrdy  : in std_logic;
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
		
		UartUsbFifoReset : out std_logic;
		ReadUartUsb : out std_logic;
		UartUsbRxFifoFull : in std_logic;
		UartUsbRxFifoEmpty : in std_logic;
		UartUsbRxFifoData : in std_logic_vector(7 downto 0);
		UartUsbRxFifoCount : in std_logic_vector(9 downto 0);
		WriteUartUsb : out std_logic;
		UartUsbTxFifoFull : in std_logic;
		UartUsbTxFifoEmpty : in std_logic;
		UartUsbTxFifoData : out std_logic_vector(7 downto 0);
		UartUsbTxFifoCount : in std_logic_vector(9 downto 0);
		UartUsbClkDivider : out std_logic_vector(7 downto 0);
		
		UartGpsFifoReset : out std_logic;
		ReadUartGps : out std_logic;
		UartGpsRxFifoFull : in std_logic;
		UartGpsRxFifoEmpty : in std_logic;
		UartGpsRxFifoData : in std_logic_vector(7 downto 0);
		UartGpsRxFifoCount : in std_logic_vector(9 downto 0);
		WriteUartGps : out std_logic;
		UartGpsTxFifoFull : in std_logic;
		UartGpsTxFifoEmpty : in std_logic;
		UartGpsTxFifoData : out std_logic_vector(7 downto 0);
		UartGpsTxFifoCount : in std_logic_vector(9 downto 0);
		UartGpsClkDivider : out std_logic_vector(7 downto 0);
		
		--Timing
		IdealTicksPerSecond : in std_logic_vector(31 downto 0);
		ActualTicksLastSecond : in std_logic_vector(31 downto 0);
		PPSCountReset : out std_logic;
		PPSDetected : in std_logic;
		ClockTicksThisSecond : in std_logic_vector(31 downto 0);				
		ClkDacWrite : out std_logic_vector(15 downto 0);
		WriteClkDac : out std_logic;
		ClkDacReadback : in std_logic_vector(15 downto 0)--;
	);
end RegisterSpacePorts;

architecture RegisterSpace of RegisterSpacePorts is

	constant MAX_ADDRESS_BITS : natural := ADDRESS_BITS;
	signal Address_i : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0);
	
	constant DeviceSerialNumberAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(0, MAX_ADDRESS_BITS));
	constant FpgaFirmwareBuildNumberAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(4, MAX_ADDRESS_BITS));

	constant UnixSecondsAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(8, MAX_ADDRESS_BITS)); --we have guard addresses on all fifos because accidental reading still removes a char from the fifo.
	constant IdealTicksPerSecondAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(12, MAX_ADDRESS_BITS));
	constant ActualTicksLastSecondAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16, MAX_ADDRESS_BITS));
	constant ClockTicksThisSecondAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(20, MAX_ADDRESS_BITS));
	constant ClockSteeringDacSetpointAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(24, MAX_ADDRESS_BITS));

	constant Reserved0Addr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(28, MAX_ADDRESS_BITS));

	constant MotorControlStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(32, MAX_ADDRESS_BITS));
	constant PosSensAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(36, MAX_ADDRESS_BITS));
	constant Reserved1Addr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(40, MAX_ADDRESS_BITS));

	constant Reserved2Addr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(48, MAX_ADDRESS_BITS));
	constant Reserved3Addr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(56, MAX_ADDRESS_BITS)); --should be contiguous with AdcSample so we can get the whole thing with an 8-byte xfer...
	constant Reserved4Addr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(64, MAX_ADDRESS_BITS));
	
	constant Uart3FifoAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(72, MAX_ADDRESS_BITS));
	constant Uart3FifoStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(80, MAX_ADDRESS_BITS));
	
	constant ControlRegisterAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(88, MAX_ADDRESS_BITS)); --we have guard addresses on all fifos because accidental reading still removes a char from the fifo.

	constant Reserved7Addr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(92, MAX_ADDRESS_BITS));

	constant PPSRtcPhaseCmpAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(96, MAX_ADDRESS_BITS));
	constant PPSAdcPhaseCmpAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(100, MAX_ADDRESS_BITS));

	constant MonitorAdcSample : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(104, MAX_ADDRESS_BITS));
	constant MonitorAdcReadChannel : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(112, MAX_ADDRESS_BITS));

	constant Uart2FifoAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(116, MAX_ADDRESS_BITS));
	constant Uart2FifoStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(120, MAX_ADDRESS_BITS));
	constant Uart1FifoAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(124, MAX_ADDRESS_BITS));
	constant Uart1FifoStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(128, MAX_ADDRESS_BITS));
	constant Uart0FifoAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(132, MAX_ADDRESS_BITS));
	constant Uart0FifoStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(136, MAX_ADDRESS_BITS));
	constant UartClockDividersAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(140, MAX_ADDRESS_BITS));
	
	constant PosDetHomeAStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(148, MAX_ADDRESS_BITS));
	constant PosDetA0StepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(152, MAX_ADDRESS_BITS));
	constant PosDetA1StepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(156, MAX_ADDRESS_BITS));
	constant PosDetA2StepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(160, MAX_ADDRESS_BITS));
	
	constant PosDetHomeBStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(164, MAX_ADDRESS_BITS));
	
	--Had to blow these out cause 16b offsets kill the bloody M3:
	--~ constant PosDetB0StepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(168, MAX_ADDRESS_BITS));
	--~ constant PosDetB1StepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(172, MAX_ADDRESS_BITS));
	--~ constant PosDetB2StepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(176, MAX_ADDRESS_BITS));
	
	--~ constant PosDet0AStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(180, MAX_ADDRESS_BITS));
	--~ constant PosDet1AStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(184, MAX_ADDRESS_BITS));
	--~ constant PosDet2AStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(188, MAX_ADDRESS_BITS));
	--~ constant PosDet3AStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(192, MAX_ADDRESS_BITS));
	--~ constant PosDet4AStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(196, MAX_ADDRESS_BITS));
	--~ constant PosDet5AStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(200, MAX_ADDRESS_BITS));
	--~ constant PosDet6AStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(204, MAX_ADDRESS_BITS));
	--~ constant PosDet7AStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(208, MAX_ADDRESS_BITS));
	
	--~ constant PosDet0BStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(212, MAX_ADDRESS_BITS));
	--~ constant PosDet1BStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(216, MAX_ADDRESS_BITS));
	--~ constant PosDet2BStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(220, MAX_ADDRESS_BITS));
	--~ constant PosDet3BStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(224, MAX_ADDRESS_BITS));
	--~ constant PosDet4BStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(228, MAX_ADDRESS_BITS));
	--~ constant PosDet5BStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(232, MAX_ADDRESS_BITS));
	--~ constant PosDet6BStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(236, MAX_ADDRESS_BITS));
	--~ constant PosDet7BStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(240, MAX_ADDRESS_BITS));
	
	--~ constant UartUsbFifoAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(244, MAX_ADDRESS_BITS));
	--~ constant UartUsbFifoStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(248, MAX_ADDRESS_BITS));
	
	--~ constant MonitorAdcSpiXferAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(252, MAX_ADDRESS_BITS));
	
	--~ constant UartGpsFifoAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(256, MAX_ADDRESS_BITS));
	--~ constant UartGpsFifoStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(260, MAX_ADDRESS_BITS));
	
	constant PosDetHomeAOnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(148, MAX_ADDRESS_BITS));
	constant PosDetHomeAOffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(152, MAX_ADDRESS_BITS));
	constant PosDetA0OnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(156, MAX_ADDRESS_BITS));
	constant PosDetA0OffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(160, MAX_ADDRESS_BITS));
	constant PosDetA1OnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(164, MAX_ADDRESS_BITS));
	constant PosDetA1OffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(168, MAX_ADDRESS_BITS));
	constant PosDetA2OnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(172, MAX_ADDRESS_BITS));
	constant PosDetA2OffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(176, MAX_ADDRESS_BITS));
	
	constant PosDetHomeBOnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(180, MAX_ADDRESS_BITS));
	constant PosDetHomeBOffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(184, MAX_ADDRESS_BITS));
	constant PosDetB0OnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(188, MAX_ADDRESS_BITS));
	constant PosDetB0OffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(192, MAX_ADDRESS_BITS));
	constant PosDetB1OnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(196, MAX_ADDRESS_BITS));
	constant PosDetB1OffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(200, MAX_ADDRESS_BITS));
	constant PosDetB2OnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(204, MAX_ADDRESS_BITS));
	constant PosDetB2OffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(208, MAX_ADDRESS_BITS));
	
	constant PosDet0AOnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(212, MAX_ADDRESS_BITS));
	constant PosDet0AOffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(216, MAX_ADDRESS_BITS));
	constant PosDet1AOnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(220, MAX_ADDRESS_BITS));
	constant PosDet1AOffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(224, MAX_ADDRESS_BITS));
	constant PosDet2AOnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(228, MAX_ADDRESS_BITS));
	constant PosDet2AOffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(232, MAX_ADDRESS_BITS));
	constant PosDet3AOnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(236, MAX_ADDRESS_BITS));
	constant PosDet3AOffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(240, MAX_ADDRESS_BITS));
	constant PosDet4AOnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(244, MAX_ADDRESS_BITS));
	constant PosDet4AOffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(248, MAX_ADDRESS_BITS));
	constant PosDet5AOnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(252, MAX_ADDRESS_BITS));
	constant PosDet5AOffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(256, MAX_ADDRESS_BITS));
	constant PosDet6AOnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(260, MAX_ADDRESS_BITS));
	constant PosDet6AOffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(264, MAX_ADDRESS_BITS));
	constant PosDet7AOnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(268, MAX_ADDRESS_BITS));
	constant PosDet7AOffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(272, MAX_ADDRESS_BITS));
	
	constant PosDet0BOnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(276, MAX_ADDRESS_BITS));
	constant PosDet0BOffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(280, MAX_ADDRESS_BITS));
	constant PosDet1BOnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(284, MAX_ADDRESS_BITS));
	constant PosDet1BOffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(288, MAX_ADDRESS_BITS));
	constant PosDet2BOnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(292, MAX_ADDRESS_BITS));
	constant PosDet2BOffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(296, MAX_ADDRESS_BITS));
	constant PosDet3BOnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(300, MAX_ADDRESS_BITS));
	constant PosDet3BOffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(304, MAX_ADDRESS_BITS));
	constant PosDet4BOnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(308, MAX_ADDRESS_BITS));
	constant PosDet4BOffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(312, MAX_ADDRESS_BITS));
	constant PosDet5BOnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(316, MAX_ADDRESS_BITS));
	constant PosDet5BOffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(320, MAX_ADDRESS_BITS));
	constant PosDet6BOnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(324, MAX_ADDRESS_BITS));
	constant PosDet6BOffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(328, MAX_ADDRESS_BITS));
	constant PosDet7BOnStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(332, MAX_ADDRESS_BITS));
	constant PosDet7BOffStepAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(336, MAX_ADDRESS_BITS));
	
	constant UartUsbFifoAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(340, MAX_ADDRESS_BITS));
	constant UartUsbFifoStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(344, MAX_ADDRESS_BITS));
	
	constant MonitorAdcSpiXferAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(348, MAX_ADDRESS_BITS));
	constant MonitorAdcSpiFrameEnableAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(352, MAX_ADDRESS_BITS));
	
	constant UartGpsFifoAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(356, MAX_ADDRESS_BITS));
	constant UartGpsFifoStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(360, MAX_ADDRESS_BITS));
	
	--Control Signals
	
	signal LastReadReq :  std_logic := '0';		
	signal LastWriteReq :  std_logic := '0';		

	--signal Uart0ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(natural((real(102000000) / ( real(38400) * 32.0)) - 1.0), 8));	--38.4k
	--signal Uart1ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(natural((real(102000000) / ( real(230400) * 32.0)) - 1.0), 8));	--230k
	--signal Uart0ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(natural((real(153000000) / ( real(38400) * 32.0)) - 1.0), 8));	--38.4k
	--signal Uart1ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(natural((real(153000000) / ( real(230400) * 32.0)) - 1.0), 8));	--230k
	signal Uart0ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(natural((real(102000000) / ( real(38400) * 16.0)) - 1.0), 8));	--38.4k
	signal Uart1ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(natural((real(102000000) / ( real(230400) * 16.0)) - 1.0), 8));	--230k
	--signal Uart0ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(natural((real(153000000) / ( real(38400) * 16.0)) - 1.0), 8));	--38.4k
	--signal Uart1ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(natural((real(153000000) / ( real(230400) * 16.0)) - 1.0), 8));	--230k
	signal Uart2ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(0, 8));	--"real fast"
	signal Uart3ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(0, 8));	--"real fast"
	
	signal MonitorAdcChannelReadIndex_i : std_logic_vector(4 downto 0);	
	signal MonitorAdcSpiFrameEnable_i : std_logic := '0';	
	
	signal MotorSeekStep_i : std_logic_vector(15 downto 0);	
	signal PosLedsEnA_i :  std_logic := '0';	
	signal PosLedsEnB_i :  std_logic := '0';	
	signal ResetSteps_i :  std_logic := '0';	
	signal MotorEnable_i :  std_logic := '0';	

	signal PowernEn5V_i :  std_logic := '0';								
	signal LedR_i :  std_logic := '0';
	signal LedG_i :  std_logic := '0';
	signal LedB_i :  std_logic := '0';
	signal Uart0OE_i :  std_logic := '0';
	signal Uart1OE_i :  std_logic := '0';
	signal Uart2OE_i :  std_logic := '0';
	signal Uart3OE_i :  std_logic := '0';								
	signal Ux1SelJmp_i :  std_logic := '0';
	signal Ux2SelJmp_i :  std_logic := '0';

	
begin

	--~ Address_i(MAX_ADDRESS_BITS - 1 downto ADDRESS_BITS) <= std_logic_vector(to_unsigned(0, MAX_ADDRESS_BITS - ADDRESS_BITS));
	--~ Address_i(ADDRESS_BITS - 1 downto 0) <= Address;
	--~ Address_i <= std_logic_vector(to_unsigned(0, MAX_ADDRESS_BITS - ADDRESS_BITS)) & Address;
	Address_i <= Address;
	
	Uart0ClkDivider <= Uart0ClkDivider_i;
	Uart1ClkDivider <= Uart1ClkDivider_i;
	Uart2ClkDivider <= Uart2ClkDivider_i;
	Uart3ClkDivider <= Uart3ClkDivider_i;
	
	MotorSeekStep <= MotorSeekStep_i;
	PosLedsEnA <= PosLedsEnA_i;
	PosLedsEnB <= PosLedsEnB_i;
	ResetSteps <= ResetSteps_i;
	MotorEnable <= MotorEnable_i;
	
	MonitorAdcChannelReadIndex <= MonitorAdcChannelReadIndex_i;
	MonitorAdcSpiFrameEnable <= MonitorAdcSpiFrameEnable_i;
	
	--~ Fault1V <= Fault1V_i;
	--~ Fault3V <= Fault3V_i;
	--~ Fault5V <= Fault5V_i;
	PowernEn5V <= PowernEn5V_i;								
	--~ PowerCycd <= PowerCycd_i;
	LedR <= LedR_i;
	LedG <= LedG_i;
	LedB <= LedB_i;
	Uart0OE <= Uart0OE_i;
	Uart1OE <= Uart1OE_i;
	Uart2OE <= Uart2OE_i;
	Uart3OE <= Uart3OE_i;								
	Ux1SelJmp <= Ux1SelJmp_i;
	Ux2SelJmp <= Ux2SelJmp_i;
	
		
	process (clk, rst)
	begin
	
		if (rst = '1') then
		
			LastReadReq <= '0';			
			LastWriteReq <= '0';		

			Uart0ClkDivider_i <= std_logic_vector(to_unsigned(natural((real(102000000) / ( real(38400) * 16.0)) - 1.0), 8));
			Uart1ClkDivider_i <= std_logic_vector(to_unsigned(natural((real(102000000) / ( real(230400) * 16.0)) - 1.0), 8));
			Uart2ClkDivider_i <= std_logic_vector(to_unsigned(0, 8));	--"real fast"
			Uart3ClkDivider_i <= std_logic_vector(to_unsigned(0, 8));	--"real fast"
			
			MonitorAdcChannelReadIndex_i <= "00000";	
			
			MotorSeekStep_i <= x"0000";	
			PosLedsEnA_i <= '0';
			PosLedsEnB_i <= '0';
			ResetSteps_i <= '0';
			MotorEnable_i <= '0';	
					
		else
			
			if ( (clk'event) and (clk = '1') ) then
			
				if (ReadReq = '1') then
				
					--ReadReq Rising Edge
					if (LastReadReq = '0') then
					
						LastReadReq <= '1';
					
						ReadAck <= '0';
						
						--~ DataOut <= Address_i(7 downto 0);
							
						case Address_i is
						
						
							--Serial Number
							
							when DeviceSerialNumberAddr =>

								DataOut <= SerialNumber;
								
							

							--Build Number
							
							when FpgaFirmwareBuildNumberAddr =>

								DataOut <= BuildNumber;
							
							
								
							--Monitor A/D
							
							--~ when MonitorAdcSample =>

								--~ DataOut <= MonitorAdcSampleToRead(31 downto 0);
						
							--~ when MonitorAdcSample + x"04" =>

								--~ DataOut <= MonitorAdcSampleToRead(63 downto 32);
														
							--~ when MonitorAdcReadChannel =>

								--~ DataOut(4 downto 0) <= MonitorAdcChannelReadIndex_i;
								--~ DataOut(31 downto 5) <= "000000000000000";
					

							when MonitorAdcReadChannel =>

								DataOut(4 downto 0) <= MonitorAdcChannelReadIndex_i;
								DataOut(7 downto 5) <= "000";
								DataOut(31 downto 8) <= x"000000";
					
							
							when MonitorAdcSpiXferAddr =>
							
								DataOut(7 downto 0) <= MonitorAdcSpiDataOut;
								DataOut(31 downto 8) <= x"000000";
								
							when MonitorAdcSpiFrameEnableAddr =>
								
								DataOut(0) <= MonitorAdcSpiFrameEnable_i;
								DataOut(1) <= MonitorAdcSpiXferDone;
								DataOut(2) <= MonitorAdcnDrdy;
								DataOut(7 downto 3) <= "00000";
								DataOut(31 downto 8) <= x"000000";
								
							
								

					
							--RS-422
								
							when Uart0FifoAddr =>

								ReadUart0 <= '1';
								DataOut(7 downto 0) <= Uart0RxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								DataOut(31 downto 8) <= x"000000";
								 
							--~ when Uart0FifoAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								--~ DataOut(7 downto 0) <= x"00";
								--~ DataOut(7 downto 0) <= Uart0RxFifoData;
								--~ DataOut(15 downto 8) <= x"00";
								
							when Uart0FifoStatusAddr =>

								DataOut(0) <= Uart0RxFifoEmpty;
								DataOut(1) <= Uart0RxFifoFull;
								DataOut(2) <= Uart0TxFifoEmpty;
								DataOut(3) <= Uart0TxFifoFull;
								DataOut(4) <= '0';
								DataOut(5) <= '0';
								DataOut(6) <= '0';
								DataOut(7) <= '0';
								DataOut(17 downto 8) <= Uart0RxFifoCount;
								DataOut(27 downto 18) <= Uart0RxFifoCount;
								DataOut(31 downto 28) <= "0000";
								
						
							
							when Uart1FifoAddr =>

								ReadUart1 <= '1';
								DataOut(7 downto 0) <= Uart1RxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								DataOut(31 downto 8) <= x"000000";
								 
							--~ when Uart1FifoAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								--~ DataOut(7 downto 0) <= x"00";
								--~ DataOut(7 downto 0) <= Uart1RxFifoData;
								--~ DataOut(15 downto 8) <= x"00";
								
							when Uart1FifoStatusAddr =>

								DataOut(0) <= Uart1RxFifoEmpty;
								DataOut(1) <= Uart1RxFifoFull;
								DataOut(2) <= Uart1TxFifoEmpty;
								DataOut(3) <= Uart1TxFifoFull;
								DataOut(4) <= '0';
								DataOut(5) <= '0';
								DataOut(6) <= '0';
								DataOut(7) <= '0';
								DataOut(17 downto 8) <= Uart1RxFifoCount;
								DataOut(27 downto 18) <= Uart1RxFifoCount;
								DataOut(31 downto 28) <= "0000";
							
							
							
							when Uart2FifoAddr =>

								ReadUart2 <= '1';
								DataOut(7 downto 0) <= Uart2RxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								DataOut(31 downto 8) <= x"000000";
								 
							--~ when Uart2FifoAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								--~ DataOut(7 downto 0) <= x"00";
								--~ DataOut(7 downto 0) <= Uart2RxFifoData;
								--~ DataOut(15 downto 8) <= x"00";
								
							when Uart2FifoStatusAddr =>

								DataOut(0) <= Uart2RxFifoEmpty;
								DataOut(1) <= Uart2RxFifoFull;
								DataOut(2) <= Uart2TxFifoEmpty;
								DataOut(3) <= Uart2TxFifoFull;
								DataOut(4) <= '0';
								DataOut(5) <= '0';
								DataOut(6) <= '0';
								DataOut(7) <= '0';
								DataOut(17 downto 8) <= Uart2RxFifoCount;
								DataOut(27 downto 18) <= Uart2RxFifoCount;
								DataOut(31 downto 28) <= "0000";
							
							
							
							when Uart3FifoAddr =>

								ReadUart3 <= '1';
								DataOut(7 downto 0) <= Uart3RxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								DataOut(31 downto 8) <= x"000000";
								 
							--~ when Uart3FifoAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								--~ DataOut(7 downto 0) <= x"00";
								--~ DataOut(7 downto 0) <= Uart3RxFifoData;
								--~ DataOut(15 downto 8) <= x"00";
								
							when Uart3FifoStatusAddr =>

								DataOut(0) <= Uart3RxFifoEmpty;
								DataOut(1) <= Uart3RxFifoFull;
								DataOut(2) <= Uart3TxFifoEmpty;
								DataOut(3) <= Uart3TxFifoFull;
								DataOut(4) <= '0';
								DataOut(5) <= '0';
								DataOut(6) <= '0';
								DataOut(7) <= '0';
								DataOut(17 downto 8) <= Uart3RxFifoCount;
								DataOut(27 downto 18) <= Uart3RxFifoCount;
								DataOut(31 downto 28) <= "0000";
								
								
								
							when UartUsbFifoAddr =>

								ReadUartUsb <= '1';
								DataOut(7 downto 0) <= UartUsbRxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								DataOut(31 downto 8) <= x"000000";
								 
							--~ when UartUsbFifoAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								--~ DataOut(7 downto 0) <= x"00";
								--~ DataOut(7 downto 0) <= UartUsbRxFifoData;
								--~ DataOut(15 downto 8) <= x"00";
								
							when UartUsbFifoStatusAddr =>

								DataOut(0) <= UartUsbRxFifoEmpty;
								DataOut(1) <= UartUsbRxFifoFull;
								DataOut(2) <= UartUsbTxFifoEmpty;
								DataOut(3) <= UartUsbTxFifoFull;
								DataOut(4) <= '0';
								DataOut(5) <= '0';
								DataOut(6) <= '0';
								DataOut(7) <= '0';
								DataOut(17 downto 8) <= UartUsbRxFifoCount;
								DataOut(27 downto 18) <= UartUsbRxFifoCount;
								DataOut(31 downto 28) <= "0000";



							when UartGpsFifoAddr =>

								ReadUartGps <= '1';
								DataOut(7 downto 0) <= UartGpsRxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								DataOut(31 downto 8) <= x"000000";
								 
							--~ when UartGpsFifoAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								--~ DataOut(7 downto 0) <= x"00";
								--~ DataOut(7 downto 0) <= UartGpsRxFifoData;
								--~ DataOut(15 downto 8) <= x"00";
								
							when UartGpsFifoStatusAddr =>

								DataOut(0) <= UartGpsRxFifoEmpty;
								DataOut(1) <= UartGpsRxFifoFull;
								DataOut(2) <= UartGpsTxFifoEmpty;
								DataOut(3) <= UartGpsTxFifoFull;
								DataOut(4) <= '0';
								DataOut(5) <= '0';
								DataOut(6) <= '0';
								DataOut(7) <= '0';
								DataOut(17 downto 8) <= UartGpsRxFifoCount;
								DataOut(27 downto 18) <= UartGpsRxFifoCount;
								DataOut(31 downto 28) <= "0000";
								
								
								
							--Uart Clock dividers
							when UartClockDividersAddr =>

								DataOut(7 downto 0) <= Uart0ClkDivider_i;
								DataOut(15 downto 8) <= Uart1ClkDivider_i;
								DataOut(23 downto 16) <= Uart2ClkDivider_i;
								DataOut(31 downto 24) <= Uart3ClkDivider_i;

												
							--Timing
				
							--IdealTicksPerSecond
							when IdealTicksPerSecondAddr =>

								DataOut <= IdealTicksPerSecond;
								
								
							--ActualTicksLastSecond
							when ActualTicksLastSecondAddr =>

								DataOut <= ActualTicksLastSecond;
								
								
							--ClockTicksThisSecond
							when ClockTicksThisSecondAddr =>

								DataOut <= ClockTicksThisSecond;
							
								
							--ClockSteeringDacSetpointAddr
							when ClockSteeringDacSetpointAddr =>

								DataOut(15 downto 0) <= ClkDacReadback;
								DataOut(31 downto 16) <= x"0000";
								
								
								
							--MotorControlStatusAddr
							when MotorControlStatusAddr =>

								DataOut(15 downto 0) <= MotorSeekStep_i;
								DataOut(31 downto 16) <= MotorCurrentStep;
								
								
								
							--ControlRegisterAddr
							when ControlRegisterAddr =>

								DataOut(0) <= PosLedsEnA_i;
								DataOut(1) <= PosLedsEnB_i;
								DataOut(2) <= MotorEnable_i;
								DataOut(3) <= ResetSteps_i;								
								DataOut(4) <= MotorAPlus;
								DataOut(5) <= MotorAMinus;
								DataOut(6) <= MotorBPlus;
								DataOut(7) <= MotorBMinus;
								
								DataOut(8) <= Fault1V;
								DataOut(9) <= Fault3V;
								DataOut(10) <= Fault5V;
								DataOut(11) <= PowernEn5V_i;								
								DataOut(12) <= PowerCycd;
								DataOut(13) <= LedR_i;
								DataOut(14) <= LedG_i;
								DataOut(15) <= LedB_i;
								
								DataOut(16) <= Uart0OE_i;
								DataOut(17) <= Uart1OE_i;
								DataOut(18) <= Uart2OE_i;
								DataOut(19) <= Uart3OE_i;								
								DataOut(20) <= Ux1SelJmp_i;
								DataOut(21) <= Ux2SelJmp_i;
								DataOut(22) <= PPSDetected;
								
								DataOut(31 downto 23) <= "000000000";
								

							--PosSensAddr
							when PosSensAddr =>
							
								DataOut(0) <= PosSenseHomeA;
								DataOut(1) <= PosSenseBit0A;
								DataOut(2) <= PosSenseBit1A;
								DataOut(3) <= PosSenseBit2A;
								DataOut(4) <= PosSenseHomeB;
								DataOut(5) <= PosSenseBit0B;
								DataOut(6) <= PosSenseBit1B;
								DataOut(7) <= PosSenseBit2B;
								DataOut(11 downto 8) <= PosSenseA;
								DataOut(15 downto 12) <= PosSenseB;
								DataOut(31 downto 16) <= x"0000";
								
							
							--The infinity of step latches
							--~ when PosDetHomeAStepAddr => DataOut(15 downto 0) <= PosDetHomeAOnStep; DataOut(31 downto 16) <= PosDetHomeAOffStep;
							--~ when PosDetA0StepAddr => DataOut(15 downto 0) <= PosDetA0OnStep; DataOut(31 downto 16) <= PosDetA0OffStep;
							--~ when PosDetA1StepAddr => DataOut(15 downto 0) <= PosDetA1OnStep; DataOut(31 downto 16) <= PosDetA1OffStep;
							--~ when PosDetA2StepAddr => DataOut(15 downto 0) <= PosDetA2OnStep; DataOut(31 downto 16) <= PosDetA2OffStep;
							
							--~ when PosDetHomeBStepAddr => DataOut(15 downto 0) <= PosDetHomeBOnStep; DataOut(31 downto 16) <= PosDetHomeBOffStep;
							--~ when PosDetB0StepAddr => DataOut(15 downto 0) <= PosDetB0OnStep; DataOut(31 downto 16) <= PosDetB0OffStep;
							--~ when PosDetB1StepAddr => DataOut(15 downto 0) <= PosDetB1OnStep; DataOut(31 downto 16) <= PosDetB1OffStep;
							--~ when PosDetB2StepAddr => DataOut(15 downto 0) <= PosDetB2OnStep; DataOut(31 downto 16) <= PosDetB2OffStep;
							
							--~ when PosDet0AStepAddr => DataOut(15 downto 0) <= PosDet0AOnStep; DataOut(31 downto 16) <= PosDet0AOffStep;
							--~ when PosDet1AStepAddr => DataOut(15 downto 0) <= PosDet1AOnStep; DataOut(31 downto 16) <= PosDet1AOffStep;
							--~ when PosDet2AStepAddr => DataOut(15 downto 0) <= PosDet2AOnStep; DataOut(31 downto 16) <= PosDet2AOffStep;
							--~ when PosDet3AStepAddr => DataOut(15 downto 0) <= PosDet3AOnStep; DataOut(31 downto 16) <= PosDet3AOffStep;
							--~ when PosDet4AStepAddr => DataOut(15 downto 0) <= PosDet4AOnStep; DataOut(31 downto 16) <= PosDet4AOffStep;
							--~ when PosDet5AStepAddr => DataOut(15 downto 0) <= PosDet5AOnStep; DataOut(31 downto 16) <= PosDet5AOffStep;
							--~ when PosDet6AStepAddr => DataOut(15 downto 0) <= PosDet6AOnStep; DataOut(31 downto 16) <= PosDet6AOffStep;
							--~ when PosDet7AStepAddr => DataOut(15 downto 0) <= PosDet7AOnStep; DataOut(31 downto 16) <= PosDet7AOffStep;
							
							--~ when PosDet0BStepAddr => DataOut(15 downto 0) <= PosDet0BOnStep; DataOut(31 downto 16) <= PosDet0BOffStep;
							--~ when PosDet1BStepAddr => DataOut(15 downto 0) <= PosDet1BOnStep; DataOut(31 downto 16) <= PosDet1BOffStep;
							--~ when PosDet2BStepAddr => DataOut(15 downto 0) <= PosDet2BOnStep; DataOut(31 downto 16) <= PosDet2BOffStep;
							--~ when PosDet3BStepAddr => DataOut(15 downto 0) <= PosDet3BOnStep; DataOut(31 downto 16) <= PosDet3BOffStep;
							--~ when PosDet4BStepAddr => DataOut(15 downto 0) <= PosDet4BOnStep; DataOut(31 downto 16) <= PosDet4BOffStep;
							--~ when PosDet5BStepAddr => DataOut(15 downto 0) <= PosDet5BOnStep; DataOut(31 downto 16) <= PosDet5BOffStep;
							--~ when PosDet6BStepAddr => DataOut(15 downto 0) <= PosDet6BOnStep; DataOut(31 downto 16) <= PosDet6BOffStep;
							--~ when PosDet7BStepAddr => DataOut(15 downto 0) <= PosDet7BOnStep; DataOut(31 downto 16) <= PosDet7BOffStep;

							when PosDetHomeAOnStepAddr => DataOut(15 downto 0) <= PosDetHomeAOnStep; DataOut(31 downto 16) <= x"0000";
							when PosDetHomeAOffStepAddr => DataOut(15 downto 0) <= PosDetHomeAOffStep; DataOut(31 downto 16) <= x"0000";
							when PosDetA0OnStepAddr => DataOut(15 downto 0) <= PosDetA0OnStep; DataOut(31 downto 16) <= x"0000";
							when PosDetA0OffStepAddr => DataOut(15 downto 0) <= PosDetA0OffStep; DataOut(31 downto 16) <= x"0000";
							when PosDetA1OnStepAddr => DataOut(15 downto 0) <= PosDetA1OnStep; DataOut(31 downto 16) <= x"0000";
							when PosDetA1OffStepAddr => DataOut(15 downto 0) <= PosDetA1OffStep; DataOut(31 downto 16) <= x"0000";
							when PosDetA2OnStepAddr => DataOut(15 downto 0) <= PosDetA2OnStep; DataOut(31 downto 16) <= x"0000";
							when PosDetA2OffStepAddr => DataOut(15 downto 0) <= PosDetA2OffStep; DataOut(31 downto 16) <= x"0000";
							
							when PosDetHomeBOnStepAddr => DataOut(15 downto 0) <= PosDetHomeBOnStep; DataOut(31 downto 16) <= x"0000";
							when PosDetHomeBOffStepAddr => DataOut(15 downto 0) <= PosDetHomeBOffStep; DataOut(31 downto 16) <= x"0000";
							when PosDetB0OnStepAddr => DataOut(15 downto 0) <= PosDetB0OnStep; DataOut(31 downto 16) <= x"0000";
							when PosDetB0OffStepAddr => DataOut(15 downto 0) <= PosDetB0OffStep; DataOut(31 downto 16) <= x"0000";
							when PosDetB1OnStepAddr => DataOut(15 downto 0) <= PosDetB1OnStep; DataOut(31 downto 16) <= x"0000";
							when PosDetB1OffStepAddr => DataOut(15 downto 0) <= PosDetB1OffStep; DataOut(31 downto 16) <= x"0000";
							when PosDetB2OnStepAddr => DataOut(15 downto 0) <= PosDetB2OnStep; DataOut(31 downto 16) <= x"0000";
							when PosDetB2OffStepAddr => DataOut(15 downto 0) <= PosDetB2OffStep; DataOut(31 downto 16) <= x"0000";
							
							when PosDet0AOnStepAddr => DataOut(15 downto 0) <= PosDet0AOnStep; DataOut(31 downto 16) <= x"0000";
							when PosDet0AOffStepAddr => DataOut(15 downto 0) <= PosDet0AOffStep; DataOut(31 downto 16) <= x"0000";
							when PosDet1AOnStepAddr => DataOut(15 downto 0) <= PosDet1AOnStep; DataOut(31 downto 16) <= x"0000";
							when PosDet1AOffStepAddr => DataOut(15 downto 0) <= PosDet1AOffStep; DataOut(31 downto 16) <= x"0000";
							when PosDet2AOnStepAddr => DataOut(15 downto 0) <= PosDet2AOnStep; DataOut(31 downto 16) <= x"0000";
							when PosDet2AOffStepAddr => DataOut(15 downto 0) <= PosDet2AOffStep; DataOut(31 downto 16) <= x"0000";
							when PosDet3AOnStepAddr => DataOut(15 downto 0) <= PosDet3AOnStep; DataOut(31 downto 16) <= x"0000";
							when PosDet3AOffStepAddr => DataOut(15 downto 0) <= PosDet3AOffStep; DataOut(31 downto 16) <= x"0000";
							when PosDet4AOnStepAddr => DataOut(15 downto 0) <= PosDet4AOnStep; DataOut(31 downto 16) <= x"0000";
							when PosDet4AOffStepAddr => DataOut(15 downto 0) <= PosDet4AOffStep; DataOut(31 downto 16) <= x"0000";
							when PosDet5AOnStepAddr => DataOut(15 downto 0) <= PosDet5AOnStep; DataOut(31 downto 16) <= x"0000";
							when PosDet5AOffStepAddr => DataOut(15 downto 0) <= PosDet5AOffStep; DataOut(31 downto 16) <= x"0000";
							when PosDet6AOnStepAddr => DataOut(15 downto 0) <= PosDet6AOnStep; DataOut(31 downto 16) <= x"0000";
							when PosDet6AOffStepAddr => DataOut(15 downto 0) <= PosDet6AOffStep; DataOut(31 downto 16) <= x"0000";
							when PosDet7AOnStepAddr => DataOut(15 downto 0) <= PosDet7AOnStep; DataOut(31 downto 16) <= x"0000";
							when PosDet7AOffStepAddr => DataOut(15 downto 0) <= PosDet7AOffStep; DataOut(31 downto 16) <= x"0000";
							
							when PosDet0BOnStepAddr => DataOut(15 downto 0) <= PosDet0BOnStep; DataOut(31 downto 16) <= x"0000";
							when PosDet0BOffStepAddr => DataOut(15 downto 0) <= PosDet0BOffStep; DataOut(31 downto 16) <= x"0000";
							when PosDet1BOnStepAddr => DataOut(15 downto 0) <= PosDet1BOnStep; DataOut(31 downto 16) <= x"0000";
							when PosDet1BOffStepAddr => DataOut(15 downto 0) <= PosDet1BOffStep; DataOut(31 downto 16) <= x"0000";
							when PosDet2BOnStepAddr => DataOut(15 downto 0) <= PosDet2BOnStep; DataOut(31 downto 16) <= x"0000";
							when PosDet2BOffStepAddr => DataOut(15 downto 0) <= PosDet2BOffStep; DataOut(31 downto 16) <= x"0000";
							when PosDet3BOnStepAddr => DataOut(15 downto 0) <= PosDet3BOnStep; DataOut(31 downto 16) <= x"0000";
							when PosDet3BOffStepAddr => DataOut(15 downto 0) <= PosDet3BOffStep; DataOut(31 downto 16) <= x"0000";
							when PosDet4BOnStepAddr => DataOut(15 downto 0) <= PosDet4BOnStep; DataOut(31 downto 16) <= x"0000";
							when PosDet4BOffStepAddr => DataOut(15 downto 0) <= PosDet4BOffStep; DataOut(31 downto 16) <= x"0000";
							when PosDet5BOnStepAddr => DataOut(15 downto 0) <= PosDet5BOnStep; DataOut(31 downto 16) <= x"0000";
							when PosDet5BOffStepAddr => DataOut(15 downto 0) <= PosDet5BOffStep; DataOut(31 downto 16) <= x"0000";
							when PosDet6BOnStepAddr => DataOut(15 downto 0) <= PosDet6BOnStep; DataOut(31 downto 16) <= x"0000";
							when PosDet6BOffStepAddr => DataOut(15 downto 0) <= PosDet6BOffStep; DataOut(31 downto 16) <= x"0000";
							when PosDet7BOnStepAddr => DataOut(15 downto 0) <= PosDet7BOnStep; DataOut(31 downto 16) <= x"0000";
							when PosDet7BOffStepAddr => DataOut(15 downto 0) <= PosDet7BOffStep; DataOut(31 downto 16) <= x"0000";
				
							
							when others =>

								DataOut <= x"BAADC0DE";
								
						end case;
						
					else
					
						ReadAck <= '1';
						
					end if;
					
				end if;
				
				if (ReadReq = '0') then
			
					--ReadReq falling edge				
					if (LastReadReq = '1') then --wait a clock before doing anything or else the uC never actaully gets the data...
					
						LastReadReq <= '0';
					
					else --ok, actually "finish" the read:
					
						ReadAck <= '0';					
						
						--If timing is good, this doesn't do anything. If the fpga is lagging the processor reads will all be 82's. Yeah, we tested that in practice; don't enable this lol.
						--DataOut <= x"9182"; 
						
						ReadUart0 <= '0';						
						ReadUart1 <= '0';						
						ReadUart2 <= '0';		
						ReadUart3 <= '0';		
						ReadUartUsb <= '0';		
						ReadUartGps <= '0';		
					
					end if;
					
				end if;

				if (WriteReq = '1') then
				
					--WriteReq Rising Edge
					if (LastWriteReq = '0') then
					
						LastWriteReq <= '1';
					
						WriteAck <= '0';
									
						case Address_i is
														
								
							--Monitor A/D

							when MonitorAdcSample =>

								MonitorAdcReset <= '1';
							
							when MonitorAdcReadChannel =>

								ReadMonitorAdcSample <= '1';
								MonitorAdcChannelReadIndex_i <= DataIn(4 downto 0);
								
							when MonitorAdcSpiXferAddr =>
							
								MonitorAdcSpiXferStart <= '1';
								MonitorAdcSpiDataIn <= DataIn(7 downto 0);
								
							when MonitorAdcSpiFrameEnableAddr =>
								
								MonitorAdcSpiFrameEnable_i <= DataIn(0);
							
							

							--RS-422
							
							when Uart0FifoAddr =>

								WriteUart0 <= '1';
								Uart0TxFifoData <= DataIn(7 downto 0);
								
							when Uart0FifoStatusAddr =>

								Uart0FifoReset <= '1';
								
							when Uart1FifoAddr =>

								WriteUart1 <= '1';
								Uart1TxFifoData <= DataIn(7 downto 0);
								
							when Uart1FifoStatusAddr =>

								Uart1FifoReset <= '1';
								
							when Uart2FifoAddr =>

								WriteUart2 <= '1';
								Uart2TxFifoData <= DataIn(7 downto 0);
								
							when Uart2FifoStatusAddr =>

								Uart2FifoReset <= '1';
								
							when Uart3FifoAddr =>

								WriteUart3 <= '1';
								Uart3TxFifoData <= DataIn(7 downto 0);
								
							when Uart3FifoStatusAddr =>

								Uart3FifoReset <= '1';
								
							when UartUsbFifoAddr =>

								WriteUartUsb <= '1';
								UartUsbTxFifoData <= DataIn(7 downto 0);
								
							when UartUsbFifoStatusAddr =>

								UartUsbFifoReset <= '1';
							
							when UartGpsFifoAddr =>

								WriteUartGps <= '1';
								UartGpsTxFifoData <= DataIn(7 downto 0);
								
							when UartGpsFifoStatusAddr =>

								UartGpsFifoReset <= '1';
							
							--Uart Clock dividers
							when UartClockDividersAddr =>

								Uart0ClkDivider_i <= DataIn(7 downto 0);
								Uart1ClkDivider_i <= DataIn(15 downto 8);
								Uart2ClkDivider_i <= DataIn(23 downto 16);
								Uart3ClkDivider_i <= DataIn(31 downto 24);
								
								
														
							--Timing
						
							when ClockSteeringDacSetpointAddr =>

								PPSCountReset <= '1';
								WriteClkDac <= '1';
								
								ClkDacWrite <= DataIn(15 downto 0);
								
								
								
								
							--MotorControlStatusAddr
							when MotorControlStatusAddr =>

								MotorSeekStep_i <= DataIn(15 downto 0);
								
								
							--ControlRegisterAddr
							when ControlRegisterAddr =>

								PosLedsEnA_i <= DataIn(0);
								PosLedsEnB_i <= DataIn(1);
								MotorEnable_i <= DataIn(2);
								ResetSteps_i <= DataIn(3);
								
								nFaultClr1V <= DataIn(8);
								nFaultClr3V <= DataIn(9);
								nFaultClr5V <= DataIn(10);
								PowernEn5V_i <= DataIn(11);
								nPowerCycClr <= DataIn(12);
								LedR_i <= DataIn(13);
								LedG_i <= DataIn(14);
								LedB_i <= DataIn(15);
								
								Uart0OE_i <= DataIn(16);
								Uart1OE_i <= DataIn(17);
								Uart2OE_i <= DataIn(18);
								Uart3OE_i <= DataIn(19);
								Ux1SelJmp_i <= DataIn(20);
								Ux2SelJmp_i <= DataIn(21);
								PPSCountReset <= DataIn(22);	
								
								
							when others => 


						end case;
					else

						WriteAck <= '1';					
						
					end if;

				end if;
				
				if (WriteReq = '0') then
			
					--WriteReq falling edge				
					if (LastWriteReq = '1') then
					
						LastWriteReq <= '0';
						
					else
					
						WriteAck <= '0';
						
						ReadMonitorAdcSample <= '0';
						MonitorAdcReset <= '0';
						MonitorAdcSpiXferStart <= '0';
							
						PPSCountReset <= '0';						
						
						WriteClkDac <= '0';		

						WriteUart0 <= '0';		
						Uart0FifoReset <= '0';						
						WriteUart1 <= '0';		
						Uart1FifoReset <= '0';						
						WriteUart2 <= '0';		
						Uart2FifoReset <= '0';						
						WriteUart3 <= '0';		
						Uart3FifoReset <= '0';						
						WriteUartUsb <= '0';		
						UartUsbFifoReset <= '0';						
						WriteUartGps <= '0';		
						UartGpsFifoReset <= '0';			

						nFaultClr1V <= '0';			
						nFaultClr3V <= '0';			
						nFaultClr5V <= '0';			
						nPowerCycClr <= '0';												
					
					end if;
					
				end if;
				
			end if;

		end if;
		
	end process;

end RegisterSpace;


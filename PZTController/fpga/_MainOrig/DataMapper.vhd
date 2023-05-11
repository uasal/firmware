--------------------------------------------------------------------------------
-- Zonge DNT GPS Board PC/104 Firmware
--
-- $Revision: 1.23 $
-- $Date: 2010/04/01 00:02:11 $
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity DataMapperPorts is
	generic (
		RAM_ADDRESS_BITS : natural := 8;
		FIFO_BITS : natural := 9;
		MUX_ADDRESS_BITS : natural := 4 --;
	);
	port (
	
		clk : in std_logic;
		
		-- Data Flow:
		Address : in std_logic_vector(RAM_ADDRESS_BITS - 1 downto 0); -- this is fucked, but vhdl can't figure out that RAM_ADDRESS_BITS is a constant because it's in a generic map...
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
		DeSyncCompleted : in std_logic;		
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
end DataMapperPorts;

architecture DataMapper of DataMapperPorts is

	-- this is fucked, but vhdl can't figure out that RAM_ADDRESS_BITS is a constant because it's in a generic map...so we do this whole circle-jerk
	constant MAX_ADDRESS_BITS : natural := RAM_ADDRESS_BITS;
	signal Address_i : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0);
	
	constant BuildNumAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0000#, MAX_ADDRESS_BITS));
	constant SerialNumAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0004#, MAX_ADDRESS_BITS));
	constant PPSCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0008#, MAX_ADDRESS_BITS));
	constant ClockSteeringDacAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#000C#, MAX_ADDRESS_BITS));
	constant AdcPrescaleAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0010#, MAX_ADDRESS_BITS));
	constant AdcPeriodAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0014#, MAX_ADDRESS_BITS));
	constant AdcDutyAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0018#, MAX_ADDRESS_BITS));
	--~ constant AdcConvAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#001C#, MAX_ADDRESS_BITS));
	constant SarAdcSampleAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0020#, MAX_ADDRESS_BITS));
	constant SarAdcSampleCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0028#, MAX_ADDRESS_BITS));
	constant FifoStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#002C#, MAX_ADDRESS_BITS));
	constant GpsUartAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0030#, MAX_ADDRESS_BITS));
	constant GpsUartCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0034#, MAX_ADDRESS_BITS));
	--~ constant UsbTxUartAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0038#, MAX_ADDRESS_BITS));
	--~ constant UsbTxUartCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#003C#, MAX_ADDRESS_BITS));
	constant GpsMillisecondsAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0040#, MAX_ADDRESS_BITS)); --all time below weeks, in mS units.
	constant SyncAdcAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#004C#, MAX_ADDRESS_BITS));
	constant PowerControlAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0050#, MAX_ADDRESS_BITS));
	constant BoardControlAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0054#, MAX_ADDRESS_BITS));
	constant TimingStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0058#, MAX_ADDRESS_BITS));
	constant BoardControlStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#005C#, MAX_ADDRESS_BITS));
	constant SpiExtInUseAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0060#, MAX_ADDRESS_BITS));
	constant SpiExtAddrAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0064#, MAX_ADDRESS_BITS));
	--~ constant MuxDivisorAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0068#, MAX_ADDRESS_BITS)); --now: DisciplineAccyPpb
	--~ constant MuxChannelAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#006C#, MAX_ADDRESS_BITS));
	constant AdcStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0070#, MAX_ADDRESS_BITS));
	constant UsbUartAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0074#, MAX_ADDRESS_BITS));
	constant UsbUartCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0078#, MAX_ADDRESS_BITS));
	constant UsbSwAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#007C#, MAX_ADDRESS_BITS)); --So we can connect/disconnect the CP2103 and LPC2148 from the actual usb connector
	constant ZigUartAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0080#, MAX_ADDRESS_BITS));
	constant ZigUartCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0084#, MAX_ADDRESS_BITS));
	constant UartMuxAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0088#, MAX_ADDRESS_BITS));
	constant SpiTxUartAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#008C#, MAX_ADDRESS_BITS));
	constant SpiTxUartCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0090#, MAX_ADDRESS_BITS));
	constant SpiRxUartAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0094#, MAX_ADDRESS_BITS));
	constant SpiRxUartCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0098#, MAX_ADDRESS_BITS));
	constant ZBusAddrOutAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#009C#, MAX_ADDRESS_BITS));
	constant ZBusAddrInAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00A0#, MAX_ADDRESS_BITS));
	constant ZigTxUartAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00A4#, MAX_ADDRESS_BITS));
	constant ZigTxUartCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00A8#, MAX_ADDRESS_BITS));
	constant AClkUartAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00AC#, MAX_ADDRESS_BITS));
	constant AClkUartCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00B0#, MAX_ADDRESS_BITS));
	constant AClkTxUartAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00B4#, MAX_ADDRESS_BITS));
	constant AClkTxUartCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00B8#, MAX_ADDRESS_BITS));
	constant AdcGainAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00BC#, MAX_ADDRESS_BITS));
	constant AdcClkDividerAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00C0#, MAX_ADDRESS_BITS));
	constant ForcePnDAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00C4#, MAX_ADDRESS_BITS));
	constant SarPPSAdcPhaseCmpAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00C8#, MAX_ADDRESS_BITS));
	--~ constant DeAdcSampleAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00CC#, MAX_ADDRESS_BITS));
	--~ constant DeAdcSampleCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00D4#, MAX_ADDRESS_BITS));
	--~ constant DePPSAdcPhaseCmpAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00D8#, MAX_ADDRESS_BITS));
	--~ constant DeAdcControlRegisterAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00E0#, MAX_ADDRESS_BITS));
	constant PPSRtcPhaseCmpAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00E4#, MAX_ADDRESS_BITS));
	constant ClockDacAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00E8#, MAX_ADDRESS_BITS));
	constant PPSPeriodDutyPhaseCmpAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00EC#, MAX_ADDRESS_BITS));
	constant ZBusTransactionAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00F0#, MAX_ADDRESS_BITS));
	constant ZBusReadbackAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#00F4#, MAX_ADDRESS_BITS));
	constant SarSamplesToAverageAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0100#, MAX_ADDRESS_BITS));
	constant XMTUartAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0104#, MAX_ADDRESS_BITS));
	constant XMTUartCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#01008#, MAX_ADDRESS_BITS));
	constant XMTTxUartAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#010C#, MAX_ADDRESS_BITS));
	constant XMTTxUartCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0110#, MAX_ADDRESS_BITS));
	constant LastSPIExtAddrAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0114#, MAX_ADDRESS_BITS));
	constant SyncSummaryAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0118#, MAX_ADDRESS_BITS));
	constant SarSamplesPerSecondAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#011C#, MAX_ADDRESS_BITS));
	constant ChopperAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16#0120#, MAX_ADDRESS_BITS));
	
	--Control Signals
	signal SyncPeriodDuty_i :  std_logic;
	signal SyncAdc_i :  std_logic;	
	signal DutyOff_i :  std_logic := '1'; --duty always starts off off.
	signal GeneratePps_i :  std_logic := '0';	
	signal UsingAtomicClock_i :  std_logic := '0';		
	signal SDPower_i :  std_logic := '1';	
	signal RadioPower_i :  std_logic := '1';	
	signal SpiExtAddr_i : std_logic_vector(7 downto 0) := x"07"; -- this is what spi address we are supposed to respond to; if zero, we are master, else slave (hence the default)
	signal SarSyncCompletedLatched :  std_logic := '0';		
	signal SarAdcOverrange_i :  std_logic := '0';		
	signal SarAdcSampleFifoFull_i :  std_logic := '0';		
	signal AdcStatusRead :  std_logic := '0';	
	signal TxTriggerAdc_i :  std_logic := '0';
	signal PPSTriggerAdc_i :  std_logic := '0';	
	signal PeriodTriggerQuadrant_i :  std_logic := '0';		
	signal DutyTriggerQuadrant_i :  std_logic := '0';		
	signal PeriodTriggerEither_i :  std_logic := '0';		
	signal DutyTriggerEither_i :  std_logic := '1';			
	signal UsbSwitch_i :  std_logic := '0';	--default to zero so we get the uart debug log by default. We should switch to the internal usb for networking after bootup.
	signal SarAdcSampleReaded :  std_logic;
	signal UartMux_i :  std_logic_vector(7 downto 0) := x"00";		
	signal ZBusAddr_i : std_logic_vector(7 downto 0);
	signal ForcePnD_i : std_logic := '0'; --Fixme: for whatever reason, this still always shows up as '1' at boot!
	signal ForcedPeriod_i : std_logic := '1';
	signal ForcedDuty_i : std_logic := '1';
	signal LatchRtc : std_logic := '0';
	signal LastLatchRtc : std_logic := '0';
	signal SecondsIn_i : std_logic_vector(21 downto 0);
	signal Milliseconds_i : std_logic_vector(9 downto 0);
	signal SecondsOut_i : std_logic_vector(21 downto 0);
	signal SetTime_i : std_logic := '0';
	signal LastSetTime : std_logic := '0';
	signal AdcClkDivider_i : std_logic_vector(15 downto 0) := x"002F"; -- x2F: 100M / 2 / 48 = 1MHz
	signal AdcGain_i : std_logic_vector(5 downto 0) := "000100"; -- x100 = Gain of 1.
	--~ signal AdcGain_i : std_logic_vector(5 downto 0) := "000010"; -- x10 = Gain of 2.
	signal SarSamplesToAverage_i : std_logic_vector(15 downto 0) := x"03FF"; -- x3FF: 1MHz / 1024 = 1kHz; 16->19bit; x3FFF: 1MHz / 16384 = 64Hz = 21bit
	signal SyncSummary_i : std_logic_vector(31 downto 0) := x"00000000";	
	signal SarSamplesPerSecond_i : std_logic_vector(31 downto 0) := x"00000400";	
	signal ChopperEnable_i : std_logic := '0';
	
begin

	--~ Address_i(MAX_ADDRESS_BITS - 1 downto RAM_ADDRESS_BITS) <= std_logic_vector(to_unsigned(0, MAX_ADDRESS_BITS - RAM_ADDRESS_BITS));
	--~ Address_i(RAM_ADDRESS_BITS - 1 downto 0) <= Address;	
	--~ Address_i <= std_logic_vector(to_unsigned(0, MAX_ADDRESS_BITS - RAM_ADDRESS_BITS)) & Address;
	Address_i <= Address;
		
	SyncPeriodDuty <= SyncPeriodDuty_i;
	SyncAdc <= SyncAdc_i;
	DutyOff <= DutyOff_i;
	GeneratePps <= GeneratePps_i;
	UsingAtomicClock <= UsingAtomicClock_i;
	SDPower <= SDPower_i;
	RadioPower <= RadioPower_i;
	SpiExtAddr <= SpiExtAddr_i;
	UsbSwitch <= UsbSwitch_i;
	UartMux <= UartMux_i;
	ZBusAddrOut <= ZBusAddr_i;
	TxTriggerAdc <= TxTriggerAdc_i;
	PPSTriggerAdc <= PPSTriggerAdc_i;
	PeriodTriggerQuadrant <= PeriodTriggerQuadrant_i;
	DutyTriggerQuadrant <= DutyTriggerQuadrant_i;
	PeriodTriggerEither <= PeriodTriggerEither_i;
	DutyTriggerEither <= DutyTriggerEither_i;
	ForcePnD <= ForcePnD_i;
	ForcedPeriod <= ForcedPeriod_i;
	ForcedDuty <= ForcedDuty_i;
	AdcClkDivider <= AdcClkDivider_i;
	AdcGain <= AdcGain_i;
	SyncSummary <= SyncSummary_i;
	SarSamplesToAverage <= SarSamplesToAverage_i;
	SarSamplesPerSecond <= SarSamplesPerSecond_i;
	ChopperEnable <= ChopperEnable_i;
	
	process (clk)
	begin
		
		if ( (clk'event) and (clk = '1') ) then
			
			--AdcOverrange
			if (SarAdcOverrange = '1') then 			
				SarAdcOverrange_i <= '1'; --latch high			
			else				
				if (AdcStatusRead = '1') then				
					AdcStatusRead <= '0';					
					SarAdcOverrange_i <= SarAdcOverrange; --allow it to go back to zero if it's been read					
				end if;				
			end if;
			
			--AdcSampleFifoFull
			if (SarAdcSampleFifoFull = '1') then 			
				SarAdcSampleFifoFull_i <= '1'; --latch high			
			else				
				if (AdcStatusRead = '1') then				
					AdcStatusRead <= '0';					
					SarAdcSampleFifoFull_i <= SarAdcSampleFifoFull; --allow it to go back to zero if it's been read					
				end if;				
			end if;
						
			--SyncCompleted
			if (SarSyncCompleted = '1') then 			
				SarSyncCompletedLatched <= '1'; --latch high			
			else				
				if (SyncAdc_i = '1') then				
					SarSyncCompletedLatched <= SarSyncCompleted; --allow it to go back to zero if an unsucessful sync occurs, otherwise, keep it latched.
				end if;				
			end if;
			
			--Grab clock so we get the whole thing matching if it's in flux...otherwise slow spi bus can read the msec just before the second rolls over, and the second just after
			if (LastLatchRtc /= LatchRtc) then
			
				LastLatchRtc <= LatchRtc;
				
				if (LatchRtc = '1') then
				
					SecondsIn_i <= SecondsIn;				
					Milliseconds_i <= Milliseconds;
					
				end if;
				
			end if;
			
			--Grab clock so we get the whole thing matching if it's in flux...otherwise slow spi bus can read the msec just before the second rolls over, and the second just after
			if (LastSetTime /= SetTime_i) then
			
				LastSetTime <= SetTime_i;
				
				if (SetTime_i = '1') then
				
					SecondsOut <= SecondsOut_i;				
					SetTime <= '1';
					--~ SetTime <= SetTime_i;
					
				end if;
				
			end if;
			
			if (SetTime_i = '0') then SetTime <= '0'; end if;
				
			-- Note:  The  behavior of read & write is subtly different since we handle both 8 & 16-bit transactions:
			-- Read: since no state is changed, we can always safely read all 16 bits, and only one req line is used;
			--	we just put the sensible value in the high byte, and it can be safely ignored for 8-bit xfers.
			-- Write: we need to explicitly write low & high bytes, so we need a complete datapath for each byte lo & hi.
			
			-- Another note: since we handle both registers and bram in the datapath, dependant only on address, 
			-- and, since many registers are read-only, we do alot of dummy writes to bram locations
			-- that cannot be read, since they are shadowed by a register.  This should be unimportant.
		
			if (DataReadReq = '1') then
				
				case Address_i is
				
					when BuildNumAddr =>

						DataFromRead <= BuildNum;
						DataReadAck <= '1';

					when SerialNumAddr =>

						DataFromRead <= DnaRegister(15 downto 0);
						DataReadAck <= '1';
						
					when SerialNumAddr + x"02" =>

						DataFromRead <= DnaRegister(31 downto 16);
						DataReadAck <= '1';
						
					
					when ClockSteeringDacAddr =>

						DataFromRead <= ClkDacReadback;
						DataReadAck <= '1';
						
					when ClockSteeringDacAddr + x"02" =>

						DataFromRead <= x"1A51";
						DataReadAck <= '1';
						
						
						
					when AdcPeriodAddr =>

						DataFromRead <= AdcPeriodDividerIn(15 downto 0);
						DataReadAck <= '1';
					
					when AdcPeriodAddr + x"02" =>

						DataFromRead <= AdcPeriodDividerIn(31 downto 16);
						DataReadAck <= '1';
						
					when AdcDutyAddr =>

						DataFromRead <= AdcDutyDividerIn(15 downto 0);
						DataReadAck <= '1';
						
					when AdcDutyAddr + x"02" =>

						DataFromRead <= AdcDutyDividerIn(31 downto 16);
						DataReadAck <= '1';

					when PPSCountAddr =>

						DataFromRead <= PPSCount(15 downto 0);
						DataReadAck <= '1';
						
					when PPSCountAddr + x"02" =>

						DataFromRead <= PPSCount(31 downto 16);
						DataReadAck <= '1';

					when SarAdcSampleAddr =>

						--When we hit the first address, we grab the data...
						SarReadAdcSample <= '1';
						DataFromRead <= SarAdcSample(15 downto 0);
						DataReadAck <= SarAdcSampleReadAck;
					
					when SarAdcSampleAddr + x"02" =>

						DataFromRead <= SarAdcSample(31 downto 16);
						DataReadAck <= '1';
					
					when SarAdcSampleAddr + x"04" =>

						DataFromRead <= SarAdcSample(47 downto 32);
						DataReadAck <= '1';
					
					when SarAdcSampleAddr + x"06" =>

						--get ready to say we are done with this sample so a new one can be preloaded...
						SarAdcSampleReaded <= '1';						
						DataFromRead <= SarAdcSample(63 downto 48);
						DataReadAck <= '1';
						
					when SarAdcSampleCountAddr =>
					
						DataFromRead(15) <= SarAdcSampleFifoFull;
						DataFromRead(14 downto 12) <= "000";
						DataFromRead(11 downto 0) <= SarAdcSampleCount;
						DataReadAck <= '1';
						
					when FifoStatusAddr =>

						DataFromRead(7) <= UsbUartFifoFull;
						DataFromRead(6) <= UsbUartFifoEmpty;
						DataFromRead(5) <= GpsUartFifoFull;
						DataFromRead(4) <= GpsUartFifoEmpty;
						DataFromRead(3) <= SarAdcSampleFifoFull;
						DataFromRead(2) <= '0';
						DataFromRead(1) <= SarAdcSampleFifoEmpty;
						DataFromRead(0) <= '0';
						DataReadAck <= '1';
						
					when FifoStatusAddr + x"01" =>

						DataFromRead(7) <= AClkOutTxdFifoEmpty;
						DataFromRead(6) <= AClkUartFifoEmpty;
						DataFromRead(5) <= ZigOutTxdFifoEmpty;
						DataFromRead(4) <= ZigUartFifoEmpty;
						DataFromRead(3) <= SpiTxUartFifoFull;
						DataFromRead(2) <= SpiTxUartFifoEmpty;
						DataFromRead(1) <= SpiRxUartFifoFull;
						DataFromRead(0) <= SpiRxUartFifoEmpty;
						DataReadAck <= '1';

					when GpsUartAddr =>

						ReadGpsUart <= '1';
						DataFromRead(15 downto 8) <= x"A1";
						DataFromRead(7 downto 0) <= GpsUart;
						DataReadAck <= GpsUartReadAck;
						
					when GpsUartCountAddr =>

						DataFromRead(15) <= GpsUartFifoFull;
						DataFromRead(14 downto FIFO_BITS) <= std_logic_vector(to_unsigned(0, 14 - (FIFO_BITS - 1)));
						DataFromRead(FIFO_BITS - 1 downto 0) <= GpsUartCount;
						DataReadAck <= '1';
	
					when GpsMillisecondsAddr =>

						LatchRtcLo <= '1';

						LatchRtc <= '1'; --first read addr; grab all matching contents at once!
						DataFromRead(7 downto 0) <= Milliseconds_i(7 downto 0);
						DataFromRead(9 downto 8) <= Milliseconds_i(9 downto 8);
						DataFromRead(15 downto 10) <= SecondsIn_i(5 downto 0);
						DataReadAck <= '1';
						
					when GpsMillisecondsAddr + x"02" =>
					
						LatchRtcHi <= '1';

						DataFromRead <= SecondsIn_i(21 downto 6);
						DataReadAck <= '1';

					when BoardControlAddr =>  --!! We don't really care about "A", since it's write-only (control addr)

						--BoardControl Byte
						DataFromRead(0) <= SyncPeriodDuty_i;
						DataFromRead(1) <= PPSDetected or GeneratePps_i;
						DataFromRead(2) <= SetChangedTime;
						DataFromRead(3) <= '0';
						DataFromRead(4) <= '0';
						DataFromRead(5) <= GeneratePps_i;
						DataFromRead(6) <= DutyOff_i;
						DataFromRead(7) <= UsingAtomicClock_i;
						DataFromRead(15 downto 11) <= "00000";
						DataReadAck <= '1';
						
					when TimingStatusAddr =>  

						DataFromRead(0) <= PeriodDutySynced;
						DataFromRead(1) <= PPSDetected or GeneratePps_i;
						DataFromRead(2) <= SetChangedTime;
						DataFromRead(3) <= AdcPeriod;
						DataFromRead(4) <= AdcDuty;
						DataFromRead(5) <= '0';						
						DataFromRead(7 downto 6) <= "00";
						DataFromRead(15 downto 11) <= "00000";
						DataReadAck <= '1';						
						
					when BoardControlStatusAddr =>  --!! This is an Odd addr!

						DataFromRead(0) <= PeriodDutySynced;
						DataFromRead(1) <= PPSDetected or GeneratePps_i;
						DataFromRead(2) <= SetChangedTime;
						DataFromRead(3) <= PeriodDutySynced;
						DataFromRead(4) <= PPSDetected or GeneratePps_i;
						DataFromRead(5) <= SetChangedTime;
						DataFromRead(6) <= '0';
						DataFromRead(7) <= '0';
						DataFromRead(15 downto 11) <= "00000";
						DataReadAck <= '1';
						
					when SyncAdcAddr =>
					
						DataFromRead(0) <= SyncAdc_i;
						DataFromRead(1) <= SarSyncCompleted;
						DataFromRead(2) <= TxTriggerAdc_i;
						DataFromRead(3) <= PeriodTriggerQuadrant_i;
						DataFromRead(4) <= DutyTriggerQuadrant_i;
						DataFromRead(5) <= PeriodTriggerEither_i;
						DataFromRead(6) <= DutyTriggerEither_i;
						DataFromRead(7) <= PPSTriggerAdc_i;
						DataFromRead(15 downto 11) <= "00000";
						DataReadAck <= '1';		
					
					when PowerControlAddr =>
					
						DataFromRead(0) <= SDPower_i;
						DataFromRead(1) <= RadioPower_i;
						DataFromRead(7 downto 2) <= "000000";
						DataFromRead(15 downto 11) <= "00000";
						DataReadAck <= '1';		

					when SpiExtInUseAddr =>
					
						DataFromRead(7 downto 0) <= SpiExtInUse;
						DataFromRead(15 downto 11) <= "00000";
						DataReadAck <= '1';		

					when SpiExtAddrAddr =>
					
						DataFromRead(7 downto 0) <= SpiExtAddr_i;
						DataFromRead(15 downto 11) <= "00000";
						DataReadAck <= '1';		
												
					when AdcStatusAddr =>
					
						DataFromRead(0) <= SarSyncCompletedLatched;
						DataFromRead(1) <= SarAdcOverrange_i;
						DataFromRead(2) <= '0';
						DataFromRead(3) <= '0';
						DataFromRead(4) <= AdcPeriod;
						DataFromRead(5) <= AdcDuty;
						DataFromRead(6) <= SarAdcSampleFifoFull_i;
						DataFromRead(7) <= '0';
						DataFromRead(15 downto 11) <= "00000";
						DataReadAck <= '1';
						
						AdcStatusRead <= '1';
						
					when UsbUartAddr =>

						ReadUsbUart <= '1';
						DataFromRead(15 downto 8) <= x"A1";
						DataFromRead(7 downto 0) <= UsbUart;
						DataReadAck <= UsbUartReadAck;

					when UsbUartCountAddr =>

						DataFromRead(15) <= UsbUartFifoFull;
						DataFromRead(14 downto FIFO_BITS) <= std_logic_vector(to_unsigned(0, 14 - (FIFO_BITS - 1)));
						DataFromRead(FIFO_BITS - 1 downto 0) <= UsbUartCount;
						DataReadAck <= '1';
						
					when UsbSwAddr =>
					
						DataFromRead(0) <= UsbSwitch_i;
						DataFromRead(7 downto 1) <= "0000000";
						DataFromRead(15 downto 11) <= "00000";
						DataReadAck <= '1';		
						
					when ZigUartAddr =>

						ReadZigUart <= '1';
						DataFromRead(15 downto 8) <= x"A1";
						DataFromRead(7 downto 0) <= ZigUart;
						DataReadAck <= ZigUartReadAck;
						
					when ZigUartCountAddr =>

						DataFromRead(15) <= ZigUartFifoFull;
						DataFromRead(14 downto FIFO_BITS) <= std_logic_vector(to_unsigned(0, 14 - (FIFO_BITS - 1)));
						DataFromRead(FIFO_BITS - 1 downto 0) <= ZigUartCount;
						DataReadAck <= '1';
						
					when UartMuxAddr =>
					
						DataFromRead(7 downto 0) <= UartMux_i;
						DataFromRead(15 downto 11) <= "00000";
						DataReadAck <= '1';		
					
					when SpiTxUartAddr =>

						ReadSpiTxUart <= '1';
						DataFromRead(15 downto 8) <= x"A1";
						DataFromRead(7 downto 0) <= SpiTxUartReadData;
						DataReadAck <= SpiTxUartReadAck;
						
					--~ when SpiTxUartCountAddr =>

						--~ DataFromRead(7) <= SpiTxUartFifoFull or SpiTxUartCount(10) or SpiTxUartCount(9) or SpiTxUartCount(8) or SpiTxUartCount(7);
						--~ DataFromRead(6 downto 0) <= SpiTxUartCount(6 downto 0);
						--~ DataReadAck <= '1';
					
					when SpiTxUartCountAddr =>

						DataFromRead(15) <= SpiTxUartFifoFull;
						DataFromRead(14 downto FIFO_BITS) <= std_logic_vector(to_unsigned(0, 14 - (FIFO_BITS - 1)));
						DataFromRead(FIFO_BITS - 1 downto 0) <= SpiTxUartCount;
						DataReadAck <= '1';
					
					when SpiRxUartAddr =>

						--When we hit the first address, we grab the data...
						ReadSpiRxUart <= '1';
						DataFromRead(15 downto 8) <= x"A1";
						DataFromRead(7 downto 0) <= SpiRxUartReadData;
						DataReadAck <= SpiRxUartReadAck;
						
					when SpiRxUartCountAddr =>
					
						DataFromRead(15) <= SpiRxUartFifoFull;
						DataFromRead(14 downto FIFO_BITS) <= std_logic_vector(to_unsigned(0, 14 - (FIFO_BITS - 1)));
						DataFromRead(FIFO_BITS - 1 downto 0) <= SpiRxUartCount;
						DataReadAck <= '1';
						
					when ZBusAddrOutAddr =>

						DataFromRead(7 downto 0) <= ZBusAddr_i;
						DataFromRead(15 downto 11) <= "00000";
						DataReadAck <= '1';
					
					when ZBusAddrInAddr =>

						DataFromRead(7 downto 0) <= ZBusAddrIn;
						DataFromRead(15 downto 11) <= "00000";
						DataReadAck <= '1';

					when ZBusReadbackAddr =>

						DataFromRead(7 downto 0) <= ZBusReadbackData;
						DataFromRead(15 downto 8) <= x"C9";
						DataReadAck <= '1';
						
					when ZigTxUartCountAddr =>

						DataFromRead(15) <= ZigOutTxdFifoFull;
						DataFromRead(14 downto FIFO_BITS) <= std_logic_vector(to_unsigned(0, 14 - (FIFO_BITS - 1)));
						DataFromRead(FIFO_BITS - 1 downto 0) <= ZigOutTxdCount;
						DataReadAck <= '1';
						
					when AClkUartAddr =>

						ReadAClkUart <= '1';
						DataFromRead(15 downto 8) <= x"A1";
						DataFromRead(7 downto 0) <= AClkUart;
						DataReadAck <= AClkUartReadAck;
						
					when AClkUartCountAddr =>

						DataFromRead(15) <= AClkUartFifoFull;
						DataFromRead(14 downto FIFO_BITS) <= std_logic_vector(to_unsigned(0, 14 - (FIFO_BITS - 1)));
						DataFromRead(FIFO_BITS - 1 downto 0) <= AClkUartCount;
						DataReadAck <= '1';
						
					when AClkTxUartCountAddr =>
					
						DataFromRead(15) <= AClkOutTxdFifoFull;
						DataFromRead(14 downto FIFO_BITS) <= std_logic_vector(to_unsigned(0, 14 - (FIFO_BITS - 1)));
						DataFromRead(FIFO_BITS - 1 downto 0) <= AClkOutTxdCount;
						DataReadAck <= '1';
						
					when XMTUartAddr =>

						--When we hit the first address, we grab the data...
						ReadXMTUart <= '1';
						DataFromRead(15 downto 8) <= x"A1";
						DataFromRead(7 downto 0) <= XMTUart;
						DataReadAck <= XMTUartReadAck;
						
					when XMTUartCountAddr =>

						DataFromRead(15) <= XMTUartFifoFull;
						DataFromRead(14 downto FIFO_BITS) <= std_logic_vector(to_unsigned(0, 14 - (FIFO_BITS - 1)));
						DataFromRead(FIFO_BITS - 1 downto 0) <= XMTUartCount;
						DataReadAck <= '1';
						
					when XMTTxUartCountAddr =>

						DataFromRead(15) <= XMTOutTxdFifoFull;
						DataFromRead(14 downto FIFO_BITS) <= std_logic_vector(to_unsigned(0, 14 - (FIFO_BITS - 1)));
						DataFromRead(FIFO_BITS - 1 downto 0) <= XMTOutTxdCount;
						DataReadAck <= '1';
						
					when PPSRtcPhaseCmpAddr =>

						DataFromRead <= PPSRtcPhaseCmp(15 downto 0);
						DataReadAck <= '1';
						
					when PPSRtcPhaseCmpAddr + x"02" =>

						DataFromRead <= PPSRtcPhaseCmp(31 downto 16);
						DataReadAck <= '1';
						
					when SarPPSAdcPhaseCmpAddr =>

						DataFromRead <= SarPPSAdcPhaseCmp(15 downto 0);
						DataReadAck <= '1';
						
					when SarPPSAdcPhaseCmpAddr + x"02" =>

						DataFromRead <= SarPPSAdcPhaseCmp(31 downto 16);
						DataReadAck <= '1';
						
					when PPSPeriodDutyPhaseCmpAddr =>

						DataFromRead <= PPSPeriodDutyPhaseCmp(15 downto 0);
						DataReadAck <= '1';
						
					when PPSPeriodDutyPhaseCmpAddr + x"02" =>

						DataFromRead <= PPSPeriodDutyPhaseCmp(31 downto 16);
						DataReadAck <= '1';
						
					when ForcePnDAddr =>
					
						DataFromRead(0) <= ForcePnD_i;
						DataFromRead(1) <= ForcedPeriod_i;
						DataFromRead(2) <= ForcedDuty_i;
						DataFromRead(7 downto 3) <= "00000";
						DataFromRead(15 downto 11) <= "00000";
						DataReadAck <= '1';
					
					when AdcGainAddr =>
					
						DataFromRead(5 downto 0) <= AdcGain_i;
						DataFromRead(7 downto 6) <= "00";
						DataFromRead(15 downto 11) <= "00000";
												
					when AdcClkDividerAddr =>

						DataFromRead <= AdcClkDivider_i;
						DataReadAck <= '1';
						
					when ClockDacAddr =>

						DataFromRead <= ClkDacReadback;
						DataReadAck <= '1';
					
					when SarSamplesToAverageAddr =>

						DataFromRead <= SarSamplesToAverage_i;
						DataReadAck <= '1';

					when LastSPIExtAddrAddr =>

						DataFromRead(6 downto 0) <= LastSPIExtAddr;
						DataFromRead(15 downto 7) <= "000000000";
						DataReadAck <= '1';
						
					when SyncSummaryAddr =>

						DataFromRead <= SyncSummary_i(15 downto 0);
						DataReadAck <= '1';
						
					when SyncSummaryAddr + x"02" =>

						DataFromRead <= SyncSummary_i(31 downto 16);
						DataReadAck <= '1';
						
					when SarSamplesPerSecondAddr =>

						DataFromRead <= SarSamplesPerSecond_i(15 downto 0);
						DataReadAck <= '1';
						
					when SarSamplesPerSecondAddr + x"02" =>

						DataFromRead <= SarSamplesPerSecond_i(31 downto 16);
						DataReadAck <= '1';
						
					when ChopperAddr =>

						DataFromRead(0) <= ChopperEnable_i;
						DataFromRead(15 downto 1) <= "000000000000000";
						DataReadAck <= '1';
						
					when others => -- Get it from BRAM!

						DataFromRead <= x"3141";
						DataReadAck <= '0';
						
				end case;

			else -- No ReadReq (probably doing a write)

				--Reset req req's for fifos if we did a read...
				
				if (SarAdcSampleReaded = '1') then
					SarAdcSampleReaded <= '0';
					SarReadAdcSample <= '0'; --has to stay high for all bytes of the transfer so we can load a new sample from the fifo on the falling edge...
				end if;
				ReadGpsUart <= '0';
				ReadUsbUart <= '0';
				ReadZigUart <= '0';
				ReadSpiTxUart <= '0';
				ReadSpiRxUart <= '0';
				ReadAClkUart <= '0';
				ReadXMTUart <= '0';				
				LatchRtc <= '0';
				LatchRtcHi <= '0';
				LatchRtcLo <= '0';
				
				DataFromRead <= x"6282"; --Do this and it's all you ever read - the arm is that slow???
				DataReadAck <= '0';
								
			end if;

			if (DataWriteReq = '1') then
			
				case Address_i is
				
					when AdcPeriodAddr =>

						AdcPeriodDividerOut(15 downto 0) <= DatatoWrite;
						AdcPeriodDividerOut(31 downto 16) <= AdcPeriodDividerIn(31 downto 16);
						DataWriteAck <= '1';
						
					when AdcPeriodAddr + x"02" =>

						AdcPeriodDividerOut(15 downto 0) <= AdcPeriodDividerIn(15 downto 0);
						AdcPeriodDividerOut(31 downto 16) <= DatatoWrite;
						DataWriteAck <= '1';
										
					when AdcDutyAddr =>

						AdcDutyDividerOut(15 downto 0) <= DatatoWrite; --byte 0
						AdcDutyDividerOut(31 downto 16) <= AdcDutyDividerIn(31 downto 16); --byte 3 byte 2 byte 1
						DataWriteAck <= '1';
						
					when AdcDutyAddr + x"02" =>

						AdcDutyDividerOut(15 downto 0) <= AdcDutyDividerIn(15 downto 0); -- byte 0 byte 1
						AdcDutyDividerOut(31 downto 16) <= DatatoWrite; --byte 2
						DataWriteAck <= '1';
						
					when GpsMillisecondsAddr =>

						--We don't actually set mS, the PPS does. --byte 0
						SecondsOut_i(5 downto 0) <= DatatoWrite(15 downto 10); --byte 1
						DataWriteAck <= '1';
						
						SetTimeLo <= '1';
						
					when GpsMillisecondsAddr + x"02" =>

						SetTimeHi <= '1';
						
						SecondsOut_i(21 downto 6) <= DatatoWrite; --byte 2 
						DataWriteAck <= '1';
						
						SetTime_i <= '1'; --this is the final write for 16-bit transfers

					when BoardControlAddr =>

						SyncPeriodDuty_i <= DatatoWrite(0);
						GeneratePps_i <= DatatoWrite(5);
						DutyOff_i <= DatatoWrite(6);			
						UsingAtomicClock_i <= DatatoWrite(7);			
						DataWriteAck <= '1';
						
					when ClockSteeringDacAddr =>

						PPSCountReset <= '1';
						WriteClkDac <= '1';
						ClkDacWrite <= DatatoWrite;
						DataWriteAck <= '1';
						
					when SarAdcSampleAddr => --writing to the fifo adress clears the fifo...
						
						SarAdcFifoReset <= '1';
						DataWriteAck <= '1';
									
					--~ when GpsUartAddr => --writing to the fifo adress clears the fifo...
						
						--~ GpsFifoReset <= '1';
						--~ DataWriteAck <= '1';
						
					when GpsUartAddr =>

						--When we hit the first address, we grab the data...
						WriteGpsOutTxd <= '1';
						GpsOutTxdWriteData <= DatatoWrite(7 downto 0);
		 				DataWriteAck <= '1';
						
					when SyncAdcAddr =>
					
						SyncAdc_i <= DatatoWrite(0);
						TxTriggerAdc_i <= DatatoWrite(2);
						PeriodTriggerQuadrant_i <= DatatoWrite(3);
						DutyTriggerQuadrant_i <= DatatoWrite(4);
						PeriodTriggerEither_i <= DatatoWrite(5);
						DutyTriggerEither_i <= DatatoWrite(6);
						PPSTriggerAdc_i <= DatatoWrite(7);

						DataWriteAck <= '1';
						
					when PowerControlAddr =>
					
						SDPower_i <= DatatoWrite(0);
						RadioPower_i <= DatatoWrite(1);
						DataWriteAck <= '1';
					
					when SpiExtAddrAddr =>
					
						SpiExtAddr_i <= DatatoWrite(7 downto 0);
						DataWriteAck <= '1';
						
					when AdcStatusAddr =>
					
						ResetSyncCompleted <= '1';
						DataWriteAck <= '1';
						
					when UsbUartAddr => --writing to the fifo adress clears the fifo...
						
						UsbFifoReset <= '1';
						DataWriteAck <= '1';
						
					when UsbSwAddr =>
					
						UsbSwitch_i <= DatatoWrite(0);
						DataWriteAck <= '1';
						
					when ZigUartAddr => --writing to the fifo adress clears the fifo...
						
						ZigFifoReset <= '1';
						DataWriteAck <= '1';
					
					when UartMuxAddr =>
					
						UartMux_i <= DatatoWrite(7 downto 0);
						DataWriteAck <= '1';
						
					when SpiTxUartAddr =>

						--When we hit the first address, we grab the data...
						WriteSpiTxUart <= '1';
						SpiTxUartWriteData <= DatatoWrite(7 downto 0);
						DataWriteAck <= '1';
						
					when SpiTxUartCountAddr =>

						SpiTxFifoReset <= '1';
						DataWriteAck <= '1';
					
					when SpiRxUartAddr =>

						--When we hit the first address, we grab the data...
						WriteSpiRxUart <= '1';
						SpiRxUartWriteData <= DatatoWrite(7 downto 0);
						DataWriteAck <= '1';
						
					when SpiRxUartCountAddr =>

						SpiRxFifoReset <= '1';
						DataWriteAck <= '1';
						
					when ZBusAddrOutAddr =>

						--When we write to this addr, have the uart initiate a transer with the 'set...'signal:
						SetZBusAddr <= '1';
						
						ZBusAddr_i <= DatatoWrite(7 downto 0);
						DataWriteAck <= '1';
						
					when ZBusTransactionAddr =>

						--When we hit the first address, we grab the data...
						WriteZBus <= '1';
						ZBusWriteData <= DatatoWrite(7 downto 0);
						DataWriteAck <= '1';
						
					when ZBusAddrInAddr =>

						DataWriteAck <= '1';
						
					when ZigTxUartAddr =>

						--When we hit the first address, we grab the data...
						WriteZigOutTxd <= '1';
						ZigOutTxdWriteData <= DatatoWrite(7 downto 0);
		 				DataWriteAck <= '1';
						
					when AClkUartAddr => --writing to the fifo adress clears the fifo...
						
						AClkFifoReset <= '1';
						DataWriteAck <= '1';

					when AClkTxUartAddr =>

						--When we hit the first address, we grab the data...
						WriteAClkOutTxd <= '1';
						AClkOutTxdWriteData <= DatatoWrite(7 downto 0);
		 				DataWriteAck <= '1';
						
					when XMTUartAddr => --writing to the fifo adress clears the fifo...
						
						XMTFifoReset <= '1';
						DataWriteAck <= '1';

					when XMTTxUartAddr =>

						--When we hit the first address, we grab the data...
						WriteXMTOutTxd <= '1';
						XMTOutTxdWriteData <= DatatoWrite(7 downto 0);
		 				DataWriteAck <= '1';
					
					when ForcePnDAddr =>
					
						ForcePnD_i <= DatatoWrite(0);
						ForcedPeriod_i <= DatatoWrite(1);
						ForcedDuty_i <= DatatoWrite(2);
						DataWriteAck <= '1';
						
					when AdcGainAddr =>
					
						AdcGain_i <= DatatoWrite(5 downto 0);
		 				DataWriteAck <= '1';
											
					when AdcClkDividerAddr =>

						AdcClkDivider_i <= DatatoWrite;
						DataWriteAck <= '1';
						
					when ClockDacAddr =>

						WriteClkDac <= '1';
						ClkDacWrite <= DatatoWrite;
						DataWriteAck <= '1';
						
					when SarSamplesToAverageAddr =>

						SarSamplesToAverage_i <= DatatoWrite;
						DataWriteAck <= '1';
						
					when SyncSummaryAddr =>

						SyncSummary_i(15 downto 0) <= DatatoWrite;
						DataWriteAck <= '1';
						
					when SyncSummaryAddr + x"02" =>

						SyncSummary_i(31 downto 16) <= DatatoWrite;
						DataWriteAck <= '1';
						
					when SarSamplesPerSecondAddr =>

						SarSamplesPerSecond_i(15 downto 0) <= DatatoWrite;
						DataWriteAck <= '1';
						
					when SarSamplesPerSecondAddr + x"02" =>

						SarSamplesPerSecond_i(31 downto 16) <= DatatoWrite;
						DataWriteAck <= '1';
						
					when ChopperAddr =>

						ChopperEnable_i <= DatatoWrite(0);
						DataWriteAck <= '1';

					when others => 

						DataWriteAck <= '0';

				end case;

			else -- No WriteReqLo (probably doing a read)
			
				ResetSyncCompleted <= '0';

				DataWriteAck <= '0';
				
				PPSCountReset <= '0';
				
				SetTime_i <= '0';
				
				SarAdcFifoReset <= '0';
				
				GpsFifoReset <= '0';
				
				UsbFifoReset <= '0';
				
				ZigFifoReset <= '0';
				
				WriteSpiTxUart <= '0';
				
				SpiTxFifoReset <= '0';
				
				WriteSpiRxUart <= '0';
				
				SpiRxFifoReset <= '0';
				
				SetZBusAddr <= '0';
				
				WriteZBus <= '0';
				
				WriteZigOutTxd <= '0';
				
				WriteGpsOutTxd <= '0';
				
				AClkFifoReset <= '0';
				
				WriteAClkOutTxd <= '0';
				
				XMTFifoReset <= '0';
				
				WriteXMTOutTxd <= '0';
				
				WriteClkDac <= '0';
				
				SetTimeHi <= '0';
						
				SetTimeLo <= '0';						
				
			end if;
			
		end if;

	end process;

end DataMapper;

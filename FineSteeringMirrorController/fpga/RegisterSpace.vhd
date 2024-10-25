--------------------------------------------------------------------------------
-- UA Extra-Solar Camera FSM Controller Project FPGA Firmware
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
		nHVEn1 : out std_logic;
		HVDis2 : out std_logic;
		PowernEnHV : out std_logic;	
		DacSelectMaxti : out std_logic;
		FaultNegV : in std_logic;
		Fault1V : in std_logic;
		Fault2VA : in std_logic;
		Fault2VD : in std_logic;
		Fault3VA : in std_logic;
		Fault3VD : in std_logic;
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
		LedR : out std_logic;
		LedG : out std_logic;
		LedB : out std_logic;
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
		WriteDacs : out std_logic; --do we wanna write all three Dac's at once? Seems likely...
		DacAReadback : in std_logic_vector(23 downto 0);
		DacBReadback : in std_logic_vector(23 downto 0);
		DacCReadback : in std_logic_vector(23 downto 0);		
		DacDReadback : in std_logic_vector(23 downto 0);		
		DacTransferComplete : in std_logic; --Prolly a bad idea if we try writing new data to the D/A's while a xfer is in progress...				

		-- FSM Readback A/Ds
		ReadAdcSample : out std_logic;
		AdcSampleToReadA : in std_logic_vector(47 downto 0);	
		AdcSampleToReadB : in std_logic_vector(47 downto 0);	
		AdcSampleToReadC : in std_logic_vector(47 downto 0);	
		AdcSampleNumAccums : in std_logic_vector(15 downto 0);	
		
		--Monitor A/D:
		MonitorAdcChannelReadIndex : out std_logic_vector(4 downto 0);
		ReadMonitorAdcSample : out std_logic;
		--~ MonitorAdcSampleToRead : in ads1258accumulator;
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
		
		UartLabFifoReset : out std_logic;
		ReadUartLab : out std_logic;
		UartLabRxFifoFull : in std_logic;
		UartLabRxFifoEmpty : in std_logic;
		UartLabRxFifoData : in std_logic_vector(7 downto 0);
		UartLabRxFifoCount : in std_logic_vector(9 downto 0);
		WriteUartLab : out std_logic;
		UartLabTxFifoFull : in std_logic;
		UartLabTxFifoEmpty : in std_logic;
		UartLabTxFifoData : out std_logic_vector(7 downto 0);
		UartLabTxFifoCount : in std_logic_vector(9 downto 0);
		UartLabClkDivider : out std_logic_vector(7 downto 0);
		
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
	constant PPSRtcPhaseCmpAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(28, MAX_ADDRESS_BITS));

	constant ControlRegisterAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(32, MAX_ADDRESS_BITS)); --we have guard addresses on all fifos because accidental reading still removes a char from the fifo.
	constant MotorControlStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(36, MAX_ADDRESS_BITS));
	constant PosSensAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(40, MAX_ADDRESS_BITS));
	
	constant DacASetpointAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(44, MAX_ADDRESS_BITS));
	constant DacBSetpointAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(48, MAX_ADDRESS_BITS));
	constant DacCSetpointAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(52, MAX_ADDRESS_BITS));
	constant DacDSetpointAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(56, MAX_ADDRESS_BITS));
	constant AdcAAccumulatorAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(60, MAX_ADDRESS_BITS));
	constant AdcBAccumulatorAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(68, MAX_ADDRESS_BITS));
	constant AdcCAccumulatorAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(76, MAX_ADDRESS_BITS)); --should be contiguous with AdcSample so we can get the whole thing with an 8-byte xfer...
	constant AdcDAccumulatorAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(84, MAX_ADDRESS_BITS)); --should be contiguous with AdcSample so we can get the whole thing with an 8-byte xfer...
	
	constant MonitorAdcSample : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(92, MAX_ADDRESS_BITS));
	constant MonitorAdcReadChannel : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(96, MAX_ADDRESS_BITS));
	constant MonitorAdcSpiXferAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(100, MAX_ADDRESS_BITS));
	constant MonitorAdcSpiFrameEnableAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(104, MAX_ADDRESS_BITS));
	
	constant UartClockDividersAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(108, MAX_ADDRESS_BITS));
	
	constant Uart0FifoAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(112, MAX_ADDRESS_BITS));
	constant Uart0FifoStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(116, MAX_ADDRESS_BITS));
	constant Uart0FifoReadDataAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(120, MAX_ADDRESS_BITS));
	
	constant Uart1FifoAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(124, MAX_ADDRESS_BITS));
	constant Uart1FifoStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(128, MAX_ADDRESS_BITS));
	constant Uart1FifoReadDataAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(132, MAX_ADDRESS_BITS));
	
	constant Uart2FifoAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(136, MAX_ADDRESS_BITS));
	constant Uart2FifoStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(140, MAX_ADDRESS_BITS));
	constant Uart2FifoReadDataAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(144, MAX_ADDRESS_BITS));
	
	constant Uart3FifoAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(148, MAX_ADDRESS_BITS));
	constant Uart3FifoStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(152, MAX_ADDRESS_BITS));
	constant Uart3FifoReadDataAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(156, MAX_ADDRESS_BITS));
	
	constant UartLabFifoAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(160, MAX_ADDRESS_BITS));
	constant UartLabFifoStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(164, MAX_ADDRESS_BITS));
	constant UartLabFifoReadDataAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(168, MAX_ADDRESS_BITS));
	
	--~ constant UartGpsFifoAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(128, MAX_ADDRESS_BITS));
	--~ constant UartGpsFifoStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(132, MAX_ADDRESS_BITS));
	--~ constant UartGpsFifoReadDataAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(136, MAX_ADDRESS_BITS));
	
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
	
	signal WriteDacs_i :  std_logic := '0';		
	signal DacASetpoint_i :  std_logic_vector(23 downto 0) := x"000000";		
	signal DacBSetpoint_i :  std_logic_vector(23 downto 0) := x"000000";		
	signal DacCSetpoint_i :  std_logic_vector(23 downto 0) := x"000000";	
	signal DacDSetpoint_i :  std_logic_vector(23 downto 0) := x"000000";	
	
	signal PowernEn_i :  std_logic := '0';								
	signal LedR_i :  std_logic := '0';
	signal LedG_i :  std_logic := '0';
	signal LedB_i :  std_logic := '0';
	signal Uart0OE_i :  std_logic := '0';
	signal Uart1OE_i :  std_logic := '0';
	signal Uart2OE_i :  std_logic := '0';
	signal Uart3OE_i :  std_logic := '0';								
	signal Ux1SelJmp_i :  std_logic := '0';
	signal Ux2SelJmp_i :  std_logic := '0';

	signal PowernEnHV_i :  std_logic := '0';
	signal nHVEn1_i :  std_logic := '0';
	signal HVDis2_i :  std_logic := '0';
	signal DacSelectMaxti_i :  std_logic := '0';								
	signal GlobalFaultInhibit_i :  std_logic := '0';
	signal nFaultsClr_i :  std_logic := '0';
	
begin

	--~ Address_i(MAX_ADDRESS_BITS - 1 downto ADDRESS_BITS) <= std_logic_vector(to_unsigned(0, MAX_ADDRESS_BITS - ADDRESS_BITS));
	--~ Address_i(ADDRESS_BITS - 1 downto 0) <= Address;
	--~ Address_i <= std_logic_vector(to_unsigned(0, MAX_ADDRESS_BITS - ADDRESS_BITS)) & Address;
	Address_i <= Address;
	
	DacASetpoint <= DacASetpoint_i;
	DacBSetpoint <= DacBSetpoint_i;
	DacCSetpoint <= DacCSetpoint_i;
	DacDSetpoint <= DacDSetpoint_i;
	WriteDacs <= WriteDacs_i;
	
	Uart0ClkDivider <= Uart0ClkDivider_i;
	Uart1ClkDivider <= Uart1ClkDivider_i;
	Uart2ClkDivider <= Uart2ClkDivider_i;
	Uart3ClkDivider <= Uart3ClkDivider_i;
	
	MonitorAdcChannelReadIndex <= MonitorAdcChannelReadIndex_i;
	MonitorAdcSpiFrameEnable <= MonitorAdcSpiFrameEnable_i;
	
	--~ Fault1V <= Fault1V_i;
	--~ Fault3V <= Fault3V_i;
	--~ Fault5V <= Fault5V_i;
	PowernEn <= PowernEn_i;								
	--~ PowerCycd <= PowerCycd_i;
	LedR <= LedR_i;
	LedG <= LedG_i;
	LedB <= LedB_i;
	Uart0OE <= Uart0OE_i;
	Uart1OE <= Uart1OE_i;
	Uart2OE <= Uart2OE_i;
	Uart3OE <= Uart3OE_i;								
	Ux1SelJmp <= Ux1SelJmp_i;	
	PowernEnHV <= PowernEnHV_i;
	nHVEn1 <= nHVEn1_i;
	HVDis2 <= HVDis2_i;
	DacSelectMaxti <= DacSelectMaxti_i;
	GlobalFaultInhibit <= GlobalFaultInhibit_i;
	nFaultsClr <= nFaultsClr_i;
		
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
			
			WriteDacs_i <= '0';		
			DacASetpoint_i <= x"000000";		
			DacBSetpoint_i <= x"000000";		
			DacCSetpoint_i <= x"000000";	
			DacDSetpoint_i <= x"000000";	
					
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
								
							
							
							
							--D/A's
							
							
							--DacASetpoint
							
							when DacASetpointAddr =>

								DataOut(23 downto 0) <= DacAReadback;
								--~ DataOut(31 downto 24) <= x"58";
								DataOut(31 downto 24) <= x"00";
							
							when DacBSetpointAddr =>

								DataOut(23 downto 0) <= DacBReadback;
								--~ DataOut(31 downto 24) <= x"58";
								DataOut(31 downto 24) <= x"00";
							
							when DacCSetpointAddr =>

								DataOut(23 downto 0) <= DacCReadback;
								--~ DataOut(31 downto 24) <= x"58";
								DataOut(31 downto 24) <= x"00";
							
							when DacDSetpointAddr =>

								DataOut(23 downto 0) <= DacDReadback;
								--~ DataOut(31 downto 24) <= x"58";
								DataOut(31 downto 24) <= x"00";
														
								

							--FSM Readback A/D's
							
							--AdcSampleToReadA
							
							when AdcAAccumulatorAddr =>

								DataOut <= AdcSampleToReadA(31 downto 0);
								
								ReadAdcSample <= '1';	

							when AdcAAccumulatorAddr + std_logic_vector(to_unsigned(4, MAX_ADDRESS_BITS)) =>

								DataOut(15 downto 0) <= AdcSampleToReadA(47 downto 32);
								DataOut(31 downto 16) <= AdcSampleNumAccums;
								
															
							--AdcSampleToReadB
							
							when AdcBAccumulatorAddr =>

								DataOut <= AdcSampleToReadB(31 downto 0);
								
								ReadAdcSample <= '1';	

							when AdcBAccumulatorAddr + std_logic_vector(to_unsigned(4, MAX_ADDRESS_BITS)) =>

								DataOut(15 downto 0) <= AdcSampleToReadB(47 downto 32);
								DataOut(31 downto 16) <= AdcSampleNumAccums;
							
							--AdcSampleToReadC
							
							when AdcCAccumulatorAddr =>

								DataOut <= AdcSampleToReadC(31 downto 0);
								
								ReadAdcSample <= '1';	

							when AdcCAccumulatorAddr + std_logic_vector(to_unsigned(4, MAX_ADDRESS_BITS)) =>

								DataOut(15 downto 0) <= AdcSampleToReadC(47 downto 32);
								DataOut(31 downto 16) <= AdcSampleNumAccums;
							
							--AdcSampleToReadD
							
							when AdcDAccumulatorAddr =>

								DataOut <= AdcSampleToReadD(31 downto 0);
								
								ReadAdcSample <= '1';	

							when AdcDAccumulatorAddr + std_logic_vector(to_unsigned(4, MAX_ADDRESS_BITS)) =>

								DataOut(15 downto 0) <= AdcSampleToReadD(47 downto 32);
								DataOut(31 downto 16) <= AdcSampleNumAccums;
							
							
								
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
							
								DataOut(7 downto 0) <= MonitorAdcSpiDataOut0;
								DataOut(7 downto 0) <= MonitorAdcSpiDataOut1;
								--~ DataOut(31 downto 8) <= x"000000";
								DataOut(31 downto 16) <= x"0000";
								
							when MonitorAdcSpiFrameEnableAddr =>
								
								DataOut(0) <= MonitorAdcSpiFrameEnable_i;
								DataOut(1) <= MonitorAdcSpiXferDone;
								DataOut(2) <= MonitorAdcnDrdy0;
								DataOut(3) <= MonitorAdcnDrdy1;
								DataOut(7 downto 4) <= "0000";
								DataOut(31 downto 8) <= x"000000";
								
							
								

					
							--RS-422
								
							when Uart0FifoAddr =>

								ReadUart0 <= '1';
								--~ DataOut(7 downto 0) <= Uart0RxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								--~ DataOut(31 downto 8) <= x"000000";
								DataOut <= x"BAADC0DE";
								
							when Uart0FifoReadDataAddr =>

								DataOut(7 downto 0) <= Uart0RxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								DataOut(31 downto 8) <= x"000000";
							
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
								--~ DataOut(7 downto 0) <= Uart1RxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								--~ DataOut(31 downto 8) <= x"000000";
								DataOut <= x"BAADC0DE";
								
							when Uart1FifoReadDataAddr =>

								DataOut(7 downto 0) <= Uart1RxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								DataOut(31 downto 8) <= x"000000";
							
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
								--~ DataOut(7 downto 0) <= Uart2RxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								--~ DataOut(31 downto 8) <= x"000000";
								DataOut <= x"BAADC0DE";
								
							when Uart2FifoReadDataAddr =>

								DataOut(7 downto 0) <= Uart2RxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								DataOut(31 downto 8) <= x"000000";
							
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
								--~ DataOut(7 downto 0) <= Uart3RxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								--~ DataOut(31 downto 8) <= x"000000";
								DataOut <= x"BAADC0DE";
								
							when Uart3FifoReadDataAddr =>

								DataOut(7 downto 0) <= Uart3RxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								DataOut(31 downto 8) <= x"000000";
							
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
								
								
								
							when UartLabFifoAddr =>

								ReadUartLab <= '1';
								--~ DataOut(7 downto 0) <= UartLabRxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								--~ DataOut(31 downto 8) <= x"000000";
								DataOut <= x"BAADC0DE";
								
							when UartLabFifoReadDataAddr =>

								DataOut(7 downto 0) <= UartLabRxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								DataOut(31 downto 8) <= x"000000";
							
							when UartLabFifoStatusAddr =>

								DataOut(0) <= UartLabRxFifoEmpty;
								DataOut(1) <= UartLabRxFifoFull;
								DataOut(2) <= UartLabTxFifoEmpty;
								DataOut(3) <= UartLabTxFifoFull;
								DataOut(4) <= '0';
								DataOut(5) <= '0';
								DataOut(6) <= '0';
								DataOut(7) <= '0';
								DataOut(17 downto 8) <= UartLabRxFifoCount;
								DataOut(27 downto 18) <= UartLabRxFifoCount;
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
								
								
							--ControlRegisterAddr
							when ControlRegisterAddr =>
							
								DataOut(0) <= FaultNegV;
								DataOut(1) <= Fault1V;
								DataOut(2) <= Fault2VA;
								DataOut(3) <= Fault2VD;								
								DataOut(4) <= Fault3VA;
								DataOut(5) <= Fault3VD;
								DataOut(6) <= Fault5V;
								DataOut(7) <= FaultHV;
								
								DataOut(8) <= nHVFaultA;
								DataOut(9) <= nHVFaultB;
								DataOut(10) <= nHVFaultC;
								DataOut(11) <= nHVFaultD;								
								DataOut(12) <= PowerCycd;
								DataOut(13) <= LedR_i;
								DataOut(14) <= LedG_i;
								DataOut(15) <= LedB_i;
								
								DataOut(16) <= Uart0OE_i;
								DataOut(17) <= Uart1OE_i;
								DataOut(18) <= Uart2OE_i;
								DataOut(19) <= Uart3OE_i;								
								DataOut(20) <= Ux1SelJmp_i;
								DataOut(21) <= '0';
								DataOut(22) <= PPSDetected;
								DataOut(23) <= '0';
								
								DataOut(24) <= PowernEnHV_i;
								DataOut(25) <= nHVEn1_i;
								DataOut(26) <= HVDis2_i;
								DataOut(27) <= DacSelectMaxti_i;
								DataOut(28) <= GlobalFaultInhibit_i;
								DataOut(29) <= nFaultsClr_i;
								DataOut(30) <= '0';
								DataOut(31) <= '0';
								 								
								--~ DataOut(31 downto 23) <= "000000000";
								
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
						
						ReadAdcSample <= '0';		
						
						ReadUart0 <= '0';						
						ReadUart1 <= '0';						
						ReadUart2 <= '0';		
						ReadUart3 <= '0';		
						ReadUartLab <= '0';		
						
					end if;
					
				end if;

				if (WriteReq = '1') then
				
					--WriteReq Rising Edge
					if (LastWriteReq = '0') then
					
						LastWriteReq <= '1';
					
						WriteAck <= '0';
									
						case Address_i is
						
						
						
						
							--D/A's
							
							--DacASetpoint
								
							when DacASetpointAddr =>

								DacASetpoint_i <= DataIn(23 downto 0);
								
								--The $$$ question: does our processor hit the low addr last or the high one???
								--Also we shold prolly wait until all the D/A registers are loaded, and do it on channel "C" only
								--~ WriteDacs_i <= '1';
								

							--DacBSetpoint
							
							when DacBSetpointAddr =>

								DacBSetpoint_i <= DataIn(23 downto 0);
								
							--DacCSetpoint
								
								when DacCSetpointAddr =>

								DacCSetpoint_i <= DataIn(23 downto 0);
							
							--DacDSetpoint
														
							when DacDSetpointAddr =>

								DacDSetpoint_i <= DataIn(23 downto 0);
								
								--The $$$ question: does our processor hit the low addr last or the high one???
								--Also we shold prolly wait until all the D/A registers are loaded, and do it on channel "C" only
								--~ WriteDacs_i <= '1';
							
								--The $$$ question: does our processor hit the low addr last or the high one???
								if ('1' = DacTransferComplete) then WriteDacs_i <= '1'; end if;
								
								
							--~ --FSM Readback A/D's
	
							--~ when AdcAAccumulatorAddr =>
								
								--~ ReadAdcSample <= '1';	
								
														
								
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
								
							when UartLabFifoAddr =>

								WriteUartLab <= '1';
								UartLabTxFifoData <= DataIn(7 downto 0);
								
							when UartLabFifoStatusAddr =>

								UartLabFifoReset <= '1';
							
							
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
								
								
								
							--ControlRegisterAddr
							when ControlRegisterAddr =>
							
								--~ PosLedsEnA_i <= DataIn(0);
								--~ PosLedsEnB_i <= DataIn(1);
								--~ MotorEnable_i <= DataIn(2);
								--~ ResetSteps_i <= DataIn(3);
								--~ PosLedsEnA_i <= DataIn(4);
								--~ PosLedsEnB_i <= DataIn(5);
								--~ MotorEnable_i <= DataIn(6);
								--~ ResetSteps_i <= DataIn(7);
								
								--~ nFaultClr1V <= DataIn(8);
								--~ nFaultClr3V <= DataIn(9);
								--~ nFaultClr5V <= DataIn(10);
								PowernEn_i <= DataIn(11);
								nPowerCycClr <= DataIn(12);
								LedR_i <= DataIn(13);
								LedG_i <= DataIn(14);
								LedB_i <= DataIn(15);
								
								Uart0OE_i <= DataIn(16);
								Uart1OE_i <= DataIn(17);
								Uart2OE_i <= DataIn(18);
								Uart3OE_i <= DataIn(19);
								Ux1SelJmp_i <= DataIn(20);
								--~ Ux2SelJmp_i <= DataIn(21);
								PPSCountReset <= DataIn(22);	
								 --~ <= DataIn(23);
								
								PowernEnHV_i <= DataIn(24);
								nHVEn1_i <= DataIn(25);
								HVDis2_i <= DataIn(26);
								DacSelectMaxti_i <= DataIn(27);
								GlobalFaultInhibit_i <= DataIn(28);
								nFaultsClr_i <= DataIn(29);
								 --~ <= DataIn(30);
								 --~ <= DataIn(31);
								
								
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
						
						WriteDacs_i <= '0';		
												
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
						WriteUartLab <= '0';		
						UartLabFifoReset <= '0';						
						
						nPowerCycClr <= '0';												
						--~ ??nFaultsClr_i <= DataIn(29);
					
					end if;
					
				end if;
				
			end if;

		end if;
		
	end process;

end RegisterSpace;


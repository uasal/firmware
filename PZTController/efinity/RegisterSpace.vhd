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
		WriteDacs : out std_logic; --do we wanna write all three Dac's at once? Seems likely...
		DacAReadback : in std_logic_vector(23 downto 0);
		DacBReadback : in std_logic_vector(23 downto 0);
		DacCReadback : in std_logic_vector(23 downto 0);		
		DacTransferComplete : in std_logic; --Prolly a bad idea if we try writing new data to the D/A's while a xfer is in progress...				

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
		PPSCountReset : out std_logic;
		ClockTicksThisSecond : in std_logic_vector(31 downto 0);				
		ClkDacWrite : out std_logic_vector(15 downto 0);
		WriteClkDac : out std_logic;
		ClkDacReadback : in std_logic_vector(15 downto 0)--;
	);
end RegisterSpacePorts;

architecture RegisterSpace of RegisterSpacePorts is

	-- this is fucked, but vhdl can't figure out that ADDRESS_BITS is a constant because it's in a generic map...so we do this whole circle-jerk
	--~ constant MAX_ADDRESS_BITS : natural := 8;
	constant MAX_ADDRESS_BITS : natural := ADDRESS_BITS;
	signal Address_i : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0);
	
	constant DeviceSerialNumberAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(0, MAX_ADDRESS_BITS));
	constant FpgaFirmwareBuildNumberAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(4, MAX_ADDRESS_BITS));
	constant UnixSecondsAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(8, MAX_ADDRESS_BITS)); --we have guard addresses on all fifos because accidental reading still removes a char from the fifo.
	constant IdealTicksPerSecondAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(12, MAX_ADDRESS_BITS));
	constant ActualTicksLastSecondAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16, MAX_ADDRESS_BITS));
	constant ClockTicksThisSecondAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(20, MAX_ADDRESS_BITS));
	constant ClockSteeringDacSetpointAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(24, MAX_ADDRESS_BITS));
	constant DacASetpointAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(28, MAX_ADDRESS_BITS));
	constant DacBSetpointAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(32, MAX_ADDRESS_BITS));
	constant DacCSetpointAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(36, MAX_ADDRESS_BITS));
	constant AdcAAccumulatorAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(40, MAX_ADDRESS_BITS));
	constant AdcBAccumulatorAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(48, MAX_ADDRESS_BITS));
	constant AdcCAccumulatorAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(56, MAX_ADDRESS_BITS)); --should be contiguous with AdcSample so we can get the whole thing with an 8-byte xfer...
	constant AdcAFifoAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(64, MAX_ADDRESS_BITS));
	constant AdcBFifoAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(72, MAX_ADDRESS_BITS));
	constant AdcCFifoAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(80, MAX_ADDRESS_BITS));
	constant ControlRegisterAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(88, MAX_ADDRESS_BITS)); --we have guard addresses on all fifos because accidental reading still removes a char from the fifo.
	constant StatusRegisterAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(92, MAX_ADDRESS_BITS));
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
	
	--Control Signals
	
	signal LastReadReq :  std_logic := '0';		
	signal LastWriteReq :  std_logic := '0';		

	signal WriteDacs_i :  std_logic := '0';		
	signal DacASetpoint_i :  std_logic_vector(23 downto 0) := x"000000";		
	signal DacBSetpoint_i :  std_logic_vector(23 downto 0) := x"000000";		
	signal DacCSetpoint_i :  std_logic_vector(23 downto 0) := x"000000";	
	--~ signal Uart0ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(natural((real(102000000) / ( real(38400) * 32.0)) - 1.0), 8));	--38.4k
	--~ signal Uart1ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(natural((real(102000000) / ( real(230400) * 32.0)) - 1.0), 8));	--230k
	--~ signal Uart0ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(natural((real(153000000) / ( real(38400) * 32.0)) - 1.0), 8));	--38.4k
	--~ signal Uart1ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(natural((real(153000000) / ( real(230400) * 32.0)) - 1.0), 8));	--230k
	signal Uart0ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(natural((real(102000000) / ( real(38400) * 16.0)) - 1.0), 8));	--38.4k
	signal Uart1ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(natural((real(102000000) / ( real(230400) * 16.0)) - 1.0), 8));	--230k
	--~ signal Uart0ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(natural((real(153000000) / ( real(38400) * 16.0)) - 1.0), 8));	--38.4k
	--~ signal Uart1ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(natural((real(153000000) / ( real(230400) * 16.0)) - 1.0), 8));	--230k
	signal Uart2ClkDivider_i : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(0, 8));	--"real fast"
	
	signal MonitorAdcChannelReadIndex_i : std_logic_vector(4 downto 0);	

	
begin

	--~ Address_i(MAX_ADDRESS_BITS - 1 downto ADDRESS_BITS) <= std_logic_vector(to_unsigned(0, MAX_ADDRESS_BITS - ADDRESS_BITS));
	--~ Address_i(ADDRESS_BITS - 1 downto 0) <= Address;
	--~ Address_i <= std_logic_vector(to_unsigned(0, MAX_ADDRESS_BITS - ADDRESS_BITS)) & Address;
	Address_i <= Address;
	
	DacASetpoint <= DacASetpoint_i;
	DacBSetpoint <= DacBSetpoint_i;
	DacCSetpoint <= DacCSetpoint_i;
	WriteDacs <= WriteDacs_i;
	Uart0ClkDivider <= Uart0ClkDivider_i;
	Uart1ClkDivider <= Uart1ClkDivider_i;
	Uart2ClkDivider <= Uart2ClkDivider_i;
	
	MonitorAdcChannelReadIndex <= MonitorAdcChannelReadIndex_i;
	
	process (clk, rst)
	begin
	
		if (rst = '1') then
		
			WriteDacs_i <= '0';		
			DacASetpoint_i <= x"000000";		
			DacBSetpoint_i <= x"000000";		
			DacCSetpoint_i <= x"000000";	
			
			LastReadReq <= '0';			
			LastWriteReq <= '0';			
		
		else
			
			if ( (clk'event) and (clk = '1') ) then
			
				--~ LastReadReq <= ReadReq;			
				--~ LastWriteReq <= WriteReq;			
										
				if (ReadReq = '1') then
				
					--ReadReq Rising Edge
					if (LastReadReq = '0') then
					
						LastReadReq <= '1';
					
						--~ DataOut <= x"77";
						
						ReadAck <= '1';
						
						--~ DataOut <= Address_i(7 downto 0);
							
						case Address_i is
						
						
							--Serial Number
							
							when DeviceSerialNumberAddr =>

								DataOut <= SerialNumber(7 downto 0);
								
							when DeviceSerialNumberAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								DataOut <= SerialNumber(15 downto 8);
								
							when DeviceSerialNumberAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DataOut <= SerialNumber(23 downto 16);
								
							when DeviceSerialNumberAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								DataOut <= SerialNumber(31 downto 24);

							

							--Build Number
							
							when FpgaFirmwareBuildNumberAddr =>

								DataOut <= BuildNumber(7 downto 0);

							when FpgaFirmwareBuildNumberAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								DataOut <= BuildNumber(15 downto 8);
								
							when FpgaFirmwareBuildNumberAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DataOut <= BuildNumber(23 downto 16);
								
							when FpgaFirmwareBuildNumberAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								DataOut <= BuildNumber(31 downto 24);

							
							
							--D/A's
							
							
							--DacASetpoint
							
							when DacASetpointAddr =>

								DataOut <= DacAReadback(7 downto 0);

							when DacASetpointAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								DataOut <= DacAReadback(15 downto 8);
								
							when DacASetpointAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DataOut <= DacAReadback(23 downto 16);
								
							when DacASetpointAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								--<No final byte>
								DataOut <= x"58";
							
							
							--DacBReadback
							
							when DacBSetpointAddr =>

								DataOut <= DacBReadback(7 downto 0);

							when DacBSetpointAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								DataOut <= DacBReadback(15 downto 8);
								
							when DacBSetpointAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DataOut <= DacBReadback(23 downto 16);
								
							when DacBSetpointAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								--<No final byte>		
								DataOut <= x"58";								
							
							
							--DacCReadback
							
							when DacCSetpointAddr =>

								DataOut <= DacCReadback(7 downto 0);

							when DacCSetpointAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								DataOut <= DacCReadback(15 downto 8);
								
							when DacCSetpointAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DataOut <= DacCReadback(23 downto 16);
								
							when DacCSetpointAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								--<No final byte>
								DataOut <= x"58";
								
								

							--PZT Readback A/D's
							
							--AdcSampleToReadA
							
							when AdcAAccumulatorAddr =>

								DataOut <= AdcSampleToReadA(7 downto 0);
								
								ReadAdcSample <= '1';	

							when AdcAAccumulatorAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleToReadA(15 downto 8);
								
							when AdcAAccumulatorAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleToReadA(23 downto 16);
								
							when AdcAAccumulatorAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleToReadA(31 downto 24);
								
							when AdcAAccumulatorAddr + std_logic_vector(to_unsigned(4, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleToReadA(39 downto 32);
								
							when AdcAAccumulatorAddr + std_logic_vector(to_unsigned(5, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleToReadA(47 downto 40);
								
							when AdcAAccumulatorAddr + std_logic_vector(to_unsigned(6, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleNumAccums(7 downto 0);
								
							when AdcAAccumulatorAddr + std_logic_vector(to_unsigned(7, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleNumAccums(15 downto 8);
								
															
							--AdcSampleToReadB
							
							when AdcBAccumulatorAddr =>

								DataOut <= AdcSampleToReadB(7 downto 0);

							when AdcBAccumulatorAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleToReadB(15 downto 8);
								
							when AdcBAccumulatorAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleToReadB(23 downto 16);
								
							when AdcBAccumulatorAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleToReadB(31 downto 24);
								
							when AdcBAccumulatorAddr + std_logic_vector(to_unsigned(4, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleToReadB(39 downto 32);
								
							when AdcBAccumulatorAddr + std_logic_vector(to_unsigned(5, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleToReadB(47 downto 40);
								
							when AdcBAccumulatorAddr + std_logic_vector(to_unsigned(6, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleNumAccums(7 downto 0);
								
							when AdcBAccumulatorAddr + std_logic_vector(to_unsigned(7, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleNumAccums(15 downto 8);
							
							--AdcSampleToReadC
							
							when AdcCAccumulatorAddr =>

								DataOut <= AdcSampleToReadC(7 downto 0);
								
							when AdcCAccumulatorAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleToReadC(15 downto 8);
								
							when AdcCAccumulatorAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleToReadC(23 downto 16);
								
							when AdcCAccumulatorAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleToReadC(31 downto 24);
								
							when AdcCAccumulatorAddr + std_logic_vector(to_unsigned(4, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleToReadC(39 downto 32);
								
							when AdcCAccumulatorAddr + std_logic_vector(to_unsigned(5, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleToReadC(47 downto 40);
								
							when AdcCAccumulatorAddr + std_logic_vector(to_unsigned(6, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleNumAccums(7 downto 0);
								
							when AdcCAccumulatorAddr + std_logic_vector(to_unsigned(7, MAX_ADDRESS_BITS)) =>

								DataOut <= AdcSampleNumAccums(15 downto 8);

								
							--Monitor A/D
							
							when MonitorAdcSample =>

								DataOut <= MonitorAdcSampleToRead(7 downto 0);
						
							when MonitorAdcSample + x"01" =>

								DataOut <= MonitorAdcSampleToRead(15 downto 8);
						
							when MonitorAdcSample + x"02" =>

								DataOut <= MonitorAdcSampleToRead(23 downto 16);
							
							when MonitorAdcSample + x"03" =>

								DataOut <= MonitorAdcSampleToRead(31 downto 24);
														
							when MonitorAdcSample + x"04" =>

								DataOut <= MonitorAdcSampleToRead(39 downto 32);
														
							when MonitorAdcSample + x"05" =>

								DataOut <= MonitorAdcSampleToRead(47 downto 40);
														
							when MonitorAdcSample + x"06" =>

								DataOut <= MonitorAdcSampleToRead(55 downto 48);
														
							when MonitorAdcSample + x"07" =>

								DataOut <= MonitorAdcSampleToRead(63 downto 56);
														
							when MonitorAdcReadChannel =>

								DataOut(4 downto 0) <= MonitorAdcChannelReadIndex_i;
								DataOut(7 downto 5) <= "000";
					


							--RS-422
								
							when Uart0FifoAddr =>

								ReadUart0 <= '1';
								DataOut(7 downto 0) <= Uart0RxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								
							when Uart0FifoAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								--~ DataOut(7 downto 0) <= x"00";
								DataOut(7 downto 0) <= Uart0RxFifoData;
								
							when Uart0FifoAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DataOut(7 downto 0) <= x"00";
								--~ DataOut(7 downto 0) <= Uart0RxFifoData;
								
							when Uart0FifoAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								DataOut(7 downto 0) <= x"00";
								--~ DataOut(7 downto 0) <= Uart0RxFifoData;
								
							when Uart0FifoStatusAddr =>

								DataOut(7) <= '0';
								DataOut(6) <= '0';
								DataOut(5) <= '0';
								DataOut(4) <= '0';
								DataOut(3) <= Uart0TxFifoFull;
								DataOut(2) <= Uart0TxFifoEmpty;
								DataOut(1) <= Uart0RxFifoFull;
								DataOut(0) <= Uart0RxFifoEmpty;
								
							when Uart0FifoStatusAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>
						
								DataOut(7 downto 0) <= Uart0RxFifoCount(7 downto 0);
								
							when Uart0FifoStatusAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>
						
								DataOut(7 downto 0) <= Uart0TxFifoCount(7 downto 0);
								
							when Uart0FifoStatusAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>
						
								DataOut(7) <= '0';
								DataOut(6) <= '0';
								DataOut(5) <= '0';
								DataOut(4) <= '0';
								DataOut(3) <= Uart0TxFifoCount(9);
								DataOut(2) <= Uart0TxFifoCount(8);
								DataOut(1) <= Uart0RxFifoCount(9);
								DataOut(0) <= Uart0RxFifoCount(8);
						
							when Uart1FifoAddr =>

								ReadUart1 <= '1';
								DataOut(7 downto 0) <= Uart1RxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								
							when Uart1FifoAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								--~ DataOut(7 downto 0) <= x"00";
								DataOut(7 downto 0) <= Uart1RxFifoData;
								
							when Uart1FifoAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DataOut(7 downto 0) <= x"00";
								--~ DataOut(7 downto 0) <= Uart1RxFifoData;
								
							when Uart1FifoAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								DataOut(7 downto 0) <= x"00";
								--~ DataOut(7 downto 0) <= Uart1RxFifoData;
								
							when Uart1FifoStatusAddr =>

								DataOut(7) <= '0';
								DataOut(6) <= '0';
								DataOut(5) <= '0';
								DataOut(4) <= '0';
								DataOut(3) <= Uart1TxFifoFull;
								DataOut(2) <= Uart1TxFifoEmpty;
								DataOut(1) <= Uart1RxFifoFull;
								DataOut(0) <= Uart1RxFifoEmpty;
								
							when Uart1FifoStatusAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>
						
								DataOut(7 downto 0) <= Uart1RxFifoCount(7 downto 0);
								
							when Uart1FifoStatusAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>
						
								DataOut(7 downto 0) <= Uart1TxFifoCount(7 downto 0);
								
							when Uart1FifoStatusAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>
						
								DataOut(7) <= '0';
								DataOut(6) <= '0';
								DataOut(5) <= '0';
								DataOut(4) <= '0';
								DataOut(3) <= Uart1TxFifoCount(9);
								DataOut(2) <= Uart1TxFifoCount(8);
								DataOut(1) <= Uart1RxFifoCount(9);
								DataOut(0) <= Uart1RxFifoCount(8);
						
							when Uart2FifoAddr =>

								ReadUart2 <= '1';
								DataOut(7 downto 0) <= Uart2RxFifoData; --note that as the fifo hasn't actually had time to do the read yet, this will actually be the previous byte
								
							when Uart2FifoAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								--~ DataOut(7 downto 0) <= x"00";
								DataOut(7 downto 0) <= Uart2RxFifoData;
								
							when Uart2FifoAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DataOut(7 downto 0) <= x"00";
								--~ DataOut(7 downto 0) <= Uart2RxFifoData;
								
							when Uart2FifoAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								DataOut(7 downto 0) <= x"00";
								--~ DataOut(7 downto 0) <= Uart2RxFifoData;
								
							when Uart2FifoStatusAddr =>

								DataOut(7) <= '0';
								DataOut(6) <= '0';
								DataOut(5) <= '0';
								DataOut(4) <= '0';
								DataOut(3) <= Uart2TxFifoFull;
								DataOut(2) <= Uart2TxFifoEmpty;
								DataOut(1) <= Uart2RxFifoFull;
								DataOut(0) <= Uart2RxFifoEmpty;
								
							when Uart2FifoStatusAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>
						
								DataOut(7 downto 0) <= Uart2RxFifoCount(7 downto 0);
								
							when Uart2FifoStatusAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>
						
								DataOut(7 downto 0) <= Uart2TxFifoCount(7 downto 0);
								
							when Uart2FifoStatusAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>
						
								DataOut(7) <= '0';
								DataOut(6) <= '0';
								DataOut(5) <= '0';
								DataOut(4) <= '0';
								DataOut(3) <= Uart2TxFifoCount(9);
								DataOut(2) <= Uart2TxFifoCount(8);
								DataOut(1) <= Uart2RxFifoCount(9);
								DataOut(0) <= Uart2RxFifoCount(8);
								

							--Uart Clock dividers
							when UartClockDividersAddr =>

								DataOut <= Uart0ClkDivider_i;

							when UartClockDividersAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								DataOut <= Uart1ClkDivider_i;
								
							when UartClockDividersAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DataOut <= Uart2ClkDivider_i;
								
							when UartClockDividersAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								--~ DataOut <= Uart3ClkDivider_i;

												
							--Timing
				
							--IdealTicksPerSecond
							when IdealTicksPerSecondAddr =>

								DataOut <= IdealTicksPerSecond(7 downto 0);
								
							when IdealTicksPerSecondAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								DataOut <= IdealTicksPerSecond(15 downto 8);
								
							when IdealTicksPerSecondAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DataOut <= IdealTicksPerSecond(23 downto 16);
								
							when IdealTicksPerSecondAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								DataOut <= IdealTicksPerSecond(31 downto 24);

								
							--ActualTicksLastSecond
							when ActualTicksLastSecondAddr =>

								DataOut <= ActualTicksLastSecond(7 downto 0);
								
							when ActualTicksLastSecondAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								DataOut <= ActualTicksLastSecond(15 downto 8);
								
							when ActualTicksLastSecondAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DataOut <= ActualTicksLastSecond(23 downto 16);
								
							when ActualTicksLastSecondAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								DataOut <= ActualTicksLastSecond(31 downto 24);

								
							--ClockTicksThisSecond
							when ClockTicksThisSecondAddr =>

								DataOut <= ClockTicksThisSecond(7 downto 0);
								
							when ClockTicksThisSecondAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								DataOut <= ClockTicksThisSecond(15 downto 8);
								
							when ClockTicksThisSecondAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DataOut <= ClockTicksThisSecond(23 downto 16);
								
							when ClockTicksThisSecondAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								DataOut <= ClockTicksThisSecond(31 downto 24);

								
							--ClockSteeringDacSetpointAddr
							when ClockSteeringDacSetpointAddr =>

								DataOut <= ClkDacReadback(7 downto 0);
								
							when ClockSteeringDacSetpointAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								DataOut <= ClkDacReadback(15 downto 8);
															
							when others =>

								DataOut <= x"41";
								
						end case;
						
					end if;
					
				end if;
				
				if (ReadReq = '0') then
			
					--ReadReq falling edge				
					if (LastReadReq = '1') then
					
						LastReadReq <= '0';
					
						--If timing is good, this doesn't do anything. If the fpga is lagging the processor reads will all be 82's. Yeah, we tested that in practice.
						DataOut <= x"82"; 
						
						ReadAck <= '0';
						
						ReadAdcSample <= '0';		

						ReadUart0 <= '0';						
						ReadUart1 <= '0';						
						ReadUart2 <= '0';						
					
					end if;
					
				end if;

				if (WriteReq = '1') then
				
					--WriteReq Rising Edge
					if (LastWriteReq = '0') then
					
						LastWriteReq <= '1';
					
						WriteAck <= '1';
									
						case Address_i is
						
							--D/A's
							
							--DacASetpoint
								
							when DacASetpointAddr =>

								DacASetpoint_i(7 downto 0) <= DataIn(7 downto 0);
								
								--The $$$ question: does our processor hit the low addr last or the high one???
								--Also we shold prolly wait until all the D/A registers are loaded, and do it on channel "C" only
								--~ WriteDacs_i <= '1';
								
							when DacASetpointAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								DacASetpoint_i(15 downto 8) <= DataIn(7 downto 0);
								
							when DacASetpointAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DacASetpoint_i(23 downto 16) <= DataIn(7 downto 0);

							when DacASetpointAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								--The $$$ question: does our processor hit the low addr last or the high one???
								--Also we shold prolly wait until all the D/A registers are loaded, and do it on channel "C" only
								--~ WriteDacs_i <= '1';


							--DacBSetpoint
							
							when DacBSetpointAddr =>

								DacBSetpoint_i(7 downto 0) <= DataIn(7 downto 0);
								
								--The $$$ question: does our processor hit the low addr last or the high one???
								--Also we shold prolly wait until all the D/A registers are loaded, and do it on channel "C" only
								--~ WriteDacs_i <= '1';
								
							when DacBSetpointAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								DacBSetpoint_i(15 downto 8) <= DataIn(7 downto 0);
								
							when DacBSetpointAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DacBSetpoint_i(23 downto 16) <= DataIn(7 downto 0);

							when DacBSetpointAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								--The $$$ question: does our processor hit the low addr last or the high one???
								--Also we shold prolly wait until all the D/A registers are loaded, and do it on channel "C" only
								--~ WriteDacs_i <= '1';

								
							--DacCSetpoint
								
							when DacCSetpointAddr =>

								DacCSetpoint_i(7 downto 0) <= DataIn(7 downto 0);
								
								--The $$$ question: does our processor hit the low addr last or the high one???
								--~ WriteDacs_i <= '1';
								
							when DacCSetpointAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								DacCSetpoint_i(15 downto 8) <= DataIn(7 downto 0);
								
							when DacCSetpointAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DacCSetpoint_i(23 downto 16) <= DataIn(7 downto 0);

							when DacCSetpointAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								--The $$$ question: does our processor hit the low addr last or the high one???
								if ('0' = DacTransferComplete) then WriteDacs_i <= '1'; end if;
								
								
							--~ --PZT Readback A/D's
	
							--~ when AdcAAccumulatorAddr =>
								
								--~ ReadAdcSample <= '1';	
								
								
							--Monitor A/D
							when MonitorAdcReadChannel =>

								ReadMonitorAdcSample <= '1';
								MonitorAdcChannelReadIndex_i <= DataIn(4 downto 0);

								
							
							--RS-422
							
							when Uart0FifoAddr =>

								WriteUart0 <= '1';
								Uart0TxFifoData <= DataIn;
								
							when Uart0FifoStatusAddr =>

								Uart0FifoReset <= '1';
								
							when Uart1FifoAddr =>

								WriteUart1 <= '1';
								Uart1TxFifoData <= DataIn;
								
							when Uart1FifoStatusAddr =>

								Uart1FifoReset <= '1';
								
							when Uart2FifoAddr =>

								WriteUart2 <= '1';
								Uart2TxFifoData <= DataIn;
								
							when Uart2FifoStatusAddr =>

								Uart2FifoReset <= '1';
								
							--Uart Clock dividers
							when UartClockDividersAddr =>

								Uart0ClkDivider_i <= DataIn;

							when UartClockDividersAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								Uart1ClkDivider_i <= DataIn;
								
							when UartClockDividersAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								Uart2ClkDivider_i <= DataIn;
								
							when UartClockDividersAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								--~ Uart3ClkDivider_i <= DataIn;

								
								
														
							--Timing
						
							when ClockSteeringDacSetpointAddr =>

								ClkDacWrite(7 downto 0) <= DataIn;
								
							when ClockSteeringDacSetpointAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								PPSCountReset <= '1';
								WriteClkDac <= '1';
								
								ClkDacWrite(15 downto 8) <= DataIn;
													
						
							when others => 


						end case;
						
					end if;

				end if;
				
				if (WriteReq = '0') then
			
					--WriteReq falling edge				
					if (LastWriteReq = '1') then
					
						LastWriteReq <= '0';
					
						WriteAck <= '0';
					
						WriteDacs_i <= '0';		
						
						ReadMonitorAdcSample <= '0';

						PPSCountReset <= '0';						
						
						WriteClkDac <= '0';		

						WriteUart0 <= '0';		
						Uart0FifoReset <= '0';						
						WriteUart1 <= '0';		
						Uart1FifoReset <= '0';						
						WriteUart2 <= '0';		
						Uart2FifoReset <= '0';						
					
					end if;
					
				end if;
				
			end if;

		end if;
		
	end process;

end RegisterSpace;

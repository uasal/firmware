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

entity DataMapperBytesPorts is
	generic (
		RAM_ADDRESS_BITS : natural := 8;
		FIFO_BITS : natural := 9;
		MUX_ADDRESS_BITS : natural := 4 --;
	);
	port (
	
		clk : in std_logic;
		
		-- Data Flow:
		Address : in std_logic_vector(RAM_ADDRESS_BITS - 1 downto 0); -- this is fucked, but vhdl can't figure out that RAM_ADDRESS_BITS is a constant because it's in a generic map...
		DataToWrite : in std_logic_vector(7 downto 0);
		DataFromRead : out std_logic_vector(7 downto 0);
		DataReadReq : in  std_logic;
		DataWriteReq : in std_logic;
		DataReadAck : out std_logic;
		DataWriteAck : out std_logic;
		
		--Data to access:			
		PPSCount : in std_logic_vector(31 downto 0);
		SarAdcOverrange : in std_logic;
		SarSyncCompleted : in std_logic;
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
		PPSRtcPhaseCmp : in std_logic_vector(31 downto 0);
		SarPPSAdcPhaseCmp : in std_logic_vector(31 downto 0);
		PPSPeriodDutyPhaseCmp : in std_logic_vector(31 downto 0);
		ClkDacReadback : in std_logic_vector(15 downto 0);	
		SyncSummary : in std_logic_vector(31 downto 0);		
		DnaRegister : in std_logic_vector(31 downto 0);
		BuildNum : in std_logic_vector(15 downto 0)--;
	);
end DataMapperBytesPorts;

architecture DataMapperBytes of DataMapperBytesPorts is

	-- this is fucked, but vhdl can't figure out that RAM_ADDRESS_BITS is a constant because it's in a generic map...so we do this whole circle-jerk
	--~ constant MAX_ADDRESS_BITS : natural := 8;
	constant MAX_ADDRESS_BITS : natural := RAM_ADDRESS_BITS;
	signal Address_i : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0);
	
	constant BuildNumAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(0, MAX_ADDRESS_BITS));
	constant SerialNumAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS));
	constant TxCtrlUartGuardAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(6, MAX_ADDRESS_BITS)); --we have guard addresses on all fifos because accidental reading still removes a char from the fifo.
	constant TxCtrlUartAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(7, MAX_ADDRESS_BITS));
	constant TxCtrlUartCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(8, MAX_ADDRESS_BITS));
	constant PPSCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(10, MAX_ADDRESS_BITS));
	constant ClockSteeringDacAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(14, MAX_ADDRESS_BITS));
	constant AdcPrescaleAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(16, MAX_ADDRESS_BITS));
	constant AdcPeriodAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(18, MAX_ADDRESS_BITS));
	constant AdcDutyAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(22, MAX_ADDRESS_BITS));
	constant TxCtrlUartBaudDivAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(26, MAX_ADDRESS_BITS));
	constant AdcSampleAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(30, MAX_ADDRESS_BITS));
	constant AdcTimestampAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(34, MAX_ADDRESS_BITS)); --should be contiguous with AdcSample so we can get the whole thing with an 8-byte xfer...
	constant AdcSampleCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(38, MAX_ADDRESS_BITS));
	constant AdcTimestampCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(39, MAX_ADDRESS_BITS));
	constant FifoStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(40, MAX_ADDRESS_BITS));
	constant GpsUartGuardAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(42, MAX_ADDRESS_BITS)); --we have guard addresses on all fifos because accidental reading still removes a char from the fifo.
	constant GpsUartAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(43, MAX_ADDRESS_BITS));
	constant GpsUartCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(44, MAX_ADDRESS_BITS));
	constant UsbTxUartGuardAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(46, MAX_ADDRESS_BITS));
	constant UsbTxUartAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(47, MAX_ADDRESS_BITS));
	constant UsbTxUartCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(48, MAX_ADDRESS_BITS));
	constant GpsMillisecondsAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(56, MAX_ADDRESS_BITS)); --all time below weeks, in mS units.
	constant ZigStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(60, MAX_ADDRESS_BITS));
	constant ZigControlAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(61, MAX_ADDRESS_BITS));
	constant SyncAdcAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(62, MAX_ADDRESS_BITS));
	constant SDPowerAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(63, MAX_ADDRESS_BITS));
	constant SyncSummaryAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(64, MAX_ADDRESS_BITS));
	constant BoardControlAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(68, MAX_ADDRESS_BITS));
	constant TimingStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(70, MAX_ADDRESS_BITS));
	constant BoardControlStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(71, MAX_ADDRESS_BITS));
	constant SpiExtInUseAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(74, MAX_ADDRESS_BITS));
	constant SpiExtAddrAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(75, MAX_ADDRESS_BITS));
	constant MuxDivisorAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(76, MAX_ADDRESS_BITS)); --now: DisciplineAccyPpb
	constant MuxChannelAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(78, MAX_ADDRESS_BITS));
	constant AdcStatusAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(79, MAX_ADDRESS_BITS));
	constant UsbUartGuardAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(80, MAX_ADDRESS_BITS));
	constant UsbUartAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(81, MAX_ADDRESS_BITS));
	constant UsbUartCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(82, MAX_ADDRESS_BITS));
	constant UsbSwAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(90, MAX_ADDRESS_BITS)); --So we can connect/disconnect the CP2103 and LPC2148 from the actual usb connector
	constant UartMuxAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(96, MAX_ADDRESS_BITS));
	constant SpiTxUartGuardAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(98, MAX_ADDRESS_BITS));
	constant SpiTxUartAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(99, MAX_ADDRESS_BITS));
	constant SpiTxUartCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(100, MAX_ADDRESS_BITS));
	constant SpiRxUartGuardAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(102, MAX_ADDRESS_BITS));
	constant SpiRxUartAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(103, MAX_ADDRESS_BITS));
	constant SpiRxUartCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(104, MAX_ADDRESS_BITS));
	constant PPSRtcPhaseCmpAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(118, MAX_ADDRESS_BITS));
	constant ForcePnDAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(122, MAX_ADDRESS_BITS));
	constant PPSAdcPhaseCmpAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(124, MAX_ADDRESS_BITS));
	constant SarAdcSampleAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(30, MAX_ADDRESS_BITS));
	constant SarAdcSampleCountAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(38, MAX_ADDRESS_BITS));
	constant AdcGainAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(64, MAX_ADDRESS_BITS));
	constant AdcClkDividerAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(92, MAX_ADDRESS_BITS));
	constant SarPPSAdcPhaseCmpAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(108, MAX_ADDRESS_BITS));
	constant ClockDacAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(116, MAX_ADDRESS_BITS));
	constant PPSPeriodDutyPhaseCmpAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(112, MAX_ADDRESS_BITS));
	constant SarSamplesToAverageAddr : std_logic_vector(MAX_ADDRESS_BITS - 1 downto 0) := std_logic_vector(to_unsigned(106, MAX_ADDRESS_BITS));

	--Control Signals
	signal SarAdcOverrange_i :  std_logic := '0';		
	--~ signal SarSyncCompleted_i :  std_logic := '0';			
	signal AdcStatusRead :  std_logic := '0';		
	
begin

	--~ Address_i(MAX_ADDRESS_BITS - 1 downto RAM_ADDRESS_BITS) <= std_logic_vector(to_unsigned(0, MAX_ADDRESS_BITS - RAM_ADDRESS_BITS));
	--~ Address_i(RAM_ADDRESS_BITS - 1 downto 0) <= Address;
	--~ Address_i <= std_logic_vector(to_unsigned(0, MAX_ADDRESS_BITS - RAM_ADDRESS_BITS)) & Address;
	Address_i <= Address;
	
	process (clk)
	begin
		
		if ( (clk'event) and (clk = '1') ) then
			
			--AdcOverrange & SyncCompleted (AdcStatus)
			if (AdcStatusRead = '1') then
			
				AdcStatusRead <= '0';					
				SarAdcOverrange_i <= SarAdcOverrange; --allow it to go back to zero if it's been read								
				--~ SarSyncCompleted_i <= SarSyncCompleted; --allow it to go back to zero if it's been read					

			else

				if (SarAdcOverrange = '1') then SarAdcOverrange_i <= '1'; end if;--latch high
				--~ if (SarSyncCompleted = '1') then SarSyncCompleted_i <= '1'; end if;--latch high
			
			end if;				
						
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

						DataFromRead <= BuildNum(7 downto 0);
						DataReadAck <= '1';
						

					when BuildNumAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

						DataFromRead <= BuildNum(15 downto 8);
						DataReadAck <= '1';
						

					when SerialNumAddr =>

						DataFromRead <= DnaRegister(7 downto 0);
						DataReadAck <= '1';
						
					when SerialNumAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

						DataFromRead <= DnaRegister(15 downto 8);
						DataReadAck <= '1';
						
					when SerialNumAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

						DataFromRead <= DnaRegister(23 downto 16);
						DataReadAck <= '1';
						
					when SerialNumAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

						DataFromRead <= DnaRegister(31 downto 24);
						DataReadAck <= '1';
					
					when PPSCountAddr =>

						DataFromRead <= PPSCount(7 downto 0);
						DataReadAck <= '1';
						
					when PPSCountAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

						DataFromRead <= PPSCount(15 downto 8);
						DataReadAck <= '1';
						
					when PPSCountAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

						DataFromRead <= PPSCount(23 downto 16);
						DataReadAck <= '1';

					when PPSCountAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

						DataFromRead <= PPSCount(31 downto 24);
						DataReadAck <= '1';
						
					when FifoStatusAddr =>

						DataFromRead(7) <= '0';
						DataFromRead(6) <= '0';
						DataFromRead(5) <= '0';
						DataFromRead(4) <= '0';
						DataFromRead(3) <= '0';
						DataFromRead(2) <= '0';
						DataFromRead(1) <= '0';
						DataFromRead(0) <= '0';
						DataReadAck <= '1';
						
					when FifoStatusAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

						DataFromRead(7) <= '0';
						DataFromRead(6) <= '0';
						DataFromRead(5) <= '0';
						DataFromRead(4) <= '0';
						DataFromRead(3) <= SpiTxUartFifoFull;
						DataFromRead(2) <= SpiTxUartFifoEmpty;
						DataFromRead(1) <= SpiRxUartFifoFull;
						DataFromRead(0) <= SpiRxUartFifoEmpty;
						DataReadAck <= '1';
												
					when AdcStatusAddr =>
					
						DataFromRead(0) <= '0';
						--~ DataFromRead(0) <= SarSyncCompleted_i;
						DataFromRead(1) <= SarAdcOverrange_i;
						DataFromRead(2) <= '0';
						DataFromRead(3) <= '0';
						DataFromRead(4) <= '0';
						DataFromRead(5) <= '0';
						DataFromRead(6) <= '0';
						DataFromRead(7) <= '0';
						DataReadAck <= '1';
						
						AdcStatusRead <= '1';
						
					when SpiTxUartAddr =>

						ReadSpiTxUart <= '1';
						DataFromRead(7 downto 0) <= SpiTxUartReadData;
						DataReadAck <= SpiTxUartReadAck;
					
					--~ when SpiTxUartCountAddr =>

						--~ DataFromRead(15) <= SpiTxUartFifoFull;
						--~ DataFromRead(14 downto FIFO_BITS) <= std_logic_vector(to_unsigned(0, 14 - (FIFO_BITS - 1)));
						--~ DataFromRead(FIFO_BITS - 1 downto 0) <= SpiTxUartCount;
						--~ DataReadAck <= '1';
					
					when SpiRxUartAddr =>

						--When we hit the first address, we grab the data...
						ReadSpiRxUart <= '1';
						DataFromRead(7 downto 0) <= SpiRxUartReadData;
						DataReadAck <= SpiRxUartReadAck;
						
					--~ when SpiRxUartCountAddr =>
					
						--~ DataFromRead(15) <= SpiRxUartFifoFull;
						--~ DataFromRead(14 downto FIFO_BITS) <= std_logic_vector(to_unsigned(0, 14 - (FIFO_BITS - 1)));
						--~ DataFromRead(FIFO_BITS - 1 downto 0) <= SpiRxUartCount;
						--~ DataReadAck <= '1';
						
					when PPSRtcPhaseCmpAddr =>

						DataFromRead <= PPSRtcPhaseCmp(7 downto 0);
						DataReadAck <= '1';
						
					when PPSRtcPhaseCmpAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

						DataFromRead <= PPSRtcPhaseCmp(15 downto 8);
						DataReadAck <= '1';
						
					when PPSRtcPhaseCmpAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

						DataFromRead <= PPSRtcPhaseCmp(23 downto 16);
						DataReadAck <= '1';
						
					when PPSRtcPhaseCmpAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

						DataFromRead <= PPSRtcPhaseCmp(31 downto 24);
						DataReadAck <= '1';
							
					when SarPPSAdcPhaseCmpAddr =>

						DataFromRead <= SarPPSAdcPhaseCmp(7 downto 0);
						DataReadAck <= '1';
						
					when SarPPSAdcPhaseCmpAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

						DataFromRead <= SarPPSAdcPhaseCmp(15 downto 8);
						DataReadAck <= '1';
						
					when SarPPSAdcPhaseCmpAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

						DataFromRead <= SarPPSAdcPhaseCmp(23 downto 16);
						DataReadAck <= '1';
						
					when SarPPSAdcPhaseCmpAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

						DataFromRead <= SarPPSAdcPhaseCmp(31 downto 24);
						DataReadAck <= '1';
						
					--~ when PPSPeriodDutyPhaseCmpAddr =>

						--~ DataFromRead <= PPSPeriodDutyPhaseCmp(15 downto 0);
						--~ DataReadAck <= '1';
						
					--~ when PPSPeriodDutyPhaseCmpAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

						--~ DataFromRead <= PPSPeriodDutyPhaseCmp(31 downto 16);
						--~ DataReadAck <= '1';
						
					when ClockDacAddr =>

						DataFromRead <= ClkDacReadback(7 downto 0);
						DataReadAck <= '1';
					
					when ClockDacAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

						DataFromRead <= ClkDacReadback(15 downto 8);
						DataReadAck <= '1';
					
					when SyncSummaryAddr =>

						DataFromRead <= SyncSummary(7 downto 0);
						DataReadAck <= '1';
						
					when SyncSummaryAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

						DataFromRead <= SyncSummary(15 downto 8);
						DataReadAck <= '1';
						
					when SyncSummaryAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

						DataFromRead <= SyncSummary(23 downto 16);
						DataReadAck <= '1';
						
					when SyncSummaryAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

						DataFromRead <= SyncSummary(31 downto 24);
						DataReadAck <= '1';

					when others => -- Get it from BRAM!

						--~ DataFromRead <= RamReadOutLo; --No bram shadow on 339 (unneeded)
						DataFromRead <= x"41";
						DataReadAck <= '0';
						
				end case;

			else -- No ReadReq (probably doing a write)

				--Reset req req's for fifos if we did a read...
				ReadSpiTxUart <= '0';
				ReadSpiRxUart <= '0';
				DataFromRead <= x"82";
				DataReadAck <= '0';
								
			end if;

			if (DataWriteReq = '1') then
			
				case Address_i is
						
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
						
					when others => 

						DataWriteAck <= '0';

				end case;

			else -- No WriteReqLo (probably doing a read)
			
				DataWriteAck <= '0';
				
				WriteSpiTxUart <= '0';
				
				SpiTxFifoReset <= '0';
				
				WriteSpiRxUart <= '0';
				
				SpiRxFifoReset <= '0';
				
			end if;
			
		end if;

	end process;

end DataMapperBytes;

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.CGraphDMTypes.all;

entity DMMainPorts is
  port (
    clk : in  std_logic;

    --ClkDac

    nCsXO : out std_logic;
    SckXO : out std_logic;
    MosiXO : out std_logic;
	
    --D/A's
    MosiA : out std_logic;
    MosiB : out std_logic;
    MosiC : out std_logic;
    MosiD : out std_logic;
	MosiE : out std_logic;
	MosiF : out std_logic;
    MisoA : in std_logic;
    MisoB : in std_logic;
    MisoC : in std_logic;
    MisoD : in std_logic;
	MisoE : in std_logic;
	MisoF : in std_logic;
    SckA : out std_logic;
	SckB : out std_logic;
	SckC : out std_logic;
	SckD : out std_logic;
	SckE : out std_logic;
	SckF : out std_logic;
    nCsA : out std_logic_vector(3 downto 0);
    nCsB : out std_logic_vector(3 downto 0);
    nCsC : out std_logic_vector(3 downto 0);
    nCsD : out std_logic_vector(3 downto 0);
    nCsE : out std_logic_vector(3 downto 0);
    nCsF : out std_logic_vector(3 downto 0);

    --Driver Control
    -- Will need to understand and work on this
--    nHVEn1 : out std_logic;
--    HVDis2 : out std_logic;
--    PowernEnHV : out std_logic;	
--    nHVFaultA : in std_logic;
--    nHVFaultB : in std_logic;
--    nHVFaultC : in std_logic;
--    nHVFaultD : in std_logic;
	
    --A/D's
--    ChopRef : out std_logic;
--    ChopAdcs : out std_logic;
--    TrigAdcs : out std_logic;	
--    SckAdcs : out std_logic;
--    nCsAdcs : out std_logic;
--    MisoAdcA : in std_logic;
--    MisoAdcB : in std_logic;
--    MisoAdcC : in std_logic;
--    MisoAdcD : in std_logic;
--    nDrdyAdcA : in std_logic;
--    nDrdyAdcB : in std_logic;
--    nDrdyAdcC : in std_logic;
--    nDrdyAdcD : in std_logic;
	
    --uC Ram Bus 
    RamBusAddress : in std_logic_vector(13 downto 0); -- Address vector is ADDRESS_BUS_BITS bits
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
--    nCsMonAdcs : out std_logic;
--    SckMonAdcs : out std_logic;
--    MosiMonAdcs : out std_logic;
--    TrigMonAdcs : out std_logic;
--    MisoMonAdc0 : in std_logic;
--    nDrdyMonAdc0 : in std_logic;
--    MisoMonAdc1 : in std_logic;
--    nDrdyMonAdc1 : in std_logic;

    --Power Supplies
--    PowerSync : out std_logic;
--    PowernEn : out std_logic;
--    GlobalFaultInhibit : out std_logic;
--    nFaultsClr : out std_logic;
--    nPowerCycClr : out std_logic;
--    PowerCycd: in std_logic;
	
    --Faults
--    FaultNegV : in std_logic;
--    Fault1V : in std_logic;
--    Fault2VA : in std_logic;
--    Fault2VD : in std_logic;
--    Fault3VA : in std_logic;
--    Fault3VD : in std_logic;
--    Fault5V : in std_logic;
--    FaultHV : in std_logic;
	
    --Expansion Bus
--    SckExt : inout std_logic;
--    MosiExt : inout std_logic;
--    MisoExt : inout std_logic;
--    nCsExt : inout std_logic;
--    DOutExt : inout std_logic;
--    DInExt : in std_logic;

    --The testpoints had to be shared with other signals due to lack of fpga pins...
    --~ LedR : out std_logic;
    --~ LedG : out std_logic;
    --~ LedB : out std_logic;
    --~ TP1 : out std_logic;
    --~ TP2 : out std_logic;
    --~ TP3 : out std_logic;
    --~ TP4 : out std_logic;
    --~ TP5 : out std_logic;
    --~ TP6 : out std_logic;
    --~ TP7 : out std_logic;
    --~ TP8 : out std_logic;
	
    Ux1SelJmp : inout std_logic--;
  );
end DMMainPorts;

architecture DMMain of DMMainPorts is

  -- Buffer component (Input to output)
  component IBufP1Ports is
    port (
      clk : in std_logic;
      I : in std_logic;
      O : out std_logic--;
      );
  end component;

  -- Another Buffer compoenent (Input to temp to output)
  component IBufP2Ports is
    port (
      clk : in std_logic;
      I : in std_logic;
      O : out std_logic--;
      );
  end component;

  -- Yet another Buffer compoenent (Input to temp1 to temp2 to output)
  component IBufP3Ports is
    port (
      clk : in std_logic;
      I : in std_logic;
      O : out std_logic--;
      );
  end component;

  -- Clock divider compoenents
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

  -- A variable clock divider compoenent
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

  -- One Shot component
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

  -- Component to save the build number
  component BuildNumberPorts is
    port (
      BuildNumber : out std_logic_vector(31 downto 0)--;
      );
  end component;

  -- Spi port driver
  -- Will edit to make useful for DAC writing
  -- And to add the bits to the DMSetpointMSB bit word
  component SpiDacPorts is
    generic (
      CLOCK_DIVIDER : natural := 1000;
      BIT_WIDTH : natural := 16--;
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
	--~ TransferComplete : out std_logic;
      );
  end component;

  -- PPS counter component
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

  -- Fifos for the rs-422 communications
  -- Receive
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

  -- Transmit
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
        Txd : out std_logic--; --Uart data output pin (i.e. to RS-DMSetpointMSB2 driver chip)
        );
  end component;

  -- The Register Space component
  component RegisterSpacePorts is
  generic(
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

    --Faults and Control (need to look over schematic)
    -- Leave space for these
    --PowernEnHV : out std_logic;	
    --PowernEn : out std_logic;
    Uart0OE : out std_logic;
    Uart1OE : out std_logic;
    Uart2OE : out std_logic;
    Uart3OE : out std_logic;				
    Ux1SelJmp : out std_logic;

    --DM Board D/A's
    -- Are these set points going to be 32 bits since
    -- we also need dac number information. This will be decoded
    -- in each Spi module.  They can all be the same.
    DacBdASetpoint : out std_logic_vector(31 downto 0);
    DacBdBSetpoint : out std_logic_vector(31 downto 0);
    DacBdCSetpoint : out std_logic_vector(31 downto 0);
    DacBdDSetpoint : out std_logic_vector(31 downto 0);
    DacBdESetpoint : out std_logic_vector(31 downto 0);
    DacBdFSetpoint : out std_logic_vector(31 downto 0);
    WriteDacs : out std_logic; --do we wanna write all three boards at once? Seems likely...
    DacBdAReadback : in std_logic_vector(31 downto 0);
    DacBdBReadback : in std_logic_vector(31 downto 0);
    DacBdCReadback : in std_logic_vector(31 downto 0);
    DacBdDReadback : in std_logic_vector(31 downto 0);
    DacBdEReadback : in std_logic_vector(31 downto 0);
    DacBdFReadback : in std_logic_vector(31 downto 0);
    DacTransferCompleteA : in std_logic; --Prolly a bad idea if we try writing new data to the D/A's while a xfer is in progress...
    DacTransferCompleteB : in std_logic;
    DacTransferCompleteC : in std_logic;
    DacTransferCompleteD : in std_logic;
    DacTransferCompleteE : in std_logic;
    DacTransferCompleteF : in std_logic;

    -- DM Readback A/Ds
--    ReadAdcSample : out std_logic;
--    AdcSampleToReadA : in std_logic_vector(47 downto 0);
--    AdcSampleToReadB : in std_logic_vector(47 downto 0);
--    AdcSampleToReadC : in std_logic_vector(47 downto 0);
--    AdcSampleToReadD : in std_logic_vector(47 downto 0);
--    AdcSampleNumAccums : in std_logic_vector(15 downto 0);	

    --Monitor A/D:
--    MonitorAdcChannelReadIndex : out std_logic_vector(4 downto 0);
--    ReadMonitorAdcSample : out std_logic;
--    --~ MonitorAdcSampleToRead : in ads1258accumulator;
--    MonitorAdcSampleToRead : in std_logic_vector(63 downto 0);
--    MonitorAdcReset : out std_logic;
--    MonitorAdcSpiDataIn : out std_logic_vector(7 downto 0);
--    MonitorAdcSpiDataOut0 : in std_logic_vector(7 downto 0);
--    MonitorAdcSpiDataOut1 : in std_logic_vector(7 downto 0);
--    MonitorAdcSpiXferStart : out std_logic;
--    MonitorAdcSpiXferDone : in std_logic;
--    MonitorAdcnDrdy0  : in std_logic;
--    MonitorAdcnDrdy1  : in std_logic;
--    MonitorAdcSpiFrameEnable : out std_logic;

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
    PPSCountReset : out std_logic;
    PPSDetected : in std_logic;
    ClockTicksThisSecond : in std_logic_vector(31 downto 0);				

    ClkDacWrite : out std_logic_vector(15 downto 0);
    WriteClkDac : out std_logic;
    ClkDacReadback : in std_logic_vector(15 downto 0)--;
	
	--~ DacSetpoints : out DMDacSetpointRam--;	
	--~ DacChannelReadIndex : in std_logic_vector(5 downto 0);
	--~ DacSetpoints : out DMDacSetpointRegisters--;
    );
  end component;    

  -- SpiDeviceDualPorts is used for the adc, but I'm not going to work on that
  -- right now

  -- Another Spi port component, but will need to modify for my needs
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
      DacWriteOutA : in std_logic_vector(31 downto 0);
      DacWriteOutB : in std_logic_vector(31 downto 0);
      DacWriteOutC : in std_logic_vector(31 downto 0);
      DacWriteOutD : in std_logic_vector(31 downto 0);
      DacReadbackA : out std_logic_vector(31 downto 0);
      DacReadbackB : out std_logic_vector(31 downto 0);
      DacReadbackC : out std_logic_vector(31 downto 0);
      DacReadbackD : out std_logic_vector(31 downto 0);
      TransferComplete : out std_logic--;
      );
  end component;
  
    component DmDacRamPorts is
	  port (
		clk : in std_logic;
		rst : in std_logic;
			
		-- Bus:
		ReadAddressController : in integer range (DMMaxControllerBoards - 1) downto 0;
		ReadAddressDac : in integer range (DMMDacsPerControllerBoard - 1) downto 0;
		ReadAddressChannel : in integer range (DMActuatorsPerDac - 1) downto 0;
		WriteAddress : in integer range (DMMaxActuators - 1) downto 0;
		DacSetpointIn : in std_logic_vector(DMSetpointMSB downto 0);
		DacSetpointOut : out std_logic_vector(DMSetpointMSB downto 0);
		WriteReq : in std_logic--;
	  );
	end component;

--- End component setup

-- Now let's figure out how they all go together

  -- Constants and Setup

  -- Clocks
  constant BoardMasterClockFreq : natural := 102000000;
  constant BoardUartClockFreq : natural := 102000000;

  signal MasterClk       : std_logic;
  signal UartClk         : std_logic;

  -- FPGA internal signals (this may get broken out if I use
  -- separate components and not stuff everything in one file.)
  signal MasterReset     : std_logic;
  signal SerialNumber    : std_logic_vector(31 downto 0);
  signal BuildNumber     : std_logic_vector(31 downto 0);

  -- Ram Bus (which is the Amba Bus to/from the processor. Internally.)
  constant ADDRESS_BUS_BITS : natural := 14;
  signal RamBusLatch_i   : std_logic;		
  signal RamBusCE_i      : std_logic;		
  signal RamBusWrnRd_i   : std_logic;		
  signal RamAddress : std_logic_vector((ADDRESS_BUS_BITS - 1) downto 0);		
  signal RamDataOut      : std_logic_vector(31 downto 0);		
  signal RamDataIn       : std_logic_vector(31 downto 0);		
  signal RamBusAck_i     : std_logic;

  -- Register space		
  signal RegisterSpaceDataToWrite : std_logic_vector(31 downto 0);
  signal RegisterSpaceWriteReq : std_logic;
  signal RegisterSpaceWriteAck : std_logic;
  signal RegisterSpaceDataFromRead : std_logic_vector(31 downto 0);
  signal RegisterSpaceReadReq : std_logic;
  signal RegisterSpaceReadAck : std_logic;
                                             
  -- DM D/As (These might get subsumed in the SPI port compoenents)
  signal DacSelectMaxti      : std_logic;
  signal nCsDacBdA_i         : std_logic;
  signal nCsDacBdB_i         : std_logic;
  signal nCsDacBdC_i         : std_logic;
  signal nCsDacBdD_i         : std_logic;
  signal nCsDacBdE_i         : std_logic;
  signal nCsDacBdF_i         : std_logic;
  signal MosiDacBdA_i        : std_logic;
  signal MosiDacBdB_i        : std_logic;
  signal MosiDacBdC_i        : std_logic;
  signal MosiDacBdD_i        : std_logic;
  signal MosiDacBdE_i        : std_logic;
  signal MosiDacBdF_i        : std_logic;
  signal MisoDacBdA_i        : std_logic;
  signal MisoDacBdB_i        : std_logic;
  signal MisoDacBdC_i        : std_logic;
  signal MisoDacBdD_i        : std_logic;
  signal MisoDacBdE_i        : std_logic;
  signal MisoDacBdF_i        : std_logic;
  signal DacBdASetpoint      : std_logic_vector(31 downto 0);
  signal DacBdBSetpoint      : std_logic_vector(31 downto 0);
  signal DacBdCSetpoint      : std_logic_vector(31 downto 0);
  signal DacBdDSetpoint      : std_logic_vector(31 downto 0);
  signal DacBdESetpoint      : std_logic_vector(31 downto 0);
  signal DacBdFSetpoint      : std_logic_vector(31 downto 0);
  signal WriteDacs           : std_logic;
  signal DacBdAReadback      : std_logic_vector(31 downto 0);
  signal DacBdBReadback      : std_logic_vector(31 downto 0);
  signal DacBdCReadback      : std_logic_vector(31 downto 0);
  signal DacBdDReadback      : std_logic_vector(31 downto 0);
  signal DacBdEReadback      : std_logic_vector(31 downto 0);
  signal DacBdFReadback      : std_logic_vector(31 downto 0);
  signal nLDacs_i            : std_logic;	
  signal DacTransferCompleteA : std_logic;
  signal DacTransferCompleteB : std_logic;
  signal DacTransferCompleteC : std_logic;
  signal DacTransferCompleteD : std_logic;
  signal DacTransferCompleteE : std_logic;
  signal DacTransferCompleteF : std_logic;

  -- DM Readback A/Ds
--  signal ReadAdcSample       : std_logic;
--  signal AdcSampleToReadA    : std_logic_vector(47 downto 0);	
--  signal AdcSampleToReadB    : std_logic_vector(47 downto 0);	
--  signal AdcSampleToReadC    : std_logic_vector(47 downto 0);	
--  signal AdcSampleToReadD    : std_logic_vector(47 downto 0);	
--  signal AdcSampleNumAccums  : std_logic_vector(15 downto 0);	

  -- Monitor A/D
--  signal MonitorAdcChannelReadIndex : std_logic_vector(4 downto 0);
--  signal ReadMonitorAdcSample       : std_logic;
--  signal MonitorAdcSampleToRead     : std_logic_vector(63 downto 0);
--  signal MonitorAdcReset            : std_logic;
--  signal MonitorAdcSpiDataIn        : std_logic_vector(7 downto 0);
--  signal MonitorAdcSpiDataOut0      : std_logic_vector(7 downto 0);
--  signal MonitorAdcSpiDataOut1      : std_logic_vector(7 downto 0);
--  signal MonitorAdcSpiXferStart     : std_logic;
--  signal MonitorAdcSpiXferDone      : std_logic;
--  signal MonitorAdcnDrdy0           : std_logic;
--  signal MonitorAdcnDrdy1           : std_logic;
--  signal MonitorAdcSpiFrameEnable   : std_logic;

  --RS-422
  signal Uart0FifoReset     : std_logic;
  signal Uart0FifoReset_i   : std_logic;
  signal ReadUart0          : std_logic;
  signal Uart0RxFifoFull    : std_logic;
  signal Uart0RxFifoEmpty   : std_logic;
  signal Uart0RxFifoReadAck : std_logic;
  signal Uart0RxFifoData    : std_logic_vector(7 downto 0);
  signal Uart0RxFifoCount   : std_logic_vector(9 downto 0);
  signal WriteUart0         : std_logic;
  signal Uart0TxFifoFull    : std_logic;
  signal Uart0TxFifoEmpty   : std_logic;
  signal Uart0TxFifoData    : std_logic_vector(7 downto 0);
  signal Uart0TxFifoCount   : std_logic_vector(9 downto 0);
  signal Uart0ClkDivider    : std_logic_vector(7 downto 0);
  signal UartClk0           : std_logic;
  signal UartTxClk0         : std_logic;
  signal Txd0_i             : std_logic;
  signal Rxd0_i             : std_logic;
  signal UartRx0Dbg         : std_logic;

  signal Uart1FifoReset     : std_logic;
  signal Uart1FifoReset_i   : std_logic;
  signal ReadUart1          : std_logic;
  signal Uart1RxFifoFull    : std_logic;
  signal Uart1RxFifoEmpty   : std_logic;
  signal Uart1RxFifoReadAck : std_logic;
  signal Uart1RxFifoData    : std_logic_vector(7 downto 0);
  signal Uart1RxFifoCount   : std_logic_vector(9 downto 0);
  signal WriteUart1         : std_logic;
  signal Uart1TxFifoFull    : std_logic;
  signal Uart1TxFifoEmpty   : std_logic;
  signal Uart1TxFifoData    : std_logic_vector(7 downto 0);
  signal Uart1TxFifoCount   : std_logic_vector(9 downto 0);
  signal Uart1ClkDivider    : std_logic_vector(7 downto 0);
  signal UartClk1           : std_logic;
  signal UartTxClk1         : std_logic;
  signal Txd1_i             : std_logic;
  signal Rxd1_i             : std_logic;
  signal UartRx1Dbg         : std_logic;

  signal Uart2FifoReset     : std_logic;
  signal Uart2FifoReset_i   : std_logic;
  signal ReadUart2          : std_logic;
  signal Uart2RxFifoFull    : std_logic;
  signal Uart2RxFifoEmpty   : std_logic;
  signal Uart2RxFifoReadAck : std_logic;
  signal Uart2RxFifoData    : std_logic_vector(7 downto 0);
  signal Uart2RxFifoCount   : std_logic_vector(9 downto 0);
  signal WriteUart2         : std_logic;
  signal Uart2TxFifoFull    : std_logic;
  signal Uart2TxFifoEmpty   : std_logic;
  signal Uart2TxFifoData    : std_logic_vector(7 downto 0);
  signal Uart2TxFifoCount   : std_logic_vector(9 downto 0);
  signal Uart2ClkDivider    : std_logic_vector(7 downto 0);
  signal UartClk2           : std_logic;
  signal UartTxClk2         : std_logic;
  signal Txd2_i             : std_logic;
  signal Rxd2_i             : std_logic;
  signal UartRx2Dbg         : std_logic;

  signal Uart3FifoReset     : std_logic;
  signal Uart3FifoReset_i   : std_logic;
  signal ReadUart3          : std_logic;
  signal Uart3RxFifoFull    : std_logic;
  signal Uart3RxFifoEmpty   : std_logic;
  signal Uart3RxFifoReadAck : std_logic;
  signal Uart3RxFifoData    : std_logic_vector(7 downto 0);
  signal Uart3RxFifoCount   : std_logic_vector(9 downto 0);
  signal WriteUart3         : std_logic;
  signal Uart3TxFifoFull    : std_logic;
  signal Uart3TxFifoEmpty   : std_logic;
  signal Uart3TxFifoData    : std_logic_vector(7 downto 0);
  signal Uart3TxFifoCount   : std_logic_vector(9 downto 0);
  signal Uart3ClkDivider    : std_logic_vector(7 downto 0);
  signal UartClk3           : std_logic;
  signal UartTxClk3         : std_logic;
  signal Txd3_i             : std_logic;
  signal Rxd3_i             : std_logic;
  signal UartRx3Dbg         : std_logic;

  -- Timing signals
  signal PPS_i              : std_logic;	
  signal PPSCountReset      : std_logic; --generated by register read
   -- are edges occuring on PPS?
   -- Mainly used by rtc to decide wether to roll the clock over on
   -- it's own or let PPS sync it
  signal PPSDetected        : std_logic;
   -- How many MasterClocks have gone by since the last PPS edge?
   -- (so we can phase-lock oscillator to GPS time)
  signal PPSCount           : std_logic_vector(31 downto 0) := x"00000000";
   --This is current count for this second, not total for the last second
  signal PPSCounter         : std_logic_vector(31 downto 0) := x"00000000";
  signal ClkDacWrite        : std_logic_vector(15 downto 0) := x"0000";
  signal WriteClkDac        : std_logic;
  signal ClkDacReadback     : std_logic_vector(15 downto 0);
  signal nCsXO_i            : std_logic;
  signal SckXO_i            : std_logic;
  signal MosiXO_i           : std_logic;
  signal MisoXO_i           : std_logic;
  
	signal DacSetpoints : DMDacSetpointRegisters;
	signal ProtoDacSetpoints : DMProtoDacSetpointRegisters;
	signal ProtoDacReadbacks : DMProtoDacSetpointRegisters;
	
	signal DacSetpointReadAddressController : integer range (DMMaxControllerBoards - 1) downto 0;
	signal DacSetpointReadAddressDac : integer range (DMMDacsPerControllerBoard - 1) downto 0;
	signal DacSetpointReadAddressChannel : integer range (DMActuatorsPerDac - 1) downto 0;
	signal DacSetpointWriteAddress : integer range (DMMaxActuators - 1) downto 0;
	signal DacSetpointToWrite : std_logic_vector(DMSetpointMSB downto 0);
	signal DacSetpointFromRead : std_logic_vector(DMSetpointMSB downto 0);
	signal DacSetpointWriteReq : std_logic;
	
	signal MosiDacA_i : std_logic;
	signal MosiDacB_i : std_logic;
	signal MosiDacC_i : std_logic;
	signal MosiDacD_i : std_logic;
	signal MosiDacE_i : std_logic;
	signal MosiDacF_i : std_logic;
	signal MisoDacA_i : std_logic;
	signal MisoDacB_i : std_logic;
	signal MisoDacC_i : std_logic;
	signal MisoDacD_i : std_logic;
	signal MisoDacE_i : std_logic;
	signal MisoDacF_i : std_logic;
	signal SckDacA_i : std_logic;
	signal SckDacB_i : std_logic;
	signal SckDacC_i : std_logic;
	signal SckDacD_i : std_logic;
	signal SckDacE_i : std_logic;
	signal SckDacF_i : std_logic;
	signal nCsDacsA_i : std_logic_vector(3 downto 0);
	signal nCsDacsB_i : std_logic_vector(3 downto 0);
	signal nCsDacsC_i : std_logic_vector(3 downto 0);
	signal nCsDacsD_i : std_logic_vector(3 downto 0);
	signal nCsDacsE_i : std_logic_vector(3 downto 0);
	signal nCsDacsF_i : std_logic_vector(3 downto 0);
	
	signal nCsDacs0_i : std_logic;
	signal nCsDacs1_i : std_logic;
	signal nCsDacs2_i : std_logic;
	signal nCsDacs3_i : std_logic;
	signal nCsDacs4_i : std_logic;
	signal nCsDacs5_i : std_logic;

  --these are just for testing the above!
  signal Board0OredSetpoints : std_logic_vector(DMSetpointMSB downto 0);
  signal Board1OredSetpoints : std_logic_vector(DMSetpointMSB downto 0);
  signal Board2OredSetpoints : std_logic_vector(DMSetpointMSB downto 0);
  signal Board3OredSetpoints : std_logic_vector(DMSetpointMSB downto 0);
  signal Board4OredSetpoints : std_logic_vector(DMSetpointMSB downto 0);
  signal Board5OredSetpoints : std_logic_vector(DMSetpointMSB downto 0);
  
  -- And a few constants
  constant nCsEnabled : std_logic := '0';
  constant nCsNotEnabled : std_logic := '1';
  constant JumperNotInserted : std_logic := '1';
  constant JumperInserted : std_logic := '0';

begin

  --- Globals ---
  MasterClk <= clk;
  UartClk <= clk;

  SerialNumber <= x"DEADBEEF"; -- this is the DM serial number

-- This is not in the include, but will copy to teh DMCIOverhaul directory
--  BuildNumber_i : BuildNumberPorts
--  port map
--  (
--    BuildNumber => BuildNumber--;
--  );

--  BootupReset : OneShotPorts
--  generic map (
--    CLOCK_FREQHZ => BoardMasterClockFreq;
--    DELAY_SECONDS => 0.000010,
--    SHOT_RST_STATE => '1',
--    SHOT_PRETRIGGER_STATE => '1'--,
--  )
--  port map 
--  (	
--    clk => MasterClk,
--    rst => '0',
--    shot => MasterReset
--  );

  --- Register Spaces ---
  --- This is the ram bus that reads and writes to memory spaces
  --- inside the M3 Core.  The DMHardware is at 0x50000000UL which
  --- writes to the AMBA bus.  This bus will then write/read the peripherals
  IBufCE : IBufP2Ports port map(clk => MasterClk, I => RamBusnCs, O => RamBusCE_i);
  IBufWrnRd : IBufP2Ports port map(clk => MasterClk, I => RamBusWrnRd, O => RamBusWrnRd_i);
  
  GenRamAddrBus: for i in 0 to (ADDRESS_BUS_BITS - 1) generate
  begin
    IBUF_RamAddr_i : IBufP1Ports
      port map (
        clk => MasterClk,
        I => RamBusAddress(i),
        O => RamAddress(i)--,
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

  
	DacSetpointWriteAddress <= conv_integer(RamAddress) - 1024;
	DacSetpointToWrite <= RamDataIn(DMSetpointMSB downto 0);
	DacSetpointWriteReq <= '1' when ( (RamBusCE_i = '1') and (RamBusWrnRd_i = '1') and (RamAddress >= std_logic_vector(to_unsigned(1024, ADDRESS_BUS_BITS))) ) else '0';
  
    DmDacRam : DmDacRamPorts
	port map (
		clk => MasterClk,
		rst => MasterReset,
		ReadAddressController => DacSetpointReadAddressController,
		ReadAddressDac => DacSetpointReadAddressDac,
		ReadAddressChannel => DacSetpointReadAddressChannel,
		WriteAddress => DacSetpointWriteAddress,
		DacSetpointIn => DacSetpointToWrite,
		DacSetpointOut => DacSetpointFromRead,
		WriteReq => DacSetpointWriteReq--,
	);

  RegisterSpaceDataToWrite <= RamDataIn;
  RegisterSpaceWriteReq <= '1' when ( (RamBusCE_i = '1') and (RamBusWrnRd_i = '1') and (RamAddress < std_logic_vector(to_unsigned(1024, ADDRESS_BUS_BITS))) ) else '0';
  RamDataOut <= RegisterSpaceDataFromRead;
  RegisterSpaceReadReq <= '1' when ( (RamBusCE_i = '1') and (RamBusWrnRd_i = '0') and (RamAddress < std_logic_vector(to_unsigned(1024, ADDRESS_BUS_BITS))) ) else '0';
  RamBusAck_i <= RegisterSpaceReadAck or RegisterSpaceWriteAck;
  RamBusAck <= RamBusAck_i;
  	
  --- Register Space ---
  --- Mapping the register space.  These come from RegisterSpace.vhd
  RegisterSpace : RegisterSpacePorts
  generic map (
    ADDRESS_BITS => ADDRESS_BUS_BITS--,
  )
  port map (
    clk => MasterClk,
    rst => MasterReset,

    Address  => RamAddress,
    DataIn   => RegisterSpaceDataToWrite,
    DataOut  => RegisterSpaceDataFromRead,
    ReadReq  => RegisterSpaceReadReq,
    WriteReq => RegisterSpaceWriteReq,
    ReadAck  => RegisterSpaceReadAck,
    WriteAck => RegisterSpaceWriteAck,
    
    --Data to access:
    
    --Infrastructure
    SerialNumber => SerialNumber,
    BuildNumber  => BuildNumber,

    -- Faults and Control
--    PowernEnHV => PowernEnHV,
--    PowernEn   => PowernEn,
    Uart0OE    => OE0,
    Uart1OE    => OE1,
    Uart2OE    => OE2,
    Uart3OE    => OE3,
    --~ Ux1SelJmp => Ux1SelJmp,
    Ux1SelJmp => open,

    --- DM D/As ---
    DacBdASetpoint      => DacBdASetpoint,
    DacBdBSetpoint      => DacBdBSetpoint,
    DacBdCSetpoint      => DacBdCSetpoint,
    DacBdDSetpoint      => DacBdDSetpoint,
    DacBdESetpoint      => DacBdESetpoint,
    DacBdFSetpoint      => DacBdFSetpoint,
    WriteDacs           => WriteDacs,
    DacBdAReadback      => DacBdAReadback,
    DacBdBReadback      => DacBdBReadback,
    DacBdCReadback      => DacBdCReadback,
    DacBdDReadback      => DacBdDReadback,
    DacBdEReadback      => DacBdEReadback,
    DacBdFReadback      => DacBdFReadback,
    DacTransferCompleteA => DacTransferCompleteA,
    DacTransferCompleteB => DacTransferCompleteB,
    DacTransferCompleteC => DacTransferCompleteC,
    DacTransferCompleteD => DacTransferCompleteD,
    DacTransferCompleteE => DacTransferCompleteE,
    DacTransferCompleteF => DacTransferCompleteF,

    -- DM Readback A/Ds
--    ReadAdcSample      => ReadAdcSample,
--    AdcSampleToReadA   => AdcSampleToReadA,
--    AdcSampleToReadB   => AdcSampleToReadB,
--    AdcSampleToReadC   => AdcSampleToReadC,
--    AdcSampleToReadD   => AdcSampleToReadD,
--    AdcSampleNumAccums => AdcSampleNumAccums,

    -- DM Monitor A/D
--    MonitorAdcChannelReadIndex => MonitorAdcChannelReadIndex,
--    ReadMonitorAdcSample       => ReadMonitorAdcSample      , 
--    MonitorAdcSampleToRead     => MonitorAdcSampleToRead    , 
--    MonitorAdcReset            => MonitorAdcReset           , 
--    MonitorAdcSpiDataIn        => MonitorAdcSpiDataIn       , 
--    MonitorAdcSpiDataOut0      => MonitorAdcSpiDataOut0     , 
--    MonitorAdcSpiDataOut1      => MonitorAdcSpiDataOut1     , 
--    MonitorAdcSpiXferStart     => MonitorAdcSpiXferStart    , 
--    MonitorAdcSpiXferDone      => MonitorAdcSpiXferDone     , 
--    MonitorAdcnDrdy0           => MonitorAdcnDrdy0          , 
--    MonitorAdcnDrdy1           => MonitorAdcnDrdy1          , 
--    MonitorAdcSpiFrameEnable   => MonitorAdcSpiFrameEnable  , 

    --- RS422 ---
    Uart0FifoReset     => Uart0FifoReset    ,
    ReadUart0          => ReadUart0         ,
    Uart0RxFifoFull    => Uart0RxFifoFull   ,
    Uart0RxFifoEmpty   => Uart0RxFifoEmpty  ,
    Uart0RxFifoData    => Uart0RxFifoData   ,
    Uart0RxFifoCount   => Uart0RxFifoCount  ,
    WriteUart0         => WriteUart0        ,
    Uart0TxFifoFull    => Uart0TxFifoFull   ,
    Uart0TxFifoEmpty   => Uart0TxFifoEmpty  ,
    Uart0TxFifoData    => Uart0TxFifoData   ,
    Uart0TxFifoCount   => Uart0TxFifoCount  ,
    Uart0ClkDivider    => Uart0ClkDivider   ,

    Uart1FifoReset     => Uart1FifoReset    ,
    ReadUart1          => ReadUart1         ,
    Uart1RxFifoFull    => Uart1RxFifoFull   ,
    Uart1RxFifoEmpty   => Uart1RxFifoEmpty  ,
    Uart1RxFifoData    => Uart1RxFifoData   ,
    Uart1RxFifoCount   => Uart1RxFifoCount  ,
    WriteUart1         => WriteUart1        ,
    Uart1TxFifoFull    => Uart1TxFifoFull   ,
    Uart1TxFifoEmpty   => Uart1TxFifoEmpty  ,
    Uart1TxFifoData    => Uart1TxFifoData   ,
    Uart1TxFifoCount   => Uart1TxFifoCount  ,
    Uart1ClkDivider    => Uart1ClkDivider   ,

    Uart2FifoReset     => Uart2FifoReset    ,
    ReadUart2          => ReadUart2         ,
    Uart2RxFifoFull    => Uart2RxFifoFull   ,
    Uart2RxFifoEmpty   => Uart2RxFifoEmpty  ,
    Uart2RxFifoData    => Uart2RxFifoData   ,
    Uart2RxFifoCount   => Uart2RxFifoCount  ,
    WriteUart2         => WriteUart2        ,
    Uart2TxFifoFull    => Uart2TxFifoFull   ,
    Uart2TxFifoEmpty   => Uart2TxFifoEmpty  ,
    Uart2TxFifoData    => Uart2TxFifoData   ,
    Uart2TxFifoCount   => Uart2TxFifoCount  ,
    Uart2ClkDivider    => Uart2ClkDivider   ,

    Uart3FifoReset     => Uart3FifoReset,
    ReadUart3          => ReadUart3,  
    Uart3RxFifoFull    => Uart3RxFifoFull    ,
    Uart3RxFifoEmpty   => Uart3RxFifoEmpty   ,
    Uart3RxFifoData    => Uart3RxFifoData    ,
    Uart3RxFifoCount   => Uart3RxFifoCount   ,
    WriteUart3         => WriteUart3         ,
    Uart3TxFifoFull    => Uart3TxFifoFull    ,
    Uart3TxFifoEmpty   => Uart3TxFifoEmpty   ,
    Uart3TxFifoData    => Uart3TxFifoData    ,
    Uart3TxFifoCount   => Uart3TxFifoCount   ,
    Uart3ClkDivider    => Uart3ClkDivider    ,

    --- Timing ---
    IdealTicksPerSecond   => std_logic_vector(to_unsigned(BoardMasterClockFreq, 32)), 
    ActualTicksLastSecond => PPSCount,
    PPSCountReset         => PPSCountReset, 
    PPSDetected           => PPSDetected  , 
    ClockTicksThisSecond  => PPSCounter   , 
    ClkDacWrite           => ClkDacWrite  , 
    WriteClkDac           => WriteClkDac  , 
    ClkDacReadback        => ClkDacReadback--,
	
	--~ DacSetpoints => DacSetpoints,
	--~ DacChannelReadIndex => DacChannelReadIndex--,
  );

	MosiA <= MosiDacA_i;
	MosiB <= MosiDacB_i;
	MosiC <= MosiDacC_i;
	MosiD <= MosiDacD_i;
	MosiE <= MosiDacE_i;
	MosiF <= MosiDacF_i;
	--~ MisoDacA_i <= MisoDacA;
	--~ MisoDacB_i <= MisoDacB;
	--~ MisoDacC_i <= MisoDacC;
	--~ MisoDacD_i <= MisoDacD;
	--~ MisoDacE_i <= MisoDacE;
	--~ MisoDacF_i <= MisoDacF;
	SckA <= SckDacA_i;
	SckB <= SckDacB_i;
	SckC <= SckDacC_i;
	SckD <= SckDacD_i;
	SckE <= SckDacE_i;
	SckF <= SckDacF_i;
	nCsA <= nCsDacsA_i;
	nCsB <= nCsDacsB_i;
	nCsC <= nCsDacsC_i;
	nCsD <= nCsDacsD_i;
	nCsE <= nCsDacsE_i;
	nCsF <= nCsDacsF_i;
	IBufMisoDacA : IBufP2Ports port map(clk => MasterClk, I => MisoA, O => MisoDacA_i);
	IBufMisoDacB : IBufP2Ports port map(clk => MasterClk, I => MisoB, O => MisoDacB_i);
	IBufMisoDacC : IBufP2Ports port map(clk => MasterClk, I => MisoC, O => MisoDacC_i);
	IBufMisoDacD : IBufP2Ports port map(clk => MasterClk, I => MisoD, O => MisoDacD_i);
	IBufMisoDacE : IBufP2Ports port map(clk => MasterClk, I => MisoE, O => MisoDacE_i);
	IBufMisoDacF : IBufP2Ports port map(clk => MasterClk, I => MisoF, O => MisoDacF_i);
	
	nCsDacsA_i(0) <= nCsDacs0_i when DacSetpointReadAddressDac = 0 else '1';
	nCsDacsA_i(1) <= nCsDacs0_i when DacSetpointReadAddressDac = 1 else '1';
	nCsDacsA_i(2) <= nCsDacs0_i when DacSetpointReadAddressDac = 2 else '1';
	nCsDacsA_i(3) <= nCsDacs0_i when DacSetpointReadAddressDac = 3 else '1';

	nCsDacsB_i(0) <= nCsDacs1_i when DacSetpointReadAddressDac = 0 else '1';
	nCsDacsB_i(1) <= nCsDacs1_i when DacSetpointReadAddressDac = 1 else '1';
	nCsDacsB_i(2) <= nCsDacs1_i when DacSetpointReadAddressDac = 2 else '1';
	nCsDacsB_i(3) <= nCsDacs1_i when DacSetpointReadAddressDac = 3 else '1';

	nCsDacsC_i(0) <= nCsDacs2_i when DacSetpointReadAddressDac = 0 else '1';
	nCsDacsC_i(1) <= nCsDacs2_i when DacSetpointReadAddressDac = 1 else '1';
	nCsDacsC_i(2) <= nCsDacs2_i when DacSetpointReadAddressDac = 2 else '1';
	nCsDacsC_i(3) <= nCsDacs2_i when DacSetpointReadAddressDac = 3 else '1';

	nCsDacsD_i(0) <= nCsDacs3_i when DacSetpointReadAddressDac = 0 else '1';
	nCsDacsD_i(1) <= nCsDacs3_i when DacSetpointReadAddressDac = 1 else '1';
	nCsDacsD_i(2) <= nCsDacs3_i when DacSetpointReadAddressDac = 2 else '1';
	nCsDacsD_i(3) <= nCsDacs3_i when DacSetpointReadAddressDac = 3 else '1';

	nCsDacsE_i(0) <= nCsDacs4_i when DacSetpointReadAddressDac = 0 else '1';
	nCsDacsE_i(1) <= nCsDacs4_i when DacSetpointReadAddressDac = 1 else '1';
	nCsDacsE_i(2) <= nCsDacs4_i when DacSetpointReadAddressDac = 2 else '1';
	nCsDacsE_i(3) <= nCsDacs4_i when DacSetpointReadAddressDac = 3 else '1';

	nCsDacsF_i(0) <= nCsDacs5_i when DacSetpointReadAddressDac = 0 else '1';
	nCsDacsF_i(1) <= nCsDacs5_i when DacSetpointReadAddressDac = 1 else '1';
	nCsDacsF_i(2) <= nCsDacs5_i when DacSetpointReadAddressDac = 2 else '1';
	nCsDacsF_i(3) <= nCsDacs5_i when DacSetpointReadAddressDac = 3 else '1';

  --- DM D/As ---
  
  DMDacsA_i : SpiDacPorts
  generic map (
    CLOCK_DIVIDER => 1000, --how much do you want to knock down the global clock to get to the spi clock rate?
    BIT_WIDTH => 16--; --how many bytes per transaction?
  )
  port map (
    clk => MasterClk,
    rst => MasterReset,
    --Spi pins  
    nCs => nCsDacs0_i,
    Mosi => MosiDacA_i,
    Sck => SckDacA_i,    
    Miso => MisoDacA_i,
    -- Control signals
    WriteDac => WriteDacs,
    DacWriteOut => ProtoDacSetpoints(0)(23 downto 8),
    DacReadback => ProtoDacReadbacks(0)(23 downto 8)--,
    --~ XferComplete => DacTransferCompleteA
  );

  DMDacsB_i : SpiDacPorts
  generic map (
    CLOCK_DIVIDER => 1000, --how much do you want to knock down the global clock to get to the spi clock rate?
    BIT_WIDTH => 16--; --how many bytes per transaction?
  )
  port map (
    clk => MasterClk,
    rst => MasterReset,
    --Spi pins  
    nCs => nCsDacs1_i,
    Mosi => MosiDacB_i,
    Sck => SckDacB_i,    
    Miso => MisoDacB_i,
    -- Control signals
    WriteDac => WriteDacs,
    DacWriteOut => ProtoDacSetpoints(1)(23 downto 8),
    DacReadback => ProtoDacReadbacks(1)(23 downto 8)--,
    --~ XferComplete => DacTransferCompleteB
  );

  DMDacsC_i : SpiDacPorts
  generic map (
    CLOCK_DIVIDER => 1000, --how much do you want to knock down the global clock to get to the spi clock rate?
    BIT_WIDTH => 16--; --how many bytes per transaction?
  )
  port map (
    clk => MasterClk,
    rst => MasterReset,
    --Spi pins  
    nCs => nCsDacs2_i,
    Mosi => MosiDacC_i,
    Sck => SckDacC_i,    
    Miso => MisoDacC_i,
    -- Control signals
    WriteDac => WriteDacs,
    DacWriteOut => ProtoDacSetpoints(2)(23 downto 8),
    DacReadback => ProtoDacReadbacks(2)(23 downto 8)--,
    --~ XferComplete => DacTransferCompleteC
  );
  
  DMDacsD_i : SpiDacPorts
  generic map (
    CLOCK_DIVIDER => 1000, --how much do you want to knock down the global clock to get to the spi clock rate?
    BIT_WIDTH => 16--; --how many bytes per transaction?
  )
  port map (
    clk => MasterClk,
    rst => MasterReset,
    --Spi pins  
    nCs => nCsDacs3_i,
    Mosi => MosiDacD_i,
    Sck => SckDacD_i,    
    Miso => MisoDacD_i,
    -- Control signals
    WriteDac => WriteDacs,
    DacWriteOut => ProtoDacSetpoints(3)(23 downto 8),
    DacReadback => ProtoDacReadbacks(3)(23 downto 8)--,
    --~ XferComplete => DacTransferCompleteD
  );
  
  DMDacsE_i : SpiDacPorts
  generic map (
    CLOCK_DIVIDER => 1000, --how much do you want to knock down the global clock to get to the spi clock rate?
    BIT_WIDTH => 16--; --how many bytes per transaction?
  )
  port map (
    clk => MasterClk,
    rst => MasterReset,
    --Spi pins  
    nCs => nCsDacs4_i,
    Mosi => MosiDacE_i,
    Sck => SckDacE_i,    
    Miso => MisoDacE_i,
    -- Control signals
    WriteDac => WriteDacs,
    DacWriteOut => ProtoDacSetpoints(4)(23 downto 8),
    DacReadback => ProtoDacReadbacks(4)(23 downto 8)--,
    --~ XferComplete => DacTransferCompleteE
  );
  
  DMDacsF_i : SpiDacPorts
  generic map (
    CLOCK_DIVIDER => 1000, --how much do you want to knock down the global clock to get to the spi clock rate?
    BIT_WIDTH => 16--; --how many bytes per transaction?
  )
  port map (
    clk => MasterClk,
    rst => MasterReset,
    --Spi pins  
    nCs => nCsDacs5_i,
    Mosi => MosiDacF_i,
    Sck => SckDacF_i,    
    Miso => MisoDacF_i,
    -- Control signals
    WriteDac => WriteDacs,
    DacWriteOut => ProtoDacSetpoints(5)(23 downto 8),
    DacReadback => ProtoDacReadbacks(5)(23 downto 8)--,
    --~ XferComplete => DacTransferCompleteF
  );

  -- Is this how we deal with loading the DACs?  All at once?
  --not(nCs) prolly works, but this is more technically correct:
--  nLDacsOneShot : OneShotPorts
--  generic map (
--    CLOCK_FREQHZ => BoardMasterClockFreq,
--    --~ DELAY_SECONDS => 0.000000025, --25ns
--    DELAY_SECONDS => 0.00000005, --50ns (MAX5719 specifies 20ns min)
--    SHOT_RST_STATE => '1',
--    SHOT_PRETRIGGER_STATE => '1' --This is gonna hold nLDac low until the next SPI cycle, which doesn't look like the pic in the datasheet, but it doesn't say we can't, since the falling edge is what matters...ideally we'd toggle it back on the Rising edge of WriteDac at the very beginning, but we can sort the brass tacks later...
--  )
--  port map (	
--    clk => MasterClk,
--    rst => not(nCsDacA_i),
--    shot => nLDacs_i
--  );


  -- RS-422 Uarts section
  
  --- Uart0 ---
  Uart0BitClockDiv : VariableClockDividerPorts
  generic map (
    WIDTH_BITS => 8,
    DIVOUT_RST_STATE => '0'--;
  )
  port map (
    --~ clki => MasterClk,
    clki => UartClk,
    rst => MasterReset,
    rst_count => x"00",
    terminal_count => Uart0ClkDivider,
    clko => UartClk0
  );
  Uart0TxBitClockDiv : ClockDividerPorts
  generic map (
    CLOCK_DIVIDER => 16,
    DIVOUT_RST_STATE => '0'--;
  )
  port map (
    clk => UartClk0,
    rst => MasterReset,
    div => UartTxClk0
  );
		
  IBufRxd0 : IBufP3Ports port map(clk => UartClk, I => Rx0, O => Rxd0_i); --if you want to change the pin for this chip select, it's here
	
  RS422_Rx0 : UartRxFifoExtClk
  generic map (
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
  port map (
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
  generic map (
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
  port map (
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

  --- Uart 1 ---
  Uart1BitClockDiv : VariableClockDividerPorts
  generic map (
    WIDTH_BITS => 8,
    DIVOUT_RST_STATE => '0'--;
  )
  port map (
    --~ clki => MasterClk,
    clki => UartClk,
    rst => MasterReset,
    rst_count => x"00",
    terminal_count => Uart1ClkDivider,
    clko => UartClk1
  );
  
  Uart1TxBitClockDiv : ClockDividerPorts
  generic map (
    CLOCK_DIVIDER => 16,
    DIVOUT_RST_STATE => '0'--;
  )
  port map (
    clk => UartClk1,
    rst => MasterReset,
    div => UartTxClk1
  );
	
  IBufRxd1 : IBufP3Ports port map(clk => UartClk, I => Rx1, O => Rxd1_i); --if you want to change the pin for this chip select, it's here
	
  RS422_Rx1 : UartRxFifoExtClk
  generic map (
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
  port map (
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
  generic map (
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
  port map (
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

  --- Uart 2 ---
  Uart2BitClockDiv : VariableClockDividerPorts
  generic map (
    WIDTH_BITS => 8,
    DIVOUT_RST_STATE => '0'--;
  )
  port map (
    --~ clki => MasterClk,
    clki => UartClk,
    rst => MasterReset,
    rst_count => x"00",
    terminal_count => Uart2ClkDivider,
    clko => UartClk2
  );
  
  Uart2TxBitClockDiv : ClockDividerPorts
  generic map (
    CLOCK_DIVIDER => 16,
    DIVOUT_RST_STATE => '0'--;
  )
  port map (
    clk => UartClk2,
    rst => MasterReset,
    div => UartTxClk2
  );
	
  --~ Ux1SelJmp <= UartClk2;
	
  IBufRxd2 : IBufP3Ports port map(clk => UartClk, I => Rx2, O => Rxd2_i); --if you want to change the pin for this chip select, it's here
	
  --~ Ux1SelJmp <= Rxd2;
	
  RS422_Rx2 : UartRxFifoExtClk
  generic map (
    --~ UART_CLOCK_FREQHZ => BoardMasterClockFreq,
    FIFO_BITS => 10--,
   --~ BAUD_DIVIDER_BITS => 8--,
   --~ BAUDRATE => 12500000--,
   --~ BAUDRATE => 8000000--,
   --~ BAUDRATE => BoardMasterClockFreq / 16--, --9.216MHz
   --~ BAUDRATE => BoardMasterClockFreq / 8192--,
   --~ BAUDRATE => 115200--,
  )
  port map (
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
  generic map (
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
  port map (
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

  --- Uart 3 ---
  Uart3BitClockDiv : VariableClockDividerPorts
  generic map (
    WIDTH_BITS => 8,
    DIVOUT_RST_STATE => '0'--;
  )
  port map (
    --~ clki => MasterClk,
    clki => UartClk,
    rst => MasterReset,
    rst_count => x"00",
    terminal_count => Uart3ClkDivider,
    clko => UartClk3
  );
  Uart3TxBitClockDiv : ClockDividerPorts
  generic map (
    CLOCK_DIVIDER => 16,
    DIVOUT_RST_STATE => '0'--;
  )
  port map (
    clk => UartClk3,
    rst => MasterReset,
    div => UartTxClk3
  );

  --~ Ux1SelJmp <= UartClk3;
	
  IBufRxd3 : IBufP3Ports port map(clk => UartClk, I => Rx3, O => Rxd3_i); --if you want to change the pin for this chip select, it's here
	
  --~ Ux1SelJmp <= Rxd3;
	
  RS433_Rx3 : UartRxFifoExtClk
  generic map (
    --~ UART_CLOCK_FREQHZ => BoardMasterClockFreq,
    FIFO_BITS => 10--,
   --~ BAUD_DIVIDER_BITS => 8--,
   --~ BAUDRATE => (ADDRESS_BUS_BITS - 1)500000--,
   --~ BAUDRATE => 8000000--,
   --~ BAUDRATE => BoardMasterClockFreq / 16--, --9.316MHz
   --~ BAUDRATE => BoardMasterClockFreq / 8193--,
   --~ BAUDRATE => 115300--,
  )
  port map (
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
  generic map (
    --~ UART_CLOCK_FREQHZ => BoardMasterClockFreq,
    --~ FIFO_BITS => 10,
    FIFO_BITS => 10--,
   --~ BAUD_DIVIDER_BITS => 8--,
   --~ BAUDRATE => (ADDRESS_BUS_BITS - 1)500000--,
   --~ BAUDRATE => 8000000--,
   --~ BAUDRATE => BoardMasterClockFreq / 16--, --9.316MHz
   --~ BAUDRATE => BoardMasterClockFreq / 8193--,
   --~ BAUDRATE => 115300--,
  )
  port map (
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

  ----------------------------- Timing ----------------------------------
	
  --~ --Just sync external PPS to master clock
  IBufPPS : IBufP2Ports port map(clk => MasterClk, I => PPS, O => PPS_i);
		
  --~ --Count up MasterClocks per PPS so we can sync the oscilator to the GPS clock
  PPSAccumulator : PPSCountPorts
  port map (
    clk => MasterClk,
    PPS => PPS_i,
    PPSReset => PPSCountReset,
    PPSDetected => PPSDetected,
    PPSCounter => PPSCounter,
    --~ PPSAccum => PPSCount--,
	PPSAccum => open--,
  );

  --- Don't know what this is
  --- Is this just part of the FineSteering Mirror Hardware?
  --- Need to check out
  MisoXO_i <= '1';

  -- Have all the SPI ports earlier in the code, not sure what this is
--  ClkDac_i : SpiDacPorts
--  generic map (
--    MASTER_CLOCK_FREQHZ => BoardMasterClockFreq,
--    BIT_WIDTH => 16
--  )
--  port map (
--    clk => MasterClk,
--    rst => MasterReset,
--    nCs => nCsXO_i,
--    Sck => SckXO_i,
--    Mosi => MosiXO_i,
--    Miso => MisoXO_i,
--    DacWriteOut => ClkDacWrite,
--    WriteDac => WriteClkDac,
--    DacReadback => ClkDacReadback
--  );

  nCsXO <= nCsXO_i;
  SckXO <= SckXO_i;
  MosiXO <= MosiXO_i;
  

  --Ok, we're gonna find a way to xor all the setpoints into the PPSCount var just for testing so it doesn't all get synthesized outta existence...  
  Board0OredSetpoints <= DacSetpoints(0, 0) xor DacSetpoints(0, 1) xor DacSetpoints(0, 2) xor DacSetpoints(0, 3);
  Board1OredSetpoints <= DacSetpoints(1, 0) xor DacSetpoints(1, 1) xor DacSetpoints(1, 2) xor DacSetpoints(1, 3);
  Board2OredSetpoints <= DacSetpoints(2, 0) xor DacSetpoints(2, 1) xor DacSetpoints(2, 2) xor DacSetpoints(2, 3);
  Board3OredSetpoints <= DacSetpoints(3, 0) xor DacSetpoints(3, 1) xor DacSetpoints(3, 2) xor DacSetpoints(3, 3);
  Board4OredSetpoints <= DacSetpoints(4, 0) xor DacSetpoints(4, 1) xor DacSetpoints(4, 2) xor DacSetpoints(4, 3);
  Board5OredSetpoints <= DacSetpoints(5, 0) xor DacSetpoints(5, 1) xor DacSetpoints(5, 2) xor DacSetpoints(5, 3);

  PPSCount(31 downto DMSetpointMSB + 1) <= x"00";
  PPSCount(DMSetpointMSB downto 0) <= Board0OredSetpoints xor Board1OredSetpoints xor Board2OredSetpoints xor Board3OredSetpoints xor Board4OredSetpoints xor Board5OredSetpoints;

  ----------------------------- Power Supplies ----------------------------------
  --- Is this also part of the FSM?
--  PowerSync <= '1';


  ----------------------------- Clocked Logic / Main Loop ----------------------------------
  process(MasterReset, MasterClk)
  begin

    if (MasterReset = '1') then	
      --This is where we have to actually set all of our registers, since the M2S devices don't support initialization as though they are from the 1980's...
    else
      if ( (MasterClk'event) and (MasterClk = '1') ) then
	  
		--Just move the addresses for the ram (in code way up above) ahead round-robin each clock for now so we can test...(need to read all 40 channels each write cycle in the real version)
		if (DacSetpointReadAddressController < (DMMaxControllerBoards - 1)) then DacSetpointReadAddressController <= DacSetpointReadAddressController + 1; else DacSetpointReadAddressController <= 0; end if;
		if (DacSetpointReadAddressDac < (DMMDacsPerControllerBoard - 1)) then DacSetpointReadAddressDac <= DacSetpointReadAddressDac + 1; else DacSetpointReadAddressDac <= 0; end if;
		if (DacSetpointReadAddressChannel < (DMActuatorsPerDac - 1)) then DacSetpointReadAddressChannel <= DacSetpointReadAddressChannel + 1; else DacSetpointReadAddressChannel <= 0; end if;

		--copy from ram to register (this works on a single clock cause we set the ram up for aysnc read)
		DacSetpoints(DacSetpointReadAddressController, DacSetpointReadAddressDac) <= DacSetpointFromRead;
		ProtoDacSetpoints(DacSetpointReadAddressController) <= DacSetpointFromRead;
		
			--~ --Mux ram outputs
			--~ for i in 0 to (DMMaxControllerBoards - 1) loop
				--~ for j in 0 to (DMMDacsPerControllerBoard - 1) loop
					--~ DacSetpoints(i,j) <= DacSetpoints_i(i,j,to_integer(unsigned(DacChannelReadIndex))); 
				--~ end loop;
			--~ end loop;

			--~ --DacSetpointsAddr:
			--~ for i in 0 to (DMMaxControllerBoards - 1) loop
				--~ for j in 0 to (DMMDacsPerControllerBoard - 1) loop
					--~ for k in 0 to (DMActuatorsPerDac - 1) loop
						--~ if (Address_i = (DacSetpointsAddr + std_logic_vector(to_unsigned((i * DMMDacsPerControllerBoard * DMActuatorsPerDac) + (j * DMActuatorsPerDac) + k, MAX_ADDRESS_BITS)))) then
							--~ DataOut(DMSetpointMSB downto 0) <= DacSetpoints_i(i,j,k); 
							--~ DataOut(31 downto 24) <= x"00";
						--~ end if;
					--~ end loop;
				--~ end loop;
			--~ end loop;
			
			--~ --DacSetpointsAddr:
			--~ for i in 0 to (DMMaxControllerBoards - 1) loop
				--~ for j in 0 to (DMMDacsPerControllerBoard - 1) loop
					--~ for k in 0 to (DMActuatorsPerDac - 1) loop
						--~ if (Address_i = (DacSetpointsAddr + std_logic_vector(to_unsigned((i * DMMDacsPerControllerBoard * DMActuatorsPerDac) + (j * DMActuatorsPerDac) + k, MAX_ADDRESS_BITS)))) then
							--~ --DacSetpoints_i(i,j,k) <= DataIn(DMSetpointMSB downto 0);
							--~ DacSetpoints_i(i,j,k) := DataIn(DMSetpointMSB downto 0);
						--~ end if;
					--~ end loop;
				--~ end loop;
			--~ end loop;

      end if;
    end if;	

  end process;

	
end DMMain;

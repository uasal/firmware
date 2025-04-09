--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--~ use IEEE.std_logic_unsigned.all;
use work.CGraphDMTypes.all;

entity DMMainPorts is
  port (
    clk : in  std_logic;
    StateOut : out std_logic_vector(4 downto 0);
	
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
		
    --uC Ram Bus 0
    RamBusAddress : in std_logic_vector(13 downto 0); -- Address vector is ADDRESS_BUS_BITS bits
    RamBusDataIn : in std_logic_vector(31 downto 0);
    RamBusDataOut : out std_logic_vector(31 downto 0);
    RamBusnCs : in std_logic;
    RamBusWrnRd : in std_logic;
    RamBusLatch : in std_logic;
    RamBusAck : out std_logic;

    --uC Ram Bus 1
    RamBusAddress1 : in std_logic_vector(13 downto 0); -- Address vector is ADDRESS_BUS_BITS bits
    RamBusDataIn1 : in std_logic_vector(31 downto 0);
    RamBusDataOut1 : out std_logic_vector(31 downto 0);
    RamBusnCs1 : in std_logic;
    RamBusWrnRd1 : in std_logic;
    RamBusLatch1 : in std_logic;
    RamBusAck1 : out std_logic;
	
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
	
	Testpoints : out std_logic_vector(5 downto 0);
		
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
      DacReadback : out std_logic_vector(BIT_WIDTH - 1 downto 0);
	  TransferComplete : out std_logic--;
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

    component DmDacRamFlatPorts is
	  port (
		clk : in std_logic;
		rst : in std_logic;
			
		-- Bus:
		ReadAddress : in integer range (DMMaxActuators - 1) downto 0;
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
  --~ signal RamBusLatch_i   : std_logic;		
  signal RamBusCE_i      : std_logic;		
  signal RamBusWrnRd_i   : std_logic;		
  signal RamAddress : std_logic_vector((ADDRESS_BUS_BITS - 1) downto 0);		
  signal RamDataOut      : std_logic_vector(31 downto 0);		
  signal RamDataIn       : std_logic_vector(31 downto 0);		
  signal RamBusAck_i     : std_logic;

  -- Ram Bus1 (which is the Amba Bus to/from the processor. Internally.)
  --~ constant ADDRESS_BUS_BITS : natural := 14;  Don't need to repeat this
  --~ signal RamBusLatch_i   : std_logic;		
  signal RamBusCE1_i      : std_logic;		
  signal RamBusWrnRd1_i   : std_logic;		
  signal RamAddress1 : std_logic_vector((ADDRESS_BUS_BITS - 1) downto 0);		
  signal RamDataOut1      : std_logic_vector(31 downto 0);		
  signal RamDataIn1       : std_logic_vector(31 downto 0);		
  signal RamBusAck1_i     : std_logic;

  -- Register space		
  signal RegisterSpaceDataToWrite : std_logic_vector(31 downto 0);
  signal RegisterSpaceWriteReq : std_logic;
  signal RegisterSpaceWriteAck : std_logic;
  signal RegisterSpaceDataFromRead : std_logic_vector(31 downto 0);
  signal RegisterSpaceReadReq : std_logic;
  signal RegisterSpaceReadAck : std_logic;
                                             
  -- DM D/As (These might get subsumed in the SPI port compoenents)

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

	signal DacSetpoints : DMDacSetpointRegisters;
	--~ signal ProtoDacSetpoints : DMProtoDacSetpointRegisters;
	signal ProtoDacReadbacks : DMProtoDacSetpointRegisters;
	
	signal DacSetpointReadAddressController : integer range (DMMaxControllerBoards - 1) downto 0;
	signal DacSetpointReadAddressDac : integer range (DMMDacsPerControllerBoard - 1) downto 0;
--        signal DacSetpointReadedAddressController : integer range (DMMaxControllerBoards - 1) downto 0;
--	signal DacSetpointReadedAddressDac : integer range (DMMDacsPerControllerBoard - 1) downto 0;
	signal DacSetpointReadAddressChannel : integer range (DMActuatorsPerDac - 1) downto 0;
	signal DacSetpointReadAddress : integer range (DMMaxActuators - 1) downto 0;
	signal DacSetpointWriteAddress : integer range (DMMaxActuators - 1) downto 0;
        signal DacSetpointWriteAck : std_logic;
	
	signal DacSetpointToWriteToRam : std_logic_vector(DMSetpointMSB downto 0);
	signal DacASetpointToWrite : std_logic_vector(DMSetpointMSB downto 0);
	signal DacBSetpointToWrite : std_logic_vector(DMSetpointMSB downto 0);
	signal DacCSetpointToWrite : std_logic_vector(DMSetpointMSB downto 0);
	signal DacDSetpointToWrite : std_logic_vector(DMSetpointMSB downto 0);
	signal DacESetpointToWrite : std_logic_vector(DMSetpointMSB downto 0);
	signal DacFSetpointToWrite : std_logic_vector(DMSetpointMSB downto 0);
	signal DacSetpointFromRead : std_logic_vector(DMSetpointMSB downto 0);
	signal DacSetpointWriteReq : std_logic;
	
	signal WriteDacs           : std_logic;
	signal nLDacs_i            : std_logic;	

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
	
	signal DacASetpointWritten : std_logic;
	signal DacBSetpointWritten : std_logic;
	signal DacCSetpointWritten : std_logic;
	signal DacDSetpointWritten : std_logic;
	signal DacESetpointWritten : std_logic;
	signal DacFSetpointWritten : std_logic;
	
	type DacProtoWriteStates is ( Idle, ReadChannel, LatchChannel, PreWriteCs0, WriteCs0, PreWriteCs1, WriteCs1, PreWriteCs2, WriteCs2, PreWriteCs3, WriteCs3, NextChannel);
	signal DacWriteNextState : DacProtoWriteStates;
	signal DacWriteCurrentState : DacProtoWriteStates;
  
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
  BuildNumber <=  x"000FADED"; -- this is the DM serial number

-- This is not in the include, but will copy to teh DMCIOverhaul directory
--  BuildNumber_i : BuildNumberPorts
--  port map
--  (
--    BuildNumber => BuildNumber--;
--  );

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

  --- Register Spaces ---
  --- This is the ram bus 0 that reads and writes to DM memory spaces
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

  -- Ram bus 1 that reads and write to the dRAM memory spaces
  -- dRAM is at 0x50001000 which is the second AMBA bus.
  IBufCE1 : IBufP2Ports port map(clk => MasterClk, I => RamBusnCs1, O => RamBusCE1_i);
  IBufWrnRd1 : IBufP2Ports port map(clk => MasterClk, I => RamBusWrnRd1, O => RamBusWrnRd1_i);
  
  GenRamAddrBus1: for i in 0 to (ADDRESS_BUS_BITS - 1) generate
  begin
    IBUF_RamAddr1_i : IBufP1Ports
      port map (
        clk => MasterClk,
        I => RamBusAddress1(i),
        O => RamAddress1(i)--,
      ); 
  end generate;
		
  GenRamDataBus1: for i in 0 to 31 generate
  begin
    IBUF_RamData1_i : IBufP1Ports
      port map (
        clk => MasterClk,
        I => RamBusDataIn1(i),
        O => RamDataIn1(i)--,
      );
			
    RamBusDataOut1(i) <= RamDataOut1(i);
  end generate;

  
  --~ DacSetpointWriteAddress <= (to_integer(unsigned(RamAddress) - 1024)/4;  --
                                                                         --keep
                                                                         --this
                                                                         --in
                                                                         --mind
                                                                         --when debugging
  DacSetpointWriteAddress <= (to_integer(unsigned(RamAddress1)) - 4096)/4; -- not offset
                                                          -- by 1024. actually
                                                          -- offset by 0x1000
                                                          -- and then we need
                                                          -- to divide by 4 to
                                                          -- get the mirror
                                                          -- number which is
                                                          -- how the flat ram
                                                          -- is indexed
                                                         
  DacSetpointToWriteToRam <= RamDataIn1(DMSetpointMSB downto 0);
  DacSetpointWriteReq <= '1' when ( (RamBusCE1_i = '1') and (RamBusWrnRd1_i = '1') and (RamAddress1 >= std_logic_vector(to_unsigned(4096, ADDRESS_BUS_BITS))) ) else '0';
  --RamBusAck1_i <= DacSetpointWriteAck;
  --RamBusAck1 <= RamBusAck1_i;
  RamBusAck1 <= '1';

  DmDacRam : DmDacRamFlatPorts
    port map (
      clk => MasterClk,
      rst => MasterReset,
      --~ ReadAddressController => DacSetpointReadAddressController,
      --~ ReadAddressDac => DacSetpointReadAddressDac,
      --~ ReadAddressChannel => DacSetpointReadAddressChannel,
      ReadAddress => DacSetpointReadAddress,
      WriteAddress => DacSetpointWriteAddress,
      DacSetpointIn => DacSetpointToWriteToRam,
      DacSetpointOut => DacSetpointFromRead,
      --WriteAck => DacSetpointWriteAck,
      WriteReq => DacSetpointWriteReq--,
    );
	
	-- n = (z * numy * numx) + (y * numx) + x
  DacSetpointReadAddress <= (DacSetpointReadAddressController * DMMDacsPerControllerBoard * DMActuatorsPerDac) + (DacSetpointReadAddressDac * DMActuatorsPerDac) + DacSetpointReadAddressChannel;

  -- Register space is still on the original rambus
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
    ActualTicksLastSecond => x"00000000",
    PPSCountReset         => open, 
    PPSDetected           => '0'  , 
    ClockTicksThisSecond  => x"00000000"   , 
    ClkDacWrite           => open  , 
    WriteClkDac           => open  , 
    ClkDacReadback        => x"0000"--,
	
	--~ DacSetpoints => DacSetpoints,
	--~ DacChannelReadIndex => DacChannelReadIndex--,
  );

	MosiA <= MosiDacA_i;
	MosiB <= MosiDacB_i;
	MosiC <= MosiDacC_i;
	MosiD <= MosiDacD_i;
	MosiE <= MosiDacE_i;
	MosiF <= MosiDacF_i;
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
	
  --- DM D/As ---
  
  DMDacsA_i : SpiDacPorts
  generic map (
    CLOCK_DIVIDER => 1000, --how much do you want to knock down the global clock to get to the spi clock rate?
    BIT_WIDTH => 24--; --how many bytes per transaction?
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
    DacWriteOut => DacASetpointToWrite,
    DacReadback => ProtoDacReadbacks(0),
    TransferComplete => DacASetpointWritten
  );

  DMDacsB_i : SpiDacPorts
  generic map (
    CLOCK_DIVIDER => 1000, --how much do you want to knock down the global clock to get to the spi clock rate?
    BIT_WIDTH => 24--; --how many bytes per transaction?
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
    DacWriteOut => DacBSetpointToWrite,
    DacReadback => ProtoDacReadbacks(1),
    TransferComplete => DacBSetpointWritten
  );

  DMDacsC_i : SpiDacPorts
  generic map (
    CLOCK_DIVIDER => 1000, --how much do you want to knock down the global clock to get to the spi clock rate?
    BIT_WIDTH => 24--; --how many bytes per transaction?
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
    DacWriteOut => DacCSetpointToWrite,
    DacReadback => ProtoDacReadbacks(2),
    TransferComplete => DacCSetpointWritten
  );
  
  DMDacsD_i : SpiDacPorts
  generic map (
    CLOCK_DIVIDER => 1000, --how much do you want to knock down the global clock to get to the spi clock rate?
    BIT_WIDTH => 24--; --how many bytes per transaction?
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
    DacWriteOut => DacDSetpointToWrite,
    DacReadback => ProtoDacReadbacks(3),
    TransferComplete => DacDSetpointWritten
  );
  
  DMDacsE_i : SpiDacPorts
  generic map (
    CLOCK_DIVIDER => 1000, --how much do you want to knock down the global clock to get to the spi clock rate?
    BIT_WIDTH => 24--; --how many bytes per transaction?
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
    DacWriteOut => DacESetpointToWrite,
    DacReadback => ProtoDacReadbacks(4),
    TransferComplete => DacESetpointWritten
  );
  
  DMDacsF_i : SpiDacPorts
  generic map (
    CLOCK_DIVIDER => 1000, --how much do you want to knock down the global clock to get to the spi clock rate?
    BIT_WIDTH => 24--; --how many bytes per transaction?
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
    DacWriteOut => DacFSetpointToWrite,
    DacReadback => ProtoDacReadbacks(5),
    TransferComplete => DacFSetpointWritten
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
    FIFO_BITS => 10--,
  )
  port map (
    clk => MasterClk,
    uclk => UartClk0,
    rst => Uart0FifoReset_i,
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
    FIFO_BITS => 10--,
  )
  port map (
    clk => MasterClk,
    uclk => UartTxClk0,
    rst => Uart0FifoReset_i,
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
    FIFO_BITS => 10--,
  )
  port map (
    clk => MasterClk,
    uclk => UartClk1,
    rst => Uart1FifoReset_i,
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
    FIFO_BITS => 10--,
  )
  port map (
    clk => MasterClk,
    uclk => UartTxClk1,
    rst => Uart1FifoReset_i,
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
    FIFO_BITS => 10--,
  )
  port map (
    clk => MasterClk,
    uclk => UartClk2,
    rst => Uart2FifoReset_i,
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
    FIFO_BITS => 10--,
  )
  port map (
    clk => MasterClk,
    uclk => UartTxClk2,
    rst => Uart2FifoReset_i,
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
    FIFO_BITS => 10--,
  )
  port map (
    clk => MasterClk,
    uclk => UartClk3,
    rst => Uart3FifoReset_i,
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
    FIFO_BITS => 10--,
  )
  port map (
    clk => MasterClk,
    uclk => UartTxClk3,
    rst => Uart3FifoReset_i,
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


  ----------------------------- Power Supplies ----------------------------------
  --- Is this also part of the FSM?
--  PowerSync <= '1';

  Testpoints(5 downto 3) <= std_logic_vector(to_unsigned(DacSetpointReadAddressController, 3));
  Testpoints(2 downto 0) <= std_logic_vector(to_unsigned(DacSetpointReadAddressDac, 3)); 

  ----------------------------- Clocked Logic / Main Loop ----------------------------------
  process(MasterReset, MasterClk)
  begin

    if (MasterReset = '1') then	
      --This is where we have to actually set all of our registers, since the M2S devices don't support initialization as though they are from the 1980's...
      -- Do we have anything for the Master Reset?
      DacWriteNextState <= Idle;
      DacWriteCurrentState <= Idle;
      -- also initialize these counting variables (won't upset state machine if
      -- not initialized, but good practice
      DacSetpointReadAddressController <= 0; 
      DacSetpointReadAddressDac <= 0;
      --DacSetpointReadAddressChannel <= 0; 
      WriteDacs <= '0';
    else
      if ( (MasterClk'event) and (MasterClk = '1') ) then

		--Change state when requested
		DacWriteCurrentState <= DacWriteNextState;

	  --This case is to make the state testpoint correct
	  case DacWriteNextState is
      when Idle => StateOut <= "00001";
      when ReadChannel => StateOut <= "00010";
      when LatchChannel => StateOut <= "00011";
      when WriteCs0 => StateOut <= "00100";
      when WriteCs1 => StateOut <= "00101";
      when WriteCs2 => StateOut <= "00110";
      when WriteCs3 => StateOut <= "00111";
      when NextChannel => StateOut <= "01000";
      when others => StateOut <= "11111";
      end case;

	  --This case is the transitions between states
      case DacWriteCurrentState is

                  when Idle =>
				  
                    DacWriteNextState <= ReadChannel;
			
                  when ReadChannel =>

					  if (DacSetpointReadAddressDac < (DMMDacsPerControllerBoard - 1)) then 	
						  DacWriteNextState <= LatchChannel;
						else
						  if (DacSetpointReadAddressController < (DMMaxControllerBoards - 1)) then
							DacWriteNextState <= LatchChannel;
						  else 
							DacWriteNextState <= PreWriteCs0;
						  end if;				
						end if;

                  when LatchChannel =>
                     
					 DacWriteNextState <= ReadChannel;
                   
                  when PreWriteCs0 =>
                     
					 DacWriteNextState <= WriteCs0;

				  when WriteCs0 =>
                   
                    if ( (DacASetpointWritten = '1') and (DacBSetpointWritten = '1') and (DacCSetpointWritten = '1') and (DacDSetpointWritten = '1') and (DacESetpointWritten = '1') and (DacFSetpointWritten = '1') ) then
                      DacWriteNextState <= PreWriteCs1;	
                    end if;
					
                  when PreWriteCs1 =>
                     
					 DacWriteNextState <= WriteCs1;

                  when WriteCs1 =>

 				    if ( (DacASetpointWritten = '1') and (DacBSetpointWritten = '1') and (DacCSetpointWritten = '1') and (DacDSetpointWritten = '1') and (DacESetpointWritten = '1') and (DacFSetpointWritten = '1') ) then
                      DacWriteNextState <= PreWriteCs2;
                    end if;
				
				  when PreWriteCs2 =>
                     
					 DacWriteNextState <= WriteCs2;

                  when WriteCs2 =>
                    
                    if ( (DacASetpointWritten = '1') and (DacBSetpointWritten = '1') and (DacCSetpointWritten = '1') and (DacDSetpointWritten = '1') and (DacESetpointWritten = '1') and (DacFSetpointWritten = '1') ) then
                      DacWriteNextState <= PreWriteCs3;
                    end if;

				  when PreWriteCs3 =>
                     
					 DacWriteNextState <= WriteCs3;

                  when WriteCs3 =>
                    if ( (DacASetpointWritten = '1') and (DacBSetpointWritten = '1') and (DacCSetpointWritten = '1') and (DacDSetpointWritten = '1') and (DacESetpointWritten = '1') and (DacFSetpointWritten = '1') ) then
                      DacWriteNextState <= NextChannel;
                    end if;

                  when NextChannel =>
                    DacWriteNextState <= Idle;
                    
                  when others =>  ought never to get here...reset everything!
                    DacWriteNextState <= Idle;
                    DacWriteCurrentState <= Idle;
                    
		end case;

    	case DacWriteCurrentState is

                  when Idle =>
				  
						DacSetpointReadAddressController <= 0; 
						DacSetpointReadAddressDac <= 0; 
						DacSetpointReadAddressChannel <= 0; 
						WriteDacs <= '0';
        	
                  when ReadChannel =>
        
                    Just move the addresses for the ram ahead round-robin each clock
                    if (DacSetpointReadAddressDac < (DMMDacsPerControllerBoard - 1)) then 	
                      DacSetpointReadAddressDac <= DacSetpointReadAddressDac + 1;
                    else
                      if (DacSetpointReadAddressController < (DMMaxControllerBoards - 1)) then
                        DacSetpointReadAddressDac <= 0;
                        DacSetpointReadAddressController <= DacSetpointReadAddressController + 1; 
                      end if;				
                    end if;

                  when LatchChannel =>
                    
					--copy from ram to register (this works on a single clock cause we set the ram up for aysnc read)
                    DacSetpoints(DacSetpointReadAddressController, DacSetpointReadAddressDac) <= DacSetpointFromRead;
                     
                  when PreWriteCs0 =>
                    
				    WriteDacs <= '0';

				  when WriteCs0 =>
                    
                    WriteDacs <= '1';
					
                    DacASetpointToWrite <= DacSetpoints(0,0);
                    DacBSetpointToWrite <= DacSetpoints(1,0);
                    DacCSetpointToWrite <= DacSetpoints(2,0);
                    DacDSetpointToWrite <= DacSetpoints(3,0);
                    DacESetpointToWrite <= DacSetpoints(4,0);
                    DacFSetpointToWrite <= DacSetpoints(5,0);
				
                    nCsDacsA_i(0) <= nCsDacs0_i;
                    nCsDacsA_i(1) <= nCsNotEnabled;
                    nCsDacsA_i(2) <= nCsNotEnabled;
                    nCsDacsA_i(3) <= nCsNotEnabled;
                    nCsDacsB_i(0) <= nCsDacs1_i;
                    nCsDacsB_i(1) <= nCsNotEnabled;
                    nCsDacsB_i(2) <= nCsNotEnabled;
                    nCsDacsB_i(3) <= nCsNotEnabled;
                    nCsDacsC_i(0) <= nCsDacs2_i;
                    nCsDacsC_i(1) <= nCsNotEnabled;
                    nCsDacsC_i(2) <= nCsNotEnabled;
                    nCsDacsC_i(3) <= nCsNotEnabled;
                    nCsDacsD_i(0) <= nCsDacs3_i;
                    nCsDacsD_i(1) <= nCsNotEnabled;
                    nCsDacsD_i(2) <= nCsNotEnabled;
                    nCsDacsD_i(3) <= nCsNotEnabled;
                    nCsDacsE_i(0) <= nCsDacs4_i;
                    nCsDacsE_i(1) <= nCsNotEnabled;
                    nCsDacsE_i(2) <= nCsNotEnabled;
                    nCsDacsE_i(3) <= nCsNotEnabled;
                    nCsDacsF_i(0) <= nCsDacs5_i;
                    nCsDacsF_i(1) <= nCsNotEnabled;
                    nCsDacsF_i(2) <= nCsNotEnabled;
                    nCsDacsF_i(3) <= nCsNotEnabled;
					  
                  when PreWriteCs1 =>
                    
				    WriteDacs <= '0';

				  when WriteCs1 =>

                    WriteDacs <= '1';
					
                    DacASetpointToWrite <= DacSetpoints(0,1);
                    DacBSetpointToWrite <= DacSetpoints(1,1);
                    DacCSetpointToWrite <= DacSetpoints(2,1);
                    DacDSetpointToWrite <= DacSetpoints(3,1);
                    DacESetpointToWrite <= DacSetpoints(4,1);
                    DacFSetpointToWrite <= DacSetpoints(5,1);
				
                    nCsDacsA_i(0) <= nCsNotEnabled;
                    nCsDacsA_i(1) <= nCsDacs0_i;
                    nCsDacsA_i(2) <= nCsNotEnabled;
                    nCsDacsA_i(3) <= nCsNotEnabled;
                    nCsDacsB_i(0) <= nCsNotEnabled;
                    nCsDacsB_i(1) <= nCsDacs1_i;
                    nCsDacsB_i(2) <= nCsNotEnabled;
                    nCsDacsB_i(3) <= nCsNotEnabled;
                    nCsDacsC_i(0) <= nCsNotEnabled;
                    nCsDacsC_i(1) <= nCsDacs2_i;
                    nCsDacsC_i(2) <= nCsNotEnabled;
                    nCsDacsC_i(3) <= nCsNotEnabled;
                    nCsDacsD_i(0) <= nCsNotEnabled;
                    nCsDacsD_i(1) <= nCsDacs3_i;
                    nCsDacsD_i(2) <= nCsNotEnabled;
                    nCsDacsD_i(3) <= nCsNotEnabled;
                    nCsDacsE_i(0) <= nCsNotEnabled;
                    nCsDacsE_i(1) <= nCsDacs4_i;
                    nCsDacsE_i(2) <= nCsNotEnabled;
                    nCsDacsE_i(3) <= nCsNotEnabled;
                    nCsDacsF_i(0) <= nCsNotEnabled;
                    nCsDacsF_i(1) <= nCsDacs5_i;
                    nCsDacsF_i(2) <= nCsNotEnabled;
                    nCsDacsF_i(3) <= nCsNotEnabled;

                  when PreWriteCs2 =>
                    
				    WriteDacs <= '0';

				  when WriteCs2 =>

 				    WriteDacs <= '1';
					
                    DacASetpointToWrite <= DacSetpoints(0,2);
                    DacBSetpointToWrite <= DacSetpoints(1,2);
                    DacCSetpointToWrite <= DacSetpoints(2,2);
                    DacDSetpointToWrite <= DacSetpoints(3,2);
                    DacESetpointToWrite <= DacSetpoints(4,2);
                    DacFSetpointToWrite <= DacSetpoints(5,2);
				
                    nCsDacsA_i(0) <= nCsNotEnabled;
                    nCsDacsA_i(1) <= nCsNotEnabled;
                    nCsDacsA_i(2) <= nCsDacs0_i;
                    nCsDacsA_i(3) <= nCsNotEnabled;
                    nCsDacsB_i(0) <= nCsNotEnabled;
                    nCsDacsB_i(1) <= nCsNotEnabled;
                    nCsDacsB_i(2) <= nCsDacs1_i;
                    nCsDacsB_i(3) <= nCsNotEnabled;
                    nCsDacsC_i(0) <= nCsNotEnabled;
                    nCsDacsC_i(1) <= nCsNotEnabled;
                    nCsDacsC_i(2) <= nCsDacs2_i;
                    nCsDacsC_i(3) <= nCsNotEnabled;
                    nCsDacsD_i(0) <= nCsNotEnabled;
                    nCsDacsD_i(1) <= nCsNotEnabled;
                    nCsDacsD_i(2) <= nCsDacs3_i;
                    nCsDacsD_i(3) <= nCsNotEnabled;
                    nCsDacsE_i(0) <= nCsNotEnabled;
                    nCsDacsE_i(1) <= nCsNotEnabled;
                    nCsDacsE_i(2) <= nCsDacs4_i;
                    nCsDacsE_i(3) <= nCsNotEnabled;
                    nCsDacsF_i(0) <= nCsNotEnabled;
                    nCsDacsF_i(1) <= nCsNotEnabled;
                    nCsDacsF_i(2) <= nCsDacs5_i;
                    nCsDacsF_i(3) <= nCsNotEnabled;
				
				  when PreWriteCs3 =>
                    
				    WriteDacs <= '0';

                  when WriteCs3 =>

				    WriteDacs <= '1';
                    
					DacASetpointToWrite <= DacSetpoints(0,3);
                    DacBSetpointToWrite <= DacSetpoints(1,3);
                    DacCSetpointToWrite <= DacSetpoints(2,3);
                    DacDSetpointToWrite <= DacSetpoints(3,3);
                    DacESetpointToWrite <= DacSetpoints(4,3);
                    DacFSetpointToWrite <= DacSetpoints(5,3);
				
                    nCsDacsA_i(0) <= nCsNotEnabled;
                    nCsDacsA_i(1) <= nCsNotEnabled;
                    nCsDacsA_i(2) <= nCsNotEnabled;
                    nCsDacsA_i(3) <= nCsDacs0_i;
                    nCsDacsB_i(0) <= nCsNotEnabled;
                    nCsDacsB_i(1) <= nCsNotEnabled;
                    nCsDacsB_i(2) <= nCsNotEnabled;
                    nCsDacsB_i(3) <= nCsDacs1_i;
                    nCsDacsC_i(0) <= nCsNotEnabled;
                    nCsDacsC_i(1) <= nCsNotEnabled;
                    nCsDacsC_i(2) <= nCsNotEnabled;
                    nCsDacsC_i(3) <= nCsDacs2_i;
                    nCsDacsD_i(0) <= nCsNotEnabled;
                    nCsDacsD_i(1) <= nCsNotEnabled;
                    nCsDacsD_i(2) <= nCsNotEnabled;
                    nCsDacsD_i(3) <= nCsDacs3_i;
                    nCsDacsE_i(0) <= nCsNotEnabled;
                    nCsDacsE_i(1) <= nCsNotEnabled;
                    nCsDacsE_i(2) <= nCsNotEnabled;
                    nCsDacsE_i(3) <= nCsDacs4_i;
                    nCsDacsF_i(0) <= nCsNotEnabled;
                    nCsDacsF_i(1) <= nCsNotEnabled;
                    nCsDacsF_i(2) <= nCsNotEnabled;
                    nCsDacsF_i(3) <= nCsDacs5_i;
				
                  when NextChannel =>

				    if (DacSetpointReadAddressChannel < (DMActuatorsPerDac - 1)) then 
                      DacSetpointReadAddressChannel <= DacSetpointReadAddressChannel + 1;
                    else
                      DacSetpointReadAddressChannel <= 0;
                    end if;
				
                    WriteDacs <= '0';
					
                  when others => 
				  
		end case;

	
      end if;
	  
    end if;	

  end process;  
	
end DMMain;

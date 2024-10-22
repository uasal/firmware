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
		Address : in std_logic_vector(ADDRESS_BITS - 1 downto 0); -- vhdl can't figure out that ADDRESS_BITS is a constant because it's in a generic map...
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
		
		--Timing
		IdealTicksPerSecond : in std_logic_vector(31 downto 0);
		ActualTicksLastSecond : in std_logic_vector(31 downto 0);
		PPSCountReset : out std_logic;
		ClockTicksThisSecond : in std_logic_vector(31 downto 0)--;				

	);
end RegisterSpacePorts;

architecture RegisterSpace of RegisterSpacePorts is

	-- vhdl can't figure out that ADDRESS_BITS is a constant because it's in a generic map...so we do this whole circle-jerk
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
	
	--Control Signals
	
	signal WriteDacs_i :  std_logic := '0';		
	signal DacASetpoint_i :  std_logic_vector(23 downto 0) := x"000000";		
	signal DacBSetpoint_i :  std_logic_vector(23 downto 0) := x"000000";		
	signal DacCSetpoint_i :  std_logic_vector(23 downto 0) := x"000000";		
	
	signal LastReadReq :  std_logic := '0';		
	signal LastWriteReq :  std_logic := '0';		
	
begin

	--~ Address_i(MAX_ADDRESS_BITS - 1 downto ADDRESS_BITS) <= std_logic_vector(to_unsigned(0, MAX_ADDRESS_BITS - ADDRESS_BITS));
	--~ Address_i(ADDRESS_BITS - 1 downto 0) <= Address;
	--~ Address_i <= std_logic_vector(to_unsigned(0, MAX_ADDRESS_BITS - ADDRESS_BITS)) & Address;
	Address_i <= Address;
	
	DacASetpoint <= DacASetpoint_i;
	DacBSetpoint <= DacBSetpoint_i;
	DacCSetpoint <= DacCSetpoint_i;
	WriteDacs <= WriteDacs_i;
	
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
								


							--Timing
				
							when ActualTicksLastSecondAddr =>

								DataOut <= ActualTicksLastSecond(7 downto 0);
								
							when ActualTicksLastSecondAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

								DataOut <= ActualTicksLastSecond(15 downto 8);
								
							when ActualTicksLastSecondAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

								DataOut <= ActualTicksLastSecond(23 downto 16);
								
							when ActualTicksLastSecondAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

								DataOut <= ActualTicksLastSecond(31 downto 24);

							
								
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
								WriteDacs_i <= '1';
								
								
														
							--Timing

							when ClockSteeringDacSetpointAddr =>

								PPSCountReset <= '1';
								--~ WriteClkDac <= '1';
								--~ ClkDacWrite <= DatatoWrite;

								
								
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

						PPSCountReset <= '0';						
					
					end if;
					
				end if;
				
			end if;

		end if;
		
	end process;

end RegisterSpace;

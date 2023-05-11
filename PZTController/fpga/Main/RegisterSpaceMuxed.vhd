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
		
		SerialNumber : in std_logic_vector(31 downto 0);
		BuildNumber : in std_logic_vector(31 downto 0);
		
		DacASetpoint : out std_logic_vector(23 downto 0);
		DacBSetpoint : out std_logic_vector(23 downto 0);
		DacCSetpoint : out std_logic_vector(23 downto 0);
		WriteDacs : out std_logic; --do we wanna write all three Dac's at once? Seems likely...
		DacAReadback : in std_logic_vector(23 downto 0);
		DacBReadback : in std_logic_vector(23 downto 0);
		DacCReadback : in std_logic_vector(23 downto 0)--;							
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
	
	--Control Signals
	
	signal WriteDacs_i :  std_logic := '0';		
	signal DacASetpoint_i :  std_logic_vector(23 downto 0) := x"000000";		
	signal DacBSetpoint_i :  std_logic_vector(23 downto 0) := x"000000";		
	signal DacCSetpoint_i :  std_logic_vector(23 downto 0) := x"000000";		
	
begin

	--~ Address_i(MAX_ADDRESS_BITS - 1 downto ADDRESS_BITS) <= std_logic_vector(to_unsigned(0, MAX_ADDRESS_BITS - ADDRESS_BITS));
	--~ Address_i(ADDRESS_BITS - 1 downto 0) <= Address;
	--~ Address_i <= std_logic_vector(to_unsigned(0, MAX_ADDRESS_BITS - ADDRESS_BITS)) & Address;
	Address_i <= Address;
	
	DacASetpoint <= DacASetpoint_i;
	DacBSetpoint <= DacBSetpoint_i;
	DacCSetpoint <= DacCSetpoint_i;
	WriteDacs <= WriteDacs_i;
	
	DataOut <= 	SerialNumber(7 downto 0) when (Address = DeviceSerialNumberAddr) else
				SerialNumber(15 downto 8) when (Address = DeviceSerialNumberAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS))) else
				SerialNumber(23 downto 16) when (Address = DeviceSerialNumberAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS))) else
				SerialNumber(31 downto 24) when (Address = DeviceSerialNumberAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS))) else
				BuildNumber(7 downto 0) when (Address = FpgaFirmwareBuildNumberAddr) else
				BuildNumber(15 downto 8) when (Address = FpgaFirmwareBuildNumberAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS))) else
				BuildNumber(23 downto 16) when (Address = FpgaFirmwareBuildNumberAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS))) else
				BuildNumber(31 downto 24) when (Address = FpgaFirmwareBuildNumberAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)));
	
	--~ process (clk, rst)
	--~ begin
	
		--~ if (rst = '1') then
		
			--~ WriteDacs_i <= '0';		
			--~ DacASetpoint_i <= x"000000";		
			--~ DacBSetpoint_i <= x"000000";		
			--~ DacCSetpoint_i <= x"000000";		
		
		--~ else
			
			--~ if ( (clk'event) and (clk = '1') ) then
										
				--~ if (ReadReq = '1') then
					
					--~ case Address_i is
					
						--~ --Serial Number
						
						--~ when DeviceSerialNumberAddr =>

							--~ DataOut <= SerialNumber(7 downto 0);
							--~ ReadAck <= '1';
							
						--~ when DeviceSerialNumberAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= SerialNumber(15 downto 8);
							--~ ReadAck <= '1';
							
						--~ when DeviceSerialNumberAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= SerialNumber(23 downto 16);
							--~ ReadAck <= '1';
							
						--~ when DeviceSerialNumberAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= SerialNumber(31 downto 24);
							--~ ReadAck <= '1';
						

						--~ --Build Number
						
						--~ when FpgaFirmwareBuildNumberAddr =>

							--~ DataOut <= BuildNumber(7 downto 0);
							--~ ReadAck <= '1';

						--~ when FpgaFirmwareBuildNumberAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= BuildNumber(15 downto 8);
							--~ ReadAck <= '1';
							
						--~ when FpgaFirmwareBuildNumberAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= BuildNumber(23 downto 16);
							--~ ReadAck <= '1';
							
						--~ when FpgaFirmwareBuildNumberAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= BuildNumber(31 downto 24);
							--~ ReadAck <= '1';
						
						
						--~ --D/A's
						
						--~ --DacASetpoint
						
						--~ when DacASetpointAddr =>

							--~ DataOut <= DacAReadback(7 downto 0);
							--~ ReadAck <= '1';

						--~ when DacASetpointAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= DacAReadback(15 downto 8);
							--~ ReadAck <= '1';
							
						--~ when DacASetpointAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= DacAReadback(23 downto 16);
							--~ ReadAck <= '1';
							
						--~ when DacASetpointAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

							--~ ReadAck <= '1';
						
						--~ --DacBReadback
						
						--~ when DacBSetpointAddr =>

							--~ DataOut <= DacBReadback(7 downto 0);
							--~ ReadAck <= '1';

						--~ when DacBSetpointAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= DacBReadback(15 downto 8);
							--~ ReadAck <= '1';
							
						--~ when DacBSetpointAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= DacBReadback(23 downto 16);
							--~ ReadAck <= '1';
							
						--~ when DacBSetpointAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

							--~ ReadAck <= '1';
						
						
						--~ --DacCReadback
						
						--~ when DacCSetpointAddr =>

							--~ DataOut <= DacCReadback(7 downto 0);
							--~ ReadAck <= '1';

						--~ when DacCSetpointAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= DacCReadback(15 downto 8);
							--~ ReadAck <= '1';
							
						--~ when DacCSetpointAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= DacCReadback(23 downto 16);
							--~ ReadAck <= '1';
							
						--~ when DacCSetpointAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

							--~ ReadAck <= '1';
						
						
						--~ when PPSCountAddr =>

							--~ DataOut <= PPSCount(7 downto 0);
							--~ ReadAck <= '1';
							
						--~ when PPSCountAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= PPSCount(15 downto 8);
							--~ ReadAck <= '1';
							
						--~ when PPSCountAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= PPSCount(23 downto 16);
							--~ ReadAck <= '1';

						--~ when PPSCountAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= PPSCount(31 downto 24);
							--~ ReadAck <= '1';
							
						--~ when FifoStatusAddr =>

							--~ DataOut(7) <= '0';
							--~ DataOut(6) <= '0';
							--~ DataOut(5) <= '0';
							--~ DataOut(4) <= '0';
							--~ DataOut(3) <= '0';
							--~ DataOut(2) <= '0';
							--~ DataOut(1) <= '0';
							--~ DataOut(0) <= '0';
							--~ ReadAck <= '1';

						--~ when PPSRtcPhaseCmpAddr =>

							--~ DataOut <= PPSRtcPhaseCmp(7 downto 0);
							--~ ReadAck <= '1';
							
						--~ when PPSRtcPhaseCmpAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= PPSRtcPhaseCmp(15 downto 8);
							--~ ReadAck <= '1';
							
						--~ when PPSRtcPhaseCmpAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= PPSRtcPhaseCmp(23 downto 16);
							--~ ReadAck <= '1';
							
						--~ when PPSRtcPhaseCmpAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= PPSRtcPhaseCmp(31 downto 24);
							--~ ReadAck <= '1';
								
						--~ when LTPPSAdcPhaseCmpAddr =>

							--~ DataOut <= LTPPSAdcPhaseCmp(7 downto 0);
							--~ ReadAck <= '1';
							
						--~ when LTPPSAdcPhaseCmpAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= LTPPSAdcPhaseCmp(15 downto 8);
							--~ ReadAck <= '1';
							
						--~ when LTPPSAdcPhaseCmpAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= LTPPSAdcPhaseCmp(23 downto 16);
							--~ ReadAck <= '1';
							
						--~ when LTPPSAdcPhaseCmpAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= LTPPSAdcPhaseCmp(31 downto 24);
							--~ ReadAck <= '1';
													
						--~ when ClockDacAddr =>

							--~ DataOut <= ClkDacReadback(7 downto 0);
							--~ ReadAck <= '1';
						
						--~ when ClockDacAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

							--~ DataOut <= ClkDacReadback(15 downto 8);
							--~ ReadAck <= '1';
						
						--~ when others =>

							--~ DataOut <= x"41";
							--~ ReadAck <= '0';
							
							--~ WriteDacs_i <= '0';
							
					--~ end case;

				--~ else -- No ReadReq (probably doing a write)

					--~ --Reset req req's for fifos if we did a read...
					--~ DataOut <= x"82";
					--~ ReadAck <= '0';
					
					--~ WriteDacs_i <= '0';
									
				--~ end if;

				--~ if (WriteReq = '1') then
				
					--~ case Address_i is
					
						--~ --D/A's
						
						--~ --DacASetpoint
							
						--~ when DacASetpointAddr =>

							--~ DacASetpoint_i(7 downto 0) <= DataIn(7 downto 0);
							--~ WriteAck <= '1';
							
							--~ --The $$$ question: does our processor hit the low addr last or the high one???
							--~ --Also we shold prolly wait until all the D/A registers are loaded, and do it on channel "C" only
							--~ --WriteDacs_i <= '1';
							
						--~ when DacASetpointAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

							--~ DacASetpoint_i(15 downto 8) <= DataIn(7 downto 0);
							--~ WriteAck <= '1';
							
						--~ when DacASetpointAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

							--~ DacASetpoint_i(23 downto 16) <= DataIn(7 downto 0);
							--~ WriteAck <= '1';

						--~ when DacASetpointAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

							--~ WriteAck <= '1';

							--~ --The $$$ question: does our processor hit the low addr last or the high one???
							--~ --Also we shold prolly wait until all the D/A registers are loaded, and do it on channel "C" only
							--~ --WriteDacs_i <= '1';

						--~ --DacBSetpoint
							
						--~ when DacBSetpointAddr =>

							--~ DacBSetpoint_i(7 downto 0) <= DataIn(7 downto 0);
							--~ WriteAck <= '1';
							
							--~ --The $$$ question: does our processor hit the low addr last or the high one???
							--~ --Also we shold prolly wait until all the D/A registers are loaded, and do it on channel "C" only
							--~ --WriteDacs_i <= '1';
							
						--~ when DacBSetpointAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

							--~ DacBSetpoint_i(15 downto 8) <= DataIn(7 downto 0);
							--~ WriteAck <= '1';
							
						--~ when DacBSetpointAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

							--~ DacBSetpoint_i(23 downto 16) <= DataIn(7 downto 0);
							--~ WriteAck <= '1';

						--~ when DacBSetpointAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

							--~ WriteAck <= '1';

							--~ --The $$$ question: does our processor hit the low addr last or the high one???
							--~ --Also we shold prolly wait until all the D/A registers are loaded, and do it on channel "C" only
							--~ --WriteDacs_i <= '1';

						--~ --DacCSetpoint
							
						--~ when DacCSetpointAddr =>

							--~ DacCSetpoint_i(7 downto 0) <= DataIn(7 downto 0);
							--~ WriteAck <= '1';
							
							--~ --The $$$ question: does our processor hit the low addr last or the high one???
							--~ --WriteDacs_i <= '1';
							
						--~ when DacCSetpointAddr + std_logic_vector(to_unsigned(1, MAX_ADDRESS_BITS)) =>

							--~ DacCSetpoint_i(15 downto 8) <= DataIn(7 downto 0);
							--~ WriteAck <= '1';
							
						--~ when DacCSetpointAddr + std_logic_vector(to_unsigned(2, MAX_ADDRESS_BITS)) =>

							--~ DacCSetpoint_i(23 downto 16) <= DataIn(7 downto 0);
							--~ WriteAck <= '1';

						--~ when DacCSetpointAddr + std_logic_vector(to_unsigned(3, MAX_ADDRESS_BITS)) =>

							--~ WriteAck <= '1';

							--~ --The $$$ question: does our processor hit the low addr last or the high one???
							--~ WriteDacs_i <= '1';

							
							
						--~ when others => 

							--~ WriteAck <= '0';
							
							--~ WriteDacs_i <= '0';

					--~ end case;

				--~ else -- No WriteReqLo (probably doing a read)
				
					--~ WriteAck <= '0';
					
					--~ WriteDacs_i <= '0';
											
				--~ end if;
				
			--~ end if;

		--~ end if;
		
	--~ end process;

end RegisterSpace;

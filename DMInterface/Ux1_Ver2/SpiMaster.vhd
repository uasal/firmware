--------------------------------------------------------------------------------
-- SpiMaster
--
-- Looks to be a canonical Spi master implementation
--
-- c2010 Franks Development, LLC
-- author: steve
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity SpiMasterPorts is
	generic 
	(
		CLOCK_DIVIDER : natural := 1000; --how much do you want to knock down the global clock to get to the spi clock rate?
		BYTE_WIDTH : natural := 1; --how many bytes per transaction?
		CPOL : std_logic := '0'; --'standard' spi knob - inverts clock polarity (0 seems to be the standard, 1 less common)
		CPHA : std_logic := '0'--; --'standard' spi knob - inverts clock phase (0 seems to be the standard, 1 less common)
	);
    port
	(
		--Globals
		clk : in std_logic;
		rst : in std_logic; --we do a single spi message for every reset cycle, reset must toggle for more than a single transfer.
		
		--Spi pins
		Mosi : out std_logic;
		Sck : out std_logic;
		Miso : in std_logic;
		
		--Registers
		DataToMosi : in std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataFromMiso : out std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		XferComplete : out std_logic--;
	);
end SpiMasterPorts;

architecture SpiMaster of SpiMasterPorts is

	signal SpiBitPos : natural range 0 to (BYTE_WIDTH * 8); --Which clock cycle are we on anyway?
	
	signal ClkDiv : natural range 0 to ((CLOCK_DIVIDER / 2) - 1); --Hold the clock divider chain
	
	signal Sck_i : std_logic;
	signal Mosi_i : std_logic;
	
	signal DataToMosi_i : std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0); --register input data
	signal DataToMosiLatched : std_logic;
	
	signal XferComplete_i : std_logic;

begin

	--~ Sck <= Sck_i xor CPOL; --Allow for Sck to be inverted
	Sck <= Sck_i; --Allow for Sck to be inverted
	Mosi <= Mosi_i;
	XferComplete <= XferComplete_i;
	
	process (clk, rst, Miso, DataToMosi)
	begin
	
		-- Chip select is reset, and starts transfer when it clocks to '0'.
		if (rst = '1') then

			Sck_i <= not(CPOL);
			Mosi_i <= DataToMosi((BYTE_WIDTH * 8) - 1); --get the first bit out there asap
			DataToMosi_i <= std_logic_vector(to_unsigned(0, BYTE_WIDTH * 8));
			DataToMosiLatched <= '0';
			DataFromMiso((BYTE_WIDTH * 8) - 1) <= Miso; --grab the first bit asap
			DataFromMiso((BYTE_WIDTH * 8) - 2 downto 0) <= std_logic_vector(to_unsigned(0, (BYTE_WIDTH * 8) - 1));
			XferComplete_i <= '0';
			SpiBitPos <= (BYTE_WIDTH * 8);	--MSB first transfers; for LSB first, load "000" instead.
			ClkDiv <= 0;
			
		else

			if ( ( clk'event) and (clk = '1') ) then
			
				--Run latch
				if (DataToMosiLatched = '0') then
			
					DataToMosi_i <= DataToMosi;
					DataToMosiLatched <= '1';
					
				end if;
			
				--Run clock divider
				if (ClkDiv < ((CLOCK_DIVIDER / 2) - 1)) then --Since we flop sck back & forth, run divider twice as fast...
					
					ClkDiv <= ClkDiv + 1;
					if (SpiBitPos = (BYTE_WIDTH * 8)) then Mosi_i <= DataToMosi((BYTE_WIDTH * 8) - 1); end if; --still time to update the MSB for Mosi. GZHOU

				
				--Run bus
				else
				
					ClkDiv <= 0;
					
					--Done?
					if (XferComplete_i = '0') then
					
						
						if (Sck_i = ((not(CPOL)) xor CPHA)) then --transition mosi when SCK != CPOL
						
							if (SpiBitPos > 0) then 
						
								Mosi_i <= DataToMosi_i(SpiBitPos - 1);
							
							end if;
							
							--Here is the transition to the final state where we idle until the next reset sequence						
							if (SpiBitPos = 0) then 
						
								XferComplete_i <= '1';
								
							end if;
							
						else --read miso when SCK = CPOL
						
							DataFromMiso(SpiBitPos - 1) <= Miso;
						
							--Move to next bit
							if (SpiBitPos > 0) then 
							
								SpiBitPos <= SpiBitPos - 1;
								
							end if;
							
						end if; --Sck_i = not(CPOL)
						
						if (SpiBitPos /= 0) then
						
							--Toggle spi bus clock output on every divider rollover
							Sck_i <= not(Sck_i);
							
						end if;							
						
					end if; --XferComplete_i = '0'

				end if; --ClkDiv
			
			end if; --clk

		end if; --rst

	end process; --(Sck, rst)

end SpiMaster;

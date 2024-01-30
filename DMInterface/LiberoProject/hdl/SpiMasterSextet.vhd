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

entity SpiMasterSextetPorts is
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
		MosiA : out std_logic;
		MosiB : out std_logic;
		MosiC : out std_logic;
                MosiD : out  std_logic;
		MosiE : out  std_logic;
		MosiF : out  std_logic;
		Sck : out std_logic;
		MisoA : in std_logic;
		MisoB : in std_logic;
		MisoC : in std_logic;
                MisoD : in  std_logic;
		MisoE : in  std_logic;
		MisoF : in  std_logic;
--                nCsA : out std_logic_vector(3 downto 0);
--                nCsB : out std_logic_vector(3 downto 0);
--                nCsC : out std_logic_vector(3 downto 0);
--                nCsD : out std_logic_vector(3 downto 0);
--                nCsE : out std_logic_vector(3 downto 0);
--                nCsF : out std_logic_vector(3 downto 0);
                nCsA : out std_logic;
                nCsB : out std_logic;
                nCsC : out std_logic;
                nCsD : out std_logic;
                nCsE : out std_logic;
                nCsF : out std_logic;
		
		--Registers
		DataToMosiA : in std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataToMosiB : in std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataToMosiC : in std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
                DataToMosiD : in std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataToMosiE : in std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataToMosiF : in std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataFromMisoA : out std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataFromMisoB : out std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataFromMisoC : out std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataFromMisoD : out std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataFromMisoE : out std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		DataFromMisoF : out std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0);
		XferComplete : out std_logic--;
	);
end SpiMasterSextetPorts;

architecture SpiMasterSextet of SpiMasterSextetPorts is

	signal SpiBitPos : natural range 0 to (BYTE_WIDTH * 8); --Which clock cycle are we on anyway?
	
	signal ClkDiv : natural range 0 to ((CLOCK_DIVIDER / 2) - 1); --Hold the clock divider chain
	
	signal Sck_i : std_logic;
	signal MosiA_i : std_logic;
	signal MosiB_i : std_logic;
	signal MosiC_i : std_logic;
        signal MosiD_i : std_logic;
	signal MosiE_i : std_logic;
	signal MosiF_i : std_logic;
	
	signal DataToMosiA_i : std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0); --register input data
	signal DataToMosiB_i : std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0); --register input data
	signal DataToMosiC_i : std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0); --register input data
        signal DataToMosiD_i : std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0); --register input data
	signal DataToMosiE_i : std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0); --register input data
	signal DataToMosiF_i : std_logic_vector((BYTE_WIDTH * 8) - 1 downto 0); --register input data
	signal DataToMosiLatched : std_logic;
	
	signal XferComplete_i : std_logic;

begin

	--~ Sck <= Sck_i xor CPOL; --Allow for Sck to be inverted
	Sck <= Sck_i; --Allow for Sck to be inverted
	MosiA <= MosiA_i;
	MosiB <= MosiB_i;
	MosiC <= MosiC_i;
        MosiD <= MosiD_i;
	MosiE <= MosiE_i;
	MosiF <= MosiF_i;
	XferComplete <= XferComplete_i;
	
	process (clk, rst, MisoA, MisoB, MisoC, MisoD, MisoE, MisoF, DataToMosiA, DataToMosiB, DataToMosiC, DataToMosiD, DataToMosiE, DataToMosiF)
	begin
	
		-- Chip select is reset, and starts transfer when it clocks to '0'.
		if (rst = '1') then

			Sck_i <= not(CPOL);
			MosiA_i <= DataToMosiA((BYTE_WIDTH * 8) - 1); --get the first bit out there asap
			MosiB_i <= DataToMosiB((BYTE_WIDTH * 8) - 1); --get the first bit out there asap
			MosiC_i <= DataToMosiC((BYTE_WIDTH * 8) - 1); --get the first bit out there asap
                        MosiD_i <= DataToMosiD((BYTE_WIDTH * 8) - 1); --get the first bit out there asap
			MosiE_i <= DataToMosiE((BYTE_WIDTH * 8) - 1); --get the first bit out there asap
			MosiF_i <= DataToMosiF((BYTE_WIDTH * 8) - 1); --get the first bit out there asap
			DataToMosiA_i <= std_logic_vector(to_unsigned(0, BYTE_WIDTH * 8));
			DataToMosiB_i <= std_logic_vector(to_unsigned(0, BYTE_WIDTH * 8));
			DataToMosiC_i <= std_logic_vector(to_unsigned(0, BYTE_WIDTH * 8));
                        DataToMosiD_i <= std_logic_vector(to_unsigned(0, BYTE_WIDTH * 8));
			DataToMosiE_i <= std_logic_vector(to_unsigned(0, BYTE_WIDTH * 8));
			DataToMosiF_i <= std_logic_vector(to_unsigned(0, BYTE_WIDTH * 8));
			DataToMosiLatched <= '0';
			DataFromMisoA((BYTE_WIDTH * 8) - 1) <= MisoA; --grab the first bit asap
			DataFromMisoA((BYTE_WIDTH * 8) - 2 downto 0) <= std_logic_vector(to_unsigned(0, (BYTE_WIDTH * 8) - 1));
			DataFromMisoB((BYTE_WIDTH * 8) - 1) <= MisoB; --grab the first bit asap
			DataFromMisoB((BYTE_WIDTH * 8) - 2 downto 0) <= std_logic_vector(to_unsigned(0, (BYTE_WIDTH * 8) - 1));
			DataFromMisoC((BYTE_WIDTH * 8) - 1) <= MisoC; --grab the first bit asap
			DataFromMisoC((BYTE_WIDTH * 8) - 2 downto 0) <= std_logic_vector(to_unsigned(0, (BYTE_WIDTH * 8) - 1));
                        DataFromMisoD((BYTE_WIDTH * 8) - 1) <= MisoD; --grab the first bit asap
			DataFromMisoD((BYTE_WIDTH * 8) - 2 downto 0) <= std_logic_vector(to_unsigned(0, (BYTE_WIDTH * 8) - 1));
			DataFromMisoE((BYTE_WIDTH * 8) - 1) <= MisoE; --grab the first bit asap
			DataFromMisoE((BYTE_WIDTH * 8) - 2 downto 0) <= std_logic_vector(to_unsigned(0, (BYTE_WIDTH * 8) - 1));
			DataFromMisoF((BYTE_WIDTH * 8) - 1) <= MisoF; --grab the first bit asap
			DataFromMisoF((BYTE_WIDTH * 8) - 2 downto 0) <= std_logic_vector(to_unsigned(0, (BYTE_WIDTH * 8) - 1));
			XferComplete_i <= '0';
			SpiBitPos <= (BYTE_WIDTH * 8);	--MSB first transfers; for LSB first, load "000" instead.
			ClkDiv <= 0;
			
		else

			if ( ( clk'event) and (clk = '1') ) then
			
				--Run latch
				if (DataToMosiLatched = '0') then
			
					DataToMosiA_i <= DataToMosiA;
					DataToMosiB_i <= DataToMosiB;
					DataToMosiC_i <= DataToMosiC;
                                        DataToMosiD_i <= DataToMosiD;
					DataToMosiE_i <= DataToMosiE;
					DataToMosiF_i <= DataToMosiF;
					
					DataToMosiLatched <= '1';
					
				end if;
			
				--Run clock divider
				if (ClkDiv < ((CLOCK_DIVIDER / 2) - 1)) then --Since we flop sck back & forth, run divider twice as fast...
					
					ClkDiv <= ClkDiv + 1;
					if (SpiBitPos = (BYTE_WIDTH * 8)) then 
					
						MosiA_i <= DataToMosiA((BYTE_WIDTH * 8) - 1); 
						MosiB_i <= DataToMosiB((BYTE_WIDTH * 8) - 1); 
						MosiC_i <= DataToMosiC((BYTE_WIDTH * 8) - 1);
                                                MosiD_i <= DataToMosiD((BYTE_WIDTH * 8) - 1); 
						MosiE_i <= DataToMosiE((BYTE_WIDTH * 8) - 1); 
						MosiF_i <= DataToMosiF((BYTE_WIDTH * 8) - 1); 
						
					end if; --still time to update the MSB for Mosi. GZHOU

				
				--Run bus
				else
				
					ClkDiv <= 0;
					
					--Done?
					if (XferComplete_i = '0') then
					
						
						if (Sck_i = ((not(CPOL)) xor CPHA)) then --transition mosi when SCK != CPOL
						
							if (SpiBitPos > 0) then 
						
								MosiA_i <= DataToMosiA_i(SpiBitPos - 1);
								MosiB_i <= DataToMosiB_i(SpiBitPos - 1);
								MosiC_i <= DataToMosiC_i(SpiBitPos - 1);
                                                                MosiD_i <= DataToMosiD_i(SpiBitPos - 1);
								MosiE_i <= DataToMosiE_i(SpiBitPos - 1);
								MosiF_i <= DataToMosiF_i(SpiBitPos - 1);
							
							end if;
							
							--Here is the transition to the final state where we idle until the next reset sequence						
							if (SpiBitPos = 0) then 
						
								XferComplete_i <= '1';
								
							end if;
							
						else --read miso when SCK = CPOL
						
							DataFromMisoA(SpiBitPos - 1) <= MisoA;
							DataFromMisoB(SpiBitPos - 1) <= MisoB;
							DataFromMisoC(SpiBitPos - 1) <= MisoC;
                                                        DataFromMisoD(SpiBitPos - 1) <= MisoD;
							DataFromMisoE(SpiBitPos - 1) <= MisoE;
							DataFromMisoF(SpiBitPos - 1) <= MisoF;
						
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

end SpiMasterSextet;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

--For now, we're going to assume a D/A which is fine with a 1MHz clock.
--It's also 16-bit.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity SpiDacSextetPorts is
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
		nCsE : out std_logic;
		nCsF : out std_logic;
		Sck : out std_logic;
		MosiA : out  std_logic;
		MosiB : out  std_logic;
		MosiC : out  std_logic;
                MosiD : out  std_logic;
		MosiE : out  std_logic;
		MosiF : out  std_logic;
		MisoA : in  std_logic;
		MisoB : in  std_logic;
		MisoC : in  std_logic;
                MisoD : in  std_logic;
		MisoE : in  std_logic;
		MisoF : in  std_logic;
		
		--Control signals
		WriteDac : in std_logic;
		DacWriteOutA : in std_logic_vector(8 downto 0);
		DacWriteOutB : in std_logic_vector(8 downto 0);
		DacWriteOutC : in std_logic_vector(8 downto 0);
                DacWriteOutD : in std_logic_vector(8 downto 0);
		DacWriteOutE : in std_logic_vector(8 downto 0);
		DacWriteOutF : in std_logic_vector(8 downto 0);
		DacReadbackA : out std_logic_vector(8 downto 0);
		DacReadbackB : out std_logic_vector(8 downto 0);
		DacReadbackC : out std_logic_vector(8 downto 0);
                DacReadbackD : out std_logic_vector(8 downto 0);
		DacReadbackE : out std_logic_vector(8 downto 0);
		DacReadbackF : out std_logic_vector(8 downto 0);
		TransferComplete : out std_logic--;
		
	); end SpiDacSextetPorts;

architecture SpiDacSextet of SpiDacSextetPorts is

	component IBufP2Ports is
	port (
		clk : in std_logic;
		I : in std_logic;
		O : out std_logic--;
	);
	end component;
		
	component SpiMasterSextetPorts is
	generic (
		CLOCK_DIVIDER : integer := 4;
		BYTE_WIDTH : natural := 1;
		CPOL : std_logic := '0'--;	
	);
	port
	(
		clk : in std_logic;
		rst : in std_logic;
		MosiA : out std_logic;
		MosiB : out std_logic;
		MosiC : out std_logic;
                MosiD : out std_logic;
		MosiE : out std_logic;
		MosiF : out std_logic;
		Sck : out std_logic;
		MisoA : in std_logic;
		MisoB : in std_logic;
		MisoC : in std_logic;
                MisoD : in std_logic;
		MisoE : in std_logic;
		MisoF : in std_logic;
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
	end component;
		
	signal SpiRst : std_logic; --kicks off / inhibits transfer of a sample out of the A/D
	signal SpiXferComplete : std_logic;
	signal LastSpiXferComplete : std_logic;
		
	--~ signal DacClk : std_logic;
	signal LastWriteDac : std_logic;
	signal DacWriteOutA_i : std_logic_vector(8 downto 0);
	signal DacWriteOutB_i : std_logic_vector(8 downto 0);
	signal DacWriteOutC_i : std_logic_vector(8 downto 0);
        signal DacWriteOutD_i : std_logic_vector(8 downto 0);
	signal DacWriteOutE_i : std_logic_vector(8 downto 0);
	signal DacWriteOutF_i : std_logic_vector(8 downto 0);
	signal DacReadbackA_i : std_logic_vector(8 downto 0);
	signal DacReadbackB_i : std_logic_vector(8 downto 0);
	signal DacReadbackC_i : std_logic_vector(8 downto 0);
        signal DacReadbackD_i : std_logic_vector(8 downto 0);
	signal DacReadbackE_i : std_logic_vector(8 downto 0);
	signal DacReadbackF_i : std_logic_vector(8 downto 0);
	
begin

	Spi : SpiMasterSextetPorts
	generic map (
		--~ CLOCK_DIVIDER => MASTER_CLOCK_FREQHZ / 4,
		--~ CLOCK_DIVIDER => 100, --1MHz
		CLOCK_DIVIDER => 10, --10MHz (50MHz max MAX5719)
		--~ CLOCK_DIVIDER => 4, --25MHz
		--~ CLOCK_DIVIDER => 3, --33MHz
		--~ CLOCK_DIVIDER => 2, --50MHz
		BYTE_WIDTH => 1,  -- keep it at one for testig purposes
		CPOL => '0'--, --'inverted' SCK polarity?
	)
	port map
	(
		clk => clk, --runs off the same clock as the A/D to keep everything nicely aligned & quiet
		rst => SpiRst, --every sample requires a set/rst sequence to run spimaster
		MosiA => MosiA,
		MosiB => MosiB,
		MosiC => MosiC,
                MosiD => MosiD,
		MosiE => MosiE,
		MosiF => MosiF,
		Sck => Sck,
		MisoA => MisoA,
		MisoB => MisoB,
		MisoC => MisoC,
                MisoD => MisoD,
		MisoE => MisoE,
		MisoF => MisoF,
		DataToMosiA => DacWriteOutA_i,
		DataToMosiB => DacWriteOutB_i,
		DataToMosiC => DacWriteOutC_i,
                DataToMosiD => DacWriteOutD_i,
		DataToMosiE => DacWriteOutE_i,
		DataToMosiF => DacWriteOutF_i,
		DataFromMisoA => DacReadbackA_i,
		DataFromMisoB => DacReadbackB_i,
		DataFromMisoC => DacReadbackC_i,
                DataFromMisoD => DacReadbackD_i,
		DataFromMisoE => DacReadbackE_i,
		DataFromMisoF => DacReadbackF_i,
		XferComplete => SpiXferComplete--,
	);
	
	nCsA <= SpiRst; --these concepts are synchronous in this design
	nCsB <= SpiRst; --these concepts are synchronous in this design
	nCsC <= SpiRst; --these concepts are synchronous in this design
        nCsD <= SpiRst; --these concepts are synchronous in this design
	nCsE <= SpiRst; --these concepts are synchronous in this design
	nCsF <= SpiRst; --these concepts are synchronous in this design
	
	TransferComplete <= SpiRst; --these concepts are synchronous in this design
		
	--Read A/D:
	process (clk, rst, WriteDac, SpiXferComplete)
	begin
	
		if (rst = '1') then 
		
			SpiRst <= '1';			
			LastWriteDac <= '0';
			LastSpiXferComplete <= '0';
			DacWriteOutA_i <= x"0000";
			DacWriteOutB_i <= x"0000";
			DacWriteOutC_i <= x"0000";
                        DacWriteOutD_i <= x"0000";
			DacWriteOutE_i <= x"0000";
			DacWriteOutF_i <= x"0000";
			
		else
			
			if ( (clk'event) and (clk = '1') ) then
			
				--Follow Drdy
				if (WriteDac /= LastWriteDac) then
				
					LastWriteDac <= WriteDac;
					
					--Here we go...
					if (WriteDac = '1') then
					
						--Latch inputs & initiate reading the data.
						DacWriteOutA_i <= DacWriteOutA;
						DacWriteOutB_i <= DacWriteOutB;
						DacWriteOutC_i <= DacWriteOutC;
                                                DacWriteOutD_i <= DacWriteOutD;
						DacWriteOutE_i <= DacWriteOutE;
						DacWriteOutF_i <= DacWriteOutF;
						SpiRst <= '0';
											
					end if;
					
				else

					--Wait for Spi xfer to complete, then grab the sample and we're done
					if (SpiXferComplete /= LastSpiXferComplete) then
					
						LastSpiXferComplete <= SpiXferComplete;

						if (SpiXferComplete = '1') then
						
							--Grab read back
							DacReadbackA <= DacReadbackA_i;
							DacReadbackB <= DacReadbackB_i;
							DacReadbackC <= DacReadbackC_i;
                                                        DacReadbackD <= DacReadbackD_i;
							DacReadbackE <= DacReadbackE_i;
							DacReadbackF <= DacReadbackF_i;
												
							--turn off spi master bus
							SpiRst <= '1';
							
						end if;
						
					end if;		
					
				end if;
				
			end if;		
			
		end if;	
		
	end process;
	
end SpiDacSextet;

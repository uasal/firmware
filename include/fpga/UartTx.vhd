library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity UartTx is
	port (
		Clk    : in  Std_Logic;
		Reset  : in  Std_Logic;
		Go     : in  Std_Logic; --To initate a xfer, raise this bit and wait for busy to go high, then lower.
		TxD    : out Std_Logic;
		Busy   : out Std_Logic;
		Data  : in  Std_Logic_Vector(7 downto 0)--; --not latched; must be held constant while busy is high
	);
end entity;

architecture Behaviour of UartTx is

  signal BitCnt : unsigned(3 downto 0);         -- bit counter
  signal LastGo : std_logic := '0';

begin
	process(Clk, Reset, Go)
		constant CntOne : Unsigned(3 downto 0):="0001";
	begin
		if (Reset = '1') then
			TxD <= '1';
			BitCnt <= "0000";
        else
			if (Rising_Edge(Clk)) then
			
				if (Go /= LastGo) then
					LastGo <= Go;
					if (Go = '1') then BitCnt <= "1111"; end if;
				end if;
				
				case BitCnt is
					when "1111" => --start bit
						TxD <= '0';
						BitCnt <= "0000";
						Busy <= '1';
					when "0000" | "0001" | "0010" | "0011" |
						"0100" | "0101" | "0110" |
						"0111" => --data bits, lsb first
						TxD <= Data(to_integer(BitCnt(2 downto 0)));
						BitCnt <= BitCnt + CntOne;
					when "1000" => --stop bit
						TxD <= '1';
						BitCnt <= BitCnt + CntOne;
					when others => --idle (i.e. "1001")
						TxD <= '1';
						Busy <= '0';
              end case;
           end if;
        end if;
    end process;

end Behaviour;
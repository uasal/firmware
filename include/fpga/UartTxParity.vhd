--
--           Copyright (c) by Franks Development, LLC
--
-- This software is copyrighted by and is the sole property of Franks
-- Development, LLC. All rights, title, ownership, or other interests
-- in the software remain the property of Franks Development, LLC. This
-- software may only be used in accordance with the corresponding
-- license agreement.  Any unauthorized use, duplication, transmission,
-- distribution, or disclosure of this software is expressly forbidden.
--
-- This Copyright notice may not be removed or modified without prior
-- written consent of Franks Development, LLC.
--
-- Franks Development, LLC. reserves the right to modify this software
-- without notice.
--
-- Franks Development, LLC            support@franks-development.com
-- 500 N. Bahamas Dr. #101           http:--www.franks-development.com
-- Tucson, AZ 85710
-- USA
--
-- Permission granted for perpetual non-exclusive end-use by the University of Arizona August 1, 2020
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity UartTxParity is
	generic 
	(
		PARITY_EVEN : std_logic := '1'--; --1=odd, 0=even
	);
	port (
		Clk    : in  Std_Logic;
		Reset  : in  Std_Logic;
		Go     : in  Std_Logic; --To initate a xfer, raise this bit and wait for busy to go high, then lower.
		TxD    : out Std_Logic;
		Busy   : out Std_Logic;
		Data  : in  Std_Logic_Vector(7 downto 0)--; --not latched; must be held constant while busy is high
	);
end entity;

architecture Behaviour of UartTxParity is

  signal BitCnt : unsigned(3 downto 0);         -- bit counter
  signal LastGo : std_logic := '0';
  signal ParityBit : std_logic := '0';

begin

	process(Clk, Reset, Go)
		constant CntOne : Unsigned(3 downto 0):="0001";
	begin
		if (Reset = '1') then
			TxD <= '1';
			BitCnt <= "1110";
			Busy <= '0';
			ParityBit <= '0';
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
						ParityBit <= '0';
					when "0000" | "0001" | "0010" | "0011" |
						"0100" | "0101" | "0110" |
						"0111" => --data bits, lsb first
						TxD <= Data(to_integer(BitCnt(2 downto 0)));
						ParityBit <= ParityBit xor Data(to_integer(BitCnt(2 downto 0)));
						BitCnt <= BitCnt + CntOne;
					when "1000" => --parity bit
						if (PARITY_EVEN = '1') then
							TxD <= ParityBit;
						else 
							TxD <= not(ParityBit);
						end if;
						BitCnt <= BitCnt + CntOne;
					when "1001" => --stop bit
						TxD <= '1';
						BitCnt <= BitCnt + CntOne;
					when others => --idle (i.e. "1010+")
						TxD <= '1';
						Busy <= '0';
              end case;
           end if;
        end if;
    end process;

end Behaviour;
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

entity UartTx is
	port (
		Clk    : in  Std_Logic;
		Reset  : in  Std_Logic;
		Go     : in  Std_Logic; --To initate a xfer, raise this bit and wait for Busy_i to go high, then lower.
		TxD    : out Std_Logic;
		Busy   : out Std_Logic;
		BitCountOut : out std_logic_vector(3 downto 0);
		Data  : in  Std_Logic_Vector(7 downto 0)--; --not latched; must be held constant while Busy_i is high
	);
end entity;

architecture Behaviour of UartTx is

  --~ signal BitCnt : std_logic_vector(3 downto 0);         -- bit counter
  signal BitCnt : natural range 0 to 15; --Which clock cycle are we on anyway?
  signal LastGo : std_logic := '0';
  signal Busy_i : std_logic := '0';
  --~ constant CntOne : std_logic_vector(3 downto 0):="0001";
  
begin

	Busy <= Busy_i;
	BitCountOut <= std_logic_vector(to_unsigned(BitCnt, 4));
	
	process(Clk, Reset, Go)
	
	begin
	
		if (Reset = '1') then
	
			TxD <= '1';
			--~ BitCnt <= "1001";
			BitCnt <= 9;
			LastGo <= '0';
			Busy_i <= '0';
        
		else
		
			if (Rising_Edge(Clk)) then
			
				if (Busy_i = '0') and (Go /= LastGo) then
			
					LastGo <= Go;
					--~ if (Go = '1') then BitCnt <= "1111"; end if;
					if (Go = '1') then BitCnt <= 15; end if;
					
				end if;
				
				case BitCnt is
				
					--~ when "1111" => --start bit
					when 15 => --start bit
						
						TxD <= '0';
						--~ BitCnt <= "0000";
						BitCnt <= 0;
						Busy_i <= '1';
				
					--~ when "0000" | "0001" | "0010" | "0011" |
						--~ "0100" | "0101" | "0110" |
						--~ "0111" => --data bits, lsb first
					when 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 =>
						
						--~ TxD <= Data(to_integer(BitCnt(2 downto 0)));
						--~ BitCnt <= BitCnt + CntOne;
						TxD <= Data(BitCnt mod 8);
						BitCnt <= BitCnt + 1;
						Busy_i <= '1';
					
					--~ when "1000" => --stop bit
					when 8 => --stop bit
						
						TxD <= '1';
						--~ BitCnt <= BitCnt + CntOne;
						BitCnt <= BitCnt + 1;
						Busy_i <= '1';
					
					when others => --idle (i.e. "1001")
						
						TxD <= '1';
						Busy_i <= '0';
						
              end case;
			  
           end if;
		   
        end if;
		
    end process;

end Behaviour;
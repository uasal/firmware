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
   
entity UartRxParity is
  port (
     Clk    : in  std_logic;  -- system clock signal
     Reset  : in  std_logic;  -- Reset input
     Enable : in  std_logic;  -- Enable input
     RxD    : in  std_logic;  -- RS-232 data input
     RxAv   : out std_logic;  -- Byte available
     DataO  : out std_logic_vector(7 downto 0)--; -- Byte received
	 --~ Samp   : out std_logic;
	 --~ Start   : out std_logic
	 );
end UartRxParity;

architecture Behaviour of UartRxParity is
  
  signal RReg    : std_logic_vector(7 downto 0); -- receive register  
  
begin
  
  -- Rx Process
  RxProc : process(Clk,Reset,Enable,RxD,RReg)

	variable BitPos : INTEGER range 0 to 11;   -- Position of the bit in the frame
	variable SampleCnt : INTEGER range 0 to 15; -- Count from 0 to 3 in each bit 
	  
begin
     if Reset = '1' then -- Reset
        BitPos := 0;
		SampleCnt := 0;
		RxAv <= '0';
		RReg <= x"00";
		DataO <= x"00";
     elsif Rising_Edge(Clk) then
        if Enable = '1' then
           case BitPos is
              when 0 => -- idle
				 if RxD = '0' then -- Start Bit
                    SampleCnt := 0;
                    BitPos := 1;
					--~ Start <= '1';
                 end if;
			  when 10 => -- Parity
				 --~ Samp <= '0';
				 DataO <= RReg;  -- Store received byte
				 if SampleCnt = 15 then -- Increment BitPos on 3
                    BitPos := BitPos + 1;
                 end if;
              when 11 => -- Stop Bit
                 BitPos := 0;    -- next is idle
                 RxAv <= '1';
                 --~ DataO <= RReg;  -- Store received byte
              when others =>
				RxAv <= '0';
				--~ Start <= '0';
				--~ if (SampleCnt = 1 and BitPos >= 2) then -- Sample RxD on 2/4
                 if (SampleCnt = 3 and BitPos >= 2) then -- Sample RxD on 4/16
                    RReg(BitPos-2) <= RxD; -- Deserialisation
					--~ Samp <= '1';
				else 
					--~ Samp <= '0';
                 end if;
                 if SampleCnt = 15 then -- Increment BitPos on 3
                    BitPos := BitPos + 1;
                 end if;
           end case;
           if SampleCnt = 15 then
		   --~ if SampleCnt = 3 then
              SampleCnt := 0;
           else
              sampleCnt := SampleCnt + 1;
           end if;
           
        end if;
     end if;
  end process;
end Behaviour;

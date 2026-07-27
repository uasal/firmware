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
  generic (
      PARITY_EVEN : natural := 0 --1=odd, 0=even
  );
  port (
     Clk    : in  std_logic;  -- system clock signal
     Reset  : in  std_logic;  -- Reset input
     Enable : in  std_logic;  -- Enable input
     RxD    : in  std_logic;  -- RS-232 data input
     RxAv   : out std_logic;  -- Byte available
     DataO  : out std_logic_vector(7 downto 0); -- Byte received
	  ParityErr : out std_logic -- Parity error flag
	 );
end UartRxParity;

architecture Behaviour of UartRxParity is
  
  signal RReg    : std_logic_vector(7 downto 0); -- receive register  
  signal ParityBit : std_logic := '0';
  signal ParityErrFailed : std_logic := '0';
  signal RxDPrev : std_logic := '1';

begin
  
  -- Rx Process
  RxProc : process(Clk, Reset)

	variable BitPos : INTEGER range 0 to 11;   -- Position of the bit in the frame
	variable SampleCnt : INTEGER range 0 to 15; -- Count from 0 to 15 in each bit 
	  
begin
   if Reset = '1' then -- Reset
      BitPos := 0;
		SampleCnt := 0;
		RxAv <= '0';
		RReg <= x"00";
		DataO <= x"00";
      ParityErr <= '0';
      ParityBit <= '0';
      ParityErrFailed <= '0';
      RxDPrev <= '1';
   elsif Rising_Edge(Clk) then
      if Enable = '1' then
         case BitPos is
            when 0 => -- idle
               if (RxDPrev = '1') and (RxD = '0') then -- Start bit falling edge
                  RxAv <= '0';
                  SampleCnt := 0;
                  BitPos := 1;
                  ParityBit <= '0';
                  --~ Start <= '1';
               end if;
            when 1 => -- Start Bit
               if SampleCnt = 7 then
                  if RxD = '0' then
                     null;
                  else
                     BitPos := 0; -- Glitch: abandon frame and return idle
                  end if;
               elsif SampleCnt = 15 then
                  BitPos := 2;
               end if;
            when 10 => -- Parity
               --~ Samp <= '0';
               if SampleCnt = 7 then
                  if (PARITY_EVEN = 0 and RxD /= ParityBit) or
                     (PARITY_EVEN = 1 and RxD /= not ParityBit) then
                     ParityErrFailed <= '1';
                  else
                     ParityErrFailed <= '0';
                  end if;
               end if;
               if SampleCnt = 15 then
                  BitPos := BitPos + 1;
               end if;
            when 11 => -- Stop Bit
               if (SampleCnt >= 3) then
                  if (Rxd = '1') and (ParityErrFailed = '0') then --stop bit
                     BitPos := 0;    -- next is idle
                     RxAv <= '1';
                     DataO <= RReg;  -- Store received byte
                     ParityErr <= '0';
                  elsif (Rxd = '1') and (ParityErrFailed = '1') then --stop bit but parity error
                     BitPos := 0;    -- next is idle
                     RxAv <= '1';
                     DataO <= RReg;  -- Store received byte
                     ParityErr <= '1';
                  end if;
               end if;
               if (SampleCnt >= 13) then --no stop bit
                  BitPos := 0;    -- next is idle
               end if;
            when others =>
               RxAv <= '0';
               ParityErrFailed <= '0';
               if SampleCnt = 7 and BitPos >= 2 and BitPos <= 9 then -- data bits
                  RReg(BitPos-2) <= RxD; -- Deserialisation
                  ParityBit <= ParityBit xor RxD;
               end if;
               if SampleCnt = 15 then -- Increment BitPos on 3
                  BitPos := BitPos + 1;
               end if;
            end case;
           if SampleCnt = 15 then
              SampleCnt := 0;
           else
              sampleCnt := SampleCnt + 1;
           end if;
           RxDPrev <= RxD;
        end if;
     end if;
  end process;
end Behaviour;

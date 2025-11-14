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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;
library work;
use work.CGraphTypes.all;

entity PeekRingBuffer is
  port (
    clk : in std_logic;
    rst : in std_logic;
		
    -- Bus:
    DataStartAddress : out std_logic_vector(PeekRamDepth - 1 downto 0);
	DataEndAddress : out std_logic_vector(PeekRamDepth - 1 downto 0);
    PeekAddress : in std_logic_vector(PeekRamDepth - 1 downto 0);
    PopAddress : in std_logic_vector(PeekRamDepth - 1 downto 0);
    ByteIn : in std_logic_vector(7 downto 0);
    ByteOut : out std_logic_vector(7 downto 0);
    WriteReq : in std_logic;
	PopReq : in std_logic;
	Dbg1 : out std_logic;
	Dbg2 : out std_logic;
	Dbg3 : out std_logic;
	Empty : out std_logic;
	Full : out std_logic;
	Count : out std_logic_vector(PeekRamDepth - 1 downto 0)--;
  );
end PeekRingBuffer;


architecture PeekRingBufferImplemenatation of PeekRingBuffer is

	component PeekRam is
	  port (
		clk : in std_logic;
		rst : in std_logic;
			
		-- Bus:
		ReadAddress : in std_logic_vector(PeekRamDepth - 1 downto 0);
		WriteAddress : in std_logic_vector(PeekRamDepth - 1 downto 0);
		ByteIn : in std_logic_vector(7 downto 0);
		ByteOut : out std_logic_vector(7 downto 0);
		WriteReq : in std_logic--;
	  );
	end component;
	
	signal DataStartAddress_i : std_logic_vector(PeekRamDepth - 1 downto 0);
	signal WriteAddress : std_logic_vector(PeekRamDepth - 1 downto 0);

	signal LastPopReq : std_logic;
	signal LastWriteReq : std_logic;
	
  begin
  
	PeekRam_i : PeekRam
	port map
	(
		clk => clk,
		rst => rst,
		ReadAddress => PeekAddress,
		WriteAddress => WriteAddress,
		ByteIn => ByteIn,
		ByteOut => ByteOut,
		WriteReq => WriteReq
	);
	
  process (clk, rst)
  begin
  
	Dbg2 <= LastWriteReq;
	Dbg3 <= WriteReq;
  
	DataStartAddress <= DataStartAddress_i;
	DataEndAddress <= WriteAddress;
	
	Empty <= '1' when (DataStartAddress_i = WriteAddress) else '0';

	Full <= '1' when ( 	( (DataStartAddress_i = 0) and (WriteAddress = ((2**PeekRamDepth) - 1)) ) or 
						( (DataStartAddress_i = 1) and (WriteAddress = 0) ) or
						( (DataStartAddress_i > 1) and (WriteAddress = (DataStartAddress_i - 1)) ) 
					 )
	else '0';
	
	Count <= (WriteAddress - DataStartAddress_i) when (WriteAddress >= DataStartAddress_i) else 
			 ( ((2**PeekRamDepth) - WriteAddress) - DataStartAddress_i);	
	
    if (rst = '1') then
      
		LastPopReq <= '0';
		LastWriteReq <= '0';
		DataStartAddress_i <= (others => '0');
		WriteAddress <= (others => '0');
        
    else
      if ( (clk'event) and (clk = '1') ) then

	    LastPopReq <= PopReq;
	    LastWriteReq <= WriteReq;
	  
        if ( (LastPopReq = '0') and (PopReq = '1') ) then
		
            DataStartAddress_i <= PopAddress;
        
		end if;

        if ( (LastWriteReq = '0') and (WriteReq = '1') ) then
		
			Dbg1 <= '1';
				
			if (WriteAddress < ( (2**PeekRamDepth) - 1) ) then
		
				--~ WriteAddress <= WriteAddress + std_logic_vector(to_unsigned(1, PeekRamDepth));
				WriteAddress <= WriteAddress + "0000000001";
				
			else --wrap
			
				WriteAddress <= (others => '0');
				
			end if;
        
		else
		
			Dbg1 <= '0';
			
		end if;

  	  end if;  
    end if;
  end process;

end PeekRingBufferImplemenatation;


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
    ByteIn : in std_logic_vector(7 downto 0);
    WriteReq : in std_logic;
	PeekAddress : in std_logic_vector(PeekRamDepth - 1 downto 0);
    ByteOut : out std_logic_vector(7 downto 0);
    PopAddress : in std_logic_vector(PeekRamDepth - 1 downto 0);
    PopReq : in std_logic;
	HeaderFound : out std_logic;
	FooterFound : out std_logic;
	HeaderEndPos : out std_logic_vector(PeekRamDepth - 1 downto 0);
	FooterEndPos : out std_logic_vector(PeekRamDepth - 1 downto 0);
    PayloadType : out std_logic_vector(15 downto 0);
	PayloadLen : out std_logic_vector(15 downto 0);
	PayloadField0 : out std_logic_vector(7 downto 0);
	PayloadField1 : out std_logic_vector(7 downto 0);
	PayloadField2 : out std_logic_vector(7 downto 0);
	PayloadField3 : out std_logic_vector(7 downto 0);
	PayloadField4 : out std_logic_vector(7 downto 0);
	PayloadField5 : out std_logic_vector(7 downto 0);
	PayloadField6 : out std_logic_vector(7 downto 0);
	PayloadField7 : out std_logic_vector(7 downto 0);
	PayloadField8 : out std_logic_vector(7 downto 0);
	PayloadField9 : out std_logic_vector(7 downto 0);
	PayloadField10 : out std_logic_vector(7 downto 0);
	PayloadField11 : out std_logic_vector(7 downto 0);
	PayloadField12 : out std_logic_vector(7 downto 0);
	PayloadField13 : out std_logic_vector(7 downto 0);
	PayloadField14 : out std_logic_vector(7 downto 0);
	PayloadField15 : out std_logic_vector(7 downto 0);
	PacketCrc : out std_logic_vector(31 downto 0);
	CalcCrc : out std_logic_vector(31 downto 0);
	PacketFound : out std_logic;
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
	
	component PatternFinder is
	  generic (
		Byte0 : std_logic_vector(7 downto 0) := x"00";
		Byte1 : std_logic_vector(7 downto 0) := x"00";
		Byte2 : std_logic_vector(7 downto 0) := x"00";
		Byte3 : std_logic_vector(7 downto 0) := x"00"--;
	  );
	  port (
		clk : in std_logic;
		rst : in std_logic;
			
		-- Bus:
		ByteIn : in std_logic_vector(7 downto 0);
		WriteReq : in std_logic;
		Found : out std_logic--;
	  );
	end component;
	
	component FieldLatcher is
	  generic (
			NumBytes : natural := 4--;
	  );
	  port (
			clk : in std_logic;
			rst : in std_logic;
				
			-- Bus:
			ByteIn : in std_logic_vector(7 downto 0);
			WriteReq : in std_logic;
			Latch : in std_logic;
			FieldLatched : out std_logic_vector((NumBytes * 8) - 1 downto 0)--;
	  );
	end component;

	component CrcStream is
	generic (
		CRC_INIT_STATE : std_logic_vector(31 downto 0) := x"FFFFFFFF";
		CRC_FINAL_XOR : std_logic_vector(31 downto 0) := x"FFFFFFFF"
	);
	port (
	
		--Globals
		clk : in std_logic;
		rst : in std_logic;
		
		data : in std_logic_vector(7 downto 0);
		crc : out std_logic_vector(31 downto 0)
	
	); end component;

	component PacketValidator is
	port (
		clk : in std_logic;
		rst : in std_logic;

		PacketFound : out std_logic;
		HeaderFound : in std_logic;
		FooterFound : in std_logic;
		HeaderEndPos : in std_logic_vector(PeekRamDepth - 1 downto 0);
		FooterEndPos : in std_logic_vector(PeekRamDepth - 1 downto 0);
		PayloadLen : in std_logic_vector(15 downto 0);
		PacketCrc : in std_logic_vector(31 downto 0);
		CalcCrc : in std_logic_vector(31 downto 0)--;
	);
	end component;

	signal DataStartAddress_i : std_logic_vector(PeekRamDepth - 1 downto 0);
	signal WriteAddress : std_logic_vector(PeekRamDepth - 1 downto 0);

	signal LastPopReq : std_logic;
	signal LastWriteReq : std_logic;
	signal PopAccepted : std_logic;
	signal PopInvalidatesParser : std_logic;
	signal WriteAccepted : std_logic;
	signal Full_i : std_logic;

	signal LastHeaderFound : std_logic;
	signal HeaderValid : std_logic;
	signal FooterFound_i : std_logic;
	signal FooterLatched : std_logic;	
	signal LastFooterFound : std_logic;
	signal CalcCrc_i : std_logic_vector(31 downto 0);
	signal CalcCrcLatched : std_logic_vector(31 downto 0);
	signal PayloadLenLow : std_logic_vector(7 downto 0);
	
	signal LatchPayloadType : std_logic;
	signal LatchPayloadLen : std_logic;
	signal LatchPayloadField0 : std_logic;
	signal LatchPayloadField1 : std_logic;
	signal LatchPayloadField2 : std_logic;
	signal LatchPayloadField3 : std_logic;
	signal LatchPayloadField4 : std_logic;
	signal LatchPayloadField5 : std_logic;
	signal LatchPayloadField6 : std_logic;
	signal LatchPayloadField7 : std_logic;
	signal LatchPayloadField8 : std_logic;
	signal LatchPayloadField9 : std_logic;
	signal LatchPayloadField10 : std_logic;
	signal LatchPayloadField11 : std_logic;
	signal LatchPayloadField12 : std_logic;
	signal LatchPayloadField13 : std_logic;
	signal LatchPayloadField14 : std_logic;
	signal LatchPayloadField15 : std_logic;
	signal LatchCrc : std_logic;	
	signal CrcRst : std_logic;
	signal CrcClk : std_logic;
	signal ValidatorRst : std_logic;
	
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
		WriteReq => WriteAccepted
	);
	
	HeaderFinder : PatternFinder
	generic map 
	(
		--~ Byte0 => x"1B", --NO!
		--~ Byte1 => x"AD" --NO!,
		--~ Byte2 => x"BA", --NO!
		--~ Byte3 => x"BE"--, --NO!
		Byte0 => x"BE", --YES!
		Byte1 => x"BA", --YES!
		Byte2 => x"AD", --YES!
		Byte3 => x"1B"--, --YES!
	)
	port map
	(
		clk => clk,
		rst => rst,
		ByteIn => ByteIn,
		WriteReq => WriteAccepted,
		Found => HeaderFound--,
	);
	
	FooterFinder : PatternFinder
	generic map 
	(
		Byte0 => x"ED",
		Byte1 => x"AD",
		Byte2 => x"0F",
		Byte3 => x"0A"--,
	)
	port map
	(
		clk => clk,
		rst => rst,
		ByteIn => ByteIn,
		WriteReq => WriteAccepted,
		Found => FooterFound_i--,
	);
	
	PayloadTypeLatcher : FieldLatcher
	generic map 
	(
		NumBytes => 2--,
	)
	port map 
	(
		clk => clk,
		rst => rst,
		ByteIn => ByteIn,
		WriteReq => WriteAccepted,
		Latch => LatchPayloadType,
		FieldLatched => PayloadType--,
	);

	PayloadLenLatcher : FieldLatcher
	generic map 
	(
		NumBytes => 2--,
	)
	port map 
	(
		clk => clk,
		rst => ValidatorRst,
		ByteIn => ByteIn,
		WriteReq => WriteAccepted,
		Latch => LatchPayloadLen,
		FieldLatched => PayloadLen--,
	);
	
	PayloadField0Latcher : FieldLatcher generic map (NumBytes => 1) port map (clk => clk, rst => rst, ByteIn => ByteIn, WriteReq => WriteAccepted, Latch => LatchPayloadField0, FieldLatched => PayloadField0);
	PayloadField1Latcher : FieldLatcher generic map (NumBytes => 1) port map (clk => clk, rst => rst, ByteIn => ByteIn, WriteReq => WriteAccepted, Latch => LatchPayloadField1, FieldLatched => PayloadField1);
	PayloadField2Latcher : FieldLatcher generic map (NumBytes => 1) port map (clk => clk, rst => rst, ByteIn => ByteIn, WriteReq => WriteAccepted, Latch => LatchPayloadField2, FieldLatched => PayloadField2);
	PayloadField3Latcher : FieldLatcher generic map (NumBytes => 1) port map (clk => clk, rst => rst, ByteIn => ByteIn, WriteReq => WriteAccepted, Latch => LatchPayloadField3, FieldLatched => PayloadField3);
	PayloadField4Latcher : FieldLatcher generic map (NumBytes => 1) port map (clk => clk, rst => rst, ByteIn => ByteIn, WriteReq => WriteAccepted, Latch => LatchPayloadField4, FieldLatched => PayloadField4);
	PayloadField5Latcher : FieldLatcher generic map (NumBytes => 1) port map (clk => clk, rst => rst, ByteIn => ByteIn, WriteReq => WriteAccepted, Latch => LatchPayloadField5, FieldLatched => PayloadField5);
	PayloadField6Latcher : FieldLatcher generic map (NumBytes => 1) port map (clk => clk, rst => rst, ByteIn => ByteIn, WriteReq => WriteAccepted, Latch => LatchPayloadField6, FieldLatched => PayloadField6);
	PayloadField7Latcher : FieldLatcher generic map (NumBytes => 1) port map (clk => clk, rst => rst, ByteIn => ByteIn, WriteReq => WriteAccepted, Latch => LatchPayloadField7, FieldLatched => PayloadField7);
	PayloadField8Latcher : FieldLatcher generic map (NumBytes => 1) port map (clk => clk, rst => rst, ByteIn => ByteIn, WriteReq => WriteAccepted, Latch => LatchPayloadField8, FieldLatched => PayloadField8);
	PayloadField9Latcher : FieldLatcher generic map (NumBytes => 1) port map (clk => clk, rst => rst, ByteIn => ByteIn, WriteReq => WriteAccepted, Latch => LatchPayloadField9, FieldLatched => PayloadField9);
	PayloadField10Latcher : FieldLatcher generic map (NumBytes => 1) port map (clk => clk, rst => rst, ByteIn => ByteIn, WriteReq => WriteAccepted, Latch => LatchPayloadField10, FieldLatched => PayloadField10);
	PayloadField11Latcher : FieldLatcher generic map (NumBytes => 1) port map (clk => clk, rst => rst, ByteIn => ByteIn, WriteReq => WriteAccepted, Latch => LatchPayloadField11, FieldLatched => PayloadField11);
	PayloadField12Latcher : FieldLatcher generic map (NumBytes => 1) port map (clk => clk, rst => rst, ByteIn => ByteIn, WriteReq => WriteAccepted, Latch => LatchPayloadField12, FieldLatched => PayloadField12);
	PayloadField13Latcher : FieldLatcher generic map (NumBytes => 1) port map (clk => clk, rst => rst, ByteIn => ByteIn, WriteReq => WriteAccepted, Latch => LatchPayloadField13, FieldLatched => PayloadField13);
	PayloadField14Latcher : FieldLatcher generic map (NumBytes => 1) port map (clk => clk, rst => rst, ByteIn => ByteIn, WriteReq => WriteAccepted, Latch => LatchPayloadField14, FieldLatched => PayloadField14);
	PayloadField15Latcher : FieldLatcher generic map (NumBytes => 1) port map (clk => clk, rst => rst, ByteIn => ByteIn, WriteReq => WriteAccepted, Latch => LatchPayloadField15, FieldLatched => PayloadField15);

	CRCLatcher : FieldLatcher
	generic map 
	(
		NumBytes => 4--,
	)
	port map 
	(
		clk => clk,
		rst => rst,
		ByteIn => ByteIn,
		WriteReq => WriteAccepted,
		Latch => LatchCRC,
		FieldLatched => PacketCrc--,
	);

	Crcer : CrcStream
	port map
	(
		clk => CrcClk,
		rst => CrcRst,
		data => ByteIn,
		crc => CalcCrc_i--,
	);

	PacketValidator_i : PacketValidator
	port map
	(
		rst => ValidatorRst,
		clk => clk,
		PacketFound => PacketFound,
		HeaderFound => HeaderValid,
		FooterFound => FooterLatched,
		HeaderEndPos => HeaderEndPos,
		FooterEndPos => FooterEndPos,
		PayloadLen => PayloadLen,
		PacketCrc => PacketCrc,
		CalcCrc => CalcCrcLatched--,
	);

	PopAccepted <= PopReq and not LastPopReq;
	CrcClk <= not WriteAccepted;
	PopInvalidatesParser <= '1' when PopAccepted = '1' and (unsigned(PopAddress) - unsigned(DataStartAddress_i) > (unsigned(HeaderEndPos) - to_unsigned(3, PeekRamDepth)) - unsigned(DataStartAddress_i)) else '0';
	Full_i <= '1' when unsigned(WriteAddress) + 1 = unsigned(DataStartAddress_i) else '0';
	-- A full buffer can accept a write only if this pop actually frees space.
	WriteAccepted <= WriteReq and not LastWriteReq when Full_i = '0' or (PopAccepted = '1' and PopAddress /= DataStartAddress_i) else '0'; -- peekringbuffer's rising edge write req
	CrcRst <= HeaderFound and not LastHeaderFound and not HeaderValid; -- rising header found without current active header
	ValidatorRst <= rst or CrcRst or PopInvalidatesParser; -- rst, new header, or pop invalidates the current packet.

	Dbg1 <= LatchCrc;
	Dbg2 <= LatchPayloadType;
	Dbg3 <= LatchPayloadLen;
	FooterFound <= FooterLatched;
	DataStartAddress <= DataStartAddress_i;
	DataEndAddress <= WriteAddress;
	CalcCrc <= CalcCrcLatched;
	Empty <= '1' when DataStartAddress_i = WriteAddress else '0';
	Full <= Full_i;
	Count <= std_logic_vector(unsigned(WriteAddress) - unsigned(DataStartAddress_i));

	process (clk, rst)
  begin
    if (rst = '1') then
      
		LastPopReq <= '0';
		LastWriteReq <= '0';
		LastHeaderFound <= '0';
		HeaderValid <= '0';
		LastFooterFound <= '0';
		FooterLatched <= '0';
		DataStartAddress_i <= (others => '0');
		WriteAddress <= (others => '0');
		HeaderEndPos <= (others => '0');
		FooterEndPos <= (others => '0');
		CalcCrcLatched <= (others => '0');
		PayloadLenLow <= (others => '0');
		LatchPayloadType <= '0';
		LatchPayloadLen <= '0';
		LatchPayloadField0 <= '0';
		LatchPayloadField1 <= '0';
		LatchPayloadField2 <= '0';
		LatchPayloadField3 <= '0';
		LatchPayloadField4 <= '0';
		LatchPayloadField5 <= '0';
		LatchPayloadField6 <= '0';
		LatchPayloadField7 <= '0';
		LatchPayloadField8 <= '0';
		LatchPayloadField9 <= '0';
		LatchPayloadField10 <= '0';
		LatchPayloadField11 <= '0';
		LatchPayloadField12 <= '0';
		LatchPayloadField13 <= '0';
		LatchPayloadField14 <= '0';
		LatchPayloadField15 <= '0';
		LatchCrc <= '0';
	    
    else
	      if rising_edge(clk) then

	    LastPopReq <= PopReq;
	    LastWriteReq <= WriteReq;
		LastHeaderFound <= HeaderFound;
		LastFooterFound <= FooterFound_i;
		FooterLatched <= '0';
		LatchPayloadType <= '0';
		LatchPayloadLen <= '0';
		LatchPayloadField0 <= '0';
		LatchPayloadField1 <= '0';
		LatchPayloadField2 <= '0';
		LatchPayloadField3 <= '0';
		LatchPayloadField4 <= '0';
		LatchPayloadField5 <= '0';
		LatchPayloadField6 <= '0';
		LatchPayloadField7 <= '0';
		LatchPayloadField8 <= '0';
		LatchPayloadField9 <= '0';
		LatchPayloadField10 <= '0';
		LatchPayloadField11 <= '0';
		LatchPayloadField12 <= '0';
		LatchPayloadField13 <= '0';
		LatchPayloadField14 <= '0';
		LatchPayloadField15 <= '0';
		LatchCrc <= '0';
	  
	    if PopAccepted = '1' then
		
			DataStartAddress_i <= PopAddress;
		end if;

	    if PopInvalidatesParser = '1' then

			HeaderValid <= '0';
			HeaderEndPos <= (others => '0');
			FooterEndPos <= (others => '0');
			
		end if;

		if FooterLatched = '1' then HeaderValid <= '0'; end if;

		if WriteAccepted = '1' then
		
			if (WriteAddress < ( (2**PeekRamDepth) - 1) ) then
		
				WriteAddress <= WriteAddress + std_logic_vector(to_unsigned(1, PeekRamDepth));
				
			else --wrap
			
				WriteAddress <= (others => '0');
				
			end if;
			
			--If we wrap footer or header, clear!
			if (HeaderEndPos = WriteAddress + std_logic_vector(to_unsigned(1, PeekRamDepth))) then HeaderEndPos <= (others => '0'); HeaderValid <= '0'; end if;
			if (FooterEndPos = WriteAddress + std_logic_vector(to_unsigned(1, PeekRamDepth))) then FooterEndPos <= (others => '0'); end if;
			
			--Grab the payload len?
			
			if (WriteAddress = HeaderEndPos + 2) then LatchPayloadType <= '1'; else LatchPayloadType <= '0'; end if;
			if (WriteAddress = HeaderEndPos + 3) then PayloadLenLow <= ByteIn; end if; -- latch the low byte of the payload length
			if (WriteAddress = HeaderEndPos + 4) then LatchPayloadLen <= '1'; else LatchPayloadLen <= '0'; end if;
			if (HeaderValid = '1') and (WriteAddress = HeaderEndPos + 5) and (unsigned(PayloadLen) > to_unsigned((2 ** PeekRamDepth) - 17, PayloadLen'length)) then HeaderValid <= '0'; end if; -- if the payload length is too long, invalidate the header
			if (WriteAddress = HeaderEndPos + 5) then LatchPayloadField0 <= '1'; else LatchPayloadField0 <= '0'; end if;
			if (WriteAddress = HeaderEndPos + 6) then LatchPayloadField1 <= '1'; else LatchPayloadField1 <= '0'; end if;
			if (WriteAddress = HeaderEndPos + 7) then LatchPayloadField2 <= '1'; else LatchPayloadField2 <= '0'; end if;
			if (WriteAddress = HeaderEndPos + 8) then LatchPayloadField3 <= '1'; else LatchPayloadField3 <= '0'; end if;
			if (WriteAddress = HeaderEndPos + 9) then LatchPayloadField4 <= '1'; else LatchPayloadField4 <= '0'; end if;
			if (WriteAddress = HeaderEndPos + 10) then LatchPayloadField5 <= '1'; else LatchPayloadField5 <= '0'; end if;
			if (WriteAddress = HeaderEndPos + 11) then LatchPayloadField6 <= '1'; else LatchPayloadField6 <= '0'; end if;
			if (WriteAddress = HeaderEndPos + 12) then LatchPayloadField7 <= '1'; else LatchPayloadField7 <= '0'; end if;
			if (WriteAddress = HeaderEndPos + 13) then LatchPayloadField8 <= '1'; else LatchPayloadField8 <= '0'; end if;
			if (WriteAddress = HeaderEndPos + 14) then LatchPayloadField9 <= '1'; else LatchPayloadField9 <= '0'; end if;
			if (WriteAddress = HeaderEndPos + 15) then LatchPayloadField10 <= '1'; else LatchPayloadField10 <= '0'; end if;
			if (WriteAddress = HeaderEndPos + 16) then LatchPayloadField11 <= '1'; else LatchPayloadField11 <= '0'; end if;
			if (WriteAddress = HeaderEndPos + 17) then LatchPayloadField12 <= '1'; else LatchPayloadField12 <= '0'; end if;
			if (WriteAddress = HeaderEndPos + 18) then LatchPayloadField13 <= '1'; else LatchPayloadField13 <= '0'; end if;
			if (WriteAddress = HeaderEndPos + 19) then LatchPayloadField14 <= '1'; else LatchPayloadField14 <= '0'; end if;
			if (WriteAddress = HeaderEndPos + 20) then LatchPayloadField15 <= '1'; else LatchPayloadField15 <= '0'; end if;
			if (HeaderValid = '1') and (unsigned(WriteAddress) = unsigned(HeaderEndPos) + to_unsigned(4, PeekRamDepth) + resize(unsigned(PayloadLen), PeekRamDepth)) then CalcCrcLatched <= CalcCrc_i; end if; -- latch the calculated CRC
			if (HeaderValid = '1') and (WriteAddress = HeaderEndPos + 4) and (PayloadLenLow = x"00") and (ByteIn = x"00") then CalcCrcLatched <= CalcCrc_i; end if; -- latch the calculated CRC if the payload length is zero
			if (unsigned(WriteAddress) = unsigned(HeaderEndPos) + to_unsigned(8, PeekRamDepth) + resize(unsigned(PayloadLen), PeekRamDepth)) then LatchCrc <= '1'; else LatchCrc <= '0'; end if; -- latch the CRC when we are at the end of the payload

		end if;

		-- End the active packet at its expected footer position.
		if (HeaderValid = '1') and (unsigned(WriteAddress) = unsigned(HeaderEndPos) + to_unsigned(13, PeekRamDepth) + resize(unsigned(PayloadLen), PeekRamDepth)) then
			if (LastFooterFound = '0') and (FooterFound_i = '1') then FooterEndPos <= WriteAddress - std_logic_vector(to_unsigned(1, PeekRamDepth)); FooterLatched <= '1'; else HeaderValid <= '0'; end if;
		end if;

		--Update on the edge of found; can't put this on the writereq edge, because the flag will toggle on the next clock after, not synchrounously!
		if CrcRst = '1' then HeaderEndPos <= WriteAddress - std_logic_vector(to_unsigned(1, PeekRamDepth)); HeaderValid <= '1'; PayloadLenLow <= (others => '0'); end if;
		
  	  end if;  
    end if;
  end process;

end PeekRingBufferImplemenatation;

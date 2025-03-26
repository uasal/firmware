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

--------------------------------------------------------------------------------------------------
-- UartTxFifo: accepts bytes into a fifo and transmits on uart until empty
--------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity UartTxFifo is
	generic 
	(
		UART_CLOCK_FREQHZ : natural := 14745600; --for making industry-standard baudrates
		FIFO_BITS : natural := 10;
		BAUDRATE : natural := 38400--;
	);
	port 
	(
		--global control signals
		clk : in std_logic; --generic clock base for fifo & control signals
		uclk : in std_logic; --clock base for correct uart speed (should be less than clk)
		rst : in std_logic; --global reset
		
		--'digital' side (backyard)
		WriteStrobe : in std_logic; --send byte to fifo
		WriteData : in std_logic_vector(7 downto 0); --the byte
		FifoFull : out std_logic; --fifo status:
		FifoEmpty : out std_logic; --fifo status:
		FifoCount : out std_logic_vector(FIFO_BITS - 1 downto 0); --fifo status:
		BitClockOut : out std_logic; --generally used for debug of divider values...		
		
		--'analog' side (frontyard)
		TxInProgress : out std_logic; --currently sending data...
		Cts : in std_logic; --Are the folks on the other end actually ready for data if we have some? (Just tie it to zero if unused).
		Txd : out std_logic--; --Uart data output pin (i.e. to RS-232 driver chip)
	);
end UartTxFifo;

architecture implementation of UartTxFifo is

	-- Component declarations
			
			component IBufP2Ports is
			port 
			(
				clk : in std_logic;
				I : in std_logic;
				O : out std_logic--;
			);
			end component;

			component ClockDividerPorts is
			generic (
				CLOCK_DIVIDER : natural := 10;
				DIVOUT_RST_STATE : std_logic := '0'--;
			);
			port (
			
				clk : in std_logic;
				rst : in std_logic;
				div : out std_logic
			);
			end component;
			
			component gated_fifo is
			generic (
				WIDTH_BITS : natural := 32;
				DEPTH_BITS : natural := 9
			);
			port (
				clk		: in std_logic;
				rst		: in std_logic;
				wone_i	: in std_logic;
				data_i	: in std_logic_vector(WIDTH_BITS - 1 downto 0);
				rone_i	: in std_logic;
				full_o	: out std_logic;
				empty_o	: out std_logic;
				data_o	: out std_logic_vector(WIDTH_BITS - 1 downto 0);
				count_o	: out std_logic_vector(DEPTH_BITS - 1 downto 0);
				r_ack : out std_logic--;
			);
			end component;
			
			component UartTx is
			port 
			(
				Clk    : in  Std_Logic;
				Reset  : in  Std_Logic;
				Go     : in  Std_Logic; --To initate a xfer, raise this bit and wait for busy to go high, then lower.
				TxD    : out Std_Logic;
				Busy   : out Std_Logic;
				Data  : in  Std_Logic_Vector(7 downto 0)--; --not latched; must be held constant while busy is high
			);
			end component;
										
	--Signals /  Local variables
		
		--Constants & Setup
		
			signal FifoEmpty_i : std_logic;
			
			signal ReadStrobe : std_logic;			
			signal FifoReadAck : std_logic;
			signal OutgoingTxByte : std_logic_vector(7 downto 0);
			
			signal BitClock : std_logic;
			signal StartTx : std_logic;
			signal StartTx_i : std_logic; --same thing, uart clk domain
			signal TxInProgress_i : std_logic; --internal readpack for output port
			signal TxInProgress_i_i : std_logic; --same thing, uart clk domain
			
			type States is (Idle, StartRead, WaitAck, Tx);
			signal NextState : States := Idle;
			signal CurrentState : States := Idle;
			
			signal Cts_i : std_logic;

begin

	------------------------------------------ Atomic Clock Uart+Fifo ---------------------------------------------------

	--~ zigfiforeset has clock domain issues, UartTxfiforeset probably does too. async->sync reset?
	--~ so does uclk, pretty much everything in the uart domain
	--~ fifos are run by uclk, but read by clk via datamapper...
	--~ should run write & data out of slow domain, run fifo from master.
	--~ also need to add useatomicclk flag to fpgacontrol register

	UartTxFifo : gated_fifo
	generic map
	(
		WIDTH_BITS => 8,
		DEPTH_BITS => FIFO_BITS--,
	)
	port map
	(
		clk => clk,
		rst => rst,
		wone_i => WriteStrobe,
		data_i => WriteData,
		rone_i => ReadStrobe,
		full_o => FifoFull,
		empty_o => FifoEmpty_i,
		data_o => OutgoingTxByte,
		count_o => FifoCount,
		r_ack => FifoReadAck--,
	);	
	FifoEmpty <= FifoEmpty_i;
	
	BitClockDiv : ClockDividerPorts
	generic map
	(
		CLOCK_DIVIDER => natural( (real(UART_CLOCK_FREQHZ) / (real(BAUDRATE)) ) + 0.5)
	)
	port map
	(
		clk => uclk,
		rst => rst,
		div => BitClock
	);
	
	BitClockOut <= BitClock;
	
	IBufStartTx : IBufP2Ports --cross the clk domain
	port map
	(
		clk => BitClock,
		I => StartTx,
		O => StartTx_i--,
	);

	UartTxUart : UartTx
	port map 
	(	
		clk => BitClock,
		reset => rst,
		Go => StartTx_i,
		TxD => Txd,
		Busy => TxInProgress_i_i,
		Data => OutgoingTxByte
	);
	
	IBufTxInProgress_i : IBufP2Ports --cross the clk domain
	port map
	(
		clk => clk,
		I => TxInProgress_i_i,
		O => TxInProgress_i--,
	);
	
	TxInProgress <= TxInProgress_i;
	
	IBufCts : IBufP2Ports --cross the clk domain
	port map
	(
		clk => clk,
		I => Cts,
		O => Cts_i--,
	);
	
	
	--Move data from fifo out uart as it's available...
	process (clk, rst, CurrentState)
	begin
	
		if (rst = '1') then
		
			CurrentState <= Idle;
			NextState <= Idle;
			ReadStrobe <= '0';
			StartTx <= '0';
			
		else
			
			if ( (clk'event) and (clk = '1') ) then
			
				CurrentState <= NextState;

				case CurrentState is
				
					when Idle =>
					
						ReadStrobe <= '0';
						
						StartTx <= '0';
					
						--~ if (FifoEmpty_i = '0') then			
						
						if ( (FifoEmpty_i = '0') and (TxInProgress_i = '0') and (Cts_i = '0') ) then
						
							NextState <= StartRead;
											
						end if;
						
					when StartRead =>
					
						if (FifoReadAck = '0') then
						
							ReadStrobe <= '1';
					
							NextState <= WaitAck;
							
						end if;
										
					when WaitAck =>
					
						if (FifoReadAck = '1') then
			
							ReadStrobe <= '0';
							
							StartTx <= '1';
							
						end if;						
						
						if (TxInProgress_i = '1') then						
						
							NextState <= Tx;
											
						end if;						
						
					when Tx =>
					
						StartTx <= '0';
					
						if (TxInProgress_i = '0') then
							
							NextState <= Idle;
											
						end if;						

					when others => -- ought never to get here...
					
						NextState <= Idle;
						
				end case;
				
			end if;
			  
		end if;

	end process;
	
end implementation;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:09:04 06/19/2013 
-- Design Name: 
-- Module Name:    IBuf - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity IBufP1Ports is
	port (
			clk : in std_logic;
			I : in std_logic;
			O : out std_logic--;
	);
end IBufP1Ports;

architecture IBufP1 of IBufP1Ports is
begin
	
	-- Master clock drives most logic
	process (clk)
	begin
		if ( (clk'event) and (clk = '1') ) then
		
			O <= I; --

		end if;

	end process; --(clock)

end IBufP1;


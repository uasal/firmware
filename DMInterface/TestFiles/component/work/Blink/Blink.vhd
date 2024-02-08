----------------------------------------------------------------------
-- Created by SmartDesign Thu Feb  8 14:21:28 2024
-- Version: 2023.2 2023.2.0.10
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;
----------------------------------------------------------------------
-- Blink entity declaration
----------------------------------------------------------------------
entity Blink is
    -- Port list
    port(
        -- Inputs
        clk    : in  std_logic;
        debug1 : in  std_logic;
        -- Outputs
        debug  : out std_logic_vector(8 downto 2)
        );
end Blink;
----------------------------------------------------------------------
-- Blink architecture body
----------------------------------------------------------------------
architecture RTL of Blink is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- FCCC_C0
component FCCC_C0
    -- Port list
    port(
        -- Inputs
        CLK0 : in  std_logic;
        -- Outputs
        GL0  : out std_logic;
        LOCK : out std_logic
        );
end component;
-- Main
component Main
    -- Port list
    port(
        -- Inputs
        clk    : in  std_logic;
        debug1 : in  std_logic;
        -- Outputs
        debug  : out std_logic_vector(8 downto 2)
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal debug_net_0   : std_logic_vector(8 downto 2);
signal FCCC_C0_0_GL0 : std_logic;
signal debug_net_1   : std_logic_vector(8 downto 2);

begin
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 debug_net_1       <= debug_net_0;
 debug(8 downto 2) <= debug_net_1;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- FCCC_C0_0
FCCC_C0_0 : FCCC_C0
    port map( 
        -- Inputs
        CLK0 => clk,
        -- Outputs
        GL0  => FCCC_C0_0_GL0,
        LOCK => OPEN 
        );
-- Main_0
Main_0 : Main
    port map( 
        -- Inputs
        clk    => FCCC_C0_0_GL0,
        debug1 => debug1,
        -- Outputs
        debug  => debug_net_0 
        );

end RTL;

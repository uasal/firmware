----------------------------------------------------------------------
-- Created by SmartDesign Wed Jan 31 10:57:18 2024
-- Version: 2023.2 2023.2.0.8
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
        port_name1 : in  std_logic;
        -- Outputs
        port_name2 : out std_logic
        );
end Blink;
----------------------------------------------------------------------
-- Blink architecture body
----------------------------------------------------------------------
architecture RTL of Blink is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- Main
component Main
    -- Port list
    port(
        -- Inputs
        port_name1 : in  std_logic;
        -- Outputs
        port_name2 : out std_logic
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal port_name2_net_0 : std_logic;
signal port_name2_net_1 : std_logic;

begin
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 port_name2_net_1 <= port_name2_net_0;
 port_name2       <= port_name2_net_1;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- Main_0
Main_0 : Main
    port map( 
        -- Inputs
        port_name1 => port_name1,
        -- Outputs
        port_name2 => port_name2_net_0 
        );

end RTL;

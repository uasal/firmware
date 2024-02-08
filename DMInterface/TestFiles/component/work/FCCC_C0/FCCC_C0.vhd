----------------------------------------------------------------------
-- Created by SmartDesign Thu Feb  8 11:34:46 2024
-- Version: 2023.2 2023.2.0.10
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Component Description (Tcl) 
----------------------------------------------------------------------
--# Exporting Component Description of FCCC_C0 to TCL
--# Family: SmartFusion2
--# Part Number: M2S025-1VF256I
--# Create and Configure the core component FCCC_C0
--create_and_configure_core -core_vlnv {Actel:SgCore:FCCC:2.0.201} -component_name {FCCC_C0} -params {\
--"ADVANCED_TAB_CHANGED:false"  \
--"CLK0_IS_USED:true"  \
--"CLK0_PAD_IS_USED:false"  \
--"CLK1_IS_USED:false"  \
--"CLK1_PAD_IS_USED:false"  \
--"CLK2_IS_USED:false"  \
--"CLK2_PAD_IS_USED:false"  \
--"CLK3_IS_USED:false"  \
--"CLK3_PAD_IS_USED:false"  \
--"DYN_CONF_IS_USED:false"  \
--"GL0_BP_IN_0_FREQ:100"  \
--"GL0_BP_IN_0_SRC:IO_HARDWIRED_0"  \
--"GL0_BP_IN_1_FREQ:100"  \
--"GL0_BP_IN_1_SRC:IO_HARDWIRED_0"  \
--"GL0_FREQUENCY_LOCKED:false"  \
--"GL0_IN_0_SRC:PLL"  \
--"GL0_IN_1_SRC:UNUSED"  \
--"GL0_IS_INVERTED:false"  \
--"GL0_IS_USED:true"  \
--"GL0_OUT_0_FREQ:204"  \
--"GL0_OUT_1_FREQ:50"  \
--"GL0_OUT_IS_GATED:false"  \
--"GL0_PLL_IN_0_PHASE:0"  \
--"GL0_PLL_IN_1_PHASE:0"  \
--"GL1_BP_IN_0_FREQ:100"  \
--"GL1_BP_IN_0_SRC:IO_HARDWIRED_0"  \
--"GL1_BP_IN_1_FREQ:100"  \
--"GL1_BP_IN_1_SRC:IO_HARDWIRED_0"  \
--"GL1_FREQUENCY_LOCKED:false"  \
--"GL1_IN_0_SRC:PLL"  \
--"GL1_IN_1_SRC:UNUSED"  \
--"GL1_IS_INVERTED:false"  \
--"GL1_IS_USED:false"  \
--"GL1_OUT_0_FREQ:100"  \
--"GL1_OUT_1_FREQ:50"  \
--"GL1_OUT_IS_GATED:false"  \
--"GL1_PLL_IN_0_PHASE:0"  \
--"GL1_PLL_IN_1_PHASE:0"  \
--"GL2_BP_IN_0_FREQ:100"  \
--"GL2_BP_IN_0_SRC:IO_HARDWIRED_0"  \
--"GL2_BP_IN_1_FREQ:100"  \
--"GL2_BP_IN_1_SRC:IO_HARDWIRED_0"  \
--"GL2_FREQUENCY_LOCKED:false"  \
--"GL2_IN_0_SRC:PLL"  \
--"GL2_IN_1_SRC:UNUSED"  \
--"GL2_IS_INVERTED:false"  \
--"GL2_IS_USED:false"  \
--"GL2_OUT_0_FREQ:100"  \
--"GL2_OUT_1_FREQ:50"  \
--"GL2_OUT_IS_GATED:false"  \
--"GL2_PLL_IN_0_PHASE:0"  \
--"GL2_PLL_IN_1_PHASE:0"  \
--"GL3_BP_IN_0_FREQ:100"  \
--"GL3_BP_IN_0_SRC:IO_HARDWIRED_0"  \
--"GL3_BP_IN_1_FREQ:100"  \
--"GL3_BP_IN_1_SRC:IO_HARDWIRED_0"  \
--"GL3_FREQUENCY_LOCKED:false"  \
--"GL3_IN_0_SRC:PLL"  \
--"GL3_IN_1_SRC:UNUSED"  \
--"GL3_IS_INVERTED:false"  \
--"GL3_IS_USED:false"  \
--"GL3_OUT_0_FREQ:100"  \
--"GL3_OUT_1_FREQ:50"  \
--"GL3_OUT_IS_GATED:false"  \
--"GL3_PLL_IN_0_PHASE:0"  \
--"GL3_PLL_IN_1_PHASE:0"  \
--"GPD0_IS_USED:false"  \
--"GPD0_NOPIPE_RSTSYNC:true"  \
--"GPD0_SYNC_STYLE:G3STYLE_AND_NO_LOCK_RSTSYNC"  \
--"GPD1_IS_USED:false"  \
--"GPD1_NOPIPE_RSTSYNC:true"  \
--"GPD1_SYNC_STYLE:G3STYLE_AND_NO_LOCK_RSTSYNC"  \
--"GPD2_IS_USED:false"  \
--"GPD2_NOPIPE_RSTSYNC:true"  \
--"GPD2_SYNC_STYLE:G3STYLE_AND_NO_LOCK_RSTSYNC"  \
--"GPD3_IS_USED:false"  \
--"GPD3_NOPIPE_RSTSYNC:true"  \
--"GPD3_SYNC_STYLE:G3STYLE_AND_NO_LOCK_RSTSYNC"  \
--"GPD_EXPOSE_RESETS:false"  \
--"GPD_SYNC_STYLE:G3STYLE_AND_LOCK_RSTSYNC"  \
--"INIT:0000007FB8000044974000318C6318C1F18C61F00404040400701"  \
--"IO_HARDWIRED_0_IS_DIFF:false"  \
--"IO_HARDWIRED_1_IS_DIFF:false"  \
--"IO_HARDWIRED_2_IS_DIFF:false"  \
--"IO_HARDWIRED_3_IS_DIFF:false"  \
--"MODE_10V:false"  \
--"NGMUX0_HOLD_IS_USED:false"  \
--"NGMUX0_IS_USED:false"  \
--"NGMUX1_HOLD_IS_USED:false"  \
--"NGMUX1_IS_USED:false"  \
--"NGMUX2_HOLD_IS_USED:false"  \
--"NGMUX2_IS_USED:false"  \
--"NGMUX3_HOLD_IS_USED:false"  \
--"NGMUX3_IS_USED:false"  \
--"NGMUX_EXPOSE_HOLD:false"  \
--"PLL_DELAY:0"  \
--"PLL_EXPOSE_BYPASS:false"  \
--"PLL_EXPOSE_RESETS:false"  \
--"PLL_EXT_FB_GL:EXT_FB_GL0"  \
--"PLL_FB_SRC:CCC_INTERNAL"  \
--"PLL_IN_FREQ:51"  \
--"PLL_IN_SRC:CORE_0"  \
--"PLL_IS_USED:true"  \
--"PLL_LOCK_IND:1024"  \
--"PLL_LOCK_WND:32000"  \
--"PLL_SSM_DEPTH:0.5"  \
--"PLL_SSM_ENABLE:false"  \
--"PLL_SSM_FREQ:40"  \
--"PLL_SUPPLY_VOLTAGE:25_V"  \
--"PLL_VCO_TARGET:700"  \
--"RCOSC_1MHZ_IS_USED:false"  \
--"RCOSC_25_50MHZ_IS_USED:false"  \
--"VCOFREQUENCY:816.000"  \
--"XTLOSC_IS_USED:false"  \
--"Y0_IS_USED:false"  \
--"Y1_IS_USED:false"  \
--"Y2_IS_USED:false"  \
--"Y3_IS_USED:false"   }
--# Exporting Component Description of FCCC_C0 to TCL done

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;
----------------------------------------------------------------------
-- FCCC_C0 entity declaration
----------------------------------------------------------------------
entity FCCC_C0 is
    -- Port list
    port(
        -- Inputs
        CLK0 : in  std_logic;
        -- Outputs
        GL0  : out std_logic;
        LOCK : out std_logic
        );
end FCCC_C0;
----------------------------------------------------------------------
-- FCCC_C0 architecture body
----------------------------------------------------------------------
architecture RTL of FCCC_C0 is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- FCCC_C0_FCCC_C0_0_FCCC   -   Actel:SgCore:FCCC:2.0.201
component FCCC_C0_FCCC_C0_0_FCCC
    -- Port list
    port(
        -- Inputs
        CLK0 : in  std_logic;
        -- Outputs
        GL0  : out std_logic;
        LOCK : out std_logic
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal GL0_net_0  : std_logic;
signal LOCK_net_0 : std_logic;
signal GL0_net_1  : std_logic;
signal LOCK_net_1 : std_logic;
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal GND_net    : std_logic;
signal PADDR_const_net_0: std_logic_vector(7 downto 2);
signal PWDATA_const_net_0: std_logic_vector(7 downto 0);

begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 GND_net            <= '0';
 PADDR_const_net_0  <= B"000000";
 PWDATA_const_net_0 <= B"00000000";
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 GL0_net_1  <= GL0_net_0;
 GL0        <= GL0_net_1;
 LOCK_net_1 <= LOCK_net_0;
 LOCK       <= LOCK_net_1;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- FCCC_C0_0   -   Actel:SgCore:FCCC:2.0.201
FCCC_C0_0 : FCCC_C0_FCCC_C0_0_FCCC
    port map( 
        -- Inputs
        CLK0 => CLK0,
        -- Outputs
        GL0  => GL0_net_0,
        LOCK => LOCK_net_0 
        );

end RTL;

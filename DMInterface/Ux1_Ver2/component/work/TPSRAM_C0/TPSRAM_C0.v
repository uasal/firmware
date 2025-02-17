//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Wed Nov 29 16:38:49 2023
// Version: 2023.2 2023.2.0.8
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////
// Component Description (Tcl) 
//////////////////////////////////////////////////////////////////////
/*
# Exporting Component Description of TPSRAM_C0 to TCL
# Family: SmartFusion2
# Part Number: M2S010-VF256
# Create and Configure the core component TPSRAM_C0
create_and_configure_core -core_vlnv {Actel:SgCore:TPSRAM:1.0.102} -component_name {TPSRAM_C0} -params {\
"A_DOUT_EN_PN:RD_EN"  \
"A_DOUT_EN_POLARITY:2"  \
"A_DOUT_SRST_PN:RD_SRST_N"  \
"A_DOUT_SRST_POLARITY:2"  \
"ARST_N_POLARITY:2"  \
"CASCADE:0"  \
"CLK_EDGE:RISE"  \
"CLKS:1"  \
"CLOCK_PN:CLK"  \
"DATA_IN_PN:WD"  \
"DATA_OUT_PN:RD"  \
"ECC:0"  \
"IMPORT_FILE:"  \
"INIT_RAM:F"  \
"LPMTYPE:LPM_RAM"  \
"PTYPE:1"  \
"RADDRESS_PN:RADDR"  \
"RCLK_EDGE:RISE"  \
"RCLOCK_PN:RCLK"  \
"RDEPTH:32"  \
"RE_PN:REN"  \
"RE_POLARITY:1"  \
"RESET_PN:ARST_N"  \
"RPMODE:0"  \
"RWIDTH:16"  \
"WADDRESS_PN:WADDR"  \
"WCLK_EDGE:RISE"  \
"WCLOCK_PN:WCLK"  \
"WDEPTH:32"  \
"WE_PN:WEN"  \
"WE_POLARITY:1"  \
"WWIDTH:16"   }
# Exporting Component Description of TPSRAM_C0 to TCL done
*/

// TPSRAM_C0
module TPSRAM_C0(
    // Inputs
    CLK,
    RADDR,
    REN,
    WADDR,
    WD,
    WEN,
    // Outputs
    RD
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input         CLK;
input  [4:0]  RADDR;
input         REN;
input  [4:0]  WADDR;
input  [15:0] WD;
input         WEN;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [15:0] RD;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          CLK;
wire   [4:0]  RADDR;
wire   [15:0] RD_net_0;
wire          REN;
wire   [4:0]  WADDR;
wire   [15:0] WD;
wire          WEN;
wire   [15:0] RD_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net = 1'b0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign RD_net_1 = RD_net_0;
assign RD[15:0] = RD_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------TPSRAM_C0_TPSRAM_C0_0_TPSRAM   -   Actel:SgCore:TPSRAM:1.0.102
TPSRAM_C0_TPSRAM_C0_0_TPSRAM TPSRAM_C0_0(
        // Inputs
        .WEN   ( WEN ),
        .REN   ( REN ),
        .CLK   ( CLK ),
        .WD    ( WD ),
        .WADDR ( WADDR ),
        .RADDR ( RADDR ),
        // Outputs
        .RD    ( RD_net_0 ) 
        );


endmodule

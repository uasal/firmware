//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Feb  3 10:29:02 2025
// Version: 2023.2 2023.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////
// Component Description (Tcl) 
//////////////////////////////////////////////////////////////////////
/*
# Exporting Component Description of COREFIFO_C0 to TCL
# Family: SmartFusion2
# Part Number: M2S010-VF256I
# Create and Configure the core component COREFIFO_C0
create_and_configure_core -core_vlnv {Actel:DirectCore:COREFIFO:3.1.101} -component_name {COREFIFO_C0} -params {\
"AE_STATIC_EN:false"  \
"AEVAL:4"  \
"AF_STATIC_EN:false"  \
"AFVAL:1020"  \
"CTRL_TYPE:1"  \
"DIE_SIZE:10"  \
"ECC:0"  \
"ESTOP:true"  \
"FSTOP:true"  \
"FWFT:false"  \
"NUM_STAGES:2"  \
"OVERFLOW_EN:false"  \
"PIPE:1"  \
"PREFETCH:false"  \
"RAM_OPT:0"  \
"RDCNT_EN:false"  \
"RDEPTH:1024"  \
"RE_POLARITY:0"  \
"READ_DVALID:false"  \
"RWIDTH:18"  \
"SYNC:0"  \
"SYNC_RESET:0"  \
"UNDERFLOW_EN:false"  \
"WDEPTH:1024"  \
"WE_POLARITY:0"  \
"WRCNT_EN:false"  \
"WRITE_ACK:false"  \
"WWIDTH:18"   }
# Exporting Component Description of COREFIFO_C0 to TCL done
*/

// COREFIFO_C0
module COREFIFO_C0(
    // Inputs
    DATA,
    RCLOCK,
    RE,
    RRESET_N,
    WCLOCK,
    WE,
    WRESET_N,
    // Outputs
    EMPTY,
    FULL,
    MEMRADDR,
    MEMRE,
    MEMWADDR,
    MEMWE,
    Q
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [17:0] DATA;
input         RCLOCK;
input         RE;
input         RRESET_N;
input         WCLOCK;
input         WE;
input         WRESET_N;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output        EMPTY;
output        FULL;
output [9:0]  MEMRADDR;
output        MEMRE;
output [9:0]  MEMWADDR;
output        MEMWE;
output [17:0] Q;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   [17:0] DATA;
wire          EMPTY_net_0;
wire          FULL_net_0;
wire   [9:0]  MEMRADDR_net_0;
wire          MEMRE_net_0;
wire   [9:0]  MEMWADDR_net_0;
wire          MEMWE_net_0;
wire   [17:0] Q_net_0;
wire          RCLOCK;
wire          RE;
wire          RRESET_N;
wire          WCLOCK;
wire          WE;
wire          WRESET_N;
wire          FULL_net_1;
wire          EMPTY_net_1;
wire          MEMWE_net_1;
wire          MEMRE_net_1;
wire   [17:0] Q_net_1;
wire   [9:0]  MEMWADDR_net_1;
wire   [9:0]  MEMRADDR_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
wire   [17:0] MEMRD_const_net_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net           = 1'b0;
assign MEMRD_const_net_0 = 18'h00000;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign FULL_net_1     = FULL_net_0;
assign FULL           = FULL_net_1;
assign EMPTY_net_1    = EMPTY_net_0;
assign EMPTY          = EMPTY_net_1;
assign MEMWE_net_1    = MEMWE_net_0;
assign MEMWE          = MEMWE_net_1;
assign MEMRE_net_1    = MEMRE_net_0;
assign MEMRE          = MEMRE_net_1;
assign Q_net_1        = Q_net_0;
assign Q[17:0]        = Q_net_1;
assign MEMWADDR_net_1 = MEMWADDR_net_0;
assign MEMWADDR[9:0]  = MEMWADDR_net_1;
assign MEMRADDR_net_1 = MEMRADDR_net_0;
assign MEMRADDR[9:0]  = MEMRADDR_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------COREFIFO_C0_COREFIFO_C0_0_COREFIFO   -   Actel:DirectCore:COREFIFO:3.1.101
COREFIFO_C0_COREFIFO_C0_0_COREFIFO #( 
        .AE_STATIC_EN ( 0 ),
        .AEVAL        ( 4 ),
        .AF_STATIC_EN ( 0 ),
        .AFVAL        ( 1020 ),
        .CTRL_TYPE    ( 1 ),
        .DIE_SIZE     ( 10 ),
        .ECC          ( 0 ),
        .ESTOP        ( 1 ),
        .FAMILY       ( 19 ),
        .FSTOP        ( 1 ),
        .FWFT         ( 0 ),
        .NUM_STAGES   ( 2 ),
        .OVERFLOW_EN  ( 0 ),
        .PIPE         ( 1 ),
        .PREFETCH     ( 0 ),
        .RAM_OPT      ( 0 ),
        .RDCNT_EN     ( 0 ),
        .RDEPTH       ( 1024 ),
        .RE_POLARITY  ( 0 ),
        .READ_DVALID  ( 0 ),
        .RWIDTH       ( 18 ),
        .SYNC         ( 0 ),
        .SYNC_RESET   ( 0 ),
        .UNDERFLOW_EN ( 0 ),
        .WDEPTH       ( 1024 ),
        .WE_POLARITY  ( 0 ),
        .WRCNT_EN     ( 0 ),
        .WRITE_ACK    ( 0 ),
        .WWIDTH       ( 18 ) )
COREFIFO_C0_0(
        // Inputs
        .CLK        ( GND_net ), // tied to 1'b0 from definition
        .WCLOCK     ( WCLOCK ),
        .RCLOCK     ( RCLOCK ),
        .RESET_N    ( GND_net ), // tied to 1'b0 from definition
        .WRESET_N   ( WRESET_N ),
        .RRESET_N   ( RRESET_N ),
        .WE         ( WE ),
        .RE         ( RE ),
        .DATA       ( DATA ),
        .MEMRD      ( MEMRD_const_net_0 ), // tied to 18'h00000 from definition
        // Outputs
        .FULL       ( FULL_net_0 ),
        .EMPTY      ( EMPTY_net_0 ),
        .AFULL      (  ),
        .AEMPTY     (  ),
        .OVERFLOW   (  ),
        .UNDERFLOW  (  ),
        .WACK       (  ),
        .DVLD       (  ),
        .MEMWE      ( MEMWE_net_0 ),
        .MEMRE      ( MEMRE_net_0 ),
        .SB_CORRECT (  ),
        .DB_DETECT  (  ),
        .Q          ( Q_net_0 ),
        .WRCNT      (  ),
        .RDCNT      (  ),
        .MEMWADDR   ( MEMWADDR_net_0 ),
        .MEMRADDR   ( MEMRADDR_net_0 ),
        .MEMWD      (  ) 
        );


endmodule

//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Dec  4 15:08:47 2023
// Version: 2023.2 2023.2.0.8
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////
// Component Description (Tcl) 
//////////////////////////////////////////////////////////////////////
/*
# Exporting Component Description of COREAPBLSRAM_C0 to TCL
# Family: SmartFusion2
# Part Number: M2S010-VF256
# Create and Configure the core component COREAPBLSRAM_C0
create_and_configure_core -core_vlnv {Actel:DirectCore:COREAPBLSRAM:3.0.101} -component_name {COREAPBLSRAM_C0} -params {\
"APB_DWIDTH:16"  \
"LSRAM_NUM_LOCATIONS_DWIDTH:2048"  \
"SEL_SRAM_TYPE:0"  \
"USRAM_NUM_LOCATIONS_DWIDTH:128"   }
# Exporting Component Description of COREAPBLSRAM_C0 to TCL done
*/

// COREAPBLSRAM_C0
module COREAPBLSRAM_C0(
    // Inputs
    PADDR,
    PCLK,
    PENABLE,
    PRESETN,
    PSEL,
    PWDATA,
    PWRITE,
    // Outputs
    PRDATA,
    PREADY,
    PSLVERR
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [19:0] PADDR;
input         PCLK;
input         PENABLE;
input         PRESETN;
input         PSEL;
input  [15:0] PWDATA;
input         PWRITE;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [15:0] PRDATA;
output        PREADY;
output        PSLVERR;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   [19:0] PADDR;
wire          PENABLE;
wire   [15:0] APBSlaveInterface_PRDATA;
wire          APBSlaveInterface_PREADY;
wire          PSEL;
wire          APBSlaveInterface_PSLVERR;
wire   [15:0] PWDATA;
wire          PWRITE;
wire          PCLK;
wire          PRESETN;
wire   [15:0] APBSlaveInterface_PRDATA_net_0;
wire          APBSlaveInterface_PREADY_net_0;
wire          APBSlaveInterface_PSLVERR_net_0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign APBSlaveInterface_PRDATA_net_0  = APBSlaveInterface_PRDATA;
assign PRDATA[15:0]                    = APBSlaveInterface_PRDATA_net_0;
assign APBSlaveInterface_PREADY_net_0  = APBSlaveInterface_PREADY;
assign PREADY                          = APBSlaveInterface_PREADY_net_0;
assign APBSlaveInterface_PSLVERR_net_0 = APBSlaveInterface_PSLVERR;
assign PSLVERR                         = APBSlaveInterface_PSLVERR_net_0;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------COREAPBLSRAM_C0_COREAPBLSRAM_C0_0_COREAPBLSRAM   -   Actel:DirectCore:COREAPBLSRAM:3.0.101
COREAPBLSRAM_C0_COREAPBLSRAM_C0_0_COREAPBLSRAM #( 
        .APB_DWIDTH                 ( 16 ),
        .FAMILY                     ( 19 ),
        .LSRAM_NUM_LOCATIONS_DWIDTH ( 2048 ),
        .SEL_SRAM_TYPE              ( 0 ),
        .USRAM_NUM_LOCATIONS_DWIDTH ( 128 ) )
COREAPBLSRAM_C0_0(
        // Inputs
        .PCLK    ( PCLK ),
        .PRESETN ( PRESETN ),
        .PSEL    ( PSEL ),
        .PENABLE ( PENABLE ),
        .PWRITE  ( PWRITE ),
        .PADDR   ( PADDR ),
        .PWDATA  ( PWDATA ),
        // Outputs
        .PSLVERR ( APBSlaveInterface_PSLVERR ),
        .PREADY  ( APBSlaveInterface_PREADY ),
        .PRDATA  ( APBSlaveInterface_PRDATA ) 
        );


endmodule

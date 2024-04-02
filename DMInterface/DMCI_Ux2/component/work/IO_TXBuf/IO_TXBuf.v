//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Tue Mar  5 16:35:53 2024
// Version: 2023.2 2023.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////
// Component Description (Tcl) 
//////////////////////////////////////////////////////////////////////
/*
# Exporting Component Description of IO_TXBuf to TCL
# Family: SmartFusion2
# Part Number: M2S025-1VF256I
# Create and Configure the core component IO_TXBuf
create_and_configure_core -core_vlnv {Actel:SgCore:IO:1.0.101} -component_name {IO_TXBuf} -params {\
"DIFF_IOSTD_OK:false"  \
"IO_TYPE:TRIBUFF"  \
"IOSTD:LVCMOS33"  \
"SINGLE_IOSTD_OK:true"  \
"VARIATION:SINGLE"  \
"WIDTH:1"   }
# Exporting Component Description of IO_TXBuf to TCL done
*/

// IO_TXBuf
module IO_TXBuf(
    // Inputs
    D,
    E,
    // Outputs
    PAD_TRI
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [0:0] D;
input  [0:0] E;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [0:0] PAD_TRI;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   [0:0] D;
wire   [0:0] E;
wire   [0:0] PAD_TRI_net_0;
wire   [0:0] PAD_TRI_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire         GND_net;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net    = 1'b0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign PAD_TRI_net_1[0] = PAD_TRI_net_0[0];
assign PAD_TRI[0:0]     = PAD_TRI_net_1[0];
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------IO_TXBuf_IO_TXBuf_0_IO   -   Actel:SgCore:IO:1.0.101
IO_TXBuf_IO_TXBuf_0_IO IO_TXBuf_0(
        // Inputs
        .D       ( D ),
        .E       ( E ),
        // Outputs
        .PAD_TRI ( PAD_TRI_net_0 ) 
        );


endmodule

//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Tue Feb 27 14:45:09 2024
// Version: 2023.2 2023.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////
// Component Description (Tcl) 
//////////////////////////////////////////////////////////////////////
/*
# Exporting Component Description of IO_nCsXO to TCL
# Family: SmartFusion2
# Part Number: M2S025-1VF256I
# Create and Configure the core component IO_nCsXO
create_and_configure_core -core_vlnv {Actel:SgCore:IO:1.0.101} -component_name {IO_nCsXO} -params {\
"DIFF_IOSTD_OK:false"  \
"IO_TYPE:OUTBUF"  \
"IOSTD:LVCMOS33"  \
"SINGLE_IOSTD_OK:true"  \
"VARIATION:SINGLE"  \
"WIDTH:1"   }
# Exporting Component Description of IO_nCsXO to TCL done
*/

// IO_nCsXO
module IO_nCsXO(
    // Inputs
    D,
    // Outputs
    PAD_OUT
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [0:0] D;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [0:0] PAD_OUT;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   [0:0] D;
wire   [0:0] PAD_OUT_net_0;
wire   [0:0] PAD_OUT_net_1;
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
assign PAD_OUT_net_1[0] = PAD_OUT_net_0[0];
assign PAD_OUT[0:0]     = PAD_OUT_net_1[0];
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------IO_nCsXO_IO_nCsXO_0_IO   -   Actel:SgCore:IO:1.0.101
IO_nCsXO_IO_nCsXO_0_IO IO_nCsXO_0(
        // Inputs
        .D       ( D ),
        // Outputs
        .PAD_OUT ( PAD_OUT_net_0 ) 
        );


endmodule

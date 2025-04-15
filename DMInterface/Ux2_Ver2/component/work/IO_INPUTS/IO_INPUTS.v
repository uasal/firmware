//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Feb 26 11:11:26 2024
// Version: 2023.2 2023.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////
// Component Description (Tcl) 
//////////////////////////////////////////////////////////////////////
/*
# Exporting Component Description of IO_INPUTS to TCL
# Family: SmartFusion2
# Part Number: M2S025-1VF256I
# Create and Configure the core component IO_INPUTS
create_and_configure_core -core_vlnv {Actel:SgCore:IO:1.0.101} -component_name {IO_INPUTS} -params {\
"DIFF_IOSTD_OK:false"  \
"IO_TYPE:OUTBUF"  \
"IOSTD:LVCMOS33"  \
"SINGLE_IOSTD_OK:true"  \
"VARIATION:SINGLE"  \
"WIDTH:4"   }
# Exporting Component Description of IO_INPUTS to TCL done
*/

// IO_INPUTS
module IO_INPUTS(
    // Inputs
    D,
    // Outputs
    PAD_OUT
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [3:0] D;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [3:0] PAD_OUT;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   [3:0] D;
wire   [3:0] PAD_OUT_net_0;
wire   [3:0] PAD_OUT_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire   [3:0] PAD_IN_const_net_0;
wire   [3:0] PAD_BI_const_net_0;
wire   [3:0] PADP_IN_const_net_0;
wire   [3:0] PADP_BI_const_net_0;
wire   [3:0] PADN_IN_const_net_0;
wire   [3:0] PADN_BI_const_net_0;
wire   [3:0] E_const_net_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign PAD_IN_const_net_0  = 4'h0;
assign PAD_BI_const_net_0  = 4'h0;
assign PADP_IN_const_net_0 = 4'h0;
assign PADP_BI_const_net_0 = 4'h0;
assign PADN_IN_const_net_0 = 4'h0;
assign PADN_BI_const_net_0 = 4'h0;
assign E_const_net_0       = 4'h0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign PAD_OUT_net_1 = PAD_OUT_net_0;
assign PAD_OUT[3:0]  = PAD_OUT_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------IO_INPUTS_IO_INPUTS_0_IO   -   Actel:SgCore:IO:1.0.101
IO_INPUTS_IO_INPUTS_0_IO IO_INPUTS_0(
        // Inputs
        .D       ( D ),
        // Outputs
        .PAD_OUT ( PAD_OUT_net_0 ) 
        );


endmodule

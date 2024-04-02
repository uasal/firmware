//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Feb 26 11:15:44 2024
// Version: 2023.2 2023.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////
// Component Description (Tcl) 
//////////////////////////////////////////////////////////////////////
/*
# Exporting Component Description of IO_OUTPUTS to TCL
# Family: SmartFusion2
# Part Number: M2S025-1VF256I
# Create and Configure the core component IO_OUTPUTS
create_and_configure_core -core_vlnv {Actel:SgCore:IO:1.0.101} -component_name {IO_OUTPUTS} -params {\
"DIFF_IOSTD_OK:false"  \
"IO_TYPE:INBUF"  \
"IOSTD:LVCMOS33"  \
"SINGLE_IOSTD_OK:true"  \
"VARIATION:SINGLE"  \
"WIDTH:9"   }
# Exporting Component Description of IO_OUTPUTS to TCL done
*/

// IO_OUTPUTS
module IO_OUTPUTS(
    // Inputs
    PAD_IN,
    // Outputs
    Y
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [8:0] PAD_IN;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [8:0] Y;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   [8:0] PAD_IN;
wire   [8:0] Y_net_0;
wire   [8:0] Y_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire   [8:0] PAD_BI_const_net_0;
wire   [8:0] PADP_IN_const_net_0;
wire   [8:0] PADP_BI_const_net_0;
wire   [8:0] PADN_IN_const_net_0;
wire   [8:0] PADN_BI_const_net_0;
wire   [8:0] D_const_net_0;
wire   [8:0] E_const_net_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign PAD_BI_const_net_0  = 9'h000;
assign PADP_IN_const_net_0 = 9'h000;
assign PADP_BI_const_net_0 = 9'h000;
assign PADN_IN_const_net_0 = 9'h000;
assign PADN_BI_const_net_0 = 9'h000;
assign D_const_net_0       = 9'h000;
assign E_const_net_0       = 9'h000;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign Y_net_1 = Y_net_0;
assign Y[8:0]  = Y_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------IO_OUTPUTS_IO_OUTPUTS_0_IO   -   Actel:SgCore:IO:1.0.101
IO_OUTPUTS_IO_OUTPUTS_0_IO IO_OUTPUTS_0(
        // Inputs
        .PAD_IN ( PAD_IN ),
        // Outputs
        .Y      ( Y_net_0 ) 
        );


endmodule

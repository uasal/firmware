//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Dec  4 14:12:38 2023
// Version: 2023.2 2023.2.0.8
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////
// Component Description (Tcl) 
//////////////////////////////////////////////////////////////////////
/*
# Exporting Component Description of CoreAHBLite_C0 to TCL
# Family: SmartFusion2
# Part Number: M2S010-VF256
# Create and Configure the core component CoreAHBLite_C0
create_and_configure_core -core_vlnv {Microchip:DirectCore:CoreAHBLite:6.0.101} -component_name {CoreAHBLite_C0} -params {\
"HADDR_SHG_CFG:1"  \
"M0_AHBSLOT0ENABLE:false"  \
"M0_AHBSLOT1ENABLE:false"  \
"M0_AHBSLOT2ENABLE:false"  \
"M0_AHBSLOT3ENABLE:false"  \
"M0_AHBSLOT4ENABLE:false"  \
"M0_AHBSLOT5ENABLE:false"  \
"M0_AHBSLOT6ENABLE:false"  \
"M0_AHBSLOT7ENABLE:false"  \
"M0_AHBSLOT8ENABLE:false"  \
"M0_AHBSLOT9ENABLE:false"  \
"M0_AHBSLOT10ENABLE:false"  \
"M0_AHBSLOT11ENABLE:false"  \
"M0_AHBSLOT12ENABLE:false"  \
"M0_AHBSLOT13ENABLE:false"  \
"M0_AHBSLOT14ENABLE:false"  \
"M0_AHBSLOT15ENABLE:false"  \
"M0_AHBSLOT16ENABLE:false"  \
"M1_AHBSLOT0ENABLE:false"  \
"M1_AHBSLOT1ENABLE:false"  \
"M1_AHBSLOT2ENABLE:false"  \
"M1_AHBSLOT3ENABLE:false"  \
"M1_AHBSLOT4ENABLE:false"  \
"M1_AHBSLOT5ENABLE:false"  \
"M1_AHBSLOT6ENABLE:false"  \
"M1_AHBSLOT7ENABLE:false"  \
"M1_AHBSLOT8ENABLE:false"  \
"M1_AHBSLOT9ENABLE:false"  \
"M1_AHBSLOT10ENABLE:false"  \
"M1_AHBSLOT11ENABLE:false"  \
"M1_AHBSLOT12ENABLE:false"  \
"M1_AHBSLOT13ENABLE:false"  \
"M1_AHBSLOT14ENABLE:false"  \
"M1_AHBSLOT15ENABLE:false"  \
"M1_AHBSLOT16ENABLE:false"  \
"M2_AHBSLOT0ENABLE:false"  \
"M2_AHBSLOT1ENABLE:false"  \
"M2_AHBSLOT2ENABLE:false"  \
"M2_AHBSLOT3ENABLE:false"  \
"M2_AHBSLOT4ENABLE:false"  \
"M2_AHBSLOT5ENABLE:false"  \
"M2_AHBSLOT6ENABLE:false"  \
"M2_AHBSLOT7ENABLE:false"  \
"M2_AHBSLOT8ENABLE:false"  \
"M2_AHBSLOT9ENABLE:false"  \
"M2_AHBSLOT10ENABLE:false"  \
"M2_AHBSLOT11ENABLE:false"  \
"M2_AHBSLOT12ENABLE:false"  \
"M2_AHBSLOT13ENABLE:false"  \
"M2_AHBSLOT14ENABLE:false"  \
"M2_AHBSLOT15ENABLE:false"  \
"M2_AHBSLOT16ENABLE:false"  \
"M3_AHBSLOT0ENABLE:false"  \
"M3_AHBSLOT1ENABLE:false"  \
"M3_AHBSLOT2ENABLE:false"  \
"M3_AHBSLOT3ENABLE:false"  \
"M3_AHBSLOT4ENABLE:false"  \
"M3_AHBSLOT5ENABLE:false"  \
"M3_AHBSLOT6ENABLE:false"  \
"M3_AHBSLOT7ENABLE:false"  \
"M3_AHBSLOT8ENABLE:false"  \
"M3_AHBSLOT9ENABLE:false"  \
"M3_AHBSLOT10ENABLE:false"  \
"M3_AHBSLOT11ENABLE:false"  \
"M3_AHBSLOT12ENABLE:false"  \
"M3_AHBSLOT13ENABLE:false"  \
"M3_AHBSLOT14ENABLE:false"  \
"M3_AHBSLOT15ENABLE:false"  \
"M3_AHBSLOT16ENABLE:false"  \
"MASTER0_INTERFACE:1"  \
"MASTER1_INTERFACE:1"  \
"MASTER2_INTERFACE:1"  \
"MASTER3_INTERFACE:1"  \
"MEMSPACE:1"  \
"SC_0:true"  \
"SC_1:false"  \
"SC_2:false"  \
"SC_3:false"  \
"SC_4:false"  \
"SC_5:false"  \
"SC_6:false"  \
"SC_7:false"  \
"SC_8:false"  \
"SC_9:false"  \
"SC_10:false"  \
"SC_11:false"  \
"SC_12:false"  \
"SC_13:false"  \
"SC_14:false"  \
"SC_15:false"  \
"SLAVE0_INTERFACE:1"  \
"SLAVE1_INTERFACE:1"  \
"SLAVE2_INTERFACE:1"  \
"SLAVE3_INTERFACE:1"  \
"SLAVE4_INTERFACE:1"  \
"SLAVE5_INTERFACE:1"  \
"SLAVE6_INTERFACE:1"  \
"SLAVE7_INTERFACE:1"  \
"SLAVE8_INTERFACE:1"  \
"SLAVE9_INTERFACE:1"  \
"SLAVE10_INTERFACE:1"  \
"SLAVE11_INTERFACE:1"  \
"SLAVE12_INTERFACE:1"  \
"SLAVE13_INTERFACE:1"  \
"SLAVE14_INTERFACE:1"  \
"SLAVE15_INTERFACE:1"  \
"SLAVE16_INTERFACE:1"  \
"SYNC_RESET:0"   }
# Exporting Component Description of CoreAHBLite_C0 to TCL done
*/

// CoreAHBLite_C0
module CoreAHBLite_C0(
    // Inputs
    HCLK,
    HRESETN,
    REMAP_M0
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  HCLK;
input  HRESETN;
input  REMAP_M0;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   HCLK;
wire   HRESETN;
wire   REMAP_M0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire   [31:0]HADDR_M0_const_net_0;
wire   [1:0]HTRANS_M0_const_net_0;
wire   GND_net;
wire   [2:0]HSIZE_M0_const_net_0;
wire   [2:0]HBURST_M0_const_net_0;
wire   [3:0]HPROT_M0_const_net_0;
wire   [31:0]HWDATA_M0_const_net_0;
wire   [31:0]HADDR_M1_const_net_0;
wire   [1:0]HTRANS_M1_const_net_0;
wire   [2:0]HSIZE_M1_const_net_0;
wire   [2:0]HBURST_M1_const_net_0;
wire   [3:0]HPROT_M1_const_net_0;
wire   [31:0]HWDATA_M1_const_net_0;
wire   [31:0]HADDR_M2_const_net_0;
wire   [1:0]HTRANS_M2_const_net_0;
wire   [2:0]HSIZE_M2_const_net_0;
wire   [2:0]HBURST_M2_const_net_0;
wire   [3:0]HPROT_M2_const_net_0;
wire   [31:0]HWDATA_M2_const_net_0;
wire   [31:0]HADDR_M3_const_net_0;
wire   [1:0]HTRANS_M3_const_net_0;
wire   [2:0]HSIZE_M3_const_net_0;
wire   [2:0]HBURST_M3_const_net_0;
wire   [3:0]HPROT_M3_const_net_0;
wire   [31:0]HWDATA_M3_const_net_0;
wire   [31:0]HRDATA_S0_const_net_0;
wire   [1:0]HRESP_S0_const_net_0;
wire   VCC_net;
wire   [31:0]HRDATA_S1_const_net_0;
wire   [1:0]HRESP_S1_const_net_0;
wire   [31:0]HRDATA_S2_const_net_0;
wire   [1:0]HRESP_S2_const_net_0;
wire   [31:0]HRDATA_S3_const_net_0;
wire   [1:0]HRESP_S3_const_net_0;
wire   [31:0]HRDATA_S4_const_net_0;
wire   [1:0]HRESP_S4_const_net_0;
wire   [31:0]HRDATA_S5_const_net_0;
wire   [1:0]HRESP_S5_const_net_0;
wire   [31:0]HRDATA_S6_const_net_0;
wire   [1:0]HRESP_S6_const_net_0;
wire   [31:0]HRDATA_S7_const_net_0;
wire   [1:0]HRESP_S7_const_net_0;
wire   [31:0]HRDATA_S8_const_net_0;
wire   [1:0]HRESP_S8_const_net_0;
wire   [31:0]HRDATA_S9_const_net_0;
wire   [1:0]HRESP_S9_const_net_0;
wire   [31:0]HRDATA_S10_const_net_0;
wire   [1:0]HRESP_S10_const_net_0;
wire   [31:0]HRDATA_S11_const_net_0;
wire   [1:0]HRESP_S11_const_net_0;
wire   [31:0]HRDATA_S12_const_net_0;
wire   [1:0]HRESP_S12_const_net_0;
wire   [31:0]HRDATA_S13_const_net_0;
wire   [1:0]HRESP_S13_const_net_0;
wire   [31:0]HRDATA_S14_const_net_0;
wire   [1:0]HRESP_S14_const_net_0;
wire   [31:0]HRDATA_S15_const_net_0;
wire   [1:0]HRESP_S15_const_net_0;
wire   [31:0]HRDATA_S16_const_net_0;
wire   [1:0]HRESP_S16_const_net_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign HADDR_M0_const_net_0   = 32'h00000000;
assign HTRANS_M0_const_net_0  = 2'h0;
assign GND_net                = 1'b0;
assign HSIZE_M0_const_net_0   = 3'h0;
assign HBURST_M0_const_net_0  = 3'h0;
assign HPROT_M0_const_net_0   = 4'h0;
assign HWDATA_M0_const_net_0  = 32'h00000000;
assign HADDR_M1_const_net_0   = 32'h00000000;
assign HTRANS_M1_const_net_0  = 2'h0;
assign HSIZE_M1_const_net_0   = 3'h0;
assign HBURST_M1_const_net_0  = 3'h0;
assign HPROT_M1_const_net_0   = 4'h0;
assign HWDATA_M1_const_net_0  = 32'h00000000;
assign HADDR_M2_const_net_0   = 32'h00000000;
assign HTRANS_M2_const_net_0  = 2'h0;
assign HSIZE_M2_const_net_0   = 3'h0;
assign HBURST_M2_const_net_0  = 3'h0;
assign HPROT_M2_const_net_0   = 4'h0;
assign HWDATA_M2_const_net_0  = 32'h00000000;
assign HADDR_M3_const_net_0   = 32'h00000000;
assign HTRANS_M3_const_net_0  = 2'h0;
assign HSIZE_M3_const_net_0   = 3'h0;
assign HBURST_M3_const_net_0  = 3'h0;
assign HPROT_M3_const_net_0   = 4'h0;
assign HWDATA_M3_const_net_0  = 32'h00000000;
assign HRDATA_S0_const_net_0  = 32'h00000000;
assign HRESP_S0_const_net_0   = 2'h0;
assign VCC_net                = 1'b1;
assign HRDATA_S1_const_net_0  = 32'h00000000;
assign HRESP_S1_const_net_0   = 2'h0;
assign HRDATA_S2_const_net_0  = 32'h00000000;
assign HRESP_S2_const_net_0   = 2'h0;
assign HRDATA_S3_const_net_0  = 32'h00000000;
assign HRESP_S3_const_net_0   = 2'h0;
assign HRDATA_S4_const_net_0  = 32'h00000000;
assign HRESP_S4_const_net_0   = 2'h0;
assign HRDATA_S5_const_net_0  = 32'h00000000;
assign HRESP_S5_const_net_0   = 2'h0;
assign HRDATA_S6_const_net_0  = 32'h00000000;
assign HRESP_S6_const_net_0   = 2'h0;
assign HRDATA_S7_const_net_0  = 32'h00000000;
assign HRESP_S7_const_net_0   = 2'h0;
assign HRDATA_S8_const_net_0  = 32'h00000000;
assign HRESP_S8_const_net_0   = 2'h0;
assign HRDATA_S9_const_net_0  = 32'h00000000;
assign HRESP_S9_const_net_0   = 2'h0;
assign HRDATA_S10_const_net_0 = 32'h00000000;
assign HRESP_S10_const_net_0  = 2'h0;
assign HRDATA_S11_const_net_0 = 32'h00000000;
assign HRESP_S11_const_net_0  = 2'h0;
assign HRDATA_S12_const_net_0 = 32'h00000000;
assign HRESP_S12_const_net_0  = 2'h0;
assign HRDATA_S13_const_net_0 = 32'h00000000;
assign HRESP_S13_const_net_0  = 2'h0;
assign HRDATA_S14_const_net_0 = 32'h00000000;
assign HRESP_S14_const_net_0  = 2'h0;
assign HRDATA_S15_const_net_0 = 32'h00000000;
assign HRESP_S15_const_net_0  = 2'h0;
assign HRDATA_S16_const_net_0 = 32'h00000000;
assign HRESP_S16_const_net_0  = 2'h0;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------CoreAHBLite_C0_CoreAHBLite_C0_0_CoreAHBLite   -   Microchip:DirectCore:CoreAHBLite:6.0.101
CoreAHBLite_C0_CoreAHBLite_C0_0_CoreAHBLite #( 
        .HADDR_SHG_CFG      ( 1 ),
        .M0_AHBSLOT0ENABLE  ( 0 ),
        .M0_AHBSLOT1ENABLE  ( 0 ),
        .M0_AHBSLOT2ENABLE  ( 0 ),
        .M0_AHBSLOT3ENABLE  ( 0 ),
        .M0_AHBSLOT4ENABLE  ( 0 ),
        .M0_AHBSLOT5ENABLE  ( 0 ),
        .M0_AHBSLOT6ENABLE  ( 0 ),
        .M0_AHBSLOT7ENABLE  ( 0 ),
        .M0_AHBSLOT8ENABLE  ( 0 ),
        .M0_AHBSLOT9ENABLE  ( 0 ),
        .M0_AHBSLOT10ENABLE ( 0 ),
        .M0_AHBSLOT11ENABLE ( 0 ),
        .M0_AHBSLOT12ENABLE ( 0 ),
        .M0_AHBSLOT13ENABLE ( 0 ),
        .M0_AHBSLOT14ENABLE ( 0 ),
        .M0_AHBSLOT15ENABLE ( 0 ),
        .M0_AHBSLOT16ENABLE ( 0 ),
        .M1_AHBSLOT0ENABLE  ( 0 ),
        .M1_AHBSLOT1ENABLE  ( 0 ),
        .M1_AHBSLOT2ENABLE  ( 0 ),
        .M1_AHBSLOT3ENABLE  ( 0 ),
        .M1_AHBSLOT4ENABLE  ( 0 ),
        .M1_AHBSLOT5ENABLE  ( 0 ),
        .M1_AHBSLOT6ENABLE  ( 0 ),
        .M1_AHBSLOT7ENABLE  ( 0 ),
        .M1_AHBSLOT8ENABLE  ( 0 ),
        .M1_AHBSLOT9ENABLE  ( 0 ),
        .M1_AHBSLOT10ENABLE ( 0 ),
        .M1_AHBSLOT11ENABLE ( 0 ),
        .M1_AHBSLOT12ENABLE ( 0 ),
        .M1_AHBSLOT13ENABLE ( 0 ),
        .M1_AHBSLOT14ENABLE ( 0 ),
        .M1_AHBSLOT15ENABLE ( 0 ),
        .M1_AHBSLOT16ENABLE ( 0 ),
        .M2_AHBSLOT0ENABLE  ( 0 ),
        .M2_AHBSLOT1ENABLE  ( 0 ),
        .M2_AHBSLOT2ENABLE  ( 0 ),
        .M2_AHBSLOT3ENABLE  ( 0 ),
        .M2_AHBSLOT4ENABLE  ( 0 ),
        .M2_AHBSLOT5ENABLE  ( 0 ),
        .M2_AHBSLOT6ENABLE  ( 0 ),
        .M2_AHBSLOT7ENABLE  ( 0 ),
        .M2_AHBSLOT8ENABLE  ( 0 ),
        .M2_AHBSLOT9ENABLE  ( 0 ),
        .M2_AHBSLOT10ENABLE ( 0 ),
        .M2_AHBSLOT11ENABLE ( 0 ),
        .M2_AHBSLOT12ENABLE ( 0 ),
        .M2_AHBSLOT13ENABLE ( 0 ),
        .M2_AHBSLOT14ENABLE ( 0 ),
        .M2_AHBSLOT15ENABLE ( 0 ),
        .M2_AHBSLOT16ENABLE ( 0 ),
        .M3_AHBSLOT0ENABLE  ( 0 ),
        .M3_AHBSLOT1ENABLE  ( 0 ),
        .M3_AHBSLOT2ENABLE  ( 0 ),
        .M3_AHBSLOT3ENABLE  ( 0 ),
        .M3_AHBSLOT4ENABLE  ( 0 ),
        .M3_AHBSLOT5ENABLE  ( 0 ),
        .M3_AHBSLOT6ENABLE  ( 0 ),
        .M3_AHBSLOT7ENABLE  ( 0 ),
        .M3_AHBSLOT8ENABLE  ( 0 ),
        .M3_AHBSLOT9ENABLE  ( 0 ),
        .M3_AHBSLOT10ENABLE ( 0 ),
        .M3_AHBSLOT11ENABLE ( 0 ),
        .M3_AHBSLOT12ENABLE ( 0 ),
        .M3_AHBSLOT13ENABLE ( 0 ),
        .M3_AHBSLOT14ENABLE ( 0 ),
        .M3_AHBSLOT15ENABLE ( 0 ),
        .M3_AHBSLOT16ENABLE ( 0 ),
        .MASTER0_INTERFACE  ( 1 ),
        .MASTER1_INTERFACE  ( 1 ),
        .MASTER2_INTERFACE  ( 1 ),
        .MASTER3_INTERFACE  ( 1 ),
        .MEMSPACE           ( 1 ),
        .SC_0               ( 1 ),
        .SC_1               ( 0 ),
        .SC_2               ( 0 ),
        .SC_3               ( 0 ),
        .SC_4               ( 0 ),
        .SC_5               ( 0 ),
        .SC_6               ( 0 ),
        .SC_7               ( 0 ),
        .SC_8               ( 0 ),
        .SC_9               ( 0 ),
        .SC_10              ( 0 ),
        .SC_11              ( 0 ),
        .SC_12              ( 0 ),
        .SC_13              ( 0 ),
        .SC_14              ( 0 ),
        .SC_15              ( 0 ),
        .SLAVE0_INTERFACE   ( 1 ),
        .SLAVE1_INTERFACE   ( 1 ),
        .SLAVE2_INTERFACE   ( 1 ),
        .SLAVE3_INTERFACE   ( 1 ),
        .SLAVE4_INTERFACE   ( 1 ),
        .SLAVE5_INTERFACE   ( 1 ),
        .SLAVE6_INTERFACE   ( 1 ),
        .SLAVE7_INTERFACE   ( 1 ),
        .SLAVE8_INTERFACE   ( 1 ),
        .SLAVE9_INTERFACE   ( 1 ),
        .SLAVE10_INTERFACE  ( 1 ),
        .SLAVE11_INTERFACE  ( 1 ),
        .SLAVE12_INTERFACE  ( 1 ),
        .SLAVE13_INTERFACE  ( 1 ),
        .SLAVE14_INTERFACE  ( 1 ),
        .SLAVE15_INTERFACE  ( 1 ),
        .SLAVE16_INTERFACE  ( 1 ),
        .SYNC_RESET         ( 0 ) )
CoreAHBLite_C0_0(
        // Inputs
        .HCLK          ( HCLK ),
        .HRESETN       ( HRESETN ),
        .REMAP_M0      ( REMAP_M0 ),
        .HADDR_M0      ( HADDR_M0_const_net_0 ), // tied to 32'h00000000 from definition
        .HMASTLOCK_M0  ( GND_net ), // tied to 1'b0 from definition
        .HSIZE_M0      ( HSIZE_M0_const_net_0 ), // tied to 3'h0 from definition
        .HTRANS_M0     ( HTRANS_M0_const_net_0 ), // tied to 2'h0 from definition
        .HWRITE_M0     ( GND_net ), // tied to 1'b0 from definition
        .HWDATA_M0     ( HWDATA_M0_const_net_0 ), // tied to 32'h00000000 from definition
        .HBURST_M0     ( HBURST_M0_const_net_0 ), // tied to 3'h0 from definition
        .HPROT_M0      ( HPROT_M0_const_net_0 ), // tied to 4'h0 from definition
        .HADDR_M1      ( HADDR_M1_const_net_0 ), // tied to 32'h00000000 from definition
        .HMASTLOCK_M1  ( GND_net ), // tied to 1'b0 from definition
        .HSIZE_M1      ( HSIZE_M1_const_net_0 ), // tied to 3'h0 from definition
        .HTRANS_M1     ( HTRANS_M1_const_net_0 ), // tied to 2'h0 from definition
        .HWRITE_M1     ( GND_net ), // tied to 1'b0 from definition
        .HWDATA_M1     ( HWDATA_M1_const_net_0 ), // tied to 32'h00000000 from definition
        .HBURST_M1     ( HBURST_M1_const_net_0 ), // tied to 3'h0 from definition
        .HPROT_M1      ( HPROT_M1_const_net_0 ), // tied to 4'h0 from definition
        .HADDR_M2      ( HADDR_M2_const_net_0 ), // tied to 32'h00000000 from definition
        .HMASTLOCK_M2  ( GND_net ), // tied to 1'b0 from definition
        .HSIZE_M2      ( HSIZE_M2_const_net_0 ), // tied to 3'h0 from definition
        .HTRANS_M2     ( HTRANS_M2_const_net_0 ), // tied to 2'h0 from definition
        .HWRITE_M2     ( GND_net ), // tied to 1'b0 from definition
        .HWDATA_M2     ( HWDATA_M2_const_net_0 ), // tied to 32'h00000000 from definition
        .HBURST_M2     ( HBURST_M2_const_net_0 ), // tied to 3'h0 from definition
        .HPROT_M2      ( HPROT_M2_const_net_0 ), // tied to 4'h0 from definition
        .HADDR_M3      ( HADDR_M3_const_net_0 ), // tied to 32'h00000000 from definition
        .HMASTLOCK_M3  ( GND_net ), // tied to 1'b0 from definition
        .HSIZE_M3      ( HSIZE_M3_const_net_0 ), // tied to 3'h0 from definition
        .HTRANS_M3     ( HTRANS_M3_const_net_0 ), // tied to 2'h0 from definition
        .HWRITE_M3     ( GND_net ), // tied to 1'b0 from definition
        .HWDATA_M3     ( HWDATA_M3_const_net_0 ), // tied to 32'h00000000 from definition
        .HBURST_M3     ( HBURST_M3_const_net_0 ), // tied to 3'h0 from definition
        .HPROT_M3      ( HPROT_M3_const_net_0 ), // tied to 4'h0 from definition
        .HRDATA_S0     ( HRDATA_S0_const_net_0 ), // tied to 32'h00000000 from definition
        .HREADYOUT_S0  ( VCC_net ), // tied to 1'b1 from definition
        .HRESP_S0      ( HRESP_S0_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S1     ( HRDATA_S1_const_net_0 ), // tied to 32'h00000000 from definition
        .HREADYOUT_S1  ( VCC_net ), // tied to 1'b1 from definition
        .HRESP_S1      ( HRESP_S1_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S2     ( HRDATA_S2_const_net_0 ), // tied to 32'h00000000 from definition
        .HREADYOUT_S2  ( VCC_net ), // tied to 1'b1 from definition
        .HRESP_S2      ( HRESP_S2_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S3     ( HRDATA_S3_const_net_0 ), // tied to 32'h00000000 from definition
        .HREADYOUT_S3  ( VCC_net ), // tied to 1'b1 from definition
        .HRESP_S3      ( HRESP_S3_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S4     ( HRDATA_S4_const_net_0 ), // tied to 32'h00000000 from definition
        .HREADYOUT_S4  ( VCC_net ), // tied to 1'b1 from definition
        .HRESP_S4      ( HRESP_S4_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S5     ( HRDATA_S5_const_net_0 ), // tied to 32'h00000000 from definition
        .HREADYOUT_S5  ( VCC_net ), // tied to 1'b1 from definition
        .HRESP_S5      ( HRESP_S5_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S6     ( HRDATA_S6_const_net_0 ), // tied to 32'h00000000 from definition
        .HREADYOUT_S6  ( VCC_net ), // tied to 1'b1 from definition
        .HRESP_S6      ( HRESP_S6_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S7     ( HRDATA_S7_const_net_0 ), // tied to 32'h00000000 from definition
        .HREADYOUT_S7  ( VCC_net ), // tied to 1'b1 from definition
        .HRESP_S7      ( HRESP_S7_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S8     ( HRDATA_S8_const_net_0 ), // tied to 32'h00000000 from definition
        .HREADYOUT_S8  ( VCC_net ), // tied to 1'b1 from definition
        .HRESP_S8      ( HRESP_S8_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S9     ( HRDATA_S9_const_net_0 ), // tied to 32'h00000000 from definition
        .HREADYOUT_S9  ( VCC_net ), // tied to 1'b1 from definition
        .HRESP_S9      ( HRESP_S9_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S10    ( HRDATA_S10_const_net_0 ), // tied to 32'h00000000 from definition
        .HREADYOUT_S10 ( VCC_net ), // tied to 1'b1 from definition
        .HRESP_S10     ( HRESP_S10_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S11    ( HRDATA_S11_const_net_0 ), // tied to 32'h00000000 from definition
        .HREADYOUT_S11 ( VCC_net ), // tied to 1'b1 from definition
        .HRESP_S11     ( HRESP_S11_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S12    ( HRDATA_S12_const_net_0 ), // tied to 32'h00000000 from definition
        .HREADYOUT_S12 ( VCC_net ), // tied to 1'b1 from definition
        .HRESP_S12     ( HRESP_S12_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S13    ( HRDATA_S13_const_net_0 ), // tied to 32'h00000000 from definition
        .HREADYOUT_S13 ( VCC_net ), // tied to 1'b1 from definition
        .HRESP_S13     ( HRESP_S13_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S14    ( HRDATA_S14_const_net_0 ), // tied to 32'h00000000 from definition
        .HREADYOUT_S14 ( VCC_net ), // tied to 1'b1 from definition
        .HRESP_S14     ( HRESP_S14_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S15    ( HRDATA_S15_const_net_0 ), // tied to 32'h00000000 from definition
        .HREADYOUT_S15 ( VCC_net ), // tied to 1'b1 from definition
        .HRESP_S15     ( HRESP_S15_const_net_0 ), // tied to 2'h0 from definition
        .HRDATA_S16    ( HRDATA_S16_const_net_0 ), // tied to 32'h00000000 from definition
        .HREADYOUT_S16 ( VCC_net ), // tied to 1'b1 from definition
        .HRESP_S16     ( HRESP_S16_const_net_0 ), // tied to 2'h0 from definition
        // Outputs
        .HRESP_M0      (  ),
        .HRDATA_M0     (  ),
        .HREADY_M0     (  ),
        .HRESP_M1      (  ),
        .HRDATA_M1     (  ),
        .HREADY_M1     (  ),
        .HRESP_M2      (  ),
        .HRDATA_M2     (  ),
        .HREADY_M2     (  ),
        .HRESP_M3      (  ),
        .HRDATA_M3     (  ),
        .HREADY_M3     (  ),
        .HSEL_S0       (  ),
        .HADDR_S0      (  ),
        .HSIZE_S0      (  ),
        .HTRANS_S0     (  ),
        .HWRITE_S0     (  ),
        .HWDATA_S0     (  ),
        .HREADY_S0     (  ),
        .HMASTLOCK_S0  (  ),
        .HBURST_S0     (  ),
        .HPROT_S0      (  ),
        .HSEL_S1       (  ),
        .HADDR_S1      (  ),
        .HSIZE_S1      (  ),
        .HTRANS_S1     (  ),
        .HWRITE_S1     (  ),
        .HWDATA_S1     (  ),
        .HREADY_S1     (  ),
        .HMASTLOCK_S1  (  ),
        .HBURST_S1     (  ),
        .HPROT_S1      (  ),
        .HSEL_S2       (  ),
        .HADDR_S2      (  ),
        .HSIZE_S2      (  ),
        .HTRANS_S2     (  ),
        .HWRITE_S2     (  ),
        .HWDATA_S2     (  ),
        .HREADY_S2     (  ),
        .HMASTLOCK_S2  (  ),
        .HBURST_S2     (  ),
        .HPROT_S2      (  ),
        .HSEL_S3       (  ),
        .HADDR_S3      (  ),
        .HSIZE_S3      (  ),
        .HTRANS_S3     (  ),
        .HWRITE_S3     (  ),
        .HWDATA_S3     (  ),
        .HREADY_S3     (  ),
        .HMASTLOCK_S3  (  ),
        .HBURST_S3     (  ),
        .HPROT_S3      (  ),
        .HSEL_S4       (  ),
        .HADDR_S4      (  ),
        .HSIZE_S4      (  ),
        .HTRANS_S4     (  ),
        .HWRITE_S4     (  ),
        .HWDATA_S4     (  ),
        .HREADY_S4     (  ),
        .HMASTLOCK_S4  (  ),
        .HBURST_S4     (  ),
        .HPROT_S4      (  ),
        .HSEL_S5       (  ),
        .HADDR_S5      (  ),
        .HSIZE_S5      (  ),
        .HTRANS_S5     (  ),
        .HWRITE_S5     (  ),
        .HWDATA_S5     (  ),
        .HREADY_S5     (  ),
        .HMASTLOCK_S5  (  ),
        .HBURST_S5     (  ),
        .HPROT_S5      (  ),
        .HSEL_S6       (  ),
        .HADDR_S6      (  ),
        .HSIZE_S6      (  ),
        .HTRANS_S6     (  ),
        .HWRITE_S6     (  ),
        .HWDATA_S6     (  ),
        .HREADY_S6     (  ),
        .HMASTLOCK_S6  (  ),
        .HBURST_S6     (  ),
        .HPROT_S6      (  ),
        .HSEL_S7       (  ),
        .HADDR_S7      (  ),
        .HSIZE_S7      (  ),
        .HTRANS_S7     (  ),
        .HWRITE_S7     (  ),
        .HWDATA_S7     (  ),
        .HREADY_S7     (  ),
        .HMASTLOCK_S7  (  ),
        .HBURST_S7     (  ),
        .HPROT_S7      (  ),
        .HSEL_S8       (  ),
        .HADDR_S8      (  ),
        .HSIZE_S8      (  ),
        .HTRANS_S8     (  ),
        .HWRITE_S8     (  ),
        .HWDATA_S8     (  ),
        .HREADY_S8     (  ),
        .HMASTLOCK_S8  (  ),
        .HBURST_S8     (  ),
        .HPROT_S8      (  ),
        .HSEL_S9       (  ),
        .HADDR_S9      (  ),
        .HSIZE_S9      (  ),
        .HTRANS_S9     (  ),
        .HWRITE_S9     (  ),
        .HWDATA_S9     (  ),
        .HREADY_S9     (  ),
        .HMASTLOCK_S9  (  ),
        .HBURST_S9     (  ),
        .HPROT_S9      (  ),
        .HSEL_S10      (  ),
        .HADDR_S10     (  ),
        .HSIZE_S10     (  ),
        .HTRANS_S10    (  ),
        .HWRITE_S10    (  ),
        .HWDATA_S10    (  ),
        .HREADY_S10    (  ),
        .HMASTLOCK_S10 (  ),
        .HBURST_S10    (  ),
        .HPROT_S10     (  ),
        .HSEL_S11      (  ),
        .HADDR_S11     (  ),
        .HSIZE_S11     (  ),
        .HTRANS_S11    (  ),
        .HWRITE_S11    (  ),
        .HWDATA_S11    (  ),
        .HREADY_S11    (  ),
        .HMASTLOCK_S11 (  ),
        .HBURST_S11    (  ),
        .HPROT_S11     (  ),
        .HSEL_S12      (  ),
        .HADDR_S12     (  ),
        .HSIZE_S12     (  ),
        .HTRANS_S12    (  ),
        .HWRITE_S12    (  ),
        .HWDATA_S12    (  ),
        .HREADY_S12    (  ),
        .HMASTLOCK_S12 (  ),
        .HBURST_S12    (  ),
        .HPROT_S12     (  ),
        .HSEL_S13      (  ),
        .HADDR_S13     (  ),
        .HSIZE_S13     (  ),
        .HTRANS_S13    (  ),
        .HWRITE_S13    (  ),
        .HWDATA_S13    (  ),
        .HREADY_S13    (  ),
        .HMASTLOCK_S13 (  ),
        .HBURST_S13    (  ),
        .HPROT_S13     (  ),
        .HSEL_S14      (  ),
        .HADDR_S14     (  ),
        .HSIZE_S14     (  ),
        .HTRANS_S14    (  ),
        .HWRITE_S14    (  ),
        .HWDATA_S14    (  ),
        .HREADY_S14    (  ),
        .HMASTLOCK_S14 (  ),
        .HBURST_S14    (  ),
        .HPROT_S14     (  ),
        .HSEL_S15      (  ),
        .HADDR_S15     (  ),
        .HSIZE_S15     (  ),
        .HTRANS_S15    (  ),
        .HWRITE_S15    (  ),
        .HWDATA_S15    (  ),
        .HREADY_S15    (  ),
        .HMASTLOCK_S15 (  ),
        .HBURST_S15    (  ),
        .HPROT_S15     (  ),
        .HSEL_S16      (  ),
        .HADDR_S16     (  ),
        .HSIZE_S16     (  ),
        .HTRANS_S16    (  ),
        .HWRITE_S16    (  ),
        .HWDATA_S16    (  ),
        .HREADY_S16    (  ),
        .HMASTLOCK_S16 (  ),
        .HBURST_S16    (  ),
        .HPROT_S16     (  ) 
        );


endmodule

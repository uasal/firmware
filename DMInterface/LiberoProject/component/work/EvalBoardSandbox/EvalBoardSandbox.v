//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Fri Mar 29 14:02:51 2024
// Version: 2023.2 2023.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// EvalBoardSandbox
module EvalBoardSandbox(
    // Inputs
    CLK0,
    DEVRST_N,
    MisoA,
    MisoB,
    MisoC,
    MisoD,
    MisoE,
    MisoF,
    PAD_IN,
    RX,
    // Outputs
    MosiA,
    MosiB,
    MosiC,
    MosiD,
    MosiE,
    MosiF,
    PAD_OUT,
    SckA,
    SckB,
    SckC,
    SckD,
    SckE,
    SckF,
    TX,
    debug,
    nCsA,
    nCsB,
    nCsC,
    nCsD,
    nCsE,
    nCsF
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input        CLK0;
input        DEVRST_N;
input        MisoA;
input        MisoB;
input        MisoC;
input        MisoD;
input        MisoE;
input        MisoF;
input  [0:0] PAD_IN;
input        RX;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output       MosiA;
output       MosiB;
output       MosiC;
output       MosiD;
output       MosiE;
output       MosiF;
output [3:0] PAD_OUT;
output       SckA;
output       SckB;
output       SckC;
output       SckD;
output       SckE;
output       SckF;
output [0:0] TX;
output [8:1] debug;
output [3:0] nCsA;
output [3:0] nCsB;
output [3:0] nCsC;
output [3:0] nCsD;
output [3:0] nCsE;
output [3:0] nCsF;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          CLK0;
wire          CoreUARTapb_C0_0_RXRDY;
wire          CoreUARTapb_C0_0_TX;
wire          CoreUARTapb_C0_0_TXRDY;
wire   [0:0]  debug_net_0;
wire          debug_0;
wire   [0:0]  debug_1;
wire   [1:1]  debug_2;
wire          debug_3;
wire          DEVRST_N;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PENABLE;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PREADY;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PSELx;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PSLVERR;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PWRITE;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PADDR;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PENABLE;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PREADY;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PSELx;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PWDATA;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PWRITE;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PADDR;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PENABLE;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PREADY;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PSELx;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PWDATA;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PWRITE;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PADDR;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PENABLE;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PREADY;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PSELx;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PWDATA;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PWRITE;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PADDR;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PENABLE;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PREADY;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PSELx;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PWDATA;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PWRITE;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PADDR;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PENABLE;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PREADY;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PSELx;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PWDATA;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PWRITE;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PADDR;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PENABLE;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PREADY;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PSELx;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PWDATA;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PWRITE;
wire          EvalSandbox_MSS_0_FIC_0_CLK;
wire          EvalSandbox_MSS_0_GPIO_1_M2F;
wire          EvalSandbox_MSS_0_GPIO_3_M2F;
wire          EvalSandbox_MSS_0_GPIO_5_M2F;
wire          EvalSandbox_MSS_0_GPIO_6_M2F;
wire   [0:0]  IO_C1_0_Y;
wire          MisoA;
wire          MisoB;
wire          MisoC;
wire          MisoD;
wire          MisoE;
wire          MisoF;
wire          MosiA_net_0;
wire          MosiB_net_0;
wire          MosiC_net_0;
wire          MosiD_net_0;
wire          MosiE_net_0;
wire          MosiF_net_0;
wire   [3:0]  nCsA_net_0;
wire   [3:0]  nCsB_net_0;
wire   [3:0]  nCsC_net_0;
wire   [3:0]  nCsD_net_0;
wire   [3:0]  nCsE_net_0;
wire   [3:0]  nCsF_net_0;
wire          OR3_0_Y;
wire          OR4_0_Y;
wire   [0:0]  PAD_IN;
wire   [3:0]  PAD_OUT_net_0;
wire          RX;
wire          SckB_net_0;
wire          SckC_net_0;
wire          SckD_net_0;
wire          SckE_net_0;
wire          SckF_net_0;
wire          SpiMasterPorts_0_XferComplete;
wire          SpiMasterPorts_1_XferComplete;
wire          SpiMasterPorts_2_XferComplete;
wire          SpiMasterPorts_3_XferComplete;
wire          SpiMasterPorts_4_XferComplete;
wire          SpiMasterPorts_5_XferComplete;
wire   [0:0]  TX_net_0;
wire          MosiA_net_1;
wire          debug_0_net_0;
wire          MosiB_net_1;
wire          SckB_net_1;
wire          SckC_net_1;
wire          MosiC_net_1;
wire          MosiD_net_1;
wire          SckD_net_1;
wire          MosiE_net_1;
wire          SckE_net_1;
wire          MosiF_net_1;
wire          SckF_net_1;
wire   [3:0]  nCsA_net_1;
wire   [1:1]  debug_3_net_0;
wire   [2:2]  MosiA_net_2;
wire   [3:3]  debug_net_1;
wire   [4:4]  debug_0_net_1;
wire   [5:5]  MosiB_net_2;
wire   [6:6]  SckB_net_2;
wire   [7:7]  debug_1_net_0;
wire   [8:8]  debug_2_net_0;
wire   [3:0]  nCsB_net_1;
wire   [3:0]  nCsC_net_1;
wire   [3:0]  nCsD_net_1;
wire   [3:0]  nCsE_net_1;
wire   [3:0]  nCsF_net_1;
wire   [0:0]  TX_net_1;
wire   [3:0]  PAD_OUT_net_1;
wire   [0:0]  PAD_OUT_slice_0;
wire   [1:1]  PAD_OUT_slice_1;
wire   [2:2]  PAD_OUT_slice_2;
wire   [3:3]  PAD_OUT_slice_3;
wire   [1:1]  nCs_slice_0;
wire   [2:2]  nCs_slice_1;
wire   [3:3]  nCs_slice_2;
wire   [2:2]  nCs_slice_3;
wire   [3:3]  nCs_slice_4;
wire   [3:0]  D_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          VCC_net;
wire   [23:0] DataToMosi_const_net_0;
wire   [23:0] DataToMosi_const_net_1;
wire   [23:0] DataToMosi_const_net_2;
wire   [23:0] DataToMosi_const_net_3;
wire   [23:0] DataToMosi_const_net_4;
wire   [23:0] DataToMosi_const_net_5;
wire          GND_net;
//--------------------------------------------------------------------
// Inverted Nets
//--------------------------------------------------------------------
wire          TXRDY_OUT_PRE_INV0_0;
//--------------------------------------------------------------------
// Bus Interface Nets Declarations - Unequal Pin Widths
//--------------------------------------------------------------------
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDR;
wire   [4:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDR_0;
wire   [4:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDR_0_4to0;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_PRDATA;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_PRDATA_0;
wire   [31:8] EvalSandbox_MSS_0_AMBA_SLAVE_0_PRDATA_0_31to8;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_PRDATA_0_7to0;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATA;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATA_0;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATA_0_7to0;
wire   [23:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PRDATA;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PRDATA_0;
wire   [23:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PRDATA_0_23to0;
wire   [31:24]EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PRDATA_0_31to24;
wire   [23:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PRDATA;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PRDATA_0;
wire   [23:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PRDATA_0_23to0;
wire   [31:24]EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PRDATA_0_31to24;
wire   [23:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA_0;
wire   [23:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA_0_23to0;
wire   [31:24]EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA_0_31to24;
wire   [23:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PRDATA;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PRDATA_0;
wire   [23:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PRDATA_0_23to0;
wire   [31:24]EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PRDATA_0_31to24;
wire   [23:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PRDATA;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PRDATA_0;
wire   [23:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PRDATA_0_23to0;
wire   [31:24]EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PRDATA_0_31to24;
wire   [23:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PRDATA;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PRDATA_0;
wire   [23:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PRDATA_0_23to0;
wire   [31:24]EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PRDATA_0_31to24;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign VCC_net                = 1'b1;
assign DataToMosi_const_net_0 = 24'hFFFFFF;
assign DataToMosi_const_net_1 = 24'hFFFFFF;
assign DataToMosi_const_net_2 = 24'hFFFFFF;
assign DataToMosi_const_net_3 = 24'hFFFFFF;
assign DataToMosi_const_net_4 = 24'hFFFFFF;
assign DataToMosi_const_net_5 = 24'hFFFFFF;
assign GND_net                = 1'b0;
//--------------------------------------------------------------------
// Inversions
//--------------------------------------------------------------------
assign CoreUARTapb_C0_0_TXRDY = ~ TXRDY_OUT_PRE_INV0_0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign MosiA_net_1      = MosiA_net_0;
assign MosiA            = MosiA_net_1;
assign debug_0_net_0    = debug_0;
assign SckA             = debug_0_net_0;
assign MosiB_net_1      = MosiB_net_0;
assign MosiB            = MosiB_net_1;
assign SckB_net_1       = SckB_net_0;
assign SckB             = SckB_net_1;
assign SckC_net_1       = SckC_net_0;
assign SckC             = SckC_net_1;
assign MosiC_net_1      = MosiC_net_0;
assign MosiC            = MosiC_net_1;
assign MosiD_net_1      = MosiD_net_0;
assign MosiD            = MosiD_net_1;
assign SckD_net_1       = SckD_net_0;
assign SckD             = SckD_net_1;
assign MosiE_net_1      = MosiE_net_0;
assign MosiE            = MosiE_net_1;
assign SckE_net_1       = SckE_net_0;
assign SckE             = SckE_net_1;
assign MosiF_net_1      = MosiF_net_0;
assign MosiF            = MosiF_net_1;
assign SckF_net_1       = SckF_net_0;
assign SckF             = SckF_net_1;
assign nCsA_net_1       = nCsA_net_0;
assign nCsA[3:0]        = nCsA_net_1;
assign debug_3_net_0[1] = debug_3;
assign debug[1:1]       = debug_3_net_0[1];
assign MosiA_net_2[2]   = MosiA_net_0;
assign debug[2:2]       = MosiA_net_2[2];
assign debug_net_1[3]   = debug_net_0[0];
assign debug[3:3]       = debug_net_1[3];
assign debug_0_net_1[4] = debug_0;
assign debug[4:4]       = debug_0_net_1[4];
assign MosiB_net_2[5]   = MosiB_net_0;
assign debug[5:5]       = MosiB_net_2[5];
assign SckB_net_2[6]    = SckB_net_0;
assign debug[6:6]       = SckB_net_2[6];
assign debug_1_net_0[7] = debug_1[0];
assign debug[7:7]       = debug_1_net_0[7];
assign debug_2_net_0[8] = debug_2[1];
assign debug[8:8]       = debug_2_net_0[8];
assign nCsB_net_1       = nCsB_net_0;
assign nCsB[3:0]        = nCsB_net_1;
assign nCsC_net_1       = nCsC_net_0;
assign nCsC[3:0]        = nCsC_net_1;
assign nCsD_net_1       = nCsD_net_0;
assign nCsD[3:0]        = nCsD_net_1;
assign nCsE_net_1       = nCsE_net_0;
assign nCsE[3:0]        = nCsE_net_1;
assign nCsF_net_1       = nCsF_net_0;
assign nCsF[3:0]        = nCsF_net_1;
assign TX_net_1[0]      = TX_net_0[0];
assign TX[0:0]          = TX_net_1[0];
assign PAD_OUT_net_1    = PAD_OUT_net_0;
assign PAD_OUT[3:0]     = PAD_OUT_net_1;
//--------------------------------------------------------------------
// Slices assignments
//--------------------------------------------------------------------
assign debug_net_0[0]     = nCsA_net_0[0:0];
assign debug_1[0]         = nCsB_net_0[0:0];
assign debug_2[1]         = nCsB_net_0[1:1];
assign PAD_OUT_slice_0[0] = PAD_OUT_net_0[0:0];
assign PAD_OUT_slice_1[1] = PAD_OUT_net_0[1:1];
assign PAD_OUT_slice_2[2] = PAD_OUT_net_0[2:2];
assign PAD_OUT_slice_3[3] = PAD_OUT_net_0[3:3];
assign nCs_slice_0[1]     = nCsA_net_0[1:1];
assign nCs_slice_1[2]     = nCsA_net_0[2:2];
assign nCs_slice_2[3]     = nCsA_net_0[3:3];
assign nCs_slice_3[2]     = nCsB_net_0[2:2];
assign nCs_slice_4[3]     = nCsB_net_0[3:3];
//--------------------------------------------------------------------
// Concatenation assignments
//--------------------------------------------------------------------
assign D_net_0 = { EvalSandbox_MSS_0_GPIO_6_M2F , EvalSandbox_MSS_0_GPIO_5_M2F , debug_3 , EvalSandbox_MSS_0_GPIO_3_M2F };
//--------------------------------------------------------------------
// Bus Interface Nets Assignments - Unequal Pin Widths
//--------------------------------------------------------------------
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDR_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDR_0_4to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDR_0_4to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDR[4:0];

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_PRDATA_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_PRDATA_0_31to8, EvalSandbox_MSS_0_AMBA_SLAVE_0_PRDATA_0_7to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_PRDATA_0_31to8 = 24'h0;
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_PRDATA_0_7to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_PRDATA[7:0];

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATA_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATA_0_7to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATA_0_7to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATA[7:0];

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PRDATA_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PRDATA_0_31to24, EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PRDATA_0_23to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PRDATA_0_23to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PRDATA[23:0];
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PRDATA_0_31to24 = 8'h0;

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PRDATA_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PRDATA_0_31to24, EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PRDATA_0_23to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PRDATA_0_23to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PRDATA[23:0];
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PRDATA_0_31to24 = 8'h0;

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA_0_31to24, EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA_0_23to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA_0_23to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA[23:0];
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA_0_31to24 = 8'h0;

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PRDATA_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PRDATA_0_31to24, EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PRDATA_0_23to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PRDATA_0_23to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PRDATA[23:0];
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PRDATA_0_31to24 = 8'h0;

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PRDATA_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PRDATA_0_31to24, EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PRDATA_0_23to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PRDATA_0_23to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PRDATA[23:0];
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PRDATA_0_31to24 = 8'h0;

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PRDATA_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PRDATA_0_31to24, EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PRDATA_0_23to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PRDATA_0_23to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PRDATA[23:0];
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PRDATA_0_31to24 = 8'h0;

//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------CoreUARTapb_C0
CoreUARTapb_C0 CoreUARTapb_C0_0(
        // Inputs
        .PCLK        ( EvalSandbox_MSS_0_FIC_0_CLK ),
        .PRESETN     ( VCC_net ),
        .RX          ( RX ),
        .PSEL        ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PSELx ),
        .PENABLE     ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PENABLE ),
        .PWRITE      ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWRITE ),
        .PADDR       ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDR_0 ),
        .PWDATA      ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATA_0 ),
        // Outputs
        .TXRDY       ( TXRDY_OUT_PRE_INV0_0 ),
        .RXRDY       ( CoreUARTapb_C0_0_RXRDY ),
        .PARITY_ERR  (  ),
        .OVERFLOW    (  ),
        .TX          ( CoreUARTapb_C0_0_TX ),
        .FRAMING_ERR (  ),
        .PREADY      ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PREADY ),
        .PSLVERR     ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PSLVERR ),
        .PRDATA      ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PRDATA ) 
        );

//--------EvalSandbox_MSS
EvalSandbox_MSS EvalSandbox_MSS_0(
        // Inputs
        .FAB_RESET_N              ( VCC_net ), // tied to 1'b1 from definition
        .AMBA_SLAVE_0_PREADYS0    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PREADY ),
        .AMBA_SLAVE_0_PSLVERRS0   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PSLVERR ),
        .AMBA_SLAVE_0_1_PREADYS1  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PREADY ),
        .AMBA_SLAVE_0_1_PSLVERRS1 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_2_PREADYS2  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PREADY ),
        .AMBA_SLAVE_0_2_PSLVERRS2 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_3_PREADYS3  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PREADY ),
        .AMBA_SLAVE_0_3_PSLVERRS3 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_4_PREADYS4  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PREADY ),
        .AMBA_SLAVE_0_4_PSLVERRS4 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_5_PREADYS5  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PREADY ),
        .AMBA_SLAVE_0_5_PSLVERRS5 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_6_PREADYS6  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PREADY ),
        .AMBA_SLAVE_0_6_PSLVERRS6 ( GND_net ), // tied to 1'b0 from definition
        .DEVRST_N                 ( DEVRST_N ),
        .CLK0                     ( CLK0 ),
        .GPIO_0_F2M               ( CoreUARTapb_C0_0_RXRDY ),
        .GPIO_2_F2M               ( OR3_0_Y ),
        .GPIO_7_F2M               ( IO_C1_0_Y ),
        .AMBA_SLAVE_0_PRDATAS0    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PRDATA_0 ),
        .AMBA_SLAVE_0_1_PRDATAS1  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PRDATA_0 ),
        .AMBA_SLAVE_0_2_PRDATAS2  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PRDATA_0 ),
        .AMBA_SLAVE_0_3_PRDATAS3  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA_0 ),
        .AMBA_SLAVE_0_4_PRDATAS4  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PRDATA_0 ),
        .AMBA_SLAVE_0_5_PRDATAS5  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PRDATA_0 ),
        .AMBA_SLAVE_0_6_PRDATAS6  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PRDATA_0 ),
        // Outputs
        .POWER_ON_RESET_N         (  ),
        .INIT_DONE                (  ),
        .AMBA_SLAVE_0_PSELS0      ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PSELx ),
        .AMBA_SLAVE_0_PENABLES    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PENABLE ),
        .AMBA_SLAVE_0_PWRITES     ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWRITE ),
        .AMBA_SLAVE_0_1_PSELS1    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PSELx ),
        .AMBA_SLAVE_0_1_PENABLES  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PENABLE ),
        .AMBA_SLAVE_0_1_PWRITES   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PWRITE ),
        .AMBA_SLAVE_0_2_PSELS2    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PSELx ),
        .AMBA_SLAVE_0_2_PENABLES  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PENABLE ),
        .AMBA_SLAVE_0_2_PWRITES   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PWRITE ),
        .AMBA_SLAVE_0_3_PSELS3    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PSELx ),
        .AMBA_SLAVE_0_3_PENABLES  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PENABLE ),
        .AMBA_SLAVE_0_3_PWRITES   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PWRITE ),
        .AMBA_SLAVE_0_4_PSELS4    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PSELx ),
        .AMBA_SLAVE_0_4_PENABLES  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PENABLE ),
        .AMBA_SLAVE_0_4_PWRITES   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PWRITE ),
        .AMBA_SLAVE_0_5_PSELS5    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PSELx ),
        .AMBA_SLAVE_0_5_PENABLES  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PENABLE ),
        .AMBA_SLAVE_0_5_PWRITES   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PWRITE ),
        .AMBA_SLAVE_0_6_PSELS6    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PSELx ),
        .AMBA_SLAVE_0_6_PENABLES  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PENABLE ),
        .AMBA_SLAVE_0_6_PWRITES   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PWRITE ),
        .FIC_0_CLK                ( EvalSandbox_MSS_0_FIC_0_CLK ),
        .FIC_0_LOCK               (  ),
        .MSS_READY                (  ),
        .GPIO_1_M2F               ( EvalSandbox_MSS_0_GPIO_1_M2F ),
        .GPIO_3_M2F               ( EvalSandbox_MSS_0_GPIO_3_M2F ),
        .GPIO_4_M2F               ( debug_3 ),
        .GPIO_5_M2F               ( EvalSandbox_MSS_0_GPIO_5_M2F ),
        .GPIO_6_M2F               ( EvalSandbox_MSS_0_GPIO_6_M2F ),
        .AMBA_SLAVE_0_PADDRS      ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDR ),
        .AMBA_SLAVE_0_PWDATAS     ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATA ),
        .AMBA_SLAVE_0_1_PADDRS    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PADDR ),
        .AMBA_SLAVE_0_1_PWDATAS   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PWDATA ),
        .AMBA_SLAVE_0_2_PADDRS    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PADDR ),
        .AMBA_SLAVE_0_2_PWDATAS   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PWDATA ),
        .AMBA_SLAVE_0_3_PADDRS    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PADDR ),
        .AMBA_SLAVE_0_3_PWDATAS   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PWDATA ),
        .AMBA_SLAVE_0_4_PADDRS    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PADDR ),
        .AMBA_SLAVE_0_4_PWDATAS   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PWDATA ),
        .AMBA_SLAVE_0_5_PADDRS    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PADDR ),
        .AMBA_SLAVE_0_5_PWDATAS   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PWDATA ),
        .AMBA_SLAVE_0_6_PADDRS    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PADDR ),
        .AMBA_SLAVE_0_6_PWDATAS   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PWDATA ) 
        );

//--------IO_C0
IO_C0 IO_C0_0(
        // Inputs
        .D       ( D_net_0 ),
        // Outputs
        .PAD_OUT ( PAD_OUT_net_0 ) 
        );

//--------IO_C1
IO_C1 IO_C1_0(
        // Inputs
        .PAD_IN ( PAD_IN ),
        // Outputs
        .Y      ( IO_C1_0_Y ) 
        );

//--------IO_UartTx
IO_UartTx IO_UartTx_0(
        // Inputs
        .D       ( CoreUARTapb_C0_0_TX ),
        .E       ( CoreUARTapb_C0_0_TXRDY ),
        // Outputs
        .PAD_TRI ( TX_net_0 ) 
        );

//--------OR3
OR3 OR3_0(
        // Inputs
        .A ( OR4_0_Y ),
        .B ( SpiMasterPorts_4_XferComplete ),
        .C ( SpiMasterPorts_5_XferComplete ),
        // Outputs
        .Y ( OR3_0_Y ) 
        );

//--------OR4
OR4 OR4_0(
        // Inputs
        .A ( SpiMasterPorts_0_XferComplete ),
        .B ( SpiMasterPorts_1_XferComplete ),
        .C ( SpiMasterPorts_2_XferComplete ),
        .D ( SpiMasterPorts_3_XferComplete ),
        // Outputs
        .Y ( OR4_0_Y ) 
        );

//--------SpiMasterPorts
SpiMasterPorts #( 
        .BYTE_WIDTH    ( 3 ),
        .CLOCK_DIVIDER ( 1000 ) )
SpiMasterPorts_0(
        // Inputs
        .clk                 ( EvalSandbox_MSS_0_FIC_0_CLK ),
        .rst                 ( EvalSandbox_MSS_0_GPIO_1_M2F ),
        .Miso                ( MisoA ),
        .Penable             ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PENABLE ),
        .Psel                ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PSELx ),
        .Presern             ( VCC_net ),
        .Pwrite              ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PWRITE ),
        .AmbaBusData         ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PWDATA ),
        .DataToMosi          ( DataToMosi_const_net_0 ),
        // Outputs
        .Mosi                ( MosiA_net_0 ),
        .Sck                 ( debug_0 ),
        .Pready              ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PREADY ),
        .AmbaDataLatched_o   (  ),
        .DataToMosiLatched_o (  ),
        .nCsLatched_o        (  ),
        .XferComplete        ( SpiMasterPorts_0_XferComplete ),
        .nCs                 ( nCsA_net_0 ),
        .DataFromMiso        ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_1_PRDATA ) 
        );

//--------SpiMasterPorts
SpiMasterPorts #( 
        .BYTE_WIDTH    ( 3 ),
        .CLOCK_DIVIDER ( 1000 ) )
SpiMasterPorts_1(
        // Inputs
        .clk                 ( EvalSandbox_MSS_0_FIC_0_CLK ),
        .rst                 ( EvalSandbox_MSS_0_GPIO_1_M2F ),
        .Miso                ( MisoB ),
        .Penable             ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PENABLE ),
        .Psel                ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PSELx ),
        .Presern             ( VCC_net ),
        .Pwrite              ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PWRITE ),
        .AmbaBusData         ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PWDATA ),
        .DataToMosi          ( DataToMosi_const_net_1 ),
        // Outputs
        .Mosi                ( MosiB_net_0 ),
        .Sck                 ( SckB_net_0 ),
        .Pready              ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PREADY ),
        .AmbaDataLatched_o   (  ),
        .DataToMosiLatched_o (  ),
        .nCsLatched_o        (  ),
        .XferComplete        ( SpiMasterPorts_1_XferComplete ),
        .nCs                 ( nCsB_net_0 ),
        .DataFromMiso        ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_1_PRDATA ) 
        );

//--------SpiMasterPorts
SpiMasterPorts #( 
        .BYTE_WIDTH    ( 3 ),
        .CLOCK_DIVIDER ( 1000 ) )
SpiMasterPorts_2(
        // Inputs
        .clk                 ( EvalSandbox_MSS_0_FIC_0_CLK ),
        .rst                 ( EvalSandbox_MSS_0_GPIO_1_M2F ),
        .Miso                ( MisoC ),
        .Penable             ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PENABLE ),
        .Psel                ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PSELx ),
        .Presern             ( VCC_net ),
        .Pwrite              ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PWRITE ),
        .AmbaBusData         ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PWDATA ),
        .DataToMosi          ( DataToMosi_const_net_2 ),
        // Outputs
        .Mosi                ( MosiC_net_0 ),
        .Sck                 ( SckC_net_0 ),
        .Pready              ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PREADY ),
        .AmbaDataLatched_o   (  ),
        .DataToMosiLatched_o (  ),
        .nCsLatched_o        (  ),
        .XferComplete        ( SpiMasterPorts_2_XferComplete ),
        .nCs                 ( nCsC_net_0 ),
        .DataFromMiso        ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA ) 
        );

//--------SpiMasterPorts
SpiMasterPorts #( 
        .BYTE_WIDTH    ( 3 ),
        .CLOCK_DIVIDER ( 1000 ) )
SpiMasterPorts_3(
        // Inputs
        .clk                 ( EvalSandbox_MSS_0_FIC_0_CLK ),
        .rst                 ( EvalSandbox_MSS_0_GPIO_1_M2F ),
        .Miso                ( MisoD ),
        .Penable             ( EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PENABLE ),
        .Psel                ( EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PSELx ),
        .Presern             ( VCC_net ),
        .Pwrite              ( EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PWRITE ),
        .AmbaBusData         ( EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PWDATA ),
        .DataToMosi          ( DataToMosi_const_net_3 ),
        // Outputs
        .Mosi                ( MosiD_net_0 ),
        .Sck                 ( SckD_net_0 ),
        .Pready              ( EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PREADY ),
        .AmbaDataLatched_o   (  ),
        .DataToMosiLatched_o (  ),
        .nCsLatched_o        (  ),
        .XferComplete        ( SpiMasterPorts_3_XferComplete ),
        .nCs                 ( nCsD_net_0 ),
        .DataFromMiso        ( EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PRDATA ) 
        );

//--------SpiMasterPorts
SpiMasterPorts #( 
        .BYTE_WIDTH    ( 3 ),
        .CLOCK_DIVIDER ( 1000 ) )
SpiMasterPorts_4(
        // Inputs
        .clk                 ( EvalSandbox_MSS_0_FIC_0_CLK ),
        .rst                 ( EvalSandbox_MSS_0_GPIO_1_M2F ),
        .Miso                ( MisoE ),
        .Penable             ( EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PENABLE ),
        .Psel                ( EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PSELx ),
        .Presern             ( VCC_net ),
        .Pwrite              ( EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PWRITE ),
        .AmbaBusData         ( EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PWDATA ),
        .DataToMosi          ( DataToMosi_const_net_4 ),
        // Outputs
        .Mosi                ( MosiE_net_0 ),
        .Sck                 ( SckE_net_0 ),
        .Pready              ( EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PREADY ),
        .AmbaDataLatched_o   (  ),
        .DataToMosiLatched_o (  ),
        .nCsLatched_o        (  ),
        .XferComplete        ( SpiMasterPorts_4_XferComplete ),
        .nCs                 ( nCsE_net_0 ),
        .DataFromMiso        ( EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PRDATA ) 
        );

//--------SpiMasterPorts
SpiMasterPorts #( 
        .BYTE_WIDTH    ( 3 ),
        .CLOCK_DIVIDER ( 1000 ) )
SpiMasterPorts_5(
        // Inputs
        .clk                 ( EvalSandbox_MSS_0_FIC_0_CLK ),
        .rst                 ( EvalSandbox_MSS_0_GPIO_1_M2F ),
        .Miso                ( MisoF ),
        .Penable             ( EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PENABLE ),
        .Psel                ( EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PSELx ),
        .Presern             ( VCC_net ),
        .Pwrite              ( EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PWRITE ),
        .AmbaBusData         ( EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PWDATA ),
        .DataToMosi          ( DataToMosi_const_net_5 ),
        // Outputs
        .Mosi                ( MosiF_net_0 ),
        .Sck                 ( SckF_net_0 ),
        .Pready              ( EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PREADY ),
        .AmbaDataLatched_o   (  ),
        .DataToMosiLatched_o (  ),
        .nCsLatched_o        (  ),
        .XferComplete        ( SpiMasterPorts_5_XferComplete ),
        .nCs                 ( nCsF_net_0 ),
        .DataFromMiso        ( EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PRDATA ) 
        );


endmodule

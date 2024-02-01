//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Wed Jan 31 16:41:14 2024
// Version: 2023.2 2023.2.0.8
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// EvalBoardSandbox
module EvalBoardSandbox(
    // Inputs
    DEVRST_N,
    MisoA,
    MisoB,
    MisoC,
    MisoD,
    MisoE,
    MisoF,
    RX,
    // Outputs
    MosiA,
    MosiB,
    MosiC,
    MosiD,
    MosiE,
    MosiF,
    SckA,
    SckB,
    SckC,
    SckD,
    SckE,
    SckF,
    TX,
    XferComplete,
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
input        DEVRST_N;
input        MisoA;
input        MisoB;
input        MisoC;
input        MisoD;
input        MisoE;
input        MisoF;
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
output       SckA;
output       SckB;
output       SckC;
output       SckD;
output       SckE;
output       SckF;
output       TX;
output       XferComplete;
output [3:0] nCsA;
output [3:0] nCsB;
output [3:0] nCsC;
output [3:0] nCsD;
output [3:0] nCsE;
output [3:0] nCsF;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          CoreUARTapb_C0_0_RXRDY;
wire          DEVRST_N;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PENABLE;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PREADY;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PSELx;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PSLVERR;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PWRITE;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PADDR;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PENABLE;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PSELx;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PWRITE;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_2_0_PADDR;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_2_0_PENABLE;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_2_0_PSELx;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_3_0_PADDR;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_3_0_PENABLE;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_3_0_PSELx;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PADDR;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PENABLE;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PSELx;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PADDR;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PENABLE;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PSELx;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PADDR;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PENABLE;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PSELx;
wire          EvalSandbox_MSS_0_FIC_0_CLK;
wire          EvalSandbox_MSS_0_GPIO_1_M2F;
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
wire          RX;
wire          SckA_net_0;
wire          SckB_net_0;
wire          SckC_net_0;
wire          SckD_net_0;
wire          SckE_net_0;
wire          SckF_net_0;
wire          TX_net_0;
wire          XferComplete_net_0;
wire          TX_net_1;
wire          XferComplete_net_1;
wire          MosiA_net_1;
wire          MosiB_net_1;
wire          MosiC_net_1;
wire          MosiD_net_1;
wire          MosiE_net_1;
wire          MosiF_net_1;
wire   [3:0]  nCsF_net_1;
wire   [3:0]  nCsE_net_1;
wire   [3:0]  nCsB_net_1;
wire   [3:0]  nCsC_net_1;
wire   [3:0]  nCsA_net_1;
wire   [3:0]  nCsD_net_1;
wire          SckF_net_1;
wire          SckB_net_1;
wire          SckC_net_1;
wire          SckD_net_1;
wire          SckE_net_1;
wire          SckA_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          VCC_net;
wire          GND_net;
wire   [31:0] AMBA_SLAVE_0_1_PRDATAS1_const_net_0;
wire   [31:0] AMBA_SLAVE_0_2_PRDATAS2_const_net_0;
wire   [31:0] AMBA_SLAVE_0_3_PRDATAS3_const_net_0;
wire   [31:0] AMBA_SLAVE_0_4_PRDATAS4_const_net_0;
wire   [31:0] AMBA_SLAVE_0_5_PRDATAS5_const_net_0;
wire   [31:0] AMBA_SLAVE_0_6_PRDATAS6_const_net_0;
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
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PWDATA;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PWDATA_0;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PWDATA_0_7to0;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_2_0_PWDATA;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_2_0_PWDATA_0;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_2_0_PWDATA_0_7to0;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_3_0_PWDATA;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_3_0_PWDATA_0;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_3_0_PWDATA_0_7to0;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PWDATA;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PWDATA_0;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PWDATA_0_7to0;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PWDATA;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PWDATA_0;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PWDATA_0_7to0;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PWDATA;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PWDATA_0;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PWDATA_0_7to0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign VCC_net                             = 1'b1;
assign GND_net                             = 1'b0;
assign AMBA_SLAVE_0_1_PRDATAS1_const_net_0 = 32'h00000000;
assign AMBA_SLAVE_0_2_PRDATAS2_const_net_0 = 32'h00000000;
assign AMBA_SLAVE_0_3_PRDATAS3_const_net_0 = 32'h00000000;
assign AMBA_SLAVE_0_4_PRDATAS4_const_net_0 = 32'h00000000;
assign AMBA_SLAVE_0_5_PRDATAS5_const_net_0 = 32'h00000000;
assign AMBA_SLAVE_0_6_PRDATAS6_const_net_0 = 32'h00000000;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign TX_net_1           = TX_net_0;
assign TX                 = TX_net_1;
assign XferComplete_net_1 = XferComplete_net_0;
assign XferComplete       = XferComplete_net_1;
assign MosiA_net_1        = MosiA_net_0;
assign MosiA              = MosiA_net_1;
assign MosiB_net_1        = MosiB_net_0;
assign MosiB              = MosiB_net_1;
assign MosiC_net_1        = MosiC_net_0;
assign MosiC              = MosiC_net_1;
assign MosiD_net_1        = MosiD_net_0;
assign MosiD              = MosiD_net_1;
assign MosiE_net_1        = MosiE_net_0;
assign MosiE              = MosiE_net_1;
assign MosiF_net_1        = MosiF_net_0;
assign MosiF              = MosiF_net_1;
assign nCsF_net_1         = nCsF_net_0;
assign nCsF[3:0]          = nCsF_net_1;
assign nCsE_net_1         = nCsE_net_0;
assign nCsE[3:0]          = nCsE_net_1;
assign nCsB_net_1         = nCsB_net_0;
assign nCsB[3:0]          = nCsB_net_1;
assign nCsC_net_1         = nCsC_net_0;
assign nCsC[3:0]          = nCsC_net_1;
assign nCsA_net_1         = nCsA_net_0;
assign nCsA[3:0]          = nCsA_net_1;
assign nCsD_net_1         = nCsD_net_0;
assign nCsD[3:0]          = nCsD_net_1;
assign SckF_net_1         = SckF_net_0;
assign SckF               = SckF_net_1;
assign SckB_net_1         = SckB_net_0;
assign SckB               = SckB_net_1;
assign SckC_net_1         = SckC_net_0;
assign SckC               = SckC_net_1;
assign SckD_net_1         = SckD_net_0;
assign SckD               = SckD_net_1;
assign SckE_net_1         = SckE_net_0;
assign SckE               = SckE_net_1;
assign SckA_net_1         = SckA_net_0;
assign SckA               = SckA_net_1;
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

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PWDATA_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PWDATA_0_7to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PWDATA_0_7to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PWDATA[7:0];

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_2_0_PWDATA_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_2_0_PWDATA_0_7to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_2_0_PWDATA_0_7to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_2_0_PWDATA[7:0];

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_3_0_PWDATA_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_3_0_PWDATA_0_7to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_3_0_PWDATA_0_7to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_3_0_PWDATA[7:0];

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PWDATA_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PWDATA_0_7to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PWDATA_0_7to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PWDATA[7:0];

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PWDATA_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PWDATA_0_7to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PWDATA_0_7to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PWDATA[7:0];

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PWDATA_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PWDATA_0_7to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PWDATA_0_7to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PWDATA[7:0];

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
        .TXRDY       (  ),
        .RXRDY       ( CoreUARTapb_C0_0_RXRDY ),
        .PARITY_ERR  (  ),
        .OVERFLOW    (  ),
        .TX          ( TX_net_0 ),
        .FRAMING_ERR (  ),
        .PREADY      ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PREADY ),
        .PSLVERR     ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PSLVERR ),
        .PRDATA      ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PRDATA ) 
        );

//--------EvalSandbox_MSS
EvalSandbox_MSS EvalSandbox_MSS_0(
        // Inputs
        .FAB_RESET_N              ( VCC_net ), // tied to 1'b1 from definition
        .AMBA_SLAVE_0_PRDATAS0    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PRDATA_0 ),
        .AMBA_SLAVE_0_PREADYS0    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PREADY ),
        .AMBA_SLAVE_0_PSLVERRS0   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PSLVERR ),
        .AMBA_SLAVE_0_1_PRDATAS1  ( AMBA_SLAVE_0_1_PRDATAS1_const_net_0 ), // tied to 32'h00000000 from definition
        .AMBA_SLAVE_0_1_PREADYS1  ( VCC_net ), // tied to 1'b1 from definition
        .AMBA_SLAVE_0_1_PSLVERRS1 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_2_PRDATAS2  ( AMBA_SLAVE_0_2_PRDATAS2_const_net_0 ), // tied to 32'h00000000 from definition
        .AMBA_SLAVE_0_2_PREADYS2  ( VCC_net ), // tied to 1'b1 from definition
        .AMBA_SLAVE_0_2_PSLVERRS2 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_3_PRDATAS3  ( AMBA_SLAVE_0_3_PRDATAS3_const_net_0 ), // tied to 32'h00000000 from definition
        .AMBA_SLAVE_0_3_PREADYS3  ( VCC_net ), // tied to 1'b1 from definition
        .AMBA_SLAVE_0_3_PSLVERRS3 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_4_PRDATAS4  ( AMBA_SLAVE_0_4_PRDATAS4_const_net_0 ), // tied to 32'h00000000 from definition
        .AMBA_SLAVE_0_4_PREADYS4  ( VCC_net ), // tied to 1'b1 from definition
        .AMBA_SLAVE_0_4_PSLVERRS4 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_5_PRDATAS5  ( AMBA_SLAVE_0_5_PRDATAS5_const_net_0 ), // tied to 32'h00000000 from definition
        .AMBA_SLAVE_0_5_PREADYS5  ( VCC_net ), // tied to 1'b1 from definition
        .AMBA_SLAVE_0_5_PSLVERRS5 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_6_PRDATAS6  ( AMBA_SLAVE_0_6_PRDATAS6_const_net_0 ), // tied to 32'h00000000 from definition
        .AMBA_SLAVE_0_6_PREADYS6  ( VCC_net ), // tied to 1'b1 from definition
        .AMBA_SLAVE_0_6_PSLVERRS6 ( GND_net ), // tied to 1'b0 from definition
        .DEVRST_N                 ( DEVRST_N ),
        .GPIO_0_F2M               ( CoreUARTapb_C0_0_RXRDY ),
        .GPIO_2_F2M               ( XferComplete_net_0 ),
        // Outputs
        .POWER_ON_RESET_N         (  ),
        .INIT_DONE                (  ),
        .AMBA_SLAVE_0_PADDRS      ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDR ),
        .AMBA_SLAVE_0_PSELS0      ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PSELx ),
        .AMBA_SLAVE_0_PENABLES    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PENABLE ),
        .AMBA_SLAVE_0_PWRITES     ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWRITE ),
        .AMBA_SLAVE_0_PWDATAS     ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATA ),
        .AMBA_SLAVE_0_1_PADDRS    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PADDR ),
        .AMBA_SLAVE_0_1_PSELS1    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PSELx ),
        .AMBA_SLAVE_0_1_PENABLES  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PENABLE ),
        .AMBA_SLAVE_0_1_PWRITES   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PWRITE ),
        .AMBA_SLAVE_0_1_PWDATAS   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PWDATA ),
        .AMBA_SLAVE_0_2_PADDRS    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_0_PADDR ),
        .AMBA_SLAVE_0_2_PSELS2    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_0_PSELx ),
        .AMBA_SLAVE_0_2_PENABLES  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_0_PENABLE ),
        .AMBA_SLAVE_0_2_PWRITES   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PWRITE ),
        .AMBA_SLAVE_0_2_PWDATAS   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_0_PWDATA ),
        .AMBA_SLAVE_0_3_PADDRS    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_0_PADDR ),
        .AMBA_SLAVE_0_3_PSELS3    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_0_PSELx ),
        .AMBA_SLAVE_0_3_PENABLES  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_0_PENABLE ),
        .AMBA_SLAVE_0_3_PWRITES   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PWRITE ),
        .AMBA_SLAVE_0_3_PWDATAS   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_0_PWDATA ),
        .AMBA_SLAVE_0_4_PADDRS    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PADDR ),
        .AMBA_SLAVE_0_4_PSELS4    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PSELx ),
        .AMBA_SLAVE_0_4_PENABLES  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PENABLE ),
        .AMBA_SLAVE_0_4_PWRITES   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PWRITE ),
        .AMBA_SLAVE_0_4_PWDATAS   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PWDATA ),
        .AMBA_SLAVE_0_5_PADDRS    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PADDR ),
        .AMBA_SLAVE_0_5_PSELS5    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PSELx ),
        .AMBA_SLAVE_0_5_PENABLES  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PENABLE ),
        .AMBA_SLAVE_0_5_PWRITES   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PWRITE ),
        .AMBA_SLAVE_0_5_PWDATAS   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PWDATA ),
        .AMBA_SLAVE_0_6_PADDRS    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PADDR ),
        .AMBA_SLAVE_0_6_PSELS6    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PSELx ),
        .AMBA_SLAVE_0_6_PENABLES  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PENABLE ),
        .AMBA_SLAVE_0_6_PWRITES   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PWRITE ),
        .AMBA_SLAVE_0_6_PWDATAS   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PWDATA ),
        .FIC_0_CLK                ( EvalSandbox_MSS_0_FIC_0_CLK ),
        .FIC_0_LOCK               (  ),
        .MSS_READY                (  ),
        .GPIO_1_M2F               ( EvalSandbox_MSS_0_GPIO_1_M2F ) 
        );

//--------SpiMasterSextetPorts
SpiMasterSextetPorts #( 
        .BYTE_WIDTH    ( 1 ),
        .CLOCK_DIVIDER ( 1000 ) )
SpiMasterSextetPorts_0(
        // Inputs
        .clk           ( EvalSandbox_MSS_0_FIC_0_CLK ),
        .rst           ( EvalSandbox_MSS_0_GPIO_1_M2F ),
        .MisoA         ( MisoA ),
        .MisoB         ( MisoB ),
        .MisoC         ( MisoC ),
        .MisoD         ( MisoD ),
        .MisoE         ( MisoE ),
        .MisoF         ( MisoF ),
        .MosiDataWrite ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PWRITE ),
        .DataToMosiA   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_0_PWDATA_0 ),
        .DataToMosiB   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_0_PWDATA_0 ),
        .DataToMosiC   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_0_PWDATA_0 ),
        .DataToMosiD   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_4_PWDATA_0 ),
        .DataToMosiE   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_5_PWDATA_0 ),
        .DataToMosiF   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_6_PWDATA_0 ),
        // Outputs
        .MosiA         ( MosiA_net_0 ),
        .MosiB         ( MosiB_net_0 ),
        .MosiC         ( MosiC_net_0 ),
        .MosiD         ( MosiD_net_0 ),
        .MosiE         ( MosiE_net_0 ),
        .MosiF         ( MosiF_net_0 ),
        .SckA          ( SckA_net_0 ),
        .SckB          ( SckB_net_0 ),
        .SckC          ( SckC_net_0 ),
        .SckD          ( SckD_net_0 ),
        .SckE          ( SckE_net_0 ),
        .SckF          ( SckF_net_0 ),
        .nCsA          ( nCsA_net_0 ),
        .nCsB          ( nCsB_net_0 ),
        .nCsC          ( nCsC_net_0 ),
        .nCsD          ( nCsD_net_0 ),
        .nCsE          ( nCsE_net_0 ),
        .nCsF          ( nCsF_net_0 ),
        .DataFromMisoA (  ),
        .DataFromMisoB (  ),
        .DataFromMisoC (  ),
        .DataFromMisoD (  ),
        .DataFromMisoE (  ),
        .DataFromMisoF (  ),
        .XferComplete  ( XferComplete_net_0 ) 
        );


endmodule

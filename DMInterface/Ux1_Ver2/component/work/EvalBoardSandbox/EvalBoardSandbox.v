//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Fri Jun  6 09:25:15 2025
// Version: 2023.2 2023.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// EvalBoardSandbox
module EvalBoardSandbox(
    // Inputs
    CLK0_PAD,
    DEVRST_N,
    MisoA,
    MisoB,
    MisoC,
    MisoD,
    MisoE,
    MisoF,
    PPS,
    Rx0,
    Rx1,
    Rx2,
    // Outputs
    MosiA,
    MosiB,
    MosiC,
    MosiD,
    MosiE,
    MosiF,
    Oe0,
    Oe1,
    Oe2,
    PowerHVnEn,
    SckA,
    SckB,
    SckC,
    SckD,
    SckE,
    SckF,
    TP1,
    TP2,
    TP3,
    TP4,
    TP5,
    TP6,
    TP7,
    TP8,
    Tx0,
    Tx1,
    Tx2,
    TxUsb,
    nClrDacs,
    nCsA,
    nCsB,
    nCsC,
    nCsD,
    nCsE,
    nCsF,
    nLDacs,
    nRstDacs,
    // Inouts
    Ux1SelJmp
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input        CLK0_PAD;
input        DEVRST_N;
input        MisoA;
input        MisoB;
input        MisoC;
input        MisoD;
input        MisoE;
input        MisoF;
input        PPS;
input        Rx0;
input        Rx1;
input        Rx2;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output       MosiA;
output       MosiB;
output       MosiC;
output       MosiD;
output       MosiE;
output       MosiF;
output       Oe0;
output       Oe1;
output       Oe2;
output       PowerHVnEn;
output       SckA;
output       SckB;
output       SckC;
output       SckD;
output       SckE;
output       SckF;
output       TP1;
output       TP2;
output       TP3;
output       TP4;
output       TP5;
output       TP6;
output       TP7;
output       TP8;
output       Tx0;
output       Tx1;
output       Tx2;
output [0:0] TxUsb;
output       nClrDacs;
output [3:0] nCsA;
output [3:0] nCsB;
output [3:0] nCsC;
output [3:0] nCsD;
output [3:0] nCsE;
output [3:0] nCsF;
output       nLDacs;
output       nRstDacs;
//--------------------------------------------------------------------
// Inout
//--------------------------------------------------------------------
inout        Ux1SelJmp;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          CLK0_PAD;
wire          DEVRST_N;
wire          DMMainPorts_1_RamBusAck;
wire          DMMainPorts_1_RamBusAck1;
wire   [31:0] DMMainPorts_1_RamBusDataOut;
wire   [31:0] DMMainPorts_1_RamBusDataOut1;
wire   [13:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PADDRS13to0;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PENABLES;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PSELS1;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PWDATAS;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PWRITES;
wire   [13:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDRS13to0;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PENABLES;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PSELS0;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATAS;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PWRITES;
wire          FCCC_C0_0_GL0;
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
wire          nClrDacs_net_0;
wire   [3:0]  nCsA_net_0;
wire   [3:0]  nCsB_net_0;
wire   [3:0]  nCsC_net_0;
wire   [3:0]  nCsD_net_0;
wire   [3:0]  nCsE_net_0;
wire   [3:0]  nCsF_net_0;
wire          nLDacs_net_0;
wire          nRstDacs_net_0;
wire          Oe0_net_0;
wire          Oe1_net_0;
wire          Oe2_net_0;
wire          PowerHVnEn_net_0;
wire          PPS;
wire          Rx0;
wire          Rx1;
wire          Rx2;
wire          SckA_net_0;
wire          SckB_net_0;
wire          SckC_net_0;
wire          SckD_net_0;
wire          SckE_net_0;
wire          SckF_net_0;
wire   [0:0]  TP1_net_0;
wire   [1:1]  TP2_net_0;
wire   [2:2]  TP3_net_0;
wire   [3:3]  TP4_net_0;
wire   [4:4]  TP5_net_0;
wire   [5:5]  TP6_net_0;
wire   [6:6]  TP7_net_0;
wire   [7:7]  TP8_net_0;
wire          Tx0_net_0;
wire          Tx1_net_0;
wire          Tx2_net_0;
wire   [0:0]  TxUsb_net_0;
wire          Ux1SelJmp;
wire          Tx0_net_1;
wire          Oe0_net_1;
wire          Tx1_net_1;
wire          Oe1_net_1;
wire          Tx2_net_1;
wire          Oe2_net_1;
wire          MosiA_net_1;
wire          MosiB_net_1;
wire          MosiC_net_1;
wire          MosiD_net_1;
wire          MosiE_net_1;
wire          MosiF_net_1;
wire          SckA_net_1;
wire          SckB_net_1;
wire          SckC_net_1;
wire          SckD_net_1;
wire          SckE_net_1;
wire          SckF_net_1;
wire          TP1_net_1;
wire          TP2_net_1;
wire          TP3_net_1;
wire          TP4_net_1;
wire          TP5_net_1;
wire          TP6_net_1;
wire          TP7_net_1;
wire          TP8_net_1;
wire          nLDacs_net_1;
wire          nRstDacs_net_1;
wire          nClrDacs_net_1;
wire          PowerHVnEn_net_1;
wire   [3:0]  nCsA_net_1;
wire   [3:0]  nCsB_net_1;
wire   [3:0]  nCsC_net_1;
wire   [3:0]  nCsD_net_1;
wire   [3:0]  nCsE_net_1;
wire   [3:0]  nCsF_net_1;
wire   [0:0]  TxUsb_net_1;
wire   [0:0]  nCsA_slice_0;
wire   [1:1]  nCsA_slice_1;
wire   [2:2]  nCsA_slice_2;
wire   [3:3]  nCsA_slice_3;
wire   [7:0]  Testpoints_net_0;
wire   [31:0] AMBA_SLAVE_0_PADDRS_net_0;
wire   [31:0] AMBA_SLAVE_0_1_PADDRS_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          VCC_net;
wire          GND_net;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign VCC_net    = 1'b1;
assign GND_net    = 1'b0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign Tx0_net_1        = Tx0_net_0;
assign Tx0              = Tx0_net_1;
assign Oe0_net_1        = Oe0_net_0;
assign Oe0              = Oe0_net_1;
assign Tx1_net_1        = Tx1_net_0;
assign Tx1              = Tx1_net_1;
assign Oe1_net_1        = Oe1_net_0;
assign Oe1              = Oe1_net_1;
assign Tx2_net_1        = Tx2_net_0;
assign Tx2              = Tx2_net_1;
assign Oe2_net_1        = Oe2_net_0;
assign Oe2              = Oe2_net_1;
assign MosiA_net_1      = MosiA_net_0;
assign MosiA            = MosiA_net_1;
assign MosiB_net_1      = MosiB_net_0;
assign MosiB            = MosiB_net_1;
assign MosiC_net_1      = MosiC_net_0;
assign MosiC            = MosiC_net_1;
assign MosiD_net_1      = MosiD_net_0;
assign MosiD            = MosiD_net_1;
assign MosiE_net_1      = MosiE_net_0;
assign MosiE            = MosiE_net_1;
assign MosiF_net_1      = MosiF_net_0;
assign MosiF            = MosiF_net_1;
assign SckA_net_1       = SckA_net_0;
assign SckA             = SckA_net_1;
assign SckB_net_1       = SckB_net_0;
assign SckB             = SckB_net_1;
assign SckC_net_1       = SckC_net_0;
assign SckC             = SckC_net_1;
assign SckD_net_1       = SckD_net_0;
assign SckD             = SckD_net_1;
assign SckE_net_1       = SckE_net_0;
assign SckE             = SckE_net_1;
assign SckF_net_1       = SckF_net_0;
assign SckF             = SckF_net_1;
assign TP1_net_1        = TP1_net_0[0];
assign TP1              = TP1_net_1;
assign TP2_net_1        = TP2_net_0[1];
assign TP2              = TP2_net_1;
assign TP3_net_1        = TP3_net_0[2];
assign TP3              = TP3_net_1;
assign TP4_net_1        = TP4_net_0[3];
assign TP4              = TP4_net_1;
assign TP5_net_1        = TP5_net_0[4];
assign TP5              = TP5_net_1;
assign TP6_net_1        = TP6_net_0[5];
assign TP6              = TP6_net_1;
assign TP7_net_1        = TP7_net_0[6];
assign TP7              = TP7_net_1;
assign TP8_net_1        = TP8_net_0[7];
assign TP8              = TP8_net_1;
assign nLDacs_net_1     = nLDacs_net_0;
assign nLDacs           = nLDacs_net_1;
assign nRstDacs_net_1   = nRstDacs_net_0;
assign nRstDacs         = nRstDacs_net_1;
assign nClrDacs_net_1   = nClrDacs_net_0;
assign nClrDacs         = nClrDacs_net_1;
assign PowerHVnEn_net_1 = PowerHVnEn_net_0;
assign PowerHVnEn       = PowerHVnEn_net_1;
assign nCsA_net_1       = nCsA_net_0;
assign nCsA[3:0]        = nCsA_net_1;
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
assign TxUsb_net_1[0]   = TxUsb_net_0[0];
assign TxUsb[0:0]       = TxUsb_net_1[0];
//--------------------------------------------------------------------
// Slices assignments
//--------------------------------------------------------------------
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PADDRS13to0 = AMBA_SLAVE_0_1_PADDRS_net_0[13:0];
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDRS13to0   = AMBA_SLAVE_0_PADDRS_net_0[13:0];
assign TP1_net_0[0]                                 = Testpoints_net_0[0:0];
assign TP2_net_0[1]                                 = Testpoints_net_0[1:1];
assign TP3_net_0[2]                                 = Testpoints_net_0[2:2];
assign TP4_net_0[3]                                 = Testpoints_net_0[3:3];
assign TP5_net_0[4]                                 = Testpoints_net_0[4:4];
assign TP6_net_0[5]                                 = Testpoints_net_0[5:5];
assign TP7_net_0[6]                                 = Testpoints_net_0[6:6];
assign TP8_net_0[7]                                 = Testpoints_net_0[7:7];
assign nCsA_slice_0[0]                              = nCsA_net_0[0:0];
assign nCsA_slice_1[1]                              = nCsA_net_0[1:1];
assign nCsA_slice_2[2]                              = nCsA_net_0[2:2];
assign nCsA_slice_3[3]                              = nCsA_net_0[3:3];
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------DMMainPorts
DMMainPorts DMMainPorts_1(
        // Inputs
        .clk            ( FCCC_C0_0_GL0 ),
        .MisoA          ( MisoA ),
        .MisoB          ( MisoB ),
        .MisoC          ( MisoC ),
        .MisoD          ( MisoD ),
        .MisoE          ( MisoE ),
        .MisoF          ( MisoF ),
        .RamBusnCs      ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PSELS0 ),
        .RamBusWrnRd    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWRITES ),
        .RamBusLatch    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PENABLES ),
        .RamBusnCs1     ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PSELS1 ),
        .RamBusWrnRd1   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PWRITES ),
        .RamBusLatch1   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PENABLES ),
        .Rx0            ( Rx0 ),
        .Rx1            ( Rx1 ),
        .Rx2            ( Rx2 ),
        .Rx3            ( VCC_net ),
        .PPS            ( PPS ),
        .RamBusAddress  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDRS13to0 ),
        .RamBusDataIn   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATAS ),
        .RamBusAddress1 ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PADDRS13to0 ),
        .RamBusDataIn1  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PWDATAS ),
        // Outputs
        .MosiA          ( MosiA_net_0 ),
        .MosiB          ( MosiB_net_0 ),
        .MosiC          ( MosiC_net_0 ),
        .MosiD          ( MosiD_net_0 ),
        .MosiE          ( MosiE_net_0 ),
        .MosiF          ( MosiF_net_0 ),
        .SckA           ( SckA_net_0 ),
        .SckB           ( SckB_net_0 ),
        .SckC           ( SckC_net_0 ),
        .SckD           ( SckD_net_0 ),
        .SckE           ( SckE_net_0 ),
        .SckF           ( SckF_net_0 ),
        .nLDacs         ( nLDacs_net_0 ),
        .nRstDacs       ( nRstDacs_net_0 ),
        .nClrDacs       ( nClrDacs_net_0 ),
        .PowerHVnEn     ( PowerHVnEn_net_0 ),
        .RamBusAck      ( DMMainPorts_1_RamBusAck ),
        .RamBusAck1     ( DMMainPorts_1_RamBusAck1 ),
        .Tx0            ( Tx0_net_0 ),
        .Oe0            ( Oe0_net_0 ),
        .Tx1            ( Tx1_net_0 ),
        .Oe1            ( Oe1_net_0 ),
        .Tx2            ( Tx2_net_0 ),
        .Oe2            ( Oe2_net_0 ),
        .Tx3            (  ),
        .Oe3            (  ),
        .nCsA           ( nCsA_net_0 ),
        .nCsB           ( nCsB_net_0 ),
        .nCsC           ( nCsC_net_0 ),
        .nCsD           ( nCsD_net_0 ),
        .nCsE           ( nCsE_net_0 ),
        .nCsF           ( nCsF_net_0 ),
        .RamBusDataOut  ( DMMainPorts_1_RamBusDataOut ),
        .RamBusDataOut1 ( DMMainPorts_1_RamBusDataOut1 ),
        .Testpoints     ( Testpoints_net_0 ),
        // Inouts
        .Ux1SelJmp      ( Ux1SelJmp ) 
        );

//--------EvalSandbox_MSS
EvalSandbox_MSS EvalSandbox_MSS_0(
        // Inputs
        .FAB_RESET_N              ( VCC_net ),
        .AMBA_SLAVE_0_PREADYS0    ( DMMainPorts_1_RamBusAck ),
        .AMBA_SLAVE_0_PSLVERRS0   ( GND_net ),
        .AMBA_SLAVE_0_1_PREADYS1  ( DMMainPorts_1_RamBusAck1 ),
        .AMBA_SLAVE_0_1_PSLVERRS1 ( GND_net ),
        .DEVRST_N                 ( DEVRST_N ),
        .CLK0                     ( FCCC_C0_0_GL0 ),
        .AMBA_SLAVE_0_PRDATAS0    ( DMMainPorts_1_RamBusDataOut ),
        .AMBA_SLAVE_0_1_PRDATAS1  ( DMMainPorts_1_RamBusDataOut1 ),
        // Outputs
        .POWER_ON_RESET_N         (  ),
        .INIT_DONE                (  ),
        .AMBA_SLAVE_0_PSELS0      ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PSELS0 ),
        .AMBA_SLAVE_0_PENABLES    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PENABLES ),
        .AMBA_SLAVE_0_PWRITES     ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWRITES ),
        .AMBA_SLAVE_0_1_PSELS1    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PSELS1 ),
        .AMBA_SLAVE_0_1_PENABLES  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PENABLES ),
        .AMBA_SLAVE_0_1_PWRITES   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PWRITES ),
        .FIC_0_CLK                (  ),
        .FIC_0_LOCK               (  ),
        .MSS_READY                (  ),
        .AMBA_SLAVE_0_PADDRS      ( AMBA_SLAVE_0_PADDRS_net_0 ),
        .AMBA_SLAVE_0_PWDATAS     ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATAS ),
        .AMBA_SLAVE_0_1_PADDRS    ( AMBA_SLAVE_0_1_PADDRS_net_0 ),
        .AMBA_SLAVE_0_1_PWDATAS   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PWDATAS ) 
        );

//--------FCCC_C0
FCCC_C0 FCCC_C0_0(
        // Inputs
        .CLK0_PAD ( CLK0_PAD ),
        // Outputs
        .GL0      ( FCCC_C0_0_GL0 ),
        .GL1      (  ),
        .LOCK     (  ) 
        );

//--------IO_C2
IO_C2 IO_C2_0(
        // Inputs
        .D       ( GND_net ),
        .E       ( GND_net ),
        // Outputs
        .PAD_TRI ( TxUsb_net_0 ) 
        );


endmodule

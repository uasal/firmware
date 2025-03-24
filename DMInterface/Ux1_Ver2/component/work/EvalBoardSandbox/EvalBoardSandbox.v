//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Mar 24 13:54:34 2025
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
    SckA,
    SckB,
    SckC,
    SckD,
    SckE,
    SckF,
    TP1,
    Tx0,
    Tx1,
    Tx2,
    nCsA,
    nCsB,
    nCsC,
    nCsD,
    nCsE,
    nCsF,
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
output       SckA;
output       SckB;
output       SckC;
output       SckD;
output       SckE;
output       SckF;
output       TP1;
output       Tx0;
output       Tx1;
output       Tx2;
output [3:0] nCsA;
output [3:0] nCsB;
output [3:0] nCsC;
output [3:0] nCsD;
output [3:0] nCsE;
output [3:0] nCsF;
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
wire   [31:0] DMMainPorts_1_RamBusDataOut;
wire   [13:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDRS13to0;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PENABLES;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PSELS0;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATAS;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PWRITES;
wire          FCCC_C0_0_GL0;
wire          FCCC_C0_0_GL1;
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
wire          Oe0_net_0;
wire          Oe1_net_0;
wire          Oe2_net_0;
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
wire          Tx0_net_0;
wire          Tx1_net_0;
wire          Tx2_net_0;
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
wire          SckA_net_2;
wire   [3:0]  nCsA_net_1;
wire   [3:0]  nCsB_net_1;
wire   [3:0]  nCsC_net_1;
wire   [3:0]  nCsD_net_1;
wire   [3:0]  nCsE_net_1;
wire   [3:0]  nCsF_net_1;
wire   [31:0] AMBA_SLAVE_0_PADDRS_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          VCC_net;
wire          GND_net;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign VCC_net = 1'b1;
assign GND_net = 1'b0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign Tx0_net_1   = Tx0_net_0;
assign Tx0         = Tx0_net_1;
assign Oe0_net_1   = Oe0_net_0;
assign Oe0         = Oe0_net_1;
assign Tx1_net_1   = Tx1_net_0;
assign Tx1         = Tx1_net_1;
assign Oe1_net_1   = Oe1_net_0;
assign Oe1         = Oe1_net_1;
assign Tx2_net_1   = Tx2_net_0;
assign Tx2         = Tx2_net_1;
assign Oe2_net_1   = Oe2_net_0;
assign Oe2         = Oe2_net_1;
assign MosiA_net_1 = MosiA_net_0;
assign MosiA       = MosiA_net_1;
assign MosiB_net_1 = MosiB_net_0;
assign MosiB       = MosiB_net_1;
assign MosiC_net_1 = MosiC_net_0;
assign MosiC       = MosiC_net_1;
assign MosiD_net_1 = MosiD_net_0;
assign MosiD       = MosiD_net_1;
assign MosiE_net_1 = MosiE_net_0;
assign MosiE       = MosiE_net_1;
assign MosiF_net_1 = MosiF_net_0;
assign MosiF       = MosiF_net_1;
assign SckA_net_1  = SckA_net_0;
assign SckA        = SckA_net_1;
assign SckB_net_1  = SckB_net_0;
assign SckB        = SckB_net_1;
assign SckC_net_1  = SckC_net_0;
assign SckC        = SckC_net_1;
assign SckD_net_1  = SckD_net_0;
assign SckD        = SckD_net_1;
assign SckE_net_1  = SckE_net_0;
assign SckE        = SckE_net_1;
assign SckF_net_1  = SckF_net_0;
assign SckF        = SckF_net_1;
assign SckA_net_2  = SckA_net_0;
assign TP1         = SckA_net_2;
assign nCsA_net_1  = nCsA_net_0;
assign nCsA[3:0]   = nCsA_net_1;
assign nCsB_net_1  = nCsB_net_0;
assign nCsB[3:0]   = nCsB_net_1;
assign nCsC_net_1  = nCsC_net_0;
assign nCsC[3:0]   = nCsC_net_1;
assign nCsD_net_1  = nCsD_net_0;
assign nCsD[3:0]   = nCsD_net_1;
assign nCsE_net_1  = nCsE_net_0;
assign nCsE[3:0]   = nCsE_net_1;
assign nCsF_net_1  = nCsF_net_0;
assign nCsF[3:0]   = nCsF_net_1;
//--------------------------------------------------------------------
// Slices assignments
//--------------------------------------------------------------------
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDRS13to0 = AMBA_SLAVE_0_PADDRS_net_0[13:0];
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------DMMainPorts
DMMainPorts DMMainPorts_1(
        // Inputs
        .clk           ( FCCC_C0_0_GL1 ),
        .MisoA         ( MisoA ),
        .MisoB         ( MisoB ),
        .MisoC         ( MisoC ),
        .MisoD         ( MisoD ),
        .MisoE         ( MisoE ),
        .MisoF         ( MisoF ),
        .RamBusnCs     ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PSELS0 ),
        .RamBusWrnRd   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWRITES ),
        .RamBusLatch   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PENABLES ),
        .Rx0           ( Rx0 ),
        .Rx1           ( Rx1 ),
        .Rx2           ( Rx2 ),
        .Rx3           ( VCC_net ),
        .PPS           ( PPS ),
        .RamBusAddress ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDRS13to0 ),
        .RamBusDataIn  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATAS ),
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
        .RamBusAck     ( DMMainPorts_1_RamBusAck ),
        .Tx0           ( Tx0_net_0 ),
        .Oe0           ( Oe0_net_0 ),
        .Tx1           ( Tx1_net_0 ),
        .Oe1           ( Oe1_net_0 ),
        .Tx2           ( Tx2_net_0 ),
        .Oe2           ( Oe2_net_0 ),
        .Tx3           (  ),
        .Oe3           (  ),
        .nCsA          ( nCsA_net_0 ),
        .nCsB          ( nCsB_net_0 ),
        .nCsC          ( nCsC_net_0 ),
        .nCsD          ( nCsD_net_0 ),
        .nCsE          ( nCsE_net_0 ),
        .nCsF          ( nCsF_net_0 ),
        .RamBusDataOut ( DMMainPorts_1_RamBusDataOut ),
        // Inouts
        .Ux1SelJmp     ( Ux1SelJmp ) 
        );

//--------EvalSandbox_MSS
EvalSandbox_MSS EvalSandbox_MSS_0(
        // Inputs
        .FAB_RESET_N            ( VCC_net ),
        .AMBA_SLAVE_0_PREADYS0  ( DMMainPorts_1_RamBusAck ),
        .AMBA_SLAVE_0_PSLVERRS0 ( GND_net ),
        .DEVRST_N               ( DEVRST_N ),
        .CLK0                   ( FCCC_C0_0_GL0 ),
        .AMBA_SLAVE_0_PRDATAS0  ( DMMainPorts_1_RamBusDataOut ),
        // Outputs
        .POWER_ON_RESET_N       (  ),
        .INIT_DONE              (  ),
        .AMBA_SLAVE_0_PSELS0    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PSELS0 ),
        .AMBA_SLAVE_0_PENABLES  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PENABLES ),
        .AMBA_SLAVE_0_PWRITES   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWRITES ),
        .FIC_0_CLK              (  ),
        .FIC_0_LOCK             (  ),
        .MSS_READY              (  ),
        .AMBA_SLAVE_0_PADDRS    ( AMBA_SLAVE_0_PADDRS_net_0 ),
        .AMBA_SLAVE_0_PWDATAS   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATAS ) 
        );

//--------FCCC_C0
FCCC_C0 FCCC_C0_0(
        // Inputs
        .CLK0_PAD ( CLK0_PAD ),
        // Outputs
        .GL0      ( FCCC_C0_0_GL0 ),
        .GL1      ( FCCC_C0_0_GL1 ),
        .LOCK     (  ) 
        );


endmodule

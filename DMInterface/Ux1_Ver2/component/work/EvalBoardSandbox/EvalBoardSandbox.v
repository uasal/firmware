//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Thu Mar  6 11:26:49 2025
// Version: 2023.2 2023.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// EvalBoardSandbox
module EvalBoardSandbox(
    // Inputs
    CLK0_PAD,
    DEVRST_N,
    Rx0,
    Rx1,
    Rx2,
    Rx3,
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
    Oe3,
    SckA,
    SckB,
    SckC,
    SckD,
    SckE,
    SckF,
    Tx0,
    Tx1,
    Tx2,
    Tx3,
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
input        CLK0_PAD;
input        DEVRST_N;
input        Rx0;
input        Rx1;
input        Rx2;
input        Rx3;
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
output       Oe3;
output       SckA;
output       SckB;
output       SckC;
output       SckD;
output       SckE;
output       SckF;
output       Tx0;
output       Tx1;
output       Tx2;
output       Tx3;
output [3:0] nCsA;
output [3:0] nCsB;
output [3:0] nCsC;
output [3:0] nCsD;
output [3:0] nCsE;
output [3:0] nCsF;
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
wire          Oe0_net_0;
wire          Oe1_net_0;
wire          Oe2_net_0;
wire          Oe3_net_0;
wire          Rx0;
wire          Rx1;
wire          Rx2;
wire          Rx3;
wire          Tx0_net_0;
wire          Tx1_net_0;
wire          Tx2_net_0;
wire          Tx3_net_0;
wire          Tx0_net_1;
wire          Oe0_net_1;
wire          Tx1_net_1;
wire          Oe1_net_1;
wire          Tx2_net_1;
wire          Oe2_net_1;
wire          Tx3_net_1;
wire          Oe3_net_1;
wire   [31:0] AMBA_SLAVE_0_PADDRS_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          VCC_net;
wire   [3:0]  nCsA_const_net_0;
wire   [3:0]  nCsB_const_net_0;
wire   [3:0]  nCsC_const_net_0;
wire   [3:0]  nCsD_const_net_0;
wire   [3:0]  nCsE_const_net_0;
wire   [3:0]  nCsF_const_net_0;
wire          GND_net;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign VCC_net          = 1'b1;
assign nCsA_const_net_0 = 4'hF;
assign nCsB_const_net_0 = 4'hF;
assign nCsC_const_net_0 = 4'hF;
assign nCsD_const_net_0 = 4'hF;
assign nCsE_const_net_0 = 4'hF;
assign nCsF_const_net_0 = 4'hF;
assign GND_net          = 1'b0;
//--------------------------------------------------------------------
// TieOff assignments
//--------------------------------------------------------------------
assign MosiA     = 1'b1;
assign MosiB     = 1'b1;
assign MosiC     = 1'b1;
assign MosiD     = 1'b1;
assign MosiE     = 1'b1;
assign MosiF     = 1'b1;
assign SckA      = 1'b1;
assign SckB      = 1'b1;
assign SckC      = 1'b1;
assign SckD      = 1'b1;
assign SckE      = 1'b1;
assign SckF      = 1'b1;
assign nCsA[3:0] = 4'hF;
assign nCsB[3:0] = 4'hF;
assign nCsC[3:0] = 4'hF;
assign nCsD[3:0] = 4'hF;
assign nCsE[3:0] = 4'hF;
assign nCsF[3:0] = 4'hF;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign Tx0_net_1 = Tx0_net_0;
assign Tx0       = Tx0_net_1;
assign Oe0_net_1 = Oe0_net_0;
assign Oe0       = Oe0_net_1;
assign Tx1_net_1 = Tx1_net_0;
assign Tx1       = Tx1_net_1;
assign Oe1_net_1 = Oe1_net_0;
assign Oe1       = Oe1_net_1;
assign Tx2_net_1 = Tx2_net_0;
assign Tx2       = Tx2_net_1;
assign Oe2_net_1 = Oe2_net_0;
assign Oe2       = Oe2_net_1;
assign Tx3_net_1 = Tx3_net_0;
assign Tx3       = Tx3_net_1;
assign Oe3_net_1 = Oe3_net_0;
assign Oe3       = Oe3_net_1;
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
        .RamBusAddress ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDRS13to0 ),
        .RamBusDataIn  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATAS ),
        .RamBusnCs     ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PSELS0 ),
        .RamBusWrnRd   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWRITES ),
        .RamBusLatch   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PENABLES ),
        .Rx0           ( Rx0 ),
        .Rx1           ( Rx1 ),
        .Rx2           ( Rx2 ),
        .Rx3           ( Rx3 ),
        .PPS           ( VCC_net ),
        // Outputs
        .nCsXO         (  ),
        .SckXO         (  ),
        .MosiXO        (  ),
        .RamBusDataOut ( DMMainPorts_1_RamBusDataOut ),
        .RamBusAck     ( DMMainPorts_1_RamBusAck ),
        .Tx0           ( Tx0_net_0 ),
        .Oe0           ( Oe0_net_0 ),
        .Tx1           ( Tx1_net_0 ),
        .Oe1           ( Oe1_net_0 ),
        .Tx2           ( Tx2_net_0 ),
        .Oe2           ( Oe2_net_0 ),
        .Tx3           ( Tx3_net_0 ),
        .Oe3           ( Oe3_net_0 ),
        // Inouts
        .Ux1SelJmp     ( VCC_net ) 
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

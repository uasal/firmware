//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Fri Apr 11 16:54:19 2025
// Version: 2023.2 2023.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// Ux2FPGA
module Ux2FPGA(
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
    RX3,
    // Outputs
    MosiA,
    MosiB,
    MosiC,
    MosiD,
    MosiE,
    MosiF,
    Oe3,
    SckADCs,
    TP,
    Tx3,
    Ux2Jmp,
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
input        MisoA;
input        MisoB;
input        MisoC;
input        MisoD;
input        MisoE;
input        MisoF;
input        PPS;
input        RX3;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output       MosiA;
output       MosiB;
output       MosiC;
output       MosiD;
output       MosiE;
output       MosiF;
output       Oe3;
output       SckADCs;
output [7:0] TP;
output       Tx3;
output       Ux2Jmp;
output       nCsA;
output       nCsB;
output       nCsC;
output       nCsD;
output       nCsE;
output       nCsF;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          CLK0_PAD;
wire          DEVRST_N;
wire          DMMainPorts_0_RamBusAck;
wire   [31:0] DMMainPorts_0_RamBusDataOut;
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
wire          nCsA_net_0;
wire          nCsB_net_0;
wire          nCsC_net_0;
wire          nCsD_net_0;
wire          nCsE_net_0;
wire          nCsF_net_0;
wire          Oe3_net_0;
wire          PPS;
wire          RX3;
wire          SckADCs_net_0;
wire   [7:0]  TP_net_0;
wire          Tx3_net_0;
wire   [13:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_PADDRS13to0;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_PENABLES;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_PSELS0;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_PWDATAS;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_PWRITES;
wire          Ux2Jmp_net_0;
wire          MosiA_net_1;
wire          nCsA_net_1;
wire          nCsB_net_1;
wire          MosiB_net_1;
wire          MosiC_net_1;
wire          nCsC_net_1;
wire          nCsD_net_1;
wire          MosiD_net_1;
wire          MosiE_net_1;
wire          nCsE_net_1;
wire          MosiF_net_1;
wire          nCsF_net_1;
wire          SckADCs_net_1;
wire          Tx3_net_1;
wire          Oe3_net_1;
wire   [7:0]  TP_net_1;
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
assign MosiA_net_1   = MosiA_net_0;
assign MosiA         = MosiA_net_1;
assign nCsA_net_1    = nCsA_net_0;
assign nCsA          = nCsA_net_1;
assign nCsB_net_1    = nCsB_net_0;
assign nCsB          = nCsB_net_1;
assign MosiB_net_1   = MosiB_net_0;
assign MosiB         = MosiB_net_1;
assign MosiC_net_1   = MosiC_net_0;
assign MosiC         = MosiC_net_1;
assign nCsC_net_1    = nCsC_net_0;
assign nCsC          = nCsC_net_1;
assign nCsD_net_1    = nCsD_net_0;
assign nCsD          = nCsD_net_1;
assign MosiD_net_1   = MosiD_net_0;
assign MosiD         = MosiD_net_1;
assign MosiE_net_1   = MosiE_net_0;
assign MosiE         = MosiE_net_1;
assign nCsE_net_1    = nCsE_net_0;
assign nCsE          = nCsE_net_1;
assign MosiF_net_1   = MosiF_net_0;
assign MosiF         = MosiF_net_1;
assign nCsF_net_1    = nCsF_net_0;
assign nCsF          = nCsF_net_1;
assign SckADCs_net_1 = SckADCs_net_0;
assign SckADCs       = SckADCs_net_1;
assign Tx3_net_1     = Tx3_net_0;
assign Tx3           = Tx3_net_1;
assign Oe3_net_1     = Oe3_net_0;
assign Oe3           = Oe3_net_1;
assign TP_net_1      = TP_net_0;
assign TP[7:0]       = TP_net_1;
//--------------------------------------------------------------------
// Slices assignments
//--------------------------------------------------------------------
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_PADDRS13to0 = AMBA_SLAVE_0_PADDRS_net_0[13:0];
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------DMMainPorts
DMMainPorts DMMainPorts_0(
        // Inputs
        .clk           ( FCCC_C0_0_GL0 ),
        .MisoA         ( MisoA ),
        .MisoB         ( MisoB ),
        .MisoC         ( MisoC ),
        .MisoD         ( MisoD ),
        .MisoE         ( MisoE ),
        .MisoF         ( MisoF ),
        .RamBusnCs     ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PSELS0 ),
        .RamBusWrnRd   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PWRITES ),
        .RamBusLatch   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PENABLES ),
        .Rx3           ( RX3 ),
        .PPS           ( PPS ),
        .RamBusAddress ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PADDRS13to0 ),
        .RamBusDataIn  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PWDATAS ),
        // Outputs
        .MosiA         ( MosiA_net_0 ),
        .MosiB         ( MosiB_net_0 ),
        .MosiC         ( MosiC_net_0 ),
        .MosiD         ( MosiD_net_0 ),
        .MosiE         ( MosiE_net_0 ),
        .MosiF         ( MosiF_net_0 ),
        .SckA          ( SckADCs_net_0 ),
        .SckB          (  ),
        .SckC          (  ),
        .SckD          (  ),
        .SckE          (  ),
        .SckF          (  ),
        .nCsA          ( nCsA_net_0 ),
        .nCsB          ( nCsB_net_0 ),
        .nCsC          ( nCsC_net_0 ),
        .nCsD          ( nCsD_net_0 ),
        .nCsE          ( nCsE_net_0 ),
        .nCsF          ( nCsF_net_0 ),
        .nLDacs        (  ),
        .nRstDacs      (  ),
        .nClrDacs      (  ),
        .PowerHVnEn    (  ),
        .RamBusAck     ( DMMainPorts_0_RamBusAck ),
        .Tx3           ( Tx3_net_0 ),
        .Oe3           ( Oe3_net_0 ),
        .RamBusDataOut ( DMMainPorts_0_RamBusDataOut ),
        .Testpoints    ( TP_net_0 ),
        // Inouts
        .Ux2SelJmp     ( Ux2Jmp_net_0 ) 
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

//--------Ux2FPGA_sb
Ux2FPGA_sb Ux2FPGA_sb_0(
        // Inputs
        .FAB_RESET_N            ( VCC_net ), // tied to 1'b1 from definition
        .AMBA_SLAVE_0_PREADYS0  ( DMMainPorts_0_RamBusAck ),
        .AMBA_SLAVE_0_PSLVERRS0 ( GND_net ), // tied to 1'b0 from definition
        .DEVRST_N               ( DEVRST_N ),
        .CLK0                   ( FCCC_C0_0_GL1 ),
        .AMBA_SLAVE_0_PRDATAS0  ( DMMainPorts_0_RamBusDataOut ),
        // Outputs
        .POWER_ON_RESET_N       (  ),
        .INIT_DONE              (  ),
        .AMBA_SLAVE_0_PSELS0    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PSELS0 ),
        .AMBA_SLAVE_0_PENABLES  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PENABLES ),
        .AMBA_SLAVE_0_PWRITES   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PWRITES ),
        .FIC_0_CLK              (  ),
        .FIC_0_LOCK             (  ),
        .MSS_READY              (  ),
        .AMBA_SLAVE_0_PADDRS    ( AMBA_SLAVE_0_PADDRS_net_0 ),
        .AMBA_SLAVE_0_PWDATAS   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PWDATAS ) 
        );


endmodule

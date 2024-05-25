//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Thu May 23 17:01:22 2024
// Version: 2023.2 2023.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// Filterwheel
module Filterwheel(
    // Inputs
    CLK0_PAD,
    DEVRST_N,
    PosSenseBit0A,
    PosSenseBit0B,
    PosSenseBit1A,
    PosSenseBit1B,
    PosSenseBit2A,
    PosSenseBit2B,
    PosSenseHomeA,
    PosSenseHomeB,
    Rxd0,
    Rxd1,
    Rxd2,
    RxdUsb,
    // Outputs
    INIT_DONE,
    MotorDriveAMinus,
    MotorDriveAMinusPrime,
    MotorDriveAPlus,
    MotorDriveAPlusPrime,
    MotorDriveBMinus,
    MotorDriveBMinusPrime,
    MotorDriveBPlus,
    MotorDriveBPlusPrime,
    Oe0,
    Oe1,
    Oe2,
    PosLEDEnA,
    PosLEDEnB,
    Txd0,
    Txd1,
    Txd2,
    TxdUsb,
    // Inouts
    Ux1SelJmp
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  CLK0_PAD;
input  DEVRST_N;
input  PosSenseBit0A;
input  PosSenseBit0B;
input  PosSenseBit1A;
input  PosSenseBit1B;
input  PosSenseBit2A;
input  PosSenseBit2B;
input  PosSenseHomeA;
input  PosSenseHomeB;
input  Rxd0;
input  Rxd1;
input  Rxd2;
input  RxdUsb;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output INIT_DONE;
output MotorDriveAMinus;
output MotorDriveAMinusPrime;
output MotorDriveAPlus;
output MotorDriveAPlusPrime;
output MotorDriveBMinus;
output MotorDriveBMinusPrime;
output MotorDriveBPlus;
output MotorDriveBPlusPrime;
output Oe0;
output Oe1;
output Oe2;
output PosLEDEnA;
output PosLEDEnB;
output Txd0;
output Txd1;
output Txd2;
output TxdUsb;
//--------------------------------------------------------------------
// Inout
//--------------------------------------------------------------------
inout  Ux1SelJmp;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire           CLK0_PAD;
wire           DEVRST_N;
wire           FCCC_C0_0_GL0;
wire           FCCC_C0_0_GL1;
wire   [9:0]   Filterwheel_sb_0_AMBA_SLAVE_0_PADDRS9to0;
wire           Filterwheel_sb_0_AMBA_SLAVE_0_PENABLES;
wire           Filterwheel_sb_0_AMBA_SLAVE_0_PSELS0;
wire   [15:0]  Filterwheel_sb_0_AMBA_SLAVE_0_PWDATAS15to0;
wire           Filterwheel_sb_0_AMBA_SLAVE_0_PWRITES;
wire           INIT_DONE_net_0;
wire   [15:0]  Main_0_RamBusDataOut;
wire           MotorDriveAMinus_net_0;
wire           MotorDriveAMinusPrime_net_0;
wire           MotorDriveAPlus_net_0;
wire           MotorDriveAPlusPrime_net_0;
wire           MotorDriveBMinus_net_0;
wire           MotorDriveBMinusPrime_net_0;
wire           MotorDriveBPlus_net_0;
wire           MotorDriveBPlusPrime_net_0;
wire           Oe0_net_0;
wire           Oe1_net_0;
wire           Oe2_net_0;
wire           PosLEDEnA_net_0;
wire           PosLEDEnB_net_0;
wire           PosSenseBit0A;
wire           PosSenseBit0B;
wire           PosSenseBit1A;
wire           PosSenseBit1B;
wire           PosSenseBit2A;
wire           PosSenseBit2B;
wire           PosSenseHomeA;
wire           PosSenseHomeB;
wire           Rxd0;
wire           Rxd1;
wire           Rxd2;
wire           RxdUsb;
wire           Txd0_net_0;
wire           Txd1_net_0;
wire           Txd2_net_0;
wire           TxdUsb_net_0;
wire           Ux1SelJmp;
wire           PosLEDEnA_net_1;
wire           PosLEDEnB_net_1;
wire           MotorDriveAPlus_net_1;
wire           MotorDriveAMinus_net_1;
wire           MotorDriveBPlus_net_1;
wire           MotorDriveBMinus_net_1;
wire           MotorDriveAPlusPrime_net_1;
wire           MotorDriveAMinusPrime_net_1;
wire           MotorDriveBPlusPrime_net_1;
wire           MotorDriveBMinusPrime_net_1;
wire           Txd0_net_1;
wire           Txd1_net_1;
wire           Txd2_net_1;
wire           Oe0_net_1;
wire           Oe1_net_1;
wire           Oe2_net_1;
wire           INIT_DONE_net_1;
wire           TxdUsb_net_1;
wire   [31:16] AMBA_SLAVE_0_PWDATAS_slice_0;
wire   [31:0]  AMBA_SLAVE_0_PRDATAS0_net_0;
wire   [31:0]  AMBA_SLAVE_0_PADDRS_net_0;
wire   [31:0]  AMBA_SLAVE_0_PWDATAS_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire           VCC_net;
wire   [31:16] AMBA_SLAVE_0_PRDATAS0_const_net_0;
wire           GND_net;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign VCC_net                           = 1'b1;
assign AMBA_SLAVE_0_PRDATAS0_const_net_0 = 16'h0000;
assign GND_net                           = 1'b0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign PosLEDEnA_net_1             = PosLEDEnA_net_0;
assign PosLEDEnA                   = PosLEDEnA_net_1;
assign PosLEDEnB_net_1             = PosLEDEnB_net_0;
assign PosLEDEnB                   = PosLEDEnB_net_1;
assign MotorDriveAPlus_net_1       = MotorDriveAPlus_net_0;
assign MotorDriveAPlus             = MotorDriveAPlus_net_1;
assign MotorDriveAMinus_net_1      = MotorDriveAMinus_net_0;
assign MotorDriveAMinus            = MotorDriveAMinus_net_1;
assign MotorDriveBPlus_net_1       = MotorDriveBPlus_net_0;
assign MotorDriveBPlus             = MotorDriveBPlus_net_1;
assign MotorDriveBMinus_net_1      = MotorDriveBMinus_net_0;
assign MotorDriveBMinus            = MotorDriveBMinus_net_1;
assign MotorDriveAPlusPrime_net_1  = MotorDriveAPlusPrime_net_0;
assign MotorDriveAPlusPrime        = MotorDriveAPlusPrime_net_1;
assign MotorDriveAMinusPrime_net_1 = MotorDriveAMinusPrime_net_0;
assign MotorDriveAMinusPrime       = MotorDriveAMinusPrime_net_1;
assign MotorDriveBPlusPrime_net_1  = MotorDriveBPlusPrime_net_0;
assign MotorDriveBPlusPrime        = MotorDriveBPlusPrime_net_1;
assign MotorDriveBMinusPrime_net_1 = MotorDriveBMinusPrime_net_0;
assign MotorDriveBMinusPrime       = MotorDriveBMinusPrime_net_1;
assign Txd0_net_1                  = Txd0_net_0;
assign Txd0                        = Txd0_net_1;
assign Txd1_net_1                  = Txd1_net_0;
assign Txd1                        = Txd1_net_1;
assign Txd2_net_1                  = Txd2_net_0;
assign Txd2                        = Txd2_net_1;
assign Oe0_net_1                   = Oe0_net_0;
assign Oe0                         = Oe0_net_1;
assign Oe1_net_1                   = Oe1_net_0;
assign Oe1                         = Oe1_net_1;
assign Oe2_net_1                   = Oe2_net_0;
assign Oe2                         = Oe2_net_1;
assign INIT_DONE_net_1             = INIT_DONE_net_0;
assign INIT_DONE                   = INIT_DONE_net_1;
assign TxdUsb_net_1                = TxdUsb_net_0;
assign TxdUsb                      = TxdUsb_net_1;
//--------------------------------------------------------------------
// Slices assignments
//--------------------------------------------------------------------
assign Filterwheel_sb_0_AMBA_SLAVE_0_PADDRS9to0   = AMBA_SLAVE_0_PADDRS_net_0[9:0];
assign Filterwheel_sb_0_AMBA_SLAVE_0_PWDATAS15to0 = AMBA_SLAVE_0_PWDATAS_net_0[15:0];
assign AMBA_SLAVE_0_PWDATAS_slice_0               = AMBA_SLAVE_0_PWDATAS_net_0[31:16];
//--------------------------------------------------------------------
// Concatenation assignments
//--------------------------------------------------------------------
assign AMBA_SLAVE_0_PRDATAS0_net_0 = { 16'h0000 , Main_0_RamBusDataOut };
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------FCCC_C0
FCCC_C0 FCCC_C0_0(
        // Inputs
        .CLK0_PAD ( CLK0_PAD ),
        // Outputs
        .GL0      ( FCCC_C0_0_GL0 ),
        .GL1      ( FCCC_C0_0_GL1 ),
        .LOCK     (  ) 
        );

//--------Filterwheel_sb
Filterwheel_sb Filterwheel_sb_0(
        // Inputs
        .FAB_RESET_N            ( VCC_net ),
        .AMBA_SLAVE_0_PREADYS0  ( VCC_net ), // tied to 1'b1 from definition
        .AMBA_SLAVE_0_PSLVERRS0 ( GND_net ), // tied to 1'b0 from definition
        .DEVRST_N               ( DEVRST_N ),
        .CLK0                   ( FCCC_C0_0_GL0 ),
        .MMUART_0_RXD_F2M       ( RxdUsb ),
        .AMBA_SLAVE_0_PRDATAS0  ( AMBA_SLAVE_0_PRDATAS0_net_0 ),
        // Outputs
        .POWER_ON_RESET_N       (  ),
        .INIT_DONE              ( INIT_DONE_net_0 ),
        .AMBA_SLAVE_0_PSELS0    ( Filterwheel_sb_0_AMBA_SLAVE_0_PSELS0 ),
        .AMBA_SLAVE_0_PENABLES  ( Filterwheel_sb_0_AMBA_SLAVE_0_PENABLES ),
        .AMBA_SLAVE_0_PWRITES   ( Filterwheel_sb_0_AMBA_SLAVE_0_PWRITES ),
        .FIC_0_CLK              (  ),
        .FIC_0_LOCK             (  ),
        .MSS_READY              (  ),
        .MMUART_0_TXD_M2F       ( TxdUsb_net_0 ),
        .AMBA_SLAVE_0_PADDRS    ( AMBA_SLAVE_0_PADDRS_net_0 ),
        .AMBA_SLAVE_0_PWDATAS   ( AMBA_SLAVE_0_PWDATAS_net_0 ) 
        );

//--------Main
Main Main_0(
        // Inputs
        .clk                   ( FCCC_C0_0_GL1 ),
        .PosSenseHomeA         ( PosSenseHomeA ),
        .PosSenseBit0A         ( PosSenseBit0A ),
        .PosSenseBit1A         ( PosSenseBit1A ),
        .PosSenseBit2A         ( PosSenseBit2A ),
        .PosSenseHomeB         ( PosSenseHomeB ),
        .PosSenseBit0B         ( PosSenseBit0B ),
        .PosSenseBit1B         ( PosSenseBit1B ),
        .PosSenseBit2B         ( PosSenseBit2B ),
        .RamBusnCs             ( Filterwheel_sb_0_AMBA_SLAVE_0_PSELS0 ),
        .RamBusWE              ( Filterwheel_sb_0_AMBA_SLAVE_0_PWRITES ),
        .RamBusOE              ( Filterwheel_sb_0_AMBA_SLAVE_0_PENABLES ),
        .Rxd0                  ( Rxd0 ),
        .Rxd1                  ( Rxd1 ),
        .Rxd2                  ( Rxd2 ),
        .RamBusAddress         ( Filterwheel_sb_0_AMBA_SLAVE_0_PADDRS9to0 ),
        .RamBusDataIn          ( Filterwheel_sb_0_AMBA_SLAVE_0_PWDATAS15to0 ),
        // Outputs
        .PosLEDEnA             ( PosLEDEnA_net_0 ),
        .PosLEDEnB             ( PosLEDEnB_net_0 ),
        .MotorDriveAPlus       ( MotorDriveAPlus_net_0 ),
        .MotorDriveAMinus      ( MotorDriveAMinus_net_0 ),
        .MotorDriveBPlus       ( MotorDriveBPlus_net_0 ),
        .MotorDriveBMinus      ( MotorDriveBMinus_net_0 ),
        .MotorDriveAPlusPrime  ( MotorDriveAPlusPrime_net_0 ),
        .MotorDriveAMinusPrime ( MotorDriveAMinusPrime_net_0 ),
        .MotorDriveBPlusPrime  ( MotorDriveBPlusPrime_net_0 ),
        .MotorDriveBMinusPrime ( MotorDriveBMinusPrime_net_0 ),
        .Txd0                  ( Txd0_net_0 ),
        .Oe0                   ( Oe0_net_0 ),
        .Txd1                  ( Txd1_net_0 ),
        .Oe1                   ( Oe1_net_0 ),
        .Txd2                  ( Txd2_net_0 ),
        .Oe2                   ( Oe2_net_0 ),
        .RamBusDataOut         ( Main_0_RamBusDataOut ),
        // Inouts
        .Ux1SelJmp             ( Ux1SelJmp ) 
        );


endmodule

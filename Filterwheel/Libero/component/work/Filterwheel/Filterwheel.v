//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Wed Apr 24 11:08:06 2024
// Version: 2023.2 2023.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// Filterwheel
module Filterwheel(
    // Inputs
    CLK0_PAD,
    DEVRST_N,
    MisoClk,
    MisoMonitorAdc,
    PosSenseBit0A,
    PosSenseBit0B,
    PosSenseBit1A,
    PosSenseBit1B,
    PosSenseBit2A,
    PosSenseBit2B,
    PosSenseHomeA,
    PosSenseHomeB,
    PpsIn,
    Rxd0,
    Rxd1,
    Rxd2,
    nDrdyMonitorAdc,
    // Outputs
    AnalogPowernEn,
    HVPowernEn,
    MosiClk,
    MosiMonitorAdc,
    MotorDriveAMinus,
    MotorDriveAMinusPrime,
    MotorDriveAPlus,
    MotorDriveAPlusPrime,
    MotorDriveBMinus,
    MotorDriveBMinusPrime,
    MotorDriveBPlus,
    MotorDriveBPlusPrime,
    PosLEDEnA,
    PosLEDEnB,
    PowerSync,
    SckClk,
    SckMonitorAdc,
    Txd0,
    Txd1,
    Txd2,
    UserJmpJstnCse,
    nCsClk,
    nCsMonitorAdc,
    nHVEn
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  CLK0_PAD;
input  DEVRST_N;
input  MisoClk;
input  MisoMonitorAdc;
input  PosSenseBit0A;
input  PosSenseBit0B;
input  PosSenseBit1A;
input  PosSenseBit1B;
input  PosSenseBit2A;
input  PosSenseBit2B;
input  PosSenseHomeA;
input  PosSenseHomeB;
input  PpsIn;
input  Rxd0;
input  Rxd1;
input  Rxd2;
input  nDrdyMonitorAdc;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output AnalogPowernEn;
output HVPowernEn;
output MosiClk;
output MosiMonitorAdc;
output MotorDriveAMinus;
output MotorDriveAMinusPrime;
output MotorDriveAPlus;
output MotorDriveAPlusPrime;
output MotorDriveBMinus;
output MotorDriveBMinusPrime;
output MotorDriveBPlus;
output MotorDriveBPlusPrime;
output PosLEDEnA;
output PosLEDEnB;
output PowerSync;
output SckClk;
output SckMonitorAdc;
output Txd0;
output Txd1;
output Txd2;
output UserJmpJstnCse;
output nCsClk;
output nCsMonitorAdc;
output nHVEn;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          AnalogPowernEn_net_0;
wire          CLK0_PAD;
wire          DEVRST_N;
wire          FCCC_C0_0_GL0;
wire          FCCC_C0_0_GL1;
wire   [9:0]  Filterwheel_sb_0_AMBA_SLAVE_0_HADDR_S09to0;
wire          Filterwheel_sb_0_AMBA_SLAVE_0_HREADY_S0;
wire          Filterwheel_sb_0_AMBA_SLAVE_0_HSEL_S0;
wire          Filterwheel_sb_0_AMBA_SLAVE_0_HWRITE_S0;
wire          HVPowernEn_net_0;
wire          MisoClk;
wire          MisoMonitorAdc;
wire          MosiClk_net_0;
wire          MosiMonitorAdc_net_0;
wire          MotorDriveAMinus_net_0;
wire          MotorDriveAMinusPrime_net_0;
wire          MotorDriveAPlus_net_0;
wire          MotorDriveAPlusPrime_net_0;
wire          MotorDriveBMinus_net_0;
wire          MotorDriveBMinusPrime_net_0;
wire          MotorDriveBPlus_net_0;
wire          MotorDriveBPlusPrime_net_0;
wire          nCsClk_net_0;
wire          nCsMonitorAdc_net_0;
wire          nDrdyMonitorAdc;
wire   [15:0] net_0;
wire          nHVEn_net_0;
wire          PosLEDEnA_net_0;
wire          PosLEDEnB_net_0;
wire          PosSenseBit0A;
wire          PosSenseBit0B;
wire          PosSenseBit1A;
wire          PosSenseBit1B;
wire          PosSenseBit2A;
wire          PosSenseBit2B;
wire          PosSenseHomeA;
wire          PosSenseHomeB;
wire          PowerSync_net_0;
wire          PpsIn;
wire          Rxd0;
wire          Rxd1;
wire          Rxd2;
wire          SckClk_net_0;
wire          SckMonitorAdc_net_0;
wire          Txd0_net_0;
wire          Txd1_net_0;
wire          Txd2_net_0;
wire          UserJmpJstnCse_net_0;
wire          PosLEDEnA_net_1;
wire          PosLEDEnB_net_1;
wire          MotorDriveAPlus_net_1;
wire          MotorDriveAMinus_net_1;
wire          MotorDriveBPlus_net_1;
wire          MotorDriveBMinus_net_1;
wire          MotorDriveAPlusPrime_net_1;
wire          MotorDriveAMinusPrime_net_1;
wire          MotorDriveBPlusPrime_net_1;
wire          MotorDriveBMinusPrime_net_1;
wire          nCsMonitorAdc_net_1;
wire          SckMonitorAdc_net_1;
wire          MosiMonitorAdc_net_1;
wire          Txd0_net_1;
wire          Txd1_net_1;
wire          Txd2_net_1;
wire          nCsClk_net_1;
wire          SckClk_net_1;
wire          MosiClk_net_1;
wire          HVPowernEn_net_1;
wire          nHVEn_net_1;
wire          AnalogPowernEn_net_1;
wire          PowerSync_net_1;
wire          UserJmpJstnCse_net_1;
wire   [31:0] AMBA_SLAVE_0_HRDATA_S0_net_0;
wire   [31:0] AMBA_SLAVE_0_HADDR_S0_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          VCC_net;
wire   [1:0]  AMBA_SLAVE_0_HRESP_S0_const_net_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign VCC_net                           = 1'b1;
assign AMBA_SLAVE_0_HRESP_S0_const_net_0 = 2'h0;
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
assign nCsMonitorAdc_net_1         = nCsMonitorAdc_net_0;
assign nCsMonitorAdc               = nCsMonitorAdc_net_1;
assign SckMonitorAdc_net_1         = SckMonitorAdc_net_0;
assign SckMonitorAdc               = SckMonitorAdc_net_1;
assign MosiMonitorAdc_net_1        = MosiMonitorAdc_net_0;
assign MosiMonitorAdc              = MosiMonitorAdc_net_1;
assign Txd0_net_1                  = Txd0_net_0;
assign Txd0                        = Txd0_net_1;
assign Txd1_net_1                  = Txd1_net_0;
assign Txd1                        = Txd1_net_1;
assign Txd2_net_1                  = Txd2_net_0;
assign Txd2                        = Txd2_net_1;
assign nCsClk_net_1                = nCsClk_net_0;
assign nCsClk                      = nCsClk_net_1;
assign SckClk_net_1                = SckClk_net_0;
assign SckClk                      = SckClk_net_1;
assign MosiClk_net_1               = MosiClk_net_0;
assign MosiClk                     = MosiClk_net_1;
assign HVPowernEn_net_1            = HVPowernEn_net_0;
assign HVPowernEn                  = HVPowernEn_net_1;
assign nHVEn_net_1                 = nHVEn_net_0;
assign nHVEn                       = nHVEn_net_1;
assign AnalogPowernEn_net_1        = AnalogPowernEn_net_0;
assign AnalogPowernEn              = AnalogPowernEn_net_1;
assign PowerSync_net_1             = PowerSync_net_0;
assign PowerSync                   = PowerSync_net_1;
assign UserJmpJstnCse_net_1        = UserJmpJstnCse_net_0;
assign UserJmpJstnCse              = UserJmpJstnCse_net_1;
//--------------------------------------------------------------------
// Slices assignments
//--------------------------------------------------------------------
assign Filterwheel_sb_0_AMBA_SLAVE_0_HADDR_S09to0 = AMBA_SLAVE_0_HADDR_S0_net_0[9:0];
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
        .FAB_RESET_N               ( VCC_net ), // tied to 1'b1 from definition
        .AMBA_SLAVE_0_HREADYOUT_S0 ( VCC_net ), // tied to 1'b1 from definition
        .DEVRST_N                  ( DEVRST_N ),
        .CLK0                      ( FCCC_C0_0_GL0 ),
        .AMBA_SLAVE_0_HRDATA_S0    ( AMBA_SLAVE_0_HRDATA_S0_net_0 ),
        .AMBA_SLAVE_0_HRESP_S0     ( AMBA_SLAVE_0_HRESP_S0_const_net_0 ), // tied to 2'h0 from definition
        // Outputs
        .POWER_ON_RESET_N          (  ),
        .INIT_DONE                 (  ),
        .AMBA_SLAVE_0_HWRITE_S0    ( Filterwheel_sb_0_AMBA_SLAVE_0_HWRITE_S0 ),
        .AMBA_SLAVE_0_HSEL_S0      ( Filterwheel_sb_0_AMBA_SLAVE_0_HSEL_S0 ),
        .AMBA_SLAVE_0_HREADY_S0    ( Filterwheel_sb_0_AMBA_SLAVE_0_HREADY_S0 ),
        .AMBA_SLAVE_0_HMASTLOCK_S0 (  ),
        .FIC_0_CLK                 (  ),
        .FIC_0_LOCK                (  ),
        .MSS_READY                 (  ),
        .AMBA_SLAVE_0_HADDR_S0     ( AMBA_SLAVE_0_HADDR_S0_net_0 ),
        .AMBA_SLAVE_0_HTRANS_S0    (  ),
        .AMBA_SLAVE_0_HSIZE_S0     (  ),
        .AMBA_SLAVE_0_HWDATA_S0    (  ),
        .AMBA_SLAVE_0_HBURST_S0    (  ),
        .AMBA_SLAVE_0_HPROT_S0     (  ) 
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
        .RamBusAddress         ( Filterwheel_sb_0_AMBA_SLAVE_0_HADDR_S09to0 ),
        .RamBusnCs             ( Filterwheel_sb_0_AMBA_SLAVE_0_HSEL_S0 ),
        .RamBusWE              ( Filterwheel_sb_0_AMBA_SLAVE_0_HWRITE_S0 ),
        .RamBusOE              ( Filterwheel_sb_0_AMBA_SLAVE_0_HREADY_S0 ),
        .MisoMonitorAdc        ( MisoMonitorAdc ),
        .nDrdyMonitorAdc       ( nDrdyMonitorAdc ),
        .Rxd0                  ( Rxd0 ),
        .Rxd1                  ( Rxd1 ),
        .Rxd2                  ( Rxd2 ),
        .PpsIn                 ( PpsIn ),
        .MisoClk               ( MisoClk ),
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
        .nCsMonitorAdc         ( nCsMonitorAdc_net_0 ),
        .SckMonitorAdc         ( SckMonitorAdc_net_0 ),
        .MosiMonitorAdc        ( MosiMonitorAdc_net_0 ),
        .Txd0                  ( Txd0_net_0 ),
        .Txd1                  ( Txd1_net_0 ),
        .Txd2                  ( Txd2_net_0 ),
        .nCsClk                ( nCsClk_net_0 ),
        .SckClk                ( SckClk_net_0 ),
        .MosiClk               ( MosiClk_net_0 ),
        .HVPowernEn            ( HVPowernEn_net_0 ),
        .nHVEn                 ( nHVEn_net_0 ),
        .AnalogPowernEn        ( AnalogPowernEn_net_0 ),
        .PowerSync             ( PowerSync_net_0 ),
        .UserJmpJstnCse        ( UserJmpJstnCse_net_0 ),
        // Inouts
        .RamBusData            ( net_0 ) 
        );


endmodule

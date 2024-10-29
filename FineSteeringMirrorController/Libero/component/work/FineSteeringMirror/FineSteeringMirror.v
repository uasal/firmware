//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Oct 28 15:39:29 2024
// Version: 2023.2 2023.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// FineSteeringMirror
module FineSteeringMirror(
    // Inputs
    DEVRST_N,
    DInExt,
    Fault1V,
    Fault2VA,
    Fault2VD,
    Fault3VA,
    Fault3VD,
    Fault5V,
    FaultHV,
    FaultNegV,
    MisoAdcA,
    MisoAdcB,
    MisoAdcC,
    MisoAdcD,
    MisoMonAdc0,
    MisoMonAdc1,
    PPS,
    PowerCycd,
    Rx0,
    Rx1,
    Rx2,
    Rx3,
    TxdLab,
    XO1,
    nDrdyAdcA,
    nDrdyAdcB,
    nDrdyAdcC,
    nDrdyAdcD,
    nDrdyMonAdc0,
    nDrdyMonAdc1,
    nHVFaultA,
    nHVFaultB,
    nHVFaultC,
    nHVFaultD,
    // Outputs
    ChopAdc,
    ChopRef,
    CtsUsb,
    GlobalFaultInhibit,
    HVDis2,
    MosiMonAdcs,
    MosiXO,
    Oe0,
    Oe1,
    Oe2,
    Oe3,
    PowerEnMax,
    PowerEnTi,
    PowerSync,
    PowernEn,
    PowernEnHV,
    RxdLab,
    SckAdcs,
    SckMonAdcs,
    SckXO,
    TrigAdcs,
    TrigMonAdcs,
    Tx0,
    Tx1,
    Tx2,
    Tx3,
    nCsAdcs,
    nCsMonAdcs,
    nCsXO,
    nFaultsClr,
    nHVEn1,
    nPowerCycClr,
    // Inouts
    DOutExt,
    MisoExt,
    MosiDacAMax,
    MosiDacATi,
    MosiDacBMax,
    MosiDacBTi,
    MosiDacCMax,
    MosiDacCTi,
    MosiDacDMax,
    MosiDacDTi,
    MosiExt,
    SckDacsMax,
    SckDacsTi,
    SckExt,
    Ux1SelJmp,
    nCsDacsMax,
    nCsDacsTi,
    nCsExt,
    nLDacsMax
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  DEVRST_N;
input  DInExt;
input  Fault1V;
input  Fault2VA;
input  Fault2VD;
input  Fault3VA;
input  Fault3VD;
input  Fault5V;
input  FaultHV;
input  FaultNegV;
input  MisoAdcA;
input  MisoAdcB;
input  MisoAdcC;
input  MisoAdcD;
input  MisoMonAdc0;
input  MisoMonAdc1;
input  PPS;
input  PowerCycd;
input  Rx0;
input  Rx1;
input  Rx2;
input  Rx3;
input  TxdLab;
input  XO1;
input  nDrdyAdcA;
input  nDrdyAdcB;
input  nDrdyAdcC;
input  nDrdyAdcD;
input  nDrdyMonAdc0;
input  nDrdyMonAdc1;
input  nHVFaultA;
input  nHVFaultB;
input  nHVFaultC;
input  nHVFaultD;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output ChopAdc;
output ChopRef;
output CtsUsb;
output GlobalFaultInhibit;
output HVDis2;
output MosiMonAdcs;
output MosiXO;
output Oe0;
output Oe1;
output Oe2;
output Oe3;
output PowerEnMax;
output PowerEnTi;
output PowerSync;
output PowernEn;
output PowernEnHV;
output RxdLab;
output SckAdcs;
output SckMonAdcs;
output SckXO;
output TrigAdcs;
output TrigMonAdcs;
output Tx0;
output Tx1;
output Tx2;
output Tx3;
output nCsAdcs;
output nCsMonAdcs;
output nCsXO;
output nFaultsClr;
output nHVEn1;
output nPowerCycClr;
//--------------------------------------------------------------------
// Inout
//--------------------------------------------------------------------
inout  DOutExt;
inout  MisoExt;
inout  MosiDacAMax;
inout  MosiDacATi;
inout  MosiDacBMax;
inout  MosiDacBTi;
inout  MosiDacCMax;
inout  MosiDacCTi;
inout  MosiDacDMax;
inout  MosiDacDTi;
inout  MosiExt;
inout  SckDacsMax;
inout  SckDacsTi;
inout  SckExt;
inout  Ux1SelJmp;
inout  nCsDacsMax;
inout  nCsDacsTi;
inout  nCsExt;
inout  nLDacsMax;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          ChopAdc_net_0;
wire          ChopRef_net_0;
wire          CtsUsb_net_0;
wire          DEVRST_N;
wire          DInExt;
wire          DOutExt;
wire          Fault1V;
wire          Fault2VA;
wire          Fault2VD;
wire          Fault3VA;
wire          Fault3VD;
wire          Fault5V;
wire          FaultHV;
wire          FaultNegV;
wire          FCCC_C0_0_GL0;
wire          FCCC_C0_0_GL1;
wire   [9:0]  FineSteeringMirror_sb_0_AMBA_SLAVE_0_PADDRS9to0;
wire          FineSteeringMirror_sb_0_AMBA_SLAVE_0_PENABLES;
wire          FineSteeringMirror_sb_0_AMBA_SLAVE_0_PSELS0;
wire   [31:0] FineSteeringMirror_sb_0_AMBA_SLAVE_0_PWDATAS;
wire          FineSteeringMirror_sb_0_AMBA_SLAVE_0_PWRITES;
wire          GlobalFaultInhibit_net_0;
wire          HVDis2_net_0;
wire          Main_0_RamBusAck;
wire   [31:0] Main_0_RamBusDataOut;
wire          MisoAdcA;
wire          MisoAdcB;
wire          MisoAdcC;
wire          MisoAdcD;
wire          MisoExt;
wire          MisoMonAdc0;
wire          MisoMonAdc1;
wire          MosiDacAMax;
wire          MosiDacATi;
wire          MosiDacBMax;
wire          MosiDacBTi;
wire          MosiDacCMax;
wire          MosiDacCTi;
wire          MosiDacDMax;
wire          MosiDacDTi;
wire          MosiExt;
wire          MosiMonAdcs_net_0;
wire          MosiXO_net_0;
wire          nCsAdcs_net_0;
wire          nCsDacsMax;
wire          nCsDacsTi;
wire          nCsExt;
wire          nCsMonAdcs_net_0;
wire          nCsXO_net_0;
wire          nDrdyAdcA;
wire          nDrdyAdcB;
wire          nDrdyAdcC;
wire          nDrdyAdcD;
wire          nDrdyMonAdc0;
wire          nDrdyMonAdc1;
wire          nFaultsClr_net_0;
wire          nHVEn1_net_0;
wire          nHVFaultA;
wire          nHVFaultB;
wire          nHVFaultC;
wire          nHVFaultD;
wire          nLDacsMax;
wire          nPowerCycClr_net_0;
wire          Oe0_net_0;
wire          Oe1_net_0;
wire          Oe2_net_0;
wire          Oe3_net_0;
wire          PowerCycd;
wire          PowerEnMax_net_0;
wire          PowerEnTi_net_0;
wire          PowernEn_net_0;
wire          PowernEnHV_net_0;
wire          PowerSync_net_0;
wire          PPS;
wire          Rx0;
wire          Rx1;
wire          Rx2;
wire          Rx3;
wire          RxdLab_net_0;
wire          SckAdcs_net_0;
wire          SckDacsMax;
wire          SckDacsTi;
wire          SckExt;
wire          SckMonAdcs_net_0;
wire          SckXO_net_0;
wire          TrigAdcs_net_0;
wire          TrigMonAdcs_net_0;
wire          Tx0_net_0;
wire          Tx1_net_0;
wire          Tx2_net_0;
wire          Tx3_net_0;
wire          TxdLab;
wire          Ux1SelJmp;
wire          XO1;
wire          Oe0_net_1;
wire          Oe1_net_1;
wire          Oe2_net_1;
wire          nCsXO_net_1;
wire          SckXO_net_1;
wire          MosiXO_net_1;
wire          Oe3_net_1;
wire          CtsUsb_net_1;
wire          nPowerCycClr_net_1;
wire          PowerSync_net_1;
wire          PowernEn_net_1;
wire          HVDis2_net_1;
wire          PowernEnHV_net_1;
wire          ChopRef_net_1;
wire          ChopAdc_net_1;
wire          TrigAdcs_net_1;
wire          SckAdcs_net_1;
wire          PowerEnTi_net_1;
wire          PowerEnMax_net_1;
wire          nHVEn1_net_1;
wire          nCsAdcs_net_1;
wire          RxdLab_net_1;
wire          nCsMonAdcs_net_1;
wire          SckMonAdcs_net_1;
wire          MosiMonAdcs_net_1;
wire          TrigMonAdcs_net_1;
wire          GlobalFaultInhibit_net_1;
wire          nFaultsClr_net_1;
wire          Tx0_net_1;
wire          Tx1_net_1;
wire          Tx2_net_1;
wire          Tx3_net_1;
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
assign Oe0_net_1                = Oe0_net_0;
assign Oe0                      = Oe0_net_1;
assign Oe1_net_1                = Oe1_net_0;
assign Oe1                      = Oe1_net_1;
assign Oe2_net_1                = Oe2_net_0;
assign Oe2                      = Oe2_net_1;
assign nCsXO_net_1              = nCsXO_net_0;
assign nCsXO                    = nCsXO_net_1;
assign SckXO_net_1              = SckXO_net_0;
assign SckXO                    = SckXO_net_1;
assign MosiXO_net_1             = MosiXO_net_0;
assign MosiXO                   = MosiXO_net_1;
assign Oe3_net_1                = Oe3_net_0;
assign Oe3                      = Oe3_net_1;
assign CtsUsb_net_1             = CtsUsb_net_0;
assign CtsUsb                   = CtsUsb_net_1;
assign nPowerCycClr_net_1       = nPowerCycClr_net_0;
assign nPowerCycClr             = nPowerCycClr_net_1;
assign PowerSync_net_1          = PowerSync_net_0;
assign PowerSync                = PowerSync_net_1;
assign PowernEn_net_1           = PowernEn_net_0;
assign PowernEn                 = PowernEn_net_1;
assign HVDis2_net_1             = HVDis2_net_0;
assign HVDis2                   = HVDis2_net_1;
assign PowernEnHV_net_1         = PowernEnHV_net_0;
assign PowernEnHV               = PowernEnHV_net_1;
assign ChopRef_net_1            = ChopRef_net_0;
assign ChopRef                  = ChopRef_net_1;
assign ChopAdc_net_1            = ChopAdc_net_0;
assign ChopAdc                  = ChopAdc_net_1;
assign TrigAdcs_net_1           = TrigAdcs_net_0;
assign TrigAdcs                 = TrigAdcs_net_1;
assign SckAdcs_net_1            = SckAdcs_net_0;
assign SckAdcs                  = SckAdcs_net_1;
assign PowerEnTi_net_1          = PowerEnTi_net_0;
assign PowerEnTi                = PowerEnTi_net_1;
assign PowerEnMax_net_1         = PowerEnMax_net_0;
assign PowerEnMax               = PowerEnMax_net_1;
assign nHVEn1_net_1             = nHVEn1_net_0;
assign nHVEn1                   = nHVEn1_net_1;
assign nCsAdcs_net_1            = nCsAdcs_net_0;
assign nCsAdcs                  = nCsAdcs_net_1;
assign RxdLab_net_1             = RxdLab_net_0;
assign RxdLab                   = RxdLab_net_1;
assign nCsMonAdcs_net_1         = nCsMonAdcs_net_0;
assign nCsMonAdcs               = nCsMonAdcs_net_1;
assign SckMonAdcs_net_1         = SckMonAdcs_net_0;
assign SckMonAdcs               = SckMonAdcs_net_1;
assign MosiMonAdcs_net_1        = MosiMonAdcs_net_0;
assign MosiMonAdcs              = MosiMonAdcs_net_1;
assign TrigMonAdcs_net_1        = TrigMonAdcs_net_0;
assign TrigMonAdcs              = TrigMonAdcs_net_1;
assign GlobalFaultInhibit_net_1 = GlobalFaultInhibit_net_0;
assign GlobalFaultInhibit       = GlobalFaultInhibit_net_1;
assign nFaultsClr_net_1         = nFaultsClr_net_0;
assign nFaultsClr               = nFaultsClr_net_1;
assign Tx0_net_1                = Tx0_net_0;
assign Tx0                      = Tx0_net_1;
assign Tx1_net_1                = Tx1_net_0;
assign Tx1                      = Tx1_net_1;
assign Tx2_net_1                = Tx2_net_0;
assign Tx2                      = Tx2_net_1;
assign Tx3_net_1                = Tx3_net_0;
assign Tx3                      = Tx3_net_1;
//--------------------------------------------------------------------
// Slices assignments
//--------------------------------------------------------------------
assign FineSteeringMirror_sb_0_AMBA_SLAVE_0_PADDRS9to0 = AMBA_SLAVE_0_PADDRS_net_0[9:0];
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------FCCC_C0
FCCC_C0 FCCC_C0_0(
        // Inputs
        .CLK0_PAD ( XO1 ),
        // Outputs
        .GL0      ( FCCC_C0_0_GL0 ),
        .GL1      ( FCCC_C0_0_GL1 ),
        .LOCK     (  ) 
        );

//--------FineSteeringMirror_sb
FineSteeringMirror_sb FineSteeringMirror_sb_0(
        // Inputs
        .FAB_RESET_N            ( VCC_net ),
        .AMBA_SLAVE_0_PREADYS0  ( Main_0_RamBusAck ),
        .AMBA_SLAVE_0_PSLVERRS0 ( GND_net ),
        .DEVRST_N               ( DEVRST_N ),
        .CLK0                   ( FCCC_C0_0_GL0 ),
        .MMUART_0_RXD_F2M       ( VCC_net ),
        .AMBA_SLAVE_0_PRDATAS0  ( Main_0_RamBusDataOut ),
        // Outputs
        .POWER_ON_RESET_N       (  ),
        .INIT_DONE              (  ),
        .AMBA_SLAVE_0_PSELS0    ( FineSteeringMirror_sb_0_AMBA_SLAVE_0_PSELS0 ),
        .AMBA_SLAVE_0_PENABLES  ( FineSteeringMirror_sb_0_AMBA_SLAVE_0_PENABLES ),
        .AMBA_SLAVE_0_PWRITES   ( FineSteeringMirror_sb_0_AMBA_SLAVE_0_PWRITES ),
        .FIC_0_CLK              (  ),
        .FIC_0_LOCK             (  ),
        .MSS_READY              (  ),
        .MMUART_0_TXD_M2F       (  ),
        .AMBA_SLAVE_0_PADDRS    ( AMBA_SLAVE_0_PADDRS_net_0 ),
        .AMBA_SLAVE_0_PWDATAS   ( FineSteeringMirror_sb_0_AMBA_SLAVE_0_PWDATAS ) 
        );

//--------Main
Main Main_0(
        // Inputs
        .clk                ( FCCC_C0_0_GL1 ),
        .nHVFaultA          ( nHVFaultA ),
        .nHVFaultB          ( nHVFaultB ),
        .nHVFaultC          ( nHVFaultC ),
        .nHVFaultD          ( nHVFaultD ),
        .MisoAdcA           ( MisoAdcA ),
        .MisoAdcB           ( MisoAdcB ),
        .MisoAdcC           ( MisoAdcC ),
        .MisoAdcD           ( MisoAdcD ),
        .nDrdyAdcA          ( nDrdyAdcA ),
        .nDrdyAdcB          ( nDrdyAdcB ),
        .nDrdyAdcC          ( nDrdyAdcC ),
        .nDrdyAdcD          ( nDrdyAdcD ),
        .RamBusAddress      ( FineSteeringMirror_sb_0_AMBA_SLAVE_0_PADDRS9to0 ),
        .RamBusDataIn       ( FineSteeringMirror_sb_0_AMBA_SLAVE_0_PWDATAS ),
        .RamBusnCs          ( FineSteeringMirror_sb_0_AMBA_SLAVE_0_PSELS0 ),
        .RamBusWrnRd        ( FineSteeringMirror_sb_0_AMBA_SLAVE_0_PWRITES ),
        .RamBusLatch        ( FineSteeringMirror_sb_0_AMBA_SLAVE_0_PENABLES ),
        .Rx0                ( Rx0 ),
        .Rx1                ( Rx1 ),
        .Rx2                ( Rx2 ),
        .Rx3                ( Rx3 ),
        .TxdLab             ( TxdLab ),
        .PPS                ( PPS ),
        .MisoMonAdc0        ( MisoMonAdc0 ),
        .nDrdyMonAdc0       ( nDrdyMonAdc0 ),
        .MisoMonAdc1        ( MisoMonAdc1 ),
        .nDrdyMonAdc1       ( nDrdyMonAdc1 ),
        .PowerCycd          ( PowerCycd ),
        .FaultNegV          ( FaultNegV ),
        .Fault1V            ( Fault1V ),
        .Fault2VA           ( Fault2VA ),
        .Fault2VD           ( Fault2VD ),
        .Fault3VA           ( Fault3VA ),
        .Fault3VD           ( Fault3VD ),
        .Fault5V            ( Fault5V ),
        .FaultHV            ( FaultHV ),
        .DInExt             ( DInExt ),
        // Outputs
        .nCsXO              ( nCsXO_net_0 ),
        .SckXO              ( SckXO_net_0 ),
        .MosiXO             ( MosiXO_net_0 ),
        .PowerEnTi          ( PowerEnTi_net_0 ),
        .PowerEnMax         ( PowerEnMax_net_0 ),
        .nHVEn1             ( nHVEn1_net_0 ),
        .HVDis2             ( HVDis2_net_0 ),
        .PowernEnHV         ( PowernEnHV_net_0 ),
        .ChopRef            ( ChopRef_net_0 ),
        .ChopAdcs           ( ChopAdc_net_0 ),
        .TrigAdcs           ( TrigAdcs_net_0 ),
        .SckAdcs            ( SckAdcs_net_0 ),
        .nCsAdcs            ( nCsAdcs_net_0 ),
        .RamBusDataOut      ( Main_0_RamBusDataOut ),
        .RamBusAck          ( Main_0_RamBusAck ),
        .Tx0                ( Tx0_net_0 ),
        .Oe0                ( Oe0_net_0 ),
        .Tx1                ( Tx1_net_0 ),
        .Oe1                ( Oe1_net_0 ),
        .Tx2                ( Tx2_net_0 ),
        .Oe2                ( Oe2_net_0 ),
        .Tx3                ( Tx3_net_0 ),
        .Oe3                ( Oe3_net_0 ),
        .RxdLab             ( RxdLab_net_0 ),
        .CtsUsb             ( CtsUsb_net_0 ),
        .nCsMonAdcs         ( nCsMonAdcs_net_0 ),
        .SckMonAdcs         ( SckMonAdcs_net_0 ),
        .MosiMonAdcs        ( MosiMonAdcs_net_0 ),
        .TrigMonAdcs        ( TrigMonAdcs_net_0 ),
        .PowerSync          ( PowerSync_net_0 ),
        .PowernEn           ( PowernEn_net_0 ),
        .GlobalFaultInhibit ( GlobalFaultInhibit_net_0 ),
        .nFaultsClr         ( nFaultsClr_net_0 ),
        .nPowerCycClr       ( nPowerCycClr_net_0 ),
        // Inouts
        .MosiTiDacA         ( MosiDacATi ),
        .MosiTiDacB         ( MosiDacBTi ),
        .MosiTiDacC         ( MosiDacCTi ),
        .MosiTiDacD         ( MosiDacDTi ),
        .SckTiDacs          ( SckDacsTi ),
        .nCsTiDacs          ( nCsDacsTi ),
        .MosiMaxDacA        ( MosiDacAMax ),
        .MosiMaxDacB        ( MosiDacBMax ),
        .MosiMaxDacC        ( MosiDacCMax ),
        .MosiMaxDacD        ( MosiDacDMax ),
        .SckMaxDacs         ( SckDacsMax ),
        .nCsMaxDacs         ( nCsDacsMax ),
        .nLoadMaxDacs       ( nLDacsMax ),
        .SckExt             ( SckExt ),
        .MosiExt            ( MosiExt ),
        .MisoExt            ( MisoExt ),
        .nCsExt             ( nCsExt ),
        .DOutExt            ( DOutExt ),
        .Ux1SelJmp          ( Ux1SelJmp ) 
        );


endmodule

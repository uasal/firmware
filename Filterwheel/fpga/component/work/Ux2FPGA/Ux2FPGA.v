//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Tue Mar 12 14:37:06 2024
// Version: 2023.2 2023.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// Ux2FPGA
module Ux2FPGA(
    // Inputs
    CLK0,
    DEVRST_N,
    MisoA,
    MisoB,
    MisoC,
    MisoD,
    MisoE,
    MisoF,
    MisoMon0,
    MisoMon1,
    PAD_IN_0,
    RX,
    // Outputs
    MosiA,
    MosiB,
    MosiC,
    MosiD,
    MosiE,
    MosiF,
    MosiMonAdc,
    PAD_OUT,
    SckADCs,
    SckMonAdc,
    Tx,
    nCsA,
    nCsB,
    nCsC,
    nCsD,
    nCsE,
    nCsF,
    nCsMonAdc,
    test
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
input        MisoMon0;
input        MisoMon1;
input  [8:0] PAD_IN_0;
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
output       MosiMonAdc;
output [3:0] PAD_OUT;
output       SckADCs;
output       SckMonAdc;
output [0:0] Tx;
output       nCsA;
output       nCsB;
output       nCsC;
output       nCsD;
output       nCsE;
output       nCsF;
output       nCsMonAdc;
output [1:8] test;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          AND4_0_Y;
wire          CLK0;
wire          CoreUARTapb_C0_0_RXRDY;
wire          CoreUARTapb_C0_0_TX;
wire          CoreUARTapb_C0_0_TXRDY;
wire          DEVRST_N;
wire   [0:0]  IO_INPUTS_Y0to0;
wire   [1:1]  IO_INPUTS_Y1to1;
wire   [2:2]  IO_INPUTS_Y2to2;
wire   [3:3]  IO_INPUTS_Y3to3;
wire   [4:4]  IO_INPUTS_Y4to4;
wire   [5:5]  IO_INPUTS_Y5to5;
wire   [6:6]  IO_INPUTS_Y6to6;
wire   [7:7]  IO_INPUTS_Y7to7;
wire   [8:8]  IO_INPUTS_Y8to8;
wire          MisoA;
wire          MisoB;
wire          MisoC;
wire          MisoD;
wire          MisoE;
wire          MisoF;
wire          MisoMon0;
wire          MisoMon1;
wire          MosiB_net_0;
wire          MosiC_net_0;
wire          MosiD_net_0;
wire          MosiE_net_0;
wire          MosiF_net_0;
wire          MosiMonAdc_net_0;
wire   [0:0]  nCsB_net_0;
wire   [0:0]  nCsC_net_0;
wire   [0:0]  nCsD_net_0;
wire   [0:0]  nCsE_net_0;
wire   [0:0]  nCsF_net_0;
wire   [0:0]  nCsMonAdc_net_0;
wire          OR4_0_Y;
wire          OR4_1_Y;
wire   [8:0]  PAD_IN_0;
wire   [3:0]  PAD_OUT_net_0;
wire          RX;
wire          SckADCs_net_0;
wire          SckMonAdc_net_0;
wire          SpiMasterPorts_0_Sck;
wire          SpiMasterPorts_0_XferComplete;
wire          SpiMasterPorts_1_Sck;
wire          SpiMasterPorts_1_XferComplete;
wire          SpiMasterPorts_2_Sck;
wire          SpiMasterPorts_2_XferComplete;
wire          SpiMasterPorts_3_Sck;
wire          SpiMasterPorts_3_XferComplete;
wire          SpiMasterPorts_4_Sck;
wire          SpiMasterPorts_4_XferComplete;
wire          SpiMasterPorts_5_Sck;
wire          SpiMasterPorts_5_XferComplete;
wire          SpiMasterPorts_6_XferComplete;
wire          SpiMasterPorts_7_XferComplete;
wire   [0:0]  test_0;
wire          test_2;
wire          test_3;
wire   [0:0]  Tx_net_0;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_PENABLE;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_PREADY;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_PSELx;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_PSLVERR;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_PWRITE;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PADDR;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PENABLE;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PREADY;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PSELx;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PWDATA;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PWRITE;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PADDR;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PENABLE;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PREADY;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PSELx;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PWDATA;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PWRITE;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PADDR;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PENABLE;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PREADY;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PSELx;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PWDATA;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PWRITE;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PADDR;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PENABLE;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PREADY;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PSELx;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PWDATA;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PWRITE;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PADDR;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PENABLE;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PREADY;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PSELx;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PWDATA;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PWRITE;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PADDR;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PENABLE;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PREADY;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PSELx;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PWDATA;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PWRITE;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PADDR;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PENABLE;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PREADY;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PSELx;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PWDATA;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PWRITE;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PADDR;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PENABLE;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PREADY;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PSELx;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PWDATA;
wire          Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PWRITE;
wire          Ux2FPGA_sb_0_FIC_0_CLK;
wire          Ux2FPGA_sb_0_GPIO_1_M2F;
wire          Ux2FPGA_sb_0_GPIO_4_M2F;
wire          Ux2FPGA_sb_0_GPIO_5_M2F;
wire          Ux2FPGA_sb_0_GPIO_6_M2F;
wire          Ux2FPGA_sb_0_GPIO_7_M2F;
wire          test_2_net_0;
wire          test_0_net_0;
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
wire          nCsMonAdc_net_1;
wire          MosiMonAdc_net_1;
wire          SckMonAdc_net_1;
wire          SckADCs_net_1;
wire   [3:0]  PAD_OUT_net_1;
wire   [0:0]  Tx_net_1;
wire   [1:1]  SckADCs_net_2;
wire   [2:2]  test_0_net_1;
wire   [3:3]  test_3_net_0;
wire   [4:4]  test_2_net_1;
wire   [1:1]  nCs_slice_0;
wire   [2:2]  nCs_slice_1;
wire   [3:3]  nCs_slice_2;
wire   [1:1]  nCs_slice_3;
wire   [2:2]  nCs_slice_4;
wire   [3:3]  nCs_slice_5;
wire   [1:1]  nCs_slice_6;
wire   [2:2]  nCs_slice_7;
wire   [3:3]  nCs_slice_8;
wire   [1:1]  nCs_slice_9;
wire   [2:2]  nCs_slice_10;
wire   [3:3]  nCs_slice_11;
wire   [1:1]  nCs_slice_12;
wire   [2:2]  nCs_slice_13;
wire   [3:3]  nCs_slice_14;
wire   [1:1]  nCs_slice_15;
wire   [2:2]  nCs_slice_16;
wire   [3:3]  nCs_slice_17;
wire   [1:1]  nCs_slice_18;
wire   [2:2]  nCs_slice_19;
wire   [3:3]  nCs_slice_20;
wire   [0:0]  nCs_slice_21;
wire   [1:1]  nCs_slice_22;
wire   [2:2]  nCs_slice_23;
wire   [3:3]  nCs_slice_24;
wire   [8:0]  Y_net_0;
wire   [3:0]  D_net_0;
wire   [3:0]  nCs_net_0;
wire   [3:0]  nCs_net_1;
wire   [3:0]  nCs_net_2;
wire   [3:0]  nCs_net_3;
wire   [3:0]  nCs_net_4;
wire   [3:0]  nCs_net_5;
wire   [3:0]  nCs_net_6;
wire   [3:0]  nCs_net_7;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
wire          VCC_net;
//--------------------------------------------------------------------
// Inverted Nets
//--------------------------------------------------------------------
wire          TXRDY_OUT_PRE_INV0_0;
//--------------------------------------------------------------------
// Bus Interface Nets Declarations - Unequal Pin Widths
//--------------------------------------------------------------------
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_PADDR;
wire   [4:0]  Ux2FPGA_sb_0_AMBA_SLAVE_0_PADDR_0;
wire   [4:0]  Ux2FPGA_sb_0_AMBA_SLAVE_0_PADDR_0_4to0;
wire   [7:0]  Ux2FPGA_sb_0_AMBA_SLAVE_0_PRDATA;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_PRDATA_0;
wire   [31:8] Ux2FPGA_sb_0_AMBA_SLAVE_0_PRDATA_0_31to8;
wire   [7:0]  Ux2FPGA_sb_0_AMBA_SLAVE_0_PRDATA_0_7to0;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_PWDATA;
wire   [7:0]  Ux2FPGA_sb_0_AMBA_SLAVE_0_PWDATA_0;
wire   [7:0]  Ux2FPGA_sb_0_AMBA_SLAVE_0_PWDATA_0_7to0;
wire   [23:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PRDATA;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PRDATA_0;
wire   [23:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PRDATA_0_23to0;
wire   [31:24]Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PRDATA_0_31to24;
wire   [23:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PRDATA;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PRDATA_0;
wire   [23:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PRDATA_0_23to0;
wire   [31:24]Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PRDATA_0_31to24;
wire   [23:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PRDATA;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PRDATA_0;
wire   [23:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PRDATA_0_23to0;
wire   [31:24]Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PRDATA_0_31to24;
wire   [23:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PRDATA;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PRDATA_0;
wire   [23:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PRDATA_0_23to0;
wire   [31:24]Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PRDATA_0_31to24;
wire   [23:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PRDATA;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PRDATA_0;
wire   [23:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PRDATA_0_23to0;
wire   [31:24]Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PRDATA_0_31to24;
wire   [23:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PRDATA;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PRDATA_0;
wire   [23:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PRDATA_0_23to0;
wire   [31:24]Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PRDATA_0_31to24;
wire   [23:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PRDATA;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PRDATA_0;
wire   [23:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PRDATA_0_23to0;
wire   [31:24]Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PRDATA_0_31to24;
wire   [23:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PRDATA;
wire   [31:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PRDATA_0;
wire   [23:0] Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PRDATA_0_23to0;
wire   [31:24]Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PRDATA_0_31to24;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net    = 1'b0;
assign VCC_net    = 1'b1;
//--------------------------------------------------------------------
// Inversions
//--------------------------------------------------------------------
assign CoreUARTapb_C0_0_TXRDY = ~ TXRDY_OUT_PRE_INV0_0;
//--------------------------------------------------------------------
// TieOff assignments
//--------------------------------------------------------------------
assign test[5:5]        = 1'b0;
assign test[6:6]        = 1'b0;
assign test[7:7]        = 1'b0;
assign test[8:8]        = 1'b0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign test_2_net_0     = test_2;
assign MosiA            = test_2_net_0;
assign test_0_net_0     = test_0[0];
assign nCsA             = test_0_net_0;
assign nCsB_net_1       = nCsB_net_0[0];
assign nCsB             = nCsB_net_1;
assign MosiB_net_1      = MosiB_net_0;
assign MosiB            = MosiB_net_1;
assign MosiC_net_1      = MosiC_net_0;
assign MosiC            = MosiC_net_1;
assign nCsC_net_1       = nCsC_net_0[0];
assign nCsC             = nCsC_net_1;
assign nCsD_net_1       = nCsD_net_0[0];
assign nCsD             = nCsD_net_1;
assign MosiD_net_1      = MosiD_net_0;
assign MosiD            = MosiD_net_1;
assign MosiE_net_1      = MosiE_net_0;
assign MosiE            = MosiE_net_1;
assign nCsE_net_1       = nCsE_net_0[0];
assign nCsE             = nCsE_net_1;
assign MosiF_net_1      = MosiF_net_0;
assign MosiF            = MosiF_net_1;
assign nCsF_net_1       = nCsF_net_0[0];
assign nCsF             = nCsF_net_1;
assign nCsMonAdc_net_1  = nCsMonAdc_net_0[0];
assign nCsMonAdc        = nCsMonAdc_net_1;
assign MosiMonAdc_net_1 = MosiMonAdc_net_0;
assign MosiMonAdc       = MosiMonAdc_net_1;
assign SckMonAdc_net_1  = SckMonAdc_net_0;
assign SckMonAdc        = SckMonAdc_net_1;
assign SckADCs_net_1    = SckADCs_net_0;
assign SckADCs          = SckADCs_net_1;
assign PAD_OUT_net_1    = PAD_OUT_net_0;
assign PAD_OUT[3:0]     = PAD_OUT_net_1;
assign Tx_net_1[0]      = Tx_net_0[0];
assign Tx[0:0]          = Tx_net_1[0];
assign SckADCs_net_2[1] = SckADCs_net_0;
assign test[1:1]        = SckADCs_net_2[1];
assign test_0_net_1[2]  = test_0[0];
assign test[2:2]        = test_0_net_1[2];
assign test_3_net_0[3]  = test_3;
assign test[3:3]        = test_3_net_0[3];
assign test_2_net_1[4]  = test_2;
assign test[4:4]        = test_2_net_1[4];
//--------------------------------------------------------------------
// Slices assignments
//--------------------------------------------------------------------
assign IO_INPUTS_Y0to0[0] = Y_net_0[0:0];
assign IO_INPUTS_Y1to1[1] = Y_net_0[1:1];
assign IO_INPUTS_Y2to2[2] = Y_net_0[2:2];
assign IO_INPUTS_Y3to3[3] = Y_net_0[3:3];
assign IO_INPUTS_Y4to4[4] = Y_net_0[4:4];
assign IO_INPUTS_Y5to5[5] = Y_net_0[5:5];
assign IO_INPUTS_Y6to6[6] = Y_net_0[6:6];
assign IO_INPUTS_Y7to7[7] = Y_net_0[7:7];
assign IO_INPUTS_Y8to8[8] = Y_net_0[8:8];
assign nCsB_net_0[0]      = nCs_net_1[0:0];
assign nCsC_net_0[0]      = nCs_net_2[0:0];
assign nCsD_net_0[0]      = nCs_net_3[0:0];
assign nCsE_net_0[0]      = nCs_net_4[0:0];
assign nCsF_net_0[0]      = nCs_net_5[0:0];
assign nCsMonAdc_net_0[0] = nCs_net_6[0:0];
assign test_0[0]          = nCs_net_0[0:0];
assign nCs_slice_0[1]     = nCs_net_0[1:1];
assign nCs_slice_1[2]     = nCs_net_0[2:2];
assign nCs_slice_2[3]     = nCs_net_0[3:3];
assign nCs_slice_3[1]     = nCs_net_1[1:1];
assign nCs_slice_4[2]     = nCs_net_1[2:2];
assign nCs_slice_5[3]     = nCs_net_1[3:3];
assign nCs_slice_6[1]     = nCs_net_2[1:1];
assign nCs_slice_7[2]     = nCs_net_2[2:2];
assign nCs_slice_8[3]     = nCs_net_2[3:3];
assign nCs_slice_9[1]     = nCs_net_3[1:1];
assign nCs_slice_10[2]    = nCs_net_3[2:2];
assign nCs_slice_11[3]    = nCs_net_3[3:3];
assign nCs_slice_12[1]    = nCs_net_4[1:1];
assign nCs_slice_13[2]    = nCs_net_4[2:2];
assign nCs_slice_14[3]    = nCs_net_4[3:3];
assign nCs_slice_15[1]    = nCs_net_5[1:1];
assign nCs_slice_16[2]    = nCs_net_5[2:2];
assign nCs_slice_17[3]    = nCs_net_5[3:3];
assign nCs_slice_18[1]    = nCs_net_6[1:1];
assign nCs_slice_19[2]    = nCs_net_6[2:2];
assign nCs_slice_20[3]    = nCs_net_6[3:3];
assign nCs_slice_21[0]    = nCs_net_7[0:0];
assign nCs_slice_22[1]    = nCs_net_7[1:1];
assign nCs_slice_23[2]    = nCs_net_7[2:2];
assign nCs_slice_24[3]    = nCs_net_7[3:3];
//--------------------------------------------------------------------
// Concatenation assignments
//--------------------------------------------------------------------
assign D_net_0 = { Ux2FPGA_sb_0_GPIO_7_M2F , Ux2FPGA_sb_0_GPIO_6_M2F , Ux2FPGA_sb_0_GPIO_5_M2F , Ux2FPGA_sb_0_GPIO_4_M2F };
//--------------------------------------------------------------------
// Bus Interface Nets Assignments - Unequal Pin Widths
//--------------------------------------------------------------------
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_PADDR_0 = { Ux2FPGA_sb_0_AMBA_SLAVE_0_PADDR_0_4to0 };
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_PADDR_0_4to0 = Ux2FPGA_sb_0_AMBA_SLAVE_0_PADDR[4:0];

assign Ux2FPGA_sb_0_AMBA_SLAVE_0_PRDATA_0 = { Ux2FPGA_sb_0_AMBA_SLAVE_0_PRDATA_0_31to8, Ux2FPGA_sb_0_AMBA_SLAVE_0_PRDATA_0_7to0 };
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_PRDATA_0_31to8 = 24'h0;
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_PRDATA_0_7to0 = Ux2FPGA_sb_0_AMBA_SLAVE_0_PRDATA[7:0];

assign Ux2FPGA_sb_0_AMBA_SLAVE_0_PWDATA_0 = { Ux2FPGA_sb_0_AMBA_SLAVE_0_PWDATA_0_7to0 };
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_PWDATA_0_7to0 = Ux2FPGA_sb_0_AMBA_SLAVE_0_PWDATA[7:0];

assign Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PRDATA_0 = { Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PRDATA_0_31to24, Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PRDATA_0_23to0 };
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PRDATA_0_23to0 = Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PRDATA[23:0];
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PRDATA_0_31to24 = 8'h0;

assign Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PRDATA_0 = { Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PRDATA_0_31to24, Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PRDATA_0_23to0 };
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PRDATA_0_23to0 = Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PRDATA[23:0];
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PRDATA_0_31to24 = 8'h0;

assign Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PRDATA_0 = { Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PRDATA_0_31to24, Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PRDATA_0_23to0 };
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PRDATA_0_23to0 = Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PRDATA[23:0];
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PRDATA_0_31to24 = 8'h0;

assign Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PRDATA_0 = { Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PRDATA_0_31to24, Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PRDATA_0_23to0 };
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PRDATA_0_23to0 = Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PRDATA[23:0];
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PRDATA_0_31to24 = 8'h0;

assign Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PRDATA_0 = { Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PRDATA_0_31to24, Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PRDATA_0_23to0 };
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PRDATA_0_23to0 = Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PRDATA[23:0];
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PRDATA_0_31to24 = 8'h0;

assign Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PRDATA_0 = { Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PRDATA_0_31to24, Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PRDATA_0_23to0 };
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PRDATA_0_23to0 = Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PRDATA[23:0];
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PRDATA_0_31to24 = 8'h0;

assign Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PRDATA_0 = { Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PRDATA_0_31to24, Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PRDATA_0_23to0 };
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PRDATA_0_23to0 = Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PRDATA[23:0];
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PRDATA_0_31to24 = 8'h0;

assign Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PRDATA_0 = { Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PRDATA_0_31to24, Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PRDATA_0_23to0 };
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PRDATA_0_23to0 = Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PRDATA[23:0];
assign Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PRDATA_0_31to24 = 8'h0;

//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------AND3
AND3 AND3_0(
        // Inputs
        .A ( AND4_0_Y ),
        .B ( SpiMasterPorts_4_Sck ),
        .C ( SpiMasterPorts_5_Sck ),
        // Outputs
        .Y ( SckADCs_net_0 ) 
        );

//--------AND4
AND4 AND4_0(
        // Inputs
        .A ( SpiMasterPorts_0_Sck ),
        .B ( SpiMasterPorts_1_Sck ),
        .C ( SpiMasterPorts_2_Sck ),
        .D ( SpiMasterPorts_3_Sck ),
        // Outputs
        .Y ( AND4_0_Y ) 
        );

//--------CoreUARTapb_C0
CoreUARTapb_C0 CoreUARTapb_C0_0(
        // Inputs
        .PCLK        ( Ux2FPGA_sb_0_FIC_0_CLK ),
        .PRESETN     ( VCC_net ),
        .RX          ( RX ),
        .PSEL        ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PSELx ),
        .PENABLE     ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PENABLE ),
        .PWRITE      ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PWRITE ),
        .PADDR       ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PADDR_0 ),
        .PWDATA      ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PWDATA_0 ),
        // Outputs
        .TXRDY       ( TXRDY_OUT_PRE_INV0_0 ),
        .RXRDY       ( CoreUARTapb_C0_0_RXRDY ),
        .PARITY_ERR  (  ),
        .OVERFLOW    (  ),
        .TX          ( CoreUARTapb_C0_0_TX ),
        .FRAMING_ERR (  ),
        .PREADY      ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PREADY ),
        .PSLVERR     ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PSLVERR ),
        .PRDATA      ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PRDATA ) 
        );

//--------IO_OUTPUTS
IO_OUTPUTS IO_INPUTS_inst_0(
        // Inputs
        .PAD_IN ( PAD_IN_0 ),
        // Outputs
        .Y      ( Y_net_0 ) 
        );

//--------IO_INPUTS
IO_INPUTS IO_OUTPUTS_inst_0(
        // Inputs
        .D       ( D_net_0 ),
        // Outputs
        .PAD_OUT ( PAD_OUT_net_0 ) 
        );

//--------IO_TXBuf
IO_TXBuf IO_TXBuf_0(
        // Inputs
        .D       ( CoreUARTapb_C0_0_TX ),
        .E       ( CoreUARTapb_C0_0_TXRDY ),
        // Outputs
        .PAD_TRI ( Tx_net_0 ) 
        );

//--------OR3
OR3 OR3_0(
        // Inputs
        .A ( OR4_1_Y ),
        .B ( SpiMasterPorts_6_XferComplete ),
        .C ( SpiMasterPorts_7_XferComplete ),
        // Outputs
        .Y ( test_3 ) 
        );

//--------OR4
OR4 OR4_0(
        // Inputs
        .A ( SpiMasterPorts_0_XferComplete ),
        .B ( SpiMasterPorts_1_XferComplete ),
        .C ( GND_net ),
        .D ( SpiMasterPorts_2_XferComplete ),
        // Outputs
        .Y ( OR4_0_Y ) 
        );

//--------OR4
OR4 OR4_1(
        // Inputs
        .A ( OR4_0_Y ),
        .B ( SpiMasterPorts_3_XferComplete ),
        .C ( SpiMasterPorts_4_XferComplete ),
        .D ( SpiMasterPorts_5_XferComplete ),
        // Outputs
        .Y ( OR4_1_Y ) 
        );

//--------SpiMasterPorts
SpiMasterPorts #( 
        .BYTE_WIDTH    ( 3 ),
        .CLOCK_DIVIDER ( 1000 ) )
SpiMasterPorts_0(
        // Inputs
        .clk          ( Ux2FPGA_sb_0_FIC_0_CLK ),
        .rst          ( Ux2FPGA_sb_0_GPIO_1_M2F ),
        .Miso         ( MisoA ),
        .Penable      ( Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PENABLE ),
        .Psel         ( Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PSELx ),
        .Presern      ( VCC_net ),
        .Pwrite       ( Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PWRITE ),
        .AmbaBusData  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PWDATA ),
        // Outputs
        .Mosi         ( test_2 ),
        .Sck          ( SpiMasterPorts_0_Sck ),
        .Pready       ( Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PREADY ),
        .XferComplete ( SpiMasterPorts_0_XferComplete ),
        .nCs          ( nCs_net_0 ),
        .DataFromMiso ( Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PRDATA ) 
        );

//--------SpiMasterPorts
SpiMasterPorts #( 
        .BYTE_WIDTH    ( 3 ),
        .CLOCK_DIVIDER ( 1000 ) )
SpiMasterPorts_1(
        // Inputs
        .clk          ( Ux2FPGA_sb_0_FIC_0_CLK ),
        .rst          ( Ux2FPGA_sb_0_GPIO_1_M2F ),
        .Miso         ( MisoB ),
        .Penable      ( Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PENABLE ),
        .Psel         ( Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PSELx ),
        .Presern      ( VCC_net ),
        .Pwrite       ( Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PWRITE ),
        .AmbaBusData  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PWDATA ),
        // Outputs
        .Mosi         ( MosiB_net_0 ),
        .Sck          ( SpiMasterPorts_1_Sck ),
        .Pready       ( Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PREADY ),
        .XferComplete ( SpiMasterPorts_1_XferComplete ),
        .nCs          ( nCs_net_1 ),
        .DataFromMiso ( Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PRDATA ) 
        );

//--------SpiMasterPorts
SpiMasterPorts #( 
        .BYTE_WIDTH    ( 3 ),
        .CLOCK_DIVIDER ( 1000 ) )
SpiMasterPorts_2(
        // Inputs
        .clk          ( Ux2FPGA_sb_0_FIC_0_CLK ),
        .rst          ( Ux2FPGA_sb_0_GPIO_1_M2F ),
        .Miso         ( MisoC ),
        .Penable      ( Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PENABLE ),
        .Psel         ( Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PSELx ),
        .Presern      ( VCC_net ),
        .Pwrite       ( Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PWRITE ),
        .AmbaBusData  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PWDATA ),
        // Outputs
        .Mosi         ( MosiC_net_0 ),
        .Sck          ( SpiMasterPorts_2_Sck ),
        .Pready       ( Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PREADY ),
        .XferComplete ( SpiMasterPorts_2_XferComplete ),
        .nCs          ( nCs_net_2 ),
        .DataFromMiso ( Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PRDATA ) 
        );

//--------SpiMasterPorts
SpiMasterPorts #( 
        .BYTE_WIDTH    ( 3 ),
        .CLOCK_DIVIDER ( 1000 ) )
SpiMasterPorts_3(
        // Inputs
        .clk          ( Ux2FPGA_sb_0_FIC_0_CLK ),
        .rst          ( Ux2FPGA_sb_0_GPIO_1_M2F ),
        .Miso         ( MisoD ),
        .Penable      ( Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PENABLE ),
        .Psel         ( Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PSELx ),
        .Presern      ( VCC_net ),
        .Pwrite       ( Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PWRITE ),
        .AmbaBusData  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PWDATA ),
        // Outputs
        .Mosi         ( MosiD_net_0 ),
        .Sck          ( SpiMasterPorts_3_Sck ),
        .Pready       ( Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PREADY ),
        .XferComplete ( SpiMasterPorts_3_XferComplete ),
        .nCs          ( nCs_net_3 ),
        .DataFromMiso ( Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PRDATA ) 
        );

//--------SpiMasterPorts
SpiMasterPorts #( 
        .BYTE_WIDTH    ( 3 ),
        .CLOCK_DIVIDER ( 1000 ) )
SpiMasterPorts_4(
        // Inputs
        .clk          ( Ux2FPGA_sb_0_FIC_0_CLK ),
        .rst          ( Ux2FPGA_sb_0_GPIO_1_M2F ),
        .Miso         ( MisoE ),
        .Penable      ( Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PENABLE ),
        .Psel         ( Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PSELx ),
        .Presern      ( VCC_net ),
        .Pwrite       ( Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PWRITE ),
        .AmbaBusData  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PWDATA ),
        // Outputs
        .Mosi         ( MosiE_net_0 ),
        .Sck          ( SpiMasterPorts_4_Sck ),
        .Pready       ( Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PREADY ),
        .XferComplete ( SpiMasterPorts_4_XferComplete ),
        .nCs          ( nCs_net_4 ),
        .DataFromMiso ( Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PRDATA ) 
        );

//--------SpiMasterPorts
SpiMasterPorts #( 
        .BYTE_WIDTH    ( 3 ),
        .CLOCK_DIVIDER ( 1000 ) )
SpiMasterPorts_5(
        // Inputs
        .clk          ( Ux2FPGA_sb_0_FIC_0_CLK ),
        .rst          ( Ux2FPGA_sb_0_GPIO_1_M2F ),
        .Miso         ( MisoF ),
        .Penable      ( Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PENABLE ),
        .Psel         ( Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PSELx ),
        .Presern      ( VCC_net ),
        .Pwrite       ( Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PWRITE ),
        .AmbaBusData  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PWDATA ),
        // Outputs
        .Mosi         ( MosiF_net_0 ),
        .Sck          ( SpiMasterPorts_5_Sck ),
        .Pready       ( Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PREADY ),
        .XferComplete ( SpiMasterPorts_5_XferComplete ),
        .nCs          ( nCs_net_5 ),
        .DataFromMiso ( Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PRDATA ) 
        );

//--------SpiMasterPorts
SpiMasterPorts #( 
        .BYTE_WIDTH    ( 3 ),
        .CLOCK_DIVIDER ( 1000 ) )
SpiMasterPorts_6(
        // Inputs
        .clk          ( Ux2FPGA_sb_0_FIC_0_CLK ),
        .rst          ( Ux2FPGA_sb_0_GPIO_1_M2F ),
        .Miso         ( MisoMon0 ),
        .Penable      ( Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PENABLE ),
        .Psel         ( Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PSELx ),
        .Presern      ( VCC_net ),
        .Pwrite       ( Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PWRITE ),
        .AmbaBusData  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PWDATA ),
        // Outputs
        .Mosi         ( MosiMonAdc_net_0 ),
        .Sck          ( SckMonAdc_net_0 ),
        .Pready       ( Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PREADY ),
        .XferComplete ( SpiMasterPorts_6_XferComplete ),
        .nCs          ( nCs_net_6 ),
        .DataFromMiso ( Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PRDATA ) 
        );

//--------SpiMasterPorts
SpiMasterPorts #( 
        .BYTE_WIDTH    ( 3 ),
        .CLOCK_DIVIDER ( 1000 ) )
SpiMasterPorts_7(
        // Inputs
        .clk          ( Ux2FPGA_sb_0_FIC_0_CLK ),
        .rst          ( Ux2FPGA_sb_0_GPIO_1_M2F ),
        .Miso         ( MisoMon1 ),
        .Penable      ( Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PENABLE ),
        .Psel         ( Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PSELx ),
        .Presern      ( VCC_net ),
        .Pwrite       ( Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PWRITE ),
        .AmbaBusData  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PWDATA ),
        // Outputs
        .Mosi         (  ),
        .Sck          (  ),
        .Pready       ( Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PREADY ),
        .XferComplete ( SpiMasterPorts_7_XferComplete ),
        .nCs          ( nCs_net_7 ),
        .DataFromMiso ( Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PRDATA ) 
        );

//--------Ux2FPGA_sb
Ux2FPGA_sb Ux2FPGA_sb_0(
        // Inputs
        .FAB_RESET_N              ( VCC_net ), // tied to 1'b1 from definition
        .AMBA_SLAVE_0_PREADYS0    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PREADY ),
        .AMBA_SLAVE_0_PSLVERRS0   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PSLVERR ),
        .AMBA_SLAVE_0_1_PREADYS1  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PREADY ),
        .AMBA_SLAVE_0_1_PSLVERRS1 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_2_PREADYS2  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PREADY ),
        .AMBA_SLAVE_0_2_PSLVERRS2 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_3_PREADYS3  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PREADY ),
        .AMBA_SLAVE_0_3_PSLVERRS3 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_4_PREADYS4  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PREADY ),
        .AMBA_SLAVE_0_4_PSLVERRS4 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_5_PREADYS5  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PREADY ),
        .AMBA_SLAVE_0_5_PSLVERRS5 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_6_PREADYS6  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PREADY ),
        .AMBA_SLAVE_0_6_PSLVERRS6 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_7_PREADYS7  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PREADY ),
        .AMBA_SLAVE_0_7_PSLVERRS7 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_8_PREADYS8  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PREADY ),
        .AMBA_SLAVE_0_8_PSLVERRS8 ( GND_net ), // tied to 1'b0 from definition
        .DEVRST_N                 ( DEVRST_N ),
        .CLK0                     ( CLK0 ),
        .GPIO_0_F2M               ( CoreUARTapb_C0_0_RXRDY ),
        .GPIO_2_F2M               ( test_3 ),
        .GPIO_8_F2M               ( IO_INPUTS_Y0to0 ),
        .GPIO_9_F2M               ( IO_INPUTS_Y1to1 ),
        .GPIO_10_F2M              ( IO_INPUTS_Y2to2 ),
        .GPIO_11_F2M              ( IO_INPUTS_Y3to3 ),
        .GPIO_12_F2M              ( IO_INPUTS_Y4to4 ),
        .GPIO_13_F2M              ( IO_INPUTS_Y5to5 ),
        .GPIO_14_F2M              ( IO_INPUTS_Y6to6 ),
        .GPIO_15_F2M              ( IO_INPUTS_Y7to7 ),
        .GPIO_16_F2M              ( IO_INPUTS_Y8to8 ),
        .AMBA_SLAVE_0_PRDATAS0    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PRDATA_0 ),
        .AMBA_SLAVE_0_1_PRDATAS1  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PRDATA_0 ),
        .AMBA_SLAVE_0_2_PRDATAS2  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PRDATA_0 ),
        .AMBA_SLAVE_0_3_PRDATAS3  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PRDATA_0 ),
        .AMBA_SLAVE_0_4_PRDATAS4  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PRDATA_0 ),
        .AMBA_SLAVE_0_5_PRDATAS5  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PRDATA_0 ),
        .AMBA_SLAVE_0_6_PRDATAS6  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PRDATA_0 ),
        .AMBA_SLAVE_0_7_PRDATAS7  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PRDATA_0 ),
        .AMBA_SLAVE_0_8_PRDATAS8  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PRDATA_0 ),
        // Outputs
        .POWER_ON_RESET_N         (  ),
        .INIT_DONE                (  ),
        .AMBA_SLAVE_0_PSELS0      ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PSELx ),
        .AMBA_SLAVE_0_PENABLES    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PENABLE ),
        .AMBA_SLAVE_0_PWRITES     ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PWRITE ),
        .AMBA_SLAVE_0_1_PSELS1    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PSELx ),
        .AMBA_SLAVE_0_1_PENABLES  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PENABLE ),
        .AMBA_SLAVE_0_1_PWRITES   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PWRITE ),
        .AMBA_SLAVE_0_2_PSELS2    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PSELx ),
        .AMBA_SLAVE_0_2_PENABLES  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PENABLE ),
        .AMBA_SLAVE_0_2_PWRITES   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PWRITE ),
        .AMBA_SLAVE_0_3_PSELS3    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PSELx ),
        .AMBA_SLAVE_0_3_PENABLES  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PENABLE ),
        .AMBA_SLAVE_0_3_PWRITES   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PWRITE ),
        .AMBA_SLAVE_0_4_PSELS4    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PSELx ),
        .AMBA_SLAVE_0_4_PENABLES  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PENABLE ),
        .AMBA_SLAVE_0_4_PWRITES   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PWRITE ),
        .AMBA_SLAVE_0_5_PSELS5    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PSELx ),
        .AMBA_SLAVE_0_5_PENABLES  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PENABLE ),
        .AMBA_SLAVE_0_5_PWRITES   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PWRITE ),
        .AMBA_SLAVE_0_6_PSELS6    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PSELx ),
        .AMBA_SLAVE_0_6_PENABLES  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PENABLE ),
        .AMBA_SLAVE_0_6_PWRITES   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PWRITE ),
        .AMBA_SLAVE_0_7_PSELS7    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PSELx ),
        .AMBA_SLAVE_0_7_PENABLES  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PENABLE ),
        .AMBA_SLAVE_0_7_PWRITES   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PWRITE ),
        .AMBA_SLAVE_0_8_PSELS8    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PSELx ),
        .AMBA_SLAVE_0_8_PENABLES  ( Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PENABLE ),
        .AMBA_SLAVE_0_8_PWRITES   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PWRITE ),
        .FIC_0_CLK                ( Ux2FPGA_sb_0_FIC_0_CLK ),
        .FIC_0_LOCK               (  ),
        .MSS_READY                (  ),
        .GPIO_1_M2F               ( Ux2FPGA_sb_0_GPIO_1_M2F ),
        .GPIO_4_M2F               ( Ux2FPGA_sb_0_GPIO_4_M2F ),
        .GPIO_5_M2F               ( Ux2FPGA_sb_0_GPIO_5_M2F ),
        .GPIO_6_M2F               ( Ux2FPGA_sb_0_GPIO_6_M2F ),
        .GPIO_7_M2F               ( Ux2FPGA_sb_0_GPIO_7_M2F ),
        .GPIO_24_M2F              (  ),
        .AMBA_SLAVE_0_PADDRS      ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PADDR ),
        .AMBA_SLAVE_0_PWDATAS     ( Ux2FPGA_sb_0_AMBA_SLAVE_0_PWDATA ),
        .AMBA_SLAVE_0_1_PADDRS    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PADDR ),
        .AMBA_SLAVE_0_1_PWDATAS   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_1_PWDATA ),
        .AMBA_SLAVE_0_2_PADDRS    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PADDR ),
        .AMBA_SLAVE_0_2_PWDATAS   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_2_PWDATA ),
        .AMBA_SLAVE_0_3_PADDRS    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PADDR ),
        .AMBA_SLAVE_0_3_PWDATAS   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_3_PWDATA ),
        .AMBA_SLAVE_0_4_PADDRS    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PADDR ),
        .AMBA_SLAVE_0_4_PWDATAS   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_4_PWDATA ),
        .AMBA_SLAVE_0_5_PADDRS    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PADDR ),
        .AMBA_SLAVE_0_5_PWDATAS   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_5_PWDATA ),
        .AMBA_SLAVE_0_6_PADDRS    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PADDR ),
        .AMBA_SLAVE_0_6_PWDATAS   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_6_PWDATA ),
        .AMBA_SLAVE_0_7_PADDRS    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PADDR ),
        .AMBA_SLAVE_0_7_PWDATAS   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_7_PWDATA ),
        .AMBA_SLAVE_0_8_PADDRS    ( Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PADDR ),
        .AMBA_SLAVE_0_8_PWDATAS   ( Ux2FPGA_sb_0_AMBA_SLAVE_0_8_PWDATA ) 
        );


endmodule

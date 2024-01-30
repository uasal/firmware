//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Jan 29 12:06:05 2024
// Version: 2023.2 2023.2.0.8
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// EvalBoardSandbox
module EvalBoardSandbox(
    // Inputs
    DEVRST_N,
    MDDR_DQS_TMATCH_0_IN,
    RX,
    // Outputs
    MDDR_ADDR,
    MDDR_BA,
    MDDR_CAS_N,
    MDDR_CKE,
    MDDR_CLK,
    MDDR_CLK_N,
    MDDR_CS_N,
    MDDR_DQS_TMATCH_0_OUT,
    MDDR_ODT,
    MDDR_RAS_N,
    MDDR_RESET_N,
    MDDR_WE_N,
    Mosi,
    MosiB,
    PWM,
    Sck,
    TX,
    XferComplete,
    nCs,
    nCsB,
    // Inouts
    MDDR_DM_RDQS,
    MDDR_DQ,
    MDDR_DQS,
    MDDR_DQS_N
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input         DEVRST_N;
input         MDDR_DQS_TMATCH_0_IN;
input         RX;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [15:0] MDDR_ADDR;
output [2:0]  MDDR_BA;
output        MDDR_CAS_N;
output        MDDR_CKE;
output        MDDR_CLK;
output        MDDR_CLK_N;
output        MDDR_CS_N;
output        MDDR_DQS_TMATCH_0_OUT;
output        MDDR_ODT;
output        MDDR_RAS_N;
output        MDDR_RESET_N;
output        MDDR_WE_N;
output        Mosi;
output        MosiB;
output [2:1]  PWM;
output        Sck;
output        TX;
output        XferComplete;
output        nCs;
output        nCsB;
//--------------------------------------------------------------------
// Inout
//--------------------------------------------------------------------
inout  [0:0]  MDDR_DM_RDQS;
inout  [7:0]  MDDR_DQ;
inout  [0:0]  MDDR_DQS;
inout  [0:0]  MDDR_DQS_N;
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
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PADDR;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PENABLE;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PSELx;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PWRITE;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_2_PADDR;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_2_PENABLE;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_2_PSELx;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_2_PWRITE;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PENABLE;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PREADY;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PSELx;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PSLVERR;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PWRITE;
wire          EvalSandbox_MSS_0_FIC_0_CLK;
wire          EvalSandbox_MSS_0_GPIO_1_M2F;
wire   [15:0] MDDR_ADDR_net_0;
wire   [2:0]  MDDR_BA_net_0;
wire          MDDR_CAS_N_net_0;
wire          MDDR_CKE_net_0;
wire          MDDR_CLK_net_0;
wire          MDDR_CLK_N_net_0;
wire          MDDR_CS_N_net_0;
wire   [0:0]  MDDR_DM_RDQS;
wire   [7:0]  MDDR_DQ;
wire   [0:0]  MDDR_DQS;
wire   [0:0]  MDDR_DQS_N;
wire          MDDR_DQS_TMATCH_0_IN;
wire          MDDR_DQS_TMATCH_0_OUT_net_0;
wire          MDDR_ODT_net_0;
wire          MDDR_RAS_N_net_0;
wire          MDDR_RESET_N_net_0;
wire          MDDR_WE_N_net_0;
wire          Mosi_net_0;
wire          MosiB_net_0;
wire          nCs_net_0;
wire          nCsB_net_0;
wire   [2:1]  PWM_net_0;
wire          RX;
wire          Sck_0;
wire          SpiDacPorts_0_DacReadback;
wire          SpiDacPorts_1_DacReadback;
wire          TX_net_0;
wire          XferComplete_net_0;
wire          MDDR_DQS_TMATCH_0_OUT_net_1;
wire          MDDR_CAS_N_net_1;
wire          MDDR_CLK_net_1;
wire          MDDR_CLK_N_net_1;
wire          MDDR_CKE_net_1;
wire          MDDR_CS_N_net_1;
wire          MDDR_ODT_net_1;
wire          MDDR_RAS_N_net_1;
wire          MDDR_RESET_N_net_1;
wire          MDDR_WE_N_net_1;
wire          TX_net_1;
wire          nCs_net_1;
wire          Sck_0_net_0;
wire          Mosi_net_1;
wire   [15:0] MDDR_ADDR_net_1;
wire   [2:0]  MDDR_BA_net_1;
wire   [2:1]  PWM_net_1;
wire          XferComplete_net_1;
wire          MosiB_net_1;
wire          nCsB_net_1;
wire   [31:0] AMBA_SLAVE_0_1_PRDATAS2_const_net_0;
wire   [31:0] AMBA_SLAVE_0_2_PRDATAS3_const_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          VCC_net;
wire          GND_net;
wire   [7:0]  DataToMosiC_const_net_0;
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
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PWDATA;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PWDATA_0;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PWDATA_0_7to0;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_2_PWDATA;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_2_PWDATA_0;
wire   [7:0]  EvalSandbox_MSS_0_AMBA_SLAVE_0_2_PWDATA_0_7to0;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PADDR;
wire   [19:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PADDR_0;
wire   [19:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PADDR_0_19to0;
wire   [15:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA_0;
wire   [15:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA_0_15to0;
wire   [31:16]EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA_0_31to16;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PWDATA;
wire   [15:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PWDATA_0;
wire   [15:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PWDATA_0_15to0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign VCC_net                 = 1'b1;
assign GND_net                 = 1'b0;
assign DataToMosiC_const_net_0 = 8'hFF;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign MDDR_DQS_TMATCH_0_OUT_net_1 = MDDR_DQS_TMATCH_0_OUT_net_0;
assign MDDR_DQS_TMATCH_0_OUT       = MDDR_DQS_TMATCH_0_OUT_net_1;
assign MDDR_CAS_N_net_1            = MDDR_CAS_N_net_0;
assign MDDR_CAS_N                  = MDDR_CAS_N_net_1;
assign MDDR_CLK_net_1              = MDDR_CLK_net_0;
assign MDDR_CLK                    = MDDR_CLK_net_1;
assign MDDR_CLK_N_net_1            = MDDR_CLK_N_net_0;
assign MDDR_CLK_N                  = MDDR_CLK_N_net_1;
assign MDDR_CKE_net_1              = MDDR_CKE_net_0;
assign MDDR_CKE                    = MDDR_CKE_net_1;
assign MDDR_CS_N_net_1             = MDDR_CS_N_net_0;
assign MDDR_CS_N                   = MDDR_CS_N_net_1;
assign MDDR_ODT_net_1              = MDDR_ODT_net_0;
assign MDDR_ODT                    = MDDR_ODT_net_1;
assign MDDR_RAS_N_net_1            = MDDR_RAS_N_net_0;
assign MDDR_RAS_N                  = MDDR_RAS_N_net_1;
assign MDDR_RESET_N_net_1          = MDDR_RESET_N_net_0;
assign MDDR_RESET_N                = MDDR_RESET_N_net_1;
assign MDDR_WE_N_net_1             = MDDR_WE_N_net_0;
assign MDDR_WE_N                   = MDDR_WE_N_net_1;
assign TX_net_1                    = TX_net_0;
assign TX                          = TX_net_1;
assign nCs_net_1                   = nCs_net_0;
assign nCs                         = nCs_net_1;
assign Sck_0_net_0                 = Sck_0;
assign Sck                         = Sck_0_net_0;
assign Mosi_net_1                  = Mosi_net_0;
assign Mosi                        = Mosi_net_1;
assign MDDR_ADDR_net_1             = MDDR_ADDR_net_0;
assign MDDR_ADDR[15:0]             = MDDR_ADDR_net_1;
assign MDDR_BA_net_1               = MDDR_BA_net_0;
assign MDDR_BA[2:0]                = MDDR_BA_net_1;
assign PWM_net_1                   = PWM_net_0;
assign PWM[2:1]                    = PWM_net_1;
assign XferComplete_net_1          = XferComplete_net_0;
assign XferComplete                = XferComplete_net_1;
assign MosiB_net_1                 = MosiB_net_0;
assign MosiB                       = MosiB_net_1;
assign nCsB_net_1                  = nCsB_net_0;
assign nCsB                        = nCsB_net_1;
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

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PWDATA_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PWDATA_0_7to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PWDATA_0_7to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PWDATA[7:0];

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_2_PWDATA_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_2_PWDATA_0_7to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_2_PWDATA_0_7to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_2_PWDATA[7:0];

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PADDR_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PADDR_0_19to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PADDR_0_19to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PADDR[19:0];

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA_0_31to16, EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA_0_15to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA_0_15to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA[15:0];
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA_0_31to16 = 16'h0;

assign EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PWDATA_0 = { EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PWDATA_0_15to0 };
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PWDATA_0_15to0 = EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PWDATA[15:0];

//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------COREAPBLSRAM_C0
COREAPBLSRAM_C0 COREAPBLSRAM_C0_0(
        // Inputs
        .PCLK    ( EvalSandbox_MSS_0_FIC_0_CLK ),
        .PRESETN ( VCC_net ),
        .PENABLE ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PENABLE ),
        .PWRITE  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PWRITE ),
        .PSEL    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PSELx ),
        .PADDR   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PADDR_0 ),
        .PWDATA  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PWDATA_0 ),
        // Outputs
        .PREADY  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PREADY ),
        .PSLVERR ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PSLVERR ),
        .PRDATA  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA ) 
        );

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
        .MDDR_DQS_TMATCH_0_IN     ( MDDR_DQS_TMATCH_0_IN ),
        .FAB_RESET_N              ( VCC_net ), // tied to 1'b1 from definition
        .AMBA_SLAVE_0_PRDATAS1    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PRDATA_0 ),
        .AMBA_SLAVE_0_PREADYS1    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PREADY ),
        .AMBA_SLAVE_0_PSLVERRS1   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PSLVERR ),
        .AMBA_SLAVE_0_1_PRDATAS2  ( AMBA_SLAVE_0_1_PRDATAS2_const_net_0 ),
        .AMBA_SLAVE_0_1_PREADYS2  ( VCC_net ), // tied to 1'b1 from definition
        .AMBA_SLAVE_0_1_PSLVERRS2 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_2_PRDATAS3  ( AMBA_SLAVE_0_2_PRDATAS3_const_net_0 ),
        .AMBA_SLAVE_0_2_PREADYS3  ( VCC_net ), // tied to 1'b1 from definition
        .AMBA_SLAVE_0_2_PSLVERRS3 ( GND_net ), // tied to 1'b0 from definition
        .AMBA_SLAVE_0_3_PRDATAS4  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PRDATA_0 ),
        .AMBA_SLAVE_0_3_PREADYS4  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PREADY ),
        .AMBA_SLAVE_0_3_PSLVERRS4 ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PSLVERR ),
        .DEVRST_N                 ( DEVRST_N ),
        .TACHIN                   ( GND_net ),
        .GPIO_0_F2M               ( CoreUARTapb_C0_0_RXRDY ),
        .GPIO_2_F2M               ( XferComplete_net_0 ),
        // Outputs
        .MDDR_DQS_TMATCH_0_OUT    ( MDDR_DQS_TMATCH_0_OUT_net_0 ),
        .MDDR_CAS_N               ( MDDR_CAS_N_net_0 ),
        .MDDR_CLK                 ( MDDR_CLK_net_0 ),
        .MDDR_CLK_N               ( MDDR_CLK_N_net_0 ),
        .MDDR_CKE                 ( MDDR_CKE_net_0 ),
        .MDDR_CS_N                ( MDDR_CS_N_net_0 ),
        .MDDR_ODT                 ( MDDR_ODT_net_0 ),
        .MDDR_RAS_N               ( MDDR_RAS_N_net_0 ),
        .MDDR_RESET_N             ( MDDR_RESET_N_net_0 ),
        .MDDR_WE_N                ( MDDR_WE_N_net_0 ),
        .MDDR_ADDR                ( MDDR_ADDR_net_0 ),
        .MDDR_BA                  ( MDDR_BA_net_0 ),
        .POWER_ON_RESET_N         (  ),
        .INIT_DONE                (  ),
        .AMBA_SLAVE_0_PADDRS      ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDR ),
        .AMBA_SLAVE_0_PSELS1      ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PSELx ),
        .AMBA_SLAVE_0_PENABLES    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PENABLE ),
        .AMBA_SLAVE_0_PWRITES     ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWRITE ),
        .AMBA_SLAVE_0_PWDATAS     ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATA ),
        .AMBA_SLAVE_0_1_PADDRS    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PADDR ),
        .AMBA_SLAVE_0_1_PSELS2    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PSELx ),
        .AMBA_SLAVE_0_1_PENABLES  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PENABLE ),
        .AMBA_SLAVE_0_1_PWRITES   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PWRITE ),
        .AMBA_SLAVE_0_1_PWDATAS   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PWDATA ),
        .AMBA_SLAVE_0_2_PADDRS    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_PADDR ),
        .AMBA_SLAVE_0_2_PSELS3    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_PSELx ),
        .AMBA_SLAVE_0_2_PENABLES  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_PENABLE ),
        .AMBA_SLAVE_0_2_PWRITES   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_PWRITE ),
        .AMBA_SLAVE_0_2_PWDATAS   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_PWDATA ),
        .AMBA_SLAVE_0_3_PADDRS    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PADDR ),
        .AMBA_SLAVE_0_3_PSELS4    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PSELx ),
        .AMBA_SLAVE_0_3_PENABLES  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PENABLE ),
        .AMBA_SLAVE_0_3_PWRITES   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PWRITE ),
        .AMBA_SLAVE_0_3_PWDATAS   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_3_PWDATA ),
        .FIC_0_CLK                ( EvalSandbox_MSS_0_FIC_0_CLK ),
        .FIC_0_LOCK               (  ),
        .DDR_READY                (  ),
        .MSS_READY                (  ),
        .PWM                      ( PWM_net_0 ),
        .GPIO_1_M2F               ( EvalSandbox_MSS_0_GPIO_1_M2F ),
        // Inouts
        .MDDR_DM_RDQS             ( MDDR_DM_RDQS ),
        .MDDR_DQ                  ( MDDR_DQ ),
        .MDDR_DQS                 ( MDDR_DQS ),
        .MDDR_DQS_N               ( MDDR_DQS_N ) 
        );

//--------SpiMasterTrioPorts
SpiMasterTrioPorts #( 
        .BYTE_WIDTH    ( 1 ),
        .CLOCK_DIVIDER ( 1000 ) )
SpiMasterTrioPorts_0(
        // Inputs
        .clk           ( EvalSandbox_MSS_0_FIC_0_CLK ),
        .rst           ( EvalSandbox_MSS_0_GPIO_1_M2F ),
        .MisoA         ( VCC_net ),
        .MisoB         ( VCC_net ),
        .MisoC         ( VCC_net ),
        .DataToMosiA   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_1_PWDATA_0 ),
        .DataToMosiB   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_2_PWDATA_0 ),
        .DataToMosiC   ( DataToMosiC_const_net_0 ),
        // Outputs
        .MosiA         ( Mosi_net_0 ),
        .MosiB         ( MosiB_net_0 ),
        .MosiC         (  ),
        .Sck           ( Sck_0 ),
        .nCsA          ( nCs_net_0 ),
        .nCsB          ( nCsB_net_0 ),
        .nCsC          (  ),
        .DataFromMisoA (  ),
        .DataFromMisoB (  ),
        .DataFromMisoC (  ),
        .XferComplete  ( XferComplete_net_0 ) 
        );


endmodule

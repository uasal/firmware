//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Jan 29 10:17:16 2024
// Version: 2023.2 2023.2.0.8
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// EvalSandbox_MSS
module EvalSandbox_MSS(
    // Inputs
    AMBA_SLAVE_0_1_PRDATAS2,
    AMBA_SLAVE_0_1_PREADYS2,
    AMBA_SLAVE_0_1_PSLVERRS2,
    AMBA_SLAVE_0_2_PRDATAS3,
    AMBA_SLAVE_0_2_PREADYS3,
    AMBA_SLAVE_0_2_PSLVERRS3,
    AMBA_SLAVE_0_3_PRDATAS4,
    AMBA_SLAVE_0_3_PREADYS4,
    AMBA_SLAVE_0_3_PSLVERRS4,
    AMBA_SLAVE_0_PRDATAS1,
    AMBA_SLAVE_0_PREADYS1,
    AMBA_SLAVE_0_PSLVERRS1,
    DEVRST_N,
    FAB_RESET_N,
    GPIO_0_F2M,
    GPIO_2_F2M,
    MDDR_DQS_TMATCH_0_IN,
    TACHIN,
    // Outputs
    AMBA_SLAVE_0_1_PADDRS,
    AMBA_SLAVE_0_1_PENABLES,
    AMBA_SLAVE_0_1_PSELS2,
    AMBA_SLAVE_0_1_PWDATAS,
    AMBA_SLAVE_0_1_PWRITES,
    AMBA_SLAVE_0_2_PADDRS,
    AMBA_SLAVE_0_2_PENABLES,
    AMBA_SLAVE_0_2_PSELS3,
    AMBA_SLAVE_0_2_PWDATAS,
    AMBA_SLAVE_0_2_PWRITES,
    AMBA_SLAVE_0_3_PADDRS,
    AMBA_SLAVE_0_3_PENABLES,
    AMBA_SLAVE_0_3_PSELS4,
    AMBA_SLAVE_0_3_PWDATAS,
    AMBA_SLAVE_0_3_PWRITES,
    AMBA_SLAVE_0_PADDRS,
    AMBA_SLAVE_0_PENABLES,
    AMBA_SLAVE_0_PSELS1,
    AMBA_SLAVE_0_PWDATAS,
    AMBA_SLAVE_0_PWRITES,
    DDR_READY,
    FIC_0_CLK,
    FIC_0_LOCK,
    GPIO_1_M2F,
    INIT_DONE,
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
    MSS_READY,
    POWER_ON_RESET_N,
    PWM,
    // Inouts
    MDDR_DM_RDQS,
    MDDR_DQ,
    MDDR_DQS,
    MDDR_DQS_N
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [31:0] AMBA_SLAVE_0_1_PRDATAS2;
input         AMBA_SLAVE_0_1_PREADYS2;
input         AMBA_SLAVE_0_1_PSLVERRS2;
input  [31:0] AMBA_SLAVE_0_2_PRDATAS3;
input         AMBA_SLAVE_0_2_PREADYS3;
input         AMBA_SLAVE_0_2_PSLVERRS3;
input  [31:0] AMBA_SLAVE_0_3_PRDATAS4;
input         AMBA_SLAVE_0_3_PREADYS4;
input         AMBA_SLAVE_0_3_PSLVERRS4;
input  [31:0] AMBA_SLAVE_0_PRDATAS1;
input         AMBA_SLAVE_0_PREADYS1;
input         AMBA_SLAVE_0_PSLVERRS1;
input         DEVRST_N;
input         FAB_RESET_N;
input         GPIO_0_F2M;
input         GPIO_2_F2M;
input         MDDR_DQS_TMATCH_0_IN;
input  [1:1]  TACHIN;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [31:0] AMBA_SLAVE_0_1_PADDRS;
output        AMBA_SLAVE_0_1_PENABLES;
output        AMBA_SLAVE_0_1_PSELS2;
output [31:0] AMBA_SLAVE_0_1_PWDATAS;
output        AMBA_SLAVE_0_1_PWRITES;
output [31:0] AMBA_SLAVE_0_2_PADDRS;
output        AMBA_SLAVE_0_2_PENABLES;
output        AMBA_SLAVE_0_2_PSELS3;
output [31:0] AMBA_SLAVE_0_2_PWDATAS;
output        AMBA_SLAVE_0_2_PWRITES;
output [31:0] AMBA_SLAVE_0_3_PADDRS;
output        AMBA_SLAVE_0_3_PENABLES;
output        AMBA_SLAVE_0_3_PSELS4;
output [31:0] AMBA_SLAVE_0_3_PWDATAS;
output        AMBA_SLAVE_0_3_PWRITES;
output [31:0] AMBA_SLAVE_0_PADDRS;
output        AMBA_SLAVE_0_PENABLES;
output        AMBA_SLAVE_0_PSELS1;
output [31:0] AMBA_SLAVE_0_PWDATAS;
output        AMBA_SLAVE_0_PWRITES;
output        DDR_READY;
output        FIC_0_CLK;
output        FIC_0_LOCK;
output        GPIO_1_M2F;
output        INIT_DONE;
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
output        MSS_READY;
output        POWER_ON_RESET_N;
output [2:1]  PWM;
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
wire          AMBA_SLAVE_0_PENABLE;
wire   [31:0] AMBA_SLAVE_0_PRDATAS1;
wire          AMBA_SLAVE_0_PREADYS1;
wire          AMBA_SLAVE_0_PSELx;
wire          AMBA_SLAVE_0_PSLVERRS1;
wire          AMBA_SLAVE_0_PWRITE;
wire   [31:0] AMBA_SLAVE_0_1_PRDATAS2;
wire          AMBA_SLAVE_0_1_PREADYS2;
wire          AMBA_SLAVE_0_1_PSELx;
wire          AMBA_SLAVE_0_1_PSLVERRS2;
wire   [31:0] AMBA_SLAVE_0_2_PRDATAS3;
wire          AMBA_SLAVE_0_2_PREADYS3;
wire          AMBA_SLAVE_0_2_PSELx;
wire          AMBA_SLAVE_0_2_PSLVERRS3;
wire   [31:0] AMBA_SLAVE_0_3_PRDATAS4;
wire          AMBA_SLAVE_0_3_PREADYS4;
wire          AMBA_SLAVE_0_3_PSELx;
wire          AMBA_SLAVE_0_3_PSLVERRS4;
wire          CoreAPB3_0_APBmslave0_PREADY;
wire          CoreAPB3_0_APBmslave0_PSELx;
wire          CoreAPB3_0_APBmslave0_PSLVERR;
wire          CORECONFIGP_0_APB_S_PCLK;
wire          CORECONFIGP_0_APB_S_PRESET_N;
wire          CORECONFIGP_0_CONFIG1_DONE;
wire          CORECONFIGP_0_CONFIG2_DONE;
wire          CORECONFIGP_0_MDDR_APBmslave_PENABLE;
wire          CORECONFIGP_0_MDDR_APBmslave_PREADY;
wire          CORECONFIGP_0_MDDR_APBmslave_PSELx;
wire          CORECONFIGP_0_MDDR_APBmslave_PSLVERR;
wire          CORECONFIGP_0_MDDR_APBmslave_PWRITE;
wire          CORECONFIGP_0_SOFT_EXT_RESET_OUT;
wire          CORECONFIGP_0_SOFT_M3_RESET;
wire          CORECONFIGP_0_SOFT_MDDR_DDR_AXI_S_CORE_RESET;
wire          CORECONFIGP_0_SOFT_RESET_F2M;
wire          corepwm_0_0_TACHINT;
wire          CORERESETP_0_M3_RESET_N;
wire          CORERESETP_0_RESET_N_F2M;
wire          DDR_READY_net_0;
wire          DEVRST_N;
wire   [31:0] EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PADDR;
wire          EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PENABLE;
wire   [31:0] EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PRDATA;
wire          EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PREADY;
wire          EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PSELx;
wire          EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PSLVERR;
wire   [31:0] EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PWDATA;
wire          EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PWRITE;
wire          EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_M_PCLK;
wire          EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_M_PRESET_N;
wire          EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PENABLE;
wire   [31:0] EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PRDATA;
wire          EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PREADY;
wire          EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PSELx;
wire          EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PSLVERR;
wire   [31:0] EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PWDATA;
wire          EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PWRITE;
wire          EvalSandbox_MSS_MSS_TMP_0_MSS_RESET_N_M2F;
wire          FAB_RESET_N;
wire          FABOSC_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC;
wire          FABOSC_0_RCOSC_25_50MHZ_O2F;
wire          FIC_0_CLK_net_0;
wire          FIC_0_LOCK_net_0;
wire          GPIO_0_F2M;
wire          GPIO_1_M2F_net_0;
wire          GPIO_2_F2M;
wire          INIT_DONE_net_0;
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
wire          MSS_READY_net_0;
wire          POWER_ON_RESET_N_net_0;
wire   [2:1]  PWM_net_0;
wire   [1:1]  TACHIN;
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
wire   [15:0] MDDR_ADDR_net_1;
wire   [2:0]  MDDR_BA_net_1;
wire          POWER_ON_RESET_N_net_1;
wire          INIT_DONE_net_1;
wire   [31:0] AMBA_SLAVE_0_PADDR_net_0;
wire          AMBA_SLAVE_0_PSELx_net_0;
wire          AMBA_SLAVE_0_PENABLE_net_0;
wire          AMBA_SLAVE_0_PWRITE_net_0;
wire   [31:0] AMBA_SLAVE_0_PWDATA_net_0;
wire   [31:0] AMBA_SLAVE_0_PADDR_net_1;
wire          AMBA_SLAVE_0_1_PSELx_net_0;
wire          AMBA_SLAVE_0_PENABLE_net_1;
wire          AMBA_SLAVE_0_PWRITE_net_1;
wire   [31:0] AMBA_SLAVE_0_PWDATA_net_1;
wire   [31:0] AMBA_SLAVE_0_PADDR_net_2;
wire          AMBA_SLAVE_0_2_PSELx_net_0;
wire          AMBA_SLAVE_0_PENABLE_net_2;
wire          AMBA_SLAVE_0_PWRITE_net_2;
wire   [31:0] AMBA_SLAVE_0_PWDATA_net_2;
wire   [31:0] AMBA_SLAVE_0_PADDR_net_3;
wire          AMBA_SLAVE_0_3_PSELx_net_0;
wire          AMBA_SLAVE_0_PENABLE_net_3;
wire          AMBA_SLAVE_0_PWRITE_net_3;
wire   [31:0] AMBA_SLAVE_0_PWDATA_net_3;
wire          FIC_0_CLK_net_1;
wire          FIC_0_LOCK_net_1;
wire          DDR_READY_net_1;
wire          MSS_READY_net_1;
wire   [2:1]  PWM_net_1;
wire          GPIO_1_M2F_net_1;
wire   [15:0] MSS_INT_F2M_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
wire   [7:2]  PADDR_const_net_0;
wire   [7:0]  PWDATA_const_net_0;
wire          VCC_net;
wire   [31:0] IADDR_const_net_0;
wire   [31:0] FDDR_PRDATA_const_net_0;
wire   [31:0] SDIF0_PRDATA_const_net_0;
wire   [31:0] SDIF1_PRDATA_const_net_0;
wire   [31:0] SDIF2_PRDATA_const_net_0;
wire   [31:0] SDIF3_PRDATA_const_net_0;
wire   [31:0] SDIF0_PRDATA_const_net_1;
wire   [31:0] SDIF1_PRDATA_const_net_1;
wire   [31:0] SDIF2_PRDATA_const_net_1;
wire   [31:0] SDIF3_PRDATA_const_net_1;
wire   [31:0] PRDATAS5_const_net_0;
wire   [31:0] PRDATAS6_const_net_0;
wire   [31:0] PRDATAS7_const_net_0;
wire   [31:0] PRDATAS8_const_net_0;
wire   [31:0] PRDATAS9_const_net_0;
wire   [31:0] PRDATAS10_const_net_0;
wire   [31:0] PRDATAS11_const_net_0;
wire   [31:0] PRDATAS12_const_net_0;
wire   [31:0] PRDATAS13_const_net_0;
wire   [31:0] PRDATAS14_const_net_0;
wire   [31:0] PRDATAS15_const_net_0;
wire   [31:0] PRDATAS16_const_net_0;
//--------------------------------------------------------------------
// Bus Interface Nets Declarations - Unequal Pin Widths
//--------------------------------------------------------------------
wire   [31:0] AMBA_SLAVE_0_PADDR;
wire   [7:0]  AMBA_SLAVE_0_PADDR_0;
wire   [7:0]  AMBA_SLAVE_0_PADDR_0_7to0;
wire   [31:0] AMBA_SLAVE_0_PWDATA;
wire   [15:0] AMBA_SLAVE_0_PWDATA_0;
wire   [15:0] AMBA_SLAVE_0_PWDATA_0_15to0;
wire   [15:0] CoreAPB3_0_APBmslave0_PRDATA;
wire   [31:0] CoreAPB3_0_APBmslave0_PRDATA_0;
wire   [15:0] CoreAPB3_0_APBmslave0_PRDATA_0_15to0;
wire   [31:16]CoreAPB3_0_APBmslave0_PRDATA_0_31to16;
wire   [15:2] CORECONFIGP_0_MDDR_APBmslave_PADDR;
wire   [10:2] CORECONFIGP_0_MDDR_APBmslave_PADDR_0;
wire   [10:2] CORECONFIGP_0_MDDR_APBmslave_PADDR_0_10to2;
wire   [15:0] CORECONFIGP_0_MDDR_APBmslave_PRDATA;
wire   [31:0] CORECONFIGP_0_MDDR_APBmslave_PRDATA_0;
wire   [15:0] CORECONFIGP_0_MDDR_APBmslave_PRDATA_0_15to0;
wire   [31:16]CORECONFIGP_0_MDDR_APBmslave_PRDATA_0_31to16;
wire   [31:0] CORECONFIGP_0_MDDR_APBmslave_PWDATA;
wire   [15:0] CORECONFIGP_0_MDDR_APBmslave_PWDATA_0;
wire   [15:0] CORECONFIGP_0_MDDR_APBmslave_PWDATA_0_15to0;
wire   [15:2] EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PADDR;
wire   [16:2] EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PADDR_0;
wire   [15:2] EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PADDR_0_15to2;
wire   [16:16]EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PADDR_0_16to16;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net                  = 1'b0;
assign PADDR_const_net_0        = 6'h00;
assign PWDATA_const_net_0       = 8'h00;
assign VCC_net                  = 1'b1;
assign IADDR_const_net_0        = 32'h00000000;
assign FDDR_PRDATA_const_net_0  = 32'h00000000;
assign SDIF0_PRDATA_const_net_0 = 32'h00000000;
assign SDIF1_PRDATA_const_net_0 = 32'h00000000;
assign SDIF2_PRDATA_const_net_0 = 32'h00000000;
assign SDIF3_PRDATA_const_net_0 = 32'h00000000;
assign SDIF0_PRDATA_const_net_1 = 32'h00000000;
assign SDIF1_PRDATA_const_net_1 = 32'h00000000;
assign SDIF2_PRDATA_const_net_1 = 32'h00000000;
assign SDIF3_PRDATA_const_net_1 = 32'h00000000;
assign PRDATAS5_const_net_0     = 32'h00000000;
assign PRDATAS6_const_net_0     = 32'h00000000;
assign PRDATAS7_const_net_0     = 32'h00000000;
assign PRDATAS8_const_net_0     = 32'h00000000;
assign PRDATAS9_const_net_0     = 32'h00000000;
assign PRDATAS10_const_net_0    = 32'h00000000;
assign PRDATAS11_const_net_0    = 32'h00000000;
assign PRDATAS12_const_net_0    = 32'h00000000;
assign PRDATAS13_const_net_0    = 32'h00000000;
assign PRDATAS14_const_net_0    = 32'h00000000;
assign PRDATAS15_const_net_0    = 32'h00000000;
assign PRDATAS16_const_net_0    = 32'h00000000;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign MDDR_DQS_TMATCH_0_OUT_net_1  = MDDR_DQS_TMATCH_0_OUT_net_0;
assign MDDR_DQS_TMATCH_0_OUT        = MDDR_DQS_TMATCH_0_OUT_net_1;
assign MDDR_CAS_N_net_1             = MDDR_CAS_N_net_0;
assign MDDR_CAS_N                   = MDDR_CAS_N_net_1;
assign MDDR_CLK_net_1               = MDDR_CLK_net_0;
assign MDDR_CLK                     = MDDR_CLK_net_1;
assign MDDR_CLK_N_net_1             = MDDR_CLK_N_net_0;
assign MDDR_CLK_N                   = MDDR_CLK_N_net_1;
assign MDDR_CKE_net_1               = MDDR_CKE_net_0;
assign MDDR_CKE                     = MDDR_CKE_net_1;
assign MDDR_CS_N_net_1              = MDDR_CS_N_net_0;
assign MDDR_CS_N                    = MDDR_CS_N_net_1;
assign MDDR_ODT_net_1               = MDDR_ODT_net_0;
assign MDDR_ODT                     = MDDR_ODT_net_1;
assign MDDR_RAS_N_net_1             = MDDR_RAS_N_net_0;
assign MDDR_RAS_N                   = MDDR_RAS_N_net_1;
assign MDDR_RESET_N_net_1           = MDDR_RESET_N_net_0;
assign MDDR_RESET_N                 = MDDR_RESET_N_net_1;
assign MDDR_WE_N_net_1              = MDDR_WE_N_net_0;
assign MDDR_WE_N                    = MDDR_WE_N_net_1;
assign MDDR_ADDR_net_1              = MDDR_ADDR_net_0;
assign MDDR_ADDR[15:0]              = MDDR_ADDR_net_1;
assign MDDR_BA_net_1                = MDDR_BA_net_0;
assign MDDR_BA[2:0]                 = MDDR_BA_net_1;
assign POWER_ON_RESET_N_net_1       = POWER_ON_RESET_N_net_0;
assign POWER_ON_RESET_N             = POWER_ON_RESET_N_net_1;
assign INIT_DONE_net_1              = INIT_DONE_net_0;
assign INIT_DONE                    = INIT_DONE_net_1;
assign AMBA_SLAVE_0_PADDR_net_0     = AMBA_SLAVE_0_PADDR;
assign AMBA_SLAVE_0_PADDRS[31:0]    = AMBA_SLAVE_0_PADDR_net_0;
assign AMBA_SLAVE_0_PSELx_net_0     = AMBA_SLAVE_0_PSELx;
assign AMBA_SLAVE_0_PSELS1          = AMBA_SLAVE_0_PSELx_net_0;
assign AMBA_SLAVE_0_PENABLE_net_0   = AMBA_SLAVE_0_PENABLE;
assign AMBA_SLAVE_0_PENABLES        = AMBA_SLAVE_0_PENABLE_net_0;
assign AMBA_SLAVE_0_PWRITE_net_0    = AMBA_SLAVE_0_PWRITE;
assign AMBA_SLAVE_0_PWRITES         = AMBA_SLAVE_0_PWRITE_net_0;
assign AMBA_SLAVE_0_PWDATA_net_0    = AMBA_SLAVE_0_PWDATA;
assign AMBA_SLAVE_0_PWDATAS[31:0]   = AMBA_SLAVE_0_PWDATA_net_0;
assign AMBA_SLAVE_0_PADDR_net_1     = AMBA_SLAVE_0_PADDR;
assign AMBA_SLAVE_0_1_PADDRS[31:0]  = AMBA_SLAVE_0_PADDR_net_1;
assign AMBA_SLAVE_0_1_PSELx_net_0   = AMBA_SLAVE_0_1_PSELx;
assign AMBA_SLAVE_0_1_PSELS2        = AMBA_SLAVE_0_1_PSELx_net_0;
assign AMBA_SLAVE_0_PENABLE_net_1   = AMBA_SLAVE_0_PENABLE;
assign AMBA_SLAVE_0_1_PENABLES      = AMBA_SLAVE_0_PENABLE_net_1;
assign AMBA_SLAVE_0_PWRITE_net_1    = AMBA_SLAVE_0_PWRITE;
assign AMBA_SLAVE_0_1_PWRITES       = AMBA_SLAVE_0_PWRITE_net_1;
assign AMBA_SLAVE_0_PWDATA_net_1    = AMBA_SLAVE_0_PWDATA;
assign AMBA_SLAVE_0_1_PWDATAS[31:0] = AMBA_SLAVE_0_PWDATA_net_1;
assign AMBA_SLAVE_0_PADDR_net_2     = AMBA_SLAVE_0_PADDR;
assign AMBA_SLAVE_0_2_PADDRS[31:0]  = AMBA_SLAVE_0_PADDR_net_2;
assign AMBA_SLAVE_0_2_PSELx_net_0   = AMBA_SLAVE_0_2_PSELx;
assign AMBA_SLAVE_0_2_PSELS3        = AMBA_SLAVE_0_2_PSELx_net_0;
assign AMBA_SLAVE_0_PENABLE_net_2   = AMBA_SLAVE_0_PENABLE;
assign AMBA_SLAVE_0_2_PENABLES      = AMBA_SLAVE_0_PENABLE_net_2;
assign AMBA_SLAVE_0_PWRITE_net_2    = AMBA_SLAVE_0_PWRITE;
assign AMBA_SLAVE_0_2_PWRITES       = AMBA_SLAVE_0_PWRITE_net_2;
assign AMBA_SLAVE_0_PWDATA_net_2    = AMBA_SLAVE_0_PWDATA;
assign AMBA_SLAVE_0_2_PWDATAS[31:0] = AMBA_SLAVE_0_PWDATA_net_2;
assign AMBA_SLAVE_0_PADDR_net_3     = AMBA_SLAVE_0_PADDR;
assign AMBA_SLAVE_0_3_PADDRS[31:0]  = AMBA_SLAVE_0_PADDR_net_3;
assign AMBA_SLAVE_0_3_PSELx_net_0   = AMBA_SLAVE_0_3_PSELx;
assign AMBA_SLAVE_0_3_PSELS4        = AMBA_SLAVE_0_3_PSELx_net_0;
assign AMBA_SLAVE_0_PENABLE_net_3   = AMBA_SLAVE_0_PENABLE;
assign AMBA_SLAVE_0_3_PENABLES      = AMBA_SLAVE_0_PENABLE_net_3;
assign AMBA_SLAVE_0_PWRITE_net_3    = AMBA_SLAVE_0_PWRITE;
assign AMBA_SLAVE_0_3_PWRITES       = AMBA_SLAVE_0_PWRITE_net_3;
assign AMBA_SLAVE_0_PWDATA_net_3    = AMBA_SLAVE_0_PWDATA;
assign AMBA_SLAVE_0_3_PWDATAS[31:0] = AMBA_SLAVE_0_PWDATA_net_3;
assign FIC_0_CLK_net_1              = FIC_0_CLK_net_0;
assign FIC_0_CLK                    = FIC_0_CLK_net_1;
assign FIC_0_LOCK_net_1             = FIC_0_LOCK_net_0;
assign FIC_0_LOCK                   = FIC_0_LOCK_net_1;
assign DDR_READY_net_1              = DDR_READY_net_0;
assign DDR_READY                    = DDR_READY_net_1;
assign MSS_READY_net_1              = MSS_READY_net_0;
assign MSS_READY                    = MSS_READY_net_1;
assign PWM_net_1                    = PWM_net_0;
assign PWM[2:1]                     = PWM_net_1;
assign GPIO_1_M2F_net_1             = GPIO_1_M2F_net_0;
assign GPIO_1_M2F                   = GPIO_1_M2F_net_1;
//--------------------------------------------------------------------
// Concatenation assignments
//--------------------------------------------------------------------
assign MSS_INT_F2M_net_0 = { 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , corepwm_0_0_TACHINT };
//--------------------------------------------------------------------
// Bus Interface Nets Assignments - Unequal Pin Widths
//--------------------------------------------------------------------
assign AMBA_SLAVE_0_PADDR_0 = { AMBA_SLAVE_0_PADDR_0_7to0 };
assign AMBA_SLAVE_0_PADDR_0_7to0 = AMBA_SLAVE_0_PADDR[7:0];

assign AMBA_SLAVE_0_PWDATA_0 = { AMBA_SLAVE_0_PWDATA_0_15to0 };
assign AMBA_SLAVE_0_PWDATA_0_15to0 = AMBA_SLAVE_0_PWDATA[15:0];

assign CoreAPB3_0_APBmslave0_PRDATA_0 = { CoreAPB3_0_APBmslave0_PRDATA_0_31to16, CoreAPB3_0_APBmslave0_PRDATA_0_15to0 };
assign CoreAPB3_0_APBmslave0_PRDATA_0_15to0 = CoreAPB3_0_APBmslave0_PRDATA[15:0];
assign CoreAPB3_0_APBmslave0_PRDATA_0_31to16 = 16'h0;

assign CORECONFIGP_0_MDDR_APBmslave_PADDR_0 = { CORECONFIGP_0_MDDR_APBmslave_PADDR_0_10to2 };
assign CORECONFIGP_0_MDDR_APBmslave_PADDR_0_10to2 = CORECONFIGP_0_MDDR_APBmslave_PADDR[10:2];

assign CORECONFIGP_0_MDDR_APBmslave_PRDATA_0 = { CORECONFIGP_0_MDDR_APBmslave_PRDATA_0_31to16, CORECONFIGP_0_MDDR_APBmslave_PRDATA_0_15to0 };
assign CORECONFIGP_0_MDDR_APBmslave_PRDATA_0_15to0 = CORECONFIGP_0_MDDR_APBmslave_PRDATA[15:0];
assign CORECONFIGP_0_MDDR_APBmslave_PRDATA_0_31to16 = 16'h0;

assign CORECONFIGP_0_MDDR_APBmslave_PWDATA_0 = { CORECONFIGP_0_MDDR_APBmslave_PWDATA_0_15to0 };
assign CORECONFIGP_0_MDDR_APBmslave_PWDATA_0_15to0 = CORECONFIGP_0_MDDR_APBmslave_PWDATA[15:0];

assign EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PADDR_0 = { EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PADDR_0_16to16, EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PADDR_0_15to2 };
assign EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PADDR_0_15to2 = EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PADDR[15:2];
assign EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PADDR_0_16to16 = 1'b0;

//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------EvalSandbox_MSS_CCC_0_FCCC   -   Actel:SgCore:FCCC:2.0.201
EvalSandbox_MSS_CCC_0_FCCC CCC_0(
        // Inputs
        .RCOSC_25_50MHZ ( FABOSC_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC ),
        // Outputs
        .GL0            ( FIC_0_CLK_net_0 ),
        .LOCK           ( FIC_0_LOCK_net_0 ) 
        );

//--------CoreAPB3   -   Actel:DirectCore:CoreAPB3:4.1.100
CoreAPB3 #( 
        .APB_DWIDTH      ( 32 ),
        .APBSLOT0ENABLE  ( 1 ),
        .APBSLOT1ENABLE  ( 1 ),
        .APBSLOT2ENABLE  ( 1 ),
        .APBSLOT3ENABLE  ( 1 ),
        .APBSLOT4ENABLE  ( 1 ),
        .APBSLOT5ENABLE  ( 0 ),
        .APBSLOT6ENABLE  ( 0 ),
        .APBSLOT7ENABLE  ( 0 ),
        .APBSLOT8ENABLE  ( 0 ),
        .APBSLOT9ENABLE  ( 0 ),
        .APBSLOT10ENABLE ( 0 ),
        .APBSLOT11ENABLE ( 0 ),
        .APBSLOT12ENABLE ( 0 ),
        .APBSLOT13ENABLE ( 0 ),
        .APBSLOT14ENABLE ( 0 ),
        .APBSLOT15ENABLE ( 0 ),
        .FAMILY          ( 19 ),
        .IADDR_OPTION    ( 0 ),
        .MADDR_BITS      ( 16 ),
        .SC_0            ( 0 ),
        .SC_1            ( 0 ),
        .SC_2            ( 0 ),
        .SC_3            ( 0 ),
        .SC_4            ( 0 ),
        .SC_5            ( 0 ),
        .SC_6            ( 0 ),
        .SC_7            ( 0 ),
        .SC_8            ( 0 ),
        .SC_9            ( 0 ),
        .SC_10           ( 0 ),
        .SC_11           ( 0 ),
        .SC_12           ( 0 ),
        .SC_13           ( 0 ),
        .SC_14           ( 0 ),
        .SC_15           ( 0 ),
        .UPR_NIBBLE_POSN ( 3 ) )
CoreAPB3_0(
        // Inputs
        .PRESETN    ( GND_net ), // tied to 1'b0 from definition
        .PCLK       ( GND_net ), // tied to 1'b0 from definition
        .PADDR      ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PADDR ),
        .PWRITE     ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PWRITE ),
        .PENABLE    ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PENABLE ),
        .PWDATA     ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PWDATA ),
        .PSEL       ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PSELx ),
        .PRDATAS0   ( CoreAPB3_0_APBmslave0_PRDATA_0 ),
        .PREADYS0   ( CoreAPB3_0_APBmslave0_PREADY ),
        .PSLVERRS0  ( CoreAPB3_0_APBmslave0_PSLVERR ),
        .PRDATAS1   ( AMBA_SLAVE_0_PRDATAS1 ),
        .PREADYS1   ( AMBA_SLAVE_0_PREADYS1 ),
        .PSLVERRS1  ( AMBA_SLAVE_0_PSLVERRS1 ),
        .PRDATAS2   ( AMBA_SLAVE_0_1_PRDATAS2 ),
        .PREADYS2   ( AMBA_SLAVE_0_1_PREADYS2 ),
        .PSLVERRS2  ( AMBA_SLAVE_0_1_PSLVERRS2 ),
        .PRDATAS3   ( AMBA_SLAVE_0_2_PRDATAS3 ),
        .PREADYS3   ( AMBA_SLAVE_0_2_PREADYS3 ),
        .PSLVERRS3  ( AMBA_SLAVE_0_2_PSLVERRS3 ),
        .PRDATAS4   ( AMBA_SLAVE_0_3_PRDATAS4 ),
        .PREADYS4   ( AMBA_SLAVE_0_3_PREADYS4 ),
        .PSLVERRS4  ( AMBA_SLAVE_0_3_PSLVERRS4 ),
        .PRDATAS5   ( PRDATAS5_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS5   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS5  ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS6   ( PRDATAS6_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS6   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS6  ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS7   ( PRDATAS7_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS7   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS7  ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS8   ( PRDATAS8_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS8   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS8  ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS9   ( PRDATAS9_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS9   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS9  ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS10  ( PRDATAS10_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS10  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS10 ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS11  ( PRDATAS11_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS11  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS11 ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS12  ( PRDATAS12_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS12  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS12 ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS13  ( PRDATAS13_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS13  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS13 ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS14  ( PRDATAS14_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS14  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS14 ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS15  ( PRDATAS15_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS15  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS15 ( GND_net ), // tied to 1'b0 from definition
        .PRDATAS16  ( PRDATAS16_const_net_0 ), // tied to 32'h00000000 from definition
        .PREADYS16  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS16 ( GND_net ), // tied to 1'b0 from definition
        .IADDR      ( IADDR_const_net_0 ), // tied to 32'h00000000 from definition
        // Outputs
        .PRDATA     ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PRDATA ),
        .PREADY     ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PREADY ),
        .PSLVERR    ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PSLVERR ),
        .PADDRS     ( AMBA_SLAVE_0_PADDR ),
        .PWRITES    ( AMBA_SLAVE_0_PWRITE ),
        .PENABLES   ( AMBA_SLAVE_0_PENABLE ),
        .PWDATAS    ( AMBA_SLAVE_0_PWDATA ),
        .PSELS0     ( CoreAPB3_0_APBmslave0_PSELx ),
        .PSELS1     ( AMBA_SLAVE_0_PSELx ),
        .PSELS2     ( AMBA_SLAVE_0_1_PSELx ),
        .PSELS3     ( AMBA_SLAVE_0_2_PSELx ),
        .PSELS4     ( AMBA_SLAVE_0_3_PSELx ),
        .PSELS5     (  ),
        .PSELS6     (  ),
        .PSELS7     (  ),
        .PSELS8     (  ),
        .PSELS9     (  ),
        .PSELS10    (  ),
        .PSELS11    (  ),
        .PSELS12    (  ),
        .PSELS13    (  ),
        .PSELS14    (  ),
        .PSELS15    (  ),
        .PSELS16    (  ) 
        );

//--------CoreConfigP   -   Actel:DirectCore:CoreConfigP:7.1.100
CoreConfigP #( 
        .DEVICE_090         ( 0 ),
        .ENABLE_SOFT_RESETS ( 1 ),
        .FDDR_IN_USE        ( 0 ),
        .MDDR_IN_USE        ( 1 ),
        .SDIF0_IN_USE       ( 0 ),
        .SDIF0_PCIE         ( 0 ),
        .SDIF1_IN_USE       ( 0 ),
        .SDIF1_PCIE         ( 0 ),
        .SDIF2_IN_USE       ( 0 ),
        .SDIF2_PCIE         ( 0 ),
        .SDIF3_IN_USE       ( 0 ),
        .SDIF3_PCIE         ( 0 ) )
CORECONFIGP_0(
        // Inputs
        .FIC_2_APB_M_PRESET_N           ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_M_PRESET_N ),
        .FIC_2_APB_M_PCLK               ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_M_PCLK ),
        .SDIF_RELEASED                  ( GND_net ), // tied to 1'b0 from definition
        .INIT_DONE                      ( INIT_DONE_net_0 ),
        .FIC_2_APB_M_PSEL               ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PSELx ),
        .FIC_2_APB_M_PENABLE            ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PENABLE ),
        .FIC_2_APB_M_PWRITE             ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PWRITE ),
        .FIC_2_APB_M_PADDR              ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PADDR_0 ),
        .FIC_2_APB_M_PWDATA             ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PWDATA ),
        .MDDR_PRDATA                    ( CORECONFIGP_0_MDDR_APBmslave_PRDATA_0 ),
        .MDDR_PREADY                    ( CORECONFIGP_0_MDDR_APBmslave_PREADY ),
        .MDDR_PSLVERR                   ( CORECONFIGP_0_MDDR_APBmslave_PSLVERR ),
        .FDDR_PRDATA                    ( FDDR_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        .FDDR_PREADY                    ( VCC_net ), // tied to 1'b1 from definition
        .FDDR_PSLVERR                   ( GND_net ), // tied to 1'b0 from definition
        .SDIF0_PRDATA                   ( SDIF0_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        .SDIF0_PREADY                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF0_PSLVERR                  ( GND_net ), // tied to 1'b0 from definition
        .SDIF1_PRDATA                   ( SDIF1_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        .SDIF1_PREADY                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF1_PSLVERR                  ( GND_net ), // tied to 1'b0 from definition
        .SDIF2_PRDATA                   ( SDIF2_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        .SDIF2_PREADY                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF2_PSLVERR                  ( GND_net ), // tied to 1'b0 from definition
        .SDIF3_PRDATA                   ( SDIF3_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        .SDIF3_PREADY                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF3_PSLVERR                  ( GND_net ), // tied to 1'b0 from definition
        // Outputs
        .APB_S_PCLK                     ( CORECONFIGP_0_APB_S_PCLK ),
        .APB_S_PRESET_N                 ( CORECONFIGP_0_APB_S_PRESET_N ),
        .CONFIG1_DONE                   ( CORECONFIGP_0_CONFIG1_DONE ),
        .CONFIG2_DONE                   ( CORECONFIGP_0_CONFIG2_DONE ),
        .FIC_2_APB_M_PRDATA             ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PRDATA ),
        .FIC_2_APB_M_PREADY             ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PREADY ),
        .FIC_2_APB_M_PSLVERR            ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PSLVERR ),
        .MDDR_PSEL                      ( CORECONFIGP_0_MDDR_APBmslave_PSELx ),
        .MDDR_PENABLE                   ( CORECONFIGP_0_MDDR_APBmslave_PENABLE ),
        .MDDR_PWRITE                    ( CORECONFIGP_0_MDDR_APBmslave_PWRITE ),
        .MDDR_PADDR                     ( CORECONFIGP_0_MDDR_APBmslave_PADDR ),
        .MDDR_PWDATA                    ( CORECONFIGP_0_MDDR_APBmslave_PWDATA ),
        .FDDR_PSEL                      (  ),
        .FDDR_PENABLE                   (  ),
        .FDDR_PWRITE                    (  ),
        .FDDR_PADDR                     (  ),
        .FDDR_PWDATA                    (  ),
        .SDIF0_PSEL                     (  ),
        .SDIF0_PENABLE                  (  ),
        .SDIF0_PWRITE                   (  ),
        .SDIF0_PADDR                    (  ),
        .SDIF0_PWDATA                   (  ),
        .SDIF1_PSEL                     (  ),
        .SDIF1_PENABLE                  (  ),
        .SDIF1_PWRITE                   (  ),
        .SDIF1_PADDR                    (  ),
        .SDIF1_PWDATA                   (  ),
        .SDIF2_PSEL                     (  ),
        .SDIF2_PENABLE                  (  ),
        .SDIF2_PWRITE                   (  ),
        .SDIF2_PADDR                    (  ),
        .SDIF2_PWDATA                   (  ),
        .SDIF3_PSEL                     (  ),
        .SDIF3_PENABLE                  (  ),
        .SDIF3_PWRITE                   (  ),
        .SDIF3_PADDR                    (  ),
        .SDIF3_PWDATA                   (  ),
        .SOFT_EXT_RESET_OUT             ( CORECONFIGP_0_SOFT_EXT_RESET_OUT ),
        .SOFT_RESET_F2M                 ( CORECONFIGP_0_SOFT_RESET_F2M ),
        .SOFT_M3_RESET                  ( CORECONFIGP_0_SOFT_M3_RESET ),
        .SOFT_MDDR_DDR_AXI_S_CORE_RESET ( CORECONFIGP_0_SOFT_MDDR_DDR_AXI_S_CORE_RESET ),
        .SOFT_FDDR_CORE_RESET           (  ),
        .SOFT_SDIF0_PHY_RESET           (  ),
        .SOFT_SDIF0_CORE_RESET          (  ),
        .SOFT_SDIF0_0_CORE_RESET        (  ),
        .SOFT_SDIF0_1_CORE_RESET        (  ),
        .SOFT_SDIF1_PHY_RESET           (  ),
        .SOFT_SDIF1_CORE_RESET          (  ),
        .SOFT_SDIF2_PHY_RESET           (  ),
        .SOFT_SDIF2_CORE_RESET          (  ),
        .SOFT_SDIF3_PHY_RESET           (  ),
        .SOFT_SDIF3_CORE_RESET          (  ),
        .R_SDIF0_PSEL                   (  ),
        .R_SDIF0_PWRITE                 (  ),
        .R_SDIF0_PRDATA                 (  ),
        .R_SDIF1_PSEL                   (  ),
        .R_SDIF1_PWRITE                 (  ),
        .R_SDIF1_PRDATA                 (  ),
        .R_SDIF2_PSEL                   (  ),
        .R_SDIF2_PWRITE                 (  ),
        .R_SDIF2_PRDATA                 (  ),
        .R_SDIF3_PSEL                   (  ),
        .R_SDIF3_PWRITE                 (  ),
        .R_SDIF3_PRDATA                 (  ) 
        );

//--------corepwm   -   Actel:DirectCore:corepwm:4.1.106
corepwm #( 
        .APB_DWIDTH          ( 16 ),
        .CONFIG_MODE         ( 0 ),
        .DAC_MODE1           ( 0 ),
        .DAC_MODE2           ( 0 ),
        .DAC_MODE3           ( 0 ),
        .DAC_MODE4           ( 0 ),
        .DAC_MODE5           ( 0 ),
        .DAC_MODE6           ( 0 ),
        .DAC_MODE7           ( 0 ),
        .DAC_MODE8           ( 0 ),
        .DAC_MODE9           ( 0 ),
        .DAC_MODE10          ( 0 ),
        .DAC_MODE11          ( 0 ),
        .DAC_MODE12          ( 0 ),
        .DAC_MODE13          ( 0 ),
        .DAC_MODE14          ( 0 ),
        .DAC_MODE15          ( 0 ),
        .DAC_MODE16          ( 0 ),
        .FAMILY              ( 17 ),
        .FIXED_PERIOD        ( 1 ),
        .FIXED_PERIOD_EN     ( 0 ),
        .FIXED_PRESCALE      ( 0 ),
        .FIXED_PRESCALE_EN   ( 0 ),
        .FIXED_PWM_NEG_EN1   ( 0 ),
        .FIXED_PWM_NEG_EN2   ( 0 ),
        .FIXED_PWM_NEG_EN3   ( 0 ),
        .FIXED_PWM_NEG_EN4   ( 0 ),
        .FIXED_PWM_NEG_EN5   ( 0 ),
        .FIXED_PWM_NEG_EN6   ( 0 ),
        .FIXED_PWM_NEG_EN7   ( 0 ),
        .FIXED_PWM_NEG_EN8   ( 0 ),
        .FIXED_PWM_NEG_EN9   ( 0 ),
        .FIXED_PWM_NEG_EN10  ( 0 ),
        .FIXED_PWM_NEG_EN11  ( 0 ),
        .FIXED_PWM_NEG_EN12  ( 0 ),
        .FIXED_PWM_NEG_EN13  ( 0 ),
        .FIXED_PWM_NEG_EN14  ( 0 ),
        .FIXED_PWM_NEG_EN15  ( 0 ),
        .FIXED_PWM_NEG_EN16  ( 0 ),
        .FIXED_PWM_NEGEDGE1  ( 0 ),
        .FIXED_PWM_NEGEDGE2  ( 0 ),
        .FIXED_PWM_NEGEDGE3  ( 0 ),
        .FIXED_PWM_NEGEDGE4  ( 0 ),
        .FIXED_PWM_NEGEDGE5  ( 0 ),
        .FIXED_PWM_NEGEDGE6  ( 0 ),
        .FIXED_PWM_NEGEDGE7  ( 0 ),
        .FIXED_PWM_NEGEDGE8  ( 0 ),
        .FIXED_PWM_NEGEDGE9  ( 0 ),
        .FIXED_PWM_NEGEDGE10 ( 0 ),
        .FIXED_PWM_NEGEDGE11 ( 0 ),
        .FIXED_PWM_NEGEDGE12 ( 0 ),
        .FIXED_PWM_NEGEDGE13 ( 0 ),
        .FIXED_PWM_NEGEDGE14 ( 0 ),
        .FIXED_PWM_NEGEDGE15 ( 0 ),
        .FIXED_PWM_NEGEDGE16 ( 0 ),
        .FIXED_PWM_POS_EN1   ( 0 ),
        .FIXED_PWM_POS_EN2   ( 0 ),
        .FIXED_PWM_POS_EN3   ( 1 ),
        .FIXED_PWM_POS_EN4   ( 1 ),
        .FIXED_PWM_POS_EN5   ( 1 ),
        .FIXED_PWM_POS_EN6   ( 1 ),
        .FIXED_PWM_POS_EN7   ( 1 ),
        .FIXED_PWM_POS_EN8   ( 1 ),
        .FIXED_PWM_POS_EN9   ( 1 ),
        .FIXED_PWM_POS_EN10  ( 1 ),
        .FIXED_PWM_POS_EN11  ( 1 ),
        .FIXED_PWM_POS_EN12  ( 1 ),
        .FIXED_PWM_POS_EN13  ( 1 ),
        .FIXED_PWM_POS_EN14  ( 1 ),
        .FIXED_PWM_POS_EN15  ( 1 ),
        .FIXED_PWM_POS_EN16  ( 1 ),
        .FIXED_PWM_POSEDGE1  ( 0 ),
        .FIXED_PWM_POSEDGE2  ( 0 ),
        .FIXED_PWM_POSEDGE3  ( 0 ),
        .FIXED_PWM_POSEDGE4  ( 0 ),
        .FIXED_PWM_POSEDGE5  ( 0 ),
        .FIXED_PWM_POSEDGE6  ( 0 ),
        .FIXED_PWM_POSEDGE7  ( 0 ),
        .FIXED_PWM_POSEDGE8  ( 0 ),
        .FIXED_PWM_POSEDGE9  ( 0 ),
        .FIXED_PWM_POSEDGE10 ( 0 ),
        .FIXED_PWM_POSEDGE11 ( 0 ),
        .FIXED_PWM_POSEDGE12 ( 0 ),
        .FIXED_PWM_POSEDGE13 ( 0 ),
        .FIXED_PWM_POSEDGE14 ( 0 ),
        .FIXED_PWM_POSEDGE15 ( 0 ),
        .FIXED_PWM_POSEDGE16 ( 0 ),
        .PWM_NUM             ( 2 ),
        .PWM_STRETCH_VALUE1  ( 0 ),
        .PWM_STRETCH_VALUE2  ( 0 ),
        .PWM_STRETCH_VALUE3  ( 0 ),
        .PWM_STRETCH_VALUE4  ( 0 ),
        .PWM_STRETCH_VALUE5  ( 0 ),
        .PWM_STRETCH_VALUE6  ( 0 ),
        .PWM_STRETCH_VALUE7  ( 0 ),
        .PWM_STRETCH_VALUE8  ( 0 ),
        .PWM_STRETCH_VALUE9  ( 0 ),
        .PWM_STRETCH_VALUE10 ( 0 ),
        .PWM_STRETCH_VALUE11 ( 0 ),
        .PWM_STRETCH_VALUE12 ( 0 ),
        .PWM_STRETCH_VALUE13 ( 0 ),
        .PWM_STRETCH_VALUE14 ( 0 ),
        .PWM_STRETCH_VALUE15 ( 0 ),
        .PWM_STRETCH_VALUE16 ( 0 ),
        .SHADOW_REG_EN1      ( 0 ),
        .SHADOW_REG_EN2      ( 0 ),
        .SHADOW_REG_EN3      ( 0 ),
        .SHADOW_REG_EN4      ( 0 ),
        .SHADOW_REG_EN5      ( 0 ),
        .SHADOW_REG_EN6      ( 0 ),
        .SHADOW_REG_EN7      ( 0 ),
        .SHADOW_REG_EN8      ( 0 ),
        .SHADOW_REG_EN9      ( 0 ),
        .SHADOW_REG_EN10     ( 0 ),
        .SHADOW_REG_EN11     ( 0 ),
        .SHADOW_REG_EN12     ( 0 ),
        .SHADOW_REG_EN13     ( 0 ),
        .SHADOW_REG_EN14     ( 0 ),
        .SHADOW_REG_EN15     ( 0 ),
        .SHADOW_REG_EN16     ( 0 ),
        .TACH_EDGE1          ( 0 ),
        .TACH_EDGE2          ( 0 ),
        .TACH_EDGE3          ( 0 ),
        .TACH_EDGE4          ( 0 ),
        .TACH_EDGE5          ( 0 ),
        .TACH_EDGE6          ( 0 ),
        .TACH_EDGE7          ( 0 ),
        .TACH_EDGE8          ( 0 ),
        .TACH_EDGE9          ( 0 ),
        .TACH_EDGE10         ( 0 ),
        .TACH_EDGE11         ( 0 ),
        .TACH_EDGE12         ( 0 ),
        .TACH_EDGE13         ( 0 ),
        .TACH_EDGE14         ( 0 ),
        .TACH_EDGE15         ( 0 ),
        .TACH_EDGE16         ( 0 ),
        .TACH_NUM            ( 1 ),
        .TACHINT_ACT_LEVEL   ( 0 ) )
corepwm_0_0(
        // Inputs
        .PADDR   ( AMBA_SLAVE_0_PADDR_0 ),
        .PCLK    ( FIC_0_CLK_net_0 ),
        .PENABLE ( AMBA_SLAVE_0_PENABLE ),
        .PRESETN ( MSS_READY_net_0 ),
        .PSEL    ( CoreAPB3_0_APBmslave0_PSELx ),
        .PWDATA  ( AMBA_SLAVE_0_PWDATA_0 ),
        .TACHIN  ( TACHIN ),
        .PWRITE  ( AMBA_SLAVE_0_PWRITE ),
        // Outputs
        .PRDATA  ( CoreAPB3_0_APBmslave0_PRDATA ),
        .PREADY  ( CoreAPB3_0_APBmslave0_PREADY ),
        .PSLVERR ( CoreAPB3_0_APBmslave0_PSLVERR ),
        .TACHINT ( corepwm_0_0_TACHINT ),
        .PWM     ( PWM_net_0 ) 
        );

//--------CoreResetP   -   Actel:DirectCore:CoreResetP:7.1.100
CoreResetP #( 
        .DDR_WAIT            ( 200 ),
        .DEVICE_090          ( 0 ),
        .DEVICE_VOLTAGE      ( 2 ),
        .ENABLE_SOFT_RESETS  ( 1 ),
        .EXT_RESET_CFG       ( 0 ),
        .FDDR_IN_USE         ( 0 ),
        .MDDR_IN_USE         ( 1 ),
        .SDIF0_IN_USE        ( 0 ),
        .SDIF0_PCIE          ( 0 ),
        .SDIF0_PCIE_HOTRESET ( 1 ),
        .SDIF0_PCIE_L2P2     ( 1 ),
        .SDIF1_IN_USE        ( 0 ),
        .SDIF1_PCIE          ( 0 ),
        .SDIF1_PCIE_HOTRESET ( 1 ),
        .SDIF1_PCIE_L2P2     ( 1 ),
        .SDIF2_IN_USE        ( 0 ),
        .SDIF2_PCIE          ( 0 ),
        .SDIF2_PCIE_HOTRESET ( 1 ),
        .SDIF2_PCIE_L2P2     ( 1 ),
        .SDIF3_IN_USE        ( 0 ),
        .SDIF3_PCIE          ( 0 ),
        .SDIF3_PCIE_HOTRESET ( 1 ),
        .SDIF3_PCIE_L2P2     ( 1 ) )
CORERESETP_0(
        // Inputs
        .RESET_N_M2F                    ( EvalSandbox_MSS_MSS_TMP_0_MSS_RESET_N_M2F ),
        .FIC_2_APB_M_PRESET_N           ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_M_PRESET_N ),
        .POWER_ON_RESET_N               ( POWER_ON_RESET_N_net_0 ),
        .FAB_RESET_N                    ( FAB_RESET_N ),
        .RCOSC_25_50MHZ                 ( FABOSC_0_RCOSC_25_50MHZ_O2F ),
        .CLK_BASE                       ( FIC_0_CLK_net_0 ),
        .CLK_LTSSM                      ( GND_net ), // tied to 1'b0 from definition
        .FPLL_LOCK                      ( VCC_net ), // tied to 1'b1 from definition
        .SDIF0_SPLL_LOCK                ( VCC_net ), // tied to 1'b1 from definition
        .SDIF1_SPLL_LOCK                ( VCC_net ), // tied to 1'b1 from definition
        .SDIF2_SPLL_LOCK                ( VCC_net ), // tied to 1'b1 from definition
        .SDIF3_SPLL_LOCK                ( VCC_net ), // tied to 1'b1 from definition
        .CONFIG1_DONE                   ( CORECONFIGP_0_CONFIG1_DONE ),
        .CONFIG2_DONE                   ( CORECONFIGP_0_CONFIG2_DONE ),
        .SDIF0_PERST_N                  ( VCC_net ), // tied to 1'b1 from definition
        .SDIF1_PERST_N                  ( VCC_net ), // tied to 1'b1 from definition
        .SDIF2_PERST_N                  ( VCC_net ), // tied to 1'b1 from definition
        .SDIF3_PERST_N                  ( VCC_net ), // tied to 1'b1 from definition
        .SDIF0_PSEL                     ( GND_net ), // tied to 1'b0 from definition
        .SDIF0_PWRITE                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF0_PRDATA                   ( SDIF0_PRDATA_const_net_1 ), // tied to 32'h00000000 from definition
        .SDIF1_PSEL                     ( GND_net ), // tied to 1'b0 from definition
        .SDIF1_PWRITE                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF1_PRDATA                   ( SDIF1_PRDATA_const_net_1 ), // tied to 32'h00000000 from definition
        .SDIF2_PSEL                     ( GND_net ), // tied to 1'b0 from definition
        .SDIF2_PWRITE                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF2_PRDATA                   ( SDIF2_PRDATA_const_net_1 ), // tied to 32'h00000000 from definition
        .SDIF3_PSEL                     ( GND_net ), // tied to 1'b0 from definition
        .SDIF3_PWRITE                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF3_PRDATA                   ( SDIF3_PRDATA_const_net_1 ), // tied to 32'h00000000 from definition
        .SOFT_EXT_RESET_OUT             ( CORECONFIGP_0_SOFT_EXT_RESET_OUT ),
        .SOFT_RESET_F2M                 ( CORECONFIGP_0_SOFT_RESET_F2M ),
        .SOFT_M3_RESET                  ( CORECONFIGP_0_SOFT_M3_RESET ),
        .SOFT_MDDR_DDR_AXI_S_CORE_RESET ( CORECONFIGP_0_SOFT_MDDR_DDR_AXI_S_CORE_RESET ),
        .SOFT_FDDR_CORE_RESET           ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF0_PHY_RESET           ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF0_CORE_RESET          ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF0_0_CORE_RESET        ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF0_1_CORE_RESET        ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF1_PHY_RESET           ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF1_CORE_RESET          ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF2_PHY_RESET           ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF2_CORE_RESET          ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF3_PHY_RESET           ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF3_CORE_RESET          ( GND_net ), // tied to 1'b0 from definition
        // Outputs
        .MSS_HPMS_READY                 ( MSS_READY_net_0 ),
        .DDR_READY                      ( DDR_READY_net_0 ),
        .SDIF_READY                     (  ),
        .RESET_N_F2M                    ( CORERESETP_0_RESET_N_F2M ),
        .M3_RESET_N                     ( CORERESETP_0_M3_RESET_N ),
        .EXT_RESET_OUT                  (  ),
        .MDDR_DDR_AXI_S_CORE_RESET_N    (  ),
        .FDDR_CORE_RESET_N              (  ),
        .SDIF0_CORE_RESET_N             (  ),
        .SDIF0_0_CORE_RESET_N           (  ),
        .SDIF0_1_CORE_RESET_N           (  ),
        .SDIF0_PHY_RESET_N              (  ),
        .SDIF1_CORE_RESET_N             (  ),
        .SDIF1_PHY_RESET_N              (  ),
        .SDIF2_CORE_RESET_N             (  ),
        .SDIF2_PHY_RESET_N              (  ),
        .SDIF3_CORE_RESET_N             (  ),
        .SDIF3_PHY_RESET_N              (  ),
        .SDIF_RELEASED                  (  ),
        .INIT_DONE                      ( INIT_DONE_net_0 ) 
        );

//--------EvalSandbox_MSS_MSS
EvalSandbox_MSS_MSS EvalSandbox_MSS_MSS_0(
        // Inputs
        .MCCC_CLK_BASE          ( FIC_0_CLK_net_0 ),
        .MDDR_DQS_TMATCH_0_IN   ( MDDR_DQS_TMATCH_0_IN ),
        .MCCC_CLK_BASE_PLL_LOCK ( FIC_0_LOCK_net_0 ),
        .MSS_RESET_N_F2M        ( CORERESETP_0_RESET_N_F2M ),
        .GPIO_0_F2M             ( GPIO_0_F2M ),
        .GPIO_2_F2M             ( GPIO_2_F2M ),
        .FIC_0_APB_M_PREADY     ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PREADY ),
        .FIC_0_APB_M_PSLVERR    ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PSLVERR ),
        .M3_RESET_N             ( CORERESETP_0_M3_RESET_N ),
        .MDDR_APB_S_PRESET_N    ( CORECONFIGP_0_APB_S_PRESET_N ),
        .MDDR_APB_S_PCLK        ( CORECONFIGP_0_APB_S_PCLK ),
        .FIC_2_APB_M_PREADY     ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PREADY ),
        .FIC_2_APB_M_PSLVERR    ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PSLVERR ),
        .MDDR_APB_S_PWRITE      ( CORECONFIGP_0_MDDR_APBmslave_PWRITE ),
        .MDDR_APB_S_PENABLE     ( CORECONFIGP_0_MDDR_APBmslave_PENABLE ),
        .MDDR_APB_S_PSEL        ( CORECONFIGP_0_MDDR_APBmslave_PSELx ),
        .MSS_INT_F2M            ( MSS_INT_F2M_net_0 ),
        .FIC_0_APB_M_PRDATA     ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PRDATA ),
        .FIC_2_APB_M_PRDATA     ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PRDATA ),
        .MDDR_APB_S_PWDATA      ( CORECONFIGP_0_MDDR_APBmslave_PWDATA_0 ),
        .MDDR_APB_S_PADDR       ( CORECONFIGP_0_MDDR_APBmslave_PADDR_0 ),
        // Outputs
        .MDDR_DQS_TMATCH_0_OUT  ( MDDR_DQS_TMATCH_0_OUT_net_0 ),
        .MDDR_CAS_N             ( MDDR_CAS_N_net_0 ),
        .MDDR_CLK               ( MDDR_CLK_net_0 ),
        .MDDR_CLK_N             ( MDDR_CLK_N_net_0 ),
        .MDDR_CKE               ( MDDR_CKE_net_0 ),
        .MDDR_CS_N              ( MDDR_CS_N_net_0 ),
        .MDDR_ODT               ( MDDR_ODT_net_0 ),
        .MDDR_RAS_N             ( MDDR_RAS_N_net_0 ),
        .MDDR_RESET_N           ( MDDR_RESET_N_net_0 ),
        .MDDR_WE_N              ( MDDR_WE_N_net_0 ),
        .MSS_RESET_N_M2F        ( EvalSandbox_MSS_MSS_TMP_0_MSS_RESET_N_M2F ),
        .GPIO_1_M2F             ( GPIO_1_M2F_net_0 ),
        .FIC_0_APB_M_PSEL       ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PSELx ),
        .FIC_0_APB_M_PWRITE     ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PWRITE ),
        .FIC_0_APB_M_PENABLE    ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PENABLE ),
        .FIC_2_APB_M_PRESET_N   ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_M_PRESET_N ),
        .FIC_2_APB_M_PCLK       ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_M_PCLK ),
        .FIC_2_APB_M_PWRITE     ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PWRITE ),
        .FIC_2_APB_M_PENABLE    ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PENABLE ),
        .FIC_2_APB_M_PSEL       ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PSELx ),
        .MDDR_APB_S_PREADY      ( CORECONFIGP_0_MDDR_APBmslave_PREADY ),
        .MDDR_APB_S_PSLVERR     ( CORECONFIGP_0_MDDR_APBmslave_PSLVERR ),
        .MDDR_ADDR              ( MDDR_ADDR_net_0 ),
        .MDDR_BA                ( MDDR_BA_net_0 ),
        .FIC_0_APB_M_PADDR      ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PADDR ),
        .FIC_0_APB_M_PWDATA     ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PWDATA ),
        .FIC_2_APB_M_PADDR      ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PADDR ),
        .FIC_2_APB_M_PWDATA     ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_MASTER_PWDATA ),
        .MDDR_APB_S_PRDATA      ( CORECONFIGP_0_MDDR_APBmslave_PRDATA ),
        // Inouts
        .MDDR_DM_RDQS           ( MDDR_DM_RDQS ),
        .MDDR_DQ                ( MDDR_DQ ),
        .MDDR_DQS               ( MDDR_DQS ),
        .MDDR_DQS_N             ( MDDR_DQS_N ) 
        );

//--------EvalSandbox_MSS_FABOSC_0_OSC   -   Actel:SgCore:OSC:2.0.101
EvalSandbox_MSS_FABOSC_0_OSC FABOSC_0(
        // Inputs
        .XTL                ( GND_net ), // tied to 1'b0 from definition
        // Outputs
        .RCOSC_25_50MHZ_CCC ( FABOSC_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC ),
        .RCOSC_25_50MHZ_O2F ( FABOSC_0_RCOSC_25_50MHZ_O2F ),
        .RCOSC_1MHZ_CCC     (  ),
        .RCOSC_1MHZ_O2F     (  ),
        .XTLOSC_CCC         (  ),
        .XTLOSC_O2F         (  ) 
        );

//--------SYSRESET
SYSRESET SYSRESET_POR(
        // Inputs
        .DEVRST_N         ( DEVRST_N ),
        // Outputs
        .POWER_ON_RESET_N ( POWER_ON_RESET_N_net_0 ) 
        );


endmodule

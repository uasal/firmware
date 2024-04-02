//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Fri Mar 29 14:02:40 2024
// Version: 2023.2 2023.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// EvalSandbox_MSS
module EvalSandbox_MSS(
    // Inputs
    AMBA_SLAVE_0_1_PRDATAS1,
    AMBA_SLAVE_0_1_PREADYS1,
    AMBA_SLAVE_0_1_PSLVERRS1,
    AMBA_SLAVE_0_2_PRDATAS2,
    AMBA_SLAVE_0_2_PREADYS2,
    AMBA_SLAVE_0_2_PSLVERRS2,
    AMBA_SLAVE_0_3_PRDATAS3,
    AMBA_SLAVE_0_3_PREADYS3,
    AMBA_SLAVE_0_3_PSLVERRS3,
    AMBA_SLAVE_0_4_PRDATAS4,
    AMBA_SLAVE_0_4_PREADYS4,
    AMBA_SLAVE_0_4_PSLVERRS4,
    AMBA_SLAVE_0_5_PRDATAS5,
    AMBA_SLAVE_0_5_PREADYS5,
    AMBA_SLAVE_0_5_PSLVERRS5,
    AMBA_SLAVE_0_6_PRDATAS6,
    AMBA_SLAVE_0_6_PREADYS6,
    AMBA_SLAVE_0_6_PSLVERRS6,
    AMBA_SLAVE_0_PRDATAS0,
    AMBA_SLAVE_0_PREADYS0,
    AMBA_SLAVE_0_PSLVERRS0,
    CLK0,
    DEVRST_N,
    FAB_RESET_N,
    GPIO_0_F2M,
    GPIO_2_F2M,
    GPIO_7_F2M,
    // Outputs
    AMBA_SLAVE_0_1_PADDRS,
    AMBA_SLAVE_0_1_PENABLES,
    AMBA_SLAVE_0_1_PSELS1,
    AMBA_SLAVE_0_1_PWDATAS,
    AMBA_SLAVE_0_1_PWRITES,
    AMBA_SLAVE_0_2_PADDRS,
    AMBA_SLAVE_0_2_PENABLES,
    AMBA_SLAVE_0_2_PSELS2,
    AMBA_SLAVE_0_2_PWDATAS,
    AMBA_SLAVE_0_2_PWRITES,
    AMBA_SLAVE_0_3_PADDRS,
    AMBA_SLAVE_0_3_PENABLES,
    AMBA_SLAVE_0_3_PSELS3,
    AMBA_SLAVE_0_3_PWDATAS,
    AMBA_SLAVE_0_3_PWRITES,
    AMBA_SLAVE_0_4_PADDRS,
    AMBA_SLAVE_0_4_PENABLES,
    AMBA_SLAVE_0_4_PSELS4,
    AMBA_SLAVE_0_4_PWDATAS,
    AMBA_SLAVE_0_4_PWRITES,
    AMBA_SLAVE_0_5_PADDRS,
    AMBA_SLAVE_0_5_PENABLES,
    AMBA_SLAVE_0_5_PSELS5,
    AMBA_SLAVE_0_5_PWDATAS,
    AMBA_SLAVE_0_5_PWRITES,
    AMBA_SLAVE_0_6_PADDRS,
    AMBA_SLAVE_0_6_PENABLES,
    AMBA_SLAVE_0_6_PSELS6,
    AMBA_SLAVE_0_6_PWDATAS,
    AMBA_SLAVE_0_6_PWRITES,
    AMBA_SLAVE_0_PADDRS,
    AMBA_SLAVE_0_PENABLES,
    AMBA_SLAVE_0_PSELS0,
    AMBA_SLAVE_0_PWDATAS,
    AMBA_SLAVE_0_PWRITES,
    FIC_0_CLK,
    FIC_0_LOCK,
    GPIO_1_M2F,
    GPIO_3_M2F,
    GPIO_4_M2F,
    GPIO_5_M2F,
    GPIO_6_M2F,
    INIT_DONE,
    MSS_READY,
    POWER_ON_RESET_N
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [31:0] AMBA_SLAVE_0_1_PRDATAS1;
input         AMBA_SLAVE_0_1_PREADYS1;
input         AMBA_SLAVE_0_1_PSLVERRS1;
input  [31:0] AMBA_SLAVE_0_2_PRDATAS2;
input         AMBA_SLAVE_0_2_PREADYS2;
input         AMBA_SLAVE_0_2_PSLVERRS2;
input  [31:0] AMBA_SLAVE_0_3_PRDATAS3;
input         AMBA_SLAVE_0_3_PREADYS3;
input         AMBA_SLAVE_0_3_PSLVERRS3;
input  [31:0] AMBA_SLAVE_0_4_PRDATAS4;
input         AMBA_SLAVE_0_4_PREADYS4;
input         AMBA_SLAVE_0_4_PSLVERRS4;
input  [31:0] AMBA_SLAVE_0_5_PRDATAS5;
input         AMBA_SLAVE_0_5_PREADYS5;
input         AMBA_SLAVE_0_5_PSLVERRS5;
input  [31:0] AMBA_SLAVE_0_6_PRDATAS6;
input         AMBA_SLAVE_0_6_PREADYS6;
input         AMBA_SLAVE_0_6_PSLVERRS6;
input  [31:0] AMBA_SLAVE_0_PRDATAS0;
input         AMBA_SLAVE_0_PREADYS0;
input         AMBA_SLAVE_0_PSLVERRS0;
input         CLK0;
input         DEVRST_N;
input         FAB_RESET_N;
input         GPIO_0_F2M;
input         GPIO_2_F2M;
input         GPIO_7_F2M;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [31:0] AMBA_SLAVE_0_1_PADDRS;
output        AMBA_SLAVE_0_1_PENABLES;
output        AMBA_SLAVE_0_1_PSELS1;
output [31:0] AMBA_SLAVE_0_1_PWDATAS;
output        AMBA_SLAVE_0_1_PWRITES;
output [31:0] AMBA_SLAVE_0_2_PADDRS;
output        AMBA_SLAVE_0_2_PENABLES;
output        AMBA_SLAVE_0_2_PSELS2;
output [31:0] AMBA_SLAVE_0_2_PWDATAS;
output        AMBA_SLAVE_0_2_PWRITES;
output [31:0] AMBA_SLAVE_0_3_PADDRS;
output        AMBA_SLAVE_0_3_PENABLES;
output        AMBA_SLAVE_0_3_PSELS3;
output [31:0] AMBA_SLAVE_0_3_PWDATAS;
output        AMBA_SLAVE_0_3_PWRITES;
output [31:0] AMBA_SLAVE_0_4_PADDRS;
output        AMBA_SLAVE_0_4_PENABLES;
output        AMBA_SLAVE_0_4_PSELS4;
output [31:0] AMBA_SLAVE_0_4_PWDATAS;
output        AMBA_SLAVE_0_4_PWRITES;
output [31:0] AMBA_SLAVE_0_5_PADDRS;
output        AMBA_SLAVE_0_5_PENABLES;
output        AMBA_SLAVE_0_5_PSELS5;
output [31:0] AMBA_SLAVE_0_5_PWDATAS;
output        AMBA_SLAVE_0_5_PWRITES;
output [31:0] AMBA_SLAVE_0_6_PADDRS;
output        AMBA_SLAVE_0_6_PENABLES;
output        AMBA_SLAVE_0_6_PSELS6;
output [31:0] AMBA_SLAVE_0_6_PWDATAS;
output        AMBA_SLAVE_0_6_PWRITES;
output [31:0] AMBA_SLAVE_0_PADDRS;
output        AMBA_SLAVE_0_PENABLES;
output        AMBA_SLAVE_0_PSELS0;
output [31:0] AMBA_SLAVE_0_PWDATAS;
output        AMBA_SLAVE_0_PWRITES;
output        FIC_0_CLK;
output        FIC_0_LOCK;
output        GPIO_1_M2F;
output        GPIO_3_M2F;
output        GPIO_4_M2F;
output        GPIO_5_M2F;
output        GPIO_6_M2F;
output        INIT_DONE;
output        MSS_READY;
output        POWER_ON_RESET_N;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   [31:0] AMBA_SLAVE_0_PADDR;
wire          AMBA_SLAVE_0_PENABLE;
wire   [31:0] AMBA_SLAVE_0_PRDATAS0;
wire          AMBA_SLAVE_0_PREADYS0;
wire          AMBA_SLAVE_0_PSELx;
wire          AMBA_SLAVE_0_PSLVERRS0;
wire   [31:0] AMBA_SLAVE_0_PWDATA;
wire          AMBA_SLAVE_0_PWRITE;
wire   [31:0] AMBA_SLAVE_0_1_PRDATAS1;
wire          AMBA_SLAVE_0_1_PREADYS1;
wire          AMBA_SLAVE_0_1_PSELx;
wire          AMBA_SLAVE_0_1_PSLVERRS1;
wire   [31:0] AMBA_SLAVE_0_2_PRDATAS2;
wire          AMBA_SLAVE_0_2_PREADYS2;
wire          AMBA_SLAVE_0_2_PSELx;
wire          AMBA_SLAVE_0_2_PSLVERRS2;
wire   [31:0] AMBA_SLAVE_0_3_PRDATAS3;
wire          AMBA_SLAVE_0_3_PREADYS3;
wire          AMBA_SLAVE_0_3_PSELx;
wire          AMBA_SLAVE_0_3_PSLVERRS3;
wire   [31:0] AMBA_SLAVE_0_4_PRDATAS4;
wire          AMBA_SLAVE_0_4_PREADYS4;
wire          AMBA_SLAVE_0_4_PSELx;
wire          AMBA_SLAVE_0_4_PSLVERRS4;
wire   [31:0] AMBA_SLAVE_0_5_PRDATAS5;
wire          AMBA_SLAVE_0_5_PREADYS5;
wire          AMBA_SLAVE_0_5_PSELx;
wire          AMBA_SLAVE_0_5_PSLVERRS5;
wire   [31:0] AMBA_SLAVE_0_6_PRDATAS6;
wire          AMBA_SLAVE_0_6_PREADYS6;
wire          AMBA_SLAVE_0_6_PSELx;
wire          AMBA_SLAVE_0_6_PSLVERRS6;
wire          CLK0;
wire          CORERESETP_0_RESET_N_F2M;
wire          DEVRST_N;
wire   [31:0] EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PADDR;
wire          EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PENABLE;
wire   [31:0] EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PRDATA;
wire          EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PREADY;
wire          EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PSELx;
wire          EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PSLVERR;
wire   [31:0] EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PWDATA;
wire          EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PWRITE;
wire          EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_M_PRESET_N;
wire          EvalSandbox_MSS_MSS_TMP_0_MSS_RESET_N_M2F;
wire          FAB_RESET_N;
wire          FABOSC_0_RCOSC_25_50MHZ_O2F;
wire          FIC_0_CLK_net_0;
wire          FIC_0_LOCK_net_0;
wire          GPIO_0_F2M;
wire          GPIO_1_M2F_net_0;
wire          GPIO_2_F2M;
wire          GPIO_3_M2F_net_0;
wire          GPIO_4_M2F_net_0;
wire          GPIO_5_M2F_net_0;
wire          GPIO_6_M2F_net_0;
wire          GPIO_7_F2M;
wire          INIT_DONE_net_0;
wire          MSS_READY_net_0;
wire          POWER_ON_RESET_N_net_0;
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
wire   [31:0] AMBA_SLAVE_0_PADDR_net_4;
wire          AMBA_SLAVE_0_4_PSELx_net_0;
wire          AMBA_SLAVE_0_PENABLE_net_4;
wire          AMBA_SLAVE_0_PWRITE_net_4;
wire   [31:0] AMBA_SLAVE_0_PWDATA_net_4;
wire   [31:0] AMBA_SLAVE_0_PADDR_net_5;
wire          AMBA_SLAVE_0_5_PSELx_net_0;
wire          AMBA_SLAVE_0_PENABLE_net_5;
wire          AMBA_SLAVE_0_PWRITE_net_5;
wire   [31:0] AMBA_SLAVE_0_PWDATA_net_5;
wire   [31:0] AMBA_SLAVE_0_PADDR_net_6;
wire          AMBA_SLAVE_0_6_PSELx_net_0;
wire          AMBA_SLAVE_0_PENABLE_net_6;
wire          AMBA_SLAVE_0_PWRITE_net_6;
wire   [31:0] AMBA_SLAVE_0_PWDATA_net_6;
wire          FIC_0_CLK_net_1;
wire          FIC_0_LOCK_net_1;
wire          MSS_READY_net_1;
wire          GPIO_1_M2F_net_1;
wire          GPIO_3_M2F_net_1;
wire          GPIO_4_M2F_net_1;
wire          GPIO_5_M2F_net_1;
wire          GPIO_6_M2F_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          VCC_net;
wire          GND_net;
wire   [7:2]  PADDR_const_net_0;
wire   [7:0]  PWDATA_const_net_0;
wire   [31:0] IADDR_const_net_0;
wire   [31:0] SDIF0_PRDATA_const_net_0;
wire   [31:0] SDIF1_PRDATA_const_net_0;
wire   [31:0] SDIF2_PRDATA_const_net_0;
wire   [31:0] SDIF3_PRDATA_const_net_0;
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
wire   [31:0] FIC_2_APB_M_PRDATA_const_net_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign VCC_net                        = 1'b1;
assign GND_net                        = 1'b0;
assign PADDR_const_net_0              = 6'h00;
assign PWDATA_const_net_0             = 8'h00;
assign IADDR_const_net_0              = 32'h00000000;
assign SDIF0_PRDATA_const_net_0       = 32'h00000000;
assign SDIF1_PRDATA_const_net_0       = 32'h00000000;
assign SDIF2_PRDATA_const_net_0       = 32'h00000000;
assign SDIF3_PRDATA_const_net_0       = 32'h00000000;
assign PRDATAS7_const_net_0           = 32'h00000000;
assign PRDATAS8_const_net_0           = 32'h00000000;
assign PRDATAS9_const_net_0           = 32'h00000000;
assign PRDATAS10_const_net_0          = 32'h00000000;
assign PRDATAS11_const_net_0          = 32'h00000000;
assign PRDATAS12_const_net_0          = 32'h00000000;
assign PRDATAS13_const_net_0          = 32'h00000000;
assign PRDATAS14_const_net_0          = 32'h00000000;
assign PRDATAS15_const_net_0          = 32'h00000000;
assign PRDATAS16_const_net_0          = 32'h00000000;
assign FIC_2_APB_M_PRDATA_const_net_0 = 32'h00000000;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign POWER_ON_RESET_N_net_1       = POWER_ON_RESET_N_net_0;
assign POWER_ON_RESET_N             = POWER_ON_RESET_N_net_1;
assign INIT_DONE_net_1              = INIT_DONE_net_0;
assign INIT_DONE                    = INIT_DONE_net_1;
assign AMBA_SLAVE_0_PADDR_net_0     = AMBA_SLAVE_0_PADDR;
assign AMBA_SLAVE_0_PADDRS[31:0]    = AMBA_SLAVE_0_PADDR_net_0;
assign AMBA_SLAVE_0_PSELx_net_0     = AMBA_SLAVE_0_PSELx;
assign AMBA_SLAVE_0_PSELS0          = AMBA_SLAVE_0_PSELx_net_0;
assign AMBA_SLAVE_0_PENABLE_net_0   = AMBA_SLAVE_0_PENABLE;
assign AMBA_SLAVE_0_PENABLES        = AMBA_SLAVE_0_PENABLE_net_0;
assign AMBA_SLAVE_0_PWRITE_net_0    = AMBA_SLAVE_0_PWRITE;
assign AMBA_SLAVE_0_PWRITES         = AMBA_SLAVE_0_PWRITE_net_0;
assign AMBA_SLAVE_0_PWDATA_net_0    = AMBA_SLAVE_0_PWDATA;
assign AMBA_SLAVE_0_PWDATAS[31:0]   = AMBA_SLAVE_0_PWDATA_net_0;
assign AMBA_SLAVE_0_PADDR_net_1     = AMBA_SLAVE_0_PADDR;
assign AMBA_SLAVE_0_1_PADDRS[31:0]  = AMBA_SLAVE_0_PADDR_net_1;
assign AMBA_SLAVE_0_1_PSELx_net_0   = AMBA_SLAVE_0_1_PSELx;
assign AMBA_SLAVE_0_1_PSELS1        = AMBA_SLAVE_0_1_PSELx_net_0;
assign AMBA_SLAVE_0_PENABLE_net_1   = AMBA_SLAVE_0_PENABLE;
assign AMBA_SLAVE_0_1_PENABLES      = AMBA_SLAVE_0_PENABLE_net_1;
assign AMBA_SLAVE_0_PWRITE_net_1    = AMBA_SLAVE_0_PWRITE;
assign AMBA_SLAVE_0_1_PWRITES       = AMBA_SLAVE_0_PWRITE_net_1;
assign AMBA_SLAVE_0_PWDATA_net_1    = AMBA_SLAVE_0_PWDATA;
assign AMBA_SLAVE_0_1_PWDATAS[31:0] = AMBA_SLAVE_0_PWDATA_net_1;
assign AMBA_SLAVE_0_PADDR_net_2     = AMBA_SLAVE_0_PADDR;
assign AMBA_SLAVE_0_2_PADDRS[31:0]  = AMBA_SLAVE_0_PADDR_net_2;
assign AMBA_SLAVE_0_2_PSELx_net_0   = AMBA_SLAVE_0_2_PSELx;
assign AMBA_SLAVE_0_2_PSELS2        = AMBA_SLAVE_0_2_PSELx_net_0;
assign AMBA_SLAVE_0_PENABLE_net_2   = AMBA_SLAVE_0_PENABLE;
assign AMBA_SLAVE_0_2_PENABLES      = AMBA_SLAVE_0_PENABLE_net_2;
assign AMBA_SLAVE_0_PWRITE_net_2    = AMBA_SLAVE_0_PWRITE;
assign AMBA_SLAVE_0_2_PWRITES       = AMBA_SLAVE_0_PWRITE_net_2;
assign AMBA_SLAVE_0_PWDATA_net_2    = AMBA_SLAVE_0_PWDATA;
assign AMBA_SLAVE_0_2_PWDATAS[31:0] = AMBA_SLAVE_0_PWDATA_net_2;
assign AMBA_SLAVE_0_PADDR_net_3     = AMBA_SLAVE_0_PADDR;
assign AMBA_SLAVE_0_3_PADDRS[31:0]  = AMBA_SLAVE_0_PADDR_net_3;
assign AMBA_SLAVE_0_3_PSELx_net_0   = AMBA_SLAVE_0_3_PSELx;
assign AMBA_SLAVE_0_3_PSELS3        = AMBA_SLAVE_0_3_PSELx_net_0;
assign AMBA_SLAVE_0_PENABLE_net_3   = AMBA_SLAVE_0_PENABLE;
assign AMBA_SLAVE_0_3_PENABLES      = AMBA_SLAVE_0_PENABLE_net_3;
assign AMBA_SLAVE_0_PWRITE_net_3    = AMBA_SLAVE_0_PWRITE;
assign AMBA_SLAVE_0_3_PWRITES       = AMBA_SLAVE_0_PWRITE_net_3;
assign AMBA_SLAVE_0_PWDATA_net_3    = AMBA_SLAVE_0_PWDATA;
assign AMBA_SLAVE_0_3_PWDATAS[31:0] = AMBA_SLAVE_0_PWDATA_net_3;
assign AMBA_SLAVE_0_PADDR_net_4     = AMBA_SLAVE_0_PADDR;
assign AMBA_SLAVE_0_4_PADDRS[31:0]  = AMBA_SLAVE_0_PADDR_net_4;
assign AMBA_SLAVE_0_4_PSELx_net_0   = AMBA_SLAVE_0_4_PSELx;
assign AMBA_SLAVE_0_4_PSELS4        = AMBA_SLAVE_0_4_PSELx_net_0;
assign AMBA_SLAVE_0_PENABLE_net_4   = AMBA_SLAVE_0_PENABLE;
assign AMBA_SLAVE_0_4_PENABLES      = AMBA_SLAVE_0_PENABLE_net_4;
assign AMBA_SLAVE_0_PWRITE_net_4    = AMBA_SLAVE_0_PWRITE;
assign AMBA_SLAVE_0_4_PWRITES       = AMBA_SLAVE_0_PWRITE_net_4;
assign AMBA_SLAVE_0_PWDATA_net_4    = AMBA_SLAVE_0_PWDATA;
assign AMBA_SLAVE_0_4_PWDATAS[31:0] = AMBA_SLAVE_0_PWDATA_net_4;
assign AMBA_SLAVE_0_PADDR_net_5     = AMBA_SLAVE_0_PADDR;
assign AMBA_SLAVE_0_5_PADDRS[31:0]  = AMBA_SLAVE_0_PADDR_net_5;
assign AMBA_SLAVE_0_5_PSELx_net_0   = AMBA_SLAVE_0_5_PSELx;
assign AMBA_SLAVE_0_5_PSELS5        = AMBA_SLAVE_0_5_PSELx_net_0;
assign AMBA_SLAVE_0_PENABLE_net_5   = AMBA_SLAVE_0_PENABLE;
assign AMBA_SLAVE_0_5_PENABLES      = AMBA_SLAVE_0_PENABLE_net_5;
assign AMBA_SLAVE_0_PWRITE_net_5    = AMBA_SLAVE_0_PWRITE;
assign AMBA_SLAVE_0_5_PWRITES       = AMBA_SLAVE_0_PWRITE_net_5;
assign AMBA_SLAVE_0_PWDATA_net_5    = AMBA_SLAVE_0_PWDATA;
assign AMBA_SLAVE_0_5_PWDATAS[31:0] = AMBA_SLAVE_0_PWDATA_net_5;
assign AMBA_SLAVE_0_PADDR_net_6     = AMBA_SLAVE_0_PADDR;
assign AMBA_SLAVE_0_6_PADDRS[31:0]  = AMBA_SLAVE_0_PADDR_net_6;
assign AMBA_SLAVE_0_6_PSELx_net_0   = AMBA_SLAVE_0_6_PSELx;
assign AMBA_SLAVE_0_6_PSELS6        = AMBA_SLAVE_0_6_PSELx_net_0;
assign AMBA_SLAVE_0_PENABLE_net_6   = AMBA_SLAVE_0_PENABLE;
assign AMBA_SLAVE_0_6_PENABLES      = AMBA_SLAVE_0_PENABLE_net_6;
assign AMBA_SLAVE_0_PWRITE_net_6    = AMBA_SLAVE_0_PWRITE;
assign AMBA_SLAVE_0_6_PWRITES       = AMBA_SLAVE_0_PWRITE_net_6;
assign AMBA_SLAVE_0_PWDATA_net_6    = AMBA_SLAVE_0_PWDATA;
assign AMBA_SLAVE_0_6_PWDATAS[31:0] = AMBA_SLAVE_0_PWDATA_net_6;
assign FIC_0_CLK_net_1              = FIC_0_CLK_net_0;
assign FIC_0_CLK                    = FIC_0_CLK_net_1;
assign FIC_0_LOCK_net_1             = FIC_0_LOCK_net_0;
assign FIC_0_LOCK                   = FIC_0_LOCK_net_1;
assign MSS_READY_net_1              = MSS_READY_net_0;
assign MSS_READY                    = MSS_READY_net_1;
assign GPIO_1_M2F_net_1             = GPIO_1_M2F_net_0;
assign GPIO_1_M2F                   = GPIO_1_M2F_net_1;
assign GPIO_3_M2F_net_1             = GPIO_3_M2F_net_0;
assign GPIO_3_M2F                   = GPIO_3_M2F_net_1;
assign GPIO_4_M2F_net_1             = GPIO_4_M2F_net_0;
assign GPIO_4_M2F                   = GPIO_4_M2F_net_1;
assign GPIO_5_M2F_net_1             = GPIO_5_M2F_net_0;
assign GPIO_5_M2F                   = GPIO_5_M2F_net_1;
assign GPIO_6_M2F_net_1             = GPIO_6_M2F_net_0;
assign GPIO_6_M2F                   = GPIO_6_M2F_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------EvalSandbox_MSS_CCC_0_FCCC   -   Actel:SgCore:FCCC:2.0.201
EvalSandbox_MSS_CCC_0_FCCC CCC_0(
        // Inputs
        .CLK0 ( CLK0 ),
        // Outputs
        .GL0  ( FIC_0_CLK_net_0 ),
        .LOCK ( FIC_0_LOCK_net_0 ) 
        );

//--------CoreAPB3   -   Actel:DirectCore:CoreAPB3:4.1.100
CoreAPB3 #( 
        .APB_DWIDTH      ( 32 ),
        .APBSLOT0ENABLE  ( 1 ),
        .APBSLOT1ENABLE  ( 1 ),
        .APBSLOT2ENABLE  ( 1 ),
        .APBSLOT3ENABLE  ( 1 ),
        .APBSLOT4ENABLE  ( 1 ),
        .APBSLOT5ENABLE  ( 1 ),
        .APBSLOT6ENABLE  ( 1 ),
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
        .PRDATAS0   ( AMBA_SLAVE_0_PRDATAS0 ),
        .PREADYS0   ( AMBA_SLAVE_0_PREADYS0 ),
        .PSLVERRS0  ( AMBA_SLAVE_0_PSLVERRS0 ),
        .PRDATAS1   ( AMBA_SLAVE_0_1_PRDATAS1 ),
        .PREADYS1   ( AMBA_SLAVE_0_1_PREADYS1 ),
        .PSLVERRS1  ( AMBA_SLAVE_0_1_PSLVERRS1 ),
        .PRDATAS2   ( AMBA_SLAVE_0_2_PRDATAS2 ),
        .PREADYS2   ( AMBA_SLAVE_0_2_PREADYS2 ),
        .PSLVERRS2  ( AMBA_SLAVE_0_2_PSLVERRS2 ),
        .PRDATAS3   ( AMBA_SLAVE_0_3_PRDATAS3 ),
        .PREADYS3   ( AMBA_SLAVE_0_3_PREADYS3 ),
        .PSLVERRS3  ( AMBA_SLAVE_0_3_PSLVERRS3 ),
        .PRDATAS4   ( AMBA_SLAVE_0_4_PRDATAS4 ),
        .PREADYS4   ( AMBA_SLAVE_0_4_PREADYS4 ),
        .PSLVERRS4  ( AMBA_SLAVE_0_4_PSLVERRS4 ),
        .PRDATAS5   ( AMBA_SLAVE_0_5_PRDATAS5 ),
        .PREADYS5   ( AMBA_SLAVE_0_5_PREADYS5 ),
        .PSLVERRS5  ( AMBA_SLAVE_0_5_PSLVERRS5 ),
        .PRDATAS6   ( AMBA_SLAVE_0_6_PRDATAS6 ),
        .PREADYS6   ( AMBA_SLAVE_0_6_PREADYS6 ),
        .PSLVERRS6  ( AMBA_SLAVE_0_6_PSLVERRS6 ),
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
        .PSELS0     ( AMBA_SLAVE_0_PSELx ),
        .PSELS1     ( AMBA_SLAVE_0_1_PSELx ),
        .PSELS2     ( AMBA_SLAVE_0_2_PSELx ),
        .PSELS3     ( AMBA_SLAVE_0_3_PSELx ),
        .PSELS4     ( AMBA_SLAVE_0_4_PSELx ),
        .PSELS5     ( AMBA_SLAVE_0_5_PSELx ),
        .PSELS6     ( AMBA_SLAVE_0_6_PSELx ),
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

//--------CoreResetP   -   Actel:DirectCore:CoreResetP:7.1.100
CoreResetP #( 
        .DDR_WAIT            ( 200 ),
        .DEVICE_090          ( 0 ),
        .DEVICE_VOLTAGE      ( 2 ),
        .ENABLE_SOFT_RESETS  ( 0 ),
        .EXT_RESET_CFG       ( 0 ),
        .FDDR_IN_USE         ( 0 ),
        .MDDR_IN_USE         ( 0 ),
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
        .CONFIG1_DONE                   ( VCC_net ),
        .CONFIG2_DONE                   ( VCC_net ),
        .SDIF0_PERST_N                  ( VCC_net ), // tied to 1'b1 from definition
        .SDIF1_PERST_N                  ( VCC_net ), // tied to 1'b1 from definition
        .SDIF2_PERST_N                  ( VCC_net ), // tied to 1'b1 from definition
        .SDIF3_PERST_N                  ( VCC_net ), // tied to 1'b1 from definition
        .SDIF0_PSEL                     ( GND_net ), // tied to 1'b0 from definition
        .SDIF0_PWRITE                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF0_PRDATA                   ( SDIF0_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        .SDIF1_PSEL                     ( GND_net ), // tied to 1'b0 from definition
        .SDIF1_PWRITE                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF1_PRDATA                   ( SDIF1_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        .SDIF2_PSEL                     ( GND_net ), // tied to 1'b0 from definition
        .SDIF2_PWRITE                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF2_PRDATA                   ( SDIF2_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        .SDIF3_PSEL                     ( GND_net ), // tied to 1'b0 from definition
        .SDIF3_PWRITE                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF3_PRDATA                   ( SDIF3_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        .SOFT_EXT_RESET_OUT             ( GND_net ), // tied to 1'b0 from definition
        .SOFT_RESET_F2M                 ( GND_net ), // tied to 1'b0 from definition
        .SOFT_M3_RESET                  ( GND_net ), // tied to 1'b0 from definition
        .SOFT_MDDR_DDR_AXI_S_CORE_RESET ( GND_net ), // tied to 1'b0 from definition
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
        .DDR_READY                      (  ),
        .SDIF_READY                     (  ),
        .RESET_N_F2M                    ( CORERESETP_0_RESET_N_F2M ),
        .M3_RESET_N                     (  ),
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
        .MCCC_CLK_BASE_PLL_LOCK ( FIC_0_LOCK_net_0 ),
        .MSS_RESET_N_F2M        ( CORERESETP_0_RESET_N_F2M ),
        .GPIO_0_F2M             ( GPIO_0_F2M ),
        .GPIO_2_F2M             ( GPIO_2_F2M ),
        .GPIO_7_F2M             ( GPIO_7_F2M ),
        .FIC_0_APB_M_PREADY     ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PREADY ),
        .FIC_0_APB_M_PSLVERR    ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PSLVERR ),
        .FIC_2_APB_M_PREADY     ( VCC_net ), // tied to 1'b1 from definition
        .FIC_2_APB_M_PSLVERR    ( GND_net ), // tied to 1'b0 from definition
        .FIC_0_APB_M_PRDATA     ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PRDATA ),
        .FIC_2_APB_M_PRDATA     ( FIC_2_APB_M_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        // Outputs
        .MSS_RESET_N_M2F        ( EvalSandbox_MSS_MSS_TMP_0_MSS_RESET_N_M2F ),
        .GPIO_1_M2F             ( GPIO_1_M2F_net_0 ),
        .GPIO_3_M2F             ( GPIO_3_M2F_net_0 ),
        .GPIO_4_M2F             ( GPIO_4_M2F_net_0 ),
        .GPIO_5_M2F             ( GPIO_5_M2F_net_0 ),
        .GPIO_6_M2F             ( GPIO_6_M2F_net_0 ),
        .FIC_0_APB_M_PSEL       ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PSELx ),
        .FIC_0_APB_M_PWRITE     ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PWRITE ),
        .FIC_0_APB_M_PENABLE    ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PENABLE ),
        .FIC_2_APB_M_PRESET_N   ( EvalSandbox_MSS_MSS_TMP_0_FIC_2_APB_M_PRESET_N ),
        .FIC_2_APB_M_PCLK       (  ),
        .FIC_2_APB_M_PWRITE     (  ),
        .FIC_2_APB_M_PENABLE    (  ),
        .FIC_2_APB_M_PSEL       (  ),
        .FIC_0_APB_M_PADDR      ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PADDR ),
        .FIC_0_APB_M_PWDATA     ( EvalSandbox_MSS_MSS_TMP_0_FIC_0_APB_MASTER_PWDATA ),
        .FIC_2_APB_M_PADDR      (  ),
        .FIC_2_APB_M_PWDATA     (  ) 
        );

//--------EvalSandbox_MSS_FABOSC_0_OSC   -   Actel:SgCore:OSC:2.0.101
EvalSandbox_MSS_FABOSC_0_OSC FABOSC_0(
        // Inputs
        .XTL                ( GND_net ), // tied to 1'b0 from definition
        // Outputs
        .RCOSC_25_50MHZ_CCC (  ),
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

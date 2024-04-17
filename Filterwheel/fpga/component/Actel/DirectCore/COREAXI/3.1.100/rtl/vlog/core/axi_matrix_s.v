/****************************************************************************/
// Actel Corporation Proprietary and Confidential
// Copyright 2010 Actel Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description: matrix_s.v
//              
//              Contains:
//                       - Wr Address Channel
//                       - Rd Address Channel
//                       - Wd Address Channel
//
// Revision Information:
// Date            Description
// ----            -----------------------------------------
// 02Feb11         Inital. Ports and Parameters declaration
//
// SVN Revision Information:
// SVN $Revision: 11146 $
// SVN $Date: 2009-11-21 11:44:53 -0800 (Sat, 21 Nov 2009) $
//
// Resolved SARs
// SAR      Date     Who   Description
//
// Notes:
// 1. 
//
// ****************************************************************************/
`timescale 1ns/1ps

module axi_matrix_s (
                 // Global signals
                 ACLK,
                 ARESETN,

                 ARADDR_M0,
                 ARLOCK_M0,
                 ARVALID_M0,
                 ARADDR_M1,
                 ARLOCK_M1,
                 ARVALID_M1,
                 ARADDR_M2,
                 ARLOCK_M2,
                 ARVALID_M2,
                 ARADDR_M3,
                 ARLOCK_M3,
                 ARVALID_M3,

                 AWADDR_M0,
                 AWVALID_M0,
                 AWLOCK_M0,
                 AWADDR_M1,
                 AWVALID_M1,
                 AWLOCK_M1,
                 AWADDR_M2,
                 AWVALID_M2,
                 AWLOCK_M2,
                 AWADDR_M3,
                 AWVALID_M3,
                 AWLOCK_M3,

                 SLAVE_NUMBER,
                 // From Master Stage
                 m0_rd_end,
                     m1_rd_end,
                 m2_rd_end,
                 m3_rd_end,
                 
                 m0_wr_end,
                 m1_wr_end,
                 m2_wr_end,
                 m3_wr_end,
                              
                 // MASTER 0
                 // AXI MASTER write address channel signals
                 AWID_MI0,
                 AWADDR_MI0,
                 AWLEN_MI0,
                 AWSIZE_MI0,
                 AWBURST_MI0,
                 AWLOCK_MI0,
                 AWCACHE_MI0,
                 AWPROT_MI0,
                 AWVALID_MI0,
                 AWREADY_IM0,
                 // AXI MASTER write data channel signals
                 WID_MI0,
                 WDATA_MI0,
                 WSTRB_MI0,
                 WLAST_MI0,
                 WVALID_MI0,
                 WREADY_IM0,
                 
                 // AXI MASTER read address channel signals
                 ARID_MI0,
                 ARADDR_MI0,
                 ARLEN_MI0,
                 ARSIZE_MI0,
                 ARBURST_MI0,
                 ARLOCK_MI0,
                 ARCACHE_MI0,
                 ARPROT_MI0,
                 ARVALID_MI0,
                 ARREADY_IM0,
                 
                 // MASTER 1
                 // AXI MASTER write address channel signals
                 AWID_MI1,
                 AWADDR_MI1,
                 AWLEN_MI1,
                 AWSIZE_MI1,
                 AWBURST_MI1,
                 AWLOCK_MI1,
                 AWCACHE_MI1,
                 AWPROT_MI1,
                 AWVALID_MI1,
                 AWREADY_IM1,
                 // AXI MASTER write data channel signals
                 WID_MI1,
                 WDATA_MI1,
                 WSTRB_MI1,
                 WLAST_MI1,
                 WVALID_MI1,
                 WREADY_IM1,
                 // AXI MASTER read address channel signals
                 ARID_MI1,
                     ARADDR_MI1,
                 ARLEN_MI1,
                 ARSIZE_MI1,
                 ARBURST_MI1,
                 ARLOCK_MI1,
                 ARCACHE_MI1,
                 ARPROT_MI1,
                 ARVALID_MI1,
                 ARREADY_IM1,
                 
                 // MASTER 2
                 // AXI MASTER write address channel signals
                 AWID_MI2,
                 AWADDR_MI2,
                 AWLEN_MI2,
                 AWSIZE_MI2,
                 AWBURST_MI2,
                 AWLOCK_MI2,
                 AWCACHE_MI2,
                 AWPROT_MI2,
                 AWVALID_MI2,
                 AWREADY_IM2,
                 // AXI MASTER write data channel signals
                 WID_MI2,
                 WDATA_MI2,
                 WSTRB_MI2,
                 WLAST_MI2,
                 WVALID_MI2,
                 WREADY_IM2,
                 // AXI MASTER read address channel signals
                 ARID_MI2,
                 ARADDR_MI2,
                 ARLEN_MI2,
                 ARSIZE_MI2,
                 ARBURST_MI2,
                 ARLOCK_MI2,
                 ARCACHE_MI2,
                 ARPROT_MI2,
                 ARVALID_MI2,
                 ARREADY_IM2,
             
                 // MASTER 3
                 // AXI MASTER write address channel signals
                 AWID_MI3,
                 AWADDR_MI3,
                 AWLEN_MI3,
                 AWSIZE_MI3,
                 AWBURST_MI3,
                 AWLOCK_MI3,
                 AWCACHE_MI3,
                 AWPROT_MI3,
                 AWVALID_MI3,
                 AWREADY_IM3,
                 // AXI MASTER write data channel signals
                 WID_MI3,
                 WDATA_MI3,
                 WSTRB_MI3,
                 WLAST_MI3,
                 WVALID_MI3,
                 WREADY_IM3,
                 // AXI MASTER read address channel signals
                 ARID_MI3,
                     ARADDR_MI3,
                 ARLEN_MI3,
                 ARSIZE_MI3,
                 ARBURST_MI3,
                 ARLOCK_MI3,
                 ARCACHE_MI3,
                 ARPROT_MI3,
                 ARVALID_MI3,
                 ARREADY_IM3,
             
                 // SLAVE 0
                 // AXI SLAVE 0 write address channel signals
                 AWID_IS,
                 AWADDR_IS,
                 AWADDR_IS_int,
                 ARADDR_IS_int,
                 AWLEN_IS,
                 AWSIZE_IS,
                 AWBURST_IS,
                 AWLOCK_IS,
                 AWCACHE_IS,
                 AWPROT_IS,
                 AWVALID_IS,
                 AWREADY_SI,
                 // AXI SLAVE 0 write data channel signals
                 WID_IS,
                 WDATA_IS,
                 WSTRB_IS,
                 WLAST_IS,
                 WVALID_IS,
                 WREADY_SI,
                 // AXI SLAVE 0 read address channel signals
                 ARID_IS,
                 ARADDR_IS,
                 ARLEN_IS,
                 ARSIZE_IS,
                 ARBURST_IS,
                 ARLOCK_IS,
                 ARCACHE_IS,
                 ARPROT_IS,
                 ARVALID_IS,
                 ARREADY_SI,

                 RVALID_SI,
                 RLAST_SI,
                 RREADY_IS,

                 gated_waddr,                 
                 gated_raddr

                 );

   // --------------------------------------------------------------------------
   // PARAMETER Declaration
   // --------------------------------------------------------------------------
   parameter AXI_AWIDTH           = 32;
   parameter AXI_DWIDTH           = 64;   // 64/128/256

   parameter M0_SLAVE0ENABLE      = 1;
   parameter M0_SLAVE1ENABLE      = 0;
   parameter M0_SLAVE2ENABLE      = 0;
   parameter M0_SLAVE3ENABLE      = 0;
   parameter M0_SLAVE4ENABLE      = 0;
   parameter M0_SLAVE5ENABLE      = 0;
   parameter M0_SLAVE6ENABLE      = 0;
   parameter M0_SLAVE7ENABLE      = 0;
   parameter M0_SLAVE8ENABLE      = 0;
   parameter M0_SLAVE9ENABLE      = 0;
   parameter M0_SLAVE10ENABLE     = 0;
   parameter M0_SLAVE11ENABLE     = 0;
   parameter M0_SLAVE12ENABLE     = 0;
   parameter M0_SLAVE13ENABLE     = 0;
   parameter M0_SLAVE14ENABLE     = 0;
   parameter M0_SLAVE15ENABLE     = 0;
   parameter M0_SLAVE16ENABLE    = 0;
   
   parameter M1_SLAVE0ENABLE      = 1;
   parameter M1_SLAVE1ENABLE      = 0;
   parameter M1_SLAVE2ENABLE      = 0;
   parameter M1_SLAVE3ENABLE      = 0;
   parameter M1_SLAVE4ENABLE      = 0;
   parameter M1_SLAVE5ENABLE      = 0;
   parameter M1_SLAVE6ENABLE      = 0;
   parameter M1_SLAVE7ENABLE      = 0;
   parameter M1_SLAVE8ENABLE      = 0;
   parameter M1_SLAVE9ENABLE      = 0;
   parameter M1_SLAVE10ENABLE     = 0;
   parameter M1_SLAVE11ENABLE     = 0;
   parameter M1_SLAVE12ENABLE     = 0;
   parameter M1_SLAVE13ENABLE     = 0;
   parameter M1_SLAVE14ENABLE     = 0;
   parameter M1_SLAVE15ENABLE     = 0;
   parameter M1_SLAVE16ENABLE     = 0;
   parameter M2_SLAVE0ENABLE      = 1;
   parameter M2_SLAVE1ENABLE      = 0;
   parameter M2_SLAVE2ENABLE      = 0;
   parameter M2_SLAVE3ENABLE      = 0;
   parameter M2_SLAVE4ENABLE      = 0;
   parameter M2_SLAVE5ENABLE      = 0;
   parameter M2_SLAVE6ENABLE      = 0;
   parameter M2_SLAVE7ENABLE      = 0;
   parameter M2_SLAVE8ENABLE      = 0;
   parameter M2_SLAVE9ENABLE      = 0;
   parameter M2_SLAVE10ENABLE     = 0;
   parameter M2_SLAVE11ENABLE     = 0;
   parameter M2_SLAVE12ENABLE     = 0;
   parameter M2_SLAVE13ENABLE     = 0;
   parameter M2_SLAVE14ENABLE     = 0;
   parameter M2_SLAVE15ENABLE     = 0;
   parameter M2_SLAVE16ENABLE     = 0;

   parameter M3_SLAVE0ENABLE      = 1;
   parameter M3_SLAVE1ENABLE      = 0;
   parameter M3_SLAVE2ENABLE      = 0;
   parameter M3_SLAVE3ENABLE      = 0;
   parameter M3_SLAVE4ENABLE      = 0;
   parameter M3_SLAVE5ENABLE      = 0;
   parameter M3_SLAVE6ENABLE      = 0;
   parameter M3_SLAVE7ENABLE      = 0;
   parameter M3_SLAVE8ENABLE      = 0;
   parameter M3_SLAVE9ENABLE      = 0;
   parameter M3_SLAVE10ENABLE     = 0;
   parameter M3_SLAVE11ENABLE     = 0;
   parameter M3_SLAVE12ENABLE     = 0;
   parameter M3_SLAVE13ENABLE     = 0;
   parameter M3_SLAVE14ENABLE     = 0;
   parameter M3_SLAVE15ENABLE     = 0;    
   parameter M3_SLAVE16ENABLE     = 0;

   parameter ID_WIDTH             = 4;

   parameter NUM_SLAVE_SLOT       = 1;  
   parameter NUM_MASTER_SLOT      = 1;  
   parameter MEMSPACE             = 1;  
   parameter HGS_CFG              = 1;  
   parameter ADDR_HGS_CFG         = 1;  

   parameter SC_0                 = 0;
   parameter SC_1                 = 0;
   parameter SC_2                 = 0;
   parameter SC_3                 = 0;
   parameter SC_4                 = 0;
   parameter SC_5                 = 0;
   parameter SC_6                 = 0;
   parameter SC_7                 = 0;
   parameter SC_8                 = 0;
   parameter SC_9                 = 0;
   parameter SC_10                = 0;
   parameter SC_11                = 0;
   parameter SC_12                = 0;
   parameter SC_13                = 0;
   parameter SC_14                = 0;
   parameter SC_15                = 0;

   parameter FEED_THROUGH         = 0;  
   parameter INP_REG_BUF          = 1;  
   parameter OUT_REG_BUF          = 1;  

   parameter WR_ACCEPTANCE        = 4;  
   parameter RD_ACCEPTANCE        = 4;  

   localparam AXI_STRBWIDTH       = AXI_DWIDTH/8;
   parameter BASE_ID_WIDTH        = 2;
   parameter SYNC_RESET           = 0;

   localparam SLAVE_0  =        17'b00000000000000001;
   localparam SLAVE_1  =        17'b00000000000000010;
   localparam SLAVE_2  =        17'b00000000000000100;
   localparam SLAVE_3  =        17'b00000000000001000;
   localparam SLAVE_4  =        17'b00000000000010000;
   localparam SLAVE_5  =        17'b00000000000100000;
   localparam SLAVE_6  =        17'b00000000001000000;
   localparam SLAVE_7  =        17'b00000000010000000;
   localparam SLAVE_8  =        17'b00000000100000000;
   localparam SLAVE_9  =        17'b00000001000000000;
   localparam SLAVE_A  =        17'b00000010000000000;
   localparam SLAVE_B  =        17'b00000100000000000;
   localparam SLAVE_C  =        17'b00001000000000000;
   localparam SLAVE_D  =        17'b00010000000000000;
   localparam SLAVE_E  =        17'b00100000000000000;
   localparam SLAVE_F  =        17'b01000000000000000;
   localparam SLAVE_N  =        17'b10000000000000000;

   // --------------------------------------------------------------------------
   // I/O Declaration
   // --------------------------------------------------------------------------
   // Global signals
   input       ACLK;
   input       ARESETN;

   input [31:0]        ARADDR_M0;
   input [1:0]                   ARLOCK_M0;
   input                         ARVALID_M0;
   input [31:0]        ARADDR_M1;
   input [1:0]                   ARLOCK_M1;
   input                         ARVALID_M1;
   input [31:0]        ARADDR_M2;
   input [1:0]                   ARLOCK_M2;
   input                         ARVALID_M2;
   input [31:0]        ARADDR_M3;
   input [1:0]                   ARLOCK_M3;
   input                         ARVALID_M3;

   input  [31:0]      AWADDR_M0;
   input  [1:0]                 AWLOCK_M0;
   input                        AWVALID_M0;
   input  [31:0]      AWADDR_M1;
   input  [1:0]                 AWLOCK_M1;
   input                        AWVALID_M1;
   input  [31:0]      AWADDR_M2;
   input  [1:0]                 AWLOCK_M2;
   input                        AWVALID_M2;
   input  [31:0]      AWADDR_M3;
   input  [1:0]                 AWLOCK_M3;
   input                        AWVALID_M3;

   input [4:0]  SLAVE_NUMBER;
//   input [4:0]  SLAVE_GATED;   
   // From Master 0
   // AXI write address channel signals
   input [BASE_ID_WIDTH+ID_WIDTH - 1:0] AWID_MI0;
   input [31:0]        AWADDR_MI0;
   input [3:0]                   AWLEN_MI0;
   input [2:0]                   AWSIZE_MI0;
   input [1:0]                   AWBURST_MI0;
   input [1:0]                   AWLOCK_MI0;
   input [3:0]                   AWCACHE_MI0;
   input [2:0]                   AWPROT_MI0;
   input                         AWVALID_MI0;
   output                        AWREADY_IM0;
   // AXI write data channel signals
   input [BASE_ID_WIDTH+ID_WIDTH - 1:0] WID_MI0;
   input [AXI_DWIDTH-1:0]        WDATA_MI0;
   input [AXI_STRBWIDTH-1:0]     WSTRB_MI0;
   input                         WLAST_MI0;
   input                         WVALID_MI0;
   output                        WREADY_IM0;
   // AXI read address channel signals
   input [BASE_ID_WIDTH+ID_WIDTH - 1:0] ARID_MI0;
   input [31:0]       ARADDR_MI0;
   input [3:0]                  ARLEN_MI0;
   input [2:0]                  ARSIZE_MI0;
   input [1:0]                  ARBURST_MI0;
   input [1:0]                  ARLOCK_MI0;
   input [3:0]                  ARCACHE_MI0;
   input [2:0]                  ARPROT_MI0;
   input                        ARVALID_MI0;
   output                       ARREADY_IM0;

   // From Master 1
   // AXI write address channel signals
   input [BASE_ID_WIDTH+ID_WIDTH - 1:0] AWID_MI1;
   input [31:0]        AWADDR_MI1;
   input [3:0]                   AWLEN_MI1;
   input [2:0]                   AWSIZE_MI1;
   input [1:0]                   AWBURST_MI1;
   input [1:0]                   AWLOCK_MI1;
   input [3:0]                   AWCACHE_MI1;
   input [2:0]                   AWPROT_MI1;
   input                         AWVALID_MI1;
   output                        AWREADY_IM1;
   // AXI write data channel signals
   input [BASE_ID_WIDTH+ID_WIDTH - 1:0] WID_MI1;
   input [AXI_DWIDTH-1:0]        WDATA_MI1;
   input [AXI_STRBWIDTH-1:0]     WSTRB_MI1;
   input                         WLAST_MI1;
   input                         WVALID_MI1;
   output                        WREADY_IM1;
   // AXI read address channel signals
   input [BASE_ID_WIDTH+ID_WIDTH - 1:0] ARID_MI1;
   input [31:0]       ARADDR_MI1;
   input [3:0]                  ARLEN_MI1;
   input [2:0]                  ARSIZE_MI1;
   input [1:0]                  ARBURST_MI1;
   input [1:0]                  ARLOCK_MI1;
   input [3:0]                  ARCACHE_MI1;
   input [2:0]                  ARPROT_MI1;
   input                        ARVALID_MI1;
   output                       ARREADY_IM1;

   // From Master 2
   // AXI write address channel signals
   input [BASE_ID_WIDTH+ID_WIDTH - 1:0] AWID_MI2;
   input [31:0]        AWADDR_MI2;
   input [3:0]                   AWLEN_MI2;
   input [2:0]                   AWSIZE_MI2;
   input [1:0]                   AWBURST_MI2;
   input [1:0]                   AWLOCK_MI2;
   input [3:0]                   AWCACHE_MI2;
   input [2:0]                   AWPROT_MI2;
   input                         AWVALID_MI2;
   output                        AWREADY_IM2;
   // AXI write data channel signals
   input [BASE_ID_WIDTH+ID_WIDTH - 1:0] WID_MI2;
   input [AXI_DWIDTH-1:0]        WDATA_MI2;
   input [AXI_STRBWIDTH-1:0]     WSTRB_MI2;
   input                         WLAST_MI2;
   input                         WVALID_MI2;
   output                        WREADY_IM2;
   // AXI read address channel signals
   input [BASE_ID_WIDTH+ID_WIDTH - 1:0] ARID_MI2;
   input [31:0]       ARADDR_MI2;
   input [3:0]                  ARLEN_MI2;
   input [2:0]                  ARSIZE_MI2;
   input [1:0]                  ARBURST_MI2;
   input [1:0]                  ARLOCK_MI2;
   input [3:0]                  ARCACHE_MI2;
   input [2:0]                  ARPROT_MI2;
   input                        ARVALID_MI2;
   output                       ARREADY_IM2;

   // From Master 3
   // AXI write address channel signals
   input [BASE_ID_WIDTH+ID_WIDTH - 1:0] AWID_MI3;
   input [31:0]        AWADDR_MI3;
   input [3:0]                   AWLEN_MI3;
   input [2:0]                   AWSIZE_MI3;
   input [1:0]                   AWBURST_MI3;
   input [1:0]                   AWLOCK_MI3;
   input [3:0]                   AWCACHE_MI3;
   input [2:0]                   AWPROT_MI3;
   input                         AWVALID_MI3;
   output                        AWREADY_IM3;
   // AXI write data channel signals
   input [BASE_ID_WIDTH+ID_WIDTH - 1:0] WID_MI3;
   input [AXI_DWIDTH-1:0]        WDATA_MI3;
   input [AXI_STRBWIDTH-1:0]     WSTRB_MI3;
   input                         WLAST_MI3;
   input                         WVALID_MI3;
   output                        WREADY_IM3;
   // AXI read address channel signals
   input [BASE_ID_WIDTH+ID_WIDTH - 1:0] ARID_MI3;
   input [31:0]       ARADDR_MI3;
   input [3:0]                  ARLEN_MI3;
   input [2:0]                  ARSIZE_MI3;
   input [1:0]                  ARBURST_MI3;
   input [1:0]                  ARLOCK_MI3;
   input [3:0]                  ARCACHE_MI3;
   input [2:0]                  ARPROT_MI3;
   input                        ARVALID_MI3;
   output                       ARREADY_IM3;

    // SLAVE 0
    // AXI SLAVE 0 write address channel signals
   output [BASE_ID_WIDTH+ID_WIDTH - 1:0] AWID_IS;
    output [31:0]      AWADDR_IS;
   output [31:0]       AWADDR_IS_int;
   output [31:0]       ARADDR_IS_int;
    output [3:0]                 AWLEN_IS;
    output [2:0]                 AWSIZE_IS;
    output [1:0]                 AWBURST_IS;
    output [1:0]                 AWLOCK_IS;
    output [3:0]                 AWCACHE_IS;
    output [2:0]                 AWPROT_IS;
    output                       AWVALID_IS;
    input                        AWREADY_SI;
    // AXI SLAVE 0 write data channel signals
   output [BASE_ID_WIDTH+ID_WIDTH - 1:0] WID_IS;
    output [AXI_DWIDTH-1:0]      WDATA_IS;
    output [AXI_STRBWIDTH-1:0]   WSTRB_IS;
    output                       WLAST_IS;
    output                       WVALID_IS;
    input                        WREADY_SI;
    // AXI SLAVE 0 read address channel signals
   output [BASE_ID_WIDTH+ID_WIDTH - 1:0] ARID_IS;
    output [31:0]      ARADDR_IS;
    output [3:0]                 ARLEN_IS;
    output [2:0]                 ARSIZE_IS;
    output [1:0]                 ARBURST_IS;
    output [1:0]                 ARLOCK_IS;
    output [3:0]                 ARCACHE_IS;
    output [2:0]                 ARPROT_IS;
    output                       ARVALID_IS;
    input                        ARREADY_SI;
    input                        RVALID_SI;
    input                        RLAST_SI;
    input                        RREADY_IS;

    // For Arbiter from Masters
    // To end grant to current master
    input                   m0_rd_end;
    input                   m1_rd_end;
    input                   m2_rd_end;
    input                   m3_rd_end;
    input                   m0_wr_end;
    input                   m1_wr_end;
    input                   m2_wr_end;
    input                   m3_wr_end;
    // To send requests to receive grant from masters 
   output [16:0]            gated_waddr;
   output [16:0]            gated_raddr;
   

   // --------------------------------------------------------------------------
   // Internal signals
   // --------------------------------------------------------------------------
   wire [16:0]                    SLAVE_SELECT_WADDRCH_M;
   wire [16:0]                    gated_waddr;
   wire [16:0]                    gated_raddr;
   wire [16:0]                    gated_waddr1;
   wire [16:0]                    gated_raddr1;
   
   wire [16:0]                    SLAVE_SELECT_RADDRCH_M;
   wire [16:0]                    SLAVE_SELECT_WDCH_M;
   wire [16:0]                    SLAVE_SELECT_WRESPCH_M;
   wire [16:0]                    SLAVE_SELECT_RDCH_M;
   reg                            AWREADY_IM;
   reg                            ARREADY_IM;
   reg                            WREADY_IM;
   reg                            WREADY_IM_int;
   reg [BASE_ID_WIDTH+ID_WIDTH - 1:0] BID_IM_int;
   reg                                BVALID_IM_int;
   reg [1:0]                          BRESP_IM_int;
                                      
   reg [1:0]                          BRESP_IM;
   reg                                BVALID_IM;
   reg [BASE_ID_WIDTH+ID_WIDTH - 1:0] BID_IM;

   wire                                BREADY_IS;
   
   wire                                RREADY_IS;
   
   wire [BASE_ID_WIDTH+ID_WIDTH - 1:0] AWID_IS;
   wire [31:0]               AWADDR_IS;
   wire [31:0]               AWADDR_IS_int;
   wire [31:0]               ARADDR_IS_int;

   wire [31:0]               AWADDR_IS_int1;
   wire [31:0]               ARADDR_IS_int1;

   wire [3:0]                          AWLEN_IS;
   wire [2:0]                          AWSIZE_IS;
   wire [1:0]                          AWBURST_IS;
   wire [1:0]                          AWLOCK_IS;
   wire [3:0]                          AWCACHE_IS;
   wire [2:0]                          AWPROT_IS;
   wire                                AWVALID_IS;


   wire [BASE_ID_WIDTH+ID_WIDTH - 1:0] ARID_IS;
   wire [31:0]               ARADDR_IS;
   wire [3:0]                          ARLEN_IS;
   wire [2:0]                          ARSIZE_IS;
   wire [1:0]                          ARBURST_IS;
   wire [1:0]                          ARLOCK_IS;
   wire [3:0]                          ARCACHE_IS;
   wire [2:0]                          ARPROT_IS;
   wire                                ARVALID_IS;

   wire [3:0]                          AR_MASGNT_IC; 
   wire [3:0]                          MST_WRGNT_NUM; 
   wire [3:0]                          MST_RDGNT_NUM; 
   wire [3:0]                          rd_rdcntr;
   wire [3:0]                          rd_wdcntr;     

   wire [1:0]                          AWLOCK_MI0;
   wire [1:0]                          AWLOCK_MI1;
   wire [1:0]                          AWLOCK_MI2;
   wire [1:0]                          AWLOCK_MI3;
   wire [1:0]                          ARLOCK_MI0;
   wire [1:0]                          ARLOCK_MI1;
   wire [1:0]                          ARLOCK_MI2;
   wire [1:0]                          ARLOCK_MI3;
   wire                                aresetn;
   wire                                sresetn;

   /////////////////////////////////////////////////////////////////////////////
   //                               Start - of - Code                         //
   /////////////////////////////////////////////////////////////////////////////

   // --------------------------------------------------------------------------
   // resets
   // --------------------------------------------------------------------------
   assign aresetn   = (SYNC_RESET == 1) ? 1'b1  : ARESETN;
   assign sresetn   = (SYNC_RESET == 1) ? ARESETN : 1'b1;

   // --------------------------------------------------------------------------
   // Write address channel instance
   // --------------------------------------------------------------------------
   axi_wa_channel #(
               .SYNC_RESET(SYNC_RESET),
               .AXI_AWIDTH(AXI_AWIDTH),
               .AXI_DWIDTH(AXI_DWIDTH),
               .NUM_SLAVE_SLOT(NUM_SLAVE_SLOT),
               .NUM_MASTER_SLOT(NUM_MASTER_SLOT),
           	   .FEED_THROUGH(FEED_THROUGH),
		       .INP_REG_BUF(INP_REG_BUF),
		       .OUT_REG_BUF(OUT_REG_BUF),
		       .MEMSPACE(MEMSPACE),
		       .HGS_CFG(HGS_CFG),
		       .ADDR_HGS_CFG(ADDR_HGS_CFG),
               .ID_WIDTH(ID_WIDTH),
               .BASE_ID_WIDTH(BASE_ID_WIDTH),
               .WR_ACCEPTANCE(WR_ACCEPTANCE),
               .RD_ACCEPTANCE(RD_ACCEPTANCE),
               .SC_0(SC_0),
               .SC_1(SC_1),
               .SC_2(SC_2),
               .SC_3(SC_3),
               .SC_4(SC_4),
               .SC_5(SC_5),
               .SC_6(SC_6),
               .SC_7(SC_7),
               .SC_8(SC_8),
               .SC_9(SC_9),
               .SC_10(SC_10),
               .SC_11(SC_11),
               .SC_12(SC_12),
               .SC_13(SC_13),
               .SC_14(SC_14),
               .SC_15(SC_15),

               .M0_SLAVE0ENABLE(M0_SLAVE0ENABLE),
               .M0_SLAVE1ENABLE(M0_SLAVE1ENABLE),
               .M0_SLAVE2ENABLE(M0_SLAVE2ENABLE),
               .M0_SLAVE3ENABLE(M0_SLAVE3ENABLE),
               .M0_SLAVE4ENABLE(M0_SLAVE4ENABLE),
               .M0_SLAVE5ENABLE(M0_SLAVE5ENABLE),
               .M0_SLAVE6ENABLE(M0_SLAVE6ENABLE),
               .M0_SLAVE7ENABLE(M0_SLAVE7ENABLE),
               .M0_SLAVE8ENABLE(M0_SLAVE8ENABLE),
               .M0_SLAVE9ENABLE(M0_SLAVE9ENABLE),
               .M0_SLAVE10ENABLE(M0_SLAVE10ENABLE),
               .M0_SLAVE11ENABLE(M0_SLAVE11ENABLE),
               .M0_SLAVE12ENABLE(M0_SLAVE12ENABLE),
               .M0_SLAVE13ENABLE(M0_SLAVE13ENABLE),
               .M0_SLAVE14ENABLE(M0_SLAVE14ENABLE),
               .M0_SLAVE15ENABLE(M0_SLAVE15ENABLE),
               .M0_SLAVE16ENABLE(M0_SLAVE16ENABLE),

               .M1_SLAVE0ENABLE(M1_SLAVE0ENABLE),
               .M1_SLAVE1ENABLE(M1_SLAVE1ENABLE),
               .M1_SLAVE2ENABLE(M1_SLAVE2ENABLE),
               .M1_SLAVE3ENABLE(M1_SLAVE3ENABLE),
               .M1_SLAVE4ENABLE(M1_SLAVE4ENABLE),
               .M1_SLAVE5ENABLE(M1_SLAVE5ENABLE),
               .M1_SLAVE6ENABLE(M1_SLAVE6ENABLE),
               .M1_SLAVE7ENABLE(M1_SLAVE7ENABLE),
               .M1_SLAVE8ENABLE(M1_SLAVE8ENABLE),
               .M1_SLAVE9ENABLE(M1_SLAVE9ENABLE),
               .M1_SLAVE10ENABLE(M1_SLAVE10ENABLE),
               .M1_SLAVE11ENABLE(M1_SLAVE11ENABLE),
               .M1_SLAVE12ENABLE(M1_SLAVE12ENABLE),
               .M1_SLAVE13ENABLE(M1_SLAVE13ENABLE),
               .M1_SLAVE14ENABLE(M1_SLAVE14ENABLE),
               .M1_SLAVE15ENABLE(M1_SLAVE15ENABLE),
               .M1_SLAVE16ENABLE(M1_SLAVE16ENABLE),

               .M2_SLAVE0ENABLE(M2_SLAVE0ENABLE),
               .M2_SLAVE1ENABLE(M2_SLAVE1ENABLE),
               .M2_SLAVE2ENABLE(M2_SLAVE2ENABLE),
               .M2_SLAVE3ENABLE(M2_SLAVE3ENABLE),
               .M2_SLAVE4ENABLE(M2_SLAVE4ENABLE),
               .M2_SLAVE5ENABLE(M2_SLAVE5ENABLE),
               .M2_SLAVE6ENABLE(M2_SLAVE6ENABLE),
               .M2_SLAVE7ENABLE(M2_SLAVE7ENABLE),
               .M2_SLAVE8ENABLE(M2_SLAVE8ENABLE),
               .M2_SLAVE9ENABLE(M2_SLAVE9ENABLE),
               .M2_SLAVE10ENABLE(M2_SLAVE10ENABLE),
               .M2_SLAVE11ENABLE(M2_SLAVE11ENABLE),
               .M2_SLAVE12ENABLE(M2_SLAVE12ENABLE),
               .M2_SLAVE13ENABLE(M2_SLAVE13ENABLE),
               .M2_SLAVE14ENABLE(M2_SLAVE14ENABLE),
               .M2_SLAVE15ENABLE(M2_SLAVE15ENABLE),
               .M2_SLAVE16ENABLE(M2_SLAVE16ENABLE),

               .M3_SLAVE0ENABLE(M3_SLAVE0ENABLE),
               .M3_SLAVE1ENABLE(M3_SLAVE1ENABLE),
               .M3_SLAVE2ENABLE(M3_SLAVE2ENABLE),
               .M3_SLAVE3ENABLE(M3_SLAVE3ENABLE),
               .M3_SLAVE4ENABLE(M3_SLAVE4ENABLE),
               .M3_SLAVE5ENABLE(M3_SLAVE5ENABLE),
               .M3_SLAVE6ENABLE(M3_SLAVE6ENABLE),
               .M3_SLAVE7ENABLE(M3_SLAVE7ENABLE),
               .M3_SLAVE8ENABLE(M3_SLAVE8ENABLE),
               .M3_SLAVE9ENABLE(M3_SLAVE9ENABLE),
               .M3_SLAVE10ENABLE(M3_SLAVE10ENABLE),
               .M3_SLAVE11ENABLE(M3_SLAVE11ENABLE),
               .M3_SLAVE12ENABLE(M3_SLAVE12ENABLE),
               .M3_SLAVE13ENABLE(M3_SLAVE13ENABLE),
               .M3_SLAVE14ENABLE(M3_SLAVE14ENABLE),
               .M3_SLAVE15ENABLE(M3_SLAVE15ENABLE),
               .M3_SLAVE16ENABLE(M3_SLAVE16ENABLE)
                )
     inst_wa_channel(
                     // Global signals
                     .ACLK(ACLK),
                     .ARESETN(ARESETN),

                     .m0_wr_end(m0_wr_end),
                     .m1_wr_end(m1_wr_end),
                     .m2_wr_end(m2_wr_end),
                     .m3_wr_end(m3_wr_end),
                     
                     .AWADDR_M0(AWADDR_M0),
                     .AWVALID_M0(AWVALID_M0),
                     .AWLOCK_M0(AWLOCK_M0),
                     .AWADDR_M1(AWADDR_M1),
                     .AWVALID_M1(AWVALID_M1),
                     .AWLOCK_M1(AWLOCK_M1),
                     .AWADDR_M2(AWADDR_M2),
                     .AWVALID_M2(AWVALID_M2),
                     .AWLOCK_M2(AWLOCK_M2),
                     .AWADDR_M3(AWADDR_M3),
                     .AWVALID_M3(AWVALID_M3),
                     .AWLOCK_M3(AWLOCK_M3),

                     // From Write Arbiter
                     .BVALID_SI(BVALID_SI),
                     .BREADY_IS(BREADY_IS),

                     // MASTER 0
                     // AXI MASTER write address channel signals
                     .AWID_MI0(AWID_MI0),
                     .AWADDR_MI0(AWADDR_MI0),
                     .AWLEN_MI0(AWLEN_MI0),
                     .AWSIZE_MI0(AWSIZE_MI0),
                     .AWBURST_MI0(AWBURST_MI0),
                     .AWLOCK_MI0(AWLOCK_MI0),
                     .AWCACHE_MI0(AWCACHE_MI0),
                     .AWPROT_MI0(AWPROT_MI0),
                     .AWVALID_MI0(AWVALID_MI0),
                     .AWREADY_IM0(AWREADY_IM0),

                     // MASTER 1
                     // AXI MASTER write address channel signals
                     .AWID_MI1(AWID_MI1),
                     .AWADDR_MI1(AWADDR_MI1),
                     .AWLEN_MI1(AWLEN_MI1),
                     .AWSIZE_MI1(AWSIZE_MI1),
                     .AWBURST_MI1(AWBURST_MI1),
                     .AWLOCK_MI1(AWLOCK_MI1),
                     .AWCACHE_MI1(AWCACHE_MI1),
                     .AWPROT_MI1(AWPROT_MI1),
                     .AWVALID_MI1(AWVALID_MI1),
                     .AWREADY_IM1(AWREADY_IM1),

                     // MASTER 2
                     // AXI MASTER write address channel signals
                     .AWID_MI2(AWID_MI2),
                     .AWADDR_MI2(AWADDR_MI2),
                     .AWLEN_MI2(AWLEN_MI2),
                     .AWSIZE_MI2(AWSIZE_MI2),
                     .AWBURST_MI2(AWBURST_MI2),
                     .AWLOCK_MI2(AWLOCK_MI2),
                     .AWCACHE_MI2(AWCACHE_MI2),
                     .AWPROT_MI2(AWPROT_MI2),
                     .AWVALID_MI2(AWVALID_MI2),
                     .AWREADY_IM2(AWREADY_IM2),

                     // MASTER 3
                     // AXI MASTER write address channel signals
                     .AWID_MI3(AWID_MI3),
                     .AWADDR_MI3(AWADDR_MI3),
                     .AWLEN_MI3(AWLEN_MI3),
                     .AWSIZE_MI3(AWSIZE_MI3),
                     .AWBURST_MI3(AWBURST_MI3),
                     .AWLOCK_MI3(AWLOCK_MI3),
                     .AWCACHE_MI3(AWCACHE_MI3),
                     .AWPROT_MI3(AWPROT_MI3),
                     .AWVALID_MI3(AWVALID_MI3),
                     .AWREADY_IM3(AWREADY_IM3),

                     // SLAVE 0
                     // AXI SLAVE 0 write address channel signals
                     .AWID_IS(AWID_IS),
                     .AWADDR_IS(AWADDR_IS),
                     .AWLEN_IS(AWLEN_IS),
                     .AWSIZE_IS(AWSIZE_IS),
                     .AWBURST_IS(AWBURST_IS),
                     .AWLOCK_IS(AWLOCK_IS),
                     .AWCACHE_IS(AWCACHE_IS),
                     .AWPROT_IS(AWPROT_IS),
                     .AWVALID_IS(AWVALID_IS),
                     .AWREADY_SI(AWREADY_SI),

                     .AWADDR_IS_int(AWADDR_IS_int1),
                     .MST_WRGNT_NUM(MST_WRGNT_NUM),
                     .gated_waddr(gated_waddr1),
                     .SLAVE_NUMBER(SLAVE_NUMBER)
 
                     );

   assign                              AWADDR_IS_int = AWADDR_IS_int1;
   assign                              gated_waddr = gated_waddr1;
   assign                              gated_raddr = gated_raddr1;
   
   // --------------------------------------------------------------------------
   // Write Data channel instancea   
   // --------------------------------------------------------------------------
   axi_wd_channel #(
                .SYNC_RESET(SYNC_RESET),
                .AXI_AWIDTH(AXI_AWIDTH),
                .AXI_DWIDTH(AXI_DWIDTH),
                .NUM_SLAVE_SLOT(NUM_SLAVE_SLOT),
                .NUM_MASTER_SLOT(NUM_MASTER_SLOT),
           	    .FEED_THROUGH(FEED_THROUGH),
		        .INP_REG_BUF(INP_REG_BUF),
		        .OUT_REG_BUF(OUT_REG_BUF),
		        .MEMSPACE(MEMSPACE),
		        .HGS_CFG(HGS_CFG),
		        .ADDR_HGS_CFG(ADDR_HGS_CFG),
                .ID_WIDTH(ID_WIDTH),
                .BASE_ID_WIDTH(BASE_ID_WIDTH),
                .WR_ACCEPTANCE(WR_ACCEPTANCE),
                .RD_ACCEPTANCE(RD_ACCEPTANCE),
                .SC_0(SC_0),
                .SC_1(SC_1),
                .SC_2(SC_2),
                .SC_3(SC_3),
                .SC_4(SC_4),
                .SC_5(SC_5),
                .SC_6(SC_6),
                .SC_7(SC_7),
                .SC_8(SC_8),
                .SC_9(SC_9),
                .SC_10(SC_10),
                .SC_11(SC_11),
                .SC_12(SC_12),
                .SC_13(SC_13),
                .SC_14(SC_14),
                .SC_15(SC_15),
                              
                .M0_SLAVE0ENABLE(M0_SLAVE0ENABLE),
                .M0_SLAVE1ENABLE(M0_SLAVE1ENABLE),
                .M0_SLAVE2ENABLE(M0_SLAVE2ENABLE),
                .M0_SLAVE3ENABLE(M0_SLAVE3ENABLE),
                .M0_SLAVE4ENABLE(M0_SLAVE4ENABLE),
                .M0_SLAVE5ENABLE(M0_SLAVE5ENABLE),
                .M0_SLAVE6ENABLE(M0_SLAVE6ENABLE),
                .M0_SLAVE7ENABLE(M0_SLAVE7ENABLE),
                .M0_SLAVE8ENABLE(M0_SLAVE8ENABLE),
                .M0_SLAVE9ENABLE(M0_SLAVE9ENABLE),
                .M0_SLAVE10ENABLE(M0_SLAVE10ENABLE),
                .M0_SLAVE11ENABLE(M0_SLAVE11ENABLE),
                .M0_SLAVE12ENABLE(M0_SLAVE12ENABLE),
                .M0_SLAVE13ENABLE(M0_SLAVE13ENABLE),
                .M0_SLAVE14ENABLE(M0_SLAVE14ENABLE),
                .M0_SLAVE15ENABLE(M0_SLAVE15ENABLE),
                .M0_SLAVE16ENABLE(M0_SLAVE16ENABLE),
                              
                .M1_SLAVE0ENABLE(M1_SLAVE0ENABLE),
                .M1_SLAVE1ENABLE(M1_SLAVE1ENABLE),
                .M1_SLAVE2ENABLE(M1_SLAVE2ENABLE),
                .M1_SLAVE3ENABLE(M1_SLAVE3ENABLE),
                .M1_SLAVE4ENABLE(M1_SLAVE4ENABLE),
                .M1_SLAVE5ENABLE(M1_SLAVE5ENABLE),
                .M1_SLAVE6ENABLE(M1_SLAVE6ENABLE),
                .M1_SLAVE7ENABLE(M1_SLAVE7ENABLE),
                .M1_SLAVE8ENABLE(M1_SLAVE8ENABLE),
                .M1_SLAVE9ENABLE(M1_SLAVE9ENABLE),
                .M1_SLAVE10ENABLE(M1_SLAVE10ENABLE),
                .M1_SLAVE11ENABLE(M1_SLAVE11ENABLE),
                .M1_SLAVE12ENABLE(M1_SLAVE12ENABLE),
                .M1_SLAVE13ENABLE(M1_SLAVE13ENABLE),
                .M1_SLAVE14ENABLE(M1_SLAVE14ENABLE),
                .M1_SLAVE15ENABLE(M1_SLAVE15ENABLE),
                .M1_SLAVE16ENABLE(M1_SLAVE16ENABLE),
                              
                .M2_SLAVE0ENABLE(M2_SLAVE0ENABLE),
                .M2_SLAVE1ENABLE(M2_SLAVE1ENABLE),
                .M2_SLAVE2ENABLE(M2_SLAVE2ENABLE),
                .M2_SLAVE3ENABLE(M2_SLAVE3ENABLE),
                .M2_SLAVE4ENABLE(M2_SLAVE4ENABLE),
                .M2_SLAVE5ENABLE(M2_SLAVE5ENABLE),
                .M2_SLAVE6ENABLE(M2_SLAVE6ENABLE),
                .M2_SLAVE7ENABLE(M2_SLAVE7ENABLE),
                .M2_SLAVE8ENABLE(M2_SLAVE8ENABLE),
                .M2_SLAVE9ENABLE(M2_SLAVE9ENABLE),
                .M2_SLAVE10ENABLE(M2_SLAVE10ENABLE),
                .M2_SLAVE11ENABLE(M2_SLAVE11ENABLE),
                .M2_SLAVE12ENABLE(M2_SLAVE12ENABLE),
                .M2_SLAVE13ENABLE(M2_SLAVE13ENABLE),
                .M2_SLAVE14ENABLE(M2_SLAVE14ENABLE),
                .M2_SLAVE15ENABLE(M2_SLAVE15ENABLE),
                .M2_SLAVE16ENABLE(M2_SLAVE16ENABLE),
                              
                .M3_SLAVE0ENABLE(M3_SLAVE0ENABLE),
                .M3_SLAVE1ENABLE(M3_SLAVE1ENABLE),
                .M3_SLAVE2ENABLE(M3_SLAVE2ENABLE),
                .M3_SLAVE3ENABLE(M3_SLAVE3ENABLE),
                .M3_SLAVE4ENABLE(M3_SLAVE4ENABLE),
                .M3_SLAVE5ENABLE(M3_SLAVE5ENABLE),
                .M3_SLAVE6ENABLE(M3_SLAVE6ENABLE),
                .M3_SLAVE7ENABLE(M3_SLAVE7ENABLE),
                .M3_SLAVE8ENABLE(M3_SLAVE8ENABLE),
                .M3_SLAVE9ENABLE(M3_SLAVE9ENABLE),
                .M3_SLAVE10ENABLE(M3_SLAVE10ENABLE),
                .M3_SLAVE11ENABLE(M3_SLAVE11ENABLE),
                .M3_SLAVE12ENABLE(M3_SLAVE12ENABLE),
                .M3_SLAVE13ENABLE(M3_SLAVE13ENABLE),
                .M3_SLAVE14ENABLE(M3_SLAVE14ENABLE),
                .M3_SLAVE15ENABLE(M3_SLAVE15ENABLE),
                .M3_SLAVE16ENABLE(M3_SLAVE16ENABLE)
                )
     inst_wd_channel(
                     // Global signals
                     .ACLK(ACLK),
                     .ARESETN(ARESETN),                            
                     
                     // From fwd master waselector
                     .MST_GNT_NUM(MST_WRGNT_NUM), 
                     .AWADDR_IS_int(AWADDR_IS),  

                     // MASTER 0
                     // AXI MASTER write data channel signals
                     .WID_MI0(WID_MI0),
                     .WDATA_MI0(WDATA_MI0),
                     .WSTRB_MI0(WSTRB_MI0),
                     .WLAST_MI0(WLAST_MI0),
                     .WVALID_MI0(WVALID_MI0),
                     .WREADY_IM0(WREADY_IM0),
                     
                     // MASTER 1
                     // AXI MASTER write data channel signals
                     .WID_MI1(WID_MI1),
                     .WDATA_MI1(WDATA_MI1),
                     .WSTRB_MI1(WSTRB_MI1),
                     .WLAST_MI1(WLAST_MI1),
                     .WVALID_MI1(WVALID_MI1),
                     .WREADY_IM1(WREADY_IM1),

                     // MASTER 2
                     // AXI MASTER write data channel signals
                     .WID_MI2(WID_MI2),
                     .WDATA_MI2(WDATA_MI2),
                     .WSTRB_MI2(WSTRB_MI2),
                     .WLAST_MI2(WLAST_MI2),
                     .WVALID_MI2(WVALID_MI2),
                     .WREADY_IM2(WREADY_IM2),
                     
                     // MASTER 3
                     // AXI MASTER write data channel signals
                     .WID_MI3(WID_MI3),
                     .WDATA_MI3(WDATA_MI3),
                     .WSTRB_MI3(WSTRB_MI3),
                     .WLAST_MI3(WLAST_MI3),
                     .WVALID_MI3(WVALID_MI3),
                     .WREADY_IM3(WREADY_IM3),

                     // SLAVE 0
                     // AXI SLAVE 0 write data channel signals
                     .WID_IS(WID_IS),  
                     .WDATA_IS(WDATA_IS),    
                     .WVALID_IS(WVALID_IS),
                     .WSTRB_IS(WSTRB_IS),   
                     .WLAST_IS(WLAST_IS), 

                     .WREADY_SI(WREADY_SI),
                     .SLAVE_NUMBER(SLAVE_NUMBER)

                     );


   // --------------------------------------------------------------------------
   // Read address channel instance
   // --------------------------------------------------------------------------
   axi_ra_channel #(
               .SYNC_RESET(SYNC_RESET),
               .AXI_AWIDTH(AXI_AWIDTH),
               .AXI_DWIDTH(AXI_DWIDTH),
               .NUM_SLAVE_SLOT(NUM_SLAVE_SLOT),
               .NUM_MASTER_SLOT(NUM_MASTER_SLOT),
           	   .FEED_THROUGH(FEED_THROUGH),
		       .INP_REG_BUF(INP_REG_BUF),
		       .OUT_REG_BUF(OUT_REG_BUF),
		       .MEMSPACE(MEMSPACE),
		       .HGS_CFG(HGS_CFG),
		       .ADDR_HGS_CFG(ADDR_HGS_CFG),
               .ID_WIDTH(ID_WIDTH),
               .BASE_ID_WIDTH(BASE_ID_WIDTH),
               .WR_ACCEPTANCE(WR_ACCEPTANCE),
               .RD_ACCEPTANCE(RD_ACCEPTANCE),
               .SC_0(SC_0),
               .SC_1(SC_1),
               .SC_2(SC_2),
               .SC_3(SC_3),
               .SC_4(SC_4),
               .SC_5(SC_5),
               .SC_6(SC_6),
               .SC_7(SC_7),
               .SC_8(SC_8),
               .SC_9(SC_9),
               .SC_10(SC_10),
               .SC_11(SC_11),
               .SC_12(SC_12),
               .SC_13(SC_13),
               .SC_14(SC_14),
               .SC_15(SC_15),

                .M0_SLAVE0ENABLE(M0_SLAVE0ENABLE),
               .M0_SLAVE1ENABLE(M0_SLAVE1ENABLE),
               .M0_SLAVE2ENABLE(M0_SLAVE2ENABLE),
               .M0_SLAVE3ENABLE(M0_SLAVE3ENABLE),
               .M0_SLAVE4ENABLE(M0_SLAVE4ENABLE),
               .M0_SLAVE5ENABLE(M0_SLAVE5ENABLE),
               .M0_SLAVE6ENABLE(M0_SLAVE6ENABLE),
               .M0_SLAVE7ENABLE(M0_SLAVE7ENABLE),
               .M0_SLAVE8ENABLE(M0_SLAVE8ENABLE),
               .M0_SLAVE9ENABLE(M0_SLAVE9ENABLE),
               .M0_SLAVE10ENABLE(M0_SLAVE10ENABLE),
               .M0_SLAVE11ENABLE(M0_SLAVE11ENABLE),
               .M0_SLAVE12ENABLE(M0_SLAVE12ENABLE),
               .M0_SLAVE13ENABLE(M0_SLAVE13ENABLE),
               .M0_SLAVE14ENABLE(M0_SLAVE14ENABLE),
               .M0_SLAVE15ENABLE(M0_SLAVE15ENABLE),
               .M0_SLAVE16ENABLE(M0_SLAVE16ENABLE),

               .M1_SLAVE0ENABLE(M1_SLAVE0ENABLE),
               .M1_SLAVE1ENABLE(M1_SLAVE1ENABLE),
               .M1_SLAVE2ENABLE(M1_SLAVE2ENABLE),
               .M1_SLAVE3ENABLE(M1_SLAVE3ENABLE),
               .M1_SLAVE4ENABLE(M1_SLAVE4ENABLE),
               .M1_SLAVE5ENABLE(M1_SLAVE5ENABLE),
               .M1_SLAVE6ENABLE(M1_SLAVE6ENABLE),
               .M1_SLAVE7ENABLE(M1_SLAVE7ENABLE),
               .M1_SLAVE8ENABLE(M1_SLAVE8ENABLE),
               .M1_SLAVE9ENABLE(M1_SLAVE9ENABLE),
               .M1_SLAVE10ENABLE(M1_SLAVE10ENABLE),
               .M1_SLAVE11ENABLE(M1_SLAVE11ENABLE),
               .M1_SLAVE12ENABLE(M1_SLAVE12ENABLE),
               .M1_SLAVE13ENABLE(M1_SLAVE13ENABLE),
               .M1_SLAVE14ENABLE(M1_SLAVE14ENABLE),
               .M1_SLAVE15ENABLE(M1_SLAVE15ENABLE),
               .M1_SLAVE16ENABLE(M1_SLAVE16ENABLE),

               .M2_SLAVE0ENABLE(M2_SLAVE0ENABLE),
               .M2_SLAVE1ENABLE(M2_SLAVE1ENABLE),
               .M2_SLAVE2ENABLE(M2_SLAVE2ENABLE),
               .M2_SLAVE3ENABLE(M2_SLAVE3ENABLE),
               .M2_SLAVE4ENABLE(M2_SLAVE4ENABLE),
               .M2_SLAVE5ENABLE(M2_SLAVE5ENABLE),
               .M2_SLAVE6ENABLE(M2_SLAVE6ENABLE),
               .M2_SLAVE7ENABLE(M2_SLAVE7ENABLE),
               .M2_SLAVE8ENABLE(M2_SLAVE8ENABLE),
               .M2_SLAVE9ENABLE(M2_SLAVE9ENABLE),
               .M2_SLAVE10ENABLE(M2_SLAVE10ENABLE),
               .M2_SLAVE11ENABLE(M2_SLAVE11ENABLE),
               .M2_SLAVE12ENABLE(M2_SLAVE12ENABLE),
               .M2_SLAVE13ENABLE(M2_SLAVE13ENABLE),
               .M2_SLAVE14ENABLE(M2_SLAVE14ENABLE),
               .M2_SLAVE15ENABLE(M2_SLAVE15ENABLE),
               .M2_SLAVE16ENABLE(M2_SLAVE16ENABLE),

               .M3_SLAVE0ENABLE(M3_SLAVE0ENABLE),
               .M3_SLAVE1ENABLE(M3_SLAVE1ENABLE),
               .M3_SLAVE2ENABLE(M3_SLAVE2ENABLE),
               .M3_SLAVE3ENABLE(M3_SLAVE3ENABLE),
               .M3_SLAVE4ENABLE(M3_SLAVE4ENABLE),
               .M3_SLAVE5ENABLE(M3_SLAVE5ENABLE),
               .M3_SLAVE6ENABLE(M3_SLAVE6ENABLE),
               .M3_SLAVE7ENABLE(M3_SLAVE7ENABLE),
               .M3_SLAVE8ENABLE(M3_SLAVE8ENABLE),
               .M3_SLAVE9ENABLE(M3_SLAVE9ENABLE),
               .M3_SLAVE10ENABLE(M3_SLAVE10ENABLE),
               .M3_SLAVE11ENABLE(M3_SLAVE11ENABLE),
               .M3_SLAVE12ENABLE(M3_SLAVE12ENABLE),
               .M3_SLAVE13ENABLE(M3_SLAVE13ENABLE),
               .M3_SLAVE14ENABLE(M3_SLAVE14ENABLE),
               .M3_SLAVE15ENABLE(M3_SLAVE15ENABLE),
               .M3_SLAVE16ENABLE(M3_SLAVE16ENABLE)
                )
     inst_ra_channel(
                     // Global signals
                     .ACLK(ACLK),
                     .ARESETN(ARESETN),
                     .ARADDR_IS_int(ARADDR_IS_int),
                     .m0_rd_end(m0_rd_end),
                     .m1_rd_end(m1_rd_end),
                     .m2_rd_end(m2_rd_end),
                     .m3_rd_end(m3_rd_end),

                     .RVALID_SI(RVALID_SI),
                     .RLAST_SI(RLAST_SI),
                     .RREADY_IS(RREADY_IS),

                     .ARADDR_M0(ARADDR_M0),
                     .ARLOCK_M0(ARLOCK_M0),
                     .ARVALID_M0(ARVALID_M0),
                     .ARADDR_M1(ARADDR_M1),
                     .ARLOCK_M1(ARLOCK_M1),
                     .ARVALID_M1(ARVALID_M1),
                     .ARADDR_M2(ARADDR_M2),
                     .ARLOCK_M2(ARLOCK_M2),
                     .ARVALID_M2(ARVALID_M2),
                     .ARADDR_M3(ARADDR_M3),
                     .ARLOCK_M3(ARLOCK_M3),
                     .ARVALID_M3(ARVALID_M3),

                     // MASTER 0
                     // AXI MASTER read address channel signals
                     .ARID_MI0(ARID_MI0),
                     .ARADDR_MI0(ARADDR_MI0),
                     .ARLEN_MI0(ARLEN_MI0),
                     .ARSIZE_MI0(ARSIZE_MI0),
                     .ARBURST_MI0(ARBURST_MI0),
                     .ARLOCK_MI0(ARLOCK_MI0),
                     .ARCACHE_MI0(ARCACHE_MI0),
                     .ARPROT_MI0(ARPROT_MI0),
                     .ARVALID_MI0(ARVALID_MI0),
                     .ARREADY_IM0(ARREADY_IM0),

                     // MASTER 1
                     // AXI MASTER read address channel signals
                     .ARID_MI1(ARID_MI1),
                     .ARADDR_MI1(ARADDR_MI1),
                     .ARLEN_MI1(ARLEN_MI1),
                     .ARSIZE_MI1(ARSIZE_MI1),
                     .ARBURST_MI1(ARBURST_MI1),
                     .ARLOCK_MI1(ARLOCK_MI1),
                     .ARCACHE_MI1(ARCACHE_MI1),
                     .ARPROT_MI1(ARPROT_MI1),
                     .ARVALID_MI1(ARVALID_MI1),
                     .ARREADY_IM1(ARREADY_IM1),

                     // MASTER 2
                     // AXI MASTER read address channel signals
                     .ARID_MI2(ARID_MI2),
                     .ARADDR_MI2(ARADDR_MI2),
                     .ARLEN_MI2(ARLEN_MI2),
                     .ARSIZE_MI2(ARSIZE_MI2),
                     .ARBURST_MI2(ARBURST_MI2),
                     .ARLOCK_MI2(ARLOCK_MI2),
                     .ARCACHE_MI2(ARCACHE_MI2),
                     .ARPROT_MI2(ARPROT_MI2),
                     .ARVALID_MI2(ARVALID_MI2),
                     .ARREADY_IM2(ARREADY_IM2),

                     // MASTER 3
                     // AXI MASTER read address channel signals
                     .ARID_MI3(ARID_MI3),
                     .ARADDR_MI3(ARADDR_MI3),
                     .ARLEN_MI3(ARLEN_MI3),
                     .ARSIZE_MI3(ARSIZE_MI3),
                     .ARBURST_MI3(ARBURST_MI3),
                     .ARLOCK_MI3(ARLOCK_MI3),
                     .ARCACHE_MI3(ARCACHE_MI3),
                     .ARPROT_MI3(ARPROT_MI3),
                     .ARVALID_MI3(ARVALID_MI3),
                     .ARREADY_IM3(ARREADY_IM3),

                     // SLAVE 0
                     // AXI SLAVE 0 read address channel signals
                     .ARID_IS(ARID_IS),
                     .ARADDR_IS(ARADDR_IS),
                     .ARLEN_IS(ARLEN_IS),
                     .ARSIZE_IS(ARSIZE_IS),
                     .ARBURST_IS(ARBURST_IS),
                     .ARLOCK_IS(ARLOCK_IS),
                     .ARCACHE_IS(ARCACHE_IS),
                     .ARPROT_IS(ARPROT_IS),
                     .ARVALID_IS(ARVALID_IS),
                     .ARREADY_SI(ARREADY_SI),

                     .MST_RDGNT_NUM(MST_RDGNT_NUM),
                     .rd_rdcntr(rd_rdcntr),    
                     .rd_wdcntr(rd_wdcntr),
                     .rd_wen_flag(rd_wen_flag),
                     .rd_ren_flag(rd_ren_flag),
                     .SLAVE_SELECT_RADDRCH_M(gated_raddr1),
                     .SLAVE_NUMBER(SLAVE_NUMBER)
                     );





endmodule // matrix_s


   /////////////////////////////////////////////////////////////////////////////
   //                               End - of - Code                           //
   /////////////////////////////////////////////////////////////////////////////


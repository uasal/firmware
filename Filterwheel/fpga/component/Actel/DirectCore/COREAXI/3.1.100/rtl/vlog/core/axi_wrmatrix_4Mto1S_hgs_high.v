// ****************************************************************************/
// Actel Corporation Proprietary and Confidential
// Copyright 2010 Actel Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description: wrmatrix_4Mto1S.v
//              
//              Contains:
//                       - Arbiter
//                       - 
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

module axi_wrmatrix_4Mto1S_hgs_high (
                        // Global signals
                        ACLK,
                        ARESETN,
                      
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

                        m0_wr_end,
                        m1_wr_end,
                        m2_wr_end,
                        m3_wr_end,

                        // AXI MASTER write address channel signals
                        AWREADY_SI,
                        BVALID_SI,
                        BREADY_IS,
                        
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
                      
                        // SLAVE 0
                        // AXI SLAVE 0 write address channel signals
                        AWID_IS,
                        AWADDR_IS,
                        AWADDR_IS_int,
                        AWLEN_IS,
                        AWSIZE_IS,
                        AWBURST_IS,
                        AWLOCK_IS,
                        AWCACHE_IS,
                        AWPROT_IS,
                        AWVALID_IS,

                        
                        MST_WRGNT_NUM,
                        SLAVE_SELECT_WADDRCH_M,
                        SLAVE_NUMBER                   
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
   parameter BASE_ID_WIDTH        = 0;

   parameter NUM_SLAVE_SLOT       = 1;  // 1 - 16
   parameter NUM_MASTER_SLOT      = 1;  // 1 - 4
   parameter MEMSPACE             = 1;  // 0 - 6
   parameter HGS_CFG              = 1;  // 1 - 6
   parameter ADDR_HGS_CFG         = 1;  // 0 - 1

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

   parameter FEED_THROUGH         = 0;  // 0 - 1
   parameter INP_REG_BUF          = 1;  // 0 - 1
   parameter OUT_REG_BUF          = 1;  // 0 - 1

   parameter WR_ACCEPTANCE        = 4;  // 1 - 4
   parameter RD_ACCEPTANCE        = 4;  // 1 - 4
   parameter SYNC_RESET           = 0;

   localparam AXI_STRBWIDTH       = AXI_DWIDTH/8;

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

   localparam COMB_REG       = {SC_0, SC_1, SC_2, SC_3, SC_4, SC_5, SC_6, SC_7, SC_8, SC_9, SC_10, SC_11, SC_12, SC_13, SC_14, SC_15};
   localparam SINGLE_MASTER  = (NUM_MASTER_SLOT == 1) ? 1 : 0;

   // --------------------------------------------------------------------------
   // I/O Declaration
   // --------------------------------------------------------------------------
   // Global signals
   input       ACLK;
   input       ARESETN;

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

   // AXI MASTER write address channel signals
   input       AWREADY_SI;
   input       BVALID_SI;
   input       BREADY_IS;
   
   // For Arbiter from Masters
   // To end grant to current master
   input       m0_wr_end;
   input       m1_wr_end;
   input       m2_wr_end;
   input       m3_wr_end;

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
   
   // SLAVE 0
   // AXI SLAVE 0 write address channel signals
   output [BASE_ID_WIDTH+ID_WIDTH - 1:0] AWID_IS;
   output [31:0]      AWADDR_IS;
   output [31:0]      AWADDR_IS_int;

   output [3:0]                 AWLEN_IS;
   output [2:0]                 AWSIZE_IS;
   output [1:0]                 AWBURST_IS;
   output [1:0]                 AWLOCK_IS;
   output [3:0]                 AWCACHE_IS;
   output [2:0]                 AWPROT_IS;
   output                       AWVALID_IS;

   output [16:0]                SLAVE_SELECT_WADDRCH_M;
   input [4:0]                  SLAVE_NUMBER;
   output [3:0]                 MST_WRGNT_NUM; 

   // --------------------------------------------------------------------------
   // Internal signals
   // --------------------------------------------------------------------------
   reg [16:0]                         SLAVE_SELECT_WADDRCH_M;
   reg [16:0]                         SLAVE_SELECT_WADDRCH_M_r;

   reg [BASE_ID_WIDTH+ID_WIDTH - 1:0] AWID_IS;
   reg [31:0]               AWADDR_IS;
   reg [3:0]                          AWLEN_IS;
   reg [2:0]                          AWSIZE_IS;
   reg [1:0]                          AWBURST_IS;
   reg [1:0]                          AWLOCK_IS;
   reg [3:0]                          AWCACHE_IS;
   reg [2:0]                          AWPROT_IS;
   reg                                AWVALID_IS;

   reg [BASE_ID_WIDTH+ID_WIDTH - 1:0] AWID_IS_int;
   reg [31:0]               AWADDR_IS_int;
   reg [3:0]                          AWLEN_IS_int;
   reg [2:0]                          AWSIZE_IS_int;
   reg [1:0]                          AWBURST_IS_int;
   reg [1:0]                          AWLOCK_IS_int;
   reg [3:0]                          AWCACHE_IS_int;
   reg [2:0]                          AWPROT_IS_int;
   reg                                AWVALID_IS_int;

   // For Arbiter from Masters
   wire                               AWREADY_SI_int;
   reg [3:0]                          wr_rdcntr;
   reg [3:0]                          wr_wdcntr;
   reg [3:0]                          MST_WRGNT_NUM; 
   wire                               wr_wen_flag;
   wire                               wr_ren_flag;

   reg                                AWREADY_IM0;
   reg                                AWREADY_IM1;
   reg                                AWREADY_IM2;
   reg                                AWREADY_IM3;

   wire [3:0]                         AW_REQ_MI;

   reg [16:0]                         SLAVE_SELECT_WRITE_M0;
   reg [16:0]                         SLAVE_SELECT_WRITE_M1;
   reg [16:0]                         SLAVE_SELECT_WRITE_M2;
   reg [16:0]                         SLAVE_SELECT_WRITE_M3;

   reg                                mst0_wr_end;
   reg [WR_ACCEPTANCE - 1: 0]         mst0_outstd_wrcntr;   
   reg                                mst0_wr_end_d1;

   reg                                mst1_wr_end;
   reg [WR_ACCEPTANCE - 1: 0]         mst1_outstd_wrcntr;   
   reg                                mst1_wr_end_d1;

   reg                                mst2_wr_end;
   reg [WR_ACCEPTANCE - 1: 0]         mst2_outstd_wrcntr;   
   reg                                mst2_wr_end_d1;

   reg                                mst3_wr_end;
   reg [WR_ACCEPTANCE - 1: 0]         mst3_outstd_wrcntr;   
   reg                                mst3_wr_end_d1;

   wire [3:0]                         AW_MASGNT_IC;
   
   reg                                AW_REQ_MI0;
   reg                                AW_REQ_MI1;
   reg                                AW_REQ_MI2;
   reg                                AW_REQ_MI3;
   
   wire                               aresetn;
   wire                               sresetn;

   /////////////////////////////////////////////////////////////////////////////
   //                               Start - of - Code                         //
   /////////////////////////////////////////////////////////////////////////////

   // --------------------------------------------------------------------------
   // resets
   // --------------------------------------------------------------------------
   assign aresetn   = (SYNC_RESET == 1) ? 1'b1  : ARESETN;
   assign sresetn   = (SYNC_RESET == 1) ? ARESETN : 1'b1;

   // -----------------------------------------------------
   // Write Arbiter Instance
   // Arbiters are not required in case of Single Master
   // -----------------------------------------------------
   axi_WA_ARBITER #( 
                 .SYNC_RESET(SYNC_RESET),
	             .AXI_AWIDTH(AXI_AWIDTH),
	             .AXI_DWIDTH(AXI_DWIDTH),
	             .AXI_STRBWIDTH(AXI_STRBWIDTH),
     		     .INP_REG_BUF(INP_REG_BUF),
		         .OUT_REG_BUF(OUT_REG_BUF),
                 .NUM_MASTER_SLOT(NUM_MASTER_SLOT)
            )
	   UWA_ARBITER (
                    // Global signals
                    .ACLK       (ACLK)
                    ,   .ARESETN    (ARESETN)
                    
                    // MASTER 0
                    ,   .AWLOCK_M0  (AWLOCK_M0)

                    // MASTER 1
                    ,   .AWLOCK_M1  (AWLOCK_M1)
                    
                    // MASTER 2
                    ,   .AWLOCK_M2  (AWLOCK_M2)

                    // MASTER 3
                    ,   .AWLOCK_M3  (AWLOCK_M3)
                    // Added 22 Apr: lock issue
                    ,   .AWLOCK_MI0  (AWLOCK_MI0)
                    ,   .AWLOCK_MI1  (AWLOCK_MI1)
                    ,   .AWLOCK_MI2  (AWLOCK_MI2)
                    ,   .AWLOCK_MI3  (AWLOCK_MI3)

                    // From Masters
                    // M0
                    ,  .m0_wr_end(m0_wr_end)
                    // M1
                    ,  .m1_wr_end(m1_wr_end)
                    // M2
                    ,  .m2_wr_end(m2_wr_end)
                    // M3
                    ,  .m3_wr_end(m3_wr_end)
                    
                    // AXI MASTER 0 
                    ,  .AW_REQ_MI0(AW_REQ_MI0)
                    
                    // AXI MASTER 1 
                    ,  .AW_REQ_MI1(AW_REQ_MI1)
                    
                    // AXI MASTER 2 
                    ,  .AW_REQ_MI2(AW_REQ_MI2)
                    
                    // AXI MASTER 3 
                    ,  .AW_REQ_MI3(AW_REQ_MI3)

                    // Outputs 
                    ,  .AW_MASGNT_MI(AW_MASGNT_IC)

                    );

   // --------------------------------------------------------------------------
   // Register the write address control signals passing to the slave interface.
   // The signals are passed only if it is meant for the intended slave. Otherwise
   // it gets blocked. This is done by checking the slave number with the received
   // write address.
   // --------------------------------------------------------------------------
   always @(posedge ACLK or negedge aresetn) begin
      if((!aresetn) || (!sresetn)) begin
  	     AWADDR_IS   <= 'h0;
		 AWID_IS     <= 'h0;
         AWLEN_IS    <= 'h0;
         AWSIZE_IS   <= 'h0;
         AWBURST_IS  <= 'h0;
         AWLOCK_IS   <= 'h0;
         AWCACHE_IS  <= 'h0;
         AWPROT_IS   <= 'h0;
         AWVALID_IS  <= 'h0; 
      end
      else begin
         if((AWADDR_IS_int[31] == 1 && SLAVE_NUMBER == AWADDR_IS_int[31 : 28]) || SLAVE_NUMBER[4] == 1'b1) begin 
  	        AWADDR_IS   <= AWADDR_IS_int;
		    AWID_IS     <= AWID_IS_int;
            AWLEN_IS    <= AWLEN_IS_int;
            AWSIZE_IS   <= AWSIZE_IS_int;
            AWBURST_IS  <= AWBURST_IS_int;
            AWLOCK_IS   <= AWLOCK_IS_int;
            AWCACHE_IS  <= AWCACHE_IS_int;
            AWPROT_IS   <= AWPROT_IS_int;
            AWVALID_IS  <= AWVALID_IS_int;
         end
         else if((AWADDR_IS_int[31] == 0 && SLAVE_NUMBER == AWADDR_IS_int[AXI_AWIDTH - 1 : AXI_AWIDTH - 4]) || SLAVE_NUMBER[4] == 1'b1) begin 
  	        AWADDR_IS   <= AWADDR_IS_int;
		    AWID_IS     <= AWID_IS_int;
            AWLEN_IS    <= AWLEN_IS_int;
            AWSIZE_IS   <= AWSIZE_IS_int;
            AWBURST_IS  <= AWBURST_IS_int;
            AWLOCK_IS   <= AWLOCK_IS_int;
            AWCACHE_IS  <= AWCACHE_IS_int;
            AWPROT_IS   <= AWPROT_IS_int;
            AWVALID_IS  <= AWVALID_IS_int;
         end
         else begin
  	        AWADDR_IS   <= AWADDR_IS;
		    AWID_IS     <= 'h0;
            AWLEN_IS    <= 'h0;
            AWSIZE_IS   <= 'h0;
            AWBURST_IS  <= 'h0;
            AWLOCK_IS   <= 'h0;
            AWCACHE_IS  <= 'h0;
            AWPROT_IS   <= 'h0;
            AWVALID_IS  <= 'h0; 
         end
      end
   end
   
   // --------------------------------------------------------------------------
   // Select the Master signals based the grant provided by the arbiter
   // The Write address channel signals are passed through from the master
   // selected by the grant from the arbiter.
   // The write address control signals are routed to the slave interface and
   // the write address ready is sent back to the granted master.
   // --------------------------------------------------------------------------
   generate
      if(NUM_MASTER_SLOT == 1) begin
         always @(posedge ACLK or negedge aresetn) begin
            if((!aresetn) || (!sresetn)) begin
	    	     AWADDR_IS_int   <= 'h0;
		         AWID_IS_int     <= 'h0;
                 AWLEN_IS_int    <= 'h0;
                 AWSIZE_IS_int   <= 'h0;
                 AWBURST_IS_int  <= 'h0;
                 AWLOCK_IS_int   <= 'h0;
                 AWCACHE_IS_int  <= 'h0;
                 AWPROT_IS_int   <= 'h0;
                 AWVALID_IS_int  <= 'h0;    
                 
                 AWREADY_IM0     <= 1'b0;
                 
	    	     MST_WRGNT_NUM   <= 4'b0000;
            end
            else begin
               
	        case(AW_MASGNT_IC)
              4'b0001 : begin 
	    	     AWADDR_IS_int   <= AWADDR_MI0;
		         AWID_IS_int     <= AWID_MI0;
                 AWLEN_IS_int    <= AWLEN_MI0;
                 AWSIZE_IS_int   <= AWSIZE_MI0;
                 AWBURST_IS_int  <= AWBURST_MI0;
                 AWLOCK_IS_int   <= AWLOCK_MI0;
                 AWCACHE_IS_int  <= AWCACHE_MI0;
                 AWPROT_IS_int   <= AWPROT_MI0;
                 AWVALID_IS_int  <= AWVALID_MI0;    
                 
                 AWREADY_IM0 <= AWREADY_SI;

	    	     MST_WRGNT_NUM <= 4'b0001;
    		  end
              default : begin 
		         AWID_IS_int     <= 'h0;
                 AWLEN_IS_int    <= 'h0;
                 AWSIZE_IS_int   <= 'h0;
                 AWBURST_IS_int  <= 'h0;
                 AWLOCK_IS_int   <= 'h0;
                 AWCACHE_IS_int  <= 'h0;
                 AWPROT_IS_int   <= 'h0;
                 AWVALID_IS_int  <= 'h0;    
                 
                 AWREADY_IM0 <= 1'b0;
                 
	    	     MST_WRGNT_NUM <= 4'b0000;
    	      end
            endcase // case (AW_MASGNT_IC)
            end // else: !if(!ARESETN)            
         end
      end // if (NUM_MASTER_SLOT == 1)      
   endgenerate


   generate 
   if(NUM_MASTER_SLOT == 2) begin
      always @(posedge ACLK or negedge aresetn) begin
         if((!aresetn) || (!sresetn)) begin
	    	AWADDR_IS_int   <= 'h0;
		    AWID_IS_int     <= 'h0;
            AWLEN_IS_int    <= 'h0;
            AWSIZE_IS_int   <= 'h0;
            AWBURST_IS_int  <= 'h0;
            AWLOCK_IS_int   <= 'h0;
            AWCACHE_IS_int  <= 'h0;
            AWPROT_IS_int   <= 'h0;
            AWVALID_IS_int  <= 'h0;    
            
            AWREADY_IM0 <= 1'b0;
            AWREADY_IM1 <= 1'b0;
            
	    	MST_WRGNT_NUM <= 4'b0000;
         end
         else begin


	   case(AW_MASGNT_IC)
         4'b0001 : begin 
	    	AWADDR_IS_int   <= AWADDR_MI0;
		    AWID_IS_int     <= AWID_MI0;
            AWLEN_IS_int    <= AWLEN_MI0;
            AWSIZE_IS_int   <= AWSIZE_MI0;
            AWBURST_IS_int  <= AWBURST_MI0;
            AWLOCK_IS_int   <= AWLOCK_MI0;
            AWCACHE_IS_int  <= AWCACHE_MI0;
            AWPROT_IS_int   <= AWPROT_MI0;
            AWVALID_IS_int  <= AWVALID_MI0;    
            
            AWREADY_IM0 <= AWREADY_SI;
            AWREADY_IM1 <= 1'b0;
            
	    	MST_WRGNT_NUM <= 4'b0001;
    	 end
         4'b0010 : begin 
	    	 AWADDR_IS_int   <= AWADDR_MI1;
		     AWID_IS_int     <= AWID_MI1;
             AWLEN_IS_int    <= AWLEN_MI1;
             AWSIZE_IS_int   <= AWSIZE_MI1;
             AWBURST_IS_int  <= AWBURST_MI1;
             AWLOCK_IS_int   <= AWLOCK_MI1;
             AWCACHE_IS_int  <= AWCACHE_MI1;
             AWPROT_IS_int   <= AWPROT_MI1;
             AWVALID_IS_int  <= AWVALID_MI1;    

             AWREADY_IM1 <= AWREADY_SI;
             AWREADY_IM0 <= 1'b0;


	    	 MST_WRGNT_NUM <= 4'b0010;
    	  end
          default : begin 
		     AWID_IS_int     <= 'h0;
             AWLEN_IS_int    <= 'h0;
             AWSIZE_IS_int   <= 'h0;
             AWBURST_IS_int  <= 'h0;
             AWLOCK_IS_int   <= 'h0;
             AWCACHE_IS_int  <= 'h0;
             AWPROT_IS_int   <= 'h0;
             AWVALID_IS_int  <= 'h0;    

             AWREADY_IM0 <= 1'b0;
             AWREADY_IM1 <= 1'b0;

	    	 MST_WRGNT_NUM <= 4'b0000;
    	  end
        endcase // case (AW_MASGNT_IC)       
         end // else: !if(!ARESETN)         
    end // always @ (*)      
   end // if (NUM_MASTER_SLOT == 2)      
   endgenerate
   
   generate 
      if(NUM_MASTER_SLOT == 3) begin
      always @(posedge ACLK or negedge aresetn) begin
         if((!aresetn) || (!sresetn)) begin
	    	AWADDR_IS_int   <= 'h0;
		    AWID_IS_int     <= 'h0;
            AWLEN_IS_int    <= 'h0;
            AWSIZE_IS_int   <= 'h0;
            AWBURST_IS_int  <= 'h0;
            AWLOCK_IS_int   <= 'h0;
            AWCACHE_IS_int  <= 'h0;
            AWPROT_IS_int   <= 'h0;
            AWVALID_IS_int  <= 'h0;    
            
            AWREADY_IM0 <= 1'b0;
            AWREADY_IM1 <= 1'b0;
            AWREADY_IM2 <= 1'b0;
            
	    	MST_WRGNT_NUM <= 4'b0000;
         end
         else begin

         case(AW_MASGNT_IC)
           4'b0001 : begin 
     	     AWADDR_IS_int    <= AWADDR_MI0;
              AWID_IS_int     <= AWID_MI0;
              AWLEN_IS_int    <= AWLEN_MI0;
              AWSIZE_IS_int   <= AWSIZE_MI0;
              AWBURST_IS_int  <= AWBURST_MI0;
              AWLOCK_IS_int   <= AWLOCK_MI0;
              AWCACHE_IS_int  <= AWCACHE_MI0;
              AWPROT_IS_int   <= AWPROT_MI0;
              AWVALID_IS_int  <= AWVALID_MI0;    

              AWREADY_IM0 <= AWREADY_SI;
              AWREADY_IM1 <= 1'b0;
              AWREADY_IM2 <= 1'b0;

     	     MST_WRGNT_NUM <= 4'b0001;
     	  end
           4'b0010 : begin 
     		  AWADDR_IS_int   <= AWADDR_MI1;
              AWID_IS_int     <= AWID_MI1;
              AWLEN_IS_int    <= AWLEN_MI1;
              AWSIZE_IS_int   <= AWSIZE_MI1;
              AWBURST_IS_int  <= AWBURST_MI1;
              AWLOCK_IS_int   <= AWLOCK_MI1;
              AWCACHE_IS_int  <= AWCACHE_MI1;
              AWPROT_IS_int   <= AWPROT_MI1;
              AWVALID_IS_int  <= AWVALID_MI1;    

              AWREADY_IM1 <= AWREADY_SI;
              AWREADY_IM0 <= 1'b0;
              AWREADY_IM2 <= 1'b0;

     	     MST_WRGNT_NUM <= 4'b0010;
     	  end
           4'b0100 : begin 
              AWADDR_IS_int   <= AWADDR_MI2;
              AWID_IS_int     <= AWID_MI2;
              AWLEN_IS_int    <= AWLEN_MI2;
              AWSIZE_IS_int   <= AWSIZE_MI2;
              AWBURST_IS_int  <= AWBURST_MI2;
              AWLOCK_IS_int   <= AWLOCK_MI2;
              AWCACHE_IS_int  <= AWCACHE_MI2;
              AWPROT_IS_int   <= AWPROT_MI2;
              AWVALID_IS_int  <= AWVALID_MI2;    

              AWREADY_IM2 <= AWREADY_SI;
              AWREADY_IM0 <= 1'b0;
              AWREADY_IM1 <= 1'b0;

     	     MST_WRGNT_NUM <= 4'b0100;
     	  end
           default : begin 
              AWID_IS_int     <= 'h0;
              AWLEN_IS_int    <= 'h0;
              AWSIZE_IS_int   <= 'h0;
              AWBURST_IS_int  <= 'h0;
              AWLOCK_IS_int   <= 'h0;
              AWCACHE_IS_int  <= 'h0;
              AWPROT_IS_int   <= 'h0;
              AWVALID_IS_int  <= 'h0;    

              AWREADY_IM0 <= 1'b0;
              AWREADY_IM1 <= 1'b0;
              AWREADY_IM2 <= 1'b0;

     	     MST_WRGNT_NUM <= 4'b0000;
     	  end
         endcase // case (AW_MASGNT_IC)       
         end // else: !if(!ARESETN)         
      end // always @ (*)      
   end // if (NUM_MASTER_SLOT == 3)
   endgenerate

   generate 
      if(NUM_MASTER_SLOT == 4) begin
      always @(posedge ACLK or negedge aresetn) begin
         if((!aresetn) || (!sresetn)) begin
	    	AWADDR_IS_int   <= 'h0;
		    AWID_IS_int     <= 'h0;
            AWLEN_IS_int    <= 'h0;
            AWSIZE_IS_int   <= 'h0;
            AWBURST_IS_int  <= 'h0;
            AWLOCK_IS_int   <= 'h0;
            AWCACHE_IS_int  <= 'h0;
            AWPROT_IS_int   <= 'h0;
            AWVALID_IS_int  <= 'h0;    
            
            AWREADY_IM0 <= 1'b0;
            AWREADY_IM1 <= 1'b0;
            AWREADY_IM2 <= 1'b0;
            AWREADY_IM3 <= 1'b0;
            
	    	MST_WRGNT_NUM <= 4'b0000;
         end
         else begin

            case (AW_MASGNT_IC)
              4'b0001 : begin 
      	         AWADDR_IS_int   <= AWADDR_MI0;
                 AWID_IS_int     <= AWID_MI0;
                 AWLEN_IS_int    <= AWLEN_MI0;
                 AWSIZE_IS_int   <= AWSIZE_MI0;
                 AWBURST_IS_int  <= AWBURST_MI0;
                 AWLOCK_IS_int   <= AWLOCK_MI0;
                 AWCACHE_IS_int  <= AWCACHE_MI0;
                 AWPROT_IS_int   <= AWPROT_MI0;
                 AWVALID_IS_int  <= AWVALID_MI0;    

                 AWREADY_IM0 <= AWREADY_SI;
                 AWREADY_IM1 <= 1'b0;
                 AWREADY_IM2 <= 1'b0;
                 AWREADY_IM3 <= 1'b0;

                 MST_WRGNT_NUM <= 4'b0001;
              end
              4'b0010 : begin 
          	     AWADDR_IS_int   <= AWADDR_MI1;
                 AWID_IS_int     <= AWID_MI1;
                 AWLEN_IS_int    <= AWLEN_MI1;
                 AWSIZE_IS_int   <= AWSIZE_MI1;
                 AWBURST_IS_int  <= AWBURST_MI1;
                 AWLOCK_IS_int   <= AWLOCK_MI1;
                 AWCACHE_IS_int  <= AWCACHE_MI1;
                 AWPROT_IS_int   <= AWPROT_MI1;
                 AWVALID_IS_int  <= AWVALID_MI1;    

                 AWREADY_IM0 <= 1'b0;
                 AWREADY_IM1 <= AWREADY_SI;
                 AWREADY_IM2 <= 1'b0;
                 AWREADY_IM3 <= 1'b0;

                 MST_WRGNT_NUM <= 4'b0010;
              end
              4'b0100 : begin 
                 AWADDR_IS_int   <= AWADDR_MI2;
   		         AWID_IS_int     <= AWID_MI2;
                 AWLEN_IS_int    <= AWLEN_MI2;
                 AWSIZE_IS_int   <= AWSIZE_MI2;
                 AWBURST_IS_int  <= AWBURST_MI2;
                 AWLOCK_IS_int   <= AWLOCK_MI2;
                 AWCACHE_IS_int  <= AWCACHE_MI2;
                 AWPROT_IS_int   <= AWPROT_MI2;
                 AWVALID_IS_int  <= AWVALID_MI2;    

                 AWREADY_IM0 <= 1'b0;
                 AWREADY_IM1 <= 1'b0;
                 AWREADY_IM2 <= AWREADY_SI;
                 AWREADY_IM3 <= 1'b0;

                 MST_WRGNT_NUM <= 4'b0100;
              end
              4'b1000 : begin 
          	     AWADDR_IS_int   <= AWADDR_MI3;
                 AWID_IS_int     <= AWID_MI3;
                 AWLEN_IS_int    <= AWLEN_MI3;
                 AWSIZE_IS_int   <= AWSIZE_MI3;
                 AWBURST_IS_int  <= AWBURST_MI3;
                 AWLOCK_IS_int   <= AWLOCK_MI3;
                 AWCACHE_IS_int  <= AWCACHE_MI3;
                 AWPROT_IS_int   <= AWPROT_MI3;
                 AWVALID_IS_int  <= AWVALID_MI3;    

                 AWREADY_IM0 <= 1'b0;
                 AWREADY_IM1 <= 1'b0;
                 AWREADY_IM2 <= 1'b0;
                 AWREADY_IM3 <= AWREADY_SI;

                 MST_WRGNT_NUM <= 4'b1000;
              end
              default : begin 
                 AWID_IS_int     <= 'h0;
                 AWLEN_IS_int    <= 'h0;
                 AWSIZE_IS_int   <= 'h0;
                 AWBURST_IS_int  <= 'h0;
                 AWLOCK_IS_int   <= 'h0;
                 AWCACHE_IS_int  <= 'h0;
                 AWPROT_IS_int   <= 'h0;
                 AWVALID_IS_int  <= 'h0;    

                 AWREADY_IM0 <= 1'b0;
                 AWREADY_IM1 <= 1'b0;
                 AWREADY_IM2 <= 1'b0;
                 AWREADY_IM3 <= 1'b0;

                 MST_WRGNT_NUM <= 4'b0000;
              end
            endcase // case (AW_MASGNT_IC)       
         end // else: !if(!ARESETN)         
         end // always @ (*)      
      end // if (NUM_MASTER_SLOT == 4)
   endgenerate


   // --------------------------------------------------------------------------
   // Select Slave slot for Write
   // --------------------------------------------------------------------------
   always @ (*) begin
      if(AWVALID_M0 == 1'b1 && AWADDR_M0[31] == 1'b1) begin
         SLAVE_SELECT_WRITE_M0 = SLAVE_N;
      end
      else begin         
      case ({AWVALID_M0,AWADDR_M0[AXI_AWIDTH - 1:AXI_AWIDTH - 4]})
        5'h10, 5'h18 : begin
           SLAVE_SELECT_WRITE_M0 = SLAVE_0;
        end

        5'h11, 5'h19 : begin
           SLAVE_SELECT_WRITE_M0 = SLAVE_1;
        end

        5'h12, 5'h1A : begin
           SLAVE_SELECT_WRITE_M0 = SLAVE_2;
        end

        5'h13, 5'h1B : begin
           SLAVE_SELECT_WRITE_M0 = SLAVE_3;
        end

        5'h14, 5'h1C : begin
           SLAVE_SELECT_WRITE_M0 = SLAVE_4;
        end

        5'h15, 5'h1D : begin
           SLAVE_SELECT_WRITE_M0 = SLAVE_5;
        end

        5'h16, 5'h1E : begin
           SLAVE_SELECT_WRITE_M0 = SLAVE_6;
        end

        5'h17, 5'h1F : begin
           SLAVE_SELECT_WRITE_M0 = SLAVE_7;
        end

        default : begin SLAVE_SELECT_WRITE_M0 = 17'h00000; end
      endcase // case ({AWVALID_MI0,AWADDR_MI0[AXI_AWIDTH - 1:AXI_AWIDTH-4]})
      end // else: !if(AWADDR_M0[31] == 1'b0)      
   end // always @ (*)

   // --------------------------------------------------------------------------
   // Select Slave slot for Write
   // --------------------------------------------------------------------------
   always @ (*) begin
      if(AWVALID_M1 == 1'b1 && AWADDR_M1[31] == 1'b1) begin
         SLAVE_SELECT_WRITE_M1 = SLAVE_N;
      end
      else begin         
      case ({AWVALID_M1,AWADDR_M1[AXI_AWIDTH - 1:AXI_AWIDTH - 4]})
        5'h10, 5'h18 : begin
           SLAVE_SELECT_WRITE_M1 = SLAVE_0;
        end

        5'h11, 5'h19 : begin
           SLAVE_SELECT_WRITE_M1 = SLAVE_1;
        end

        5'h12, 5'h1A : begin
           SLAVE_SELECT_WRITE_M1 = SLAVE_2;
        end

        5'h13, 5'h1B : begin
           SLAVE_SELECT_WRITE_M1 = SLAVE_3;
        end

        5'h14, 5'h1C : begin
           SLAVE_SELECT_WRITE_M1 = SLAVE_4;
        end

        5'h15, 5'h1D : begin
           SLAVE_SELECT_WRITE_M1 = SLAVE_5;
        end

        5'h16, 5'h1E : begin
           SLAVE_SELECT_WRITE_M1 = SLAVE_6;
        end

        5'h17, 5'h1F : begin
           SLAVE_SELECT_WRITE_M1 = SLAVE_7;
        end

        default : begin SLAVE_SELECT_WRITE_M1 = 17'h00000; end
      endcase // case ({AWVALID_MI0,AWADDR_MI0[AXI_AWIDTH - 1:AXI_AWIDTH-4]})
      end // else: !if(AWADDR_M1[31] == 1'b0)     
   end // always @ (*)
      
   // --------------------------------------------------------------------------
   // Select Slave slot for Write
   // --------------------------------------------------------------------------
   always @ (*) begin
      if(AWVALID_M2 == 1'b1 && AWADDR_M2[31] == 1'b1) begin
         SLAVE_SELECT_WRITE_M2 = SLAVE_N;
      end
      else begin         
      case ({AWVALID_M2,AWADDR_M2[AXI_AWIDTH - 1:AXI_AWIDTH - 4]})
        5'h10, 5'h18 : begin
           SLAVE_SELECT_WRITE_M2 = SLAVE_0;
        end

        5'h11, 5'h19 : begin
           SLAVE_SELECT_WRITE_M2 = SLAVE_1;
        end

        5'h12, 5'h1A : begin
           SLAVE_SELECT_WRITE_M2 = SLAVE_2;
        end

        5'h13, 5'h1B : begin
           SLAVE_SELECT_WRITE_M2 = SLAVE_3;
        end

        5'h14, 5'h1C : begin
           SLAVE_SELECT_WRITE_M2 = SLAVE_4;
        end

        5'h15, 5'h1D : begin
           SLAVE_SELECT_WRITE_M2 = SLAVE_5;
        end

        5'h16, 5'h1E : begin
           SLAVE_SELECT_WRITE_M2 = SLAVE_6;
        end

        5'h17, 5'h1F : begin
           SLAVE_SELECT_WRITE_M2 = SLAVE_7;
        end

        default : begin SLAVE_SELECT_WRITE_M2 = 17'h00000; end
      endcase // case ({AWVALID_MI0,AWADDR_MI0[AXI_AWIDTH - 1:AXI_AWIDTH-4]})
      end // else: !if(AWADDR_M2[31] == 1'b1)      
   end // always @ (*)

   // --------------------------------------------------------------------------
   // Select Slave slot for Write
   // --------------------------------------------------------------------------
   always @ (*) begin
      if(AWVALID_M3 == 1'b1 && AWADDR_M3[31] == 1'b1) begin
         SLAVE_SELECT_WRITE_M3 = SLAVE_N;
      end
      else begin         
      case ({AWVALID_M3,AWADDR_M3[AXI_AWIDTH - 1:AXI_AWIDTH - 4]})
        5'h10, 5'h18 : begin
           SLAVE_SELECT_WRITE_M3 = SLAVE_0;
        end

        5'h11, 5'h19 : begin
           SLAVE_SELECT_WRITE_M3 = SLAVE_1;
        end

        5'h12, 5'h1A : begin
           SLAVE_SELECT_WRITE_M3 = SLAVE_2;
        end

        5'h13, 5'h1B : begin
           SLAVE_SELECT_WRITE_M3 = SLAVE_3;
        end

        5'h14, 5'h1C : begin
           SLAVE_SELECT_WRITE_M3 = SLAVE_4;
        end

        5'h15, 5'h1D : begin
           SLAVE_SELECT_WRITE_M3 = SLAVE_5;
        end

        5'h16, 5'h1E : begin
           SLAVE_SELECT_WRITE_M3 = SLAVE_6;
        end

        5'h17, 5'h1F : begin
           SLAVE_SELECT_WRITE_M3 = SLAVE_7;
        end

        default : begin SLAVE_SELECT_WRITE_M3 = 17'h00000; end
      endcase // case ({AWVALID_MI3,AWADDR_MI3[AXI_AWIDTH - 1:AXI_AWIDTH-4]})
      end // else: !if(AWADDR_M3[31] == 1'b1)      
   end // always @ (*)

   //---------------------------------------------------------------------------
   // Generate the write requests to the arbiter 
   //---------------------------------------------------------------------------
   always @(posedge ACLK or negedge aresetn) begin
      if((!aresetn) || (!sresetn)) begin
         AW_REQ_MI0 <= 'h0;
         AW_REQ_MI1 <= 'h0;
         AW_REQ_MI2 <= 'h0;
         AW_REQ_MI3 <= 'h0;
      end
      else begin
         AW_REQ_MI0 <= ((| SLAVE_SELECT_WRITE_M0) & ((SLAVE_NUMBER[3:0] == AWADDR_M0[AXI_AWIDTH - 1:AXI_AWIDTH - 4] & AWADDR_M0[31] == 1'b0) | ((SLAVE_NUMBER[4] == 1'b1) & (AWADDR_M0[31] == 1'b1))));
         AW_REQ_MI1 <= ((| SLAVE_SELECT_WRITE_M1) & ((SLAVE_NUMBER[3:0] == AWADDR_M1[AXI_AWIDTH - 1:AXI_AWIDTH - 4] & AWADDR_M1[31] == 1'b0) | ((SLAVE_NUMBER[4] == 1'b1) & (AWADDR_M1[31] == 1'b1))));
         AW_REQ_MI2 <= ((| SLAVE_SELECT_WRITE_M2) & ((SLAVE_NUMBER[3:0] == AWADDR_M2[AXI_AWIDTH - 1:AXI_AWIDTH - 4] & AWADDR_M2[31] == 1'b0) | ((SLAVE_NUMBER[4] == 1'b1) & (AWADDR_M2[31] == 1'b1))));
         AW_REQ_MI3 <= ((| SLAVE_SELECT_WRITE_M3) & ((SLAVE_NUMBER[3:0] == AWADDR_M3[AXI_AWIDTH - 1:AXI_AWIDTH - 4] & AWADDR_M3[31] == 1'b0) | ((SLAVE_NUMBER[4] == 1'b1) & (AWADDR_M3[31] == 1'b1))));
       end
   end
   

   always @ (*) begin
      if(AWVALID_IS == 1'b1 && AWADDR_IS[31] == 1'b1) begin
         SLAVE_SELECT_WADDRCH_M = SLAVE_N;
      end
      else begin         
      case ({AWVALID_IS,AWADDR_IS[AXI_AWIDTH - 1:AXI_AWIDTH-4]})
        5'h10, 5'h18 : begin
           SLAVE_SELECT_WADDRCH_M = SLAVE_0;
        end

        5'h11, 5'h19 : begin
           SLAVE_SELECT_WADDRCH_M = SLAVE_1;
        end

        5'h12, 5'h1A : begin
           SLAVE_SELECT_WADDRCH_M = SLAVE_2;
        end

        5'h13, 5'h1B : begin
           SLAVE_SELECT_WADDRCH_M = SLAVE_3;
        end

        5'h14, 5'h1C : begin
           SLAVE_SELECT_WADDRCH_M = SLAVE_4;
        end

        5'h15, 5'h1D : begin
           SLAVE_SELECT_WADDRCH_M = SLAVE_5;
        end

        5'h16, 5'h1E : begin
           SLAVE_SELECT_WADDRCH_M = SLAVE_6;
        end

        5'h17, 5'h1F : begin
           SLAVE_SELECT_WADDRCH_M = SLAVE_7;
        end

        default : begin SLAVE_SELECT_WADDRCH_M = SLAVE_SELECT_WADDRCH_M_r; end
      endcase
      end // else: !if(AWADDR_IS[31] == 1'b1)      
   end // always @ (*)   

   // Latch Write data channel signals
   always @(posedge ACLK or negedge aresetn) begin
      if((!aresetn) || (!sresetn)) begin
	     SLAVE_SELECT_WADDRCH_M_r  <=  'h0;
      end
      else begin
	     SLAVE_SELECT_WADDRCH_M_r  <= SLAVE_SELECT_WADDRCH_M;
      end
   end   

endmodule // wrmatrix_4Mto1S_hgs_high




   /////////////////////////////////////////////////////////////////////////////
   //                               End - of - Code                           //
   /////////////////////////////////////////////////////////////////////////////


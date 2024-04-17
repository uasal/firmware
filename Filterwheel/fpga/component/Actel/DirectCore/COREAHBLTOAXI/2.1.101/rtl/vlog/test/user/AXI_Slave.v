// ********************************************************************/
// Actel Corporation Proprietary and Confidential
// Copyright 2010 Actel Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description:	
//
// Revision Information:
// Date			Description
// ----			-----------------------------------------
// 04AUG10		Production Release Version 1.0
//
// SVN Revision Information:
// SVN $Revision: $
// SVN $Date: $
//
// Resolved SARs
// SAR      Date     Who   Description
//
// Notes: 
//
// *********************************************************************/
`timescale 1ns/1ps
module AXI_Slave ( 
     // AXI Interface
          ACLK,
          AWID,
          AWADDR,
          AWLEN,
          AWSIZE,
          AWBURST,
          AWLOCK,
          AWVALID,
          //RWM,
          AWREADY,
          WID,
          WDATA,
          WSTRB,
          WLAST,
          WVALID,
          WREADY,
          BREADY,
          BID,
          BRESP,
          BVALID,
          ARID,
          ARADDR,
          ARLEN,
          ARSIZE,
          ARBURST,
          ARLOCK,
          ARVALID,
          ARREADY,
          RREADY,
          RID,
          RDATA,
          RRESP,
          RLAST,
          RVALID
         );

//---------------------------------------------------
// Global parameters
//---------------------------------------------------
  parameter   AXI_AWIDTH   = 32; 
  parameter   AXI_DWIDTH   = 64; 
  parameter   UNDEF_BURST  = 0;  // if '0' then single transter else INCR16
  
  localparam  AXI_WRSTB    = AXI_DWIDTH / 8;

//---------------------------------------------------
// Input-Output Ports
//---------------------------------------------------
  // Inputs on AXI Interface
  output                    AWREADY;
  output                    WREADY;
  output[3:0]               BID;
  output[1:0]               BRESP;
  output                    BVALID;
  output                    ARREADY;
  output[3:0]               RID;
  output[AXI_DWIDTH-1:0]    RDATA;
  output[1:0]               RRESP;
  output                    RLAST;
  output                    RVALID;

  // Outputs on AXI Interface
  input                     ACLK;
  input  [3:0]              AWID;
  input  [AXI_AWIDTH-1:0]   AWADDR;
  input  [3:0]              AWLEN;
  input  [2:0]              AWSIZE;
  input  [1:0]              AWBURST;
  input                     AWVALID;
//  input                     RWM;
  input  [3:0]              WID;
  input  [AXI_DWIDTH-1:0]   WDATA;
  input  [AXI_WRSTB-1:0]    WSTRB;
  input                     WLAST;
  input                     WVALID;
  input                     BREADY;
  input  [3:0]              ARID;
  input  [AXI_AWIDTH-1:0]   ARADDR;
  input  [3:0]              ARLEN;
  input  [2:0]              ARSIZE;
  input  [1:0]              ARBURST;
  input  [1:0]              ARLOCK;
  input                     ARVALID;
  input                     RREADY;
  input  [1:0]              AWLOCK; 
  

  reg                     AWREADY;
  reg                     WREADY;
  reg [3:0]               BID;
  reg [1:0]               BRESP;
  reg                     BVALID;
  reg                     ARREADY;
  reg [3:0]               RID;
  reg [AXI_DWIDTH-1:0]    RDATA;
  reg [1:0]               RRESP;
  reg                     RLAST;
  reg                     RVALID;

  reg [3:0]              ARID_d;
  reg [AXI_AWIDTH-1:0]   ARADDR_d;
  reg [3:0]              ARLEN_d;
  reg [1:0]              ARSIZE_d;
  reg [1:0]              ARBURST_d;
  reg [1:0]              ARLOCK_d;
  reg [31:0]             rdata_lsb;
  reg [31:0]             rdata_msb;
  reg [AXI_DWIDTH-1:0]    rd_data;


  //---------------------------------------------------------------------------
  // Initial value declarations
  //---------------------------------------------------------------------------
  initial begin
    AWREADY = 1'b0;
    WREADY = 1'b1;
    BVALID = 1'b0;
    ARREADY = 1'b0;
    RVALID = 1'b0;
    RLAST = 1'b0;
    RRESP = 2'b00;
    RID   = 4'b0000;
    BID   = 4'b0000;
    //axi_write;
    //axi_read;
    //axi_read;
  end
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------

  task axi_write;
    input [1:0]   wr_resp; 
    begin
      wait (AWVALID);
      @ (posedge ACLK);
      @ (posedge ACLK);
      @ (posedge ACLK);
      @ (posedge ACLK);
      @ (posedge ACLK);
      AWREADY = 1'b1;
      @ (posedge ACLK);
      AWREADY = 1'b0;
      wait (WLAST);
      @ (posedge ACLK);
      BRESP = 2'b00; // OKAY resp
      BVALID = 1'b1;
      @ (posedge ACLK);
      BVALID = 1'b0;
      BRESP = 2'b00; 
    end
  endtask  // axi_write

  task axi_read;
    input [1:0]   rd_resp; 
    integer i;
    reg     low;
    reg [3:0] incr;
    begin
      wait (ARVALID);
      @ (posedge ACLK);
      @ (posedge ACLK);
      @ (posedge ACLK);
      @ (posedge ACLK);
      @ (posedge ACLK);
      ARREADY = 1'b1;
      ARID_d[3:0]    = ARID;
      ARADDR_d[AXI_AWIDTH-1:0]  = ARADDR;
      ARLEN_d[3:0]   = ARLEN;
      ARSIZE_d[1:0]  = ARSIZE[1:0];
      ARBURST_d[1:0] = ARBURST;
      ARLOCK_d  = ARLOCK;
      @ (posedge ACLK);
      ARREADY = 1'b0;
      for (i=0;i<=ARLEN_d;i=i+1) begin
        wait (RREADY);
        if (i == ARLEN_d) begin
          RLAST = 1'b1;
        end
        RVALID = 1'b1;
        //RDATA = 64'hAABB_CCDD_FFEE_55A5 + i;
        rdata_msb = $random;
        rdata_lsb = $random;
        low = 1'b0;
        case(ARSIZE_d)
          2'b11: rd_data = {rdata_msb,rdata_lsb};
          2'b10: if (ARADDR_d[2:0] == 3'b000) begin
                   rd_data = {{32{low}},rdata_lsb[31:0]};
                 end 
                 else if (ARADDR_d[2:0] == 3'b100) begin
                   rd_data = {rdata_msb[31:0],{32{low}}};
                 end 
          2'b01: if (ARADDR_d[2:1] == 2'b00) begin
                   rd_data = {{48{low}},rdata_lsb[15:0]};
                 end 
                 else if (ARADDR_d[2:1] == 2'b01) begin
                   rd_data = {{32{low}},rdata_lsb[15:0],{16{low}}};
                 end 
                 else if (ARADDR_d[2:1] == 2'b10) begin
                   rd_data = {{16{low}},rdata_lsb[15:0],{32{low}}};
                 end 
                 else if (ARADDR_d[2:1] == 2'b11) begin
                   rd_data = {rdata_lsb[15:0],{48{low}}};
                 end 
          2'b00: if (ARADDR_d[2:0] == 3'b000) begin
                   rd_data = {{56{low}},rdata_lsb[7:0]};
                 end 
                 else if (ARADDR_d[2:0] == 3'b001) begin
                   rd_data = {{48{low}},rdata_lsb[7:0],{8{low}}};
                 end 
                 else if (ARADDR_d[2:0] == 3'b010) begin
                   rd_data = {{40{low}},rdata_lsb[7:0],{16{low}}};
                 end 
                 else if (ARADDR_d[2:0] == 3'b011) begin
                   rd_data = {{32{low}},rdata_lsb[7:0],{24{low}}};
                 end 
                 else if (ARADDR_d[2:0] == 3'b100) begin
                   rd_data = {{24{low}},rdata_lsb[7:0],{32{low}}};
                 end 
                 else if (ARADDR_d[2:0] == 3'b101) begin
                   rd_data = {{16{low}},rdata_lsb[7:0],{40{low}}};
                 end 
                 else if (ARADDR_d[2:0] == 3'b110) begin
                   rd_data = {{8{low}},rdata_lsb[7:0],{48{low}}};
                 end 
                 else if (ARADDR_d[2:0] == 3'b111) begin
                   rd_data = {rdata_lsb[7:0],{56{low}}};
                 end 
        endcase
        case(ARSIZE_d)
          2'b00: incr = 4'b0001;
          2'b01: incr = 4'b0010;
          2'b10: incr = 4'b0100;
          2'b11: incr = 4'b1000;
        endcase
        RDATA = rd_data;
        ARADDR_d = ARADDR_d + incr; 
        @ (posedge ACLK);
      end
      RLAST = 1'b0;
      RVALID = 1'b0;
    end
  endtask  // axi_read


endmodule
//-----------------------------------------------------------------------------
// File End
//-----------------------------------------------------------------------------

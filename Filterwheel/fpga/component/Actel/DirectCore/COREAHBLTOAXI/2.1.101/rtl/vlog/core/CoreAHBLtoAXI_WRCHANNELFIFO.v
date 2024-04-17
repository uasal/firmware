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
// Notes: Asynchronous fifo implementation
//
// *********************************************************************/

module CoreAHBLtoAXI_WRCHANNELFIFOHX #(
  parameter   AHB_DWIDTH = 32, //  AHB bus Data Width
  parameter   AXI_DWIDTH = 64, //  AXI bus Data Width
  parameter   AWIDTH     = 8  //  Address Width
 )
(
//Inputs
input                   wrrst_n,
input                   wrclk,
input                   wrinr,
input  [AHB_DWIDTH-1:0] wrdata,

input                   rdrst_n,
input                   rdclk,
input                   rdinr,
input                   valid_ahbcmd,
input                   ahb_busyidle_cyc,

//Outputs
output [AXI_DWIDTH-1:0] rddata,
output reg              fifo_full,
output reg              fifo_empty
);

//-----------------------------------------------------------------------------
// Register Declarations
//-----------------------------------------------------------------------------
reg  [AWIDTH:0]         rbinaddr;
reg  [AWIDTH:0]         raddr_gray;    // Gray read address goes to write logic
reg  [AWIDTH:0]         wbinaddr;
reg  [AWIDTH:0]         waddr_gray;    // Gray write address goes to read logic
reg  [AWIDTH:0]         wsync1_rptr;   
reg  [AWIDTH:0]         wsync2_rptr;   // Synchronized read pointer in write domain
reg  [AWIDTH:0]         rsync1_wptr;   
reg  [AWIDTH:0]         rsync2_wptr;   // Synchronized write pointer in read domain
reg                     wren_2;
reg                     rdinr_d;
reg [AXI_DWIDTH-1:0]    rddata_r;
//-----------------------------------------------------------------------------
// Wire Declarations
//-----------------------------------------------------------------------------
wire                     rden_1;
wire                     rden_2;
wire [AWIDTH-1:0]        raddr;         // Read binary address goes to RAM
wire [AWIDTH:0]          rgraynext;
wire [AWIDTH:0]          rbinnext;
wire [AWIDTH-1:0]        waddr;         // Write binary address goes to RAM
wire [AWIDTH:0]          wgraynext;
wire [AWIDTH:0]          wbinnext;

wire                     writefull;     
wire                     wren_1;
wire [AXI_DWIDTH-1:0]    rddata_c;

///////////////////////////////////////////////////////////////////////////////
//                         Start-of-code                                     //
///////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// Read Pointer Generation
// Read pointer is a dual n-bit gray code counter. The n-bit pointer is passed
// to the write clock domain through double synchronizer. n-1 bit pointer is
// used to address the fifo buffer.
//-----------------------------------------------------------------------------
always @ (posedge rdclk or negedge rdrst_n) begin : Read_Bin_Ptr
  if (rdrst_n == 1'b0) begin
    rbinaddr <= {AWIDTH+1{1'b0}};
  end
  else if (valid_ahbcmd == 1'b1) begin
    rbinaddr <= {AWIDTH+1{1'b0}};
  end
  else begin
    rbinaddr <= rbinnext[AWIDTH:0];
  end
end

assign raddr = rbinaddr[AWIDTH-1:0];

assign rbinnext = rbinaddr + (rdinr & !fifo_empty);
assign rgraynext = (rbinnext>>1) ^ rbinnext;

always @ (posedge rdclk or negedge rdrst_n) begin : Read_Gray_Ptr
  if (rdrst_n == 1'b0) begin
    raddr_gray <= {AWIDTH+1{1'b0}};
  end
  else begin
    raddr_gray <= rgraynext[AWIDTH:0];
  end
end

//-----------------------------------------------------------------------------
// Read enable generation for two RAMs.
//-----------------------------------------------------------------------------
assign rden_1 = rdinr;
assign rden_2 = rdinr;

always @ (posedge rdclk or negedge rdrst_n) begin 
  if (rdrst_n == 1'b0) begin
    rdinr_d <= 1'b0;
  end
  else begin
    rdinr_d <= rdinr;
  end
end

//-----------------------------------------------------------------------------
// Write Pointer Generation
// Write pointer is a dual n-bit gray code counter. The n-bit pointer is passed
// to the read clock domain through double synchronizer. n-1 bit pointer is
// used to address the fifo buffer.
//-----------------------------------------------------------------------------
always @ (posedge wrclk or negedge wrrst_n) begin : Write_Bin_Ptr
  if (wrrst_n == 1'b0) begin
    wbinaddr <= {AWIDTH+1{1'b0}};
  end
  else if (valid_ahbcmd == 1'b1) begin
    wbinaddr <= {AWIDTH+1{1'b0}};
  end
  else begin
    wbinaddr <= wbinnext[AWIDTH:0];
  end
end

assign waddr = wbinaddr[AWIDTH-1:0];

assign wbinnext = wbinaddr + (wren_2 & wrinr & !ahb_busyidle_cyc & !fifo_full);
assign wgraynext = (wbinnext>>1) ^ wbinnext;

always @ (posedge wrclk or negedge wrrst_n) begin : Write_Gray_Ptr
  if (wrrst_n == 1'b0) begin
    waddr_gray <= {AWIDTH+1{1'b0}};
  end
  else begin
    waddr_gray <= wgraynext[AWIDTH:0];
  end
end

//-----------------------------------------------------------------------------
// Write enable generation for two RAMs.
//-----------------------------------------------------------------------------
always @ (posedge wrclk or negedge wrrst_n) begin : RAM_Write_En
  if (wrrst_n == 1'b0) begin
    wren_2 <= 1'b0;
  end
  else if (ahb_busyidle_cyc == 1'b1) begin
    wren_2 <= wren_2;
  end
  else if (wrinr == 1'b0) begin
    wren_2 <= 1'b0;
  end
  else if (wrinr == 1'b1) begin
    wren_2 <= !wren_2;
  end
end

assign wren_1 = wrinr & !wren_2;


//-----------------------------------------------------------------------------
// Synchronize Read gray pointer into Write domain
//-----------------------------------------------------------------------------
always @ (posedge wrclk or negedge wrrst_n) begin : Sync_Read_Ptr
  if (wrrst_n == 1'b0) begin
    wsync1_rptr <= {AWIDTH+1{1'b0}};
    wsync2_rptr <= {AWIDTH+1{1'b0}};
  end
  else begin
    wsync1_rptr <= raddr_gray[AWIDTH:0];
    wsync2_rptr <= wsync1_rptr;
  end
end

//-----------------------------------------------------------------------------
// Synchronize Write gray pointer into Read domain
//-----------------------------------------------------------------------------
always @ (posedge rdclk or negedge rdrst_n) begin : Sync_Write_Ptr
  if (rdrst_n == 1'b0) begin
    rsync1_wptr <= {AWIDTH+1{1'b0}};
    rsync2_wptr <= {AWIDTH+1{1'b0}};
  end
  else begin
    rsync1_wptr <= waddr_gray[AWIDTH:0];
    rsync2_wptr <= rsync1_wptr;
  end
end

//-----------------------------------------------------------------------------
// FIFO empty when the next read pointer equals the synchronized write pointer
// or on reset
//-----------------------------------------------------------------------------
always @ (posedge rdclk or negedge rdrst_n) begin : Gen_Empty
  if (rdrst_n == 1'b0) begin
    fifo_empty <= 1'b1;
  end
  else begin
    fifo_empty <= (rgraynext == rsync2_wptr);
  end
end

//-----------------------------------------------------------------------------
// Three conditions are necessary for fifo to be full:
// 1) write pointer and synchronized read pointer MSB's are not equal
// 2) wirte pointer and synchronized read pointer 2nd MSB's are not equal
// 3) all other bits of write pointer and synchronized write pointer must be equal
//-----------------------------------------------------------------------------
assign writefull = ((wgraynext[AWIDTH] != wsync2_rptr[AWIDTH]) && 
                    (wgraynext[AWIDTH-1] != wsync2_rptr[AWIDTH-1]) &&
                    (wgraynext[AWIDTH-2:0] == wsync2_rptr[AWIDTH-2:0]));

always @ (posedge rdclk or negedge rdrst_n) begin : Gen_Full
  if (rdrst_n == 1'b0) begin
    fifo_full <= 1'b0;
  end
  else begin
    fifo_full <= writefull;
  end
end

//-----------------------------------------------------------------------------
// Instantiate RAM module
//-----------------------------------------------------------------------------
CoreAHBLtoAXI_wrch_ramHX #(
          .ADDR_BIT            (AWIDTH),
          .WR_DATA_BIT         (AHB_DWIDTH),
          .RD_DATA_BIT         (AXI_DWIDTH)
           )      
  U_WRCH_RAM (
          //-------------------------------------  
          // RAM Interface details
          //-------------------------------------  
            // INPUT signals
              .WCLK             (wrclk)
            , .RCLK             (rdclk)
            , .WAddr            (waddr[3:0])
            , .RAddr            (raddr[3:0])
            , .We1              (wren_1)
            , .We2              (wren_2)
            , .Re1              (rden_1)
            , .Re2              (rden_2)
            , .Wfull            (fifo_full)
            , .Rempty           (fifo_empty)
            , .Wdata            (wrdata[AHB_DWIDTH-1:0])

            // OUTPUT signals
            , .Rdata            (rddata_c[AXI_DWIDTH-1:0])

     );

  assign rddata[AXI_DWIDTH-1:0] = (rdinr_d == 1'b1) ? rddata_c[AXI_DWIDTH-1:0] : rddata_r;

   always @ (posedge rdclk or negedge rdrst_n) begin
      if (rdrst_n == 1'b0) begin
        rddata_r  <= {AXI_DWIDTH{1'b0}};
      end
      else begin
        rddata_r  <= rddata;
      end
   end

endmodule

///////////////////////////////////////////////////////////////////////////////
//                         End-of-code                                       //
///////////////////////////////////////////////////////////////////////////////


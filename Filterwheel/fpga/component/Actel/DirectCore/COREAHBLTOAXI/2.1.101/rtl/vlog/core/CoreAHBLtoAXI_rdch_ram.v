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
// RAM module
module CoreAHBLtoAXI_rdch_ramHX (
                       WCLK
                     , RCLK
                     , WAddr
                     , RAddr
                     , We1
                     , Re1
                     , Wfull
                     , Rempty
                     , Wdata
                     , Rdata
                     );

//---------------------------------------------------
// Global parameters
//---------------------------------------------------
parameter   ADDR_BIT     = 32;
parameter   WR_DATA_BIT  = 32;
parameter   RD_DATA_BIT  = 32;

localparam  MEM_DATA_BIT = 32;
localparam  FDEPTH       = 16;
parameter   RAM_AWIDTH   = FDEPTH >> 2;

//---------------------------------------------------
// Input-Output Ports
//---------------------------------------------------
input                    WCLK;
input                    RCLK;
input  [RAM_AWIDTH-1:0]  WAddr;
input  [RAM_AWIDTH-1:0]  RAddr;
input                    We1;
input                    Re1;
input                    Wfull;
input                    Rempty;
input  [WR_DATA_BIT-1:0] Wdata;

output [RD_DATA_BIT-1:0] Rdata;


//-----------------------------------------------------------------------------
// Register Declarations
//-----------------------------------------------------------------------------
reg    [RD_DATA_BIT-1:0]  Rdata;
reg    [MEM_DATA_BIT-1:0] mem1 [0:(FDEPTH-1)];

///////////////////////////////////////////////////////////////////////////////
//                         Start-of-code                                     //
///////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// Memory-1 Write and Read logic
//-----------------------------------------------------------------------------
always @ (posedge WCLK) begin
   if ((We1 == 1'b1) && (Wfull == 1'b0)) begin
      mem1[WAddr] <= Wdata[31:0];
   end
end

always @ (posedge RCLK) begin
   if (Re1 == 1'b1) begin
      Rdata[31:0] <= mem1[RAddr];
   end
   else begin
      Rdata[31:0] <= 32'b0;
   end
end

   
endmodule // rdch_ramHX

///////////////////////////////////////////////////////////////////////////////
//                         End-of-code                                       //
///////////////////////////////////////////////////////////////////////////////



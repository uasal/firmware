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
// Synchronizer - here clock and reset should be destination clock and reset
module Synchronizer_AXItoAHBHX (
                       ACLK
                     , HCLK
                     , ARESETn
                     , HRESETn
                     , Din_0
                     , Dout_0
                     , Din_1
                     , Dout_1
                     );

//---------------------------------------------------
// Input-Output Ports
//---------------------------------------------------
input                   ACLK;
input                   HCLK;
input                   ARESETn;
input                   HRESETn;
input                   Din_0;    // Input signal from source domain
output                  Dout_0;   // Output of Synchronizer into destination domain
input                   Din_1;    // Input signal from source domain
output                  Dout_1;   // Output of Synchronizer into destination domain

//-----------------------------------------------------------------------------
// Register Declarations
//-----------------------------------------------------------------------------
reg [1:0]        synchronizer_0;
reg [1:0]        synchronizer_1;
reg              pre_sync_0_reg;
reg              pre_sync_1_reg;
reg              post_sync_0_reg;
reg              post_sync_1_reg;

//-----------------------------------------------------------------------------
// Wire Declarations
//-----------------------------------------------------------------------------
wire             sync_out_0;
wire             sync_out_1;


///////////////////////////////////////////////////////////////////////////////
//                         Start-of-code                                     //
///////////////////////////////////////////////////////////////////////////////

always @ (posedge ACLK or negedge ARESETn) begin
   if (ARESETn == 1'b0) begin
     pre_sync_0_reg <= 1'b0;
   end
   else begin
     if (Din_0 == 1'b1) begin
       pre_sync_0_reg <= ~pre_sync_0_reg;
     end 
     else begin
       pre_sync_0_reg <= pre_sync_0_reg;
     end
   end
end

always @ (posedge HCLK or negedge HRESETn) begin
   if (HRESETn == 1'b0) begin
     synchronizer_0[1:0] <= 2'b00;
   end
   else begin
     synchronizer_0[1:0] <= {pre_sync_0_reg, synchronizer_0[1]};
   end
end

assign sync_out_0 = synchronizer_0[0];

always @ (posedge HCLK or negedge HRESETn) begin
   if (HRESETn == 1'b0) begin
     post_sync_0_reg <= 1'b0;
   end
   else begin
     post_sync_0_reg <= sync_out_0;
   end
end

assign Dout_0 = sync_out_0 ^ post_sync_0_reg;

//--------------------------------------------------------------------------
//--------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn) begin
   if (ARESETn == 1'b0) begin
     pre_sync_1_reg <= 1'b0;
   end
   else begin
     if (Din_1 == 1'b1) begin
       pre_sync_1_reg <= ~pre_sync_1_reg;
     end 
     else begin
       pre_sync_1_reg <= pre_sync_1_reg;
     end
   end
end

always @ (posedge HCLK or negedge HRESETn) begin
   if (HRESETn == 1'b0) begin
     synchronizer_1[1:0] <= 2'b00;
   end
   else begin
     synchronizer_1[1:0] <= {pre_sync_1_reg, synchronizer_1[1]};
   end
end

assign sync_out_1 = synchronizer_1[0];

always @ (posedge HCLK or negedge HRESETn) begin
   if (HRESETn == 1'b0) begin
     post_sync_1_reg <= 1'b0;
   end
   else begin
     post_sync_1_reg <= sync_out_1;
   end
end

assign Dout_1 = sync_out_1 ^ post_sync_1_reg;



endmodule

///////////////////////////////////////////////////////////////////////////////
//                         End-of-code                                       //
///////////////////////////////////////////////////////////////////////////////



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
// Double Synchronizer - here clock and reset should be destination clock and reset
module Synchronizer_AHBtoAXIHX (
                       CLK
                     , rstn
                     , Din_0
                     , Dout_0
                     , Din_1
                     , Dout_1
                     , Din_2
                     , Dout_2
                     , Din_3
                     , Dout_3
                     );

//---------------------------------------------------
// Input-Output Ports
//---------------------------------------------------
input                   CLK;
input                   rstn;
input                   Din_0;    // Input signal from source domain
output                  Dout_0;   // Output of Synchronizer into destination domain
input                   Din_1;    // Input signal from source domain
output                  Dout_1;   // Output of Synchronizer into destination domain
input                   Din_2;    // Input signal from source domain
output                  Dout_2;   // Output of Synchronizer into destination domain
input                   Din_3;    // Input signal from source domain
output                  Dout_3;   // Output of Synchronizer into destination domain

//-----------------------------------------------------------------------------
// Register Declarations
//-----------------------------------------------------------------------------
reg [1:0]        synchronizer_0;
reg [1:0]        synchronizer_1;
reg [1:0]        synchronizer_2;
reg [1:0]        synchronizer_3;

///////////////////////////////////////////////////////////////////////////////
//                         Start-of-code                                     //
///////////////////////////////////////////////////////////////////////////////

always @ (posedge CLK or negedge rstn) begin
   if (rstn == 1'b0) begin
     synchronizer_0[1:0] <= 2'b00;
     synchronizer_1[1:0] <= 2'b00;
     synchronizer_2[1:0] <= 2'b00;
     synchronizer_3[1:0] <= 2'b00;
   end
   else begin
     synchronizer_0[1:0] <= {Din_0, synchronizer_0[1]};
     synchronizer_1[1:0] <= {Din_1, synchronizer_1[1]};
     synchronizer_2[1:0] <= {Din_2, synchronizer_2[1]};
     synchronizer_3[1:0] <= {Din_3, synchronizer_3[1]};
   end
end

assign Dout_0 = synchronizer_0[0];
assign Dout_1 = synchronizer_1[0];
assign Dout_2 = synchronizer_2[0];
assign Dout_3 = synchronizer_3[0];

endmodule

///////////////////////////////////////////////////////////////////////////////
//                         End-of-code                                       //
///////////////////////////////////////////////////////////////////////////////


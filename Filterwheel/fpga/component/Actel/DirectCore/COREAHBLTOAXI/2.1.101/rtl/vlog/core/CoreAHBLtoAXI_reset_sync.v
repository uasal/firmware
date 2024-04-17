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

module CoreAHBLtoAXI_reset_syncHX (
          CLK,
          RESETINn,
          RESETOUTn
    );

input       CLK;
input       RESETINn;
output      RESETOUTn;

//-----------------------------------------------------------------------------
// Register Declarations
//-----------------------------------------------------------------------------
  reg reset_sync_1;
  reg reset_sync_2;

///////////////////////////////////////////////////////////////////////////////
//                         Start-of-code                                     //
///////////////////////////////////////////////////////////////////////////////

  always @ (posedge CLK or negedge RESETINn) begin : reset_sync_logic
     if (RESETINn == 1'b0) begin
        reset_sync_1 <= 1'b0;
        reset_sync_2 <= 1'b0;
     end else begin
        reset_sync_1 <= reset_sync_2;
        reset_sync_2 <= 1'b1;
     end

  end

  assign RESETOUTn = reset_sync_1;


endmodule

///////////////////////////////////////////////////////////////////////////////
//                         End-of-code                                       //
///////////////////////////////////////////////////////////////////////////////



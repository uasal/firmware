`timescale 1ns / 1ps
// ********************************************************************/
// Actel Corporation Proprietary and Confidential
// Copyright 2010 Actel Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description:This module generates clocks for AXI_Master
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


module clkgen(
    ACLK,
    ARESETN
);

parameter AXICLK =2;

output ACLK;
output ARESETN;

reg ACLK;
reg ARESETN;

initial begin
    ACLK=0;
end

task reset;
input[31:0] delay;
begin
    ARESETN=0;
    #delay;
    ARESETN=1;
end
endtask

    always #AXICLK ACLK= ~ACLK;

 endmodule

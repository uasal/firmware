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
//`define CORETOP       Tb_CoreAHBLtoAXI.U_CoreAHBLtoAXI
module checker (
          HCLK,
          HSEL,
          HWRITE,
          HBURST,
          HSIZE,
          HADDR,
          HTRANS,
          HWDATA,
          HRDATA,
          HREADYOUT,
          HREADY,
          WSTRB,
          ACLK,
          WDATA,
          RDATA,
          RVALID,
          WLAST,
          WVALID
    );

//---------------------------------------------------
// Global parameters
//---------------------------------------------------
  parameter   AHB_AWIDTH   = 32; 
  parameter   AHB_DWIDTH   = 32; 
  parameter   AXI_DWIDTH   = 64; 
  parameter   UNDEF_BURST  = 0;  // if '0' then single transter else INCR16

  localparam  AXI_WRSTB    = AXI_DWIDTH / 8;

//---------------------------------------------------
// Input-Output Ports
//---------------------------------------------------
  // Inputs on the AHBL interface
  input                     HCLK;
  input                     HSEL;
  input                     ACLK;
  input                     HWRITE;
  input [1:0]               HTRANS;
  input [2:0]               HSIZE;
  input [AHB_AWIDTH-1:0]    HADDR;
  input [2:0]               HBURST;
  input [AHB_DWIDTH-1:0]    HWDATA;
  input [AHB_DWIDTH-1:0]    HRDATA;
  input                     WVALID;
  input                     RVALID;
  input                     WLAST;
  input [AXI_DWIDTH-1:0]    WDATA;
  input [AXI_DWIDTH-1:0]    RDATA;
  input                     HREADYOUT;
  input                     HREADY;
  input   [AXI_WRSTB-1:0]    WSTRB;
  
  `include "./defines.v"

  localparam   CH_DEPTH  =  128;

//-----------------------------------------------------------------------------
// Register Declarations
//-----------------------------------------------------------------------------
  reg [AHB_DWIDTH-1:0]  write_actual_mem [0:CH_DEPTH-1];
  reg [AHB_DWIDTH-1:0]  write_golden_mem [0:CH_DEPTH-1];
  reg [AHB_DWIDTH-1:0]  read_actual_mem [0:CH_DEPTH-1];
  reg [AHB_DWIDTH-1:0]  read_golden_mem [0:CH_DEPTH-1];
  wire [AHB_AWIDTH-1:0]  haddr_hsize;

reg [8*79:1]          pound_str,test_str;
//-----------------------------------------------------------------------------
// Wire Declarations
//-----------------------------------------------------------------------------
  integer adr_0, adr_00, ii, error_count_0;
  integer adr_1, adr_11, rr, error_count_1;
  integer error_count;


  initial begin
    adr_0       = 0;
    ii          = 0;
    adr_00      = 0;
    error_count_0 = 0;
    adr_1       = 0;
    rr          = 0;
    adr_11      = 0;
    error_count_1 = 0;
    error_count   = 0;
    pound_str           =
    "=============================================================================";
    test_str            =
    "#############################################################################";
  end


//#############################################################################
// AHB TO AXI WRITE OPERATION COMPARISION
//#############################################################################
  assign haddr_hsize = HADDR - (HSIZE[1:0] +1);
  always @(posedge HCLK) begin
    if ((HTRANS==SEQ || HTRANS == NONSEQ) && (HREADYOUT) && (HREADY) && HWRITE) begin
      case (HSIZE[1:0])
        2'b10: write_golden_mem[adr_0] = HWDATA[AHB_DWIDTH-1:0];
        2'b01: if (haddr_hsize[1:0] == 2'b00) begin
                 write_golden_mem[adr_0] = {16'h0000,HWDATA[15:0]};
               end 
               else if (haddr_hsize[1:0] == 2'b10) begin
                 write_golden_mem[adr_0] = {HWDATA[31:16],16'h0000};
               end
        2'b00: if (haddr_hsize[1:0] == 2'b00) begin
                 write_golden_mem[adr_0] = {24'h0000,HWDATA[7:0]};
               end 
               else if (haddr_hsize[1:0] == 2'b01) begin
                 write_golden_mem[adr_0] = {16'h0000,HWDATA[15:8],8'h00};
               end
               else if (haddr_hsize[1:0] == 2'b10) begin
                 write_golden_mem[adr_0] = {8'h00,HWDATA[23:16],16'h0000};
               end
               else if (haddr_hsize[1:0] == 2'b11) begin
                 write_golden_mem[adr_0] = {HWDATA[31:24],24'h000000};
               end
      endcase
      //write_golden_mem[adr_0] = HWDATA[AHB_DWIDTH-1:0];
        adr_0 = adr_0 + 1;
    end
  end

  always @(posedge ACLK) begin
    if (WVALID && HWRITE) begin
      case (WSTRB[3:0])
        4'b1111: write_actual_mem[adr_00] = WDATA[31:0];
        4'b0011: write_actual_mem[adr_00] = {16'h0000,WDATA[15:0]};
        4'b1100: write_actual_mem[adr_00] = {WDATA[31:16],16'h0000};
        4'b0001: write_actual_mem[adr_00] = {24'h0000,WDATA[7:0]};
        4'b0010: write_actual_mem[adr_00] = {16'h0000,WDATA[15:8],8'h00};
        4'b0100: write_actual_mem[adr_00] = {8'h00,WDATA[23:16],16'h0000};
        4'b1000: write_actual_mem[adr_00] = {WDATA[31:24],24'h0000};
      endcase 
      //write_actual_mem[adr_00] = WDATA[31:0];
        adr_00 = adr_00 + 1;
      //adr_00 = adr_00 + 1;
      if ((HBURST == SINGLE) || ((HBURST == INCR) && (UNDEF_BURST == 0))) begin 
      end
      else begin
        case (WSTRB[7:4])
          4'b1111: write_actual_mem[adr_00] = WDATA[63:32];
          4'b0011: write_actual_mem[adr_00] = {16'h0000,WDATA[47:32]};
          4'b1100: write_actual_mem[adr_00] = {WDATA[63:48],16'h0000};
          4'b0001: write_actual_mem[adr_00] = {24'h0000,WDATA[39:32]};
          4'b0010: write_actual_mem[adr_00] = {16'h0000,WDATA[47:40],8'h00};
          4'b0100: write_actual_mem[adr_00] = {8'h00,WDATA[55:48],16'h0000};
          4'b1000: write_actual_mem[adr_00] = {WDATA[63:56],24'h0000};
        endcase 
       // write_actual_mem[adr_00] = WDATA[63:32];
        adr_00 = adr_00 + 1;
      end
    end
  end

  always @(*) begin
  if (WLAST && HWRITE) begin  
     wait(( (HREADYOUT) && (HREADY) && HWRITE)); //Added AP - 15/9
      @(posedge ACLK);
      @(posedge ACLK);
      @(posedge ACLK);
      @(posedge ACLK);
      @(posedge ACLK);
      $display ("\n\n");
      $display ("############################################");
      $display ("###########Single AHB-AXI WRITE ############");
      $display ("############################################");
      //$display ("%t write_golden_mem[0]= %h , write_actual_mem[0]= %h  \n", $time, write_golden_mem[0],write_actual_mem[0]);
      for (ii=0;ii<CH_DEPTH;ii=ii+1) begin
        if (write_golden_mem[ii] === write_actual_mem[ii]) begin
          if (write_golden_mem[ii] !== 32'hx) begin
            error_count_0 = error_count_0;
            $display ("CLEAR !!!! golden_data= %h; actual_data= %h; %d data matched\n",write_golden_mem[ii],write_actual_mem[ii],ii);
          end
        end
        else begin
          if (write_golden_mem[ii] !== 32'hx) begin
            error_count_0 = error_count_0 + 1;
            $display ("ERROR !!!! golden_data= %h; actual_data= %h; %d data mismatched\n",write_golden_mem[ii],write_actual_mem[ii],ii);
          end
        end
      end 
      adr_0 = 0;
      adr_00 = 0;
    end
end

//#############################################################################
 
//#############################################################################
// AHB TO AXI READ OPERATION COMPARISION
//#############################################################################
  always @(posedge `CORETOP.ARREADY) begin
    get_golden_read_data;
  end

  task get_golden_read_data;
    reg  [3:0]   arlen;
    reg  [1:0]   arburst;
    reg  [1:0]   arsize;
    reg  [31:0]  araddr;
    reg  [63:0]  rdata_64;
    reg          swap;
    reg  [2:0]   swapreg;
    reg  [2:0]   inc;
    integer      rd;
    begin
      swap    = 1'b0;
      swapreg = 8'b0;
      arlen   = `CORETOP.ARLEN[3:0];
      arsize  = `CORETOP.ARSIZE[1:0];
      arburst = `CORETOP.ARBURST[1:0];
      araddr  = `CORETOP.ARADDR[31:0];
      swapreg = araddr[2:0];
      for (rd=0;rd<=arlen;rd=rd+1) begin
        wait (RVALID & `CORETOP.RREADY);
        @(posedge ACLK);
        rdata_64 = RDATA[63:0];
        //read_golden_mem[rd] = (swap == 1'b0) ? rdata_64[31:0] : rdata_64[63:32];
        read_golden_mem[rd] = (swapreg < 3'b100) ? rdata_64[31:0] : rdata_64[63:32];
        swap = ~swap;
        case(arsize)
          2'b00: inc = 3'b001;
          2'b01: inc = 3'b010;
          2'b10: inc = 3'b100;
        endcase
        swapreg = swapreg+inc;
      end
    end
  endtask
 
 

  always @(negedge HCLK) begin
    //if ((HTRANS==SEQ || HTRANS == NONSEQ) && (HREADYOUT) && !HWRITE) begin
    if (HREADYOUT && !HWRITE && HSEL) begin
      read_actual_mem[adr_1] = HRDATA[AHB_DWIDTH-1:0];
      //adr_1 = adr_1 + 1;
    end
  end

  always @(negedge HSEL) begin
    if (!HWRITE) begin
      @(posedge HCLK);

      if (read_golden_mem[0] !== 32'hx) begin  
        $display ("############################################");
        $display ("############ AHB-AXI READ ##################");
        $display ("############################################");
        for (rr=0;rr<CH_DEPTH;rr=rr+1) begin
          if (read_golden_mem[rr] === read_actual_mem[rr]) begin
            if (read_golden_mem[rr] !== 32'hx) begin  
              error_count_1 = error_count_1;
              $display ("CLEAR !!!! golden_data= %h; actual_data= %h; %d data matched",read_golden_mem[rr],read_actual_mem[rr],rr);
            end
          end
          else begin
            if (read_golden_mem[rr] !== 32'hx) begin  
              error_count_1 = error_count_1 + 1;
              $display ("ERROR !!!! golden_data= %h; actual_data= %h; %d data mismatched",read_golden_mem[rr],read_actual_mem[rr],rr);
            end
          end
        end  
      end  
      adr_1 = 0;
    end
  end


//#############################################################################


//#############################################################################
//#############################################################################
  task tcstatus();
    begin
      error_count = error_count_0 + error_count_1;
      #100;   // wait to finish all DUT process
      $display(">>>>>>>>>>>>   TOTAL NUMBER OF ERRORS:= %0d   <<<<<<<<<<<<<\n",error_count);
      //$display("");
      //$display("%0s",pound_str);

      //$write("%c[1;34m",27);
      if (error_count !== 0) begin
      $display("\t\t\t TESTCASE FAIL\n");
      end
      else begin
      $display("\t\t\t TESTCASE PASS\n");
      end
      $display("");
      $display("%0s",pound_str);      
      //$write("%c[0m",27);
      //$display("%0s",pound_str);
      //$display("");
      // color display start
      //$write("%c[1;34m",27);
      //$display("*********** This is in colour ***********");
      //$write("%c[0m",27);
      // color display end
    end
  endtask // tcstatus

  task testcase_start();
    begin
      $display("%0s",test_str);
      $display("\t\t\t TESTCASE START");
      $display("%0s",test_str);
    end
  endtask // testcase_start

  task testcase_end();
    begin
      $display("%0s",test_str);
      $display("\t\t\t TESTCASE END");
      $display("%0s",test_str);
    end
  endtask // testcase_end

//#############################################################################

endmodule
//-----------------------------------------------------------------------------
// File End
//-----------------------------------------------------------------------------

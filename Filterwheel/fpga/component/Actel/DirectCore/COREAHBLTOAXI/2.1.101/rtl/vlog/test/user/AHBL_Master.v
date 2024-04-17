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
module AHBL_Master ( 
    // AHBL interface
          HCLK,
          HRESETn,
          HSEL,
          HADDR,
          HWRITE,
          HREADY,
          HTRANS,
          HSIZE,
          HWDATA,
          HBURST,
          HMASTLOCK,
          HREADYOUT,
          HRESP,
          HRDATA
         );

//---------------------------------------------------
// Global parameters
//---------------------------------------------------
  parameter   AHB_AWIDTH   = 32; 
  parameter   AHB_DWIDTH   = 32; 
  parameter   UNDEF_BURST  = 0;  // if '0' then single transter else INCR16
  
 // localparam  AXI_WRSTB    = AXI_DWIDTH / 8;
  localparam  AHB_CLK_PERIOD = 5;   // Assuming AHB CLK to be 100MHz
  
`define reset_time = 2ns;
//---------------------------------------------------
// Input-Output Ports
//---------------------------------------------------
  // Inputs on the AHBL interface
  output                    HCLK;
  output                    HRESETn;
  output                    HSEL;
  output[AHB_AWIDTH-1:0]    HADDR;
  output                    HWRITE;
  output                    HREADY;
  output[1:0]               HTRANS;
  output[2:0]               HSIZE;
  output[AHB_DWIDTH-1:0]    HWDATA;
  output[2:0]               HBURST;
  output                    HMASTLOCK;
  
  // Outputs on the AHBL Interface
  input                     HREADYOUT;
  input [1:0]               HRESP;
  input  [AHB_DWIDTH-1:0]   HRDATA;
  
  `include "./defines.v"

  reg                       HCLK;
  reg                       HSEL;
  reg                       HWRITE;
  reg   [1:0]               HTRANS;
  reg   [2:0]               HSIZE;
  reg   [2:0]               HBURST;
  reg                       HMASTLOCK;
  reg                       HREADY;
  reg   [AHB_AWIDTH-1:0]    HADDR;
  reg   [AHB_DWIDTH-1:0]    HWDATA;
  reg                       nreset;
  reg  [AHB_DWIDTH-1:0]   read_data;
  
  reg    [AHB_AWIDTH-1:0]  haddr, haddr_w,init_addr;
  
  reg  [3:0]   haddr_incr;
  reg  [4:0]   hburst_value;
  reg          wrap_enable;
  reg  [7:0]   set_wrap_addr;
  reg  [1:0]   write_resp;

  //---------------------------------------------------------------------------
  // Initial value declarations
  //---------------------------------------------------------------------------
  initial begin
    nreset          = 1'b0; 
    HCLK            = 1'b0; 
    HSEL            = 1'b0; 
    HWRITE          = 1'b0;
    HREADY          = 1'b0;
    HTRANS          = 2'b00;
    HADDR           = 32'h0000_0000;
    HBURST          = 3'b000;
    HSIZE           = 3'b000;
    HMASTLOCK       = 1'b0;
  end
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
  assign HRESETn = nreset;
  always begin
    #AHB_CLK_PERIOD HCLK = ~HCLK;
  end
  
  task dut_reset;
    begin
      //nreset = #2 1'b1;
      nreset = 1'b0;
      #120;
      nreset = 1'b1;
    end
  endtask

  task set_wraddr_incr_value;
    input  [1:0]   hsize;
    begin
      case (hsize) 
        2'b00 : haddr_incr = 4'h1;
        2'b01 : haddr_incr = 4'h2;
        2'b10 : haddr_incr = 4'h4;
        2'b11 : haddr_incr = 4'h8;
      endcase
    end
  endtask

  task set_hburst_value;
    input  [2:0]   hburst;
    begin
      case (hburst) 
        3'b000 : hburst_value = 5'h01;
        3'b001 :  if (UNDEF_BURST == 0) begin
                    hburst_value = 5'h01;
                  end else begin
                    hburst_value = 5'h10;
                  end
        3'b010 : hburst_value = 5'h04;
        3'b011 : hburst_value = 5'h04;
        3'b100 : hburst_value = 5'h08;
        3'b101 : hburst_value = 5'h08;
        3'b110 : hburst_value = 5'h10;
        3'b111 : hburst_value = 5'h10;
      endcase
      case (hburst) 
        3'b000 : wrap_enable = 1'b0;
        3'b001 : wrap_enable = 1'b0;
        3'b010 : wrap_enable = 1'b1;
        3'b011 : wrap_enable = 1'b0;
        3'b100 : wrap_enable = 1'b1;
        3'b101 : wrap_enable = 1'b0;
        3'b110 : wrap_enable = 1'b1;
        3'b111 : wrap_enable = 1'b0;
      endcase
    end
  endtask
   
  task set_wrap_value;
    begin
      case (HBURST[2:0]) 
        3'b010 : if (HSIZE == 2'b10) begin
                   set_wrap_addr = 8'h0C;
                 end else if (HSIZE == 2'b01) begin
                   set_wrap_addr = 8'h06;
                 end else if (HSIZE == 2'b00) begin
                   set_wrap_addr = 8'h03;
                 end
        3'b100 : if (HSIZE == 2'b10) begin
                   set_wrap_addr = 8'h1C;
                 end else if (HSIZE == 2'b01) begin
                   set_wrap_addr = 8'h0E;
                 end else if (HSIZE == 2'b00) begin
                   set_wrap_addr = 8'h07;
                 end
        3'b110 : if (HSIZE == 2'b10) begin
                   set_wrap_addr = 8'h3C;
                 end else if (HSIZE == 2'b01) begin
                   set_wrap_addr = 8'h1E;
                 end else if (HSIZE == 2'b00) begin
                   set_wrap_addr = 8'h0F;
                 end
        default : set_wrap_addr = 8'h00;
      endcase
    end
  endtask

  task set_haddr;
    input  [31:0]  initaddr;
    input  [31:0]  haddr;
    input  [1:0]   hsize;  // 00-byte, 01-halfword, 10-word, 11-doubleword
    output [31:0]  haddr_out;
    reg    [31:0]  haddr_reg;
    reg    [3:0]   LAST_NIBBLE;
    begin
      case (hsize) 
        2'b00: LAST_NIBBLE = 4'hF;  // Byte
        2'b01: LAST_NIBBLE = 4'hE;  // Halfword
        2'b10: LAST_NIBBLE = 4'hC;  // Word
      endcase 
      set_wrap_value;
      haddr_reg = haddr;
      if (wrap_enable) begin
        if ((haddr_reg[3:0] == LAST_NIBBLE) && (haddr_reg[7:4] == initaddr[7:4])) begin
          haddr_reg = haddr_reg - set_wrap_addr;
        end
        else begin
          haddr_reg  = haddr_reg + haddr_incr;
        end
      end
      else begin
        haddr_reg  = haddr_reg + haddr_incr;
      end
      haddr_out = haddr_reg;
    end   
  endtask // set_haddr

  task ahb_write;
    //input  [1:0]   htrans;
    input  [2:0]   hburst;
    input  [1:0]   hsize;
    input  [3:0]   adr_incr;
    integer i;
    reg    [AHB_DWIDTH-1:0]  hwdata;
    begin
      case (hsize[1:0])
        2'b00: haddr = 32'h1111_AA20+adr_incr;
        2'b01: haddr = 32'h1111_AA20+(2*adr_incr);
        2'b10: haddr = 32'h1111_AA20+(4*adr_incr);
        2'b11: haddr = 32'h1111_AA20;
      endcase
      init_addr = haddr;
      hwdata = 32'h12345678; 
      set_wraddr_incr_value(hsize);
      set_hburst_value(hburst);
      @ (posedge HCLK);
      @ (posedge HCLK);
      // First non-seq cycle 
      HSEL   = HIGH; 
      HTRANS = NONSEQ;
      HADDR  = haddr;
      HBURST = hburst;
      HWRITE = WRITE;
      HSIZE  = hsize;
      HREADY = HIGH;
      //HWDATA = hwdata;
      HWDATA = $random;
      @ (posedge HCLK);
      //HWDATA = hwdata;
      HTRANS = LOW;

      wait (HREADYOUT);
      @ (posedge HCLK);

      // wait for write response from slave side
      wait (HREADYOUT);
      // latch write response here
      write_resp = HRESP[1:0];
      // After completion of last cycle 
      @ (posedge HCLK);
      HSEL   = LOW; 
      HTRANS = IDLE;
      HADDR  = 32'h0000_0000;
      HBURST = 3'b000;
      HWRITE = 1'b0;
      HSIZE  = 2'b00;
      HREADY = LOW;
      HWDATA = {AHB_DWIDTH{1'b0}};
      @ (posedge HCLK);
    end
  endtask // ahb_write
 
  task ahb_address;
    input  [1:0]   w_hw_b;
    begin
    end
  endtask // ahb_address

  task ahb_read;
    //input  [1:0]   htrans;
    input  [2:0]   hburst;
    input  [1:0]   hsize;
    input  [3:0]   adr_incr;
    integer i;
    reg    [AHB_DWIDTH-1:0]  hrdata;
    begin
      case (hsize[1:0])
        2'b00: haddr = 32'h1111_AA20+adr_incr;
        2'b01: haddr = 32'h1111_AA20+(2*adr_incr);
        2'b10: haddr = 32'h1111_AA20+(4*adr_incr);
        2'b11: haddr = 32'h1111_AA20;
      endcase
      init_addr = haddr;
      set_wraddr_incr_value(hsize);
      set_hburst_value(hburst);
      @ (posedge HCLK);
      @ (posedge HCLK);
      // First non-seq cycle 
      HSEL   = HIGH; 
      HTRANS = NONSEQ;
      HADDR  = haddr;
      HBURST = hburst;
      HWRITE = READ;
      HSIZE  = hsize;
      HREADY = HIGH;
      @ (posedge HCLK);
      HTRANS = LOW;
      wait (HREADYOUT);
      @ (posedge HCLK);


      wait (HREADYOUT);
      @ (posedge HCLK);
      HSEL   = LOW; 
      HTRANS = IDLE;
      HADDR  = 32'h0000_0000;
      HBURST = 3'b000;
      HWRITE = 1'b0;
      HSIZE  = 3'b000;
      HREADY = LOW;
      @ (posedge HCLK);
    end
  endtask // ahb_read
  
  task set_number_of_transfers;
    input  [1:0]  size;
    output [3:0]  transcount;
    begin
        transcount = 4'b1000 >> size;
    end
  endtask

  task ahb_write_busy_cycle;
    input  [2:0]   hburst;
    input  [1:0]   hsize;
    input  [3:0]   adr_incr;
    integer i;
    reg    [AHB_DWIDTH-1:0]  hwdata;
    begin
      case (hsize[1:0])
        2'b00: haddr = 32'h1111_AA20+adr_incr;
        2'b01: haddr = 32'h1111_AA20+(2*adr_incr);
        2'b10: haddr = 32'h1111_AA20+(4*adr_incr);
        2'b11: haddr = 32'h1111_AA20;
      endcase
      init_addr = haddr;
      hwdata = $random; 
      set_wraddr_incr_value(hsize);
      set_hburst_value(hburst);
      @ (posedge HCLK);
      @ (posedge HCLK);
      // First non-seq cycle 
      HSEL   = HIGH; 
      HTRANS = NONSEQ;
      HADDR  = haddr;
      HBURST = hburst;
      HWRITE = WRITE;
      HSIZE  = hsize;
      HREADY = HIGH;
      HWDATA = {AHB_DWIDTH{1'b0}};
      wait (HREADYOUT);
      @ (posedge HCLK);
      // Second cycle - ready low from master
      HTRANS = BUSY;
      set_haddr(init_addr,haddr,hsize,haddr_w);
      HADDR  = haddr_w;
      HWDATA = hwdata;
      HREADY = HIGH;
      wait (HREADYOUT);
      @ (posedge HCLK);
      // Third cycle - ready high for previous cycle
      HTRANS = SEQ;
      HADDR  = haddr_w;
      HWDATA = $random;
      HREADY = HIGH;
      wait (HREADYOUT);
      @ (posedge HCLK);

      for (i=0;i<hburst_value;i=i+1) begin
        HTRANS = SEQ;
        set_haddr(init_addr,haddr_w,hsize,haddr_w);
        //hwdata = hwdata + 2'b01;
        hwdata = $random;
        HADDR  = haddr_w;
        HWDATA = hwdata;
        HREADY = HIGH;
        wait (HREADYOUT);
        @ (posedge HCLK);
      end

      // wait for write response from slave side
      wait (HREADYOUT);
      // latch write response here
      write_resp = HRESP[1:0];
      // After completion of last cycle 
      HSEL   = LOW; 
      HTRANS = IDLE;
      HADDR  = 32'h0000_0000;
      HBURST = 3'b000;
      HWRITE = 1'b0;
      HSIZE  = 3'b000;
      HREADY = LOW;
      HWDATA = {AHB_DWIDTH{1'b0}};
      @ (posedge HCLK);
    end
  endtask // ahb_write_busy_cycle


endmodule
//-----------------------------------------------------------------------------
// File End
//-----------------------------------------------------------------------------

`timescale 1ns / 1ps
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

//`include "compilelistfile"
module coresdr_axi_tb();

  

  // DUT parameters
  `include "../../../coreparameters.v"
//  `include "../coreparameters.v"
  
  // constants
  localparam                AXI_AWIDTH = 32; // fixed
  localparam                AXI_DWIDTH = 64; // fixed
  localparam                AXI_WRSTB = AXI_DWIDTH / 8; // fixed
  localparam                MAX_SDRAM_DQSIZE = 64;
  localparam                MAX_SDRAM_DQM_SIZE = 8;
  
  // testbench specific parameters
  parameter       TB_AXI_WIDTH = 64; // transfer size
  parameter [1:0] TB_AXI_SIZE = 3; // must match with above (2=32, 3=64, 1=16)
  parameter       TB_BURST_LEN = 4;
  parameter       TB_ADDR_BASE = 32'h00000000;
  parameter       TB_ADDR_LIM = 32'h000001FF;
  
  
  // testbench derived parameters
  localparam        TB_ADDR_BITS = CLogB2(TB_ADDR_LIM);
  localparam        TB_BUS_RATIO = TB_AXI_WIDTH/SDRAM_DQSIZE;
  localparam        TB_INCREMENT = TB_BURST_LEN*(TB_AXI_WIDTH/8);       // note: 64 = doubleword aligned (0x00, 0x08, ...)
                                                                        //       32 = word aligned (0x00, 0x04, ...)
                                                                        //       16 = halfword aligned (0x00, 0x02,...)
                                                                        //       8  = byte aligned (0x00, 0x01, ...)
  // AXI  
  wire                       ACLK;
  wire                       ARESETn;
  wire                      AWREADY;
  wire                      WREADY;
  wire[3:0]                 BID;
  wire[1:0]                 BRESP;
  wire                      BVALID;
  wire                      ARREADY;
  wire[3:0]                 RID;
  wire[AXI_DWIDTH-1:0]      RDATA;
  wire[1:0]                 RRESP;
  wire                      RLAST;
  wire                      RVALID;
  wire  [3:0]               AWID;
  wire  [AXI_AWIDTH-1:0]    AWADDR;
  wire  [3:0]               AWLEN;
  wire  [2:0]               AWSIZE;
  wire  [1:0]               AWBURST;
  wire                      AWVALID;
  wire  [3:0]               WID;
  wire  [AXI_DWIDTH-1:0]    WDATA;
  wire  [AXI_WRSTB-1:0]     WSTRB;
  wire                      WLAST;
  wire                      WVALID;
  wire                      BREADY;
  wire  [3:0]               ARID;
  wire  [AXI_AWIDTH-1:0]    ARADDR;
  wire  [3:0]               ARLEN;
  wire  [2:0]               ARSIZE;
  wire  [1:0]               ARBURST;
  wire [1:0]                ARLOCK;
  wire                      ARVALID;
  wire                      RREADY;
  wire  [1:0]               AWLOCK; 

  // AXI check memory registers
  reg [TB_AXI_WIDTH-1:0]        write_mem[TB_ADDR_LIM-1:0];
  reg [TB_AXI_WIDTH-1:0]        read_mem[TB_ADDR_LIM-1:0];
  reg [TB_ADDR_BITS-1:0] wcount;
  reg [TB_ADDR_BITS-1:0] rcount;
  
  
  wire                          SDRCLK_out;
  
  // SDR (AS TODO: write a checker for these - done, added mem)
  wire                          SDRCLK;
  wire                          OE;
  // modified to maximum width for all configurations (64 bits)
	wire    [MAX_SDRAM_DQSIZE-1:0]    DQ;
  wire    [MAX_SDRAM_DQSIZE-1:0]    DQ_out;                 
  reg     [MAX_SDRAM_DQSIZE-1:0]    DQ_delayed;     
  wire    [13:0]                mem_SA;             // SDRAM Clock Enable
	wire    [13:0]                mem_SA_out;         // SDRAM Clock Enable
  wire                          mem_CAS_N;          // SDRAM Address Bus
  wire                          mem_CAS_N_out;          // SDRAM Address Bus
  wire                          mem_RAS_N;          // SDRAM Bank Select
  wire                          mem_RAS_N_out;          // SDRAM Bank Select
  wire                          mem_WE_N;           // SDRAM Chip Select
  wire                          mem_WE_N_out;           // SDRAM Chip Select
  wire    [1:0]                 mem_BA;             // SDRAM RAS Control Signal
  wire    [1:0]                 mem_BA_out;             // SDRAM RAS Control Signal
  wire    [SDRAM_CHIPS-1:0]     mem_CS_N;           // SDRAM CAS Control Signal
  wire    [SDRAM_CHIPS-1:0]     mem_CS_N_out;           // SDRAM CAS Control Signal
  wire                          mem_CKE;            // SDRAM WE Control Signal
  wire                          mem_CKE_out;            // SDRAM WE Control Signal
  wire    [MAX_SDRAM_DQSIZE/8-1:0]  mem_DQM;            // Local Side Data Mask Input
  wire    [MAX_SDRAM_DQSIZE/8-1:0]  mem_DQM_out;            // Local Side Data Mask Input
  
  // AS: invert clock (180 phase shift), for timing
  assign SDRCLK = SDRCLK_out;
  
  // vars / regs for TB
  integer                       k, j, i;
  reg  [31:0]                   addr;

  // Need to insert this delay to work with memory models
  // Otherwise, we well get hold / setup time errors
  assign #2000 mem_CAS_N_out =    mem_CAS_N;
  assign #2000 mem_RAS_N_out =    mem_RAS_N;
  assign #2000 mem_WE_N_out =     mem_WE_N;
  assign #2000 mem_SA_out =       mem_SA;
  assign #2000 mem_BA_out =       mem_BA;
  assign #2000 mem_CS_N_out =     mem_CS_N;
  assign #2000 mem_CKE_out =      mem_CKE;
  assign #2000 mem_DQM_out =      mem_DQM;                   //used for SDR only
  assign #2000 DQ_out =           OE ? DQ : {SDRAM_DQSIZE{1'bz}};      //used for SDR only
  
  // Main data bus
  assign    DQ = OE ? 64'bz : (REGDIMM ? DQ_delayed : DQ_out);

  // Use delayed data output if data is buffered (above)
  always @(posedge SDRCLK) begin
   DQ_delayed <= DQ_out;  
  end
  
  
 //----------Instance of AXI-Master ---------------
 //AXI_Master interface with COREAXITOAHBL,CHECKER,CLKGEN
 //It sends data to AHB SLAVE through COREAXITOAHBL and receive data from
 //AHB SLAVE through COREAXITOAHBL 
 
 AXI_Master master_0(
	//AXI Interface
          .ACLK (ACLK),
	        .ARESETN(ARESETn),
          .AWID (AWID),
          .AWADDR(AWADDR),
          .AWLEN(AWLEN),
	        .AWSIZE(AWSIZE),
          .AWBURST(AWBURST),
          .AWLOCK(AWLOCK),
          .AWVALID(AWVALID),
          .AWREADY(AWREADY),
          .WID(WID),
          .WDATA(WDATA),
          .WSTRB(WSTRB),
          .WLAST(WLAST),
          .WVALID(WVALID),
          .WREADY(WREADY),
          .BREADY(BREADY),
          .BID(BID),
          .BRESP(BRESP),
          .BVALID(BVALID),
          .ARID(ARID),
          .ARADDR(ARADDR),
          .ARLEN(ARLEN),
          .ARSIZE(ARSIZE),
          .ARBURST(ARBURST),
          .ARLOCK(ARLOCK),
          .ARVALID(ARVALID),
          .ARREADY(ARREADY),
          .RREADY(RREADY),
          .RID(RID),
          .RDATA(RDATA),
          .RRESP(RRESP),
          .RLAST(RLAST),
          .RVALID(RVALID)
	);

//---------- Instance of memory --------------------------
// 16M x 16 quadruple wide, two chip selects

//memory under first chip select
generate 
if (SDRAM_CHIPS > 0)
 begin
   mt48lc16m16a2 mem000      (.Dq(DQ_out[15:0]),
                        .Addr(mem_SA_out[12:0]),
                        .Ba(mem_BA_out),
                        .Clk(SDRCLK),
                        .Cke(mem_CKE_out),
                        .Cs_n(mem_CS_N_out[0]),
                        .Cas_n(mem_CAS_N_out),
                        .Ras_n(mem_RAS_N_out),
                        .We_n(mem_WE_N_out),
                        .Dqm(mem_DQM_out[1:0]));

  if (SDRAM_DQSIZE > 16)
  begin
   mt48lc16m16a2 mem001     (.Dq(DQ_out[31:16]),
                        .Addr(mem_SA_out[12:0]),
                        .Ba(mem_BA_out),
                        .Clk(SDRCLK),
                        .Cke(mem_CKE_out),
                        .Cs_n(mem_CS_N_out[0]),
                        .Cas_n(mem_CAS_N_out),
                        .Ras_n(mem_RAS_N_out),
                        .We_n(mem_WE_N_out),
                        .Dqm(mem_DQM_out[3:2]));
  end

  if (SDRAM_DQSIZE > 32)
  begin
   mt48lc16m16a2 mem010     (.Dq(DQ_out[47:32]),
                        .Addr(mem_SA_out[12:0]),
                        .Ba(mem_BA_out),
                        .Clk(SDRCLK),
                        .Cke(mem_CKE_out),
                        .Cs_n(mem_CS_N_out[0]),
                        .Cas_n(mem_CAS_N_out),
                        .Ras_n(mem_RAS_N_out),
                        .We_n(mem_WE_N_out),
                        .Dqm(mem_DQM_out[5:4]));
                        
   mt48lc16m16a2 mem011     (.Dq(DQ_out[63:48]),
                        .Addr(mem_SA_out[12:0]),
                        .Ba(mem_BA_out),
                        .Clk(SDRCLK),
                        .Cke(mem_CKE_out),
                        .Cs_n(mem_CS_N_out[0]),
                        .Cas_n(mem_CAS_N_out),
                        .Ras_n(mem_RAS_N_out),
                        .We_n(mem_WE_N_out),
                        .Dqm(mem_DQM_out[7:6]));
  end
  
  
 end
endgenerate

// Second chip select
generate 
if (SDRAM_CHIPS > 1)
 begin
   mt48lc16m16a2 mem100     (.Dq(DQ_out[15:0]),
                        .Addr(mem_SA_out[12:0]),
                        .Ba(mem_BA_out),
                        .Clk(SDRCLK),
                        .Cke(mem_CKE_out),
                        .Cs_n(mem_CS_N_out[1]),
                        .Cas_n(mem_CAS_N_out),
                        .Ras_n(mem_RAS_N_out),
                        .We_n(mem_WE_N_out),
                        .Dqm(mem_DQM_out[1:0]));
                        
  if (SDRAM_DQSIZE > 16)
  begin
   mt48lc16m16a2 mem101     (.Dq(DQ_out[31:16]),
                        .Addr(mem_SA_out[12:0]),
                        .Ba(mem_BA_out),
                        .Clk(SDRCLK),
                        .Cke(mem_CKE_out),
                        .Cs_n(mem_CS_N_out[1]),
                        .Cas_n(mem_CAS_N_out),
                        .Ras_n(mem_RAS_N_out),
                        .We_n(mem_WE_N_out),
                        .Dqm(mem_DQM_out[3:2]));
  end
  
  if (SDRAM_DQSIZE > 32)
  begin
   mt48lc16m16a2 mem110     (.Dq(DQ_out[47:32]),
                        .Addr(mem_SA_out[12:0]),
                        .Ba(mem_BA_out),
                        .Clk(SDRCLK),
                        .Cke(mem_CKE_out),
                        .Cs_n(mem_CS_N_out[1]),
                        .Cas_n(mem_CAS_N_out),
                        .Ras_n(mem_RAS_N_out),
                        .We_n(mem_WE_N_out),
                        .Dqm(mem_DQM_out[5:4]));
                        
   mt48lc16m16a2 mem111     (.Dq(DQ_out[63:48]),
                        .Addr(mem_SA_out[12:0]),
                        .Ba(mem_BA_out),
                        .Clk(SDRCLK),
                        .Cke(mem_CKE_out),
                        .Cs_n(mem_CS_N_out[1]),
                        .Cas_n(mem_CAS_N_out),
                        .Ras_n(mem_RAS_N_out),
                        .We_n(mem_WE_N_out),
                        .Dqm(mem_DQM_out[7:6]));
  end
  
 end
endgenerate


//----------Instance of DUT (CORESDR_AXI) ----------------
//CORESDR_AXI interface with AXI MASTER, CHECKER, CLKGEN
//It receives data from AHBSLAVE and send in to AXIMASTER
//It recive data from AXIMASTER and send in to AHBSLAVE
 
CORESDR_AXI # (
  .SDRAM_CHIPS				     (SDRAM_CHIPS),   
  .SDRAM_COLBITS           (SDRAM_COLBITS),
  .SDRAM_ROWBITS           (SDRAM_ROWBITS),
  .SDRAM_CHIPBITS          (SDRAM_CHIPBITS),
  .SDRAM_BANKSTATMODULES   (SDRAM_BANKSTATMODULES),
  .SDRAM_DQSIZE            (SDRAM_DQSIZE),
  .RAS                     (RAS),
  .RCD                     (RCD),
  .RRD                     (RRD),
  .RP                      (RP),
  .RC                      (RC),
  .RFC                     (RFC),
  .WR                      (WR),
  .MRD                     (MRD),
  .CL                      (CL),
  .DELAY                   (DELAY),
  .REF                     (REF),
  .REGDIMM                 (REGDIMM),
  .AUTO_PCH                (AUTO_PCH)
) DUT_0 (
  // AXI INTERFACE
  .ACLK(ACLK),
  .ARESETN(ARESETn),
  .AWID(AWID),
  .AWADDR(AWADDR),
  .AWLEN(AWLEN),
  .AWSIZE(AWSIZE),
  .AWBURST(AWBURST),
  .AWLOCK(AWLOCK),
  .AWVALID(AWVALID),
  .AWREADY(AWREADY),
  .WID(WID),
  .WDATA(WDATA),
  .WSTRB(WSTRB),
  .WLAST(WLAST),
  .WVALID(WVALID),
  .WREADY(WREADY),
  .BREADY(BREADY),
  .BID(BID),
  .BRESP(BRESP),
  .BVALID(BVALID),
  .ARID(ARID),
  .ARADDR(ARADDR),
  .ARLEN(ARLEN),
  .ARSIZE(ARSIZE),
  .ARBURST(ARBURST),
  .ARLOCK(ARLOCK),
  .ARVALID(ARVALID),
  .ARREADY(ARREADY),
  .RREADY(RREADY),
  .RID(RID),
  .RDATA(RDATA),
  .RRESP(RRESP),
  .RLAST(RLAST),
  .RVALID(RVALID),
  // SDR INTERFACE
  .SDRCLK(SDRCLK_out), 
  .OE(OE), 
  .SA(mem_SA), 
  .BA(mem_BA), 
  .CS_N(mem_CS_N), 
  .DQM(mem_DQM[SDRAM_DQSIZE/8-1:0]),
  .CKE(mem_CKE), 
  .RAS_N(mem_RAS_N), 
  .CAS_N(mem_CAS_N), 
  .WE_N(mem_WE_N), 
  .DQ(DQ[SDRAM_DQSIZE-1:0])
);

//-------------------Instance of checker-----------------
//It interface with AXIMASTER,AHBSLAVE,COREAXITOAHBL,CLKGEN
//It checks the data,send and receive by AXIMASTER,as well as
//AHB SLAVE,compare it,and send the result as PASS or FAIL
 
checker check(
        .ACLK(ACLK),
        .AWADDR(AWADDR),
        .WSTRB(WSTRB),
        .AWSIZE(AWSIZE),
        .AWLEN(AWLEN),
        .ARADDR(ARADDR),
        .ARLEN(ARLEN),
        .ARSIZE(ARSIZE),
        .RLAST(RLAST)
    );

//------------------Instance of clock generator-----------
//It interface with AXIMASTER,AHBSLAVE,COREAXITOAHBL,CHECKER
//It generate the clock for AXI MASTER and AHB SLAVE

clkgen # (
  .AXICLK(7500) // 66Mhz clk (15ns)
)
gen(
        .ACLK(ACLK),
        .ARESETN(ARESETn)
    );
     
    initial begin
      // some vars
      i = 0;
      j = 0;
      k = 0;
      gen.reset (50000);
      // TEMP
      // run some test AXI transactions
      // format: axi_read (raddr, ralen, rasize, raid, raburst, nob)
      //         axi_write (waddr,walen,wasize,waid,waburst,nob, wstrb)
      
      #300000000;
      
      if (SDRAM_DQSIZE < 16)
      begin
        $display("----------------------------------------------------");
        $display("Testbench does not support memory width less than 16");
        $display("----------------------------------------------------");
        $stop;
      end
      
      // WRITE
      // ADDRESS LOOP (i = address)
      $display("----------------------------------------");
      $display("Performing writes up to address %0h", TB_ADDR_LIM);
      $display("----------------------------------------");
      for (addr=TB_ADDR_BASE; addr <= TB_ADDR_BASE+ TB_ADDR_LIM; addr = addr+(TB_INCREMENT))
      begin
        master_0.axi_write (addr, TB_BURST_LEN-1, TB_AXI_SIZE, 4'h2, 2'b10, 3'b000, 8'hFF);
      end
      //master_0.axi_write (32'h000000, 4'h3, 2'b11, 4'h0, 2'b10, 3'b000, 8'hFF);
      //master_0.axi_write (32'h00000, 4'h3, 2'b11, 4'h0, 2'b10, 3'b000, 8'hFF);
      
      
      
      // READ
      // ADDRESS LOOP (i = address)
      $display("----------------------------------------");
      $display("Performing reads up to address %0h", TB_ADDR_LIM);
      $display("----------------------------------------");
      for (addr=TB_ADDR_BASE; addr <= TB_ADDR_BASE+TB_ADDR_LIM; addr = addr+(TB_INCREMENT))
      begin
        master_0.axi_read (addr, TB_BURST_LEN-1, TB_AXI_SIZE, 4'h2, 2'b10, 1'b0);
      end
      
      // check for axi read and write mismatch
      $display("----------------------------------------");
      $display("Checking for mismatches");
      $display("----------------------------------------");
      for (addr=0; addr <= wcount-1; addr = addr+1)
      begin
        if (write_mem[addr] != read_mem[addr])
        begin
          $display("Mismatch occurred");
          $display ("%0d: AXI read data %0h mis-matched write data %0h", addr, read_mem[addr], write_mem[addr]);
          $stop;
        end
        else
        begin
          $display ("%0d: AXI read data %0h matched write data %0h", addr, read_mem[addr], write_mem[addr]);
        
        end
      end
      
      $display("Tests passed");
      $stop;
    end
    
    // data verification
    always @ (posedge ACLK)
    begin
      if (ARESETn == 1'b0)
      begin
        // clear counters
        wcount <= 0;
        rcount <= 0;
      end
      else
      begin
        if (WVALID == 1'b1 && WREADY == 1'b1)
        begin
          write_mem [wcount[TB_ADDR_BITS-1:0]] <= WDATA[TB_AXI_WIDTH-1:0];
          wcount <= wcount + 1;
        end
        else if (RVALID == 1'b1 && RREADY == 1'b1)
        begin
          rcount <= rcount + 1;
          read_mem [rcount[TB_ADDR_BITS-1:0]] <= RDATA[TB_AXI_WIDTH-1:0];
        end
      end
    end
    
  // ceil of the log base 2
  function integer CLogB2;
    input [31:0] Depth;
    integer i;
    begin
         i = Depth;        
        for(CLogB2 = 0; i > 0; CLogB2 = CLogB2 + 1)
            i = i >> 1;
    end
  endfunction
    
    
  endmodule

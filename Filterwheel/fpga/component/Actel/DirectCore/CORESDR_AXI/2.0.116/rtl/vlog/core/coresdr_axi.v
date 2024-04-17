// *********************************************************************/ 
// Copyright (c) 2011 Actel Corporation.  All rights reserved.  
// 
// Any use or redistribution in part or in whole must be handled in 
// accordance with the Actel license agreement and must be approved 
// in advance in writing.  
//  
// File : coresdr_axi.v 
//     
// Description: This module is the top level module for the Local bus version of the
//              SDRAM controller, with an AXI wrapper
//
// TODO's:
// - clean up comments
//
// Changed:
// - remove FIFO implementation
// - add suport for 32-bit AxSIZE AXI transactions
// - do read- and write-splitting for when SDRAM_DQSIZE < AxSIZE
// - added logic to adjust SDR burst length for unaligned addresses
// - skip "dead" (DQM[1:0] == 2'b00) sdr beats, to improve throughput
// - remove dead cycles after sdr burst complete
// - fixed DQM issue (see SAR 33506), each data word has its own DQM value now
// - fixed DQM issue (see SAR 33186), DQM derived from WSTRB only during writes
// - flopped DQ and DQM, added extra cycle to SDR control (for timing)
// - WRAP burst support (fix for SAR 43393)
//
// Notes:
//
// *********************************************************************/ 

module CORESDR_AXI (
  ACLK,
  ARESETN,
  AWID,
  AWADDR,
  AWLEN,
  AWSIZE,
  AWBURST,
  AWLOCK,
  AWVALID,
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
  RVALID,

  SDRCLK, 
  OE, 
  SA, 
  BA, 
  CS_N, 
  DQM,
  CKE, 
  RAS_N, 
  CAS_N, 
  WE_N, 
  DQ
);

// -------------------------------------------------------------------
// PARAMETERS
// -------------------------------------------------------------------

// top-level parameters
parameter FAMILY                  = 16; // DEVICE FAMILY
parameter	SDRAM_CHIPS				      = 8;  // NUMBER OF CHIP SELECTS
parameter	SDRAM_COLBITS         	= 12; // NUMBER OF COLUMN BITS
parameter	SDRAM_ROWBITS         	= 14; // NUMBER OF ROW BITS
parameter	SDRAM_CHIPBITS        	= 3;  // NUMBER OF CHIP SELECT BITS
parameter SDRAM_BANKSTATMODULES   = 4;  // NUMBER OF BANK STATUS MODULES
parameter SDRAM_DQSIZE            = 32; // DATA BUS WIDTH

parameter [3:0] RAS = 2;                // Minimum ACTIVE to PRECHARGE
parameter [2:0] RCD = 1;                // Minimum time between ACTIVATE and READ/WRITE
parameter [1:0] RRD = 1;                // Minimum time between ACTIVATE to ACTIVATE in different banks
parameter [2:0] RP = 1;                 // Minimum PRECHARGE to ACTIVATE.
parameter [3:0] RC = 3;                 // Minimum ACTIVATE to ACTIVATE in same bank.
parameter [3:0] RFC = 10;               // Minimum AUTO-REFRESH to ACTIVATE/AUTO-REFRESH in same bank  
parameter [1:0] WR = 2;                 // Minimum delay from write to PRECHARGE
parameter [2:0] MRD = 2;                // Minimum LOADMODE to ACTIVATE command.
parameter [2:0] CL = 2;                 // Cas latency.
parameter [15:0] DELAY = 6800;          // Initialization delay
parameter [15:0] REF = 4096;            // Refresh Period.
parameter [0:0] REGDIMM = 0;            // Registered/Buffered DIMMS
parameter [0:0] AUTO_PCH = 0;           // issues read with auto precharge or write with auto precharge


// constants
localparam AXI_DWIDTH             = 64; // data width fixed at 64 bits for G4 (max), actual data width is determined by AxSIZE signal
localparam AXI_AWIDTH             = 32; // address width fixed at 32 bits
localparam SDRAM_RASIZE			      = 31; // READ ADDRESS

localparam [1:0] BL =  3;                 // Maximum burst length, 0=1 1=2 2=4 (default) 3=8
localparam [1:0] ROWBITS = SDRAM_ROWBITS - 11;            // # of row bits on sdram device(s)
localparam [2:0] COLBITS = SDRAM_COLBITS - 5;            // # of column bits on sdram device(s)

// derived parameters
localparam DQM_SIZE               = SDRAM_DQSIZE/8;   // one bit per byte


// axi states
localparam [3:0] AXI_IDLE = 0;  // idle state
localparam [3:0] AXI_RADR = 1;  // read axi addressing state
localparam [3:0] AXI_WADR = 2;  // write axi addressing state
localparam [3:0] AXI_RTRN = 3;  // read AXI-side transfer state
localparam [3:0] AXI_WTRN = 4;  // write AXI-side transfer state
localparam [3:0] AXI_WRSP = 5;  // write response state
localparam [3:0] AXI_WREQ = 6;  // SDR write request state
localparam [3:0] AXI_RREQ = 7;  // SDR read request state
localparam [3:0] AXI_RSDR = 8;  // SDR read transfer state
localparam [3:0] AXI_WSDR = 9;  // SDR write transfer state

// -------------------------------------------------------------------
// TOP-LEVEL SIGNALS
// -------------------------------------------------------------------

// inputs on AXI Interface
input                    ACLK;          // AXI clock
input                    ARESETN;       // active low reset
input [3:0]              AWID;          // write address ID
input [(AXI_AWIDTH-1):0]   AWADDR;        // write address
input [3:0]              AWLEN;         // burst length
input [2:0]              AWSIZE;        // write transfer size (expected to be fixed at 64 bits for G4)
input [1:0]              AWBURST;       // burst type (01 or 10)
input                    AWVALID;       // write address valid
input [3:0]              WID;           // write ID
input [AXI_DWIDTH-1:0]   WDATA;         // write data
input [7:0]              WSTRB;         // write strobe, 1 bit per byte of data
input                    WLAST;         // last write in burst
input                    WVALID;        // write data valid
input                    BREADY;        // response ready
input [3:0]              ARID;          // unused
input [AXI_AWIDTH-1:0]   ARADDR;        // read address
input [3:0]              ARLEN;         // burst length
input [2:0]              ARSIZE;        // read transfer size (expected to be fixed at 64 bits for G4)
input [1:0]              ARBURST;       // burst type (01 or 10)
input [1:0]              ARLOCK;        // unused
input                    ARVALID;       // address valid signal
input                    RREADY;        // master read ready
input [1:0]              AWLOCK;        // unused

// Outputs on AXI interface
output                     AWREADY;     // write address ready
output                     WREADY;      // write data ready
output [3:0]               BID;         // unused
output [1:0]               BRESP;       // write response data: 0 = OKAY, 1 = SLVERR
output                     BVALID;      // response data valid
output                     ARREADY;     // read address ready
output [3:0]               RID;         // unused
output [AXI_DWIDTH-1:0]    RDATA;       // read data
output [1:0]               RRESP;       // read response: 0 = OKAY, 1 = SLVERR
output                     RLAST;       // last read in burst
output                     RVALID;      // read data valid

// SDR signals
output SDRCLK; 
wire SDRCLK;
output OE; 
reg OE;
wire OE_i;
output[13:0] SA; 
reg[13:0] SA;
wire[13:0] SA_i;
output[1:0] BA; 
reg[1:0] BA;
wire[1:0] BA_i;
output[SDRAM_CHIPS - 1:0] CS_N; 
reg[SDRAM_CHIPS - 1:0] CS_N;
wire[SDRAM_CHIPS - 1:0] CS_N_i;
output [SDRAM_DQSIZE/8-1:0] DQM;
reg [SDRAM_DQSIZE/8-1:0] DQM;
wire [SDRAM_DQSIZE/8-1:0] DQM_i;
output CKE; 
reg CKE;
wire CKE_i;
output RAS_N; 
reg RAS_N;
wire RAS_N_i;
output CAS_N; 
reg CAS_N;
wire CAS_N_i;
output WE_N; 
reg WE_N;
wire WE_N_i;
inout[SDRAM_DQSIZE - 1:0] DQ; 
wire[SDRAM_DQSIZE - 1:0] DQ;

reg[7:0]   len_size_reg;

// -------------------------------------------------------------------
// internal wires and registers
// -------------------------------------------------------------------

// registered (during ADDRESS phase) AXI control
reg [3:0]              AWID_reg;          // write address ID
reg [3:0]              ARID_reg;          // read address ID
reg [3:0]              AWLEN_reg;         // burst length
reg [2:0]              AWSIZE_reg;        // write transfer size (expected to be fixed at 64 bits for SmartFusion4)
reg [3:0]              ARLEN_reg;         // burst length
reg [2:0]              ARSIZE_reg;        // read transfer size (expected to be fixed at 64 bits for SmartFusion4)
reg [7:0]              WSTRB_reg;         // write strobe, to be registered
reg [7:0]              WSTRB_mux;         // muxed write strobe, depending on transfer size

// ID outputs
wire [3:0]             BID;               // write response ID
wire [3:0]             RID;               // read ID


// registered AXI data buses
reg [AXI_DWIDTH-1:0]   WDATA_reg;         // write data
reg [AXI_DWIDTH-1:0]   RDATA_reg;         // read data
reg [AXI_DWIDTH-1:0]   RDATA;             // read data
reg [AXI_DWIDTH-1:0]   WDATA_mux;         // muxed write data, depending on transfer size


// muxed depending on memory bus width
wire [AXI_AWIDTH-1:0]   ARADDR_mux;
wire [AXI_AWIDTH-1:0]   AWADDR_mux;

reg[3:0] axi_state;                       // AXI state
reg[3:0] axi_nextstate;                   // AXI next state
wire axi_rvalid, axi_wvalid;              // AXI valid address registered
wire[1:0] asize;                          // muxed ARSIZE and AWSIZE
reg[1:0] asize_reg;                       // registered AxSIZE
wire[1:0] aburst;
reg[1:0] aburst_reg;
wire[3:0] alen;
reg[3:0] alen_reg;
//wire [AXI_AWIDTH-1:0] aaddr_mux;          // generic address line for control logic


reg [3:0] axi_count;
reg [3:0] sdr_count;                      // SDR burst count

reg [SDRAM_DQSIZE-1:0] sdr_datain;        // sdram write data
reg [SDRAM_DQSIZE-1:0] sdr_datain_reg;    // sdram write data
wire [SDRAM_DQSIZE-1:0] sdr_dataout;      // sdram read data
reg [SDRAM_DQSIZE-1:0] sdr_dataout_reg;   // sdram read data, registered
wire dqm_sdr;                             // sdr mask
reg [7:0] DQM_mux;                        // DQM_mux, selects and inverts
                                          // appropriate bits from WSTRB

wire[SDRAM_RASIZE - 1:0] RADDR;           // SDR address
reg[SDRAM_RASIZE - 1:0] raddr_reg;        // SDR address hold register
wire R_REQ;                               // read request to SDR
wire W_REQ;                               // write request to SDR
reg w_req_reg;                            // generated write request to SDR
wire RW_ACK;                              // r/w acknowledge from SDR
wire R_VALID_i;                             // Read data valid from SDR
reg  R_VALID;                             // Read data valid from SDR
reg  R_VALID_reg;                         // Read data valid from SDR
wire D_REQ;                               // SDR requesting data on RDATA, next clk cycle
wire W_VALID;                             // Unused- LEGACY
reg[3:0] B_SIZE;

// registered B_SIZE (muxed)
reg [3:0] B_SIZE_reg;

// next raddr net
reg[SDRAM_RASIZE - 1:0] raddr_next;
reg[SDRAM_RASIZE - 1:0] raddr_incr;

// -------------------------------------------------------------------
// OUTPUT ASSIGNMENTS
// -------------------------------------------------------------------

// SDR output assignments
assign SDRCLK = ACLK;             // SDRCLOCK pass-through

// Data bus and mask
assign DQ[SDRAM_DQSIZE-1:0] = (OE == 1'b1) ? sdr_datain_reg[SDRAM_DQSIZE-1:0] : {SDRAM_DQSIZE{1'bz}} ;

// Mask, using WSTRB, which was registered during address phase
assign DQM_i[0] = (axi_state == AXI_WSDR) ? (DQM_mux[0] | dqm_sdr) : dqm_sdr;
assign DQM_i[1] = (axi_state == AXI_WSDR) ? (DQM_mux[1] | dqm_sdr) : dqm_sdr;

generate
if(SDRAM_DQSIZE > 16)
begin
  assign DQM_i[2] = (axi_state == AXI_WSDR) ? (DQM_mux[2] | dqm_sdr) : dqm_sdr; 
  assign DQM_i[3] = (axi_state == AXI_WSDR) ? (DQM_mux[3] | dqm_sdr) : dqm_sdr; 
end
endgenerate

generate
if(SDRAM_DQSIZE > 32)
begin
  assign DQM_i[4] = (axi_state == AXI_WSDR) ? (DQM_mux[4] | dqm_sdr) : dqm_sdr; 
  assign DQM_i[5] = (axi_state == AXI_WSDR) ? (DQM_mux[5] | dqm_sdr) : dqm_sdr; 
  assign DQM_i[6] = (axi_state == AXI_WSDR) ? (DQM_mux[6] | dqm_sdr) : dqm_sdr; 
  assign DQM_i[7] = (axi_state == AXI_WSDR) ? (DQM_mux[7] | dqm_sdr) : dqm_sdr; 
end
endgenerate

// AS: replaced with RDATA mux for byte alignement
// assign RDATA[63:0] = RDATA_reg;

// only accept addresses when 
// a) AXI i/f is in address mode
// b) A Valid transfer is present (see axi_rvalid and axi_wvalid signals)
assign ARREADY = (axi_state == AXI_RADR) ? 1'b1 : 1'b0;
assign AWREADY = (axi_state == AXI_WADR) ? 1'b1 : 1'b0;

// accept data as long as we are in transfer phase and have not yet received
// all data
assign WREADY = ((axi_state == AXI_WTRN) && (axi_count[3:0] != 4'b0000)) ? 1'b1 : 1'b0;

// Read data is valid when we are in read transfer mode
assign RVALID = ((axi_state == AXI_RTRN) && (axi_count[3:0] != 4'b0000)) ? 1'b1 : 1'b0;
assign RID[3:0] = (RVALID == 1'b1) ? ARID_reg[3:0] : 4'b0000;

// Write response
assign BVALID = (axi_state == AXI_WRSP);
assign BRESP = (axi_state == AXI_WRSP) ? 2'b00 : 2'b01;
assign BID = (axi_state == AXI_WRSP) ? AWID_reg[3:0] : 4'b000;

// Error if error flag set OR we are not in READ transfer mode
assign RRESP = (axi_state == AXI_RTRN) ? 2'b00 : 2'b01;

// Last transfer indicator
assign RLAST = ((axi_state == AXI_RTRN) && (axi_count[3:0] == 4'b0001)) ? 1'b1 : 1'b0;

// -------------------------------------------------------------------
// COMBINATORIAL LOGIC
// -------------------------------------------------------------------

// Data bus
assign sdr_dataout[SDRAM_DQSIZE-1:0] = DQ[SDRAM_DQSIZE-1:0];

// AXI Read Data bus repeating
always@(*)
begin
  case(asize_reg[1:0])
    // 16 bit transfer
    2'b01:
    begin
      RDATA[63:0] <= {RDATA_reg[15:0], RDATA_reg[15:0], RDATA_reg[15:0], RDATA_reg[15:0]};
    end
    // 32 bit transfer
    2'b10:
    begin
      RDATA[63:0] <= {RDATA_reg[31:0], RDATA_reg[31:0]};
    end
    // 64 bit transfer
    2'b11:
    begin
      RDATA[63:0] <= RDATA_reg[63:0];
    end
    default:
    begin
      RDATA[63:0] <= RDATA_reg[63:0];
    end
  endcase
end

// mux DQM input to SDR
// AS: added DQM masking / negation 8/24/11
generate
if (SDRAM_DQSIZE == 16)
begin
  always@(*)
  begin
    DQM_mux[7:2] <= 6'b000000;
    case (sdr_count[3:0])
      4'b0000: 
        DQM_mux[1:0] <= {~WSTRB_mux[1], ~WSTRB_mux[0]};
      4'b0001: 
        DQM_mux[1:0] <= {~WSTRB_mux[3], ~WSTRB_mux[2]};
      4'b0010:
        DQM_mux[1:0] <= {~WSTRB_mux[5], ~WSTRB_mux[4]};
      4'b0011:
        DQM_mux[1:0] <= {~WSTRB_mux[7], ~WSTRB_mux[6]};
      default:
        DQM_mux[1:0] <= {~WSTRB_mux[1], ~WSTRB_mux[0]};
    endcase
  end
end
else if (SDRAM_DQSIZE == 32)
begin
  always@(*)
  begin
    DQM_mux[7:4] <= 4'b0000;
    case (sdr_count[3:0])
      4'b0000: 
        DQM_mux[3:0] <= {~WSTRB_mux[3],~WSTRB_mux[2],~WSTRB_mux[1],~WSTRB_mux[0]};
      4'b0001: 
        DQM_mux[3:0] <= {~WSTRB_mux[7],~WSTRB_mux[6],~WSTRB_mux[5],~WSTRB_mux[4]};
      default: 
        DQM_mux[3:0] <= {~WSTRB_mux[3],~WSTRB_mux[2],~WSTRB_mux[1],~WSTRB_mux[0]};
    endcase
  end
end
else if (SDRAM_DQSIZE == 64)
begin
  always@(*)
  begin
    DQM_mux[7:0] <= {~WSTRB_mux[7],~WSTRB_mux[6],~WSTRB_mux[5],~WSTRB_mux[4],~WSTRB_mux[3],~WSTRB_mux[2],~WSTRB_mux[1],~WSTRB_mux[0]};
  end
end
endgenerate

// -------------------------------------------------------------------
// Write strob mapping to DQM
//
always@(*)
begin
  case(asize_reg[1:0])
    // 16 bit transfer
    2'b01:
    begin
      WSTRB_mux[7:2] <= 6'b000000;
      // Select between WSTRB[1:0], WSTRB[3:2], WSTRB[5:4] WSTRB[7:6]
      if (WSTRB_reg[1] == 1'b1 || WSTRB_reg[0] == 1'b1)
        WSTRB_mux[1:0] <= WSTRB_reg[1:0];
      else if (WSTRB_reg[3] == 1'b1 || WSTRB_reg[2] == 1'b1)
        WSTRB_mux[1:0] <= WSTRB_reg[3:2];
      else if (WSTRB_reg[5] == 1'b1 || WSTRB_reg[4] == 1'b1)
        WSTRB_mux[1:0] <= WSTRB_reg[5:4];
      else if (WSTRB_reg[7] == 1'b1 || WSTRB_reg[6] == 1'b1)
        WSTRB_mux[1:0] <= WSTRB_reg[7:6];
      else
        WSTRB_mux[1:0] <= WSTRB_reg[1:0];
    end
    // 32 bit transfer
    2'b10:
    begin
      WSTRB_mux[7:4] <= 4'b0000;
      // Select between WSTRB[3:0], WSTRB[7:4]
      if (WSTRB_reg[3] == 1'b1 || WSTRB_reg[2] == 1'b1 || WSTRB_reg[1] == 1'b1 || WSTRB_reg[0] == 1'b1)
        WSTRB_mux[3:0] <= WSTRB_reg[3:0];
      else if (WSTRB_reg[7] == 1'b1 || WSTRB_reg[6] == 1'b1 || WSTRB_reg[5] == 1'b1 || WSTRB_reg[4] == 1'b1)
        WSTRB_mux[3:0] <= WSTRB_reg[7:4];
      else
        WSTRB_mux[3:0] <= WSTRB_reg[3:0];
    end
    // 64 bit transfer
    2'b11:
    begin
      WSTRB_mux[7:0] <= WSTRB_reg[7:0];
    end
    default:
    begin
      WSTRB_mux[7:0] <= WSTRB_reg[7:0];
    end
  endcase
end


// mux data input to SDR
generate
if (SDRAM_DQSIZE == 16)
begin
  always@(*)
  begin
    case (sdr_count[3:0])
      4'b0000: 
        sdr_datain[15:0] <= WDATA_reg[15:0];
      4'b0001: 
        sdr_datain[15:0] <= WDATA_reg[31:16];
      4'b0010:
        sdr_datain[15:0] <= WDATA_reg[47:32];
      4'b0011:
        sdr_datain[15:0] <= WDATA_reg[63:48];
      default:
        sdr_datain[15:0] <= WDATA_reg[15:0];
    endcase
  end
end
else if (SDRAM_DQSIZE == 32)
begin
  always@(*)
  begin
    case (sdr_count[3:0])
      4'b0000: 
        sdr_datain[31:0] <= WDATA_reg[31:0];
      4'b0001: 
        sdr_datain[31:0] <= WDATA_reg[63:32];
      default: 
        sdr_datain[31:0] <= WDATA_reg[31:0];
    endcase
  end
end
else if (SDRAM_DQSIZE == 64)
begin
  always@(*)
  begin
    sdr_datain[63:0] <= WDATA_reg[63:0];
  end
end
endgenerate

// ---------------------------------------------------------------------
// AS: fix for SAR 43393 (http://bugzilla/show_bug.cgi?id=43393)
// LUT for next raddr generation, based on:
// - AWADDR/ARADDR
// - AWBURST/ARBURST (WRAP vs. INCR)
// - B_SIZE (SDR burst size)
// - AWLEN/ARLEN

generate
if (SDRAM_DQSIZE == 16)
begin
  always@(*)
  begin
    raddr_incr <= raddr_reg +  B_SIZE_reg;
  end
  
  always@(*)
  begin
    if (aburst_reg[1:0] == 2'b10) // WRAP burst, need to deal with wrap boundaries
    begin
      case(alen_reg[3:0])
        4'b0000:
          // no wrap boundary
          raddr_next <= raddr_incr;
        4'b0001:
          // wrap at every 2 locations
          case(asize_reg[1:0]) 
            2'b11: begin
              if (raddr_incr[2:0] == 3'b000)
                raddr_next <= {raddr_reg[SDRAM_RASIZE-1:3], 3'b000};
              else
                raddr_next <= raddr_incr;
            end
            2'b10: begin
              if (raddr_incr[1:0] == 2'b00)
                raddr_next <= {raddr_reg[SDRAM_RASIZE-1:2], 2'b00};
              else
                raddr_next <= raddr_incr;
            end
            2'b01: begin
              if (raddr_incr[0] == 1'b0)
                raddr_next <= {raddr_reg[SDRAM_RASIZE-1:1], 1'b0};
              else
                raddr_next <= raddr_incr;
            end
            default : raddr_next <= raddr_incr;
          endcase
        4'b0011:
          // wrap at every 4 locations
          case(asize_reg[1:0])
              2'b11: begin
                if (raddr_incr[3:0] == 4'b0000)
                  raddr_next <= {raddr_reg[SDRAM_RASIZE-1:4], 4'b0000};
                else
                  raddr_next <= raddr_incr;
              end
              2'b10: begin
                if (raddr_incr[2:0] == 3'b000)
                  raddr_next <= {raddr_reg[SDRAM_RASIZE-1:3], 3'b000};
                else
                  raddr_next <= raddr_incr;
              end
              2'b01: begin
                if (raddr_incr[1:0] == 2'b00)
                  raddr_next <= {raddr_reg[SDRAM_RASIZE-1:2], 2'b00};
                else
                  raddr_next <= raddr_incr;
              end
            default : raddr_next <= raddr_incr;
          endcase
        4'b0111:
          // wrap at every 8 locations
          case(asize_reg[1:0])
            2'b11: begin
              if (raddr_incr[4:0] == 5'b00000)
                raddr_next <= {raddr_reg[SDRAM_RASIZE-1:5], 5'b00000};
              else
                raddr_next <= raddr_incr;
            end
            2'b10:begin
              if (raddr_incr[3:0] == 4'b0000)
                raddr_next <= {raddr_reg[SDRAM_RASIZE-1:4], 4'b0000};
              else
                raddr_next <= raddr_incr;
            end
            2'b01: begin
              if (raddr_incr[2:0] == 3'b000)
                raddr_next <= {raddr_reg[SDRAM_RASIZE-1:3], 3'b000};
              else
                raddr_next <= raddr_incr;
            end
            default : raddr_next <= raddr_incr;
        endcase
        default:
          raddr_next <= raddr_incr;
      endcase
    end
    else
    begin
      // INCR burst, straight increment, bro!
      raddr_next <= raddr_reg + B_SIZE_reg;
    end
  end
end
else if (SDRAM_DQSIZE == 32)
begin
  always@(*)
  begin
    raddr_incr <= raddr_reg +  B_SIZE_reg;
  end
  
  always@(*)
  begin
    if (aburst_reg[1:0] == 2'b10) // WRAP burst, need to deal with wrap boundaries
    begin
      case(alen_reg[3:0])
        4'b0000:
          // no wrap boundary
          raddr_next <= raddr_incr;
        4'b0001:
          // wrap at every 2 locations
          case(asize_reg[1:0])
              2'b11: begin
                if (raddr_incr[1:0] == 2'b00)
                  raddr_next <= {raddr_reg[SDRAM_RASIZE-1:2], 2'b00};
                else
                  raddr_next <= raddr_incr;
              end
              2'b10:begin
                if (raddr_incr[0] == 1'b0)
                  raddr_next <= {raddr_reg[SDRAM_RASIZE-1:1], 1'b0};
                else
                  raddr_next <= raddr_incr;
              end
              default: raddr_next <= raddr_incr;
          endcase
        4'b0011:
          // wrap at every 4 locations
          case(asize_reg[1:0])
            2'b11: begin
              if (raddr_incr[2:0] == 3'b000)
                raddr_next <= {raddr_reg[SDRAM_RASIZE-1:3], 3'b000};
              else
                raddr_next <= raddr_incr;
            end
            2'b10: begin
              if (raddr_incr[1:0] == 2'b00)
                raddr_next <= {raddr_reg[SDRAM_RASIZE-1:2], 2'b00};
              else
                raddr_next <= raddr_incr;
            end
            default: raddr_next <= raddr_incr;
          endcase
        4'b0111:
          // wrap at every 8 locations
          case(asize_reg[1:0])
            2'b11: begin
             if (raddr_incr[3:0] == 4'b0000)
               raddr_next <= {raddr_reg[SDRAM_RASIZE-1:4], 4'b0000};
             else
               raddr_next <= raddr_incr;
            end
            2'b10: begin
             if (raddr_incr[2:0] == 3'b000)
               raddr_next <= {raddr_reg[SDRAM_RASIZE-1:3], 3'b000};
             else
               raddr_next <= raddr_incr;
            end
          endcase
        default:
          raddr_next <= raddr_incr;
      endcase
    end
    else
    begin
      // INCR burst, straight increment, bro!
      raddr_next <= raddr_reg + B_SIZE_reg;
    end
  end
end
else if (SDRAM_DQSIZE == 64)
begin
  always@(*)
  begin
    raddr_incr <= raddr_reg +  B_SIZE_reg;
  end
  
  always@(*)
  begin
    if (aburst_reg[1:0] == 2'b10) // WRAP burst, need to deal with wrap boundaries
    begin
      case(alen_reg[3:0])
        4'b0000:
          // no wrap boundary
          raddr_next <= raddr_incr;
        4'b0001:
          // wrap at every 2 locations
          if (raddr_incr[0] == 1'b0)
            raddr_next <= {raddr_reg[SDRAM_RASIZE-1:1], 1'b0};
          else
            raddr_next <= raddr_incr;
        4'b0011:
          // wrap at every 4 locations
          if (raddr_incr[1:0] == 2'b00)
            raddr_next <= {raddr_reg[SDRAM_RASIZE-1:2], 2'b00};
          else
            raddr_next <= raddr_incr;
        4'b0111:
          // wrap at every 8 locations
          if (raddr_incr[2:0] == 3'b000)
            raddr_next <= {raddr_reg[SDRAM_RASIZE-1:3], 3'b000};
          else
            raddr_next <= raddr_incr;
        default:
          raddr_next <= raddr_incr;
      endcase
    end
    else
    begin
      // INCR burst, straight increment, bro!
      raddr_next <= raddr_reg + B_SIZE_reg;
    end
  end
end
endgenerate



// ---------------------------------------------------------------------

assign RADDR = raddr_reg;

// generate SDR-side read request when AXI requests it
assign R_REQ = (axi_state == AXI_RREQ)| ((axi_state == AXI_RTRN) & (RREADY == 1'b1));

// only generate SDR-side write request once data is buffered, or bufferING
assign W_REQ = (axi_state == AXI_WREQ) | ((axi_state == AXI_WTRN) & (WVALID == 1'b1));


// AXI transfer only valid if
// 1) 64 bit transaction used (which it will be for G4) [AS: removed this condition]
// 2) INCR (01) or WRAP (10) tranfer indicated on BURST line
// 3) Burst length is less than 8
// 4) A[*]VALID signal asserted
assign axi_rvalid = ((ARVALID == 1'b1)  & ((ARBURST[1:0] == 2'b01) | (ARBURST[1:0] == 2'b10)) & (ARLEN[3:0] <= 8)) ? 1'b1 : 1'b0;
assign axi_wvalid = ((AWVALID == 1'b1)  & ((AWBURST[1:0] == 2'b01) | (AWBURST[1:0] == 2'b10)) & (AWLEN[3:0] <= 8)) ? 1'b1 : 1'b0;

// generice asize, muxed AxSIZE signals
assign asize[1:0] =   (ARVALID == 1'b1) ? ARSIZE[1:0] :
                      (AWVALID == 1'b1) ? AWSIZE[1:0] :
                      2'b11;

// generic alen, muxed AxLEN signals
assign alen[3:0]  =   (ARVALID == 1'b1) ? ARLEN[3:0] :
                      (AWVALID == 1'b1) ? AWLEN[3:0] :
                      4'b0000;

// generic aburst, muxed AxBURST signals
assign aburst[1:0] =  (ARVALID == 1'b1) ? ARBURST[1:0] :
                      (AWVALID == 1'b1) ? AWBURST[1:0] :
                      2'b11;
                                            
// generic aaddr, muxed AxADDR signals
//assign aaddr_mux[31:0] =  (ARVALID == 1'b1) ? ARADDR[31:0] :
//                          (AWVALID == 1'b1) ? AWADDR[31:0] :
//                          32'h0000;

// AXI next state and R/W assignment
always @ (*)
begin
  case (axi_state)

    AXI_IDLE:
      // Idle phase
      if (axi_rvalid == 1'b1) // read
      begin
        axi_nextstate <= AXI_RADR;
      end
      else if ((AWVALID == 1'b1)) // write
      begin
        axi_nextstate <= AXI_WADR;
      end
      else
        axi_nextstate <= AXI_IDLE;

    AXI_RADR:
      // AXI read address phase
      if (ARVALID == 1'b1)
        axi_nextstate <= AXI_RREQ;
      else 
        axi_nextstate <= AXI_RADR;

    AXI_WADR:
      // AXI write address phase
      if (AWVALID == 1'b1)
        axi_nextstate <= AXI_WTRN;
      else
        axi_nextstate <= AXI_WADR;

    AXI_RREQ:
      // SDR read request generate
      if (RW_ACK == 1'b1)
        axi_nextstate <= AXI_RSDR;
      else 
        axi_nextstate <= AXI_RREQ;

    AXI_WREQ:
      // SDR request write operation
      if (RW_ACK == 1'b1)
        axi_nextstate <= AXI_WSDR;
      else
        axi_nextstate <= AXI_WREQ;

    AXI_RTRN:
      // AXI read operation
      // AS: modified 12/5/11 for SARno 35167 (http://bugzilla/show_bug.cgi?id=35167)
      if (axi_count[3:0] == 4'b0001 && RREADY == 1'b1)
        axi_nextstate <= AXI_IDLE;
      else if (RREADY == 1'b1)
        axi_nextstate <= AXI_RREQ;
      else
        axi_nextstate <= AXI_RTRN;

    AXI_WTRN:
      // AXI write operation
      // Here we will the write FIFO, then generate
      // the write request
      if (axi_count[3:0] == 4'b0000)
        axi_nextstate <= AXI_WRSP;
      else if (WVALID == 1'b1)
        axi_nextstate <= AXI_WREQ;
      else
        axi_nextstate <= AXI_WTRN;
        
    AXI_WRSP:
      // AXI write response
      // Need a separate cycle after write complete
      if (BREADY == 1'b1)
        axi_nextstate <= AXI_IDLE;
      else
        axi_nextstate <= AXI_WRSP;

    AXI_RSDR:
      // SDR read
      // AS: this causes isses for SDRAM_DQSIZE == 64,
      //     because we start off with that count
      //     needed to add R_VALID condition to ensure we wait long enough
      if ((sdr_count[3:0] == B_SIZE_reg[3:0] - 1) && (R_VALID == 1'b1))
        axi_nextstate <= AXI_RTRN;
      else
        axi_nextstate <= AXI_RSDR;


    AXI_WSDR:
      // SDR write
      // AS: removed write cycle, needed to add W_VALID condition for
      //     case of SDR_DQSIZE == ARSIZE/AWSIZE width (1 SDR beat per AXI beat)
      if ((sdr_count[3:0] == B_SIZE_reg[3:0] - 1) && (W_VALID == 1'b1))
      begin
        if (axi_count[3:0] == 4'b0000)
          axi_nextstate <= AXI_WRSP;
        else
          axi_nextstate <= AXI_WTRN;
      end
      else
        axi_nextstate <= AXI_WSDR;

    default:
      axi_nextstate <= AXI_IDLE;

  endcase
end


//--------------------------------------------------------------------
// TODO: clean this up!
// adjust for unaligned addresses
// AS: added 8/24/2011
// changes the starting SDR transfer location


// -------------------------------------------------------------------
// Decode burst size AND address mapping
generate
if (SDRAM_DQSIZE == 16)
begin
  
  assign ARADDR_mux = {1'b0, ARADDR[31:1]};
  assign AWADDR_mux = {1'b0, AWADDR[31:1]};

  // B_SIZE
  always@(*)
  begin
    case(asize[1:0])
      2'b01:
        B_SIZE <= 4'b0001;
      2'b10:
        B_SIZE <= 4'b0010;
      2'b11:
        B_SIZE <= 4'b0100;
      default:
        B_SIZE <= 4'b0001;
    endcase
  end
  
end
else if (SDRAM_DQSIZE == 32)
begin

  assign ARADDR_mux = {2'b00, ARADDR[31:2]};
  assign AWADDR_mux = {2'b00, AWADDR[31:2]};

  always@(*)
  begin
    case(asize[1:0])
      2'b10:
        B_SIZE <= 4'b0001;
      2'b11:
        B_SIZE <= 4'b0010;
      default:
        B_SIZE <= 4'b0001;
    endcase
  end
end
else if (SDRAM_DQSIZE == 64)
begin

  assign ARADDR_mux = {3'b000, ARADDR[31:3]};
  assign AWADDR_mux = {3'b000, AWADDR[31:3]};

  always@(*)
  begin
    case(asize[1:0])
      2'b11:
        B_SIZE <= 4'b0001;
      default:
        B_SIZE <= 4'b0001;
    endcase
  end
end
endgenerate

// -------------------------------------------------------------------
// Write strobe mapping byte mapping
//
always@(*)
begin
  case(asize_reg[1:0])
    // 16 bit transfer
    2'b01:
    begin
      WDATA_mux[63:16] <= 0;
      
      // Byte0
      if (WSTRB[0] == 1'b1)
        WDATA_mux[7:0] <= WDATA[7:0];
      else if (WSTRB[2] == 1'b1)
        WDATA_mux[7:0] <= WDATA[23:16];
      else if (WSTRB[4] == 1'b1)
        WDATA_mux[7:0] <= WDATA[39:32];
      else if (WSTRB[6] == 1'b1)
        WDATA_mux[7:0] <= WDATA[55:48];
      else
        WDATA_mux[7:0] <= 8'h00;
      
      // Byte1
      if (WSTRB[1] == 1'b1)
        WDATA_mux[15:8] <= WDATA[15:8];
      else if (WSTRB[3] == 1'b1)
        WDATA_mux[15:8] <= WDATA[31:24];
      else if (WSTRB[5] == 1'b1)
        WDATA_mux[15:8] <= WDATA[47:40];
      else if (WSTRB[7] == 1'b1)
        WDATA_mux[15:8] <= WDATA[63:56];
      else
        WDATA_mux[15:8] <= 8'h00;
    end
    // 32 bit transfer
    2'b10:
    begin
      WDATA_mux[63:32] <= 0;   

      // Byte0 
      if (WSTRB[0] == 1'b1)
        WDATA_mux[7:0] <= WDATA[7:0];
      else if (WSTRB[4] == 1'b1)
        WDATA_mux[7:0] <= WDATA[39:32];
      else
        WDATA_mux[7:0] <= 8'h00;
        
      // Byte1
      if (WSTRB[1] == 1'b1)
        WDATA_mux[15:8] <= WDATA[15:8];
      else if (WSTRB[5] == 1'b1)
        WDATA_mux[15:8] <= WDATA[47:40];
      else
        WDATA_mux[15:8] <= 8'h00;
        
      // Byte2
      if (WSTRB[2] == 1'b1)
        WDATA_mux[23:16] <= WDATA[23:16];
      else if (WSTRB[6] == 1'b1)
        WDATA_mux[23:16] <= WDATA[55:48];
      else
        WDATA_mux[23:16] <= 8'h00;
        
      // Byte3
      if (WSTRB[3] == 1'b1)
        WDATA_mux[31:24] <= WDATA[31:24];
      else if (WSTRB[7] == 1'b1)
        WDATA_mux[31:24] <= WDATA[63:56];
      else
        WDATA_mux[31:24] <= 8'h00;
    end
    // 64 bit transfer
    2'b11:
    begin
      WDATA_mux[63:0] <= WDATA[63:0];
    end
    default:
    begin
      WDATA_mux[63:0] <= WDATA[63:0];
    end
  endcase
end

// -------------------------------------------------------------------
// SYNCHRONOUS LOGIC
// -------------------------------------------------------------------

// -------------------------------------------------------------------
// Register write data (sdr) and dqm
always@(posedge ACLK or negedge ARESETN)
begin
  if (ARESETN == 1'b0)
  begin
    // reset
    sdr_dataout_reg <= 0;
    sdr_datain_reg <= 0;
    DQM <= 0;
    SA <= 0;
    BA <= 0;
    CS_N <= 0;
    CKE <= 0;
    RAS_N <= 0;
    CAS_N <= 0;
    WE_N <= 0;
    OE <= 0;
    R_VALID <= 0;
  end
  else
  begin
    // posedge clock
    sdr_dataout_reg <= sdr_dataout;
    sdr_datain_reg <= sdr_datain;
    DQM <= DQM_i;
    SA <= (SA_i);
    BA <= (BA_i);
    CS_N <= (CS_N_i);
    CKE <= (CKE_i);
    RAS_N <= (RAS_N_i); 
    CAS_N <= (CAS_N_i);
    WE_N <= (WE_N_i);
    OE <= (OE_i);
    R_VALID_reg <= (R_VALID_i);
    R_VALID <= R_VALID_reg;
  end
end

// -------------------------------------------------------------------
// Register Write Data
always@(posedge ACLK or negedge ARESETN)
begin
  if (ARESETN == 1'b0)
  begin
    // reset
    WDATA_reg[AXI_DWIDTH-1:0] <= {AXI_DWIDTH{1'b0}};
  end
  else
  begin
    // posedge clock
    if (WVALID == 1'b1 && WREADY == 1'b1)
      WDATA_reg[AXI_DWIDTH-1:0] <= WDATA_mux[AXI_DWIDTH-1:0];
    else
      WDATA_reg[AXI_DWIDTH-1:0] <= WDATA_reg[AXI_DWIDTH-1:0];
  end
end

// -------------------------------------------------------------------
// Register/Capture Read Data
// For 16/32/64 bit data

// AS: SARno 45369, registered output data

generate
if (SDRAM_DQSIZE == 16)
begin
  always@(posedge ACLK or negedge ARESETN)
  begin
    if (ARESETN == 1'b0)
    begin
      // reset
      RDATA_reg[AXI_DWIDTH-1:0] <= {AXI_DWIDTH{1'b0}};
    end
    else
    begin
      // posedge clock
      // read data present, register it to AXI
      if (R_VALID == 1'b1)
      begin
        case (sdr_count[1:0])
          2'b00: 
            RDATA_reg[15:0] <= sdr_dataout_reg[15:0];
          2'b01: 
            RDATA_reg[31:16] <= sdr_dataout_reg[15:0];
          2'b10:
            RDATA_reg[47:32] <= sdr_dataout_reg[15:0];
          2'b11:
            RDATA_reg[63:48] <= sdr_dataout_reg[15:0];
          default:
            RDATA_reg[15:0] <= sdr_dataout_reg[15:0];
        endcase
      end
    end
  end
end
else if (SDRAM_DQSIZE == 32)
begin
  always@(posedge ACLK or negedge ARESETN)
  begin
    if (ARESETN == 1'b0)
    begin
      // reset
      RDATA_reg[AXI_DWIDTH-1:0] <= {AXI_DWIDTH{1'b0}};
    end
    else
    begin
      // posedge clock
      // read data present, register it to AXI
      if (R_VALID == 1'b1)
      begin
        case (sdr_count[0])
          1'b0: 
            RDATA_reg[31:0] <= sdr_dataout_reg[31:0];
          1'b1: 
            RDATA_reg[63:32] <= sdr_dataout_reg[31:0];
          default:
            RDATA_reg[31:0] <= sdr_dataout_reg[31:0];
        endcase
      end
    end
  end
end
else if (SDRAM_DQSIZE == 64)
begin
  always@(posedge ACLK or negedge ARESETN)
  begin
    if (ARESETN == 1'b0)
    begin
      // reset
      RDATA_reg[AXI_DWIDTH-1:0] <= {AXI_DWIDTH{1'b0}};
    end
    else
    begin
      // posedge clock
      // read data present, register it to AXI
      if (R_VALID == 1'b1)
      begin
        RDATA_reg[63:0] <= sdr_dataout_reg[63:0];
      end
    end
  end
end

endgenerate
// -------------------------------------------------------------------
// AXI state registering
always@(posedge ACLK or negedge ARESETN)
begin
  if (ARESETN == 1'b0)
  begin
    // reset
    axi_state <= AXI_IDLE;
  end
  else
  begin
    // posedge clock
    axi_state <= axi_nextstate;
  end
end

// -------------------------------------------------------------------
// counter and buffer read/write controller
// and error generation
always@(posedge ACLK or negedge ARESETN)
begin
  if (ARESETN == 1'b0)
  begin
    axi_count[3:0] <=4'b0000;
    sdr_count[3:0] <=4'b0000;
  end
  else
  begin
    // address phase
    if (axi_state == AXI_RADR)
    begin
      // AXI decrements
      // SDR increments
      axi_count[3:0] <= ARLEN[3:0] + 4'b0001;
      sdr_count[3:0] <= 4'b0000;
    end
    else if (axi_state == AXI_WADR)
    begin
      axi_count[3:0] <= AWLEN[3:0]+ 4'b0001;
      sdr_count[3:0] <= 4'b0000;
    end
    else if (axi_state == AXI_RTRN)
    begin
      if (RREADY == 1'b1)
      begin
        axi_count <= axi_count - 1;
        sdr_count[3:0] <= 4'b0000;
      end
    end
    else if (axi_state == AXI_WTRN)
    begin
      if (WVALID == 1'b1)
      begin
        axi_count <= axi_count - 1;
        sdr_count[3:0] <= 4'b0000;
      end
    end
    else if (axi_state == AXI_RSDR)
    begin
      // Valid data present at SDR output
      if (R_VALID == 1'b1)
      begin
        sdr_count  <= sdr_count + 1;
      end
    end
    else if (axi_state == AXI_WSDR | axi_state == AXI_WREQ)
    begin
      // SDR requests data
      // AS: W_VALID indicates write has been completed
//      if (D_REQ == 1'b1)
      if (W_VALID == 1'b1)
      begin
        sdr_count  <= sdr_count + 1;
      end
    end
    else if (axi_state == AXI_RREQ)
    begin
      // read request, hold axi length for now
      axi_count <= axi_count;
    end
    else
    begin
      // AXI_IDLE
      axi_count[3:0] <= 4'b0000;
      sdr_count[3:0] <= 4'b0000;
    end
  end
end

// -------------------------------------------------------------------
// AXI control signal registering during address phase
always@(posedge ACLK or negedge ARESETN)
begin
  if (ARESETN == 1'b0)
  begin
    // reset
    B_SIZE_reg[3:0] <= 4'b0000;
    WSTRB_reg[7:0] <= 8'h00;
    asize_reg[1:0] <= 2'b00;
    alen_reg[3:0] <= 4'b0000;
    AWID_reg[3:0] <= 4'b0000;
    ARID_reg[3:0] <= 4'b0000;
  end
  else
  begin
    // posedge clock
    if (axi_state == AXI_IDLE)
    begin
      if ((ARVALID == 1'b1) || (AWVALID == 1'b1))
      begin
        // write / read
        if (AWVALID == 1'b1)
          AWID_reg[3:0] <= AWID[3:0];
        else
          ARID_reg[3:0] <= ARID[3:0];
          
        // write or read
        // AS: muxed B_SIZE_registering to account for unaligned addresses
        //B_SIZE_reg[3:0] <= B_SIZE_mux;
        B_SIZE_reg[3:0] <= B_SIZE;
        asize_reg[1:0] <= asize[1:0];
        alen_reg[3:0] <= alen[3:0];
        aburst_reg[1:0] <= aburst[1:0];
      end
    end
    else
    begin
      // register write strob when write is done
      if (WVALID == 1'b1 && WREADY == 1'b1)
      begin
        WSTRB_reg[7:0] <= WSTRB[7:0];
      end
      else
      begin
        WSTRB_reg[7:0] <= WSTRB_reg[7:0];
      end
      // non-IDLE state, hold
      B_SIZE_reg[3:0] <= B_SIZE_reg[3:0];
      asize_reg[1:0] <= asize_reg[1:0];
      ARID_reg[3:0] <= ARID_reg[3:0];
      AWID_reg[3:0] <= AWID_reg[3:0];
    end
  end
end

// -------------------------------------------------------------------
// Register SDR address from AXI address
// Control registered separately (above)
always@(posedge ACLK or negedge ARESETN)
begin
  if (ARESETN == 1'b0)
  begin
    // reset
    raddr_reg[SDRAM_RASIZE-1:0] <= {SDRAM_RASIZE{1'b0}};
  end
  else
  begin
    // posedge clock
    if ((axi_state == AXI_IDLE))
    begin
      if(ARVALID == 1'b1)
        raddr_reg[SDRAM_RASIZE-1:0] <= ARADDR_mux[SDRAM_RASIZE-1:0];        // register read address
      else if(AWVALID == 1'b1)
        raddr_reg[SDRAM_RASIZE-1:0] <= AWADDR_mux[SDRAM_RASIZE-1:0];        // register write addres
      else
        raddr_reg[SDRAM_RASIZE-1:0] <= {SDRAM_RASIZE{1'b0}};            // clear if no transfer occurring
    end
    else if ((axi_state == AXI_WSDR) || (axi_state == AXI_RSDR))
    begin
      // increment address when done current SDR transfer
      // AS: needed to add these cases for SDRAM_DQSIZE == ARSIZE/AWSIZE width
      if ((sdr_count[3:0] == B_SIZE_reg[3:0] - 1) &&
          (W_VALID == 1'b1 || R_VALID == 1'b1)
          )
        // AS: fix for SAR 43393
        // raddr_reg <= raddr_reg + B_SIZE_reg;
        raddr_reg <= raddr_next;
    end
    else
      raddr_reg[SDRAM_RASIZE-1:0] <= raddr_reg[SDRAM_RASIZE-1:0];       // hold
  end
end



// -------------------------------------------------------------------
// INSTANTIATIONS
// -------------------------------------------------------------------

// AS: removed fifos

// Instantiation SDR controller top level
CORESDR #(
  .SDRAM_RASIZE(SDRAM_RASIZE), 
  .SDRAM_CHIPS(SDRAM_CHIPS), 
  .SDRAM_COLBITS(SDRAM_COLBITS), 
  .SDRAM_ROWBITS(SDRAM_ROWBITS), 
  .SDRAM_CHIPBITS(SDRAM_CHIPBITS), 
  .SDRAM_BANKSTATMODULES(SDRAM_BANKSTATMODULES)
) 
CoreSDR_0(
  .CLK(SDRCLK), 
  .RESET_N(ARESETN), 
  .RADDR(RADDR),          // registered and held
  .B_SIZE(B_SIZE_reg),    // registered and held
  .R_REQ(R_REQ), 
  .W_REQ(W_REQ), 
  .AUTO_PCH(AUTO_PCH), 
  .RW_ACK(RW_ACK), 
  .D_REQ(D_REQ),          // used for buffer purposes, requests data on the write data bus (datain)
  .W_VALID(W_VALID), 
  .R_VALID(R_VALID_i), 
  .SD_INIT(1'b0),         // run-time init not performed
  .RAS(RAS), 
  .RCD(RCD), 
  .RRD(RRD), 
  .RP(RP), 
  .RC(RC), 
  .RFC(RFC), 
  .MRD(MRD), 
  .CL(CL), 
  .BL(BL), 
  .WR(WR), 
  .DELAY(DELAY), 
  .REF(REF), 
  .COLBITS(COLBITS), 
  .ROWBITS(ROWBITS), 
  .REGDIMM(REGDIMM), 
  .SA(SA_i), 
  .BA(BA_i), 
  .CS_N(CS_N_i), 
  .CKE(CKE_i), 
  .RAS_N(RAS_N_i), 
  .CAS_N(CAS_N_i), 
  .WE_N(WE_N_i), 
  .OE(OE_i), 
  .DQM(dqm_sdr)
); 

endmodule

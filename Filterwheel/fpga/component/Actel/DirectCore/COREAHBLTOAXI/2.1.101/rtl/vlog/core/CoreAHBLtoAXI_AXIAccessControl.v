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

module CoreAHBLtoAXI_AXIAccessControlHX (
    // AHBL interface
          HSEL,
          HADDR,
          HWRITE,
          HREADY,
          HTRANS,
          HSIZE,
          HBURST,
          HMASTLOCK,
          latch_ahb_sig_sync,
          ahb_wr_done_sync,
          ahb_rd_req_sync,
          burst_count_valid_sync,
          burst_count_r,
          rdch_fifo_full,
          wrch_fifo_empty,
     // AXI Interface
          ACLK,
          ARESETn,
          axi_wr_data,
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
          WRCH_fifo_rd_en,
          BRESP_sync,
          rdch_fifo_wr_en_r,
          rdch_fifo_wr_data,
          axi_read_rlast
    );

//---------------------------------------------------
// Global parameters
//---------------------------------------------------
  parameter   AHB_AWIDTH   = 32; 
  parameter   AHB_DWIDTH   = 32; 
  parameter   AXI_AWIDTH   = 32; 
  parameter   AXI_DWIDTH   = 64; 
  parameter   CLOCKS_ASYNC = 1; 
  parameter   UNDEF_BURST  = 0;  // if '0' then single transter else INCR16
  
  localparam  AXI_WRSTB   = AXI_DWIDTH / 8;
  localparam WRITE_C      = 1'b1;   // write constant
  localparam READ_C       = 1'b0;   // read constant
  
  localparam RESPOK_C     = 2'b00;   // response OKAY from AXI
  localparam RESPERR_C    = 2'b01;   // response ERROR from AXI

// State machine variables
  localparam IDLE            = 3'b000;
  localparam SEND_WR_ADDR    = 3'b001;
  localparam SEND_WR_DATA    = 3'b010;
  localparam READ_WR_RESP    = 3'b011;
  localparam SEND_RD_ADDR    = 3'b100;
  localparam READ_RD_DATA    = 3'b101;


//---------------------------------------------------
// Input-Output Ports
//---------------------------------------------------
  // Inputs on the AHBL interface
  input                     HSEL;
  input [AHB_AWIDTH-1:0]    HADDR;
  input                     HWRITE;
  input                     HREADY;
  input [1:0]               HTRANS;
  input [2:0]               HSIZE;
  input [2:0]               HBURST;
  input                     HMASTLOCK;
  input                     latch_ahb_sig_sync;
  input                     ahb_wr_done_sync;
  input                     ahb_rd_req_sync;
  input [3:0]               burst_count_r;
  input                     burst_count_valid_sync;
  input                     rdch_fifo_full;
  input                     wrch_fifo_empty;
  
  // Inputs on AXI Interface
  input                     ACLK;
  input                     ARESETn;
  input                     AWREADY;
  input                     WREADY;
  input [3:0]               BID;
  input [1:0]               BRESP;
  input                     BVALID;
  input                     ARREADY;
  input [3:0]               RID;
  input [AXI_DWIDTH-1:0]    RDATA;
  input [1:0]               RRESP;
  input                     RLAST;
  input                     RVALID;
  input [AXI_DWIDTH-1:0]    axi_wr_data;

  // Outputs on AXI Interface
  output [3:0]              AWID;
  output [AXI_AWIDTH-1:0]   AWADDR;
  output [3:0]              AWLEN;
  output [2:0]              AWSIZE;
  output [1:0]              AWBURST;
  output                    AWVALID;
  output [3:0]              WID;
  output [AXI_DWIDTH-1:0]   WDATA;
  output [AXI_WRSTB-1:0]    WSTRB;
  output                    WLAST;
  output                    WVALID;
  output                    BREADY;
  output [3:0]              ARID;
  output [AXI_AWIDTH-1:0]   ARADDR;
  output [3:0]              ARLEN;
  output [2:0]              ARSIZE;
  output [1:0]              ARBURST;
  output [1:0]              ARLOCK;
  output                    ARVALID;
  output                    RREADY;
  output [1:0]              AWLOCK; 
  output                    WRCH_fifo_rd_en;
  output [1:0]              BRESP_sync;
  output                    rdch_fifo_wr_en_r;
  output [AHB_DWIDTH-1:0]   rdch_fifo_wr_data;
  output                    axi_read_rlast;

//-----------------------------------------------------------------------------
// Register Declarations
//-----------------------------------------------------------------------------
  reg [3:0]              AWID;
  reg [AXI_AWIDTH-1:0]   AWADDR;
  reg [3:0]              AWLEN;
  reg [2:0]              AWSIZE;
  reg [1:0]              AWBURST;
  wire                    AWVALID; 
  wire [3:0]              WID;
  wire                    WLAST;

  reg                    WVALID;
  reg                    wvalid_reg;
  wire                   BREADY;
  reg [3:0]              ARID;
  reg [AXI_AWIDTH-1:0]   ARADDR;
  reg [3:0]              ARLEN;
  reg [2:0]              ARSIZE;
  reg [1:0]              ARBURST;
  reg [1:0]              ARLOCK;
  wire                   ARVALID; 
  reg                    RREADY;
  reg [1:0]              AWLOCK; 

  reg [2:0]              axi_current_state;
  reg [2:0]              axi_next_state;

  reg                    HSEL_sync;
  reg [AHB_AWIDTH-1:0]   HADDR_sync;
  reg                    HWRITE_sync;
  reg                    HREADY_sync;
  reg [1:0]              HTRANS_sync;
  reg [2:0]              HSIZE_sync;
  reg [2:0]              HBURST_sync;
  reg                    HMASTLOCK_sync;
  
  reg                    awaddr_awvalid_set;        
  reg                    wvalid_set;
  reg                    wvalid_clr;
  reg                    bready_set;
  reg                    burstcount_load;
  reg                    burstcount_dec;
  reg                    burstcount_dec_r;
  reg                    WRCH_fifo_rd_en;
  reg [1:0]              latch_wr_resp;
  reg                    latch_wr_resp_set;
  reg [3:0]              axiwr_burst_length;
  reg [3:0]              axird_burst_length;
  reg [1:0]              axi_burst_type;
  reg                    awaddr_awvalid_clr;
  reg [4:0]              burstcount_reg;
  reg [4:0]              burstcount_reg_r;
  reg [3:0]              burst_count_r_sync;

  reg [AXI_DWIDTH-1:0]   rdch_write_data_r;
  reg [AHB_DWIDTH-1:0]   rd_data_c;
  reg                    rdch_fifo_wr_en_r;
  reg                    axi_read_data;
  reg                    rready_set;
  reg [1:0]              axi_read_resp;
  reg                    ahb_rd_req_sync_d;
  reg                    axi_read_rlast;
  reg                    latch_ahb_sig_sync_d;
  reg [AXI_WRSTB-1:0]    axi_wstrb;
  reg [3:0]              swap_rd_data_byte;
  reg [AXI_DWIDTH-1:0]   axi_wrdata;
  reg [1:0]              wrstb_count;
  reg [2:0]              AWADDR_incr;
  reg [AXI_DWIDTH-1:0]   axi_wr_data_d;

  reg                    awaddr_awvalid_clr_d;
  reg                    araddr_arvalid_clr_d;
  reg                    araddr_arvalid_set;
  reg                    araddr_arvalid_clr;

  reg                    WREADY_reg;
  reg                    BVALID_reg;
  reg                    wvalid_reg_r;
  reg                    wvalid_set_r;
  reg                    wvalid_set_r1;
  reg                    wvalid_clr_t;
  reg                    wvalid_clr_r;
  reg [AXI_DWIDTH-1:0]   axi_wr_data_lat;


//-----------------------------------------------------------------------------
// Wire Declarations
//-----------------------------------------------------------------------------
  wire  [AHB_AWIDTH-1:0] rd_haddr;
  wire                   axi_rd_start;
  wire                   store_ahb_sig;
  wire  [3:0]            undef_wr_burst_size_32;
  wire  [3:0]            undef_rd_burst_size_32;
  wire  [3:0]            undef_wr_burst_size_64;
  wire  [3:0]            undef_rd_burst_size_64;

///////////////////////////////////////////////////////////////////////////////
//                         Start-of-code                                     //
///////////////////////////////////////////////////////////////////////////////


   
//-----------------------------------------------------------------------------
// Generate the write data to be sent to the AXI interface
// This is the 64-bit data read from the WRCHANNEL fifo and sent on the Write
// data channel on the AXI bus 
//-----------------------------------------------------------------------------
  always @(*) begin
      case (HSIZE_sync[1:0])
        2'b11 : axi_wrdata = axi_wr_data[AXI_DWIDTH-1:0];

        // Word
        2'b10 : begin
           if(HBURST_sync[2:0] == 3'b000) begin     // For Single
              axi_wrdata = (AWADDR_incr[2] == 1'b1) ? {axi_wr_data[31:0],axi_wr_data[63:32]} : {axi_wr_data[63:32],axi_wr_data[31:0]};
           end 
           else if(HBURST_sync[2:0] == 3'b001) begin  // For undef
              axi_wrdata = (AWADDR_incr[2] == 1'b1) ? {axi_wr_data[31:0],axi_wr_data[63:32]} : axi_wr_data;              
           end 
           else begin // For all bursts
              if(HBURST_sync[0] == 1'b1) begin    // For incr bursts
                 if(HADDR_sync[2] == 1'b0) begin     
                    axi_wrdata = axi_wr_data[AXI_DWIDTH-1:0];
                 end
                 else begin
                    axi_wrdata = {axi_wr_data[31:0],axi_wr_data[63:32]};
                 end
              end
              else begin       // For wrap bursts
                 if(HADDR_sync[2] == 1'b0) begin
                    axi_wrdata = axi_wr_data[AXI_DWIDTH-1:0];
                 end
                 else begin
                    axi_wrdata = {axi_wr_data[31:0],axi_wr_data[63:32]};
                 end
              end
           end           
        end
        
        // Half word
        2'b01 : 
          if(HBURST_sync[2:0] == 3'b000) begin       // For Single
             if (HADDR_sync[2:1] == 2'b00) begin
                axi_wrdata = (burstcount_reg[0] == 1'b1) ? {32'h0,axi_wr_data[63:48],axi_wr_data[15:0]} : {axi_wr_data[63:48],axi_wr_data[15:0],32'h0};
             end
             else if (HADDR_sync[2:1] == 2'b10) begin
                axi_wrdata = (burstcount_reg[0] == 1'b1) ? {axi_wr_data[63:48],axi_wr_data[15:0],32'h0} : {32'h0,axi_wr_data[63:48],axi_wr_data[15:0]};
             end
             else if (HADDR_sync[2:1] == 2'b11) begin
                axi_wrdata = {axi_wr_data[31:16],axi_wr_data[15:0],32'h0};
             end
             else begin
                axi_wrdata = axi_wr_data[AXI_DWIDTH-1:0];
             end
          end
          else if(HBURST_sync[2:0] == 3'b001) begin  // For undef
             axi_wrdata = (AWADDR_incr[2] == 1'b1) ? {axi_wr_data[31:0],axi_wr_data[63:32]} : axi_wr_data;              
          end 
          else begin // For Bursts
             if (AWADDR_incr[2:1] == 2'b00) begin
                axi_wrdata = (burstcount_reg[0] == 1'b1) ? {32'h0,axi_wr_data[63:48],axi_wr_data[15:0]} : {32'h0, axi_wr_data[63:48],axi_wr_data[47:32]};
             end
             else if (AWADDR_incr[2:1] == 2'b01) begin
                axi_wrdata = (burstcount_reg[0] == 1'b1) ? {32'h0,axi_wr_data[31:16],axi_wr_data[15:0]} : {32'h0,axi_wr_data[63:48],axi_wr_data[15:0]};
             end
             else if (AWADDR_incr[2:1] == 2'b10) begin
                axi_wrdata = (burstcount_reg[0] == 1'b1) ? {axi_wr_data[63:48],axi_wr_data[15:0],32'h0} : {axi_wr_data[63:48],axi_wr_data[47:32],32'h0};
             end
             else begin
                axi_wrdata = (burstcount_reg[0] == 1'b1) ? {axi_wr_data[31:16],axi_wr_data[15:0],32'h0} : {axi_wr_data[63:48],axi_wr_data[15:0],32'h0};
             end          
          end

        // Byte           
        2'b00 : begin 
           if (HBURST_sync[2:0] == 3'b000) begin     // For Single
              axi_wrdata = (AWADDR_incr[2] == 1'b1) ? {axi_wr_data[31:0],axi_wr_data[31:0]} : axi_wr_data;      
           end
           else if(HBURST_sync[2:0] == 3'b001) begin  // For undef
              axi_wrdata = (AWADDR_incr[2] == 1'b1) ? {axi_wr_data[31:0],axi_wr_data[63:32]} : axi_wr_data;              
           end
           else begin
              if (HBURST_sync[0] == 1'b1) begin   // For incr bursts
                 if (AWADDR_incr[2] == 1'b1) begin  
                    axi_wrdata = (burstcount_reg[0] == 1'b1) ? {axi_wr_data[31:0],32'h0} : {axi_wr_data_d[63:32],32'h0};
                 end 
                 else begin
                    axi_wrdata = (burstcount_reg[0] == 1'b1) ? {32'h0,axi_wr_data[31:0]} : {32'h0,axi_wr_data_d[63:32]};
                 end
              end
              else begin     // For wrap bursts
                 if (HADDR_sync[2] == 1'b0) begin  // Address less than 4 - lower range
                    if (AWADDR_incr[2:0] < 3'b100) begin  
                       if (AWADDR_incr[0] == 1'b1) begin  
                          axi_wrdata = {axi_wr_data[31:0],axi_wr_data[63:32]};
                       end 
                       else begin
                          axi_wrdata = axi_wr_data;
                       end
                    end
                    else begin
                       if (AWADDR_incr[0] == 1'b0) begin  
                          axi_wrdata = {axi_wr_data[31:0],axi_wr_data[63:32]};
                       end 
                       else begin
                          axi_wrdata = axi_wr_data;
                       end
                    end
                 end
                 else begin     // Address falling in upper range
                    if (AWADDR_incr[2:0] >= 3'b100) begin  
                       if (AWADDR_incr[0] == 1'b1) begin  
                          axi_wrdata = axi_wr_data;
                       end 
                       else begin
                          axi_wrdata = {axi_wr_data[31:0],axi_wr_data[63:32]};
                       end
                    end
                    else begin
                       if (AWADDR_incr[0] == 1'b0) begin  
                          axi_wrdata = axi_wr_data;
                       end 
                       else begin
                          axi_wrdata = {axi_wr_data[31:0],axi_wr_data[63:32]};
                       end
                    end
                 end
              end // else: !if(HBURST_sync[0] == 1'b1)                   
           end // else: !if(HBURST_sync[2:0] == 3'b001)           
        end // case: 2'b00
        
        default : axi_wrdata = {AXI_DWIDTH{1'b0}};
      endcase
  end

  always @(posedge ACLK or negedge ARESETn) begin
    if (ARESETn == 1'b0) begin
      burstcount_dec_r <= 1'b0;
    end
    else begin
       burstcount_dec_r <= burstcount_dec;       
    end
  end

//-----------------------------------------------------------------------------
// Generate the write strobe to be sent to the AXI interface
//-----------------------------------------------------------------------------
  always @(posedge ACLK or negedge ARESETn) begin
    if (ARESETn == 1'b0) begin
      axi_wstrb <= {AXI_WRSTB{1'b0}};
    end
    else begin
      case (HSIZE_sync[1:0])
        2'b11 : axi_wstrb <= {AXI_WRSTB{1'b1}};

        // Word
        2'b10 : if ((HBURST_sync[2:0] == 3'b000) || ((HBURST_sync[2:0] == 3'b001) && (UNDEF_BURST == 1'b0))) begin // For Single/Undef
		   if(HADDR_sync[2:0] == 3'b000) begin
              axi_wstrb <= 8'b0000_1111;
	       end
		   else if(HADDR_sync[2:0] == 3'b100) begin
              axi_wstrb <= 8'b1111_0000;
		   end
        end
        else begin  // For all bursts
           if (HBURST_sync[0] == 1'b1) begin  // For incr bursts
              if (HADDR_sync[2] == 1'b1) begin   
                 if (AWVALID && AWREADY) begin
                    axi_wstrb <= 8'b00001111 << HADDR_sync[2:0];
                 end
                 else if (WVALID && WREADY) begin
                    if (axi_wstrb == 8'hF0) begin
                       axi_wstrb <= 8'h0F;
                    end
                    else begin
                       axi_wstrb <= axi_wstrb << 4'b0100;
                    end
                 end
              end // if (HADDR_sync[2] == 1'b1)
              else begin
                 axi_wstrb <= {AXI_WRSTB{1'b1}};
              end
           end
           else begin      // For wrap bursts
              if(burstcount_reg == 5'b00000) begin
                 axi_wstrb <= axi_wstrb;                 
              end
		      else if(WVALID && WREADY && axi_wstrb == 8'hF0) begin
                 axi_wstrb <=  8'h0F;
              end
		      else if(WVALID && WREADY) begin
                 axi_wstrb <=  axi_wstrb << 4'b0100;
              end
		      else begin
                 if(wvalid_set_r) begin
                    axi_wstrb <= (AWADDR_incr[2:0] == 3'b000) ? 8'b00001111 : 8'b11110000;
                 end
              end
           end
        end

        // Half word
        2'b01 : if ((HBURST_sync[2:0] == 3'b000) || ((HBURST_sync[2:0] == 3'b001) && (UNDEF_BURST == 1'b0))) begin // For Single/Undef
                  axi_wstrb <= 8'b00000011 << HADDR_sync[2:0];
                end
        else begin  // For all bursts
           if (AWVALID && AWREADY) begin
              axi_wstrb <= 8'b00000011 << HADDR_sync[2:0];         
           end
           else if (WVALID & WREADY && HADDR_sync[1:0] == 2'b10) begin
              if (axi_wstrb == 8'hC0) begin
                 axi_wstrb <= 8'h03;
              end
              else begin
                 axi_wstrb <= axi_wstrb << 4'b0010;
              end
           end
           else if (WVALID & WREADY) begin
              if (axi_wstrb == 8'hC0) begin
                 axi_wstrb <= 8'b00000011;
              end
              else begin
                 axi_wstrb <= axi_wstrb << 4'b0010;
              end
           end
        end

        // Byte
        2'b00 : if ((HBURST_sync[2:0] == 3'b000) || ((HBURST_sync[2:0] == 3'b001) && (UNDEF_BURST == 1'b0))) begin // For Single/Undef
           axi_wstrb <= 8'b00000001 << HADDR_sync[2:0];
        end
        else begin   // For all bursts
           if (AWVALID & AWREADY) begin
              axi_wstrb <= 8'b00000001 << HADDR_sync[2:0];
           end
           else if (WVALID & WREADY) begin
              if (axi_wstrb == 8'h80) begin
                 axi_wstrb <= 8'b00000001;
              end
              else begin
                 axi_wstrb <= axi_wstrb << 1'b1;
              end
           end
        end
        
        default : axi_wstrb <= {AXI_WRSTB{1'b0}};
      endcase
    end
  end

  always @(posedge ACLK or negedge ARESETn) begin
    if (ARESETn == 1'b0) begin
      wrstb_count <= 2'b00;
    end
    else if (WLAST) begin
      wrstb_count <= 2'b00;
    end
    else if ((wvalid_reg == 1'b1) && (axi_next_state == SEND_WR_DATA)) begin
      wrstb_count <= wrstb_count + 1'b1;
    end
  end


   //-----------------------------------------------------------------------------
   // Generate the address increment logic on AXI
   // This is write data generation on the AXI interface
   //-----------------------------------------------------------------------------
   always @(posedge ACLK or negedge ARESETn) begin
      if (ARESETn == 1'b0) begin
         latch_ahb_sig_sync_d <= 1'b0;
         axi_wr_data_d        <= {AXI_DWIDTH{1'b0}};
         AWADDR_incr          <= 3'b000;
      end
      else begin
         latch_ahb_sig_sync_d <= latch_ahb_sig_sync;
         axi_wr_data_d        <= axi_wr_data[AXI_DWIDTH-1:0];
         if (AWVALID & AWREADY) begin
            AWADDR_incr <= AWADDR[2:0];
         end
         else if (WVALID && WREADY) begin
            AWADDR_incr <= AWADDR_incr + (001 << HSIZE_sync[1:0]);
         end
      end
   end

   //-----------------------------------------------------------------------------
   // Create a sync pulse to trigger the AXI state machine when there is valid
   // AHB command
   //-----------------------------------------------------------------------------
   assign store_ahb_sig = latch_ahb_sig_sync & (!latch_ahb_sig_sync_d);

   //-----------------------------------------------------------------------------
   // Synchronize the AHB signals to AXI clock on store_ahb_sig signal
   //-----------------------------------------------------------------------------
   always @(posedge ACLK or negedge ARESETn) begin : ahb_to_axi_latch_logic
      if (ARESETn == 1'b0) begin
         HSEL_sync      <= 1'b0;
         HADDR_sync     <= {AHB_AWIDTH{1'b0}};
         HWRITE_sync    <= 1'b0;
         HREADY_sync    <= 1'b0;
         HTRANS_sync    <= 2'b00;
         HSIZE_sync     <= 3'b000;
         HBURST_sync    <= 3'b000;
         HMASTLOCK_sync <= 1'b0;
      end
      else if (store_ahb_sig == 1'b1) begin
         HSEL_sync      <= HSEL;
         HADDR_sync     <= HADDR;
         HWRITE_sync    <= HWRITE;
         HREADY_sync    <= HREADY;
         HTRANS_sync    <= HTRANS;
         HSIZE_sync     <= HSIZE;
         HBURST_sync    <= HBURST;
         HMASTLOCK_sync <= HMASTLOCK;
      end
   end

//-----------------------------------------------------------------------------
// Extract AXI Burst Length from HBURST
//-----------------------------------------------------------------------------
generate if (UNDEF_BURST == 1) begin
  assign undef_wr_burst_size_32 = 4'h7;
  assign undef_wr_burst_size_64 = 4'hF;
  assign undef_rd_burst_size_32 = 4'hF;
  assign undef_rd_burst_size_64 = 4'hF;
end
else begin
  assign undef_wr_burst_size_32 = 4'h0;
  assign undef_wr_burst_size_64 = 4'h0;
  assign undef_rd_burst_size_32 = 4'h0;
  assign undef_rd_burst_size_64 = 4'h0;
end
endgenerate

//-----------------------------------------------------------------------------
// Generate AXI Write channel Burst Length from HBURST and HSYNC
//-----------------------------------------------------------------------------
generate if (AHB_DWIDTH == 32) begin : axiwr_burst_length_ahb32
  always @(*) begin
     if(HSIZE_sync[1:0] == 2'b00) begin
      case (HBURST_sync[2:0])
        3'b000 : axiwr_burst_length <= 4'h0;
        3'b001 : axiwr_burst_length <= undef_wr_burst_size_32;
        3'b010 : axiwr_burst_length <= 4'h3;
        3'b011 : axiwr_burst_length <= 4'h3;
        3'b100 : axiwr_burst_length <= 4'h7;
        3'b101 : axiwr_burst_length <= 4'h7;
        3'b110 : axiwr_burst_length <= 4'hF;
        3'b111 : axiwr_burst_length <= 4'hF;
      endcase // case (HBURST_sync[2:0])
     end // if (HSIZE_sync[1:0] == 2'b00)
     else if(HSIZE_sync[1:0] == 2'b01) begin
      case (HBURST_sync[2:0])
        3'b000 : axiwr_burst_length <= 4'h0;
        3'b001 : axiwr_burst_length <= undef_wr_burst_size_32;
        3'b010 : axiwr_burst_length <= 4'h3;
        3'b011 : axiwr_burst_length <= 4'h3;
        3'b100 : axiwr_burst_length <= 4'h7;
        3'b101 : axiwr_burst_length <= 4'h7;
        3'b110 : axiwr_burst_length <= 4'hF;
        3'b111 : axiwr_burst_length <= 4'hF;
      endcase // case (HBURST_sync[2:0])
     end // if (HSIZE_sync[1:0] == 2'b01)     
     else begin
        if(HADDR_sync[2] == 1'b0) begin         // 30/01/13 - added check to see if address starts from '4
           case (HBURST_sync[2:0])
             3'b000 : axiwr_burst_length <= 4'h0;
             3'b001 : axiwr_burst_length <= undef_wr_burst_size_32;
             3'b010 : axiwr_burst_length <= 4'h3;
             3'b011 : axiwr_burst_length <= 4'h1;
             3'b100 : axiwr_burst_length <= 4'h7;
             3'b101 : axiwr_burst_length <= 4'h3;
             3'b110 : axiwr_burst_length <= 4'hF;
             3'b111 : axiwr_burst_length <= 4'h7;
           endcase // case (HBURST_sync[2:0])
        end // if (HSIZE_sync[1:0] == 2'b01)
        else begin
           case (HBURST_sync[2:0])
             3'b000 : axiwr_burst_length <= 4'h0;
             3'b001 : axiwr_burst_length <= undef_wr_burst_size_32;
             3'b010 : axiwr_burst_length <= 4'h3;
             3'b011 : axiwr_burst_length <= 4'h3;
             3'b100 : axiwr_burst_length <= 4'h7;
             3'b101 : axiwr_burst_length <= 4'h7;
             3'b110 : axiwr_burst_length <= 4'hF;
             3'b111 : axiwr_burst_length <= 4'hF;
           endcase // case (HBURST_sync[2:0])
        end
     end // else: !if(HSIZE_sync[1:0] == 2'b10)     
  end // always @ (*)   
end // block: axiwr_burst_length_ahb32   
else begin : axiwr_burst_length_ahb64
  always @(*) begin
      case (HBURST_sync[2:0])
        3'b000 : axiwr_burst_length <= 4'h0;
        3'b001 : axiwr_burst_length <= undef_wr_burst_size_64;
        3'b010 : axiwr_burst_length <= 4'h3;
        3'b011 : axiwr_burst_length <= 4'h3;
        3'b100 : axiwr_burst_length <= 4'h7;
        3'b101 : axiwr_burst_length <= 4'h7;
        3'b110 : axiwr_burst_length <= 4'hF;
        3'b111 : axiwr_burst_length <= 4'hF;
      endcase // case (HBURST_sync[2:0])
  end 
end
endgenerate

//-----------------------------------------------------------------------------
// Generate AXI Read channel Burst Length from HBURST and HSYNC
//-----------------------------------------------------------------------------
generate if (AHB_DWIDTH == 32) begin : axi_burst_length_ahb32
  always @(*) begin     // orig
      case (HBURST_sync[2:0])
        3'b000 : axird_burst_length <= 4'h0;
        3'b001 : axird_burst_length <= undef_rd_burst_size_32;
        3'b010 : axird_burst_length <= 4'h3;
        3'b011 : axird_burst_length <= 4'h3;
        3'b100 : axird_burst_length <= 4'h7;
        3'b101 : axird_burst_length <= 4'h7;
        3'b110 : axird_burst_length <= 4'hF;
        3'b111 : axird_burst_length <= 4'hF;
      endcase
  end // always @ (*)   
end
else begin : axi_burst_length_ahb64
  always @(*) begin 
      case (HBURST_sync[2:0])
        3'b000 : axird_burst_length <= 4'h0;
        3'b001 : axird_burst_length <= undef_rd_burst_size_64;
        3'b010 : axird_burst_length <= 4'h3;
        3'b011 : axird_burst_length <= 4'h3;
        3'b100 : axird_burst_length <= 4'h7;
        3'b101 : axird_burst_length <= 4'h7;
        3'b110 : axird_burst_length <= 4'hF;
        3'b111 : axird_burst_length <= 4'hF;
      endcase
  end 
end
endgenerate

//-----------------------------------------------------------------------------
// Extract AXI Burst type from HBURST
//-----------------------------------------------------------------------------
  always @(*) begin 
      case (HBURST_sync[2:0])
        3'b000 : axi_burst_type <= 2'b01;
        3'b001 : axi_burst_type <= 2'b01;
        3'b010 : axi_burst_type <= 2'b10;
        3'b011 : axi_burst_type <= 2'b01;
        3'b100 : axi_burst_type <= 2'b10;
        3'b101 : axi_burst_type <= 2'b01;
        3'b110 : axi_burst_type <= 2'b10;
        3'b111 : axi_burst_type <= 2'b01;
      endcase
  end

//-----------------------------------------------------------------------------
// Synchronize burst count value received from the AHB Access Control logic
// This is used for for loading the initial value in burstcount_reg signal
//-----------------------------------------------------------------------------
  always @(posedge ACLK or negedge ARESETn) begin: sync_ahb_2_axi
    if (ARESETn == 1'b0) begin
      burst_count_r_sync  <= 4'b0000;
    end
    else if (burst_count_valid_sync) begin
      burst_count_r_sync  <= burst_count_r[3:0];
    end
  end

  always @(posedge ACLK or negedge ARESETn) begin 
    if (ARESETn == 1'b0) begin
      awaddr_awvalid_clr_d <= 1'b0;
    end
    else begin
      awaddr_awvalid_clr_d <= awaddr_awvalid_clr;
    end
  end 

  always @(posedge ACLK or negedge ARESETn) begin 
    if (ARESETn == 1'b0) begin
      araddr_arvalid_clr_d <= 1'b0;
    end
    else begin
      araddr_arvalid_clr_d <= araddr_arvalid_clr;
    end
  end 
         //*****************************************************************//
         //                  Write  Data Channel                            //
         //*****************************************************************//

//-----------------------------------------------------------------------------
// Latch AHB signals into AXI domain on synchronised control signal
//-----------------------------------------------------------------------------
   assign WDATA =  axi_wrdata[AXI_DWIDTH-1:0];
   assign WSTRB =  axi_wstrb;
   assign WID   =  4'h0;
   assign WLAST =  wvalid_clr;      

  always @(posedge ACLK or negedge ARESETn) begin 
    if (ARESETn == 1'b0) begin
       WREADY_reg   <= 1'b0;
       wvalid_reg_r <= 1'b0;
       wvalid_clr_r <= 1'b0;
       axi_wr_data_lat  <= {AXI_DWIDTH{1'b0}};
    end
    else begin
       WREADY_reg   <= WREADY;
       wvalid_reg_r <= wvalid_reg;
       wvalid_clr_r <= wvalid_clr;
       axi_wr_data_lat  <= axi_wrdata;       
    end
  end 

  always @(posedge ACLK or negedge ARESETn) begin 
    if (ARESETn == 1'b0) begin
       wvalid_set_r     <= 1'b0;
       wvalid_set_r1    <= 1'b0;
       burstcount_reg_r <= 5'b00000;
    end
    else begin
       wvalid_set_r     <= wvalid_set & !wvalid_reg;
       wvalid_set_r1    <= wvalid_set_r;       
       burstcount_reg_r <= burstcount_reg;
    end
  end 
   
//-----------------------------------------------------------------------------
// The logic is used to de-assert the WVALID
//-----------------------------------------------------------------------------
  always @(posedge ACLK or negedge ARESETn) begin 
    if (ARESETn == 1'b0) begin
      wvalid_clr_t <= 1'b0;
    end
    else begin
      if(axi_current_state == SEND_WR_DATA && wvalid_clr == 1'b1) begin
        wvalid_clr_t <= 1'b1;
      end
      else begin
        wvalid_clr_t <= 1'b0;
      end
    end
  end 

//-----------------------------------------------------------------------------
// Generation of WVALID signal
// wvalid_set asserts the WVALID and wvalid_clr signal de-asserts it.
//-----------------------------------------------------------------------------
  always @(posedge ACLK or negedge ARESETn) begin
    if (ARESETn == 1'b0) begin
      WVALID        <= 1'b0;
      wvalid_reg    <= 1'b0;
    end
    else begin
      if (wvalid_clr  == 1'b1 && WREADY == 1'b1) begin
        wvalid_reg  <= 1'b0;
      end
      else if (wvalid_set == 1'b1 && wvalid_clr_t == 1'b0) begin
        wvalid_reg  <= 1'b1;
      end

       WVALID <= WREADY ? (!wvalid_clr & wvalid_reg & (axi_next_state == SEND_WR_DATA)) :  wvalid_reg;
 
    end
  end


         //*****************************************************************//
         //                  Write  Address Channel                         //
         //*****************************************************************//
assign AWVALID = awaddr_awvalid_clr_d ? 1'b0 : (awaddr_awvalid_set ? 1'b1 : 1'b0);  
//-----------------------------------------------------------------------------
// Write address channel generation
//-----------------------------------------------------------------------------

always @(*) begin           // 07/02/13 - add
        AWID    <= 4'h0;
        AWADDR  <= HADDR_sync[AXI_AWIDTH-1:0];  // 07/02/13 - add
        AWLEN   <= axiwr_burst_length[3:0];
        AWBURST <= axi_burst_type[1:0];
        AWLOCK  <= {HMASTLOCK_sync,1'b0};  
         if(HBURST_sync[2:0] == 3'b000 || HBURST_sync[2:0] == 3'b001) begin
            AWSIZE   <= HSIZE_sync[2:0];
         end
         else begin  // For all bursts
            if(HBURST_sync[0] == 1'b1) begin      // For incr
               if(HADDR_sync[2] == 1'b0) begin  
                  case (HSIZE_sync[1:0])
                    2'b00: AWSIZE   <= 3'b000;  // 1 bytes in one transfer
                    2'b01: AWSIZE   <= 3'b001;  // 2 bytes in one transfer
                    2'b10: AWSIZE   <= 3'b011;  // 8 bytes in one transfer
                    2'b11: AWSIZE   <= 3'b011;
                    default: AWSIZE <= 3'b011;
                  endcase // case (HSIZE_sync[1:0])
               end
               else begin
                  case (HSIZE_sync[1:0])
                    2'b00: AWSIZE   <= 3'b000;  // 1 bytes in one transfer
                    2'b01: AWSIZE   <= 3'b001;  // 2 bytes in one transfer
                    2'b10: AWSIZE   <= 3'b010;  // 4 bytes in one transfer
                    2'b11: AWSIZE   <= 3'b011;
                    default: AWSIZE <= 3'b011;
                  endcase // case (HSIZE_sync[1:0])
               end
            end
            else begin  // For wrap
               case (HSIZE_sync[1:0])
                 2'b00: AWSIZE   <= 3'b000;  // 1 bytes in one transfer
                 2'b01: AWSIZE   <= 3'b001;  // 2 bytes in one transfer
                 2'b10: AWSIZE   <= 3'b010;  // 4 bytes in one transfer
                 2'b11: AWSIZE   <= 3'b011;
                 default: AWSIZE <= 3'b011;
               endcase // case (HSIZE_sync[1:0])
            end
         end
end


//-----------------------------------------------------------------------------
// burstcount_reg holds the burst count value
// The count value is decremented on the burstcount_dec assertion
//-----------------------------------------------------------------------------
  always @(posedge ACLK or negedge ARESETn) begin
    if (ARESETn == 1'b0) begin
      burstcount_reg    <= 5'b00000;
    end
    else begin
      // Load the burst count value
      if (burstcount_load == 1'b1) begin
        if((HSIZE_sync[1:0]==2'b00 && HBURST_sync != 3'b000 && HBURST_sync != 3'b001)) begin    // Byte bursts
           if(HBURST_sync[0] == 1'b1) begin  // incr
              burstcount_reg <= 1'b1 + (burst_count_r_sync[3:0]);
           end
           else begin  // wrap
              burstcount_reg <= burst_count_r_sync[3:0];
           end
        end 
        else if((HSIZE_sync[1:0]==2'b01 && HBURST_sync != 3'b000 && HBURST_sync != 3'b001)) begin  // HW bursts
           burstcount_reg <= 1'b1 + (burst_count_r_sync[3:0]);
        end
        else if((HSIZE_sync[1:0]==2'b10 && HBURST_sync != 3'b000 && HBURST_sync != 3'b001)) begin  // Word bursts
           if(HBURST_sync[0] == 1'b1) begin  // incr
              burstcount_reg <= 1'b1 + ((HADDR_sync[2] == 1'b0) ? (burst_count_r_sync[3:0] >> 1) : burst_count_r_sync[3:0]);              
           end
           else begin  // wrap
              burstcount_reg <= burst_count_r_sync[3:0];
           end
        end
        else if((HSIZE_sync[1:0]==2'b10 && HBURST_sync == 3'b001)) begin  // Word undef 
           burstcount_reg <= 1'b1 + (burst_count_r_sync[3:0] >> 1);
        end
        else begin   // Single
           burstcount_reg <= 1'b1 + (burst_count_r_sync[3:0] >> 1);
        end
      end
      else if (burstcount_dec == 1'b1) begin
        burstcount_reg <= burstcount_reg - 1'b1;
      end
 
    end
  end


         //*****************************************************************//
         //                  Write Response Channel                         //
         //*****************************************************************//

//-----------------------------------------------------------------------------
// Generation of BREADY write response ready signal
// BREADY is always asserted
//-----------------------------------------------------------------------------
  assign BREADY     = 1'b1;
  assign BRESP_sync = latch_wr_resp[1:0];

//-----------------------------------------------------------------------------
// Latch the write response received on the response channel
//-----------------------------------------------------------------------------
  always @(posedge ACLK or negedge ARESETn) begin
    if (ARESETn == 1'b0) begin
      latch_wr_resp <= 2'b00;
    end
    else begin
      // write response
      if (latch_wr_resp_set == 1'b1) begin
        latch_wr_resp[1:0] <= BRESP[1:0];
      end
    end // else: !if(ARESETn == 1'b0)
  end // always @ (posedge ACLK or negedge ARESETn)

  always @(posedge ACLK or negedge ARESETn) begin 
    if (ARESETn == 1'b0) begin
       BVALID_reg   <= 1'b0;
    end
    else begin
       BVALID_reg   <= BVALID;
    end
  end 


         //*****************************************************************//
         //                  Read Address Channel                           //
         //*****************************************************************//
assign  ARVALID = araddr_arvalid_clr_d ? 1'b0 : (araddr_arvalid_set ? 1'b1 : 1'b0);  
//-----------------------------------------------------------------------------
// AXI Read Address channel generation
//-----------------------------------------------------------------------------
always @(*) begin   
   ARADDR  <= HADDR_sync[AXI_AWIDTH-1:0];
   ARID    <= 4'h0;
   ARLEN   <= axird_burst_length[3:0];
   ARSIZE  <= HSIZE_sync[2:0];
   ARBURST <= axi_burst_type[1:0];
   ARLOCK  <= {HMASTLOCK_sync,1'b0};
end


//-----------------------------------------------------------------------------
// Generation of write enable to RDCHANNEL fifo
//-----------------------------------------------------------------------------
  always @(posedge ACLK or negedge ARESETn) begin
    if (ARESETn == 1'b0) begin
      ahb_rd_req_sync_d <= 1'b0;
      rdch_fifo_wr_en_r <= 1'b0;
    end
    else begin
      ahb_rd_req_sync_d <= ahb_rd_req_sync;
      rdch_fifo_wr_en_r <= axi_read_data;
    end
  end


         //*****************************************************************//
         //                  Read Data Channel                              //
         //*****************************************************************//
//-----------------------------------------------------------------------------
// Generation of RREADY 
//-----------------------------------------------------------------------------
  always @(posedge ACLK or negedge ARESETn) begin
    if (ARESETn == 1'b0) begin
       RREADY <= 1'b0;
    end
    else begin
      if (rready_set == 1'b1) begin
        RREADY <= 1'b1;
      end
      else begin
        RREADY <= 1'b0;
      end
    end
  end

  assign rd_haddr = HADDR_sync;

//-----------------------------------------------------------------------------
// Latch the incoming read data from the AXI Read data channel 
//-----------------------------------------------------------------------------
  always @(posedge ACLK or negedge ARESETn) begin
    if (ARESETn == 1'b0) begin
      rdch_write_data_r <= {AXI_DWIDTH{1'b0}};
    end
    else begin
      if (axi_read_data == 1'b1) begin
        rdch_write_data_r[AXI_DWIDTH-1:0] <= RDATA[AXI_DWIDTH-1:0];
      end
    end
  end

  always @(*) begin
    case (HSIZE_sync[1:0]) 
      2'b11: rd_data_c = rdch_write_data_r[AXI_DWIDTH-1:0];

      // Word
      2'b10: begin
         if(HBURST_sync[2:0] == 3'b000 || HBURST_sync[2:0] == 3'b001) begin // For Single/undef
            if (rd_haddr[2:0] == 3'b000) begin
               rd_data_c[31:0] = rdch_write_data_r[31:0];
            end 
            else begin
               rd_data_c[31:0] = rdch_write_data_r[63:32];		     
            end
         end
         else begin  // For all other burst types
            if (rd_haddr[2:0] == 3'b000) begin
               rd_data_c[31:0] = (swap_rd_data_byte[0] == 1'b1) ? rdch_write_data_r[31:0] : rdch_write_data_r[63:32];
            end 
            else begin
               rd_data_c[31:0] = (swap_rd_data_byte[0] == 1'b1) ? rdch_write_data_r[63:32] : rdch_write_data_r[31:0];		     
            end
         end // else: !if(HBURST_sync[2:0] == 3'b000)
      end      
      
      // Half word
      2'b01: begin
         if(HBURST_sync[2:0] == 3'b000 || HBURST_sync[2:0] == 3'b001) begin  // For Single/undef
            if (rd_haddr[2:0] < 3'b100) begin
               if (rd_haddr[1:0] == 2'b00 || rd_haddr[1:0] == 2'b10) begin 
                  rd_data_c[31:0] = rdch_write_data_r[31:0];
               end
               else begin
                  rd_data_c[31:0] = rdch_write_data_r[63:32];
               end
            end
            else begin
               if (rd_haddr[1:0] == 2'b00 || rd_haddr[1:0] == 2'b10) begin 
                  rd_data_c[31:0] = rdch_write_data_r[63:32];
               end
               else begin
                  rd_data_c[31:0] = rdch_write_data_r[31:0];
               end
            end // else: !if(rd_haddr[2:0] < 3'b100)
         end
         else begin  // For all other burst types
            if (rd_haddr[2:0] < 3'b100) begin
               if (rd_haddr[1:0] == 2'b00) begin 
                  rd_data_c[31:0] = ((swap_rd_data_byte[1:0] == 2'b01) || (swap_rd_data_byte[1:0] == 2'b10)) ? 
                                    rdch_write_data_r[31:0] : rdch_write_data_r[63:32];
               end
               else begin
                  rd_data_c[31:0] = ((swap_rd_data_byte[1:0] == 2'b11) || (swap_rd_data_byte[1:0] == 2'b10)) ? 
                                    rdch_write_data_r[31:0] : rdch_write_data_r[63:32];
               end
            end
            else begin
               if (rd_haddr[1:0] == 2'b00) begin 
                  rd_data_c[31:0] = ((swap_rd_data_byte[1:0] == 2'b01) || (swap_rd_data_byte[1:0] == 2'b10)) ? 
                                    rdch_write_data_r[63:32] : rdch_write_data_r[31:0];
               end
               else begin
                  rd_data_c[31:0] = ((swap_rd_data_byte[1:0] == 2'b11) || (swap_rd_data_byte[1:0] == 2'b10)) ? 
                                    rdch_write_data_r[63:32] : rdch_write_data_r[31:0];
               end
            end // else: !if(rd_haddr[2:0] < 3'b100)
         end // else: !if(HBURST_sync[2:0] == 3'b000)
         
      end // case: 2'b01
      
      // Byte
      2'b00: begin
         if(HBURST_sync[2:0] == 3'b000 || HBURST_sync[2:0] == 3'b001) begin  // For Single/undef
            if ((rd_haddr[2:0] < 3'b100)) begin
               rd_data_c[31:0] = ((swap_rd_data_byte[2:0] == 3'b001) || (swap_rd_data_byte[2:0] == 3'b010) || 
                                  (swap_rd_data_byte[2:0] == 3'b011) || (swap_rd_data_byte[2:0] == 3'b000)) ? 
                                 rdch_write_data_r[31:0] : rdch_write_data_r[63:32];
            end
            else begin
               rd_data_c[31:0] = ((swap_rd_data_byte[2:0] == 3'b101) || (swap_rd_data_byte[2:0] == 3'b110) ||
                                  (swap_rd_data_byte[2:0] == 3'b111) || (swap_rd_data_byte[2:0] == 3'b100)) ? 
                                 rdch_write_data_r[63:32] : rdch_write_data_r[31:0];
            end
         end
         else begin  // For all other burst types
            if ((rd_haddr[2:0] < 3'b100)) begin
               rd_data_c[31:0] = ((swap_rd_data_byte[3:0] == 4'b0001) || (swap_rd_data_byte[3:0] == 4'b0010) || 
                                  (swap_rd_data_byte[3:0] == 4'b1001) || (swap_rd_data_byte[3:0] == 4'b1010) || 
                                  (swap_rd_data_byte[3:0] == 4'b1011) || (swap_rd_data_byte[3:0] == 4'b1100) || 
                                  (swap_rd_data_byte[3:0] == 4'b0011) || (swap_rd_data_byte[3:0] == 4'b0100)) ? 
                                 rdch_write_data_r[31:0] : rdch_write_data_r[63:32];
            end
            else begin
               rd_data_c[31:0] = ((swap_rd_data_byte[3:0] == 4'b1000) || (swap_rd_data_byte[3:0] == 4'b0101) || 
                                  (swap_rd_data_byte[3:0] == 4'b1101) || (swap_rd_data_byte[3:0] == 4'b1110) || 
                                  (swap_rd_data_byte[3:0] == 4'b1111) || (swap_rd_data_byte[3:0] == 4'b0000) || 
                                  (swap_rd_data_byte[3:0] == 4'b0110) || (swap_rd_data_byte[3:0] == 4'b0111)) ? 
                                 rdch_write_data_r[63:32] : rdch_write_data_r[31:0];
            end
         end
      end
      
      default: rd_data_c = {AHB_DWIDTH{1'b0}};
    endcase
  end

  always @(posedge ACLK or negedge ARESETn) begin
    if (ARESETn == 1'b0) begin
      swap_rd_data_byte <= 4'b0000;
    end
    else if (HBURST_sync[2:0] == 3'b000 || HBURST_sync[2:0] == 3'b001) begin
       swap_rd_data_byte <= {1'b0,HADDR_sync[2:0]};
    end
    else if (ARREADY & ARVALID) begin
      swap_rd_data_byte <= {1'b0,ARADDR[2:0]};
    end
    else if (RREADY & RVALID) begin
      swap_rd_data_byte <= swap_rd_data_byte + 1'b1;
    end
  end

//-----------------------------------------------------------------------------
// Write data to RDCHANNEL fifo
// The data is the Read data from AXI Read data channel
//-----------------------------------------------------------------------------
  assign rdch_fifo_wr_data = rd_data_c;

//-----------------------------------------------------------------------------
// Generate start signal for read channel fifo to enable read from AHB side
//-----------------------------------------------------------------------------
  always @(posedge ACLK or negedge ARESETn) begin : gen_start_for_rdch_read
    if (ARESETn == 1'b0) begin
      axi_read_rlast <= 1'b0;
    end
    else begin
      axi_read_rlast <= RLAST & RVALID & RREADY;
    end
  end

//-----------------------------------------------------------------------------
// Invokes the AXI State machine on ahb_rd_req coming from the AHB Access Ctrl
//-----------------------------------------------------------------------------
  assign axi_rd_start      = ~ahb_rd_req_sync & ahb_rd_req_sync_d;

//-----------------------------------------------------------------------------
// Sequential block for State Machine
//-----------------------------------------------------------------------------
  always @(posedge ACLK or negedge ARESETn) begin : axi_state_machine_seq_logic
    if (ARESETn == 1'b0) begin
      axi_current_state <= IDLE;
    end
    else begin
      axi_current_state <= axi_next_state;
    end
  end 

//-----------------------------------------------------------------------------
// Combinational block for State Machine
//-----------------------------------------------------------------------------
  always @(*) begin : axi_state_machine_combo_logic
    axi_next_state     = axi_current_state;
    awaddr_awvalid_set = 1'b0;
    araddr_arvalid_set = 1'b0;
    awaddr_awvalid_clr = 1'b0;
    araddr_arvalid_clr = 1'b0;
    wvalid_set         = 1'b0;
    wvalid_clr         = 1'b0;
    bready_set         = 1'b0;
    burstcount_load    = 1'b0;
    burstcount_dec     = 1'b0;
    WRCH_fifo_rd_en    = 1'b0;
    latch_wr_resp_set  = 1'b0;
    axi_read_resp[1:0] = 2'b00;
    axi_read_data      = 1'b0;
    rready_set         = 1'b0;
 
    case (axi_current_state)
      //---------------------------------------
      // IDLE STATE
      //---------------------------------------
      IDLE : 
        begin
          if (ahb_wr_done_sync == 1'b1) begin
            axi_next_state = SEND_WR_ADDR;
          end 
          else if (axi_rd_start == 1'b1) begin
            axi_next_state = SEND_RD_ADDR;
          end
        end
      //-------------------------------------------
      // SEND WRITE ADDRESS AND CONTROL ON AXI BUS
      //-------------------------------------------
      SEND_WR_ADDR : 
        begin
          awaddr_awvalid_set = 1'b1;
          burstcount_load    = 1'b1;
          if (AWREADY == 1'b1) begin
            awaddr_awvalid_clr = 1'b1;
            case (HWRITE_sync)
              WRITE_C :
                begin
                  axi_next_state = SEND_WR_DATA;
                end
              READ_C :
                begin
                  axi_next_state = READ_RD_DATA;
                end
            endcase
          end
          else begin
            awaddr_awvalid_clr = 1'b0;
          end 
        end
      //-------------------------------------------
      // SEND WRITE DATA ON AXI WRITE DATA BUS
      //-------------------------------------------
      SEND_WR_DATA : 
        begin
          burstcount_load    = 1'b0;
          bready_set = 1'b1;
          wvalid_set = 1'b1;
           if(HBURST_sync == 3'b000) begin      // All Single
 	          //if (wvalid_reg_r == 1'b1 && WREADY == 1'b1) begin
 	          if (wvalid_reg_r == 1'b1 && wvalid_reg == 1'b1) begin // added on 6th May
                 wvalid_clr = 1'b1;
              end 
              else begin
                 wvalid_clr = 1'b0;
              end
              
              if (burstcount_reg == 5'b00000) begin  // Last burst count
                 axi_next_state = READ_WR_RESP;
              end
              else begin               // Not a last burst count
                 if (wvalid_reg == 1'b1 && wvalid_set_r == 1'b1) begin
                    WRCH_fifo_rd_en    = (HSIZE_sync[1:0] == 2'b00) ? burstcount_reg[0] : 1'b1;
                 end
                 else begin
                    WRCH_fifo_rd_en    = 1'b0;
                 end
                 
                 if (wvalid_reg_r == 1'b1 && WREADY == 1'b1) begin // Wready added by mahesh
                    burstcount_dec = 1'b1;
                 end
                 else begin
                    burstcount_dec = 1'b0;
                 end	      
              end
           end
           // For word undef
	       else if(HBURST_sync == 3'b001 && HSIZE_sync[1:0] == 2'b10) begin
              if (burstcount_reg == 5'b00000) begin
                 if (wvalid_reg == 1'b1) begin
                    wvalid_clr = 1'b1;
                 end 
                 else begin
                    wvalid_clr = 1'b0;
                 end

                 if (wvalid_reg == 1'b1 && WREADY == 1'b1) begin
                    axi_next_state = READ_WR_RESP;
                 end
              end
              else begin               // Not a last burst count
                 if (WREADY && wvalid_reg) begin
                    burstcount_dec = 1'b1;
                    WRCH_fifo_rd_en    = 1'b1;
                 end
                 else begin
                    burstcount_dec = 1'b0;
                    WRCH_fifo_rd_en = 1'b0;
                 end
              end
           end
           // For Halfword undef
	       else if(HBURST_sync == 3'b001 && HSIZE_sync[1:0] == 2'b01) begin
              if (burstcount_reg == 5'b00000) begin
                 if (wvalid_reg == 1'b1) begin
                    wvalid_clr = 1'b1;
                 end 
                 else begin
                    wvalid_clr = 1'b0;
                 end

                 if (wvalid_reg == 1'b1 && WREADY == 1'b1) begin
                    axi_next_state = READ_WR_RESP;
                 end
              end
              else begin               // Not a last burst count
                 if (WREADY && wvalid_reg) begin
                    burstcount_dec = 1'b1;
                    WRCH_fifo_rd_en    = 1'b1;
                 end
                 else begin
                    burstcount_dec = 1'b0;
                    WRCH_fifo_rd_en = 1'b0;
                 end
              end
           end
           // For Byte undef
	       else if(HBURST_sync == 3'b001 && HSIZE_sync[1:0] == 2'b00) begin
              if (burstcount_reg == 5'b00000) begin
                 if (wvalid_reg == 1'b1) begin
                    wvalid_clr = 1'b1;
                 end 
                 else begin
                    wvalid_clr = 1'b0;
                 end

                 if (wvalid_reg == 1'b1 && WREADY == 1'b1) begin
                    axi_next_state = READ_WR_RESP;
                 end
              end
              else begin               // Not a last burst count
                 if (WREADY && wvalid_reg) begin
                    burstcount_dec = 1'b1;
                    WRCH_fifo_rd_en    = 1'b1;
                 end
                 else begin
                    burstcount_dec = 1'b0;
                    WRCH_fifo_rd_en = 1'b0;
                 end
              end
           end
	       else begin        // All Bursts
              if (burstcount_reg == 5'b00000) begin
                 if (wvalid_reg == 1'b1) begin
                    wvalid_clr = 1'b1;
                 end 
                 else begin
                    wvalid_clr = 1'b0;
                 end

                 if (wvalid_reg == 1'b1 && WREADY == 1'b1) begin
                    axi_next_state = READ_WR_RESP;
                 end
              end
              else begin               // Not a last burst count
                 if (HBURST_sync[0] == 1'b1) begin  // incr bursts
                    if (WREADY && wvalid_reg) begin
                       burstcount_dec = 1'b1;
                       if ((HSIZE_sync[1:0] == 2'b00 || HSIZE_sync[1:0] == 2'b01)) begin  
                          WRCH_fifo_rd_en    = ~burstcount_reg[0];
                       end
                       else if ((HSIZE_sync[1:0] == 2'b10 && HADDR_sync[2] == 1'b1)) begin  
                          WRCH_fifo_rd_en    = ~burstcount_reg[0];
                       end
                       else begin  
                          WRCH_fifo_rd_en    = 1'b1;
                       end
                    end
                    else begin
                       burstcount_dec = 1'b0;
                       WRCH_fifo_rd_en    = 1'b0;
                    end
                 end
                 else begin     // wrap bursts
                    if (WREADY && wvalid_reg && !wvalid_set_r1) begin
                       burstcount_dec = 1'b1;
                    end
                    else begin
                       burstcount_dec = 1'b0;
                    end
                    if (wvalid_set_r || (!burstcount_reg[0] && WREADY && !wvalid_set_r1)) begin       // wrap
                       WRCH_fifo_rd_en    = 1'b1;
                    end
                    else begin
                       WRCH_fifo_rd_en    = 1'b0;
                    end
                 end // else: !if(HBURST_sync[0] == 1'b1)
              end
           end
        end
      //-------------------------------------------
      // GET WRITE RESPONSE FROM AXI SLAVE
      //-------------------------------------------
      READ_WR_RESP : 
        begin
          if ((BVALID_reg == 1'b1) && (BREADY == 1'b1)) begin
            latch_wr_resp_set = 1'b1;
            axi_next_state = IDLE;
          end
          else begin
            latch_wr_resp_set = 1'b0;
          end
        end
      //-------------------------------------------
      // SEND READ ADDRESS AND CONTROL ON AXI BUS
      //-------------------------------------------
      SEND_RD_ADDR : 
        begin
          araddr_arvalid_set = 1'b1;
          burstcount_load    = 1'b1;
          rready_set = 1'b1;
          if (ARREADY == 1'b1) begin
            araddr_arvalid_clr = 1'b1;
            case (HWRITE_sync)
              WRITE_C :
                begin
                  axi_next_state = SEND_WR_DATA;
                end
              READ_C :
                begin
                  axi_next_state = READ_RD_DATA;
                end
            endcase
          end
          else begin
            araddr_arvalid_clr = 1'b0;
          end 
        end
      //-------------------------------------------
      // READ AXI DATA AND WRITE INTO RDCH FIFO
      //-------------------------------------------
      READ_RD_DATA : 
        begin
          burstcount_load    = 1'b0;
          rready_set = 1'b1;
          axi_read_data = 1'b0;
          if (RLAST == 1'b1) begin  // Last burst transfer
            if (RVALID == 1'b1) begin
              axi_read_data = 1'b1;
              if (RRESP == RESPOK_C) begin // OKAY response
                axi_read_resp[1:0] = RESPOK_C;
              end
              else begin  // ERROR response
                axi_read_resp[1:0] = RESPERR_C;
              end
              axi_next_state = IDLE;
              rready_set = 1'b0;
            end
            else begin
            end
          end 
          else begin   
            if ((RVALID == 1'b1) && (RREADY == 1'b1)) begin
              axi_read_data = 1'b1;
              if (RRESP == RESPOK_C) begin  // OKAY response
                axi_read_resp[1:0] = RESPOK_C;
              end
              else begin   // Error respnose
                axi_read_resp[1:0] = RESPERR_C;
              end
            end
            else begin
            end
          end
        end
      default : 
        begin
          axi_next_state = axi_current_state;
        end
    endcase
  end 


endmodule // AXIAccessControlHX


///////////////////////////////////////////////////////////////////////////////
//                         End-of-code                                       //
///////////////////////////////////////////////////////////////////////////////


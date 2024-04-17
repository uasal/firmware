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

module CoreAHBLtoAXI_AHBAccessControlHX (
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
          BVALID_sync,
          BRESP_sync,
          wrch_fifo_full,
          rdch_fifo_empty,
          axi_read_rlast_sync,
          RD_DATA,
          HREADYOUT,
          HRESP,
          HRDATA,
          hwdata_r,
          wrch_fifo_wr_en_r,
          rdch_fifo_rd_en_r,
          ahb_wr_done,
          ahb_rd_req,
          latch_ahb_sig,
          burst_count_r,
          burst_count_valid,
          HSEL_d,
          HADDR_d,
          HWRITE_d,
          HREADY_d,
          HTRANS_d,
          HSIZE_d,
          HBURST_d,
          HMASTLOCK_d,
          valid_ahbcmd,
          ahb_busyidle_cyc
    );

//---------------------------------------------------
// Global parameters
//---------------------------------------------------
  parameter   AHB_AWIDTH   = 32; 
  parameter   AHB_DWIDTH   = 32; 
  parameter   CLOCKS_ASYNC = 1; 
  parameter   UNDEF_BURST  = 0;  // if '0' then single transter else INCR16


// State machine variables
  localparam IDLE            = 3'b000;
  localparam WR_IN_FIFO      = 3'b001;
  localparam WAIT_FOR_RESP   = 3'b010;
  localparam RD_FROM_FIFO    = 3'b011;
  localparam WR_RESP_ERR     = 3'b100;
  localparam WAIT_STATE     = 3'b101;
  localparam READ_DONE      = 3'b110;
  localparam DUMMY_WAIT     = 3'b111;

  localparam WRITE_C      = 1'b1;   // write constant
  localparam READ_C       = 1'b0;   // read constant

  localparam RESPOK_C     = 2'b00;   // response OKAY from AXI
  localparam RESPERR_C    = 2'b01;   // response ERROR from AXI

//---------------------------------------------------
// Input-Output Ports
//---------------------------------------------------
  // Inputs on the AHBL interface
  input                     HCLK;
  input                     HRESETn;
  input                     HSEL;
  input [AHB_AWIDTH-1:0]    HADDR;
  input                     HWRITE;
  input                     HREADY;
  input [1:0]               HTRANS;
  input [2:0]               HSIZE;
  input [AHB_DWIDTH-1:0]    HWDATA;
  input [2:0]               HBURST;
  input                     HMASTLOCK;
  input                     BVALID_sync;
  input [1:0]               BRESP_sync;
  input                     wrch_fifo_full;
  input                     rdch_fifo_empty;
  input [AHB_DWIDTH-1:0]    RD_DATA;
  input                     axi_read_rlast_sync;
  
  // Outputs on the AHBL Interface
  output                    HREADYOUT;
  output [1:0]              HRESP;
  output [AHB_DWIDTH-1:0]   HRDATA;
  output [AHB_DWIDTH-1:0]   hwdata_r;
  output                    wrch_fifo_wr_en_r;
  output                    rdch_fifo_rd_en_r;
  output                    ahb_wr_done;
  output                    ahb_rd_req;
  output                    latch_ahb_sig;
  output [3:0]              burst_count_r;
  output                    burst_count_valid;
  output                    HSEL_d;
  output [AHB_AWIDTH-1:0]   HADDR_d;
  output                    HWRITE_d;
  output                    HREADY_d;
  output [1:0]              HTRANS_d;
  output [2:0]              HSIZE_d;
  output [2:0]              HBURST_d;
  output                    HMASTLOCK_d;
  output                    valid_ahbcmd;
  output                    ahb_busyidle_cyc;
  

//-----------------------------------------------------------------------------
// Register Declarations
//-----------------------------------------------------------------------------
  reg                  burst_count_valid;
  reg  [2:0]           current_state;
  reg  [2:0]           next_state;
  reg                  latchahbcmd;
  reg  [3:0]           burst_count_r;
  reg  [4:0]           burst_num_r;
  reg                  fifo_wr_en;
  reg                  ahb_busyidle_cyc;
  reg                  wrch_fifo_wr_en_r;
  reg                  fifo_rd_en;
  reg                  rdch_fifo_rd_en_r;
  reg                  rdch_fifo_rd_en_r_d;
  reg                  HREADYOUT;
  reg [1:0]            HRESP;
  reg [AHB_DWIDTH-1:0] hwdata_r;

  reg                  burst_count_load;
  reg                  ahb_wr_done;
  reg                  ahb_rd_req;
  reg                  latch_ahb_sig;
  reg [1:0]            wr_resp_reg;
  reg                  BVALID_sync_d;
  reg                  HSEL_d;
  reg [AHB_AWIDTH-1:0] HADDR_d;
  reg                  HWRITE_d;
  reg                  HREADY_d;
  reg [1:0]            HTRANS_d;
  reg [2:0]            HSIZE_d;
  reg [2:0]            HBURST_d;
  reg                  HMASTLOCK_d;
  reg [1:0]            wait_count;
  reg [1:0]            count;

  reg [AHB_DWIDTH-1:0] RD_DATA_d1;
  reg [AHB_DWIDTH-1:0] RD_DATA_d2;

  reg                  set_idle_cyc;
  reg                  set_idle_cyc_r;
  reg                  latchahbcmd_r;
  reg                  latchahbcmd_undef;
  reg                  latchahbcmd_undef_r;
  reg                  latchahbcmd_rd_undef;
  reg                  latchahbcmd_rd_undef_r;
  wire                  valid_ahbcmd_undef;  
  wire                  valid_ahbcmd_rd_undef;
  reg                  valid_ahbcmd_r;
  reg                  HSEL_undef_d;
  reg [AHB_AWIDTH-1:0] HADDR_undef_d;
  reg                  HWRITE_undef_d;
  reg                  HREADY_undef_d;
  reg [1:0]            HTRANS_undef_d;
  reg [2:0]            HSIZE_undef_d;
  reg [2:0]            HBURST_undef_d;
  reg                  HMASTLOCK_undef_d;
  
//-----------------------------------------------------------------------------
// Wire Declarations
//-----------------------------------------------------------------------------
  wire [AHB_DWIDTH-1:0] HRDATA;
  wire                 valid_ahbcmd;
  wire                 busy_idle_state;
  wire [3:0]           burst_count;
   
///////////////////////////////////////////////////////////////////////////////
//                       Start-of-Code                                       //
///////////////////////////////////////////////////////////////////////////////

   //-----------------------------------------------------------------------------
   // Generate the valid ahb command signal
   //-----------------------------------------------------------------------------
   assign valid_ahbcmd = HSEL & HREADY & (HTRANS[1:0] == 2'b10);    
   
   //-----------------------------------------------------------------------------
   // Generate the valid ahb command signal for undefined transactions for write
   //-----------------------------------------------------------------------------
   assign valid_ahbcmd_undef = (HWRITE && HSEL && HREADY && (HTRANS[1:0] == 2'b11));  


   //-----------------------------------------------------------------------------
   // Generate the valid ahb command signal for undefined transactions for read
   //-----------------------------------------------------------------------------
   assign valid_ahbcmd_rd_undef = (!HWRITE && HSEL && HREADY && (HTRANS[1:0] == 2'b11));  

  always @(posedge HCLK or negedge HRESETn) begin
    if (HRESETn == 1'b0) begin
       valid_ahbcmd_r         <= 1'b0;
       latchahbcmd_r          <= 1'b0;
       latchahbcmd_undef_r    <= 1'b0;
       latchahbcmd_rd_undef_r <= 1'b0;
    end
    else begin
       valid_ahbcmd_r         <= valid_ahbcmd;
       latchahbcmd_r          <= latchahbcmd;
       latchahbcmd_undef_r    <= latchahbcmd_undef;
       latchahbcmd_rd_undef_r <= latchahbcmd_rd_undef;
    end
  end

   //-----------------------------------------------------------------------------
   // This signal is used by the AXI Access control to initiate its state m/c
   //-----------------------------------------------------------------------------
   always @(posedge HCLK or negedge HRESETn) begin : register_cntrl_signal
    if (HRESETn == 1'b0) begin
       latch_ahb_sig <= 1'b0;
    end
    else if ((valid_ahbcmd || valid_ahbcmd_undef || valid_ahbcmd_rd_undef)  && latchahbcmd) begin  
       latch_ahb_sig <= 1'b1;
    end
    else begin
       latch_ahb_sig <= 1'b0;
    end
   end // block: register_cntrl_signal

   //-----------------------------------------------------------------------------
   // This register is read by AHB host to get Write response.
   //-----------------------------------------------------------------------------
   always @(posedge HCLK or negedge HRESETn) begin : latch_wr_resp
      if (HRESETn == 1'b0) begin
         wr_resp_reg <= 2'b00;
      end
      else if (BVALID_sync) begin
         wr_resp_reg <= BRESP_sync[1:0];
      end
   end

   //-----------------------------------------------------------------------------
   // Count is used to provide necessary wait and HREADYOUT is asserted high
   // when when count=2'b00 in the READ_FROM_FIFO state
   //-----------------------------------------------------------------------------
   always @(posedge HCLK or negedge HRESETn) begin
      if (HRESETn == 1'b0) begin
         count <= 2'b00;
      end
      else if (current_state == WAIT_STATE) begin
         count <= 2'b11;
      end
      else if ((current_state == RD_FROM_FIFO) && (!busy_idle_state)) begin
         count <= count - 1'b1;
      end
   end // always @ (posedge HCLK or negedge HRESETn)


   always @(posedge HCLK or negedge HRESETn) begin
      if (HRESETn == 1'b0) begin
         burst_count_valid <= 1'b0;
         BVALID_sync_d     <= 1'b0;
         set_idle_cyc_r   <= 1'b0;       
      end
      else begin
         burst_count_valid <= latchahbcmd;
         BVALID_sync_d     <= BVALID_sync;
         set_idle_cyc_r   <= set_idle_cyc;       
      end
   end


   assign busy_idle_state = (HTRANS_d[1] == 1'b0);

   //-----------------------------------------------------------------------------
   // Generate the HRDATA read data to the AHB interface
   //-----------------------------------------------------------------------------
   assign HRDATA = RD_DATA_d1;
   
   always @(posedge HCLK or negedge HRESETn) begin
      if (HRESETn == 1'b0) begin
         wrch_fifo_wr_en_r  <= 1'b0;
         rdch_fifo_rd_en_r  <= 1'b0;
      end
      else begin
         wrch_fifo_wr_en_r <= fifo_wr_en;
         rdch_fifo_rd_en_r <= fifo_rd_en;
      end
   end

   //-----------------------------------------------------------------------------
   // Calculate the burst count value to determine the number of bursts
   //-----------------------------------------------------------------------------
   generate if (UNDEF_BURST) begin  // convert to INCR16
      assign burst_count = (HBURST[2:1]   == 2'b11) ? 4'hF : 
                           ((HBURST[2:1]  == 2'b10) ? 4'h7 :
                            (((HBURST[2:1] == 2'b01) ? 4'h3 : (HBURST[0] == 1'b1 ? 4'hF : (HWRITE ? 1'b1:1'b0)))));
   end
   else begin  // convert to SINGLE 
      assign burst_count = (HBURST[2:1] == 2'b11) ? 4'hF : 
                           ((HBURST[2:1] == 2'b10) ? 4'h7 :
                            (((HBURST[2:1] == 2'b01) ? 4'h3 : (HWRITE == 1'b1 ? 4'h1 : 4'h0))));
   end
   endgenerate

   //-----------------------------------------------------------------------------
   // Calculate the burst count
   // burst_count_r = Burst value sent to the AXI interface
   // burst_num_r   = Burst value used in AHB Access Control state machine
   //                 It is decremented for every write data written into Write
   //                 channel fifo OR every read data from Read Channel fifo.
   //-----------------------------------------------------------------------------
   always @(posedge HCLK or negedge HRESETn) begin
      if (HRESETn == 1'b0) begin
         burst_count_r      <= 4'b0000;
         burst_num_r        <= 5'b00000;
      end
      else begin
         if (latchahbcmd == 1'b1) begin
            burst_count_r <= burst_count; 
         end
         
         if ((burst_count_load == 1'b1) || (axi_read_rlast_sync == 1'b1)) begin
            burst_num_r <= burst_count + (!HWRITE); 
         end
         //else if (((HREADY && current_state == WR_IN_FIFO) || ((current_state == RD_FROM_FIFO) && (fifo_rd_en)))) begin  //01/02/13 - cc
         else if (((fifo_wr_en && current_state == WR_IN_FIFO) || 
		  ((current_state == DUMMY_WAIT || current_state == RD_FROM_FIFO) && (fifo_rd_en)))) begin       //15/02/13 - 1E CHANGE
      	    burst_num_r <= burst_num_r - 1'b1;
         end
      end
   end

   //-----------------------------------------------------------------------------
   // wait_count is used is used in DUMMY_WAIT_STATE to generate the read enable
   // to the Read channel fifo
   //-----------------------------------------------------------------------------
   always @(posedge HCLK or negedge HRESETn) begin
      if (HRESETn == 1'b0) begin
         wait_count = 2'b00;
      end
      else if (current_state == DUMMY_WAIT) begin
         wait_count = wait_count + 1'b1;
      end
      else begin
         wait_count = 2'b00;
      end
   end

//---------------------------------------------------------------------------//
//                           STATE MACHINE LOGIC                             //
//---------------------------------------------------------------------------//

//-----------------------------------------------------------------------------
// Sequential block for State Machine
//-----------------------------------------------------------------------------
  always @(posedge HCLK or negedge HRESETn) begin : state_machine_seq_logic
    if (HRESETn == 1'b0) begin
      current_state <= IDLE;
    end
    else begin
      current_state <= next_state;
    end
  end

//-----------------------------------------------------------------------------
// Combinational block for State Machine
//-----------------------------------------------------------------------------
  always @(*) begin : state_machine_combo_logic
    next_state       = current_state;
    HREADYOUT        = 1'b0;
    latchahbcmd      = 1'b0;
    latchahbcmd_undef  = 1'b0;
    latchahbcmd_rd_undef  = 1'b0;
    burst_count_load = 1'b0;
    fifo_wr_en       = 1'b0;
    HRESP            = RESPOK_C;
    fifo_rd_en       = 1'b0;
    ahb_wr_done      = 1'b0;
    ahb_rd_req       = 1'b0;
     set_idle_cyc    = 1'b0;

    case (current_state)
      //--------------------------------------------------- 
      // IDLE state
      //--------------------------------------------------- 
      IDLE : 
        begin
           next_state = current_state;
           HREADYOUT  = 1'b1;    // Ready for AHB transaction
           if (valid_ahbcmd == 1'b1 || valid_ahbcmd_undef == 1'b1 || valid_ahbcmd_rd_undef == 1'b1) begin   
                latchahbcmd  = 1'b1;

              case (HWRITE)
                // Write Signal Generation
                WRITE_C : begin
                   burst_count_load = 1'b1;
                   next_state       = WR_IN_FIFO;
                end
                // Read Signal Generation
                READ_C : begin
                   burst_count_load = 1'b1;
                   next_state       = WAIT_STATE;
                   ahb_rd_req       = 1'b1;
                end
              endcase // case (HWRITE)
           end // if (valid_ahbcmd == 1'b1)
        end // case: IDLE
      
      //--------------------------------------------------- 
      // WRITE INTO WRITE CHANNEL FIFO state
      //--------------------------------------------------- 
      WR_IN_FIFO : 
        begin
           if (burst_num_r[3:0] != 4'h0 && !((HBURST == 3'b000) || (HBURST == 3'b001 && UNDEF_BURST == 0))) begin 
       	      if (wrch_fifo_full == 1'b0) begin
                 fifo_wr_en = 1'b1;
                 HREADYOUT  = 1'b1;  
              end
              else begin
                 fifo_wr_en = 1'b0;
                 HREADYOUT  = 1'b0;
              end
           end
           else if (!((HBURST_d == 3'b000) || (HBURST_d == 3'b001 && UNDEF_BURST == 0))) begin 
              fifo_wr_en = 1'b1;
              HREADYOUT  = 1'b1;
              ahb_wr_done = 1'b1;
              next_state = WAIT_FOR_RESP;
           end
           else begin
              HREADYOUT  = 1'b0;
              fifo_wr_en = 1'b1;
              
              ahb_wr_done = 1'b1;
              next_state = WAIT_FOR_RESP;
           end
      end

      //--------------------------------------------------- 
      // WAIT FOR WRITE RESPONSE FROM AXI
      //--------------------------------------------------- 
      WAIT_FOR_RESP:
        begin
           HREADYOUT  = 1'b0;
           fifo_wr_en = 1'b0;
           ahb_wr_done = 1'b0;

           // For Single and Bursts
           if (BVALID_sync_d == 1'b1 && HBURST_d[2:0] != 3'b001) begin
              // Check OK response from AXI
              if (wr_resp_reg == RESPOK_C) begin     
                 HRESP = RESPOK_C;
                 // next AHB cycle  
                 if (valid_ahbcmd == 1'b1) begin
                    latchahbcmd  = 1'b1;
                    case (HWRITE)
                      // Write Signal Generation
                      WRITE_C : begin
                         burst_count_load = 1'b1;
			 next_state       = WR_IN_FIFO;
                      end
                      // Read Signal Generation
                      READ_C : begin
                         burst_count_load = 1'b1;
                         next_state       = WAIT_STATE;
                         ahb_rd_req       = 1'b1;
                      end
                    endcase // case (HWRITE)
                 end // if (valid_ahbcmd == 1'b1)
                 else begin
                    next_state = IDLE;
                 end // else: !if(valid_ahbcmd == 1'b1)
              end // if (wr_resp_reg == RESPOK_C)
              else begin     // ERROR response from AXI
                 HREADYOUT  = 1'b0;
                 HRESP      = RESPERR_C;
                 //next state is Error state
                 next_state = WR_RESP_ERR;
              end // else: !if(wr_resp_reg == RESPOK_C)
           end // if (BVALID_sync_d == 1'b1)

           // For undef
           if (BVALID_sync == 1'b1 && HBURST_d[2:0] == 3'b001) begin 
              // Check OK response from AXI
              if (wr_resp_reg == RESPOK_C) begin     
                 HRESP = RESPOK_C;
                 // next AHB cycle  
                 if (valid_ahbcmd_undef == 1'b1) begin
                    latchahbcmd_undef  = 1'b1;
                    case (HWRITE)
                      // Write Signal Generation
                      WRITE_C : begin
                         burst_count_load = 1'b1;
                         next_state       = WR_IN_FIFO;
                         //HREADYOUT  = 1'b1; // 30/01/13
                      end
                      // Read Signal Generation
                      READ_C : begin
                         burst_count_load = 1'b1;
                         next_state       = WAIT_STATE;
                         ahb_rd_req       = 1'b1;
                      end
                    endcase // case (HWRITE)
                 end // if (valid_ahbcmd_undef == 1'b1)
                 else begin
                    next_state = IDLE;
                 end // else: !if(valid_ahbcmd_undef == 1'b1)
              end // if (wr_resp_reg == RESPOK_C)
              else begin     // ERROR response from AXI
                 HREADYOUT  = 1'b0;
                 HRESP      = RESPERR_C;
                 //next state is Error state
                 next_state = WR_RESP_ERR;
              end // else: !if(wr_resp_reg == RESPOK_C)
           end // if (BVALID_sync_d == 1'b1)

        end // case: WAIT_FOR_RESP

      //--------------------------------------------------- 
      // RECEIVED WRITE ERROR RESPONSE FROM AXI
      //--------------------------------------------------- 
      WR_RESP_ERR : 
        begin
              HREADYOUT = 1'b1;
              HRESP = RESPERR_C;
              // next AHB cycle  
              if (valid_ahbcmd == 1'b1 || valid_ahbcmd_undef == 1'b1) begin
                latchahbcmd  = 1'b1;
                latchahbcmd_undef  = 1'b1;
                case (HWRITE)
                  // Write Signal Generation
                  WRITE_C : begin
                              burst_count_load = 1'b1;
                              next_state       = WR_IN_FIFO;
                  end
                  // Read Signal Generation
                  READ_C : begin
                              burst_count_load = 1'b1;
                              next_state = WAIT_STATE;
                              ahb_rd_req = 1'b1;
                  end
                endcase // case (HWRITE)
              end // if (valid_ahbcmd == 1'b1)
              else begin
                next_state = IDLE;
              end // else: !if(valid_ahbcmd == 1'b1)
        end // case: WR_RESP_ERR

      //--------------------------------------------------- 
      // WAIT STATE
      //--------------------------------------------------- 
      WAIT_STATE : 
        begin
          ahb_rd_req = 1'b0;
          HREADYOUT  = 1'b0;
          if (axi_read_rlast_sync == 1'b1) begin
            if (burst_count[1] == 1'b0) begin
              next_state = DUMMY_WAIT;
            end
            else begin
              next_state = RD_FROM_FIFO;
            end
          end
        end // case: WAIT_STATE

      //--------------------------------------------------- 
      // DUMMY WAIT STATE
      //--------------------------------------------------- 
      DUMMY_WAIT : 
        begin
          ahb_rd_req = 1'b0;
          HREADYOUT  = 1'b0;
          if (wait_count == 2'b10) begin
            next_state = RD_FROM_FIFO;
          end
          // for Single burst
          if (rdch_fifo_empty == 1'b0 && HBURST_d == 3'b000 && wait_count == 2'b00) begin
            fifo_rd_en = 1'b1;
          end
          // for undef
          else if (rdch_fifo_empty == 1'b0  && HBURST_d == 3'b001 && wait_count == 2'b00) begin
            fifo_rd_en = 1'b1;
          end
           // for other bursts
          else if (rdch_fifo_empty == 1'b0 && HBURST_d != 3'b000 && HBURST_d != 3'b001) begin
            fifo_rd_en = 1'b1;
          end
          else begin
            fifo_rd_en = 1'b0;
          end
        end // case: DUMMY_WAIT

      //--------------------------------------------------- 
      // READ DATA FROM READ CHANNEL FIFO
      //--------------------------------------------------- 
      RD_FROM_FIFO : 
        begin
          if ((burst_num_r != 5'b00000) && !((HBURST_d == 3'b000) || 
                                             (HBURST_d == 3'b001 && UNDEF_BURST == 0))) begin
            if ((rdch_fifo_empty == 1'b0)  && (count == 2'b11) ) begin
              fifo_rd_en = 1'b1;
            end
            else begin
              fifo_rd_en = 1'b0;
            end

             if (count == 2'b00) begin 
                HREADYOUT  = 1'b1;
             end
             else begin
                HREADYOUT  = 1'b0;
             end
          end
          else if (!((HBURST_d == 3'b000) || (HBURST_d == 3'b001 && UNDEF_BURST == 0))) begin
              fifo_rd_en = 1'b0;
              next_state = READ_DONE;
          end
          else begin   // Last read
              fifo_rd_en = 1'b0;
              next_state = READ_DONE;
          end


        end // case: RD_FROM_FIFO

      //--------------------------------------------------- 
      // DATA READ COMPLETE FROM READ CHANNEL FIFO
      //--------------------------------------------------- 
      READ_DONE : 
        begin
          HREADYOUT  = 1'b0;
           
           if (valid_ahbcmd == 1'b1 && HBURST[2:0] != 3'b001) begin
             latchahbcmd  = 1'b1;
             HREADYOUT  = 1'b1;
             case (HWRITE)
               // Write Signal Generation
               WRITE_C : begin
                           burst_count_load = 1'b1;
                           next_state       = WR_IN_FIFO;
               end
               // Read Signal Generation
               READ_C : begin
                           burst_count_load = 1'b1;
                           next_state = WAIT_STATE;
                           ahb_rd_req = 1'b1;
               end
             endcase // case (HWRITE)
           end // if (valid_ahbcmd == 1'b1)
           else begin
             HREADYOUT  = 1'b0;
             next_state = IDLE;
           end // else: !if(valid_ahbcmd == 1'b1)

          // for undef
           if (valid_ahbcmd_rd_undef == 1'b1 && HBURST[2:0] == 3'b001) begin
             latchahbcmd_rd_undef  = 1'b1;
             HREADYOUT  = 1'b1;
             case (HWRITE)
               // Write Signal Generation
               WRITE_C : begin
                           burst_count_load = 1'b1;
                           next_state       = WR_IN_FIFO;
               end
               // Read Signal Generation
               READ_C : begin
                           burst_count_load = 1'b1;
                           next_state = WAIT_STATE;
                           ahb_rd_req = 1'b1;
               end
             endcase // case (HWRITE)
           end // if (valid_ahbcmd == 1'b1)
           else begin
             HREADYOUT  = 1'b0;
             next_state = IDLE;
           end // else: !if(valid_ahbcmd == 1'b1)


        end // case: READ_DONE

      default : 
        begin
           next_state = current_state;
        end
    endcase // case (current_state)
  end // block: state_machine_combo_logic

   //-------------------------------------------------------------------
   // For Single and bursts - Latch AHB interface signals on latchahbcmd 
   // Only for undefined    - Copy latched signals and pass to AXI i/f on 
   //                         latchahbcmd_undef, latchahbcmd_rd_undef
   //-------------------------------------------------------------------
  always @(posedge HCLK or negedge HRESETn) begin : register_ahb_signals
    if (HRESETn == 1'b0) begin
      HSEL_d      <= 1'b0;
      HADDR_d     <= {AHB_AWIDTH{1'b0}};
      HWRITE_d    <= 1'b0;
      HREADY_d    <= 1'b0;
      HTRANS_d    <= 2'b00;
      HSIZE_d     <= 3'b000;
      HBURST_d    <= 3'b000;
      HMASTLOCK_d <= 1'b0;
    end
    // for single and bursts
    else if (latchahbcmd == 1'b1) begin
      HSEL_d      <= HSEL;
      HADDR_d     <= HADDR;
      HWRITE_d    <= HWRITE;
      HREADY_d    <= HREADY;
      HTRANS_d    <= HTRANS;
      HSIZE_d     <= HSIZE;
      HBURST_d    <= HBURST;
      HMASTLOCK_d <= HMASTLOCK;
    end
    // for undef
    else if (latchahbcmd_undef == 1'b1 || latchahbcmd_rd_undef == 1'b1) begin  
      HSEL_d      <= HSEL_undef_d;
      HADDR_d     <= HADDR_undef_d;
      HWRITE_d    <= HWRITE_undef_d;
      HREADY_d    <= HREADY_undef_d;
      HTRANS_d    <= HTRANS_undef_d;
      HSIZE_d     <= HSIZE_undef_d;
      HBURST_d    <= HBURST_undef_d;
      HMASTLOCK_d <= HMASTLOCK_undef_d;
    end
  end // block: register_ahb_signals

   //-------------------------------------------------------------------
   // For Undefined - Latch AHB interface signals on latchahbcmd_undef_r,
   //                 latchahbcmd_r, latchahbcmd_rd_undef_r
   //-------------------------------------------------------------------
  always @(posedge HCLK or negedge HRESETn) begin
    if (HRESETn == 1'b0) begin
      HSEL_undef_d      <= 1'b0;
      HADDR_undef_d     <= {AHB_AWIDTH{1'b0}};
      HWRITE_undef_d    <= 1'b0;
      HREADY_undef_d    <= 1'b0;
      HTRANS_undef_d    <= 2'b00;
      HSIZE_undef_d     <= 3'b000;
      HBURST_undef_d    <= 3'b000;
      HMASTLOCK_undef_d <= 1'b0;
    end
    else if (latchahbcmd_r == 1'b1 || latchahbcmd_undef_r == 1'b1 || 
             latchahbcmd_rd_undef_r == 1'b1) begin
      HSEL_undef_d      <= HSEL;
      HADDR_undef_d     <= HADDR;
      HWRITE_undef_d    <= HWRITE;
      HREADY_undef_d    <= HREADY;
      HTRANS_undef_d    <= HTRANS;
      HSIZE_undef_d     <= HSIZE;
      HBURST_undef_d    <= HBURST;
      HMASTLOCK_undef_d <= HMASTLOCK;
    end
  end

   //-------------------------------------------------------------------
   // Generate busy idle cycle when HTRANS = IDLE
   //-------------------------------------------------------------------
   always @(posedge HCLK or negedge HRESETn) begin
      if (HRESETn == 1'b0) begin
         ahb_busyidle_cyc   <= 1'b0;
      end
      else begin
         ahb_busyidle_cyc   <= (HTRANS_d[1] == 1'b0);
      end
   end

   //-------------------------------------------------------------------
   // Delayed HWDATA bus
   //-------------------------------------------------------------------
   always @(posedge HCLK or negedge HRESETn) begin
      if (HRESETn == 1'b0) begin
         hwdata_r           <= {AHB_DWIDTH{1'b0}};
      end
      else begin
         hwdata_r           <= HWDATA;
      end
   end

   //-------------------------------------------------------------------
   // Delayed HWDATA bus
   //-------------------------------------------------------------------
   always @(posedge HCLK or negedge HRESETn) begin
      if (HRESETn == 1'b0) begin
         RD_DATA_d1 <= {AHB_DWIDTH{1'b0}};
         RD_DATA_d2 <= {AHB_DWIDTH{1'b0}};
      end
      else if(rdch_fifo_rd_en_r_d) begin
         RD_DATA_d1 <= RD_DATA;
         RD_DATA_d2 <= RD_DATA_d1;
      end
   end

   always @(posedge HCLK or negedge HRESETn) begin
      if (HRESETn == 1'b0) begin
         rdch_fifo_rd_en_r_d <= 1'b0;       
      end
      else begin
         rdch_fifo_rd_en_r_d <= rdch_fifo_rd_en_r;
      end
   end

endmodule // AHBAccessControlHX

///////////////////////////////////////////////////////////////////////////////
//                         End-of-code                                       //
///////////////////////////////////////////////////////////////////////////////


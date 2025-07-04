// ********************************************************************/
// Microchip Corporation Proprietary and Confidential
// Copyright 2023 Microchip Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE MICROCHIP LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// IP Core:      COREFIFO
//
// SVN Revision Information:
// SVN $Revision:  $
// SVN $Date:  $
//
//
// *********************************************************************/

`timescale 1ns / 100ps
module COREFIFO_C0_COREFIFO_C0_0_COREFIFO (
                  // Clocks and Reset
                  CLK,          // Single Clock for synchronous operation
                  WCLOCK,       // write Clock
                  RCLOCK,       // Read Clock
                  RESET_N,        // Reset active low
				  WRESET_N,
				  RRESET_N,
                  // Input Data Bus and Control ports
                  DATA,         // Input Write data
                  WE,           // Write Enable
                  RE,           // Read Enable
                  // Output Data bus
                  Q,            // Output Read data
                  // Status Flags
                  FULL,         // Full flag
                  EMPTY,        // Empty flag
                  AFULL,        // Almost Full flag
                  AEMPTY,       // Almost Empty flag
                  OVERFLOW,     // Overflow indicates write failure
                  UNDERFLOW,    // Underflow indicates read failure
                  WACK,         // Write Acknowledge
                  DVLD,         // Read Data valid
                  WRCNT,        // No.of remaining elements in write domain
                  RDCNT,        // No.of remaining elements in read domain
                  // For external memory
                  MEMWE,        // Memory Write enable
                  MEMRE,        // Memory Read enable
                  MEMWADDR,     // Memory Write Address
                  MEMRADDR,     // Memory Read Address
                  MEMWD,        // Memory Write Data
                  MEMRD,        // Memory Read Data
                  SB_CORRECT,   // One-bit correct flag
                  DB_DETECT     // Detect flag
                  );


   // --------------------------------------------------------------------------
   // PARAMETER Declaration
   // --------------------------------------------------------------------------
   parameter                FAMILY        = 19;
   parameter                SYNC          = 0;   // Synchronous or Asynchronous operation | 1 - Single Clock, 0 - Dual clock
   //parameter                RCLK_EDGE     = 1;   // Read  Clock Edge | 1 - Posedge, 0 - Negedge		// commented in v3.0
   //parameter                WCLK_EDGE     = 1;   // Write Clock Edge | 1 - Posedge, 0 - Negedge       // commented in v3.0
   parameter                RE_POLARITY   = 0;   // Read  Enable Clock Edge | 1 - Active Low, 0 - Active High
   parameter                WE_POLARITY   = 0;   // Write Enable Clock Edge | 1 - Active Low, 0 - Active High
   parameter                RWIDTH        = 18;  // Read  port Data Width
   parameter                WWIDTH        = 18;  // Write port Data Width
   parameter                RDEPTH        = 1024; // Read  port Data Depth
   parameter                WDEPTH        = 1024; // Write port Data Depth
   parameter                READ_DVALID   = 0;   // Read Data Valid | 0 - Disable , 1 - Enable Read data valid generation
   parameter                WRITE_ACK     = 0;   // Write Data Ack  | 0 - Disable , 1 - Enable Write data ack generation
   parameter                CTRL_TYPE     = 1;   // Controller only options | 1 - Controller Only, 2 - RAM1Kx18, 3 - RAM64x18
   parameter                ESTOP         = 1;   // 0 - Allow Reads when Empty, 1 - Disable Reads when Empty
   parameter                FSTOP         = 1;   // 0 - Allow Writes when Full,  1 - Disable Writes when Full
   parameter                AE_STATIC_EN  = 0;   // Almost Empty Threshold Enable/Disable Static values
                                                 // 0 - Disable values, 1 - Enable Static values 
   parameter                AF_STATIC_EN  = 0;   // Almost Full Threshold Enable/Disable Static values
                                                 // 0 - Disable values, 1 - Enable Static values
   parameter                AEVAL         = 4;   // Almost Empty Threshold assert value
   parameter                AFVAL         = 1020; // Almost Full  Threshold assert value
   parameter                PIPE          = 1;   // Pipeline read data out
   parameter                PREFETCH      = 0;   // Prefetching of Read data | 0 - Disable Pre-fetching, 1 - Enable Pre-fetching only if PIPE=1
   parameter                FWFT          = 0;   // FWFT of Read data | 0 - Disable FWFT, 1 - Enable FWFT only if PIPE=1
   parameter                ECC           = 0;   // ECC | 0 - ECC Disable, 1 - Pipelined ECC, 2 - Non-pipelined ECC
  // parameter                RESET_POLARITY = 0;  // Polarity of Reset | 0 - Active Low, 1 - Active High// commented in v3.0
   parameter                OVERFLOW_EN    = 0;  // Overflow Enable/Disable | 0 - Disable, 1 - Enable
   parameter                UNDERFLOW_EN   = 0;  // Underflow Enable/Disable | 0 - Disable, 1 - Enable
   parameter                WRCNT_EN       = 0;  // Write Count Enable/Disable | 0 - Disable, 1 - Enable
   parameter                RDCNT_EN       = 0;  // Read Count Enable/Disable | 0 - Disable, 1 - Enable
   
   parameter                NUM_STAGES       = 2; // To select number of synchronizer stages.
   
   
   ////Added in v3.0
   parameter				SYNC_RESET		= 0;//To select reset type asynch/sync reset.|0-async reset, 1-sync reset
   parameter				RAM_OPT			= 0;//RAM optimization for high speed or low power.|0-High Speed,1-Low power
   parameter				DIE_SIZE		= 30; //added in v3.0
 //------
 
 
   // **************************************************************************
   // Function Declaration
   // **************************************************************************
   function [31:0] ceil_log2;
      input integer x;
      integer tmp, res;
      begin
         tmp = 1;
         res = 0;
         while(tmp < x) begin
            tmp = tmp * 2;
            res = res + 1;
         end
         ceil_log2 = res;
      end
   endfunction // ceil_log2

  function [31:0] ceil_log2t;
      input integer x;
      integer tmp, res;
      begin
         tmp = 1;
         res = 0;
	 if(x == 1) begin
           ceil_log2t = 1;
	 end
	 else begin
           while(tmp < x) begin
              tmp = tmp * 2;
              res = res + 1;
           end
	   ceil_log2t = res;
         end
      end
   endfunction // ceil_log2t
   // **************************************************************************

   // --------------------------------------------------------------------------
   // Local parameter
   // --------------------------------------------------------------------------
   localparam WMSB_DEPTH      = (ceil_log2(WDEPTH));
   localparam RMSB_DEPTH      = (ceil_log2(RDEPTH)); 
   localparam WDEPTH_CAL      = (WDEPTH == 1) ? (ceil_log2(WDEPTH))  : (ceil_log2(WDEPTH)-1); 
   localparam RDEPTH_CAL      = (RDEPTH == 1) ? (ceil_log2(RDEPTH))  : (ceil_log2(RDEPTH)-1); 
   localparam RESET_POLARITY  = 0;  // Polarity of Reset | 0 - Active Low, ----added in v3.0
   localparam RCLK_EDGE  = 1;  // Read  Clock Edge | 1 - Posedge, 	----added in v3.0
   localparam WCLK_EDGE  = 1;  // Write  Clock Edge | 1 - Posedge,	----added in v3.0
   //localparam SYNC_RESET      = (FAMILY == 25) ? 1 : 0; // 0 = async mode, 1 = sync mode
   
   
   //localparam SYNC_RESET      = (RESET_TYPE == 1) ? 1 : 0; // 0 = async mode, 1 = sync mode

   // --------------------------------------------------------------------------
   // I/O Declaration
   // --------------------------------------------------------------------------
   
   //--------
   // Inputs
   //--------

   // Clocks and Reset
   input                            CLK;   
   input                            WCLOCK;
   input                            RCLOCK;
   input                            RESET_N;
   input							WRESET_N;//Added in v3.0
   input							RRESET_N;//Added in v3.0
   // Input Data Bus and Control ports
   input [WWIDTH - 1 : 0]           DATA;
   input                            WE;
   input                            RE;
   input [RWIDTH - 1 : 0]           MEMRD;

   output                            SB_CORRECT;
   output                            DB_DETECT;

   //---------
   // Outputs
   //---------

   // Output Data bus
   output [RWIDTH - 1 : 0]          Q;
   // Output Status Flags
   output                           FULL;
   output                           EMPTY;
   output                           AFULL;
   output                           AEMPTY;
   output                           OVERFLOW;
   output                           UNDERFLOW;
   output                           WACK;
   output                           DVLD;
   output [(ceil_log2(WDEPTH)) : 0] WRCNT;
   output [(ceil_log2(RDEPTH)) : 0] RDCNT;
   // Outputs For external memory
   output                           MEMWE;
   output                           MEMRE;
   output [WDEPTH_CAL : 0]          MEMWADDR;
   output [RDEPTH_CAL : 0]          MEMRADDR;
   output [WWIDTH - 1 : 0]          MEMWD;

   // --------------------------------------------------------------------------
   // Internal signals
   // --------------------------------------------------------------------------
   wire                             EMPTY1;
   wire                             AEMPTY1;
   wire                             EMPTY2;
   wire                             AEMPTY2;
   wire                             fifo_rd_en;
   wire                             fifo_re_in;   
   wire [WDEPTH_CAL : 0]            fifo_MEMWADDR;
   wire [RDEPTH_CAL : 0]            fifo_MEMRADDR;
   wire [RDEPTH_CAL : 0]            pf_MEMRADDR;
   wire [RDEPTH_CAL : 0]            fwft_MEMRADDR;
   wire [RDEPTH_CAL : 0]            ram_raddr;
   wire                             fifo_MEMWE;
   wire                             fifo_MEMRE;
   wire                             fifo_MEMRE_int;
   wire [RWIDTH - 1 : 0]            pf_Q;
   wire [RWIDTH - 1 : 0]            fwft_Q;
   wire [RWIDTH - 1 : 0]            int_MEMRD;
   wire [RWIDTH - 1 : 0]            int_MEMRD_fwft;
   wire [RWIDTH - 1 : 0]            int_MEMRD_pipe0;
   wire [RWIDTH - 1 : 0]            int_MEMRD_pipe1;
   wire [RWIDTH - 1 : 0]            int_MEMRD_pipe2;
   wire [RWIDTH - 1 : 0]            mem_pf_RD;
   wire [RWIDTH - 1 : 0]            ext_MEMRD;
   wire [RWIDTH - 1 : 0]            ext_MEMRD_fwft;
   wire [RWIDTH - 1 : 0]            ext_MEMRD_pipe0;
   wire [RWIDTH - 1 : 0]            ext_MEMRD_pipe1;
   wire [RWIDTH - 1 : 0]            ext_MEMRD_pipe2;
   wire                             RE_pol;
   wire [RWIDTH - 1 : 0]            RDATA_int;  
   wire                             re_pulse; 
   wire                             re_pulse_pre; 
   wire                             aresetn;
   wire                             sresetn;//uncommented in v3.0
   wire                             DVLD_async;
   wire                             DVLD_scntr;
   wire                             DVLD_sync;
   wire                             fwft_dvld;
   wire                             fwft_reg_valid;   
   wire                             pf_dvld;
   wire                             pos_rclk;
   wire                             pos_wclk;
   wire                             SB_CORRECT;
   wire                             DB_DETECT;
   wire                             A_SB_CORRECT;
   wire                             A_DB_DETECT;
   wire                             B_SB_CORRECT;
   wire                             B_DB_DETECT;
   reg                              reg_valid;
   reg                              re_set;
   reg [RWIDTH - 1 : 0]             RDATA_r;  
   reg [RWIDTH - 1 : 0]             RDATA_r1;  
   reg [RWIDTH - 1 : 0]             RDATA_r_pre;  
   reg [RWIDTH - 1 : 0]             RDATA_ext_r;  
   reg [RWIDTH - 1 : 0]             RDATA_ext_r1;  
   reg                              REN_d1;
   reg                              REN_d2;
   reg                              re_pulse_d1;
   reg                              re_pulse_d2;
   reg                              RE_d1 ;
   reg                              RE_d2 ;
   reg [RWIDTH - 1 : 0]             fwft_Q_r;
   reg [RWIDTH - 1 : 0]             reg_RD;
   reg                              AEMPTY1_r;
   reg                              AEMPTY1_r1;
   // Jul 1 : For ECC
   reg [RWIDTH - 1 : 0]             RDATA_r2;   
   reg                              RE_d3 ;
   reg                              REN_d3;
   reg                              re_pulse_d3;
   wire [RWIDTH - 1 : 0]            int_MEMRD_pipe1_ecc1;
   wire [RWIDTH - 1 : 0]            int_MEMRD_pipe2_ecc1;
   reg                              DVLD_async_ecc;
   reg                              DVLD_sync_ecc;
   reg                              DVLD_scntr_ecc;
   
   /*reg reset_reg;
   reg reset_reg1;*/
   wire re_p;
   wire we_p;
   
   wire reset_rclk;
   wire reset_wclk;
   wire reset_sync_r;
   wire reset_sync_w;

   wire aresetn_wclk;
   wire sresetn_wclk; 
   wire aresetn_rclk;   
   wire sresetn_rclk; 
   
   wire neg_reset;
   wire neg_wreset;
   wire neg_rreset;

   // --------------------------------------------------------------------------
   // ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
   // ||                                                                      ||
   // ||                     Start - of - Code                                ||
   // ||                                                                      ||
   // ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
   // --------------------------------------------------------------------------
   
   // --------------------------------------------------------------------------
   // clocks and enables
   // --------------------------------------------------------------------------
   generate
      if(RCLK_EDGE == 1) begin
         assign pos_rclk  = SYNC ? CLK : RCLOCK;  //SAR#60185
      end
   endgenerate
   generate
      if(RCLK_EDGE == 0) begin
         assign pos_rclk  = SYNC ? ~CLK :  ~RCLOCK; //SAR#60185
      end
   endgenerate
   generate
      if(WCLK_EDGE == 1) begin
         assign pos_wclk  = SYNC ? CLK :  WCLOCK;
      end
   endgenerate
   generate
      if(WCLK_EDGE == 0) begin
         assign pos_wclk  = SYNC ? ~CLK :  ~WCLOCK;
      end
   endgenerate

   // --------------------------------------------------------------------------
   // resets
   // --------------------------------------------------------------------------
   assign neg_reset = (RESET_POLARITY == 1) ? ~RESET_N : RESET_N;//  uncommented in v3.0
   
   assign neg_wreset = (RESET_POLARITY == 1) ? ~WRESET_N : WRESET_N;//  added  in v3.0
   assign neg_rreset = (RESET_POLARITY == 1) ? ~RRESET_N : RRESET_N;//  added in v3.0
   
  
/*    generate
	  if(SYNC == 1)
		begin
			assign aresetn   = (SYNC_RESET == 1) ? 1'b1  : neg_reset;
			assign sresetn   = (SYNC_RESET == 1) ? neg_reset : 1'b1;  
		end
	endgenerate

   generate
	  if(SYNC == 0)
		begin
			assign w_aresetn   = (SYNC_RESET == 1) ? 1'b1 : neg_wreset ;
			assign w_sresetn   = (SYNC_RESET == 1) ? neg_wreset : 1'b1 ;
			assign r_aresetn   = (SYNC_RESET == 1) ? 1'b1 : neg_rreset;
			assign r_sresetn   = (SYNC_RESET == 1) ? neg_rreset : 1'b1 ; 			
		end
	endgenerate */
	 

			assign aresetn_wclk   = (SYNC_RESET == 1) ? 1'b1  : (SYNC == 1) ? neg_reset : neg_wreset ;
			assign sresetn_wclk   = (SYNC_RESET == 0) ? 1'b1  : (SYNC == 1) ? neg_reset : neg_wreset ;
			assign aresetn_rclk   = (SYNC_RESET == 1) ? 1'b1  : (SYNC == 1) ? neg_reset : neg_rreset;
			assign sresetn_rclk   = (SYNC_RESET == 0) ? 1'b1  : (SYNC == 1) ? neg_reset : neg_rreset ; 

	generate
	  if(SYNC == 1)
	    begin
			//assign aresetn   	  = (SYNC_RESET == 1) ? 1'b1 : neg_reset;
			//assign sresetn   	  = (SYNC_RESET == 1) ? neg_reset : 1'b1;
			assign aresetn   	  = aresetn_wclk;
			assign sresetn   	  = sresetn_wclk;			
		end	
	endgenerate			
/* 	generate
	  if(SYNC == 0)
	    begin
			assign aresetn_wclk   = (SYNC_RESET == 1) ? 1'b1 : neg_wreset ;
			assign sresetn_wclk   = (SYNC_RESET == 0) ? 1'b1 : neg_wreset ;
			assign aresetn_rclk   = (SYNC_RESET == 1) ? 1'b1 : neg_rreset;
			assign sresetn_rclk   = (SYNC_RESET == 0) ? 1'b1 : neg_rreset ;
		end
	  else
	    begin
		   assign aresetn   	  = (SYNC_RESET == 1) ? 1'b1 : neg_reset;
		   assign sresetn   	  = (SYNC_RESET == 1) ? neg_reset : 1'b1;
	    end
	endgenerate
		 */
/*  generate
      if(SYNC == 0) begin   
 COREFIFO_C0_COREFIFO_C0_0_corefifo_resetsync # (
                                  .NUM_STAGES (NUM_STAGES)
								  )
								  
		          w_corefifo_resetSync (
				                       .clk         (pos_wclk ),
									   .reset       (aresetn  ),
									   .reset_out   (reset_sync_w)
									   );
									

 COREFIFO_C0_COREFIFO_C0_0_corefifo_resetsync # (
                                  .NUM_STAGES (NUM_STAGES)
								  )
								  
		          r_corefifo_resetSync (
				                       .clk         (pos_rclk ),
									   .reset       (aresetn  ),
									   .reset_out   (reset_sync_r)
									   );		

  end
  endgenerate	 */	



									  
//-----------------------------------------------------------
//Resets 
//-----------------------------------------------------------
/*  generate
      if(SYNC == 0) begin
         assign reset_rclk  =(SYNC_RESET == 1) ? r_sresetn : r_aresetn;
         assign reset_wclk  =(SYNC_RESET == 1) ? w_sresetn : w_aresetn;
      end
   endgenerate
   
   
  generate
      if(SYNC == 1) begin
         assign reset_rclk  = (SYNC_RESET == 1) ? sresetn : aresetn;
         assign reset_wclk  = (SYNC_RESET == 1) ? sresetn : aresetn;
      end
   endgenerate
    */

         assign re_p  = RE_POLARITY  ? (~RE) : (RE);
         assign we_p  = WE_POLARITY  ? (~WE) : (WE);

/* synthesis translate_off */
always @(posedge pos_wclk)	 begin
	if(we_p & FULL)	
		$display("time:%t --> FAIL: Writing when FIFO is full",$time)	;		
end	


always @(posedge pos_rclk)	begin
	if(re_p & EMPTY) 
		$display("time:%t --> FAIL: Reading when FIFO is Empty",$time);		
	end

/* synthesis translate_on */

   // --------------------------------------------------------------------------
   // Generate top-level read data output
   // --------------------------------------------------------------------------         
   generate
      if(FWFT == 0 && PREFETCH == 0) begin
         assign Q   = mem_pf_RD;
      end
   endgenerate

   generate
      if(FWFT == 1 && PREFETCH == 0 && PIPE == 1) begin
         //assign Q   = (fwft_dvld & (RE_pol | fwft_reg_valid)) ? fwft_Q : fwft_Q_r;
         //assign Q   = (EMPTY == 1) ? fwft_Q_r : fwft_Q; // added by  mahesh
         assign Q   =  fwft_Q; // added by  mahesh
      end
   endgenerate

   generate
      if(FWFT == 0 && PREFETCH == 1 && PIPE == 1) begin
         assign Q   = RE_pol ? fwft_Q : fwft_Q_r; 
      end
   endgenerate
   
   // --------------------------------------------------------------------------
   // Generate FIFO flags
   // --------------------------------------------------------------------------         
   assign EMPTY  = (FWFT || PREFETCH) ? EMPTY2 : EMPTY1;

   generate
      if((FWFT == 1 || PREFETCH == 1) && PIPE == 1) begin
         assign AEMPTY = AEMPTY2;  
      end
   endgenerate
   generate
      if(FWFT == 0 && PREFETCH == 0) begin
         assign AEMPTY = AEMPTY1;
      end
   endgenerate
 
   always @(posedge pos_rclk or negedge aresetn_rclk)
     begin
        if(!aresetn_rclk | !sresetn_rclk) begin
           AEMPTY1_r  <= 'h0;
           AEMPTY1_r1 <= 'h0;
        end
        else begin
           AEMPTY1_r  <= AEMPTY1;
           AEMPTY1_r1 <= AEMPTY1_r;
        end
     end

   // Jul 1 : For ECC
   always @(posedge pos_rclk or negedge aresetn_rclk)
     begin
        if(!aresetn_rclk | !sresetn_rclk) begin
           DVLD_async_ecc  <= 'h0;
           DVLD_sync_ecc   <= 'h0;
           DVLD_scntr_ecc  <= 'h0;
        end
        else begin
           DVLD_async_ecc  <= DVLD_async;
           DVLD_sync_ecc   <= DVLD_sync;
           DVLD_scntr_ecc  <= DVLD_scntr;
        end
     end
   // --------------------------------------------------------------------------
   // Generate top-level read data valid output
   // --------------------------------------------------------------------------         
   generate
      if (SYNC == 0 && FWFT == 0 && PREFETCH == 0) begin
         assign DVLD = (ECC == 1) ? DVLD_async_ecc : DVLD_async;  
      end
   endgenerate
   generate
      if (((SYNC == 1) && (RDEPTH == WDEPTH) && (ESTOP == 1) && (FSTOP ==  1)) && FWFT == 0 && PREFETCH == 0) begin  
         assign DVLD = (ECC == 1) ? DVLD_scntr_ecc : DVLD_scntr;  
      end
   endgenerate
   generate
      if ((SYNC == 1) && (RDEPTH == WDEPTH) && (ESTOP == 0 || FSTOP ==  0) && FWFT == 0 && PREFETCH == 0) begin  
         assign DVLD = (ECC == 1) ? DVLD_sync_ecc : DVLD_sync;  
      end
   endgenerate
   generate
      if (SYNC == 1 &&  (RDEPTH != WDEPTH) && FWFT == 0 && PREFETCH == 0) begin
         assign DVLD = (ECC == 1) ? DVLD_sync_ecc : DVLD_sync;  
      end
   endgenerate
   generate
      if (FWFT == 1 || PREFETCH == 1) begin
         assign DVLD = (READ_DVALID == 1) ? fwft_dvld : 1'b0;
      end
   endgenerate

   // --------------------------------------------------------------------------
   // Generate read enable to the FIFO controller based on whether FWFT/PREFETCH
   // mode is selected or not.
   // --------------------------------------------------------------------------         
   assign  fifo_re_in   = ((FWFT == 1 || PREFETCH == 1) && PIPE == 1) ? fifo_rd_en : RE;   
   //assign  fifo_re_in   = ((FWFT == 1 || PREFETCH == 1) && PIPE == 1) ? RE : RE;   // added by mahesh

   // --------------------------------------------------------------------------
   // Generate top-level outputs to External memory
   // --------------------------------------------------------------------------
   assign MEMWADDR     = (CTRL_TYPE == 1) ? fifo_MEMWADDR : 'h0;
   assign MEMWE        = (CTRL_TYPE == 1) ? fifo_MEMWE    : 1'b0;
   assign MEMWD        = (CTRL_TYPE == 1) ? DATA          : 'h0;
   assign #1 MEMRE     = (CTRL_TYPE == 1) ? fifo_MEMRE    : 1'b0; 
   assign #1 MEMRADDR  = (CTRL_TYPE == 1) ? ((FWFT == 1 && PIPE == 1) ? fwft_MEMRADDR : ((PREFETCH == 1 && PIPE == 1) ? fwft_MEMRADDR : fifo_MEMRADDR)) : 'h0;

   // --------------------------------------------------------------------------
   // Based on the 'SYNC' parameter generate either Synchronous FIFO or
   // Asynchronous FIFO
   // --------------------------------------------------------------------------
   generate
        if ((SYNC == 1) && (RDEPTH == WDEPTH) && (ESTOP == 1) && (FSTOP ==  1))
        // ------------------------------------
        // Synchronous FIFO operation Instance
    	// Equal Depths and No wrap around
        // ------------------------------------
		
            COREFIFO_C0_COREFIFO_C0_0_corefifo_sync_scntr #(
                .WRITE_WIDTH      (WWIDTH         ),
                .WRITE_DEPTH      ((ceil_log2(WDEPTH))),
                .FULL_WRITE_DEPTH (WDEPTH         ),
                .READ_WIDTH       (RWIDTH         ),
                .READ_DEPTH       ((ceil_log2(RDEPTH))),
                .FULL_READ_DEPTH  (RDEPTH         ),
                .WCLK_HIGH        (WCLK_EDGE      ),
                .PREFETCH         (PREFETCH       ),
                .FWFT             (FWFT           ), 
                .RESET_LOW        (RESET_POLARITY ),
                .WRITE_LOW        (WE_POLARITY    ),
                .READ_LOW         (RE_POLARITY    ),
                .AF_FLAG_STATIC   (AF_STATIC_EN   ),
                .AE_FLAG_STATIC   (AE_STATIC_EN   ),
                .AFULL_VAL        (AFVAL          ),
                .AEMPTY_VAL       (AEVAL          ),
                .ESTOP            (ESTOP          ),
                .FSTOP            (FSTOP          ),
                .PIPE             (PIPE           ),
                .SYNC_RESET       (SYNC_RESET     ),//uncommented in v3.0
                .REGISTER_RADDR   (PIPE           ),
                .READ_DVALID      (READ_DVALID    ),
                .WRITE_ACK        (WRITE_ACK      ),
				.OVERFLOW_EN      (OVERFLOW_EN    ),
                .UNDERFLOW_EN     (UNDERFLOW_EN   ),
                .WRCNT_EN         (WRCNT_EN       ),
                .RDCNT_EN         (RDCNT_EN       ),
				.ECC              (ECC),
				.FAMILY			  (FAMILY		  )
            )
                fifo_corefifo_sync_scntr (
                    .clk          (CLK          ),
                    //.reset        (RESET    ),
                    .aresetn        (aresetn    ),
                    .sresetn        (sresetn    ),
                    .we           (WE           ),
                    .re           (fifo_re_in   ),  
                    .re_top       (RE           ),
                    .full         (FULL         ),
                    .afull        (AFULL        ),
                    .wrcnt        (WRCNT        ),
                    .empty        (EMPTY1       ),
                    .aempty       (AEMPTY1       ),
                    .rdcnt        (RDCNT        ),
                    .underflow    (UNDERFLOW    ),
                    .overflow     (OVERFLOW     ),
                    .dvld         (DVLD_scntr   ),
                    .wack         (WACK         ),
                    .memwaddr     (fifo_MEMWADDR),
                    .memwe        (fifo_MEMWE   ),
                    .memraddr     (fifo_MEMRADDR),
                    .memre        (fifo_MEMRE   ),
                    .empty_top_fwft(EMPTY2   )  
                );
   
      else if (SYNC == 1 &&  (WDEPTH >= RDEPTH)) begin
        // ------------------------------------
        // Synchronous FIFO operation Instance
        // ------------------------------------
        COREFIFO_C0_COREFIFO_C0_0_corefifo_sync  #(
                          .WRITE_WIDTH      (WWIDTH        ),
                          .WRITE_DEPTH      ((ceil_log2(WDEPTH))),
                          .FULL_WRITE_DEPTH (WDEPTH        ),
                          .READ_WIDTH       (RWIDTH        ),
                          .READ_DEPTH       ((ceil_log2(RDEPTH))),
                          .VAR_ASPECT_WRDEPTH ((ceil_log2(WDEPTH))),
                          .VAR_ASPECT_RDDEPTH ((ceil_log2(WDEPTH))),
                          .FULL_READ_DEPTH  (RDEPTH        ),
                          .PREFETCH         (PREFETCH      ),
                          .FWFT             (FWFT          ),
                          .WCLK_HIGH        (WCLK_EDGE     ),
                          .RESET_LOW        (RESET_POLARITY),
                          .WRITE_LOW        (WE_POLARITY   ),
                          .READ_LOW         (RE_POLARITY   ),
                          .AF_FLAG_STATIC   (AF_STATIC_EN  ),
                          .AE_FLAG_STATIC   (AE_STATIC_EN  ),
                          .AFULL_VAL        (AFVAL         ),
                          .AEMPTY_VAL       (AEVAL         ),
                          .ESTOP            (ESTOP         ),
                          .FSTOP            (FSTOP         ),
                          .PIPE             (PIPE          ),
                          .SYNC_RESET       (SYNC_RESET    ),//uncommented in v3.0
                          .REGISTER_RADDR   (PIPE          ),
                          .READ_DVALID      (READ_DVALID   ),
                          .WRITE_ACK        (WRITE_ACK     ),
    	              	  .OVERFLOW_EN      (OVERFLOW_EN   ),
                          .UNDERFLOW_EN     (UNDERFLOW_EN  ),
                          .WRCNT_EN         (WRCNT_EN      ),
                          .RDCNT_EN         (RDCNT_EN      )
                         ) 
                        U_corefifo_sync(
                                         .clk              (CLK             ),
                                         //.reset          (RESET       ),
										 .aresetn          (aresetn    		),
										 .sresetn          (sresetn    		),										 
                                         .we               (WE              ),
                                         .re               (RE              ),
                                         .full             (FULL            ),
                                         .afull            (AFULL           ),
                                         .wrcnt            (WRCNT           ),
                                         .empty            (EMPTY1          ),
                                         .aempty           (AEMPTY1         ),
                                         .rdcnt            (RDCNT           ),
                                         .underflow        (UNDERFLOW       ),
                                         .overflow         (OVERFLOW        ),
                                         .dvld             (DVLD_sync       ),
                                         .wack             (WACK            ),
                                         .memwaddr         (fifo_MEMWADDR   ),
                                         .memwe            (fifo_MEMWE      ),
                                         .memraddr         (fifo_MEMRADDR   ),
                                         .memre            (fifo_MEMRE      )
                                         );
      end
      else if (SYNC == 1 &&  (RDEPTH > WDEPTH)) begin
        // ------------------------------------
        // Synchronous FIFO operation Instance
        // ------------------------------------
        COREFIFO_C0_COREFIFO_C0_0_corefifo_sync  #(
                          .WRITE_WIDTH      (WWIDTH        ),
                          .WRITE_DEPTH      ((ceil_log2(WDEPTH))),
                          .FULL_WRITE_DEPTH (WDEPTH        ),
                          .READ_WIDTH       (RWIDTH        ),
                          .READ_DEPTH       ((ceil_log2(RDEPTH))),
                          .VAR_ASPECT_WRDEPTH ((ceil_log2(RDEPTH))),
                          .VAR_ASPECT_RDDEPTH ((ceil_log2(RDEPTH))),
                          .FULL_READ_DEPTH  (RDEPTH        ),
                          .PREFETCH         (PREFETCH      ),
                          .FWFT             (FWFT          ),
                          .WCLK_HIGH        (WCLK_EDGE     ),
                          .RESET_LOW        (RESET_POLARITY),
                          .WRITE_LOW        (WE_POLARITY   ),
                          .READ_LOW         (RE_POLARITY   ),
                          .AF_FLAG_STATIC   (AF_STATIC_EN  ),
                          .AE_FLAG_STATIC   (AE_STATIC_EN  ),
                          .AFULL_VAL        (AFVAL         ),
                          .AEMPTY_VAL       (AEVAL         ),
                          .ESTOP            (ESTOP         ),
                          .FSTOP            (FSTOP         ),
                          .PIPE             (PIPE          ),
                          .SYNC_RESET       (SYNC_RESET    ),//uncommented in v3.0
                          .REGISTER_RADDR   (PIPE          ),
                          .READ_DVALID      (READ_DVALID   ),
                          .WRITE_ACK        (WRITE_ACK     ),
    	              	  .OVERFLOW_EN      (OVERFLOW_EN   ),
                          .UNDERFLOW_EN     (UNDERFLOW_EN  ),
                          .WRCNT_EN         (WRCNT_EN      ),
                          .RDCNT_EN         (RDCNT_EN      )
                         ) 
                        U_corefifo_sync(
                                         .clk              (CLK             ),
                                         //.reset            (RESET       ),
										 .aresetn          (aresetn    		),
										 .sresetn          (sresetn    		),										 
                                         .we               (WE              ),
                                         .re               (RE              ),
                                         .full             (FULL            ),
                                         .afull            (AFULL           ),
                                         .wrcnt            (WRCNT           ),
                                         .empty            (EMPTY1          ),
                                         .aempty           (AEMPTY1         ),
                                         .rdcnt            (RDCNT           ),
                                         .underflow        (UNDERFLOW       ),
                                         .overflow         (OVERFLOW        ),
                                         .dvld             (DVLD_sync       ),
                                         .wack             (WACK            ),
                                         .memwaddr         (fifo_MEMWADDR   ),
                                         .memwe            (fifo_MEMWE      ),
                                         .memraddr         (fifo_MEMRADDR   ),
                                         .memre            (fifo_MEMRE      )
                                         );

      end
      else if (SYNC == 0 && (WDEPTH >= RDEPTH) ) begin  // for variable aspect ratio
        // --------------------------------------------------------------------
        // Asynchronous FIFO operation Instance with Controller Only operation
        // --------------------------------------------------------------------
        COREFIFO_C0_COREFIFO_C0_0_corefifo_async  #(
                          .WRITE_WIDTH      (WWIDTH         ),
                          .WRITE_DEPTH      ((ceil_log2(WDEPTH))),
                          .FULL_WRITE_DEPTH (WDEPTH         ),
                          .READ_WIDTH       (RWIDTH         ),
                          .READ_DEPTH       ((ceil_log2(RDEPTH))),
                          .VAR_ASPECT_WRDEPTH ((ceil_log2(WDEPTH))),
                          .VAR_ASPECT_RDDEPTH ((ceil_log2(WDEPTH))),
                          .FULL_READ_DEPTH  (RDEPTH         ),
                          .PREFETCH         (PREFETCH       ),
                          .FWFT             (FWFT           ),
                          .WCLK_HIGH        (WCLK_EDGE      ),
                          .RCLK_HIGH        (RCLK_EDGE      ),
                          .RESET_LOW        (RESET_POLARITY ),
                          .WRITE_LOW        (WE_POLARITY    ),
                          .READ_LOW         (RE_POLARITY    ),
                          .AF_FLAG_STATIC   (AF_STATIC_EN   ),
                          .AE_FLAG_STATIC   (AE_STATIC_EN   ),
                          .AFULL_VAL        (AFVAL          ),
                          .AEMPTY_VAL       (AEVAL          ),
                          .ESTOP            (ESTOP          ),
                          .FSTOP            (FSTOP          ),
                          .PIPE             (PIPE           ),
                          .SYNC_RESET       (SYNC_RESET     ),//uncommented in v3.0
                          .REGISTER_RADDR   (PIPE           ),
                          .READ_DVALID      (READ_DVALID    ),
                          .WRITE_ACK        (WRITE_ACK      ),
	       	              .OVERFLOW_EN      (OVERFLOW_EN    ),
                          .UNDERFLOW_EN     (UNDERFLOW_EN   ),
                          .WRCNT_EN         (WRCNT_EN       ),
						  .NUM_STAGES       (NUM_STAGES     ),
                          .RDCNT_EN         (RDCNT_EN       )

                         ) 
                        U_corefifo_async(
                                         .rclk             (RCLOCK          ),
                                         .wclk             (WCLOCK          ),
                                         //.reset_rclk       (reset_rclk      ),//commented in v3.0
                                         //.reset_wclk       (reset_wclk      ),//commented in v3.0
                                         //.RRESET       (RRESET      ),//Added in v3.0
                                         //.WRESET       (WRESET      ),	//Added in v3.0	
										 .aresetn_wclk     (aresetn_wclk    ),
										 .aresetn_rclk     (aresetn_rclk    ),
										 .sresetn_wclk     (sresetn_wclk    ),
										 .sresetn_rclk     (sresetn_rclk    ),											 
                                         .we               (WE              ),
                                         .re               (fifo_re_in      ),  
                                         .re_top           (RE              ),
                                         .full             (FULL            ),
                                         .afull            (AFULL           ),
                                         .wrcnt            (WRCNT           ),
                                         .empty            (EMPTY1          ),
                                         .aempty           (AEMPTY1         ),
                                         .rdcnt            (RDCNT           ),
                                         .underflow        (UNDERFLOW       ),
                                         .overflow         (OVERFLOW        ),
                                         .dvld             (DVLD_async      ),
                                         .wack             (WACK            ),
                                         .memwaddr         (fifo_MEMWADDR   ),
                                         .memwe            (fifo_MEMWE      ),
                                         .memraddr         (fifo_MEMRADDR   ),
                                         .memre            (fifo_MEMRE      )
                                         );
      end
      else if (SYNC == 0 && (RDEPTH > WDEPTH) ) begin  // for variable aspect ratio
        // --------------------------------------------------------------------
        // Asynchronous FIFO operation Instance with Controller Only operation
        // --------------------------------------------------------------------
        COREFIFO_C0_COREFIFO_C0_0_corefifo_async  #(
                          .WRITE_WIDTH      (WWIDTH         ),
                          .WRITE_DEPTH      ((ceil_log2(WDEPTH))),
                          .FULL_WRITE_DEPTH (WDEPTH         ),
                          .READ_WIDTH       (RWIDTH         ),
                          .READ_DEPTH       ((ceil_log2(RDEPTH))),
                          .VAR_ASPECT_WRDEPTH ((ceil_log2(RDEPTH))),
                          .VAR_ASPECT_RDDEPTH ((ceil_log2(RDEPTH))),
                          .FULL_READ_DEPTH  (RDEPTH         ),
                          .PREFETCH         (PREFETCH       ),
                          .FWFT             (FWFT           ),
                          .WCLK_HIGH        (WCLK_EDGE      ),
                          .RCLK_HIGH        (RCLK_EDGE      ),
                          .RESET_LOW        (RESET_POLARITY ),
                          .WRITE_LOW        (WE_POLARITY    ),
                          .READ_LOW         (RE_POLARITY    ),
                          .AF_FLAG_STATIC   (AF_STATIC_EN   ),
                          .AE_FLAG_STATIC   (AE_STATIC_EN   ),
                          .AFULL_VAL        (AFVAL          ),
                          .AEMPTY_VAL       (AEVAL          ),
                          .ESTOP            (ESTOP          ),
                          .FSTOP            (FSTOP          ),
                          .PIPE             (PIPE           ),
                          .SYNC_RESET       (SYNC_RESET     ),//uncommented in v3.0
                          .REGISTER_RADDR   (PIPE           ),
                          .READ_DVALID      (READ_DVALID    ),
                          .WRITE_ACK        (WRITE_ACK      ),
	       	          .OVERFLOW_EN      (OVERFLOW_EN    ),
                          .UNDERFLOW_EN     (UNDERFLOW_EN   ),
						  .NUM_STAGES       (NUM_STAGES     ),
                          .WRCNT_EN         (WRCNT_EN       ),
                          .RDCNT_EN         (RDCNT_EN       )

                         ) 
                        U_corefifo_async(
                                         .rclk             (RCLOCK          ),
                                         .wclk             (WCLOCK          ),
                                         //.reset_rclk       (reset_rclk      ),commented in v3.0
                                         //.reset_wclk       (reset_wclk      ),commented in v3.0
                                         //.WRESET       (WRESET      ),//Added in v3.0
                                         //.RRESET       (RRESET      ),//Added in v3.0
										 .aresetn_wclk  (aresetn_wclk),
										 .aresetn_rclk  (aresetn_rclk),
										 .sresetn_wclk  (sresetn_wclk),
										 .sresetn_rclk  (sresetn_rclk),											 
                                         .we               (WE              ),
                                         .re               (RE              ),
                                         .re_top           (RE              ),
                                         .full             (FULL            ),
                                         .afull            (AFULL           ),
                                         .wrcnt            (WRCNT           ),
                                         .empty            (EMPTY1          ),
                                         .aempty           (AEMPTY1         ),
                                         .rdcnt            (RDCNT           ),
                                         .underflow        (UNDERFLOW       ),
                                         .overflow         (OVERFLOW        ),
                                         .dvld             (DVLD_async      ),
                                         .wack             (WACK            ),
                                         .memwaddr         (fifo_MEMWADDR   ),
                                         .memwe            (fifo_MEMWE      ),
                                         .memraddr         (fifo_MEMRADDR   ),
                                         .memre            (fifo_MEMRE      )
                                         );
      end
      else begin  // for variable aspect ratio
        // --------------------------------------------------------------------
        // Asynchronous FIFO operation Instance with Controller Only operation
        // --------------------------------------------------------------------
        COREFIFO_C0_COREFIFO_C0_0_corefifo_async  #(
                          .WRITE_WIDTH      (WWIDTH         ),
                          .WRITE_DEPTH      ((ceil_log2(WDEPTH))),
                          .FULL_WRITE_DEPTH (WDEPTH         ),
                          .READ_WIDTH       (RWIDTH         ),
                          .READ_DEPTH       ((ceil_log2(RDEPTH))),
                          .VAR_ASPECT_RDDEPTH ((ceil_log2(RDEPTH))),
                          .VAR_ASPECT_WRDEPTH ((ceil_log2(WDEPTH))),
                          .FULL_READ_DEPTH  (RDEPTH         ),
                          .PREFETCH         (PREFETCH       ),
                          .FWFT             (FWFT           ),
                          .WCLK_HIGH        (WCLK_EDGE      ),
                          .RCLK_HIGH        (RCLK_EDGE      ),
                          .RESET_LOW        (RESET_POLARITY ),
                          .WRITE_LOW        (WE_POLARITY    ),
                          .READ_LOW         (RE_POLARITY    ),
                          .AF_FLAG_STATIC   (AF_STATIC_EN   ),
                          .AE_FLAG_STATIC   (AE_STATIC_EN   ),
                          .AFULL_VAL        (AFVAL          ),
                          .AEMPTY_VAL       (AEVAL          ),
                          .ESTOP            (ESTOP          ),
                          .FSTOP            (FSTOP          ),
                          .PIPE             (PIPE           ),
                          .SYNC_RESET       (SYNC_RESET     ),//uncommented in v3.0
                          .REGISTER_RADDR   (PIPE           ),
                          .READ_DVALID      (READ_DVALID    ),
                          .WRITE_ACK        (WRITE_ACK      ),
    	       	          .OVERFLOW_EN      (OVERFLOW_EN    ),
                          .UNDERFLOW_EN     (UNDERFLOW_EN   ),
						  .NUM_STAGES       (NUM_STAGES     ),
                          .WRCNT_EN         (WRCNT_EN       ),
                          .RDCNT_EN         (RDCNT_EN       )

                         ) 
                        U_corefifo_async(
                                         .rclk             (RCLOCK          ),
                                         .wclk             (WCLOCK          ),
                                          //.reset_rclk       (reset_rclk      ),commented in v3.0
                                         //.reset_wclk       (reset_wclk      ),commented in v3.0
                                         //.WRESET       (WRESET      ),//Added in v3.0
                                         //.RRESET       (RRESET      ),//Added in v3.0
										 .aresetn_wclk  (aresetn_wclk),
										 .aresetn_rclk  (aresetn_rclk),
										 .sresetn_wclk  (sresetn_wclk),
										 .sresetn_rclk  (sresetn_rclk),										 
                                         .we               (WE              ),
                                         .re               (RE              ),
                                         .re_top           (RE              ),
                                         .full             (FULL            ),
                                         .afull            (AFULL           ),
                                         .wrcnt            (WRCNT           ),
                                         .empty            (EMPTY1          ),
                                         .aempty           (AEMPTY1         ),
                                         .rdcnt            (RDCNT           ),
                                         .underflow        (UNDERFLOW       ),
                                         .overflow         (OVERFLOW        ),
                                         .dvld             (DVLD_async      ),
                                         .wack             (WACK            ),
                                         .memwaddr         (fifo_MEMWADDR   ),
                                         .memwe            (fifo_MEMWE      ),
                                         .memraddr         (fifo_MEMRADDR   ),
                                         .memre            (fifo_MEMRE      )
                                         );
      end      
   endgenerate
   

   // -----------------------------------------------------------------------
   // FWFT/Prefetch logic
   // The module is used to provide FWFT and Prefetch logic.
   // -----------------------------------------------------------------------
   generate
      if ((FWFT == 1 || PREFETCH == 1) && PIPE == 1)  

        // FWFT module instance 
        COREFIFO_C0_COREFIFO_C0_0_corefifo_fwft #(
                   .RWIDTH    (RWIDTH         ),
                   .WWIDTH    (WWIDTH         ),
                   .RCLK_HIGH (RCLK_EDGE      ),
                   .WCLK_HIGH (WCLK_EDGE      ),
                   .RESET_LOW (RESET_POLARITY ),
                   .WRITE_LOW (WE_POLARITY    ),
                   .READ_LOW  (RE_POLARITY    ),
                   .PREFETCH  (PREFETCH       ),
                   .FWFT      (FWFT           ),
                   .SYNC      (SYNC           ),
                   .SYNC_RESET(SYNC_RESET     ),//uncommented in v3.0
                   .RDEPTH    (ceil_log2(RDEPTH))
                   )
          u_corefifo_fwft(
                     .rd_clk        (RCLOCK        ),
                     .wr_clk        (WCLOCK        ),
                     .clk           (CLK           ),
                     //.reset_rclk_top         (reset_rclk         ),commented in v3.0
                     //.reset_wclk_top         (reset_wclk         ),commented in v3.0
					 .aresetn_wclk  (aresetn_wclk),
					 .aresetn_rclk  (aresetn_rclk),
					 .sresetn_wclk  (sresetn_wclk),
					 .sresetn_rclk  (sresetn_rclk),
                     .empty         (EMPTY2        ),
                     .aempty        (AEMPTY2       ),
                     .rd_en         (RE            ),
                     .fifo_rd_en    (fifo_rd_en    ),
                     .fifo_dout     (mem_pf_RD     ),
                     .fifo_empty    (EMPTY1        ),
                     .fifo_aempty   (AEMPTY1       ),
                     .wr_en         (WE            ), 
                     .din           (DATA          ), 
                     .fwft_dvld     (fwft_dvld     ),
                     .reg_valid     (fwft_reg_valid),
                     .fifo_MEMRADDR (fifo_MEMRADDR ),
                     .fwft_MEMRADDR (fwft_MEMRADDR ),
                     .dout          (fwft_Q        )  
                     );


   endgenerate

   // --------------------------------------------------------------------------
   // Provides read address to ram memory
   // --------------------------------------------------------------------------
   generate
      if(FWFT == 0 && PREFETCH == 0) begin
        //assign #1 ram_raddr = fifo_MEMRADDR;   commented in v3.0
        assign ram_raddr = fifo_MEMRADDR;  //uncommented in v3.0
      end
   endgenerate

   generate
      if(FWFT == 1 && PIPE == 1) begin
         //assign #1 ram_raddr = fwft_MEMRADDR;  commented in v3.0 
         assign  ram_raddr = fwft_MEMRADDR;   
      end
   endgenerate

   generate
      if(PREFETCH == 1 && PIPE == 1) begin
         //assign #1 ram_raddr = fwft_MEMRADDR;  commented in v3.0 
         assign  ram_raddr = fwft_MEMRADDR;  
      end
   endgenerate

   // --------------------------------------------------------------------------
   // Provides read address to ram memory
   // --------------------------------------------------------------------------
   always @(posedge pos_rclk or negedge aresetn_rclk)
     begin
        if(!aresetn_rclk | !sresetn_rclk) begin
           re_set <= 'h0;
        end
        else begin
           if(fifo_MEMRE && !REN_d1) begin      
              re_set <= 1'b0;
           end
           else if(!fifo_MEMRE && REN_d1) begin  
              re_set <= 1'b1;
           end
        end
     end

     always @(posedge pos_rclk or negedge aresetn_rclk)
       begin
          if(!aresetn_rclk | !sresetn_rclk ) begin
            RDATA_r <= 'h0;
          end
          else if(!fifo_MEMRE && REN_d1) begin
             RDATA_r <= RDATA_int;
          end
       end
     
   // --------------------------------------------------------------------------
   // Maintain the last read data
   // --------------------------------------------------------------------------
   always @(posedge pos_rclk or negedge aresetn_rclk)   
     begin
        if(!aresetn_rclk | !sresetn_rclk) begin
           fwft_Q_r <= 'h0;
        end
        else begin
           fwft_Q_r <= Q;
        end
     end

   always @(posedge pos_rclk or negedge aresetn_rclk)   
     begin
        if(!aresetn_rclk | !sresetn_rclk) begin
           RDATA_r_pre <= 'h0;
        end
        else if(fifo_MEMRE) begin
           RDATA_r_pre <= Q ;
        end
     end

   always @(posedge pos_rclk or negedge aresetn_rclk)   
     begin
        if(!aresetn_rclk | !sresetn_rclk) begin
           RDATA_r1 <= 'h0;
        end
        else if(!REN_d1 && REN_d2) begin
           RDATA_r1 <= RDATA_int;
        end
     end

   always @(posedge pos_rclk or negedge aresetn_rclk)   
     begin
        if(!aresetn_rclk | !sresetn_rclk) begin
           RDATA_r2 <= 'h0;
        end
        else if(!REN_d2 && REN_d3) begin
           RDATA_r2 <= RDATA_int;
        end
     end

   assign RE_pol  = RE_POLARITY  ? (~RE) : (RE); 

   always @(posedge pos_rclk or negedge aresetn_rclk)
     begin
        if(!aresetn_rclk) begin
           REN_d1      <= 'h0;
           REN_d2      <= 'h0;
           REN_d3      <= 'h0;         
           RE_d1       <= 'h0;
           RE_d2       <= 'h0;
           RE_d3       <= 'h0;         
           re_pulse_d1 <= 'h0;
           re_pulse_d2 <= 'h0;
           re_pulse_d3 <= 'h0;         
        end
        else begin
           RE_d1       <= RE_pol;
           RE_d2       <= RE_d1;
           RE_d3       <= RE_d2;       
           REN_d1      <= fifo_MEMRE;
           REN_d2      <= REN_d1;
           REN_d3      <= REN_d2;      
           re_pulse_d1 <= re_pulse;
           re_pulse_d2 <= re_pulse_d1;
           re_pulse_d3 <= re_pulse_d2; 
        end
     end

   assign re_pulse     = (!fifo_MEMRE & REN_d1) | re_set;
   assign re_pulse_pre = !fifo_MEMRE;

   assign int_MEMRD_fwft  =  (re_set  & (RE_d1==0      )) ? RDATA_r     : RDATA_int;  
   assign int_MEMRD_pipe0 =  (re_pulse     & (RE_pol==0)) ? RDATA_r_pre : RDATA_int;
   assign int_MEMRD_pipe1 =  (re_pulse_d1  & (RE_d1==0 ) & (ECC == 0 || ECC == 2)) ? RDATA_r     : RDATA_int;  
   assign int_MEMRD_pipe2 =  (re_pulse_d2  & (RE_d2==0 ) & (ECC == 0 || ECC == 2)) ? RDATA_r1    : RDATA_int;  
   
   assign int_MEMRD_pipe1_ecc1 =  (re_pulse_d2  & (RE_d2==0 ) & (ECC == 1)) ? RDATA_r1    : RDATA_int;  
   assign int_MEMRD_pipe2_ecc1 =  (re_pulse_d3  & (RE_d3==0 ) & (ECC == 1)) ? RDATA_r2    : RDATA_int;  

   assign int_MEMRD       =  (FWFT == 1) ? int_MEMRD_fwft      : 
                             ((PREFETCH == 1) ? int_MEMRD_fwft :
                              ((PIPE == 0)? int_MEMRD_pipe0    : 
                               ((PIPE == 1 && ECC != 1) ? int_MEMRD_pipe1  : 
                                ((PIPE == 2 && ECC != 1) ? int_MEMRD_pipe2 : 
                                  ((PIPE == 1 && ECC == 1) ? int_MEMRD_pipe1_ecc1  : 
                                    ((PIPE == 2 && ECC == 1) ? int_MEMRD_pipe2_ecc1 : 
                                     RDATA_int)))))); 

   assign ext_MEMRD_fwft  =  (re_set  & (RE_d1==0      )) ? RDATA_ext_r : MEMRD;
   assign ext_MEMRD_pipe0 =  (re_pulse     & (RE_pol==0)) ? RDATA_r_pre  : MEMRD;
   assign ext_MEMRD_pipe1 =  (re_pulse_d1  & (RE_d1==0 )) ? RDATA_ext_r  : MEMRD;
   assign ext_MEMRD_pipe2 =  (re_pulse_d2  & (RE_d2==0 )) ? RDATA_ext_r1 : MEMRD;
   assign ext_MEMRD       =  (FWFT == 1) ? ext_MEMRD_fwft      : 
                             ((PREFETCH == 1) ? ext_MEMRD_fwft :
                              ((PIPE == 0)? ext_MEMRD_pipe0    : 
                               ((PIPE == 1) ? ext_MEMRD_pipe1  : 
                                ((PIPE == 2) ? ext_MEMRD_pipe2 : MEMRD)))); 

   // --------------------------------------------------------------------------
   // Get the READ Data from internal or external memory based on CTRL_TYPE
   // --------------------------------------------------------------------------
   assign mem_pf_RD = (CTRL_TYPE == 1) ? ext_MEMRD : int_MEMRD;

   //assign #1 fifo_MEMRE_int = fifo_MEMRE;  commented in v3.0 
	assign fifo_MEMRE_int = fifo_MEMRE; // uncommented in v3.0 


   always @(posedge pos_rclk or negedge aresetn_rclk)
     begin
        if(!aresetn_rclk | !sresetn_rclk) begin
           RDATA_ext_r <= 'h0;
        end
        else if(!fifo_MEMRE && REN_d1) begin
           RDATA_ext_r <= MEMRD;
        end
     end
   
   always @(posedge pos_rclk or negedge aresetn_rclk)  
     begin
        if(!aresetn_rclk | !sresetn_rclk) begin
           RDATA_ext_r1 <= 'h0;
        end
        else if(!REN_d1 && REN_d2) begin
           RDATA_ext_r1 <= MEMRD;
        end
     end

   // Connect Correct and Detect flags to the top-level
   generate
     if (ECC != 0) begin
	assign SB_CORRECT = (CTRL_TYPE == 2) ? A_SB_CORRECT : ((CTRL_TYPE == 3) ? (A_SB_CORRECT | B_SB_CORRECT) : 1'b0);
        assign DB_DETECT  = (CTRL_TYPE == 2) ? A_DB_DETECT  : ((CTRL_TYPE == 3) ? (A_DB_DETECT  | B_DB_DETECT ) : 1'b0);
     end
	 
	 else 
		begin
			assign SB_CORRECT = 1'b0;
			assign DB_DETECT  = 1'b0;
		end
endgenerate



   // -----------------------------------------------------------------------
   // Memory wrapper instance
   // -----------------------------------------------------------------------

   generate
     //if (CTRL_TYPE != 1 && FAMILY != 25) begin
     if (CTRL_TYPE != 1 && SYNC == 1) begin

        COREFIFO_C0_COREFIFO_C0_0_ram_wrapper #(
                   .RWIDTH    (RWIDTH            ),
                   .WWIDTH    (WWIDTH            ),
                   .SYNC      (SYNC              ),
				   .SYNC_RESET(SYNC_RESET),
				   .RAM_OPT   (RAM_OPT),
                   .PIPE      (PIPE              ),
                   .CTRL_TYPE (CTRL_TYPE         ),
                   .RDEPTH    (ceil_log2t(RDEPTH)),
                   .WDEPTH    (ceil_log2t(WDEPTH))
                   )
                UI_ram_wrapper_1 (
                                .WDATA (DATA            ),
                                .WADDR (fifo_MEMWADDR   ),
                                .WEN   (fifo_MEMWE      ),
                                .REN   (fifo_MEMRE_int  ),
                                .RDATA (RDATA_int       ), 
                                .RADDR (ram_raddr       ),
                                .CLOCK (CLK             ),  
                                .WCLOCK(WCLOCK          ),  
                                .RCLOCK(RCLOCK          ),  
                                .A_SB_CORRECT(A_SB_CORRECT),  
                                .B_SB_CORRECT(B_SB_CORRECT),  
                                .A_DB_DETECT (A_DB_DETECT),  
                                .B_DB_DETECT (B_DB_DETECT),  
                                .RESET_N(RESET_N          )
                                );
     end
endgenerate

 generate
     //if (CTRL_TYPE != 1 && FAMILY != 25) begin
     if (CTRL_TYPE != 1 && SYNC == 0) begin

        COREFIFO_C0_COREFIFO_C0_0_ram_wrapper #(
                   .RWIDTH    (RWIDTH            ),
                   .WWIDTH    (WWIDTH            ),
                   .SYNC      (SYNC              ),
				   .SYNC_RESET(SYNC_RESET),
				   .RAM_OPT   (RAM_OPT),
                   .PIPE      (PIPE              ),
                   .CTRL_TYPE (CTRL_TYPE         ),
                   .RDEPTH    (ceil_log2t(RDEPTH)),
                   .WDEPTH    (ceil_log2t(WDEPTH))
                   )
                UI_ram_wrapper_1 (
                                .WDATA (DATA            ),
                                .WADDR (fifo_MEMWADDR   ),
                                .WEN   (fifo_MEMWE      ),
                                .REN   (fifo_MEMRE_int  ),
                                .RDATA (RDATA_int       ), 
                                .RADDR (ram_raddr       ),
                                .CLOCK (CLK             ),  
                                .WCLOCK(WCLOCK          ),  
                                .RCLOCK(RCLOCK          ),  
                                .A_SB_CORRECT(A_SB_CORRECT),  
                                .B_SB_CORRECT(B_SB_CORRECT),  
                                .A_DB_DETECT (A_DB_DETECT),  
                                .B_DB_DETECT (B_DB_DETECT),  
                                .RESET_N(RRESET_N          )
                                );
     end
endgenerate

/* // The following changes are done for RTG4 Family only.
// When RESET_POLARITY = 1 (Active HIGH), the RAM memories must be applied
// constant '0' de-asserted state .
// When RESET_POLARITY = 0 (Active LOW), the RAM memories must be applied
// constant '1' de-asserted state.
// v2.5: Added ECC functionality
   generate
     if ((CTRL_TYPE != 1 && FAMILY == 25 && RESET_POLARITY == 1 && ECC == 0) || (CTRL_TYPE == 3 && FAMILY == 25 && RESET_POLARITY == 1 && ECC == 1 && PIPE == 0)) begin 

        COREFIFO_C0_COREFIFO_C0_0_ram_wrapper #(
                   .RWIDTH    (RWIDTH            ),
                   .WWIDTH    (WWIDTH            ),
                   .SYNC      (SYNC              ),
                   .PIPE      (PIPE              ),
                   .CTRL_TYPE (CTRL_TYPE         ),
                   .RDEPTH    (ceil_log2t(RDEPTH)),
                   .WDEPTH    (ceil_log2t(WDEPTH))
                   )
                UI_ram_wrapper_2 (
                                .WDATA (DATA            ),
                                .WADDR (fifo_MEMWADDR   ),
                                .WEN   (fifo_MEMWE      ),
                                .REN   (fifo_MEMRE_int  ),
                                .RDATA (RDATA_int       ), 
                                .RADDR (ram_raddr       ),
                                .CLOCK (CLK             ),  
                                .WCLOCK(WCLOCK          ),  
                                .RCLOCK(RCLOCK          ),  
                                .A_SB_CORRECT(A_SB_CORRECT),  
                                .B_SB_CORRECT(B_SB_CORRECT),  
                                .A_DB_DETECT (A_DB_DETECT ),  
                                .B_DB_DETECT (B_DB_DETECT ),  
                                //.RESET_N(1'b0         )commented in v3.0
                                .RESET_N(RRESET          )
                                );
     end
endgenerate

   generate
     if ((CTRL_TYPE != 1 && FAMILY == 25 && RESET_POLARITY == 0 && ECC == 0)  || (CTRL_TYPE == 3 && FAMILY == 25 && RESET_POLARITY == 1 && ECC == 1 && PIPE == 0))begin 

        COREFIFO_C0_COREFIFO_C0_0_ram_wrapper #(
                   .RWIDTH    (RWIDTH            ),
                   .WWIDTH    (WWIDTH            ),
                   .SYNC      (SYNC              ),
                   .PIPE      (PIPE              ),
                   .CTRL_TYPE (CTRL_TYPE         ),
                   .RDEPTH    (ceil_log2t(RDEPTH)),
                   .WDEPTH    (ceil_log2t(WDEPTH))
                   )
                UI_ram_wrapper_3 (
                                .WDATA (DATA            ),
                                .WADDR (fifo_MEMWADDR   ),
                                .WEN   (fifo_MEMWE      ),
                                .REN   (fifo_MEMRE_int  ),
                                .RDATA (RDATA_int       ), 
                                .RADDR (ram_raddr       ),
                                .CLOCK (CLK             ),  
                                .WCLOCK(WCLOCK          ),  
                                .RCLOCK(RCLOCK          ),  
                                .A_SB_CORRECT(A_SB_CORRECT),  
                                .B_SB_CORRECT(B_SB_CORRECT),  
                                .A_DB_DETECT (A_DB_DETECT ),  
                                .B_DB_DETECT (B_DB_DETECT ),  
                                //.RESET_N(1'b1           )commented in v3.0
                                .RESET_N(RRESET           )
                                );
     end
endgenerate


// v2.5
   generate
     if (CTRL_TYPE == 2 && FAMILY == 25 && RESET_POLARITY == 1 && ECC != 0) begin

        COREFIFO_C0_COREFIFO_C0_0_ram_wrapper #(
                   .RWIDTH    (RWIDTH            ),
                   .WWIDTH    (WWIDTH            ),
                   .SYNC      (SYNC              ),
                   .PIPE      (PIPE              ),
                   .CTRL_TYPE (CTRL_TYPE         ),
                   .RDEPTH    (ceil_log2t(RDEPTH)),
                   .WDEPTH    (ceil_log2t(WDEPTH))
                   )
                UI_ram_wrapper_2 (
                                .WDATA (DATA            ),
                                .WADDR (fifo_MEMWADDR   ),
                                .WEN   (fifo_MEMWE      ),
                                .REN   (fifo_MEMRE_int  ),
                                .RDATA (RDATA_int       ), 
                                .RADDR (ram_raddr       ),
                                .CLOCK (CLK             ),  
                                .WCLOCK(WCLOCK          ),  
                                .RCLOCK(RCLOCK          ),  
                                .A_SB_CORRECT(A_SB_CORRECT),  
                                .B_SB_CORRECT(B_SB_CORRECT),  
                                .A_DB_DETECT (A_DB_DETECT ),  
                                .B_DB_DETECT (B_DB_DETECT),  
                                //.RESET_N(1'b0           )commented in v3.0
                                .RESET_N(RRESET           )
                                );
     end
endgenerate

   generate
     if (CTRL_TYPE == 2 && FAMILY == 25 && RESET_POLARITY == 0 && ECC != 0) begin

        COREFIFO_C0_COREFIFO_C0_0_ram_wrapper #(
                   .RWIDTH    (RWIDTH            ),
                   .WWIDTH    (WWIDTH            ),
                   .SYNC      (SYNC              ),
                   .PIPE      (PIPE              ),
                   .CTRL_TYPE (CTRL_TYPE         ),
                   .RDEPTH    (ceil_log2t(RDEPTH)),
                   .WDEPTH    (ceil_log2t(WDEPTH))
                   )
                UI_ram_wrapper_3 (
                                .WDATA (DATA            ),
                                .WADDR (fifo_MEMWADDR   ),
                                .WEN   (fifo_MEMWE      ),
                                .REN   (fifo_MEMRE_int  ),
                                .RDATA (RDATA_int       ), 
                                .RADDR (ram_raddr       ),
                                .CLOCK (CLK             ),  
                                .WCLOCK(WCLOCK          ),  
                                .RCLOCK(RCLOCK          ),  
                                .A_SB_CORRECT(A_SB_CORRECT),  
                                .B_SB_CORRECT(B_SB_CORRECT),  
                                .A_DB_DETECT (A_DB_DETECT ),  
                                .B_DB_DETECT (B_DB_DETECT),  
                                //.RESET_N(1'b1           )commented in v3.0
                                .RESET_N(RRESET           )
                                );
     end
endgenerate

   generate
     if (CTRL_TYPE == 3 && FAMILY == 25 && RESET_POLARITY == 1 && ((ECC != 0 && PIPE !=0) || (ECC == 2 && PIPE == 0))) begin

        COREFIFO_C0_COREFIFO_C0_0_ram_wrapper #(
                   .RWIDTH    (RWIDTH            ),
                   .WWIDTH    (WWIDTH            ),
                   .SYNC      (SYNC              ),
                   .PIPE      (PIPE              ),
                   .CTRL_TYPE (CTRL_TYPE         ),
                   .RDEPTH    (ceil_log2t(RDEPTH)),
                   .WDEPTH    (ceil_log2t(WDEPTH))
                   )
                UI_ram_wrapper_2 (
                                .WDATA (DATA            ),
                                .WADDR (fifo_MEMWADDR   ),
                                .WEN   (fifo_MEMWE      ),
                                .REN   (fifo_MEMRE_int  ),
                                .RDATA (RDATA_int       ), 
                                .RADDR (ram_raddr       ),
                                .CLOCK (CLK             ),  
                                .WCLOCK(WCLOCK          ),  
                                .RCLOCK(RCLOCK          ),  
                                .A_SB_CORRECT(A_SB_CORRECT),  
                                .B_SB_CORRECT(B_SB_CORRECT),  
                                .A_DB_DETECT (A_DB_DETECT ),  
                                .B_DB_DETECT (B_DB_DETECT ),  
                                //.RESET_N(1'b0           )commented in v3.0
                                .RESET_N(RRESET          )
                                );
     end
endgenerate

   generate
     if (CTRL_TYPE == 3 && FAMILY == 25 && RESET_POLARITY == 0 && ((ECC != 0 && PIPE !=0) || (ECC == 2 && PIPE == 0))) begin
        COREFIFO_C0_COREFIFO_C0_0_ram_wrapper #(
                   .RWIDTH    (RWIDTH            ),
                   .WWIDTH    (WWIDTH            ),
                   .SYNC      (SYNC              ),
                   .PIPE      (PIPE              ),
                   .CTRL_TYPE (CTRL_TYPE         ),
                   .RDEPTH    (ceil_log2t(RDEPTH)),
                   .WDEPTH    (ceil_log2t(WDEPTH))
                   )
                UI_ram_wrapper_3 (
                                .WDATA (DATA            ),
                                .WADDR (fifo_MEMWADDR   ),
                                .WEN   (fifo_MEMWE      ),
                                .REN   (fifo_MEMRE_int  ),
                                .RDATA (RDATA_int       ), 
                                .RADDR (ram_raddr       ),
                                .CLOCK (CLK             ),  
                                .WCLOCK(WCLOCK          ),  
                                .RCLOCK(RCLOCK          ),  
                                .A_SB_CORRECT(A_SB_CORRECT),  
                                .B_SB_CORRECT(B_SB_CORRECT),  
                                .A_DB_DETECT (A_DB_DETECT ),  
                                .B_DB_DETECT (B_DB_DETECT ),  
                                //.RESET_N(1'b1           )commented in v3.0
                                .RESET_N(RRESET       )
                                );
     end
endgenerate */




endmodule // COREFIFO_C0_COREFIFO_C0_0_COREFIFO

   // --------------------------------------------------------------------------
   //                             End - of - Code
   // --------------------------------------------------------------------------

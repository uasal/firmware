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

`timescale 1ns/100ps

module COREFIFO_C0_COREFIFO_C0_0_corefifo_sync_scntr (
    clk,
    //reset,
	aresetn,
	sresetn,
    we,
    re,
    re_top,
    full,
    afull,
    wrcnt,
    empty,
    aempty,
    rdcnt,
    underflow,
    overflow,
    dvld,
    wack,
    memwaddr,
    memwe,
    memraddr,
    memre,
    empty_top_fwft   

);

   // --------------------------------------------------------------------------
   // PARAMETER Declaration
   // --------------------------------------------------------------------------
   parameter WRITE_WIDTH      = 18;
   parameter WRITE_DEPTH      = 10;
   parameter FULL_WRITE_DEPTH = 1024;
   parameter READ_WIDTH       = 18;
   parameter READ_DEPTH       = WRITE_DEPTH;
   parameter FULL_READ_DEPTH  = 1024;
   parameter PREFETCH         = 1;
   parameter FWFT             = 0;
   parameter WCLK_HIGH        = 1;
   parameter RESET_LOW        = 1;
   parameter WRITE_LOW        = 1;
   parameter READ_LOW         = 1;
   parameter AF_FLAG_STATIC   = 1;
   parameter AE_FLAG_STATIC   = 1;
   parameter AFULL_VAL        = 1020;
   parameter AEMPTY_VAL       = 4;
   parameter ESTOP            = 1;
   parameter FSTOP            = 1;
   parameter PIPE             = 1;
   parameter REGISTER_RADDR   = 1;
   parameter READ_DVALID      = 1;
   parameter WRITE_ACK        = 1;
   parameter OVERFLOW_EN      = 1; 
   parameter UNDERFLOW_EN     = 1; 
   parameter WRCNT_EN         = 1; 
   parameter RDCNT_EN         = 1; 
   parameter ECC              = 1;
   parameter SYNC_RESET       = 0;//uncommented in v3.0
   parameter FAMILY			  = 25;
   localparam WDEPTH_CAL      = (WRITE_DEPTH == 0) ? WRITE_DEPTH : (WRITE_DEPTH-1); 
   localparam RDEPTH_CAL      = (READ_DEPTH == 0)  ? READ_DEPTH  : (READ_DEPTH-1); 

   // --------------------------------------------------------------------------
   // I/O Declaration
   // --------------------------------------------------------------------------
   
   //--------
   // Inputs
   //--------
    input                    clk;                  // fifo clock
    //input                    reset;                // reset
    input                     aresetn;
    input                     sresetn;	
    input                    we;                   // write enable to fifo
    input                    re;                   // read enable to fifo
    input                    re_top;                   // read enable to fifo
    input                    empty_top_fwft;    

   //---------
   // Outputs
   //---------
    output                   full;                 // full status flag
    output                   afull;                // almost full status flag
    output [WRITE_DEPTH:0]   wrcnt;                // number of elements remaining in write domain

    output                   empty;                // empty status flag
    output                   aempty;               // almost empty status flag
    output [READ_DEPTH:0]    rdcnt;                // number of elements remaining in read domain

    output                   underflow;            // underflow status flag
    output                   overflow;             // overflow status flag
    output                   dvld;                 // dvld status flag
    output                   wack;                 // wack status flag

    output [WDEPTH_CAL:0]    memwaddr;             // memory write address
    output                   memwe;                // memory write enable
    output [RDEPTH_CAL:0]    memraddr;             // memory read address
    output                   memre;                // memory read enable
    
   // --------------------------------------------------------------------------
   // Internal signals
   // --------------------------------------------------------------------------
    wire                     full;
    wire                     afull;
    reg    [WRITE_DEPTH:0]   wrcnt;
    wire                     empty;
    wire                     aempty;
    wire                     aempty_fwft;
    reg    [READ_DEPTH:0]    rdcnt;
    wire   [WDEPTH_CAL:0]    memwaddr;
    wire                     memwe;
    wire   [RDEPTH_CAL:0]    memraddr;
    wire                     memre;

    reg                      full_r;
    reg                      full_reg;
    reg                      afull_r;
    reg                      empty_r;
    reg                      empty_r_fwft;
    reg                      empty_top_fwft_r;
    reg                      aempty_r;
    reg                      aempty_r_fwft;
    reg    [WDEPTH_CAL:0]    memwaddr_r;
    reg    [RDEPTH_CAL:0]    memraddr_r;
    reg                      dvld_r;
    reg                      dvld_r2;
    reg                      underflow_r;
    reg                      wack_r;
    reg                      overflow_r;
    reg    [READ_DEPTH:0]    sc_r;
    reg    [WRITE_DEPTH:0]    sc_w;
    wire    [READ_DEPTH:0]    sc_r_cmb;//added in v3.0
    wire    [WRITE_DEPTH:0]    sc_w_cmb;//added in v3.0
    reg    [READ_DEPTH:0]    sc_r_fwft;
    wire    [READ_DEPTH:0]    sc_r_fwft_cmb;//added in v3.0
    reg                      almostemptyi;
    reg                      re_p_d1; 
    reg                      we_f_i; 

    wire   [WRITE_DEPTH:0]   afthreshi;
    wire   [READ_DEPTH:0]    aethreshi;
    wire                     fulli;
    wire                     almostfulli;
    wire                     almostfulli_assert;   
    wire                     almostfulli_deassert; 
    wire                     fulli_assert; 
    wire                     fulli_deassert; 
    wire                     emptyi;
    wire                     emptyi_fwft;
    wire                     we_p;
    wire                     re_p;
    wire                     we_i;
    wire                     re_i;
    wire                     pos_clk;
    wire                     neg_reset;
    wire                     re_top_p;
    wire                     aresetn;
    wire                     sresetn;//uncommented in v3.0

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
   assign pos_clk   =  WCLK_HIGH  ? clk    : ~clk; 
   
   
   //assign resetn =  RESET_LOW  ? ~reset : reset;

   // --------------------------------------------------------------------------
   // resets
   // --------------------------------------------------------------------------
   //assign aresetn   = (SYNC_RESET == 1) ? 1'b1      : neg_reset;
   //assign sresetn   = (SYNC_RESET == 1) ? neg_reset : 1'b1;

   //assign aresetn   = (SYNC_RESET == 1) ? 1'b1      : resetn;
   //assign sresetn   = (SYNC_RESET == 1) ? resetn : 1'b1;


   // --------------------------------------------------------------------------
   // Read and Write enables
   // --------------------------------------------------------------------------
   generate  
      if (FWFT == 0 && PREFETCH == 0)  begin
         assign re_p  = READ_LOW  ? (~re) : (re);
         assign we_p  = WRITE_LOW ? (~we) : (we);
      end
   endgenerate

   generate
      if ((FWFT == 1 || PREFETCH == 1) && PIPE == 1)  begin
         assign re_p  = re;
         assign re_top_p  = READ_LOW  ? (~re_top) : (re_top);
         assign we_p  = WRITE_LOW ? (~we) : (we);
      end
   endgenerate

   assign       we_i = we_p & !full_r ;
   assign       re_i = re_p & !empty_r;

   // --------------------------------------------------------------------------
   // Top-level outputs
   // --------------------------------------------------------------------------
   assign full      = full_r;
   assign afull     = afull_r;
   assign empty     = empty_r;
   assign aempty    = aempty_r;
   assign aempty_fwft = aempty_r;
   assign underflow = underflow_r;
   assign wack      = wack_r;
   assign dvld      = (REGISTER_RADDR==2) ? dvld_r2 : 
	              ((REGISTER_RADDR == 1 && PREFETCH == 0) ? dvld_r : re_i);
   assign overflow  = overflow_r;
   assign memwaddr  = memwaddr_r;
   assign memraddr  = memraddr_r;
   assign memwe     = we_i;
   assign memre     = re_i;    

   // --------------------------------------------------------------------------
   // Generate top-level read data output
   // wrcnt: write count is the number of elements remaining in the Wr clock
   // domain
   // --------------------------------------------------------------------------         
   always @(negedge aresetn or posedge pos_clk)  
     begin
        if (!aresetn | !sresetn ) begin
           wrcnt <= {WRITE_DEPTH{1'b0}};
        end
        else if (WRCNT_EN && PREFETCH == 0 && FWFT == 0 && ECC == 1 && FAMILY == 25) begin
           //wrcnt <= sc_r; 
           wrcnt <= sc_w_cmb; ////added in v3.0
        end		
        else if (WRCNT_EN && PREFETCH == 0 && FWFT == 0) begin
           //wrcnt <= sc_r; 
           wrcnt <= sc_r_cmb; ////added in v3.0
        end
		
        else if (WRCNT_EN && (PREFETCH == 1 || FWFT == 1)) begin
           //wrcnt <= sc_r_fwft; 
           wrcnt <= sc_r_fwft_cmb; ////added in v3.0
        end
        else begin
           wrcnt <= {WRITE_DEPTH{1'b0}};
        end
     end

   // --------------------------------------------------------------------------
   // rdcnt: read count is the number of elements remaining in the Rd clock
   // domain
   // --------------------------------------------------------------------------         
   always @(negedge aresetn or posedge pos_clk)
     begin
        if (!aresetn | !sresetn) begin
           rdcnt <= {READ_DEPTH{1'b0}};
        end
        else if (RDCNT_EN && PREFETCH == 0 && FWFT == 0) begin
           //rdcnt <= sc_r; 
           rdcnt <= sc_r_cmb; ////added in v3.0
        end
        else if (RDCNT_EN && (PREFETCH == 1 || FWFT == 1)) begin
           //rdcnt <= sc_r_fwft; 
           rdcnt <= sc_r_fwft_cmb; //added in v3.0
        end
       else begin
          rdcnt <= {READ_DEPTH{1'b0}};
       end
     end

//////////////////////////////////////For ECC and pipe/////AI
generate 
 //if ( ECC == 1 && PIPE == 2 )  
 if ( ECC == 1 && FAMILY == 25 )  
   begin 
     reg empty_f;
    
     assign emptyi    =  (( sc_r == 1) & re_i & !we_f_i); 

     always @(negedge aresetn or posedge pos_clk)
       begin
         if (!aresetn | !sresetn) 
           empty_f <= 1'b1;        
         else if (re_i ^ we_i)  
           empty_f <= emptyi ;
       end

     always @(posedge pos_clk or negedge aresetn)
       if (!aresetn | !sresetn) //begin
         empty_r <= 1'b1; 
       else
         empty_r <= emptyi ? 1'b1 : empty_f;
   end 
 else 
   begin
      assign       emptyi    =  ( sc_r == 1) & !we_i & re_i;

      always @(posedge pos_clk or negedge aresetn)
        if (!aresetn | !sresetn) 
          empty_r <= 1'b1; 
        else if(re_i ^ we_i)
          empty_r <= emptyi;
   end  
 endgenerate 

////////////////////////////////////////////


      always @(posedge pos_clk or negedge aresetn)
        if (!aresetn | !sresetn) 
          we_f_i <= 1'b0; 
        else
          we_f_i <= we_i;


    

     assign sc_r_cmb = ( ECC == 1 && FAMILY == 25 ) ? sc_r + we_f_i - re_i : sc_r + we_i - re_i;////added in v3.0
	 generate	
		if(( ECC == 1 && FAMILY == 25 ))
			assign sc_w_cmb =  sc_w + we_i - re_i;////added in v3.0 
		else
			assign sc_w_cmb = 0;
	 endgenerate
	 
     assign sc_r_fwft_cmb = sc_r_fwft + we_i - re_top_p;////added in v3.0
   // --------------------------------------------------------------------------
   // Binary counter
   // The counter increments on Write and decrements on Read
   // --------------------------------------------------------------------------
    always @(negedge aresetn or posedge pos_clk)
    begin
       if (!aresetn | !sresetn) begin
           sc_r <= 0;
       end
       else if ( ECC == 1 && FAMILY == 25 ) begin
		if( we_f_i ^ re_i) begin
			sc_r <= sc_r_cmb; 
		end
	   end
       else begin
			if ( we_i ^ re_i) begin
             sc_r <= sc_r_cmb; //added in v3.0
		end
	   end
    end


    always @(negedge aresetn or posedge pos_clk)
    begin
       if (!aresetn | !sresetn) begin
           sc_w <= 0;
       end
       else if ( ECC == 1 && FAMILY == 25 ) begin
		if( we_i ^ re_i) begin
			sc_w <= sc_w_cmb; 
		end
	   end
    end


   always @(negedge aresetn or posedge pos_clk)
     begin
        if (!aresetn | !sresetn) begin
           sc_r_fwft <= 0;
        end
        //else if ( we_i ^ ((re_top_p & empty_top_fwft & !empty_top_fwft_r) || (re_top_p & !empty_top_fwft) )) begin   ---SAR #112344
        else if ( we_i ^ (re_top_p & !empty_top_fwft)) begin  
	     if(we_i == 1'b1) begin
               //sc_r_fwft <= (sc_r_fwft + 1); 
               sc_r_fwft <= sc_r_fwft_cmb; //added in v3.0
             end
	     //else if(((re_top_p & empty_top_fwft & !empty_top_fwft_r) || (re_top_p & !empty_top_fwft) )) begin  ---SAR #112344
	     else if(re_top_p & !empty_top_fwft) begin  
               //sc_r_fwft <= (sc_r_fwft - 1); 
               sc_r_fwft <= sc_r_fwft_cmb;
	     end
        end
    end

   assign emptyi_fwft  =  ( sc_r_fwft  == 'h0);  
   
   // --------------------------------------------------------------------------
   // Generate almost flags
   // --------------------------------------------------------------------------         
   generate
      if (FWFT == 0 && PREFETCH == 0)  begin

      // --------------------------------------------------------------------------
      // threshold values
      // --------------------------------------------------------------------------
      assign afthreshi =  AF_FLAG_STATIC ? AFULL_VAL-1  : FULL_WRITE_DEPTH;     
      assign aethreshi =  AE_FLAG_STATIC ? AEMPTY_VAL   : 2;    //SAR#60185

      always @(*)
      begin
        //***AHK almostemptyi =  (( sc_r <= aethreshi) & !we_i & re_i) | ( (sc_r < aethreshi) & we_i & !re_i);          
        almostemptyi =  (( sc_r <= aethreshi) & !we_i & re_i) | ( (sc_r+1 < aethreshi) & we_i & !re_i);          
      end

      //***AHK assign almostfulli  =  ((sc_r >= (afthreshi)) & we_i & !re_i) | ( (sc_r > afthreshi) & !we_i & re_i);
      assign almostfulli  =  ( ECC == 1 && FAMILY == 25 ) ? ((sc_w >= (afthreshi)) & we_i & !re_i) | ( (sc_w-1 > afthreshi) & !we_i & re_i) : ((sc_r >= (afthreshi)) & we_i & !re_i) | ( (sc_r-1 > afthreshi) & !we_i & re_i);
      assign fulli        =  ( ECC == 1 && FAMILY == 25 ) ? ( sc_w == (FULL_WRITE_DEPTH-1)) & we_i & !re_i : ( sc_r == (FULL_WRITE_DEPTH-1)) & we_i & !re_i ;
      end
   endgenerate

   generate
      if ((FWFT == 1 || PREFETCH == 1) && PIPE == 1)  begin

      // --------------------------------------------------------------------------
      // threshold values
      // --------------------------------------------------------------------------
      assign afthreshi =  AF_FLAG_STATIC ? AFULL_VAL    : FULL_WRITE_DEPTH;     
      assign aethreshi =  AE_FLAG_STATIC ? AEMPTY_VAL   : 2;    //SAR#60185

   always @(posedge pos_clk or negedge aresetn)
     begin
        if (!aresetn | !sresetn) begin
           almostemptyi <= 1'b1;
        end 
        else begin
           if((sc_r_fwft >= aethreshi) && we_i & !re_top_p) begin
              almostemptyi <= 1'b0;
           end
           else if((sc_r_fwft-1 <= aethreshi) && sc_r_fwft > 0 && !we_i & re_top_p) begin   
              almostemptyi <= 1'b1;
           end
        end
     end

         assign almostfulli_assert    =  ((sc_r_fwft >= (afthreshi-1)) & we_i & !(re_top_p & !empty_r_fwft));  
         assign almostfulli_deassert  =  ( (sc_r_fwft <= afthreshi) & !we_i & (re_top_p & !empty_r_fwft));     
         assign almostfulli  =  almostfulli_assert ? 1'b1 : (almostfulli_deassert ? 1'b0 : afull_r); 

         assign fulli_assert   =  ( sc_r_fwft >= (FULL_WRITE_DEPTH-1)) & we_i & !(re_top_p & !empty_r_fwft);  
         assign fulli_deassert =  ( sc_r_fwft < (FULL_WRITE_DEPTH-1 )) & !we_i & (re_top_p & !empty_r_fwft);  
         assign fulli          =  fulli_deassert ? 1'b0 : (fulli_assert ? 1'b1 : full_r);  
      end
   endgenerate

   always @(posedge pos_clk or negedge aresetn)
     begin
        if (!aresetn | !sresetn) begin
           dvld_r2  <= 1'b0;
           full_reg <= 1'b0;
           re_p_d1  <= 'h0;
           empty_top_fwft_r <= 1'b1;
        end
        else begin
           dvld_r2  <= dvld_r;
           full_reg <= full_r;
           re_p_d1  <= re_p;
           empty_top_fwft_r <= empty_top_fwft;  
        end
     end

   // --------------------------------------------------------------------------    
   // Generate the status flags - Empty/Full/Almost Empty/ Almost Full
   // Generate the data handshaking flags - DVLD/WACK
   // Generate error count flags - Underflow/Overflow
   // Generate write and read address signals to the external memory
   // --------------------------------------------------------------------------    
    always @(posedge pos_clk or negedge aresetn)
    begin
        if (!aresetn | !sresetn) begin
         //   empty_r     <= 1'b1;
            empty_r_fwft<= 1'b1;
            aempty_r_fwft    <= 1'b1;
            dvld_r      <= 1'b0;
            underflow_r <= 1'b0;
        end
        else begin

         //   if (we_i ^ re_i)
           //     empty_r <= emptyi;

            if (we_i ^  ((re_top_p &  empty_top_fwft & !empty_top_fwft_r)|| (re_top_p & !empty_top_fwft)))  
                empty_r_fwft <= emptyi_fwft;

            if ((we_i ^ (re_top_p &  !empty_r_fwft)))
              aempty_r_fwft <= almostemptyi;


            if (re_i == 1'b1 && READ_DVALID == 1 && (FWFT == 0 && PREFETCH == 0))
               dvld_r <= 1'b1;
            else if ((re_top_p &  !empty_r_fwft) && READ_DVALID == 1 && (FWFT == 1 || PREFETCH == 1))  
               dvld_r <= 1'b1;
            else
               dvld_r <= 1'b0;

            if ( re_p == 1'b1 && empty_r == 1'b1 && UNDERFLOW_EN == 1 && (FWFT == 0 && PREFETCH == 0))
               underflow_r <= 1'b1;
            else if ( re_top_p == 1'b1 && empty_top_fwft == 1'b1 && UNDERFLOW_EN == 1  && (FWFT == 1 || PREFETCH == 1))  
              underflow_r <= 1'b1;
            else
              underflow_r <= 1'b0;

        end
    end

   generate
      if (FWFT == 0 && PREFETCH == 0)  begin

         always @(posedge pos_clk or negedge aresetn)
         begin
          if (!aresetn | !sresetn) begin
            aempty_r    <= 1'b1;
          end
          else begin
            if ((we_i ^ re_i)) begin  
                aempty_r <= almostemptyi;
            end
          end
         end

       always @(posedge pos_clk or negedge aresetn)
       begin
        if (!aresetn | !sresetn) begin
            full_r     <= 1'b0;
            afull_r    <= 1'b0;
            wack_r     <= 1'b0;
            overflow_r <= 1'b0;
        end
        else begin
		
			if(we_i ^ re_i) begin
				full_r  <= fulli;
			end


            if ((we_i ^ re_i))
               afull_r <= almostfulli;

            if (we_i == 1'b1 && WRITE_ACK == 1)
               wack_r <= 1'b1;
            else
               wack_r <= 1'b0;

            if ( we_p == 1'b1 && full_r == 1'b1 && OVERFLOW_EN == 1)
               overflow_r <= 1'b1; 
            else
               overflow_r <= 1'b0;

        end
       end

      end
   endgenerate

   generate
      if ((FWFT == 1 || PREFETCH == 1) && PIPE == 1)  begin
         always @(*)
         begin
           aempty_r = almostemptyi;
         end

         always @(posedge pos_clk or negedge aresetn)
         begin
           if (!aresetn | !sresetn) begin
            full_r     <= 1'b0;
            afull_r    <= 1'b0;
            wack_r     <= 1'b0;
            overflow_r <= 1'b0;
           end
           else begin
            if ((we_i ^ (re_top_p &  !empty_r_fwft)) ) begin
               if (we_i == 1'b1 && !(re_top_p &  !empty_r_fwft)) begin 
                 full_r  <= fulli;
               end 
               else if (we_i == 1'b0 && (re_top_p &  !empty_r_fwft)) begin 
                 full_r  <= 1'b0;
               end 
            end

            if ((we_i ^ (re_top_p &  !empty_r_fwft)))
               afull_r <= almostfulli;

            if (we_i == 1'b1 && WRITE_ACK == 1)
               wack_r <= 1'b1;
            else
               wack_r <= 1'b0;

            if ( we_p == 1'b1 && full_r == 1'b1 && OVERFLOW_EN == 1)
               overflow_r <= 1'b1;
            else
               overflow_r <= 1'b0;


        end
    end

     end
   endgenerate

   // --------------------------------------------------------------------------
   // Generate write and read addresses to the memory
   // --------------------------------------------------------------------------         
   always @(posedge pos_clk or negedge aresetn )
     begin
        if ( !aresetn | !sresetn ) begin
           memwaddr_r <= 'h0;
        end
        else begin
           if ( we_i == 1'b1) begin
              if(memwaddr_r == (FULL_WRITE_DEPTH-1)) begin    //SAR#68070
                 memwaddr_r <= 'h0;
	      end else begin
                 memwaddr_r <= memwaddr_r + 1;
              end
           end
        end
     end

   always @(posedge pos_clk or negedge aresetn)
     begin
        if ( !aresetn | !sresetn ) begin
           memraddr_r <= 'h0;
        end
        else begin
	   if ( re_i == 1'b1) begin
              if(memraddr_r == (FULL_READ_DEPTH-1)) begin    //SAR#68070
                memraddr_r <= 'h0;
	      end else begin
                memraddr_r <= memraddr_r + 1;
              end
           end
        end
     end

endmodule // corefifo_sync_scntr

   // --------------------------------------------------------------------------
   //                             End - of - Code
   // --------------------------------------------------------------------------

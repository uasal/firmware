// ********************************************************************/
// Actel Corporation Proprietary and Confidential
// Copyright 2010 Actel Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description: AXI_Master module perform axi_write task and axi_read task,
// where it generate data and send it to DUT during write task and receive
// data during read task from DUT.
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


module AXI_Master(
	//AXI Interface
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
          RVALID
         
	);
         
//---------------------------------------------------
// Global parameters
//---------------------------------------------------
  parameter   AXI_AWIDTH   = 32; 
  parameter   AXI_DWIDTH   = 64; 
  parameter   UNDEF_BURST  = 0;  // if '0' then single transter else INCR16
  
  localparam  AXI_WRSTB    = AXI_DWIDTH / 8;
  localparam  DEPTH        = 256;
  localparam  MNOB         = 8;
  localparam  LOWERLIMIT   = 0;


//-----------------------------------------------------------------------------
//----------------------INPUT-OUTPUT PORTS-------------------------------------
//-----------------------------------------------------------------------------


// Outputs on AXI Interface
  input                      ACLK;
  input                      ARESETN;
  input                      AWREADY;
  input                      WREADY;
  input[3:0]                 BID;
  input[1:0]                 BRESP;
  input                      BVALID;
  input                      ARREADY;
  input[3:0]                 RID;
  input[AXI_DWIDTH-1:0]      RDATA;
  input[1:0]                 RRESP;
  input                      RLAST;
  input                      RVALID;


// Inputs on AXI Interface
  output  [3:0]              AWID;
  output  [AXI_AWIDTH-1:0]   AWADDR;
  output  [3:0]              AWLEN;
  output  [2:0]              AWSIZE;
  output  [1:0]              AWBURST;
  output                     AWVALID;
  output  [3:0]              WID;
  output  [AXI_DWIDTH-1:0]   WDATA;
  output  [AXI_WRSTB-1:0]    WSTRB;
  output                     WLAST;
  output                     WVALID;
  output                     BREADY;
  output  [3:0]              ARID;
  output  [AXI_AWIDTH-1:0]   ARADDR;
  output  [3:0]              ARLEN;
  output  [2:0]              ARSIZE;
  output  [1:0]              ARBURST;
  output [1:0]               ARLOCK;
  output                     ARVALID;
  output                     RREADY;
  output  [1:0]              AWLOCK;
  

  reg  [3:0]                 AWID;
  reg  [AXI_AWIDTH-1:0]      AWADDR;
  reg  [3:0]                 AWLEN;
  reg  [2:0]                 AWSIZE;
  reg  [1:0]                 AWBURST;
  reg                        AWVALID;
  reg  [3:0]                 WID;
  reg  [AXI_DWIDTH-1:0]      WDATA;
  reg  [AXI_WRSTB-1:0]       WSTRB;
  reg                        WLAST;
  reg                        WVALID;
  reg                        BREADY;
  reg  [3:0]                 ARID;
  reg  [AXI_AWIDTH-1:0]      ARADDR;
  reg  [3:0]                 ARLEN;
  reg  [2:0]                 ARSIZE;
  reg  [1:0]                 ARBURST;
  reg [1:0]                  ARLOCK;
  reg                        ARVALID;
  reg                        RREADY;
  reg  [1:0]                 AWLOCK; 
  reg  [1:0]    	     RESP;
  reg [AXI_DWIDTH-1:0]       data;
  reg [7:0]                  check_mem[DEPTH-1:0];
  reg [AXI_AWIDTH-1:0]	     aligned_add;
  reg [AXI_AWIDTH-1:0]       wrap_bound;
  reg [3:0]                  rid;
  integer                     k;
  integer                     j;
  integer                     counter;
//------ INTIAL VALUE DECLARATION---------
  initial begin
	  AWID    =    {4{1'b0}};
          AWADDR  =    {AXI_AWIDTH{1'b0}};
          AWLEN   =    {4{1'b0}};
          AWSIZE  =    {3{1'b0}};
          AWBURST =    {2{1'b0}};
          AWVALID =    0;
          WID     =  {4{1'b0}};
          WDATA    =  {AXI_DWIDTH{1'b0}};
          WSTRB    =  {AXI_WRSTB{1'b0}};
          WLAST    =  0;
          WVALID   =  0; 
          BREADY   =  0;
          ARID     =  {4{1'b0}};
          ARADDR   =  {AXI_AWIDTH{1'b0}};
          ARLEN    =  {4{1'b0}};
          ARSIZE   =  {3{1'b0}};
          ARBURST  =  {2{1'b0}} ;
          ARLOCK   =  {2{1'b0}};
          ARVALID  =  0;
          RREADY   =  0;
          AWLOCK   = {2{1'b0}}; 
          j        =  0;
          k        =  0;
          counter  =  0;
          for(k=0;k<=DEPTH-1;k=k+1) begin
              check_mem[k]={AXI_DWIDTH-1{1'b0}};
          end
         j=0;
         k=0;	 
end
//--------------------------AXI_TASK WRITE------------------------
//This task take address,length,wsize,waid,waburst,swtrb as inputs
//This task runs for one complete burst
//It generate data and sends to COREAXITOAHBL(DUT)
//The generated data is store in the memory at the corresponding address

task axi_write;
  input [AXI_AWIDTH-1:0]    WADDAR;
  input [3:0]               WALEN;
  input [2:0]               WASIZE;
  input [3:0]               WAID;
  input [1:0]               WABURST;
  input [2:0]               NOB;
  input [AXI_WRSTB-1:0]     SWTRB;
  reg [AXI_AWIDTH-1:0]      writeadd;
  integer                   strval;
  integer                   start;
  integer                   starter0;
  integer                   starter1;
  reg [AXI_WRSTB-1:0]       writestb;
  integer                   i;
    begin
        @ (posedge ACLK);
        @ (posedge ACLK);
        AWVALID = 1;
        AWADDR = WADDAR;
        writeadd = WADDAR;
        AWSIZE = WASIZE;
        AWLEN = WALEN;
        AWBURST = WABURST;
        i=0;
        starter0=0;
        starter1=0;
        start=0;
        if(NOB==MNOB) begin
            AWLOCK = 2'b00;
        end
        else begin
            AWLOCK = 2'b10;
        end
        AWID = WAID;
        wait(AWREADY);
        @ (posedge ACLK);
        AWVALID = 0;
        WVALID = 1;
        //This loop runs for given length
        for(i=0;i<=AWLEN;i=i+1)  begin
           if(i==AWLEN) begin
              WLAST = 1;
           end
           WDATA[63:32] = $random;
           WDATA[31:0] = $random;
           if(i==0) begin
              WSTRB = SWTRB;
              writestb=SWTRB;
           end
           else begin
              case(AWSIZE[1:0]) 
                 // Calculation of write strobe 
                 2'b11: WSTRB = {AXI_WRSTB{1'b1}};
                 2'b10: begin
                           strval= $floor((WADDAR[2:0]/4));
                           //Starting value of strobe will be as input write strobe
                           //based on address and negate for the rest of
                           //the length
                           if(strval==0) begin
                              if(starter0==0) begin
                                  WSTRB=8'b11110000;
                                  starter0=1;
                              end
                              else begin
                                  WSTRB=~WSTRB;
                              end
                           end
                           else if(strval==1) begin
                              if(starter1==0) begin
                                 WSTRB=8'b00001111;
                                 starter1=1;
                              end
                              else begin
                                 WSTRB=~WSTRB;
                              end
                           end
                       end        
                 2'b01: begin
                          case(WSTRB)
                             8'h03:WSTRB=8'h0c;
                             8'h02:WSTRB=8'h0c;
                             8'h0c:WSTRB=8'h30;
                             8'h08:WSTRB=8'h30;
                             8'h30:WSTRB=8'hc0;
                             8'h20:WSTRB=8'hc0;
                             8'hc0:WSTRB=8'h03;
                             8'h80:WSTRB=8'h03;
                             default:WSTRB=8'h03;
                          endcase
                       end
                 2'b00: begin
                          case(WSTRB)
                             8'h01:WSTRB=8'h02;
                             8'h02:WSTRB=8'h04;
                             8'h04:WSTRB=8'h08;
                             8'h08:WSTRB=8'h10;
                             8'h10:WSTRB=8'h20;
                             8'h20:WSTRB=8'h40;
                             8'h40:WSTRB=8'h80;
                             8'h80:WSTRB=8'h01;
                          endcase
                       end
                endcase
           end
           WID = WAID;
           BREADY=1;
           // AS: modified 7/20/11
           wait(WREADY);
           @ (posedge ACLK);
           wait(WREADY);
           @ (posedge ACLK);
           case(AWBURST)
              //--------------- Calculation of internal writeaddress-----------------------
              2'b00 : writeadd = writeadd;
              2'b01 : begin // INCR 
                        //starting address is same as input address 
                        //for rest it will increment according to AWSIZE
                        if(start==1) begin
                           case(AWSIZE[1:0])
                              2'b00 : writeadd = writeadd + 4'b0001;
                              2'b01 : writeadd = writeadd + 4'b0010;
                              2'b10 : writeadd = writeadd + 4'b0100;
                              2'b11 : writeadd = writeadd + 4'b1000;
                           endcase
                           aligned_add = ($floor(writeadd/2**AWSIZE[1:0]))*(2**AWSIZE[1:0]);
                           writeadd=aligned_add;
                        end
                        start=1;
                    end
              2'b10 : begin //WRAP
                           //starting address is same as input address 
                           //for rest it will increment according to AWSIZE
                        if(start==1) begin
                           aligned_add = ($floor(WADDAR/2**AWSIZE[1:0]))*(2**AWSIZE[1:0]);
                           wrap_bound = ($floor(WADDAR/(2**AWSIZE[1:0]*AWLEN)))*(2**AWSIZE[1:0]*AWLEN);
                           if(writeadd >= wrap_bound) begin
                              writeadd = aligned_add;
                           end
                           else begin
                             case(AWSIZE[1:0])
                               2'b00 : writeadd = writeadd + 4'b0001;
                               2'b01 : writeadd = writeadd + 4'b0010;
                               2'b10 : writeadd = writeadd + 4'b0100;
                               2'b11 : writeadd = writeadd + 4'b1000;
                             endcase
                           end
                       end
                       start=1;
                    end
              2'b11 : begin
                          writeadd = writeadd;
                      end
            endcase
            //The valid data is send to memory task 
            //along with AWSIZE,corresponding address
            memory(writeadd,AWSIZE,WDATA); 
            if(WLAST == 1) begin
               WVALID = 0;
               WLAST =0;
               wait(BVALID);
               @ (posedge ACLK);
               RESP = BRESP;
            end
       end
       //----------------Calling checker write  Task---------------------
       check.check_write;
       if(check.check_write.count2==1) begin
          counter =counter+1;
       end
   end
endtask

//--------------------------AXI_TASK READ-------------------------
//This task take address,length,wsize,waid,waburst,swtrb as inputs
//This task runs for one complete burst
//It receive data send by COREAXITOAHBL(DUT)
//The received data is store in the memory at the corresponding address

task axi_read;
  input [AXI_AWIDTH-1:0] RADDR;
  input [3:0]            RALEN;
  input [2:0]            RASIZE;
  input [3:0]            RAID;
  input [1:0]            RABURST;
  input                  NOB;
  reg [AXI_AWIDTH-1:0]   readadd;
  integer                i;
  integer                start;
    begin
          @ (posedge ACLK);
          @ (posedge ACLK);
          ARVALID = 1;
          ARADDR = RADDR;
          readadd = RADDR;
          ARID = RAID;
          ARLEN = RALEN;
          ARSIZE = RASIZE;
          ARBURST = RABURST;
          start=0;
          if(NOB == MNOB) begin
             ARLOCK = 2'b00;
          end
          else begin
             ARLOCK = 2'b10;
          end
          wait(ARREADY);
          @ (posedge ACLK);
          ARVALID = 0;
          RREADY  = 1;
          i=0;
          //Runs till last transaction of the burst
          while(!RLAST) begin
             wait(RVALID);
             if(start==0)
             begin
                //Receive data from DUT
                case(ARSIZE[1:0])
                2'b11:begin
                        case(readadd[2:0])
                            3'b000:data = RDATA[63:0];
                            3'b001:data = {RDATA[63:8],data[7:0]};
                            3'b010:data = {RDATA[63:16],data[15:0]};
                            3'b011:data = {RDATA[63:24],data[23:0]};
                            3'b100:data = {RDATA[63:32],data[31:0]};
                            3'b101:data = {RDATA[63:40],data[39:0]};
                            3'b110:data = {RDATA[63:48],data[47:0]};
                            3'b111:data = {RDATA[63:56],data[55:0]};
                        endcase
                    end
               2'b10:begin
                        case(readadd[2:0])
                            3'b000:data = {data[63:32],RDATA[31:0]};
                            3'b001:data = {data[63:32],RDATA[31:8],data[7:0]};
                            3'b010:data = {data[63:32],RDATA[31:16],data[15:0]};
                            3'b011:data = {data[63:32],RDATA[31:24],data[23:0]};
                            3'b100:data = {RDATA[63:32],data[31:0]};
                            3'b101:data = {RDATA[63:40],data[39:0]};
                            3'b110:data = {RDATA[63:48],data[47:0]};
                            3'b000:data = {RDATA[63:56],data[55:0]};
                        endcase
                    end
               2'b01:begin
                        case(readadd[2:0])
                            3'b000:data = {data[63:16],RDATA[15:0]};
                            3'b001:data = {data[63:16],RDATA[15:8],data[7:0]};
                            3'b010:data = {data[63:32],RDATA[31:16],data[15:0]};
                            3'b011:data = {data[63:24],RDATA[24:16],data[15:0]};
                            3'b100:data = {data[63:48],RDATA[47:32],data[31:0]};
                            3'b101:data = {data[63:48],RDATA[48:40],data[39:0]};
                            3'b110:data = {RDATA[63:48],data[47:0]};
                            3'b111:data = {RDATA[63:56],data[55:0]};
                        endcase
                    end
              2'b00:begin
                        case(readadd[2:0])
                            3'b000:data = {data[63:8],RDATA[7:0]};
                            3'b001:data = {data[63:16],RDATA[15:8],data[7:0]};
                            3'b010:data = {data[63:24],RDATA[23:16],data[15:0]};
                            3'b011:data = {data[63:32],RDATA[31:24],data[23:0]};
                            3'b100:data = {data[63:40],RDATA[39:32],data[31:0]};
                            3'b101:data = {data[63:48],RDATA[47:40],data[39:0]};
                            3'b110:data = {data[63:56],RDATA[55:48],data[47:0]};
                            3'b111:data = {RDATA[63:56],data[55:0]};
                        endcase
                    end
              endcase
            end	
            else begin
                data = RDATA;
            end
            //received data is send to memory task along with ARSIZE and
            //read address.
            memory(readadd,ARSIZE,data); 
            case(ARBURST)
              //------------------ Calculation of internal readaddress-----------------
              2'b00 : readadd = readadd;
              2'b01 : //INCR      
              begin 
                 //starting address is same as input address 
                 //for rest it will increment according to ARSIZE
                 if(start==1) begin
                    case(ARSIZE[1:0])
                      2'b00 : readadd = readadd + 4'b0001;
                      2'b01 : readadd = readadd + 4'b0010;
                      2'b10 : readadd = readadd + 4'b0100;
                      2'b11 : begin
                                @(posedge RVALID);
                                readadd = readadd + 4'b1000;
                              end 
                    endcase
                     aligned_add = ($floor(readadd/2**ARSIZE[1:0]))*(2**ARSIZE[1:0]);
                     readadd=aligned_add;
                end
                 start=1;
              end
            2'b10 : // WRAP
             begin
                 //starting address is same as input address 
                 //for rest it will increment according to ARSIZE
                if(start==1) begin
                   aligned_add = ($floor(RADDR/2**ARSIZE[1:0]))*(2**ARSIZE[1:0]);
                   wrap_bound = ($floor(RADDR/(2**ARSIZE[1:0]*ARLEN)))*(2**ARSIZE[1:0]*ARLEN);
                   if(readadd >= wrap_bound) begin
                      readadd = aligned_add;
                   end
                   else begin
                      case(ARSIZE[1:0])
                        2'b00 : readadd = readadd + 4'b0001;
                        2'b01 : readadd = readadd + 4'b0010;
                        2'b10 : readadd = readadd + 4'b0100;
                        2'b11 : readadd = readadd + 4'b1000;
                      endcase
                   end
                end
                start=1;
            end
            2'b11 : begin
                    readadd = readadd;
                 end
           endcase
           @ (posedge ACLK);
            rid = RID;
            i=i+1;
        end
        wait(RVALID);
        data = RDATA;
        //The data of last transaction is send to memory task 
        //with corresponding address
        memory(readadd,ARSIZE,data); 
        @ (posedge ACLK);
        //----------------Calling checker read  Task---------------------
        check.check_read;
        if(check.check_read.count2==1) begin
            counter=counter+1;
        end
        rid = RID;
        RREADY = 0;
  end
endtask

//-----------------------------AXI_READ TOP TASK---------------------------
//This task  call axi_read task for each burst transaction
//If all the received data are compared sucessfully with the send data at
//ahb side, then it will genrate ALL TEST CASE PASSED;

task axi_readtop;
 input [AXI_AWIDTH-1:0] RADDR;
 input [3:0] RALEN;
 input [2:0] RASIZE;
 input [3:0] RAID;
 input [1:0] RABURST;
 input [2:0] NOB;
 integer i;
 integer y;
 begin
    i=15;
    for(i=RALEN;i>=LOWERLIMIT;i=i-1) begin
      axi_read(RADDR,RALEN,RASIZE,RAID,RABURST,NOB);
      RALEN=RALEN-1;
      if(counter==(RALEN+1)) begin
         $display("ALL TEST CASE PASSED");
         $display("counter=%h",counter);
      end
    end
 end
endtask
	
//-----------------------------AXI_WRITE TOP TASK---------------------------
//This task  call axi_write task for each burst transaction
//If all the send data are compared sucessfully with the recieved data at
//ahb side, then it will genrate ALL TEST CASE PASSED;
task axi_writetop1;
 input [AXI_AWIDTH-1:0] WADDAR;
 input [3:0] WALEN;
 input [2:0] WASIZE;
 input [3:0] WAID;
 input [1:0] WABURST;
 input [2:0] NOB;
 input [AXI_WRSTB-1:0] SWTRB1;
 reg   [AXI_WRSTB-1:0] SWTRB;
 reg   [3:0] LEN;
 reg [2:0] i;
 integer x;
 integer y;
 begin
     counter=0;
     y=0;
     i=0;
     x=15;
     for(x=WALEN;x>=LOWERLIMIT;x=x-1)
     begin
        axi_write(WADDAR,WALEN,WASIZE,WAID,WABURST,NOB,SWTRB1);
        WALEN = WALEN - 1;
        if(counter==WALEN) begin
        $display("ALL TEST CASE PASSED");
        $display("counter=%h",counter);
       end
     end
end
endtask

//---------------------------------------TASK MEMORY----------------------------
//This task is called from axi_write as well as from axi_read.
//This task will store the input data at the corresponding address based on
//size.
task memory;
input [AXI_AWIDTH-1:0] address;
input [2:0] SIZE;
input [AXI_DWIDTH-1:0] DATA;
integer add_val;
integer i;
integer strval;
integer b;
begin
    add_val=address[2:0];
    case(SIZE[1:0])
      //------ Storing data in to memory-----------------
     2'b11:begin
             i=0;
             for(i=add_val;i<8;i=i+1)
             begin
                case(i)
                    3'b000:check_mem[address[7:0]] = DATA[7:0];
                    3'b001:check_mem[address[7:0]] = DATA[15:8];
                    3'b010:check_mem[address[7:0]] = DATA[23:16];
                    3'b011:check_mem[address[7:0]] = DATA[31:24];
                    3'b100:check_mem[address[7:0]] = DATA[39:32];
                    3'b101:check_mem[address[7:0]] = DATA[47:40];
                    3'b110:check_mem[address[7:0]] = DATA[55:48];
                    3'b111:check_mem[address[7:0]] = DATA[63:56];
                endcase
                     address=address+1'b1;
             end
            end
      2'b10:begin
             i=0;
              if(add_val<3'd4) begin
                 for(i=add_val;i<4;i=i+1) begin
                   case(i)
                    3'b000:check_mem[address[7:0]] = DATA[7:0];
                    3'b001:check_mem[address[7:0]] = DATA[15:8];
                    3'b010:check_mem[address[7:0]] = DATA[23:16];
                    3'b011:check_mem[address[7:0]] = DATA[31:24];
                   endcase
                         address=address+1'b1;
                 end
             end
             else begin
               for(i=add_val;i<8;i=i+1) begin
                case(i)
                   3'b100:check_mem[address[7:0]] = DATA[39:32];
                   3'b101:check_mem[address[7:0]] = DATA[47:40];
                   3'b110:check_mem[address[7:0]] = DATA[55:48];
                   3'b111:check_mem[address[7:0]] = DATA[63:56];
                endcase
                     address=address+1'b1;
              end
            end
          end
      2'b01:begin
            i=0;
            if(add_val<3'd2) begin
                for(i=add_val;i<2;i=i+1) begin
                   case(i)
                     3'b000:check_mem[address[7:0]] = DATA[7:0];
                     3'b001:check_mem[address[7:0]] = DATA[15:8];
                  endcase
                     address=address+1'b1;
                end
            end
            else if(add_val<3'd4) begin
                for(i=add_val;i<4;i=i+1) begin
                  case(i)
                    3'b010:check_mem[address[7:0]] = DATA[23:16];
                    3'b011:check_mem[address[7:0]] = DATA[31:24];
                  endcase
                    address=address+1'b1;
                end
            end
            else if(add_val<3'd6) begin
                for(i=add_val;i<6;i=i+1) begin
                   case(i)
                     3'b100:check_mem[address[7:0]] = DATA[39:32];
                     3'b101:check_mem[address[7:0]] = DATA[47:40];
                   endcase
                    address=address+1'b1;
                end
            end
            else
            begin
                for(i=add_val;i<8;i=i+1)
                begin
                  case(i)
                    3'b110:check_mem[address[7:0]] = DATA[55:48];
                    3'b111:check_mem[address[7:0]] = DATA[63:56];
                  endcase
                    address=address+1'b1;
                end
            end
        end
    2'b00:begin
            i=add_val;
             case(i)
                3'b000:check_mem[address[7:0]] = DATA[7:0];
                3'b001:check_mem[address[7:0]] = DATA[15:8];
                3'b010:check_mem[address[7:0]] = DATA[23:16];
                3'b011:check_mem[address[7:0]] = DATA[31:24];
                3'b100:check_mem[address[7:0]] = DATA[39:32];
                3'b101:check_mem[address[7:0]] = DATA[47:40];
                3'b110:check_mem[address[7:0]] = DATA[55:48];
                3'b111:check_mem[address[7:0]] = DATA[63:56];
             endcase
          end
   endcase  
end
endtask
endmodule
		
			











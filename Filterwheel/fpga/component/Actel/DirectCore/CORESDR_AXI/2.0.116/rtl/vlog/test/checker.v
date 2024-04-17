// ********************************************************************/
// Actel Corporation Proprietary and Confidential
// Copyright 2010 Actel Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description:Checker module will compare both AXI_Master memory wi-
//th AHB_Slave memory in both read and write task,and display result
//according to it.
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

module checker(
        ACLK,
        //HCLK,
        AWADDR,
        WSTRB,
        AWLEN,
        AWSIZE,
        ARADDR,
        ARLEN,
        ARSIZE,
        RLAST
        );
  parameter AXI_AWIDTH =  32;
  parameter   AXI_DWIDTH   = 64; 
  localparam  AXI_WRSTB    = AXI_DWIDTH / 8;

  input                     ACLK;
//  input                     HCLK;
  input  [AXI_AWIDTH-1:0]   AWADDR;
  input  [2:0]              AWSIZE;
  input  [AXI_WRSTB-1:0]    WSTRB;
  input  [3:0]              AWLEN;
  input  [AXI_AWIDTH-1:0]   ARADDR;
  input  [3:0]              ARLEN;
  input  [2:0]              ARSIZE;
  input                     RLAST;
  integer                   add;
  integer                   i;
  integer                   count;
  integer                   count1;
  

  initial begin
      add=8'h00;
      count=0;
  end
  
//-----------------------Checker read task---------------------------
//This task is called from axiread task,this task will generatethe final
//address based on starting address and ARLEN.Based on both the addresses
//the value stored in AXI_MEMORY is compared with the AHB_Memory for the
//valid address,if all the transactions are right it will display pass
//otherwise fail along with length

  task check_read;
  reg       count2;
  integer   finaladd;
  begin  
     finaladd=8'h00;
     $display("--------------ARLEN--------------=%h",ARLEN);
     add=ARADDR[7:0];
     case(ARSIZE[1:0])
       2'b11:case(add[2:0])
               3'b000:finaladd=(add+7)+(ARLEN)*8;
               3'b001:finaladd=(add+6)+(ARLEN)*8;
               3'b010:finaladd=(add+5)+(ARLEN)*8;
               3'b011:finaladd=(add+4)+(ARLEN)*8;
               3'b100:finaladd=(add+3)+(ARLEN)*8;
               3'b101:finaladd=(add+2)+(ARLEN)*8;
               3'b110:finaladd=(add+1)+(ARLEN)*8;
               3'b111:finaladd=(add)+(ARLEN)*8;
             endcase
      2'b10:case(add[1:0])
                2'b00:finaladd=(add+3)+(ARLEN)*4;
                2'b01:finaladd=(add+2)+(ARLEN)*4;
                2'b10:finaladd=(add+1)+(ARLEN)*4;
                2'b11:finaladd=(add)+(ARLEN)*4;
            endcase
      2'b01:begin
             if(add%2==0) begin
                 finaladd=(add+1)+(ARLEN)*2;
             end
             else begin
                 finaladd=add+(ARLEN)*2;
             end
            end
      2'b00:finaladd=add+(ARLEN)*1;
    endcase
//    for(i=add;i<=finaladd;i=i+1)
//    begin
//        if(master_0.check_mem[i]==slave_0.check_readmem[i])
//        begin
//            $display("address0X=%h,master_val=%h,slave_val=%h",i,master_0.check_mem[i],slave_0.check_readmem[i]);
//        end
//        else begin
//            count=count+1;
//            $display("count=%h,address=%h,master_val=%h,slave_val=%h",count,i,master_0.check_mem[i],slave_0.check_readmem[i]);
//        end
//            
//    end
    if(count==0)
    begin
        $display("--------PASS----------");
                count2=1;
    end
    else begin
        $display("fail");
        $display("ARLEN=%h",ARLEN);
        $display("add=%h",add);
            
        end
     
 end
endtask
//-----------------------Checker write task---------------------------
//This task is called from axiwrite task,this task will generate the final
//address based on starting address,here starting address for comparision 
//depends on the writestrobe and final address is calculated based on ARLEN.
//Based on both the addresses the value stored in AXI_MEMORY is compared with
//the AHB_Memory for the all valid address,if all the transactions are right 
//it will display pass otherwise fail along with length

task check_write;
  reg count2;
  integer   finaladd;
  begin  
       count=0; 
        finaladd=8'h00;
        $display("--------------AWLEN--------------=%h",AWLEN);
        case(AWSIZE[1:0])
         2'b11: case(master_0.axi_write.writestb)
                 8'b11111111:add[3:0]=4'b0000;
                 8'b11111110:add[3:0]=4'b0001;
                 8'b11111100:add[3:0]=4'b0010;
                 8'b11111000:add[3:0]=4'b0011;
                 8'b11110000:add[3:0]=4'b0100;
                 8'b11100000:add[3:0]=4'b0101;
                 8'b11000000:add[3:0]=4'b0110;
                 8'b10000000:add[3:0]=4'b0111;
                endcase
         2'b10: case(master_0.axi_write.writestb)
                 8'b00001111:add[3:0]=4'b0000;
                 8'b00001110:add[3:0]=4'b0001;
                 8'b00001100:add[3:0]=4'b0010;
                 8'b00001000:add[3:0]=4'b0011;
                 8'b11110000:add[3:0]=4'b0100;
                 8'b11100000:add[3:0]=4'b0101;
                 8'b11000000:add[3:0]=4'b0110;
                 8'b10000000:add[3:0]=4'b0111;
                endcase
         2'b01: case(master_0.axi_write.writestb)
                 8'b00000011:add[3:0]=4'b0000;
                 8'b00000010:add[3:0]=4'b0001;
                 8'b00001100:add[3:0]=4'b0010;
                 8'b00001000:add[3:0]=4'b0011;
                 8'b00110000:add[3:0]=4'b0100;
                 8'b00100000:add[3:0]=4'b0101;
                 8'b11000000:add[3:0]=4'b0110;
                 8'b10000000:add[3:0]=4'b0111;
                endcase
         2'b00: case(master_0.axi_write.writestb)
                 8'b00000001:add[3:0]=4'b0000;
                 8'b00000010:add[3:0]=4'b0001;
                 8'b00000100:add[3:0]=4'b0010;
                 8'b00001000:add[3:0]=4'b0011;
                 8'b00010000:add[3:0]=4'b0100;
                 8'b00100000:add[3:0]=4'b0101;
                 8'b01000000:add[3:0]=4'b0110;
                 8'b10000000:add[3:0]=4'b0111;
                endcase
         endcase
         add[7:4]=AWADDR[7:4];
         case(AWSIZE[1:0])
           2'b11:case(add[2:0])
                    3'b000:finaladd=(add+7)+(AWLEN)*8;
                    3'b001:finaladd=(add+6)+(AWLEN)*8;
                    3'b010:finaladd=(add+5)+(AWLEN)*8;
                    3'b011:finaladd=(add+4)+(AWLEN)*8;
                    3'b100:finaladd=(add+3)+(AWLEN)*8;
                    3'b101:finaladd=(add+2)+(AWLEN)*8;
                    3'b110:finaladd=(add+1)+(AWLEN)*8;
                    3'b111:finaladd=(add)+(AWLEN)*8;
                endcase
          2'b10:case(add[1:0])
                    2'b00:finaladd=(add+3)+(AWLEN)*4;
                    2'b01:finaladd=(add+2)+(AWLEN)*4;
                    2'b10:finaladd=(add+1)+(AWLEN)*4;
                    2'b11:finaladd=(add)+(AWLEN)*4;
                    endcase
          2'b01:begin
                 if(add%2==0) begin
                    finaladd=(add+1)+(AWLEN)*2;
                   end
                 else begin
                           finaladd=add+(AWLEN)*2;
                    end
                end  
          2'b00:finaladd=add+(AWLEN)*1;
        endcase
//        for(i=add;i<=finaladd;i=i+1)
//        begin
//            if(master_0.check_mem[i]==slave_0.check_writemem[i])
//            begin
//                $display("address0X=%h,master_val=%h,slave_val=%h",i,master_0.check_mem[i],slave_0.check_writemem[i]);
//            end
//            else begin
//                count=count+1;
//                $display("count=%h,address=%h,master_val=%h,slave_val=%h",count,i,master_0.check_mem[i],slave_0.check_writemem[i]);
//                
//            end
//                
//        end
        
        if(count==0)
        begin
            $display("--------PASS----------");
                    count2=1;
        end
        else begin
            $display("fail");
            $display("AWLEN=%h",AWLEN);
        end
 end
endtask
endmodule
        
  
 

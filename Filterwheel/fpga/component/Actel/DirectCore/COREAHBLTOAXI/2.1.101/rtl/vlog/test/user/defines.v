localparam IDLE   = 2'b00;
localparam BUSY   = 2'b01;
localparam NONSEQ = 2'b10;
localparam SEQ    = 2'b11;

localparam SINGLE    = 3'b000;
localparam INCR      = 3'b001;
localparam WRAP4     = 3'b010;
localparam INCR4     = 3'b011;
localparam WRAP8     = 3'b100;
localparam INCR8     = 3'b101;
localparam WRAP16    = 3'b110;
localparam INCR16    = 3'b111;

localparam BYTE       = 2'b00;
localparam HALFWORD   = 2'b01;
localparam WORD       = 2'b10;
localparam DOUBLEWORD = 2'b11;

localparam OKAY       = 2'b00;
localparam ERROR      = 2'b01;
localparam RETRY      = 2'b10;
localparam SPLIT      = 2'b11;

localparam WRITE      = 1'b1;
localparam READ       = 1'b0;
localparam HIGH       = 1'b1;
localparam LOW        = 1'b0;

`define CORETOP       testbench.U_CoreAHBLtoAXI
`define AHBMASTER     testbench.U_AHBL_Master
`define AHBSLAVE      testbench.U_AXI_Slave
`define CHECKER       testbench.U_checker

`define burst;
`define size;

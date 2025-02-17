`timescale 1 ns/100 ps
// Version: 2023.2 2023.2.0.10


module IO_C1_IO_C1_0_IO(
       PAD_IN,
       Y
    );
input  [0:0] PAD_IN;
output [0:0] Y;

    
    INBUF #( .IOSTD("LVCMOS33") )  U0_0 (.PAD(PAD_IN[0]), .Y(Y[0]));
    
endmodule

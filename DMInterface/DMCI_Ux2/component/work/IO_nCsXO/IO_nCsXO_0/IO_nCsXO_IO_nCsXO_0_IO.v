`timescale 1 ns/100 ps
// Version: 2023.2 2023.2.0.10


module IO_nCsXO_IO_nCsXO_0_IO(
       PAD_OUT,
       D
    );
output [0:0] PAD_OUT;
input  [0:0] D;

    
    OUTBUF #( .IOSTD("LVCMOS33") )  U0_0 (.D(D[0]), .PAD(PAD_OUT[0]));
    
endmodule

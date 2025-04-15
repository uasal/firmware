`timescale 1 ns/100 ps
// Version: 2023.2 2023.2.0.10


module IO_TXBuf_IO_TXBuf_0_IO(
       PAD_TRI,
       D,
       E
    );
output [0:0] PAD_TRI;
input  [0:0] D;
input  [0:0] E;

    
    TRIBUFF #( .IOSTD("LVCMOS33") )  U0_0 (.D(D[0]), .E(E[0]), .PAD(
        PAD_TRI[0]));
    
endmodule

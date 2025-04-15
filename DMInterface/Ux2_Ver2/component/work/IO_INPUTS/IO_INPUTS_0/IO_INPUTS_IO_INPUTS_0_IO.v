`timescale 1 ns/100 ps
// Version: 2023.2 2023.2.0.10


module IO_INPUTS_IO_INPUTS_0_IO(
       PAD_OUT,
       D
    );
output [3:0] PAD_OUT;
input  [3:0] D;

    
    OUTBUF #( .IOSTD("LVCMOS33") )  U0_0 (.D(D[0]), .PAD(PAD_OUT[0]));
    OUTBUF #( .IOSTD("LVCMOS33") )  U0_3 (.D(D[3]), .PAD(PAD_OUT[3]));
    OUTBUF #( .IOSTD("LVCMOS33") )  U0_2 (.D(D[2]), .PAD(PAD_OUT[2]));
    OUTBUF #( .IOSTD("LVCMOS33") )  U0_1 (.D(D[1]), .PAD(PAD_OUT[1]));
    
endmodule

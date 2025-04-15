`timescale 1 ns/100 ps
// Version: 2023.2 2023.2.0.10


module IO_OUTPUTS_IO_OUTPUTS_0_IO(
       PAD_IN,
       Y
    );
input  [8:0] PAD_IN;
output [8:0] Y;

    
    INBUF #( .IOSTD("LVCMOS33") )  U0_4 (.PAD(PAD_IN[4]), .Y(Y[4]));
    INBUF #( .IOSTD("LVCMOS33") )  U0_0 (.PAD(PAD_IN[0]), .Y(Y[0]));
    INBUF #( .IOSTD("LVCMOS33") )  U0_8 (.PAD(PAD_IN[8]), .Y(Y[8]));
    INBUF #( .IOSTD("LVCMOS33") )  U0_3 (.PAD(PAD_IN[3]), .Y(Y[3]));
    INBUF #( .IOSTD("LVCMOS33") )  U0_6 (.PAD(PAD_IN[6]), .Y(Y[6]));
    INBUF #( .IOSTD("LVCMOS33") )  U0_5 (.PAD(PAD_IN[5]), .Y(Y[5]));
    INBUF #( .IOSTD("LVCMOS33") )  U0_2 (.PAD(PAD_IN[2]), .Y(Y[2]));
    INBUF #( .IOSTD("LVCMOS33") )  U0_1 (.PAD(PAD_IN[1]), .Y(Y[1]));
    INBUF #( .IOSTD("LVCMOS33") )  U0_7 (.PAD(PAD_IN[7]), .Y(Y[7]));
    
endmodule

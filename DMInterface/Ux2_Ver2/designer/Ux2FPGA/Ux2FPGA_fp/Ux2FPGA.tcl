open_project -project {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\designer\Ux2FPGA\Ux2FPGA_fp\Ux2FPGA.pro}\
         -connect_programmers {FALSE}
load_programming_data \
    -name {M2S025} \
    -fpga {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\designer\Ux2FPGA\Ux2FPGA.map} \
    -header {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\designer\Ux2FPGA\Ux2FPGA.hdr} \
    -envm {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\designer\Ux2FPGA\Ux2FPGA.efc} \
    -spm {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\designer\Ux2FPGA\Ux2FPGA.spm} \
    -dca {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\designer\Ux2FPGA\Ux2FPGA.dca}
export_single_ppd \
    -name {M2S025} \
    -file {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\designer\Ux2FPGA\Ux2FPGA.ppd}

save_project
close_project

open_project -project {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\designer\EvalBoardSandbox\EvalBoardSandbox_fp\EvalBoardSandbox.pro}\
         -connect_programmers {FALSE}
load_programming_data \
    -name {M2S025} \
    -fpga {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\designer\EvalBoardSandbox\EvalBoardSandbox.map} \
    -header {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\designer\EvalBoardSandbox\EvalBoardSandbox.hdr} \
    -envm {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\designer\EvalBoardSandbox\EvalBoardSandbox.efc} \
    -spm {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\designer\EvalBoardSandbox\EvalBoardSandbox.spm} \
    -dca {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\designer\EvalBoardSandbox\EvalBoardSandbox.dca}
export_single_ppd \
    -name {M2S025} \
    -file {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\designer\EvalBoardSandbox\EvalBoardSandbox.ppd}

save_project
close_project

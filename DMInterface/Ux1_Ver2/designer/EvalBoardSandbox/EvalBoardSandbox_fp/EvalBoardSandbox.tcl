open_project -project {/home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/designer/EvalBoardSandbox/EvalBoardSandbox_fp/EvalBoardSandbox.pro}\
         -connect_programmers {FALSE}
load_programming_data \
    -name {M2S025} \
    -fpga {/home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/designer/EvalBoardSandbox/EvalBoardSandbox.map} \
    -header {/home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/designer/EvalBoardSandbox/EvalBoardSandbox.hdr} \
    -envm {/home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/designer/EvalBoardSandbox/EvalBoardSandbox.efc} \
    -spm {/home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/designer/EvalBoardSandbox/EvalBoardSandbox.spm} \
    -dca {/home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/designer/EvalBoardSandbox/EvalBoardSandbox.dca}
export_single_ppd \
    -name {M2S025} \
    -file {/home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/designer/EvalBoardSandbox/EvalBoardSandbox.ppd}

save_project
close_project

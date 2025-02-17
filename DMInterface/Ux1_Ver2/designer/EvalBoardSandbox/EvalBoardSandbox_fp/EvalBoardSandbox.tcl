open_project -project {C:\MicroSemiProj\Libero\DMCIOverhaul\designer\EvalBoardSandbox\EvalBoardSandbox_fp\EvalBoardSandbox.pro}\
         -connect_programmers {FALSE}
load_programming_data \
    -name {M2S010} \
    -fpga {C:\MicroSemiProj\Libero\DMCIOverhaul\designer\EvalBoardSandbox\EvalBoardSandbox.map} \
    -header {C:\MicroSemiProj\Libero\DMCIOverhaul\designer\EvalBoardSandbox\EvalBoardSandbox.hdr} \
    -envm {C:\MicroSemiProj\Libero\DMCIOverhaul\designer\EvalBoardSandbox\EvalBoardSandbox.efc} \
    -spm {C:\MicroSemiProj\Libero\DMCIOverhaul\designer\EvalBoardSandbox\EvalBoardSandbox.spm} \
    -dca {C:\MicroSemiProj\Libero\DMCIOverhaul\designer\EvalBoardSandbox\EvalBoardSandbox.dca}
export_single_ppd \
    -name {M2S010} \
    -file {C:\MicroSemiProj\Libero\DMCIOverhaul\designer\EvalBoardSandbox\EvalBoardSandbox.ppd}

save_project
close_project

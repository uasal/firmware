new_project \
         -name {EvalBoardSandbox} \
         -location {C:\Users\SKaye\repos9\firmware\DMInterface\Ux1_Ver2\designer\EvalBoardSandbox\EvalBoardSandbox_fp} \
         -mode {chain} \
         -connect_programmers {FALSE}
add_actel_device \
         -device {M2S010} \
         -name {M2S010}
enable_device \
         -name {M2S010} \
         -enable {TRUE}
save_project
close_project

open_project -project {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\designer\EvalBoardSandbox\EvalBoardSandbox_fp\EvalBoardSandbox.pro}
enable_device -name {M2S025} -enable 1
set_programming_file -name {M2S025} -file {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\designer\EvalBoardSandbox\EvalBoardSandbox.ppd}
set_programming_action -action {PROGRAM} -name {M2S025} 
run_selected_actions
save_project
close_project

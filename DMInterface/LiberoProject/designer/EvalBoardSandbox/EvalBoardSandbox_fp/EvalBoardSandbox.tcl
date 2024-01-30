open_project -project {C:\MicroSemiProj\EvalBoardSandbox\designer\EvalBoardSandbox\EvalBoardSandbox_fp\EvalBoardSandbox.pro}
enable_device -name {M2S010} -enable 1
set_programming_file -name {M2S010} -file {C:\MicroSemiProj\EvalBoardSandbox\designer\EvalBoardSandbox\EvalBoardSandbox.ppd}
set_programming_action -action {PROGRAM} -name {M2S010} 
run_selected_actions
save_project
close_project

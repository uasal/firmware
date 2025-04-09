open_project -project {/home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/designer/EvalBoardSandbox/EvalBoardSandbox_fp/EvalBoardSandbox.pro}
enable_device -name {M2S010} -enable 1
set_programming_file -name {M2S010} -file {/home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/designer/EvalBoardSandbox/EvalBoardSandbox.ppd}
set_programming_action -action {PROGRAM} -name {M2S010} 
run_selected_actions
save_project
close_project

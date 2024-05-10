open_project -project {/home/summer/projects/CGraph/firmware/Filterwheel/Libero/designer/Filterwheel/Filterwheel_fp/Filterwheel.pro}
enable_device -name {M2S025} -enable 1
set_programming_file -name {M2S025} -file {/home/summer/projects/CGraph/firmware/Filterwheel/Libero/designer/Filterwheel/Filterwheel.ppd}
set_programming_action -action {PROGRAM} -name {M2S025} 
run_selected_actions
save_project
close_project

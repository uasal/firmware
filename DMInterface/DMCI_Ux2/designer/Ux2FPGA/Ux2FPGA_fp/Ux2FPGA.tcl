open_project -project {C:\MicroSemiProj\DMCI_Ux2\designer\Ux2FPGA\Ux2FPGA_fp\Ux2FPGA.pro}
enable_device -name {M2S025} -enable 1
set_programming_file -name {M2S025} -file {C:\MicroSemiProj\DMCI_Ux2\designer\Ux2FPGA\Ux2FPGA.ppd}
set_programming_action -action {PROGRAM} -name {M2S025} 
run_selected_actions
save_project
close_project

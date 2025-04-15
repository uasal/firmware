new_project \
         -name {Ux2FPGA} \
         -location {C:\MicroSemiProj\DMCI_Ux2\designer\Ux2FPGA\Ux2FPGA_fp} \
         -mode {chain} \
         -connect_programmers {FALSE}
add_actel_device \
         -device {M2S025} \
         -name {M2S025}
enable_device \
         -name {M2S025} \
         -enable {TRUE}
save_project
close_project

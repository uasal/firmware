set_device -family {SmartFusion2} -die {M2S025} -speed {-1}
read_adl {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\designer\Ux2FPGA\Ux2FPGA.adl}
read_afl {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\designer\Ux2FPGA\Ux2FPGA.afl}
map_netlist
read_sdc {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\constraint\Ux2FPGA_derived_constraints.sdc}
read_sdc {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\constraint\user.sdc}
check_constraints -ignore_errors {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\constraint\placer_sdc_errors.log}
write_sdc -mode layout {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\designer\Ux2FPGA\place_route.sdc}

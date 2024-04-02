set_device -family {SmartFusion2} -die {M2S025} -speed {-1}
read_adl {C:\MicroSemiProj\DMCI_Ux2\designer\Ux2FPGA\Ux2FPGA.adl}
read_afl {C:\MicroSemiProj\DMCI_Ux2\designer\Ux2FPGA\Ux2FPGA.afl}
map_netlist
read_sdc {C:\MicroSemiProj\DMCI_Ux2\constraint\Ux2FPGA_derived_constraints.sdc}
check_constraints {C:\MicroSemiProj\DMCI_Ux2\constraint\placer_sdc_errors.log}
write_sdc -mode layout {C:\MicroSemiProj\DMCI_Ux2\designer\Ux2FPGA\place_route.sdc}

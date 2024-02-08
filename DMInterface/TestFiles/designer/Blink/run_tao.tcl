set_device -family {SmartFusion2} -die {M2S025} -speed {-1}
read_vhdl -mode vhdl_2008 {/home/summer/projects/CGraph/firmware/DMInterface/TestFiles/component/work/FCCC_C0/FCCC_C0_0/FCCC_C0_FCCC_C0_0_FCCC.vhd}
read_vhdl -mode vhdl_2008 {/home/summer/projects/CGraph/firmware/DMInterface/TestFiles/component/work/FCCC_C0/FCCC_C0.vhd}
read_vhdl -mode vhdl_2008 {/home/summer/projects/CGraph/firmware/DMInterface/TestFiles/hdl/Main.vhd}
read_vhdl -mode vhdl_2008 {/home/summer/projects/CGraph/firmware/DMInterface/TestFiles/component/work/Blink/Blink.vhd}
set_top_level {Blink}
map_netlist
check_constraints {/home/summer/projects/CGraph/firmware/DMInterface/TestFiles/constraint/synthesis_sdc_errors.log}
write_fdc {/home/summer/projects/CGraph/firmware/DMInterface/TestFiles/designer/Blink/synthesis.fdc}

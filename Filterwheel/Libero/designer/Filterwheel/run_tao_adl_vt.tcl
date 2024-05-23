set_device -family {SmartFusion2} -die {M2S025} -speed {-1}
read_adl {/home/summer/projects/CGraph/firmware/Filterwheel/Libero/designer/Filterwheel/Filterwheel.adl}
read_afl {/home/summer/projects/CGraph/firmware/Filterwheel/Libero/designer/Filterwheel/Filterwheel.afl}
map_netlist
check_constraints {/home/summer/projects/CGraph/firmware/Filterwheel/Libero/constraint/timing_sdc_errors.log}
write_sdc -mode smarttime {/home/summer/projects/CGraph/firmware/Filterwheel/Libero/designer/Filterwheel/timing_analysis.sdc}

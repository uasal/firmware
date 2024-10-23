set_device -family {SmartFusion2} -die {M2S010} -speed {STD}
read_adl {/home/summer/projects/CGraph/firmware/FineSteeringMirrorTq144/Libero/designer/FineSteeringMirror/FineSteeringMirror.adl}
read_afl {/home/summer/projects/CGraph/firmware/FineSteeringMirrorTq144/Libero/designer/FineSteeringMirror/FineSteeringMirror.afl}
map_netlist
check_constraints {/home/summer/projects/CGraph/firmware/FineSteeringMirrorTq144/Libero/constraint/timing_sdc_errors.log}
write_sdc -mode smarttime {/home/summer/projects/CGraph/firmware/FineSteeringMirrorTq144/Libero/designer/FineSteeringMirror/timing_analysis.sdc}

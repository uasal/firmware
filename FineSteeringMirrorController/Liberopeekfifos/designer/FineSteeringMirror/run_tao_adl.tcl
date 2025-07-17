set_device -family {SmartFusion2} -die {M2S010} -speed {STD}
read_adl {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/designer/FineSteeringMirror/FineSteeringMirror.adl}
read_afl {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/designer/FineSteeringMirror/FineSteeringMirror.afl}
map_netlist
read_sdc {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/constraint/user.sdc}
check_constraints {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/constraint/placer_sdc_errors.log}
write_sdc -mode layout {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/designer/FineSteeringMirror/place_route.sdc}

set_device \
    -fam SmartFusion2 \
    -die PA4M1000_N \
    -pkg tq144
set_input_cfg \
	-path {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Liberopeekfifos/component/work/FineSteeringMirror_sb_MSS/ENVM.cfg}
set_output_efc \
    -path {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Liberopeekfifos/designer/FineSteeringMirror/FineSteeringMirror.efc}
set_proj_dir \
    -path {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Liberopeekfifos}
set_is_relative_path \
    -value {TRUE}
set_root_path_dir \
    -path {CGRAPH_FIRMWARE}
gen_prg -use_init false

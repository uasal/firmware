set_device \
    -fam SmartFusion2 \
    -die PA4M1000_N \
    -pkg tq144
set_input_cfg \
	-path {/home/summer/projects/CGraph/firmware/FilterwheelTq144/Libero/component/work/Filterwheel_sb_MSS/ENVM.cfg}
set_output_efc \
    -path {/home/summer/projects/CGraph/firmware/FilterwheelTq144/Libero/designer/Filterwheel/Filterwheel.efc}
set_proj_dir \
    -path {/home/summer/projects/CGraph/firmware/FilterwheelTq144/Libero}
set_is_relative_path \
    -value {FALSE}
set_root_path_dir \
    -path {}
gen_prg -use_init false

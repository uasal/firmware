set_device \
    -fam SmartFusion2 \
    -die PA4M1000_N \
    -pkg vf256
set_input_cfg \
	-path {/home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/component/work/EvalSandbox_MSS_MSS/ENVM.cfg}
set_output_efc \
    -path {/home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/designer/EvalBoardSandbox/EvalBoardSandbox.efc}
set_proj_dir \
    -path {/home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2}
set_is_relative_path \
    -value {TRUE}
set_root_path_dir \
    -path {CGRAPH_FIRMWARE}
gen_prg -use_init false

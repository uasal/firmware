set_device \
    -fam SmartFusion2 \
    -die PA4M1000_N \
    -pkg vf256
set_input_cfg \
	-path {C:/MicroSemiProj/EvalBoardSandbox/component/work/EvalSandbox_MSS_MSS/ENVM.cfg}
set_output_efc \
    -path {C:\MicroSemiProj\EvalBoardSandbox\designer\EvalBoardSandbox\EvalBoardSandbox.efc}
set_proj_dir \
    -path {C:\MicroSemiProj\EvalBoardSandbox}
set_is_relative_path \
    -value {FALSE}
set_root_path_dir \
    -path {}
gen_prg -use_init false

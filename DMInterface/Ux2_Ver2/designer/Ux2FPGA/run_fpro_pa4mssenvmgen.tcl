set_device \
    -fam SmartFusion2 \
    -die PA4M2500_N \
    -pkg vf256
set_input_cfg \
	-path {C:/Users/SKaye/repos7/firmware/DMInterface/Ux2_Ver2/component/work/Ux2FPGA_sb_MSS/ENVM.cfg}
set_output_efc \
    -path {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\designer\Ux2FPGA\Ux2FPGA.efc}
set_proj_dir \
    -path {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2}
set_is_relative_path \
    -value {FALSE}
set_root_path_dir \
    -path {}
gen_prg -use_init false

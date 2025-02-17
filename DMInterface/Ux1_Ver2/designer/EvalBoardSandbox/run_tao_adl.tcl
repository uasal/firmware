set_device -family {SmartFusion2} -die {M2S010} -speed {STD}
read_adl {C:\MicroSemiProj\Libero\Ux1_Ver2\designer\EvalBoardSandbox\EvalBoardSandbox.adl}
read_afl {C:\MicroSemiProj\Libero\Ux1_Ver2\designer\EvalBoardSandbox\EvalBoardSandbox.afl}
map_netlist
read_sdc {C:\MicroSemiProj\Libero\Ux1_Ver2\constraint\EvalBoardSandbox_derived_constraints.sdc}
check_constraints {C:\MicroSemiProj\Libero\Ux1_Ver2\constraint\placer_sdc_errors.log}
write_sdc -mode layout {C:\MicroSemiProj\Libero\Ux1_Ver2\designer\EvalBoardSandbox\place_route.sdc}

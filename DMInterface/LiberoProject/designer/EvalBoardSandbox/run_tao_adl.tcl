set_device -family {SmartFusion2} -die {M2S010} -speed {STD}
read_adl {C:\MicroSemiProj\EvalBoardSandbox\designer\EvalBoardSandbox\EvalBoardSandbox.adl}
read_afl {C:\MicroSemiProj\EvalBoardSandbox\designer\EvalBoardSandbox\EvalBoardSandbox.afl}
map_netlist
read_sdc {C:\MicroSemiProj\EvalBoardSandbox\constraint\EvalBoardSandbox_derived_constraints.sdc}
check_constraints {C:\MicroSemiProj\EvalBoardSandbox\constraint\placer_sdc_errors.log}
write_sdc -mode layout {C:\MicroSemiProj\EvalBoardSandbox\designer\EvalBoardSandbox\place_route.sdc}

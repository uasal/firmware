set_device -family {SmartFusion2} -die {M2S010} -speed {STD}
read_adl {C:\Users\SKaye\repos10\firmware\DMInterface\Ux1_Ver2\designer\EvalBoardSandbox\EvalBoardSandbox.adl}
read_afl {C:\Users\SKaye\repos10\firmware\DMInterface\Ux1_Ver2\designer\EvalBoardSandbox\EvalBoardSandbox.afl}
map_netlist
read_sdc {C:\Users\SKaye\repos10\firmware\DMInterface\Ux1_Ver2\constraint\EvalBoardSandbox_derived_constraints.sdc}
read_sdc {C:\Users\SKaye\repos10\firmware\DMInterface\Ux1_Ver2\constraint\user.sdc}
check_constraints -ignore_errors {C:\Users\SKaye\repos10\firmware\DMInterface\Ux1_Ver2\constraint\placer_sdc_errors.log}
write_sdc -mode layout {C:\Users\SKaye\repos10\firmware\DMInterface\Ux1_Ver2\designer\EvalBoardSandbox\place_route.sdc}

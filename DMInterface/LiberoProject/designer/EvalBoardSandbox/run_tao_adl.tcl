set_device -family {SmartFusion2} -die {M2S025} -speed {-1}
read_adl {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\designer\EvalBoardSandbox\EvalBoardSandbox.adl}
read_afl {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\designer\EvalBoardSandbox\EvalBoardSandbox.afl}
map_netlist
read_sdc {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\constraint\EvalBoardSandbox_derived_constraints.sdc}
check_constraints {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\constraint\placer_sdc_errors.log}
write_sdc -mode layout {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\designer\EvalBoardSandbox\place_route.sdc}

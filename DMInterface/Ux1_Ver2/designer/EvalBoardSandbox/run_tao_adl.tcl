set_device -family {SmartFusion2} -die {M2S025} -speed {STD}
read_adl {/home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/designer/EvalBoardSandbox/EvalBoardSandbox.adl}
read_afl {/home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/designer/EvalBoardSandbox/EvalBoardSandbox.afl}
map_netlist
read_sdc {/home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/constraint/EvalBoardSandbox_derived_constraints.sdc}
read_sdc {/home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/constraint/user.sdc}
check_constraints -ignore_errors {/home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/constraint/placer_sdc_errors.log}
write_sdc -mode layout {/home/summer/projects/CGraph/firmware/DMInterface/Ux1_Ver2/designer/EvalBoardSandbox/place_route.sdc}

set_device \
    -family  SmartFusion2 \
    -die     PA4M2500_N \
    -package vf256 \
    -speed   STD \
    -tempr   {IND} \
    -voltr   {IND}
set_def {VOLTAGE} {1.2}
set_def {VCCI_1.2_VOLTR} {COM}
set_def {VCCI_1.5_VOLTR} {COM}
set_def {VCCI_1.8_VOLTR} {COM}
set_def {VCCI_2.5_VOLTR} {COM}
set_def {VCCI_3.3_VOLTR} {COM}
set_def {PLL_SUPPLY} {PLL_SUPPLY_25}
set_def USE_CONSTRAINTS_FLOW 1
set_netlist -afl {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\designer\EvalBoardSandbox\EvalBoardSandbox.afl} -adl {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\designer\EvalBoardSandbox\EvalBoardSandbox.adl}
set_constraints   {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\designer\EvalBoardSandbox\EvalBoardSandbox.tcml}
set_placement   {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\designer\EvalBoardSandbox\EvalBoardSandbox.loc}
set_routing     {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\designer\EvalBoardSandbox\EvalBoardSandbox.seg}
set_sdcfilelist -sdc {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\constraint\EvalBoardSandbox_derived_constraints.sdc, C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\constraint\user.sdc}

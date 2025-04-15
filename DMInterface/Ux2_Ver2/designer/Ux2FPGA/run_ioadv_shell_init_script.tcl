set_device \
    -family  SmartFusion2 \
    -die     PA4M2500_N \
    -package vf256 \
    -speed   -1 \
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
set_netlist -afl {C:\MicroSemiProj\DMCI_Ux2\designer\Ux2FPGA\Ux2FPGA.afl} -adl {C:\MicroSemiProj\DMCI_Ux2\designer\Ux2FPGA\Ux2FPGA.adl}
set_constraints   {C:\MicroSemiProj\DMCI_Ux2\designer\Ux2FPGA\Ux2FPGA.tcml}
set_placement   {C:\MicroSemiProj\DMCI_Ux2\designer\Ux2FPGA\Ux2FPGA.loc}
set_routing     {C:\MicroSemiProj\DMCI_Ux2\designer\Ux2FPGA\Ux2FPGA.seg}
set_sdcfilelist -sdc {C:\MicroSemiProj\DMCI_Ux2\constraint\Ux2FPGA_derived_constraints.sdc}

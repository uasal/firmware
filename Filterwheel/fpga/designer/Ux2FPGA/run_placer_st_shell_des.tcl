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
set_def {RTG4_MITIGATION_ON} {0}
set_def USE_CONSTRAINTS_FLOW 1
set_def NETLIST_TYPE EDIF
set_name Ux2FPGA
set_workdir {C:\MicroSemiProj\DMCI_Ux2\designer\Ux2FPGA}
set_log     {C:\MicroSemiProj\DMCI_Ux2\designer\Ux2FPGA\Ux2FPGA_sdc.log}
set_design_state pre_layout

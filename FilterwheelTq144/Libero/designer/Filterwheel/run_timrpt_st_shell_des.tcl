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
set_def USE_CONSTRAINTS_FLOW 1
set_name Filterwheel
set_workdir {/home/summer/projects/CGraph/firmware/Filterwheel/Libero/designer/Filterwheel}
set_design_state post_layout

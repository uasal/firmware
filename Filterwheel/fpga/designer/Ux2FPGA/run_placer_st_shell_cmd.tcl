read_sdc -scenario "place_and_route" -netlist "optimized" -pin_separator "/" -ignore_errors {C:/MicroSemiProj/DMCI_Ux2/designer/Ux2FPGA/place_route.sdc}
set_options -tdpr_scenario "place_and_route" 
save
set_options -analysis_scenario "place_and_route"
report -type combinational_loops -format xml {C:\MicroSemiProj\DMCI_Ux2\designer\Ux2FPGA\Ux2FPGA_layout_combinational_loops.xml}
report -type slack {C:\MicroSemiProj\DMCI_Ux2\designer\Ux2FPGA\pinslacks.txt}
set coverage [report \
    -type     constraints_coverage \
    -format   xml \
    -slacks   no \
    {C:\MicroSemiProj\DMCI_Ux2\designer\Ux2FPGA\Ux2FPGA_place_and_route_constraint_coverage.xml}]
set reportfile {C:\MicroSemiProj\DMCI_Ux2\designer\Ux2FPGA\coverage_placeandroute}
set fp [open $reportfile w]
puts $fp $coverage
close $fp
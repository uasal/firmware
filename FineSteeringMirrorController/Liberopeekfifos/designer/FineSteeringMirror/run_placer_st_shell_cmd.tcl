read_sdc -scenario "place_and_route" -netlist "optimized" -pin_separator "/" -ignore_errors {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Liberopeekfifos/designer/FineSteeringMirror/place_route.sdc}
set_options -tdpr_scenario "place_and_route" 
save
set_options -analysis_scenario "place_and_route"
report -type combinational_loops -format xml {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Liberopeekfifos/designer/FineSteeringMirror/FineSteeringMirror_layout_combinational_loops.xml}
report -type slack {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Liberopeekfifos/designer/FineSteeringMirror/pinslacks.txt}
set coverage [report \
    -type     constraints_coverage \
    -format   xml \
    -slacks   no \
    {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Liberopeekfifos/designer/FineSteeringMirror/FineSteeringMirror_place_and_route_constraint_coverage.xml}]
set reportfile {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Liberopeekfifos/designer/FineSteeringMirror/coverage_placeandroute}
set fp [open $reportfile w]
puts $fp $coverage
close $fp
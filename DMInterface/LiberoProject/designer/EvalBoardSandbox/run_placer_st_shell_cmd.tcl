read_sdc -scenario "place_and_route" -netlist "optimized" -pin_separator "/" -ignore_errors {C:/MicroSemiProj/EvalBoardSandbox/designer/EvalBoardSandbox/place_route.sdc}
set_options -tdpr_scenario "place_and_route" 
save
set_options -analysis_scenario "place_and_route"
report -type combinational_loops -format xml {C:\MicroSemiProj\EvalBoardSandbox\designer\EvalBoardSandbox\EvalBoardSandbox_layout_combinational_loops.xml}
report -type slack {C:\MicroSemiProj\EvalBoardSandbox\designer\EvalBoardSandbox\pinslacks.txt}
set coverage [report \
    -type     constraints_coverage \
    -format   xml \
    -slacks   no \
    {C:\MicroSemiProj\EvalBoardSandbox\designer\EvalBoardSandbox\EvalBoardSandbox_place_and_route_constraint_coverage.xml}]
set reportfile {C:\MicroSemiProj\EvalBoardSandbox\designer\EvalBoardSandbox\coverage_placeandroute}
set fp [open $reportfile w]
puts $fp $coverage
close $fp
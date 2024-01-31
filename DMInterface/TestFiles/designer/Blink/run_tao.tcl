set_device -family {SmartFusion2} -die {M2S025} -speed {-1}
read_vhdl -mode vhdl_2008 {C:\MicroSemiProj\LEDTest\hdl\Main.vhd}
read_vhdl -mode vhdl_2008 {C:\MicroSemiProj\LEDTest\component\work\Blink\Blink.vhd}
set_top_level {Blink}
map_netlist
check_constraints {C:\MicroSemiProj\LEDTest\constraint\synthesis_sdc_errors.log}
write_fdc {C:\MicroSemiProj\LEDTest\designer\Blink\synthesis.fdc}

set_device -family {SmartFusion2} -die {M2S025} -speed {-1}
set_editor_type {SYNTHESIS}
set_proj_path {C:\MicroSemiProj\DMCI_Ux2\DMCI_Ux2.prjx}
read_verilog -mode system_verilog {C:\MicroSemiProj\DMCI_Ux2\component\work\CoreUARTapb_C0\CoreUARTapb_C0_0\rtl\vlog\core_obfuscated\Clock_gen.v}
read_verilog -mode system_verilog {C:\MicroSemiProj\DMCI_Ux2\component\work\CoreUARTapb_C0\CoreUARTapb_C0_0\rtl\vlog\core_obfuscated\Rx_async.v}
read_verilog -mode system_verilog {C:\MicroSemiProj\DMCI_Ux2\component\work\CoreUARTapb_C0\CoreUARTapb_C0_0\rtl\vlog\core_obfuscated\Tx_async.v}
read_verilog -mode system_verilog {C:\MicroSemiProj\DMCI_Ux2\component\work\CoreUARTapb_C0\CoreUARTapb_C0_0\rtl\vlog\core_obfuscated\fifo_256x8_g4.v}
read_verilog -mode system_verilog {C:\MicroSemiProj\DMCI_Ux2\component\work\CoreUARTapb_C0\CoreUARTapb_C0_0\rtl\vlog\core_obfuscated\CoreUART.v}
read_verilog -mode system_verilog {C:\MicroSemiProj\DMCI_Ux2\component\work\CoreUARTapb_C0\CoreUARTapb_C0_0\rtl\vlog\core_obfuscated\CoreUARTapb.v}
read_verilog -mode system_verilog {C:\MicroSemiProj\DMCI_Ux2\component\work\CoreUARTapb_C0\CoreUARTapb_C0.v}
read_verilog -mode system_verilog {C:\MicroSemiProj\DMCI_Ux2\component\work\IO_INPUTS\IO_INPUTS_0\IO_INPUTS_IO_INPUTS_0_IO.v}
read_verilog -mode system_verilog {C:\MicroSemiProj\DMCI_Ux2\component\work\IO_INPUTS\IO_INPUTS.v}
read_verilog -mode system_verilog {C:\MicroSemiProj\DMCI_Ux2\component\work\IO_OUTPUTS\IO_OUTPUTS_0\IO_OUTPUTS_IO_OUTPUTS_0_IO.v}
read_verilog -mode system_verilog {C:\MicroSemiProj\DMCI_Ux2\component\work\IO_OUTPUTS\IO_OUTPUTS.v}
read_vhdl -mode vhdl_2008 {C:\MicroSemiProj\DMCI_Ux2\hdl\SpiMasterAPB3.vhd}
read_verilog -mode system_verilog {C:\MicroSemiProj\DMCI_Ux2\component\work\Ux2FPGA_sb\CCC_0\Ux2FPGA_sb_CCC_0_FCCC.v}
read_verilog -mode system_verilog {C:\MicroSemiProj\DMCI_Ux2\component\work\Ux2FPGA_sb\FABOSC_0\Ux2FPGA_sb_FABOSC_0_OSC.v}
read_verilog -mode system_verilog {C:\MicroSemiProj\DMCI_Ux2\component\work\Ux2FPGA_sb_MSS\Ux2FPGA_sb_MSS.v}
read_verilog -mode system_verilog {C:\MicroSemiProj\DMCI_Ux2\component\Actel\DirectCore\CoreResetP\7.1.100\rtl\vlog\core\coreresetp_pcie_hotreset.v}
read_verilog -mode system_verilog {C:\MicroSemiProj\DMCI_Ux2\component\Actel\DirectCore\CoreResetP\7.1.100\rtl\vlog\core\coreresetp.v}
read_verilog -mode system_verilog -lib COREAPB3_LIB {C:\MicroSemiProj\DMCI_Ux2\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vlog\core\coreapb3_muxptob3.v}
read_verilog -mode system_verilog -lib COREAPB3_LIB {C:\MicroSemiProj\DMCI_Ux2\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vlog\core\coreapb3_iaddr_reg.v}
read_verilog -mode system_verilog -lib COREAPB3_LIB {C:\MicroSemiProj\DMCI_Ux2\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vlog\core\coreapb3.v}
read_verilog -mode system_verilog {C:\MicroSemiProj\DMCI_Ux2\component\work\Ux2FPGA_sb\Ux2FPGA_sb.v}
read_verilog -mode system_verilog {C:\MicroSemiProj\DMCI_Ux2\component\work\Ux2FPGA\Ux2FPGA.v}
set_top_level {Ux2FPGA}
map_netlist
read_sdc {C:\MicroSemiProj\DMCI_Ux2\constraint\Ux2FPGA_derived_constraints.sdc}
set_output_sdc {C:\MicroSemiProj\DMCI_Ux2\constraint\user.sdc}

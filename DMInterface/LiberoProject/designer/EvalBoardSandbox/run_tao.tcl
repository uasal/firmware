set_device -family {SmartFusion2} -die {M2S025} -speed {-1}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\work\CoreUARTapb_C0\CoreUARTapb_C0_0\rtl\vlog\core_obfuscated\Clock_gen.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\work\CoreUARTapb_C0\CoreUARTapb_C0_0\rtl\vlog\core_obfuscated\Rx_async.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\work\CoreUARTapb_C0\CoreUARTapb_C0_0\rtl\vlog\core_obfuscated\Tx_async.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\work\CoreUARTapb_C0\CoreUARTapb_C0_0\rtl\vlog\core_obfuscated\fifo_256x8_g4.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\work\CoreUARTapb_C0\CoreUARTapb_C0_0\rtl\vlog\core_obfuscated\CoreUART.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\work\CoreUARTapb_C0\CoreUARTapb_C0_0\rtl\vlog\core_obfuscated\CoreUARTapb.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\work\CoreUARTapb_C0\CoreUARTapb_C0.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\work\EvalSandbox_MSS\CCC_0\EvalSandbox_MSS_CCC_0_FCCC.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\work\EvalSandbox_MSS\FABOSC_0\EvalSandbox_MSS_FABOSC_0_OSC.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\work\EvalSandbox_MSS_MSS\EvalSandbox_MSS_MSS.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\Actel\DirectCore\CoreResetP\7.1.100\rtl\vlog\core\coreresetp_pcie_hotreset.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\Actel\DirectCore\CoreResetP\7.1.100\rtl\vlog\core\coreresetp.v}
read_verilog -mode system_verilog -lib COREAPB3_LIB {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vlog\core\coreapb3_muxptob3.v}
read_verilog -mode system_verilog -lib COREAPB3_LIB {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vlog\core\coreapb3_iaddr_reg.v}
read_verilog -mode system_verilog -lib COREAPB3_LIB {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vlog\core\coreapb3.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\work\EvalSandbox_MSS\EvalSandbox_MSS.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\work\IO_C0\IO_C0_0\IO_C0_IO_C0_0_IO.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\work\IO_C0\IO_C0.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\work\IO_C1\IO_C1_0\IO_C1_IO_C1_0_IO.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\work\IO_C1\IO_C1.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\work\IO_UartTx\IO_UartTx_0\IO_UartTx_IO_UartTx_0_IO.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\work\IO_UartTx\IO_UartTx.v}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\hdl\SpiMasterAPB3.vhd}
read_verilog -mode system_verilog {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\component\work\EvalBoardSandbox\EvalBoardSandbox.v}
set_top_level {EvalBoardSandbox}
map_netlist
read_sdc {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\constraint\EvalBoardSandbox_derived_constraints.sdc}
check_constraints {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\SKaye\repos\firmware\DMInterface\LiberoProject\designer\EvalBoardSandbox\synthesis.fdc}

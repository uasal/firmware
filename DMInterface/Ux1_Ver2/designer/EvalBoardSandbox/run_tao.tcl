set_device -family {SmartFusion2} -die {M2S010} -speed {STD}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\CGraphDmTypes.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\CGraphDmDacRamFlat.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\IBufP1.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\IBufP2.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\IBufP3.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\UartRxRaw.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\UartRxExtClk.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\fifo_gen.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\gated_fifo.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\UartRxFifoExtClk.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\UartTx.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\UartTxFifoExtClk.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\VariableClockDivider2X.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\ClockDivider2X.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\OneShot.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\hdl\RegisterSpace.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\SpiMaster.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\SpiDac.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\hdl\DMMain.vhd}
read_verilog -mode system_verilog {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\component\work\EvalSandbox_MSS\CCC_0\EvalSandbox_MSS_CCC_0_FCCC.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\component\work\EvalSandbox_MSS\FABOSC_0\EvalSandbox_MSS_FABOSC_0_OSC.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\component\work\EvalSandbox_MSS_MSS\EvalSandbox_MSS_MSS.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\component\Actel\DirectCore\CoreResetP\7.1.100\rtl\vlog\core\coreresetp_pcie_hotreset.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\component\Actel\DirectCore\CoreResetP\7.1.100\rtl\vlog\core\coreresetp.v}
read_verilog -mode system_verilog -lib COREAPB3_LIB {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vlog\core\coreapb3_muxptob3.v}
read_verilog -mode system_verilog -lib COREAPB3_LIB {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vlog\core\coreapb3_iaddr_reg.v}
read_verilog -mode system_verilog -lib COREAPB3_LIB {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vlog\core\coreapb3.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\component\work\EvalSandbox_MSS\EvalSandbox_MSS.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\component\work\FCCC_C0\FCCC_C0_0\FCCC_C0_FCCC_C0_0_FCCC.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\component\work\FCCC_C0\FCCC_C0.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\component\work\EvalBoardSandbox\EvalBoardSandbox.v}
set_top_level {EvalBoardSandbox}
map_netlist
read_sdc {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\constraint\EvalBoardSandbox_derived_constraints.sdc}
read_sdc {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\constraint\user.sdc}
check_constraints -ignore_errors {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\SKaye\repos7\firmware\DMInterface\Ux1_Ver2\designer\EvalBoardSandbox\synthesis.fdc}

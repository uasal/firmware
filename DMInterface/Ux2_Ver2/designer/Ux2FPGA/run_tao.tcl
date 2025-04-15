set_device -family {SmartFusion2} -die {M2S025} -speed {-1}
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
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\VariableClockDivider.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\ClockDivider.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\OneShot.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\CGraphDmTypes.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\hdl\RegisterSpace2.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\SpiMaster.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\include\fpga\SpiDac.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\hdl\DMMain2.vhd}
read_verilog -mode system_verilog {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\component\work\FCCC_C0\FCCC_C0_0\FCCC_C0_FCCC_C0_0_FCCC.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\component\work\FCCC_C0\FCCC_C0.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\component\work\Ux2FPGA_sb\CCC_0\Ux2FPGA_sb_CCC_0_FCCC.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\component\work\Ux2FPGA_sb\FABOSC_0\Ux2FPGA_sb_FABOSC_0_OSC.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\component\work\Ux2FPGA_sb_MSS\Ux2FPGA_sb_MSS.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\component\Actel\DirectCore\CoreResetP\7.1.100\rtl\vlog\core\coreresetp_pcie_hotreset.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\component\Actel\DirectCore\CoreResetP\7.1.100\rtl\vlog\core\coreresetp.v}
read_verilog -mode system_verilog -lib COREAPB3_LIB {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vlog\core\coreapb3_muxptob3.v}
read_verilog -mode system_verilog -lib COREAPB3_LIB {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vlog\core\coreapb3_iaddr_reg.v}
read_verilog -mode system_verilog -lib COREAPB3_LIB {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vlog\core\coreapb3.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\component\work\Ux2FPGA_sb\Ux2FPGA_sb.v}
read_verilog -mode system_verilog {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\component\work\Ux2FPGA\Ux2FPGA.v}
set_top_level {Ux2FPGA}
map_netlist
read_sdc {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\constraint\Ux2FPGA_derived_constraints.sdc}
read_sdc {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\constraint\user.sdc}
check_constraints -ignore_errors {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\SKaye\repos7\firmware\DMInterface\Ux2_Ver2\designer\Ux2FPGA\synthesis.fdc}

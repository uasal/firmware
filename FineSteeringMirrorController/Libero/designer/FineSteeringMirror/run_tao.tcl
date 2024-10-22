set_device -family {SmartFusion2} -die {M2S010} -speed {STD}
read_verilog -mode system_verilog {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/component/work/FCCC_C0/FCCC_C0_0/FCCC_C0_FCCC_C0_0_FCCC.v}
read_verilog -mode system_verilog {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/component/work/FCCC_C0/FCCC_C0.v}
read_verilog -mode system_verilog {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/component/work/Filterwheel_sb/CCC_0/Filterwheel_sb_CCC_0_FCCC.v}
read_verilog -mode system_verilog {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/component/work/Filterwheel_sb/FABOSC_0/Filterwheel_sb_FABOSC_0_OSC.v}
read_verilog -mode system_verilog {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/component/work/Filterwheel_sb_MSS/Filterwheel_sb_MSS.v}
read_verilog -mode system_verilog {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/component/Actel/DirectCore/CoreResetP/7.1.100/rtl/vlog/core/coreresetp_pcie_hotreset.v}
read_verilog -mode system_verilog {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/component/Actel/DirectCore/CoreResetP/7.1.100/rtl/vlog/core/coreresetp.v}
read_verilog -mode system_verilog -lib COREAPB3_LIB {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vlog/core/coreapb3_muxptob3.v}
read_verilog -mode system_verilog -lib COREAPB3_LIB {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vlog/core/coreapb3_iaddr_reg.v}
read_verilog -mode system_verilog -lib COREAPB3_LIB {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vlog/core/coreapb3.v}
read_verilog -mode system_verilog {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/component/work/Filterwheel_sb/Filterwheel_sb.v}
read_vhdl -mode vhdl_2008 {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/fpga/Main.vhd}
read_verilog -mode system_verilog {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/component/work/FineSteeringMirror/FineSteeringMirror.v}
set_top_level {FineSteeringMirror}
map_netlist
check_constraints {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/constraint/synthesis_sdc_errors.log}
write_fdc {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Libero/designer/FineSteeringMirror/synthesis.fdc}

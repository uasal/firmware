quietly set ACTELLIBNAME SmartFusion2
quietly set PROJECT_DIR "C:/MicroSemiProj/EvalBoardSandbox"
source "${PROJECT_DIR}/simulation/bfmtovec_compile.tcl";
source "${PROJECT_DIR}/simulation/CM3_compile_bfm.tcl";


if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   file delete -force presynth 
   vlib presynth
}
vmap presynth presynth
vmap SmartFusion2 "C:/Microchip/Libero_SoC_v2023.2/Designer/lib/modelsimpro/precompiled/vlog/smartfusion2"
vmap COREPWM_LIB "../component/Actel/DirectCore/corepwm/4.1.106/mti/lib_vlog_obs/COREPWM_LIB"
vcom -work COREPWM_LIB -force_refresh
vlog -work COREPWM_LIB -force_refresh
if {[file exists COREAPB3_LIB/_info]} {
   echo "INFO: Simulation library COREAPB3_LIB already exists"
} else {
   file delete -force COREAPB3_LIB 
   vlib COREAPB3_LIB
}
vmap COREAPB3_LIB "COREAPB3_LIB"
if {[file exists ../component/Actel/DirectCore/CoreAHBLite/5.2.100/mti/user_vlog/COREAHBLITE_LIB/_info]} {
   echo "INFO: Simulation library ../component/Actel/DirectCore/CoreAHBLite/5.2.100/mti/user_vlog/COREAHBLITE_LIB already exists"
} else {
   file delete -force ../component/Actel/DirectCore/CoreAHBLite/5.2.100/mti/user_vlog/COREAHBLITE_LIB 
   vlib ../component/Actel/DirectCore/CoreAHBLite/5.2.100/mti/user_vlog/COREAHBLITE_LIB
}
vmap COREAHBLITE_LIB "../component/Actel/DirectCore/CoreAHBLite/5.2.100/mti/user_vlog/COREAHBLITE_LIB"
if {[file exists COREAHBTOAPB3_LIB/_info]} {
   echo "INFO: Simulation library COREAHBTOAPB3_LIB already exists"
} else {
   file delete -force COREAHBTOAPB3_LIB 
   vlib COREAHBTOAPB3_LIB
}
vmap COREAHBTOAPB3_LIB "COREAHBTOAPB3_LIB"
if {[file exists CORESPI_LIB/_info]} {
   echo "INFO: Simulation library CORESPI_LIB already exists"
} else {
   file delete -force CORESPI_LIB 
   vlib CORESPI_LIB
}
vmap CORESPI_LIB "CORESPI_LIB"
if {[file exists COREAHBLSRAM_LIB/_info]} {
   echo "INFO: Simulation library COREAHBLSRAM_LIB already exists"
} else {
   file delete -force COREAHBLSRAM_LIB 
   vlib COREAHBLSRAM_LIB
}
vmap COREAHBLSRAM_LIB "COREAHBLSRAM_LIB"

vlog -sv -work CORESPI_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CORESPI/5.2.104/rtl/vlog/core/spi_clockmux.v"
vlog -sv -work CORESPI_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CORESPI/5.2.104/rtl/vlog/core/spi_chanctrl.v"
vlog -sv -work CORESPI_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CORESPI/5.2.104/rtl/vlog/core/spi_fifo.v"
vlog -sv -work CORESPI_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CORESPI/5.2.104/rtl/vlog/core/spi_rf.v"
vlog -sv -work CORESPI_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CORESPI/5.2.104/rtl/vlog/core/spi_control.v"
vlog -sv -work CORESPI_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CORESPI/5.2.104/rtl/vlog/core/spi.v"
vlog -sv -work CORESPI_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CORESPI/5.2.104/rtl/vlog/core/corespi.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CORESPI_C0/CORESPI_C0.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CoreUARTapb_C0/CoreUARTapb_C0_0/rtl/vlog/core_obfuscated/Clock_gen.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CoreUARTapb_C0/CoreUARTapb_C0_0/rtl/vlog/core_obfuscated/fifo_256x8_g4.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CoreUARTapb_C0/CoreUARTapb_C0_0/rtl/vlog/core_obfuscated/Rx_async.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CoreUARTapb_C0/CoreUARTapb_C0_0/rtl/vlog/core_obfuscated/Tx_async.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CoreUARTapb_C0/CoreUARTapb_C0_0/rtl/vlog/core_obfuscated/CoreUART.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CoreUARTapb_C0/CoreUARTapb_C0_0/rtl/vlog/core_obfuscated/CoreUARTapb.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CoreUARTapb_C0/CoreUARTapb_C0.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/EvalSandbox_MSS/CCC_0/EvalSandbox_MSS_CCC_0_FCCC.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/EvalSandbox_MSS/FABOSC_0/EvalSandbox_MSS_FABOSC_0_OSC.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/EvalSandbox_MSS_MSS/EvalSandbox_MSS_MSS.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Actel/DirectCore/CoreConfigP/7.1.100/rtl/vlog/core/coreconfigp.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Actel/DirectCore/CoreResetP/7.1.100/rtl/vlog/core/coreresetp_pcie_hotreset.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Actel/DirectCore/CoreResetP/7.1.100/rtl/vlog/core/coreresetp.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Actel/DirectCore/corepwm/4.1.106/rtl/vlog/core_obfuscated/pwm_gen.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Actel/DirectCore/corepwm/4.1.106/rtl/vlog/core_obfuscated/reg_if.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Actel/DirectCore/corepwm/4.1.106/rtl/vlog/core_obfuscated/timebase.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Actel/DirectCore/corepwm/4.1.106/rtl/vlog/core_obfuscated/tach_if.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Actel/DirectCore/corepwm/4.1.106/rtl/vlog/core_obfuscated/corepwm.v"
vlog -sv -work COREAPB3_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vlog/core/coreapb3_muxptob3.v"
vlog -sv -work COREAPB3_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vlog/core/coreapb3_iaddr_reg.v"
vlog -sv -work COREAPB3_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vlog/core/coreapb3.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/EvalSandbox_MSS/EvalSandbox_MSS.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/EvalBoardSandbox/EvalBoardSandbox.v"
vlog "+incdir+${PROJECT_DIR}/component/Actel/Simulation/RESET_GEN/1.0.1" "+incdir+${PROJECT_DIR}/component/work/RESET_GEN_C0" "+incdir+${PROJECT_DIR}/component/work/MySandbox" -sv -work presynth "${PROJECT_DIR}/component/Actel/Simulation/RESET_GEN/1.0.1/RESET_GEN.v"
vlog "+incdir+${PROJECT_DIR}/component/Actel/Simulation/RESET_GEN/1.0.1" "+incdir+${PROJECT_DIR}/component/work/RESET_GEN_C0" "+incdir+${PROJECT_DIR}/component/work/MySandbox" -sv -work presynth "${PROJECT_DIR}/component/work/RESET_GEN_C0/RESET_GEN_C0.v"
vlog "+incdir+${PROJECT_DIR}/component/Actel/Simulation/RESET_GEN/1.0.1" "+incdir+${PROJECT_DIR}/component/work/RESET_GEN_C0" "+incdir+${PROJECT_DIR}/component/work/MySandbox" -sv -work presynth "${PROJECT_DIR}/component/work/MySandbox/MySandbox.v"

vsim -L SmartFusion2 -L presynth -L COREPWM_LIB -L COREAPB3_LIB -L COREAHBLITE_LIB -L COREAHBTOAPB3_LIB -L CORESPI_LIB -L COREAHBLSRAM_LIB  -t 1fs presynth.MySandbox
do "${PROJECT_DIR}/wave.do"
run 10000ns

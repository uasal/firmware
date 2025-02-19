# Microsemi Corp.
# Date: 2025-Feb-17 14:17:33
# This file was generated based on the following SDC source files:
#   C:/MicroSemiProj/Libero/Ux1_Ver2/component/work/EvalSandbox_MSS/CCC_0/EvalSandbox_MSS_CCC_0_FCCC.sdc
#   C:/Microchip/Libero_SoC_v2023.2/Designer/data/aPA4M/cores/constraints/coreresetp.sdc
#   C:/MicroSemiProj/Libero/Ux1_Ver2/component/work/EvalSandbox_MSS_MSS/EvalSandbox_MSS_MSS.sdc
#   C:/MicroSemiProj/Libero/Ux1_Ver2/component/work/EvalSandbox_MSS/FABOSC_0/EvalSandbox_MSS_FABOSC_0_OSC.sdc
#   C:/MicroSemiProj/Libero/Ux1_Ver2/component/work/FCCC_C0/FCCC_C0_0/FCCC_C0_FCCC_C0_0_FCCC.sdc
#   C:/Microchip/Libero_SoC_v2023.2/Designer/data/aPA4M/cores/constraints/sysreset.sdc
# *** Any modifications to this file will be lost if derived constraints is re-run. ***
#

create_clock -ignore_errors -name {EvalSandbox_MSS_0/FABOSC_0/I_RCOSC_25_50MHZ/CLKOUT} -period 20 [ get_pins { EvalSandbox_MSS_0/FABOSC_0/I_RCOSC_25_50MHZ/CLKOUT } ]
create_clock -name {CLK0_PAD} -period 19.6078 [ get_ports { CLK0_PAD } ]

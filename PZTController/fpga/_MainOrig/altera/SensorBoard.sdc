## Generated SDC file "Brd457.out.sdc"

## Copyright (C) 2016  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Intel and sold by Intel or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 16.1.0 Build 196 10/24/2016 SJ Lite Edition"

## DATE    "Thu Jan 18 11:30:45 2018"

##
## DEVICE  "10M08DAF256C7G"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {VCXO} -period 59.603 -waveform { 0.000 29.801 } [get_ports { VCXO }]
create_clock -name {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i} -period 1.000 -waveform { 0.000 0.500 } [get_registers {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]
create_clock -name {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i} -period 1.000 -waveform { 0.000 0.500 } [get_registers {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}]
create_clock -name {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i} -period 1.000 -waveform { 0.000 0.500 } [get_registers {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}]
create_clock -name {ltc2378fifoPorts:ltc2378|OneShotPorts:SpiEnableDelayOneShot|shot_i} -period 1.000 -waveform { 0.000 0.500 } [get_registers {ltc2378fifoPorts:ltc2378|OneShotPorts:SpiEnableDelayOneShot|shot_i}]
create_clock -name {ZBusPorts:ZBus_i|SpiRst} -period 1.000 -waveform { 0.000 0.500 } [get_registers {ZBusPorts:ZBus_i|SpiRst}]
create_clock -name {ltc2378fifoPorts:ltc2378|AdcClkReset} -period 1.000 -waveform { 0.000 0.500 } [get_registers {ltc2378fifoPorts:ltc2378|AdcClkReset}]
create_clock -name {IBufP2Ports:IBufnCsExt|O} -period 1.000 -waveform { 0.000 0.500 } [get_registers {IBufP2Ports:IBufnCsExt|O}]
create_clock -name {SpiDacPorts:ClkDac_i|SpiRst} -period 1.000 -waveform { 0.000 0.500 } [get_registers {SpiDacPorts:ClkDac_i|SpiRst}]
create_clock -name {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i} -period 1.000 -waveform { 0.000 0.500 } [get_registers {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}]
create_clock -name {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i} -period 1.000 -waveform { 0.000 0.500 } [get_registers {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}]
create_clock -name {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i} -period 1.000 -waveform { 0.000 0.500 } [get_registers {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}]
create_clock -name {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i} -period 1.000 -waveform { 0.000 0.500 } [get_registers {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}]
create_clock -name {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i} -period 1.000 -waveform { 0.000 0.500 } [get_registers {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]
create_clock -name {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i} -period 1.000 -waveform { 0.000 0.500 } [get_registers {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]
create_clock -name {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i} -period 1.000 -waveform { 0.000 0.500 } [get_registers {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]
create_clock -name {DnaRegisterPorts:DnaRegister|DnaClk} -period 1.000 -waveform { 0.000 0.500 } [get_registers {DnaRegisterPorts:DnaRegister|DnaClk}]
create_clock -name {ZBusAddrTxPorts:ZBusAddrOutUart|ClockDividerPorts:ZBusAddrTxdClockDiv|div_i} -period 1.000 -waveform { 0.000 0.500 } [get_registers {ZBusAddrTxPorts:ZBusAddrOutUart|ClockDividerPorts:ZBusAddrTxdClockDiv|div_i}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {MasterPll|altpll_analog|auto_generated|pll1|clk[0]} -source [get_pins {MasterPll|altpll_analog|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 6 -master_clock {VCXO} [get_pins {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {UartPll|altpll_analog|auto_generated|pll1|clk[0]} -source [get_pins {UartPll|altpll_analog|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 7 -divide_by 8 -master_clock {VCXO} [get_pins {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {ZBusAddrTxPorts:ZBusAddrOutUart|ClockDividerPorts:ZBusAddrTxdClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {ZBusAddrTxPorts:ZBusAddrOutUart|ClockDividerPorts:ZBusAddrTxdClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {ZBusAddrTxPorts:ZBusAddrOutUart|ClockDividerPorts:ZBusAddrTxdClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {ZBusAddrTxPorts:ZBusAddrOutUart|ClockDividerPorts:ZBusAddrTxdClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {ZBusAddrTxPorts:ZBusAddrOutUart|ClockDividerPorts:ZBusAddrTxdClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {ZBusAddrTxPorts:ZBusAddrOutUart|ClockDividerPorts:ZBusAddrTxdClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {ZBusAddrTxPorts:ZBusAddrOutUart|ClockDividerPorts:ZBusAddrTxdClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {ZBusAddrTxPorts:ZBusAddrOutUart|ClockDividerPorts:ZBusAddrTxdClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -rise_to [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -fall_to [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -rise_to [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -fall_to [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {SpiDacPorts:ClkDac_i|SpiRst}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {SpiDacPorts:ClkDac_i|SpiRst}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {SpiDacPorts:ClkDac_i|SpiRst}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {SpiDacPorts:ClkDac_i|SpiRst}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {SpiDacPorts:ClkDac_i|SpiRst}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {SpiDacPorts:ClkDac_i|SpiRst}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {SpiDacPorts:ClkDac_i|SpiRst}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {SpiDacPorts:ClkDac_i|SpiRst}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {IBufP2Ports:IBufnCsExt|O}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {IBufP2Ports:IBufnCsExt|O}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {IBufP2Ports:IBufnCsExt|O}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {IBufP2Ports:IBufnCsExt|O}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {IBufP2Ports:IBufnCsExt|O}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {IBufP2Ports:IBufnCsExt|O}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {IBufP2Ports:IBufnCsExt|O}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {IBufP2Ports:IBufnCsExt|O}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {ltc2378fifoPorts:ltc2378|AdcClkReset}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {ltc2378fifoPorts:ltc2378|AdcClkReset}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {ltc2378fifoPorts:ltc2378|AdcClkReset}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {ltc2378fifoPorts:ltc2378|AdcClkReset}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {ltc2378fifoPorts:ltc2378|AdcClkReset}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {ltc2378fifoPorts:ltc2378|AdcClkReset}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {ltc2378fifoPorts:ltc2378|AdcClkReset}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {ltc2378fifoPorts:ltc2378|AdcClkReset}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {ltc2378fifoPorts:ltc2378|OneShotPorts:SpiEnableDelayOneShot|shot_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {ltc2378fifoPorts:ltc2378|OneShotPorts:SpiEnableDelayOneShot|shot_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {ltc2378fifoPorts:ltc2378|OneShotPorts:SpiEnableDelayOneShot|shot_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {ltc2378fifoPorts:ltc2378|OneShotPorts:SpiEnableDelayOneShot|shot_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {ltc2378fifoPorts:ltc2378|OneShotPorts:SpiEnableDelayOneShot|shot_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {ltc2378fifoPorts:ltc2378|OneShotPorts:SpiEnableDelayOneShot|shot_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {ltc2378fifoPorts:ltc2378|OneShotPorts:SpiEnableDelayOneShot|shot_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {ltc2378fifoPorts:ltc2378|OneShotPorts:SpiEnableDelayOneShot|shot_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {ZBusPorts:ZBus_i|SpiRst}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {ZBusPorts:ZBus_i|SpiRst}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {ZBusPorts:ZBus_i|SpiRst}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {ZBusPorts:ZBus_i|SpiRst}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {ZBusPorts:ZBus_i|SpiRst}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {ZBusPorts:ZBus_i|SpiRst}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {ZBusPorts:ZBus_i|SpiRst}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {ZBusPorts:ZBus_i|SpiRst}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -setup 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ZBusAddrTxPorts:ZBusAddrOutUart|ClockDividerPorts:ZBusAddrTxdClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ZBusAddrTxPorts:ZBusAddrOutUart|ClockDividerPorts:ZBusAddrTxdClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ZBusAddrTxPorts:ZBusAddrOutUart|ClockDividerPorts:ZBusAddrTxdClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ZBusAddrTxPorts:ZBusAddrOutUart|ClockDividerPorts:ZBusAddrTxdClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {SpiDacPorts:ClkDac_i|SpiRst}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {SpiDacPorts:ClkDac_i|SpiRst}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {SpiDacPorts:ClkDac_i|SpiRst}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {SpiDacPorts:ClkDac_i|SpiRst}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {IBufP2Ports:IBufnCsExt|O}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {IBufP2Ports:IBufnCsExt|O}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {IBufP2Ports:IBufnCsExt|O}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {IBufP2Ports:IBufnCsExt|O}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ltc2378fifoPorts:ltc2378|AdcClkReset}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ltc2378fifoPorts:ltc2378|AdcClkReset}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ltc2378fifoPorts:ltc2378|AdcClkReset}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ltc2378fifoPorts:ltc2378|AdcClkReset}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ltc2378fifoPorts:ltc2378|OneShotPorts:SpiEnableDelayOneShot|shot_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ltc2378fifoPorts:ltc2378|OneShotPorts:SpiEnableDelayOneShot|shot_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ltc2378fifoPorts:ltc2378|OneShotPorts:SpiEnableDelayOneShot|shot_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ltc2378fifoPorts:ltc2378|OneShotPorts:SpiEnableDelayOneShot|shot_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ZBusPorts:ZBus_i|SpiRst}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ZBusPorts:ZBus_i|SpiRst}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ZBusPorts:ZBus_i|SpiRst}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ZBusPorts:ZBus_i|SpiRst}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}]  0.140  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}]  0.140  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ZBusAddrTxPorts:ZBusAddrOutUart|ClockDividerPorts:ZBusAddrTxdClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ZBusAddrTxPorts:ZBusAddrOutUart|ClockDividerPorts:ZBusAddrTxdClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ZBusAddrTxPorts:ZBusAddrOutUart|ClockDividerPorts:ZBusAddrTxdClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ZBusAddrTxPorts:ZBusAddrOutUart|ClockDividerPorts:ZBusAddrTxdClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {DnaRegisterPorts:DnaRegister|DnaClk}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:AClkUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:UsbUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:XMTUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifoParity:GpsUart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRx:ZBusAddrInUart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:ZigOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:XMTOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {SpiDacPorts:ClkDac_i|SpiRst}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {SpiDacPorts:ClkDac_i|SpiRst}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {SpiDacPorts:ClkDac_i|SpiRst}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {SpiDacPorts:ClkDac_i|SpiRst}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {IBufP2Ports:IBufnCsExt|O}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {IBufP2Ports:IBufnCsExt|O}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {IBufP2Ports:IBufnCsExt|O}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {IBufP2Ports:IBufnCsExt|O}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ltc2378fifoPorts:ltc2378|AdcClkReset}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ltc2378fifoPorts:ltc2378|AdcClkReset}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ltc2378fifoPorts:ltc2378|AdcClkReset}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ltc2378fifoPorts:ltc2378|AdcClkReset}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ltc2378fifoPorts:ltc2378|OneShotPorts:SpiEnableDelayOneShot|shot_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ltc2378fifoPorts:ltc2378|OneShotPorts:SpiEnableDelayOneShot|shot_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ltc2378fifoPorts:ltc2378|OneShotPorts:SpiEnableDelayOneShot|shot_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ltc2378fifoPorts:ltc2378|OneShotPorts:SpiEnableDelayOneShot|shot_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifoParity:GpsOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ZBusPorts:ZBus_i|SpiRst}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ZBusPorts:ZBus_i|SpiRst}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ZBusPorts:ZBus_i|SpiRst}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ZBusPorts:ZBus_i|SpiRst}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartRxFifo:ZigUart|UartRx:Uart|ClockDividerPorts:UartClkDiv|div_i}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartTxFifo:AClkOutUart|ClockDividerPorts:BitClockDiv|div_i}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}]  0.140  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {UartPll|altpll_analog|auto_generated|pll1|clk[0]}]  0.140  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {MasterPll|altpll_analog|auto_generated|pll1|clk[0]}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************


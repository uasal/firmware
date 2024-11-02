#~ $Source: /raincloud/src/clients/zonge/Zeus/Zeus3/firmware/arm/main/Makefile,v $
#~ $Revision: 1.15 $
#~ $Date: 2010/06/08 18:28:02 $
#~ $Author: steve $

FLASH_TOOL = OPENOCD

#ARCH = AArch32
MCU = coretx-m3
RUN_MODE = ROM_RUN
TARGET = Main

#~ FW: Main.o ../MonitorAdc.o $(INCLUDE_LOCAL)/uart/AsciiCmdUserInterfaceLinux.o CmdTableAscii.o CmdHandlersAscii.o FlightComms.o CmdTableBinary.o CmdHandlersBinary.o $(INCLUDE_LOCAL)/cgraph/CGraphFWHardwareInterface.o $(INCLUDE_LOCAL)/DelayLinux.o $(INCLUDE_LOCAL)/stdintle.o $(INCLUDE_LOCAL)/arm/LinuxUtils.o $(INCLUDE_LOCAL)/arm/imx6-eim.o $(INCLUDE_LOCAL)/uart/CmdSystem.o $(INCLUDE_LOCAL)/format/formatf_stdio.o #$(INCLUDE_LOCAL)/dbg/memwatch.o $(INCLUDE_LOCAL)/dbg/memwatchcpp.o $(INCLUDE_LOCAL)/gprof-helper.o 
	#~ btracer ../FW
	#~ $(CC) Main.o ../MonitorAdc.o $(INCLUDE_LOCAL)/uart/AsciiCmdUserInterfaceLinux.o CmdTableAscii.o CmdHandlersAscii.o FlightComms.o CmdTableBinary.o CmdHandlersBinary.o $(INCLUDE_LOCAL)/cgraph/CGraphFWHardwareInterface.o $(INCLUDE_LOCAL)/DelayLinux.o $(INCLUDE_LOCAL)/stdintle.o $(INCLUDE_LOCAL)/arm/LinuxUtils.o $(INCLUDE_LOCAL)/arm/imx6-eim.o $(INCLUDE_LOCAL)/uart/CmdSystem.o $(INCLUDE_LOCAL)/format/formatf_stdio.o -o FW $(CFLAGS) $(LDFLAGS) -L. -L/lib -L/usr/lib -L/usr/local/lib -pthread -lpthread -lc -lstdc++ -lm -ldl -lrt
	#~ $(CROSS_COMPILE)objdump -d -g -C -l -S --prefix-addresses FW > builds/FW.v$(GITVERSION).b$(BUILDNUM).lss
	#~ cp $@ builds/FW.v$(GITVERSION).b$(BUILDNUM)

CSRC = $(INCLUDE_LOCAL)/arm/lpcinit_14.745MhzTurbo.c $(INCLUDE_LOCAL)/arm/armVIC.c $(INCLUDE_LOCAL)/eeprom/LpcIap.c $(INCLUDE_LOCAL)/eeprom/ChaN/hw_drivers/multifat/sd_hal_multifat.c $(INCLUDE_LOCAL)/eeprom/MultiFat/mmc_spi.c $(INCLUDE_LOCAL)/eeprom/ChaN/ff.c $(INCLUDE_LOCAL)/basic/basic.c $(INCLUDE_LOCAL)/format/src/format.c

CPPSRC = $(INCLUDE_LOCAL)/stdintle.cpp $(INCLUDE_LOCAL)/format/formatf.cpp $(INCLUDE_LOCAL)/uart/CmdSystem.cpp $(INCLUDE_LOCAL)/eeprom/SDLogfileChaN.cpp $(INCLUDE_LOCAL)/rf/XBeeATCommands.cpp $(INCLUDE_LOCAL)/filters/FFTSingleBin.cpp ./../../../../include/timing/Brd377Registers.cpp ./../../../../include/timing/ZongeHwTypes.cpp ./../../../../include/timing/GpsInfrastructure.cpp ./../../../../include/timing/GpsResync.cpp ./../../../../include/timing/TsipCallbacks.cpp ./../../../../include/timing/CmdHandlersGps.cpp CmdHandlersGpsBinary.cpp $(INCLUDE_LOCAL)/Brd355CalAtten.cpp $(INCLUDE_LOCAL)/Brd441ZT-50.cpp $(INCLUDE_LOCAL)/Brd412MX-2.cpp $(INCLUDE_LOCAL)/rf/ZongeProtocol.cpp $(INCLUDE_LOCAL)/schedule/CmdHandlersSchedule.cpp CmdHandlersScheduleBinary.cpp ./../Brd339Pinouts.cpp Globals.cpp CmdTable.cpp CmdHandlersConfig.cpp CmdHandlersConfigBinary.cpp CmdHandlersDatacard.cpp CmdHandlersDatacardBinary.cpp CmdHandlersDebug.cpp CmdHandlersDebugBinary.cpp MainAdcRoutines.cpp MainGpsSync.cpp MainZigbee.cpp MainSchedule.cpp

CDEFS		= 
OPT = s
#~ OPT = 0
#~ OPT = 3

include ./../../../include/arm/GNUMakefile

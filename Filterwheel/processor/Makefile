#
#           University of Arizona
#           Steward Observatory
#           UASAL - UA Space Astrophysics Labratory
#           CAAO - Center for Astronomical Adaptive Optics
#           MagAOX
#

INCLUDE_LOCAL = ./../../include
LIB_LOCAL = $(INCLUDE_LOCAL)

#ARCH = AArch32
MCU = cortex-m3
TARGET = Main
PROJECT_NAME = Filterwheel

CFLAGS += -Wno-address-of-packed-member

ASRCARM = $(INCLUDE_LOCAL)/arm/smartfusion/startup_m2sxxx.S $(INCLUDE_LOCAL)/arm/smartfusion/HardfaultHandler.S $(INCLUDE_LOCAL)/arm/armdelay.S

CSRC = $(INCLUDE_LOCAL)/arm/smartfusion/system_m2sxxx.c $(INCLUDE_LOCAL)/arm/smartfusion/sys_config.c $(INCLUDE_LOCAL)/arm/smartfusion/newlib_stubs.c $(INCLUDE_LOCAL)/arm/smartfusion/DelayLoops.c $(INCLUDE_LOCAL)/uart/Crc32Bzip2.c $(INCLUDE_LOCAL)/arm/BuildParameters.c $(INCLUDE_LOCAL)/format/src/format.c

CPPSRC = Filterwheel.cpp CmdTableAscii.cpp CmdHandlersAscii.cpp CmdTableBinary.cpp CmdHandlersBinary.cpp Uarts.cpp MonitorAdc.cpp $(INCLUDE_LOCAL)/cgraph/CGraphFWHardwareInterface.cpp $(INCLUDE_LOCAL)/uart/CmdSystem.cpp $(INCLUDE_LOCAL)/format/formatf.cpp $(INCLUDE_LOCAL)/arm/smartfusion/HardFaultHandler.cpp
#$(INCLUDE_LOCAL)/dbg/memwatch.cpp $(INCLUDE_LOCAL)/dbg/memwatchcpp.cpp $(INCLUDE_LOCAL)/gprof-helper.cpp 

OPT = s
#~ OPT = 3
RUN_MODE = RELEASE

#~ OPT = 0
#~ RUN_MODE = DEBUG
#~ CFLAGS += -g
#~ CFLAGS += -ggdb

FLASH_TOOL = OPENOCD

include $(INCLUDE_LOCAL)/arm/GNUMakefile

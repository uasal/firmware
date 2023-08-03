OS := $(shell uname -a)
ifeq (,$(findstring imx6,$(OS)))
	INCLUDE_LOCAL = /home/summer/projects/CGraph/firmware/include
	#~ INCLUDE_LOCAL2 = /home/summer/projects/MountainOps/software/CGraph/Sanford/apps
	#~ INCLUDE_LOCAL2 = /home/summer/projects/CGraph/firmware/include
	CROSS_COMPILE ?= /home/summer/gcc-linaro-arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
	CC = $(CROSS_COMPILE)gcc
else
	#~ INCLUDE_LOCAL = /home/root/include
	INCLUDE_LOCAL = /media/9016-4EF8/include
endif
LIB_LOCAL = /home/summer/projects/include
vpath %.h $(INCLUDE_LOCAL) $(INCLUDE_LOCAL2)
vpath %.hpp $(INCLUDE_LOCAL) $(INCLUDE_LOCAL2)
vpath %.c $(LIB_LOCAL)
vpath %.cpp $(LIB_LOCAL)
vpath %.o $(LIB_LOCAL)
vpath %.a $(LIB_LOCAL)
EXTRAINCDIRS = . ./../../../../include/ $(INCLUDE_LOCAL) $(INCLUDE_LOCAL2)
EXTRA_LIBDIRS = . ./../lib/ $(LIB_LOCAL) # /home/summer/projects/include/libconfig/
#~ CFLAGS +=  -pg -Os -static-libstdc++ -Wall -Wextra -Wno-unused-parameter $(patsubst %,-I%,$(EXTRAINCDIRS)) #-static
#~ LDFLAGS += -pg -Wl,-Map=PZT.map,--cref,--gc-sections
#~ CFLAGS += -Os 
CFLAGS += -static -static-libstdc++
#~ CFLAGS += -DMEMWATCH -DMW_PTHREADS -DMW_STDIO
CFLAGS += -g3 
CFLAGS += -O3 
#~ CFLAGS += -Os 
#~ CFLAGS += -O1
#~ CFLAGS += -O0
CFLAGS += -fno-omit-frame-pointer
CFLAGS += -static-libstdc++ -Wall -Wextra -Wno-unused-parameter $(patsubst %,-I%,$(EXTRAINCDIRS)) #-static
CFLAGS += -Wa,-adhlns=$<.lst
LDFLAGS += -rdynamic -Wl,-Map=PZT.map,--cref,--gc-sections
LDFLAGS += $(patsubst %,-L%,$(EXTRA_LIBDIRS))
LDFLAGS += $(patsubst %,-l%,$(EXTRA_LIBS))

GITVERSION:= $(shell git rev-parse HEAD)
BUILDNUM:= $(shell bquery ../PZT)
#~ CFLAGS += -DGITVERSION="\"${GITVERSION}\"" -DBUILDNUM="\"${BUILDNUM}\""  -static -static-libstdc++ -std=gnu++11 # -fsanitize=address -fsanitize=undefined
CFLAGS += -DGITVERSION="\"${GITVERSION}\"" -DBUILDNUM="\"${BUILDNUM}\"" -static-libstdc++ -std=gnu++11 # -fsanitize=address -fsanitize=undefined

%.o: %.cpp
	$(CC) $(CFLAGS) -I. -c $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -I. -c $< -o $@
	
PZT: Main.o ../MonitorAdc.o $(INCLUDE_LOCAL)/uart/AsciiCmdUserInterfaceLinux.o CmdTableAscii.o CmdHandlersAscii.o FlightComms.o ClientSocket.o CmdTableBinary.o CmdHandlersBinary.o $(INCLUDE_LOCAL)/cgraph/CGraphFSMHardwareInterface.o $(INCLUDE_LOCAL)/DelayLinux.o $(INCLUDE_LOCAL)/stdintle.o $(INCLUDE_LOCAL)/arm/LinuxUtils.o $(INCLUDE_LOCAL)/arm/imx6-eim.o $(INCLUDE_LOCAL)/uart/CmdSystem.o $(INCLUDE_LOCAL)/format/formatf_stdio.o #$(INCLUDE_LOCAL)/dbg/memwatch.o $(INCLUDE_LOCAL)/dbg/memwatchcpp.o $(INCLUDE_LOCAL)/gprof-helper.o 
	btracer ../PZT
	$(CC) Main.o ../MonitorAdc.o $(INCLUDE_LOCAL)/uart/AsciiCmdUserInterfaceLinux.o CmdTableAscii.o CmdHandlersAscii.o FlightComms.o ClientSocket.o CmdTableBinary.o CmdHandlersBinary.o $(INCLUDE_LOCAL)/cgraph/CGraphFSMHardwareInterface.o $(INCLUDE_LOCAL)/DelayLinux.o $(INCLUDE_LOCAL)/stdintle.o $(INCLUDE_LOCAL)/arm/LinuxUtils.o $(INCLUDE_LOCAL)/arm/imx6-eim.o $(INCLUDE_LOCAL)/uart/CmdSystem.o $(INCLUDE_LOCAL)/format/formatf_stdio.o -o PZT $(CFLAGS) $(LDFLAGS) -L. -L/lib -L/usr/lib -L/usr/local/lib -pthread -lpthread -lc -lstdc++ -lm -ldl -lrt
	$(CROSS_COMPILE)objdump -d -g -C -l -S --prefix-addresses PZT > builds/PZT.v$(GITVERSION).b$(BUILDNUM).lss
	cp $@ builds/PZT.v$(GITVERSION).b$(BUILDNUM)
	
all: PZT

program: PZT
	#~ -ssh root@192.168.1.223 systemctl stop PZT
	#~ -ssh root@192.168.1.223 killall PZT
	#~ -scp PZT root@192.168.1.223:/home/root
	-ssh root@1fsm systemctl stop PZT
	-ssh root@fsm killall PZT
	-scp PZT root@fsm:/home/root
	
burn:
	-ssh root@192.168.1.223 killall PZT
	-scp PZT root@192.168.1.223:/home/root

clean:
	-rm *.o
	-rm *.lst
	-rm ../*.o
	-rm $(INCLUDE_LOCAL)/*.o
	-rm $(INCLUDE_LOCAL)/arm/*.o
	-rm $(INCLUDE_LOCAL)/uart/*.o
	-rm $(INCLUDE_LOCAL)/format/*.o
	-rm $(INCLUDE_LOCAL)/cgraph/*.o
	-rm PZT
	-killall PZT

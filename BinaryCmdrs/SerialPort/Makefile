OS := $(shell uname)
ifeq ($(OS),Linux)
	INCLUDE_LOCAL = ../../include
else
	INCLUDE_LOCAL = /cygdrive/n/firmware/include
endif
LIB_LOCAL = ../../include
vpath %.h $(INCLUDE_LOCAL)
vpath %.hpp $(INCLUDE_LOCAL)
vpath %.c $(LIB_LOCAL)
vpath %.cpp $(LIB_LOCAL)
vpath %.o $(LIB_LOCAL)
vpath %.a $(LIB_LOCAL)
EXTRAINCDIRS = . ../../include/ $(INCLUDE_LOCAL)
EXTRA_LIBDIRS = . ./../lib/ $(LIB_LOCAL)
CFLAGS += $(patsubst %,-I%,$(EXTRAINCDIRS))
LDFLAGS += $(patsubst %,-L%,$(EXTRA_LIBDIRS))
LDFLAGS += $(patsubst %,-l%,$(EXTRA_LIBS))

HERE:= $(shell pwd)
GITVERSION:= $(shell git rev-parse HEAD)
BUILDNUM:= $(shell bquery ../Pearl)
#~ CFLAGS += -DGITVERSION="\"${GITVERSION}\"" -DBUILDNUM="\"${BUILDNUM}\""  -static -static-libstdc++ -std=gnu++11 # -fsanitize=address -fsanitize=undefined
CFLAGS += -DGITVERSION="\"${GITVERSION}\"" -DBUILDNUM="\"${BUILDNUM}\"" -static-libstdc++ -std=gnu++11 # -fsanitize=address -fsanitize=undefined

%.o: %.cpp
	gcc $(CFLAGS) -g -I. -c $< -o $@

%.o: %.c
	gcc $(CFLAGS) -g -I. -c $< -o $@

PearlCmdrSerial: main.o ../CmdTableAscii.o ../CmdHandlersAsciiGeneral.o ../CmdHandlersAsciiFineSteeringMirror.o ../CmdHandlersAsciiDeformableMirror.o ../CmdHandlersAsciiFilterWheel.o ../CmdTableBinary.o ../CmdHandlersBinaryGeneral.o ../CmdHandlersBinaryFineSteeringMirror.o ../CmdHandlersBinaryDeformableMirror.o ../CmdHandlersBinaryFilterWheel.o $(INCLUDE_LOCAL)/uart/AsciiCmdUserInterfaceLinux.o $(INCLUDE_LOCAL)/uart/CmdSystem.o $(INCLUDE_LOCAL)/format/formatf_stdio.o $(INCLUDE_LOCAL)/cgraph/CGraphFSMHardwareInterface.o $(INCLUDE_LOCAL)/cgraph/CGraphDMHardwareInterface.o $(INCLUDE_LOCAL)/cgraph/CGraphFWHardwareInterface.o
	btracer ../PearlCmdrSerial
	gcc main.o ../CmdTableAscii.o ../CmdHandlersAsciiGeneral.o ../CmdHandlersAsciiFineSteeringMirror.o ../CmdHandlersAsciiDeformableMirror.o ../CmdHandlersAsciiFilterWheel.o ../CmdTableBinary.o ../CmdHandlersBinaryGeneral.o ../CmdHandlersBinaryFineSteeringMirror.o ../CmdHandlersBinaryDeformableMirror.o ../CmdHandlersBinaryFilterWheel.o $(INCLUDE_LOCAL)/uart/AsciiCmdUserInterfaceLinux.o $(INCLUDE_LOCAL)/uart/CmdSystem.o $(INCLUDE_LOCAL)/format/formatf_stdio.o $(INCLUDE_LOCAL)/cgraph/CGraphFSMHardwareInterface.o $(INCLUDE_LOCAL)/cgraph/CGraphDMHardwareInterface.o $(INCLUDE_LOCAL)/cgraph/CGraphFWHardwareInterface.o -g -o PearlCmdrSerial $(CFLAGS) $(LDFLAGS) -g -L. -L/lib -L/usr/lib -L/usr/local/lib -lc -lstdc++ -lm -lpthread -lncurses
	cp $@ ~/bin/
	
all: PearlCmdrSerial

program: PearlCmdrSerial
	-mate-terminal -e "$(HERE)/PearlCmdrSerial /dev/ttyUSB0 38400"

clean:
	-rm ../*.o
	-rm *.o
	-rm $(INCLUDE_LOCAL)/*.o
	-rm $(INCLUDE_LOCAL)/arm/*.o
	-rm $(INCLUDE_LOCAL)/uart/*.o
	-rm $(INCLUDE_LOCAL)/format/*.o
	-rm $(INCLUDE_LOCAL)/cgraph/*.o
	-rm PearlCmdrSerial
	-killall PearlCmdrSerial
	
OS := $(shell uname)
ifeq ($(OS),Linux)
	INCLUDE_LOCAL = /home/summer/projects/include
else
	INCLUDE_LOCAL = /cygdrive/n/firmware/include
endif
#~ INCLUDE_LOCAL2 = /home/summer/projects/MountainOps/software/CGraph/Sanford/apps
INCLUDE_LOCAL2 = /home/summer/projects/MountainOps/firmware/CGraph/include/
LIB_LOCAL = /home/summer/projects/firmware/include
vpath %.h $(INCLUDE_LOCAL) $(INCLUDE_LOCAL2)
vpath %.hpp $(INCLUDE_LOCAL) $(INCLUDE_LOCAL2)
vpath %.c $(LIB_LOCAL)
vpath %.cpp $(LIB_LOCAL)
vpath %.o $(LIB_LOCAL)
vpath %.a $(LIB_LOCAL)
EXTRAINCDIRS = . ./../../../../include/ $(INCLUDE_LOCAL) $(INCLUDE_LOCAL2)
EXTRA_LIBDIRS = . ./../lib/ $(LIB_LOCAL)
CFLAGS += $(patsubst %,-I%,$(EXTRAINCDIRS))
LDFLAGS += $(patsubst %,-L%,$(EXTRA_LIBDIRS))
LDFLAGS += $(patsubst %,-l%,$(EXTRA_LIBS))

HERE:= $(shell pwd)
GITVERSION:= $(shell git rev-parse HEAD)
BUILDNUM:= $(shell bquery ../PZT)
#~ CFLAGS += -DGITVERSION="\"${GITVERSION}\"" -DBUILDNUM="\"${BUILDNUM}\""  -static -static-libstdc++ -std=gnu++11 # -fsanitize=address -fsanitize=undefined
CFLAGS += -DGITVERSION="\"${GITVERSION}\"" -DBUILDNUM="\"${BUILDNUM}\"" -static-libstdc++ -std=gnu++11 # -fsanitize=address -fsanitize=undefined

%.o: %.cpp
	gcc $(CFLAGS) -g -I. -c $< -o $@

%.o: %.c
	gcc $(CFLAGS) -g -I. -c $< -o $@

PZTCmdrSerial: main.o ../CmdTableAscii.o ../CmdHandlersAscii.o ../CmdTableBinary.o ../CmdHandlersBinary.o $(INCLUDE_LOCAL)/uart/AsciiCmdUserInterfaceLinux.o $(INCLUDE_LOCAL)/uart/CmdSystem.o $(INCLUDE_LOCAL)/format/formatf_stdio.o $(INCLUDE_LOCAL2)/CGraphFSMHardwareInterface.o
	btracer ../PZTCmdrSerial
	gcc main.o ../CmdTableAscii.o ../CmdHandlersAscii.o ../CmdTableBinary.o ../CmdHandlersBinary.o $(INCLUDE_LOCAL)/uart/AsciiCmdUserInterfaceLinux.o $(INCLUDE_LOCAL)/uart/CmdSystem.o $(INCLUDE_LOCAL)/format/formatf_stdio.o $(INCLUDE_LOCAL2)/CGraphFSMHardwareInterface.o -g -o PZTCmdrSerial $(CFLAGS) $(LDFLAGS) -g -L. -L/lib -L/usr/lib -L/usr/local/lib -lc -lstdc++ -lm -lpthread -lncurses
	cp $@ /home/summer/bin/
	
all: PZTCmdrSerial

program:
	mate-terminal -e "$(HERE)/PZTCmdrSerial"

clean:
	-rm ../*.o
	-rm *.o
	-rm $(INCLUDE_LOCAL)/*.o
	-rm $(INCLUDE_LOCAL)/arm/*.o
	-rm $(INCLUDE_LOCAL)/uart/*.o
	-rm $(INCLUDE_LOCAL)/format/*.o
	-rm $(INCLUDE_LOCAL2)/*.o
	-rm PZTCmdrSerial
	-killall PZTCmdrSerial
	
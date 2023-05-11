OS := $(shell uname)
ifeq ($(OS),Linux)
	INCLUDE_LOCAL = /home/summer/projects/include
else
	INCLUDE_LOCAL = /cygdrive/n/zonge/firmware/include
endif
LIB_LOCAL = /home/summer/projects/include
vpath %.h $(INCLUDE_LOCAL)
vpath %.hpp $(INCLUDE_LOCAL)
vpath %.c $(LIB_LOCAL)
vpath %.cpp $(LIB_LOCAL)
vpath %.o $(LIB_LOCAL)
vpath %.a $(LIB_LOCAL)
EXTRAINCDIRS = . ./../../../../include/ $(INCLUDE_LOCAL)
EXTRA_LIBDIRS = . ./../lib/ $(LIB_LOCAL)
CFLAGS += -fno-rtti -std=gnu++11 $(patsubst %,-I%,$(EXTRAINCDIRS))
LDFLAGS += $(patsubst %,-L%,$(EXTRA_LIBDIRS))
LDFLAGS += $(patsubst %,-l%,$(EXTRA_LIBS))

GITVERSION:= $(shell git describe --always --dirty --long --tags)
BUILDNUM:= $(shell bquery Main)
CFLAGS += -DGITVERSION="\"${GITVERSION}\"" -DBUILDNUM="\"${BUILDNUM}\""

%.o: %.cpp
	gcc $(CFLAGS) -g -I. -c $< -o $@

%.o: %.c
	gcc $(CFLAGS) -g -I. -c $< -o $@
	
SensorBoardServer: SensorBoardServerArchitecture.dot *.h *.hpp main.o ClientConnection.o SensorBoardConnection.o AsciiCmdUserInterface.o CmdHandlersAscii.o CmdTableAscii.o CmdHandlersSocket.o CmdTableSocket.o $(INCLUDE_LOCAL)/stdintle.o $(INCLUDE_LOCAL)/uart/CmdSystem.o $(INCLUDE_LOCAL)/rf/MountainOpsProtocol.o $(INCLUDE_LOCAL)/format/formatf_stdio.o $(INCLUDE_LOCAL)/format/src/format.o $(INCLUDE_LOCAL)/timing/MountainOpsHwTypes.o ./../../firmware/linux/SensorBoardProcessTable.o
	btracer Main
	gcc main.o ClientConnection.o SensorBoardConnection.o AsciiCmdUserInterface.o CmdHandlersAscii.o CmdTableAscii.o CmdHandlersSocket.o CmdTableSocket.o $(INCLUDE_LOCAL)/stdintle.o $(INCLUDE_LOCAL)/uart/CmdSystem.o $(INCLUDE_LOCAL)/rf/MountainOpsProtocol.o $(INCLUDE_LOCAL)/format/formatf_stdio.o $(INCLUDE_LOCAL)/format/src/format.o $(INCLUDE_LOCAL)/timing/MountainOpsHwTypes.o  ./../../firmware/linux/SensorBoardProcessTable.o -g -o SensorBoardServer $(CFLAGS) $(LDFLAGS) -pthread -L. -L/lib -L/usr/lib -L/usr/local/lib -lc -lstdc++ -lm 
	cp $@ builds/SensorBoardServer.v$(GITVERSION).b$(BUILDNUM)
	dot SensorBoardServerArchitecture.dot -Tpdf:cairo -o SensorBoardServerArchitecture.pdf
	#gcc main.o -o SensorBoardServer -L/lib -L/usr/lib -L/usr/local/lib -lc -lstdc++ -lm -lboost_filesystem-mt

all: SensorBoardServer

program: all
	#~ ./SensorBoardServer

#~ burn:
	#~ ./SensorBoardServer

clean:
	-rm *.o
	-rm $(INCLUDE_LOCAL)/stdintle.o
	-rm $(INCLUDE_LOCAL)/rf/MountainOpsProtocol.o
	-rm $(INCLUDE_LOCAL)/format/formatf_stdio.o
	-rm $(INCLUDE_LOCAL)/format/src/format.o
	-rm $(INCLUDE_LOCAL)/timing/MountainOpsHwTypes.o
	-rm $(INCLUDE_LOCAL)/uart/CmdSystem.o
	-rm ./../../firmware/linux/SensorBoardProcessTable.o
	-rm SensorBoardServer
	-killall SensorBoardServer

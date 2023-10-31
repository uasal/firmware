OS := $(shell uname)
ifeq ($(OS),Linux)
	INCLUDE_LOCAL = /home/steve/projects/zonge/firmware/include
else
	INCLUDE_LOCAL = /cygdrive/n/zonge/firmware/include
endif
LIB_LOCAL = /home/steve/projects/zonge/firmware/include
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

HGVERSION:= $(shell expr 1 + `hg -q parents --template '{rev}'`)
BUILDNUM:= $(shell bquery Main)
CFLAGS += -DHGVERSION="\"${HGVERSION}\"" -DBUILDNUM="\"${BUILDNUM}\""

%.o: %.cpp
	gcc $(CFLAGS) -g -I. -c $< -o $@

%.o: %.c
	gcc $(CFLAGS) -g -I. -c $< -o $@
	
Zen457Server: Zen457ServerArchitecture.dot *.h *.hpp main.o ClientConnection.o ZenConnection.o AsciiCmdUserInterface.o CmdHandlersAscii.o CmdTableAscii.o CmdHandlersSocket.o CmdTableSocket.o $(INCLUDE_LOCAL)/stdintle.o $(INCLUDE_LOCAL)/uart/CmdSystem.o $(INCLUDE_LOCAL)/rf/ZongeProtocol.o $(INCLUDE_LOCAL)/format/formatf_stdio.o $(INCLUDE_LOCAL)/format/src/format.o $(INCLUDE_LOCAL)/timing/ZongeHwTypes.o ./../../firmware/linux/ZenProcessTable.o
	btracer Main
	gcc main.o ClientConnection.o ZenConnection.o AsciiCmdUserInterface.o CmdHandlersAscii.o CmdTableAscii.o CmdHandlersSocket.o CmdTableSocket.o $(INCLUDE_LOCAL)/stdintle.o $(INCLUDE_LOCAL)/uart/CmdSystem.o $(INCLUDE_LOCAL)/rf/ZongeProtocol.o $(INCLUDE_LOCAL)/format/formatf_stdio.o $(INCLUDE_LOCAL)/format/src/format.o $(INCLUDE_LOCAL)/timing/ZongeHwTypes.o  ./../../firmware/linux/ZenProcessTable.o -g -o Zen457Server $(CFLAGS) $(LDFLAGS) -pthread -L. -L/lib -L/usr/lib -L/usr/local/lib -lc -lstdc++ -lm 
	cp $@ builds/Zen457Server.v$(HGVERSION).b$(BUILDNUM)
	dot Zen457ServerArchitecture.dot -Tpdf:cairo -o Zen457ServerArchitecture.pdf
	#gcc main.o -o Zen457Server -L/lib -L/usr/lib -L/usr/local/lib -lc -lstdc++ -lm -lboost_filesystem-mt

all: Zen457Server

program: all
	#~ ./Zen457Server

#~ burn:
	#~ ./Zen457Server

clean:
	-rm *.o
	-rm $(INCLUDE_LOCAL)/stdintle.o
	-rm $(INCLUDE_LOCAL)/rf/ZongeProtocol.o
	-rm $(INCLUDE_LOCAL)/format/formatf_stdio.o
	-rm $(INCLUDE_LOCAL)/format/src/format.o
	-rm $(INCLUDE_LOCAL)/timing/ZongeHwTypes.o
	-rm $(INCLUDE_LOCAL)/uart/CmdSystem.o
	-rm ./../../firmware/linux/ZenProcessTable.o
	-rm Zen457Server
	-killall Zen457Server

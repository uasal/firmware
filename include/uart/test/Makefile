INCLUDE_LOCAL = ../../
CFLAGS = -I$(INCLUDE_LOCAL) -DGITVERSION="\"test\"" -DBUILDNUM="\"0\"" -static-libstdc++ -std=gnu++11

%.o: %.cpp
	gcc $(CFLAGS) -g -c $< -o $@

%.o: %.c
	gcc $(CFLAGS) -g -c $< -o $@

TestBulkRead: TestBulkRead.o $(INCLUDE_LOCAL)/uart/BinaryUart.o $(INCLUDE_LOCAL)/uart/CmdSystem.o $(INCLUDE_LOCAL)/uart/Crc32Bzip2.o $(INCLUDE_LOCAL)/format/formatf_stdio.o
	gcc $^ -g -o $@ -lstdc++ -lm -lpthread -lutil

clean:
	-rm -f *.o $(INCLUDE_LOCAL)/uart/BinaryUart.o $(INCLUDE_LOCAL)/uart/CmdSystem.o $(INCLUDE_LOCAL)/uart/Crc32Bzip2.o $(INCLUDE_LOCAL)/format/formatf_stdio.o TestBulkRead

all: TestBulkRead

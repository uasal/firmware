# -------------------------------------
# Author:  Tyler Newton
# Program: Build Tracer
# Date:    August 27,2004
# OS:      Red Hat 9.0
# -------------------------------------
program: main.o vhdmain.o qmain.o qvhdmain.o
	gcc main.o -o btracer -L/lib -L/usr/lib -L/usr/local/lib -lc -lstdc++
	gcc vhdmain.o -o vhdbtracer -L/lib -L/usr/lib -L/usr/local/lib -lc -lstdc++
	gcc qmain.o -o bquery -L/lib -L/usr/lib -L/usr/local/lib -lc -lstdc++
	gcc qvhdmain.o -o vhdbquery -L/lib -L/usr/lib -L/usr/local/lib -lc -lstdc++
	cp btracer ~/bin/
	cp vhdbtracer ~/bin/
	cp bquery ~/bin/
	cp vhdbquery ~/bin/

main.o: main.cpp
	gcc -c main.cpp -o main.o

vhdmain.o: vhdmain.cpp
	gcc -c vhdmain.cpp -o vhdmain.o

qmain.o: qmain.cpp
	gcc -c qmain.cpp -o qmain.o

qvhdmain.o: qvhdmain.cpp
	gcc -c qvhdmain.cpp -o qvhdmain.o

clean:
	rm *.o
	rm btracer
	rm vhdbtracer
	rm qbtracer
	rm qvhdbtracer

# -------------------------------------

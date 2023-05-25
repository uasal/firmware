/// \file
/// $Source: /raincloud/src/projects/include/uart/linux_pinout_stdio.hpp,v $
/// $Revision: 1.9 $
/// $Date: 2009/11/14 00:20:04 $
/// $Author: steve $

#ifndef _linux_pinout_stdio_h
#define _linux_pinout_stdio_h
#pragma once

#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

//open files:
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>

#include "ncurses.h"
//~ #include <termios.h>

#include "IUart.h"

class linux_pinout_stdio : public IUart
{
	
public:

	linux_pinout_stdio() : IUart() 
	{ 
		//Tell libc not to buffer input too, so we get every char, not every line...
		setvbuf(stdin, NULL, _IONBF, 0);
		
		//Tell tty not to buffer input, so we get every char, not every line...
		initscr(); //ncurses
		cbreak(); //ncurses
		//~ system("stty raw -echo"); //just call a shell process to do it - lazy!
		//~ //termios:
		//~ struct termios old = {0};
        //~ if (tcgetattr(0, &old) < 0) { perror("tcsetattr()"); }
        //~ old.c_lflag &= ~ICANON;
        //~ old.c_lflag &= ~ECHO;
        //~ old.c_cc[VMIN] = 1;
        //~ old.c_cc[VTIME] = 0;
        //~ if (tcsetattr(0, TCSANOW, &old) < 0) { perror("tcsetattr ICANON"); }			
	}
	
	virtual ~linux_pinout_stdio() 
	{ 
		endwin(); //ncurses
		
		//~ struct termios old = {0};
        //~ if (tcgetattr(0, &old) < 0) { perror("tcsetattr()"); }
        //~ old.c_lflag |= ICANON;
        //~ old.c_lflag |= ECHO;
        //~ if (tcsetattr(0, TCSADRAIN, &old) < 0) { perror ("tcsetattr ~ICANON"); }
	}

	//~ virtual int init(const uint32_t Baudrate, const char* device) { return(IUartOK); }
	//~ virtual void deinit() { }
	
	virtual bool dataready() 
	{ 
		bool ready = (0 != kbhit());
		//~ if (ready) { ::formatf("\nnch: %u\n", kbhit()); }
		return(ready); 
	}

	virtual char getcqq()
	{
		char c = getch(); //ncurses
		//~ char c = getchar();
		
		//~ putchar(c);
		//~ 

  		return(c);
	}

	//~ virtual char putcqq(char c) const { putchar(c); return (c); }
	virtual char putcqq(char c) { addch(c); return (c); } //ncurses

private:

	//~ int kbhit() const
	//~ {
		//~ struct timeval tv;
		//~ fd_set fds;
		//~ tv.tv_sec = 0;
		//~ tv.tv_usec = 0;
		//~ FD_ZERO(&fds);
		//~ FD_SET(STDIN_FILENO, &fds); //STDIN_FILENO is 0
		//~ select(STDIN_FILENO+1, &fds, NULL, NULL, &tv);
		//~ return FD_ISSET(STDIN_FILENO, &fds);
	//~ }

	int kbhit() const
	{
		int i = 0;
		ioctl(0, FIONREAD, &i);
		return(i); /* return a count of chars available to read */
	}
};

#endif //linux_pinout_stdio_h

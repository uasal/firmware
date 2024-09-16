//
///           Copyright (c) by Franks Development, LLC
//
// This software is copyrighted by and is the sole property of Franks
// Development, LLC. All rights, title, ownership, or other interests
// in the software remain the property of Franks Development, LLC. This
// software may only be used in accordance with the corresponding
// license agreement.  Any unauthorized use, duplication, transmission,
// distribution, or disclosure of this software is expressly forbidden.
//
// This Copyright notice may not be removed or modified without prior
// written consent of Franks Development, LLC.
//
// Franks Development, LLC. reserves the right to modify this software
// without notice.
//
// Franks Development, LLC            support@franks-development.com
// 500 N. Bahamas Dr. #101           http://www.franks-development.com
// Tucson, AZ 85710
// USA
//
// Permission granted for perpetual non-exclusive end-use by the University of Arizona August 1, 2020
//


#ifndef _linux_pinout_named_pipe_h
#define _linux_pinout_named_pipe_h
#pragma once

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/select.h>
#include <sys/time.h>
#include <sys/types.h>
#include <errno.h>
	   
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//~ #include "format/printf.h"

#include "IUart.h"

class linux_pinout_named_pipe : public IUart
{
public:

	const uint32_t ReadWriteMaskRead;
	const uint32_t ReadWriteMaskWrite;
	
	linux_pinout_named_pipe() : IUart(), ReadWriteMaskRead((uint32_t)O_RDONLY), ReadWriteMaskWrite((uint32_t)O_WRONLY), silent(false), fd(-1) { }
	virtual ~linux_pinout_named_pipe() { }

	linux_pinout_named_pipe(int hAlreadyOpenedPipe) : IUart(), ReadWriteMaskRead((uint32_t)O_RDONLY), ReadWriteMaskWrite((uint32_t)O_WRONLY), silent(false), fd(hAlreadyOpenedPipe) { }
	
	virtual int init(const uint32_t ReadWriteMask, const char* named_pipe_path_name)
	{
		deinit(); //close named_pipe if open
		
		//~ printf("\nlinux_pinout_named_pipe::init(): silent: %c.\n", silent?'Y':'N');
		
		//~ if (!silent) { printf("\nlinux_pinout_named_pipe::init() : opening named_pipe \"%s\".\n", named_pipe_path_name); }
		
		//We need fifo to be readable by nobody a lot...
		umask(S_IRUSR | S_IWUSR | S_IXUSR | S_IRGRP | S_IWGRP | S_IXGRP | S_IROTH | S_IWOTH | S_IXOTH);
		
		if (0 != mkfifo(named_pipe_path_name, S_IRUSR | S_IWUSR | S_IXUSR | S_IRGRP | S_IWGRP | S_IXGRP | S_IROTH | S_IWOTH | S_IXOTH))
		{
			if (EEXIST != errno) //If it's there already from our last run, then fine.
			{
				//~ printf("\nlinux_pinout_named_pipe::init() : error in mkfifo(): %ld.\n", (long int)errno);					
				if (!silent) { perror("\nlinux_pinout_named_pipe::init() : error in mkfifo()"); }
				return(errno);
			}
		}
		
		fd = open(named_pipe_path_name, (int)ReadWriteMask | O_NONBLOCK);
		if (fd < 0) 
		{
			//~ if (!silent) { printf("\nlinux_pinout_named_pipe::init() : error in open(): %ld.\n", (long int)errno); }
			if (!silent) { perror("\nlinux_pinout_named_pipe::init() : error in open()"); }		
			return(errno);
		}
		else
		{
			return(IUartOK);
		}
	}

	virtual void deinit()
	{
		if (-1 != fd) 
		{ 
			if (!silent) { printf("\nlinux_pinout_named_pipe::deinit() : closing named_pipe.\n"); }
			
			if (close(fd) < 0)
			{
				//~ if (!silent) { printf("\nlinux_pinout_named_pipe::init() : error in close(): %ld.\n", (long int)errno); }
				if (!silent) { perror("\nlinux_pinout_named_pipe::init() : error in close()"); }
			}
			fd = -1;
		}
	}
	
	virtual bool dataready() const
	{
		fd_set pipeset;
		struct timeval  nowait;
		memset((char *)&nowait,0,sizeof(nowait));
		if (-1 == fd) { return(false); } //open?
		FD_ZERO(&pipeset);
		FD_SET(fd, &pipeset);	
		int result = select(fd + 1, &pipeset, NULL, NULL, &nowait);
		if (result < 0)	
		{ 
			//~ if (!silent) { printf("\nlinux_pinout_named_pipe::dataready(): select() failed with %ld.\n", (long int)errno); }
			if (!silent) { perror("\nlinux_pinout_named_pipe::dataready(): select() failed"); }			
		}
		else if (result == 1)
		{
			if (FD_ISSET(fd, &pipeset)) // The pipeet has data. For good measure, it's not a bad idea to test further
			{
				return(true);
			}
		}
		return(false);
	}

	virtual char getcqq()
	{
		char c = 0;
		
		if (-1 != fd)
		{
			ssize_t numbytes = read(fd, &c, 1);
			if (numbytes < 0)
			{
				//~ if (!silent) { printf("\nlinux_pinout_named_pipe::getcqq(): read() failed with %ld.\n", (long int)errno); }
				if (!silent) { perror("\nlinux_pinout_named_pipe::getcqq(): read() failed"); }
				//~ deinit();
				return((char)errno);
			}
		}
		else
		{
			if (!silent) { printf("\nlinux_pinout_named_pipe::getcqq(): read on uninitialized named_pipe; please open named_pipe!\n"); }
		}

  		return(c);
	}
	
	virtual int get(void* p, const size_t len)
	{
		ssize_t numbytes = 0;
		
		if (-1 != fd)
		{
			numbytes = read(fd, p, len);
			if (numbytes < 0)
			{
				//~ if (!silent) { printf("\nlinux_pinout_named_pipe::getcqq(): read() failed with %ld.\n", (long int)errno); }
				if (!silent) { perror("\nlinux_pinout_named_pipe::get(): read() failed"); }
				//~ deinit();
				return(errno);
			}
		}
		else
		{
			if (!silent) { printf("\nlinux_pinout_named_pipe::get(): read on uninitialized named_pipe; please open named_pipe!\n"); }
		}

  		return(numbytes);
	}
	
	virtual char putcqq(char c)
	{
		if (-1 != fd)
		{
			ssize_t numbytes = write(fd, &c, 1);
			if (numbytes < 0)
			{
				//~ if (!silent) { printf("\nlinux_pinout_named_pipe::putcqq(): write() failed with %ld.\n", (long int)errno); }
				if (!silent) { perror("\nlinux_pinout_named_pipe::putcqq(): write() failed"); }				
				//~ deinit();
				return((char)errno);
			}
		}
		else
		{
			if (!silent) { printf("\nlinux_pinout_named_pipe::putcqq(): write on uninitialized named_pipe; please open named_pipe!\n"); }
		}

  		return(c);
	}
	
	virtual int put(const void* p, const size_t len)
	{
		ssize_t numbytes = 0;
		
		if (-1 != fd)
		{
			numbytes = write(fd, p, len);
			if (numbytes < 0)
			{
				//~ if (!silent) { printf("\nlinux_pinout_named_pipe::putcqq(): write() failed with %ld.\n", (long int)errno); }
				if (!silent) { perror("\nlinux_pinout_named_pipe::put(): write() failed"); }				
				//~ deinit();
				return(errno);
			}
		}
		else
		{
			if (!silent) { printf("\nlinux_pinout_named_pipe::put(): write on uninitialized named_pipe; please open named_pipe!\n"); }
		}

  		return(numbytes);
	}

	virtual void purgeinput() { for(size_t i = 0; i < 8191; i++) { if(dataready()) { getcqq(); } else { break; } } }
	
	virtual bool isopen() const { return(-1 != fd); }
	
	void Silent(const bool s) { silent = s; } //printf("\nlinux_pinout_named_pipe::silent(%c)\n", silent?'Y':'N'); }
	
	void size(int max_storage_bytes)
	{
		if (-1 != fd)
		{
			int err = fcntl(fd, F_SETPIPE_SZ, max_storage_bytes);
			if (err < 0)
			{
				perror("\nlinux_pinout_named_pipe::size(): fcntl() failed"); 
			}
			else
			{
				printf("\nlinux_pinout_named_pipe::size(%d): sucess.\n", err);
			}
		}
	}
	
	virtual void flushoutput() { }
	
	private:

		bool silent;
		int fd;
};

#endif //linux_pinout_named_pipe_h
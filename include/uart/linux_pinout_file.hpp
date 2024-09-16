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


#ifndef _linux_pinout_file_h
#define _linux_pinout_file_h
#pragma once

#include <stdio.h>
#include <stdlib.h>
//~ #include <string.h>
//~ #include "format/printf.h"

#include "IUart.h"

class linux_pinout_file : public IUart
{
public:

	linux_pinout_file() : IUart(), fd(NULL) { }
	virtual ~linux_pinout_file() { deinit(); }

	virtual int init(const uint32_t ignored, const char* FileName)
	{
		deinit(); //close file if open
		
		printf("\nlinux_pinout_file::init() : opening file.\n");		
		
		fd = fopen(FileName, "ra+");
		if (NULL != fd) 
		{
			return(IUartOK);
		}
		else
		{
			return(-1);
		}
	}

	virtual void deinit()
	{
		if (NULL != fd) 
		{ 
			printf("\nlinux_pinout_file::deinit() : closing file.\n");		
			fclose(fd);
			fd = NULL;
		}
	}
	
	virtual void flushoutput()
	{
		if (NULL != fd) { fflush(fd); } 
	}
	
	
	virtual void purgeinput()
	{
		if (NULL != fd) { fseek(fd, 0, SEEK_SET); } 
	}
	
	virtual bool isopen() const
	{
		return(NULL != fd);
	}
	
	
	virtual bool dataready() const
	{
		if (NULL == fd) { return(false); }
		return(!feof(fd));
	}

	virtual char getcqq()
	{
		char c = 0;
		
		if (NULL != fd)
		{
			int numbytes = fread(&c, 1, 1, fd);
			if (1 != numbytes)
			{
				printf("\nlinux_pinout_file::getcqq(): read failed with %d.\n", numbytes);
				deinit();
			}
		}
		else
		{
			printf("\nlinux_pinout_file::getcqq(): read on uninitialized file; please open file!\n");
		}

  		return(c);
	}

	virtual char putcqq(char c)
	{
		if (NULL != fd)
		{
			int numbytes = fwrite(&c, 1, 1, fd);
			if (1 != numbytes)
			{
				printf("\nlinux_pinout_file::putcqq(): write failed with %d.\n", numbytes);
				deinit();
			}
		}
		else
		{
			printf("\nlinux_pinout_file::putcqq(): write on uninitialized file; please open file!\n");
		}

 		return (c);
	}
	
	private:

		FILE* fd;
};

#endif //linux_pinout_file_h

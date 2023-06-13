#include <stdio.h>
#include <string.h>

#include "formatf.h"

extern "C"
{
	#include "src/format.h"
	
	extern int stdio_hook_putc(int ch);

	//dump the chars to the display
	static void * stdout_func(void* unused, const char* buf, size_t n )
	{
		if (NULL == buf) { return(NULL); }
		
		for (size_t i = 0; i < n; i++) 
		{
			stdio_hook_putc(buf[i]);
		}

		return((void *)(n));
	}

	//dump the chars to a string
	static void * wrstr_func(void* p, const char* buf, size_t n )
	{
		#ifndef __linux__
		if ( (p < (void*)(0x40000000)) || (p > (void*)(0x40008000)) ) { printf("\n!formatf::wrstr_func(%p, %p, %lu)!\n", p, buf, (unsigned long)n); return((void*)((char*)p + n)); }
		#endif
			
		char* s = (char*)p;
			
		//~ //do nothing:
		//~ return ((void*)(s + n));			
		
		return ((void*)((char*)(memcpy( s, buf, n )) + n));
		
		//~ //this works also:
		//~ while (n--) { *s++ = *buf++; }    
		//~ return(s);
	}
	
	//dump the chars to a file
	static void * wrf_func(void* p, const char* buf, size_t n )
	{
		if ( (NULL == buf) || (NULL == p) ) { return(NULL); }
		
		FILE* f = (FILE*)p;
		
		for (size_t i = 0; i < n; i++) 
		{
			putc(buf[i], f);
		}

		return((void *)(n));
	}
	
	//printf()
	int formatf(const char *fmt, ... )
	{
		va_list arg;
		int done;
		
		va_start (arg, fmt);
		done = format(stdout_func, NULL, fmt, arg);
		va_end (arg);
		
		return done;
	}
	
	//sprintf()
	int sformatf(char* s, const char *fmt, ... )
	{
		//~ return(sprintf(s, fmt));
		va_list arg;
		int done;
		
		va_start ( arg, fmt );
		done = format( wrstr_func, s, fmt, arg );
		if ( 0 <= done ) { s[done] = '\0'; }
		va_end ( arg );
		
		return done;
	}
	
	//snprintf()
	int snformatf(char* str, size_t max, const char *fmt, ... )
	{
		va_list arg;
		int done;
		
		va_start (arg, fmt);
		done = format(wrstr_func, str, fmt, arg);
		va_end (arg);
		
		return done;
	}
	
	//fprintf()
	int fformatf(FILE* f, const char *fmt, ... )
	{
		va_list arg;
		int done;
		
		va_start (arg, fmt);
		done = format(wrf_func, f, fmt, arg);
		va_end (arg);
		
		return done;
	}
}
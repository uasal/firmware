#include <stdio.h>
#include <string.h>

#include "formatf.h"

extern "C"
{
	#include "src/format.h"
	
	//printf()
	int formatf(const char *fmt, ... )
	{
		va_list arg;
		int done;
		
		va_start (arg, fmt);
		done = vprintf(fmt, arg);
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
		done = vsprintf(s, fmt, arg);
		va_end ( arg );
		
		return done;
	}
	
	//snprintf()
	int snformatf(char* str, size_t max, const char *fmt, ... )
	{
		va_list arg;
		int done;
		
		va_start (arg, fmt);
		done = vsnprintf(str, max, fmt, arg);
		va_end (arg);
		
		return done;
	}
	
	//fprintf()
	int fformatf(FILE* f, const char *fmt, ... )
	{
		va_list arg;
		int done;
		
		va_start (arg, fmt);
		done = vfprintf(f, fmt, arg);
		va_end (arg);
		
		return done;
	}
}
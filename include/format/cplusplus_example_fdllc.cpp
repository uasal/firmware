extern "C"
{
	#ifndef __arm__
		#define __arm__ 7
	#endif
	#ifndef DBL_DIG
		#define DBL_DIG 16
	#endif

	#include "format/trunk/src/format_config.h"
	#include "format/trunk/src/format.h"
};


int main()
{
	int outf ( const char *fmt, ... )
	{
		va_list arg;
		int done;
		
		va_start ( arg, fmt );
		done = format( outfunc, NULL, fmt, arg );
		va_end ( arg );
		
		return done;
	}

	::outf("; %f,%f\n", (float)test, test1); //this locks up the processor with printf.
}
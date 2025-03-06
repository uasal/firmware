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

#include <limits.h>
#include <sched.h>
#include <unistd.h>
#include <pthread.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
//~ #include <sys/socket.h>
//~ #include <netinet/in.h>
#include <pthread.h>
#include <sched.h>
//~ #include <sys/mman.h>
#include <errno.h>
#include <dirent.h>

#include "dbg/memwatch.h"

#include "uart/CmdSystem.hpp"

//Define these in your program:
extern const Cmd AsciiCmds[];
extern const uint8_t NumAsciiCmds;

extern "C"
{
	int stdio_hook_putc(int c) { putchar(c); return(c); }
};

//Here's where we talk to stdin:
int linelen = 0;
bool newline = false;
const size_t linemaxlen = 512;
char line[linemaxlen];
pthread_mutex_t linelock;

void* StdInClientThread(void *argument);

void StartUserInterface()
{
	printf("\n\n: Start UI...");

	pthread_t thread;
	int rc;  
	printf("\nCreating stdin handler thread...");
	pthread_mutex_init(&linelock, NULL);
	rc = pthread_create(&thread, NULL, StdInClientThread, (void *)NULL);
	if (0 != rc) { printf("\nStartUserInterface::pthread_create returned %d.\n", rc); }
	
	printf("\nAvailable UI commands:\n");
	for (size_t i = 0; i < NumAsciiCmds; i++)
	{
		printf("\t%s\n", AsciiCmds[i].Name);
	}
}

bool ProcessUserInterface()
{
	bool DidSomething = false;
	
	//Listen for ascii commands from the keyboard (stdin), and send them out the uart to the 
	if (0 == pthread_mutex_trylock(&linelock))
	{
		if (newline)
		{
			ParseCmd(line, linelen, AsciiCmds, NumAsciiCmds, false);
			linelen = 0;
			line[0] = '\0';
			newline = false;
			DidSomething = true;
		}
		pthread_mutex_unlock(&linelock);
	}
	
	return(DidSomething);
}

void Wait50()
{
	#ifndef WIN32		
	//good practice to always wait at end of while(true) loops, in case something allows us to freerun, so we don't hog 100% cpu...
	struct timespec fiftymilliseconds;
	memset((char *)&fiftymilliseconds,0,sizeof(fiftymilliseconds));
	fiftymilliseconds.tv_nsec = 50000000;
	nanosleep(&fiftymilliseconds, NULL);
	#else
	sleep(50);
	#endif
}

void* StdInClientThread(void *argument)
{
	printf("\nStdInClientThread() started...\n");
	
	while(true)
	{
		char* pline = fgets(line, linemaxlen, stdin);
		if (pline)
		{
			linelen = strnlen(line, linemaxlen);
			for (int i = 0; i < linelen; i++) { if ('\r' == line[i]) { line[i] = '\n'; } } //bloody windows
			pthread_mutex_lock(&linelock);
			newline = true;
			pthread_mutex_unlock (&linelock);
			while (newline) { Wait50(); }
		}
		
		Wait50();
	}
	
	return(NULL);
}
	
//Required by ParseCmd()... 
char* strupr(char* s)
{
	if (NULL == s) { printf("\nstrupr() null.\n"); return(NULL); }
	
	for (size_t i = 0; i < linemaxlen; i++)
	{
		if ('\0' == s[i]) { break; }
		else { s[i] = toupper(s[i]); }
	}
	
	return(s);
}

void ParseConfigFile(const char* ConfigFileName)
{
	#ifndef WIN32		/* replace with: https://github.com/boldowa/mman-win32 when we have oodles of time on our hands... */
	char Line[4096 + 1];
	size_t BufPos = 0;
	size_t FileLen = 0;
	uint8_t* ParseConfigFileDataBuffer = NULL;

	int ParseFileHandle = open(ConfigFileName, O_RDONLY, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP); //O_NONBLOCK?
    if (((int)ParseFileHandle) < 0)
    {
        perror("\nMapParseConfigFileDataBuffer(): error in open(): ");
        return;
    }
    else
    {
		struct stat s;
		//~ int err = stat(ConfigFileName, &s);
		int err = fstat(ParseFileHandle, &s);
		if (0 != err)
        {
            perror("\nMapParseConfigFileDataBuffer(): error in stat(): ");
            return;
        }
        
		FileLen = s.st_size;

        ParseConfigFileDataBuffer = (uint8_t*)mmap(0, FileLen, PROT_READ, MAP_SHARED, (int)ParseFileHandle, 0);
        if (MAP_FAILED == ParseConfigFileDataBuffer)
        {
            ParseConfigFileDataBuffer = NULL;
            printf("\nMapParseConfigFileDataBuffer(%zu): error in mmap(%d): ", FileLen, errno);
            return;
        }
        else
        {
            printf("\nMapParseConfigFileDataBuffer(): Mapped at: %p; len: %zu.\n", ParseConfigFileDataBuffer, FileLen);
        }
    }

	printf("\n\nStartup configuration file %s opened, handle: %d, preparing to parse commands...\n", ConfigFileName, ParseFileHandle);

	//Start finding lines
	for (BufPos = 0; BufPos < FileLen; BufPos++)
	{
		//Find the end of the next line in the buffer
		uint8_t* c = (uint8_t*)memchr(&(ParseConfigFileDataBuffer[BufPos]), '\n', FileLen - BufPos);

		//~ printf("\nParseConfigFile(): found '\\n' in buffer at %lu.\n\n", (uint32_t)(c - snprintfBuffer));

		//done with this buffer:
		if (NULL == c) { break; }

		//Move into seperate buffer so parser can't muck us up...
		size_t LineLen = c - &(ParseConfigFileDataBuffer[BufPos]);
		if (LineLen > 4095) { LineLen = 4095; }
		memcpy(Line, &(ParseConfigFileDataBuffer[BufPos]), LineLen);
		Line[LineLen] = '\n';
		Line[LineLen + 1] = '\0';

		//~ printf("\nParseConfigFile::Line:\"%s\"\n\n", Line);

		ParseCmd(Line, LineLen, AsciiCmds, NumAsciiCmds, true, 0, 0);

		//~ printf("\nParseConfigFile(): new read position is %lu, start position at %lu.", BufPos, StartBufPos);

		BufPos = c - ParseConfigFileDataBuffer;
		//~ printf("\nParseConfigFile(): new read position is %lu.", BufPos);
	}

	int mmerr = munmap(ParseConfigFileDataBuffer, FileLen);
	if (0 != mmerr)
	{
		perror("\nParseConfigFile::munmap(err) : ");
	}

	close(ParseFileHandle);

	printf("\b\nParseConfigFile(%s): Complete.\n", ConfigFileName);
	#endif
}

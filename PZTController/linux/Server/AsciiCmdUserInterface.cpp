#include <limits.h>
#include <sched.h>
#include <unistd.h>
#include <pthread.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#ifdef WIN32
#include <windows.h>
#endif

#include "uart/CmdSystem.hpp"
#include "format/formatf.h"
#include "timing/ZongeHwTypes.h"
#include "ZenTypes.h"
#include "MainBuildNum"

#include "AsciiCmdUserInterface.h"

//Define these in your program:
extern const Cmd AsciiCmds[];
extern const uint8_t NumAsciiCmds;

//Here's where we talk to stdin:
int linelen = 0;
bool newline = false;
const size_t linemaxlen = 4096;
char line[linemaxlen];
pthread_mutex_t linelock;

void* StdInClientThread(void *argument);

void StartUserInterface()
{
	formatf("\n\nZenHardware: Start UI...");

	pthread_t thread;
	int rc;  
	printf("\nCreating stdin handler thread...");
	pthread_mutex_init(&linelock, NULL);
	rc = pthread_create(&thread, NULL, StdInClientThread, (void *)NULL);
	if (0 != rc) { printf("\npthread_create returned %d.\n", rc); }
	
	printf("\nAvailable UI commands:\n");
	for (size_t i = 0; i < NumAsciiCmds; i++)
	{
		printf("\t%s\n", AsciiCmds[i].Name);
	}
}

bool ProcessUserInterface()
{
	bool DidSomething = false;
	
	//Listen for ascii commands from the keyboard (stdin), and send them out the uart to the Zen
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
	#ifdef WIN32
	Sleep(50);
	#else
	//good practice to always wait at end of while(true) loops, in case something allows us to freerun, so we don't hog 100% cpu...
	struct timespec fiftymilliseconds;
	memset((char *)&fiftymilliseconds,0,sizeof(fiftymilliseconds));
	fiftymilliseconds.tv_nsec = 50000000;
	nanosleep(&fiftymilliseconds, NULL);
	#endif
}

void* StdInClientThread(void *argument)
{
	printf("\nZen457Server: StdInClientThread() started...\n");
	
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
	
int8_t ExitCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	formatf("\n\nExitCommand: Goodbye!\n\n\n\n");
	exit(0);
	
	return(ParamsLen);
}

int8_t AsciiVersionCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	formatf("Version: Global Revision: %s; build number: %d on: %s.\n", HGVERSION, BuildNum, BuildTimeStr);
	//~ formatf("Version: Global Revision: %s.\n", HGVERSION);
	
    return(strlen(Params));
}

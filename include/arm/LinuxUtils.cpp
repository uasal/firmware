#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <stdio.h>
#include <spawn.h> //posix_spawn()
#include <execinfo.h> //backtrace()

#include "LinuxUtils.h"

int CreateTempFolder(const char* s)
{
	if (0 != mkdir(s, S_IRUSR | S_IWUSR | S_IXUSR | S_IRGRP))
	{
		if (EEXIST != errno) //If it's there already from our last run, then fine.
		{
			printf("\nCreateTempFolder()::init() : error in mkdir(\"%s\"): %ld.\n", s, (long int)errno);					
			//~ perror();
			return(errno);
		}
	}
	
	return(0);
}

int spawn(const char* exe, const char* paramA, const char* paramB, const char* paramC, const char* paramD, const char* paramE, const char* paramF, const char* paramG)
{
	extern char **environ;
	pid_t pid = 0;
	char* _argv[] = { const_cast<char*>(exe), const_cast<char*>(paramA), const_cast<char*>(paramB), const_cast<char*>(paramC), const_cast<char*>(paramD), const_cast<char*>(paramE), const_cast<char*>(paramF), const_cast<char*>(paramG), NULL };
	//~ int err = posix_spawn(&pid, exe, NULL, NULL, reinterpret_cast<char* const*>(_argv), environ);
	int err = posix_spawn(&pid, exe, NULL, NULL, _argv, environ);
	//~ if (0 != err) { printf("posix_spawn: %s\n", strerror(errno)); }
	if (0 != err) { perror("\nposix_spawn: "); }
	else { printf("\nposix_spawn(\"%s\"): pid: %u\n", *_argv, (unsigned int)(pid)); } 
	return((int)pid);
}

//You can call this when something crashes or goes sideways to get a sense of where you were in the code...
void ShowCallStack(void* RealAddr)
{
  void *array[20];
  size_t size;
  //~ char **strings;
  //~ size_t i;

  size = backtrace(array, 20);
  printf("Obtained %zd stack frames.\n", size);
	
	//overwrite sigaction call stack with caller's address call stack
	//~ array[1] = RealAddr;
	//~ array[2] = RealAddr;

	//~ strings = backtrace_symbols(array, size);
  //~ for (i = 0; i < size; i++)
  //~ {
    //~ printf("%s\n", strings[i]);
	  
	  //~ addr2line(icky_global_program_name, (void*)frame.AddrPC.Offset);
  //~ }
  //~ free(strings);	
	
  backtrace_symbols_fd(array, size, 2);
}

//EOF

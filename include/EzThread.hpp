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
/// EzThread: a class for making threads that do stuff. Just derive a class from this one and fill in your own virtual Process(), OneHzRoutines(), and TenHzRoutines(), then call Init() somewhere in main().

#ifndef _EzThread_h
#define _EzThread_h
#pragma once

#include <stdint.h>
#include <errno.h>
#include <unistd.h>
#include <pthread.h> //Must use "-lpthread linker cmd
#include <sys/time.h>
#include <sys/types.h>
#include <sys/syscall.h>
#include "Delay.h"

//A class for making threads that do stuff. Just derive a class from this one and fill in your own virtual Process(), OneSecondRoutines(), and TenHzRoutines(), then call Init() somewhere in main().
class EzThread
{

public:

	EzThread() : BoredDelayuS(500000), MinimumDelayuS(1000) { strcpy(ThreadName, "EzThreadGeneric"); }
	virtual ~EzThread() { }
	
	//This gets called by the thread once; call things like nice() here.
	virtual void ThreadInit() { }	
	//If this returns true, the thread will not sleep but will call Process() continuously. This can overload the CPU.
	virtual bool Process() { return(false); }
	//Called every second:
	virtual void OneSecondRoutines() { }
	//Called ten times per second:
	virtual void TenHzRoutines() { }
	
	pthread_t Thread;
	size_t BoredDelayuS;
	size_t MinimumDelayuS;
	char ThreadName[256];
	
	//Call this to start the thread!
	void Init() 
	{
		printf("\nEzThread(%s): launching...", ThreadName);
		//~ if (0 != pthread_create(&Thread, NULL, EzThreadFunc, (void*)this))
		if (0 != pthread_create(&Thread, NULL, EzThreadFunc, (void*)this))
		{ 
			perror("\nEzThread: pthread_create() error: "); 
		}
	}
	
	static void* EzThreadFunc(void *pthis)
	{
		//~ printf("\nEzThread: EzThreadFunc(%p).\n", pthis);
		//~ fflush(stdout);
		
		if (NULL == pthis) { return(0); }
		//~ EzThread* Me = reinterpret_cast<EzThread*>(pthis);
		EzThread* Me = reinterpret_cast<EzThread*>(pthis);
		
		pid_t tid = syscall(SYS_gettid);
		printf("\nEzThread(%s): launched! ID: %d", Me->ThreadName, tid);
		
		Me->ThreadInit();
		
		timespec tNow;
		tNow.tv_sec = 0;
		tNow.tv_nsec = 0;
		timespec tLastSecond;
		tLastSecond.tv_sec = 0;
		tLastSecond.tv_nsec = 0;
		timespec tLastSubSecond;
		tLastSubSecond.tv_sec = 0;
		tLastSubSecond.tv_nsec = 0;
		
		bool Bored = true;
		
		while(true)
		{
			Bored = true;
		
			//~ printf("\nEzThread(%s): Process(%p).\n", Me->ThreadName, Me);
			
			//Here's our high-speed process function, call it on every loop!
			if (Me->Process()) { Bored = false; }
			
			//~ printf("\nEzThread(%s): gettimeofday.\n", Me->ThreadName);
			
			//Keep track of the time and run the timed processes:
			int err = clock_gettime(CLOCK_MONOTONIC, &tNow);
			if (0 == err)
			{
				uint64_t Now = ((uint64_t)tNow.tv_sec * 1000000000ULL) + (uint64_t)tNow.tv_nsec;
				uint64_t LastSecond = ((uint64_t)tLastSecond.tv_sec * 1000000000ULL) + (uint64_t)tLastSecond.tv_nsec;
				uint64_t LastSubSecond = ((uint64_t)tLastSubSecond.tv_sec * 1000000000ULL) + (uint64_t)tLastSubSecond.tv_nsec;

				if (Now > (LastSubSecond + 100000000ULL)) { Me->TenHzRoutines(); memcpy(&tLastSubSecond, &tNow, sizeof(timespec)); }
				if (Now > (LastSecond + 1000000000ULL)) { Me->OneSecondRoutines(); memcpy(&tLastSecond, &tNow, sizeof(timespec)); }
				
				//Weird errors we need to catch:
				if (LastSubSecond > Now) { /* printf("\nEzThread(%s): LastSubSecond error! %llu\n", Me->ThreadName, LastSubSecond); */ memcpy(&tLastSubSecond, &tNow, sizeof(timespec)); }
				if (LastSecond > Now) { /* printf("\nEzThread(%s): LastSecond error! %llu\n", Me->ThreadName, LastSecond); */ memcpy(&tLastSecond, &tNow, sizeof(timespec)); }
			}

			//give up our timeslice so as not to bog the system:
			if (Bored) { delayus(Me->BoredDelayuS); } else { delayus(Me->MinimumDelayuS); }
		}
		
		return(0);		
	}
};

#endif //_EzThread_h

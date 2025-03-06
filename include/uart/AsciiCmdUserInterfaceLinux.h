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

#pragma once

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

#include "uart/CmdSystem.hpp"

//Define these in your program:
extern const Cmd AsciiCmds[];
extern const uint8_t NumAsciiCmds;

void* StdInClientThread(void *argument);

void StartUserInterface();

bool ProcessUserInterface();

void ParseConfigFile(const char* ConfigFileName);

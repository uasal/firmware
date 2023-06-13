/*
** MEMWATCH.C
** Nonintrusive ANSI C memory leak / overwrite detection
** Copyright (C) 1992-2003 Johan Lindh
** All rights reserved.
** Version 2.71

	This file is part of MEMWATCH.

    MEMWATCH is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    MEMWATCH is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with MEMWATCH; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

**
** 920810 JLI   [1.00]
** 920830 JLI   [1.10 double-free detection]
** 920912 JLI   [1.15 mwPuts, mwGrab/Drop, mwLimit]
** 921022 JLI   [1.20 ASSERT and VERIFY]
** 921105 JLI   [1.30 C++ support and TRACE]
** 921116 JLI   [1.40 mwSetOutFunc]
** 930215 JLI   [1.50 modified ASSERT/VERIFY]
** 930327 JLI   [1.51 better auto-init & PC-lint support]
** 930506 JLI   [1.55 MemWatch class, improved C++ support]
** 930507 JLI   [1.60 mwTest & CHECK()]
** 930809 JLI   [1.65 Abort/Retry/Ignore]
** 930820 JLI   [1.70 data dump when unfreed]
** 931016 JLI   [1.72 modified C++ new/delete handling]
** 931108 JLI   [1.77 mwSetAssertAction() & some small changes]
** 940110 JLI   [1.80 no-mans-land alloc/checking]
** 940328 JLI   [2.00 version 2.0 rewrite]
**              Improved NML (no-mans-land) support.
**              Improved performance (especially for free()ing!).
**              Support for 'read-only' buffers (checksums)
**              ^^ NOTE: I never did this... maybe I should?
**              FBI (free'd block info) tagged before freed blocks
**              Exporting of the mwCounter variable
**              mwBreakOut() localizes debugger support
**              Allocation statistics (global, per-module, per-line)
**              Self-repair ability with relinking
** 950913 JLI   [2.10 improved garbage handling]
** 951201 JLI   [2.11 improved auto-free in emergencies]
** 960125 JLI   [X.01 implemented auto-checking using mwAutoCheck()]
** 960514 JLI   [2.12 undefining of existing macros]
** 960515 JLI   [2.13 possibility to use default new() & delete()]
** 960516 JLI   [2.20 suppression of file flushing on unfreed msgs]
** 960516 JLI   [2.21 better support for using MEMWATCH with DLL's]
** 960710 JLI   [X.02 multiple logs and mwFlushNow()]
** 960801 JLI   [2.22 merged X.01 version with current]
** 960805 JLI   [2.30 mwIsXXXXAddr() to avoid unneeded GP's]
** 960805 JLI   [2.31 merged X.02 version with current]
** 961002 JLI   [2.32 support for realloc() + fixed STDERR bug]
** 961222 JLI   [2.40 added mwMark() & mwUnmark()]
** 970101 JLI   [2.41 added over/underflow checking after failed ASSERT/VERIFY]
** 970113 JLI   [2.42 added support for PC-Lint 7.00g]
** 970207 JLI   [2.43 added support for strdup()]
** 970209 JLI   [2.44 changed default filename to lowercase]
** 970405 JLI   [2.45 fixed bug related with atexit() and some C++ compilers]
** 970723 JLI   [2.46 added MW_ARI_NULLREAD flag]
** 970813 JLI   [2.47 stabilized marker handling]
** 980317 JLI   [2.48 ripped out C++ support; wasn't working good anyway]
** 980318 JLI   [2.50 improved self-repair facilities & SIGSEGV support]
** 980417 JLI	[2.51 more checks for invalid addresses]
** 980512 JLI	[2.52 moved MW_ARI_NULLREAD to occur before aborting]
** 990112 JLI	[2.53 added check for empty heap to mwIsOwned]
** 990217 JLI	[2.55 improved the emergency repairs diagnostics and NML]
** 990224 JLI	[2.56 changed ordering of members in structures]
** 990303 JLI	[2.57 first maybe-fixit-for-hpux test]
** 990516 JLI	[2.58 added 'static' to the definition of mwAutoInit]
** 990517 JLI	[2.59 fixed some high-sensitivity warnings]
** 990610 JLI	[2.60 fixed some more high-sensitivity warnings]
** 990715 JLI	[2.61 changed TRACE/ASSERT/VERIFY macro names]
** 991001 JLI	[2.62 added CHECK_BUFFER() and mwTestBuffer()]
** 991007 JLI	[2.63 first shot at a 64-bit compatible version]
** 991009 JLI	[2.64 undef's strdup() if defined, mwStrdup made const]
** 000704 JLI	[2.65 added some more detection for 64-bits]
** 010502 JLI   [2.66 incorporated some user fixes]
**              [mwRelink() could print out garbage pointer (thanks mac@phobos.ca)]
**				[added array destructor for C++ (thanks rdasilva@connecttel.com)]
**				[added mutex support (thanks rdasilva@connecttel.com)]
** 010531 JLI	[2.67 fix: mwMutexXXX() was declared even if MW_HAVE_MUTEX was not defined]
** 010619 JLI	[2.68 fix: mwRealloc() could leave the mutex locked]
** 020918 JLI	[2.69 changed to GPL, added C++ array allocation by Howard Cohen]
** 030212 JLI	[2.70 mwMalloc() bug for very large allocations (4GB on 32bits)]
** 030520 JLI	[2.71 added ULONG_LONG_MAX as a 64-bit detector (thanks Sami Salonen)]
*/

#include "memwatch.h"

extern int      mwInited;
extern int      mwUseAtexit;

/**********************************************************************
** C++ new & delete
**********************************************************************/

//~ #if 0 /* 980317: disabled C++ */

#ifdef __cplusplus
//~ #ifndef MEMWATCH_NOCPP

int mwNCur = 0;
const char *mwNFile = NULL;
int mwNLine = 0;

MemWatch::MemWatch() {
    if( mwInited ) return;
    mwUseAtexit = 0;
    mwInit();
    }

MemWatch::~MemWatch() {
    if( mwUseAtexit ) return;
    mwTerm();
    }

/*
** This global new will catch all 'new' calls where MEMWATCH is
** not active.
*/
void* operator new( unsigned size ) {
    mwNCur = 0;
    return mwMalloc( size, "<unknown>", 0 );
    }

/*
** This is the new operator that's called when a module uses mwNew.
*/
void* operator new( unsigned size, const char *file, int line ) {
    mwNCur = 0;
    return mwMalloc( size, file, line );
    }

/*
** This is the new operator that's called when a module uses mwNew[].
** -- hjc 07/16/02
*/
void* operator new[] ( unsigned size, const char *file, int line ) {
    mwNCur = 0;
    return mwMalloc( size, file, line );
    }

/*
** Since this delete operator will recieve ALL delete's
** even those from within libraries, we must accept
** delete's before we've been initialized. Nor can we
** reliably check for wild free's if the mwNCur variable
** is not set.
*/
void operator delete( void *p ) noexcept (true) {
    if( p == NULL ) return;
    if( !mwInited ) {
        free( p );
        return;
        }
    if( mwNCur ) {
        mwFree( p, mwNFile, mwNLine );
        mwNCur = 0;
        return;
        }
    mwFree_( p );
    }

void operator delete[]( void *p ) noexcept (true) {
    if( p == NULL ) return;
    if( !mwInited ) {
        free( p );
        return;
        }
    if( mwNCur ) {
        mwFree( p, mwNFile, mwNLine );
        mwNCur = 0;
        return;
        }
    mwFree_( p );
    }

//~ #endif /* MEMWATCH_NOCPP */
#endif /* __cplusplus */

//~ #endif /* 980317: disabled C++ */

/* MEMWATCH.C */

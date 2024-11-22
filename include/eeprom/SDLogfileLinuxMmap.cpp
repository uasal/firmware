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
/// \file
/// $Source: /raincloud/src/projects/include/eeprom/SDLogfile.cpp,v $
/// $Revision: 1.15 $
/// $Date: 2010/02/22 22:08:15 $
/// $Author: steve $

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <pthread.h>
#include <sched.h>
#include <sys/mman.h>
#include <errno.h>
#include <dirent.h>

#include <format/formatf.h>

#include "SDLogfileLinuxMmap.hpp"

SDLogfileLinuxMmap::SDLogfileLinuxMmap() :
    SDCardPresent(true),
    LogFileOpen(false),
    SDLogfileLinuxMmapDataBuffer(NULL),
    SDLogfileLinuxMmapDataBufferPos(0),
    //~ SDLogfileLinuxMmapMapLen(1 * 1024 * 1024),
    //~ SDLogfileLinuxMmapMapFileGrowSize(1024 * 1024), //How much do we alloc every time we pass the end of the file?
    //~ SDLogfileLinuxMmapMapFileGrowSize(32768), //How much do we alloc every time we pass the end of the file?
    SDLogfileLinuxMmapMapFileLen(0)
{ }

SDLogfileLinuxMmap::~SDLogfileLinuxMmap()
{
    Close();
}

bool SDLogfileLinuxMmap::InitSDCard()
{
    return(true);
}

bool SDLogfileLinuxMmap::InitLogFile(const char* LogFileName, const char* Mode)
{
    //Make sure to close file if it's open...
    if (LogFileOpen)
    {
        printf("\nSDLogfileLinuxMmap::Init() : Warning - logfile was open, writing & closing before re-init...\n");
        Close();
    }

	//Ok, reset to closed!
	SDLogfileLinuxMmapDataBuffer = NULL;
	LogFileOpen = false;
	
	//Open file:
    SDLogfileHandle = (FILE*)open(LogFileName, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP); //O_NONBLOCK?
    if (((int)SDLogfileHandle) < 0)
    {
        SDLogfileHandle = NULL;
        printf("\nMapSDLogfileLinuxMmapDataBuffer(): error in open(/dev/mem): %ld.\n", (long int)errno);
        return(false);
    }
    else
    {
        //Reset file size:
        SDLogfileLinuxMmapMapFileLen = SDLogfileLinuxMmapMapFileGrowSize;
        int ft = ftruncate((int)SDLogfileHandle, SDLogfileLinuxMmapMapFileLen);  //Make sure the file is big enough for all read/writes to mmap
        if (ft < 0)
        {
			close((int)SDLogfileHandle);
            perror("\nMapSDLogfileLinuxMmapDataBuffer(): error in ftruncate() ");
            SDLogfileHandle = NULL;
            return(false);
        }

		//Create mmap to file:
        SDLogfileLinuxMmapDataBuffer = (size_t*)mmap(0, SDLogfileLinuxMmapMapFileLen, PROT_READ | PROT_WRITE, MAP_SHARED, (int)SDLogfileHandle, 0);
        if (MAP_FAILED == SDLogfileLinuxMmapDataBuffer)
        {
			close((int)SDLogfileHandle);
			SDLogfileHandle = NULL;
            SDLogfileLinuxMmapDataBuffer = NULL;
            printf("\nMapSDLogfileLinuxMmapDataBuffer(): error in mmap(): %ld.\n", (long int)errno);
            return(false);
        }
        else
        {
            printf("\nMapSDLogfileLinuxMmapDataBuffer(): Mapped at: %p.\n", SDLogfileLinuxMmapDataBuffer);
        }

        SDLogfileLinuxMmapDataBufferPos = 0;
    }

	formatf ("\nSDLogfileLinuxMmap::Init() : Logfile opened.\n");
	LogFileOpen = true;
	strncpy(FileName, LogFileName, MaxFileNameLen);

    return(LogFileOpen);
}

bool SDLogfileLinuxMmap::InitLogfile(const char* LogFileName)
{
    return(InitLogFile(LogFileName, "w+b"));
}

bool SDLogfileLinuxMmap::InitLogfileAppend(const char* LogFileName)
{
    return(InitLogFile(LogFileName, "a+b"));
}

bool SDLogfileLinuxMmap::InitLogfileReadOnly(const char* LogFileName)
{
    return(InitLogFile(LogFileName, "rb"));
}

void SDLogfileLinuxMmap::Eject() { Close(); }

bool SDLogfileLinuxMmap::Log(const void* src, const size_t len, const bool flushwhenfull)
{
    if ( (!LogFileOpen) || (NULL == SDLogfileLinuxMmapDataBuffer) )
    {
        printf("\nSDLogfileLinuxMmap::Log() : Cannot write, file not open...\n");
        return(false);
    }

    //Do we have space in the file?
    if ((SDLogfileLinuxMmapDataBufferPos + len) >= SDLogfileLinuxMmapMapFileLen)
    {
        //Alloc another chunk...
        SDLogfileLinuxMmapMapFileLen += SDLogfileLinuxMmapMapFileGrowSize;

        //~ printf("\nSDLogfileLinuxMmap::Log() : Growing mmap() backing file to: %u bytes.\n", SDLogfileLinuxMmapMapFileLen);

        int ft = ftruncate((int)SDLogfileHandle, SDLogfileLinuxMmapMapFileLen);  //Make sure the file is big enough for all read/writes to mmap
        if (ft < 0)
        {
			Close();
            SDLogfileLinuxMmapDataBuffer = NULL;
			SDLogfileHandle = NULL;
			LogFileOpen = false;
            perror("\nMapSDLogfileLinuxMmapDataBuffer(): error in ftruncate() ");
            return(false);
        }
		
		SDLogfileLinuxMmapDataBuffer = (size_t*)mremap(SDLogfileLinuxMmapDataBuffer, SDLogfileLinuxMmapMapFileLen - SDLogfileLinuxMmapMapFileGrowSize, SDLogfileLinuxMmapMapFileLen, MREMAP_MAYMOVE);
		if (MAP_FAILED == SDLogfileLinuxMmapDataBuffer)
		{
			Close();
			SDLogfileLinuxMmapDataBuffer = NULL;
			SDLogfileHandle = NULL;
			LogFileOpen = false;
            perror("\nMapSDLogfileLinuxMmapDataBuffer(): error in mremap() ");
			return(false);
		}
    }

    //~ printf("\nSDLogfileLinuxMmap::Log(%u @ %u -> %p).\n", len, SDLogfileLinuxMmapDataBufferPos, SDLogfileLinuxMmapDataBuffer);
    
    //write...
    uint8_t* dest = (uint8_t*)SDLogfileLinuxMmapDataBuffer;
    memcpy(&(dest[SDLogfileLinuxMmapDataBufferPos]), src, len);
    SDLogfileLinuxMmapDataBufferPos += len;

    return(true);
}

bool SDLogfileLinuxMmap::LogBuffered(const void* src, const size_t size, const uint8_t bufferpadvalue, const bool flushwhenfull)
{
    return(Log(src, size, flushwhenfull));
}

size_t SDLogfileLinuxMmap::Read(uint8_t* Buffer, const size_t Len)
{
    //~ if (!LogFileOpen)
    //~ {
    //~ printf("SDLogfileLinuxMmap::Log() : Cannot read, file not open...\n");
    //~ return(0);
    //~ }

    //~ size_t numbytesread = fread(Buffer, 1, Len, SDLogfileHandle);
    //~ if (numbytesread != Len)
    //~ {
    //~ printf("SDLogfileLinuxMmap::Log() : Error reading from logfile, was the end-of-file reached/passed? (bytes read: %u; should have been: %lu)\n", (uint32_t)numbytesread, (long unsigned int)Len);
    //~ Close();
    //~ }

    //~ return(numbytesread);
    return(0);
}

bool SDLogfileLinuxMmap::Seek(const size_t Len)
{
    //~ if (!LogFileOpen)
    //~ {
    //~ printf("SDLogfileLinuxMmap::Read() : No card or file not open: nothing to read! (card present: %u, handle: %lu)...\n", SDCardPresent, (long unsigned int)SDLogfileHandle);
    //~ return(false);
    //~ }

    //~ uint8_t Seeked = fseek(SDLogfileHandle, Len, 0);
    //~ if (0 != Seeked)
    //~ {
    //~ printf("SDLogfileLinuxMmap::Seek() : Error seeking (0x%.4X [%u]), please reinsert card & re-initialize!\n", Seeked, Seeked);
    //~ Close();
    //~ return(false);
    //~ }
    return(true);
}

void SDLogfileLinuxMmap::Flush()
{
    msync(SDLogfileLinuxMmapDataBuffer, SDLogfileLinuxMmapDataBufferPos, MS_ASYNC);
    //~ fsync((int)SDLogfileHandle);
}

bool SDLogfileLinuxMmap::IsOpen()
{
    return(LogFileOpen && (NULL != SDLogfileLinuxMmapDataBuffer));
}

void SDLogfileLinuxMmap::Close()
{
    if (LogFileOpen)
    {
		LogFileOpen = false; //Set this very first so nothing blows up when multithreaded! This will block other threads from trying to write when we close the file!

        printf("\nSDLogfileLinuxMmap::munmap()\n");
        //~ msync(SDLogfileLinuxMmapDataBuffer, SDLogfileLinuxMmapDataBufferPos, MS_SYNC);
        int err = munmap(SDLogfileLinuxMmapDataBuffer, SDLogfileLinuxMmapMapFileLen); //unmap the max!!!
        if (0 != err)
        {
            perror("\nSDLogfileLinuxMmap::munmap(err) : ");
        }
		SDLogfileLinuxMmapMapFileLen = 0;
        SDLogfileLinuxMmapDataBuffer = NULL;
        
        if (0 != SDLogfileLinuxMmapDataBufferPos)
        {
            //~ printf("\nSDLogfileLinuxMmap::truncate()\n");
            int ft = ftruncate((int)SDLogfileHandle, SDLogfileLinuxMmapDataBufferPos); //Make the file exactly as big as the actual data it contains when closing...
            if (ft < 0)
            {
                perror("\nMapSDLogfileLinuxMmapDataBuffer(): error in ftruncate() ");
                SDLogfileHandle = NULL;
            }
        }
		SDLogfileLinuxMmapDataBufferPos = 0;
        
        printf("\nSDLogfileLinuxMmap::close()\n");
        //~ fsync((int)SDLogfileHandle);
        close((int)SDLogfileHandle);
		SDLogfileHandle = NULL;
    }
}

bool SDLogfileLinuxMmap::FileExists(const char* filename)
{
    FILE* file = fopen(const_cast<char*>(filename), "r");
    if (NULL != file)
    {
        fclose(file);
        return(true);
    }
    //~ printf("SDLogfileLinuxMmap::FileExists() : No match on %s; FindName returned: %u [0x%.2X]\n", FileName, match, match);
    return(false);
}

void SDLogfileLinuxMmap::ShowStatus()
{
    printf("SDLogfileLinuxMmap::ShowStatus() : Card present: %c, Logfile open: %c\n", SDCardPresent?'Y':'N', (LogFileOpen)?'Y':'N');
}

void SDLogfileLinuxMmap::ListFilesOnCard()
{
    DIR           *d;
    struct dirent *dir;
	size_t numfiles = 0;
	size_t numbytes = 0;
	
    d = opendir(".");
    if (d)
    {
        while ((dir = readdir(d)) != NULL)
        {
            if (dir->d_type == DT_REG)
            {
				numfiles++;				
				struct stat st;
				int err = stat(dir->d_name, &st);
				if (0 == err)
				{
					numbytes += st.st_size;
					struct tm* fdate = gmtime(&(st.st_mtim.tv_sec));
					if (NULL != fdate)
					{
						formatf("----- ");
						formatf("%u/%02u/%02u ", fdate->tm_year + 1900, fdate->tm_mon + 1, fdate->tm_mday);
						formatf("%02u:%02u; %9lu; ", fdate->tm_hour, fdate->tm_min, st.st_size);
						formatf("%s; %s\n", dir->d_name, dir->d_name);
					}
				}
            }
        }
		
		formatf("%4u File(s),%10lu bytes total\n", numfiles, numbytes);
		//~ FATFS* pFat = 0;
		//~ res = f_getfree("", (DWORD*)&p1, &pFat);
		//~ if (res == FR_OK)
		//~ {
			//~ formatf(", %10lu bytes free\n", p1 * pFat->csize * 512);
		//~ }

        closedir(d);
    }
}

size_t SDLogfileLinuxMmap::NumFiles(const char* dirname, const char* mask)
{
    DIR           *d;
    struct dirent *dir;
	size_t numfiles = 0;
	d = opendir(dirname);
    if (d)
    {
        while ((dir = readdir(d)) != NULL)
        {
            if (dir->d_type == DT_REG)
            {
				if (NULL != mask)
				{
					if (strstr(dir->d_name, mask))
					{
						numfiles++;				
					}
				}
				else
				{
					numfiles++;				
				}
            }
        }
	}
	closedir(d);
		
	return(numfiles);
}

DIR *SDLogfileLinuxMmapListFileDir;

uint32_t SDLogfileLinuxMmap::ListFilesPrep()
{
	SDLogfileLinuxMmapListFileDir = opendir(".");
	if (NULL == SDLogfileLinuxMmapListFileDir) { return(errno); }    
    return(0);
}

uint32_t SDLogfileLinuxMmap::ListNextFile(void* f_info, size_t maxlen)
{
	if (NULL == SDLogfileLinuxMmapListFileDir) { return(ENOENT); }    
	if ((NULL == f_info) || (maxlen < sizeof(struct dirent))) { return(EINVAL); }    
	
	struct dirent *dir;	
	while ((dir = readdir(SDLogfileLinuxMmapListFileDir)) != NULL)
	{
		if (dir->d_type == DT_REG)
		{
			memcpy(f_info, dir, sizeof(struct dirent));
			return(0);
		}
	}
	
	closedir(SDLogfileLinuxMmapListFileDir);			
    return(ENOENT);
}

void SDLogfileLinuxMmap::ReOpen()
{
    if (LogFileOpen)
    {
        Close();
    }

    InitLogfile(FileName);

    formatf ("SDLogfileMultiFat::ReOpen() : Complete.\n");
}

uint32_t SDLogfileLinuxMmap::FileSize()
{
    //~ struct stat s;
    //~ int err = stat(FileName, &s);
    //~ return(err == 0 ? s.st_size : -1);

    return(SDLogfileLinuxMmapDataBufferPos);
}

void SDLogfileLinuxMmap::TestSD() { }

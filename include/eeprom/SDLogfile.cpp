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

extern "C"
{
	#include "./MultiFat/mmc_spi.h"
	#include "./MultiFat/dos.h"
	#include "./MultiFat/fat.h"
	#include "./MultiFat/rtc.h"
};

#include "format/formatf.h"

#include "SDLogfile.hpp"

bool SDLogfile::SDCardPresent = false;

SDLogfile::SDLogfile() : DataLogSectorSize(512)
{
	SDLogfileHandle = MAX_OPEN_FILE;
	memset(DataLogSector, 0xCD, DataLogSectorSize * sizeof(uint8_t));
	DataLogSectorPos = 0;

}

SDLogfile::~SDLogfile()
{
	Close();
}

bool SDLogfile::InitSDCard()
{
	MMC_FIO_Init();

	const unsigned char timeout = 10;
	unsigned char i = 0;
	for (i = 0; i < timeout; i++)
	{
		if (F_OK == GetDriveInformation()) { break; }
	}
	
	if (i >= timeout)
    {
        formatf ("SDLogfile::Init() : MMC/SD-Card not found or not formatted!\n");
		
		SDCardPresent = false;
        return(false);
    }
	
	SDCardPresent = true;
	return(true);
}

bool SDLogfile::InitLogfile(const char* LogFileName)
{	
	//Make sure to close file if it's open...
	if (SDLogfileHandle < MAX_OPEN_FILE)
	{
		::formatf("SDLogfile::Init() : Warning - logfile was open, writing & closing before re-init...\n");
        Fclose(SDLogfileHandle);
		SDLogfileHandle = MAX_OPEN_FILE;
	}

	//Make sure to initialize card if someone calls this blind...
	if (!SDCardPresent) 
	{
		bool Sucess = InitSDCard();
		if (!Sucess) 
		{ 
			formatf ("SDLogfile::InitLogfile() : Card won't initialize, can't open logfile.\n");
			return(false); 
		} 
		else
		{
			formatf ("SDLogfile::Init() : Card initialized.\n");
		}
	}
	
	SDLogfileHandle = Fopen(const_cast<char*>(LogFileName), F_APPEND); //Bugfixed: F_WRITE | F_APPEND gets interpreted as F_WRITE only, unlike mature filesystems....

	if (SDLogfileHandle < MAX_OPEN_FILE)
	{
		formatf ("SDLogfile::Init() : Logfile opened, handle=%lu.\n", SDLogfileHandle);
		SDCardPresent = true;
		return(true); 
	}		
	else
	{
		formatf ("Open %s failed with: %lu.\n", LogFileName, SDLogfileHandle);
	}				
	return(false); 
}

void SDLogfile::Eject()
{
	//Static function can't close files for each instance, unfortunately...
	//~ //Make sure to close file if it's open...
	//~ if (SDLogfileHandle < MAX_OPEN_FILE)
    //~ {
        //~ Fclose(SDLogfileHandle);
		//~ SDLogfileHandle = MAX_OPEN_FILE;
	//~ }
	
	SDCardPresent = false;
}

bool SDLogfile::Log(const void* src, const size_t len, const bool flushwhenfull)
{
	if ( (!SDCardPresent) || (SDLogfileHandle >= MAX_OPEN_FILE) ) 
	{ 
		::formatf("SDLogfile::Log() : Please insert SD card & initialize (card present: %u, handle: %lu)...\n", SDCardPresent, SDLogfileHandle); 
		return(false);
	}
		
	//write...
	size_t numbyteswritten = Fwrite((U8*)const_cast<void*>(src), len, SDLogfileHandle);
	if (numbyteswritten != len)
	{
		::formatf("SDLogfile::Log() : Error writing to logfile, please reinsert card & re-initialize! (bytes written: %lu; should have been: %lu)\n", (uint32_t)numbyteswritten, (uint32_t)len); 
		Fclose(SDLogfileHandle);
		SDLogfileHandle = MAX_OPEN_FILE;
		return(false);
	}
	else
	{
		//~ #ifdef DEBUG_SD
		//~ ::formatf("Logged.\n");
		//~ #endif
	}
	
	//We oughtta flush every so often...
	DataLogSectorPos += len;
	if ( (flushwhenfull) && (DataLogSectorPos >= DataLogSectorSize) )
	{
		//Warning!  This never appears to flush!  Debug needed!  (Probably due to underlying buffering arch in lib?)
		Flush();
		DataLogSectorPos %= DataLogSectorSize;
	}
	
	return(true);
}

bool SDLogfile::LogBuffered(const void* src, const size_t size, const uint8_t bufferpadvalue, const bool flushwhenfull)
{
	bool Sucess = false;
	
	//This is really a pointless operation if logging more than a sector at a time, and will cause pointer crash.
	if (size >= DataLogSectorSize) 
	{
		return(false);
	}

	//Room in buffer for string?
	if ( (DataLogSectorPos + size) < DataLogSectorSize)
	{
		memcpy(&(DataLogSector[DataLogSectorPos]), src, size);
		DataLogSectorPos += size;
		Sucess = true;
	}	
	else //No room - write & clear buffer
	{
		//Pad buffer
		for (size_t pos = DataLogSectorPos; pos < DataLogSectorSize; pos++)
		{
			DataLogSector[pos] = bufferpadvalue;
		}

		//Write buffer
		Sucess = Log(DataLogSector, DataLogSectorSize);
		if (flushwhenfull)
		{
			Flush();
		}

		//Reset buffer
		DataLogSectorPos = 0;
		DataLogSector[0] = '\0';
		
		//Stick current data that didn't fit into 'new' buffer:
		memcpy(&(DataLogSector[0]), src, size);
		DataLogSectorPos += size;
	}

	return(Sucess);
}

size_t SDLogfile::Read(uint8_t const* Buffer, const size_t Len)
{
	if ( (!SDCardPresent) || (SDLogfileHandle >= MAX_OPEN_FILE) ) 
	{ 
		::formatf("SDLogfile::Read() : No card or file not open: nothing to read! (card present: %u, handle: %lu)...\n", SDCardPresent, SDLogfileHandle); 
		return(false);
	}
	
	size_t numbytesread = Fread(reinterpret_cast<U8*>(const_cast<uint8_t*>(Buffer)), Len, SDLogfileHandle);
	return(numbytesread);
}

bool SDLogfile::Seek(const size_t Len)
{
	if ( (!SDCardPresent) || (SDLogfileHandle >= MAX_OPEN_FILE) ) 
	{ 
		::formatf("SDLogfile::Read() : No card or file not open: nothing to read! (card present: %u, handle: %lu)...\n", SDCardPresent, SDLogfileHandle); 
		return(false);
	}
	
	uint8_t Seeked = Fseek(Len, SEEK_SET, SDLogfileHandle);
	if (0 != Seeked)
	{
		::formatf("SDLogfile::Seek() : Error seeking (0x%.4X [%u]), please reinsert card & re-initialize!\n", Seeked, Seeked); 
		Fclose(SDLogfileHandle);
		SDLogfileHandle = MAX_OPEN_FILE;
		return(false);
	}
	else
	{
		//~ #ifdef DEBUG_SD
		//~ ::formatf("Read ok.\n");
		//~ #endif
	}
	return(true);
}

void SDLogfile::Flush()
{
	if (SDLogfileHandle < MAX_OPEN_FILE)
    {
        Fflush(SDLogfileHandle);
	}
	
	DataLogSectorPos = 0;
}

bool SDLogfile::IsOpen() { return(SDLogfileHandle < MAX_OPEN_FILE); }

void SDLogfile::Close()
{
	if (SDLogfileHandle < MAX_OPEN_FILE)
    {
        Fflush(SDLogfileHandle);
		Fclose(SDLogfileHandle);		
	}

	SDLogfileHandle = MAX_OPEN_FILE;
	
	DataLogSectorPos = 0;
}

bool SDLogfile::FileExists(const char* FileName)
{
	uint8_t match = FindName83(const_cast<char*>(FileName));
	if (FULL_MATCH == match) 
	{ 
		return(true); 
	}
	//~ ::formatf("SDLogFile::FileExists() : No match on %s; FindName returned: %u [0x%.2X]\n", FileName, match, match);
	return(false);
}

void SDLogfile::ShowStatus()
{
	::formatf("SDLogfile::ShowStatus() : Card present: %c, Logfile open: %c\n", SDCardPresent?'Y':'N', (SDLogfileHandle < MAX_OPEN_FILE)?'Y':'N');
}

void SDLogfile::ListFilesOnCard()
{
	//Make sure to initialize card if someone calls this blind...
	if (!SDCardPresent) 
	{
		bool Sucess = InitSDCard();
		if (!Sucess) 
		{ 
			formatf ("SDLogfile::InitLogfile() : Card won't initialize, can't list files on card.\n");
			return; 
		} 
		else
		{
			formatf ("SDLogfile::Init() : Card initialized.\n");
		}
	}
	
	ListDirectory();	
}

//Helpers for TestSD:
void WriteTestFile(char *name, unsigned char *buf, U16 bufsize);
void ReadTestFile(char *name, unsigned char *buf, U16 bufsize);
unsigned char VerifyTestFile(char *name, unsigned char *buffer, U16 bufsize);
void ShowDOSConfig();

#define TEST_FILE_SIZE	(unsigned long)2000 * (unsigned long)1024  // test filesize 2MB

void SDLogfile::TestSD()
{
	unsigned char buffer[129];
	
	//Make sure to close file if it's open...
	if (SDLogfileHandle < MAX_OPEN_FILE)
    {
		::formatf("SDLogfile::Init() : Warning - logfile was open, writing & closing before card test...\n");
        Fclose(SDLogfileHandle);
		SDLogfileHandle = MAX_OPEN_FILE;
	}
	
	unsigned char timeout = 3;

	//Turn off all fastIO, since MultiFAT never used it, and we haven't done the required massive cut & paste yet...
	//~ SCS &= ~(0x03UL);
	
	//~ IODIR0 = (1<<3);
	//~ IOSET0 = (1<<3);
	
    MMC_FIO_Init();

    while (GetDriveInformation() != F_OK && timeout--)
    {
        formatf ("MMC/SD-Card not found !\n\r");
        return;
    }

    ShowDOSConfig(); // show selected DOS details from dosdefs.h

    formatf(const_cast<char*>("\nTest directory functions\n"));
    Chdir(const_cast<char*>("dir1"));
    Remove(const_cast<char*>("dir4"));
    Chdir(const_cast<char*>("/")); // Back to root
    Remove(const_cast<char*>("dir1"));

    Mkdir(const_cast<char*>("dir1"));
    Chdir(const_cast<char*>("dir1"));
    Mkdir(const_cast<char*>("dir2"));
    Mkdir(const_cast<char*>("dir3"));
    Rename(const_cast<char*>("dir3"),const_cast<char*>("dir4"));
    Remove(const_cast<char*>("dir2"));
    Chdir(const_cast<char*>("/")); // Back to root

    formatf(const_cast<char*>("\nDeleting files\n"));
    Remove(const_cast<char*>("01.bin")); //Remove last data
    Remove(const_cast<char*>("02.bin"));
    Remove(const_cast<char*>("04.bin"));
    Remove(const_cast<char*>("08.bin"));
    Remove(const_cast<char*>("16.bin"));
    Remove(const_cast<char*>("32.bin"));
    Remove(const_cast<char*>("64.bin"));
    Remove(const_cast<char*>("77.bin"));
    Remove(const_cast<char*>("128.bin"));
    
    formatf(const_cast<char*>("\nStart writing files\n"));
    WriteTestFile(const_cast<char*>("01.bin"),buffer,1);
    WriteTestFile(const_cast<char*>("02.bin"),buffer,2);
    WriteTestFile(const_cast<char*>("04.bin"),buffer,4);
    WriteTestFile(const_cast<char*>("08.bin"),buffer,8);
    WriteTestFile(const_cast<char*>("16.bin"),buffer,16);
    WriteTestFile(const_cast<char*>("32.bin"),buffer,32);
    WriteTestFile(const_cast<char*>("64.bin"),buffer,64);
    WriteTestFile(const_cast<char*>("77.bin"),buffer,77);
    WriteTestFile(const_cast<char*>("128.bin"),buffer,128);
    
    formatf(const_cast<char*>("\nStart reading files\n"));
    ReadTestFile(const_cast<char*>("01.bin"),buffer,1);
    ReadTestFile(const_cast<char*>("02.bin"),buffer,2);
    ReadTestFile(const_cast<char*>("04.bin"),buffer,4);
    ReadTestFile(const_cast<char*>("08.bin"),buffer,8);
    ReadTestFile(const_cast<char*>("16.bin"),buffer,16);
    ReadTestFile(const_cast<char*>("32.bin"),buffer,32);
    ReadTestFile(const_cast<char*>("64.bin"),buffer,64);
    ReadTestFile(const_cast<char*>("77.bin"),buffer,77);
    ReadTestFile(const_cast<char*>("128.bin"),buffer,128);
    
    formatf(const_cast<char*>("\nVerifying files\n"));
    VerifyTestFile(const_cast<char*>("32.bin"),buffer,32);
    VerifyTestFile(const_cast<char*>("64.bin"),buffer,64);
    VerifyTestFile(const_cast<char*>("77.bin"),buffer,77);
    VerifyTestFile(const_cast<char*>("128.bin"),buffer,128);
    
    formatf(const_cast<char*>("Test done.\n"));

	//Turn fastIO back on...
	//~ InitCommBoardPinouts();
}

//###################################################################################
void WriteTestFile(char *name, unsigned char *buf, U16 bufsize)
//###################################################################################
{
    unsigned long i;
    S16 fileid;

    fileid=Fopen(name,F_WRITE);
    if (fileid>=0 && fileid<MAX_OPEN_FILE)
    {
        //~ StartTimer();
        for (i=0; i<TEST_FILE_SIZE; i+=bufsize)
        {
            if (Fwrite(buf,bufsize,fileid)!=bufsize) break;
        }
        Fclose(fileid);
        formatf("%3lu",(U32)bufsize);
        //~ StopTimer();
    }
}

//###################################################################################
void ReadTestFile(char *name, unsigned char *buf, U16 bufsize)
//###################################################################################
{
    unsigned long i;
    S16 fileid;

    fileid=Fopen(const_cast<char*>("01.TXT"),F_READ);
    if (fileid>=0 && fileid<MAX_OPEN_FILE)
    {
        //~ StartTimer();
        for (i=0; i<TEST_FILE_SIZE; i+=bufsize)
        {
            if (Fread(buf,bufsize,fileid)!=bufsize) break;
        }
        Fclose(fileid);
        formatf("%3lu",(U32)bufsize);
        //~ StopTimer();
    }
}

//###################################################################################
unsigned char VerifyTestFile(char *name, unsigned char *buffer, U16 bufsize)
//###################################################################################
{
    S16 fileid;
    unsigned long i, k;
    unsigned char result;

    result=F_OK;

    fileid=Fopen(name,F_READ);
    if (fileid>=0 && fileid<MAX_OPEN_FILE)
    {
        for (i=0; i<TEST_FILE_SIZE; i+=bufsize)
        {
            if (Fread(buffer,bufsize,fileid)!=bufsize) result=F_ERROR;
            if (result==F_ERROR) break;

            //Verify buffer
            for (k=0; k<bufsize; k++)
            {
                if (buffer[k] != (unsigned char)(k))
                {
                    formatf("Verify Error at 0x%08lX\n", i+k);
                    result=F_ERROR;
                    break;
                }
            }

            if (result==F_ERROR) break;
        }
        Fclose(fileid);

        if (result!=F_ERROR) formatf("%s verify ok !\n", name);
        else formatf("%s verify NOT ok !\n", name);
    }

    return result;
}

//#############################################################
void ShowDOSConfig()
//#############################################################
{
	
#ifdef USE_FAT12
    formatf("Using FAT12\n");
#endif

#ifdef USE_FAT16
    formatf("Using FAT16\n");
#endif

#ifdef USE_FAT32
    formatf("Using FAT32\n");
#endif

#ifdef USE_FATBUFFER
    formatf("\nUsing FAT Buffer\n");
#else
    formatf("\nNo FAT Buffer\n");
#endif

#ifdef COMPACTFLASH_CARD
    formatf("CF Card\n");
#endif
#ifdef MMC_CARD_SPI //SD_CARD_SPI too !
    formatf("MMC/SD Card\n");
#endif

#ifdef STANDARD_SPI_WRITE  // No optimizations
    formatf("STANDARD_SPI_WRITE\n");
#endif
#ifdef FAST_SPI_WRITE      // Optimizations
    formatf("FAST_SPI_WRITE\n");
#endif
#ifdef STANDARD_SPI_READ  // No optimizations
    formatf("STANDARD_SPI_READ\n");
#endif
#ifdef FAST_SPI_READ      // Optimizations
    formatf("FAST_SPI_READ\n");
#endif

#ifdef USE_SPI0
    formatf("SPI0\n");
#endif
#ifdef USE_SPI1
    formatf("SPI1\n");
#endif
    formatf("SPI_PRESCALER %u\n",SPI_PRESCALER);


    formatf("\nCPU configuration\n");

#if defined (__arm__)
    formatf("ARM mode\n");
#endif

#if defined (__thumb__)
    formatf("THUMB mode\n");
#endif

    //~ formatf("FOSC %lu\n",FOSC);
    //~ formatf("PLL_M %lu\n",PLL_M);
    //~ formatf("VPBDIV %lu\n\n",VPBDIV_VAL);
}

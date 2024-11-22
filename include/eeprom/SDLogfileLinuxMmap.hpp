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
/// $Source: /raincloud/src/projects/include/eeprom/SDLogfile.hpp,v $
/// $Revision: 1.10 $
/// $Date: 2010/02/22 22:08:15 $
/// $Author: steve $

#pragma once

#include <stdint.h>
#include <stdio.h>
#include <dirent.h>

#include "SDLogfile.hpp"

class SDLogfileLinuxMmap : public SDLogfile
{
	public:
		
		SDLogfileLinuxMmap();
		virtual ~SDLogfileLinuxMmap();
			
		//Per card functions
		virtual bool InitSDCard();			
		virtual void Eject();
		virtual bool FileExists(const char* FileName);
		virtual bool CardPresent() { return(SDCardPresent); }
		virtual void ListFilesOnCard();
		virtual uint32_t ListFilesPrep();
		virtual uint32_t ListNextFile(void* f_info, size_t maxlen);
		virtual size_t NumFiles(const char* dir = ".", const char* mask = NULL);

		//Per file functions
		bool InitLogFile(const char* LogFileName, const char* Mode);
		virtual bool InitLogfile(const char* LogFileName);
		virtual bool InitLogfileAppend(const char* LogFileName);
		virtual bool InitLogfileReadOnly(const char* LogFileName);
		virtual bool Log(const void* line, const size_t len, const bool flushwhenfull = true);
		virtual bool LogBuffered(const void* line, const size_t len, const uint8_t bufferpadvalue = (uint8_t)(' '), const bool flushwhenfull = true);
		virtual size_t Read(uint8_t* Buffer, const size_t Len);
		virtual bool Seek(const size_t Len);
		virtual void Flush();
		virtual bool IsOpen();
		virtual void Close();
		virtual void ReOpen();
		virtual void ShowStatus();
		virtual uint32_t FileSize();	
		virtual void TestSD();	
		
	protected:

		const bool SDCardPresent;
		bool LogFileOpen;
		FILE* SDLogfileHandle;
		
		static const size_t MaxFileNameLen = 32;
		char FileName[MaxFileNameLen];
	
		void* SDLogfileLinuxMmapDataBuffer = NULL;
		size_t SDLogfileLinuxMmapDataBufferPos = 0;
		const size_t SDLogfileLinuxMmapMapFileGrowSize = 65536; //How much do we alloc every time we pass the end of the file?
		//~ const size_t SDLogfileLinuxMmapMapFileGrowSize = 1024*1024; //How much do we alloc every time we pass the end of the file?
		size_t SDLogfileLinuxMmapMapFileLen = 0;
};

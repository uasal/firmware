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

class SDLogfile
{
	public:
		
		SDLogfile() { }
		virtual ~SDLogfile() { }
			
		//Per card functions
		virtual bool InitSDCard() = 0;			
		virtual void Eject() = 0;
		virtual bool FileExists(const char* FileName) = 0;
		virtual bool CardPresent() = 0;
		virtual void ListFilesOnCard() = 0;
		virtual uint32_t ListFilesPrep() = 0;
		virtual uint32_t ListNextFile(void* f_info, size_t maxlen) = 0;
		virtual size_t NumFiles(const char* dir = ".", const char* mask = NULL) = 0;
		
		//Per file functions
		virtual bool InitLogfile(const char* LogFileName) = 0;
		virtual bool InitLogfileAppend(const char* LogFileName) = 0;
		virtual bool InitLogfileReadOnly(const char* LogFileName) = 0;
		virtual bool Log(const void* line, const size_t len, const bool flushwhenfull = true) = 0;
		virtual bool LogBuffered(const void* line, const size_t len, const uint8_t bufferpadvalue = (uint8_t)(' '), const bool flushwhenfull = true) = 0;
		virtual size_t Read(uint8_t* Buffer, const size_t Len) = 0;
		virtual bool Seek(const size_t Len) = 0;
		virtual void Flush() = 0;
		virtual bool IsOpen() = 0;
		virtual void Close() = 0;
		virtual void ReOpen() = 0;
		virtual void ShowStatus() = 0;
		virtual uint32_t FileSize() = 0;	
		virtual void TestSD() = 0;	
		
		static const bool FlushWhenFull = true;
		static const bool NoFlush = false;
		static const size_t DataLogSectorSize = 512;	
};

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


#ifndef _win32_pinout_uart_h
#define _win32_pinout_uart_h
#pragma once

#include <stdio.h>
#include <string.h>
#include <windows.h>

#include "IUart.h"

class win32_pinout_uart : public IUart
{
public:

	win32_pinout_uart() : IUart(), ComFileDescriptor(INVALID_HANDLE_VALUE), echo(false) { }
	virtual ~win32_pinout_uart() { if (INVALID_HANDLE_VALUE != ComFileDescriptor) { CloseHandle(ComFileDescriptor); } }

	virtual int init(const uint32_t Baudrate, const char* device, const bool UseRtsCts = IUart::NoRTSCTS)
	{
		DCB    dcb;
		COMMTIMEOUTS CommTimeOuts;
		
		//close if previously opened
		if (INVALID_HANDLE_VALUE != ComFileDescriptor) { CloseHandle(ComFileDescriptor); }

		//open port
		ComFileDescriptor = CreateFile(device, GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
		
		if (INVALID_HANDLE_VALUE == ComFileDescriptor)
		{
			int err = GetLastError();
			printf("\nwin32_pinout_uart::init(): Can't open COM-Port %s ! (Error: %dd (0x%X))\n", device, err, err);
			return(err);
		}
		
		CommTimeOuts.ReadIntervalTimeout = 0xFFFFFFFF;
		CommTimeOuts.ReadTotalTimeoutMultiplier = 0;
		CommTimeOuts.ReadTotalTimeoutConstant = 0;
		CommTimeOuts.WriteTotalTimeoutMultiplier = 0;
		//~ CommTimeOuts.WriteTotalTimeoutConstant = 5000;
		CommTimeOuts.WriteTotalTimeoutConstant = 0; //Don't time out on write
		SetCommTimeouts(ComFileDescriptor, &CommTimeOuts);
		
		//~ GetCommState(ComFileDescriptor, &dcb);
		//~ dcb.BaudRate    = Baudrate;
		//~ dcb.ByteSize    = 8;
		//~ dcb.StopBits    = ONESTOPBIT;
		//~ dcb.Parity      = NOPARITY;
		//~ dcb.fDtrControl = DTR_CONTROL_DISABLE;
		//~ dcb.fOutX       = TRUE; // TL TODO - according to LPC manual! FALSE;
		//~ dcb.fInX        = TRUE; // TL TODO - according to LPC manual! FALSE;
		//~ dcb.fNull       = FALSE;
		//~ dcb.fRtsControl = RTS_CONTROL_DISABLE;

		//~ // added by Herbert Demmel - iF CTS line has the wrong state, we would never send anything!
		//~ dcb.fOutxCtsFlow = FALSE;
		//~ dcb.fOutxDsrFlow = FALSE;

		//~ if (SetCommState(ComFileDescriptor, &dcb) == 0)
		//~ {
			//~ printf("\nwin32_pinout_uart::init(): Can't set baudrate %u ! - Error: %ld", Baudrate, GetLastError());
			//~ exit(3);
		//~ }
		
		dcb.DCBlength = sizeof(DCB);
		GetCommState(ComFileDescriptor, &dcb);
		dcb.BaudRate = Baudrate;
		dcb.ByteSize = 8;
		dcb.StopBits    = ONESTOPBIT;
		dcb.Parity      = NOPARITY;
		dcb.fDtrControl = DTR_CONTROL_DISABLE;
		dcb.fOutX       = FALSE;
		dcb.fInX        = FALSE;
		dcb.fNull       = FALSE;
		dcb.fOutxDsrFlow = FALSE;
		dcb.fDsrSensitivity = FALSE;

		if (UseRtsCts) { dcb.fRtsControl = RTS_CONTROL_ENABLE; dcb.fOutxCtsFlow = TRUE; }
		else { dcb.fRtsControl = RTS_CONTROL_DISABLE; dcb.fOutxCtsFlow = FALSE; }
		
		if( !SetCommState(ComFileDescriptor, &dcb) || !SetupComm(ComFileDescriptor, 10000, 10000) )
		{
			DWORD dwError = GetLastError();
			printf("\nwin32_pinout_uart::init(): Can't set serial port params! (Error: %lu (0x%lX))\n", dwError, dwError);
			CloseHandle(ComFileDescriptor);
			return(dwError);
		}

		PurgeComm(ComFileDescriptor, PURGE_TXABORT | PURGE_RXABORT | PURGE_TXCLEAR | PURGE_RXCLEAR);
		
		//~ printf("\nwin32_pinout_uart::init()\n");

		return(IUartOK);
	}

	virtual void deinit()
	{
		CloseHandle(ComFileDescriptor);
	}
	
	virtual bool Echo() const { return(echo); }
	virtual void Echo(const bool e) { echo = e; }

	virtual bool dataready() const
	{
		DWORD dwErrorFlags;
		COMSTAT ComStat;

		if (INVALID_HANDLE_VALUE == ComFileDescriptor) { printf("\nwin32_pinout_uart::dataready(): ioctl on uninitialized port; please open port!\n"); return(false); }

		ClearCommError(ComFileDescriptor, &dwErrorFlags, &ComStat );

		return(0 != ComStat.cbInQue);
	}

	virtual char getcqq()
	{
		char c = '\0';

		if (INVALID_HANDLE_VALUE == ComFileDescriptor) { printf("\nwin32_pinout_uart::getcqq(): read on uninitialized port; please open port!\n"); return('\0'); }

	    unsigned long len = 0;
		
		//~ printf("\nwin32_pinout_uart::getcqq(): read().\n");
		
		bool readed = ReadFile(ComFileDescriptor, &c, 1, &len, NULL);

		if ( (!readed) || (len != 1) ) { int err = GetLastError(); printf("\nwin32_pinout_uart::getcqq(): read failure (len: %lu, errno: %u)\n", len, err); return('\0'); }
			
		if (echo) { printf(":%.2X:", c); }

  		return(c);
	}

	virtual char putcqq(char c)
	{
		if (INVALID_HANDLE_VALUE != ComFileDescriptor)
		{
		    unsigned long len = 0;
			
			//~ printf("\nwin32_pinout_uart::putcqq(): write().\n");

			bool written = WriteFile(ComFileDescriptor, &c, 1, &len, NULL);
			
			if ( (!written) || (len != 1) ) { int err = GetLastError(); printf("\nwin32_pinout_uart::putcqq(): write failure (len: %lu, errno: %u)\n", len, err); return('\0'); }
			
		}
		else
		{
			printf("win32_pinout_uart::putcqq(): write on uninitialized port; please open port!\n");
		}

 		return (c);
	}

	//~ virtual void flushoutput() const
	//~ {
		//~ if (INVALID_HANDLE_VALUE != ComFileDescriptor)
		//~ {
			
		//~ }
		//~ else
		//~ {
			//~ printf("win32_pinout_uart::flushout(): fflush on uninitialized port; please open port!\n");
		//~ }
	//~ }
	
	virtual void purgeinput()
	{
		if (INVALID_HANDLE_VALUE != ComFileDescriptor)
		{
			PurgeComm(ComFileDescriptor, PURGE_TXABORT | PURGE_RXABORT | PURGE_TXCLEAR | PURGE_RXCLEAR);
		}
		else
		{
			printf("win32_pinout_uart::purgeinput(): tcflush on uninitialized port; please open port!\n");
		}
	}
	
	virtual void flushoutput() { }
	
	virtual bool isopen() const { return(INVALID_HANDLE_VALUE != ComFileDescriptor); }
	
	private:

		HANDLE ComFileDescriptor; //INVALID_HANDLE_VALUE: not open
	
		bool echo;
};

#endif //win32_pinout_uart_h

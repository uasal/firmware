
#pragma once
#ifndef _IProtocol_H_
#define _IProtocol_H_

#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>

class IProtocol
{
public:
	IProtocol() { }
	virtual ~IProtocol() { }

	virtual bool dataready() const = 0;
	virtual char getcqq() = 0;
	virtual char putcqq(char c) = 0;
	virtual void flushoutput() = 0;
	virtual void purgeinput() = 0;
	virtual bool isopen() const = 0;
};

#endif // _IProtocol_H_

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
#pragma once

#include <stdint.h>
#include <string.h>
#include <stdio.h>

struct Cmd ///everything we need to know about a command, in a format that allows us to declare them sequentially in a file
{
	char const* Name; ///The acutal command
	char const* Help; ///Any instructions for the command we'd like users to see
	uint8_t Strlen; ///Embbed the lenght of 'Name' in the struct so we're not always calling the strlen() function
	int8_t (*Response)(char const*, char const*, const size_t, const void*); ///callback function to excecute this command when it's located.

	Cmd(const char* name, const char* help, int8_t (*resp)(char const*, char const*, const size_t, const void*) )
		: Name(name), Help(help), Response(resp)
	{
		Strlen = strlen(Name);
	}
	
	//~ Cmd(const uint32_t& BinaryCmdType, const char* help, int8_t (*resp)(char const*, char const*, const size_t, const void*) )
		//~ : Help(help), Response(resp)
	//~ {
		//~ Name = (char const*)(&BinaryCmdType);
		//~ Strlen = sizeof(uint32_t);
	//~ }
};

struct BinaryCmd ///everything we need to know about a command, in a format that allows us to declare them sequentially in a file
{
	uint32_t Name; ///The acutal command
	char const* Help; ///Any instructions for the command we'd like users to see
	int8_t (*Response)(const uint32_t, char const*, const size_t, const void*); ///callback function to excecute this command when it's located.

	BinaryCmd(const uint32_t name, const char* help, int8_t (*resp)(const uint32_t, char const*, const size_t, const void*) )
		: Name(name), Help(help), Response(resp)
	{ }
};

///The function to locate and execute a command from a line of text
bool ParseCmd(const char* LineIn, const unsigned int LineLen, const Cmd* Cmds, const size_t NumCmds, const bool Quiet = false, const char* Prefix = (const char*)(0), const unsigned int PrefixLen = 0, const bool Binary = false, const void* Argument = 0);
bool ParseBinaryCmd(const char* LineIn, const unsigned int LineLen, const BinaryCmd* Cmds, const size_t NumCmds, const bool Quiet = false, const char* Prefix = (const char*)(0), const unsigned int PrefixLen = 0, const bool Binary = false, const void* Argument = 0);

void HelpCmds(const Cmd* Cmds, const size_t NumCmds);

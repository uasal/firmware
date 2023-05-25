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
/// $Source: /raincloud/src/projects/include/uart/CmdSystem.cpp,v $
/// $Revision: 1.10 $
/// $Date: 2009/09/30 17:53:08 $
/// $Author: steve $

#include <string.h>
#include <stdio.h>
#include <stdint.h>
//~ #include <ctype.h> //toupper()

#include "format/formatf.h"

#include "CmdSystem.hpp"

//~ #ifndef strupr
	//~ char* strupr(char* s);
//~ #endif

const size_t MaxCmdNameLen = 32;

static char LineInUpperCase[MaxCmdNameLen];	

//This parses a line, possibly executing multiple commands; assumes it has already passed the adress checks - used alot internally to parse actions, etc., as well as by uart handler
bool ParseCmd(const char* LineIn, const unsigned int LineLen, const Cmd* Cmds, const size_t NumCmds, const bool Quiet, const char* Prefix, const unsigned int PrefixLen, const bool Binary, const void* Argument)
{
	size_t i = 0;
	//~ size_t ParamsLenUsed = 0;
	
	if ( (0 == LineIn) || (0 == LineLen) )
	{
		return(false);
	}

	if ( (0 != Prefix) && (0 != PrefixLen) )
	{
		if (0 != strncmp(LineIn, Prefix, strnlen(Prefix, PrefixLen)))
		{
			return(false);
		}
	}
	
	//Now do a temporary, since strupr is destructive:
	size_t ucaselen = LineLen;
	if (MaxCmdNameLen < ucaselen) { ucaselen = MaxCmdNameLen; }
	//~ strncpy(LineInUpperCase, LineIn, ucaselen);
	if (!Binary)
	{
		for (i = 0; i < strnlen(LineIn, ucaselen); i++) 
		{ 
			( (LineIn[i] >= 'a') && (LineIn[i] <= 'z') ) ? LineInUpperCase[i] = LineIn[i] - ' ' : LineInUpperCase[i] = LineIn[i]; //this works...
			//~ LineInUpperCase[i] = toupper(LineIn[i]); //this does the same thing; newlib clib is crap!
		}
	}
	LineInUpperCase[MaxCmdNameLen - 1] = '\0';
	
	//All our internal parsing is done in uppercase - if your command doesn't work, make sure it isn't comparing against lowercase letters anywhere.
	//~ strupr((char*) LineInUpperCase); //this turns 'VERSION' into 'VER3ION' in 487 proj!!

	//Params is the location in the string right after the command
	char* Params = NULL;

	//look at each command, and exectute it if the input line matches.
	for(i = 0; i < NumCmds; i++)
	{
		//~ formatf("\nParseCmd(): i=%d, Line=%s (len=%d), L[0] = 0x%.2X, Cmd=", i, LineIn, strlen(LineIn), (uint16_t)(LineIn[0]));
		//~ formatf(Cmds[i].Name);
		//~ formatf(" CmdLen=%d\n", Cmds[i].Strlen);

		unsigned int min = Cmds[i].Strlen;
		if (LineLen < min) { min = LineLen; }

		//do we match command(i)?
		if ( (0 == strncmp(LineInUpperCase, Cmds[i].Name, min)) || (0 == strncmp(LineIn, Cmds[i].Name, min)) )
		{
			//strip the part of the line with the arguments to this command (chars following command)
			Params = const_cast<char*>(&(LineIn[Cmds[i].Strlen]));

			//call the actual command
			//~ ParamsLenUsed = 
			Cmds[i].Response(Cmds[i].Name, Params, LineLen - Cmds[i].Strlen, Argument);

			return(true);
			
			//~ //if it worked, how many chars to the next potential command on this line? (multiple comands per line ok) - else bail out now.
			//~ if( ParamsLenUsed >= 0)
			//~ {
				//~ return(true);
			//~ }

			//~ //if a command fails, we break out of the loop, ignoring the rest of the line.
			//~ else
			//~ {
				//~ if (false == Quiet)
				//~ {
					//~ formatf("Invalid parameters for command: \"%s\"\n", Params);
					//~ formatf(Cmds[i].Help);
				//~ }
				//~ return(false);
			//~ }
		}
	}

	//didn't find a command - give the user a list of all commands and *break out of the loop*
	if (false == Quiet)
	{
		formatf("\n\nInvalid command (\"%s\"; [", LineInUpperCase);
		for (i = 0; i < 10; i++) { formatf("%.2hhX:", LineInUpperCase[i]); }
		formatf("] ) - listing all available commands:\n");
	}
	else
	{
		//~ formatf("\n\nInvalid command (\"%s\") - try 'help' to list all commands:\n", LineIn);
		//~ formatf("\n\nExact input in hex: ");
		//~ for (i = 0; i < LineLen; i++) { formatf("%.2X:", LineIn[i]); }
		//~ for (i = 0; i < strlen(Cmds[1].Name); i++) { formatf("%.2X:", Cmds[1].Name[i]); }
		//~ formatf(" : %s\n", Cmds[1].Help);
		//~ formatf("\n\n");
	}
	
	if (false == Quiet)
	{
		HelpCmds(Cmds, NumCmds);
	}

	return(false);
}

void HelpCmds( const Cmd* Cmds, const size_t NumCmds)
{
	for(size_t j = 0; j < NumCmds; j++)
	{
		formatf("%s: %s\n", Cmds[j].Name, Cmds[j].Help);
	}
}

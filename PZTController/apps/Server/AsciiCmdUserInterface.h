#pragma once

//~ #include <limits.h>
#include "uart/CmdSystem.hpp"

//Define these in your program:
extern const Cmd AsciiCmds[];
extern const uint8_t NumAsciimds;

void StartUserInterface();
bool ProcessUserInterface();

//Required by ParseCmd()... 
char* strupr(char* s);

//EOF

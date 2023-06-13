#pragma once

#include <stddef.h>

int CreateTempFolder(const char* s);
int spawn(const char* exe, const char* paramA = NULL, const char* paramB = NULL, const char* paramC = NULL, const char* paramD = NULL, const char* paramE = NULL, const char* paramF = NULL, const char* paramG = NULL);
void ShowCallStack(void* RealAddr); //You can call this when something crashes or goes sideways to get a sense of where you were in the code...

//EOF

#pragma once

#include <stdlib.h>
#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif


int formatf(const char *fmt, ...); //printf()
int sformatf(char* str, const char *fmt, ... ); //sprintf()
int snformatf(char* str, size_t max, const char *fmt, ... ); //snprintf()
int fformatf(FILE* f, const char *fmt, ... ); //fprintf()

#ifdef __cplusplus
};
#endif

//EOF


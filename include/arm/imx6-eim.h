#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdint.h>
#include <sys/mman.h>

void eim_write_32(off_t offset, uint32_t *pvalue);
void eim_read_32(off_t offset, uint32_t *pvalue);
int eim_setup(void);

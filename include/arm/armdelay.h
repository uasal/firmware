#pragma once

//~ #include "arm/lpcinit.h"

#ifdef __cplusplus
extern "C" {
#endif

__inline__ void Delay4CyclesArm7tdmi(const unsigned long loops)
{
   __asm volatile
   (                                                                       \
      "\n\t"                                                               \
      "LOOP_%=:                                                      \n\t" \
      "subs %0, %0, #1           @ 1 cycle                           \n\t" \
      "bne LOOP_%=               @ 3 cycles (true), 1 cycle (false)  \n\t" \
      "\n\t"                                                               \
      : /* NO OUTPUTS */                                                   \
      : "r" (loops)                                                        \
   );
}

#ifdef __cplusplus
};
#endif

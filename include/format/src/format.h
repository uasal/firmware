/* ****************************************************************************
 * Format - lightweight string formatting library.
 * Copyright (C) 2010-2011, Neil Johnson
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms,
 * with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * * Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * * Neither the name of nor the names of its contributors
 *   may be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
 * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * ************************************************************************* */

#ifndef FORMAT_H
#define FORMAT_H

#include <stdarg.h>

/* Error code returned when problem with format specification */

#define EXBADFORMAT             (-1)

/**
    Interpret format specification passing formatted text to consumer function.
    
    Executes the printf-compatible format specification @a fmt, referring to 
    optional arguments @a ap.  Any output text is passed to caller-provided
    consumer function @a cons, which also takes caller-provided opaque pointer
    @a arg.
    
    @param cons         Pointer to caller-provided consumer function.
    @param arg          Opaque pointer passed through to @a cons.
    @param fmt          printf-compatible format specifier.
    @param ap           List of optional format string arguments
    
    @returns            Number of characters sent to @a cons, or EXBADFORMAT.
**/
#ifdef __cplusplus
extern "C" {
#endif
extern int format( void * (* /* cons */) (void *, const char *, size_t),
             void *          /* arg  */,
             const char *    /* fmt  */,
             va_list         /* ap   */
);


/*****************************************************************************/
/* Data types                                                                */
/*****************************************************************************/

/**
    Describe a format specification.
**/
typedef struct {
    unsigned int    nChars; /**< number of chars emitted so far     **/
    unsigned int    flags;  /**< flags                              **/
    int             width;  /**< width                              **/
    int             prec;   /**< precision                          **/
    int             base;   /**< numeric base                       **/
    char            qual;   /**< length qualifier                   **/
    char            repchar;/**< Repetition character               **/
    struct {
#if defined(CONFIG_HAVE_ALT_PTR)
        enum ptr_mode mode; /**< grouping spec pointer type         **/
#endif
        const void *  ptr;  /**< ptr to grouping specification      **/
        size_t        len;  /**< length of grouping spec            **/
    } grouping;
    struct {
        size_t w_int;       /**< fixed-point integer field width    **/
        size_t w_frac;      /**< fixed-point fractional field width **/
    } xp;
} T_FormatSpec;

/*****************************************************************************/
/* Macros, constants                                                         */
/*****************************************************************************/

/**
    Define the field flags
**/
#define FSPACE          ( 0x01 )
#define FPLUS           ( 0x02 )
#define FMINUS          ( 0x04 )
#define FHASH           ( 0x08 )
#define FZERO           ( 0x10 )
#define FBANG           ( 0x20 )
#define FCARET          ( 0x40 )
#define F_IS_SIGNED     ( 0x80 )

/**
    Some length qualifiers are doubled-up (e.g., "hh").

    This little hack works on the basis that all the valid length qualifiers
    (h,l,j,z,t,L) ASCII values are all even, so we use the LSB to tag double
    qualifiers.  I'm not sure if this was the intent of the spec writers but
    it is certainly convenient!  If this ever changes then we need to review
    this hack and come up with something else.
**/
#define DOUBLE_QUAL(q)  ( (q) | 1 )

/**
    Set limits.
**/
#define MAXWIDTH        ( 500 )
#define MAXPREC         ( 500 )
#define MAXBASE         ( 36 )
#define BUFLEN          ( 130 )  /* Must be long enough for 64-bit pointers
                                  * in binary with maximum grouping chars and
                                  * prefix:
                                  *  "0b" + 64 digits + 64 grouping chars
                                  */

/* Fixed-point field width limits */
#define MAX_XP_INT      ( sizeof(int) * CHAR_BIT )
#define MAX_XP_FRAC     ( sizeof(int) * CHAR_BIT )
#define MAX_XP_WIDTH    ( sizeof(long) * CHAR_BIT )

/**
    Return the maximum/minimum of two scalar values.
**/
#define MAX(a,b)        ( (a) > (b) ? (a) : (b) )
#define MIN(a,b)        ( (a) < (b) ? (a) : (b) )

/**
    Return the number of elements in a static array.
**/
#define NELEMS(a)       ( sizeof(a) / sizeof(*(a)) )

/**
    Return the absolute value of a signed scalar value.
**/
#define ABS(a)          ( (a) < 0 ? -(a) : (a) )




#ifdef __cplusplus
};
#endif

/*    The Consumer Function
 *
 * The consumer function 'cons' must have the following type:
 *
 *   void * cons ( void * arg, const char * s, size_t n )
 *
 * You may give your function any valid C name.
 *
 * It takes an opaque pointer argument, which may be modified by the call.
 * The second and third arguments specify the source string and the number of
 *  characters to take from the string.
 * If the call is successful then a new value of the opaque pointer is returned,
 *  which will be passed on the next time the function is called.
 * In case of an error, the function returns NULL.
 */

#endif

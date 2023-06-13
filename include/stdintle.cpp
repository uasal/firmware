//
///           Copyright (c) by Franks Development, LLC
//
// This software is copyrighted by and is the sole property of Franks
// Development, LLC. All rights, title, ownership, or other interests
// in the s1ware remain the property of Franks Development, LLC. This
// s1ware may only be used in accordance with the corresponding
// license agreement.  Any unauthorized use, duplication, transmission,
// distribution, or disclosure of this s1ware is expressly forbidden.
//
// This Copyright notice may not be removed or modified without prior
// written consent of Franks Development, LLC.
//
// Franks Development, LLC. reserves the right to modify this s1ware
// without notice.
//
// Franks Development, LLC            support@franks-development.com
// 500 N. Bahamas Dr. #101           http://www.franks-development.com
// Tucson, AZ 85710
// USA
//
/// \file
/// $Source: /raincloud/src/projects/include//stdintle.cpp,v $
/// $Revision: 1.1 $
/// $Date: 2008/06/06 16:51:34 $
/// $Author: steve $

#include <stdint.h>

#include "stdintle.h"

uint16_t endianswap_uint16_t(const uint8_t* src)
{
	if (0 == src) { return(0); }
	uint16_t temp;
	uint8_t* dest = (uint8_t*)(&temp);
	dest[0] = src[1];
	dest[1] = src[0];	
	return(temp);
}
	
uint32_t endianswap_uint32_t(const uint8_t* src)
{
	if (0 == src) { return(0); }
	uint32_t temp;
	uint8_t* dest = (uint8_t*)(&temp);
	dest[0] = src[3];
	dest[1] = src[2];
	dest[2] = src[1];
	dest[3] = src[0];	
	return(temp);
}

uint64_t endianswap_uint64_t(const uint8_t* src)
{
	if (0 == src) { return(0); }
	uint64_t temp;
	uint8_t* dest = (uint8_t*)(&temp);
	dest[0] = src[7];
	dest[1] = src[6];
	dest[2] = src[5];
	dest[3] = src[4];
	dest[4] = src[3];
	dest[5] = src[2];
	dest[6] = src[1];
	dest[7] = src[0];	
	return(temp);
}

float endianswap_float(const uint8_t* src)
{
	if (0 == src) { return(0); }
	float temp;
	uint8_t* dest = (uint8_t*)(&temp);
	dest[0] = src[3];
	dest[1] = src[2];
	dest[2] = src[1];
	dest[3] = src[0];
	return(temp);
}

double endianswap_double(const uint8_t* src)
{
	if (0 == src) { return(0); }
	double temp;
	uint8_t* dest = (uint8_t*)(&temp);
	dest[0] = src[7];
	dest[1] = src[6];
	dest[2] = src[5];
	dest[3] = src[4];
	dest[4] = src[3];
	dest[5] = src[2];
	dest[6] = src[1];
	dest[7] = src[0];	
	return(temp);
}

double endianswap_double_arm7(const uint8_t* src)
{
	if (0 == src) { return(0); }
	double temp;
	uint8_t* dest = (uint8_t*)(&temp);
	dest[4] = src[7];
	dest[5] = src[6];
	dest[6] = src[5];
	dest[7] = src[4];
	dest[0] = src[3];
	dest[1] = src[2];
	dest[2] = src[1];
	dest[3] = src[0];
	return(temp);
}

double endianswap_doublehalves_arm7(const double& source)
{
	double temp;
	const uint32_t* src = (const uint32_t*)(&source);
	uint32_t* dest = (uint32_t*)(&temp);
	dest[0] = src[1];
	dest[1] = src[0];
	return(temp);
}

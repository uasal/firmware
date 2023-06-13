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
/// $Source: /raincloud/src/projects/include//stdintle.h,v $
/// $Revision: 1.3 $
/// $Date: 2008/06/06 16:51:34 $
/// $Author: steve $

#pragma once

#include <stdint.h>

uint16_t endianswap_uint16_t(const uint8_t* src);
uint32_t endianswap_uint32_t(const uint8_t* src);
uint64_t endianswap_uint64_t(const uint8_t* src);
float endianswap_float(const uint8_t* src);
double endianswap_double(const uint8_t* src);
double endianswap_double_arm7(const uint8_t* src);
double endianswap_doublehalves_arm7(const double& src);

struct uint16be_t
{
	uint8_t one;
	uint8_t two;
	
	uint16_t le() { return( (uint16_t)one << 8 | two ); }

} __attribute__((__packed__));

struct uint32be_t
{
	uint8_t one;
	uint8_t two;
	uint8_t three;
	uint8_t four;
	
	uint32_t le() { return( (uint32_t)one << 24 | (uint32_t)two << 16 | (uint32_t)three << 8 | (uint32_t)four); }

} __attribute__((__packed__));

union floatbe_t
{
	float all;
	struct
	{
		uint8_t one;
		uint8_t two;
		uint8_t three;
		uint8_t four;
	};
	
	float le() 
	{ 
		//~ uint32_t temp = (uint32_t)one << 24 | (uint32_t)two << 16 | (uint32_t)three << 8 | (uint32_t)four;
		//~ return( *(reinterpret_cast<float*>((unsigned)(&temp))) ); 
		uint8_t temp = one;
		one = four;
		four = temp;
		temp = two;
		two = three;
		three = temp;
		return(all); 
	}

} __attribute__((__packed__));

union doublebe_t
{
	double all;
	struct
	{
		uint8_t one;
		uint8_t two;
		uint8_t three;
		uint8_t four;
		uint8_t five;
		uint8_t six;
		uint8_t seven;
		uint8_t eight;
	};
	
	double le() 
	{ 
		//~ uint64_t temp = (uint64_t)one << 56 | (uint64_t)two << 48 | (uint64_t)three << 40 | (uint64_t)four << 32 | (uint64_t)five << 24 | (uint64_t)six << 16 | (uint64_t)seven << 8 | (uint64_t)eight;
		//~ return( *(reinterpret_cast<double*>(&temp)) ); 
		uint8_t temp = one;
		one = eight;
		eight = temp;
		
		temp = two;
		two = seven;
		seven = temp;
		
		temp = three;
		three = six;
		six = temp;
		
		temp = four;
		four = five;
		five = temp;
		
		return(all); 
	}

} __attribute__((__packed__));

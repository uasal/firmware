#pragma once
#include <stdint.h>

union IPAddr
{
	uint32_t all;
	struct
	{
		uint8_t O3; //lsb
		uint8_t O2;
		uint8_t O1;
		uint8_t O0; //msb
	} __attribute__((__packed__));
	IPAddr() { all = 0; }
	IPAddr(const uint32_t ip) { all = ip; }
	IPAddr(const uint8_t o3, const uint8_t o2, const uint8_t o1, const uint8_t o0) { O3 = o3; O2 = o2; O1 = o1; O0 = o0; }
	bool operator==(const IPAddr& ip) const { return(all == ip.all); }
	bool operator!=(const IPAddr& ip) const { return(all != ip.all); }
	void printf() const { ::printf("%hu.%hu.%hu.%hu (0x%.8X)", O3, O2, O1, O0, all); }
	char* sprintf(char* s) const { ::sprintf(s, "%hu.%hu.%hu.%hu", O3, O2, O1, O0); return(s); }
} __attribute__((__packed__));

//EOF

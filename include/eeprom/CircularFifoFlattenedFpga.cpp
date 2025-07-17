#include "CircularFifoFlattenedFpga.hpp"

#include "format/formatf.h"

size_t CircularFifoFlattenedFpga::Depth() const
{
	if ( (nullptr == WriteOffset) || (nullptr == ReadOffset) ) { return(0); }
	
	size_t w,r;
	w = *WriteOffset;
	if ( (w > Len) || (w < 0) ) { w = 0; }
	r = *ReadOffset;
	if ( (r > Len) || (r < 0) ) { r = 0; }
	long d = w - r;
	if (d < 0) { d += Len; }
	return((size_t)d);
}

void CircularFifoFlattenedFpga::PopMany(const size_t LastReadAddrToPop)
{
	if (nullptr == PopRegister) { return; }
	//~ size_t popmany = LastReadAddrToPop;
	//~ if (popmany >= len) { popmany = len;}
	::formatf("\n\nCircularFifoFlattenedFpga: PopMany(%u) @ 0x%p.\n\r", LastReadAddrToPop, PopRegister);
	*PopRegister = LastReadAddrToPop;
}

size_t CircularFifoFlattenedFpga::CopyToFlatBuffer(const size_t StartOffset, size_t& NumToCopy, uint8_t* const Buffer, const size_t BufferMaxLen) const
{
	if ( NumToCopy > BufferMaxLen) { NumToCopy = BufferMaxLen - 1; }
	size_t depth = Depth();
	if ( NumToCopy > depth) { NumToCopy = depth - 1; }
	
	if ( (nullptr == WriteOffset) || (nullptr == ReadOffset) ) { return(0); }

	size_t w,r;
	w = *WriteOffset;
	if ( (w > Len) || (w < 0) ) { w = 0; }
	r = *ReadOffset;
	if ( (r > Len) || (r < 0) ) { r = 0; }
	
	long d = w - r;
	if (d < 0) { d += Len; }
	if (d > (long)Len) { d = Len; }

	size_t i = 0;
	for (i = 0; i < NumToCopy; i++)
	{
		size_t offset = i + r + StartOffset;
		if (offset >= Len) { offset -= Len; }		
		//!The data is not a C/C++ array! It is two addresses in the Fpga registers, one for the address of the data and one for the actual data
		*DataOffset = offset;
		Buffer[i] = *Data;
	}
	return(i);
}

//EOF
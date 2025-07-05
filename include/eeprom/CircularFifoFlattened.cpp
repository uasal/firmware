#include "CircularFifoFlattened.hpp"

#include "format/formatf.h"

size_t CircularFifoFlattened::Depth() const
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

void CircularFifoFlattened::PopMany(const size_t LastReadAddrToPop)
{
	if (nullptr == PopRegister) { return; }
	//~ size_t popmany = LastReadAddrToPop;
	//~ if (popmany >= len) { popmany = len;}
	::formatf("\n\nCircularFifoFlattened: PopMany(%u) @ 0x%p.\n\r", LastReadAddrToPop, PopRegister);
	*PopRegister = LastReadAddrToPop;
}

size_t CircularFifoFlattened::CopyToFlatBuffer(const size_t StartOffset, size_t& NumToCopy, uint8_t* const Buffer, const size_t BufferMaxLen) const
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
	if (d > Len) { d = Len; }

	size_t i = 0;
	for (i = 0; i < NumToCopy; i++)
	{
		size_t offset = i + r + StartOffset;
		if (offset >= Len) { offset -= Len; }		
		Buffer[i] = Data[offset];
	}
	return(i);
}

//EOF
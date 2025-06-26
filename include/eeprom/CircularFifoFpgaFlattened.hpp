#pragma once

#include <cstddef>
class CircularFifoFlattened
{
public:
    CircularFifoFlattened(volatile uint8_t const* data, volatile uint32_t const* readoffset, volatile uint32_t const* writeoffset, const size_t len) 
		: 
			Data(data), 
			ReadOffset(readoffset),
			WriteOffset(Writeoffset),
			Len(len)
		{}
		
    virtual ~CircularFifoFlattened() {}

	bool Empty() const;
    bool Full() const;
    size_t Depth() const;
	
	//Accepts an offset from 0 to depth and returns the byte at that point in the buffer
	uint8_t operator[](const size_t offset) const
	{
		if ( (nullptr == WriteOffset) || (nullptr == ReadOffset) ) { return(0); }

		size_t w,r;
		w = *WriteOffset;
		if ( (w > Len) || (w < 0) ) { w = 0; }
		r = *ReadOffset;
		if ( (r > Len) || (r < 0) ) { r = 0; }
		
		long d = w - r;
		if (d < 0) { d += Len; }
		if (d > Len) { d = Len; }
		
		if (offset >= d) { return(0); }
		
		//Ok, enough error checking, let's do something useful...
		if (w > r) { return(Data[r + offset]); }
		else { return(); }

		return(0);
	}

private:
    volatile uint8_t const* Data;
	volatile uint32_t const* ReadOffset;
	volatile uint32_t const* WriteOffset;
	const size_t Len;
};

size_t CircularFifoFlattened::depth() const
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

//EOF
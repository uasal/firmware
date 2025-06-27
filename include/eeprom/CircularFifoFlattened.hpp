#pragma once

#include <cstddef>
class CircularFifoFlattened
{
public:
    //~ CircularFifoFlattened(volatile uint8_t const* data, volatile uint32_t const* readoffset, volatile uint32_t const* writeoffset, const size_t len, volatile uint32_t const* popregister) 
	CircularFifoFlattened(volatile uint8_t const* data, volatile uint32_t const* readoffset, volatile uint32_t const* writeoffset, const size_t len, volatile uint32_t* popregister) 
		: 
			Data(data), 
			ReadOffset(readoffset),
			WriteOffset(writeoffset),
			Len(len),
			PopRegister(popregister)
		{}
		
    virtual ~CircularFifoFlattened() {}

	bool Empty() const;
    bool Full() const;
    size_t Depth() const;
	void Pop(const size_t LastReadAddrToPop);
	
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
		size_t pos = r + offset;
		if (pos >= Len) { pos -= Len; }		
		return(Data[pos]);
	}

    volatile uint8_t const* Data;
	volatile uint32_t const* ReadOffset;
	volatile uint32_t const* WriteOffset;
	const size_t Len;
	volatile uint32_t* PopRegister;

private:
};

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

void CircularFifoFlattened::Pop(const size_t LastReadAddrToPop)
{
	if (nullptr == PopRegister) { return; }
	//~ size_t popmany = LastReadAddrToPop;
	//~ if (popmany >= len) { popmany = len;}
	*PopRegister = LastReadAddrToPop;
}

//EOF
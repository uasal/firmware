#pragma once

#include <cstddef>

#include "IArray.hpp"

class CircularFifoFlattenedFpga : public IArray
{
public:
	//!The data is not a C/C++ array! It is two addresses in the Fpga registers, one for the address of the data and one for the actual data
	CircularFifoFlattenedFpga(volatile uint32_t* const dataoffset, volatile uint8_t* const data, volatile uint32_t* const readoffset, volatile uint32_t* const writeoffset, const size_t len, volatile uint32_t* const popregister) 
		: 
			DataOffset(dataoffset), 
			Data(data), 
			ReadOffset(readoffset),
			WriteOffset(writeoffset),
			Len(len),
			PopRegister(popregister)
		{}
		
    virtual ~CircularFifoFlattenedFpga() {}

	bool Empty() const;
    bool Full() const;
    size_t Depth() const override;
	void PopMany(const size_t LastReadAddrToPop) override;
	size_t CopyToFlatBuffer(const size_t StartOffset, size_t& NumToCopy, uint8_t* const Buffer, const size_t BufferMaxLen) const override;

	
	//Accepts an offset from 0 to depth and returns the byte at that point in the buffer
	uint8_t operator[](const size_t offset) const override
	{
		if ( (nullptr == WriteOffset) || (nullptr == ReadOffset) ) { return(0); }

		size_t w,r;
		w = *WriteOffset;
		if ( (w > Len) || (w < 0) ) { w = 0; }
		r = *ReadOffset;
		if ( (r > Len) || (r < 0) ) { r = 0; }
		
		long d = w - r;
		if (d < 0) { d += Len; }
		if (d > (long)Len) { d = Len; }
		
		if ((long)offset >= d) { return(0); }
		
		//Ok, enough error checking, let's do something useful...
		size_t pos = r + offset;
		if (pos >= Len) { pos -= Len; }		
		*DataOffset = pos;
		return(*Data);
	}
	
	//Accepts an offset from 0 to depth and returns the byte at that point in the buffer
	uint8_t peek(const size_t offset) const override
	{
		if ( (nullptr == WriteOffset) || (nullptr == ReadOffset) ) { return(0); }

		size_t w,r;
		w = *WriteOffset;
		if ( (w > Len) || (w < 0) ) { w = 0; }
		r = *ReadOffset;
		if ( (r > Len) || (r < 0) ) { r = 0; }
		
		long d = w - r;
		if (d < 0) { d += Len; }
		if (d > (long)Len) { d = Len; }
		
		if ((long)offset >= d) { return(0); }
		
		//Ok, enough error checking, let's do something useful...
		size_t pos = r + offset;
		if (pos >= Len) { pos -= Len; }		
		*DataOffset = pos;
		return(*Data);
	}
	
	uint16_t asU16(const size_t offset) const override
	{
		uint16_t val = 0;
		val = peek(offset) | (peek(offset + 1) << 8);
		return(val);
	}
	
	uint32_t asU32(const size_t offset) const override
	{
		uint32_t val = 0;
		val = peek(offset) | (peek(offset + 1) << 8) | (peek(offset + 2) << 16) | (peek(offset + 3) << 24);
		return(val);		
	}

    volatile uint32_t* const DataOffset;
    volatile uint8_t* const Data;
	volatile uint32_t* const ReadOffset;
	volatile uint32_t* const WriteOffset;
	const size_t Len;
	volatile uint32_t* const PopRegister;

private:
};

//EOF
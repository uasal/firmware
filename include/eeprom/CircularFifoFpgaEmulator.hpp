/*
* Not any company's property but Public-Domain
* Do with source-code as you will. No requirement to keep this
* header if need to use it/change it/ or do whatever with it
*
* Note that there is No guarantee that this code will work
* and I take no responsibility for this code and any problems you
* might get if using it.
*
* Code & platform dependent issues with it was originally
* published at http://www.kjellkod.cc/threadsafecircularqueue
* 2012-16-19  @author Kjell Hedström, hedstrom@kjellkod.cc */
//https://kjellkod.wordpress.com/2012/11/28/c-debt-paid-in-full-wait-free-lock-free-queue/#heading_part_II

// std::atomic requires C++11 support.

#pragma once

#include <cstddef>
template<size_t Size>
class CircularFifoFpgaEmulator
{
public:
    enum { Capacity = Size+1 };

    CircularFifoFpgaEmulator() : _tail(0), _head(0) {}
    virtual ~CircularFifoFpgaEmulator() {}

	void flush();
		
	bool push(const uint8_t& item); // pushByMOve?
    bool pop(uint8_t& item);

    bool wasEmpty() const;
    bool wasFull() const;
 	size_t depth() const;
	void PopMany(const size_t PopToPos);

	uint32_t  _tail;  // tail(input) index
    uint32_t _head; // head(output) index
	
private:
    size_t increment(size_t idx) const;
	uint8_t    _array[Capacity];
};

template<size_t Size>
void CircularFifoFpgaEmulator<uint8_t, Size>::flush()
{
	_tail = 0;
	_head = 0;
}

template<size_t Size>
bool CircularFifoFpgaEmulator<uint8_t, Size>::push(const uint8_t& item)
{
    const auto current_tail = _tail;
    const auto next_tail = increment(current_tail);
    if(next_tail != _head)
    {
        _array[current_tail] = item;
        _tail = next_tail;
		
		//~ size_t t = _tail.load(std::memory_order_seq_cst);
		//~ size_t h = _head.load(std::memory_order_seq_cst);
		//~ printf("push(%p): t:%zu, h:%zu, l:%zu.\n", this, t, h, t-h);
		
        return true;
    }

    return false; // full queue

}

// Pop by Consumer can only update the head (load with relaxed, store with release)
//     the tail must be accessed with at least aquire
template<size_t Size>
bool CircularFifoFpgaEmulator<uint8_t, Size>::pop(uint8_t& item)
{
	//~ size_t t = _tail.load(std::memory_order_seq_cst);
	//~ size_t h = _head.load(std::memory_order_seq_cst);
	//~ printf("pop(%p): t:%zu, h:%zu, l:%zu.\n", this, t, h, t-h);

    const auto current_head = _head;
    if(current_head == _tail)
        return false; // empty queue

    item = _array[current_head];
    _head = increment(current_head);
    return true;
}

template<size_t Size>
bool CircularFifoFpgaEmulator<uint8_t, Size>::wasEmpty() const
{
    // snapshot with acceptance of that this comparison operation is not atomic
    return (_head == _tail);
}


// snapshot with acceptance that this comparison is not atomic
template<size_t Size>
bool CircularFifoFpgaEmulator<uint8_t, Size>::wasFull() const
{
    const auto next_tail = increment(_tail); // aquire, we dont know who call
    return (next_tail == _head);
}

template<size_t Size>
size_t CircularFifoFpgaEmulator<uint8_t, Size>::increment(size_t idx) const
{
    return (idx + 1) % Capacity;
}

template<size_t Size>
size_t CircularFifoFpgaEmulator<uint8_t, Size>::increment(size_t idx, size_t inc_len) const
{
    return (idx + inc_len) % Capacity;
}

template<size_t Size>
size_t CircularFifoFpgaEmulator<uint8_t, Size>::depth() const
{
	size_t t,h;
	h = _head;
	t = _tail;
	//~ if (h > t) { return(h - t); }
	//~ return(t - h);
	long d = t - h;
	if (d < 0) { d += Capacity; }
	return((size_t)d);
}

template<size_t Size>
void PopMany(const size_t PopToPos)
{
	_head = PopToPos;
}

template<size_t Size>
void PushMany(uint8_t const* PushData, const size_t PushLen)
{
	for(size_t i = 0; i < PushLen; i++) { push(PushData[i]); )
}

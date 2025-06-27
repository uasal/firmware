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

#ifndef CIRCULARFIFO_AQUIRE_RELEASE_H_
#define CIRCULARFIFO_AQUIRE_RELEASE_H_

#include <atomic>
#include <cstddef>
template<typename Element, size_t Size>
class CircularFifo
{
public:
    enum { Capacity = Size+1 };

    CircularFifo() : _tail(0), _head(0) {}
    virtual ~CircularFifo() {}

	void flush();
		
	bool push(const Element& item); // pushByMOve?
    bool pop(Element& item);

    bool wasEmpty() const;
    bool wasFull() const;
    bool isLockFree() const;
	size_t depth() const;
	size_t len() const;

    std::atomic <size_t>  _tail;  // tail(input) index
    Element    _array[Capacity];
    std::atomic<size_t>   _head; // head(output) index

private:
    size_t increment(size_t idx) const;

    //~ std::atomic <size_t>  _tail;  // tail(input) index
    //~ Element    _array[Capacity];
    //~ std::atomic<size_t>   _head; // head(output) index
};

template<typename Element, size_t Size>
void CircularFifo<Element, Size>::flush()
{
	_tail.store(0);
	_head.store(0);
}

template<typename Element, size_t Size>
bool CircularFifo<Element, Size>::push(const Element& item)
{
    const auto current_tail = _tail.load(std::memory_order_relaxed);
    const auto next_tail = increment(current_tail);
    if(next_tail != _head.load(std::memory_order_acquire))
    {
        _array[current_tail] = item;
        _tail.store(next_tail, std::memory_order_release);
		
		//~ size_t t = _tail.load(std::memory_order_seq_cst);
		//~ size_t h = _head.load(std::memory_order_seq_cst);
		//~ printf("push(%p): t:%zu, h:%zu, l:%zu.\n", this, t, h, t-h);
		
        return true;
    }

    return false; // full queue

}

// Pop by Consumer can only update the head (load with relaxed, store with release)
//     the tail must be accessed with at least aquire
template<typename Element, size_t Size>
bool CircularFifo<Element, Size>::pop(Element& item)
{
	//~ size_t t = _tail.load(std::memory_order_seq_cst);
	//~ size_t h = _head.load(std::memory_order_seq_cst);
	//~ printf("pop(%p): t:%zu, h:%zu, l:%zu.\n", this, t, h, t-h);

    const auto current_head = _head.load(std::memory_order_relaxed);
    if(current_head == _tail.load(std::memory_order_acquire))
        return false; // empty queue

    item = _array[current_head];
    _head.store(increment(current_head), std::memory_order_release);
    return true;
}

template<typename Element, size_t Size>
bool CircularFifo<Element, Size>::wasEmpty() const
{
    // snapshot with acceptance of that this comparison operation is not atomic
    return (_head.load() == _tail.load());
}


// snapshot with acceptance that this comparison is not atomic
template<typename Element, size_t Size>
bool CircularFifo<Element, Size>::wasFull() const
{
    const auto next_tail = increment(_tail.load()); // aquire, we dont know who call
    return (next_tail == _head.load());
}


template<typename Element, size_t Size>
bool CircularFifo<Element, Size>::isLockFree() const
{
    return (_tail.is_lock_free() && _head.is_lock_free());
}

template<typename Element, size_t Size>
size_t CircularFifo<Element, Size>::increment(size_t idx) const
{
    return (idx + 1) % Capacity;
}

template<typename Element, size_t Size>
size_t CircularFifo<Element, Size>::depth() const
{
	size_t t,h;
	h = _head.load();
	t = _tail.load();
	//~ if (h > t) { return(h - t); }
	//~ return(t - h);
	long d = t - h;
	if (d < 0) { d += Capacity; }
	return((size_t)d);
}

template<typename Element, size_t Size>
size_t CircularFifo<Element, Size>::len() const { return(Capacity); }

#endif /* CIRCULARFIFO_AQUIRE_RELEASE_H_ */

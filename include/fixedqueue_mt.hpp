/// \file
/// $Source: /raincloud/src/projects/include//fixedqueue_mt.hpp,v $
/// $Revision: 1.4 $
/// $Date: 2010/05/14 21:57:41 $
/// $Author: steve $
#ifndef _fixedque_mt_H_
#define _fixedque_mt_H_
#pragma once

#include <atomic>
#include <cstddef>

template<typename T, size_t queue_size> class fixedqueue_mt
{
	private:
		
		T data[queue_size] __attribute__((aligned(4)));
		
		std::atomic <size_t> begin;
		std::atomic <size_t> end;
		
		size_t next(const size_t in) const { return( (in == (queue_size - 1)) ? 0 : in + 1 ); }
		
	public:
		
		fixedqueue_mt(): begin(0), end(0) { }
		
		size_t max() const { return(queue_size); }
		
		bool empty() const { return begin.load() == end.load(); }
		bool wasEmpty() const { return(empty()); }
    
		bool full() const { return (next(end.load()) == begin.load()); }
		bool wasFull() const { return(full()); }
			
		size_t len() const
		{
			size_t temp(end.load()-begin.load());
			//~ if (temp < 0) temp += queue_size;
			if (temp >= queue_size) temp %= queue_size;
			return temp;
		}
		size_t depth() const { return(len()); }
    
		void clear() { begin.store(0); end.store(0); }
		void flush() { return(clear()); }
		
		bool pop(T& element)
		{
			if ( empty() ) { return(false); }
			element = data[begin.load()];
			begin.store(next(begin.load()));
			return(true);
		}
		
		bool push(T const& element)
		{
			if ( full() ) { return(false); }
			data[end.load()] = element;
			end.store(next(end.load()));
			return(true);
		}
};

#endif //_fixedque_mt_H_

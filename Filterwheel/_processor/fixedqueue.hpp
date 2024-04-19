/// \file
/// $Source: /raincloud/src/projects/include//fixedqueue.hpp,v $
/// $Revision: 1.4 $
/// $Date: 2010/05/14 21:57:41 $
/// $Author: steve $
#ifndef _fixedque_H_
#define _fixedque_H_
#pragma once

#include <cstddef>
//#include "stddef.h"

template<typename T, size_t queue_size> class fixedqueue
{
	private:

		T data[queue_size] __attribute__((aligned(4)));

		size_t volatile begin;
		size_t volatile end;

		size_t next(const size_t in) const
		{
            size_t tNxt ;
// joeb
//            tNxt =  (in == (queue_size - 1)) ? 0 : in + 1 ;
            tNxt =  ( in + 1 ) % queue_size ;
            return tNxt ;
		}

	public:

		fixedqueue(): begin(0), end(0) { }

		bool empty() const { return begin == end; }

		bool full() const { return (next(end) == begin); }

// joeb
//		size_t max() const { return(queue_size); }
		size_t max() const { return(queue_size -1); }

		size_t len() const
		{
// joeb
//			size_t temp(end-begin);
//			if (temp < 0) temp += queue_size;
			size_t temp = ( queue_size + end - begin ) % queue_size ;
			return temp;
		}

		void clear() { begin = end = 0; }
		T const& front() const { return data[begin]; }
		T const& back() const { return data[end ? (end-1) : (queue_size-1)]; }

		bool pop(T& element)
		{
			if ( empty() ) { return(false); }
			element = data[begin];
			begin = next(begin);
			return(true);
		}

		bool push(T const& element)
		{
			if ( full() ) { return(false); }
			data[end] = element;
			end = next(end);
			return(true);
		}
};

#endif //_fixedque_H_

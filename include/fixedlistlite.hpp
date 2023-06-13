/// \file
/// $Source: /raincloud/src/projects/include//fixedlistlite.hpp,v $
/// $Revision: 1.6 $
/// $Date: 2010/04/07 00:22:10 $
/// $Author: steve $
#ifndef _fixedlistlite_H_
#define _fixedlistlite_H_
#pragma once

#include <stddef.h>

template<typename T, size_t list_size=16> class fixedlistlite
{
	private:
	
		T data[list_size] __attribute__((aligned(4)));
		size_t len;
	
	public:
		
		fixedlistlite() // : 
		{ 
			Clear();
		}
		
		size_t Max() const { return(list_size); }
		
		T* Data() { return(data); }
		
		//Dangerous: avoids use of 'slot_used' flag, may return uninitialized data.
		T& operator[] (size_t i) { if (i >= len) { return(data[len - 1]); } else { return(data[i]); } }
		
		size_t Len() { return(len); }
		
		void Clear() { len = 0; }
		
		bool Get(size_t i, T& element) const
		{ 
			if (i >= list_size) { return(false); }
			
			if (i < len)
			{
				element = data[i];
				return(true);
			}
			
			return(false);
		}

		bool Add(T const& element)
		{
			if (len < list_size)
			{
				data[len] = element;
				len++;
				return(true);
			}
			return(false);
		}
		
		T const& operator +=(T const& element) { Add(element); return(element); }			
		
		//~ size_t Find(T const& element) const
		//~ {
			//~ for(size_t i = 0; i < list_size; i++)
			//~ {
				//~ if ( (data[i] == element) && (slot_used[i]) )
				//~ {
					//~ return(i);
				//~ }
			//~ }
			//~ return(list_size);
		//~ }
};

#endif //_fixedlistlite_H_

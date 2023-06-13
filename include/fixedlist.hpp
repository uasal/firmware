/// \file
/// $Source: /raincloud/src/projects/include//fixedlist.hpp,v $
/// $Revision: 1.6 $
/// $Date: 2010/04/07 00:22:10 $
/// $Author: steve $
#ifndef _fixedlist_H_
#define _fixedlist_H_
#pragma once

#include <stddef.h>

template<typename T, size_t list_size=16> class fixedlist
{
	private:
	
		T data[list_size] __attribute__((aligned(4)));;
		bool slot_used[list_size];
	
	public:
		
		fixedlist() // : 
		{ 
			Clear();
		}
		
		fixedlist(const size_t len, const T t[]) // : 
		{ 
			size_t max = len;
			if (max > list_size) { max = list_size; }
			Clear();
			for (size_t i = 0; i < max; i++) { Add(t[i]); }
		}
		
		size_t Size() const { return(list_size); }
		
		T* Data() { return(data); }
		
		//Dangerous: avoids use of 'slot_used' flag, may return uninitialized data.
		T& operator[] (size_t i) { if (i >= list_size) { return(data[list_size - 1]); } else { return(data[i]); } }
		
		size_t Len()
		{
			size_t i = 0;
			
			for (i = 0; i < list_size; i++) { if (!slot_used[i]) { break; } }
			
			return(i);
		}
		
		bool Used(const size_t i) const 
		{
			if (i >= list_size) { return(false); }
			
			return(slot_used[i]);
		}
		
		bool Get(size_t i, T& element) const
		{ 
			if (i >= list_size) { return(false); }
			
			if (slot_used[i])
			{
				element = data[i];
				return(true);
			}
			
			return(false);
		}

		void Clear()
		{
			for (size_t i = 0; i < list_size; i++)
			{
				slot_used[i] = false;
			}
		}
		
		bool Add(T const& element)
		{
			for(size_t i = 0; i < list_size; i++)
			{
				if(!(slot_used[i]))
				{
					data[i] = element;
					slot_used[i] = true;
					return(true);
				}
			}
			return(false);
		}
		
		T const& operator +=(T const& element) { Add(element); return(element); }			
		
		bool AddUnique(T const& element) //returns "Replaced"
		{
			if(Find(element) < list_size) { return(true); }
			
			//It's not there already, put it in:
			return(Add(element));
		}
		
		bool UpdateUnique(T const& element)
		{
			//Is there one that equals this one in there already?
			size_t i = Find(element);
			
			if(i < list_size) 
			{ 
				data[i] = element;
				return(true); 
			}
			
			//It's not there already, just put it in:
			Add(element);
			
			return(false);
		}
		
		bool Delete(T const& element)
		{
			for(size_t i = 0; i < list_size; i++)
			{
				if( data[i] == element)
				{
					slot_used[i] = false;
					return(true);
				}
			}
			return(false);
		}
		
		bool Delete(const size_t index)
		{
			if (index >= list_size) { return(false); }
			
			slot_used[index] = false;
			
			return(true);
		}
		
		size_t Find(T const& element) const
		{
			for(size_t i = 0; i < list_size; i++)
			{
				if ( (data[i] == element) && (slot_used[i]) )
				{
					return(i);
				}
			}
			return(list_size);
		}
		
		bool Replace(size_t i, const T& element) 
		{ 
			if (i >= list_size) { return(false); }
			
			if (slot_used[i])
			{
				data[i] = element;
				return(true);
			}
			
			return(false);
		}
};

#endif //_fixedlist_H_

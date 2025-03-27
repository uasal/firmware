//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
//

#include <stdint.h>
#include <format/formatf.h>

#ifdef __cplusplus
extern "C" {
#endif

	extern unsigned long __vector_table_start;
	extern unsigned long _evector_table;
	extern unsigned long __text_start;
	extern unsigned long _etext;
	extern unsigned long __exidx_start;
	extern unsigned long __exidx_end;
	extern unsigned long __data_start;
	extern unsigned long _edata;
	extern unsigned long __bss_start__;
	extern unsigned long _ebss;
	extern unsigned long __heap_start__;
	extern unsigned long _eheap;
	extern unsigned long __stack_start__;
	extern unsigned long _estack;
	extern unsigned long _end;	

	//We're gonna wanna figure out how to send this out all uarts?...should be a binary buildparams packet of some sort on the binary uarts...
	
	void ShowBuildParameters()
	{
		
		formatf("\nBuild parameters: \n");
		formatf("__vector_table_start: 0x%.8lX\n", (uint32_t)__vector_table_start);
		formatf("_evector_table: 0x%.8lX\n", (uint32_t)_evector_table);
		formatf("__text_start: 0x%.8lX\n", (uint32_t)__text_start);
		formatf("_etext: 0x%.8lX\n", (uint32_t)_etext);
		formatf("__exidx_start: 0x%.8lX\n", (uint32_t)__exidx_start);
		formatf("__exidx_end: 0x%.8lX\n", (uint32_t)__exidx_end);
		formatf("__data_start: 0x%.8lX\n", (uint32_t)__data_start);
		formatf("_edata: 0x%.8lX\n", (uint32_t)_edata);
		formatf("__bss_start__: 0x%.8lX\n", (uint32_t)__bss_start__);
		formatf("_ebss: 0x%.8lX\n", (uint32_t)_ebss);
		formatf("__heap_start__: 0x%.8lX\n", (uint32_t)__heap_start__);
		formatf("_eheap: 0x%.8lX\n", (uint32_t)_eheap);
		formatf("__stack_start__: 0x%.8lX\n", (uint32_t)__stack_start__);
		formatf("_estack: 0x%.8lX\n", (uint32_t)_estack);
		formatf("_end: 0x%.8lX\n", (uint32_t)_end);
		formatf("\n\n");
	}

#ifdef __cplusplus
}
#endif

//EOF

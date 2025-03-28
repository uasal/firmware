//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
//

#include <stdint.h>
#include "format/formatf.h"
#include "uart/UartParserTable.hpp"
#include "cgraph/CGraphPacket.hpp"

#include "arm/smartfusion/CortexMFaults.hpp"

void ProcessAllUarts();

#ifdef __cplusplus
extern "C" {
#endif

	// NOTE: If you are using CMSIS, the registers can also be
	// accessed through CoreDebug->DHCSR & CoreDebug_DHCSR_C_DEBUGEN_Msk
	#define HALT_IF_DEBUGGING()                              \
	  do {                                                   \
		if ((*(volatile uint32_t *)0xE000EDF0) & (1 << 0)) { \
		  __asm("bkpt 1");                                   \
		}                                                    \
	} while (0)
  	
	void hard_fault_handler_c(ContextStateFrame* CSFrm)
	{
		formatf ("\n\n\n!HardFault!\n");

		// If and only if a debugger is attached, execute a breakpoint
		// instruction so we can take a look at what triggered the fault
		HALT_IF_DEBUGGING();
		// Now when a fault occurs and a debugger is attached, we will automatically hit a breakpoint and be able to look at the register state! Re-examining our illegal_instruction_execution example we have:
		//	0x00000244 in my_fault_handler_c (frame=0x200005d8 <ucHeap+1136>) at ./cortex-m-fault-debug/startup.c:94
		//	94	  HALT_IF_DEBUGGING();
		//	(gdb) p/a *frame
		//	$18 = {
		//	  r0 = 0x0 <g_pfnVectors>,
		//	  r1 = 0x200003c4 <ucHeap+604>,
		//	  r2 = 0x10000000,
		//	  r3 = 0xe0000000,
		//	  r12 = 0x200001b8 <ucHeap+80>,
		//	  lr = 0x61 <illegal_instruction_execution+16>,
		//	  return_address = 0xe0000000,
		//	  xpsr = 0x80000000
		//	}

		CSFrm->formatf();
		formatf ("\n");
		//~ UFSR->formatf();
		//~ formatf ("\n");
		//~ BFSR->formatf();
		//~ formatf ("\n");
		//~ MMFSR->formatf();
		//~ formatf ("\n");
		CFSR->formatf();
		formatf ("\n");
		HFSR->formatf();
		formatf ("\n");
		BFAR->formatf();
		formatf ("\n");
		MMFAR->formatf();
		formatf ("\n");
		
		//We're gonna wanna figure out how to send this out all uarts...should be a binary crash packet of some sort on the binary uarts...
		//~ for (size_t i = 0; i < NumBinaryUartParsers; i++)
		//~ {
			//~ //void TxBinaryPacket(const uint16_t PayloadType, const uint32_t SerialNumber, const void* PayloadData, const size_t PayloadLen) const
			//~ if (NULL != BinaryUartParsers[i]) { BinaryUartParsers[i]->TxBinaryPacket(CGraphPayloadTypeHardFault, 0, &Fault, sizeof(CGraphHardFaultPayload)); }
		//~ }

		//~ while (1); //we really don't wanna lock up in flight!
		//~ while(1) { ProcessAllUarts(); }
		for (size_t i = 0; i < 4096; i++) { ProcessAllUarts(); }		
		
		// Flight: just attempt to reboot and recover...
		// see: https://developer.arm.com/documentation/dui0552/a/Cihehdge for the proper way to reboot
		void (*boot)() = 0;
		boot();
		
		//Ok, don't do this (yet)!: it's the correct way to reboot, but somehow it doesn't clear the fault so it goes into an infinite loop of calling this function:
		//~ ApplicationInterruptResetControlRegister Reboot(ApplicationInterruptResetControlRegisterVectKey, 1);
		//~ *AIRCR = Reboot;
	}
	
	void bus_fault_handler_c (unsigned int * hardfault_args)
	{
		unsigned int stacked_lr;
		unsigned int stacked_pc;
		
		formatf ("\n\n\n!BusFault!\n");
		
		stacked_pc = ((unsigned long) hardfault_args[6]);
		stacked_lr = ((unsigned long) hardfault_args[5]);

		formatf ("PC [R15] = %x\n", stacked_pc);
		formatf ("LR [R14] = %x\n", stacked_lr);
		
		for (size_t i = 0; i < 4096; i++) { ProcessAllUarts(); }		
		
		//Flight: just attempt to reboot and recover...
		void (*boot)() = 0;
		boot();
	}
	
	void usage_fault_handler_c (unsigned int * hardfault_args)
	{
		unsigned int stacked_lr;
		unsigned int stacked_pc;
		
		formatf ("\n\n\n!UsageFault!\n");
		
		stacked_pc = ((unsigned long) hardfault_args[6]);
		stacked_lr = ((unsigned long) hardfault_args[5]);

		formatf ("PC [R15] = %x\n", stacked_pc);
		formatf ("LR [R14] = %x\n", stacked_lr);
		
		for (size_t i = 0; i < 4096; i++) { ProcessAllUarts(); }		
		
		//Flight: just attempt to reboot and recover...
		void (*boot)() = 0;
		boot();
	}
		
	void memmang_fault_handler_c (unsigned int * hardfault_args)
	{
		unsigned int stacked_lr;
		unsigned int stacked_pc;
		
		formatf ("\n\n\n!MemMangFault!\n");
		
		stacked_pc = ((unsigned long) hardfault_args[6]);
		stacked_lr = ((unsigned long) hardfault_args[5]);

		formatf ("PC [R15] = %x\n", stacked_pc);
		formatf ("LR [R14] = %x\n", stacked_lr);
		
		for (size_t i = 0; i < 4096; i++) { ProcessAllUarts(); }		
		
		//Flight: just attempt to reboot and recover...
		void (*boot)() = 0;
		boot();
	}
	

#ifdef __cplusplus
}
#endif

//EOF

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

#ifdef __cplusplus
extern "C" {
#endif
  	
	//We're gonna wanna figure out how to send this out all uarts...should be a binary crash packet of some sort on the binary uarts...
	
	void hard_fault_handler_c (unsigned int * hardfault_args)
	{
		unsigned int stacked_r0;
		unsigned int stacked_r1;
		unsigned int stacked_r2;
		unsigned int stacked_r3;
		unsigned int stacked_r12;
		unsigned int stacked_lr;
		unsigned int stacked_pc;
		unsigned int stacked_psr;
		
	    formatf ("\n\n!MajorCrashSegFaultHandler()!\n");
		
		stacked_r0 = ((unsigned long) hardfault_args[0]);
		stacked_r1 = ((unsigned long) hardfault_args[1]);
		stacked_r2 = ((unsigned long) hardfault_args[2]);
		stacked_r3 = ((unsigned long) hardfault_args[3]);

		stacked_r12 = ((unsigned long) hardfault_args[4]);
		stacked_lr = ((unsigned long) hardfault_args[5]);
		stacked_pc = ((unsigned long) hardfault_args[6]);
		stacked_psr = ((unsigned long) hardfault_args[7]);

		formatf ("R0 = %x\n", stacked_r0);
		formatf ("R1 = %x\n", stacked_r1);
		formatf ("R2 = %x\n", stacked_r2);
		formatf ("R3 = %x\n", stacked_r3);
		formatf ("R12 = %x\n", stacked_r12);
		formatf ("LR [R14] = %x  subroutine call return address\n", stacked_lr);
		formatf ("PC [R15] = %x  program counter\n", stacked_pc);
		formatf ("PSR = %x\n", stacked_psr);
		formatf ("BFAR = %x\n", (*((volatile unsigned long *)(0xE000ED38))));
		formatf ("CFSR = %x\n", (*((volatile unsigned long *)(0xE000ED28))));
		formatf ("HFSR = %x\n", (*((volatile unsigned long *)(0xE000ED2C))));
		formatf ("DFSR = %x\n", (*((volatile unsigned long *)(0xE000ED30))));
		formatf ("AFSR = %x\n", (*((volatile unsigned long *)(0xE000ED3C))));
		//~ this is an STM32 thing? formatf ("SCB_SHCSR = %x\n", SCB->SHCSR);
		
		CGraphHardFaultPayload Fault;
	
		Fault.R0 = stacked_r0;
		Fault.R1 = stacked_r1;
		Fault.R2 = stacked_r2;
		Fault.R3 = stacked_r3;
		Fault.R12 = stacked_r12;
		Fault.LR = stacked_lr;
		Fault.PC = stacked_pc;
		Fault.PSR = stacked_psr;
		Fault.BFAR = (*((volatile unsigned long *)(0xE000ED38)));
		Fault.CFSR = (*((volatile unsigned long *)(0xE000ED28)));
		Fault.HFSR = (*((volatile unsigned long *)(0xE000ED2C)));
		Fault.DFSR = (*((volatile unsigned long *)(0xE000ED30)));
		Fault.AFSR = (*((volatile unsigned long *)(0xE000ED3C)));

		for (size_t i = 0; i < NumBinaryUartParsers; i++)
		{
			//void TxBinaryPacket(const uint16_t PayloadType, const uint32_t SerialNumber, const void* PayloadData, const size_t PayloadLen) const
			if (NULL != BinaryUartParsers[i]) { BinaryUartParsers[i]->TxBinaryPacket(CGraphPayloadTypeHardFault, 0, &Fault, sizeof(CGraphHardFaultPayload)); }
		}

		//~ while (1); //we really don't wanna lock up in flight!
		
		//Just attempt to reboot and recover...
		void (*boot)() = 0;
		boot();
	}

#ifdef __cplusplus
}
#endif

//EOF

#
#/           University of Arizona
#/           Steward Observatory
#/           UASAL - UA Space Astrophysics Labratory
#/           CAAO - Center for Astronomical Adaptive Optics
#/           MagAOX
#
	.syntax unified 
	
	.extern hard_fault_handler_c 
	.extern bus_fault_handler_c 
	.extern usage_fault_handler_c 
	.extern memmang_fault_handler_c 
	
	.global HardFault_Handler 
	.type   HardFault_Handler, %function
	HardFault_Handler: 
	TST LR, #4 
	ITE EQ 
	MRSEQ R0, MSP 
	MRSNE R0, PSP 
	B hard_fault_handler_c 
	
	.global BusFault_Handler 
	.type   BusFault_Handler, %function
	BusFault_Handler: 
	TST LR, #4 
	ITE EQ 
	MRSEQ R0, MSP 
	MRSNE R0, PSP 
	B bus_fault_handler_c 
	
	.global UsageFault_Handler 
	.type   UsageFault_Handler, %function
	UsageFault_Handler: 
	TST LR, #4 
	ITE EQ 
	MRSEQ R0, MSP 
	MRSNE R0, PSP 
	B usage_fault_handler_c 
	
	.global MemMangFault_Handler 
	.type   MemMangFault_Handler, %function
	MemMangFault_Handler: 
	TST LR, #4 
	ITE EQ 
	MRSEQ R0, MSP 
	MRSNE R0, PSP 
	B memmang_fault_handler_c 
		
#EOF

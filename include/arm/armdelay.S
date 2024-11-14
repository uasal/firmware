#
#/           University of Arizona
#/           Steward Observatory
#/           UASAL - UA Space Astrophysics Labratory
#/           CAAO - Center for Astronomical Adaptive Optics
#/           MagAOX
#

# "For GCC; works on CM0, CM3, ARM7, ARM9... -Paul Curtis, Rowley Associates Ltd"

	.syntax unified 
	
	.global ArmDelayLoop 
	.type   ArmDelayLoop, %function
	
	ArmDelayLoop: 
	
	1: subs r0, r0, #1
	bne 1b
	bx lr
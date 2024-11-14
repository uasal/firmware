//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
//

#include <stdint.h>
#include <arm/armdelay.h>

#ifdef __cplusplus
extern "C" {
#endif

	extern void ArmDelayLoop(const unsigned int microseconds);

	extern unsigned long long fclk_for_delay_loops;

	void delayus(const unsigned long microseconds)
	{
		unsigned long loops = ( (fclk_for_delay_loops * (unsigned long long)microseconds) / 1000000ULL ) + 1;

		ArmDelayLoop(loops);
	}

	void delayms(const unsigned long milliseconds)
	{
		delayus(milliseconds * 1000U);		
	}

	void delays(const unsigned long seconds)
	{
		delayms(seconds * 1000U);		
	}

#ifdef __cplusplus
};
#endif
//EOF

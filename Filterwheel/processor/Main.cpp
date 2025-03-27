//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
//

#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <algorithm>

#include "Delay.h"

#include "arm/BuildParameters.h"

#include "cgraph/CGraphFWHardwareInterface.hpp"

#include "format/formatf.h"

#include "uart/UartParserTable.hpp"

#include "Uarts.hpp"


#include "MonitorAdc.hpp"

extern "C"
{	
	unsigned long long fclk_for_delay_loops = 102000000;

	//Does the current clib need this?
    //~ void AtExit()
    //~ {
        //~ mwTerm();
    //~ }

	//Does the current clib need this?
    //~ void mwOutFunc(int c)
    //~ {
        //~ putchar(c);
    //~ }
};

int main(int argc, char *argv[])
{	
    //Tell C lib (stdio.h) not to buffer output, so we can ditch all the fflush(stdout) calls...
    setvbuf(stdout, NULL, _IONBF, 0);

    //~ if (argc > 2)

	FPGAUartPinoutUsb.putcqq('\n');
	FPGAUartPinoutUsb.putcqq('\n');
	FPGAUartPinoutUsb.putcqq('\n');
	FPGAUartPinoutUsb.putcqq('\n');
	FPGAUartPinoutUsb.putcqq('\n');
	FPGAUartPinoutUsb.putcqq('\n');
	FPGAUartPinoutUsb.putcqq('\n');
	FPGAUartPinoutUsb.putcqq('\n');
	FPGAUartPinoutUsb.putcqq('\n');
	FPGAUartPinoutUsb.putcqq('H');
	FPGAUartPinoutUsb.putcqq('e');
	FPGAUartPinoutUsb.putcqq('l');
	FPGAUartPinoutUsb.putcqq('l');
	FPGAUartPinoutUsb.putcqq('o');
    FPGAUartPinoutUsb.putcqq('-');
    FPGAUartPinoutUsb.putcqq('E');
    FPGAUartPinoutUsb.putcqq('S');
    FPGAUartPinoutUsb.putcqq('C');
    FPGAUartPinoutUsb.putcqq('-');
    FPGAUartPinoutUsb.putcqq('F');
    FPGAUartPinoutUsb.putcqq('W');
	FPGAUartPinoutUsb.putcqq('\n');

	FPGAUartPinout0.putcqq('\n');
	FPGAUartPinout0.putcqq('\n');
	FPGAUartPinout0.putcqq('\n');
	FPGAUartPinout0.putcqq('\n');
	FPGAUartPinout0.putcqq('\n');
	FPGAUartPinout0.putcqq('\n');
	FPGAUartPinout0.putcqq('\n');
	FPGAUartPinout0.putcqq('\n');
	FPGAUartPinout0.putcqq('\n');
	FPGAUartPinout0.putcqq('H');
	FPGAUartPinout0.putcqq('e');
	FPGAUartPinout0.putcqq('l');
	FPGAUartPinout0.putcqq('l');
	FPGAUartPinout0.putcqq('o');
    FPGAUartPinout0.putcqq('-');
    FPGAUartPinout0.putcqq('E');
    FPGAUartPinout0.putcqq('S');
    FPGAUartPinout0.putcqq('C');
    FPGAUartPinout0.putcqq('-');
    FPGAUartPinout0.putcqq('F');
    FPGAUartPinout0.putcqq('W');
	FPGAUartPinout0.putcqq('\n');


	formatf("\n\nESC-FW: v%s.b%s\n", GITVERSION, BUILDNUM);
    
	formatf("\nOffset of ControlRegister: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFWHardwareInterface, ControlRegister), 32UL);
	
	ShowBuildParameters();
	
	CGraphFWHardwareControlRegister HCR;
	HCR.PosLedsEnA = 1;
    HCR.PosLedsEnB = 1;
	HCR.MotorEnable = 1;
	HCR.ResetSteps = 1;
	FW->ControlRegister = HCR;		
	HCR.ResetSteps = 0;
	FW->ControlRegister = HCR;		
	
	formatf("\nESC-FW: Set control register.\n\n");        
	
	formatf("\nOffset of UartFifoUsb: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFWHardwareInterface, UartFifoUsb), 116UL);
	formatf("\nOffset of UartFifoUsbReadData: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFWHardwareInterface, UartFifoUsbReadData), 124UL);

	DbgUartUsb.Init();
	DbgUart485_0.Init();

    DbgUartUsb.SetEcho(false);
    DbgUart485_0.SetEcho(false);
	
	//~ MonitorAdc.SetMonitor(true);
	MonitorAdc.SetMonitor(false);
	MonitorAdc.Init();
	
	//~ uint8_t i = 0;
    while(true)
    {
		MonitorAdc.Process();
	
		ProcessAllUarts();
    }

    return(0);
}

//EOF

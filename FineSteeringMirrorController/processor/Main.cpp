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

#include "cgraph/CGraphPacket.hpp"

#include "cgraph/CGraphFSMHardwareInterface.hpp"
extern CGraphFSMHardwareInterface* volatile FSM;

#include "format/formatf.h"

#include "CmdTableAscii.hpp"

//~ #include "CmdTableBinary.hpp"

//~ #include "uart/BinaryUart.hpp"

#include "Uarts.hpp"

#include "MonitorAdc.hpp"
extern CGraphFSMMonitorAdc MonitorAdc;

//Enable this if malloc problems occur (!!we shouldn't be using malloc, but c-libraries sometimes link it in!!)
//~ class MTracer
//~ {
//~ public:

//~ MTracer()
//~ {
//~ putenv("MALLOC_TRACE=/home/root/FSMTrace.txt");
//~ mtrace(); /* Starts the recording of memory allocations and releases */
//~ }
//~ } mtracer;

extern "C"
{	
	unsigned long long fclk_for_delay_loops = 102000000;

    void wooinit(void) __attribute__((constructor));

	//Does the current clib need this?
    void AtExit()
    {
        //~ mwTerm();
    }

	//Does the current clib need this?
    void mwOutFunc(int c)
    {
        putchar(c);
    }
};

bool Process()
{
    bool Bored = true;
	
	MonitorAdc.Process();
	
	//Enable this if we need to debug ascii and binary on the same uart (note: madness ensues!)
	//~ {
		//~ if (FPGAUartPinout0.dataready())
		//~ {
			//~ Bored = false;
			
			//~ char c = FPGAUartPinout0.getcqq();
			
			//~ UsbUartAscii.remoteputcqq(c);
			//~ UsbUartBinary.remoteputcqq(c);
		//~ }
		//~ if (UsbUartAscii.remotedataready()) { FPGAUartPinout0.putcqq(UsbUartAscii.remotegetcqq()); }
		//~ if (UsbUartBinary.remotedataready()) { FPGAUartPinout0.putcqq(UsbUartBinary.remotegetcqq()); }
	//~ }
	
    //~ if (FpgaUartParser3.Process()) { Bored = false; }    
	//~ if (FpgaUartParser2.Process()) { Bored = false; }    
	//~ if (FpgaUartParser1.Process()) { Bored = false; }    
	//~ //if (FpgaUartParser0.Process()) { Bored = false; }    
	//~ //if (FpgaUartParserUsb.Process()) { Bored = false; }    
	//~ //if (DbgUartUsb.Process()) { Bored = false; }    
    if (DbgUart485_0.Process()) { Bored = false; }
	
    return(Bored);
}

int main(int argc, char *argv[])
{	
    //Tell C lib (stdio.h) not to buffer output, so we can ditch all the fflush(stdout) calls...
    //~ setvbuf(stdout, NULL, _IONBF, 0);

    //~ if (argc > 2)

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
	FPGAUartPinout0.putcqq(' ');
	FPGAUartPinout0.putcqq('E');
    FPGAUartPinout0.putcqq('S');
    FPGAUartPinout0.putcqq('C');
    FPGAUartPinout0.putcqq('-');
    FPGAUartPinout0.putcqq('F');
    FPGAUartPinout0.putcqq('S');
	FPGAUartPinout0.putcqq('M');
	FPGAUartPinout0.putcqq('\n');

	formatf("\n\nESC-FSM: v%s.b%s; Offset of ControlRegister: 0x%.2lX, expected: 0x%.2lX.", GITVERSION, BUILDNUM, (unsigned long)offsetof(CGraphFSMHardwareInterface, ControlRegister), 32UL);
	
	//~ ShowBuildParameters();

	//~ formatf("\nUartFifo3: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFSMHardwareInterface, UartFifo3), 152UL);
	//~ formatf("\nOffset of FSM->ControlRegister: 0x%.2lX, expected: 0x%.2lX; size: %lu.", (unsigned long)offsetof(CGraphFSMHardwareInterface, ControlRegister), 32UL, sizeof(CGraphFSMHardwareControlRegister));
	//~ formatf("\nOffset of FSM->MonitorAdcSpiTransactionRegister: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFSMHardwareInterface, MonitorAdcSpiTransactionRegister), 104UL);
	formatf("\nOffset of FSM->LatchAdcs: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFSMHardwareInterface, LatchAdcs), 200UL);
	formatf("\nOffset of FSM->AdcAAccumulator: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFSMHardwareInterface, AdcAAccumulator), 60UL);
	formatf("\nOffset of FSM->AdcBAccumulator: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFSMHardwareInterface, AdcBAccumulator), 68UL);
	formatf("\nOffset of FSM->Uart0RxFifoPeekReadAddr: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFSMHardwareInterface, Uart0RxFifoPeekReadAddr), 164UL);
	

	//~ DbgUartUsb.Init();
	DbgUart485_0.Init();

    //~ DbgUartUsb.SetEcho(false);
    DbgUart485_0.SetEcho(false);
	
	//~ MonitorAdc.SetMonitor(true);
	MonitorAdc.SetMonitor(false);
	MonitorAdc.Init();
	
	//~ uint8_t i = 0;
    while(true)
    {
		//~ FSM->ClockSteeringDacSetpoint = offsetof(CGraphFSMHardwareInterface, UartFifo0);
		
		Process();
		
		//~ CGraphBaudDividers Bauds;
		//~ Bauds.Divider0 = (102000000.0 / (115200.0 * 16.0)) - 1.0;
		//~ Bauds.Divider1 = (102000000.0 / (115200.0 * 16.0)) - 1.0;
		//~ Bauds.Divider2 = (102000000.0 / (115200.0 * 16.0)) - 1.0;
		//~ Bauds.Divider3 = (102000000.0 / (115200.0 * 16.0)) - 1.0;
		//~ FSM->BaudDividers = Bauds;
		
		//~ FPGAUartPinout0.putcqq('.');
		//~ FPGAUartPinout1.putcqq('*');
		//~ FPGAUartPinout2.putcqq('#');
		//~ FPGAUartPinout3.putcqq('$');
		
		//~ FSM->UartFifo0 = '.'; //period on port 1
		//~ FSM->UartFifo1 = '*'; //asterisk on port 2
		//~ FSM->UartFifo2 = '#'; //pound on port 3
		//~ FSM->UartFifo3 = '$'; //dolla on port 4
    }

    return(0);
}

//EOF

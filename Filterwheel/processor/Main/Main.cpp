#include <stdint.h>
#include <string.h>
#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif
  
#include "hal/hal.h"
#include "hal/hal_assert.h"
#include "Filterwheel_hw_platform.h"

#ifdef __cplusplus
}
#endif


#include "Delay.h"

#include "cgraph/CGraphFWHardwareInterface.hpp"
extern CGraphFWHardwareInterface* FW;	

#include "format/formatf.h"

#include "CmdTableAscii.hpp"

#include "uart/BinaryUart.hpp"

#include "uart/linux_pinout_circular_uart.hpp"

#include "FlightComms.hpp"

FPGABinaryUartCallbacks PacketCallbacks;
CGraphPacket FPGAUartProtocol;
FW_pinout_FPGAUart0 FPGAUartPinout0;
FW_pinout_FPGAUart1 FPGAUartPinout1;
FW_pinout_FPGAUart2 FPGAUartPinout2;
FW_pinout_FPGAUart3 FPGAUartPinout3;
FW_pinout_FPGAUartUsb FPGAUartPinoutUsb;

linux_pinout_circular_uart<char, 16, 512> UsbUartAscii; //We handle incoming bytes one at a time, but the outgoing buffer needs to be big enough to hold a whole packet or formatf string...
linux_pinout_circular_uart<char, 16, 256> UsbUartBinary;

//~ BinaryUart(struct IUart& pinout, struct IPacket& packet, const Cmd* cmds, const size_t numcmds, struct BinaryUartCallbacks& callbacks, const bool verbose = true, const uint64_t serialnum = InvalidSerialNumber);
BinaryUart FpgaUartParser3(FPGAUartPinout1, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, PacketCallbacks, false);
BinaryUart FpgaUartParser2(FPGAUartPinout2, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, PacketCallbacks, false);
BinaryUart FpgaUartParser1(FPGAUartPinout1, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, PacketCallbacks, false);
//~ BinaryUart FpgaUartParser0(FPGAUartPinout1, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, PacketCallbacks, false);
//~ BinaryUart FpgaUartParserUsb(FPGAUartPinoutUsb, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, PacketCallbacks, false);
BinaryUart FpgaUartParserUsb(UsbUartBinary, FPGAUartProtocol, BinaryCmds, NumBinaryCmds, PacketCallbacks, false);

#include "uart/TerminalUart.hpp"
char prompt[] = "\n\nESC-FW> ";
const char* TerminalUartPrompt()
{
    return(prompt);
}
//Handle incoming ascii cmds & binary packets from the usb
TerminalUart<16, 4096> DbgUartUsb(FPGAUartPinoutUsb, AsciiCmds, NumAsciiCmds, &TerminalUartPrompt, NoRTS, NoPrefix, false);
//TerminalUart<16, 4096> DbgUartUsb(UsbUartAscii, AsciiCmds, NumAsciiCmds, &TerminalUartPrompt, NoRTS, NoPrefix, false);
TerminalUart<16, 4096> DbgUart485_0(FPGAUartPinout0, AsciiCmds, NumAsciiCmds, &TerminalUartPrompt, NoRTS, NoPrefix, false);

#include "../MonitorAdc.hpp"
extern CGraphFWMonitorAdc MonitorAdc;

//~ class MTracer
//~ {
//~ public:

//~ MTracer()
//~ {
//~ putenv("MALLOC_TRACE=/home/root/FWTrace.txt");
//~ mtrace(); /* Starts the recording of memory allocations and releases */
//~ }
//~ } mtracer;

extern "C"
{
    void wooinit(void) __attribute__((constructor));
};

extern "C"
{
	int stdio_hook_putc(int c) 
	{ 
		FPGAUartPinout0.putcqq(c); 
		FPGAUartPinoutUsb.putcqq(c);
		return(c);
	}
};

extern "C"
{
	void asm_hard_fault_handler_c_container()
	{
		asm volatile
		(\
			".syntax unified ;" \
			\
			".global HardFault_Handler ;" \
			".extern hard_fault_handler_c ;" \
			\
			"HardFault_Handler: ;" \
			"TST LR, #4 ;" \
			"ITE EQ ;" \
			"MRSEQ R0, MSP ;" \
			"MRSNE R0, PSP ;" \
			"B hard_fault_handler_c ;" \
			\
		);
	}
	
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
		
	    const char Msg[] = "\n\n!MajorCrashSegFaultHandler()!\n";
        //~ write(stdout, Msg, strlen(Msg));
        DbgUartUsb.puts(Msg, strlen(Msg));
		DbgUart485_0.puts(Msg, strlen(Msg));
    
		stacked_r0 = ((unsigned long) hardfault_args[0]);
		stacked_r1 = ((unsigned long) hardfault_args[1]);
		stacked_r2 = ((unsigned long) hardfault_args[2]);
		stacked_r3 = ((unsigned long) hardfault_args[3]);

		stacked_r12 = ((unsigned long) hardfault_args[4]);
		stacked_lr = ((unsigned long) hardfault_args[5]);
		stacked_pc = ((unsigned long) hardfault_args[6]);
		stacked_psr = ((unsigned long) hardfault_args[7]);

		formatf ("\n\n[Hard fault handler - all numbers in hex]\n");
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

		while (1);
	}

    void AtExit()
    {
        //~ mwTerm();
    }

    void mwOutFunc(int c)
    {
        putchar(c);
    }
};

bool Process()
{
    bool Bored = true;
	
	MonitorAdc.Process();
	
	//~ if (FPGAUartPinoutUsb.dataready())
	//~ {
		//~ Bored = false;
		
		//~ char c = FPGAUartPinoutUsb.getcqq();
		
		//~ UsbUartAscii.remoteputcqq(c);
		//~ UsbUartBinary.remoteputcqq(c);
	//~ }
	//~ if (UsbUartAscii.remotedataready()) { FPGAUartPinoutUsb.putcqq(UsbUartAscii.remotegetcqq()); }
	//~ if (UsbUartBinary.remotedataready()) { FPGAUartPinoutUsb.putcqq(UsbUartBinary.remotegetcqq()); }

    if (FpgaUartParser3.Process()) { Bored = false; }    
	if (FpgaUartParser2.Process()) { Bored = false; }    
	if (FpgaUartParser1.Process()) { Bored = false; }    
	//~ if (FpgaUartParser0.Process()) { Bored = false; }    
	if (FpgaUartParserUsb.Process()) { Bored = false; }    
	if (DbgUartUsb.Process()) { Bored = false; }    
    if (DbgUart485_0.Process()) { Bored = false; }
	
    return(Bored);
}

void ProcessAllUarts()
{
	FpgaUartParser3.Process();
	FpgaUartParser2.Process();
	FpgaUartParser1.Process();
	//~ FpgaUartParser0.Process();
	FpgaUartParserUsb.Process();
	DbgUartUsb.Process();
	DbgUart485_0.Process();
}

int main(int argc, char *argv[])
{
	//~ uint16_t i = 0;
	
    //Tell C lib (stdio.h) not to buffer output, so we can ditch all the fflush(stdout) calls...
    //~ setvbuf(stdout, NULL, _IONBF, 0);

    //~ if (argc > 2)

    //~ //formatf("Welcome to FW v%s.b%s.\n", GITVERSION, BUILDNUM);

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
	FPGAUartPinoutUsb.putcqq(' ');
	FPGAUartPinoutUsb.putcqq('T');
	FPGAUartPinoutUsb.putcqq('E');
	FPGAUartPinoutUsb.putcqq('S');
	FPGAUartPinoutUsb.putcqq('S');
	FPGAUartPinoutUsb.putcqq('!');
	FPGAUartPinoutUsb.putcqq(' ');
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
	FPGAUartPinout0.putcqq(' ');
	FPGAUartPinout0.putcqq('T');
	FPGAUartPinout0.putcqq('E');
	FPGAUartPinout0.putcqq('S');
	FPGAUartPinout0.putcqq('S');
	FPGAUartPinout0.putcqq('!');
	FPGAUartPinout0.putcqq(' ');
    FPGAUartPinout0.putcqq('-');
    FPGAUartPinout0.putcqq('E');
    FPGAUartPinout0.putcqq('S');
    FPGAUartPinout0.putcqq('C');
    FPGAUartPinout0.putcqq('-');
    FPGAUartPinout0.putcqq('F');
    FPGAUartPinout0.putcqq('W');
	FPGAUartPinout0.putcqq('\n');

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
    register char * stack_ptr asm ("sp");
    
	
	//~ formatf("\nBuild parameters: \n");
    //~ formatf("__vector_table_start: 0x%.8lX\n", (uint32_t)__vector_table_start);
    //~ formatf("_evector_table: 0x%.8lX\n", (uint32_t)_evector_table);
    //~ formatf("__text_start: 0x%.8lX\n", (uint32_t)__text_start);
    //~ formatf("_etext: 0x%.8lX\n", (uint32_t)_etext);
    //~ formatf("__exidx_start: 0x%.8lX\n", (uint32_t)__exidx_start);
    //~ formatf("__exidx_end: 0x%.8lX\n", (uint32_t)__exidx_end);
    //~ formatf("__data_start: 0x%.8lX\n", (uint32_t)__data_start);
    //~ formatf("_edata: 0x%.8lX\n", (uint32_t)_edata);
    //~ formatf("__bss_start__: 0x%.8lX\n", (uint32_t)__bss_start__);
    //~ formatf("_ebss: 0x%.8lX\n", (uint32_t)_ebss);
    //~ formatf("__heap_start__: 0x%.8lX\n", (uint32_t)__heap_start__);
    //~ formatf("_eheap: 0x%.8lX\n", (uint32_t)_eheap);
    //~ formatf("__stack_start__: 0x%.8lX\n", (uint32_t)__stack_start__);
    //~ formatf("_estack: 0x%.8lX\n", (uint32_t)_estack);
    //~ formatf("stack pointer: 0x%.8lX\n", (uint32_t)stack_ptr);
    //~ formatf("_end: 0x%.8lX\n", (uint32_t)_end);
    //~ formatf("\n\n");

	//UART_init(&my_uart, COREUARTAPB_C0_0, BAUD_VALUE_115200, (DATA_8_BITS | NO_PARITY));
	//UART_polled_tx_string(&my_uart,(const uint8_t*)"\nFW: GO --->"); // getting here?


	//formatf("\n\nFW: Welcome...");
    
	//~ formatf("\n\nFW: Start User Interface...");    
	
    //~ GlobalRestore();

    //~ formatf("\nFW: Ready.\n");
	
	formatf("\n\nESC-FW: Offset of ControlRegister: 0x%.2lX, expected: 0x%.2lX.", (unsigned long)offsetof(CGraphFWHardwareInterface, ControlRegister), 88UL);
	
	CGraphFWHardwareControlRegister HCR;
	HCR.PosLedsEnA = 1;
    HCR.PosLedsEnB = 1;
	HCR.MotorEnable = 1;
	HCR.ResetSteps = 0;
	FW->ControlRegister = HCR;		
	
	formatf("\nESC-FW: Set control register.\n");        

    DbgUartUsb.SetEcho(false);
    DbgUart485_0.SetEcho(false);
	
	MonitorAdc.Init();
	
    while(true)
    {
		Process();
		
		//~ bool Bored = true;
		
		//Handle stdio (local) user interface:
        //~ if (Process())
        //~ {
            //~ Bored = false;
        //~ }
		
		//ENable this stuff if we want an intermediate buffer between the threads.
		//~ //Handle fpga (remote) user interface:
		//~ {
			//~ if (NULL != FW) 
			//~ {
				//~ CGraphFWUartStatusRegister UartStatus = FW->UartStatusRegister;
				//~ UartStatus.formatf();	
				
				//~ uint16_t FpgaUartBufferLen = UartStatus.Uart2RxFifoCount;
				//~ if ( (0 == FpgaUartBufferLen) && (0 == UartStatus.Uart2RxFifoEmpty) ) { FpgaUartBufferLen = 1; } //so we can be lazy about checking the high bytes...we really need to rearrange the fpga so we get the whole count as one integer...
				
				//~ if (FpgaUartBuffer.wasFull()) { FpgaUartBufferLen = 0; }
				
				//~ for (size_t i = 0; i < FpgaUartBufferLen; i++) 
				//~ { 
					//~ Bored = false; //if we're multithreaded, we need to know to give up our timeslice...
					//~ char c = FW->UartFifo;
					//~ putchar('$');
					//~ putchar(c);
					//~ putchar('\n');
					//~ FpgaUartBuffer.push(c); 
				//~ }
			//~ }
			
			//~ FpgaUart.Process();
		//~ }
		
		//~ if (FpgaUartParser2.Process()) { Bored = false; }
		//~ if (FpgaUartParser1.Process()) { Bored = false; }
		//~ if (FpgaUartParser0.Process()) { Bored = false; }
		
        //give up our timeslice so as not to bog the system:
        //~ if (Bored)
        //~ {
            //~ delayms(100);
        //~ }
		//delayms(1);
        //~ uint16_t j = offsetof(CGraphFWHardwareInterface, UartFifoUsb);
        //~ uint16_t k = offsetof(CGraphFWHardwareInterface, UartStatusRegisterUsb);
		//~ uint16_t k1 = offsetof(CGraphFWHardwareInterface, PosDetHomeA);		
		//~ uint16_t k2 = offsetof(CGraphFWHardwareInterface, PosDet7B);		
		//~ uint16_t k3 = offsetof(CGraphFWHardwareInterface, BaudDividers);		
		//~ uint16_t k4 = offsetof(CGraphFWHardwareInterface, UartFifo2);		
		//~ uint16_t k5 = offsetof(CGraphFWHardwareInterface, ControlRegister);		
		//~ uint16_t k6 = offsetof(CGraphFWHardwareInterface, PositionSensors);		
		//~ uint16_t k7 = offsetof(CGraphFWHardwareInterface, UartFifo3);		

		//~ i++;
		//~ FW->MotorControlStatus.SeekStep = j;
		//~ FW->MotorControlStatus.SeekStep = k;
		//FPGAUartPinout0.putcqq(k);
		//~ FPGAUartPinoutUsb.putcqq(i);
        //~ HW_set_32bit_reg(FILTERWHEEL_SB_0, j); // send all 32 bits and FPGA bus will truncate it
    }

    return(0);
}

//~ class FpgaThread : public EzThread
//~ {
//~ public:
	//~ FpgaThread() { BoredDelayuS = 1000; strcpy(ThreadName, "FpgaThread"); }
	//~ virtual ~FpgaThread() { }
	//~ virtual void ThreadInit();
	//~ virtual bool Process();
//~ };
//~ extern FpgaThread FpgaProcessor;

#include "arm/armdelay.h"

#ifdef __cplusplus
extern "C" {
#endif

void delayus(const unsigned long microseconds)
{
	unsigned long long fclk = 102000000;
	unsigned long loops = ( (fclk * (unsigned long long)microseconds) / 1000000ULL ) + 1;

	Delay4CyclesArm7tdmi(loops);
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

//This technically is a "BZIP2CRC32", not an "ANSICRC32"; seealso: https://crccalc.com/
uint32_t CRC32(const uint8_t* data, const size_t length)
{
	static const uint32_t table[256] = 
	{
    0x00000000UL,0x04C11DB7UL,0x09823B6EUL,0x0D4326D9UL,
    0x130476DCUL,0x17C56B6BUL,0x1A864DB2UL,0x1E475005UL,
    0x2608EDB8UL,0x22C9F00FUL,0x2F8AD6D6UL,0x2B4BCB61UL,
    0x350C9B64UL,0x31CD86D3UL,0x3C8EA00AUL,0x384FBDBDUL,
    0x4C11DB70UL,0x48D0C6C7UL,0x4593E01EUL,0x4152FDA9UL,
    0x5F15ADACUL,0x5BD4B01BUL,0x569796C2UL,0x52568B75UL,
    0x6A1936C8UL,0x6ED82B7FUL,0x639B0DA6UL,0x675A1011UL,
    0x791D4014UL,0x7DDC5DA3UL,0x709F7B7AUL,0x745E66CDUL,
    0x9823B6E0UL,0x9CE2AB57UL,0x91A18D8EUL,0x95609039UL,
    0x8B27C03CUL,0x8FE6DD8BUL,0x82A5FB52UL,0x8664E6E5UL,
    0xBE2B5B58UL,0xBAEA46EFUL,0xB7A96036UL,0xB3687D81UL,
    0xAD2F2D84UL,0xA9EE3033UL,0xA4AD16EAUL,0xA06C0B5DUL,
    0xD4326D90UL,0xD0F37027UL,0xDDB056FEUL,0xD9714B49UL,
    0xC7361B4CUL,0xC3F706FBUL,0xCEB42022UL,0xCA753D95UL,
    0xF23A8028UL,0xF6FB9D9FUL,0xFBB8BB46UL,0xFF79A6F1UL,
    0xE13EF6F4UL,0xE5FFEB43UL,0xE8BCCD9AUL,0xEC7DD02DUL,
    0x34867077UL,0x30476DC0UL,0x3D044B19UL,0x39C556AEUL,
    0x278206ABUL,0x23431B1CUL,0x2E003DC5UL,0x2AC12072UL,
    0x128E9DCFUL,0x164F8078UL,0x1B0CA6A1UL,0x1FCDBB16UL,
    0x018AEB13UL,0x054BF6A4UL,0x0808D07DUL,0x0CC9CDCAUL,
    0x7897AB07UL,0x7C56B6B0UL,0x71159069UL,0x75D48DDEUL,
    0x6B93DDDBUL,0x6F52C06CUL,0x6211E6B5UL,0x66D0FB02UL,
    0x5E9F46BFUL,0x5A5E5B08UL,0x571D7DD1UL,0x53DC6066UL,
    0x4D9B3063UL,0x495A2DD4UL,0x44190B0DUL,0x40D816BAUL,
    0xACA5C697UL,0xA864DB20UL,0xA527FDF9UL,0xA1E6E04EUL,
    0xBFA1B04BUL,0xBB60ADFCUL,0xB6238B25UL,0xB2E29692UL,
    0x8AAD2B2FUL,0x8E6C3698UL,0x832F1041UL,0x87EE0DF6UL,
    0x99A95DF3UL,0x9D684044UL,0x902B669DUL,0x94EA7B2AUL,
    0xE0B41DE7UL,0xE4750050UL,0xE9362689UL,0xEDF73B3EUL,
    0xF3B06B3BUL,0xF771768CUL,0xFA325055UL,0xFEF34DE2UL,
    0xC6BCF05FUL,0xC27DEDE8UL,0xCF3ECB31UL,0xCBFFD686UL,
    0xD5B88683UL,0xD1799B34UL,0xDC3ABDEDUL,0xD8FBA05AUL,
    0x690CE0EEUL,0x6DCDFD59UL,0x608EDB80UL,0x644FC637UL,
    0x7A089632UL,0x7EC98B85UL,0x738AAD5CUL,0x774BB0EBUL,
    0x4F040D56UL,0x4BC510E1UL,0x46863638UL,0x42472B8FUL,
    0x5C007B8AUL,0x58C1663DUL,0x558240E4UL,0x51435D53UL,
    0x251D3B9EUL,0x21DC2629UL,0x2C9F00F0UL,0x285E1D47UL,
    0x36194D42UL,0x32D850F5UL,0x3F9B762CUL,0x3B5A6B9BUL,
    0x0315D626UL,0x07D4CB91UL,0x0A97ED48UL,0x0E56F0FFUL,
    0x1011A0FAUL,0x14D0BD4DUL,0x19939B94UL,0x1D528623UL,
    0xF12F560EUL,0xF5EE4BB9UL,0xF8AD6D60UL,0xFC6C70D7UL,
    0xE22B20D2UL,0xE6EA3D65UL,0xEBA91BBCUL,0xEF68060BUL,
    0xD727BBB6UL,0xD3E6A601UL,0xDEA580D8UL,0xDA649D6FUL,
    0xC423CD6AUL,0xC0E2D0DDUL,0xCDA1F604UL,0xC960EBB3UL,
    0xBD3E8D7EUL,0xB9FF90C9UL,0xB4BCB610UL,0xB07DABA7UL,
    0xAE3AFBA2UL,0xAAFBE615UL,0xA7B8C0CCUL,0xA379DD7BUL,
    0x9B3660C6UL,0x9FF77D71UL,0x92B45BA8UL,0x9675461FUL,
    0x8832161AUL,0x8CF30BADUL,0x81B02D74UL,0x857130C3UL,
    0x5D8A9099UL,0x594B8D2EUL,0x5408ABF7UL,0x50C9B640UL,
    0x4E8EE645UL,0x4A4FFBF2UL,0x470CDD2BUL,0x43CDC09CUL,
    0x7B827D21UL,0x7F436096UL,0x7200464FUL,0x76C15BF8UL,
    0x68860BFDUL,0x6C47164AUL,0x61043093UL,0x65C52D24UL,
    0x119B4BE9UL,0x155A565EUL,0x18197087UL,0x1CD86D30UL,
    0x029F3D35UL,0x065E2082UL,0x0B1D065BUL,0x0FDC1BECUL,
    0x3793A651UL,0x3352BBE6UL,0x3E119D3FUL,0x3AD08088UL,
    0x2497D08DUL,0x2056CD3AUL,0x2D15EBE3UL,0x29D4F654UL,
    0xC5A92679UL,0xC1683BCEUL,0xCC2B1D17UL,0xC8EA00A0UL,
    0xD6AD50A5UL,0xD26C4D12UL,0xDF2F6BCBUL,0xDBEE767CUL,
    0xE3A1CBC1UL,0xE760D676UL,0xEA23F0AFUL,0xEEE2ED18UL,
    0xF0A5BD1DUL,0xF464A0AAUL,0xF9278673UL,0xFDE69BC4UL,
    0x89B8FD09UL,0x8D79E0BEUL,0x803AC667UL,0x84FBDBD0UL,
    0x9ABC8BD5UL,0x9E7D9662UL,0x933EB0BBUL,0x97FFAD0CUL,
    0xAFB010B1UL,0xAB710D06UL,0xA6322BDFUL,0xA2F33668UL,
    0xBCB4666DUL,0xB8757BDAUL,0xB5365D03UL,0xB1F740B4UL,
    };

	uint32_t crc = 0xffffffff;
	
	size_t len = length;
    while (len > 0)
    {
      crc = table[*data ^ ((crc >> 24) & 0xff)] ^ (crc << 8);
      data++;
      len--;
    }
    return crc ^ 0xffffffff;
}

//EOF

#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <setjmp.h>
#include <signal.h>
#include <syscall.h>
#include <execinfo.h>
#include <ucontext.h>
#include <sys/resource.h>

//DEBUG!
//~ #include "dbg/memwatch.h"
#include <mcheck.h>

#include "Delay.h"

#include "arm/LinuxUtils.h"
#include "arm/imx6/imx6-eim.h"
#include "uart/AsciiCmdUserInterfaceLinux.h"

#include "cgraph/CGraphDeprecatedPZTHardwareInterface.hpp"
int MmapHandle = 0;
CGraphPZTHardwareInterface* PZT = NULL;

bool MonitorBinaryUarts = false;

#include "uart/BinaryUart.hpp"
extern BinaryUart FpgaUartParser2;
extern BinaryUart FpgaUartParser1;
extern BinaryUart FpgaUartParser0;

//~ #include "uart/TerminalUart.hpp"
#include "CmdTableAscii.hpp"

#include "ClientSocket.hpp"

#include "eeprom/SDLogfileLinuxMmap.hpp"

//~ char prompt[] = "\n\nPZT> ";
//~ const char* TerminalUartPrompt()
//~ {
    //~ return(prompt);
//~ }
//Handle incoming ascii cmds & binary packets from the usb
//~ TerminalUart<1024, 1024> FpgaUart(FpgaHardwareUartPinout, AsciiCmds, NumAsciiCmds, &TerminalUartPrompt, NoRTS, NoPrefix, false);

//~ bool ProcessUserInterface();
//~ void StartUserInterface();

//~ MemWatch mW;

//~ class MTracer
//~ {
//~ public:

//~ MTracer()
//~ {
//~ putenv("MALLOC_TRACE=/home/root/PZTTrace.txt");
//~ mtrace(); /* Starts the recording of memory allocations and releases */
//~ }
//~ } mtracer;

extern "C"
{
    void wooinit(void) __attribute__((constructor));
};

extern "C"
{
    static void MajorCrashSegFaultHandler(int sig, siginfo_t *siginfo, void *context)
    {
        const char Msg[] = "\n\n!MajorCrashSegFaultHandler()!\n";
        //~ write(stdout, Msg, strlen(Msg));
        write(1, Msg, strlen(Msg));

        if (NULL != siginfo)
        {
            printf("signo: %d\n", siginfo->si_signo);
            printf("errno: %d\n", siginfo->si_errno);
            printf("sigcode: %d\n", siginfo->si_code);
            printf("sigval: %d\n", (int)siginfo->si_value.sival_int);
            printf("addr: %p\n", siginfo->si_addr);
            //~ printf("si_lower: %p\n", siginfo->si_lower);
            //~ printf("si_upper: %p\n", siginfo->si_upper);
            //~ printf("si_call_addr: %p\n", siginfo->si_call_addr); //v5.x compiler only!
            //~ printf("si_syscall: %d\n", siginfo->si_syscall); //v5.x compiler only!
        }

        //~ void *trace[16];
        //~ char **messages = (char **)NULL;
        //~ int i, trace_size = 0;
        ucontext_t *uc = (ucontext_t *)context;

        //~ /* Do something useful with siginfo_t */
        //~ if (sig == SIGSEGV)
        //~ printf("Got signal %d, faulty address is %p, "
        //~ "from %p\n", sig, info->si_addr,
        //~ uc->uc_mcontext.gregs[REG_EIP]);
        //~ else
        //~ printf("Got signal %d#92;n", sig);

        //~ trace_size = backtrace(trace, 16);
        //~ /* overwrite sigaction with caller's address */
        //~ trace[1] = (void *) uc->uc_mcontext.gregs[REG_EIP];

        //~ messages = backtrace_symbols(trace, trace_size);
        //~ /* skip first stack frame (points here) */
        //~ printf("[bt] Execution path:#92;n");
        //~ for (i=1; i<trace_size; ++i)
        //~ printf("[bt] %s#92;n", messages[i]);

#ifdef __X86__
        ShowCallStack((void *) uc->uc_mcontext.gregs[REG_EIP]);
#elseif __x86_64__
        ShowCallStack((void *) uc->uc_mcontext.gregs[REG_RIP]);
#else
        ShowCallStack((void *) uc->uc_mcontext.arm_pc);
#endif

        //~ mwAbort();

        abort(); //"I have seen a lot of answers here performing a signal handler and then exiting. That's the way to go, but remember a very important fact: If you want to get the core dump for the generated error, you can't call exit(status). Call abort() instead!"
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

    if (ProcessUserInterface())
    {
        Bored = false;
    }
    
    return(Bored);
}

int main(int argc, char *argv[])
{
	char LogBuffer[4096];

    //Tell C lib (stdio.h) not to buffer output, so we can ditch all the fflush(stdout) calls...
    setvbuf(stdout, NULL, _IONBF, 0);

    //~ if (argc > 2)

    printf("Welcome to PZT v%s.b%s.\n", GITVERSION, BUILDNUM);

    printf("\nPZT: Configure Ram bus wait states...\n");

	//The particulars of connecting the NXP iMX6 processor external memory bus to our FPGA
    eim_setup();

    printf("\n\nPZT: Configure crash handler...\n");
    {
        spawn("ulimit -c unlimited");
        spawn("ulimit -a");

        //~ http://man7.org/linux/man-pages/man2/sigaction.2.html
        //~ SA_ONSTACK
        //~ Call the signal handler on an alternate signal stack
        //~ provided by sigaltstack(2).  If an alternate stack is not
        //~ available, the default stack will be used.  This flag is
        //~ meaningful only when establishing a signal handler.

		//~ The siginfo_t argument to a SA_SIGINFO handler
        //~ When the SA_SIGINFO flag is specified in act.sa_flags, the signal
        //~ handler address is passed via the act.sa_sigaction field.  This
        //~ handler takes three arguments, as follows:

        //~ void
        //~ handler(int sig, siginfo_t *info, void *ucontext)
        //~ {
        //~ ...
        //~ }

        //~ The siginfo_t data type is a structure with the following fields:

        //~ siginfo_t {
        //~ int      si_signo;     /* Signal number */
        //~ int      si_errno;     /* An errno value */
        //~ int      si_code;      /* Signal code */
        //~ int      si_trapno;    /* Trap number that caused
        //~ hardware-generated signal
        //~ (unused on most architectures) */
        //~ pid_t    si_pid;       /* Sending process ID */
        //~ uid_t    si_uid;       /* Real user ID of sending process */
        //~ int      si_status;    /* Exit value or signal */
        //~ clock_t  si_utime;     /* User time consumed */
        //~ clock_t  si_stime;     /* System time consumed */
        //~ sigval_t si_value;     /* Signal value */
        //~ int      si_int;       /* POSIX.1b signal */
        //~ void    *si_ptr;       /* POSIX.1b signal */
        //~ int      si_overrun;   /* Timer overrun count;
        //~ POSIX.1b timers */
        //~ int      si_timerid;   /* Timer ID; POSIX.1b timers */
        //~ void    *si_addr;      /* Memory location which caused fault */
        //~ long     si_band;      /* Band event (was int in
        //~ glibc 2.3.2 and earlier) */
        //~ int      si_fd;        /* File descriptor */
        //~ short    si_addr_lsb;  /* Least significant bit of address
        //~ (since Linux 2.6.32) */
        //~ void    *si_lower;     /* Lower bound when address violation
        //~ occurred (since Linux 3.19) */
        //~ void    *si_upper;     /* Upper bound when address violation
        //~ occurred (since Linux 3.19) */
        //~ int      si_pkey;      /* Protection key on PTE that caused
        //~ fault (since Linux 4.6) */
        //~ void    *si_call_addr; /* Address of system call instruction
        //~ (since Linux 3.5) */
        //~ int      si_syscall;   /* Number of attempted system call
        //~ (since Linux 3.5) */
        //~ unsigned int si_arch;  /* Architecture of attempted system call
        //~ (since Linux 3.5) */
        //~ }

        //~ SIGILL, SIGFPE, SIGSEGV, SIGBUS, and SIGTRAP fill in si_addr with
        //~ the address of the fault.  On some architectures, these signals
        //~ also fill in the si_trapno field.

        //This Works:
        struct sigaction sa;
        memset(&sa, 0, sizeof(sa));
        sigemptyset(&sa.sa_mask);

        sa.sa_flags     = SA_RESTART | SA_SIGINFO;
        sa.sa_sigaction = MajorCrashSegFaultHandler;

        sigaction(SIGSEGV, &sa, NULL);
        sigaction(SIGILL, &sa, NULL);
        sigaction(SIGFPE, &sa, NULL);
        sigaction(SIGSEGV, &sa, NULL);
        sigaction(SIGBUS, &sa, NULL);
        sigaction(SIGUSR1, &sa, NULL);

        //~ mwSetOutFunc(mwOutFunc);

        //~ atexit (AtExit); //Set up normal exit handler to write dbg files
    }

    //~ {
    //~ struct rlimit limit; //RLIM_INFINITY denotes no limit on a resource; RLIMIT_CORE: When 0 no core dump files are created
    //~ printf("\n\nPZT: Show process resource limits (inf=%llu): ", RLIM_INFINITY);
    //~ prlimit(0, RLIMIT_AS, NULL, &limit);
    //~ printf("RLIMIT_AS: %llu/%llu; ", limit.rlim_cur, limit.rlim_max);
    //~ prlimit(0, RLIMIT_DATA, NULL, &limit);
    //~ printf("RLIMIT_DATA: %llu/%llu; ", limit.rlim_cur, limit.rlim_max);
    //~ printf ("%dKiB\n", getpagesize ()/1024); return 0;
    //~ prlimit(0, RLIMIT_MEMLOCK, NULL, &limit);
    //~ printf("RLIMIT_MEMLOCK: %llu/%llu\n\n", limit.rlim_cur, limit.rlim_max);
    //~ }

    struct rlimit limit;
    prlimit(0, RLIMIT_CORE, NULL, &limit);
    printf("RLIMIT_CORE: %llu/%llu; ", (long long unsigned int)limit.rlim_cur, (long long unsigned int)limit.rlim_max);
    limit.rlim_cur = RLIM_INFINITY;
    limit.rlim_max = RLIM_INFINITY;
    prlimit(0, RLIMIT_CORE, &limit, NULL);
    prlimit(0, RLIMIT_CORE, NULL, &limit);
    printf("RLIMIT_CORE: %llu/%llu; ", (long long unsigned int)limit.rlim_cur, (long long unsigned int)limit.rlim_max);

    //DEBUG!! Profiling is ~major~ slowdown!
    //~ {
        //~ printf("\n\nPZT: Initialize thread profiler...");
        //~ wooinit();
    //~ }

    //~ printf("\n\nPZT: Load configuration...");

    //~ CreatePZTTempFolder();

    //~ printf("\n\nPZT: Start Fpga Hardware Manger thread...");
    //~ {
        //~ FpgaProcessor.Init();
    //~ }

	printf("\n\nPZT: Connect to hardware...");    
    
	int err = CGraphPZTProtoHardwareMmapper::open(MmapHandle, PZT);
	
	if (err < 0) { printf("\n\nPZT: Coudn't connect to hardware: %d", err); }
	
	printf("\n\nPZT: Start User Interface...");    
	
	InitClientSocket();

    //~ GlobalRestore();
	
	SDLogfileLinuxMmap Logfile;
	//~ Logfile.InitLogFile("/media/mmcblk1p1/PZTAdcLog.csv", "");
	//~ if (Logfile.IsOpen())
	//~ {
		//~ snprintf(LogBuffer, 4095, "Time_s, Time_us, Araw, Braw, Craw, Avolts, Bvolts, Cvolts\n");
		//~ Logfile.Log(LogBuffer, strnlen(LogBuffer, 4095));
	//~ }
	

    char pwd[PATH_MAX];
    getcwd(pwd, PATH_MAX);
    printf("\nPZT: operating in path \"%s\".\n", pwd);

    printf("\nPZT: Ready.\n");
	
	pid_t tid = syscall(SYS_gettid);
	printf("\nMainThread ID: %d\n\n PZT> ", tid);

	StartUserInterface();
	
	AdcAccumulator A, B, C;
	AdcAccumulator LastA, LastB, LastC;
						
    while(true)
    {
		bool Bored = true;
		
		//Handle stdio (local) user interface:
        if (Process())
        {
            Bored = false;
        }
		
		//ENable this stuff if we want an intermediate buffer between the threads.
		//~ //Handle fpga (remote) user interface:
		//~ {
			//~ if (NULL != PZT) 
			//~ {
				//~ CGraphPZTUartStatusRegister UartStatus = PZT->UartStatusRegister;
				//~ UartStatus.printf();	
				
				//~ uint16_t FpgaUartBufferLen = UartStatus.Uart2RxFifoCount;
				//~ if ( (0 == FpgaUartBufferLen) && (0 == UartStatus.Uart2RxFifoEmpty) ) { FpgaUartBufferLen = 1; } //so we can be lazy about checking the high bytes...we really need to rearrange the fpga so we get the whole count as one integer...
				
				//~ if (FpgaUartBuffer.wasFull()) { FpgaUartBufferLen = 0; }
				
				//~ for (size_t i = 0; i < FpgaUartBufferLen; i++) 
				//~ { 
					//~ Bored = false; //if we're multithreaded, we need to know to give up our timeslice...
					//~ char c = PZT->UartFifo;
					//~ putchar('$');
					//~ putchar(c);
					//~ putchar('\n');
					//~ FpgaUartBuffer.push(c); 
				//~ }
			//~ }
			
			//~ FpgaUart.Process();
		//~ }
		
		if (FpgaUartParser2.Process()) { Bored = false; }
		if (FpgaUartParser1.Process()) { Bored = false; }
		if (FpgaUartParser0.Process()) { Bored = false; }
		
		//Log the A/D's if possible:
		if (Logfile.IsOpen())
		{
			struct timeval Now;
			gettimeofday(&Now,NULL);

			A = PZT->AdcAAccumulator;
			B = PZT->AdcBAccumulator;
			C = PZT->AdcCAccumulator;
			
			if ( (A.all != LastA.all) || (B.all != LastB.all) || (C.all != LastC.all) )
			{
				LastA = A;
				LastB = B;
				LastC = C;
				
				double Av, Bv, Cv;
				Av = (8.192 * ((A.Samples - 0) / A.NumAccums)) / 16777216.0;
				Bv = (8.192 * ((B.Samples - 0) / B.NumAccums)) / 16777216.0;
				Cv = (8.192 * ((C.Samples - 0) / C.NumAccums)) / 16777216.0;
				
				snprintf(LogBuffer, 4095, "\n%08ld, %lf, %+lld, %+lld, %+lld, %+1.6lf, %+1.6lf, %+1.6lf\n", Now.tv_sec, ((double)Now.tv_usec / 1000000.0), A.Samples, B.Samples, C.Samples, Av, Bv, Cv);
				Logfile.Log(LogBuffer, strnlen(LogBuffer, 4095));
			}
		}
		
        //give up our timeslice so as not to bog the system:
        //~ if (Bored)
        {
            //~ delayus(100);
			delayus(10);
        }
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

//EOF


//------------------------------------------------------------------------------
// Headers
//------------------------------------------------------------------------------
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdint.h>
#include <sys/mman.h>

//------------------------------------------------------------------------------
// Defines
//------------------------------------------------------------------------------
#define MEMORY_DEVICE   "/dev/mem"

//------------------------------------------------------------------------------
// CPU Registers
//------------------------------------------------------------------------------
enum IMX6DQ_REGISTER_OFFSET
{
        EIM_CS0GCR1                             = 0x021B8000,
        EIM_CS0GCR2                             = 0x021B8004,
        EIM_CS0RCR1                             = 0x021B8008,
        EIM_CS0RCR2                             = 0x021B800C,
        EIM_CS0WCR1                             = 0x021B8010,
        EIM_CS0WCR2                             = 0x021B8014,
        EIM_WCR                                 = 0x021B8090,
        EIM_WIAR                                = 0x021B8094,
        EIM_EAR                                 = 0x021B8098,
};

//------------------------------------------------------------------------------
// Structures
//------------------------------------------------------------------------------
union EIM_CS_GCR1
{
	unsigned int all;
	
	struct
	{
        unsigned int    csen                    : 1;
        unsigned int    swr                     : 1;
        unsigned int    srd                     : 1;
        unsigned int    mum                     : 1;
        unsigned int    wfl                     : 1;
        unsigned int    rfl                     : 1;
        unsigned int    cre                     : 1;
        unsigned int    crep                    : 1;
        unsigned int    bl                      : 3;
        unsigned int    wc                      : 1;
        unsigned int    bcd                     : 2;
        unsigned int    bcs                     : 2;
        unsigned int    dsz                     : 3;
        unsigned int    sp                      : 1;
        unsigned int    csrec                   : 3;
        unsigned int    aus                     : 1;
        unsigned int    gbc                     : 3;
        unsigned int    wp                      : 1;
        unsigned int    psz                     : 4;
	
	} __attribute__((__packed__));
	
	void formatf() { ::printf("\nEIM_CS_GCR1: 0x%.8X; csen: %X,  swr: %X,  srd: %X,  mum: %X,  wfl: %X,  rfl: %X,  cre: %X,  crep: %X,  bl: %X,  wc: %X,  bcd: %X,  bcs: %X,  dsz: %X,  sp: %X,  csrec: %X,  aus: %X,  gbc: %X,  wp: %X,  psz: %X, ", all, csen, swr, srd, mum, wfl, rfl, cre, crep, bl, wc, bcd, bcs, dsz, sp, csrec, aus, gbc, wp, psz); }
} __attribute__((__packed__));

union EIM_CS_GCR2
{
	unsigned int all;
	
	struct
	{
        unsigned int    adh                     :  2;
        unsigned int    reserved_3_2            :  2;
        unsigned int    daps                    :  4;
        unsigned int    dae                     :  1;
        unsigned int    dap                     :  1;
        unsigned int    reserved_11_10          :  2;
        unsigned int    mux16_byp_grant         :  1;
        unsigned int    reserved_31_13          : 19;
	
	} __attribute__((__packed__));
	
	void formatf() { ::printf("\nEIM_CS_GCR2: 0x%.8X; adh: %X,  reserved_3_2: %X,  daps: %X,  dae: %X,  dap: %X,  reserved_11_10: %X,  mux16_byp_grant: %X,  reserved_31_13: %X, ", all, adh, reserved_3_2, daps, dae, dap, reserved_11_10, mux16_byp_grant, reserved_31_13); }
} __attribute__((__packed__));

union EIM_CS_RCR1
{
	unsigned int all;
	
	struct
	{
        unsigned int    rcsn                    : 3; //Read CS Negation w/s
        unsigned int    reserved_3              : 1;
        unsigned int    rcsa                    : 3; //Read CS Assertion w/s
        unsigned int    reserved_7              : 1;
        unsigned int    oen                     : 3; //OE Negation w/s
        unsigned int    reserved_11             : 1;
        unsigned int    oea                     : 3; //OE Assertion w/s
        unsigned int    reserved_15             : 1;
        unsigned int    radvn                   : 3; //ADV Negation w/s
        unsigned int    ral                     : 1; //Read ADV Low
        unsigned int    radva                   : 3; //ADV Assertion w/s
        unsigned int    reserved_23             : 1;
        unsigned int    rwsc                    : 6; //Read Wait State Control
        unsigned int    reserved_31_30          : 2;
	
	} __attribute__((__packed__));
	
	void formatf() { ::printf("\nEIM_CS_RCR1: 0x%.8X; rcsn: %X,  reserved_3: %X,  rcsa: %X,  reserved_7: %X,  oen: %X,  reserved_11: %X,  oea: %X,  reserved_15: %X,  radvn: %X,  ral: %X,  radva: %X,  reserved_23: %X,  rwsc: %X,  reserved_31_30: %X, ", all, rcsn, reserved_3, rcsa, reserved_7, oen, reserved_11, oea, reserved_15, radvn, ral, radva, reserved_23, rwsc, reserved_31_30); }
} __attribute__((__packed__));

union EIM_CS_RCR2
{
	unsigned int all;
	
	struct
	{
        unsigned int    rben                    :  3;
        unsigned int    rbe                     :  1;
        unsigned int    rbea                    :  3;
        unsigned int    reserved_7              :  1;
        unsigned int    rl                      :  2;
        unsigned int    reserved_11_10          :  2;
        unsigned int    pat                     :  3;
        unsigned int    apr                     :  1;
        unsigned int    reserved_31_16          : 16;
	
	} __attribute__((__packed__));
	
	void formatf() { ::printf("\nEIM_CS_RCR2: 0x%.8X; rben: %X,  rbe: %X,  rbea: %X,  reserved_7: %X,  rl: %X,  reserved_11_10: %X,  pat: %X,  apr: %X,  reserved_31_16: %X, ", all, rben, rbe, rbea, reserved_7, rl, reserved_11_10, pat, apr, reserved_31_16); }
} __attribute__((__packed__));


union EIM_CS_WCR1
{
	unsigned int all;
	
	struct
	{
        unsigned int    wcsn                    : 3; //Write CS Negation w/s
        unsigned int    wcsa                    : 3; //Write CS Assertion w/s
        unsigned int    wen                     : 3; //WE Negation w/s
        unsigned int    wea                     : 3; //WE Assertion w/s
        unsigned int    wben                    : 3; //BE[3:0] Negation w/s
        unsigned int    wbea                    : 3; //BE Assertion w/s
        unsigned int    wadvn                   : 3; //ADV Negation w/s
        unsigned int    wadva                   : 3; //ADV Assertion w/s
        unsigned int    wwsc                    : 6; //Write Wait State Control
        unsigned int    wbed                    : 1; //Write Byte Enable Disable
        unsigned int    wal                     : 1; //Write ADV Low
	
	} __attribute__((__packed__));

		void formatf() { ::printf("\nEIM_CS_WCR1: 0x%.8X; wcsn: %X, wcsa: %X, wen: %X, wea: %X, wben: %X, wbea: %X, wadvn: %X, wadva: %X, wwsc: %X, wbed: %X, wal: %X", all, wcsn, wcsa, wen, wea, wben, wbea, wadvn, wadva, wwsc, wbed, wal); }
} __attribute__((__packed__));

union EIM_CS_WCR2
{
	unsigned int all;
	
	struct
	{
        unsigned int    wbcdd                   :  1;
        unsigned int    reserved_31_1           : 31;
	
	} __attribute__((__packed__));

	void formatf() { ::printf("\nEIM_CS_WCR2: 0x%.8X; wbcdd: %X, reserved_31_1: %X, ", all, wbcdd, reserved_31_1); }
} __attribute__((__packed__));


union EIM_WCR
{
	unsigned int all;
	
	struct
	{
        unsigned int    bcm                     :  1;
        unsigned int    gbcd                    :  2;
        unsigned int    reserved_3              :  1;
        unsigned int    inten                   :  1;
        unsigned int    intpol                  :  1;
        unsigned int    reserved_7_6            :  2;
        unsigned int    wdog_en                 :  1;
        unsigned int    wdog_limit              :  2;
        unsigned int    reserved_31_11          : 21;

	} __attribute__((__packed__));
	
	void formatf() { ::printf("\nEIM_CS_WCR: 0x%.8X; bcm: %X,  gbcd: %X,  reserved_3: %X,  inten: %X,  intpol: %X,  reserved_7_6: %X,  wdog_en: %X,  wdog_limit: %X,  reserved_31_11: %X, ", all, bcm, gbcd, reserved_3, inten, intpol, reserved_7_6, wdog_en, wdog_limit, reserved_31_11); }
} __attribute__((__packed__));


union EIM_WIAR
{
	unsigned int all;
	
	struct
	{
        unsigned int    ips_req                 :  1;
        unsigned int    ips_ack                 :  1;
        unsigned int    irq                     :  1;
        unsigned int    errst                   :  1;
        unsigned int    aclk_en                 :  1;
        unsigned int    reserved_31_5           : 27;

	} __attribute__((__packed__));
	
	void formatf() { ::printf("\nEIM_CS_WIAR: 0x%.8X; ips_req: %X,  ips_ack: %X,  irq: %X,  errst: %X,  aclk_en: %X,  reserved_31_5: %X, ", all, ips_req, ips_ack, irq, errst, aclk_en, reserved_31_5); }
} __attribute__((__packed__));


struct EIM_EAR
{
        unsigned int    error_addr              : 32;
};


//------------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------------
static long     mem_page_size   = 0;
static int      mem_dev_fd      = -1;
static void *   mem_map_ptr     = MAP_FAILED;
static off_t    mem_base_addr   = 0;


//------------------------------------------------------------------------------
// Prototypes
//------------------------------------------------------------------------------
static void     _eim_setup_eim          (void);
static void     _eim_cleanup            (void);
static off_t    _eim_calc_offset        (off_t);
static void     _eim_remap_mem          (off_t);


//------------------------------------------------------------------------------
// Write a 32-bit word to EIM.
// If EIM is not set up correctly, this will abort with a bus error.
//------------------------------------------------------------------------------
void eim_write_32(off_t offset, uint32_t *pvalue)
{
    // calculate memory offset
    uint32_t *ptr = (uint32_t *)_eim_calc_offset(offset);

    // write data to memory
    memcpy(ptr, pvalue, sizeof(uint32_t));
}

//------------------------------------------------------------------------------
// Read a 32-bit word from EIM.
// If EIM is not set up correctly, this will abort with a bus error.
//------------------------------------------------------------------------------
void eim_read_32(off_t offset, uint32_t *pvalue)
{
    // calculate memory offset
    uint32_t *ptr = (uint32_t *)_eim_calc_offset(offset);

    // read data from memory
    memcpy(pvalue, ptr, sizeof(uint32_t));
}


//------------------------------------------------------------------------------
// Calculate an offset into the currently-mapped EIM page.
//------------------------------------------------------------------------------
static off_t _eim_calc_offset(off_t offset)
{
    // make sure that memory is mapped
    if (mem_map_ptr == MAP_FAILED)
        _eim_remap_mem(offset);

    // calculate starting and ending addresses of currently mapped page
    off_t offset_low    = mem_base_addr;
    off_t offset_high   = mem_base_addr + (mem_page_size - 1);

    // check that offset is in currently mapped page, remap new page otherwise
    if ((offset < offset_low) || (offset > offset_high))
        _eim_remap_mem(offset);

    // calculate pointer
    return (off_t)mem_map_ptr + (offset - mem_base_addr);
}


//------------------------------------------------------------------------------
// Map in a new EIM page.
//------------------------------------------------------------------------------
static void _eim_remap_mem(off_t offset)
{
    // unmap old memory page if needed
    if (mem_map_ptr != MAP_FAILED) {
        if (munmap(mem_map_ptr, mem_page_size) != 0) {
            fprintf(stderr, "ERROR: munmap() failed.\n");
            exit(EXIT_FAILURE);
        }
    }

    // calculate starting address of new page
    while (offset % mem_page_size)
        offset--;

    // try to map new memory page
    mem_map_ptr = mmap(NULL, mem_page_size, PROT_READ | PROT_WRITE, MAP_SHARED,
                       mem_dev_fd, offset);
    if (mem_map_ptr == MAP_FAILED) {
        fprintf(stderr, "ERROR: mmap() failed.\n");
        exit(EXIT_FAILURE);
    }

    // save last mapped page address
    mem_base_addr = offset;
}

//------------------------------------------------------------------------------
// Set up EIM bus. Returns 0 on success, -1 on failure.
//------------------------------------------------------------------------------
int eim_setup(void)
{
    // register cleanup function
    if (atexit(_eim_cleanup) != 0) {
        fprintf(stderr, "ERROR: atexit() failed.\n");
        return -1;
    }

    // determine memory page size to use in mmap()
    mem_page_size = sysconf(_SC_PAGESIZE);
    if (mem_page_size < 1) {
        fprintf(stderr, "ERROR: sysconf(_SC_PAGESIZE) == %ld\n", mem_page_size);
        return -1;
    }

    // try to open memory device
    mem_dev_fd = open(MEMORY_DEVICE, O_RDWR | O_SYNC);
    if (mem_dev_fd == -1) {
        fprintf(stderr, "ERROR: open(%s) failed.\n", MEMORY_DEVICE);
        return -1;
    }

    /* We need to properly configure EIM mode and all the corresponding parameters.
     * That's a lot of code, let's do it now.
     */
    _eim_setup_eim();

    // done
    return 0;
}


//------------------------------------------------------------------------------
// Shut down EIM bus. This is called automatically on exit().
//------------------------------------------------------------------------------
static void _eim_cleanup(void)
{
    // unmap memory if needed
    if (mem_map_ptr != MAP_FAILED)
        if (munmap(mem_map_ptr, mem_page_size) != 0)
            fprintf(stderr, "WARNING: munmap() failed.\n");

    // close memory device if needed
    if (mem_dev_fd != -1)
        if (close(mem_dev_fd) != 0)
            fprintf(stderr, "WARNING: close() failed.\n");
}

//------------------------------------------------------------------------------
// Configure EIM mode and all the corresponding parameters. That's a lot of code.
//------------------------------------------------------------------------------
static void _eim_setup_eim(void)
{
    // create structures
    EIM_CS_GCR1  gcr1;
    EIM_CS_GCR2  gcr2;
    EIM_CS_RCR1  rcr1;
    EIM_CS_RCR2  rcr2;
    EIM_CS_WCR1  wcr1;
    EIM_CS_WCR2  wcr2;
    //~ EIM_WCR      wcr;
    //~ EIM_WIAR     wiar;
    //~ struct EIM_EAR ear;

    // read all the registers
    eim_read_32(EIM_CS0GCR1, (uint32_t *)&gcr1);
    eim_read_32(EIM_CS0GCR2, (uint32_t *)&gcr2);
    eim_read_32(EIM_CS0RCR1, (uint32_t *)&rcr1);
    eim_read_32(EIM_CS0RCR2, (uint32_t *)&rcr2);
    eim_read_32(EIM_CS0WCR1, (uint32_t *)&wcr1);
    eim_read_32(EIM_CS0WCR2, (uint32_t *)&wcr2);
    //~ eim_read_32(EIM_WCR,        (uint32_t *)&wcr);
    //~ eim_read_32(EIM_WIAR,       (uint32_t *)&wiar);
    //~ eim_read_32(EIM_EAR,        (uint32_t *)&ear);

	gcr1.formatf();
	gcr2.formatf();
	rcr1.formatf();
	rcr2.formatf();
	wcr1.formatf();
	wcr2.formatf();
	//~ wcr.formatf();
	//~ wiar.formatf();
	//~ ear.formatf();
	
    //~ // manipulate registers as needed
    //~ gcr1.csen           = 1;    // chip select is enabled
    //~ gcr1.swr            = 1;    // write is sync
    //~ gcr1.srd            = 1;    // read is sync
    //~ gcr1.mum            = 1;    // address and data are multiplexed
    //~ gcr1.wfl            = 0;    // write latency is not fixed
    //~ gcr1.rfl            = 0;    // read latency is not fixed
    //~ gcr1.cre            = 0;    // CRE signal not needed
    //~ //gcr1.crep         = x;    // don't care, CRE not used
    //~ gcr1.bl             = 4;    // burst length
    //~ gcr1.wc             = 0;    // write is not continuous
    //~ gcr1.bcd            = 3;    // BCLK divisor is 3+1=4
    //~ gcr1.bcs            = 1;    // delay from ~CS to BCLK is 1 cycle
    //~ gcr1.dsz            = 1;    // 16 bits per databeat at DATA[15:0]
	gcr1.dsz            = 4;    // 8 bits per databeat at DATA[15:0]
    //~ gcr1.sp             = 0;    // supervisor protection is disabled
    //~ gcr1.csrec          = 1;    // ~CS recovery is 1 cycle
    //~ gcr1.aus            = 1;    // address is not shifted
    //~ gcr1.gbc            = 1;    // ~CS gap is 1 cycle
    //~ gcr1.wp             = 0;    // write protection is not enabled
    //~ //gcr1.psz          = x;    // don't care, page mode is not used

    //~ gcr2.adh            = 0;    // address hold duration is 1 cycle
    //~ //gcr2.daps         = x;    // don't care, DTACK is not used
    //~ gcr2.dae            = 0;    // DTACK is not used
    //~ //gcr2.dap          = x;    // don't care, DTACK is not used
    //~ gcr2.mux16_byp_grant= 1;    // enable grant mechanism
    //~ gcr2.reserved_3_2   = 0;    // must be 0
    //~ gcr2.reserved_11_10 = 0;    // must be 0
    //~ gcr2.reserved_31_13 = 0;    // must be 0

    //~ rcr1.rcsn         = 7;
	rcr1.rcsn         = 0;
	
    rcr1.rcsa           = 3;    // no delay for ~CS needed
	
    //~ rcr1.oen          = 7;
    //~ rcr1.oen          = 3;
	rcr1.oen          = 0;
    
	rcr1.oea            = 7;
    //~ rcr1.radvn          = 0;    // no delay for ~LBA needed
    //~ rcr1.ral            = 0;    // clear ~LBA when needed
    //~ rcr1.radva          = 0;    // no delay for ~LBA needed
    
	//~ rcr1.rwsc           = 63;    // 63 w/s
    rcr1.rwsc           = 31;    // 63 w/s
    
	rcr1.reserved_3     = 0;    // must be 0
    rcr1.reserved_7     = 0;    // must be 0
    rcr1.reserved_11    = 0;    // must be 0
    rcr1.reserved_15    = 0;    // must be 0
    rcr1.reserved_23    = 0;    // must be 0
    rcr1.reserved_31_30 = 0;    // must be 0

    //~ //rcr2.rben         = x;    // don't care in sync mode
    //~ rcr2.rbe            = 0;    // BE is disabled
    //~ //rcr2.rbea         = x;    // don't care when BE is not used
    //~ rcr2.rl             = 0;    // read latency is 0
    //~ //rcr2.pat          = x;    // don't care when page read is not used
    //~ rcr2.apr            = 0;    // page read mode is not used
    //~ rcr2.reserved_7     = 0;    // must be 0
    //~ rcr2.reserved_11_10 = 0;    // must be 0
    //~ rcr2.reserved_31_16 = 0;    // must be 0

    //~ //wcr1.wcsn         = x;    // don't care in sync mode
    //~ wcr1.wcsa           = 0;    // no delay for ~CS needed
    wcr1.wen          = 0;    // don't care in sync mode
    wcr1.wea            = 7;    // no delay for ~WR_N needed
    //~ //wcr1.wben         = x;    // don't care in sync mode
    //~ //wcr1.wbea         = x;    // don't care in sync mode
    //~ wcr1.wadvn          = 0;    // no delay for ~LBA needed
    //~ wcr1.wadva          = 0;    // no delay for ~LBA needed
    //~ wcr1.wwsc           = 63; //Max wait states
	wcr1.wwsc           = 31; //Max wait states
    //~ wcr1.wbed           = 1;    // BE is disabled
    //~ wcr1.wal            = 0;    // clear ~LBA when needed

    //~ wcr2.wbcdd          = 0;    // write clock division is not needed
    //~ wcr2.reserved_31_1  = 0;    // must be 0

    //~ wcr.bcm             = 0;    // clock is only active during access
    //~ //wcr.gbcd          = x;    // don't care when BCM=0
    //~ wcr.inten           = 0;    // interrupt is not used
    //~ //wcr.intpol        = x;    // don't care when interrupt is not used
    //~ wcr.wdog_en         = 1;    // watchdog is enabled
    //~ wcr.wdog_limit      = 00;   // timeout is 128 BCLK cycles
    //~ wcr.reserved_3      = 0;    // must be 0
    //~ wcr.reserved_7_6    = 0;    // must be 0
    //~ wcr.reserved_31_11  = 0;    // must be 0

    //~ wiar.ips_req        = 0;    // IPS not needed
    //~ wiar.ips_ack        = 0;    // IPS not needed
    //~ //wiar.irq          = x;    // don't touch
    //~ //wiar.errst        = x;    // don't touch
    //~ wiar.aclk_en        = 1;    // clock is enabled
    //~ wiar.reserved_31_5  = 0;    // must be 0

    //ear.error_addr    = x;    // read-only

    // write modified registers
    eim_write_32(EIM_CS0GCR1,   (uint32_t *)&gcr1);
    eim_write_32(EIM_CS0GCR2,   (uint32_t *)&gcr2);
    eim_write_32(EIM_CS0RCR1,   (uint32_t *)&rcr1);
    eim_write_32(EIM_CS0RCR2,   (uint32_t *)&rcr2);
    eim_write_32(EIM_CS0WCR1,   (uint32_t *)&wcr1);
    eim_write_32(EIM_CS0WCR2,   (uint32_t *)&wcr2);
    //~ eim_write_32(EIM_WCR,               (uint32_t *)&wcr);
    //~ eim_write_32(EIM_WIAR,      (uint32_t *)&wiar);
	//~ /*  eim_write_32(EIM_EAR,       (uint32_t *)&ear);*/
	
	//readback:
    eim_read_32(EIM_CS0GCR1, (uint32_t *)&gcr1);
    eim_read_32(EIM_CS0GCR2, (uint32_t *)&gcr2);
    eim_read_32(EIM_CS0RCR1, (uint32_t *)&rcr1);
    eim_read_32(EIM_CS0RCR2, (uint32_t *)&rcr2);
    eim_read_32(EIM_CS0WCR1, (uint32_t *)&wcr1);
    eim_read_32(EIM_CS0WCR2, (uint32_t *)&wcr2);
    //~ eim_read_32(EIM_WCR,        (uint32_t *)&wcr);
    //~ eim_read_32(EIM_WIAR,       (uint32_t *)&wiar);
    //~ eim_read_32(EIM_EAR,        (uint32_t *)&ear);

	gcr1.formatf();
	gcr2.formatf();
	rcr1.formatf();
	rcr2.formatf();
	wcr1.formatf();
	wcr2.formatf();
	//~ wcr.formatf();
	//~ wiar.formatf();
	//~ ear.formatf();
}


	//pg 1051 of  uC/IMX6SLDRM:

	//https://github.com/bunnie/novena-fpga-drivers/blob/master/eim.c	

	//~ write_kernel_memory( 0x020c4080, 0xcf3, 0, 4 ); // ungate eim slow clocks

	// EIM_CS0GCR1   
	// 0101 0  001 1   001    0   001 11  00  0  000  1    0   1   1   1   0   0   1
	// PSZ  WP GBC AUS CSREC  SP  DSZ BCS BCD WC BL   CREP CRE RFL WFL MUM SRD SWR CSEN
	//
	// PSZ = 0101  256 words page size
	// WP = 0      (not protected)
	// GBC = 001   min 1 cycles between chip select changes
	// AUS = 0     address shifted according to port size
	// CSREC = 001 min 1 cycles between CS, OE, WE signals
	// SP = 0      no supervisor protect (user mode access allowed)
	// DSZ = 001   16-bit port resides on DATA[15:0]
	// BCS = 11    3 clock delay for burst generation
	// BCD = 00    divide EIM clock by 1 for burst clock
	// WC = 0      specify write bust according to BL
	// BL = 000    4 words wrap burst length
	// CREP = 1    non-PSRAM, set to 1
	// CRE = 0     CRE is disabled
	// RFL = 1     fixed latency reads (don't monitor WAIT)
	// WFL = 1     fixed latency writes (don't monitor WAIT)
	// MUM = 1     multiplexed mode enabled
	// SRD = 0     no synch reads
	// SWR = 0     no synch writes
	// CSEN = 1    chip select is enabled

	// 0101 0111 1111    0001 1100  0000  1011   1   0   0   1
	// 0x5  7    F        1   C     0     B    9

	// 0101 0001 1001    0001 1100  0000  1011   1001
	// 5     1    9       1    c     0     B      9

	//~ write_kernel_memory( 0x21b8000, 0x5191C0B9, 0, 4 );

	// EIM_CS0GCR2   
	//  MUX16_BYP_GRANT = 1
	//  ADH = 1 (1 cycles)
	//  0x1001
	//~ write_kernel_memory( 0x21b8004, 0x1001, 0, 4 );


	// EIM_CS0RCR1   
	// 00 000101 0 000   0   000   0 000 0 000 0 000 0 000
	//    RWSC     RADVA RAL RADVN   OEA   OEN   RCSA  RCSN
	// RWSC 000101    5 cycles for reads to happen
	//
	// 0000 0111 0000   0011   0000 0000 0000 0000
	//  0    7     0     3      0  0    0    0
	// 0000 0101 0000   0000   0 000 0 000 0 000 0 000
	//  write_kernel_memory( 0x21b8008, 0x05000000, 0, 4 );
	//~ write_kernel_memory( 0x21b8008, 0x0A024000, 0, 4 );
	// EIM_CS0RCR2  
	// 0000 0000 0   000 00 00 0 010  0 001 
	//           APR PAT    RL   RBEA   RBEN
	// APR = 0   mandatory because MUM = 1
	// PAT = XXX because APR = 0
	// RL = 00   because async mode
	// RBEA = 000  these match RCSA/RCSN from previous field
	// RBEN = 000
	// 0000 0000 0000 0000 0000  0000
	//~ write_kernel_memory( 0x21b800c, 0x00000000, 0, 4 );

	// EIM_CS0WCR1
	// 0   0    000100 000   000   000  000  010 000 000  000
	// WAL WBED WWSC   WADVA WADVN WBEA WBEN WEA WEN WCSA WCSN
	// WAL = 0       use WADVN
	// WBED = 0      allow BE during write
	// WWSC = 000100 4 write wait states
	// WADVA = 000   same as RADVA
	// WADVN = 000   this sets WE length to 1 (this value +1)
	// WBEA = 000    same as RBEA
	// WBEN = 000    same as RBEN
	// WEA = 010     2 cycles between beginning of access and WE assertion
	// WEN = 000     1 cycles to end of WE assertion
	// WCSA = 000    cycles to CS assertion
	// WCSN = 000    cycles to CS negation
	// 1000 0111 1110 0001 0001  0100 0101 0001
	// 8     7    E    1    1     4    5    1
	// 0000 0111 0000 0100 0000  1000 0000 0000
	// 0      7    0   4    0     8    0     0
	// 0000 0100 0000 0000 0000  0100 0000 0000
	//  0    4    0    0     0    4     0    0

	//~ write_kernel_memory( 0x21b8010, 0x09080800, 0, 4 );

	// EIM_WCR
	// BCM = 1   free-run BCLK
	// GBCD = 0  don't divide the burst clock
	//~ write_kernel_memory( 0x21b8090, 0x1, 0, 4 );

	// EIM_WIAR 
	// ACLK_EN = 1
	//~ write_kernel_memory( 0x21b8094, 0x10, 0, 4 );

//------------------------------------------------------------------------------
// End-of-File
//------------------------------------------------------------------------------

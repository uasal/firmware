//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
//

#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/mman.h>

#include "CGraphDeprecatedPZTHardwareInterface.hpp"

#define FPGA_MEM_ADDR 0x08000000
#define FPGA_MAP_MASK 0x00000FFF

const uint32_t CGraphPZTHardwareInterface::DacFullScale = 0x007FFFFFUL; //2^20 - 1 (do these need to be initialized in constructor even though it's static can't remember?)
const double CGraphPZTHardwareInterface::DacDriverFullScaleOutputVoltage = 150.0; //Volts, don't get your fingers near this thing!
const double CGraphPZTHardwareInterface::PZTDriverFullScaleOutputTravel = 0.00001; //Meters; note our granularity is this / DacFullScale which is approx 10pm

const off_t CGraphPZTProtoHardwareMmapper::FpgaMmapAdress = 0x08000000UL;
const off_t CGraphPZTProtoHardwareMmapper::FpgaMmapMask = 0x00000FFFUL;
const char CGraphPZTProtoHardwareMmapper::FpgaBusEmulationPathName[] = "~/.UACGraph/PZTFpgaBusEmulator.ram";

int CGraphPZTProtoHardwareMmapper::open(int& FpgaHandle, CGraphPZTHardwareInterface*& FpgaBus)
{
    if (FpgaHandle > 0) { return(EBADF); } //already open?
    if (NULL != FpgaBus) { return(EALREADY); } //already mapped?

    #ifdef EMULATE_PZT_HARDWARE
    FpgaHandle = ::open(getenv("FPGABUS_EMULATION_PATHNAME") ? getenv("FPGABUS_EMULATION_PATHNAME") : FpgaBusEmulationPathName
                       , O_RDWR | O_CREAT, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP
                       ); //O_NONBLOCK?
    #else
    FpgaHandle = ::open("/dev/mem", O_RDWR | O_SYNC);
    #endif
    if (FpgaHandle <= 0)
    {
        printf("\nMapFpgaBus(): error in open(/dev/mem): %ld.\n", (long int)errno);
        return(errno);
    }
    else
    {
        #ifdef EMULATE_PZT_HARDWARE
        int ft = ftruncate(FpgaHandle, sizeof(CGraphPZTHardwareInterface));  //Make sure the file is big enough for all read/writes to mmap
        if (ft < 0)
        {
                perror("\nMapFpgaBus(): error in ftruncate() ");
                return(errno);
        }
        #endif

        #ifdef EMULATE_PZT_HARDWARE
        FpgaBus = reinterpret_cast<CGraphPZTHardwareInterface*>(mmap(0, sizeof(CGraphPZTHardwareInterface), PROT_READ | PROT_WRITE, MAP_SHARED, FpgaHandle, 0));
        #else
        FpgaBus = reinterpret_cast<CGraphPZTHardwareInterface*>(mmap(0, sizeof(CGraphPZTHardwareInterface), PROT_READ | PROT_WRITE, MAP_SHARED, FpgaHandle, FPGA_MEM_ADDR & ~FPGA_MAP_MASK)); //we're using #define's here for FPGA_MEM_ADDR cause this code worked, using the off_t consts seems suspect (like ~ is just gonna turn all the high bits on?
        #endif

        if (MAP_FAILED == FpgaBus)
        {
            printf("\nMapFpgaBus(): error in mmap(): %ld.\n", (long int)errno);
            return(errno);
        }
        else
        {
            #ifdef EMULATE_PZT_HARDWARE
            printf("\nMapFpgaBus(): file Mapped at: %p.\n", FpgaBus);
            #else
            printf("\nMapFpgaBus(): /dev/mem Mapped at: %p.\n", FpgaBus);
            #endif
        }
    }

    return(0);
}

int CGraphPZTProtoHardwareMmapper::close(int& FpgaHandle, CGraphPZTHardwareInterface*& FpgaBus)
{
    if (NULL != FpgaBus)
    {
        int unmap = munmap(FpgaBus, sizeof(CGraphPZTHardwareInterface));
        if (unmap < 0)
        {
            perror("\nCGraphPZTProtoHardwareMmapper::close(): error in munmap() ");
                return(errno);
        }
        FpgaBus = NULL;
    }
    else { return(EALREADY); }

    if (FpgaHandle > 0)
    {
        int closed = ::close(FpgaHandle);
        if (closed < 0)
        {
            perror("\nCGraphPZTProtoHardwareMmapper::close(): error in close() ");
            return(errno);
        }
        FpgaHandle = 0;
    }
    else { return(EBADF); }

    return(0);
}

int CGraphPZTProtoHardwareMmapper::read(const CGraphPZTHardwareInterface* FpgaBus, const size_t Address, void* Buffer, const size_t Len)
{
    if ( (NULL == FpgaBus) || (NULL == Buffer) ) { return(EINVAL); }

    if ( (Address + Len) > sizeof(CGraphPZTHardwareInterface) ) { return(EFAULT); }

    //Read data from fpga:
    memcpy(Buffer, ((uint8_t*)FpgaBus) + Address, Len);

    //~ if (Address == ZBusReadbackOffset) { printf("\nReadFpgaBus(): @ %p : 0x%.2X.\n", Address, ((uint8_t*)Buffer)[0]); }

    return(0);
}

int CGraphPZTProtoHardwareMmapper::write(CGraphPZTHardwareInterface* FpgaBus, const size_t Address, const void* Buffer, const size_t Len)
{
    if ( (NULL == FpgaBus) || (NULL == Buffer) ) { return(EINVAL); }

    if ( (Address + Len) > sizeof(CGraphPZTHardwareInterface) ) { return(EFAULT); }

    //Write data to fpga:
    memcpy(((uint8_t*)FpgaBus) + Address, Buffer, Len);

    return(0);
}

//EOF

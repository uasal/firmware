/// \file
/// $Revision: $

#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/mman.h>

#include "CGraphDMHardwareInterface.hpp"

#define FPGA_MEM_ADDR 0x08000000
#define FPGA_MAP_MASK 0x00000FFF

const uint32_t CGraphDMCIHardwareInterface::DacFullScale = 0x007FFFFFUL; //2^20 - 1 (do these need to be initialized in constructor even though it's static can't remember?)
const double CGraphDMCIHardwareInterface::DacDriverFullScaleOutputVoltage = 150.0; //Volts, don't get your fingers near this thing!

const off_t CGraphDMCIProtoHardwareMmapper::FpgaMmapAdress = 0x08000000UL;
const off_t CGraphDMCIProtoHardwareMmapper::FpgaMmapMask = 0x00000FFFUL;
const char CGraphDMCIProtoHardwareMmapper::FpgaBusEmulationPathName[] = "~/.UACGraph/PZTFpgaBusEmulator.ram";

int CGraphDMCIProtoHardwareMmapper::open(int& FpgaHandle, CGraphDMCIHardwareInterface*& FpgaBus)
{
    if (FpgaHandle > 0) { return(EBADF); } //already open?
    if (NULL != FpgaBus) { return(EALREADY); } //already mapped?

    #ifdef EMULATE_DMCI_HARDWARE
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
        #ifdef EMULATE_DMCI_HARDWARE
        int ft = ftruncate(FpgaHandle, sizeof(CGraphDMCIHardwareInterface));  //Make sure the file is big enough for all read/writes to mmap
        if (ft < 0)
        {
                perror("\nMapFpgaBus(): error in ftruncate() ");
                return(errno);
        }
        #endif

        #ifdef EMULATE_DMCI_HARDWARE
        FpgaBus = (CGraphDMCIHardwareInterface*)mmap(0, sizeof(CGraphDMCIHardwareInterface), PROT_READ | PROT_WRITE, MAP_SHARED, FpgaHandle, 0);
        #else
        FpgaBus = (CGraphDMCIHardwareInterface*)mmap(0, sizeof(CGraphDMCIHardwareInterface), PROT_READ | PROT_WRITE, MAP_SHARED, FpgaHandle, FPGA_MEM_ADDR & ~FPGA_MAP_MASK); //we're using #define's here for FPGA_MEM_ADDR cause this code worked, using the off_t consts seems suspect (like ~ is just gonna turn all the high bits on?
        #endif

        if (MAP_FAILED == FpgaBus)
        {
            printf("\nMapFpgaBus(): error in mmap(): %ld.\n", (long int)errno);
            return(errno);
        }
        else
        {
            #ifdef EMULATE_DMCI_HARDWARE
            printf("\nMapFpgaBus(): file Mapped at: %p.\n", FpgaBus);
            #else
            printf("\nMapFpgaBus(): /dev/mem Mapped at: %p.\n", FpgaBus);
            #endif
        }
    }

    return(0);
}

int CGraphDMCIProtoHardwareMmapper::close(int& FpgaHandle, CGraphDMCIHardwareInterface*& FpgaBus)
{
    if (NULL != FpgaBus)
    {
        int unmap = munmap(FpgaBus, sizeof(CGraphDMCIHardwareInterface));
        if (unmap < 0)
        {
            perror("\nCGraphDMCIProtoHardwareMmapper::close(): error in munmap() ");
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
            perror("\nCGraphDMCIProtoHardwareMmapper::close(): error in close() ");
            return(errno);
        }
        FpgaHandle = 0;
    }
    else { return(EBADF); }

    return(0);
}

int CGraphDMCIProtoHardwareMmapper::read(const CGraphDMCIHardwareInterface* FpgaBus, const size_t Address, void* Buffer, const size_t Len)
{
    if ( (NULL == FpgaBus) || (NULL == Buffer) ) { return(EINVAL); }

    if ( (Address + Len) > sizeof(CGraphDMCIHardwareInterface) ) { return(EFAULT); }

    //Read data from fpga:
    memcpy(Buffer, ((uint8_t*)FpgaBus) + Address, Len);

    //~ if (Address == ZBusReadbackOffset) { printf("\nReadFpgaBus(): @ %p : 0x%.2X.\n", Address, ((uint8_t*)Buffer)[0]); }

    return(0);
}

int CGraphDMCIProtoHardwareMmapper::write(CGraphDMCIHardwareInterface* FpgaBus, const size_t Address, const void* Buffer, const size_t Len)
{
    if ( (NULL == FpgaBus) || (NULL == Buffer) ) { return(EINVAL); }

    if ( (Address + Len) > sizeof(CGraphDMCIHardwareInterface) ) { return(EFAULT); }

    //Write data to fpga:
    memcpy(((uint8_t*)FpgaBus) + Address, Buffer, Len);

    return(0);
}

//EOF

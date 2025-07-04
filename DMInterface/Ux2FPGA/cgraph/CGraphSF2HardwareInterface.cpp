/*****************************************************************************************
 * This file adapts the previous hardware interface to the Smart Fusion 2 hardware.      *
 *                                                                                       *
 * Author: Stephen Kaye                                                                  *
 *                                                                                       *
 ****************************************************************************************/

#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
//#include <sys/types.h>
//#include <sys/mman.h>

//#include "CGraphSF2HardwareInterface.hpp"
#include "CGraphSF2HardwareInterface.hpp"

#define FPGA_MEM_ADDR 0x08000000
#define FPGA_MAP_MASK 0x00000FFF

const uint32_t CGraphDMHardwareInterface::DacFullScale = 0x007FFFFFUL; //2^20 - 1 (do these need to be initialized in constructor even though it's static can't remember?)
const double CGraphDMHardwareInterface::DacDriverFullScaleOutputVoltage = 150.0; //Volts, don't get your fingers near this thing!
////const double CGraphDMHardwareInterface::PZTDriverFullScaleOutputTravel = 0.00001; //Meters; note our granularity is this / DacFullScale which is approx 10pm

const off_t CGraphDMProtoHardwareMmapper::FpgaMmapAdress = 0x08000000UL;
const off_t CGraphDMProtoHardwareMmapper::FpgaMmapMask = 0x00000FFFUL;
const char CGraphDMProtoHardwareMmapper::FpgaBusEmulationPathName[] = "~/.UACGraph/PZTFpgaBusEmulator.ram";

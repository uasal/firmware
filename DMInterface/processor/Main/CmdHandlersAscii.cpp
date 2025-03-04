//
///           Copyright (c) by Franks Development, LLC
//
// This software is copyrighted by and is the sole property of Franks
// Development, LLC. All rights, title, ownership, or other interests
// in the software remain the property of Franks Development, LLC. This
// software may only be used in accordance with the corresponding
// license agreement.  Any unauthorized use, duplication, transmission,
// distribution, or disclosure of this software is expressly forbidden.
//
// This Copyright notice may not be removed or modified without prior
// written consent of Franks Development, LLC.
//
// Franks Development, LLC. reserves the right to modify this software
// without notice.
//
// Franks Development, LLC            support@franks-development.com
// 500 N. Bahamas Dr. #101           http://www.franks-development.com
// Tucson, AZ 85710
// USA
//
/// \file
/// $Source: /raincloud/src/clients/UACGraph/Zeus/Zeus3/firmware/arm/main/CmdHandlersConfig.cpp,v $
/// $Revision: 1.7 $
/// $Date: 2010/06/08 23:51:10 $
/// $Author: summer $

#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <inttypes.h>
//offsetof:
#include <cstddef>
#include <unordered_map>
using namespace std;

//~ #include <mcheck.h>
//~ #include "dbg/memwatch.h"

#include "uart/BinaryUart.hpp"

#include "uart/uart_pinout_fpga.hpp"

#include "cgraph/CGraphPacket.hpp"

#include "cgraph/CGraphDMHardwareInterface.hpp"
extern CGraphDMHardwareInterface* DM;	

//#include "../MonitorAdc.hpp"
//extern CGraphDMMonitorAdc MonitorAdc;

#include "MainBuildNum"

extern uart_pinout_fpga FPGAUartPinout0;
extern uart_pinout_fpga FPGAUartPinout1;
extern uart_pinout_fpga FPGAUartPinout2;
//extern uart_pinout_fpga FPGAUartPinout3;
//extern uart_pinout_fpga FPGAUartPinoutUsb;

//extern BinaryUart FpgaUartParser3;
extern BinaryUart FpgaUartParser2;
extern BinaryUart FpgaUartParser1;
extern BinaryUart FpgaUartParser0; //using this one for ascii rn...

char Buffer[4096];

int8_t VersionCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	if (NULL != DM)
	{
		printf("\n\nVersion: Serial Number: %.8lX, Global Revision: %s; build number: %u on: %s; fpga build: %lu.\n", DM->DeviceSerialNumber, GITVERSION, BuildNum, BuildTimeStr, DM->FpgaFirmwareBuildNumber);
	}
	else
	{
		printf("\n\nVersion: Global Revision: %s; build number: %u on: %s.\n", GITVERSION, BuildNum, BuildTimeStr);
	}
	
    return(strlen(Params));
}

int8_t ReadFpgaCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	uint8_t FpgaRdBuf;

	//Convert parameter to an integer
    size_t addr = 0;
	int8_t numfound = sscanf(Params, "%zX", &addr);
    if (numfound < 1)
    {
		printf("\nReadFpgaCommand: ");
		//~ for (addr = 0; addr <= 64; addr++)
		for (addr = 0; addr <= 128; addr++)
		{
			FpgaRdBuf = *(((uint8_t*)DM)+addr);
			printf("\n0x%.2zX: 0x%.2X ", addr, FpgaRdBuf);
			printf("[%u]", FpgaRdBuf);
			//~ printf(" ('%c')", FpgaRdBuf);
		}	
		printf("\n\n");
    }
	else
	{
		FpgaRdBuf = *(((uint8_t*)DM)+addr);
		printf("\nReadFpgaCommand: ");
		//~ printf("\n%zu: 0x%.2X ", addr, FpgaRdBuf);
		printf("\n0x%.2zX: 0x%.2X ", addr, FpgaRdBuf);
		printf("[%u]", FpgaRdBuf);
		printf(" ('%c')\n\n", FpgaRdBuf);
	}
	
	return(ParamsLen);
}

int8_t WriteFpgaCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	//Convert parameter to an integer
	size_t addr = 0;
    unsigned long val = 0;
    int8_t numfound = sscanf(Params, "%zX %lu", &addr, &val);
    if (numfound < 2)
    {
		printf("\nWriteFpgaCommand: need 2 numeric parameters (address and value), got \"%s\" (%d params).\n", Params, numfound);
        return(-1);
    }

	//Write data to fpga:
	*(((uint8_t*)DM)+addr) = (uint8_t)val;

	printf("\nWriteFpgaCommand: Wrote %lu to ", val);
	printf("0x%.4zX.\n", addr);
	
	return(ParamsLen);
}


int8_t DMDacCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    unsigned long A = 0, B = 0, C = 0;	
    if (NULL == DM) {
      printf("\n\nDMDacs: Fpga interface is not initialized! Please call InitFpga first!.");
      return(ParamsLen);
    }
	
    //Convert parameters
    int8_t numfound = sscanf(Params, "%lx,%lx,%lx", &A, &B, &C);
    if (numfound >= 3) {
//      DM->DacASetpoint = A;
//      DM->DacBSetpoint = B;
//      DM->DacCSetpoint = C;
      printf("\n\nDMDacs: set to: %lx, %lx, %lx.\n", A, B, C);
      return(ParamsLen);
    }
    if (numfound >= 1) {
//      DM->DacASetpoint = A;
//      DM->DacBSetpoint = A;
//      //~ DM->DacBSetpoint = 0x006FFFFFUL; //Sometimes this is 100V
//      //~ DM->DacBSetpoint = 0x00CFFFFFUL; //Aaaaaand, sometimes this is 100V
//      DM->DacCSetpoint = A;
      printf("\n\nDMDacs: set to: %lx, %lx, %lx.\n", A, A, A);
      return(ParamsLen);
    }

//    A = DM->DacASetpoint;
//    B = DM->DacBSetpoint;
//    C = DM->DacCSetpoint;
    printf("\n\nDMDacs: current value: %lx, %lx, %lx.\n", A, B, C);
	
    //Show current A/D values:
    {
      AdcAccumulator Aa, Ba, Ca;
//      Aa = DM->AdcAAccumulator;
//      Ba = DM->AdcBAccumulator;
//      Ca = DM->AdcCAccumulator;
      
      double Av, Bv, Cv;
      Av = (8.192 * ((Aa.Samples - 0) / Aa.NumAccums)) / 16777216.0;
      Bv = (8.192 * ((Ba.Samples - 0) / Ba.NumAccums)) / 16777216.0;
      Cv = (8.192 * ((Ca.Samples - 0) / Ca.NumAccums)) / 16777216.0;
      printf("\nDMDacs: Sensor A/D's: 0x%016llx, 0x%016llx, 0x%016llx; %+d(%u), %+d(%u), %+d(%u), %+1.3lf, %+1.3lf, %+1.3lf\n", Aa.all, Ba.all, Ca.all, Aa.Samples, Aa.NumAccums, Ba.Samples, Ba.NumAccums, Ca.Samples, Ca.NumAccums, Av, Bv, Cv);
    }
	
    return(ParamsLen);
}

//int8_t VoltageCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
//{
//	double VA = 0.0, VB = 0.0, VC = 0.0;	
//	unsigned long A = 0, B = 0, C = 0;	
//	
//	if (NULL == DM)
//	{
//		printf("\n\nVoltage: Fpga interface is not initialized! Please call InitFpga first!.");
//		return(ParamsLen);
//	}
//	
//	//Convert parameters
//    int8_t numfound = sscanf(Params, "%lf,%lf,%lf", &VA, &VB, &VC);
//	
//	A = (VA * (double)(0x00FFFFFFUL) * 60.0) / 4.096;
//	B = (VB * (double)(0x00FFFFFFUL) * 60.0) / 4.096;
//	C = (VC * (double)(0x00FFFFFFUL) * 60.0) / 4.096;
//	
//    if (numfound >= 3)
//    {
//		DM->DacASetpoint = A;
//		DM->DacBSetpoint = B;
//		DM->DacCSetpoint = C;
//		printf("\n\nVoltage: set to: %3.1lf (%lx), %3.1lf (%lx), %3.1lf (%lx).\n", VA, A, VB, B, VC, C);
//		return(ParamsLen);
//    }
//	if (numfound >= 1)
//    {
//		DM->DacASetpoint = A;
//		DM->DacBSetpoint = A;
//		//~ DM->DacBSetpoint = 0x006FFFFFUL; //Sometimes this is 100V
//		//~ DM->DacBSetpoint = 0x00CFFFFFUL; //Aaaaaand, sometimes this is 100V
//		DM->DacCSetpoint = A;
//		printf("\n\nVoltage: set to: %3.1lf (%lx), %3.1lf (%lx), %3.1lf (%lx).\n", VA, A, VB, B, VC, C);
//		return(ParamsLen);
//    }
//
//	A = DM->DacASetpoint;
//	B = DM->DacBSetpoint;
//	C = DM->DacCSetpoint;
//	
//	VA = 4.096 * (double)(A) / ((double)(0x00FFFFFFUL) * 60.0);
//	VB = 4.096 * (double)(A) / ((double)(0x00FFFFFFUL) * 60.0);
//	VC = 4.096 * (double)(A) / ((double)(0x00FFFFFFUL) * 60.0);
//	
//	printf("\n\nVoltage: current values: %3.1lf (%lx), %3.1lf (%lx), %3.1lf (%lx).\n", VA, A, VB, B, VC, C);
//	
//	return(ParamsLen);	
//}

int8_t DMAdcsCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
  //~ size_t cycle = 0;
  //~ int key = 0;

  if (NULL == DM) {
    printf("\n\nDMAdcs: Fpga interface is not initialized! Please call InitFpga first!.");
    return(ParamsLen);
  }
	
  {
    AdcAccumulator A, B, C;
//    A = DM->AdcAAccumulator;
//    B = DM->AdcBAccumulator;
//    C = DM->AdcCAccumulator;
    
    double Av, Bv, Cv;
    Av = (8.192 * ((A.Samples - 0) / A.NumAccums)) / 16777216.0;
    Bv = (8.192 * ((B.Samples - 0) / B.NumAccums)) / 16777216.0;
    Cv = (8.192 * ((C.Samples - 0) / C.NumAccums)) / 16777216.0;
			
    printf("\nDMAdcs: current values: 0x%016llx, 0x%016llx, 0x%016llx; %+d(%u), %+d(%u), %+d(%u), %+1.3lf, %+1.3lf, %+1.3lf\n", A.all, B.all, C.all, A.Samples, A.NumAccums, B.Samples, B.NumAccums, C.Samples, C.NumAccums, Av, Bv, Cv);
  }
		
  return(ParamsLen);
}

int8_t BISTCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
  size_t cycle = 0;
  //~ unsigned long daca = 0;
  int key = 0;
	
  while(true) {
    cycle++;
		
    {
      size_t j = cycle % 12;
      switch(j) {
//        case 0: { formatf("P1V2: %3.6lf V\n", MonitorAdc.GetP1V2()); break; }
//        case 1: { formatf("P2V2: %3.6lf V\n", MonitorAdc.GetP2V2()); break; }
//        case 2: { formatf("P28V: %3.6lf V\n", MonitorAdc.GetP28V()); break; }
//        case 3: { formatf("P2V5: %3.6lf V\n", MonitorAdc.GetP2V5()); break; }
//          //~ case 4: { formatf("P3V3A: %3.6lf V\n", MonitorAdc.GetP3V3A()); break; }
//        case 5: { formatf("P6V: %3.6lf V\n", MonitorAdc.GetP6V()); break; }
//        case 6: { formatf("P5V: %3.6lf V\n", MonitorAdc.GetP5V()); break; }
//        case 7: { formatf("P3V3D: %3.6lf V\n", MonitorAdc.GetP3V3D()); break; }
//        case 8: { formatf("P4V3: %3.6lf V\n", MonitorAdc.GetP4V3()); break; }
          //~ case 9: { formatf("N5V: %3.6lf V\n", MonitorAdc.GetN5V()); break; }
          //~ case 10: { formatf("N6V: %3.6lf V\n", MonitorAdc.GetN6V()); break; }
          //~ case 11: { formatf("P150V: %3.6lf V\n\n\n", MonitorAdc.GetP150V()); break; }
        default : { }
      }
    }
		
    //Quit on any keypress
    {
      //~ if (0 != key) 
      { 
        fflush(stdin);
        printf("\n\nBIST: Keypress(%d); exiting.\n", key);
        break; 
      }			
    }

    //~ DelayMs(10);
  }
	
  return(ParamsLen);
}

int8_t UartCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
  struct timespec sleeptime;
  memset((char *)&sleeptime,0,sizeof(sleeptime));
  sleeptime.tv_nsec = 1000000;
  sleeptime.tv_sec = 0;
  int key = 0;

  
  printf("\nUartCommand: %u, %u. ", offsetof(CGraphDMHardwareInterface, UartFifo2), offsetof(CGraphDMHardwareInterface, UartStatusRegister2));
	
  if (0 == strncmp(&(Params[1]), "loop", 4)) {
    while(true) {
      //~ DM->UartFifo0 = 0x55;
      //~ DM->UartFifo1 = 0x55;	
      DM->UartFifo2 = 0x55;
			
      //Quit on any keypress
      {
        //~ if (0 != key) 
        { 
          fflush(stdin);
          printf("\n\nCircles: Keypress(%d); exiting.\n", key);
          break; 
        }			
      }
    }
  }
	
  CGraphVersionPayload Version;
  Version.SerialNum = 0;
  Version.ProcessorFirmwareBuildNum = BuildNum;
  Version.FPGAFirmwareBuildNum = 0;
  if (DM) { 
    Version.SerialNum = DM->DeviceSerialNumber; 
    Version.FPGAFirmwareBuildNum = DM->FpgaFirmwareBuildNumber; 
  }
  printf("\nUartCommand: Sending response (%u bytes): ", sizeof(CGraphVersionPayload));
  Version.formatf();
  printf("\n");
  //~ TxBinaryPacket(&FpgaUartParser0, CGraphPayloadTypeVersion, 0, &Version, sizeof(CGraphVersionPayload));
  TxBinaryPacket(&FpgaUartParser0, CGraphPayloadTypeVersion, 0, &Version, sizeof(CGraphVersionPayload));
  TxBinaryPacket(&FpgaUartParser1, CGraphPayloadTypeVersion, 0, &Version, sizeof(CGraphVersionPayload));
  TxBinaryPacket(&FpgaUartParser2, CGraphPayloadTypeVersion, 0, &Version, sizeof(CGraphVersionPayload));
    
  printf("\nUartCommand: complete.\n");

  return(ParamsLen);
}

int8_t BaudDividersCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
  unsigned long A = 0, B = 0, C = 0, D = 0;
  
  if (NULL == DM) {
    printf("\n\nBaudDividers: Fpga interface is not initialized! Please call InitFpga first!.");
    return(ParamsLen);
  }
	
  //Convert parameters
  int8_t numfound = sscanf(Params, "%lu,%lu,%lu,%lu", &A, &B, &C, &D);
  if (numfound >= 4) {
//    DM->BaudDividers.Divider0 = A;
//    DM->BaudDividers.Divider1 = B;
//    DM->BaudDividers.Divider2 = C;
    //    DM->BaudDividers.Divider3 = D;
    printf("\n\nBaudDividers: setting to: %lu, %lu, %lu, %lu.\n", A, B, C, D);
  }
  else {
    if (numfound >= 1) {
//      DM->BaudDividers.Divider0 = A;
//      DM->BaudDividers.Divider1 = A;
//      DM->BaudDividers.Divider2 = A;
      //DM->BaudDividers.Divider3 = A;
      printf("\n\nBaudDividers: setting to: %lu, %lu, %lu, %lu.\n", A, A, A, A);
    }
  }
	
//  A = DM->BaudDividers.Divider0;
//  B = DM->BaudDividers.Divider1;
//  C = DM->BaudDividers.Divider2;
  //D = DM->BaudDividers.Divider3;
  printf("\n\nBaudDividers: current values: %lu, %lu, %lu.\n", A, B, C);
	
  double BaudClock = 102000000.0;
  //~ unsigned int ActualDividerA = (A + 1) * 2;
  //~ unsigned int ActualDividerB = (B + 1) * 2;
  //~ unsigned int ActualDividerC = (C + 1) * 2;
  //~ unsigned int ActualDividerD = (D + 1) * 2;
  unsigned int ActualDividerA = (A + 1);
  unsigned int ActualDividerB = (B + 1);
  unsigned int ActualDividerC = (C + 1);
  //unsigned int ActualDividerD = (D + 1);
  double BaudRateA = (BaudClock / ActualDividerA) / 16;
  double BaudRateB = (BaudClock / ActualDividerB) / 16;
  double BaudRateC = (BaudClock / ActualDividerC) / 16;
  //double BaudRateD = (BaudClock / ActualDividerD) / 16;
	
  printf("\nBaudDividers: Port0 final division ratio: %u (/16); Actual baudrate: %.5lf", ActualDividerA, BaudRateA);
  printf("\nBaudDividers: Port1 final division ratio: %u (/16); Actual baudrate: %.5lf", ActualDividerB, BaudRateB);
  printf("\nBaudDividers: Port2 final division ratio: %u (/16); Actual baudrate: %.5lf\n", ActualDividerC, BaudRateC);
  //printf("\nBaudDividers: Port3 final division ratio: %u (/16); Actual baudrate: %.5lf\n", ActualDividerD, BaudRateD);
	
  return(ParamsLen);
}

int8_t PrintBuffersCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
  printf("\nShowBuffersCommand: FpgaUartParser: ");
  FpgaUartParser0.formatf();
  FpgaUartParser1.formatf();
  FpgaUartParser2.formatf();
  //FpgaUartParser3.formatf();
  printf("\n\n");
  return(ParamsLen);
}

int8_t MonitorSerialCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
  unsigned long port = 0;
  char seperator[8];
  char onoff;
  bool OnOff = false;

  //Convert parameters
  int8_t numfound = sscanf(Params, "%lu%2[,\t ]%c", &port, seperator, &onoff);
  if (numfound >= 4) {
    if ( ('Y' == onoff) || ('y' == onoff) || ('T' == onoff) || ('t' == onoff) || ('1' == onoff) ) {
      OnOff = true;
    }
		
    formatf("\n\nMonitorSerialCommand: Monitoring port %lu: %c.\n", port, OnOff?'Y':'N');
		
    switch(port) {
    case 0 : { FPGAUartPinout0.Monitor(OnOff); break; }			
    case 1 : { FPGAUartPinout1.Monitor(OnOff); break; }			
    case 2 : { FPGAUartPinout2.Monitor(OnOff); break; }			
      //case 3 : { FPGAUartPinout3.Monitor(OnOff); break; }			
    default : 
      { 
        formatf("\n\nMonitorSerialCommand: Invalid port %lu; max is #2.\n", port);
      }
    }
			
    return(strlen(Params));
  }
	
  formatf("\n\nMonitorSerialCommand: Insufficient parameters (%u; should be 2); querying...", numfound);
  
  formatf("\nMonitorSerialCommand: Monitoring port 0: %c.\n", FPGAUartPinout0.Monitor()?'Y':'N');
  formatf("\nMonitorSerialCommand: Monitoring port 1: %c.\n", FPGAUartPinout1.Monitor()?'Y':'N');
  formatf("\nMonitorSerialCommand: Monitoring port 2: %c.\n", FPGAUartPinout2.Monitor()?'Y':'N');	
  //formatf("\nMonitorSerialCommand: Monitoring port 3: %c.\n", FPGAUartPinout3.Monitor()?'Y':'N');	
	
  return(strlen(Params));
}



//EOF


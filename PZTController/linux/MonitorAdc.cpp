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
#include <time.h>
#include <ctype.h> //tolower
//kbhit
#include <termios.h>
#include <sys/ioctl.h>


#include "Delay.h"

#include "MonitorAdc.hpp"

CGraphFSMMonitorAdc MonitorAdc;

MonitorAdcCalibratedInput P1V2Calibrate(1.0, 0.0); //1:1
MonitorAdcCalibratedInput P2V2Calibrate(2.0, 0.0); //1:2
MonitorAdcCalibratedInput P24VCalibrate(16.0, 0.0); //1:16
MonitorAdcCalibratedInput P2V5Calibrate(2.0, 0.0); //1:2
MonitorAdcCalibratedInput P3V3ACalibrate(2.0, 0.0); //1:2
MonitorAdcCalibratedInput P6VCalibrate(4.922, 0.0); //2.55:12.55
MonitorAdcCalibratedInput P5VCalibrate(4.922, 0.0); //2.55:12.55
MonitorAdcCalibratedInput P3V3DCalibrate(2.0, 0.0); //1:2
MonitorAdcCalibratedInput P4V3Calibrate(3.0, 0.0); //1:3
MonitorAdcCalibratedInput N5VCalibrate(3.922, 0.0); //2.55:10
MonitorAdcCalibratedInput N6VCalibrate(3.922, 0.0); //2.55:10
MonitorAdcCalibratedInput P150VCalibrate(101.0, 0.0); //1:101
MonitorAdcCalibratedInput Aux0Calibrate(1.0, 0.0); //1:1
MonitorAdcCalibratedInput Aux1Calibrate(1.0, 0.0); //1:1
MonitorAdcCalibratedInput AmbientLightCalibrate(1.0, 0.0); //1:1 301-ohm
MonitorAdcCalibratedInput TemperatureCalibrate(1.0, 0.0); //not actually connected on prototype pcb
//~ //Debug: Make all gains 1.0 so we get raw volts from the board...
//~ MonitorAdcCalibratedInput P1V2Calibrate(1.0, 0.0); //1:1
//~ MonitorAdcCalibratedInput P2V2Calibrate(1.0, 0.0); //1:2
//~ MonitorAdcCalibratedInput P24VCalibrate(1.0, 0.0); //1:16
//~ MonitorAdcCalibratedInput P2V5Calibrate(1.0, 0.0); //1:2
//~ MonitorAdcCalibratedInput P3V3ACalibrate(1.0, 0.0); //1:2
//~ MonitorAdcCalibratedInput P6VCalibrate(1.0, 0.0); //1:12.55
//~ MonitorAdcCalibratedInput P5VCalibrate(1.0, 0.0); //1:12.55
//~ MonitorAdcCalibratedInput P3V3DCalibrate(1.0, 0.0); //1:2
//~ MonitorAdcCalibratedInput P4V3Calibrate(1.0, 0.0); //1:3
//~ MonitorAdcCalibratedInput N5VCalibrate(1.0, 0.0); //2.55:10
//~ MonitorAdcCalibratedInput N6VCalibrate(1.0, 0.0); //2.55:10
//~ MonitorAdcCalibratedInput P150VCalibrate(1.0, 0.0); //1:101
//~ MonitorAdcCalibratedInput Aux0Calibrate(1.0, 0.0); //1:1
//~ MonitorAdcCalibratedInput Aux1Calibrate(1.0, 0.0); //1:1
//~ MonitorAdcCalibratedInput AmbientLightCalibrate(1.0, 0.0); //1:1 301-ohm
//~ MonitorAdcCalibratedInput TemperatureCalibrate(1.0, 0.0); //not actually connected on prototype pcb
//~ //\Debug

const char ScanMonitorAdcCmdString[] = "SCANMONITORADC";
const char ScanMonitorAdcHelp[] = "\"ScanMonitorAdc\"; Show current input voltages...";
int8_t ScanMonitorAdcCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    formatf("\n\nScanMonitorAdc Command: Values with corrected units follow:\n");
	
	formatf("P1V2: %3.6lf V\n", MonitorAdc.GetP1V2());
	formatf("P2V2: %3.6lf V\n", MonitorAdc.GetP2V2());
	formatf("P24V: %3.6lf V\n", MonitorAdc.GetP24V());
	formatf("P2V5: %3.6lf V\n", MonitorAdc.GetP2V5());
	formatf("P3V3A: %3.6lf V\n", MonitorAdc.GetP3V3A());
	formatf("P6V: %3.6lf V\n", MonitorAdc.GetP6V());
	formatf("P5V: %3.6lf V\n", MonitorAdc.GetP5V());
	formatf("P3V3D: %3.6lf V\n", MonitorAdc.GetP3V3D());
	formatf("P4V3: %3.6lf V\n", MonitorAdc.GetP4V3());
	formatf("N5V: %3.6lf V\n", MonitorAdc.GetN5V());
	formatf("N6V: %3.6lf V\n", MonitorAdc.GetN6V());
	formatf("P150V: %3.6lf V\n", MonitorAdc.GetP150V());
	formatf("Aux0: %3.6lf V\n", MonitorAdc.GetAux0());
	formatf("Aux1: %3.6lf V\n", MonitorAdc.GetAux1());
	formatf("AmbientLight: %3.6lf V\n", MonitorAdc.GetAmbientLight());
	formatf("Temperature: %3.6lf V\n", MonitorAdc.GetTemperature());
	
    formatf("\nScanMonitorAdc Command: Complete.\n\n");
    return(strlen(Params));
}

const char TestMonitorAdcCmdString[] = "TESTMONITORADC";
const char TestMonitorAdcHelp[] = "\"TestMonitorAdc\"; Show raw A/D counts...";
int8_t TestMonitorAdcCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	size_t cycle = 0;
	int key = 0;
	
	while(true)
	{
		cycle++;
	
		formatf("\n\nTestMonitorAdc Command: Serial: Reading A/D's (raw values):\n");
		
		Ltc244xAccumulator Sample;
		 
		//~ MonitorAdc.GetP1V2Raw(Sample); formatf("\nP1V2: "); Sample.formatf();
		//~ MonitorAdc.GetP2V2Raw(Sample); formatf("\nP2V2: "); Sample.formatf();
		//~ MonitorAdc.GetP24VRaw(Sample); formatf("\nP24V: "); Sample.formatf();
		//~ MonitorAdc.GetP2V5Raw(Sample); formatf("\nP2V5: "); Sample.formatf();
		//~ MonitorAdc.GetP3V3ARaw(Sample); formatf("\nP3V3A: "); Sample.formatf();
		//~ MonitorAdc.GetP6VRaw(Sample); formatf("\nP6V: "); Sample.formatf();
		//~ MonitorAdc.GetP5VRaw(Sample); formatf("\nP5V: "); Sample.formatf();
		//~ MonitorAdc.GetP3V3DRaw(Sample); formatf("\nP3V3D: "); Sample.formatf();
		//~ MonitorAdc.GetP4V3Raw(Sample); formatf("\nP4V3: "); Sample.formatf();
		//~ MonitorAdc.GetN5VRaw(Sample); formatf("\nN5V: "); Sample.formatf();
		//~ MonitorAdc.GetN6VRaw(Sample); formatf("\nN6V: "); Sample.formatf();
		//~ MonitorAdc.GetP150VRaw(Sample); formatf("\nP150V: "); Sample.formatf();
		//~ MonitorAdc.GetAux0Raw(Sample); formatf("\nAux0: "); Sample.formatf();
		//~ MonitorAdc.GetAux1Raw(Sample); formatf("\nAux1: "); Sample.formatf();
		//~ MonitorAdc.GetAmbientLightRaw(Sample); formatf("\nAmbientLight: "); Sample.formatf();
		//~ MonitorAdc.GetTemperatureRaw(Sample); formatf("\nTemperature: "); Sample.formatf();
		
		for(size_t i = 0; i < 32; i++)
		{
			MonitorAdc.SetAdcReadChannel(i);
			MonitorAdc.GetAdcSample(Sample);
			formatf("\nCh%2u : ", i);
			Sample.formatf();
			double Volts = ((double)(0-(int32_t)Sample.Sample) * (double)8.192) / (1.0 * ((double)lt244xdetails::CountPosVRef - (double)lt244xdetails::CountNegVRef));
			formatf("; %lfV.", Volts);
			
		}
		
		//Quit on any keypress
		{
			struct termios argin, argout;
			tcgetattr(0,&argin);
			argout = argin;
			argout.c_lflag &= ~(ICANON);
			argout.c_iflag &= ~(ICRNL);
			argout.c_oflag &= ~(OPOST);
			argout.c_cc[VMIN] = 1;
			argout.c_cc[VTIME] = 0;
			tcsetattr(0,TCSADRAIN,&argout);
			//~ read(0, &key, 1);
			ioctl(0, FIONREAD, &key);
			tcsetattr(0,TCSADRAIN,&argin);
			if (0 != key) 
			{ 
				printf("\n\nBIST: Keypress(%d); exiting.\n", key);
				break; 
			}			
		}

		struct timespec sleeptime;
		memset((char *)&sleeptime,0,sizeof(sleeptime));
		sleeptime.tv_nsec = 0;
		sleeptime.tv_sec = 1;
		nanosleep(&sleeptime, NULL);
	}
	
    formatf("\nTestMonitorAdc Command: Complete.\n\n");
    return(strlen(Params));
}

const char CalibrateMonitorAdcCmdString[] = "CALIBRATEMONITORADC";
const char CalibrateMonitorAdcHelp[] = "\"CalibrateMonitorAdc <readout>,<gain>(optional),<offset>(optional)\"; Calibrate (or query) the given readout";
int8_t CalibrateMonitorAdcCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	bool Query = true;
	
	char* InputName = strtok(const_cast<char*>(Params)," ,\t\r\n");
	char* Gn = strtok((char*)NULL," ,\t\r\n");
	char* Of = strtok((char*)NULL," ,\t\r\n");
	double Gain = 1.0;
	double Offset = 0.0;
	
	if (NULL == InputName)
	{
		formatf("\nMonitorAdcCalibrate: Invalid parameters; must give at least name of input calibration to query!\n\n");
		return(strlen(Params));
	}
	
	for (size_t i = 0; i < ParamsLen; i++)
	{
		if ('\0' == InputName[i]) { break; }
		InputName[i] = toupper(InputName[i]); //(1 to skip first whitespace)
	}
	
	if (NULL != Gn)
	{
		Query = false;
		sscanf(Gn, "%le", &Gain);
	}
	
	if (NULL != Of)
	{
		Query = false;
		sscanf(Of, "%le", &Offset);
	}
	
	if (0 == strncmp(InputName, "DEFAULTS", 8))
	{	
		P1V2Calibrate.Calibrate(1.0, 0.0);
		P2V2Calibrate.Calibrate(2.0, 0.0);
		P24VCalibrate.Calibrate(16.0, 0.0);
		P2V5Calibrate.Calibrate(2.0, 0.0);
		P3V3ACalibrate.Calibrate(2.0, 0.0);
		P6VCalibrate.Calibrate(4.922, 0.0);
		P5VCalibrate.Calibrate(4.922, 0.0);
		P3V3DCalibrate.Calibrate(2.0, 0.0);
		P4V3Calibrate.Calibrate(3.0, 0.0);
		N5VCalibrate.Calibrate(3.922, 0.0);
		N6VCalibrate.Calibrate(3.922, 0.0);
		P150VCalibrate.Calibrate(101.0, 0.0);
		Aux0Calibrate.Calibrate(1.0, 0.0);
		Aux1Calibrate.Calibrate(1.0, 0.0);
		AmbientLightCalibrate.Calibrate(1.0, 0.0);
		TemperatureCalibrate.Calibrate(1.0, 0.0);
		formatf("\nMonitorAdcCalibrate: All calibrates set to defaults!\n\n");
		return(strlen(Params));
	}

	MonitorAdcCalibratedInput* CalibrateMe = NULL;
	
	if (0 == strncmp(InputName, "P1V2", 8)) { CalibrateMe = &P1V2Calibrate; } 
	if (0 == strncmp(InputName, "P2V2", 8)) { CalibrateMe = &P2V2Calibrate; } 
	if (0 == strncmp(InputName, "P24V", 8)) { CalibrateMe = &P24VCalibrate; } 
	if (0 == strncmp(InputName, "P2V5", 8)) { CalibrateMe = &P2V5Calibrate; } 
	if (0 == strncmp(InputName, "P3V3A", 8)) { CalibrateMe = &P3V3ACalibrate; } 
	if (0 == strncmp(InputName, "P6V", 8)) { CalibrateMe = &P6VCalibrate; } 
	if (0 == strncmp(InputName, "P5V", 8)) { CalibrateMe = &P5VCalibrate; } 
	if (0 == strncmp(InputName, "P3V3D", 8)) { CalibrateMe = &P3V3DCalibrate; } 
	if (0 == strncmp(InputName, "P4V3", 8)) { CalibrateMe = &P4V3Calibrate; } 
	if (0 == strncmp(InputName, "N5V", 8)) { CalibrateMe = &N5VCalibrate; } 
	if (0 == strncmp(InputName, "N6V", 8)) { CalibrateMe = &N6VCalibrate; } 
	if (0 == strncmp(InputName, "P150V", 8)) { CalibrateMe = &P150VCalibrate; } 
	if (0 == strncmp(InputName, "AUX0", 8)) { CalibrateMe = &Aux0Calibrate; } 
	if (0 == strncmp(InputName, "AUX1", 8)) { CalibrateMe = &Aux1Calibrate; } 
	if (0 == strncmp(InputName, "AMBIENTLIGHT", 8)) { CalibrateMe = &AmbientLightCalibrate; } 
	if (0 == strncmp(InputName, "TEMPERATURE", 8)) { CalibrateMe = &TemperatureCalibrate; } 

	if (NULL != CalibrateMe)
	{
		if (!Query)
		{
			CalibrateMe->Calibrate(Gain, Offset);
			formatf("\nMonitorAdcCalibrate: Set Gain: %le (\"%s\"), Set Offset: %le (\"%s\")\n", Gain, Gn, Offset, Of);
		}
		
		formatf("\nMonitorAdcCalibrate: Gain: %le, Offset: %le\n", CalibrateMe->GetGain(), CalibrateMe->GetOffset());
	}
	else
	{
		formatf("\nMonitorAdcCalibrate: Unable to locate input matching \"%s\"!\n", InputName);
	}
	
	formatf("\nMonitorAdcCalibrate: Complete.\n\n");
	
	return(strlen(Params));
}

//EOF

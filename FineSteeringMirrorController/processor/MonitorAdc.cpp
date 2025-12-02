//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
///
///           based on a framework Copyright (c) 2009 by Franks Development, LLC, used with permission
//

#include <time.h>
#include <ctype.h> //tolower

#include "Delay.h"

#include "Uarts.hpp"

#include "MonitorAdc.hpp"

CGraphFSMMonitorAdc MonitorAdc;

MonitorAdcCalibratedInput P1V2Calibrate(1.0, 0.0); //1:1
MonitorAdcCalibratedInput P2V2Calibrate(2.0, 0.0); //1:2
MonitorAdcCalibratedInput P28VCalibrate(16.0, 0.0); //1:16
MonitorAdcCalibratedInput P2V5Calibrate(2.0, 0.0); //1:2
MonitorAdcCalibratedInput P3V3DCalibrate(2.0, 0.0); //1:2
MonitorAdcCalibratedInput P6VCalibrate(4.922, 0.0); //2.55:12.55
MonitorAdcCalibratedInput P5VCalibrate(4.922, 0.0); //2.55:12.55
MonitorAdcCalibratedInput P4V3Calibrate(3.0, 0.0); //1:3
MonitorAdcCalibratedInput P2I2Calibrate(1.0, 0.0); //1:1
MonitorAdcCalibratedInput P4I3Calibrate(1.0, 0.0); //1:1
MonitorAdcCalibratedInput P6ICalibrate(1.0, 0.0); //1:1
MonitorAdcCalibratedInput Aux0Calibrate(1.0, 0.0); //1:1
MonitorAdcCalibratedInput Aux1Calibrate(1.0, 0.0); //1:1
MonitorAdcCalibratedInput Aux2Calibrate(1.0, 0.0); //1:1
MonitorAdcCalibratedInput AmbientLightCalibrate(2.0, 0.0); //1:1 301-ohm
MonitorAdcCalibratedInput TemperatureCalibrate(1.0, 0.0); //not actually connected on prototype pcb
//~ //Debug: Make all gains 1.0 so we get raw volts from the board...
//~ MonitorAdcCalibratedInput P1V2Calibrate(1.0, 0.0); //1:1
//~ MonitorAdcCalibratedInput P2V2Calibrate(1.0, 0.0); //1:2
//~ MonitorAdcCalibratedInput P28VCalibrate(1.0, 0.0); //1:16
//~ MonitorAdcCalibratedInput P2V5Calibrate(1.0, 0.0); //1:2
//~ MonitorAdcCalibratedInput P6VCalibrate(1.0, 0.0); //1:12.55
//~ MonitorAdcCalibratedInput P5VCalibrate(1.0, 0.0); //1:12.55
//~ MonitorAdcCalibratedInput P3V3DCalibrate(1.0, 0.0); //1:2
//~ MonitorAdcCalibratedInput P4V3Calibrate(1.0, 0.0); //1:3
//~ MonitorAdcCalibratedInput P2I2Calibrate(1.0, 0.0); //1:1
//~ MonitorAdcCalibratedInput P4I3Calibrate(1.0, 0.0); //1:1
//~ MonitorAdcCalibratedInput P6ICalibrate(1.0, 0.0); //1:1
//~ MonitorAdcCalibratedInput Aux0Calibrate(1.0, 0.0); //1:1
//~ MonitorAdcCalibratedInput Aux1Calibrate(1.0, 0.0); //1:1
//~ MonitorAdcCalibratedInput Aux2Calibrate(1.0, 0.0); //1:1
//~ MonitorAdcCalibratedInput AmbientLightCalibrate(1.0, 0.0); //1:1 301-ohm
//~ MonitorAdcCalibratedInput TemperatureCalibrate(1.0, 0.0); //not actually connected on prototype pcb
//~ //\Debug


void CGraphFSMMonitorAdc::Init()
{
	for (uint8_t i = 0; i < 10; i++)
	{
		uint8_t AdcInit = Adc.Init(GpioDirections);
		if (Adc.InitOK == AdcInit)
		{
			AdcFound = true;
			break;
		}
		else
		{
			formatf("\nMonitorAdc: Error initializing Adc: %u [0x%.2X].\n", AdcInit, AdcInit);
		}
	}
	if (AdcFound)
	{

	//~ //Adc1 channels:
	//~ #define TempChannel ads1258details::chan_se0
	//~ #define P3V3DChannel ads1258details::chan_se1
	//~ #define P28VChannel ads1258details::chan_se2
	//~ #define P2V2Channel ads1258details::chan_se3
	//~ #define P2V5DChannel ads1258details::chan_se4
	//~ #define P1V2Channel ads1258details::chan_se5
	//~ #define P2V5AChannel ads1258details::chan_se6
	//~ #define P4V3Channel ads1258details::chan_se7
	//~ #define I3VAChannel ads1258details::chan_se8
	//~ #define P3V3AChannel ads1258details::chan_se9
	//~ #define P6VChannel ads1258details::chan_se10
	//~ #define P5VAChannel ads1258details::chan_se11
	//~ #define LuxRadsChannel ads1258details::chan_se12
	//~ #define M18VChannel ads1258details::chan_se13
	//~ #define M20VChannel ads1258details::chan_se14
	//~ #define P125VChannel ads1258details::chan_se15

		Adc.ClearScanChannels();
		Adc.AddScanChannel(IHVChannel);
		Adc.AddScanChannel(IMVChannel);
		Adc.AddScanChannel(I6VChannel);
		Adc.AddScanChannel(I3VDChannel);
		Adc.AddScanChannel(I2VDChannel);
		Adc.AddScanChannel(I1VChannel);
		Adc.AddScanChannel(StrainBPChannel);
		Adc.AddScanChannel(StrainBMChannel);
		Adc.AddScanChannel(StrainDPChannel);
		Adc.AddScanChannel(StrainDMChannel);
		Adc.AddScanChannel(StrainCMChannel);
		Adc.AddScanChannel(StrainCPChannel);
		Adc.AddScanChannel(StrainAMChannel);
		Adc.AddScanChannel(StrainAPChannel);
		Adc.AddScanChannel(P5VDChannel);
		Adc.AddScanChannel(I2VAChannel);
		Adc.AddScanChannel(StrainBChannel);
		Adc.AddScanChannel(StrainDChannel);
		Adc.AddScanChannel(StrainCChannel);
		Adc.AddScanChannel(StrainAChannel);
		
		Adc.CommitScanChannels();
		Adc.StartChannelScan();
		//Take start pin high to initiate auto-scan
		{
			Adc.WriteRegister(ads1258details::register_gpiod, StartPinMask);
			//~ if (Monitor)
			{
				formatf("\nMonitorAdc: Starting A/D auto-scan; wrote 0x%.2X to gpio's, readback: 0x%.2X\n", StartPinMask, Adc.ReadRegister(ads1258details::register_gpiod));
				fflush(stdout);
			}
		}
	}
	else
	{
		formatf("\nMonitorAdc: No Adc found!\n");
	}
};
	
void CGraphFSMMonitorAdc::Process()
{
	if (AdcFound)
	{
		//~ we don't have anything connected to gpios but might in the future, and dm does if this code gets cut&pasted: GpioInputs = Adc.ReadRegister(ads1258details::register_gpiod);
		
		ads1258details::ads1258sample sample;
		
		for(size_t CurrentChan = 0; CurrentChan < ads1258details::ads1258numchannels; CurrentChan++)
		{
			ProcessAllUarts();
			
			Adc.AutoScan();
		
			if (Adc.IsScanChannel(CurrentChan))
			{
				ProcessAllUarts();
			
				Adc.GetLastSample(CurrentChan, sample);
				
				ProcessAllUarts();
								
				if ( (sample.status.isbrownout) || (sample.status.isclipped) )
				{ 
					if (Monitor) { ::formatf("\nMonitorAdc: ch %u bad status: 0x%.2X\n", sample.status.channel, sample.status.all); }
				}					
				else
				{
					if (sample.status.isnew)
					{
						if (Monitor) { ::formatf("\nMonitorAdc: ch %u reads: %lf Volts [%lu lsb's]\n", sample.status.channel, Adc.CountsToVolts(sample.sample), sample.sample); }

						switch(sample.status.channel)
						{
							case IHVChannel : { P1V2 = (sample.sample); break; } 
							case IMVChannel : { P2V2 = (sample.sample); break; } 
							case I6VChannel : { P28V = (sample.sample); break; } 
							case I3VDChannel : { P2V5 = (sample.sample); break; } 
							case I2VDChannel : { P6V = (sample.sample); break; } 
							case I1VChannel : { P5V = (sample.sample); break; } 
							case StrainBPChannel : { P3V3D = (sample.sample); break; } 
							case StrainBMChannel : { P4V3 = (sample.sample); break; } 
							case StrainDPChannel : { P2I2 = (sample.sample); break; } 
							case StrainDMChannel : { P4I3 = (sample.sample); break; } 
							case StrainCMChannel : { P6I = (sample.sample); break; } 
							case StrainCPChannel : { Aux0 = (sample.sample); break; } 
							case StrainAMChannel : { Aux1 = (sample.sample); break; } 
							case StrainAPChannel : { Aux2 = (sample.sample); break; } 
							case P5VDChannel : { AmbientLight = (sample.sample); break; } 
							case I2VAChannel : { Temperature = (sample.sample); break; } 
							
							default: { break; } //do nothing; we can scan all 16 channels and discard the unused ones.
						}
					}
					else
					{
						if (Monitor) { ::formatf("\nMonitorAdc: ch %u no new sample this scan.\n", sample.status.channel); }
					}						
				}
			}
		}
	}
};
	
const char ScanMonitorAdcCmdString[] = "SCANMONITORADC";
const char ScanMonitorAdcHelp[] = "\"ScanMonitorAdc\"; Show current input voltages...";
int8_t ScanMonitorAdcCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
    formatf("\n\nScanMonitorAdc Command: Values with corrected units follow:\n");
	
	formatf("IHV: %3.6lf V\n", MonitorAdc.GetP1V2());
	formatf("IMV: %3.6lf V\n", MonitorAdc.GetP2V2());
	formatf("I6V: %3.6lf V\n", MonitorAdc.GetP28V());
	formatf("I3VD: %3.6lf V\n", MonitorAdc.GetP2V5());
	formatf("I2VD: %3.6lf V\n", MonitorAdc.GetP6V());
	formatf("I1V: %3.6lf V\n", MonitorAdc.GetP5V());
	formatf("StrainB+: %3.6lf V\n", MonitorAdc.GetP3V3D());
	formatf("StrainB-: %3.6lf V\n", MonitorAdc.GetP4V3());
	formatf("StrainD+: %3.6lf V\n", MonitorAdc.GetP2I2());
	formatf("StrainD:- %3.6lf V\n", MonitorAdc.GetP4I3());
	formatf("StrainC-: %3.6lf V\n", MonitorAdc.GetP6I());
	formatf("StrainC+: %3.6lf V\n", MonitorAdc.GetAux0());
	formatf("StrainA-: %3.6lf V\n", MonitorAdc.GetAux1());
	formatf("StrainA+: %3.6lf V\n", MonitorAdc.GetAux2());
	formatf("P5VD: %3.6lf V\n", MonitorAdc.GetAmbientLight());
	formatf("I2VA: %3.6lf V\n", MonitorAdc.GetTemperature());
	
    formatf("\nScanMonitorAdc Command: Complete.\n\n");
    return(strlen(Params));
}

const char TestMonitorAdcCmdString[] = "TESTMONITORADC";
const char TestMonitorAdcHelp[] = "\"TestMonitorAdc\"; Show raw A/D counts...";
int8_t TestMonitorAdcCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument)
{
	size_t cycle = 0;
	//~ int key = 1;
	
	{
		cycle++;
	
		formatf("\n\nTestMonitorAdc Command: Serial: Reading A/D's (raw values):\n");
		
		int32_t Sample;
		 
		MonitorAdc.GetP1V2Raw(Sample); formatf("\nP1V2: %+ld, 0x%.8lX", (signed long)Sample, (unsigned long)Sample);
		MonitorAdc.GetP2V2Raw(Sample); formatf("\nP2V2: %+ld, 0x%.8lX", (signed long)Sample, (unsigned long)Sample);
		MonitorAdc.GetP28VRaw(Sample); formatf("\nP28V: %+ld, 0x%.8lX", (signed long)Sample, (unsigned long)Sample);
		MonitorAdc.GetP2V5Raw(Sample); formatf("\nP2V5: %+ld, 0x%.8lX", (signed long)Sample, (unsigned long)Sample);
		MonitorAdc.GetP6VRaw(Sample); formatf("\nP6V: %+ld, 0x%.8lX", (signed long)Sample, (unsigned long)Sample);
		MonitorAdc.GetP5VRaw(Sample); formatf("\nP5V: %+ld, 0x%.8lX", (signed long)Sample, (unsigned long)Sample);
		MonitorAdc.GetP3V3DRaw(Sample); formatf("\nP3V3D: %+ld, 0x%.8lX", (signed long)Sample, (unsigned long)Sample);
		MonitorAdc.GetP4V3Raw(Sample); formatf("\nP4V3: %+ld, 0x%.8lX", (signed long)Sample, (unsigned long)Sample);
		MonitorAdc.GetP2I2Raw(Sample); formatf("\nP2I2: %+ld, 0x%.8lX", (signed long)Sample, (unsigned long)Sample);
		MonitorAdc.GetP4I3Raw(Sample); formatf("\nP4I3: %+ld, 0x%.8lX", (signed long)Sample, (unsigned long)Sample);
		MonitorAdc.GetP6IRaw(Sample); formatf("\nP6I: %+ld, 0x%.8lX", (signed long)Sample, (unsigned long)Sample);
		MonitorAdc.GetAux0Raw(Sample); formatf("\nAux0: %+ld, 0x%.8lX", (signed long)Sample, (unsigned long)Sample);
		MonitorAdc.GetAux1Raw(Sample); formatf("\nAux1: %+ld, 0x%.8lX", (signed long)Sample, (unsigned long)Sample);
		MonitorAdc.GetAux2Raw(Sample); formatf("\nAux2: %+ld, 0x%.8lX", (signed long)Sample, (unsigned long)Sample);
		MonitorAdc.GetAmbientLightRaw(Sample); formatf("\nAmbientLight: %+ld, 0x%.8lX", (signed long)Sample, (unsigned long)Sample);
		MonitorAdc.GetTemperatureRaw(Sample); formatf("\nTemperature: %+ld, 0x%.8lX", (signed long)Sample, (unsigned long)Sample);
	
		//~ //Read raw from fpga:
		//~ for(size_t i = 0; i < 32; i++)
		//~ {
			//~ MonitorAdc.SetAdcReadChannel(i);
			//~ MonitorAdc.GetAdcSample(Sample);
			//~ formatf("\nCh%2u : ", i);
			//~ Sample.formatf();
			//~ double Volts = ((double)(0-(int32_t)Sample.Sample) * (double)8.192) / (1.0 * ((double)lt244xdetails::CountPosVRef - (double)lt244xdetails::CountNegVRef));
			//~ formatf("; %lfV.", Volts);
			
		//~ }
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
		P28VCalibrate.Calibrate(16.0, 0.0);
		P2V5Calibrate.Calibrate(2.0, 0.0);
		P6VCalibrate.Calibrate(4.922, 0.0);
		P5VCalibrate.Calibrate(4.922, 0.0);
		P3V3DCalibrate.Calibrate(2.0, 0.0);
		P4V3Calibrate.Calibrate(3.0, 0.0);
		P2I2Calibrate.Calibrate(1.0, 0.0);
		P4I3Calibrate.Calibrate(1.0, 0.0);
		P6ICalibrate.Calibrate(1.0, 0.0);
		Aux0Calibrate.Calibrate(1.0, 0.0);
		Aux1Calibrate.Calibrate(1.0, 0.0);
		Aux2Calibrate.Calibrate(1.0, 0.0);
		AmbientLightCalibrate.Calibrate(2.0, 0.0);
		TemperatureCalibrate.Calibrate(1.0, 0.0);
		formatf("\nMonitorAdcCalibrate: All calibrates set to defaults!\n\n");
		return(strlen(Params));
	}

	MonitorAdcCalibratedInput* CalibrateMe = NULL;
	
	if (0 == strncmp(InputName, "P1V2", 8)) { CalibrateMe = &P1V2Calibrate; } 
	if (0 == strncmp(InputName, "P2V2", 8)) { CalibrateMe = &P2V2Calibrate; } 
	if (0 == strncmp(InputName, "P28V", 8)) { CalibrateMe = &P28VCalibrate; } 
	if (0 == strncmp(InputName, "P2V5", 8)) { CalibrateMe = &P2V5Calibrate; } 
	if (0 == strncmp(InputName, "P6V", 8)) { CalibrateMe = &P6VCalibrate; } 
	if (0 == strncmp(InputName, "P5V", 8)) { CalibrateMe = &P5VCalibrate; } 
	if (0 == strncmp(InputName, "P3V3D", 8)) { CalibrateMe = &P3V3DCalibrate; } 
	if (0 == strncmp(InputName, "P4V3", 8)) { CalibrateMe = &P4V3Calibrate; } 
	if (0 == strncmp(InputName, "P2I2", 8)) { CalibrateMe = &P2I2Calibrate; } 
	if (0 == strncmp(InputName, "P4I3", 8)) { CalibrateMe = &P4I3Calibrate; } 
	if (0 == strncmp(InputName, "P6I", 8)) { CalibrateMe = &P6ICalibrate; } 
	if (0 == strncmp(InputName, "AUX0", 8)) { CalibrateMe = &Aux0Calibrate; } 
	if (0 == strncmp(InputName, "AUX1", 8)) { CalibrateMe = &Aux1Calibrate; } 
	if (0 == strncmp(InputName, "AUX2", 8)) { CalibrateMe = &Aux2Calibrate; } 
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


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
#pragma once

#include <stdint.h>
#include <string.h>

#include "adc/lt244x_accum.h"
#include "adc/lt244x.h"
#include "temp/TempLM35.hpp"
#include "format/formatf.h"

#include "cgraph/CGraphFSMHardwareInterface.hpp"
extern CGraphFSMHardwareInterface* FSM;	

const uint8_t MonitorAdcFpgaAdcSampleAddr = 104;
const uint8_t MonitorAdcFpgaAdcChannelAddr = 112;

struct PinoutMonitorAdc
{
	PinoutMonitorAdc() { }
	static uint8_t GetAdcReadChannel()								{ uint8_t val = *(((uint8_t*)FSM)+MonitorAdcFpgaAdcChannelAddr); return(val); }
	static void SetAdcReadChannel(const uint8_t val) 					{ *(((uint8_t*)FSM)+MonitorAdcFpgaAdcChannelAddr) = (uint8_t)val; }
	static void GetAdcSample(Ltc244xAccumulator& val) 				{ val = *((Ltc244xAccumulator*)(((uint8_t*)FSM)+MonitorAdcFpgaAdcSampleAddr)); }		
};

struct MonitorAdcCalibratedInput
{
	private:
		
		double Gain;
		double Offset;
		
	public:
		
	MonitorAdcCalibratedInput(double gain, double offset) : Gain(gain), Offset(offset) { }
	//~ MonitorAdcCalibratedInput() { }
	MonitorAdcCalibratedInput() : Gain(1.0), Offset(0.0) { }
	MonitorAdcCalibratedInput(const MonitorAdcCalibratedInput& a) : Gain(a.Gain), Offset(a.Offset) { }
	
	void Calibrate(double gain, double offset) { Gain = gain; Offset = offset; }
	
	//~ double ReadCalibrated(const int32_t& RawInput) const { return((((double)(RawInput)) * Gain) + Offset); }
	double ReadCalibrated(const Ltc244xAccumulator& RawInput) const { return( (RawInput.CountsToVolts() * Gain) + Offset); }
	
	double GetGain() const { return(Gain); }
	double GetOffset() const { return(Offset); }
};

extern MonitorAdcCalibratedInput P1V2Calibrate;
extern MonitorAdcCalibratedInput P2V2Calibrate;
extern MonitorAdcCalibratedInput P24VCalibrate;
extern MonitorAdcCalibratedInput P2V5Calibrate;
extern MonitorAdcCalibratedInput P3V3ACalibrate;
extern MonitorAdcCalibratedInput P6VCalibrate;
extern MonitorAdcCalibratedInput P5VCalibrate;
extern MonitorAdcCalibratedInput P3V3DCalibrate;
extern MonitorAdcCalibratedInput P4V3Calibrate;
extern MonitorAdcCalibratedInput N6VCalibrate;
extern MonitorAdcCalibratedInput N5VCalibrate;
extern MonitorAdcCalibratedInput P150VCalibrate;
extern MonitorAdcCalibratedInput Aux0Calibrate;
extern MonitorAdcCalibratedInput Aux1Calibrate;
extern MonitorAdcCalibratedInput AmbientLightCalibrate;
extern MonitorAdcCalibratedInput TemperatureCalibrate;

//~ template <class spi, class adcpinout, unsigned int spiclkdivider = 39>
struct CGraphFSMMonitorAdc
{
	
private:
			
	lt244x_accum<PinoutMonitorAdc> Adc;
	
public:
	
	CGraphFSMMonitorAdc() : Adc(4.096)//, 
	{ }
	
	~CGraphFSMMonitorAdc() { }
	
	static uint8_t GetAdcReadChannel()								{ uint8_t val = *(((uint8_t*)FSM)+MonitorAdcFpgaAdcChannelAddr); return(val); }
	static void SetAdcReadChannel(const uint8_t val) 					{ *(((uint8_t*)FSM)+MonitorAdcFpgaAdcChannelAddr) = (uint8_t)val; }
	static void GetAdcSample(Ltc244xAccumulator& val) 				{ val = *((Ltc244xAccumulator*)(((uint8_t*)FSM)+MonitorAdcFpgaAdcSampleAddr)); }		
	
	//Adc channels:
	#define P1V2Channel Adc.chan_se0
	#define P2V2Channel Adc.chan_se1
	#define P24VChannel Adc.chan_se2
	#define P2V5Channel Adc.chan_se3
	#define P3V3AChannel Adc.chan_se4
	#define P6VChannel Adc.chan_se5
	#define P5VChannel Adc.chan_se6
	#define P3V3DChannel Adc.chan_se7
	#define P4V3Channel Adc.chan_se8
	#define N5VChannel Adc.chan_se9
	#define N6VChannel Adc.chan_se10
	#define P150VChannel Adc.chan_se11
	#define Aux0Channel Adc.chan_se12
	#define Aux1Channel Adc.chan_se13
	#define AmbientLightChannel Adc.chan_se14
	#define TemperatureChannel Adc.chan_se15
	
	double GetP1V2() { Ltc244xAccumulator val; Adc.ReadChannel(P1V2Channel, val); return(P1V2Calibrate.ReadCalibrated(val)); }
	double GetP2V2() { Ltc244xAccumulator val; Adc.ReadChannel(P2V2Channel, val); return(P2V2Calibrate.ReadCalibrated(val)); }
	double GetP24V() { Ltc244xAccumulator val; Adc.ReadChannel(P24VChannel, val); return(P24VCalibrate.ReadCalibrated(val)); }
	double GetP2V5() { Ltc244xAccumulator val; Adc.ReadChannel(P2V5Channel, val); return(P2V5Calibrate.ReadCalibrated(val)); }
	double GetP3V3A() { Ltc244xAccumulator val; Adc.ReadChannel(P3V3AChannel, val); return(P3V3ACalibrate.ReadCalibrated(val)); }
	double GetP6V() { Ltc244xAccumulator val; Adc.ReadChannel(P6VChannel, val); return(P6VCalibrate.ReadCalibrated(val)); }
	double GetP5V() { Ltc244xAccumulator val; Adc.ReadChannel(P5VChannel, val); return(P5VCalibrate.ReadCalibrated(val)); }
	double GetP3V3D() { Ltc244xAccumulator val; Adc.ReadChannel(P3V3DChannel, val); return(P3V3DCalibrate.ReadCalibrated(val)); }
	double GetP4V3() { Ltc244xAccumulator val; Adc.ReadChannel(P4V3Channel, val); return(P4V3Calibrate.ReadCalibrated(val)); }
	double GetN5V() { Ltc244xAccumulator val; Adc.ReadChannel(N5VChannel, val); return(N5VCalibrate.ReadCalibrated(val)); }
	double GetN6V() { Ltc244xAccumulator val; Adc.ReadChannel(N6VChannel, val); return(N6VCalibrate.ReadCalibrated(val)); }
	double GetP150V() { Ltc244xAccumulator val; Adc.ReadChannel(P150VChannel, val); return(P150VCalibrate.ReadCalibrated(val)); }
	double GetAux0() { Ltc244xAccumulator val; Adc.ReadChannel(Aux0Channel, val); return(Aux0Calibrate.ReadCalibrated(val)); }
	double GetAux1() { Ltc244xAccumulator val; Adc.ReadChannel(Aux1Channel, val); return(Aux1Calibrate.ReadCalibrated(val)); }
	double GetAmbientLight() { Ltc244xAccumulator val; Adc.ReadChannel(AmbientLightChannel, val); return(AmbientLightCalibrate.ReadCalibrated(val)); }
	double GetTemperature() { Ltc244xAccumulator val; Adc.ReadChannel(TemperatureChannel, val); return(TemperatureCalibrate.ReadCalibrated(val)); }
	
	void GetP1V2Raw(Ltc244xAccumulator& val) { Adc.ReadChannel(P1V2Channel, val); }
	void GetP2V2Raw(Ltc244xAccumulator& val) { Adc.ReadChannel(P2V2Channel, val); }
	void GetP24VRaw(Ltc244xAccumulator& val) { Adc.ReadChannel(P24VChannel, val); }
	void GetP2V5Raw(Ltc244xAccumulator& val) { Adc.ReadChannel(P2V5Channel, val); }
	void GetP3V3ARaw(Ltc244xAccumulator& val) { Adc.ReadChannel(P3V3AChannel, val); }
	void GetP6VRaw(Ltc244xAccumulator& val) { Adc.ReadChannel(P6VChannel, val); }
	void GetP5VRaw(Ltc244xAccumulator& val) { Adc.ReadChannel(P5VChannel, val); }
	void GetP3V3DRaw(Ltc244xAccumulator& val) { Adc.ReadChannel(P3V3DChannel, val); }
	void GetP4V3Raw(Ltc244xAccumulator& val) { Adc.ReadChannel(P4V3Channel, val); }
	void GetN5VRaw(Ltc244xAccumulator& val) { Adc.ReadChannel(N5VChannel, val); }
	void GetN6VRaw(Ltc244xAccumulator& val) { Adc.ReadChannel(N6VChannel, val); }
	void GetP150VRaw(Ltc244xAccumulator& val) { Adc.ReadChannel(P150VChannel, val); }
	void GetAux0Raw(Ltc244xAccumulator& val) { Adc.ReadChannel(Aux0Channel, val); }
	void GetAux1Raw(Ltc244xAccumulator& val) { Adc.ReadChannel(Aux1Channel, val); }
	void GetAmbientLightRaw(Ltc244xAccumulator& val) { Adc.ReadChannel(AmbientLightChannel, val); }
	void GetTemperatureRaw(Ltc244xAccumulator& val) { Adc.ReadChannel(TemperatureChannel, val); }
	
	//~ double GetP1V2() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(P1V2Channel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetP2V2() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(P2V2Channel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetP24V() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(P24VChannel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetP2V5() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(P2V5Channel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetP3V3A() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(P3V3AChannel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetP6V() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(P6VChannel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetP5V() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(P5VChannel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetP3V3D() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(P3V3DChannel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetOutputCurrent() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(OutputCurrentChannel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetOutputVoltage() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(OutputVoltageChannel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetInputCurrent() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(InputCurrentChannel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetInputVoltage() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(InputVoltageChannel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetP4V3() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(P4V3Channel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetN5V() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(N5VChannel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetN6V() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(N6VChannel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetP150V() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(P150VChannel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetAux0() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(Aux0Channel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetAux1() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(Aux1Channel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetAmbientLight() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(AmbientLightChannel, val); return(Adc.CountsToVolts(val)); }
	//~ double GetTemperature() { lt244xdetails::lt244x_sample val; Adc.ReadChannel(TemperatureChannel, val); return(Adc.CountsToVolts(val)); }
	
	void SaveCals(double* Buffer, size_t& BufferMaxInBufferUsedOut)
	{
		if ( (NULL == Buffer) || (BufferMaxInBufferUsedOut < (32 * sizeof(double))) )
		{ 
			formatf("\nMonitorAdc: Insufficient Buffer to save Calibrates! Given: %zu, required: %zu\n\n", BufferMaxInBufferUsedOut, (32 * sizeof(double)));
			return; 
		}
				
		Buffer[0] = P1V2Calibrate.GetGain();
		Buffer[1] = P2V2Calibrate.GetGain();
		Buffer[2] = P24VCalibrate.GetGain();
		Buffer[3] = P2V5Calibrate.GetGain();
		Buffer[4] = P3V3ACalibrate.GetGain();
		Buffer[5] = P6VCalibrate.GetGain();
		Buffer[6] = P5VCalibrate.GetGain();
		Buffer[7] = P3V3DCalibrate.GetGain();
		Buffer[8] = P4V3Calibrate.GetGain();
		Buffer[9] = N5VCalibrate.GetGain();
		Buffer[10] = N6VCalibrate.GetGain();
		Buffer[11] = P150VCalibrate.GetGain();	
		Buffer[12] = Aux0Calibrate.GetGain();
		Buffer[13] = Aux1Calibrate.GetGain();
		Buffer[14] = AmbientLightCalibrate.GetGain();
		Buffer[15] = TemperatureCalibrate.GetGain();	
		
		Buffer[16] = P1V2Calibrate.GetOffset();
		Buffer[17] = P2V2Calibrate.GetOffset();
		Buffer[18] = P24VCalibrate.GetOffset();
		Buffer[19] = P2V5Calibrate.GetOffset();
		Buffer[20] = P3V3ACalibrate.GetOffset();
		Buffer[21] = P6VCalibrate.GetOffset();
		Buffer[22] = P5VCalibrate.GetOffset();
		Buffer[23] = P3V3DCalibrate.GetOffset();
		Buffer[24] = P4V3Calibrate.GetOffset();
		Buffer[25] = N5VCalibrate.GetOffset();
		Buffer[26] = N6VCalibrate.GetOffset();
		Buffer[27] = P150VCalibrate.GetOffset();	
		Buffer[28] = Aux0Calibrate.GetOffset();
		Buffer[29] = Aux1Calibrate.GetOffset();
		Buffer[30] = AmbientLightCalibrate.GetOffset();
		Buffer[31] = TemperatureCalibrate.GetOffset();	
		
		BufferMaxInBufferUsedOut = (32 * sizeof(double));
	}

	void RestoreCals(const double* Buffer, size_t& BufferMaxInBufferUsedOut)	
	{
		if ( (NULL == Buffer) || ((BufferMaxInBufferUsedOut < (32 * sizeof(double)))) )
		{ 
			formatf("\nMonitorAdc: Insufficient Buffer to restore Calibrates! Given: %zu, required: %zu\n\n", BufferMaxInBufferUsedOut, (32 * sizeof(double)));
			return; 
		}
		
		P1V2Calibrate.Calibrate(Buffer[0], Buffer[16]);
		P2V2Calibrate.Calibrate(Buffer[1], Buffer[17]);
		P24VCalibrate.Calibrate(Buffer[2], Buffer[18]);
		P2V5Calibrate.Calibrate(Buffer[3], Buffer[19]);
		P3V3ACalibrate.Calibrate(Buffer[4], Buffer[20]);
		P6VCalibrate.Calibrate(Buffer[5], Buffer[21]);
		P5VCalibrate.Calibrate(Buffer[6], Buffer[22]);
		P3V3DCalibrate.Calibrate(Buffer[7], Buffer[23]);
		P4V3Calibrate.Calibrate(Buffer[8], Buffer[24]);
		N5VCalibrate.Calibrate(Buffer[9], Buffer[25]);
		N6VCalibrate.Calibrate(Buffer[10], Buffer[26]);
		P150VCalibrate.Calibrate(Buffer[11], Buffer[27]);	
		Aux0Calibrate.Calibrate(Buffer[12], Buffer[28]);
		Aux1Calibrate.Calibrate(Buffer[13], Buffer[29]);
		AmbientLightCalibrate.Calibrate(Buffer[14], Buffer[30]);
		TemperatureCalibrate.Calibrate(Buffer[15], Buffer[31]);	
		
		BufferMaxInBufferUsedOut = (32 * sizeof(double));
	}
};

//Command Parser interface:
extern const char ScanMonitorAdcCmdString[];
extern const char ScanMonitorAdcHelp[];
int8_t ScanMonitorAdcCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);

extern const char TestMonitorAdcCmdString[];
extern const char TestMonitorAdcHelp[];
int8_t TestMonitorAdcCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);

extern const char CalibrateMonitorAdcCmdString[];
extern const char CalibrateMonitorAdcHelp[];
int8_t CalibrateMonitorAdcCommand(char const* Name, char const* Params, const size_t ParamsLen, const void* Argument);

//EOF

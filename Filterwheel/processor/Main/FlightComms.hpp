#include <stdint.h>
#include <string.h>
#include <stdio.h>
//~ #include <setjmp.h>
//~ #include <signal.h>
//~ #include <syscall.h>
//~ #include <execinfo.h>
//~ #include <ucontext.h>
//~ #include <sys/resource.h>

//DEBUG!
//~ #include "dbg/memwatch.h"
//~ #include <mcheck.h>

#include "Delay.h"

#include "uart/IUart.h"

#include "uart/BinaryUart.hpp"

#include "cgraph/CGraphPacket.hpp"

#include "cgraph/CGraphFWHardwareInterface.hpp"
extern CGraphFWHardwareInterface* FW;	

#include "CmdTableBinary.hpp"

//~ size_t LastUartCount = 0;
bool MonitorSerial0 = false;
bool MonitorSerial1 = false;
bool MonitorSerial2 = false;
bool MonitorSerial3 = false;
bool MonitorSerialUsb = false;
		
class FW_pinout_FPGAUart3 : public IUart
{
public:

	FW_pinout_FPGAUart3() : IUart() { }
	virtual ~FW_pinout_FPGAUart3() { }

	virtual int init(const uint32_t nc, const char* nc3) { return(IUartOK); }

	virtual void deinit() { }
	
	virtual bool dataready() const
	{
		if (NULL == FW) { return(false); }
		CGraphFWUartStatusRegister UartStatus = FW->UartStatusRegister3;
		return(0 == UartStatus.RxFifoEmpty);
	}

	virtual char getcqq()
	{
		if (NULL == FW) { return(false); }
		uint16_t c = 0;
		c = FW->UartFifo3;
		c >>= 8;
		//~ formatf("|%c", c);
		if (MonitorSerial3) { formatf("|%.3x", c); }
		//~ formatf("|%.4x", c);
		return((char)(c));
	}

	virtual char putcqq(char c)
	{
		if (NULL == FW) { return(c); }
		FW->UartFifo3 = c;		
		delayus(13); //This was neccessary the last hardware we tried this on...
		return(c);
	}
	
	virtual size_t depth() const
	{
		if (NULL == FW) { return(false); }
		CGraphFWUartStatusRegister UartStatus = FW->UartStatusRegister3;
		return(UartStatus.RxFifoCount);
	}

	virtual void flushoutput() { } // if (FW) { FW->UartTxStatusRegister = 0; } //Need to make tx & rx status registers seperate...
	virtual void purgeinput() { } // if (FW) { FW->UartRxStatusRegister = 0; }	
	virtual bool connected() { return(true); }	
	virtual bool isopen() const { return(true); }	
	
	private:
		//~ CGraphFWHardwareInterface* fpgaFW;	
	
};

class FW_pinout_FPGAUart2 : public IUart
{
public:

	FW_pinout_FPGAUart2() : IUart() { }
	virtual ~FW_pinout_FPGAUart2() { }

	virtual int init(const uint32_t nc, const char* nc2) { return(IUartOK); }

	virtual void deinit() { }
	
	virtual bool dataready() const
	{
		if (NULL == FW) { return(false); }
		CGraphFWUartStatusRegister UartStatus = FW->UartStatusRegister2;
		return(0 == UartStatus.RxFifoEmpty);
	}

	virtual char getcqq()
	{
		if (NULL == FW) { return(false); }
		uint16_t c = 0;
		c = FW->UartFifo2;
		c >>= 8;
		//~ formatf("|%c", c);
		if (MonitorSerial2) { formatf("|%.2x", c); }
		//~ formatf("|%.4x", c);
		return((char)(c));
	}

	virtual char putcqq(char c)
	{
		if (NULL == FW) { return(c); }
		FW->UartFifo2 = c;		
		delayus(12); //This was neccessary the last hardware we tried this on...
		return(c);
	}
	
	virtual size_t depth() const
	{
		if (NULL == FW) { return(false); }
		CGraphFWUartStatusRegister UartStatus = FW->UartStatusRegister2;
		return(UartStatus.RxFifoCount);
	}

	virtual void flushoutput() { } // if (FW) { FW->UartTxStatusRegister = 0; } //Need to make tx & rx status registers seperate...
	virtual void purgeinput() { } // if (FW) { FW->UartRxStatusRegister = 0; }	
	virtual bool connected() { return(true); }	
	virtual bool isopen() const { return(true); }	
	
	private:
		//~ CGraphFWHardwareInterface* fpgaFW;	
	
};

class FW_pinout_FPGAUart1 : public IUart
{
public:

	FW_pinout_FPGAUart1() : IUart() { }
	virtual ~FW_pinout_FPGAUart1() { }

	virtual int init(const uint32_t nc, const char* nc2) { return(IUartOK); }

	virtual void deinit() { }
	
	virtual bool dataready() const
	{
		if (NULL == FW) { return(false); }
		CGraphFWUartStatusRegister UartStatus = FW->UartStatusRegister1;
		return(0 == UartStatus.RxFifoEmpty);
	}

	virtual char getcqq()
	{
		if (NULL == FW) { return(false); }
		uint16_t c = 0;
		c = FW->UartFifo1;
		c >>= 8;
		//~ formatf("|%c", c);
		if (MonitorSerial1) { formatf("!%.2x", c); }
		//~ formatf("|%.4x", c);
		return((char)(c));
	}

	virtual char putcqq(char c)
	{
		if (NULL == FW) { return(c); }
		FW->UartFifo1 = c;		
		delayus(12); //This was neccessary the last hardware we tried this on...
		return(c);
	}
	
	virtual size_t depth() const
	{
		if (NULL == FW) { return(false); }
		CGraphFWUartStatusRegister UartStatus = FW->UartStatusRegister1;
		return(UartStatus.RxFifoCount);
	}

	virtual void flushoutput() { } // if (FW) { FW->UartTxStatusRegister = 0; } //Need to make tx & rx status registers seperate...
	virtual void purgeinput() { } // if (FW) { FW->UartRxStatusRegister = 0; }	
	virtual bool connected() { return(true); }	
	virtual bool isopen() const { return(true); }	
	
	private:
		//~ CGraphFWHardwareInterface* fpgaFW;	

};

class FW_pinout_FPGAUart0 : public IUart
{
public:

	FW_pinout_FPGAUart0() : IUart() { }
	virtual ~FW_pinout_FPGAUart0() { }

	virtual int init(const uint32_t nc, const char* nc2) { return(IUartOK); }

	virtual void deinit() { }
	
	virtual bool dataready() const
	{
		if (NULL == FW) { return(false); }
		CGraphFWUartStatusRegister UartStatus = FW->UartStatusRegister0;
		return(0 == UartStatus.RxFifoEmpty);
	}

	virtual char getcqq()
	{
		if (NULL == FW) { return(false); }
		uint16_t c = 0;
		c = FW->UartFifo0;
		c >>= 8;
		//~ formatf("|%c", c);
		if (MonitorSerial0) { formatf(":%.2x", c); }
		//~ formatf("|%.4x", c);
		return((char)(c));
	}

	virtual char putcqq(char c)
	{
		if (NULL == FW) { return(c); }
		FW->UartFifo0 = c;		
		delayus(12); //This was neccessary the last hardware we tried this on...
		return(c);
	}
	
	virtual size_t depth() const
	{
		if (NULL == FW) { return(false); }
		CGraphFWUartStatusRegister UartStatus = FW->UartStatusRegister0;
		return(UartStatus.RxFifoCount);
	}

	virtual void flushoutput() { } // if (FW) { FW->UartTxStatusRegister = 0; } //Need to make tx & rx status registers seperate...
	virtual void purgeinput() { } // if (FW) { FW->UartRxStatusRegister = 0; }	
	virtual bool connected() { return(true); }	
	virtual bool isopen() const { return(true); }	
	
	private:
		//~ CGraphFWHardwareInterface* fpgaFW;	
	
};

		
class FW_pinout_FPGAUartUsb : public IUart
{
public:

	FW_pinout_FPGAUartUsb() : IUart() { }
	virtual ~FW_pinout_FPGAUartUsb() { }

	virtual int init(const uint32_t nc, const char* ncUsb) { return(IUartOK); }

	virtual void deinit() { }
	
	virtual bool dataready() const
	{
		if (NULL == FW) { return(false); }
		CGraphFWUartStatusRegister UartStatus = FW->UartStatusRegisterUsb;
		//return(0 == UartStatus.RxFifoEmpty);
		return(0 != UartStatus.RxFifoCount);
	}

	virtual char getcqq()
	{
		if (NULL == FW) { return(false); }
		uint16_t c = 0;
		c = ((FW->UartFifoUsb) & 0x00FFU);
		//c >>= 8;
		//~ formatf("|%c", c);
		if (MonitorSerialUsb) { formatf("|%.Usbx", c); }
		//~ formatf("|%.4x", c);
		return((char)(c));
	}

	virtual char putcqq(char c)
	{
		if (NULL == FW) { return(c); }
		FW->UartFifoUsb = c;		
		delayus(12); //This was neccessary the last hardware we tried this on...
		return(c);
	}
	
	virtual size_t depth() const
	{
		if (NULL == FW) { return(false); }
		CGraphFWUartStatusRegister UartStatus = FW->UartStatusRegisterUsb;
		return(UartStatus.RxFifoCount);
	}

	virtual void flushoutput() { } // if (FW) { FW->UartTxStatusRegister = 0; } //Need to make tx & rx status registers seperate...
	virtual void purgeinput() { } // if (FW) { FW->UartRxStatusRegister = 0; }	
	virtual bool connected() { return(true); }	
	virtual bool isopen() const { return(true); }	
	
	private:
		//~ CGraphFWHardwareInterface* fpgaFW;		
};

struct FPGABinaryUartCallbacks : public BinaryUartCallbacks
{
	FPGABinaryUartCallbacks() { }
	virtual ~FPGABinaryUartCallbacks() { }
	
	//Malformed/corrupted packet handler:
	virtual void InvalidPacket(const uint8_t* Buffer, const size_t& BufferLen)
	{ 
		if ( (NULL == Buffer) || (BufferLen < 1) ) { formatf("\nFPGAUartCallbacks: NULL(%u) InvalidPacket!\n\n", BufferLen); return; }
	
		size_t len = BufferLen;
		if (len > 32) { len = 32; }
		formatf("\nFPGAUartCallbacks: InvalidPacket! contents: :");
		for(size_t i = 0; i < len; i++) { formatf("%.2X:", Buffer[i]); }
		formatf("\n\n");
	}
	
	//Packet with no matching command handler:
	virtual void UnHandledPacket(const IPacket* Packet, const size_t& PacketLen)
	{ 
		if ( (NULL == Packet) || (PacketLen < sizeof(CGraphPacketHeader)) ) { formatf("\nFPGABinaryUartCallbacks: NULL(%u) UnHandledPacket!\n\n", PacketLen); return; }
		
		const CGraphPacketHeader* Header = reinterpret_cast<const CGraphPacketHeader*>(Packet);
		formatf("\nFPGAUartCallbacks: Unhandled packet(%u): ", PacketLen);
		Header->formatf();
		formatf("\n\n");
	}
	
	//In case we need to look at every packet that goes by...
	//~ virtual void EveryPacket(const IPacket& Packet, const size_t& PacketLen) { }
	
	//We just wanna see if this is happening, not much to do about it
	virtual void BufferOverflow(const uint8_t* Buffer, const size_t& BufferLen) 
	{ 
		//~ formatf("\nFPGABinaryUartCallbacks: BufferOverflow(%zu)!\n", BufferLen);
	}

};



//EOF

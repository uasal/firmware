#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <ctype.h>
//~ #include <cctype>

//open files:
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#include <iostream>
using namespace std;

#include <pthread.h>

#include "uart/BinaryUart.hpp"

#include "cgraph/CGraphPacket.hpp"

#include "uart/linux_pinout_client_socket.hpp"

#include "uart/AsciiCmdUserInterfaceLinux.h"

#include "../CmdTableAscii.hpp"
#include "../CmdTableBinary.hpp"

//~ #include "main.hpp"

struct SocketBinaryUartCallbacks : public BinaryUartCallbacks
{
	SocketBinaryUartCallbacks() { }
	virtual ~SocketBinaryUartCallbacks() { }
	
	//Malformed/corrupted packet handler:
	virtual void InvalidPacket(const uint8_t* Buffer, const size_t& BufferLen)
	{ 
		if ( (NULL == Buffer) || (BufferLen < 1) ) { printf("\nSocketUartCallbacks: NULL(%lu) InvalidPacket!\n\n", (unsigned long)BufferLen); return; }
	
		size_t len = BufferLen;
		if (len > 32) { len = 32; }
		printf("\nSocketUartCallbacks: InvalidPacket! contents: :");
		for(size_t i = 0; i < len; i++) { printf("%.2X:", Buffer[i]); }
		printf("\n\n");
	}
	
	//Packet with no matching command handler:
	virtual void UnHandledPacket(const IPacket* Packet, const size_t& PacketLen)
	{ 
		if ( (NULL == Packet) || (PacketLen < sizeof(CGraphPacketHeader)) ) { printf("\nSocketUartCallbacks: NULL(%lu) UnHandledPacket!\n\n", (unsigned long)PacketLen); return; }
		
		const CGraphPacketHeader* Header = reinterpret_cast<const CGraphPacketHeader*>(Packet);
		printf("\nSocketUartCallbacks: Unhandled packet(%lu): ", (unsigned long)PacketLen);
		Header->formatf();
		printf("\n\n");
	}
	
	//In case we need to look at every packet that goes by...
	//~ virtual void EveryPacket(const IPacket& Packet, const size_t& PacketLen) { }
	
	//We just wanna see if this is happening, not much to do about it
	virtual void BufferOverflow(const uint8_t* Buffer, const size_t& BufferLen) 
	{ 
		printf("\nSocketBinaryUartCallbacks: BufferOverflow(%zu)!\n", BufferLen);
	}

} PacketCallbacks;

CGraphPacket SocketProtocol;

linux_pinout_client_socket LocalPortPinout;

BinaryUart UartParser(LocalPortPinout, SocketProtocol, BinaryCmds, NumBinaryCmds, PacketCallbacks, false);

bool Process()
{
    return(ProcessUserInterface());
}

int main(int argc, char *argv[])
{
	char PortName[255];
    int nHostPort = 65536 + 1337;	
    // strcpy(PortName, "192.168.1.223");
    strcpy(PortName, "127.0.0.1");
	
	//Tell C lib (stdio.h) not to buffer output, so we can ditch all the fflush(stdout) calls...
	setvbuf(stdout, NULL, _IONBF, 0);

	formatf("\n\n\n\nWelcome to UASALBinaryCmdr!");
	formatf("\n\nIn order to tunnel to the lab use the following command before running this program: \"ssh -L 1337:localhost:1337 -N -f fsm\" (where fsm is the ssh alias of the remote server)!\n\n");
	
	
	//~ #ifdef WIN32
	//~ // set to line buffered mode.
	//~ SetConsoleMode(GetStdHandle(STD_INPUT_HANDLE),ENABLE_LINE_INPUT|ENABLE_ECHO_INPUT);
	//~ #endif

	//IP other than localhost?
	if (argc > 1)
    {
        strncpy(PortName, argv[1], 255);
        PortName[255] = '\0';
    }
    
	//non-standard port?
	if (argc > 2)
    {
        nHostPort = atoi(argv[2]);
    }
	
    int err = LocalPortPinout.init(nHostPort, PortName);
    if (IUart::IUartOK != err)
    {
        formatf("UASALBinaryCmdr: can't open socket (%s:%u), exiting.\n", PortName, nHostPort);
        exit(-1);
    }
	
	printf("\n\nUASALBinaryCmdr: Start User Interface...");    
	
	StartUserInterface();
	
	//~ UartParser.Debug(true);
	UartParser.Debug(false);
	
	while(true)
	{
		bool Bored = true;
		
		//Handle stdio (local) user interface:
        if (Process())
        {
            Bored = false;
        }
		
		if (UartParser.Process())
		{
            Bored = false;
        }
		
		if (false == LocalPortPinout.connected())
		{
			int err = LocalPortPinout.init(nHostPort, PortName);
			if (IUart::IUartOK != err)
			{
				formatf("UASALBinaryCmdr: can't open socket (%s:%l).\n", PortName, nHostPort);
				//~ exit(-1);
			}
		}

		//give up our timeslice so as not to bog the system
		if (Bored)
		{
			#ifdef WIN32
			Sleep(50);
			#else
			struct timespec fiftymilliseconds;
			memset((char *)&fiftymilliseconds,0,sizeof(fiftymilliseconds));
			fiftymilliseconds.tv_nsec = 50000000;
			nanosleep(&fiftymilliseconds, NULL);
			#endif
		}
	}

    return(0);
}

//This technically is a "BZIP2CRC32", not an "ANSICRC32"; seealso: https://crccalc.com/
uint32_t CRC32(const uint8_t* data, const size_t length)
{
	static const uint32_t table[256] = 
	{
    0x00000000UL,0x04C11DB7UL,0x09823B6EUL,0x0D4326D9UL,
    0x130476DCUL,0x17C56B6BUL,0x1A864DB2UL,0x1E475005UL,
    0x2608EDB8UL,0x22C9F00FUL,0x2F8AD6D6UL,0x2B4BCB61UL,
    0x350C9B64UL,0x31CD86D3UL,0x3C8EA00AUL,0x384FBDBDUL,
    0x4C11DB70UL,0x48D0C6C7UL,0x4593E01EUL,0x4152FDA9UL,
    0x5F15ADACUL,0x5BD4B01BUL,0x569796C2UL,0x52568B75UL,
    0x6A1936C8UL,0x6ED82B7FUL,0x639B0DA6UL,0x675A1011UL,
    0x791D4014UL,0x7DDC5DA3UL,0x709F7B7AUL,0x745E66CDUL,
    0x9823B6E0UL,0x9CE2AB57UL,0x91A18D8EUL,0x95609039UL,
    0x8B27C03CUL,0x8FE6DD8BUL,0x82A5FB52UL,0x8664E6E5UL,
    0xBE2B5B58UL,0xBAEA46EFUL,0xB7A96036UL,0xB3687D81UL,
    0xAD2F2D84UL,0xA9EE3033UL,0xA4AD16EAUL,0xA06C0B5DUL,
    0xD4326D90UL,0xD0F37027UL,0xDDB056FEUL,0xD9714B49UL,
    0xC7361B4CUL,0xC3F706FBUL,0xCEB42022UL,0xCA753D95UL,
    0xF23A8028UL,0xF6FB9D9FUL,0xFBB8BB46UL,0xFF79A6F1UL,
    0xE13EF6F4UL,0xE5FFEB43UL,0xE8BCCD9AUL,0xEC7DD02DUL,
    0x34867077UL,0x30476DC0UL,0x3D044B19UL,0x39C556AEUL,
    0x278206ABUL,0x23431B1CUL,0x2E003DC5UL,0x2AC12072UL,
    0x128E9DCFUL,0x164F8078UL,0x1B0CA6A1UL,0x1FCDBB16UL,
    0x018AEB13UL,0x054BF6A4UL,0x0808D07DUL,0x0CC9CDCAUL,
    0x7897AB07UL,0x7C56B6B0UL,0x71159069UL,0x75D48DDEUL,
    0x6B93DDDBUL,0x6F52C06CUL,0x6211E6B5UL,0x66D0FB02UL,
    0x5E9F46BFUL,0x5A5E5B08UL,0x571D7DD1UL,0x53DC6066UL,
    0x4D9B3063UL,0x495A2DD4UL,0x44190B0DUL,0x40D816BAUL,
    0xACA5C697UL,0xA864DB20UL,0xA527FDF9UL,0xA1E6E04EUL,
    0xBFA1B04BUL,0xBB60ADFCUL,0xB6238B25UL,0xB2E29692UL,
    0x8AAD2B2FUL,0x8E6C3698UL,0x832F1041UL,0x87EE0DF6UL,
    0x99A95DF3UL,0x9D684044UL,0x902B669DUL,0x94EA7B2AUL,
    0xE0B41DE7UL,0xE4750050UL,0xE9362689UL,0xEDF73B3EUL,
    0xF3B06B3BUL,0xF771768CUL,0xFA325055UL,0xFEF34DE2UL,
    0xC6BCF05FUL,0xC27DEDE8UL,0xCF3ECB31UL,0xCBFFD686UL,
    0xD5B88683UL,0xD1799B34UL,0xDC3ABDEDUL,0xD8FBA05AUL,
    0x690CE0EEUL,0x6DCDFD59UL,0x608EDB80UL,0x644FC637UL,
    0x7A089632UL,0x7EC98B85UL,0x738AAD5CUL,0x774BB0EBUL,
    0x4F040D56UL,0x4BC510E1UL,0x46863638UL,0x42472B8FUL,
    0x5C007B8AUL,0x58C1663DUL,0x558240E4UL,0x51435D53UL,
    0x251D3B9EUL,0x21DC2629UL,0x2C9F00F0UL,0x285E1D47UL,
    0x36194D42UL,0x32D850F5UL,0x3F9B762CUL,0x3B5A6B9BUL,
    0x0315D626UL,0x07D4CB91UL,0x0A97ED48UL,0x0E56F0FFUL,
    0x1011A0FAUL,0x14D0BD4DUL,0x19939B94UL,0x1D528623UL,
    0xF12F560EUL,0xF5EE4BB9UL,0xF8AD6D60UL,0xFC6C70D7UL,
    0xE22B20D2UL,0xE6EA3D65UL,0xEBA91BBCUL,0xEF68060BUL,
    0xD727BBB6UL,0xD3E6A601UL,0xDEA580D8UL,0xDA649D6FUL,
    0xC423CD6AUL,0xC0E2D0DDUL,0xCDA1F604UL,0xC960EBB3UL,
    0xBD3E8D7EUL,0xB9FF90C9UL,0xB4BCB610UL,0xB07DABA7UL,
    0xAE3AFBA2UL,0xAAFBE615UL,0xA7B8C0CCUL,0xA379DD7BUL,
    0x9B3660C6UL,0x9FF77D71UL,0x92B45BA8UL,0x9675461FUL,
    0x8832161AUL,0x8CF30BADUL,0x81B02D74UL,0x857130C3UL,
    0x5D8A9099UL,0x594B8D2EUL,0x5408ABF7UL,0x50C9B640UL,
    0x4E8EE645UL,0x4A4FFBF2UL,0x470CDD2BUL,0x43CDC09CUL,
    0x7B827D21UL,0x7F436096UL,0x7200464FUL,0x76C15BF8UL,
    0x68860BFDUL,0x6C47164AUL,0x61043093UL,0x65C52D24UL,
    0x119B4BE9UL,0x155A565EUL,0x18197087UL,0x1CD86D30UL,
    0x029F3D35UL,0x065E2082UL,0x0B1D065BUL,0x0FDC1BECUL,
    0x3793A651UL,0x3352BBE6UL,0x3E119D3FUL,0x3AD08088UL,
    0x2497D08DUL,0x2056CD3AUL,0x2D15EBE3UL,0x29D4F654UL,
    0xC5A92679UL,0xC1683BCEUL,0xCC2B1D17UL,0xC8EA00A0UL,
    0xD6AD50A5UL,0xD26C4D12UL,0xDF2F6BCBUL,0xDBEE767CUL,
    0xE3A1CBC1UL,0xE760D676UL,0xEA23F0AFUL,0xEEE2ED18UL,
    0xF0A5BD1DUL,0xF464A0AAUL,0xF9278673UL,0xFDE69BC4UL,
    0x89B8FD09UL,0x8D79E0BEUL,0x803AC667UL,0x84FBDBD0UL,
    0x9ABC8BD5UL,0x9E7D9662UL,0x933EB0BBUL,0x97FFAD0CUL,
    0xAFB010B1UL,0xAB710D06UL,0xA6322BDFUL,0xA2F33668UL,
    0xBCB4666DUL,0xB8757BDAUL,0xB5365D03UL,0xB1F740B4UL,
    };

	uint32_t crc = 0xffffffff;
	
	size_t len = length;
    while (len > 0)
    {
      crc = table[*data ^ ((crc >> 24) & 0xff)] ^ (crc << 8);
      data++;
      len--;
    }
    return crc ^ 0xffffffff;
}

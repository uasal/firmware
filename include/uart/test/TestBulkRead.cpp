/// Test for Process() correctness and performance.
/// Uses linux_pinout_uart over a PTY (pseudo-terminal) loopback so that
/// read() exercises the real OS read() path without needing hardware.

#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <pty.h>

#include "uart/BinaryUart.hpp"
#include "cgraph/CGraphPacket.hpp"
#include "uart/linux_pinout_uart.hpp"

// ---- Minimal command table (CGraphPayloadTypeVersion only) ----

int8_t BinaryVersionCommand(const uint32_t Name, char const* Buffer, const size_t BufferLen, const void* Argument)
{
	(void)Name; (void)Buffer; (void)BufferLen; (void)Argument;
	return 0;
}

extern const BinaryCmd BinaryCmds[];
extern const uint8_t   NumBinaryCmds;

const BinaryCmd BinaryCmds[] =
{
	BinaryCmd(CGraphPayloadTypeVersion, "BinaryVersionCommand", BinaryVersionCommand),
};
const uint8_t NumBinaryCmds = sizeof(BinaryCmds) / sizeof(BinaryCmds[0]);

// ---- Callbacks that count packets ----

static int g_validPackets   = 0;
static int g_invalidPackets = 0;

struct TestCallbacks : public BinaryUartCallbacks
{
	TestCallbacks() { }
	virtual ~TestCallbacks() { }

	virtual void InvalidPacket(const uint8_t* Buffer, const size_t& BufferLen)
	{
		(void)Buffer;
		(void)BufferLen;
		g_invalidPackets++;
	}

	virtual void UnHandledPacket(const IPacket* Packet, const size_t& PacketLen)
	{
		(void)Packet;
		(void)PacketLen;
	}

	virtual void BufferOverflow(const uint8_t* Buffer, const size_t& BufferLen)
	{
		(void)Buffer;
		(void)BufferLen;
		printf("  BufferOverflow!\n");
	}

	virtual void EveryPacket(const IPacket* Packet, const size_t& PacketLen)
	{
		(void)Packet;
		(void)PacketLen;
		g_validPackets++;
	}
} g_callbacks;

// ---- Real UART over PTY loopback ----

static int g_ptyMaster = -1;        // Write test bytes into this end
static char g_ptySlaveName[256];     // Device path for the slave end (e.g. /dev/pts/3)

linux_pinout_uart g_uart;            // Opens the slave end as a real serial port
CGraphPacket g_protocol;

BinaryUart g_parser(g_uart, g_protocol, BinaryCmds, NumBinaryCmds, g_callbacks, false);

/// Create a PTY pair and open the slave side via linux_pinout_uart::init().
static bool setupPtyLoopback()
{
	int slave_fd = -1;
	if (openpty(&g_ptyMaster, &slave_fd, g_ptySlaveName, NULL, NULL) < 0) {
		perror("openpty");
		return false;
	}
	// We don't need the slave fd directly since linux_pinout_uart will open it by path.
	close(slave_fd);

	printf("  PTY loopback: master fd=%d, slave=%s\n", g_ptyMaster, g_ptySlaveName);

	// Choose default baud rate of 115200 for the test, but it doesn't matter since it's PTY.
	int err = g_uart.init(115200, g_ptySlaveName, IUart::NoRTSCTS, IUart::NoParity);
	if (err != IUart::IUartOK) {
		printf("  linux_pinout_uart::init() failed: %d\n", err);
		return false;
	}
	return true;
}

static void teardownPtyLoopback()
{
	g_uart.deinit();
	if (g_ptyMaster >= 0) { close(g_ptyMaster); g_ptyMaster = -1; }
}

// ---- Test packets ----
static const uint8_t TestPacketEasy1[]          = { 0xBE,0xBA,0xAD,0x1B, 0x04,0x00, 0x00,0x00, 0xC2,0xA3,0x53,0xFC, 0xED,0xAD,0x0F,0x0A };
static const uint8_t TestPacketEasy2[]          = { 0xBE,0xBA,0xAD,0x1B, 0x01,0x00, 0x00,0x00, 0x70,0x75,0xCB,0x5C, 0xED,0xAD,0x0F,0x0A };
static const uint8_t TestPacketWithPayload[]    = { 0xBE,0xBA,0xAD,0x1B, 0x02,0x00, 0x0C,0x00, 0x01,0x00,0x00,0x00, 0x02,0x00,0x00,0x00, 0x03,0x00,0x00,0x00, 0x51,0xE6,0xD6,0x8F, 0xED,0xAD,0x0F,0x0A };
static const uint8_t TestPacketGarbageBefore[]  = { 0xAF,0x45,0x11,0x0A, 0xBE,0xBA,0xAD,0x1B, 0x01,0x00, 0x00,0x00, 0x70,0x75,0xCB,0x5C, 0xED,0xAD,0x0F,0x0A };
static const uint8_t TestPacketBackToBack[]     = { 0xBE,0xBA,0xAD,0x1B, 0x01,0x00, 0x00,0x00, 0x70,0x75,0xCB,0x5C, 0xED,0xAD,0x0F,0x0A,
                                                    0xBE,0xBA,0xAD,0x1B, 0x01,0x00, 0x00,0x00, 0x70,0x75,0xCB,0x5C, 0xED,0xAD,0x0F,0x0A };

struct TestCase
{
	const uint8_t*  data;
	size_t          len;
	const char*     name;
	int             expectedPackets;
};

static const TestCase g_tests[] =
{
	{ TestPacketEasy1,         sizeof(TestPacketEasy1),         "Simple packet 1",        1 },
	{ TestPacketEasy2,         sizeof(TestPacketEasy2),         "Simple packet 2 (Version)", 1 },
	{ TestPacketWithPayload,   sizeof(TestPacketWithPayload),   "Packet with 12B payload", 1 },
	{ TestPacketGarbageBefore, sizeof(TestPacketGarbageBefore), "Garbage before packet",   1 },
	{ TestPacketBackToBack,    sizeof(TestPacketBackToBack),    "Back-to-back packets",    2 },
};
static const size_t g_numTests = sizeof(g_tests) / sizeof(g_tests[0]);

// ---- Helpers ----

/// Write bytes into the master side of the PTY — they arrive on the
/// slave side (the linux_pinout_uart) as if they came over Serial.
static void injectBytes(const uint8_t* data, size_t len)
{
	ssize_t written = write(g_ptyMaster, data, len);
	if (written < 0) perror("injectBytes write");
	// Give the kernel a moment to shuttle bytes through the PTY
	usleep(2000);
}

static void resetParser()
{
	g_uart.purgeinput();
	g_parser.Init(BinaryUart::InvalidSerialNumber);
	g_validPackets   = 0;
	g_invalidPackets = 0;
}

// ---- Correctness tests ----

static int testCorrectness()
{
	int failures = 0;

	printf("\n==== Correctness: Process() (bulk read) ====\n");
	for (size_t t = 0; t < g_numTests; t++)
	{
		resetParser();
		injectBytes(g_tests[t].data, g_tests[t].len);

		// Process reads all available bytes at once
		g_parser.Process();

		bool pass = (g_validPackets == g_tests[t].expectedPackets);
		printf("  [%s] %-30s  (got %d packets, expected %d)\n",
			pass ? "PASS" : "FAIL", g_tests[t].name, g_validPackets, g_tests[t].expectedPackets);
		if (!pass) failures++;
	}

	return failures;
}

// ---- Performance benchmark ----

static uint64_t now_ns()
{
	struct timespec ts;
	clock_gettime(CLOCK_MONOTONIC, &ts);
	return (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
}

static void benchmarkProcessMethods()
{
	const int ITERATIONS = 500;

	printf("\n==== Performance: %d iterations of back-to-back packets (PTY I/O) ====\n", ITERATIONS);

	// --- Benchmark Process() (bulk read) ---
	for (int iter = 0; iter < ITERATIONS; iter++)
		write(g_ptyMaster, TestPacketBackToBack, sizeof(TestPacketBackToBack));
	usleep(50000); // 50ms — let kernel buffer everything

	g_parser.Init(BinaryUart::InvalidSerialNumber);
	g_validPackets = 0;

	size_t totalBytes = ITERATIONS * sizeof(TestPacketBackToBack);

	uint64_t t0 = now_ns();
	for (int i = 0; i < ITERATIONS; i++)
		g_parser.Process();
	uint64_t t1 = now_ns();
	double processTime = (double)(t1 - t0) / 1e6;
	int processPackets = g_validPackets;

	printf("  Process()     : %.3f ms  (%d packets detected, %zu bytes via bulk read)\n",
		processTime, processPackets, totalBytes);
}

// ---- Main ----

int main(int argc, char* argv[])
{
	(void)argc; (void)argv;
	setvbuf(stdout, NULL, _IONBF, 0);

	printf("\nBulkReadTest: Starting...\n");

	if (!setupPtyLoopback()) {
		printf("Failed to set up PTY loopback. Exiting.\n");
		return 1;
	}

	int failures = testCorrectness();

	benchmarkProcessMethods();

	teardownPtyLoopback();

	printf("\n%s\n\n", (failures == 0) ? "All tests PASSED." : "Some tests FAILED!");

	return (failures == 0) ? 0 : 1;
}


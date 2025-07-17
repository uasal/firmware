#include "BinaryUartRingBuffer.hpp"

//Slightly ugly hack cause our CmdSystem is C, not C++, but whatever...
void TxBinaryPacket(const void* TxPktContext, const uint16_t PayloadTypeToken, const uint32_t SerialNumber, const void* PayloadData, const size_t PayloadLen)
{
	if (NULL != TxPktContext) { reinterpret_cast<const BinaryUartRingBuffer*>(TxPktContext)->TxBinaryPacket(PayloadTypeToken, SerialNumber, PayloadData, PayloadLen); }
	else { ::formatf("\n\nTxBinaryPacket: NULL PacketContext! (Should be BinaryUart*) Please recompile this binary...\n"); }
};

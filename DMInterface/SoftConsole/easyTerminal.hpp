template<uint8_t baudratediv> struct lpc210x_pinout_uart0
{
	lpc210x_pinout_uart0() {}
	int init()
	{
				// set port pins for UART0
          PINSEL0 = (PINSEL0 & ~U0_PINMASK) | U0_PINSEL;
          U0IER = 0x00;                         // disable all interrupts
          U0IIR;                                // clear interrupt ID
          U0RBR;                                // clear receive register
          U0LSR;                                // clear line status register
          // set the baudrate
          U0LCR = ULCR_DLAB_ENABLE;             // select divisor latches
          U0DLL = (uint8_t)baud;                // set for baud low byte
          U0DLM = (uint8_t)(baud >> 8);         // set for baud high byte
          // set the number of characters and other
          // user specified operating parameters
          U0LCR = (mode & ~ULCR_DLAB_ENABLE);
          U0FCR = fmode;
          #if defined(UART0_TX_INT_MODE) || defined(UART0_RX_INT_MODE)
          // initialize the interrupt vector
          VICIntSelect &= ~VIC_BIT(VIC_UART0);  // UART0 selected as IRQ
          VICIntEnable = VIC_BIT(VIC_UART0);    // UART0 interrupt enabled
          VICVectCntl0 = VIC_ENABLE | VIC_UART0;
          VICVectAddr0 = (uint32_t)uart0ISR;    // address of the ISR
#ifdef UART0_TX_INT_MODE
          // initialize the transmit data queue
          uart0_tx_extract_idx = uart0_tx_insert_idx = 0;
          uart0_tx_running = 0;
#endif
#ifdef UART0_RX_INT_MODE
          // initialize the receive data queue
          uart0_rx_extract_idx = uart0_rx_insert_idx = 0;
          // enable receiver interrupts
          U0IER = UIER_ERBFI;
#endif
#endif
          enableIRQ();
          uart0Puts("\r\nHello World!\r\n");
          return(0);
	}
  void wait_tx() { while (0 == UCSR0A.five); }
  void wait_rx() { while (0 == UCSR0A.seven); }
  void rx(uint8_t data)
  {
#ifdef UART0_RX_INT_MODE
    uint8_t ch;
    if (uart0_rx_insert_idx == uart0_rx_extract_idx) // check if character is available
      return -1;
    ch = uart0_rx_buffer[uart0_rx_extract_idx++]; // get character, bump pointer
    uart0_rx_extract_idx %= UART0_RX_BUFFER_SIZE; // limit the pointer
    return ch;
#else
    if (U0LSR & ULSR_RDR)                 // check if character is available
      return U0RBR;                       // return character
    return -1;
#endif
  }

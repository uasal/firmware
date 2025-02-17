//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Feb 17 14:17:21 2025
// Version: 2023.2 2023.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// EvalBoardSandbox
module EvalBoardSandbox(
    // Inputs
    CLK0_PAD,
    DEVRST_N,
    Rx0,
    // Outputs
    MosiA,
    MosiB,
    MosiC,
    MosiD,
    MosiE,
    MosiF,
    SckA,
    SckB,
    SckC,
    SckD,
    SckE,
    SckF,
    Tx0,
    Uart0OE,
    nCsA,
    nCsB,
    nCsC,
    nCsD,
    nCsE,
    nCsF
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input        CLK0_PAD;
input        DEVRST_N;
input        Rx0;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output       MosiA;
output       MosiB;
output       MosiC;
output       MosiD;
output       MosiE;
output       MosiF;
output       SckA;
output       SckB;
output       SckC;
output       SckD;
output       SckE;
output       SckF;
output       Tx0;
output       Uart0OE;
output [3:0] nCsA;
output [3:0] nCsB;
output [3:0] nCsC;
output [3:0] nCsD;
output [3:0] nCsE;
output [3:0] nCsF;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          AND2_0_Y;
wire          AND2_1_Y;
wire          CLK0_PAD;
wire          DEVRST_N;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDRS31to0;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PENABLES;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PSELS0;
wire   [31:0] EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATAS;
wire          EvalSandbox_MSS_0_AMBA_SLAVE_0_PWRITES;
wire          FCCC_C0_0_GL0;
wire          FCCC_C0_0_GL1;
wire          MosiA_net_0;
wire   [3:0]  nCsA_net_0;
wire          OR2_0_Y;
wire   [31:0] RegisterSpacePorts_0_DacABdSetpoint_1;
wire   [31:0] RegisterSpacePorts_0_DataOut;
wire          RegisterSpacePorts_0_ReadAck;
wire          RegisterSpacePorts_0_ReadUart0;
wire   [7:0]  RegisterSpacePorts_0_Uart0TxFifoData;
wire          RegisterSpacePorts_0_WriteAck;
wire          RegisterSpacePorts_0_WriteClkDac;
wire          RegisterSpacePorts_0_WriteUart0;
wire          Rx0;
wire          SckA_net_0;
wire   [31:0] SpiDacPorts_0_DataFromMiso;
wire          SpiDacPorts_0_XferComplete;
wire          Tx0_net_0;
wire          Uart0OE_net_0;
wire   [9:0]  UartRxFifoExtClk_0_FifoCount;
wire          UartRxFifoExtClk_0_FifoEmpty;
wire          UartRxFifoExtClk_0_FifoFull;
wire   [7:0]  UartRxFifoExtClk_0_FifoReadData;
wire   [9:0]  UartTxFifoExtClk_0_FifoCount;
wire          UartTxFifoExtClk_0_FifoEmpty;
wire          UartTxFifoExtClk_0_FifoFull;
wire          Tx0_net_1;
wire          Uart0OE_net_1;
wire          MosiA_net_1;
wire          SckA_net_1;
wire   [3:0]  nCsA_net_1;
wire   [31:0] AMBA_SLAVE_0_PADDRS_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          VCC_net;
wire   [3:0]  nCsB_const_net_0;
wire   [3:0]  nCsC_const_net_0;
wire   [3:0]  nCsD_const_net_0;
wire   [3:0]  nCsE_const_net_0;
wire   [3:0]  nCsF_const_net_0;
wire   [31:0] SerialNumber_const_net_0;
wire   [31:0] BuildNumber_const_net_0;
wire   [31:10]DbusAddr_const_net_0;
wire   [31:0] DacBBdReadback_const_net_0;
wire   [31:0] DacCBdReadback_const_net_0;
wire   [31:0] DacDBdReadback_const_net_0;
wire   [31:0] DacEBdReadback_const_net_0;
wire   [31:0] DacFBdReadback_const_net_0;
wire   [31:0] IdealTicksPerSecond_const_net_0;
wire   [31:0] ActualTicksLastSecond_const_net_0;
wire   [31:0] ClockTicksThisSecond_const_net_0;
wire   [15:0] ClkDacReadback_const_net_0;
wire          GND_net;
//--------------------------------------------------------------------
// Inverted Nets
//--------------------------------------------------------------------
wire          B_IN_POST_INV0_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign VCC_net                           = 1'b1;
assign nCsB_const_net_0                  = 4'hF;
assign nCsC_const_net_0                  = 4'hF;
assign nCsD_const_net_0                  = 4'hF;
assign nCsE_const_net_0                  = 4'hF;
assign nCsF_const_net_0                  = 4'hF;
assign SerialNumber_const_net_0          = 32'hDEADBEEF;
assign BuildNumber_const_net_0           = 32'h5A5A5A5A;
assign DbusAddr_const_net_0              = 22'h3FFFFF;
assign DacBBdReadback_const_net_0        = 32'hFFFFFFFF;
assign DacCBdReadback_const_net_0        = 32'hFFFFFFFF;
assign DacDBdReadback_const_net_0        = 32'hFFFFFFFF;
assign DacEBdReadback_const_net_0        = 32'hFFFFFFFF;
assign DacFBdReadback_const_net_0        = 32'hFFFFFFFF;
assign IdealTicksPerSecond_const_net_0   = 32'hFFFFFFFF;
assign ActualTicksLastSecond_const_net_0 = 32'hFFFFFFFF;
assign ClockTicksThisSecond_const_net_0  = 32'hFFFFFFFF;
assign ClkDacReadback_const_net_0        = 16'hFFFF;
assign GND_net                           = 1'b0;
//--------------------------------------------------------------------
// Inversions
//--------------------------------------------------------------------
assign B_IN_POST_INV0_0 = ~ EvalSandbox_MSS_0_AMBA_SLAVE_0_PWRITES;
//--------------------------------------------------------------------
// TieOff assignments
//--------------------------------------------------------------------
assign MosiB         = 1'b1;
assign SckB          = 1'b1;
assign MosiC         = 1'b1;
assign SckC          = 1'b1;
assign MosiD         = 1'b1;
assign SckD          = 1'b1;
assign MosiE         = 1'b1;
assign SckE          = 1'b1;
assign MosiF         = 1'b1;
assign SckF          = 1'b1;
assign nCsB[3:0]     = 4'hF;
assign nCsC[3:0]     = 4'hF;
assign nCsD[3:0]     = 4'hF;
assign nCsE[3:0]     = 4'hF;
assign nCsF[3:0]     = 4'hF;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign Tx0_net_1     = Tx0_net_0;
assign Tx0           = Tx0_net_1;
assign Uart0OE_net_1 = Uart0OE_net_0;
assign Uart0OE       = Uart0OE_net_1;
assign MosiA_net_1   = MosiA_net_0;
assign MosiA         = MosiA_net_1;
assign SckA_net_1    = SckA_net_0;
assign SckA          = SckA_net_1;
assign nCsA_net_1    = nCsA_net_0;
assign nCsA[3:0]     = nCsA_net_1;
//--------------------------------------------------------------------
// Slices assignments
//--------------------------------------------------------------------
assign EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDRS31to0 = AMBA_SLAVE_0_PADDRS_net_0[31:0];
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------AND2
AND2 AND2_0(
        // Inputs
        .A ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PSELS0 ),
        .B ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWRITES ),
        // Outputs
        .Y ( AND2_0_Y ) 
        );

//--------AND2
AND2 AND2_1(
        // Inputs
        .A ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PSELS0 ),
        .B ( B_IN_POST_INV0_0 ),
        // Outputs
        .Y ( AND2_1_Y ) 
        );

//--------EvalSandbox_MSS
EvalSandbox_MSS EvalSandbox_MSS_0(
        // Inputs
        .FAB_RESET_N            ( VCC_net ), // tied to 1'b1 from definition
        .AMBA_SLAVE_0_PREADYS0  ( OR2_0_Y ),
        .AMBA_SLAVE_0_PSLVERRS0 ( GND_net ), // tied to 1'b0 from definition
        .DEVRST_N               ( DEVRST_N ),
        .CLK0                   ( FCCC_C0_0_GL0 ),
        .AMBA_SLAVE_0_PRDATAS0  ( RegisterSpacePorts_0_DataOut ),
        // Outputs
        .POWER_ON_RESET_N       (  ),
        .INIT_DONE              (  ),
        .AMBA_SLAVE_0_PSELS0    ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PSELS0 ),
        .AMBA_SLAVE_0_PENABLES  ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PENABLES ),
        .AMBA_SLAVE_0_PWRITES   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWRITES ),
        .FIC_0_CLK              (  ),
        .FIC_0_LOCK             (  ),
        .MSS_READY              (  ),
        .AMBA_SLAVE_0_PADDRS    ( AMBA_SLAVE_0_PADDRS_net_0 ),
        .AMBA_SLAVE_0_PWDATAS   ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATAS ) 
        );

//--------FCCC_C0
FCCC_C0 FCCC_C0_0(
        // Inputs
        .CLK0_PAD ( CLK0_PAD ),
        // Outputs
        .GL0      ( FCCC_C0_0_GL0 ),
        .GL1      ( FCCC_C0_0_GL1 ),
        .LOCK     (  ) 
        );

//--------OR2
OR2 OR2_0(
        // Inputs
        .A ( RegisterSpacePorts_0_ReadAck ),
        .B ( RegisterSpacePorts_0_WriteAck ),
        // Outputs
        .Y ( OR2_0_Y ) 
        );

//--------RegisterSpacePorts
RegisterSpacePorts RegisterSpacePorts_0(
        // Inputs
        .clk                   ( FCCC_C0_0_GL1 ),
        .rst                   ( VCC_net ),
        .ReadReq               ( AND2_1_Y ),
        .WriteReq              ( AND2_0_Y ),
        .DEnable               ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PENABLES ),
        .DacTransferCompleteA  ( SpiDacPorts_0_XferComplete ),
        .DacTransferCompleteB  ( VCC_net ),
        .DacTransferCompleteC  ( VCC_net ),
        .DacTransferCompleteD  ( VCC_net ),
        .DacTransferCompleteE  ( VCC_net ),
        .DacTransferCompleteF  ( VCC_net ),
        .Uart0RxFifoFull       ( UartRxFifoExtClk_0_FifoFull ),
        .Uart0RxFifoEmpty      ( UartRxFifoExtClk_0_FifoEmpty ),
        .Uart0TxFifoFull       ( UartTxFifoExtClk_0_FifoFull ),
        .Uart0TxFifoEmpty      ( UartTxFifoExtClk_0_FifoEmpty ),
        .PPSDetected           ( VCC_net ),
        .Address               ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PADDRS31to0 ),
        .DataIn                ( EvalSandbox_MSS_0_AMBA_SLAVE_0_PWDATAS ),
        .SerialNumber          ( SerialNumber_const_net_0 ),
        .BuildNumber           ( BuildNumber_const_net_0 ),
        .DbusAddr              ( DbusAddr_const_net_0 ),
        .DacABdReadback        ( SpiDacPorts_0_DataFromMiso ),
        .DacBBdReadback        ( DacBBdReadback_const_net_0 ),
        .DacCBdReadback        ( DacCBdReadback_const_net_0 ),
        .DacDBdReadback        ( DacDBdReadback_const_net_0 ),
        .DacEBdReadback        ( DacEBdReadback_const_net_0 ),
        .DacFBdReadback        ( DacFBdReadback_const_net_0 ),
        .Uart0RxFifoData       ( UartRxFifoExtClk_0_FifoReadData ),
        .Uart0RxFifoCount      ( UartRxFifoExtClk_0_FifoCount ),
        .Uart0TxFifoCount      ( UartTxFifoExtClk_0_FifoCount ),
        .IdealTicksPerSecond   ( IdealTicksPerSecond_const_net_0 ),
        .ActualTicksLastSecond ( ActualTicksLastSecond_const_net_0 ),
        .ClockTicksThisSecond  ( ClockTicksThisSecond_const_net_0 ),
        .ClkDacReadback        ( ClkDacReadback_const_net_0 ),
        // Outputs
        .ReadAck               ( RegisterSpacePorts_0_ReadAck ),
        .WriteAck              ( RegisterSpacePorts_0_WriteAck ),
        .PowernEnHV            (  ),
        .PowernEn              (  ),
        .Uart0OE               ( Uart0OE_net_0 ),
        .Ux1SelJmp             (  ),
        .WriteDacs             (  ),
        .Uart0FifoReset        (  ),
        .ReadUart0             ( RegisterSpacePorts_0_ReadUart0 ),
        .WriteUart0            ( RegisterSpacePorts_0_WriteUart0 ),
        .PPSCountReset         (  ),
        .WriteClkDac           ( RegisterSpacePorts_0_WriteClkDac ),
        .DataOut               ( RegisterSpacePorts_0_DataOut ),
        .DacABdSetpoint        ( RegisterSpacePorts_0_DacABdSetpoint_1 ),
        .DacBBdSetpoint        (  ),
        .DacCBdSetpoint        (  ),
        .DacDBdSetpoint        (  ),
        .DacEBdSetpoint        (  ),
        .DacFBdSetpoint        (  ),
        .Uart0TxFifoData       ( RegisterSpacePorts_0_Uart0TxFifoData ),
        .Uart0ClkDivider       (  ),
        .ClkDacWrite           (  ) 
        );

//--------SpiDacPorts
SpiDacPorts SpiDacPorts_0(
        // Inputs
        .clk          ( FCCC_C0_0_GL1 ),
        .rst          ( VCC_net ),
        .Miso         ( MosiA_net_0 ),
        .WriteDac     ( RegisterSpacePorts_0_WriteClkDac ),
        .DataToMosi   ( RegisterSpacePorts_0_DacABdSetpoint_1 ),
        // Outputs
        .Sck          ( SckA_net_0 ),
        .Mosi         ( MosiA_net_0 ),
        .XferComplete ( SpiDacPorts_0_XferComplete ),
        .nCs          ( nCsA_net_0 ),
        .DataFromMiso ( SpiDacPorts_0_DataFromMiso ) 
        );

//--------UartRxFifoExtClk
UartRxFifoExtClk UartRxFifoExtClk_0(
        // Inputs
        .clk          ( FCCC_C0_0_GL1 ),
        .uclk         ( VCC_net ),
        .rst          ( VCC_net ),
        .Rxd          ( Rx0 ),
        .ReadFifo     ( RegisterSpacePorts_0_ReadUart0 ),
        // Outputs
        .Dbg1         (  ),
        .RxComplete   (  ),
        .FifoReadAck  (  ),
        .FifoFull     ( UartRxFifoExtClk_0_FifoFull ),
        .FifoEmpty    ( UartRxFifoExtClk_0_FifoEmpty ),
        .FifoReadData ( UartRxFifoExtClk_0_FifoReadData ),
        .FifoCount    ( UartRxFifoExtClk_0_FifoCount ) 
        );

//--------UartTxFifoExtClk
UartTxFifoExtClk UartTxFifoExtClk_0(
        // Inputs
        .clk          ( FCCC_C0_0_GL1 ),
        .uclk         ( VCC_net ),
        .rst          ( VCC_net ),
        .WriteStrobe  ( RegisterSpacePorts_0_WriteUart0 ),
        .Cts          ( GND_net ),
        .WriteData    ( RegisterSpacePorts_0_Uart0TxFifoData ),
        // Outputs
        .FifoFull     ( UartTxFifoExtClk_0_FifoFull ),
        .FifoEmpty    ( UartTxFifoExtClk_0_FifoEmpty ),
        .BitClockOut  (  ),
        .TxInProgress (  ),
        .Txd          ( Tx0_net_0 ),
        .FifoCount    ( UartTxFifoExtClk_0_FifoCount ),
        .BitCountOut  (  ) 
        );


endmodule

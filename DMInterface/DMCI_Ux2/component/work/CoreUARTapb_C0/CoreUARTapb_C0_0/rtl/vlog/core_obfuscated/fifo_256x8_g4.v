// Actel Corporation Proprietary and Confidential
//  Copyright 2008 Actel Corporation.  All rights reserved.
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//  Revision Information:
// Jun09    Revision 4.1
// Aug10    Revision 4.2
// SVN Revision Information:
// SVN $Revision: 8508 $
// SVN $Date: 2009-06-15 16:49:49 -0700 (Mon, 15 Jun 2009) $
`timescale 1ns/100ps
module
CoreUARTapb_C0_CoreUARTapb_C0_0_fifo_256x8
(
CUARTOOOI
,
CUARTIOOI
,
CUARTlOOI
,
CUARTOIOI
,
WRB
,
RDB
,
RESET
,
FULL
,
EMPTY
)
;
output
[
7
:
0
]
CUARTOOOI
;
input
CUARTIOOI
;
input
CUARTlOOI
;
input
[
7
:
0
]
CUARTOIOI
;
input
WRB
;
input
RDB
;
input
RESET
;
output
FULL
;
output
EMPTY
;
parameter
SYNC_RESET
=
0
;
parameter
[
6
:
0
]
CUARTOIlI
=
64
;
wire
[
7
:
0
]
CUARTOOOI
;
wire
AEMPTY
,
AFULL
,
FULL
,
EMPTY
;
CoreUARTapb_C0_CoreUARTapb_C0_0_fifo_ctrl_128
#
(
.SYNC_RESET
(
SYNC_RESET
)
)
CUARTO0Ol
(
.CUARTlOII
(
CUARTOIOI
)
,
.CUARTOIII
(
CUARTOOOI
)
,
.CUARTlIlI
(
WRB
)
,
.CUARTOllI
(
RDB
)
,
.CUARTIllI
(
CUARTlOOI
)
,
.CUARTlllI
(
FULL
)
,
.CUARTO0lI
(
EMPTY
)
,
.CUARTI0lI
(
GEQTH
)
,
.CUARTlI
(
RESET
)
,
.CUARTOIlI
(
CUARTOIlI
)
)
;
endmodule
module
CoreUARTapb_C0_CoreUARTapb_C0_0_fifo_ctrl_128
(
CUARTIllI
,
CUARTlI
,
CUARTlOII
,
CUARTOllI
,
CUARTlIlI
,
CUARTOIlI
,
CUARTOIII
,
CUARTlllI
,
CUARTO0lI
,
CUARTI0lI
)
;
parameter
SYNC_RESET
=
0
;
parameter
CUARTl0lI
=
128
;
parameter
CUARTO1lI
=
7
;
parameter
CUARTI1lI
=
8
;
input
CUARTIllI
;
input
CUARTlI
;
input
[
CUARTI1lI
-
1
:
0
]
CUARTlOII
;
input
CUARTOllI
;
input
CUARTlIlI
;
input
[
6
:
0
]
CUARTOIlI
;
output
[
CUARTI1lI
-
1
:
0
]
CUARTOIII
;
output
CUARTlllI
;
output
CUARTO0lI
;
output
CUARTI0lI
;
wire
CUARTIllI
;
wire
CUARTlI
;
wire
[
CUARTI1lI
-
1
:
0
]
CUARTlOII
;
wire
CUARTOllI
;
wire
CUARTlIlI
;
reg
[
CUARTI1lI
-
1
:
0
]
CUARTOIII
;
wire
CUARTlllI
;
wire
CUARTO0lI
;
wire
CUARTI0lI
;
wire
[
CUARTI1lI
-
1
:
0
]
CUARTl1lI
;
reg
CUARTOO0I
;
reg
[
CUARTO1lI
-
1
:
0
]
CUARTIO0I
;
reg
[
CUARTO1lI
-
1
:
0
]
CUARTlO0I
;
reg
[
CUARTO1lI
-
1
:
0
]
CUARTOI0I
;
wire
CUARTI1
;
wire
CUARTl1
;
assign
CUARTI1
=
(
SYNC_RESET
==
1
)
?
1
'b
1
:
CUARTlI
;
assign
CUARTl1
=
(
SYNC_RESET
==
1
)
?
CUARTlI
:
1
'b
1
;
assign
CUARTlllI
=
(
CUARTIO0I
==
CUARTl0lI
-
1
)
?
1
'b
1
:
1
'b
0
;
assign
CUARTO0lI
=
(
CUARTIO0I
==
0
)
?
1
'b
1
:
1
'b
0
;
assign
CUARTI0lI
=
(
CUARTIO0I
>=
CUARTOIlI
)
?
1
'b
1
:
1
'b
0
;
always
@
(
posedge
CUARTIllI
or
negedge
CUARTI1
)
begin
if
(
(
!
CUARTI1
)
||
(
!
CUARTl1
)
)
begin
CUARTlO0I
<=
{
CUARTO1lI
{
1
'b
0
}
}
;
CUARTOI0I
<=
{
CUARTO1lI
{
1
'b
0
}
}
;
CUARTIO0I
<=
{
CUARTO1lI
{
1
'b
0
}
}
;
end
else
begin
if
(
~
CUARTOllI
)
begin
if
(
CUARTlIlI
)
begin
CUARTIO0I
<=
CUARTIO0I
-
1
;
end
if
(
CUARTlO0I
==
CUARTl0lI
-
1
)
CUARTlO0I
<=
{
CUARTO1lI
{
1
'b
0
}
}
;
else
CUARTlO0I
<=
CUARTlO0I
+
1
;
end
if
(
~
CUARTlIlI
)
begin
if
(
CUARTIO0I
>=
CUARTl0lI
)
begin
$display
(
"\nERROR at time %0t:"
,
$time
)
;
$display
(
"FIFO Overflow\n"
)
;
$stop
;
end
if
(
CUARTOllI
)
begin
CUARTIO0I
<=
CUARTIO0I
+
1
;
end
if
(
CUARTOI0I
==
CUARTl0lI
-
1
)
CUARTOI0I
<=
{
CUARTO1lI
{
1
'b
0
}
}
;
else
CUARTOI0I
<=
CUARTOI0I
+
1
;
end
end
end
always
@
(
posedge
CUARTIllI
or
negedge
CUARTI1
)
begin
if
(
(
!
CUARTI1
)
||
(
!
CUARTl1
)
)
begin
CUARTOO0I
<=
1
'b
0
;
CUARTOIII
<=
1
'b
0
;
end
else
begin
CUARTOO0I
<=
CUARTOllI
;
if
(
CUARTOO0I
==
1
'b
0
)
begin
CUARTOIII
<=
CUARTl1lI
;
end
else
begin
CUARTOIII
<=
CUARTOIII
;
end
end
end
CoreUARTapb_C0_CoreUARTapb_C0_0_ram128x8_pa4
CUARTI0Ol
(
.CUARTII1I
(
CUARTlOII
)
,
.CUARTlI1I
(
CUARTl1lI
)
,
.CUARTOl1I
(
CUARTOI0I
)
,
.CUARTIl1I
(
CUARTlO0I
)
,
.CUARTll1I
(
CUARTlIlI
)
,
.CUARTI01I
(
CUARTIllI
)
,
.CUARTl01I
(
CUARTIllI
)
,
.CUARTlI
(
CUARTlI
)
)
;
endmodule
module
CoreUARTapb_C0_CoreUARTapb_C0_0_ram128x8_pa4
(
CUARTII1I
,
CUARTlI1I
,
CUARTOl1I
,
CUARTIl1I
,
CUARTll1I
,
CUARTI01I
,
CUARTl01I
,
CUARTlI
)
;
input
[
7
:
0
]
CUARTII1I
;
input
[
6
:
0
]
CUARTOl1I
,
CUARTIl1I
;
input
CUARTll1I
,
CUARTI01I
,
CUARTl01I
,
CUARTlI
;
output
[
7
:
0
]
CUARTlI1I
;
wire
[
17
:
0
]
CUARTl0Ol
;
wire
CUARTI11I
,
VCC
,
GND
;
VCC
CUARTl11I
(
.Y
(
VCC
)
)
;
GND
CUARTOOOl
(
.Y
(
GND
)
)
;
INV
CUARTIOOl
(
.A
(
CUARTll1I
)
,
.Y
(
CUARTI11I
)
)
;
assign
CUARTlI1I
=
CUARTl0Ol
[
7
:
0
]
;
RAM64x18
CUARTO1Ol
(
.A_DOUT
(
CUARTl0Ol
)
,
.B_DOUT
(
)
,
.BUSY
(
)
,
.A_ADDR_CLK
(
CUARTl01I
)
,
.A_DOUT_CLK
(
VCC
)
,
.A_ADDR_SRST_N
(
VCC
)
,
.A_DOUT_SRST_N
(
VCC
)
,
.A_ADDR_ARST_N
(
VCC
)
,
.A_DOUT_ARST_N
(
VCC
)
,
.A_ADDR_EN
(
VCC
)
,
.A_DOUT_EN
(
VCC
)
,
.A_BLK
(
{
2
'b
11
}
)
,
.A_ADDR
(
{
CUARTIl1I
[
6
:
0
]
,
3
'b
0
}
)
,
.B_ADDR_CLK
(
VCC
)
,
.B_DOUT_CLK
(
VCC
)
,
.B_ADDR_SRST_N
(
VCC
)
,
.B_DOUT_SRST_N
(
VCC
)
,
.B_ADDR_ARST_N
(
VCC
)
,
.B_DOUT_ARST_N
(
VCC
)
,
.B_ADDR_EN
(
VCC
)
,
.B_DOUT_EN
(
VCC
)
,
.B_BLK
(
{
2
'b
0
}
)
,
.B_ADDR
(
{
10
'b
0
}
)
,
.C_CLK
(
CUARTI01I
)
,
.C_ADDR
(
{
CUARTOl1I
[
6
:
0
]
,
3
'b
0
}
)
,
.C_DIN
(
{
10
'b
0
,
CUARTII1I
[
7
:
0
]
}
)
,
.C_WEN
(
CUARTI11I
)
,
.C_BLK
(
{
2
'b
11
}
)
,
.A_EN
(
VCC
)
,
.A_ADDR_LAT
(
GND
)
,
.A_DOUT_LAT
(
VCC
)
,
.B_EN
(
GND
)
,
.B_ADDR_LAT
(
GND
)
,
.B_DOUT_LAT
(
VCC
)
,
.C_EN
(
VCC
)
,
.A_WIDTH
(
{
3
'b
011
}
)
,
.B_WIDTH
(
{
3
'b
011
}
)
,
.C_WIDTH
(
{
3
'b
011
}
)
,
.SII_LOCK
(
GND
)
)
;
endmodule

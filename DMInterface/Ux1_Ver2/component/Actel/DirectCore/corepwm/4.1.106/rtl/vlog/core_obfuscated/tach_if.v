/******************************************************************************

    File Name:  tach_if.v
      Version:  4.0
         Date:  Jul 24th, 2009
  Description:  Tachometer Interface
  
  
  SVN Revision Information:
  SVN $Revision: 9212 $
  SVN $Date: 2009-07-24 15:32:50 -0700 (Fri, 24 Jul 2009) $  
  
  

 COPYRIGHT 2009 BY ACTEL 
 THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
 FROM ACTEL CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
 ACTEL FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
 NO BACK-UP OF THE FILE SHOULD BE MADE. 
 
FUNCTIONAL DESCRIPTION: 
Refer to the CorePWM Handbook.
******************************************************************************/
`timescale 1ns/1ns
module
tach_if
#
(
parameter
TACH_NUM
=
1
)
(
input
PCLK,
input
PRESETN,
input
TACHIN,
input
TACHMODE,
input
TACH_EDGE,
input
TACHSTATUS,
input
status_clear,
input
tach_cnt_clk,
output
[
15
:
0
]
TACHPULSEDUR,
output
update_status
)
;
parameter
cnt0
=
0
;
parameter
cnt1
=
1
;
reg
[
15
:
0
]
CPWMlIII
;
reg
[
15
:
0
]
CPWMOlII
;
reg
CPWMIlII
;
reg
CPWMllII
;
reg
[
15
:
0
]
CPWMO0II
;
reg
[
15
:
0
]
CPWMI0II
;
reg
CPWMl0II
;
reg
CPWMO1II
;
reg
CPWMI1II
;
reg
CPWMl1II
;
reg
CPWMOOlI
;
reg
CPWMIOlI
;
reg
CPWMlOlI
;
reg
[
15
:
0
]
CPWMOIlI
;
reg
CPWMIIlI
;
always
@
(
negedge
PRESETN
or
posedge
PCLK
)
begin
if
(
!
PRESETN
)
begin
CPWMOIlI
<=
0
;
end
else
begin
CPWMOIlI
<=
CPWMO0II
;
end
end
assign
TACHPULSEDUR
=
CPWMOIlI
;
assign
update_status
=
CPWMIIlI
;
always
@
(
negedge
PRESETN
or
posedge
PCLK
)
begin
if
(
!
PRESETN
)
begin
CPWMlIII
<=
0
;
CPWMO0II
<=
0
;
CPWMOOlI
<=
0
;
CPWMIOlI
<=
0
;
CPWMlOlI
<=
0
;
CPWMl1II
<=
0
;
CPWMIlII
<=
0
;
CPWMIIlI
<=
1
'b
0
;
CPWMO1II
<=
1
'b
0
;
end
else
begin
if
(
tach_cnt_clk
==
1
'b
1
)
begin
CPWMO1II
<=
CPWMI1II
;
CPWMOOlI
<=
TACHIN
;
CPWMIOlI
<=
CPWMOOlI
;
CPWMlOlI
<=
CPWMIOlI
;
CPWMO0II
<=
CPWMI0II
;
CPWMIIlI
<=
CPWMl0II
;
CPWMlIII
<=
CPWMOlII
;
if
(
CPWMllII
==
1
'b
1
)
begin
CPWMIlII
<=
1
'b
1
;
end
else
if
(
CPWMl1II
==
1
'b
1
)
begin
CPWMIlII
<=
1
'b
0
;
end
if
(
(
TACHSTATUS
==
1
'b
0
)
&&
(
TACH_EDGE
==
1
'b
1
)
)
begin
CPWMl1II
<=
(
(
CPWMIOlI
)
&&
(
!
CPWMlOlI
)
)
;
end
else
begin
CPWMl1II
<=
(
(
!
CPWMIOlI
)
&&
(
CPWMlOlI
)
)
;
end
end
end
end
always
@(*)
begin
CPWMI0II
=
CPWMO0II
;
CPWMOlII
=
0
;
CPWMl0II
=
1
'b
0
;
CPWMI1II
=
CPWMO1II
;
CPWMllII
=
0
;
case
(
CPWMO1II
)
cnt0
:
begin
CPWMI1II
=
cnt0
;
CPWMllII
=
0
;
if
(
CPWMl1II
==
1
'b
1
)
begin
CPWMOlII
=
0
;
CPWMI1II
=
cnt1
;
end
end
cnt1
:
begin
CPWMI0II
=
CPWMO0II
;
CPWMl0II
=
1
'b
0
;
CPWMllII
=
0
;
if
(
CPWMl1II
==
1
'b
1
)
begin
CPWMOlII
=
0
;
CPWMllII
=
0
;
if
(
(
CPWMIlII
==
1
)
&&
(
status_clear
==
1
'b
1
)
)
begin
CPWMI0II
=
0
;
end
else
begin
if
(
(
TACHMODE
==
1
'b
1
)
&&
(
status_clear
==
1
'b
1
)
)
begin
CPWMI0II
=
CPWMlIII
+
1
;
end
else
if
(
TACHMODE
==
1
'b
0
)
begin
if
(
CPWMIlII
==
1
)
begin
CPWMI0II
=
0
;
end
else
begin
CPWMI0II
=
CPWMlIII
+
1
;
end
end
if
(
status_clear
==
1
'b
1
)
begin
CPWMl0II
=
1
'b
1
;
end
end
end
else
begin
if
(
CPWMIlII
==
0
)
begin
CPWMOlII
=
CPWMlIII
+
1
;
if
(
CPWMlIII
==
65535
)
begin
CPWMllII
=
1
;
end
end
end
end
endcase
end
endmodule

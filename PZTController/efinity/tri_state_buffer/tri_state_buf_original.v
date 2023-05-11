/////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2013-2018 Efinix Inc. All rights reserved.
//
// Tri-State Buffer Templete - Traditional Method
// Note: This will not work on Efinity. Just for user references only.
//
// *******************************
// Revisions:
// 0.0 Initial rev
// *******************************

module tri_state_buf_original (a);

inout a;

wire b;
wire oe;

assign a= (oe ? b : 1'bZ);

endmodule

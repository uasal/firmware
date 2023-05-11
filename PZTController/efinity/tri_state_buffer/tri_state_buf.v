/////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2013-2018 Efinix Inc. All rights reserved.
//
// Tri-State Buffer Templete
// Info: This is a example guildline for user to infer a tri-state buffer in Efinity 
// software. 
//
// *******************************
// Revisions:
// 0.0 Initial rev
// *******************************

module tri_state_buf (a_in, a_out, a_ena, internal_tri_state_buf_in, internal_tri_state_buf_out,internal_tri_state_buf_ena);

// Split the initial inout port a to three wrapper ports of tri state buffer.
input a_in;
output a_out;
output a_ena;

// Act as the internal tri state buffer signals. 
output internal_tri_state_buf_out;
input internal_tri_state_buf_in;
input internal_tri_state_buf_ena;

//Modification from traditional way of inferring.
assign internal_tri_state_buf_out = a_in;
assign a_out = internal_tri_state_buf_in;
assign a_ena = internal_tri_state_buf_ena; 

endmodule

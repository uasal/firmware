onerror {resume}
virtual type { AXI_IDLE AXI_RADR AXI_WADR AXI_RTRN AXI_WTRN AXI_WRSP AXI_WREQ AXI_RREQ AXI_RSDR AXI_WSDR} axiStates
quietly virtual function -install /coresdr_axi_tb/DUT_0 -env /coresdr_axi_tb { (axiStates)(/coresdr_axi_tb/DUT_0/axi_state)} myAxiState
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Top Level}
add wave -noupdate -group AXI
add wave -noupdate -group AXI -format Logic /coresdr_axi_tb/DUT_0/ACLK
add wave -noupdate -group AXI -format Literal /coresdr_axi_tb/DUT_0/ARADDR
add wave -noupdate -group AXI -format Literal /coresdr_axi_tb/DUT_0/ARBURST
add wave -noupdate -group AXI -format Logic /coresdr_axi_tb/DUT_0/ARESETN
add wave -noupdate -group AXI -format Literal /coresdr_axi_tb/DUT_0/ARID
add wave -noupdate -group AXI -format Literal /coresdr_axi_tb/DUT_0/ARLEN
add wave -noupdate -group AXI -format Literal /coresdr_axi_tb/DUT_0/ARLOCK
add wave -noupdate -group AXI -format Logic /coresdr_axi_tb/DUT_0/ARREADY
add wave -noupdate -group AXI -format Literal /coresdr_axi_tb/DUT_0/ARSIZE
add wave -noupdate -group AXI -format Logic /coresdr_axi_tb/DUT_0/ARVALID
add wave -noupdate -group AXI -format Literal /coresdr_axi_tb/DUT_0/AWADDR
add wave -noupdate -group AXI -format Literal /coresdr_axi_tb/DUT_0/AWBURST
add wave -noupdate -group AXI -format Literal /coresdr_axi_tb/DUT_0/AWID
add wave -noupdate -group AXI -format Literal /coresdr_axi_tb/DUT_0/AWLEN
add wave -noupdate -group AXI -format Literal /coresdr_axi_tb/DUT_0/AWLOCK
add wave -noupdate -group AXI -format Logic /coresdr_axi_tb/DUT_0/AWREADY
add wave -noupdate -group AXI -format Literal /coresdr_axi_tb/DUT_0/AWSIZE
add wave -noupdate -group AXI -format Logic /coresdr_axi_tb/DUT_0/AWVALID
add wave -noupdate -group SDR
add wave -noupdate -group SDR -format Literal /coresdr_axi_tb/DUT_0/BA
add wave -noupdate -group SDR -format Logic /coresdr_axi_tb/DUT_0/CAS_N
add wave -noupdate -group SDR -format Logic /coresdr_axi_tb/DUT_0/CKE
add wave -noupdate -group SDR -format Literal /coresdr_axi_tb/DUT_0/CS_N
add wave -noupdate -group SDR -format Literal /coresdr_axi_tb/DUT_0/DQ
add wave -noupdate -group SDR -format Literal /coresdr_axi_tb/DUT_0/DQM
add wave -noupdate -group SDR -format Logic /coresdr_axi_tb/DUT_0/OE
add wave -noupdate -group SDR -format Logic /coresdr_axi_tb/DUT_0/RAS_N
add wave -noupdate -group SDR -format Literal /coresdr_axi_tb/DUT_0/SA
add wave -noupdate -group SDR -format Logic /coresdr_axi_tb/DUT_0/SDRCLK
add wave -noupdate -group SDR -format Logic /coresdr_axi_tb/DUT_0/WE_N
add wave -noupdate -divider {SDRAM Modules}
add wave -noupdate -expand -group mem0
add wave -noupdate -group mem0 -format Literal -radix hexadecimal /coresdr_axi_tb/genblk1/mem000/Dq
add wave -noupdate -group mem0 -format Literal /coresdr_axi_tb/genblk1/mem000/Addr
add wave -noupdate -group mem0 -format Literal /coresdr_axi_tb/genblk1/mem000/Ba
add wave -noupdate -group mem0 -format Logic /coresdr_axi_tb/genblk1/mem000/Clk
add wave -noupdate -group mem0 -format Logic /coresdr_axi_tb/genblk1/mem000/Cke
add wave -noupdate -group mem0 -format Logic /coresdr_axi_tb/genblk1/mem000/Cs_n
add wave -noupdate -group mem0 -format Logic /coresdr_axi_tb/genblk1/mem000/Ras_n
add wave -noupdate -group mem0 -format Logic /coresdr_axi_tb/genblk1/mem000/Cas_n
add wave -noupdate -group mem0 -format Logic /coresdr_axi_tb/genblk1/mem000/We_n
add wave -noupdate -group mem0 -format Literal /coresdr_axi_tb/genblk1/mem000/Dqm
add wave -noupdate -group mem1
add wave -noupdate -group mem2
add wave -noupdate -group mem3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {326267700656 ps} 0}
configure wave -namecolwidth 449
configure wave -valuecolwidth 138
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {326201415846 ps} {326339399166 ps}

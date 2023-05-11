export EFINITY_HOME=/home/summer/Downloads/efinity/2021.2/
export EFXPT_HOME=/home/summer/Downloads/efinity/2021.2/pt/
export PYTHONPATH=$PYTHONPATH$:/home/summer/Downloads/efinity/2021.2/lib/python3.8/site-packages
export EFXPGM_HOME=/home/summer/Downloads/efinity/2021.2/pgm
#~ EFINITY_HOME:=/home/summer/Downloads/efinity/2021.2/
#~ EFXPT_HOME:=/home/summer/Downloads/efinity/2021.2/pt/

OS := $(shell uname -a)
ifeq (,$(findstring imx6,$(OS)))
	INCLUDE_LOCAL = /home/summer/projects/include
	INCLUDE_LOCAL2 = /home/summer/projects/MountainOps/software/CGraph/Sanford/apps
	CROSS_COMPILE ?= /home/summer/gcc-linaro-arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
	CC = $(CROSS_COMPILE)gcc
else
	#~ INCLUDE_LOCAL = /home/root/include
	INCLUDE_LOCAL = /media/9016-4EF8/include
endif
LIB_LOCAL = /home/summer/projects/include
vpath %.h $(INCLUDE_LOCAL) $(INCLUDE_LOCAL2)
vpath %.hpp $(INCLUDE_LOCAL) $(INCLUDE_LOCAL2)
vpath %.c $(LIB_LOCAL)
vpath %.cpp $(LIB_LOCAL)
vpath %.o $(LIB_LOCAL)
vpath %.a $(LIB_LOCAL)
EXTRAINCDIRS = . ./../../../../include/ $(INCLUDE_LOCAL) $(INCLUDE_LOCAL2)
EXTRA_LIBDIRS = . ./../lib/ $(LIB_LOCAL) # /home/summer/projects/include/libconfig/

GITVERSION:= $(shell git rev-parse HEAD)
BUILDNUM:= $(shell vhdbquery BuildNumber.vhd)

#~ %.o: %.cpp
	#~ $(CC) $(CFLAGS) -I. -c $< -o $@

#~ %.o: %.c
	#~ $(CC) $(CFLAGS) -I. -c $< -o $@
	
PZT: 
	vhdbtracer BuildNumber.vhd
	/home/summer/Downloads/efinity/2021.2/bin/efx_map --project "CGraphPZT" --root "CGraphPZTPorts" --arch "CGraphPZT" --write-efx-verilog "outflow/CGraphPZT.map.v" --write-premap-module "outflow/CGraphPZT.elab.vdb" --binary-db "CGraphPZT.vdb" --device "T20Q144" --family "Trion" --mode "speed" --max_ram "-1" --max_mult "-1" --infer-clk-enable "3" --infer-sync-set-reset "1" --fanout-limit "0" --bram_output_regs_packing "1" --retiming "1" --seq_opt "1" --blast_const_operand_adders "1" --operator-sharing "0" --optimize-adder-tree "0" --mult_input_regs_packing "1" --mult_output_regs_packing "1" --veri_option "verilog_mode=verilog_2k,vhdl_mode=vhdl_2008" --work-dir "work_syn" --output-dir "outflow" --project-xml "CGraphPZT.xml" --I "." --I "/home/summer/projects/include/fpga"
	/home/summer/Downloads/efinity/2021.2/bin/python3  "/home/summer/Downloads/efinity/2021.2/scripts/efx_run_pt.py"  "CGraphPZT"  "Trion"  "T20Q144"
	/home/summer/Downloads/efinity/2021.2/bin/efx_pnr --circuit "CGraphPZT" --family "Trion" --device "T20Q144" --operating_conditions "I4" --pack --place --route --vdb_file "CGraphPZT.vdb" --use_vdb_file "on" --place_file "outflow/CGraphPZT.place" --route_file "outflow/CGraphPZT.route" --sdc_file "../fpga/Main/CGraphPZT.sdc" --sync_file "outflow/CGraphPZT.interface.csv" --seed "1" --work_dir "work_pnr" --output_dir "outflow" --timing_analysis "on" --load_delay_matrix	
	/home/summer/Downloads/efinity/2021.2/bin/efx_pgm --source "work_pnr/CGraphPZT.lbf" --dest "outflow/CGraphPZT.hex" --device "T20Q144" --family "Trion" --periph "outflow/CGraphPZT.lpf" --interface_designer_settings "outflow/CGraphPZT_or.ini" --enable_external_master_clock "off" --oscillator_clock_divider "DIV8" --active_capture_clk_edge "posedge" --spi_low_power_mode "on" --io_weak_pullup "on" --enable_roms "smart" --mode "active" --width "1" --release_tri_then_reset "on"
	cp outflow/CGraphPZT.bit builds/CGraphPZT.v$(GITVERSION).b$(BUILDNUM).bit
	cp outflow/CGraphPZT.hex builds/CGraphPZT.v$(GITVERSION).b$(BUILDNUM).hex
	
all: PZT

program: PZT
	/home/summer/Downloads/efinity/2021.2/pgm/bin/efx_pgm/ftdi_program.py outflow/CGraphPZT.bit -m jtag 
	#~ efx_run.py CGraphPZT.xml --flow program --pgm_opts mode=jtag
	#~ --pgm_opts mode=jtag_bridge
	#~ --pgm_opts mode=active
	#~ -ssh root@192.168.1.223 killall PZT
	#~ -scp PZT root@192.168.1.223:/home/root
	
burn:
	#~ efx_run.py CGraphPZT.xml --flow program --pgm_opts mode=jtag jtag_spi_flash_loader.bit
	#~ efx_run.py CGraphPZT.xml --flow program --pgm_opts mode=jtag_bridge outflow/CGraphPZT.hex
	/home/summer/Downloads/efinity/2021.2/pgm/bin/efx_pgm/ftdi_program.py jtag_spi_flash_loader.bit -m jtag
	/home/summer/Downloads/efinity/2021.2/pgm/bin/efx_pgm/ftdi_program.py outflow/CGraphPZT.hex -m jtag_bridge
	#~ -ssh root@192.168.1.223 killall PZT
	#~ -scp PZT root@192.168.1.223:/home/root

clean:
	-rm -r work_syn
	-rm -r work_pt
	-rm -r work_pnr
	-rm -r outflow
	#~ -killall PZT

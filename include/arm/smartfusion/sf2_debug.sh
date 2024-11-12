#!/bin/bash

echo "Starting debugger..."

killall gnome-terminal-server

killall fpServer
export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/usr/lib/i386-linux-gnu:$INCLUDE_LOCAL/arm/openocd/fpserver:$LD_LIBRARY_PATH 
pushd $INCLUDE_LOCAL/arm/openocd/fpserver 
pwd
gnome-terminal -- bash -c ./fpServer
#xfce4-terminal -x ./fpServer
popd

killall openocd
export OPENOCD_SCRIPTS="$INCLUDE_LOCAL/arm/openocd/scripts"
#~ pushd $INCLUDE_LOCAL/arm/openocd
gnome-terminal -- bash -c '$INCLUDE_LOCAL/arm/openocd/openocd --command "gdb_port 3333" --command "tcl_port 6666" --command "telnet_port 4444" --command "set DEVICE M2S010" --file board/microsemi-cortex-m3.cfg --command "program $TARGET.elf verify reset"'
#~ popd

killall gdb
gnome-terminal -- bash -c '$GDB -ex "target remote localhost:3333" -ex "set mem inaccessible-by-default off" -ex "file $TARGET.elf"'

#~ nemiver&
	

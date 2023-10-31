#!/bin/bash
timestamp=$(/bin/date +"%F_%T")

sudo umount -lf /home/steve/projects/zonge/457/457
sshfs root@$1:/ /home/steve/projects/zonge/457/457 -ouid=1000
rsync -vrclpEt --exclude "*builds*" --exclude "*.o" --exclude "*.l*" --exclude "*.map" --exclude "*zip" TresCaminos /home/steve/projects/zonge/457/457/home/root/linux/
rsync -vrclpEt TresCaminos/Zen457 /home/steve/projects/zonge/457/457/home/root
rsync -vrclpEt TresCaminos/Zen457.cfg /home/steve/projects/zonge/457/457/home/root

#Shut down auto-run Zen if it's running
#~ xfce4-terminal --maximize -e "ssh -t root@$1 'systemctl stop Zen'" &
ssh root@$1 'systemctl stop Zen'

# Individual Zen Pipe Applications
#~ xfce4-terminal --maximize -e "ssh -t root@192.168.$1 'cd /home/root/linux/ZenMsg ; bash -c /home/root/linux/ZenMsg/ZenMsg; bash'" &
#~ xfce4-terminal --maximize -e "ssh -t root@192.168.$1 'cd /home/root/linux/ZenHardware ; /home/root/linux/ZenHardware/ZenHardware; bash'" &
#~ xfce4-terminal --maximize -e "ssh -t root@192.168.$1 'cd /home/root/linux/ZenGpsSync ; bash -c /home/root/linux/ZenGpsSync/ZenGpsSync; bash'" &
#~ xfce4-terminal --maximize -e "ssh -t root@192.168.$1 'cd /home/root/linux/ZenSchedule ; bash -c /home/root/linux/ZenSchedule/ZenSchedule; bash'" &
#~ xfce4-terminal --maximize -e "ssh -t root@192.168.$1 'cd /home/root/linux/ZenHub ; bash -c /home/root/linux/ZenHub/ZenHub; bash'" &
#~ xfce4-terminal --maximize -e "ssh -t root@192.168.$1 'cd /home/root/linux/ZenCal ; bash -c /home/root/linux/ZenCal/ZenCal; bash'" &

#~ # Todos / Zen457
#~ xfce4-terminal --maximize -e "ssh -t root@192.168.$1 'cd /home/root/linux/Todos ; /home/root/linux/Todos/Zen457; bash'" &

# Tres Caminos / Zen457
#~ xfce4-terminal --maximize -e "ssh -t root@$1 'cd /home/root/linux/TresCaminos ; /home/root/linux/TresCaminos/Zen457 | tee Zen457.$now.log; bash'" &
#~ xfce4-terminal --maximize -e "ssh root@$1 'cd /home/root/linux/TresCaminos; /home/root/linux/TresCaminos/Zen457' | tee Zen457.$timestamp.log; bash" &
#~ ssh root@$1 'cd /home/root/linux/TresCaminos; /home/root/linux/TresCaminos/Zen457' | tee Zen457.$timestamp.log
xfce4-terminal --maximize -e "./sshwithlog.sh $1"

# Binary Cmdr
#xfce4-terminal --maximize -e "ssh -t root@192.168.$1 'cd /home/root/linux ; bash -c /home/root/linux/BinaryCmdr; bash'" & # so we can run binary cmds

# Empty Terminal
#xfce4-terminal --maximize -e "ssh -t root@192.168.$1 'cd /home/root/linux ; bash'" & #so we can run random stuff

#!/bin/bash
timestamp=$(/bin/date +"%Y.%m.%d.%H.%M.%S")
ssh root@$1 'systemctl stop Zen && cd /home/root/linux/TresCaminos; killall -KILL Zen457; /home/root/linux/TresCaminos/Zen457 2>&1; bash' | tee Zen457.$timestamp.log

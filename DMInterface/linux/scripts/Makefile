all: 
	-ssh root@192.168.1.223 "systemctl stop PZT"
	scp -r etc root@192.168.1.223:/
	scp -r home root@192.168.1.223:/
	ssh root@192.168.1.223 "systemctl daemon-reload"

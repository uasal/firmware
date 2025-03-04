all: 
	-ssh root@192.168.1.223 "systemctl stop PZT"
	scp -r etc root@192.168.1.223:/
	scp -r home root@192.168.1.223:/
	ssh root@192.168.1.223 "systemctl daemon-reload"
#
	#-ssh torizon@192.168.1.223 "sudo -S systemctl stop PZT"
	#-ssh torizon@192.168.1.223 "mkdir /home/torizon/root"
	#scp -r etc torizon@192.168.1.223:/home/torizon/root
	#scp -r home torizon@192.168.1.223:/home/torizon/root
	#ssh torizon@192.168.1.223 "sudo -S rsync -avc /home/torizon/root/* /"
	#ssh torizon@192.168.1.223 "sudo -S nmcli con reload" #gives weird error
	#ssh torizon@192.168.1.223 "chmod -R 700 /home/torizon/.ssh"
	#ssh torizon@192.168.1.223 "chown -R root:root /etc"
	ssh torizon@192.168.1.223 "sudo -S systemctl daemon-reload"#

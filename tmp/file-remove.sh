#/bin/bash


function clean_logs() {


	cd /var/log
	#find . -type f -mtime +7 -exec rm -rf {} +
	find . -size +50M -exec rm -rf {} +

	cd /run
	#find . -type f -mtime +7 -exec rm -rf {} +
	find . -size +50M -exec rm -rf {} +

	cd /tmp/
	#find . -type f -mtime +7 -exec rm -rf {} +
	find . -size +50M -exec rm -rf {} +

	if [ ! -f /root/.generatelogs ]
	then
		rm -rf /root/upload
		rm -rf /root/log
	fi

	rm -rf /root/.ACPI 2> /dev/null
	rm -rf /data/licen.txt
	rm -rf /home/osuser/Downloads/*.ica
	rm -rf /root/osuser/Downloads/*.ica
	
	killall syslogd
	syslogd

}

if [ $1 == "--daemon" ]
then
	while :
	do
		clean_logs		
		sleep 1h
	done
	
else
	clean_logs
fi


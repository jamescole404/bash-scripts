#!/bin/bash
for i in /var/repos2/ISO/mariadb/*.iso; do
	part1=$(dirname "$i")
	part2=$(basename "$i")
	echo "Pushing ISO $part1 $part2"
	smbclient //192.168.1.2/yum-updates -A ~/.smbcredentials -c "lcd $part1 ; prompt ; mput $part2"
	sleep 5m	

done

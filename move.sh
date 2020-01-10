# moving RedHat ISOs to Microshaft
echo "Moving RedHat ISOs to Microshaft"
IPADDY="192.168.1.5"
for i in /var/repos2/ISO/redhat/*.iso; do
	partr1=$(dirname "$i")
	partr2=$(basename "$i")
	echo "Pushing Redhat ISO $part2"
	smbclient //$IPADDY/yum-updates -A ~/.smbcredentials -c "lcd $partr1 ; prompt ; mput $partr2"
	sleep 5m	

done


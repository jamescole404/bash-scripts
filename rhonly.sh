#!/bin/bash
# Get updates

TIME=$(date "+%Y%m%d-%H%M%S")
echo "Get updates. Please wait..." 
echo $TIME

#reposync -n  --download_path=/var/repos/redhat/7 --downloadcomps --download-metadata > /var/reposlogs/rh/$TIME+redhat7.log

echo "Checking for Thumbdrive."
mountvar=$(lsblk -rpo "name,type,size,mountpoint,vendor" | awk '$2=="part"&&$4==""&&$3=="931.5G"{printf "%s",$1}')
while [ -z $mountvar ]; do
        echo "Please insert the Thumbdrive and hit ENTER"
        read
        echo "Waiting for Thumbdrive to be found"
        sleep 5s
        mountvar=$(lsblk -rpo "name,type,size,mountpoint,vendor" | awk '$2=="part"&&$4==""&&$3=="931.5G"{printf "%s",$1}')
done
echo "Found Thumbdrive."
echo "Mounting Thumbdrive to /root/thumb."
mount $mountvar /root/thumb
echo "Testing for /root/thumb/redhat."
test -d /root/thumb/redhat && echo "Copying Redhat files. Please wait..."; rsync -av --modify-window=1 --inplace --delete-after /var/repos/redhat/ /root/thumb/redhat/ > /var/reposlogs/rh/movelog/rh.log
echo "Unmounting ThumbDrive"
umount $mountvar
echo "Deleting files in ISO prep file"
rm -rf /var/repos2/redhat/*
echo "Moving updates to ISO prep file"

awk '$1!="deleting" {print $1}' /var/reposlogs/rh/movelog/rh.log | grep -E "\w+\.[a-z][a-z][a-z]?$" | rsync -avr --files-from=- /var/repos/redhat/ /var/repos2/redhat/
echo "Deleting TAR and ISO files"
rm -rf /var/repos2/ISO/redhat/*
echo "Creating Delete Logs"
awk '$1=="deleting" {print $1}' /var/reposlogs/rh/movelog/rh.log | grep -E "\w+\.[a-z][a-z][a-z]?$" > /var/repos2/ISO/redhat/rhdeletedfiles.log

echo "Creating RedHat TAR file"
rhtarfile="redhatrepo.$(date "+%Y%m%d").tar.bz2"
tar -cvjf /var/repos2/ISO/redhat/$rhtarfile /var/repos2/redhat/*
echo "Making ISO(s) of Redhat TAR file"
tarsize=$(ls -l /var/repos2/ISO/redhat/$rhtarfile | awk '{print $5}')
if (( $tarsize > 4000000000 )); then
  split -b 4GB /var/repos2/ISO/redhat/$rhtarfile  /var/repos2/ISO/redhat/$rhtarfile".part"
  for i in /var/repos2/ISO/redhat/*part*; do
    mkisofs -o $i".iso" -J -R -A -V -v $i 
  done
else
  mkisofs -o /var/repos2/ISO/redhat/$rhtarfile".iso" -J -R -A -V -v /var/repos2/ISO/redhat/$rhtarfile
fi

# moving RedHat ISOs to Microshaft
echo "Moving RedHat ISOs to Microshaft"
#IPADDY=$(arp | awk '$3=="5c:f3:fc:34:da:fe" {print $1}')
IPADDY="192.168.1.5"
for i in /var/repos2/ISO/redhat/*.iso; do
	partr1=$(dirname "$i")
	partr2=$(basename "$i")
	echo "Pushing Redhat ISO $part2"
	smbclient //$IPADDY/yum-updates -A ~/.smbcredentials -c "lcd $partr1 ; prompt ; mput $partr2"
	sleep 5m	

done


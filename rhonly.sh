#!/bin/bash
# Get updates

TIME=$(date "+%Y%m%d-%H%M%S")
echo "Get updates. Please wait..." 
echo $TIME

#reync -n  --download_path=/var/re/redhat/7 --downloadcomps --download-metadata > /var/relogs/rh/$TIME+redhat7.log

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
test -d /root/thumb/redhat && echo "Copying Redhat files. Please wait..."; rsync -av --modify-window=1 --inplace --delete-after /var/re/redhat/ /root/thumb/redhat/ > /var/relogs/rh/movelog/rh.log
echo "Unmounting ThumbDrive"
umount $mountvar
echo "Deleting files in ISO prep file"
rm -rf /var/re2/redhat/*
echo "Moving updates to ISO prep file"

awk '$1!="deleting" {print $1}' /var/relogs/rh/movelog/rh.log | grep -E "\w+\.[a-z][a-z][a-z]?$" | rsync -avr --files-from=- /var/re/redhat/ /var/re2/redhat/
echo "Deleting TAR and ISO files"
rm -rf /var/re2/ISO/redhat/*
echo "Creating Delete Logs"
awk '$1=="deleting" {print $1}' /var/relogs/rh/movelog/rh.log | grep -E "\w+\.[a-z][a-z][a-z]?$" > /var/re2/ISO/redhat/rhdeletedfiles.log

echo "Creating RedHat TAR file"
rhtarfile="redhatrepo.$(date "+%Y%m%d").tar.bz2"
tar -cvjf /var/re2/ISO/redhat/$rhtarfile /var/re2/redhat/*
echo "Making ISO(s) of Redhat TAR file"
tarsize=$(ls -l /var/re2/ISO/redhat/$rhtarfile | awk '{print $5}')
if (( $tarsize > 4000000000 )); then
  split -b 4GB /var/re2/ISO/redhat/$rhtarfile  /var/re2/ISO/redhat/$rhtarfile".part"
  for i in /var/re2/ISO/redhat/*part*; do
    mkisofs -o $i".iso" -J -R -A -V -v $i 
  done
else
  mkisofs -o /var/re2/ISO/redhat/$rhtarfile".iso" -J -R -A -V -v /var/re2/ISO/redhat/$rhtarfile
fi

# moving RedHat ISOs to Microshaft
echo "Moving RedHat ISOs to Microshaft"
#IPADDY=$(arp | awk '$3=="5c:f4:f3:64:4a:de" {print $1}')
IPADDY="192.168.1.5"
for i in /var/re2/ISO/redhat/*.iso; do
	partr1=$(dirname "$i")
	partr2=$(basename "$i")
	echo "Pushing Redhat ISO $part2"
	smbclient //$IPADDY/yum-updates -A ~/.smbcredentials -c "lcd $partr1 ; prompt ; mput $partr2"
	sleep 5m	

done


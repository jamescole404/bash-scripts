# Get the updates
TIME=$(date "+%Y%m%d-%H%M%S")
echo "Get updates. Please wait..." 
rsync --log-file=/var/reposlogs/mariadb/$TIME.mariadb.log -a --partial --delete-after  --delete-after rsync.osuosl.org::mariadb /var/repos/mariadb
reposync -n --config=/home/xadministrator/redhat.repo --download_path=/var/repos/redhat/6 --downloadcomps --download-metadata > /var/reposlogs/rh/$TIME+redhat6.9.log
reposync -n --config=/home/xadministrator/redhat6.7.repo --download_path=/var/repos/redhat/6 --downloadcomps --download-metadata > /var/reposlogs/rh/$TIME+redhat6.7.log
reposync -n --config=/home/xadministrator/redhat6.4.repo --download_path=/var/repos/redhat/6 --downloadcomps --download-metadata > /var/reposlogs/rh/$TIME+redhat6.4.log
reposync -n --config=/home/xadministrator/redhat6.3.repo --download_path=/var/repos/redhat/6 --downloadcomps --download-metadata > /var/reposlogs/rh/$TIME+redhat6.3.log
reposync -n  --download_path=/var/repos/redhat/7 --downloadcomps --download-metadata > /var/reposlogs/rh/$TIME+redhat7.log

echo "Checking for Thumbdrive."
mountvar=$(lsblk -rpo "name,type,size,mountpoint,vendor" | awk '$2=="part"&&$4==""&&$3=="931.5G"{printf "%s",$1}')
while [ -z $mountvar ]; do
        echo "Please insert the Thumbdrive and hit ENTER"
        read
        echo "Waiting for Thumbdrive to be found"
        sleep 6s
        mountvar=$(lsblk -rpo "name,type,size,mountpoint,vendor" | awk '$2=="part"&&$4==""&&$3=="931.5G"{printf "%s",$1}')
done
echo "Found Thumbdrive."
echo "Mounting Thumbdrive to /root/thumb."
mount $mountvar /root/thumb
echo "Testing for /root/thumb/mariadb."
test -d /root/thumb/mariadb && echo "Copying Mariadb files. Please wait..."; rsync -av --modify-window=1 --inplace --delete-after /var/repos/mariadb/ /root/thumb/mariadb/ > /var/reposlogs/mariadb/movelog/mdb.log
echo "Testing for /root/thumb/redhat."
test -d /root/thumb/redhat && echo "Copying Redhat files. Please wait..."; rsync -av --modify-window=1 --inplace --delete-after /var/repos/redhat/ /root/thumb/redhat/ > /var/reposlogs/rh/movelog/rh.log
echo "Unmounting ThumbDrive"
umount $mountvar
echo "Deleting files in ISO prep file"
rm -rf /var/repos2/mariadb/*
rm -rf /var/repos2/redhat/*
echo "Moving updates to ISO prep file"
awk '$1!="deleting" {print $1}' /var/reposlogs/mariadb/movelog/mdb.log | grep -E "\w+\.[a-z][a-z][a-z]?$" | rsync -avr --files-from=- /var/repos/mariadb/ /var/repos2/mariadb/

echo "Deleting TAR and ISO files"
rm -rf /var/repos2/ISO/mariadb/*
rm -rf /var/repos2/ISO/redhat/*
echo "Creating Delete Logs"
awk '$1=="deleting" {print $1}' /var/reposlogs/mariadb/movelog/mdb.log | grep -E "\w+\.[a-z][a-z][a-z]?$" > /var/repos2/ISO/mariadb/mariadbdeletedfiles.log
awk '$1=="deleting" {print $1}' /var/reposlogs/rh/movelog/rh.log | grep -E "\w+\.[a-z][a-z][a-z]?$" > /var/repos2/ISO/redhat/rhdeletedfiles.log

echo "Creating TAR file"
tarfile="mariadbrepo.$(date "+%Y%m%d").tar.bz2"
tar -cvjf /var/repos2/ISO/mariadb/$tarfile /var/repos2/mariadb/*
echo "Making ISO(s) of Mariadb TAR file"
tarsize=$(ls -l /var/repos2/ISO/mariadb/$tarfile | awk '{print $5}')
if (( $tarsize > 4000000000 )); then
  split -b 4GB /var/repos2/ISO/mariadb/$tarfile  /var/repos2/ISO/mariadb/$tarfile".part"
  for i in /var/repos2/ISO/mariadb/*part*; do
    mkisofs -o $i".iso" -J -R -A -V -v $i 
  done
else
 mkisofs -o /var/repos2/ISO/mariadb/$tarfile".iso" -J -R -A -V -v /var/repos2/ISO/mariadb/$tarfile
fi

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

# moving Mariadb ISOs to Microshaft
echo "Moving Mariadb ISOs to Microshaft"
for i in /var/repos2/ISO/mariadb/*.iso; do
	part1=$(dirname "$i")
	part2=$(basename "$i")
	echo "Pushing Mariadb ISO $part2"
	smbclient //192.168.1.2/yum-updates -A ~/.smbcredentials -c "lcd $part1 ; prompt ; mput $part2"
	sleep 5m	

done
# moving RedHat ISOs to Microshaft
echo "Moving RedHat ISOs to Microshaft"
for i in /var/repos2/ISO/redhat/*.iso; do
	partr1=$(dirname "$i")
	partr2=$(basename "$i")
	echo "Pushing Redhat ISO $part2"
	smbclient //192.168.1.2/yum-updates -A ~/.smbcredentials -c "lcd $partr1 ; prompt ; mput $partr2"
	sleep 5m	

done


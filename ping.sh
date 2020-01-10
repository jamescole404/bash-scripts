The following script is used to ping multiple hosts.

#!/bin/bash
for i in 192.168.0.{1..10}
do
   ping -c 1 -t 1 "$i" >/dev/null 2>&1 &&
   echo "Ping Status of $i : Success" ||
   echo "Ping Status of $i : Failed"
done

Suppose, if we have more host names in the text file, then we can use the below script.


while read hostname
do
ping -c 1 -t 1 "$hostname" > /dev/null 2>&1 && 
echo "Ping Status of $hostname : Success" || 
echo "Ping Status of $hostname : Failed" 
done < host.txt
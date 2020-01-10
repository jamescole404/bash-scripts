#!/bin/bash

TIME=$(date "+%Y%m%d-%H%M%S")
echo "Geting MariaDB updates. Please wait..." 
rsync --log-file=/var/reposlogs/mariadb/$TIME.mariadb.log -a --partial --delete-after  --delete-after rsync.osuosl.org::mariadb /var/repos/mariadb


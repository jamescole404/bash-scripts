#!/bin/bash
TIME=`date "+%Y%m%d-%H%M%S"`
#rsync --log-file=/var/relogs/$TIME.mariadb.log -a --partial --delete-after  rsync.osuosl.org::mariadb /var/re/mariadb

rsync -n --config=/home/user/redhat6.10.repo --download_path=/var/re/redhat/6 --downloadcomps --download-metadata > /var/relogs/$TIME+redhat6.10.log

rsync -n --config=/home/user/redhat.repo --download_path=/var/re/redhat/6 --downloadcomps --download-metadata > /var/relogs/$TIME+redhat6.9.log

rsync -n --config=/home/user/redhat6.7.repo --download_path=/var/re/redhat/6 --downloadcomps --download-metadata > /var/relogs/$TIME+redhat6.7.log

rsync -n --config=/home/user/redhat6.4.repo --download_path=/var/re/redhat/6 --downloadcomps --download-metadata > /var/relogs/$TIME+redhat6.4.log

rsync -n --config=/home/user/redhat6.3.repo --download_path=/var/re/redhat/6 --downloadcomps --download-metadata > /var/relogs/$TIME+redhat6.3.log

rsync -n  --download_path=/var/re/redhat/7 --downloadcomps --download-metadata > /var/relogs/$TIME+redhat7.log


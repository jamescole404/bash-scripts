#!/bin/bash
TIME=`date "+%Y%m%d-%H%M%S"`
#rsync --log-file=/var/reposlogs/$TIME.mariadb.log -a --partial --delete-after  rsync.osuosl.org::mariadb /var/repos/mariadb

reposync -n --config=/home/xadministrator/redhat6.10.repo --download_path=/var/repos/redhat/6 --downloadcomps --download-metadata > /var/reposlogs/$TIME+redhat6.10.log

reposync -n --config=/home/xadministrator/redhat.repo --download_path=/var/repos/redhat/6 --downloadcomps --download-metadata > /var/reposlogs/$TIME+redhat6.9.log

reposync -n --config=/home/xadministrator/redhat6.7.repo --download_path=/var/repos/redhat/6 --downloadcomps --download-metadata > /var/reposlogs/$TIME+redhat6.7.log

reposync -n --config=/home/xadministrator/redhat6.4.repo --download_path=/var/repos/redhat/6 --downloadcomps --download-metadata > /var/reposlogs/$TIME+redhat6.4.log

reposync -n --config=/home/xadministrator/redhat6.3.repo --download_path=/var/repos/redhat/6 --downloadcomps --download-metadata > /var/reposlogs/$TIME+redhat6.3.log

reposync -n  --download_path=/var/repos/redhat/7 --downloadcomps --download-metadata > /var/reposlogs/$TIME+redhat7.log


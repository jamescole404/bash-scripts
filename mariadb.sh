#!/bin/bash
TIME='date +%Y%m%d-%H%M%S'

rsync --log-file=/var/reposlogs/$TIME.mariadb.log -av --partial --delete-after rsync.osuosl.org::mariadb /var/repos/mariadb
rsync --log-file=/var/reposlogs/$TIME.mariadb.log -av --partial --delete-after rsync.osuosl.org::mariadb /var/repos/mariadb




#mv /var/reposlogs/mariadb.log /var/reposlogs/archive/$TIME.mariadb.log

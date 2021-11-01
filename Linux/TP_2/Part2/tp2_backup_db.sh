#!/bin/bash

# Backup script for db.tp2.linux
# Edited : 29/10/21
# Author : Yaniss Loisel
# Version : 1.0.0

database=$2
destination=$1
archiveName="$(date '+tp2_backup_db_%Y%m%d_%T' | tr -d :).tar"

mysqldump "$database" --user=nextcloud --password=meow > backup.sql

tar cvf $archiveName "backup.sql"
gzip $archiveName

rsync -av --remove-source-files "$archiveName.gz" $destFolder
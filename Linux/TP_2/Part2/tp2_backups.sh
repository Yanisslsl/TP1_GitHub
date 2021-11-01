#!/bin/bash 
# Simple backup script
# Author: Yaniss Loisel

destination=$1
target=$2
backup=$(date +tp2_backup_%y%m%d_%H%M%S.tar.gz)
backup_path="$(pwd)/${backup}"

check_before(){
	if (( $EUID != 0)); then
        	echo "This program must be run with root privileges"
        	exit
	fi

	if [[ -z $destination || -z $target ]] ; then
       		echo "You must specify a destination and dir to backup"
       		exit
	fi
	
	if [[ ! -d $destination ]]; then 
		echo  "The directory {$destination} is not accessible, please retry..."
	fi

	if [[ ! -d $target && ! -f $target ]] ; then 
		echo "The target is not acessible ,please retry.."
	fi

} 


archive_compress(){
	dir_to_archive=$1
	tar cvzf $backup_path $dir_to_archive &> /dev/null
	status=$?
	if [[ $status -eq 0 ]] ; then
		echo "Great !! Archive successfully created"
	else
		echo "Archive creation has failed"
		exit 
	fi
}

synchronize(){
	
	rsync -av --remove-source-files "${backup_path}" "${destination}" &> /dev/null
	status=$?
	if [[ $status -eq 0 ]] ; then
		echo "Archive successfully synchronized to ${destination}"
	else 
		echo "Synchronization has failed"
		exit
	fi
}

check_before
archive_compress "${target}"
synchronize

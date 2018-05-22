#!/usr/bin/bash

DATE=$(date +%Y%m%d%H%M%S)
NW_CONFIG_PATH="/etc/sysconfig/network-scripts"

backup_config(){
	BACKUP_DIR=${NW_CONFIG_PATH}/backup/${DATE}
	# Create backup folder
	if [ ! -d ${BACKUP_DIR} ]; then
		mkdir -p ${BACKUP_DIR}
	fi
	# Backup configuration files
	cp ${NW_CONFIG_PATH}/ifcfg-* ${BACKUP_DIR}
}

reconfigure_ifaces(){
	# Expected arguments
	# $1: Input file

	# First backup current configuration
	backup_config

	INPUT_FILE="$1"
	while read -r line
	do
		[[ "${line}" =~ ^#.*$ ]] && continue
		configuration=(${line//,/ })
		# OLD IP,NEW IP,NEW NETMASK,NEW GW
		OLD_IP=${configuration[0]}
		NEW_IP=${configuration[1]}
		NEW_MASK=${configuration[2]}
		NEW_GW=${configuration[3]}
	done < ${INPUT_FILE}
}


if [ $# -eq 0 ]; then
	echo "Np input file was provided"
	exit 1
elif [ $# -eq 1 ]; then
	INPUT_FILE="$1"
	if [ ! -f ${INPUT_FILE} ]; then
		echo "Input file could not be found"
		exit 1
	else
		# Add functions here
		reconfigure_ifaces ${INPUT_FILE}
	fi
else
	echo "More than one argument was provided"
	exit 1
fi

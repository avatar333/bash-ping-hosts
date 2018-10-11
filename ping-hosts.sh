#!/usr/bin/env bash

#title           :ping-hosts.sh
#description     :Ping a bunch of hosts to determine the one with the lowest latency
#author          :Kevin Pillay
#date            :2018/10/11
#version         :1.0
#usage           :bash ping-hosts.sh
#notes           : 
#==============================================================================

# VARIABLES

# Text color variables
TXTUND=$(tput sgr 0 1)          # Underline
TXTBLD=$(tput bold)             # Bold
BLDRED=${TXTBLD}$(tput setaf 1) # red
BLDGRN=${TXTBLD}$(tput setaf 2) # green
BLDYEL=${TXTBLD}$(tput setaf 3) # yellow
BLDBLU=${TXTBLD}$(tput setaf 4) # blue
BLDWHT=${TXTBLD}$(tput setaf 7) # white
TXTRST=$(tput sgr0)             # Reset

SRCFILE=host-list.txt

rm -f /tmp/ping-hosts-output.txt
touch /tmp/ping-hosts-output.txt

for NODE in $(cat $SRCFILE | grep "slickvpn.com")
do
	CANPING=$(ping -c1 $NODE > /dev/null 2>&1; echo $?)

#	printf "CANPING : $CANPING, NODE: $NODE\n"

	if [[ $CANPING -le 0 ]]
	then
		AVG=$(printf "ping -c 4 -W 2 $NODE | grep avg | cut -f5 -d\/ \n"|/bin/bash)

		if [[ ${#AVG} -le 0 ]]
		then
			AVG=1000
		fi

		printf "$AVG $NODE\n"
		printf "$AVG $NODE\n" >> /tmp/ping-hosts-output.txt
	else

		printf "Can't ping : $NODE\n"
	fi

done

cat /tmp/ping-hosts-output.txt | sort -k1 -rn


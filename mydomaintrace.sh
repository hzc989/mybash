#!/bin/bash
#########################################################################
# File Name: mydomaintrace.sh
# Author: Houston Wong
# mail: hzc989@163.com
# Created Time: Tue 14 Apr 2015 08:51:44 PM HKT
# USAGE: this script is used to trace domain name.
#########################################################################
domain=$1
if [ x$domain != x ];then
	#do the domain name departure
	if [ "x${domain##*.}" == "x" ];then
		domain=${domain%*.} #remove the root. from the domain	
	fi
	TLD=${domain##*.}
	REST=${domain%.*}
	SLD="${REST##*.}.${domain##*.}"
			
	#get root DNS Server
	echo -e "-------getting root DNS Server:-------\n"
	curl http://ftp.internic.net/domain/named.cache | grep "^\."
	#get the first line of the TLD DNS Server as rd
	rd=`curl http://ftp.internic.net/domain/named.cache | grep "^\." | awk '{print $4}' | sed -n '1p'`
	echo -e "-------getting $TLD DNS Server:-------\n"
	dig $TLD @$rd | grep "^$TLD"
	#get the first line of the SLD DNS Server as second
	second=`dig $TLD @$rd | grep "^$TLD" | awk '{print $5}' | sed -n '1p'`
	echo -e "-------getting $SLD DNS Server:--------\n"
	dig $SLD @$second | grep "^$SLD"
	#get the first line of  the last DNS Server as last
	last=`dig $SLD @$second | grep "^$SLD" | awk '{print $5}' | sed -n '1p'`
	echo -e "-------getting $domain DNS Server-------\n"
	dig $domain @$last | sed -n '/;; ANSWER SECTION:/,+3p'
else
	usage="USAGE:./mydomaintrace.sh domain"
	echo -e "$usage\n"
fi

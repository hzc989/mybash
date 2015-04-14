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
	#get root DNS Server
	echo -e "-------getting root DNS Server:-------\n"
	curl http://ftp.internic.net/domain/named.cache | grep '^\.'
	echo $root
	#get com. DNS Server 
	rd=`curl http://ftp.internic.net/domain/named.cache | grep '^\.' | awk '{print $4}' | sed -n '1p'`
	echo -e "-------getting com DNS Server:-------\n"
	dig com @$rd | grep '^com'
	#get *.com DNS Server
	second=`dig com @$rd | grep '^com\.' | awk '{print $5}' | sed -n '2p'`
	echo -e "-------getting ${domain#*.*.} DNS Server:--------\n"
	dig ${domain#*.*.} @$second | grep 'NS'
	#get the result
	last=`dig ${domain#*.*.} @$second | grep 'NS' | awk '{print $5}' | sed -n '2p'`
	echo -e "-------getting result-------\n"
	dig $domain @$last | sed -n '/;; ANSWER SECTION:/,+3p'
else
	usage="USAGE:./mydomaintrace.sh domain"
	echo -e "$usage\n"
fi

#!/bin/bash
#########################################################################
# File Name: mydomaintrace.sh
# Author: Houston Wong
# mail: hzc989@163.com
# Created Time: Tue 14 Apr 2015 08:51:44 PM HKT
# USAGE: this script is used to trace domain name.
#########################################################################
domain=$1
if [ "x$domain" != "x" ];then
	#do the domain name departure
	if [ "x${domain##*.}" == "x" ];then
		domain=${domain%*.} #remove the root. from the domain	
	fi			
	#start getting Root DNS Server
	echo -e "-------getting root DNS Server:-------\n"
	curl http://ftp.internic.net/domain/named.cache | grep "^\."
	#get the first line of the root DNS Server as root server
	root=`curl http://ftp.internic.net/domain/named.cache | grep "^\." | awk '{print $4}' | sed -n '1p'`
	echo $root	
	#init the parameters 
	current=${domain##*.}
	rest=${domain%.*}
	dns=$root
	#recursively getting the dns server
	while [ "$current" != "${domain%%.*}.$domain" ]
	do
	echo -e "\n-------getting $current DNS Server-------\n"
	if [ "$current" == "$domain" ];then
		dig $current @$dns | grep -A 5 "^$current" | grep -v "^;;" 
	else
		dig $current @$dns | grep "^$current"
	fi
	#get the first line of the DNS Servers as the next dns server
	type=`dig $current @$dns | grep "^$current" | awk '{print $4}' | sed -n '1p'`
	if [ "$type" == "NS" ];then
	dns=`dig $current @$dns | grep "^$current" | awk '{print $5}' | sed -n '1p'`
	fi
	current="${rest##*.}.$current"
	rest=${rest%.*}
	done
else
	usage="USAGE:./mydomaintrace.sh domain"
	echo -e "$usage\n"
fi

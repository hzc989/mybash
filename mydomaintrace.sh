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
	echo -e "-------getting root DNS Server-------\n"
	curl -s http://ftp.internic.net/domain/named.cache | grep "^\."
	#get the first line of the root DNS Server as root server
	root=`curl -s http://ftp.internic.net/domain/named.cache | grep "^\." | awk '{print $4}' | sed -n '1p'`
	#init the parameters 
	dns=$root
	answer=""
	#recursively query before getting ANSWER SECTION
	while [ "$answer" != ";; ANSWER SECTION:" ]
	do
	answer=`dig $domain @$dns | grep ";; ANSWER SECTION:"`
	echo -e "\n-------query from $dns-------\n"
	if [ "$answer" != ";; ANSWER SECTION:" ];then
		dig $domain @$dns | grep -w "NS" #display the AUTHORITY SECTION
	else #display the ANSWER SECTION
		dig $domain @$dns | grep -A 3 ";; ANSWER SECTION:" | grep -v ";;"
	fi
	#get the first line of the DNS Servers as the next dns server
	dns=`dig $domain @$dns | grep -w "NS" | awk '{print $5}' | sed -n '1p'`
	done
else
	usage="USAGE:./mydomaintrace.sh domain"
	echo -e "$usage\n"
fi

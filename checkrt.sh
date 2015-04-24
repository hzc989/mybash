#!/bin/bash
#########################################################################
# File Name: checkrt.sh
# Author: Houston Wong
# mail: hzc989@163.com
# Created Time: Wed 22 Apr 2015 08:23:58 PM HKT
# USAGE: checkrt.sh [ip|domain].default ip is 220.181.30.53
# EXAMPLE: checkrt.sh www.163.com
#########################################################################
ip="${1-"220.181.30.53"}"
#using mtr to check route
echo -e "[`date`]START checking route to $ip\n\
No.hop IpAddr	Loss% Snt Last Avg Best Wrst StDev" >> /var/log/checkrt.log
mtr -n --report -c 100 $ip | sed '1d' | while read LINE
do
loss=`echo $LINE | awk '{split($0,a," ");print a[3]}'`
avg=`echo $LINE | awk '{split($0,a," ");print a[6]}'`

#filter 100%loss route
if [ "$loss" == "sed" ];then
	echo $LINE | sed 's/awk sed/  unknown  /' >> /var/log/checkrt.log
	continue
fi
if [ ${loss%.*} -ge 10 -o ${avg%.*} -ge 50 ];then
	echo $LINE >> /var/log/checkrt.log
fi
done
echo "[`date`]checking route to $ip DONE" >> /var/log/checkrt.log

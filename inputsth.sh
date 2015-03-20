#########################################################################
# File Name: inputsth.sh
# Author: Houston Wong
# mail: hzc989@163.com
# Created Time: Fri 19 Sep 2014 08:48:49 PM HKT
#########################################################################
#!/bin/bash
if [ "$1" == "hello" ];then
	echo "Hello!How are you?"
elif [ "$1" == "Houston" ];then
	echo "Hello!Nice to meet u Houston!"
elif [ "$1" == "" ];then
	echo "You must input parameters,ex> {$0 someword}"
else
	echo "please input $0 hello or $0 Houston"
fi


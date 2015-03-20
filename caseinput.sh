#########################################################################
# File Name: caseinput.sh
# Author: Houston Wong
# mail: hzc989@163.com
# Created Time: Fri 19 Sep 2014 10:05:30 PM HKT
#########################################################################
#!/bin/bash
case $1 in
	"hello")
	echo "hello,how are you?"
	;;
	"")
	echo "you have input nothing!"
	;;
	"Houston")
	echo "hello!Houston!my name is Siri!"
	;;
	*)
	echo "you must input sth!"
	;;
esac

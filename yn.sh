#########################################################################
# File Name: yn.sh
# Author: Houston Wong
# mail: hzc989@163.com
# Created Time: Fri 19 Sep 2014 08:29:13 PM HKT
#########################################################################
#!/bin/bash
read -p "please input(Y/N): " yn
if [ "$yn" == "Y" ] || [ "$yn" == "y" ];then
	echo "continue,ok!"
elif [ "$yn" == "N" ]||[ "$yn" == "n" ];then
	echo "oh!break up!"
else
	echo "I don't know what your choice is?" 
fi

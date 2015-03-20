#!/bin/bash
########################################################################
# File Name: rotate_log.sh
# Author: Houston Wong
# mail: hzc989@163.com
# Created Time: Tue 10 Mar 2015 07:42:32 PM HKT
#########################################################################


#DEFAULT args
rotation=1
mode="move"
zcount=1000

#usage info
usage="USAGE:$0 [-n] [-m|--mode copytruncate|move] [-s|--size 100|100k|100M|100G] [-z count] filename"

#getopt 
while true; do
	if [ x$1 != x ];then
		case $1 in 
			-n)
				rotation=0
				shift;;
			-m|--mode)
				case $2 in
					copytruncate)
						mode="cptr"
						shift 2;;
					move)
						mode="move"
						shift 2;;
					*)
						echo -e "NO SUCH MODE\n${usage}"
						exit 1;;
				esac;;
			-s|--size)
				minsize=$2
				#size format handler
				unit=${minsize//[0-9]/''}
				d=${minsize//[^0-9]/''}
				case ${unit} in
					GB|Gb|gb|g|G)
						minsize=$[d*1024*1024]
						;;
					MB|Mb|mb|M|m)
						minsize=$[d*1024]
						;;
					KB|Kb|kb|K|k)
						minsize=${d}
						;;
					'')
						minsize=$[minsize/1024]
						;;
					*)
						echo -e "ERROR SIZE!\n${usage}"
						exit 1;;
				esac	
				shift 2;;
			-z)	
				zcount=$2
				shift 2;;
			*)
				if [ -f $1 ];then
					filename=$1;
					break
				else
					echo -e "argument/file no found\n${usage}"
					exit 1
				fi;;
		esac
	else
		break
	fi
done
#operation
re=`ls | awk '/^'"${filename}"'.[0-9]+.gz|^'"${filename}"'.[0-9]+/' | sort -t . -k2,2nr -k3,3nr`
num=`ls | awk '/^'"${filename}"'.[0-9]+/' | sort -t '.' -k2 -nr | wc -w`

#rename the rotated logs by +1
function mvold(){
zc=$1
for file in ${re};
do
	tmp=${file%.gz}
	if [ "${file##*.}" == "gz" ];then #mv the .n.gz file
		mv ${file} ${file%.*.gz}.`expr ${tmp##*.} + 1`.gz
	else
		if [ "${tmp##*.}" -ge "${zc}" ];then #gzip the file
			tar -czf ${file%.*}.`expr ${tmp##*.} + 1`.gz ${file} --remove-files
		else #mv the .n file
			mv ${file} ${file%.*}.`expr ${file##*.} + 1`
		fi
	fi
done
}

#cptr the current log
function cptr(){
cp ${filename} ${filename}.1
truncate -s 0 ${filename}
}

#mv the current log
function move(){
mv ${filename} ${filename}.1
touch ${filename}
}

#TEST 
echo $minsize
#main
if [ $rotation ];then
	if [ $(du ${filename} | awk '{print $1}') -gt ${minsize:--1} ];then
		case $mode in
			cptr)
				mvold $zcount
				cptr
				;;
			move)
				mvold $zcount
				move
				;;
		esac
	else
		echo "target log file is NO larger than minsize,nothing accomplished."
	fi
else
	exit 0
fi

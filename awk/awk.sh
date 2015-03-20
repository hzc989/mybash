#########################################################################
# File Name: awk.sh
# Author: Houston Wong
# mail: hzc989@163.com
# Created Time: Fri 10 Oct 2014 11:01:36 AM HKT
#########################################################################
#!/bin/bash
sf=$1
echo "sourcefile:$sf"
#change the sourcefile from ：to : using sed -i
sed -i "s/：/:/g" $sf
echo "            ***FIRST QUARTERLY REPORT **** "  
echo "            ***CAMPAIGN 2000 CONTRIBUTIONS ***"  
echo "-------------------------------------------------------------------"  
echo "  NAME                  PHONE      JAN| Feb| Mar|	Total Danated "  
echo "-------------------------------------------------------------------"
awk -F: '{printf("%-20s%15s%5d%5d%5d\t%5d\n",$1,$2,$3,$4,$5,$3+$4+$5)}' $sf
echo "-------------------------------------------------------------------"  
awk -F: 'BEGIN{sum=0;total=0}{total=$3+$4+$5;sum+=total}END{printf("SUMMARY\t\t\t\t\t\t total:$%d\n",sum)}' $sf
awk -F: 'BEGIN{sum=0;total=0;average=0;i=0}{total=$3+$4+$5;sum+=total;i++}END{printf("\t\t\t\t\t\taverage:$%.2f\n",sum/i)}' $sf
awk -F: 'BEGIN{top=0;total=0;name}{total=$3+$4+$5;if(top<total){top=total;name=$1}}END{printf("\t\t\thighest donation:$%.2f,from %-20s\n",top,name)}' $sf
echo "-------------------------------------------------------------------"

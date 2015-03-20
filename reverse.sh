#########################################################################
# File Name: reverse.sh
# Author: Houston Wong
# mail: hzc989@163.com
# Created Time: Fri 19 Sep 2014 10:43:48 AM HKT
#########################################################################
#!/bin/bash
read -p 'please input a sentence:' str
echo $str | tac -s ' '

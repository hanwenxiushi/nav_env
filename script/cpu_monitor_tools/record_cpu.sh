#!/bin/bash

Now_time=$(date)
CURRENT_DIR=$(cd `dirname $0`; pwd)
GOAL_DIR=$(cd $(dirname $0);cd ../../..; pwd)
echo -e "\e[34mCURRENT_DIR=${CURRENT_DIR} \e[0m"
echo -e "\e[36mGOAL_DIR=${GOAL_DIR} \e[0m"

cd ${GOAL_DIR}

if [[ ! -d "cpu" ]];then
	echo -e "\e[31m/cpu not exist \e[0m"
	echo -e "\e[32mmkdir cpu \e[0m"
	mkdir cpu && cd cpu
else
	cd cpu
fi
echo -e "\e[1;32mNow_time:${Now_time} \e[0m" && sleep 1;
echo -e "\e[32mOk, Now start to record a cpu.txt! \e[0m" && sleep 0.1;


while true
do
	sleep 3
	top -b -n 1 -d 3 | grep -E "comm_bridge|lslam|iros" >> record_cpu.txt
done
# split -l 2000 record_cpu.txt -d -a 3 cpu_ #按行数切割
# split -b 10k record_cpu.txt -d -a 1 cpu_ #按大小切割

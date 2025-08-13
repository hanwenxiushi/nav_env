#!/bin/bash

# 执行一次脚本后，可自行终端查看crontab -e保证定时任务设置准确

function setCrontab()
{
	Now_time=$(date);
	CURRENT_DIR=$(cd `dirname $0`; pwd)										#当前脚本执行目录
	rosbag_tools_DIR=$(cd `dirname $0`;cd ../rosbag_tools; pwd)				#录包工具目录
	cpu_monitor_tools_DIR=$(cd `dirname $0`;cd ../cpu_monitor_tools; pwd)		#cpu工具目录

	# echo -e "\e[32mCURRENT_DIR=${CURRENT_DIR} \e[0m"
	# echo -e "\e[32mrosbag_tools_DIR=${rosbag_tools_DIR} \e[0m"
	# echo -e "\e[32mcpu_monitor_tools_DIR=${cpu_monitor_tools_DIR} \e[0m"

	crontab -l > local_crontab

	# echo "当前脚本名称＝${BASH_SOURCE[0]:2}"
	# echo "* */3 * * * ${CURRENT_DIR}${BASH_SOURCE[0]:1}" >> local_crontab  #将当前脚本放入crontab中定时运行

	echo "* */3 * * * ${rosbag_tools_DIR}/clear_bag.sh >> ${rosbag_tools_DIR}/history.txt" >> local_crontab				#清理ros包，及记录清除历史
	echo "* */6 * * * ${cpu_monitor_tools_DIR}/clear_cpu.sh >> ${cpu_monitor_tools_DIR}/history.txt" >> local_crontab	#清理cpu记录文本，及记录清除历史
	echo "* * */1 * * cat /dev/null　> ${rosbag_tools_DIR}/history.txt" >> local_crontab									#删除清理ros包的记录历史
	echo "* * */1 * * cat /dev/null　> ${cpu_monitor_tools_DIR}/history.txt" >> local_crontab							#删除清理cpu记录文本的记录历史

	crontab local_crontab
}

function showCrontab()
{
	echo -e "\e[01;33mShow the local crontab\e[0m"
	echo -e "\e[01;33mPlease check whether the crontab already has the same scheduled task \e[0m"
	# gnome-terminal -x bash -c "crontab -l;sleep 2;exec bash"
	crontab -l && sleep 2
	echo -e "\e[01;32m#1.Continue?\n#2.Cancel?\e[0m"
	while [[ true ]]; do
		read -p "Input your num >" num
		if [[ ${num} -eq 1 ]]; then
			break
		elif [[ ${num} -eq 2 ]]; then
			exit
		else
			echo -e "\e[05;31mPlease input correct num, try again!\e[0m"
			continue
		fi
	done
	clear
}

# function compare()
# {	
# 	cat static_crontab local_crontab_tmp | sort | uniq -u > result.txt #对比本地定时任务初始的定时任务是否有新增
# 	if [[ ! -e result.txt ]]; then
# 		echo -e "\e[31mAn error occurs \e[0m"
# 		exit
# 	elif [[ -s result.txt ]]; then
# 		echo -e "\e[33mScheduled tasks already exist on the crontab ! \e[0m"
# 		echo -e "\e[01;04;32mIf there is no scheduled task you want, rerun the script and select yes\e[0m"
# 	fi
# }

function main()
{
	# crontab -l > local_crontab_tmp 	#保存当前本地定时任务
	clear
	echo -e "\e[01;05;32mYou can run the \"crontab -e\" command to modify scheduled tasks!\e[0m"
	showCrontab
	echo -e "\033[42m---------------------------------------------------------\033[0m"
	echo -e "\e[01;32mConfirm it is correct, and add it directly[确认无误，直接增加?]\e[0m"
	echo -e "#\e[32m 1.Yes\e[0m                       #"
	echo -e "#\e[31m 2.No\e[0m                        #"
	echo -e "\033[42m---------------------------------------------------------\033[0m"
	read -p "Input the num > " choice
	case $choice in
	1)
		# compare
		setCrontab
		echo -e "\e[32mNow the crontab has already done"
	;;
	2)
		# compare
		rm -rf local_crontab
		exit
	;;
	*)
		echo -e "\e[05;33mPlease input correct num \e[0m"
		echo -e "\e[01;05;31mYou can run the \"crontab -e\" command to modify scheduled tasks[0m"
	;;
	esac
	# rm -rf local_crontab_tmp local_crontab result.txt
	rm -rf local_crontab
	crontab -l
	exit
}

main



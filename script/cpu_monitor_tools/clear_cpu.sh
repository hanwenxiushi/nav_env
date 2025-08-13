#!/bin/bash
cpu_DIR=$(cd `dirname $0`;cd ../../../cpu; pwd) #ros包存放目录
cd ${cpu_DIR}
echo $PWD

#检查文件的大小
Check_File_Size(){
    local file_name=$1
    local file_small_size=$2       #设置包的最小值，1024代表1M
    [[ ! -f ${file_name} ]] && Log ERROR "${file_name} Not Found" && exit 1
    if ! echo ${file_small_size} | egrep '^[[:digit:]]+$' &> /dev/null;then
        Log ERROR "file_small_size Must Is Number" && exit 1
    fi
    echo "INFO:Begin Check ${file_name}..."
    local file_size=$(du -s ${file_name} | awk '{print $1}')
    if [[ ${file_size} -gt ${file_small_size} ]];then
        echo -e"\e32mINFO:${file_name} is cleared \e[0m" && cat /dev/null > ${file_name}
        exit 1
    else
        echo -e "\e[32m${file_name} is smaller \e[0m"
    fi
}

Check_File_Size record_cpu.txt 20480


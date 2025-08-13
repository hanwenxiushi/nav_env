#!/bin/bash
ros_bag_DIR=$(cd `dirname $0`;cd ../../../ros_bag; pwd) #ros包存放目录
data_path=${ros_bag_DIR}

function deletefiles(){
	local currentDate=`date +%s`
	echo "current date is:" $currentDate
	for file in `find $1 -name "*.bag*"`
	do
	local name=$file
	local modifyDate=$(stat -c %Y $file)
	echo "modify date is:" $modifyDate
	local existTime=$[$currentDate-$modifyDate]
		if [ $existTime -gt 10800 ]; then
			echo "file:" $name "modify Date:" $modifyDate + "Exist time:" $existTime + "Delete:yes"
			rm -rf $file
		else
			echo "file:" $name "modify Date:" $modifyDate + "Exist time:" $existTime + "Delete:no"
		fi
	done
}
deletefiles ${data_path}
#! /bin/bash
#***************************************************
# Author        : lumeng
# Filename      : autopackage.sh
# Last modified : 2022.09.21
# Description   : script to package deb
#***************************************************
#packageArray=("inav" "irviz")
packageArray=("inav")
definePathStr="home/lum/iros_bt"

controlStr="Package: test_package_name
Version: 0.0.1
Architecture: amd64
Description: Navigation function package by Infore Robot
Maintainer: zhangjian
Priority: optional
Section: utils
"

echo "------------start--------------------"
basepath=$(cd `dirname $0`; pwd)
echo "basepath = $basepath"

ROBOT_USER=
if [ ! -n "$1" ] ;then
  	echo "you have not input username!"
  	ROBOT_USER=/home/${HOME##*/}
else
	ROBOT_USER=/home/$1
fi
echo "ROBOT_USER = $ROBOT_USER"

function  package_deb_func()
{
	echo ""
	echo "------------the following is to package $1--------------------"
	for fileParam in `ls $basepath/$1`; 
	do 
		if [ "$(echo $fileParam | grep "_version")" == "" ];then
			echo $fileParam;
			rm ./tempdeb -rf
			mkdir -p ./tempdeb/$ROBOT_USER
			mkdir -p ./tempdeb/DEBIAN
			touch ./tempdeb/DEBIAN/control
			
			for fileCtx in $((cat $basepath/$1/$fileParam) | sed 's/\r//g');
			do
				echo $fileCtx
				filePath1=$(echo ${fileCtx#*/})
				#echo $filePath1
				filePath2=$(echo ${filePath1#*/})
				#echo $filePath2
				filePath3=$(echo ${filePath2#*/})
				#echo $filePath3

				if [ -d $fileCtx ];then
					newFilePath="./tempdeb/$ROBOT_USER/$filePath3"
					echo "newFilePath = $newFilePath"
					mkdir -p $newFilePath
					cp $fileCtx/* $newFilePath/ -rf;
				elif [ -f $fileCtx ];then
					newFolderPath="./tempdeb/$ROBOT_USER/$(echo ${filePath3%/*})"
					echo "newFolderPath = $newFolderPath"
					mkdir -p $newFolderPath
					cp $fileCtx $newFolderPath;
				fi
			done
			
			controlVer="0.0.1";
			for verParam in `ls $basepath/$1`; 
			do 
				if [ "$verParam" == "$fileParam"_version"" ];then
					controlVer=$(cat $basepath/$1/$verParam);
				fi
			done
			bakCtrStr="$controlStr";
			bakCtrStr=$(echo "${bakCtrStr/test_package_name/$fileParam}")
			bakCtrStr=$(echo "${bakCtrStr/0.0.1/$controlVer}")
			echo "$bakCtrStr" >> ./tempdeb/DEBIAN/control
			sed -i 's/_/-/g' ./tempdeb/DEBIAN/control
			dpkg -b tempdeb/ $fileParam-$controlVer.deb
		fi
	done
	echo "------------finish package $1--------------------"
}

for value in ${packageArray[*]}
do 
	package_deb_func $value
done

rm ./tempdeb -rf
rm "package" -rf
mkdir -p "package"
mv *.deb "package"

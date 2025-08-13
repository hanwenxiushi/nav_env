#!/bin/bash

ROOT_DIR=$(cd $(dirname $0); pwd)
ARCH=$(arch)

ROBOT_DEB=
if [ ! -n "$1" ] ;then
  	echo "you have not input username!"
  	ROBOT_DEB="inav"
else
	ROBOT_DEB="$1"
fi
echo "ROBOT_DEB = $ROBOT_DEB"

apt-get clean
cd ${ROOT_DIR}

#安装deb
for deb in $(ls ${ROOT_DIR}/package/*.deb)
do
    echo "start dpkg -i ${deb}"
    echo '123' |sudo -S dpkg -i --force-all ${deb}
    echo "complete dpkg -i ${deb}"
done
#chmod 777 /home/lum/iros_ws/nav_env/* -Rf
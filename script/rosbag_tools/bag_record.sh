#!/bin/bash
clear;

echo $ROBOT_ENV_PATH

Now_time=$(date);
echo  -ne "\e[1;32m  Now_time:${Now_time} \e[0m" && sleep 0.1;
echo -e "\e[32m   PID:$(echo $$) \e[0m" && sleep 0.5;
 
read -p "Enter your rosbag Mode:[rosbag: 0 1 2]" mode;
while  test -z "$mode" || test $mode -lt 0 || test $mode -gt 2 #检测输入内容是否正确
do
        echo -e "\e[1;31mPlease Enter a Valid Integer (0 < Num < 3)!! \e[0m" && sleep 0.5;
        read -p "Enter your rosbag Mode:[0  1  2]" mode; 
done
 
if (($mode == 0)); then 
        echo -e "\e[32mOk, Record a rosbag odom/scan/imu/! \e[0m" && sleep 1;
        cd $ROBOT_ENV_PATH/script/ros_bag/
        rosbag  record --split --size=100 /odom /imu /scan;
elif (($mode == 1)); then 
        echo -e "\e[32mOk, Record a rosbag! odom/scan/imu\e[0m" && sleep 1;
        cd $ROBOT_ENV_PATH/script/ros_bag/
        rosbag  record --split --size=150 /odom /imu /scan;
elif (($mode == 2)); then 
        echo -e "\e[32mOk, Record a rosbag! odom/scan/imu\e[0m" && sleep 1;
        cd $ROBOT_ENV_PATH/script/ros_bag/
        rosbag record --split --size=200 /cameraImage;
elif (($mode == 3)); then
        echo -e "\e[32mOk, Record a cpu.txt! \e[0m" && sleep 1;
        cd $ROBOT_ENV_PATH/script/ros_bag/
        top | grep -E "iros|commbridge|lslam" > cpu.txt;
fi
exit 0;
#!/bin/bash
Now_time=$(date)
CURRENT_DIR=$(cd `dirname $0`; pwd)
GOAL_DIR=$(cd $(dirname $0);cd ../../..; pwd)
echo -e "\e[34mCURRENT_DIR=${CURRENT_DIR} \e[0m"
echo -e "\e[36mGOAL_DIR=${GOAL_DIR} \e[0m"

cd ${GOAL_DIR}

if [[ ! -d "ros_bag" ]];then
	echo -e "\e[31m/ros_bag not exist \e[0m"
	echo -e "\e[32mmkdir ros_bag \e[0m"
	mkdir ros_bag && cd ros_bag
else
	cd ros_bag
fi

echo -e "\e[1;32mNow_time:${Now_time} \e[0m" && sleep 1;
echo -e "\e[32mOk, Now start to record rosbag \e[0m" && sleep 0.1;


robot_name=$(grep 'robot_name' ${GOAL_DIR}/nav_env/resource/cfg/iros.toml | awk -F '"' '{print $2}')
echo "robot_name: $robot_name"
smzx_robot=("bingp" "zhuoyi" "fuwutai" "dingp" "chadian" "kongtiao") #smzx机型添加

is_smzx=0
for robot in "${smzx_robot[@]}"; do
    # 判断提取的robot_name值是否等于compare_string
    if [ "$robot_name" = "$robot" ]; then
    	#smzx
        is_smzx=1
        rosbag record --split --size=300 -j /imu /imu/data /imu_offset /odom /safe_area_mode /pre_warn_area /wr_scan_1 /wr_scan_2 /wj_scan_1 /wj_scan_2 /initialpose /watch/current_pose /tracked_pose /upd_map2base /pre_map2base /steering_wheel_angle /cmd_vel /relo_pose /active_map_pcd /history_map_pcd /location_state /other_robot /watch/local_path /map_point_cloud /align_point_cloud /MyPointCloud2 /MyDynamicPointCloud2 /new_pose
        break;
    fi
done

if [[ ${is_smzx} != 1 ]]; then
    #试验区
    rosbag record --split --size=300 -j /imu /imu/data /imu_offset /odom /safe_area_mode /pre_warn_area /scan /scan1 /scan2 /lidar1/scan /lidar2/scan /initialpose /watch/current_pose /tracked_pose /upd_map2base /pre_map2base /cmd_vel /relo_pose /location_state /watch/local_path /history_map_pcd /map_point_cloud /MyPointCloud2 /MyDynamicPointCloud2 /new_pose
    
fi
# # 如果没有找到匹配项
# if [ $? -ne 0 ]; then
#     echo "$robot_name is not equal to any of the smzx_robot"
# fi

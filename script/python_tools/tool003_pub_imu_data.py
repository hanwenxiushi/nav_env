# /* 
# * @Author: {Zhidong Jiao}
# * @Date: 2022-12-10 13:36:15  
# * @Last Modified by:   Zhidong Jiao  
# * @Last Modified time: 2022-12-11 15:36:15  
# */
import rospy
from sensor_msgs.msg import Imu
from nav_msgs.msg import Odometry
import os
import math 


# 订阅 /imu 话题消息，再转换到odom坐标系下进行rviz可视化
def sub_imu_cb(imu_):
    imu_new = Odometry()
    imu_new.header.stamp = imu_.header.stamp
    imu_new.header.frame_id = "odom"
    imu_new.child_frame_id = "imu"
    imu_new.pose.pose.position.x = 0
    imu_new.pose.pose.position.y = 0
    imu_new.pose.pose.position.z = 0
    imu_new.pose.pose.orientation.x = imu_.orientation.x
    imu_new.pose.pose.orientation.y = imu_.orientation.y
    imu_new.pose.pose.orientation.z = imu_.orientation.z
    imu_new.pose.pose.orientation.w = imu_.orientation.w

    pub1 = rospy.Publisher("/imu2odom",Odometry,queue_size=100)
    pub1.publish(imu_new)
    imu_yaw = math.degrees( math.atan2(2*(imu_.orientation.w * imu_.orientation.z),1-2*(imu_.orientation.z **2)))
    print('imu角度为(°):  '+str(imu_yaw))



# 订阅 /imu/data 话题消息，再转换到odom坐标系下进行rviz可视化
def sub_imu_data_cb(imu_data_):
    imu_data_new = Odometry()
    imu_data_new.header.stamp = imu_data_.header.stamp
    imu_data_new.header.frame_id = "odom"
    imu_data_new.child_frame_id = "imu_data"
    imu_data_new.pose.pose.position.x = 0
    imu_data_new.pose.pose.position.y = 0
    imu_data_new.pose.pose.position.z = 0
    imu_data_new.pose.pose.orientation.x = imu_data_.orientation.x
    imu_data_new.pose.pose.orientation.y = imu_data_.orientation.y
    imu_data_new.pose.pose.orientation.z = imu_data_.orientation.z
    imu_data_new.pose.pose.orientation.w = imu_data_.orientation.w

    pub2 = rospy.Publisher("/imu_data2odom",Odometry,queue_size=100)
    pub2.publish(imu_data_new)
    imu_yaw = math.degrees( math.atan2(2*(imu_data_.orientation.w * imu_data_.orientation.z),1-2*(imu_data_.orientation.z **2)))
    print('imu_data角度为(°):  '+str(imu_yaw))
    


if __name__ == '__main__':
    rospy.init_node("imu_node")
    sub1 = rospy.Subscriber("/imu", Imu, sub_imu_cb, queue_size = 100)
    sub2 = rospy.Subscriber("/imu/data", Imu, sub_imu_data_cb, queue_size = 100)
    cmd1 = "pwd"
    path = os.popen(cmd1).read().strip().split("scripts")[0]
    print(path)
    cmd2 = "rviz -d" + path + "/data/tool003_pub_imu_data.rviz"
    os.system(cmd2)
    rospy.spin()

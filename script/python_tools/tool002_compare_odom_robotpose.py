import rospy
import os
import math
from nav_msgs.msg import Odometry
from geometry_msgs.msg import Pose
import matplotlib.pyplot as plt


count1 = 0
count2 = 0
count3 = 0
x1=[0]
y1=[0]
x2=[0]
y2=[0]
x3=[0]
y3=[0]
x4=[0]
y4=[0]

first_frame_ox = 0
first_frame_oy = 0
first_frame_od_theta = 0
first_frame_rx = 0
first_frame_ry = 0
first_frame_rp_theta = 0
odom_x_delta = 0
odom_y_delta = 0
odom_theta_delta = 0
rp_x_delta = 0
rp_y_delta = 0
rp_theta_delta = 0

class CompareOdomRobotpose:
    def tf_swap(delta_x,delta_y,theta):
        x = delta_x*math.cos(theta) - delta_y*math.sin(theta)
        y = delta_y*math.cos(theta) + delta_x*math.sin(theta)
        return x,y

    # odom回调
    def OdomCB(odom_):
        global count1,first_frame_ox,first_frame_oy,first_frame_od_theta,odom_x_delta,odom_y_delta,odom_theta_delta
        odom_x = odom_.pose.pose.position.x
        odom_y = odom_.pose.pose.position.y
        odom_theta = math.atan2(2*(odom_.pose.pose.orientation.w*odom_.pose.pose.orientation.z),1-2*(odom_.pose.pose.orientation.z**2))
        # 第一帧判断
        if count1 == 0:
            first_frame_ox = odom_x
            first_frame_oy = odom_y
            first_frame_od_theta = odom_theta
            count1+=1
        
        odom_x_delta = odom_x - first_frame_ox
        odom_y_delta = odom_y - first_frame_oy
        odom_theta_delta = odom_theta - first_frame_od_theta


    # robot_pose回调
    def RobotPoseCB(rp_):
        global count2,first_frame_rx,first_frame_ry,first_frame_rp_theta,rp_x_delta,rp_y_delta,rp_theta_delta
        rp_x = rp_.position.x
        rp_y = rp_.position.y
        rp_theta = math.atan2(2*(rp_.orientation.w*rp_.orientation.z),1-2*(rp_.orientation.z**2)) #弧度
        # 第一帧判断
        if count2 == 0:
            first_frame_rx = rp_x  # 第一帧x
            first_frame_ry = rp_y  # 第一帧y
            first_frame_rp_theta = rp_theta  # 第一帧theta1
            count2+=1

        rp_x_delta = rp_x
        rp_y_delta = rp_y
        rp_theta_delta = rp_theta

    


    


    def DrawGrapher():
        # CompareOdomRobotpose.DrawGrapher2()
        global count3,x1,x2,x3,x4,y1,y2,y3,y4,rp_x_delta,rp_y_delta,odom_x_delta,odom_y_delta,rp_theta_delta,odom_theta_delta
        global first_frame_rx,first_frame_ry,first_frame_od_theta,first_frame_rp_theta
        while not rospy.is_shutdown():
            plt.clf()  #清除上一幅图像
            delta_theta = first_frame_rp_theta - first_frame_od_theta   # odom相对的robot_pose初始位差
            print(delta_theta)
            odom_x_2rp = first_frame_rx + odom_x_delta * math.cos(delta_theta) - odom_y_delta * math.sin(delta_theta)  # robot_pose相对odom的旋转公式
            odom_y_2rp = first_frame_ry + odom_y_delta * math.cos(delta_theta) + odom_x_delta * math.sin(delta_theta)
            odom_theta_2rp = first_frame_rp_theta + odom_theta_delta                
            
            x1.append(odom_x_2rp)
            y1.append(odom_y_2rp)
            x2.append(rp_x_delta)
            y2.append(rp_y_delta)

            
            x3.append(count3)
            y3.append(odom_theta_2rp)
            y4.append(rp_theta_delta)
            count3 += 1
            
            plt.figure(1)
            plt.title("Compare odom and robot_pose position", fontsize=12)
            plt.xlabel("x(m)", fontsize=10)
            plt.ylabel("y(m)", fontsize=10)
            plt.plot(x1,y1,'-g')
            plt.plot(x2,y2,'-r')
            plt.legend(["od2rp", "rp"])
            plt.savefig('Compare position')


            plt.figure(2)
            plt.title("Compare odom and robot_pose theta", fontsize=12)
            plt.xlabel("cycle", fontsize=10)
            plt.ylabel("theta(°)",fontsize=10)          
            plt.plot(x3,y3,'-b')
            plt.plot(x3,y4,'-y')
            plt.legend(["od2rp", "rp"])            
            plt.savefig('Compare theta')

            plt.pause(0.25)
              




if __name__ == '__main__':
    rospy.init_node("compare_odom_robotpose_node")
    sub1 = rospy.Subscriber("/odom", Odometry, CompareOdomRobotpose.OdomCB, queue_size=100)
    sub2 = rospy.Subscriber("/robot_pose", Pose, CompareOdomRobotpose.RobotPoseCB, queue_size=100)
    CompareOdomRobotpose.DrawGrapher()
    rospy.spin()
    

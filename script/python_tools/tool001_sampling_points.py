import rospy
from geometry_msgs.msg import Pose
import math
M_PI = 3.1415926


def sub_robot_pose_cb(pose):
    pos_x_ = pose.position.x
    pos_y_ = pose.position.y
    pos_z_ = pose.position.z
    ori_x_ = pose.orientation.x
    ori_y_ = pose.orientation.y
    ori_z_ = pose.orientation.z
    ori_w_ = pose.orientation.w
    # rospy.sleep(1)
    # 弧度
    roll_ = math.atan2(2*(ori_w_ * ori_x_ + ori_y_ * ori_z_),1-2*(ori_x_ * ori_x_ + ori_y_ * ori_y_))
    if(math.fabs(2*(ori_w_ * ori_y_ - ori_x_ * ori_z_)) >=1 ):
        pitch_ = math.copysign(M_PI/2,2*(ori_w_ * ori_y_ - ori_x_ * ori_z_))
    else:
        pitch_ = math.asin(2*(ori_w_ * ori_y_ - ori_x_ * ori_z_))
    yaw_ = math.atan2(2*(ori_w_ * ori_z_ + ori_x_ * ori_y_),1-2*(ori_y_ * ori_y_ + ori_z_ * ori_z_))

    # 角度
    angleR = math.degrees(roll_)
    angleP = math.degrees(pitch_)
    angleY = math.degrees(yaw_)

    print("-----------------------")
    print("当前位姿信息为：")
    print("位置x:", pos_x_)
    print("位置y:", pos_y_)
    print("弧度rad：", yaw_)
    print("角度°：", angleY)
    # Note.write(str(pos_x_))
    # Note.write(str(pos_y_)
    # Note.write(str(yaw_)
    # Note.write(angleY)
    # Note.write('------ \n')
    

if __name__ == '__main__':
    rospy.init_node("robot_pose_node")
    sub = rospy.Subscriber("/robot_pose",Pose,sub_robot_pose_cb,queue_size=10)
    rospy.spin()

function pathPoint=calThePath(pathAngle)
%这个函数的功能是输入STN的坐标targetP，得到规划好的坐标pathPoint;
%pathPoint包含6个坐标，分别是矢状位左/右，冠状位左/右和轴位左/右规划好的坐标形态，图中坐标
%maindir标志显示轴/冠/矢，L是显示长度，Arc鼻/后脑，Rad左/右
%2017-02-13万森
global targetPoints;

targetP=zeros(6,3);
tempPoint=coordinateChange(targetPoints,1);
pathAngle=deg2rad(pathAngle);
L=2000;

targetP(1,2)=tempPoint(4,2)+L*cos(pathAngle(1,2))*cos(pathAngle(1,1));
targetP(1,3)=tempPoint(4,3)-L*cos(pathAngle(1,2))*sin(pathAngle(1,1));
targetP(2,2)=tempPoint(5,2)+L*cos(pathAngle(2,2))*cos(pathAngle(2,1));
targetP(2,3)=tempPoint(5,3)-L*cos(pathAngle(2,2))*sin(pathAngle(2,1));

targetP(3,1)=tempPoint(4,1)+L*sin(pathAngle(1,2));
targetP(3,3)=tempPoint(4,3)-L*cos(pathAngle(1,2))*sin(pathAngle(1,1));
targetP(4,1)=tempPoint(5,1)-L*sin(pathAngle(2,2));
targetP(4,3)=tempPoint(5,3)-L*cos(pathAngle(2,2))*sin(pathAngle(2,1));

targetP(5,1)=tempPoint(4,1)+L*sin(pathAngle(1,2));
targetP(5,2)=tempPoint(4,2)-L*cos(pathAngle(1,2))*cos(pathAngle(1,1));
targetP(6,1)=tempPoint(5,1)-L*sin(pathAngle(2,2));
targetP(6,2)=tempPoint(5,2)-L*cos(pathAngle(2,2))*cos(pathAngle(2,1));    

pathPoint=targetP;
function initialPath(pathAngle)
%该函数用于初始化点击路径规划
%L为电极的长度，一般显示在平面内要小于150mm
%Arc是鼻-后脑方向的角度
%Rad是矢状位的角度
%2017-02-10 万森
%因此在水平面内，x=stnL(1)-L*sin（Rad）,y=stnL(2)-L*cos(Rad)*sin(Arc)
%在冠状位内，x=stnL(1)-L*sin（Rad）,z=stnL(3)+L*cos(Rad)*sin(Arc)
global targetPoints;
% global maindir;
global lPath;
global rPath;

tempPoint=coordinateChange(targetPoints,1);
pathPoint=calThePath(pathAngle);
hold on;
lPath=plot([tempPoint(4,1),pathPoint(5,1)],[tempPoint(4,2),pathPoint(5,2)],'-.y');
hold on;
rPath=plot([tempPoint(5,1),pathPoint(6,1)],[tempPoint(5,2),pathPoint(6,2)],'-.y');
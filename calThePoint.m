function [L1,L2,pointInSlice]=calThePoint(maindir,pathAngle,handles)

%����������ڼ���·������ÿһ��ĵ������
%���������ͼ��ǣ�maindir��,��������꣨pathAngle��,�����targetPoint
%�Լ�������sliceIndex�������ڲ�׽��ǰ��
%���Ϊ�����������
%20170212��ɭ
global targetPoints;
tempPoint=coordinateChange(targetPoints,1);
pathAngle=deg2rad(pathAngle);
sliceP=zeros(2,2);


switch maindir
    case 1
        sliceIndex=str2double(get(handles.TX1,'String'));
        L1=(targetPoints(4,1)-sliceIndex)/cos(pathAngle(1,2));
        sliceP(1,1)=tempPoint(4,2)+L1*cos(pathAngle(1,2))*cos(pathAngle(1,1));
        sliceP(1,2)=tempPoint(4,3)-L1*cos(pathAngle(1,2))*sin(pathAngle(1,1));
        L2=(sliceIndex-targetPoints(5,1))/cos(pathAngle(2,2));
        sliceP(2,1)=tempPoint(5,2)+L2*cos(pathAngle(2,2))*cos(pathAngle(2,1));
        sliceP(2,2)=tempPoint(5,3)-L2*cos(pathAngle(2,2))*sin(pathAngle(2,1));
    case 2
        sliceIndex=str2double(get(handles.TY1,'String'));
        L1=(targetPoints(4,2)-sliceIndex)/(cos(pathAngle(1,2))*cos(pathAngle(1,1)));
        sliceP(1,1)=tempPoint(4,1)+L1*sin(pathAngle(1,2));
        sliceP(1,2)=tempPoint(4,3)-L1*cos(pathAngle(1,2))*sin(pathAngle(1,1));
        L2=(targetPoints(5,2)-sliceIndex)/(cos(pathAngle(2,2))*cos(pathAngle(2,1)));
        sliceP(2,1)=tempPoint(5,1)-L2*sin(pathAngle(2,2));
        sliceP(2,2)=tempPoint(5,3)-L2*cos(pathAngle(2,2))*sin(pathAngle(2,1));
    case 3
        sliceIndex=str2double(get(handles.TZ1,'String'));
        L1=(sliceIndex-targetPoints(4,3))/(cos(pathAngle(1,2))*sin(pathAngle(1,1)));
        sliceP(1,1)=tempPoint(4,1)+L1*sin(pathAngle(1,2));
        sliceP(1,2)=tempPoint(4,2)-L1*cos(pathAngle(1,2))*cos(pathAngle(1,1));
        L2=(sliceIndex-targetPoints(5,3))/(cos(pathAngle(2,2))*sin(pathAngle(2,1)));
        sliceP(2,1)=tempPoint(5,1)-L2*sin(pathAngle(2,2));
        sliceP(2,2)=tempPoint(5,2)-L2*cos(pathAngle(2,2))*cos(pathAngle(2,1));
end
pointInSlice=sliceP;
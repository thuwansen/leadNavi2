function pathPoint=calThePath(pathAngle)
%��������Ĺ���������STN������targetP���õ��滮�õ�����pathPoint;
%pathPoint����6�����꣬�ֱ���ʸ״λ��/�ң���״λ��/�Һ���λ��/�ҹ滮�õ�������̬��ͼ������
%maindir��־��ʾ��/��/ʸ��L����ʾ���ȣ�Arc��/���ԣ�Rad��/��
%2017-02-13��ɭ
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
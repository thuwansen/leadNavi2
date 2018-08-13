function initialPath(pathAngle)
%�ú������ڳ�ʼ�����·���滮
%LΪ�缫�ĳ��ȣ�һ����ʾ��ƽ����ҪС��150mm
%Arc�Ǳ�-���Է���ĽǶ�
%Rad��ʸ״λ�ĽǶ�
%2017-02-10 ��ɭ
%�����ˮƽ���ڣ�x=stnL(1)-L*sin��Rad��,y=stnL(2)-L*cos(Rad)*sin(Arc)
%�ڹ�״λ�ڣ�x=stnL(1)-L*sin��Rad��,z=stnL(3)+L*cos(Rad)*sin(Arc)
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
function targetLoc=findLoc(startLoc,Y)
%�ú��������������ó�ʼ��6��λ�õ��Լ�ͼ�񣬵õ�ͼ�������յ�6��λ�õ�
%���ڻ�ö�λ�������
%��ɭ2017/02/06

location=zeros(6,2);
for i=1:6
    aera=Y(startLoc(i,2)-20:startLoc(i,2)+20,startLoc(i,1)-20:startLoc(i,1)+20);
    hold on;
    temp=sort(aera(:));
    [m,n]=find(aera>=temp(length(temp)-5));
    LOCy=round(mean(m));
    LOCx=round(mean(n));
    location(i,1)=LOCx+startLoc(i,1)-21;
    location(i,2)=LOCy+startLoc(i,2)-21;
end
targetLoc=location;
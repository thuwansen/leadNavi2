function targetLoc=findLoc(startLoc,Y)
%该函数的作用是利用初始的6个位置点以及图像，得到图像上最终的6个位置点
%用于获得定位点的坐标
%万森2017/02/06

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
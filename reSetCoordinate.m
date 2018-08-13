function reSetCoordinate(tempI,flag)

% 本函数的目的是根据第一个页面得到的坐标，对所有页面的坐标进行校正，并将最终坐标放置在coordinatePoint中
% flag用于标记是向上读，还是向下读
global coordinatePoint;
global rCT;
global K;
temp=tempI-flag;
    for j=1:1:6
        i1=round(coordinatePoint(j,1,temp))-10;
        if i1<1 
            i1=1; 
        else if i1>576
            i1=576;
            end 
        end
        i2=round(coordinatePoint(j,1,temp))+10;
        if i2<1 
            i2=1; 
        else if i2>576
            i2=576;
            end 
        end
        
        i3=round(coordinatePoint(j,2,temp))-10;
        if i3<1 
            i3=1; 
        else if i3>576
            i3=576;
            end 
        end
        i4=round(coordinatePoint(j,2,temp))+10;
        if i4<1 
            i4=1; 
        else if i4>576
            i4=576;
            end 
        end
        
        myFig=rCT(i1:i2,i3:i4,(tempI)*K);
        myFig=squeeze(myFig);
        [locationX,locationY]=find(myFig>1.2*mean(mean(myFig)));
        tempM=[locationX,locationY];
        cor=mean(tempM);
        coordinatePoint(j,1,tempI)=cor(1);
        coordinatePoint(j,2,tempI)=cor(2);
    end
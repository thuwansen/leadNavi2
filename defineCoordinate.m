function defineCoordinate(A)
%该函数用于选取头架定位点，右键选取最近的点，左键将该点定位在所选的位置,并将之前的定位点去除
%2017-01-26-万森
global circle1;
global circle2;
global circle3;
global circle4;
global circle5;
global circle6;
global framePoints;
global slicenum;
global mouseFlag;

if strcmp(get(gcf,'selectiontype'),'alt') %如果按下右键，则选择附近的定位圈
        pt=get(gca,'CurrentPoint');
        x=pt(1,1);y=pt(1,2);
        lengthP=[abs(x-framePoints(1,1,slicenum))+abs(y-framePoints(1,2,slicenum)),...
            abs(x-framePoints(2,1,slicenum))+abs(y-framePoints(2,2,slicenum)),...
            abs(x-framePoints(3,1,slicenum))+abs(y-framePoints(3,2,slicenum)),...
            abs(x-framePoints(4,1,slicenum))+abs(y-framePoints(4,2,slicenum)),...
            abs(x-framePoints(5,1,slicenum))+abs(y-framePoints(5,2,slicenum)),...
            abs(x-framePoints(6,1,slicenum))+abs(y-framePoints(6,2,slicenum))];
        if min(lengthP)<80
            i=find(lengthP==min(lengthP));
            switch i
                case 1
                    mouseFlag=1;
                    delete(circle1);
                    circle1=plotCircle(A,framePoints(1,:,slicenum),1);
                case 2
                     mouseFlag=2;
                    delete(circle2);
                    circle2=plotCircle(A,framePoints(2,:,slicenum),1);
                case 3
                     mouseFlag=3;
                    delete(circle3);
                    circle3=plotCircle(A,framePoints(3,:,slicenum),1);  
                case 4
                     mouseFlag=4;
                    delete(circle4);
                    circle4=plotCircle(A,framePoints(4,:,slicenum),1);  
                case 5
                     mouseFlag=5;
                    delete(circle5);
                    circle5=plotCircle(A,framePoints(5,:,slicenum),1);
                case 6
                    mouseFlag=6;
                    delete(circle6);
                    circle6=plotCircle(A,framePoints(6,:,slicenum),1);
            end

        end
        
elseif strcmp(get(gcf,'selectiontype'),'normal')
        pt=get(gca,'CurrentPoint');
        x=pt(1,1);y=pt(1,2);z=slicenum;
            switch mouseFlag
                case 1
                    delete(circle1);
                    circle1=plotCircle(A,[x,y],0);
                    framePoints(1,1,z)=x;
                    framePoints(1,2,z)=y;
                case 2
                    delete(circle2);
                    circle2=plotCircle(A,[x,y],0); 
                    framePoints(2,1,z)=x;
                    framePoints(2,2,z)=y;
                case 3
                    delete(circle3);
                    circle3=plotCircle(A,[x,y],0); 
                    framePoints(3,1,z)=x;
                    framePoints(3,2,z)=y;
                case 4
                    delete(circle4);
                    circle4=plotCircle(A,[x,y],0);
                    framePoints(4,1,z)=x;
                    framePoints(4,2,z)=y;
                case 5
                    delete(circle5);
                    circle5=plotCircle(A,[x,y],0);
                    framePoints(5,1,z)=x;
                    framePoints(5,2,z)=y;
                case 6
                    delete(circle6);
                    circle6=plotCircle(A,[x,y],0);
                    framePoints(6,1,z)=x;
                    framePoints(6,2,z)=y;
            end

end

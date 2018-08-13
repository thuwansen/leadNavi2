function showAC(handles);

global indexAC;
global circleAC;
global flagAC;
global targetPoints;
global maindir;
global indexX;
global indexY;
global slicenum;

indexAC=targetPoints(1,:);
if ~isempty(indexAC);
    switch maindir;
        case 1;
            if indexX == targetPoints(1,1);
                axes(handles.mainView);
                circleAC = text(targetPoints(1,1),targetPoints(1,2),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagAC = text(targetPoints(1,1),targetPoints(1,2),'   AC', 'color', 'b');
            end
        case 2;
            if indexY == targetPoints(1,2);
                axes(handles.mainView);
                circleAC = text(targetPoints(1,1),targetPoints(1,2),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagAC = text(targetPoints(1,1),targetPoints(1,2),'   AC', 'color', 'b');
            end
        case 3;
            if slicenum == targetPoints(1,3);
                axes(handles.mainView);
                circleAC = text(targetPoints(1,1),targetPoints(1,2),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagAC = text(targetPoints(1,1),targetPoints(1,2),'   AC', 'color', 'b');
            end
    end
end
function showPC(handles);

global indexPC;
global circlePC;
global flagPC;
global targetPoints;
global maindir;
global indexX;
global indexY;
global slicenum;

indexPC=targetPoints(2,:);
if ~isempty(indexPC);
    switch maindir;
        case 1;
            if indexX == targetPoints(2,1);
                axes(handles.mainView);
                circlePC = text(targetPoints(2,1),targetPoints(2,2),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagPC = text(targetPoints(2,1),targetPoints(2,2),'   PC', 'color', 'b');
            end
        case 2;
            if indexY == targetPoints(2,2);
                axes(handles.mainView);
                circlePC = text(targetPoints(2,1),targetPoints(2,2),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagPC = text(targetPoints(2,1),targetPoints(2,2),'   PC', 'color', 'b');
            end
        case 3;
            if slicenum == targetPoints(2,3);
                axes(handles.mainView);
                circlePC = text(targetPoints(2,1),targetPoints(2,2),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagPC = text(targetPoints(2,1),targetPoints(2,2),'   PC', 'color', 'b');
            end
    end
end
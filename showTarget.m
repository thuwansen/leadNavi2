function showTarget(TPoints,handles)
%该函数用于展现新的目标点
%应用格式为ShowTarget('AC',handles)
%2017-02-08万森
global circleAC;
global flagAC;
global circlePC;
global flagPC;
global circleMR;
global flagMR;
global circleSTNl;
global flagSTNl;
global circleSTNr;
global flagSTNr;
global targetPoints;
global slicenum;
global maindir;
global indexX;
global indexY;
global myScale;


switch TPoints
    case 'AC'
        targetFlag=1;
        targetPointsTu=coordinateChange(targetPoints,1);
        switch maindir
            case 1
                if(str2double(get(handles.TX1,'String')))==round(targetPoints(targetFlag,1))
                    axes(handles.mainView);
                    circleAC = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                    flagAC = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'   AC', 'color', 'b');
                end                
            case 2
                if(str2double(get(handles.TY1,'String')))==round(targetPoints(targetFlag,2))
                    axes(handles.mainView);
                    circleAC = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                    flagAC = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'   AC', 'color', 'b');
                end  
            case 3
                 if(str2double(get(handles.TZ1,'String')))==round(targetPoints(targetFlag,3))
                    axes(handles.mainView);
                    circleAC = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'+', 'color', 'b','HorizontalAlignment','center'); 
                    flagAC = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'   AC', 'color', 'b');
                end
        end
    case 'PC'
        targetFlag=2;
        targetPointsTu=coordinateChange(targetPoints,1);
        switch maindir
            case 1
                if(str2double(get(handles.TX1,'String')))==round(targetPoints(targetFlag,1))
                    axes(handles.mainView);
                    circlePC = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                    flagPC = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'   PC', 'color', 'b');
                end                
            case 2
                if(str2double(get(handles.TY1,'String')))==round(targetPoints(targetFlag,2))
                    axes(handles.mainView);
                    circlePC = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                    flagPC = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'   PC', 'color', 'b');
                end  
            case 3
                 if(str2double(get(handles.TZ1,'String')))==round(targetPoints(targetFlag,3))
                    axes(handles.mainView);
                    circlePC = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'+', 'color', 'b','HorizontalAlignment','center'); 
                    flagPC = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'   PC', 'color', 'b');
                end
        end
    case 'MR'
        targetFlag=3;
        targetPointsTu=coordinateChange(targetPoints,1);
        switch maindir
            case 1
                if(str2double(get(handles.TX1,'String')))==round(targetPoints(targetFlag,1))
                    axes(handles.mainView);
                    circleMR = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                    flagMR = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'   MR', 'color', 'b');
                end                
            case 2
                if(str2double(get(handles.TY1,'String')))==round(targetPoints(targetFlag,2))
                    axes(handles.mainView);
                    circleMR = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                    flagMR = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'   MR', 'color', 'b');
                end  
            case 3
                 if(str2double(get(handles.TZ1,'String')))==round(targetPoints(targetFlag,3))
                    axes(handles.mainView);
                    circleMR = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'+', 'color', 'b','HorizontalAlignment','center'); 
                    flagMR = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'   MR', 'color', 'b');
                end
        end
    case 'STNl'
        targetFlag=4;
        targetPointsTu=coordinateChange(targetPoints,1);
        switch maindir
            case 1
                if(str2double(get(handles.TX1,'String')))==round(targetPoints(targetFlag,1))
                    axes(handles.mainView);
                    circleSTNl = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                    flagSTNl = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'   STNl', 'color', 'b');
                end                
            case 2
                if(str2double(get(handles.TY1,'String')))==round(targetPoints(targetFlag,2))
                    axes(handles.mainView);
                    circleSTNl = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                    flagSTNl = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'   STNl', 'color', 'b');
                end  
            case 3
                 if(str2double(get(handles.TZ1,'String')))==round(targetPoints(targetFlag,3))
                    axes(handles.mainView);
                    circleSTNl = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'+', 'color', 'b','HorizontalAlignment','center'); 
                    flagSTNl = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'   STNl', 'color', 'b');
                end
        end
    case 'STNr'
        targetFlag=5;
        targetPointsTu=coordinateChange(targetPoints,1);
        switch maindir
            case 1
                if(str2double(get(handles.TX1,'String')))==round(targetPoints(targetFlag,1))
                    axes(handles.mainView);
                    circleSTNr = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                    flagSTNr = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'   STNr', 'color', 'b');
                end                
            case 2
                if(str2double(get(handles.TY1,'String')))==round(targetPoints(targetFlag,2))
                    axes(handles.mainView);
                    circleSTNr = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                    flagSTNr = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'   STNr', 'color', 'b');
                end  
            case 3
                 if(str2double(get(handles.TZ1,'String')))==round(targetPoints(targetFlag,3))
                    axes(handles.mainView);
                    circleSTNr = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'+', 'color', 'b','HorizontalAlignment','center'); 
                    flagSTNr = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'   STNr', 'color', 'b');
                end
        end      
end
function delShowTarget(TPoints,handles)
%�ú�������ɾ��Ŀ��㣬��ȷ���µ�Ŀ���
%Ӧ�ø�ʽΪdelShowTarget('AC',handles)
%2017-02-08��ɭ

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
global maindir;
global indexX;
global indexY;
global slicenum;
global myScale;

%-----------------�˴���̫ͨ�ã���Ҫ��ͨ�����޸�-----------������----
global voxsize_ref;
% myscale=voxsize_ref(3)/voxsize_ref(1);

switch TPoints
    case 'AC'
        targetFlag=1;
        switch maindir;
            case 1;
                if(str2double(get(handles.TX1,'String')))==round(targetPoints(targetFlag,1))
                    delete(circleAC);
                    delete(flagAC);
                end
                axes(handles.mainView);
                x=str2double(get(handles.TX1,'String'));
                y=str2double(get(handles.TY1,'String'));
                z=str2double(get(handles.TZ1,'string'));
                targetPoints(targetFlag,:)=[x,y,z];
                targetPointsTu=coordinateChange(targetPoints,1);
                circleAC = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagAC = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'   AC', 'color', 'b');
            case 2;
                if(str2double(get(handles.TY1,'String')))==round(targetPoints(targetFlag,2))
                    delete(circleAC);
                    delete(flagAC);
                end
                axes(handles.mainView);
                x=str2double(get(handles.TX1,'String'));
                y=str2double(get(handles.TY1,'String'));
                z=str2double(get(handles.TZ1,'string'));
                targetPoints(targetFlag,:)=[x,y,z];
                targetPointsTu=coordinateChange(targetPoints,1);
                circleAC = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagAC = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'   AC', 'color', 'b');
            case 3;
                if(str2double(get(handles.TZ1,'String')))==round(targetPoints(targetFlag,3))
                    delete(circleAC);
                    delete(flagAC);
                end
                axes(handles.mainView);
                x=str2double(get(handles.TX1,'String'));
                y=str2double(get(handles.TY1,'String'));
                z=str2double(get(handles.TZ1,'string'));
                targetPoints(targetFlag,:)=[x,y,z];
                targetPointsTu=coordinateChange(targetPoints,1);
                circleAC = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagAC = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'   AC', 'color', 'b');
        end   
    case 'PC'
        targetFlag=2;
        switch maindir;
            case 1;
                if(str2double(get(handles.TX1,'String')))==round(targetPoints(targetFlag,1))
                    delete(circlePC);
                    delete(flagPC);
                end
                axes(handles.mainView);
                x=str2double(get(handles.TX1,'String'));
                y=str2double(get(handles.TY1,'String'));
                z=str2double(get(handles.TZ1,'string'));
                targetPoints(targetFlag,:)=[x,y,z];
                targetPointsTu=coordinateChange(targetPoints,1);
                circlePC = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagPC = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'   PC', 'color', 'b');
            case 2;
                if(str2double(get(handles.TY1,'String')))==round(targetPoints(targetFlag,2))
                    delete(circlePC);
                    delete(flagPC);
                end
                axes(handles.mainView);
                x=str2double(get(handles.TX1,'String'));
                y=str2double(get(handles.TY1,'String'));
                z=str2double(get(handles.TZ1,'string'));
                targetPoints(targetFlag,:)=[x,y,z];
                targetPointsTu=coordinateChange(targetPoints,1);
                circlePC = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagPC = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'   PC', 'color', 'b');
            case 3;
                if(str2double(get(handles.TZ1,'String')))==round(targetPoints(targetFlag,3))
                    delete(circlePC);
                    delete(flagPC);
                end
                axes(handles.mainView);
                x=str2double(get(handles.TX1,'String'));
                y=str2double(get(handles.TY1,'String'));
                z=str2double(get(handles.TZ1,'string'));
                targetPoints(targetFlag,:)=[x,y,z];
                targetPointsTu=coordinateChange(targetPoints,1);
                circlePC = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagPC = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'   PC', 'color', 'b');
        end  
    case 'MR'
        targetFlag=3;
        switch maindir;
            case 1;
                if(str2double(get(handles.TX1,'String')))==round(targetPoints(targetFlag,1))
                    delete(circleMR);
                    delete(flagMR);
                end
                axes(handles.mainView);
                x=str2double(get(handles.TX1,'String'));
                y=str2double(get(handles.TY1,'String'));
                z=str2double(get(handles.TZ1,'string'));
                targetPoints(targetFlag,:)=[x,y,z];
                targetPointsTu=coordinateChange(targetPoints,1);
                circleMR = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagMR = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'   MR', 'color', 'b');
            case 2;
                if(str2double(get(handles.TY1,'String')))==round(targetPoints(targetFlag,2))
                    delete(circleMR);
                    delete(flagMR);
                end
                axes(handles.mainView);
                x=str2double(get(handles.TX1,'String'));
                y=str2double(get(handles.TY1,'String'));
                z=str2double(get(handles.TZ1,'string'));
                targetPoints(targetFlag,:)=[x,y,z];
                targetPointsTu=coordinateChange(targetPoints,1);
                circleMR = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagMR = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'   MR', 'color', 'b');
            case 3;
                if(str2double(get(handles.TZ1,'String')))==round(targetPoints(targetFlag,3))
                    delete(circleMR);
                    delete(flagMR);
                end
                axes(handles.mainView);
                x=str2double(get(handles.TX1,'String'));
                y=str2double(get(handles.TY1,'String'));
                z=str2double(get(handles.TZ1,'string'));
                targetPoints(targetFlag,:)=[x,y,z];
                targetPointsTu=coordinateChange(targetPoints,1);
                circleMR = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagMR = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'   MR', 'color', 'b');
        end   
    case 'STNl'
        targetFlag=4;
        switch maindir;
            case 1;
                if(str2double(get(handles.TX1,'String')))==round(targetPoints(targetFlag,1))
                    delete(circleSTNl);
                    delete(flagSTNl);
                end
                axes(handles.mainView);
                x=str2double(get(handles.TX1,'String'));
                y=str2double(get(handles.TY1,'String'));
                z=str2double(get(handles.TZ1,'string'));
                targetPoints(targetFlag,:)=[x,y,z];
                targetPointsTu=coordinateChange(targetPoints,1);
                circleSTNl = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagSTNl = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'   STNl', 'color', 'b');
            case 2;
                if(str2double(get(handles.TY1,'String')))==round(targetPoints(targetFlag,2))
                    delete(circleSTNl);
                    delete(flagSTNl);
                end
                axes(handles.mainView);
                x=str2double(get(handles.TX1,'String'));
                y=str2double(get(handles.TY1,'String'));
                z=str2double(get(handles.TZ1,'string'));
                targetPoints(targetFlag,:)=[x,y,z];
                targetPointsTu=coordinateChange(targetPoints,1);
                circleSTNl = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagSTNl = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'   STNl', 'color', 'b');
            case 3;
                if(str2double(get(handles.TZ1,'String')))==round(targetPoints(targetFlag,3))
                    delete(circleSTNl);
                    delete(flagSTNl);
                end
                axes(handles.mainView);
                x=str2double(get(handles.TX1,'String'));
                y=str2double(get(handles.TY1,'String'));
                z=str2double(get(handles.TZ1,'string'));
                targetPoints(targetFlag,:)=[x,y,z];
                targetPointsTu=coordinateChange(targetPoints,1);
                circleSTNl = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagSTNl = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'   STNl', 'color', 'b');
        end  
    case 'STNr'
        targetFlag=5;
        switch maindir;
            case 1;
                if(str2double(get(handles.TX1,'String')))==round(targetPoints(targetFlag,1))
                    delete(circleSTNr);
                    delete(flagSTNr);
                end
                axes(handles.mainView);
                x=str2double(get(handles.TX1,'String'));
                y=str2double(get(handles.TY1,'String'));
                z=str2double(get(handles.TZ1,'string'));
                targetPoints(targetFlag,:)=[x,y,z];
                targetPointsTu=coordinateChange(targetPoints,1);
                circleSTNr = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagSTNr = text(targetPointsTu(targetFlag,2),targetPointsTu(targetFlag,3),'   STNr', 'color', 'b');
            case 2;
                if(str2double(get(handles.TY1,'String')))==round(targetPoints(targetFlag,2))
                    delete(circleSTNr);
                    delete(flagSTNr);
                end
                axes(handles.mainView);
                x=str2double(get(handles.TX1,'String'));
                y=str2double(get(handles.TY1,'String'));
                z=str2double(get(handles.TZ1,'string'));
                targetPoints(targetFlag,:)=[x,y,z];
                targetPointsTu=coordinateChange(targetPoints,1);
                circleSTNr = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagSTNr = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,3),'   STNr', 'color', 'b');
            case 3;
                if(str2double(get(handles.TZ1,'String')))==round(targetPoints(targetFlag,3))
                    delete(circleSTNr);
                    delete(flagSTNr);
                end
                axes(handles.mainView);
                x=str2double(get(handles.TX1,'String'));
                y=str2double(get(handles.TY1,'String'));
                z=str2double(get(handles.TZ1,'string'));
                targetPoints(targetFlag,:)=[x,y,z];
                targetPointsTu=coordinateChange(targetPoints,1);
                circleSTNr = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'+', 'color', 'b','HorizontalAlignment','center'); 
                flagSTNr = text(targetPointsTu(targetFlag,1),targetPointsTu(targetFlag,2),'   STNr', 'color', 'b');
        end   
end

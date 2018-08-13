function CurPosShow(OpSet)
% Show (On/Off) the Cursor Position on the Current Axes
% OpSet = 'on' or 'off'
% the axes tag is '**n' ,and textbox' tag should be 'TXn' and 'TYn'
% 将坐标显示调整为标准样式，即定义：
%(左耳-右耳)（Xmin->Xmax）
%(鼻子->后脑)（Ymin->Ymax）
%(下巴->头顶)（Zmin->Zmax）
% 万森2017-2-9
global maindir;
global voxsize_ref;
global ref_hdr;
sizeOfRef=ref_hdr.dim;
sizeOfRef(3)=sizeOfRef(3)*voxsize_ref(3)/voxsize_ref(1);

handles=guidata(gcbo);                                    % get handles
X=get(gca,'XLim');                                             % x range of current axes 
Xmin=X(1);
Xmax=X(2);
Y=get(gca,'YLim');                                              % y range of current axes 
Ymin=Y(1);
Ymax=Y(2);

hTX=findobj(gcf,'tag','TX1');        % find correspond text box x
hTY=findobj(gcf,'tag','TY1');         % find correspond text box y
hTZ=findobj(gcf,'tag','TZ1');
%-------------------------------------万森2017-2-7注释掉下面一行------------------
% set(gcf,'windowbuttonmotionfcn','');                  % dissable all callback in figure
set(gcf,'windowbuttonmotionfcn','CurPosShow on');   % set callback when mouse move
set(gcf,'pointer','fullcrosshair'); %关于指针形状，见链接http://www.ilovematlab.cn/thread-67126-1-1.html
switch OpSet
case 'on'
   curPos = get(gca, 'CurrentPoint');
%对curPos进行矫正
%定义(左耳-右耳)（Xmin->Xmax）
%(鼻子->后脑)（Ymin->Ymax）
%(下巴->头顶)（Zmin->Zmax）
%在轴状位的图中，Xtu=size(1)-Xreal,Y=Y,Z=Z;
%在冠状位的图中，Xtu=size(1)-Xreal,Ytu=size(2)-Yreal，Ztu=size(3)-Zreal
%在矢状位中，Xtu=size(1)-Xreal,Ytu=size(2)-Yreal，Ztu=size(3)-Zreal
   switch maindir
       case 1
           curPos(1,1)=sizeOfRef(2)-curPos(1,1);
           curPos(1,2)=sizeOfRef(3)-curPos(1,2);  
       case 2
           curPos(1,1)=sizeOfRef(1)-curPos(1,1);
           curPos(1,2)=sizeOfRef(3)-curPos(1,2);
       case 3 
           curPos(1,1)=sizeOfRef(1)-curPos(1,1);
           curPos(1,2)=curPos(1,2);
   end

   pX=max([Xmin curPos(1,1)]);
   pX=min([Xmax pX]);
   pY=max([Ymin curPos(1,2)]);
   pY=min([Ymax pY]);
   switch maindir;
       case 1;
            set(hTY,'String',pX);
            set(hTZ,'String',pY); 
       case 2;
            set(hTX,'String',pX);
            set(hTZ,'String',pY); 
       case 3;
            set(hTX,'String',pX);
            set(hTY,'String',pY); 
   end

case 'off' 
    set(gcf,'windowbuttonmotionfcn','');             % dissable callback
    set(gcf,'pointer','arrow'); %关于指针形状，见链接http://www.ilovematlab.cn/thread-67126-1-1.html
end
guidata(gcbo,handles);                              % save handles (refresh)gui
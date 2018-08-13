function showhTXYZ();

global indexX;
global indexY;
global slicenum;
global hTX;
global hTY;
global hTZ;

hTX=findobj(gcf,'tag','TX1');
set(hTX,'String',indexX);
hTY=findobj(gcf,'tag','TY1');
set(hTY,'String',indexY);
hTZ=findobj(gcf,'tag','TZ1');
set(hTZ,'String',slicenum);
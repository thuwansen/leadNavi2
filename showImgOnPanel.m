function showImgOnPanel(A,B,degree,P)

global rCT;
rCT=A;
global rT2;
rT2=B;
global transDegree;
transDegree=degree;
global x_Img;
x_Img=P(1);
global y_Img;
y_Img=P(2);
global z_Img;
z_Img=P(3);
[axisImg,corImg,sagImg]=splitImg(rCT,rT2,transDegree,[x_Img,y_Img,z_Img]);
axes(handles.axes3);
imshow(axisImg,[]);
axes(handles.axes2);
imshow(sagImg,[]);
axes(handles.axes1);
imshow(corImg,[]);
guidata(hObject,handles);
function varargout = leadNavi(varargin)
% LEADNAVI MATLAB code for leadNavi.fig
%      LEADNAVI, by itself, creates a new LEADNAVI or raises the existing
%      singleton*.
%
%      H = LEADNAVI returns the handle to a new LEADNAVI or the handle to
%      the existing singleton*.
%
%      LEADNAVI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LEADNAVI.M with the given input arguments.
%
%      LEADNAVI('Property','Value',...) creates a new LEADNAVI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before leadNavi_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to leadNavi_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help leadNavi

% Last Modified by GUIDE v2.5 11-Feb-2017 17:59:04

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @leadNavi_OpeningFcn, ...
    'gui_OutputFcn',  @leadNavi_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});pro
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before leadNavi is made Visible.
function leadNavi_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to leadNavi (see VARARGIN)

clear global;
global stepFlag;
stepFlag=1;
global setPointFlag;
setPointFlag=0;
global targetPoints;
targetPoints=zeros(5,3);
global slicenum_correct;
global myScale;
global pathAngle;
pathAngle=[0,45;0,45];
% Choose default command line output for leadNavi
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes leadNavi wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = leadNavi_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
javaFrame = get(gcf,'JavaFrame');
set(javaFrame,'Maximized',1);

% --- Executes on button press in loadFile.
function loadFile_Callback(hObject, eventdata, handles)
% hObject    handle to loadFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global filePath;
filePath=uigetdir({},'选择图像文件夹');
fileName=dir([filePath,'\*.nii']);

set(handles.codeState,'BackgroundColor',[1,0,0]);
guidata(hObject,handles);

a='';
for j=1:length(fileName)
    a=[a,'|',fileName(j).name];
end
a=a(2:length(a));
set(handles.listOfFiles,'String',a);

pause(0.1);

global ref_hdr;
global ref_img;
global ref_range;
global mov_hdr_orig;
global mov_hdr;
global mov_img;
global mov_range;
global slicenum;
global indexX;
global indexY;
global showMR;
global voxsize_ref;
global voxsize_mov;
global axisImg;
global sagImg;
global corImg;
global mainImg;
global maindir;
global transDegree;
global mainViewH;
global hT;
global showhT;
global indexAC;
global hAC;
global indexPC;
global hPC;
global indexSTN_L;
global hSTN_L;
global indexSTN_R;
global hSTN_R;
global framePoints;
global mouseFlag;%目的是看鼠标点了哪个定位圈
global setNaviPara; %第三步的按键没有按下
setNaviPara=0;
mouseFlag=1;

showMR =0;

ref_hdr = spm_vol([filePath, '\T2.nii']);
ref_img = spm_read_vols(ref_hdr);
mov_hdr = spm_vol([filePath, '\CT.nii']);
mov_hdr_orig = mov_hdr;
mov_img = spm_read_vols(mov_hdr);
ref_range = [prctile(ref_img(:), 3), prctile(ref_img(:), 97)];
mov_range = [prctile(mov_img(:), 3), prctile(mov_img(:), 97)];


[~, trans_ref] = qr(ref_hdr.mat);
voxsize_ref = abs(round(diag(trans_ref)*10)/10);
voxsize_ref = voxsize_ref(1:3);
global myScale;
myScale=voxsize_ref(3)/voxsize_ref(1);

[~, trans_mov] = qr(mov_hdr.mat);
voxsize_mov = abs(round(diag(trans_mov)*10)/10);
voxsize_mov = voxsize_mov(1:3);

geometry_trans = ref_hdr.mat*[(ref_hdr.dim.'+[1; 1; 1])/2; 1]-...
    mov_hdr_orig.mat*[(mov_hdr_orig.dim.'+[1; 1; 1])/2; 1];
geometry_params = [0, 0, 0, 0, 0, 0];
geometry_params(1:3) = geometry_trans(1:3);
mov_hdr.mat = spm_matrix(geometry_params)*mov_hdr.mat;

transDegree=0.5;

maindir = 3;
framePoints=zeros(6,2,mov_hdr.dim(3));
defaultPoints=[50,50;50,150;50,250;450,50;450,150;450,250];
for i=1:mov_hdr.dim(3)
    framePoints(:,:,i)=defaultPoints;
end


slicenum = round(mov_hdr.dim(3)/2);
axes(handles.axes3);
axisImg = imageshow('','', mov_hdr, mov_img, round(mov_hdr.dim(3)/2), transDegree, '', mov_range, 3);
axes3_H=imshow(axisImg);
set(axes3_H,'ButtonDownFcn',{@axes3_ButtonDownFcn,handles});

axes(handles.axes2);
sagImg = imageshow('', '', mov_hdr, mov_img, round(mov_hdr.dim(2)/2), transDegree, '', mov_range, 2);
axes2_H=imshow(sagImg);
set(axes2_H,'ButtonDownFcn',{@axes2_ButtonDownFcn,handles});

axes(handles.axes1);
corImg = imageshow('', '', mov_hdr, mov_img, round(mov_hdr.dim(1)/2), transDegree, '', mov_range, 1);
axes1_H=imshow(corImg);
set(axes1_H,'ButtonDownFcn',{@axes1_ButtonDownFcn,handles});

showhT = 0;
axes(handles.mainView);
mainImg=axisImg;
mainViewH=imshow(mainImg);
set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});

% indexX = 50;
% indexY = 50;
% axes(handles.mainView);
% hT = text(0, 0, 'inithT', 'color', 'b');
% hT.Visible = 'off';
% 
% indexAC = [0,0,0];
% hAC = text(0, 0, 'initAC', 'color', 'r');
% hAC.Visible = 'off';
% 
% indexPC = [0,0,0];
% hPC = text(0, 0, 'initPC', 'color', 'r');
% hPC.Visible = 'off';
% 
% indexSTN_L = [0,0,0];
% hSTN_L = text(0, 0, 'initSTN_L', 'color', 'y');
% hSTN_L.Visible = 'off';
% 
% indexSTN_R = [0,0,0];
% hSTN_R = text(0, 0, 'initSTN_R', 'color', 'y');
% hSTN_R.Visible = 'off';
% 
% showhTXYZ();

set(handles.codeState,'BackgroundColor',[0,0,0]);%将程序状态标志位设置为黑色
guidata(hObject,handles);

% --- Executes on button press in coreg.
function coreg_Callback(hObject, eventdata, handles)
% hObject    handle to coreg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filePath;
global ref_hdr;
global ref_img;
global ref_range;
global mov_hdr;
global mov_hdr_orig;
global mov_img;
global mov_range;
global axisImg;
global sagImg;
global corImg;
global mainImg;
global maindir;
global showMR;
global slicenum;
global transDegree;
global mainViewH;
global indexX;
global indexY;
global hT;
global showhT;

maindir = 3;
showMR = 1;

set(handles.codeState,'BackgroundColor',[1,0,0]);

pause(0.1);

mov_reg2_ref = init_coreg({[filePath, '\CT.nii'], [filePath, '\T2.nii']});
mov_hdr.mat =mov_reg2_ref*mov_hdr_orig.mat;

pause(0.1);

slicenum=round(get(handles.sliderAxis,'Value')*mov_hdr.dim(3));
transDegree = get(handles.sliderTrans,'Value');



axes(handles.axes3);
axisImg = imageshow(mov_hdr, mov_img,ref_hdr, ref_img, ...
    round(ref_hdr.dim(3)/2), 0.5,mov_range, ref_range, 3);
axes3_H=imshow(axisImg);
set(axes3_H,'ButtonDownFcn',{@axes3_ButtonDownFcn,handles});

axes(handles.axes2);
sagImg = imageshow(mov_hdr, mov_img,ref_hdr, ref_img, ...
    round(ref_hdr.dim(2)/2), 0.5, mov_range, ref_range, 2);
axes2_H=imshow(sagImg);
set(axes2_H,'ButtonDownFcn',{@axes2_ButtonDownFcn,handles});

axes(handles.axes1);
corImg = imageshow( mov_hdr, mov_img,ref_hdr, ref_img,...
    round(ref_hdr.dim(1)/2), 0.5, mov_range, ref_range, 1);
axes1_H=imshow(corImg);
set(axes1_H,'ButtonDownFcn',{@axes1_ButtonDownFcn,handles});
axes(handles.mainView);
mainImg = imageshow(mov_hdr, mov_img,ref_hdr, ref_img, ...
    slicenum, transDegree,mov_range, ref_range, 3);
mainViewH = imshow(mainImg);
set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});

showhT = 0;
indexX = 0;
indexY = 0;

axes(handles.mainView);
hT = text(0, 0, 'inithT', 'color', 'b');
hT.Visible = 'off';

showhTXYZ();

showAC(handles);
showPC(handles);
showSTN_L(handles);
showSTN_R(handles);

set(handles.codeState,'BackgroundColor',[0,0,0]);
guidata(hObject,handles);


function TX1_Callback(hObject, eventdata, handles)
% hObject    handle to TX1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TX1 as text
%        str2double(get(hObject,'String')) returns contents of TX1 as a double

% --- Executes during object creation, after setting all properties.
function TX1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TX1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function TY1_Callback(hObject, eventdata, handles)
% hObject    handle to TY1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TY1 as text
%        str2double(get(hObject,'String')) returns contents of TY1 as a double


% --- Executes during object creation, after setting all properties.
function TY1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TY1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function TZ1_Callback(hObject, eventdata, handles)
% hObject    handle to TZ1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TZ1 as text
%        str2double(get(hObject,'String')) returns contents of TZ1 as a double

% --- Executes during object creation, after setting all properties.
function TZ1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TZ1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function sliderTrans_Callback(hObject, eventdata, handles)
% hObject    handle to sliderTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns Position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global transDegree;
global ref_hdr;
global ref_img;
global ref_range;
global mov_hdr;
global mov_img;
global mov_range;
global slicenum;
global axisImg;
global sagImg;
global corImg;
global mainImg;
global mainViewH;
global maindir;
global indexX;
global indexY;
global showMR;
global stepFlag;

if stepFlag==3&&showMR==1;
transDegree=get(hObject,'Value');

    switch maindir;
        case 1;
            axes(handles.mainView);
            indexX=round(get(handles.sliderAxis,'Value')*mov_hdr.dim(1));
            mainImg = imageshow(mov_hdr, mov_img,ref_hdr, ref_img, ...
                indexX, transDegree, mov_range, ref_range, maindir);
        case 2;
            axes(handles.mainView);
            indexY=round(get(handles.sliderAxis,'Value')*mov_hdr.dim(2));
            mainImg = imageshow(mov_hdr, mov_img,ref_hdr, ref_img, ...
                indexY, transDegree, mov_range, ref_range, maindir);
        case 3;
            axes(handles.mainView);
            slicenum=round(get(handles.sliderAxis,'Value')*mov_hdr.dim(3));
            mainImg = imageshow(mov_hdr, mov_img, ref_hdr, ref_img, ...
                slicenum, transDegree, mov_range, ref_range, maindir);
    end
    
    mainViewH = imshow(mainImg);
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});
%     showhT_auto(handles);
%     showAC(handles);
%     showPC(handles);
%     showSTN_L(handles);
%     showSTN_R(handles);
    
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sliderTrans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function showFiles_Callback(hObject, eventdata, handles)
% hObject    handle to showFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of showFiles as text
%        str2double(get(hObject,'String')) returns contents of showFiles as a double

% --- Executes during object creation, after setting all properties.
function showFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to showFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listOfFiles.
function listOfFiles_Callback(hObject, eventdata, handles)
% hObject    handle to listOfFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listOfFiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listOfFiles

% --- Executes during object creation, after setting all properties.
function listOfFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listOfFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in nii1.
function nii1_Callback(hObject, eventdata, handles)
% hObject    handle to nii1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of nii1

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
set(hObject,'xTick',[]);
set(hObject,'ytick',[]);
set(hObject,'box','on');

% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2
set(hObject,'xTick',[]);
set(hObject,'ytick',[]);
set(hObject,'box','on');

% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3
set(hObject,'xTick',[]);
set(hObject,'ytick',[]);
set(hObject,'box','on');
% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over sliderTrans.

function sliderTrans_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to sliderTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on slider movement.
function sliderAxis_Callback(hObject, eventdata, handles)
% hObject    handle to sliderAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns Position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global transDegree;
global ref_hdr;
global ref_img;
global ref_range;
global mov_hdr;
global mov_img;
global mov_range;
global slicenum;
global indexX;
global indexY;
global mainImg;
global maindir;
global mainViewH;
global circle1;
global circle2;
global circle3;
global circle4;
global circle5;
global circle6;
global framePoints;
global stepFlag;
global slicenum_correct;
global myScale;

if stepFlag==2
    slicenum=round(get(handles.sliderAxis,'Value')*mov_hdr.dim(3));
    mainImg = imageshow([], [], mov_hdr, mov_img, slicenum, transDegree, [], mov_range, 3);
    axes(handles.mainView);
    mainViewH = imshow(mainImg);
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});
    hold on;
    circle1=plotCircle(handles.mainView,framePoints(1,:,slicenum),0);
    hold on;
    circle2=plotCircle(handles.mainView,framePoints(2,:,slicenum),0);
    hold on;
    circle3=plotCircle(handles.mainView,framePoints(3,:,slicenum),0);
    hold on;
    circle4=plotCircle(handles.mainView,framePoints(4,:,slicenum),0);
    hold on;
    circle5=plotCircle(handles.mainView,framePoints(5,:,slicenum),0);
    hold on;
    circle6=plotCircle(handles.mainView,framePoints(6,:,slicenum),0);
    hTZ=findobj(gcf,'tag','TZ1');
    set(hTZ,'String',slicenum);

end

if stepFlag==3 
    switch maindir;
        case 1;
            indexX = round(get(hObject,'Value')*mov_hdr.dim(1));
            mainImg = imageshow( mov_hdr, mov_img, ref_hdr, ref_img,...
                indexX, transDegree,mov_range, ref_range,  maindir);
        case 2;
            indexY = round(get(hObject,'Value')*mov_hdr.dim(2));
            mainImg = imageshow( mov_hdr, mov_img, ref_hdr, ref_img,...
                indexY, transDegree,mov_range, ref_range,  maindir);
        case 3;
            slicenum = round(get(hObject,'Value')*mov_hdr.dim(3));
            mainImg = imageshow( mov_hdr, mov_img, ref_hdr, ref_img,...
                slicenum, transDegree,mov_range, ref_range,  maindir);
    end
    
    axes(handles.mainView);
    mainViewH = imshow(mainImg);
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});
    
    switch maindir;
        case 1;
            indexY = 0;
            slicenum = 0;
        case 2;
            indexX = 0;
            slicenum = 0;
        case 3;
            indexX = 0;
            indexY = 0;
    end
end


if stepFlag==4
    
    switch maindir;
        case 1;
            set(handles.sliderAxis,'sliderstep',[0.011,0.11]);
            indexX=round(get(hObject,'Value')*ref_hdr.dim(1));
%             indexX = round((1-get(hObject,'Value'))*ref_hdr.dim(1));
            mainImg = imageshow([], [], ref_hdr, ref_img, indexX, ...
                0, [], ref_range, maindir);
            set(handles.TX1,'String',round((1-get(hObject,'Value'))*ref_hdr.dim(1)));
        case 2;
            set(handles.sliderAxis,'sliderstep',[0.011,0.11]);
            indexY = round(get(hObject,'Value')*ref_hdr.dim(2));
%             indexY = round((1-get(hObject,'Value'))*ref_hdr.dim(2));
            mainImg = imageshow([], [], ref_hdr, ref_img, indexY, ...
                0, [], ref_range, maindir);
            set(handles.TY1,'String',round((1-get(hObject,'Value'))*ref_hdr.dim(2)));
        case 3;
            set(handles.sliderAxis,'sliderstep',[1/ref_hdr.dim(3),0.1]);
            slicenum = round(get(hObject,'Value')*ref_hdr.dim(3));
            mainImg = imageshow([], [], ref_hdr, ref_img, slicenum, ...
                0, [], ref_range, maindir);            
            slicenum_correct=slicenum*myScale;
            set(handles.TZ1,'String',slicenum_correct);
    end
    
    axes(handles.mainView);
    mainViewH = imshow(mainImg); 
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});
    showTarget('AC',handles);
    showTarget('PC',handles);
    showTarget('MR',handles);
    showTarget('STNl',handles);
    showTarget('STNr',handles);
end

global pathPoint;
if stepFlag==5    
    plotPath(maindir,pathPoint,handles);
end

guidata(hObject,handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over sliderAxis.
function sliderAxis_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to sliderAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function codeState_CreateFcn(hObject, eventdata, handles)
% hObject    handle to codeState (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function mainView_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mainView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate mainView
set(hObject,'xTick',[]);
set(hObject,'ytick',[]);
set(hObject,'box','on');

% --- Executes on mouse press over axes background.
function mainView_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to mainView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global stepFlag;
global setPointFlag;
global targetPoints;
global circleAC;
global circlePC;
global circleMR;
global circleSTNl;
global circleSTNr;
global flagAC;
global flagPC;
global flagMR;
global flagSTNl;
global flagSTNr;
global slicenum;
if stepFlag==2
    defineCoordinate(handles.mainView);
end
if stepFlag==4
       switch setPointFlag;
           case 0;
               CurPosShow('off');
           case 1;
               delShowTarget('AC',handles);
               CurPosShow('off');
               set(handles.setAC,'BackgroundColor','blue');
           case 2;
               delShowTarget('PC',handles);
               CurPosShow('off');
               set(handles.setPC,'BackgroundColor','blue');
           case 3;
               delShowTarget('MR',handles);
               CurPosShow('off');
               set(handles.setMR,'BackgroundColor','blue');
           case 4;
               delShowTarget('STNl',handles);
               CurPosShow('off');
               set(handles.confirmSTN_L,'BackgroundColor','blue');
           case 5;
               delShowTarget('STNr',handles);
               CurPosShow('off');
               set(handles.confirmSTN_R,'BackgroundColor','blue');
       end
end


function myCallback(hObject, eventdata, handles)
% circle1=plotCircle(handles.mainView,[350,50]);
set(handles.codeState,'BackgroundColor',[1,0,0]);
global circle1;
delete(circle1);
hold on;
circle1=plotCircle(handles.mainView,[350,50],0);
guidata(hObject,handles)

function ImgButtonDown(hObject, eventdata, handles)
% CurPosShow('on');
% global buttonFlag;
% buttonFlag=1-buttonFlag;
% global i;
% defineCoordinate(buttonFlag);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over TX1.
function TX1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to TX1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in autoSTN_L.
function autoSTN_L_Callback(hObject, eventdata, handles)
% hObject    handle to autoSTN_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global indexAC;
global indexPC;
global indexSTN_L;
global ref_hdr;
global targetPoints;

indexAC=targetPoints(1,:);
indexPC=targetPoints(2,:);
if ~isequal(indexAC, [0, 0, 0]) && ~isequal(indexPC, [0, 0, 0]);
    diry = ref_hdr.mat*[(indexAC-indexPC).'; 0];
    diry = diry(1:3);
    diry = diry*(diry(2)>=0)/norm(diry);
    dirx = [diry(2), -diry(1), 0].';
    dirx = dirx*(dirx(1)>=0)/norm(dirx);
    dirz = [dirx(2)*diry(3)-dirx(3)*diry(2), dirx(3)*diry(1)-dirx(1)*diry(3), dirx(1)*diry(2)-dirx(2)*diry(1)].';
    dirz = dirz*(dirz(3)>=0)/norm(dirz);
    origin = ref_hdr.mat*[((indexAC+indexPC)/2).'; 1];
    indexSTN_L = inv(ref_hdr.mat)*[(origin(1:3)+9.5*dirx-0.5*diry-4.5*dirz); 1];
    indexSTN_L = round(indexSTN_L(1:3));
    indexSTN_L(3)=fix(indexSTN_L(3)/5)*5;
    targetPoints(4,:)=indexSTN_L;
%     delShowTarget('STNl',handles);
     showTarget('STNl',handles);
%     showSTN_L(handles);
end

% --- Executes on button press in autoSTN_R.
function autoSTN_R_Callback(hObject, eventdata, handles)
% hObject    handle to autoSTN_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global indexAC;
global indexPC;
global indexSTN_R;
global ref_hdr;
global targetPoints;
indexAC=targetPoints(1,:);
indexPC=targetPoints(2,:);
if ~isequal(indexAC, [0, 0, 0]) && ~isequal(indexPC, [0, 0, 0]);
    diry = ref_hdr.mat*[(indexAC-indexPC).'; 0];
    diry = diry(1:3);
    diry = diry*(diry(2)>=0)/norm(diry);
    dirx = [diry(2), -diry(1), 0].';
    dirx = dirx*(dirx(1)>=0)/norm(dirx);
    dirz = [dirx(2)*diry(3)-dirx(3)*diry(2), dirx(3)*diry(1)-dirx(1)*diry(3), dirx(1)*diry(2)-dirx(2)*diry(1)].';
    dirz = dirz*(dirz(3)>=0)/norm(dirz);
    origin = ref_hdr.mat*[((indexAC+indexPC)/2).'; 1];
    indexSTN_R = inv(ref_hdr.mat)*[(origin(1:3)-9.5*dirx-0.5*diry-4.5*dirz); 1];
    indexSTN_R = round(indexSTN_R(1:3));
    indexSTN_R(3)=fix(indexSTN_R(3)/5)*5;
    targetPoints(5,:)=indexSTN_R;
%     delShowTarget('STNr',handles);
     showTarget('STNr',handles);
%     showSTN_R(handles);
end

% --- Executes on button press in confirmSTN_L.
function confirmSTN_L_Callback(hObject, eventdata, handles)
% hObject    handle to confirmSTN_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global setPointFlag;
if setPointFlag==4
    setPointFlag=0;
else
    setPointFlag=4;%如果设定AC按下，则setPointFlag为1
end
if setPointFlag==4
    set(handles.confirmSTN_L,'BackgroundColor','red');
    axes(handles.mainView);
    CurPosShow('on');
elseif setPointFlag==0
    set(handles.confirmSTN_L,'BackgroundColor',[0.94,0.94,0.94]);
    CurPosShow('off');
end


% --- Executes on button press in confirmSTN_R.
function confirmSTN_R_Callback(hObject, eventdata, handles)
% hObject    handle to confirmSTN_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global setPointFlag;
if setPointFlag==5
    setPointFlag=0;
else
    setPointFlag=5;%如果设定AC按下，则setPointFlag为1
end
if setPointFlag==5
    set(handles.confirmSTN_R,'BackgroundColor','red');
    axes(handles.mainView);
    CurPosShow('on');
elseif setPointFlag==0
    set(handles.confirmSTN_R,'BackgroundColor',[0.94,0.94,0.94]);
    CurPosShow('off');
end

% --- Executes on button press in antoFrame.
function antoFrame_Callback(hObject, eventdata, handles)
% hObject    handle to antoFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.codeState,'BackgroundColor',[1,0,0]);
pause(0.5);
guidata(hObject,handles);
global framePoints;
global slicenum;
global mov_img;
global mov_hdr; 
startLoc=framePoints(:,:,slicenum);
targetLoc=findLoc(startLoc,rot90(mov_img(:,:,slicenum)));
framePoints(:,:,slicenum)=targetLoc;

maxD=mov_hdr.dim(3);
for j=slicenum:1:maxD-1
    startLoc=framePoints(:,:,j);
    Y_present=rot90(mov_img(:,:,j+1));
%     E=3;m=0.45;
%     Y_present=1./(1+(m./(double(Y_present)+eps)).^4E);
    targetLoc=findLoc(startLoc,Y_present);
    framePoints(:,:,j+1)=targetLoc;
    %如果上下两个点相距很近，则停止扫描
    length1=norm(framePoints(2,:,j+1)-framePoints(1,:,j+1));
    length2=norm(framePoints(2,:,j+1)-framePoints(3,:,j+1));
    length3=norm(framePoints(5,:,j+1)-framePoints(4,:,j+1));
    length4=norm(framePoints(5,:,j+1)-framePoints(6,:,j+1));
    minlength=min([length1,length2,length3,length4]);
    if minlength<30
        break;
    end
end

for j=slicenum:-1:1
    Y_present=rot90(mov_img(:,:,j-1));
    startLoc=framePoints(:,:,j);
    targetLoc=findLoc(startLoc,Y_present);
    framePoints(:,:,j-1)=targetLoc;
    length1=norm(framePoints(2,:,j+1)-framePoints(1,:,j+1));
    length2=norm(framePoints(2,:,j+1)-framePoints(3,:,j+1));
    length3=norm(framePoints(5,:,j+1)-framePoints(4,:,j+1));
    length4=norm(framePoints(5,:,j+1)-framePoints(6,:,j+1));
    minlength=min([length1,length2,length3,length4]);
    if minlength<30
        break;
    end
end
defineCoordinate(handles.mainView);
set(handles.codeState,'BackgroundColor',[0,0,0]);%将程序状态标志位设置为黑色
guidata(hObject,handles);


% --- Executes on button press in loadMR.
function loadMR_Callback(hObject, eventdata, handles)
% hObject    handle to loadMR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global showMR;
global stepFlag;
global transDegree;
global maindir;
global slicenum;
global indexX;
global indexY;
global ref_hdr;
global ref_img;
global mov_hdr;
global mov_img;
global ref_range;
global mov_range;


stepFlag=3;
showMR=1;
sliderTrans=findobj(gcf,'tag','sliderTrans');
set(sliderTrans,'Value',0.5);
transDegree=0.5;
maindir=3;

switch maindir;
        case 1;
            indexX = round(get(handles.sliderAxis,'Value')*mov_hdr.dim(1));
            mainImg = imageshow( mov_hdr, mov_img, ref_hdr, ref_img,...
                indexX, transDegree,mov_range, ref_range,  maindir);
        case 2;
            indexY = round(get(handles.sliderAxis,'Value')*mov_hdr.dim(2));
            mainImg = imageshow( mov_hdr, mov_img, ref_hdr, ref_img,...
                indexY, transDegree,mov_range, ref_range,  maindir);
        case 3;
            slicenum = round(get(handles.sliderAxis,'Value')*mov_hdr.dim(3));
            mainImg = imageshow( mov_hdr, mov_img, ref_hdr, ref_img,...
                slicenum, transDegree,mov_range, ref_range,  maindir);
end

axes(handles.mainView);
mainViewH = imshow(mainImg);
set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});

switch maindir;
    case 1;
        indexY = 0;
        slicenum = 0;
    case 2;
        indexX = 0;
        slicenum = 0;
    case 3;
        indexX = 0;
        indexY = 0;
end


% --- Executes on button press in setNavi.
function setNavi_Callback(hObject, eventdata, handles)
% hObject    handle to setNavi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%设置路径的步骤，只显示MR图像，将透明度归零
%三个axes也都改成MR的原图
global setNaviPara;
global stepFlag;
global transDegree;
global slicenum;
global ref_img;
global ref_hdr;
global ref_range;
global indexX;
global indexY;
global maindir;

setNaviPara=~setNaviPara;
stepFlag=4;
maindir=3;
% set(handles.sliderAxis,'value',0.5);
set(handles.sliderTrans,'value',1);
slicenum=round(ref_hdr.dim(3)*get(handles.sliderAxis,'Value'));
axisImg=imageshow([], [], ref_hdr, ref_img, slicenum, transDegree, [], ref_range, 3);
axes(handles.mainView);
hold off;
mainImg=axisImg;
mainViewH=imshow(mainImg);
set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});

axes(handles.axes3);
hold off;
axes3_H=imshow(mainImg);
set(axes3_H,'ButtonDownFcn',{@axes3_ButtonDownFcn,handles});

axes(handles.axes1);
hold off;
indexX=round(ref_hdr.dim(1)*get(handles.sliderAxis,'Value'));
sagImg=imageshow([], [], ref_hdr, ref_img, indexX, transDegree, [], ref_range,1);
axes1_H=imshow(sagImg);
set(axes1_H,'ButtonDownFcn',{@axes1_ButtonDownFcn,handles});

axes(handles.axes2);
hold off;
indexY=round(ref_hdr.dim(2)*get(handles.sliderAxis,'Value'));
corImg=imageshow([], [], ref_hdr, ref_img, indexY, transDegree, [], ref_range,2);
axes2_H=imshow(corImg);
set(axes2_H,'ButtonDownFcn',{@axes2_ButtonDownFcn,handles});

%设置初始化目标点
axes(handles.mainView);
showTarget('AC',handles);
showTarget('PC',handles);
showTarget('MR',handles);
showTarget('STNl',handles);
showTarget('STNr',handles);

% --- Executes on button press in setCoordinate.
function setCoordinate_Callback(hObject, eventdata, handles)
% hObject    handle to setCoordinate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stepFlag;
global slicenum;
global circle1;
global circle2;
global circle3;
global circle4;
global circle5;
global circle6;
global framePoints;
global mov_hdr;
global mov_img;
global transDegree;
global mov_range;

stepFlag=2;
slicenum=round(get(handles.sliderAxis,'Value')*mov_hdr.dim(3));
mainImg = imageshow([], [], mov_hdr, mov_img, slicenum, transDegree, [], mov_range, 3);
axes(handles.mainView);
mainViewH = imshow(mainImg);
set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});

hold on;
circle1=plotCircle(handles.mainView,framePoints(1,:,slicenum),0);
hold on;
circle2=plotCircle(handles.mainView,framePoints(2,:,slicenum),0);
hold on;
circle3=plotCircle(handles.mainView,framePoints(3,:,slicenum),0);
hold on;
circle4=plotCircle(handles.mainView,framePoints(4,:,slicenum),0);
hold on;
circle5=plotCircle(handles.mainView,framePoints(5,:,slicenum),0);
hold on;
circle6=plotCircle(handles.mainView,framePoints(6,:,slicenum),0);


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% function mainView_ButtonDownFcn(hObject, eventdata, handles)
global stepFlag;
global maindir;
global indexX;
global transDegree;
global mov_hdr;
global mov_img;
global ref_hdr;
global ref_img;
global mov_range;
global ref_range;
global mainViewH;

transDegree = get(handles.sliderTrans,'Value');
maindir=1;
if stepFlag==3
    indexX = round(get(handles.sliderAxis,'Value')*mov_hdr.dim(1));
    sagImg = imageshow( mov_hdr, mov_img, ref_hdr, ref_img,...
        indexX, transDegree,mov_range, ref_range,maindir);
    axes(handles.mainView);
    hold off;
    mainImg=sagImg;
    mainViewH=imshow(mainImg);
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});
end
if stepFlag==4
    axes(handles.mainView);
    hold off;
    indexX=round(ref_hdr.dim(1)*get(handles.sliderAxis,'Value'));
    set(handles.TX1,'String',round(ref_hdr.dim(1)*(1-get(handles.sliderAxis,'Value'))));
    sagImg=imageshow([], [], ref_hdr, ref_img, indexX, 1, [], ref_range,maindir);
    mainViewH=imshow(sagImg);
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});
    %设置初始化目标点
    axes(handles.mainView);
    showTarget('AC',handles);
    showTarget('PC',handles);
    showTarget('MR',handles);
    showTarget('STNl',handles);
    showTarget('STNr',handles);
end
    
global pathPoint;
if stepFlag==5
    axes(handles.mainView);
    hold off;
    indexX=round(ref_hdr.dim(1)*get(handles.sliderAxis,'Value'));
    set(handles.TX1,'String',round(ref_hdr.dim(1)*(1-get(handles.sliderAxis,'Value'))));
    sagImg=imageshow([], [], ref_hdr, ref_img, indexX, 1, [], ref_range,maindir);
    mainViewH=imshow(sagImg);
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});
    plotPath(maindir,pathPoint,handles);
end

% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stepFlag;
global maindir;
global indexY;
global transDegree;
global mov_hdr;
global mov_img;
global ref_hdr;
global ref_img;
global mov_range;
global ref_range;
global mainViewH;

transDegree = get(handles.sliderTrans,'Value');
maindir=2;

if stepFlag==3
    indexY = round(get(handles.sliderAxis,'Value')*mov_hdr.dim(2));
    corImg = imageshow( mov_hdr, mov_img, ref_hdr, ref_img,...
        indexY, transDegree,mov_range, ref_range,maindir);
    axes(handles.mainView);
    hold off;
    mainImg=corImg;
    mainViewH=imshow(mainImg);
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});
end

if stepFlag==4
    axes(handles.mainView);
    hold off;
    indexY=round(ref_hdr.dim(2)*get(handles.sliderAxis,'Value'));
    set(handles.TY1,'String',round(ref_hdr.dim(2)*(1-get(handles.sliderAxis,'Value'))));
    corImg=imageshow([], [], ref_hdr, ref_img, indexY, 1, [], ref_range,maindir);
    mainViewH=imshow(corImg);
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});
    showTarget('AC',handles);
    showTarget('PC',handles);
    showTarget('MR',handles);
    showTarget('STNl',handles);
    showTarget('STNr',handles);
end
global pathPoint;
if stepFlag==5
    axes(handles.mainView);
    hold off;
    indexY=round(ref_hdr.dim(2)*get(handles.sliderAxis,'Value'));
    set(handles.TY1,'String',round(ref_hdr.dim(2)*(1-get(handles.sliderAxis,'Value'))));
    corImg=imageshow([], [], ref_hdr, ref_img, indexY, 1, [], ref_range,maindir);
    mainViewH=imshow(corImg);
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});
    plotPath(maindir,pathPoint,handles);
end

% --- Executes on mouse press over axes background.
function axes3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stepFlag;
global maindir;
global slicenum;
global transDegree;
global mov_hdr;
global mov_img;
global ref_hdr;
global ref_img;
global mov_range;
global ref_range;
global mainViewH;
global myScale;

transDegree = get(handles.sliderTrans,'Value');
maindir=3;
if stepFlag==3
    slicenum = round(get(handles.sliderAxis,'Value')*mov_hdr.dim(3));
    axisImg = imageshow( mov_hdr, mov_img, ref_hdr, ref_img,...
        slicenum, transDegree,mov_range, ref_range,maindir);
    axes(handles.mainView);
    hold off;
    mainImg=axisImg;
    mainViewH=imshow(mainImg);
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});
end
if stepFlag==4
    axes(handles.mainView);
    hold off;
    slicenum=round(ref_hdr.dim(3)*get(handles.sliderAxis,'Value'));
    set(handles.TZ1,'String',slicenum*myScale);
    axisImg=imageshow([], [], ref_hdr, ref_img, slicenum, 1, [], ref_range,maindir);
    mainViewH=imshow(axisImg);
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});
    showTarget('AC',handles);
    showTarget('PC',handles);
    showTarget('MR',handles);
    showTarget('STNl',handles);
    showTarget('STNr',handles);
end
global pathPoint;
if stepFlag==5
    axes(handles.mainView);
    hold off;
    indexX=round(ref_hdr.dim(1)*get(handles.sliderAxis,'Value'));
    set(handles.TX1,'String',round(ref_hdr.dim(1)*(1-get(handles.sliderAxis,'Value'))));
    sagImg=imageshow([], [], ref_hdr, ref_img, indexX, 1, [], ref_range,maindir);
    mainViewH=imshow(sagImg);
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});
    plotPath(maindir,pathPoint,handles);
end

% --- Executes on button press in setAC.
function setAC_Callback(hObject, eventdata, handles)
% hObject    handle to setAC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global setPointFlag;
if setPointFlag==1
    setPointFlag=0;
else
    setPointFlag=1;%如果设定AC按下，则setPointFlag为1
end
if setPointFlag==1
    set(handles.setAC,'BackgroundColor','red');
    axes(handles.mainView);
    CurPosShow('on');
elseif setPointFlag==0
    set(handles.setAC,'BackgroundColor',[0.94,0.94,0.94]);
    CurPosShow('off');
end


% --- Executes on button press in setPC.
function setPC_Callback(hObject, eventdata, handles)
% hObject    handle to setPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global setPointFlag;
if setPointFlag==2
    setPointFlag=0;
else
    setPointFlag=2;%如果设定PC按下，则setPointFlag为2
end
if setPointFlag==2
    set(handles.setPC,'BackgroundColor','red');
    axes(handles.mainView);
    CurPosShow('on');
elseif setPointFlag==0
    set(handles.setPC,'BackgroundColor',[0.94,0.94,0.94]);
    CurPosShow('off');
end


% --- Executes on button press in setMR.
function setMR_Callback(hObject, eventdata, handles)
% hObject    handle to setMR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global setPointFlag;
if setPointFlag==3
    setPointFlag=0;
else
    setPointFlag=3;%如果设定PC按下，则setPointFlag为2
end
if setPointFlag==3
    set(handles.setMR,'BackgroundColor','red');
    axes(handles.mainView);
    CurPosShow('on');
elseif setPointFlag==0
    set(handles.setMR,'BackgroundColor',[0.94,0.94,0.94]);
    CurPosShow('off');
end


% --- Executes on button press in pathPlan.
function pathPlan_Callback(hObject, eventdata, handles)
% hObject    handle to pathPlan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stepFlag;
stepFlag=5;
global ref_hdr;
global ref_img;
global slicenum;
global ref_range;
global maindir;
global pathAngle;
global pathPoint;
% global targetPoints;
axes(handles.mainView);
mainImg = imageshow('', '',ref_hdr, ref_img, ...
    slicenum, '','', ref_range, maindir);
mainViewH = imshow(mainImg);
set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});
showTarget('AC',handles);
showTarget('PC',handles);
showTarget('MR',handles);
showTarget('STNl',handles);
showTarget('STNr',handles);
initialPath(pathAngle);
pathPoint=calThePath(pathAngle);
set(handles.editArcL,'String',pathAngle(1,1));
set(handles.editRadL,'String',pathAngle(1,2));
set(handles.editArcR,'String',pathAngle(2,1));
set(handles.editRadR,'String',pathAngle(2,2));


function editArcL_Callback(hObject, eventdata, handles)
% hObject    handle to editArcL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editArcL as text
%        str2double(get(hObject,'String')) returns contents of editArcL as a double


% --- Executes during object creation, after setting all properties.
function editArcL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editArcL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRadL_Callback(hObject, eventdata, handles)
% hObject    handle to editRadL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRadL as text
%        str2double(get(hObject,'String')) returns contents of editRadL as a double


% --- Executes during object creation, after setting all properties.
function editRadL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRadL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in leftPath.
function leftPath_Callback(hObject, eventdata, handles)
% hObject    handle to leftPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of leftPath


% --- Executes on button press in rightPath.
function rightPath_Callback(hObject, eventdata, handles)
% hObject    handle to rightPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rightPath



function editArcR_Callback(hObject, eventdata, handles)
% hObject    handle to editArcR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editArcR as text
%        str2double(get(hObject,'String')) returns contents of editArcR as a double


% --- Executes during object creation, after setting all properties.
function editArcR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editArcR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRadR_Callback(hObject, eventdata, handles)
% hObject    handle to editRadR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRadR as text
%        str2double(get(hObject,'String')) returns contents of editRadR as a double


% --- Executes during object creation, after setting all properties.
function editRadR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRadR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on editArcL and none of its controls.
function editArcL_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editArcL (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
global pathAngle;
global lPath;
global maindir;
global targetPoints;
global pathPoint;
pathPoint=calThePath(pathAngle);  
if strcmp(eventdata.Key,'return')
      pathAngle(1,1)=str2double(get(handles.editArcL,'String'));
%       delete(lPath);
%       tempPoint=coordinateChange(targetPoints,1);
      pathPoint=calThePath(pathAngle);
%       lPath=plot([tempPoint(4,1),pathPoint(5,1)],[tempPoint(4,2),pathPoint(5,2)],'-.y');
      plotPath(maindir,pathPoint,handles);
end


% --- Executes on key press with focus on editRadL and none of its controls.
function editRadL_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editRadL (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
global pathAngle;
global lPath;
global maindir;
global targetPoints;
global pathPoint;
pathPoint=calThePath(pathAngle); 
if strcmp(eventdata.Key,'return')
      pathAngle(1,2)=str2double(get(handles.editRadL,'String'));
%       delete(lPath);
%       tempPoint=coordinateChange(targetPoints,1);
      pathPoint=calThePath(pathAngle);
%       lPath=plot([tempPoint(4,1),pathPoint(5,1)],[tempPoint(4,2),pathPoint(5,2)],'-.y');
      plotPath(maindir,pathPoint,handles);
end


% --- Executes on key press with focus on editArcR and none of its controls.
function editArcR_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editArcR (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
global pathAngle;
global rPath;
global maindir;
global targetPoints;
global pathPoint;
pathPoint=calThePath(pathAngle); 
if strcmp(eventdata.Key,'return')
      pathAngle(2,1)=str2double(get(handles.editArcR,'String'));
%       delete(rPath);
%       tempPoint=coordinateChange(targetPoints,1);
      pathPoint=calThePath(pathAngle);
%       rPath=plot([tempPoint(5,1),pathPoint(6,1)],[tempPoint(5,2),pathPoint(6,2)],'-.y');      
      plotPath(maindir,pathPoint,handles);
end


% --- Executes on key press with focus on editRadR and none of its controls.
function editRadR_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editRadR (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
global pathAngle;
global rPath;
global maindir;
global targetPoints;
global pathPoint;
pathPoint=calThePath(pathAngle); 
if strcmp(eventdata.Key,'return')
      pathAngle(2,2)=str2double(get(handles.editRadR,'String'));
%       delete(rPath);
%       tempPoint=coordinateChange(targetPoints,1);
      pathPoint=calThePath(pathAngle);
%       rPath=plot([tempPoint(5,1),pathPoint(6,1)],[tempPoint(5,2),pathPoint(6,2)],'-.y');
      plotPath(maindir,pathPoint,handles);
end


% --- Executes during object creation, after setting all properties.
function sliderAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

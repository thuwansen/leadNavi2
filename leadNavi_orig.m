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

% Last Modified by GUIDE v2.5 09-Jan-2017 11:49:31

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

showMR = 1;

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

slicenum = round(ref_hdr.dim(3)/2);
axes(handles.axes3);
axisImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, round(ref_hdr.dim(3)/2), transDegree, ref_range, mov_range, 3);
imshow(axisImg); 
axes(handles.axes2);
sagImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, round(ref_hdr.dim(1)/2), transDegree, ref_range, mov_range, 1);
imshow(sagImg);
axes(handles.axes1);
corImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, round(ref_hdr.dim(2)/2), transDegree, ref_range, mov_range, 2);
imshow(corImg);

showhT = 0;
axes(handles.mainView);
mainImg=axisImg;
mainViewH=imshow(mainImg);
set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});

indexX = 0;
indexY = 0;

axes(handles.mainView);
hT = text(0, 0, 'inithT', 'color', 'b');
hT.Visible = 'off';

indexAC = [0,0,0];
hAC = text(0, 0, 'initAC', 'color', 'r');
hAC.Visible = 'off';

indexPC = [0,0,0];
hPC = text(0, 0, 'initPC', 'color', 'r');
hPC.Visible = 'off';

indexSTN_L = [0,0,0];
hSTN_L = text(0, 0, 'initSTN_L', 'color', 'y');
hSTN_L.Visible = 'off';

indexSTN_R = [0,0,0];
hSTN_R = text(0, 0, 'initSTN_R', 'color', 'y');
hSTN_R.Visible = 'off';

showhTXYZ();

set(handles.codeState,'BackgroundColor',[0,0,0]);

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

slicenum = round(ref_hdr.dim(3)/2);
transDegree = 0.5;

axes(handles.axes3);
axisImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, round(ref_hdr.dim(3)/2), transDegree, ref_range, mov_range, 3);
imshow(axisImg);
axes(handles.axes2);
sagImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, round(ref_hdr.dim(1)/2), transDegree, ref_range, mov_range, 1);
imshow(sagImg);
axes(handles.axes1);
corImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, round(ref_hdr.dim(2)/2), transDegree, ref_range, mov_range, 2);
imshow(corImg);
axes(handles.mainView);
mainImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, slicenum, transDegree, ref_range, mov_range, 3);
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

% --- Executes on button press in setCoordinate.
function setCoordinate_Callback(hObject, eventdata, handles)
% hObject    handle to setCoordinate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%线设置指示块变红
set(handles.codeState,'BackgroundColor',[1,0,0]);

global showMR;
global transDegree;
global mov_hdr;
global mov_img;
global mov_range;
global slicenum;
global maindir;
global mainImg;
global mainViewH;
global indexX;
global indexY;
global hT;
global showhT;

maindir = 3;

showMR = 0;
slicenum = round(mov_hdr.dim(3)/2);

transDegree=get(hObject,'Value');
% [axisImg,corImg,sagImg]=splitImg(rT2,rCT,transDegree,[x_Img,y_Img,z_Img]);
axes(handles.mainView);
mainImg = imageshow([], [], mov_hdr, mov_img, slicenum, transDegree, [], mov_range, 3);
mainViewH = imshow(mainImg);
set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});

showhT = 0;
indexX = 0;
indexY = 0;

axes(handles.mainView);
hT = text(0, 0, 'inithT', 'color', 'b');
hT.Visible = 'off';

showhTXYZ();

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

if showMR==1;
    
    transDegree=get(hObject,'Value');
    axes(handles.axes3);
    axisImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, round(ref_hdr.dim(3)/2), transDegree, ref_range, mov_range, 3);
    imshow(axisImg);
    axes(handles.axes2);
    sagImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, round(ref_hdr.dim(1)/2), transDegree, ref_range, mov_range, 1);
    imshow(sagImg);
    axes(handles.axes1);
    corImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, round(ref_hdr.dim(2)/2), transDegree, ref_range, mov_range, 2);
    imshow(corImg);
    switch maindir;
        case 1;
            axes(handles.mainView);
            mainImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, indexX, transDegree, ref_range, mov_range, maindir);
        case 2;
            axes(handles.mainView);
            mainImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, indexY, transDegree, ref_range, mov_range, maindir);
        case 3;
            axes(handles.mainView);
            mainImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, slicenum, transDegree, ref_range, mov_range, maindir);
    end
    
    mainViewH = imshow(mainImg);
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});

    showhT_auto(handles);
    showAC(handles);
    showPC(handles);
    showSTN_L(handles);
    showSTN_R(handles);
    
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
global showMR;
global hT;
global showhT;

if showMR==1;
    
    switch maindir;
        case 1;
            indexX = round(get(hObject,'Value')*ref_hdr.dim(1));
            mainImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, indexX, transDegree, ref_range, mov_range, maindir);
        case 2;
            indexY = round(get(hObject,'Value')*ref_hdr.dim(2));
            mainImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, indexY, transDegree, ref_range, mov_range, maindir);
        case 3;
            slicenum = round(get(hObject,'Value')*ref_hdr.dim(3));
            mainImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, slicenum, transDegree, ref_range, mov_range, maindir);
    end
    
    axes(handles.mainView);
    mainViewH = imshow(mainImg);
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});

    showAC(handles);
    showPC(handles);
    showSTN_L(handles);
    showSTN_R(handles);
    
    showhT = 0;
    
    switch maindir;
        case 1;
            indexY = 0;
            slicenum = 0;
%             axes(handles.mainView);
%             hT = text(indexY-2, round((showMR*ref_hdr.dim(3)+(1-showMR)*mov_hdr.dim(3)-slicenum)*voxsize_ref(3)/voxsize_ref(2))+1-1, ['o   (',num2str(indexX), ',', num2str(indexY), ',',num2str(slicenum), ')'], 'color', 'b');
%             hT.Visible = 'off';
%             hTX=findobj(gcf,'tag','TX1');
%             set(hTX,'String',indexX);
%             hTY=findobj(gcf,'tag','TY1');
%             set(hTY,'String',indexY);
%             hTZ=findobj(gcf,'tag','TZ1');
%             set(hTZ,'String',slicenum);
        case 2;
            indexX = 0;
            slicenum = 0;
        case 3;
            indexX = 0;
            indexY = 0;
%             axes(handles.mainView);
%             hT = text(showMR*ref_hdr.dim(1)+(1-showMR)*mov_hdr.dim(1)-indexX+1-2, round((showMR*ref_hdr.dim(2)+(1-showMR)*mov_hdr.dim(2)-indexY)*voxsize_ref(2)/voxsize_ref(1))+1-1, ['o   (',num2str(indexX),',',num2str(indexY), ',', num2str(slicenum), ')'], 'color', 'b');
%             hT.Visible = 'off';
%             hTX=findobj(gcf,'tag','TX1');
%             set(hTX,'String',indexX);
%             hTY=findobj(gcf,'tag','TY1');
%             set(hTY,'String',indexY);
%             hTZ=findobj(gcf,'tag','TZ1');
%             set(hTZ,'String',slicenum);
    end
    axes(handles.mainView);
    showhT_auto(handles);
    hT.Visible = 'off';
    showhTXYZ();
    
else
    
    indexX = 0;
    indexY = 0;
    
    slicenum=round(get(hObject,'Value')*mov_hdr.dim(3));
    mainImg = imageshow([], [], mov_hdr, mov_img, slicenum, transDegree, [], mov_range, 3);
    axes(handles.mainView);
    mainViewH = imshow(mainImg);
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});
    axes(handles.mainView);
    showhT_auto(handles);
    hT.Visible = 'off';
    showhTXYZ();
    
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sliderAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

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

% CurPosShow('on');
global indexX;
global indexY;
global slicenum;
global hT;
global showhT;
global showMR;
global ref_hdr;
global mov_hdr;
global maindir;
global voxsize_ref;

showhT = 1;

switch maindir;
    case 1;
        mainindex = get(gca,'CurrentPoint');
        indexY = round(mainindex(1,1));
        slicenum = showMR*ref_hdr.dim(3)+(1-showMR)*mov_hdr.dim(3)-round(mainindex(1,2)*voxsize_ref(2)/voxsize_ref(3))+1;
    case 2;
        mainindex = get(gca,'CurrentPoint');
        indexX = round(mainindex(1,1));
        slicenum = showMR*ref_hdr.dim(3)+(1-showMR)*mov_hdr.dim(3)-round(mainindex(1,2)*voxsize_ref(1)/voxsize_ref(3))+1;
    case 3;
        mainindex = get(gca,'CurrentPoint');
        indexX = round(mainindex(1,1));
        indexY = showMR*ref_hdr.dim(2)+(1-showMR)*mov_hdr.dim(2)-round(mainindex(1,2)*voxsize_ref(1)/voxsize_ref(2))+1;
end

showhT_auto(handles);

showhTXYZ();


function myCallback(hObject, eventdata, handles)
% circle1=plotCircle(handles.mainView,[350,50]);
set(handles.codeState,'BackgroundColor',[1,0,0]);
global circle1;
delete(circle1);
hold on;
circle1=plotCircle(handles.mainView,[350,50],0);
guidata(hObject,handles)

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
function ImgButtonDown(hObject, eventdata, handles)
CurPosShow('on');
global buttonFlag;
buttonFlag=1-buttonFlag;
global i;

defineCoordinate(buttonFlag);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over TX1.
function TX1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to TX1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in confirmAC.
function confirmAC_Callback(hObject, eventdata, handles)
% hObject    handle to confirmAC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global indexAC;
global indexX;
global indexY;
global slicenum;
global hT;
global showhT;
global showMR;
global hAC;

if showhT == 1 && showMR == 1;
    
    indexAC = [indexX, indexY, slicenum];
    hT.Visible = 'off';
    showAC(handles);
    hAC.Visible = 'on';
    showhT = 0;
    
end

% --- Executes on button press in confirmPC.
function confirmPC_Callback(hObject, eventdata, handles)
% hObject    handle to confirmPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global indexPC;
global indexX;
global indexY;
global slicenum;
global hT;
global showhT;
global showMR;
global hPC;

if showhT == 1 && showMR == 1;
    
    indexPC = [indexX, indexY, slicenum];
    hT.Visible = 'off';
    showPC(handles);
    hPC.Visible = 'on';
    showhT = 0;
    
end

% --- Executes on button press in autoSTN_L.
function autoSTN_L_Callback(hObject, eventdata, handles)
% hObject    handle to autoSTN_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global indexAC;
global indexPC;
global indexSTN_L;
global ref_hdr;

if ~isequal(indexAC, [0, 0, 0]) && ~isequal(indexPC, [0, 0, 0]);
    diry = ref_hdr.mat*[(indexAC-indexPC).'; 0];
    diry = diry(1:3);
    diry = diry*(diry(2)>=0)/norm(diry);
    dirx = [diry(2), -diry(1), 0].';
    dirx = dirx*(dirx(1)>=0)/norm(dirx);
    dirz = [dirx(2)*diry(3)-dirx(3)*diry(2), dirx(3)*diry(1)-dirx(1)*diry(3), dirx(1)*diry(2)-dirx(2)*diry(1)].';
    dirz = dirz*(dirz(3)>=0)/norm(dirz);
    origin = ref_hdr.mat*[((indexAC+indexPC)/2).'; 1];
    indexSTN_L = inv(ref_hdr.mat)*[(origin(1:3)-9.5*dirx-0.5*diry-4.5*dirz); 1];
    indexSTN_L = round(indexSTN_L(1:3));
    showSTN_L(handles);
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

if ~isequal(indexAC, [0, 0, 0]) && ~isequal(indexPC, [0, 0, 0]);
    diry = ref_hdr.mat*[(indexAC-indexPC).'; 0];
    diry = diry(1:3);
    diry = diry*(diry(2)>=0)/norm(diry);
    dirx = [diry(2), -diry(1), 0].';
    dirx = dirx*(dirx(1)>=0)/norm(dirx);
    dirz = [dirx(2)*diry(3)-dirx(3)*diry(2), dirx(3)*diry(1)-dirx(1)*diry(3), dirx(1)*diry(2)-dirx(2)*diry(1)].';
    dirz = dirz*(dirz(3)>=0)/norm(dirz);
    origin = ref_hdr.mat*[((indexAC+indexPC)/2).'; 1];
    indexSTN_R = inv(ref_hdr.mat)*[(origin(1:3)+9.5*dirx-0.5*diry-4.5*dirz); 1];
    indexSTN_R = round(indexSTN_R(1:3));
    showSTN_R(handles);
end

% --- Executes on button press in confirmSTN_L.
function confirmSTN_L_Callback(hObject, eventdata, handles)
% hObject    handle to confirmSTN_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global indexSTN_L;
global indexX;
global indexY;
global slicenum;
global hT;
global showhT;
global showMR;
global hSTN_L;

if showhT == 1 && showMR == 1;
    
    indexSTN_L = [indexX, indexY, slicenum];
    hT.Visible = 'off';
    showSTN_L(handles);
    hSTN_L.Visible = 'on';
    showhT = 0;
    
end

% --- Executes on button press in confirmSTN_R.
function confirmSTN_R_Callback(hObject, eventdata, handles)
% hObject    handle to confirmSTN_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global indexSTN_R;
global indexX;
global indexY;
global slicenum;
global hT;
global showhT;
global showMR;
global hSTN_R;

if showhT == 1 && showMR == 1;
    
    indexSTN_R = [indexX, indexY, slicenum];
    hT.Visible = 'off';
    showSTN_R(handles);
    hSTN_R.Visible = 'on';
    showhT = 0;
    
end

% --- Executes on button press in axis.
function axis_Callback(hObject, eventdata, handles)
% hObject    handle to axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ref_hdr;
global ref_img;
global ref_range;
global mov_hdr;
global mov_img;
global mov_range;
global transDegree;
global mainImg;
global maindir;
global mainViewH;
global indexX;
global indexY;
global slicenum;
global voxsize_ref;
global showMR;
global hT;
global showhT;

if maindir~=3 && showMR == 1;
    maindir = 3;
    showhT = 0;
    transDegree = 0.5;
    indexX = 0;
    indexY = 0;
    slicenum = round(ref_hdr.dim(3)/2);
    axes(handles.mainView);
    mainImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, slicenum, transDegree, ref_range, mov_range, maindir);
    mainViewH = imshow(mainImg);
    showhT_auto(handles);
    hT.Visible = 'off';
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});

    showhTXYZ();
end

% --- Executes on button press in sag.
function sag_Callback(hObject, eventdata, handles)
% hObject    handle to sag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ref_hdr;
global ref_img;
global ref_range;
global mov_hdr;
global mov_img;
global mov_range;
global transDegree;
global mainImg;
global maindir;
global mainViewH;
global indexX;
global indexY;
global slicenum;
global voxsize_ref;
global showMR;
global hT;
global showhT;

if maindir ~= 1 && showMR == 1;
    maindir = 1;
    showhT = 0;
    transDegree = 0.5;
    indexX = round(ref_hdr.dim(1)/2);
    indexY = 0;
    slicenum = 0;
    axes(handles.mainView);
    mainImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, indexX, transDegree, ref_range, mov_range, maindir);
    mainViewH = imshow(mainImg);
    showhT_auto(handles);
    hT.Visible = 'off';
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});
    
    showhTXYZ();
end

% --- Executes on button press in cor.
function cor_Callback(hObject, eventdata, handles)
% hObject    handle to cor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ref_hdr;
global ref_img;
global ref_range;
global mov_hdr;
global mov_img;
global mov_range;
global transDegree;
global mainImg;
global maindir;
global mainViewH;
global indexX;
global indexY;
global slicenum;
global voxsize_ref;
global showMR;
global hT;
global showhT;

if maindir ~= 2 && showMR == 1;
    maindir = 2;
    showhT = 0;
    transDegree = 0.5;
    indexX = 0;
    indexY = round(ref_hdr.dim(2)/2);
    slicenum = 0;
    axes(handles.mainView);
    mainImg = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, indexY, transDegree, ref_range, mov_range, maindir);
    mainViewH = imshow(mainImg);
    showhT_auto(handles);
    hT.Visible = 'off';
    set(mainViewH,'ButtonDownFcn',{@mainView_ButtonDownFcn,handles});
    
    showhTXYZ();
    
end
function showhT_auto(handles);

global maindir;
global indexX;
global indexY;
global slicenum;
global showMR;
global voxsize_ref;
global ref_hdr;
global mov_hdr;
global hT;
global showhT;

switch maindir;
    case 1;
        axes(handles.mainView);
        if ~isprop(hT, 'Visible');
            if showhT == 0;
                hT = text(indexY-2, round((showMR*ref_hdr.dim(3)+(1-showMR)*mov_hdr.dim(3)-slicenum)*voxsize_ref(3)/voxsize_ref(2))+1-1, ['o   (', num2str(indexX), ',', num2str(indexY),',',num2str(slicenum), ')'], 'color', 'b');
                hT.Visible = 'off';
            else
                hT = text(indexY-2, round((showMR*ref_hdr.dim(3)+(1-showMR)*mov_hdr.dim(3)-slicenum)*voxsize_ref(3)/voxsize_ref(2))+1-1, ['o   (', num2str(indexX), ',', num2str(indexY),',',num2str(slicenum), ')'], 'color', 'b');
            end
        else
            hT.Position = [indexY-2, round((showMR*ref_hdr.dim(3)+(1-showMR)*mov_hdr.dim(3)-slicenum)*voxsize_ref(3)/voxsize_ref(2))+1-1];
            hT.String = ['o   (', num2str(indexX), ',', num2str(indexY),',',num2str(slicenum), ')'];
            hT.Visible = 'on';
        end
    case 2;
        axes(handles.mainView);
        if ~isprop(hT, 'Visible');
            if showhT == 0;
                hT = text(indexX-2, round((showMR*ref_hdr.dim(3)+(1-showMR)*mov_hdr.dim(3)-slicenum)*voxsize_ref(3)/voxsize_ref(1))+1-1, ['o   (',num2str(indexX),',',num2str(indexY), ',', num2str(slicenum), ')'], 'color', 'b');
                hT.Visible = 'off';
            else
                hT = text(indexX-2, round((showMR*ref_hdr.dim(3)+(1-showMR)*mov_hdr.dim(3)-slicenum)*voxsize_ref(3)/voxsize_ref(1))+1-1, ['o   (',num2str(indexX),',',num2str(indexY), ',', num2str(slicenum), ')'], 'color', 'b');
            end
        else
            hT.Position = [indexX-2, round((showMR*ref_hdr.dim(3)+(1-showMR)*mov_hdr.dim(3)-slicenum)*voxsize_ref(3)/voxsize_ref(1))+1-1];
            hT.String = ['o   (', num2str(indexX), ',', num2str(indexY),',',num2str(slicenum), ')'];
            hT.Visible = 'on';
        end
    case 3;
        axes(handles.mainView);
        if ~isprop(hT, 'Visible');
            if showhT == 0;
                hT = text(indexX-2, round((showMR*ref_hdr.dim(2)+(1-showMR)*mov_hdr.dim(2)-indexY)*voxsize_ref(2)/voxsize_ref(1))+1-1, ['o   (',num2str(indexX),',',num2str(indexY), ',', num2str(slicenum), ')'], 'color', 'b');
                hT.Visible = 'off';
            else
                hT = text(indexX-2, round((showMR*ref_hdr.dim(2)+(1-showMR)*mov_hdr.dim(2)-indexY)*voxsize_ref(2)/voxsize_ref(1))+1-1, ['o   (',num2str(indexX),',',num2str(indexY), ',', num2str(slicenum), ')'], 'color', 'b');
            end
        else
            hT.Position = [indexX-2, round((showMR*ref_hdr.dim(2)+(1-showMR)*mov_hdr.dim(2)-indexY)*voxsize_ref(2)/voxsize_ref(1))+1-1];
            hT.String = ['o   (', num2str(indexX), ',', num2str(indexY),',',num2str(slicenum), ')'];
            hT.Visible = 'on';
        end
end
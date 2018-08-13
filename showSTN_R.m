function showSTN_R(handles);

global indexSTN_R;
global hSTN_R;
global showMR;
global ref_hdr;
global mov_hdr;
global maindir;
global voxsize_ref;
global indexX;
global indexY;
global slicenum;

if ~isempty(indexSTN_R);
    switch maindir;
        case 1;
            if ~isprop(hSTN_R, 'Visible');
                if indexX == indexSTN_R(1);
                    axes(handles.mainView);
                    hSTN_R = text(indexSTN_R(2)-2, round((showMR*ref_hdr.dim(3)+(1-showMR)*mov_hdr.dim(3)-indexSTN_R(3))*voxsize_ref(3)/voxsize_ref(2))+1-1, '+   ”“≤‡STN', 'color', 'y');
                end
            else
                hSTN_R.Position = [indexSTN_R(2)-2, round((showMR*ref_hdr.dim(3)+(1-showMR)*mov_hdr.dim(3)-indexSTN_R(3))*voxsize_ref(3)/voxsize_ref(2))+1-1];
                hSTN_R.String = '+   ”“≤‡STN';
                hSTN_R.Visible = 'on';
            end
        case 2;
            if ~isprop(hSTN_R, 'Visible');
                if indexY == indexSTN_R(2);
                    axes(handles.mainView);
                    hSTN_R = text(indexSTN_R(1)-57, round((showMR*ref_hdr.dim(3)+(1-showMR)*mov_hdr.dim(3)-indexSTN_R(3))*voxsize_ref(3)/voxsize_ref(1))+1-1, '”“≤‡STN   +', 'color', 'y');
                end
            else
                hSTN_R.Position = [indexSTN_R(1)-57, round((showMR*ref_hdr.dim(3)+(1-showMR)*mov_hdr.dim(3)-indexSTN_R(3))*voxsize_ref(3)/voxsize_ref(1))+1-1];
                hSTN_R.String = '”“≤‡STN   +';
                hSTN_R.Visible = 'on';
            end
        case 3;
            if ~isprop(hSTN_R, 'Visible');
                if slicenum == indexSTN_R(3);
                    axes(handles.mainView);
                    hSTN_R = text(indexSTN_R(1)-57, round((showMR*ref_hdr.dim(2)+(1-showMR)*mov_hdr.dim(2)-indexSTN_R(2))*voxsize_ref(2)/voxsize_ref(1))+1-1, '”“≤‡STN   +', 'color', 'y');
                end
            else
                hSTN_R.Position = [indexSTN_R(1)-57, round((showMR*ref_hdr.dim(2)+(1-showMR)*mov_hdr.dim(2)-indexSTN_R(2))*voxsize_ref(2)/voxsize_ref(1))+1-1];
                hSTN_R.String = '”“≤‡STN   +';
                hSTN_R.Visible = 'on';
            end
    end
end
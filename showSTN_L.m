function showSTN_L(handles);

global indexSTN_L;
global hSTN_L;
global showMR;
global ref_hdr;
global mov_hdr;
global maindir;
global voxsize_ref;
global indexX;
global indexY;
global slicenum;

if ~isempty(indexSTN_L);
    switch maindir;
        case 1;
            if ~isprop(hSTN_L, 'Visible');
                if indexX == indexSTN_L(1);
                    axes(handles.mainView);
                    hSTN_L = text(indexSTN_L(2)-2, round((showMR*ref_hdr.dim(3)+(1-showMR)*mov_hdr.dim(3)-indexSTN_L(3))*voxsize_ref(3)/voxsize_ref(2))+1-1, '+   ×ó²àSTN', 'color', 'y');
                end
            else
                hSTN_L.Position = [indexSTN_L(2)-2, round((showMR*ref_hdr.dim(3)+(1-showMR)*mov_hdr.dim(3)-indexSTN_L(3))*voxsize_ref(3)/voxsize_ref(2))+1-1];
                hSTN_L.String = '+   ×ó²àSTN';
                hSTN_L.Visible = 'on';
            end
        case 2;
            if ~isprop(hSTN_L, 'Visible');
                if indexY == indexSTN_L(2);
                    axes(handles.mainView);
                    hSTN_L = text(indexSTN_L(1)-2, round((showMR*ref_hdr.dim(3)+(1-showMR)*mov_hdr.dim(3)-indexSTN_L(3))*voxsize_ref(3)/voxsize_ref(1))+1-1, '+   ×ó²àSTN', 'color', 'y');
                end
            else
                hSTN_L.Position = [indexSTN_L(1)-2, round((showMR*ref_hdr.dim(3)+(1-showMR)*mov_hdr.dim(3)-indexSTN_L(3))*voxsize_ref(3)/voxsize_ref(1))+1-1];
                hSTN_L.String = '+   ×ó²àSTN';
                hSTN_L.Visible = 'on';
            end
        case 3;
            if ~isprop(hSTN_L, 'Visible');
                if slicenum == indexSTN_L(3);
                    axes(handles.mainView);
                    hSTN_L = text(indexSTN_L(1)-2, round((showMR*ref_hdr.dim(2)+(1-showMR)*mov_hdr.dim(2)-indexSTN_L(2))*voxsize_ref(2)/voxsize_ref(1))+1-1, '+   ×ó²àSTN', 'color', 'y');
                end
            else
                hSTN_L.Position = [indexSTN_L(1)-2, round((showMR*ref_hdr.dim(2)+(1-showMR)*mov_hdr.dim(2)-indexSTN_L(2))*voxsize_ref(2)/voxsize_ref(1))+1-1];
                hSTN_L.String = '+   ×ó²àSTN';
                hSTN_L.Visible = 'on';
            end
    end
end
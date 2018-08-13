function imout = imageshow(ref_hdr, ref_img, mov_hdr, mov_img, ref_slicenum, mov_weight, ref_range, mov_range, dir);
%该函数用于将MR和CT显示在同一张图片中，可以设置透明度
%申伦豪

if isempty(ref_hdr) && isempty(ref_img) && isempty(ref_range);
    ref_hdr = mov_hdr;
    ref_img = mov_img;
    ref_range = mov_range;
    mov_hdr = [];
    mov_img = [];
    mov_range = [];
end

[~, trans] = qr(ref_hdr.mat);
voxsize = abs(round(diag(trans)*10)/10);
voxsize = voxsize(1:3);

switch dir
    case 1;
        [ref_indexZ, ref_indexY] = meshgrid(1:voxsize(2)/voxsize(3):ref_hdr.dim(3), 1:ref_hdr.dim(2));
        ref_indexX = ones(size(ref_indexY))*ref_slicenum;
        if ref_slicenum>0 && ref_slicenum<=ref_hdr.dim(1);
            ref_slice = reshape(interp2(squeeze(ref_img(ref_slicenum, :, :)), ref_indexZ(:), ref_indexY(:)), ...
                size(ref_indexX));
            ref_slice(isnan(ref_slice)) = 0;
        else
            ref_slice = zeros(size(ref_indexX));
        end
        
        if ~isempty(mov_hdr) && ~isempty(mov_img) && ~isempty(mov_range);
            
            ref_coord = ref_hdr.mat*[ref_indexX(:), ref_indexY(:), ref_indexZ(:), ones(numel(ref_indexX), 1)].';
            
            mov_index = reshape((mov_hdr.mat\ref_coord).', [size(ref_indexX), 4]);
            mov_indexX = mov_index(:, :, 1);
            mov_indexY = mov_index(:, :, 2);
            mov_indexZ = mov_index(:, :, 3);
            clear mov_index;
            
            mov_slice = reshape(interp3(mov_img(min(mov_hdr.dim(1)-1, max(1, floor(min(mov_indexX(:))))):max(2, min(mov_hdr.dim(1), ceil(max(mov_indexX(:))))), :, :), ...
                mov_indexY(:), mov_indexX(:)-min(mov_hdr.dim(1)-1, max(1, floor(min(mov_indexX(:)))))+1, mov_indexZ(:)), size(ref_indexX));
            mov_slice(isnan(mov_slice)) = 0;
            
        end
    case 2;
        [ref_indexZ, ref_indexX] = meshgrid(1:voxsize(1)/voxsize(3):ref_hdr.dim(3), 1:ref_hdr.dim(1));
        ref_indexY = ones(size(ref_indexX))*ref_slicenum;
        if ref_slicenum>0 && ref_slicenum<=ref_hdr.dim(2);
            ref_slice = reshape(interp2(squeeze(ref_img(:, ref_slicenum, :)), ref_indexZ(:), ref_indexX(:)), ...
                size(ref_indexX));
            ref_slice(isnan(ref_slice)) = 0;
        else
            ref_slice = zeros(size(ref_indexX));
        end
        
        if ~isempty(mov_hdr) && ~isempty(mov_img) && ~isempty(mov_range);
            
            ref_coord = ref_hdr.mat*[ref_indexX(:), ref_indexY(:), ref_indexZ(:), ones(numel(ref_indexX), 1)].';
            
            mov_index = reshape((mov_hdr.mat\ref_coord).', [size(ref_indexX), 4]);
            mov_indexX = mov_index(:, :, 1);
            mov_indexY = mov_index(:, :, 2);
            mov_indexZ = mov_index(:, :, 3);
            clear mov_index;
            
            mov_slice = reshape(interp3(mov_img(:, min(mov_hdr.dim(2)-1, max(1, floor(min(mov_indexY(:))))):max(2, min(mov_hdr.dim(2), ceil(max(mov_indexY(:))))), :), ...
                mov_indexY(:)-min(mov_hdr.dim(2)-1, max(1, floor(min(mov_indexY(:)))))+1, mov_indexX(:), mov_indexZ(:)), size(ref_indexX));
            mov_slice(isnan(mov_slice)) = 0;
            
        end
    case 3;
        [ref_indexY, ref_indexX] = meshgrid(1:voxsize(1)/voxsize(2):ref_hdr.dim(2), 1:ref_hdr.dim(1));
        ref_indexZ = ones(size(ref_indexX))*ref_slicenum;
        if ref_slicenum>0 && ref_slicenum<=ref_hdr.dim(3);
            ref_slice = reshape(interp2(squeeze(ref_img(:, :, ref_slicenum)), ref_indexY(:), ref_indexX(:)), ...
                size(ref_indexX));
            ref_slice(isnan(ref_slice)) = 0;
        else
            ref_slice = zeros(size(ref_indexX));
        end
        
        if ~isempty(mov_hdr) && ~isempty(mov_img) && ~isempty(mov_range);
            
            ref_coord = ref_hdr.mat*[ref_indexX(:), ref_indexY(:), ref_indexZ(:), ones(numel(ref_indexX), 1)].';
            
            mov_index = reshape((mov_hdr.mat\ref_coord).', [size(ref_indexX), 4]);
            mov_indexX = mov_index(:, :, 1);
            mov_indexY = mov_index(:, :, 2);
            mov_indexZ = mov_index(:, :, 3);
            clear mov_index;
            
            mov_slice = reshape(interp3(mov_img(:, :, min(mov_hdr.dim(3)-1, max(1, floor(min(mov_indexZ(:))))):max(2, min(mov_hdr.dim(3), ceil(max(mov_indexZ(:)))))), ...
                mov_indexY(:), mov_indexX(:), mov_indexZ(:)-min(mov_hdr.dim(3)-1, max(1, floor(min(mov_indexZ(:)))))+1), size(ref_indexX));
            mov_slice(isnan(mov_slice)) = 0;
            
        end
    otherwise
        error('unknown direction!');
end

% figure;
% imshow(mat2gray(rot90(ref_slice), ref_range)*(1-mov_weight)+mat2gray(rot90(mov_slice), mov_range)*mov_weight, [0, 1]);

if ~isempty(mov_hdr) && ~isempty(mov_img) && ~isempty(mov_range);
    
    imout = mat2gray(rot90(ref_slice), ref_range)*(1-mov_weight)+mat2gray(rot90(mov_slice), mov_range)*mov_weight;
    
else
    
    imout = mat2gray(rot90(ref_slice), ref_range);
    
end

end
function coreg_linear(fileDir,fixImg,moveImg)
% This function is writen by Wansen based on spm8
%input: fileDir: the path of image to be processed,fixImg,moveImg,and the
%       name of newImg
%function:coregist the moveImg to fixImg in a linear way, name of new image
%         is newImg
%2016.07.22 Wansen


OrigionalPath=cd;
cd (fileDir);
V_newImg=spm_vol(moveImg);
V_fixImg=spm_vol(fixImg);
x = spm_coreg(V_newImg,V_fixImg);
V_newImg.mat=spm_matrix(x(:)')*V_newImg.mat;
Y=spm_read_vols(V_newImg);
spm_write_vol(V_newImg,Y);
cd (OrigionalPath);
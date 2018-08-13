function normalZ(dirOfNii,nameOfNii)

%该函数的目的是将CT MR图像的中心的Z坐标变换为0
%输入：图像的路径，图像的名字
%输出：将图像直接更改了坐标
%例子：normalZ('./zhanglanlan/','T2.nii')
%2016.11.16 Wansen

VofMR=spm_vol([dirOfNii,nameOfNii]);
MR=spm_read_vols(VofMR);
[x,y,z]=size(MR);
pOfCenter=VofMR.mat*[round(x/2);round(y/2);round(z/2);1];
transMat=[1,0,0,0;0,1,0,0;0,0,1,-pOfCenter(3);0,0,0,1];
VofMR.mat=transMat*VofMR.mat;
spm_write_vol(VofMR,MR);
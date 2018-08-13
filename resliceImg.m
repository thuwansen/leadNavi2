function resliceImg(filePath,overlay,underlay)
% 这个函数的目的是用于透明显示上层和下层
% degreeOfTrans表征透明度，默认是0.5

%首先将两张图转为相同的分辨率
filePath='zhanglanlan/';overlay='T2.nii';underlay='CT.nii';
global VofOverlay;
VofOverlay=spm_vol([filePath,overlay]);
global VofUnderlay;
VofUnderlay=spm_vol([filePath,underlay]);
P={[filePath,overlay];[filePath,underlay]};
flag=struct('interp',1,'mask',1,'mean',0,'which',1,'wrap',[0 0 0]',...
                   'prefix','r');;
spm_reslice(P,flag);

%将两张图合成一张图
newUnderlay=['r',underlay];
global VofNewUnderlay;
VofNewUnderlay=spm_vol([filePath,newUnderlay]);

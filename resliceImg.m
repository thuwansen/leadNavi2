function resliceImg(filePath,overlay,underlay)
% ���������Ŀ��������͸����ʾ�ϲ���²�
% degreeOfTrans����͸���ȣ�Ĭ����0.5

%���Ƚ�����ͼתΪ��ͬ�ķֱ���
filePath='zhanglanlan/';overlay='T2.nii';underlay='CT.nii';
global VofOverlay;
VofOverlay=spm_vol([filePath,overlay]);
global VofUnderlay;
VofUnderlay=spm_vol([filePath,underlay]);
P={[filePath,overlay];[filePath,underlay]};
flag=struct('interp',1,'mask',1,'mean',0,'which',1,'wrap',[0 0 0]',...
                   'prefix','r');;
spm_reslice(P,flag);

%������ͼ�ϳ�һ��ͼ
newUnderlay=['r',underlay];
global VofNewUnderlay;
VofNewUnderlay=spm_vol([filePath,newUnderlay]);

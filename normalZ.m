function normalZ(dirOfNii,nameOfNii)

%�ú�����Ŀ���ǽ�CT MRͼ������ĵ�Z����任Ϊ0
%���룺ͼ���·����ͼ�������
%�������ͼ��ֱ�Ӹ���������
%���ӣ�normalZ('./zhanglanlan/','T2.nii')
%2016.11.16 Wansen

VofMR=spm_vol([dirOfNii,nameOfNii]);
MR=spm_read_vols(VofMR);
[x,y,z]=size(MR);
pOfCenter=VofMR.mat*[round(x/2);round(y/2);round(z/2);1];
transMat=[1,0,0,0;0,1,0,0;0,0,1,-pOfCenter(3);0,0,0,1];
VofMR.mat=transMat*VofMR.mat;
spm_write_vol(VofMR,MR);
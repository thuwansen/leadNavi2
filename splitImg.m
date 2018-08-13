function [axisImg,corImg,sagImg]=splitImg(rCT,rT2,transDegree,centerPoint)
% ��������Ĺ����ǽ�A,B����nii�ļ��е�ͼ���ʾ������
% ����: ��ά����A,B����ͬ��size,͸����tranDegree,[x,y,z]���������
% �����rotate֮�������λ�õ�ͼ��
x=centerPoint(1);
y=centerPoint(2);
z=centerPoint(3);
axisImg=rCT(:,:,z)*(transDegree+0.01)+rT2(:,:,z)*(1.01-transDegree);
axisImg=imrotate(axisImg,90);
sagImg=rCT(x,:,:)*(transDegree+0.01)+rT2(x,:,:)*(1.01-transDegree);
sagImg=imrotate(squeeze(sagImg),90);
corImg=rCT(:,y,:)*(transDegree+0.01)+rT2(:,y,:)*(1.01-transDegree);
corImg=imrotate(squeeze(corImg),90);

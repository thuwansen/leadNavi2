function [axisImg,corImg,sagImg]=splitImg(rCT,rT2,transDegree,centerPoint)
% 这个函数的功能是将A,B两个nii文件中的图像表示出来，
% 输入: 三维矩阵A,B，相同的size,透明度tranDegree,[x,y,z]焦点的坐标
% 输出：rotate之后的三个位置的图像
x=centerPoint(1);
y=centerPoint(2);
z=centerPoint(3);
axisImg=rCT(:,:,z)*(transDegree+0.01)+rT2(:,:,z)*(1.01-transDegree);
axisImg=imrotate(axisImg,90);
sagImg=rCT(x,:,:)*(transDegree+0.01)+rT2(x,:,:)*(1.01-transDegree);
sagImg=imrotate(squeeze(sagImg),90);
corImg=rCT(:,y,:)*(transDegree+0.01)+rT2(:,y,:)*(1.01-transDegree);
corImg=imrotate(squeeze(corImg),90);

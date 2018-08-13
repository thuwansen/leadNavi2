function myImg=resizeImg(A)
% 这个函数的作用是调整VOXEL的大小来使图像显示更加协调,并将不全面的地方拉黑
V=spm_vol(A);
img=spm_read_vols(V);
[x,y,z]=size(img);
k=abs(round(V.mat(3,3)/V.mat(1,1)));
finalImg=zeros(x,y,z*k);
for i=1:z
    for j=1:k
        finalImg(:,:,(i-1)*k+j)=img(:,:,i);
    end
end
V.mat(:,3)=V.mat(:,3)/k;

myImg=zeros(x,x,450);
myImg(:,:,round(450/2)-round(z*k/2):round(450/2)-round(z*k/2)+z*k-1)=finalImg;
V.dim=size(myImg);
spm_write_vol(V,myImg);
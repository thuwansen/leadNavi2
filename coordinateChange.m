function postPoint=coordinateChange(origionPoint,transDirection)

%这个函数用于转换实际存储的坐标和画在图画上的坐标,如果transDirection=0，plot->real
%首先根据赵立福GPi左侧毁损，得出图片是从脚底向上扫描的结论，即显示的时候右边是左脑
%定义(左耳-右耳)（Xmin->Xmax）
%(鼻子->后脑)（Ymin->Ymax）
%(下巴->头顶)（Zmin->Zmax）
%在轴状位的图中，Xtu=size(1)-Xreal,Y=Y,Z=Z;
%在冠状位的图中，Xtu=size(1)-Xreal,Ytu=size(2)-Yreal，Ztu=size(3)-Zreal
%在矢状位中，Xtu=size(1)-Xreal,Ytu=size(2)-Yreal，Ztu=size(3)-Zreal
%所有呈现在图中的都是插值之后的图像

%何时需要坐标转换？定位用的6个点不需要，因为只有CT的轴状位;对于step4中，
%各个targetPoint需要，并且在plot时需要转换回来
global maindir;
global voxsize_ref;
global ref_hdr;

%将三个维度的坐标统一起来----------这里不具有普适性！！！！-----------
sizeOfRef=ref_hdr.dim;
sizeOfRef(3)=sizeOfRef(3)*voxsize_ref(3)/voxsize_ref(1);

[m,n]=size(origionPoint);
b=ones(m,1);
            

if transDirection==0 %从图中读取，保存到real中
    switch maindir
        case 1
            tempOrigion=[origionPoint,b];
            trans=[-1,0,0,0;0,-1,0,0;0,0,-1,0;sizeOfRef(1),sizeOfRef(2),sizeOfRef(3),1];
            tempPost=tempOrigion*trans;
            postPoint=tempPost(:,1:3);
        case 2
            tempOrigion=[origionPoint,b];
            trans=[-1,0,0,0;0,-1,0,0;0,0,-1,0;sizeOfRef(1),sizeOfRef(2),sizeOfRef(3),1];
            tempPost=tempOrigion*trans;
            postPoint=tempPost(:,1:3);
        case 3
            tempOrigion=[origionPoint,b];
            trans=[-1,0,0,0;0,1,0,0;0,0,1,0;sizeOfRef(1),0,0,1];
            tempPost=tempOrigion*trans;
            postPoint=tempPost(:,1:3);
    end
end

if transDirection==1%从real中提取，绘制到tu中
     switch maindir
        case 1
            tempOrigion=[origionPoint,b];
            trans=[-1,0,0,0;0,-1,0,0;0,0,-1,0;sizeOfRef(1),sizeOfRef(2),sizeOfRef(3),1];
            tempPost=tempOrigion*trans;
            postPoint=tempPost(:,1:3);
        case 2
            tempOrigion=[origionPoint,b];
            trans=[-1,0,0,0;0,-1,0,0;0,0,-1,0;sizeOfRef(1),sizeOfRef(2),sizeOfRef(3),1];
            tempPost=tempOrigion*trans;
            postPoint=tempPost(:,1:3);
        case 3
            tempOrigion=[origionPoint,b];
            trans=[-1,0,0,0;0,1,0,0;0,0,1,0;sizeOfRef(1),0,0,1];
            tempPost=tempOrigion*trans;
            postPoint=tempPost(:,1:3);
    end
end
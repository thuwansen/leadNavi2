function postPoint=coordinateChange(origionPoint,transDirection)

%�����������ת��ʵ�ʴ洢������ͻ���ͼ���ϵ�����,���transDirection=0��plot->real
%���ȸ���������GPi�����𣬵ó�ͼƬ�Ǵӽŵ�����ɨ��Ľ��ۣ�����ʾ��ʱ���ұ�������
%����(���-�Ҷ�)��Xmin->Xmax��
%(����->����)��Ymin->Ymax��
%(�°�->ͷ��)��Zmin->Zmax��
%����״λ��ͼ�У�Xtu=size(1)-Xreal,Y=Y,Z=Z;
%�ڹ�״λ��ͼ�У�Xtu=size(1)-Xreal,Ytu=size(2)-Yreal��Ztu=size(3)-Zreal
%��ʸ״λ�У�Xtu=size(1)-Xreal,Ytu=size(2)-Yreal��Ztu=size(3)-Zreal
%���г�����ͼ�еĶ��ǲ�ֵ֮���ͼ��

%��ʱ��Ҫ����ת������λ�õ�6���㲻��Ҫ����Ϊֻ��CT����״λ;����step4�У�
%����targetPoint��Ҫ��������plotʱ��Ҫת������
global maindir;
global voxsize_ref;
global ref_hdr;

%������ά�ȵ�����ͳһ����----------���ﲻ���������ԣ�������-----------
sizeOfRef=ref_hdr.dim;
sizeOfRef(3)=sizeOfRef(3)*voxsize_ref(3)/voxsize_ref(1);

[m,n]=size(origionPoint);
b=ones(m,1);
            

if transDirection==0 %��ͼ�ж�ȡ�����浽real��
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

if transDirection==1%��real����ȡ�����Ƶ�tu��
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
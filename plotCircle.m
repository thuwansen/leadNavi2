function a=plotCircle(A,P,color)
% �������������������ͼ�ϻ�ԲȦ,color����0ʱ����ɫ��Ȧ������1ʱ�Ǻ�ɫ��Ȧ
t = 0:0.2:2*pi;x = P(1)+3*sin(t);y = P(2)+3*cos(t);
if color==0
a=plot(A,x,y,'b');
else
a=plot(A,x,y,'r');
end


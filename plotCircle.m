function a=plotCircle(A,P,color)
% 这个函数的作用是在脑图上画圆圈,color等于0时是蓝色的圈，等于1时是红色的圈
t = 0:0.2:2*pi;x = P(1)+3*sin(t);y = P(2)+3*cos(t);
if color==0
a=plot(A,x,y,'b');
else
a=plot(A,x,y,'r');
end


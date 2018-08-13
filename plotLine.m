function plotLine(A,B,P)
% 这个函数的作用是在脑图上画圆圈
minX=min(A(1),B(1));maxX=max(A(1),B(1));
minY=min(A(2),B(2));maxY=max(A(2),B(2));
t = minX:0.2:2*pi;x = P(1)+5*sin(t);y = P(2)+5*cos(t);
plot(A,x,y);

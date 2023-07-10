clear all;
close all;
clc;

A = [1 -1.5 0.54];
B = [2 -1.8];
C = [1 0.2 -0.48];

nk = 1;
lambda = 3;
mk = nk;

t = 1:0.1:10;

[F,G] = efge(A,C,nk)
BF = conv(B,F);

y = [ 0 0 ];
u = 1*sin(t);
e = 0.001*randn(size(t));
yref = square(t);

for k = 3:length(t)
    y(k) = 1.5*y(k-1)-0.54*y(k-2)+2*u(k-1)-1.8*u(k-2)+3*(e(k)+0.2*e(k-1)-0.48*e(k-2));
    u(k) = 1/BF(1) * (-BF(2)*u(k-1)+C(1)*yref(k)+C(2)*yref(k-1)+C(3)*yref(k-2)-G(1)*y(k)-G(2)*y(k-1));
end

plot(t,y,'r',t,yref,'g');
grid on;
figure;
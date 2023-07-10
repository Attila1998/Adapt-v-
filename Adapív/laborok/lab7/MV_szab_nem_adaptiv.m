clc;
close all;
clear all;

A=[1 -1.5 0.54];
B=[2 -1.8];
C=[1 0.2 -.48];
nk=1;
Ts=0.1;
t=0:Ts:10;
maxShift=2;
e=0.1*ones(1,length(t));
y=zeros(1,maxShift);
u=5*ones(length(t));
Yref=3*square(t);
[F,G]=efge(A,C,nk);
u=zeros(1,maxShift);
for i=3:length(t)
    Y=1.5*y(i-1)-0.54*y(i-2)+2*u(i-1)-1.8*u(i-2)+3*(e(i)+0.2*e(i-1)-0.48*e(i-2));
    y=[y Y];
    BF=conv(B,F);
    U=(1/BF(1))*(-BF(2)*u(i-1)+C(1)*Yref(i)+C(2)*Yref(i-1)+C(3)*Yref(i-2)-G(1)*y(i)-G(2)*y(i-1));
    u=[u U];
end

hold on;
plot(t,y)
plot(t,u);
plot(t,Yref);
legend("signal","control signal","ref");








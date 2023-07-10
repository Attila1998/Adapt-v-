clc;
close all;
clear all;

A=[1 5 0.6];
B=[1 0.2 0.1];
C=[0 -4.8 -0.5];

nk=1;
Ts=0.01;
t=0:Ts:10;
maxShift=2;

e=0.1*ones(1,length(t));
y=zeros(1,maxShift);
u=5*ones(length(t));
Yref=square(2*3.14*0.2*t);
[F,G]=efge(A,C,nk);

u=zeros(1,maxShift);

teta=rand(4,1);
P=5*eye(4);
for i=3:length(t)
    if t(i)>7
        B(1)=2.1;
    elseif t(i)>5
        B(1)=1.9;
    end
    Y=-A(2)*y(i-1)-A(3)*y(i-2)+B(1)*u(i-1)+B(2)*u(i-2)+3*(C(1)*e(i)+C(2)*e(i-1)-C(3)*e(i-2));
    y=[y Y];                                                                        % elmentem a kimenetet
    %% becslo
    fi=[y(i-1) -y(i-3) u(i-1) u(i-2)];
    yb=fi*teta;
    est_error=Y-yb;
    K=(P*fi')/(1+fi*P*fi');
    P=(eye(4)-K*fi)*P;
    teta=teta+K*est_error;
    %% szbalyozo param szamitas
    Ab=[1 teta(1:2)'];
    Bb=teta(3:4)';
    [F,G]=efge(Ab,C,nk);
    BF=conv(Bb,F);
    U=(1/BF(1))*(-BF(2)*u(i-1)+C(1)*Yref(i)+C(2)*Yref(i-1)+C(3)*Yref(i-2)-G(1)*y(i)-G(2)*y(i-1));
    u=[u U];
end

hold on;
plot(t,y)
plot(t,u);
plot(t,Yref);
legend("signal","control signal","ref");








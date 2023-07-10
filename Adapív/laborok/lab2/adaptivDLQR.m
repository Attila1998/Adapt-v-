clc;
close all;
clear all;

    %% A MÁTRIXOK
 n=3;
 m=1;
p=1;
 Ad=[-0.6 0 0;
     0.02 -0.8 0 ;
     0 0 0.3];
 Bd=[-2; 1 ;2];
 Cd=[1 1 -1];
  
    %% SZÁMÍTÁS                    

Ts=0.01;    

t=0:Ts:2;
% u(1,:)=1*ones(1,length(t));                                       % szomszed homerseklet
x=-2*ones(n,1);
X=x;
y=[];
R=20*eye(m);         % bemeneteket sulyoz
Q=50*eye(p);
yref=20*ones(1,length(t)); 

teta0=[Ad; Bd']+rand(n+m,n);
P0=rand(n+m,n+m);
u=[];
for i=1:length(t)
        Pc=dare(Ad,Bd,Cd'*Q*Cd,R);
        K1=-((R+Bd'*Pc*Bd)^(-1))*(Bd'*Pc*Ad);                                               % fb
        K2=((R+Bd'*Pc*Bd)^(-1))*Bd'*((eye(3)-Ad-Bd*K1)'^(-1))*Cd'*Q;                        % ff
        u=[u K1*x+K2*yref(:,i)];                                                                % control signal
        
        
        x=Ad*x+Bd*u(i);                                                                        % system
        X=[X x];
        Y=x(1,1)+x(2,1)-x(3,1);
        y=[y Y];
        
        if i>1
            fi=[X(:,i-1)' u(:,i-1)'];                                   % becslo
            size(fi)
            size(teta0)
            yb=fi*teta0;
            e=y(:,i)-yb;
            K=(P0*fi')/(1+fi*P0*fi');
            P0=(eye(n+m)-K*fi)*P0;
            teta0=teta0+K*e;
        end
end

hold on;
plot(t,y(1,:));



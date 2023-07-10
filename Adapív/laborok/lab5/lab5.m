clc;
close all;
clear all;
m=menu("Valassz","nem adaptiv","adaptiv");
%% folyamat parameterei
b1 = 0.104;
b0 = 0.0883;
a1 = -1.4138;
a0 = 0.6065;

bm1=0.09833 ;
bm0= 0.07778;
bm=bm1+bm0;
am1=- 1.32 ;
am0= 0.4966;

Ts=0.5;
t=0:Ts:500;
ref=5*square(t*0.15);
y=[];
y(1)=0;
y(2)=0;
ym=[];
ym(1)=0;
ym(2)=0;
u=ref;
%% szabalyzo parametereinek szamitasa
r0=1;
r1=b0/b1;
t1=bm/b1;
s0=(am0-a0)/b1;
s1=(am1-a1)/b1;
teta=[a1 a0 b1 b0]'+randn(4,1);
P=100*eye(4);
ybtomb=[0 0];
lambda=0.9;
tetatomb=[];
Pnyoma=[];
for  i=3:length(t)
%     if t(i)>=50
%         b0r=b0+0.05;
%     else
%         b0r=b0;
%     end
     if t(i)>=50
        b1r=b1+0.05;
    else
        b1r=b1;
    end
    
%folyamat kimenet szamitas
y(i)=-a1*y(i-1)-a0*y(i-2)+b1r*u(i-1)+b0*u(i-2);
% online becslo IO mod.
fi=[-y(i-1) -y(i-2) u(i-1) u(i-2)]';
yb=fi'*teta;
e=y(i)-yb;
K=(P*fi)/(lambda+fi'*P*fi);
P=((1/lambda)*eye(4)-K*fi')*P;
teta=teta+K*e;
tetatomb=[tetatomb  teta];
Pnyoma=[Pnyoma trace(P)];
if m==2
%kiszamolom a becsult ertekekkel ujra a szabalyzo parametereit
a1b=teta(1);
a0b=teta(2);
b1b=teta(3);
b0b=teta(4);
else
a1b=a1;
a0b=a0;
b1b=b1;
b0b=b0;
end
r1=b0b/b1b;
t1=bm/b1b;
s0=(am0-a0b)/b1b;
s1=(am1-a1b)/b1b;
ybtomb=[ybtomb yb];
%szabalyzojel szmaitas
u(i)=(-r1*u(i-1)+t1*ref(i)-s1*y(i)-s0*y(i-1))/r0;


% referencia modell kimenetenek szamitasa
ym(i)=-am1*ym(i-1)-am0*ym(i-2)+bm1*ref(i-1)+bm0*ref(i-2);

end
figure(1);
plot(t,y,t,ym);
legend('y','yb');
figure();
plot(tetatomb');
title('Teta');
figure();
plot(Pnyoma);
title('Pnyoma');
% figure();
% plot(t,ym);